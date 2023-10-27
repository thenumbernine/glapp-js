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
	repeat
		local i = code:find('/*',1,true)
		if not i then break end
		local j = code:find('*/',i+2,true)
		if not j then
			error("found /* with no */")
		end
		code = code:sub(1,i-1)..code:sub(j+2)
	until false

	-- remove all // \n blocks first
	repeat
		local i = code:find('//',1,true)
		if not i then break end
		local j = code:find('\n',i+2,true) or #code
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
--assert(getmetatable(self.type) == ffi.CType)
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
		self.name = nextuniquename()
		self.anonymous = true
	end
	assert(not ctypes[self.name], "tried to redefine "..tostring(self.name))
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
--print('finalize '..self.name)	
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
--print(field)
	end
	-- make sure we take up at least something - no zero-sized arrays (right?)
	self.size = math.max(1, self.size)
--print('...'..self.name..' has size '..self.size)

	-- this is all flattened anonymous fields
	-- and that means a mechanism for offsetting into nested struct-of-(anonymous)-struct fields
	self.fieldForName = {}
	local function addFields(fields, baseOffset)
		for _,field in ipairs(fields) do
			local fieldOffset = field.offset + baseOffset
--print('has field '..field.name..' at offset '..fieldOffset..' of type '..tostring(field.type))
			if field.type.anonymous then
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
			if self.isunion then
				-- then only assign to the first entry? hmmm ...
				self.fields[1].type:assign(blob, offset, ...)
			else
				for i=1,math.min(#self.fields, select('#', ...)) do
					local field = self.fields[i]
					field.type:assign(blob, offset + field.offset, (select(i, ...)))
				end
			end
		else
		-- TODO handle arrays?	
			assert(self.isPrimitive)
			local v = ...
			local vt = type(v)
			if vt ~= 'number' then
				error("can't convert "..vt.." to number")
			end
assert(self.set, "expected primitive to have a setter")
assert(blob.dataview)			
			self.set(blob.dataview, offset, v)
--print('TODO *('..tostring(self)..')(ptr+'..tostring(offset)..') = '..tostring(v))
--print(debug.traceback())
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
	for _,symbol in ipairs{'(', ')', '[', ']', '{', '}', ',', ';', '=', '*'} do
		if str:match('^'..patescape(symbol)) then
			local rest = str:sub(#symbol+1)
--print('consume', symbol, 'symbol')
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
--print('consume', keyword, 'keyword')
			return rest, keyword, 'keyword'
		end
	end
	-- names
	local name = str:match('^([_a-zA-Z][_a-zA-Z0-9]*)')
	if name then
		local rest = str:sub(#name+1)
--print('consume', name, 'name')
		return rest, name, 'name'
	end
	
	-- hexadecimal integer numbers
	-- match before decimal
	-- TODO make sure the next char is a separator (not a word)
	local d = str:match'^(0x[0-9a-fA-F]+)'
	if d then
		local rest = str:sub(#d+1)
--print('consume', d, 'number')
		return rest, d, 'number'
	end

	-- decimal integer numbers
	-- TODO make sure the next char is a separator (not a word)
	local d = str:match'^(%d+)'
	if d then
		local rest = str:sub(#d+1)
--print('consume', d, 'number')
		return rest, d, 'number'
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
--print('field first token', token, tokentype)
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
--assert(getmetatable(nestedtype) == ffi.CType)
--assert(nestedtype.size)
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

			local name = token
			if signedness then
				name = signedness..' '..name
			end

			-- fields ...
			-- TODO this should be 'parsetype' and work just like variable declarations
			-- and should be interoperable with typedefs
			-- except typedefs can't use comma-separated list (can they?)
			local baseFieldType = assert(getctype(name), "couldn't find type "..name)
--assert(getmetatable(baseFieldType) == ffi.CType)
--assert(baseFieldType.size, "ctype "..tostring(name).." has no size!")

			while true do
				str, token, tokentype = consume(str)
				
				local fieldtype = baseFieldType
				while token == '*' do
					fieldtype = ffi.CType{
						baseType = fieldtype,
						isPointer = true,
					}
					str, token, tokentype = consume(str)
				end

				assert(tokentype == 'name', "expected field name, found "..tostring(token)..", rest "..tostring(str))
				local fieldname = token
				local field = Field{
					name = fieldname,
					type = fieldtype,
				}
				ctype.fields:insert(field)

				str, token, tokentype = consume(str)
				while token == '[' do
					str, token, tokentype = consume(str)
					assert(tokentype == 'number', "expected array size")
					local count = assert(tonumber(token))
					assert(count > 0, "can we allow non-positive-sized arrays?")
					field.count = count

					str, token, tokentype = consume(str)
					assert(token == ']')

					str, token, tokentype = consume(str)
				end

				if token == ';' then
					break
				elseif token ~= ',' then
					error("expected , or ;")
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
	local ctype = ffi.CType{
		name = name,
		baseType = assert(ctypes.uint32_t),
	}

	local value = 0
	while true do
		assert(tokentype == 'name', "enum expected name, got "..tostring(token).." rest is "..str)
		local name = token

		str, token, tokentype = consume(str)
		if token == '=' then
			str, token, tokentype = consume(str)
			assert(tokentype == 'number', "expected value to be a number, found "..tostring(token).." rest "..tostring(str))
			value = token
			
			str, token, tokentype = consume(str)
		end
	
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
				srctype = ffi.CType{
					baseType = srctype,
					isPointer = true,
				}
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
--print'parse done'
end

function ffi.cdef(str)
--print("ffi.cdef("..tostring(str)..")")
	-- TODO ... hmm ... luajit's lj_cparse ...
	-- I can compile that to emscripten ...
	-- hmm ...
	str = removeCommentsAndApplyContinuations(str)
	parse(str)
--print'ffi.cdef done'
end

function ffi.sizeof(ctype)
--print('ffi.sizeof('..tostring(ctype)..')')
	-- TODO matches ffi.new ...
	if type(ctype) == 'string' then
		local typename = trim(ctype)
		local basetype, ar = typename:match'^(.+)%s*%[(%d+)%]$'
		if basetype then
			return tonumber(ar) * ffi.sizeof(basetype)
		end
		ctype = assert(getctype(typename), "couldn't find type "..typename)
	end
	assert(getmetatable(ctype) == ffi.CType, "ffi.sizeof object is not a ctype")
--assert(ctype.size, "need to calculate a size")
--print('ffi.sizeof('..tostring(ctype)..') = '..ctype.size)
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
		omt.blob = assert(blob)
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
			local fieldOffset = mt.offset + index * mt.type.size
			if fieldType.isPrimitive then
				return fieldtype.get(mt.blob.dataview, fieldOffset)
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
		error("can't index cdata of type "..tostring(self))
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
			local fieldType = mt.type.baseType
			local fieldOffset = mt.offset + index * mt.type.size
			if fieldType.isPrimitive then
				return fieldtype.set(mt.blob.dataview, fieldOffset, value)
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
		error("can't assign cdata of type "..tostring(self))
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

function ffi.new(ctype, ...)
	-- [[ same as in ffi.sizeof:
	if type(ctype) == 'string' then
		-- TODO proper tokenizer for C types
		local typename = trim(ctype)
		local basetype, ar = typename:match'^(.+)%s*%[(%d+)%]$'
		if basetype then
			-- TODO also change the ctype to an array-of-base-type?
			-- so that ffi.sizeof will work ...
			ar = assert(tonumber(ar))
			ctype = assert(getctype(basetype), "couldn't find type "..basetype)
			-- make an array-type of the base type
			ctype = ffi.CType{
				baseType = ctype,
				arrayCount = ar,
			}
		else
			ctype = assert(getctype(typename), "couldn't find type "..typename)
		end
	end
	assert(getmetatable(ctype) == ffi.CType, "ffi.sizeof object is not a ctype")
	--]]

	-- TODO return a pointer?
	-- or how will sizeof handle pointers?
	-- or should I return a pointer-to-fixed-size-array, which auto converts to pointer to base type upon arithmetic?
	local blob = MemoryBlob(ctype.size)

	local ptr = CData(blob, ctype)

	if select('#', ...) > 0 then
		ctype:assign(blob, 0, ...)
	end

	return ptr
end

-- TODO ptr has to be a MemoryBlob
local function strlen(buffer)
	for i=0,buffer.length-1 do
		if buffer[i] == 0 then
			return i
		end
	end
	return buffer.length
end

-- string-to-lua here
-- TODO ptr has to be a MemoryBlob
function ffi.string(ptr)
	if ptr == ffi.null then
		return '(null)'
	end
	return tostring(js.new(js.global.TextDecoder):decode(
		ptr.buffer:subarray(0, strlen(ptr.buffer))
	))
end

-- not in the luajit ffi api
-- lua-string to MemoryBlob
function ffi.stringBuffer(str)
	str = tostring(str)
	-- ... starting to think I should just allocate all my ffi memory as a giant js buffer
	local blob = MemoryBlob(#str+1)
	for i=1,#str do
		blob.buffer[i-1] = str:byte(i)
	end
	blob.buffer[#str] = 0
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
--print('calling ctor on '..ctype.name..' with', ...)
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

--[[
because nil and anything else (userdata, object, etc) will always be false in vanilla lua ...
--]]
ffi.null = {}

return ffi
