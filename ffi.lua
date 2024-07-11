-- also in ext.class
local function class()
	local cl = setmetatable({}, {
		__call = function(mt, ...)
			local o = setmetatable({}, mt)
			if o.init then o:init(...) end
			return o
		end,
	})
	cl.__index = cl
	return cl
end

local function defaultConcat(a,b)
	return tostring(a) .. tostring(b)
end

-- also in ext/table.lua
local tablemt = {__index = table}

-- also in ext/table.lua as 'table()'
local function newtable(...)
	return setmetatable({}, tablemt)
end

-- also in ext/string.lua
local function trim(str)
	return str:match'^%s*(.-)%s*$'
end

-- also in ext/string.lua
local escapeFind = '[' .. ([[^$()%.[]*+-?]]):gsub('.', '%%%1') .. ']'
function patescape(s)
	return (s:gsub(escapeFind, '%%%1'))
end

-- also in preproc/preproc.lua
function removeCommentsAndApplyContinuations(code)
	code = code:gsub('\r\n', '\n')
	repeat
		local i, j = code:find('\\\n')
		if not i then break end
		code = code:sub(1,i-1)..' '..code:sub(j+1)
	until false

	-- remove all /* */ blocks first
	-- re-insert their \n's to keep the line numbers the same
	repeat
		local i = code:find('/*',1,true)
		if not i then break end
		local j = code:find('*/',i+2,true)
		if not j then
			error("found /* with no */")
		end
		local numlines = select(2, code:sub(i,j+1):gsub('\n', ''))
		code = code:sub(1,i-1)..('\n'):rep(numlines)..code:sub(j+2)
	until false

	-- remove all // \n blocks first
	repeat
		local i = code:find('//',1,true)
		if not i then break end
		local j = code:find('\n',i+2,true) or #code+1
		code = code:sub(1,i-1)..code:sub(j)
	until false

	return code
end


local ffi = {}

ffi.os = 'Web'
ffi.arch = 'x64'

-- put ffi.cdef functions here
ffi.C = {}

-- helper function for the webgl shim layer equivalent of the ffi .so header files
-- ... instead of ffi.cdef
-- NOTICE this field deviates from luajit ffi
function ffi.cdef_enum(keys, dest)
	dest = dest or ffi.C
	local v = 0
	for _,k in ipairs(keys) do
		if type(k) == 'table' then
			k, v = next(k)
		end
		dest[k] = v
		v = v + 1
	end
end

-- put ffi.cdef types here
local ctypes = {}

local nextuniquenameindex = 0
local function nextuniquename()
	nextuniquenameindex = nextuniquenameindex + 1
	return '#'..nextuniquenameindex
end

local Field = class()
function Field:init(args)
	self.name = assert(args.name)
	assert(type(self.name) == 'string')
	self.type = assert(args.type)
assert(getmetatable(self.type) == ffi.CType)
	self.offset = 0	-- TODO calculate this
end
function Field:__tostring()
	return '[@'..self.offset..' '..self.type.name..' '..self.name..']'
end
Field.__concat = defaultConcat

--[[
args:
	name = it could be nameless for typedef'd or anonymous nested structs
	anonymous = true for name == nil for nested anonymous structs/unions
	fields = it will only exist for structs
	isunion = goes with fields for unions vs structs
	baseType = for typedefs or for arrays
	arrayCount = if the type is an array of another type
	size = defined for prims, computed for structs, it'll be manually set for primitives
	getset = suffix of DataView member getter/setter for primitives
	mt = is the metatype of this ctype
	isPrimitive = if this is a primitive type
	isPointer = is a pointer of the base type

usage: (TODO subclasses?)
primitives: name isPrimitive size get set
typedef: name baseType
array: [name] baseType arrayCount
pointer: baseType isPointer
struct: [name] fields [isunion]
--]]
ffi.CType = class()
function ffi.CType:init(args)
	args = args or {}
	self.name = args.name
	if not self.name then
		-- if it's a pointer type ...
		if args.baseType then
			if args.arrayCount then
				self.name = args.baseType.name..'['..args.arrayCount..']'
			elseif args.isPointer then
				self.name = args.baseType.name..'*'
			else
				error("???")
			end
		else
			self.name = nextuniquename()
			self.anonymous = true
		end
	end
	assert(not ctypes[self.name], "tried to redefine "..tostring(self.name))
--DEBUG:print('setting ctype '..self.name)
	ctypes[self.name] = self

	self.fields = args.fields
	self.isunion = args.isunion
	self.baseType = args.baseType
	self.arrayCount = args.arrayCount
	self.isPrimitive = args.isPrimitive
	self.isPointer = args.isPointer
	self.mt = args.mt

	assert(not (self.arrayCount and self.fields), "can't have an array of a struct - split these into two CTypes")

	if self.isPointer then
		assert(self.baseType)
		self.size = ctypes.intptr_t.size
	elseif self.isPrimitive then
		-- primitive type? expects size
		self.size = args.size
		local getset = args.getset
		if getset then
			local gettername = 'get'..getset
			self.get = js.global.DataView.prototype[gettername] or error("failed to find getter "..gettername)
			local settername = 'set'..getset
			self.set = js.global.DataView.prototype[settername] or error("failed to find setter "..settername)
		end
	elseif self.arrayCount then
		-- array type? calculate
		self.size = self.baseType.size * self.arrayCount
	elseif not self.fields then
		-- typedef?
		self.size = assert(self.baseType.size, "failed to find size for baseType "..tostring(self.baseType))
	else
		-- struct?
		assert(self.fields)
		-- expect :finalize to be called later
	end
end
function ffi.CType:finalize()
	if self.size then return end

	if self.arrayCount then
		self.size = self.baseType.size * self.arrayCount
		return
	end

	assert(self.fields, "failed to finalize for type "..tostring(self))
--DEBUG:print('finalize '..self.name)
	-- struct/union
	self.size = 0
	-- TODO alignment ...
	for _,field in ipairs(self.fields) do
		assert(field.type)
		assert(field.type.size)
		if self.isunion then
			field.offset = 0
			self.size = math.max(self.size, ffi.sizeof(field.type))
		else
			field.offset = self.size
			self.size = self.size + ffi.sizeof(field.type)
		end
		-- TODO alignment here
--DEBUG:print(field)
	end
	-- make sure we take up at least something - no zero-sized arrays (right?)
	self.size = math.max(1, self.size)
--DEBUG:print('...'..self.name..' has size '..self.size)

	-- this is all flattened anonymous fields
	-- and that means a mechanism for offsetting into nested struct-of-(anonymous)-struct fields
	self.fieldForName = {}
	local function addFields(fields, baseOffset)
		for _,field in ipairs(fields) do
			local fieldOffset = field.offset + baseOffset
--DEBUG:print('has field '..field.name..' at offset '..fieldOffset..' of type '..tostring(field.type))
			if field.type.anonymous then
				-- TODO would be nice to get the string of the currently-parsed-struct here ...
				assert(field.type.fields, "anonymous struct needs fields")
				addFields(field.type.fields, fieldOffset)
			else
				assert(field.name and #field.name > 0)
				self.fieldForName[field.name] = {
					type = field.type,
					offset = fieldOffset,
				}
			end
		end
	end
	addFields(self.fields, 0)
end
function ffi.CType:__tostring()
	return tostring(self.name)
end
function ffi.CType:assign(blob, offset, ...)
	if select('#', ...) > 0 then
		if self.fields then
			-- structs
			if self.isunion then
				-- then only assign to the first entry? hmmm ...
				self.fields[1].type:assign(blob, offset, ...)
			else
				for i=1,math.min(#self.fields, select('#', ...)) do
					local field = self.fields[i]
					field.type:assign(blob, offset + field.offset, (select(i, ...)))
				end
			end
		elseif self.arrayCount then
			-- arrays
			local v = ...
			if type(v) == 'table' then
				for i=1, #v do
					self.baseType:assign(blob, offset + (i-1) * self.baseType.size, v[i])
				end
			else
				for i=1, select('#', ...) do
					local vi = select(i, ...)
					self.baseType:assign(blob, offset + (i-1) * self.baseType.size, vi)
				end
			end
		else
			assert(self.isPrimitive, "assigning to a non-primitive...")
			local v = ...
			local vt = type(v)
			if vt ~= 'number' then
				error("can't convert "..vt.." to number")
			end
assert(self.set, "expected primitive to have a setter")
assert(blob.dataview)
			self.set(blob.dataview, offset, v)
--DEBUG:print('TODO *('..tostring(self)..')(ptr+'..tostring(offset)..') = '..tostring(v))
--DEBUG:print(debug.traceback())
		end
	end
end


ffi.CType{name='void', size=0, isPrimitive=true}	-- let's all admit that a void* is really a char*
ffi.CType{name='int8_t', size=1, isPrimitive=true, getset='Int8'}
ffi.CType{name='uint8_t', size=1, isPrimitive=true, getset='Uint8'}
ffi.CType{name='int16_t', size=2, isPrimitive=true, getset='Int16'}
ffi.CType{name='uint16_t', size=2, isPrimitive=true, getset='Uint16'}
ffi.CType{name='int32_t', size=4, isPrimitive=true, getset='Int32'}
ffi.CType{name='uint32_t', size=4, isPrimitive=true, getset='Uint32'}
ffi.CType{name='int64_t', size=8, isPrimitive=true, getset='BigInt64'}	-- why Big?
ffi.CType{name='uint64_t', size=8, isPrimitive=true, getset='BigUint64'}

ffi.CType{name='float', size=4, isPrimitive=true, getset='Float32'}
ffi.CType{name='double', size=8, isPrimitive=true, getset='Float64'}
--ffi.CType{name='long double', size=16, isPrimitive=true}	-- no get/set in Javascript DataView ... hmm ...

-- add these as typedefs
ffi.CType{name='char', baseType=assert(ctypes.uint8_t)}	-- char default is unsigned, right?
ffi.CType{name='signed char', baseType=assert(ctypes.int8_t)}
ffi.CType{name='unsigned char', baseType=assert(ctypes.uint8_t)}
ffi.CType{name='short', baseType=assert(ctypes.int16_t)}
ffi.CType{name='signed short', baseType=assert(ctypes.int16_t)}
ffi.CType{name='unsigned short', baseType=assert(ctypes.uint16_t)}
ffi.CType{name='int', baseType=assert(ctypes.int32_t)}
ffi.CType{name='signed int', baseType=assert(ctypes.int32_t)}
ffi.CType{name='unsigned int', baseType=assert(ctypes.uint32_t)}
ffi.CType{name='long', baseType=assert(ctypes.int64_t)}
ffi.CType{name='signed long', baseType=assert(ctypes.int64_t)}
ffi.CType{name='unsigned long', baseType=assert(ctypes.uint64_t)}
ffi.CType{name='intptr_t', baseType=assert(ctypes.int64_t)}
ffi.CType{name='uintptr_t', baseType=assert(ctypes.uint64_t)}
ffi.CType{name='ssize_t', baseType=assert(ctypes.int64_t)}
ffi.CType{name='size_t', baseType=assert(ctypes.uint64_t)}

local function consume(str)
	str = trim(str)
	if #str == 0 then return end
	-- symbols, first-come first-serve, interpret largest to smallest
	for _,symbol in ipairs{'(', ')', '[', ']', '{', '}', ',', ';', '=', '*',
		'?',	-- special for luajit
	} do
		if str:match('^'..patescape(symbol)) then
			local rest = str:sub(#symbol+1)
--DEBUG:print('consume', symbol, 'symbol')
			return rest, symbol, 'symbol'
		end
	end
	-- keywords
	for _,keyword in ipairs{
		'typedef',
		'struct',
		'union',
		'enum',
		'extern',
	} do
		if str:match('^'..keyword) and (str:match('^'..keyword..'$') or str:match('^'..keyword..'[^_a-zA-Z0-9]')) then
			local rest = str:sub(#keyword+1)
--DEBUG:print('consume', keyword, 'keyword')
			return rest, keyword, 'keyword'
		end
	end
	-- names
	local name = str:match('^([_a-zA-Z][_a-zA-Z0-9]*)')
	if name then
		local rest = str:sub(#name+1)
--DEBUG:print('consume', name, 'name')
		return rest, name, 'name'
	end

	-- hexadecimal integer numbers
	-- match before decimal
	-- TODO make sure the next char is a separator (not a word)
	local d = str:match'^(0x[0-9a-fA-F]+)'
	if d then
		local rest = str:sub(#d+1)
--DEBUG:print('consume', d, 'number')
		return rest, d, 'number'
	end

	-- decimal integer numbers
	-- TODO make sure the next char is a separator (not a word)
	local d = str:match'^(%d+)' or str:match'^(%-%d+)'
	if d then
		local rest = str:sub(#d+1)
--DEBUG:print('consume', d, 'number')
		return rest, d, 'number'
	end

	local d = str:match"^'\\.'"
	if d then
		assert(#d == 4)
		local rest = str:sub(#d+1)
		local esc = d:sub(3,3)
		if esc == 'b' then
			d = ('\b'):byte()
		elseif esc == 'n' then
			d = ('\n'):byte()
		elseif esc == 'r' then
			d = ('\r'):byte()
		elseif esc == 't' then
			d = ('\t'):byte()
		elseif esc == "'" then
			d = ("'"):byte()
		elseif esc == "\\" then
			d = ("\\"):byte()
		else
			error("unknown escape code "..d)
		end
		return rest, d, 'char'	-- TODO escape?
	end

	-- handle '.' after '\\.' so that '\'' gets handled correctly
	local d = str:match"^'.'"
	if d then
		assert(#d == 3)
		local rest = str:sub(#d+1)
		return rest, d:sub(2,2):byte(), 'char'
	end

	local d = str:match"^'\\x[0-9a-fA-F][0-9a-fA-F]'"
	if d then
		assert(#d == 6)
		local rest = str:sub(#d+1)
		local esc = tonumber(d:sub(4,5), 16)
		assert(esc, "failed to parse hex char "..d)
		return rest, esc, 'char'	-- TODO escape?
	end

	error("unknown token "..str)
end

-- follow typedef baseType lookups to the origin and return that
local function getctype(typename)
	local ctype = ctypes[typename]
	if not ctype then return end

	if (ctype.baseType and not ctype.arrayCount) then
		local sofar = {}
		-- if it has a baseType and no arrayCount then it's just a typedef ...
		repeat
			if sofar[ctype] then
				error"found a typedef loop"
			end
			sofar[ctypes] = true
			ctype = ctype.baseType
		until not (ctype.baseType and not ctype.arrayCount)
	end
	return ctype
end

local function getptrtype(baseType)
	local ptrType = getctype(baseType.name..'*')
	if ptrType then return ptrType end
	return ffi.CType{
		baseType = baseType,
		isPointer = true,
	}
end

local function getArrayType(baseType, ar)
	local ctype = getctype(baseType.name..'['..ar..']')
--DEBUG:print('looking for ctype name', baseType.name..'['..ar..'], got', ctype)
	-- if not then make the array-type
	if not ctype then
		ctype = ffi.CType{
			baseType = baseType,
			arrayCount = ar,
		}
	end
	return ctype
end

-- parse a ffi.cast or ffi.new 
-- similar to struct but without the loop over multiple named vars with the same base type
local function parseType(str, allowVarArray)
--print('parseType', str, allowVarArray)
	local gotVarArray
	str, token, tokentype = consume(str)

	-- should these be keywords?
	local signedness
	if token == 'signed'
	or token == 'unsigned'
	then
		signedness = token
		str, token, tokentype = consume(str)
	end

	--const-ness ... meh?
	if token == 'const' then
		str, token, tokentype = consume(str)
	end

	local structunion
	if token == 'struct' or token == 'union' then
		structunion = token
		str, token, tokentype = consume(str)
	end

	local name = token
	if structunion then
		name = structunion..' '..name
	end
	if signedness then
		name = signedness..' '..name
	end

	-- fields ...
	-- TODO this should be 'parsetype' and work just like variable declarations
	-- and should be interoperable with typedefs
	-- except typedefs can't use comma-separated list (can they?)
	local baseFieldType = assert(getctype(name), "couldn't find type "..name)
assert(getmetatable(baseFieldType) == ffi.CType)
assert(baseFieldType.size, "ctype "..tostring(name).." has no size!")

	str, token, tokentype = consume(str)
	local fieldtype = baseFieldType
	while token == '*' do
		fieldtype = getptrtype(fieldtype)
		str, token, tokentype = consume(str)
		-- const-ness ... meh?
		if token == 'const' then
			str, token, tokentype = consume(str)
		end
	end

	while token == '[' do
		str, token, tokentype = consume(str)
		local count
		if allowVarArray and token == '?' then
			gotVarArray = true
		else
			assert(tokentype == 'number', "expected array size, found "..tostring(tokentype)..' '..tostring(token))
			count = assert(tonumber(token))
			assert(count > 0, "can we allow non-positive-sized arrays?")
			fieldtype = getArrayType(fieldtype, count)
		end

		str, token, tokentype = consume(str)
		assert(token == ']')
		str, token, tokentype = consume(str)
	end

	assert(not str or str:match'^%s*$', 'done parsing type with this left: '..tostring(str))
--print('got type', fieldtype, gotVarArray)
	return fieldtype, gotVarArray 
end

-- assumes 'struct' or 'union' has already been parsed
-- doesn't assert closing ';' (since it could be used in typedef)
local function parseStruct(str, isunion)
	local token, tokentype
	str, token, tokentype = consume(str)

	local name
	if tokentype == 'name' then
		name = (isunion and 'union' or 'struct')..' '..token
		str, token, tokentype = consume(str)
	end

	if token ~= '{' then
		if not name then
			error("struct/union expected name or {")
		end

		local ctype = getctype(name)
		assert(ctype, "couldn't find type "..tostring(name))
		-- TODO in the case of typedef calling this
		-- the 'struct XXX' might not yet exist ...
		-- hmm ...
		return str, token, tokentype, ctype
	end

	-- struct [name] { ...
	local ctype = ffi.CType{
		name = name,	-- auto-generate a name for the anonymous struct/union
		fields = newtable(),
		isunion = isunion,
	}

	while true do
		str, token, tokentype = consume(str)
--DEBUG:print('field first token', token, tokentype)
		if token == '}' then
			break
		elseif token == 'struct'
		or token == 'union'
		then
			-- TODO
			-- if the next token is a { then parse a stuct
			-- if the next token is a name then ...
			-- 	if the next after that is { then parse a struct
			--  if the next after that is not then it's a "struct" typename...

			-- nameless struct/union's within struct/union's ...
			-- or even if they have names, the names should get ignored?
			-- or how long does the scope of the name of an inner struct in C last?

			local nestedtype
			str, token, tokentype, nestedtype = parseStruct(str, token == 'union')
assert(getmetatable(nestedtype) == ffi.CType)
assert(nestedtype.size)
			ctype.fields:insert(Field{
				name = '',
				type = nestedtype,
			})
			-- what kind of name should I use for nameless nested structs?

			assert(token == ';', "expected ;, found "..tostring(token))
		elseif tokentype == 'name' then

			-- should these be keywords?
			local signedness
			if token == 'signed'
			or token == 'unsigned'
			then
				signedness = token
				str, token, tokentype = consume(str)
			end

			--const-ness ... meh?
			if token == 'const' then
				str, token, tokentype = consume(str)
			end

			local name = token
			if signedness then
				name = signedness..' '..name
			end

			-- fields ...
			-- TODO this should be 'parsetype' and work just like variable declarations
			-- and should be interoperable with typedefs
			-- except typedefs can't use comma-separated list (can they?)
			local baseFieldType = assert(getctype(name), "couldn't find type "..name)
assert(getmetatable(baseFieldType) == ffi.CType)
assert(baseFieldType.size, "ctype "..tostring(name).." has no size!")

			while true do
				str, token, tokentype = consume(str)

				local fieldtype = baseFieldType
				while token == '*' do
					fieldtype = getptrtype(fieldtype)
					str, token, tokentype = consume(str)
					-- const-ness ... meh?
					if token == 'const' then
						str, token, tokentype = consume(str)
					end
				end

				assert(tokentype == 'name', "expected field name, found "..tostring(token)..", rest "..tostring(token))
				local fieldname = token
				local field = Field{
					name = fieldname,
					type = fieldtype,
				}
				ctype.fields:insert(field)

				str, token, tokentype = consume(str)
				while token == '[' do
					str, token, tokentype = consume(str)
					assert(tokentype == 'number', "expected array size, found "..tostring(tokentype)..' '..tostring(token))
					local count = assert(tonumber(token))
					assert(count > 0, "can we allow non-positive-sized arrays?")
					-- TODO shouldn't we be modifying field.type to be an array-type with array 'count' ?
					field.count = count

					str, token, tokentype = consume(str)
					assert(token == ']')

					str, token, tokentype = consume(str)
				end

				if token == ';' then
					break
				elseif token ~= ',' then
					error("expected , or ;, found "..tostring(tokentype).." "..tostring(token))
				end
			end
		else
			error("got end of string")
		end
	end
	ctype:finalize()

	-- consume the next and forward it
	-- needed to handle 'struct alreadyDefinedType' above
	str, token, tokentype = consume(str)

	return str, token, tokentype, ctype
end

local function parseEnum(str)
	local token, tokentype
	str, token, tokentype = consume(str)	-- skip past "enum"

	local name
	if tokentype == 'name' then
		name = 'enum '..token
		str, token, tokentype = consume(str)
	end

	if token ~= '{' then
		if not name then
			error("enum expected name or {")
		end

		local ctype = getctype(name)
		assert(ctype, "couldn't find type "..tostring(name))
		-- TODO in the case of typedef calling this
		-- the 'enum XXX' might not yet exist ...
		-- hmm ...
		return str, token, tokentype, ctype
	end

	str, token, tokentype = consume(str)
	local ctype
	if name then
		-- if it's enum XXX then do a typedef to the base enum type
		ctype = ffi.CType{
			name = name,
			baseType = assert(ctypes.uint32_t),
		}
	else
		ctype = ctypes.uint32_t
	end

	local value = 0
	while true do
		assert(tokentype == 'name', "enum expected name, got "..tostring(token).." rest is "..str)
		local name = token

-- TODO need to handle arithmetic operations here ...
-- or just always make sure to evaluate them in whatever ffi libs that this port uses
		str, token, tokentype = consume(str)
		if token == '=' then
			str, token, tokentype = consume(str)
			assert(tokentype == 'number' or tokentype == 'char', "expected value to be a number or char, found "..tostring(token).." rest "..tostring(str))
			value = token

			str, token, tokentype = consume(str)
		end

--DEBUG:print('setting enum '..tostring(name)..' = '..tostring(value))
		ffi.C[name] = value
		value = value + 1

		local gotComma
		if token == ',' then
			gotComma = true
			str, token, tokentype = consume(str)
		end

		if token == '}' then break end

		if not gotComma then error("expected , found "..tostring(token).." rest is "..tostring(str)) end
	end

	str, token, tokentype = consume(str)

	return str, token, tokentype, ctype
end

-- assumes comments and \'s are removed
local function parse(str)
	local origstr = str
	local origlen = #str
	assert(xpcall(function()
		local token, tokentype
		while true do
			str, token, tokentype = consume(str)
			if token == 'typedef' then
				-- next is either a previously declared typename or 'struct'/'union' followed by a struct/union def
				str, token, tokentype = consume(str)

				local srctype
				if tokentype == 'name' then
					local signedness
					if token == 'signed'
					or token == 'unsigned'
					then
						signedness = token
						str, token, tokentype = consume(str)
					end

					local name = token
					if signedness then
						name = signedness..' '..name
					end
					srctype = assert(getctype(name), "couldn't find type "..name)

					str, token, tokentype = consume(str)

				-- alright I'm reaching the limit of non-state-based tokenizers ...
				elseif tokentype == 'keyword' then
					if token == 'struct'
					or token == 'union'
					then
						-- TODO this still could either be ...
						--  ... a named struct declaration
						--  ... an anonymous struct declaration
						--  ... a 'struct ____' typename
						-- and we can't know until after we read the '{'

						str, token, tokentype, srctype = parseStruct(str, token == 'union')
						assert(srctype)
					elseif token == 'enum' then
						str, token, tokentype, srctype = parseEnum(str)
						assert(srctype)
					else
						error("got unknown keyword: "..tostring(token))
					end
				else
					error("here")
				end

				while token == '*' do
					srctype = getptrtype(srctype)
					str, token, tokentype = consume(str)
				end

				-- assume the current token is the typedef name
				if tokentype ~= 'name' then
					error("expected name, found "..token.." rest "..str)
				end

				-- make a typedef type
				ffi.CType{
					name = token,
					baseType = srctype,
				}

				str, token, tokentype = consume(str)

				-- TODO ... token could be [
				-- in which case we don't just have a typedef
				--  we have a new ctype of only an array

				assert(token == ';')
			elseif token == 'union'
			or token == 'struct'
			then
				local ctype
				str, token, tokentype, ctype = parseStruct(str, token == 'union')
				assert(token == ';')
			elseif token == 'enum' then
				str, token, tokentype, ctype = parseEnum(str)
				assert(token == ';')
			elseif token == 'extern' then
				str, token, tokentype = consume(str)
				local ctype = assert(getctype(token), "couldn't find type "..token)

				str, token, tokentype = consume(str)
				local name = token

				-- TODO create ffi.C[name] as a pointer to this data

				str, token, tokentype = consume(str)
				assert(token == ';')
			elseif not token then
				break
			else
				error("got eof with rest "..tostring(str))
			end
		end
--DEBUG:print'parse done'
	end, function(err)
		local curlen = #str
		local sofar = origstr:sub(1, -curlen)

		local lastline = sofar:match('[^\n]*$') or ''
		local lineno = select(2,sofar:gsub('\n', ''))
		local colno = #lastline

		return 'on line '..lineno..' col '..colno..'\n'
			..err..'\n'..debug.traceback()
	end))
end

function ffi.cdef(str)
--DEBUG:print("ffi.cdef("..tostring(str)..")")
	-- TODO ... hmm ... luajit's lj_cparse ...
	-- I can compile that to emscripten ...
	-- hmm ...
	str = removeCommentsAndApplyContinuations(str)
	parse(str)
--DEBUG:print'ffi.cdef done'
end

-- if ctype is a string then make it into a CType object
-- otherwise make sure it's a CType object
local function toctype(ctype, allowVarArray, ...)
	local didHandleVarArray
	if type(ctype) == 'string' then
		ctype, gotVarArray = parseType(ctype, allowVarArray)
		if gotVarArray then
			local count = assert(tonumber((...)))
			ctype = getArrayType(ctype, count)
			didHandleVarArray = true
		end
	end
	assert(getmetatable(ctype) == ffi.CType, "ffi.sizeof object is not a ctype")
	return ctype, didHandleVarArray
end

function ffi.sizeof(ctype)
--DEBUG:print('ffi.sizeof('..tostring(ctype)..')')
	ctype = toctype(ctype)
assert(ctype.size, "need to calculate a size")
--DEBUG:print('ffi.sizeof('..tostring(ctype)..') = '..ctype.size)
	return ctype.size
end

local MemoryBlob = class()
function MemoryBlob:init(size)
	self.buffer = js.new(js.global.ArrayBuffer, size)
	self.dataview = js.new(js.global.DataView, self.buffer)
end

-- metatable assigned *after* init for CData
local CData = setmetatable({}, {
	__call = function(mt, blob, ctype, offset)
		-- NOTICE unlike most class()'s, 'o' doesn't yet have access to its mt during construction
		local o = {}	--

		-- now 'o's __index will be overridden so it can be treated like a C pointer
		local omt = {}
		for k,v in pairs(mt) do
			omt[k] = v
		end

		-- hide these from user ... but how?
		omt.blob = blob	-- should be a MemoryBlob or nil
		omt.type = ctype or ctypes.uint8_t
		omt.offset = offset or 0
		omt.isCData = true

		return setmetatable(o, omt)
	end,
})
-- hmm __index is overridden for the user's api
-- so that means I can't use self: for CData ...
function CData.__index(self, key)
	local mt = getmetatable(self)
	local ctype = mt.type
	if ctype.baseType then
		if ctype.arrayCount then
			-- array ...
			local index = tonumber(key) or error("expected key to be integer, found "..require 'ext.tolua'(key))
			local fieldType = mt.type.baseType
			local fieldOffset = mt.offset + index * ctype.baseType.size
			if fieldType.isPrimitive then
				return fieldType.get(mt.blob.dataview, fieldOffset)
			else
				return CData(mt.blob, fieldType, fieldOffset)
			end
		else
			-- typedef
			error("don't allow pointers to hold typedefs")
		end
	elseif ctype.fields then
		-- struct/union
		local field = ctype.fieldForName[key]
		if not field then error("in type "..tostring(self).." couldn't find field "..tostring(key)) end
		local fieldType = field.type
		local fieldOffset = mt.offset + field.offset
		if fieldType.isPrimitive then
			return fieldType.get(mt.blob.dataview, fieldOffset)
		else
			return CData(mt.blob, fieldType, fieldOffset)
		end
	else
		error("can't index cdata of type "..tostring(mt.type))
	end
end
function CData.__newindex(self, key, value)
	if type(value) ~= 'number' then
		error("can't assign non-primitive values.  got "..require 'ext.tolua'(value))
	end
	local mt = getmetatable(self)
	local ctype = mt.type
	if ctype.baseType then
		if ctype.arrayCount then
			-- array
			local index = tonumber(key) or error("expected key to be integer, found "..require 'ext.tolua'(key))
			local fieldType = ctype.baseType
			local fieldOffset = mt.offset + index * ctype.baseType.size
			if fieldType.isPrimitive then
--DEBUG:		return select(2, assert(xpcall(function()
					return fieldType.set(mt.blob.dataview, fieldOffset, value)
--DEBUG:		end, function(err)
--DEBUG:			return 'setting '..tostring(fieldType.name)..' offset='..tostring(fieldOffset)..' value='..tostring(value)..' buffersize='..tostring(mt.blob.dataview.byteLength)..'\n'
--DEBUG:				..tostring(err)..'\n'
--DEBUG:				..debug.traceback()
--DEBUG:		end)))
			else
				error("can't assign to non-primitive type "..tostring(mt))
			end
		else
			-- typedef
			error("don't allow pointers to hold typedefs")
		end
	elseif ctype.fields then
		-- struct/union
		local field = ctype.fieldForName[key]
		if not field then error("in type "..tostring(self).." couldn't find field "..tostring(key)) end
		local fieldType = field.type
		local fieldOffset = mt.offset + field.offset
		if fieldType.isPrimitive then
			return fieldType.set(mt.blob.dataview, fieldOffset, value)
		else
			error("can't assign to non-primitive type "..tostring(mt))
		end
	else
		error("can't assign cdata of type "..tostring(mt.type))
	end
end
function CData:add(index)
	local mt = getmetatable(self)
	return CData(
		mt.blob,
		mt.type,
		mt.offset + index * mt.type.size
	)
end
function CData.__add(a,b)
	local ma = getmetatable(a)
	local mb = getmetatable(b)
	local pa = ma and ma.isCData
	local pb = mb and mb.isCData
	local na = type(a) == 'number'
	local nb = type(b) == 'number'
	if pa and nb then
		return CData.add(a, b)
	elseif pb and na then
		return CData.add(b, a)
	else
		error("don't know how to add")
	end
end

function ffi.cast(ctype, src)
	ctype = toctype(ctype)

	if type(src) == 'string' then
		-- in luajit doing this gives you access to the string's own underlying buffer
		-- TODO eventually pull that out of Fengari
		-- until then, make a new buffer and return the pointer to it
		src = ffi.stringBuffer(src)
		local srcmt = getmetatable(src)
		return CData(srcmt.blob, ctype, srcmt.offset)
	elseif type(src) == 'nil' then
		return CData(nil, ctype, 0)
	else	-- expect it to be cdata
		local srcmt = getmetatable(src)
		return CData(srcmt.blob, ctype, srcmt.offset)
	end
end

function ffi.new(ctype, ...)
	local didHandleVarArray
	ctype, didHandleVarArray = toctype(ctype, true, ...)

	-- TODO return a pointer?
	-- or how will sizeof handle pointers?
	-- or should I return a pointer-to-fixed-size-array, which auto converts to pointer to base type upon arithmetic?
--DEBUG:print('for type', ctype.name, 'allocating blob', ctype.size)
	local blob = MemoryBlob(ctype.size)

	local ptr = CData(blob, ctype)

	if not didHandleVarArray and select('#', ...) > 0 then
		ctype:assign(blob, 0, ...)
	end

	return ptr
end

-- string-to-lua here
-- TODO ptr has to be a MemoryBlob
function ffi.string(ptr)
	if ptr == ffi.null then
		return '(null)'
	end
	local ptrmt = assert(getmetatable(ptr))
	local blob = assert(ptrmt.blob)
	return tostring(js.new(js.global.TextDecoder):decode(blob.dataview))
end

-- not in the luajit ffi api
-- lua-string/js-string to cdata
function ffi.stringBuffer(str)
--DEBUG:print('ffi.stringBuffer', str)
	str = tostring(str)
--DEBUG:print('...after tostring', str)	
	local dst = ffi.new('char[?]', #str+1)
	ffi.copy(dst, str)
	return dst
end

function ffi.metatype(ctype, mt)
	if type(ctype) == 'string' then
		ctype = assert(getctype(ctype), "couldn't find type "..ctype)
	end
	assert(getmetatable(ctype) == ffi.CType, "ffi.sizeof object is not a ctype")

	assert(ctype.fields, "can only call ctype on structs/unions")

	-- only metatype on structs/unions
	if ctype.mt then
		error("already called ffi.metatype on type "..tostring(ctype.name))
	end
	-- modify it to include __call ...
	local copy = {}
	for k,v in pairs(mt) do copy[k] = v end
	mt = copy

	-- now fill in args
	-- TODO same as ffi.new('ctype', ...) ?
	mt.__call = function(t, ...)
--DEBUG:print('calling ctor on '..ctype.name..' with', ...)
		local blob = MemoryBlob(ctype.size)
		local ptr = CData(blob, ctype)

		-- TODO instead of ctype:assign, use ptr:set ?
		-- TODO double check that in ffi you can use cdata operator= to duplicate ffi.new / metatype-ctor behavior
		ctype:assign(blob, 0, ...)

		return ptr
	end

	-- TODO store old __index
	-- and give this a new __index
	-- which first looks up any field names, tries to write to them
	-- and if it fails then goes to __index

	ctype.mt = setmetatable({}, mt)
	return ctype.mt
end

local oldtype = _G.type
local newtype = function(o)
	local mt = getmetatable(o)
	if mt and mt.isCData then return 'cdata' end
	return oldtype(o)
end
type = newtype

local function cdataToHex(d)
	local dv = getmetatable(d).blob.dataview
	local s = {}
	for i=0,dv.byteLength-1 do
		table.insert(s, ('%02x'):format(dv:getUint8(i)))
	end
	return table.concat(s)
end

function ffi.copy(dst, src, len)
--print('ffi.copy', cdataToHex(dst), cdataToHex(src), len)
	assert(type(dst) == 'cdata')
	--asserttype(dst, 'cdata')	-- TODO this plz?
	local dstmt = getmetatable(dst)
	if not (dstmt and dstmt.isCData) then
		error("ffi.copy dst is not a cdata, got "..tostring(dst))
	end

	if type(src) == 'string' then
		-- convert from lua string to js buffer
		len = len or #src+1	-- ...including the newline
		for i=1,len do
			dstmt.blob.dataview:setUint8(dstmt.offset + i-1, src:byte(i) or 0)
		end
	else
		assert(type(src) == 'cdata')
		local srcmt = getmetatable(src)
		assert(srcmt and srcmt.isCData, "ffi.copy src is not a cdata")
		assert(len, "expected len")	-- or can't it coerce size from cdata?
		-- construct a temporary object just to copy bytes.  why is javascript so retarded?
		js.new(js.global.Uint8Array, dstmt.blob.buffer, dstmt.offset, len):set(
			js.new(js.global.Uint8Array, srcmt.blob.buffer, srcmt.offset, len)
		)
	end
--print('ffi.copy finished', cdataToHex(dst), cdataToHex(src), len)
end

function ffi.fill(dst, len, value)
	assert(type(dst) == 'cdata')
	local dstmt = getmetatable(dst)
	assert(dstmt and dstmt.isCData, "ffi.fill dst is not a cdata")
	value = value or 0
	-- what type/size does luajit ffi fill with?  uint8? 16? 32? 64?
	js.new(js.global.Uint8Array, dstmt.blob, dstmt.offset, len):fill(value, 0, len)
end

--[[
because nil and anything else (userdata, object, etc) will always be false in vanilla lua ...
--]]
ffi.null = ffi.new'void*'

return ffi
