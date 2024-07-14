-- also in ext.class
local oldtype = _G.type
local oldtonumber = _G.tonumber

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

local membuf = js.new(js.global.ArrayBuffer, 0x100000)
ffi.membuf = membuf

local memview = js.new(js.global.DataView, membuf)
ffi.memview = memview

local memUsedSoFar = 0

function ffi.memdump(from, len)
	from = from or 0
	len = len or memUsedSoFar - from
	local s = {}
	for i=from,from+len-1 do
		table.insert(s, ('%02x'):format(memview:getUint8(i)))
	end
	return table.concat(s)
end

local dict = newtable()
local function malloc(size)
	-- no zero allocs
	size = math.max(size, 4)
	-- 4byte align
	size = (size & ~3) + ((size & 3) == 0 and 0 or 4)

--DEBUG:print('malloc', size)
	for _,d in ipairs(dict) do
		if d.free
		and d.size >= size
		then
			d.free = false
			return d.addr
		end
	end

	local reqmax = memUsedSoFar + size
	if reqmax > membuf.byteLength then
		membuf:resize(bit.band(reqmax, 0xfffff) + 0x100000)	-- 1<<20-1
print('resizing base memory to', membuf.byteLength)
	end

	local addr = memUsedSoFar
	dict:insert{
		addr = addr,
		size = size,
		free = false,
	}
	memUsedSoFar = memUsedSoFar + size
	return addr
end

-- put ffi.cdef types here
local ctypes = {}
ffi.ctypes = ctypes

-- ptr type and 64 and js is a mess
local function memSetPtr(addr, value)
	--[[ even tho i've got intptr_t set to 64 bit, js doesn't like assigning 64 bits at once, so ...
	gettype'intptr_t'.set(memview, addr, value)
	--]]
	-- [[
	ctypes.uint32_t.set(memview, addr, value)
	--ctypes.uint32_t.set(memview, addr + 4, 0)	-- only for 64bit addresses
	--]]
end
ffi.memSetPtr = memSetPtr

-- read the pointer in memory at addr
local function memGetPtr(addr)
	return ctypes.uint32_t.get(memview, addr)
--		| (ctypes.uint32_t.get(memview, addr + 4, 0) << 32)	-- allow >32 bit?
end
ffi.memGetPtr = memGetPtr

local function getTypeAndMT(o)
	local mt = debug.getmetatable(o)
	local t = oldtype(o)
	if mt then
		if mt.isCType then
			t = 'cdata'	-- this is a convention I wouldn't have chosen ...
		elseif mt.isCData then
			t = 'cdata'
		end
	end
	return t, mt
end

-- x = cdata
-- if x's type is an array or prim then return x's addr
-- if x's type is a pointer hten return x's value
local function getAddr(x)
	local t, mt = getTypeAndMT(x)
	if not (t == 'cdata' and mt.isCData) then error("expected cdata") end
	local ctype = assert(mt.type)
	local addr = assert(mt.addr)
	if ctype.isPointer then return memGetPtr(addr) end

	-- TODO real luajit ffi has ref types as well
	-- this should only return addr if the type is a ref-type or an array type ... not for primitives!
	assert(not ctype.isPrimitive, "TODO reftypes")
	return addr
end
ffi.getAddr = getAddr

local function strlen(addr)
	local len = 0
	while true do
		if addr >= memview.byteLength then
			error("strlen ran away")
		end
		if memview:getUint8(addr) == 0 then break end
		addr = addr + 1
		len = len + 1
	end
	return len
end

-- alloc and push string onto mem and return its addr
local function pushString(str)
	str = tostring(str)
	local len = #str
	local addr = malloc(len+1)
	for i=1,len do
		memview:setUint8(addr + i-1, str:byte(i))
	end
	memview:setUint8(addr + len, 0)
	return addr
end

local nextuniquenameindex = 0
local function nextuniquename()
	nextuniquenameindex = nextuniquenameindex + 1
	return '#'..nextuniquenameindex
end

local CType

local Field = class()
function Field:init(args)
	self.name = assert(args.name)
	assert(type(self.name) == 'string')
	self.type = assert(args.type)
assert(debug.getmetatable(self.type) == CType)
	self.offset = 0	-- calculate this later
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
CType = class()
ffi.CType = CType
function CType:init(args)
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
--DEBUG:print('...CType new name', self.name)
	else
--DEBUG:print('...CType already has name', self.name)
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
		self.get = args.get
		self.set = args.set
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

--DEBUG:print('setting ctype['..self.name..'] = '..tostring(self))
end

function CType:finalize()
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

--DEBUG:print('struct name', self.name)
--DEBUG:for i,field in ipairs(self.fields) do
--DEBUG:print('field', i, 'name', field.type, field.name, 'offset', field.offset)
--DEBUG:end
--DEBUG:for name,field in pairs(self.fieldForName) do
--DEBUG:print('fieldForName', field.type, name, 'offset', field.offset)
--DEBUG:end
end

function CType:assign(addr, ...)
--DEBUG:print('CType:assign', addr, ...)
	if select('#', ...) > 0 then
		if self.fields then
--DEBUG:print('...assigning to struct')
			-- structs
			if self.isunion then
				-- then only assign to the first entry? hmmm ...
				self.fields[1].type:assign(addr, ...)
			else
				for i=1,math.min(#self.fields, select('#', ...)) do
					local field = self.fields[i]
					field.type:assign(addr + field.offset, (select(i, ...)))
				end
			end
		elseif self.arrayCount then
--DEBUG:print('...assigning to array')
			-- arrays
			local v = ...
			if type(v) == 'table' then
				for i=1, #v do
					self.baseType:assign(addr + (i-1) * self.baseType.size, v[i])
				end
			else
				for i=1, select('#', ...) do
					local vi = select(i, ...)
					self.baseType:assign(addr + (i-1) * self.baseType.size, vi)
				end
			end
		else
--DEBUG:print('...assigning to primitive or pointer')
			assert(self.isPrimitive, "assigning to a non-primitive...")
			local v = ...
			local vt = type(v)
			local srcmt = debug.getmetatable(v)
			-- TODO maybe all this goes inside self.set?
			if v == nil then
				self.set(memview, addr, 0)
			elseif vt == 'cdata'
			and srcmt.isCData
			then
--DEBUG:print('...assigning from cdata')
--DEBUG:print('...with addr', srcmt.addr)
				local srcctype = srcmt.type
--DEBUG:print('...with ctype', srcctype)
				local len = self.size	--srcmt.type.size
--DEBUG:print('...with len', len)
				-- same as ffi.copy
				if srcctype.isPointer then
					value = memGetPtr(srcmt.addr)
--DEBUG:print('assigning from pointer with value-addr', value,'to addr', addr)
					self.set(memview, addr, value)
--DEBUG:print('double-check got at addr '..addr..' value', self.get(memview, addr))
				elseif srcctype.arrayCount then
					-- TODO only if we are assigning to a pointer?  to an intptr_t ?
					self.set(memview, addr, srcmt.addr)
				else
					self.set(memview, addr, srcctype.get(memview, srcmt.addr))
				end
			elseif vt ~= 'number' then
				error("can't convert "..vt.." to number")
			else
assert(self.set, "expected primitive to have a setter")
				self.set(memview, addr, v)
			end
--DEBUG:print('TODO *('..tostring(self)..')(ptr+'..tostring(addr)..') = '..tostring(v))
--DEBUG:print(debug.traceback())
		end
	end
end

-- I think I need to make ffi.typeof return proxy objects to CType
-- and then I need to make ffi.new, ffi.cast, etc accept these objects
-- and then the luajit code will operate on these objects,
--  and the CType .mt etc will be hidden from it
local CTypeProxy = setmetatable({}, {
	__call = function(mt, ctype)
		if debug.getmetatable(ctype) ~= CType then
			error("CTypeProxy() expected a CType object, got "..tostring(ctype))
		end

		local omt = {}
		for k,v in pairs(mt) do
			omt[k] = v
		end

		omt.type = ctype
		omt.isCType = true

		return setmetatable({}, omt)
	end,
})

CTypeProxy.__metatable = 'ffi'

function CTypeProxy:__call(...)
	local mt = debug.getmetatable(self)
	if not mt then error("tried to do ffi metatype __call on a non cdata") end
	local ctype = mt.type
	local ffimt = ctype.mt
	if not ffimt or not ffimt.__call then
		return ffi.new(ctype, ...)
	end
	return ffimt.__call(self, ...)
end

function CTypeProxy:__index(key)
	local mt = debug.getmetatable(self)
	if not mt then error("tried to do ffi metatype __index on a non cdata") end
	local ctype = mt.type
	local ffimt = ctype.mt
	if ffimt then
		local index = ffimt.__index
		if type(index) == 'function' then
			return index(self, key)
		elseif type(index) == 'table' then
			return index[key]
		else
			error(tostring(ctype).." has unknown __index type "..type(index))
		end
	end
	error("'"..tostring(ctype).."' has no member '"..tostring(key).."'")
end

function CTypeProxy:__tostring()
	local mt = debug.getmetatable(self)
	if not mt then error("tried to do ffi metatype __index on a non cdata") end
	local ctype = mt.type
	return 'ctype<'..tostring(ctype.name)..'>'
end

--[=[
function CType:__index(key)
	local mt = rawget(self, 'mt')
	--[[
	if mt then
		local index = mt.__index
		if index then
			if type(index) == 'function' then
				return index(self, key)
			elseif type(index) == 'table' then
				return index[key]
			end
		end
	end
	--]]
	return rawget(self, key)
end
--]=]

CType{name='void', size=0, isPrimitive=true}	-- let's all admit that a void* is really a char*
CType{name='bool', size=1, isPrimitive=true, getset='Uint8'}	-- not a typedef of char / byte ...
CType{name='int8_t', size=1, isPrimitive=true, getset='Int8'}
CType{name='uint8_t', size=1, isPrimitive=true, getset='Uint8'}
CType{name='int16_t', size=2, isPrimitive=true, getset='Int16'}
CType{name='uint16_t', size=2, isPrimitive=true, getset='Uint16'}
CType{name='int32_t', size=4, isPrimitive=true, getset='Int32'}
CType{name='uint32_t', size=4, isPrimitive=true, getset='Uint32'}

CType{name='int64_t', size=8, isPrimitive=true,
	get=function(memview, addr)
		--[[
		return memview:getBigInt64(addr)
		--]]
		-- [[
		return memview:getUint32(addr) | (memview:getUint32(addr + 4) << 32)
		--]]
	end,
	set=function(memview, addr, v)
		--[[ "Cannot convert undefined to a BigInt"
		return memview:setBigInt64(addr, js.global.BigInt(v))
		--]]
		--[[ "Invalid value used as weak map key"
		return memview:setBigInt64(addr, js.global.BigInt(nil, v))
		--]]
		--[[ "Invalid value used as weak map key"
		return memview:setBigInt64(addr, js.global.BigInt(js.global.BigInt, v))
		--]]
		-- [[
		memview:setInt32(addr, v & 0xffffffff)
		memview:setInt32(addr + 4, (v >> 32) & 0xffffffff)
		--]]
	end,
}	-- why Big?
CType{name='uint64_t', size=8, isPrimitive=true,
	get=function(memview, addr)
		--return memview:getBigUInt64(addr)
		return memview:getUint32(addr) | (memview:getUint32(addr + 4) << 32)
	end,
	set=function(memview, addr, v)
		--return memview:setBigUInt64(addr, js.global.BigInt(v))
		memview:setUint32(addr, v & 0xffffffff)
		memview:setUint32(addr + 4, (v >> 32) & 0xffffffff)
	end,
}

-- i hate javascript ... endianness problems ...
CType{name='float', size=4, isPrimitive=true,
	get=function(memview, addr)
		return memview:getFloat32(addr, true)
	end,
	set=function(memview, addr, v)
		memview:setFloat32(addr, v, true)
	end,
}
CType{name='double', size=8, isPrimitive=true,
	get=function(memview, addr)
		return memview:getFloat64(addr, true)
	end,
	set=function(memview, addr, v)
		memview:setFloat64(addr, v, true)
	end,
}
--CType{name='long double', size=16, isPrimitive=true}	-- no get/set in Javascript DataView ... hmm ...

-- add these as typedefs
CType{name='char', baseType=assert(ctypes.uint8_t)}	-- char default is unsigned, right?
CType{name='signed char', baseType=assert(ctypes.int8_t)}
CType{name='unsigned char', baseType=assert(ctypes.uint8_t)}
CType{name='short', baseType=assert(ctypes.int16_t)}
CType{name='signed short', baseType=assert(ctypes.int16_t)}
CType{name='unsigned short', baseType=assert(ctypes.uint16_t)}
CType{name='int', baseType=assert(ctypes.int32_t)}
CType{name='signed int', baseType=assert(ctypes.int32_t)}
CType{name='unsigned int', baseType=assert(ctypes.uint32_t)}
CType{name='long', baseType=assert(ctypes.int64_t)}
CType{name='signed long', baseType=assert(ctypes.int64_t)}
CType{name='unsigned long', baseType=assert(ctypes.uint64_t)}
--[[ I wish but js and BigInt stuff is irritating
CType{name='intptr_t', baseType=assert(ctypes.int64_t)}
CType{name='uintptr_t', baseType=assert(ctypes.uint64_t)}
--]]
-- [[
CType{name='intptr_t', baseType=assert(ctypes.int32_t)}
CType{name='uintptr_t', baseType=assert(ctypes.uint32_t)}
--]]
CType{name='ssize_t', baseType=assert(ctypes.int64_t)}
CType{name='size_t', baseType=assert(ctypes.uint64_t)}

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
		local esc = oldtonumber(d:sub(4,5), 16)
		assert(esc, "failed to parse hex char "..d)
		return rest, esc, 'char'	-- TODO escape?
	end

	error("unknown token "..str)
end

-- follow typedef baseType lookups to the origin and return that
local function getctype(typename)
	local ctype = ctypes[typename]
	if not ctype then return end

	if ctype.baseType
	and not ctype.arrayCount
	and not ctype.isPointer
	then
		local sofar = {}
		-- if it has a baseType and no arrayCount then it's just a typedef ...
		repeat
			if sofar[ctype] then
				error"found a typedef loop"
			end
			sofar[ctypes] = true
			ctype = ctype.baseType
		until not (
			ctype.baseType
			and not ctype.arrayCount
			and not ctype.isPointer
		)
	end
	return ctype
end

local function getptrtype(baseType)
--DEBUG:print('getptrtype', baseType)
	local ptrtypename = baseType.name..'*'
--DEBUG:print('getptrtype ptrtypename', ptrtypename)
	local ptrType = getctype(ptrtypename)
	if ptrType then
--DEBUG:print('...getptrtype found old', ptrType, ptrType == ctypes.void, ptrType==ctypes['void*'])
		return ptrType
	end
	ptrType = CType{
		baseType = baseType,
		isPointer = true,
	}
--DEBUG:print('...getptrtype made new', ptrType)
	return ptrType
end

local function getArrayType(baseType, ar)
	local ctype = getctype(baseType.name..'['..ar..']')
--DEBUG:print('looking for ctype name', baseType.name..'['..ar..'], got', ctype)
	-- if not then make the array-type
	if not ctype then
		ctype = CType{
			baseType = baseType,
			arrayCount = ar,
		}
	end
	return ctype
end

-- parse a ffi.cast or ffi.new
-- similar to struct but without the loop over multiple named vars with the same base type
local function parseType(str, allowVarArray)
--DEBUG:print('parseType', ('%q'):format(str), allowVarArray)
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

--DEBUG:print('parseType name', name)
	-- fields ...
	-- TODO this should be 'parsetype' and work just like variable declarations
	-- and should be interoperable with typedefs
	-- except typedefs can't use comma-separated list (can they?)
	local baseFieldType = assert(getctype(name), "couldn't find type "..name)
assert(debug.getmetatable(baseFieldType) == CType)
assert(baseFieldType.size, "ctype "..tostring(name).." has no size!")
--DEBUG:print('parseType baseFieldType', baseFieldType)
--DEBUG:print('does baseFieldType* exist?', ctypes[baseFieldType.name..'*'])
	str, token, tokentype = consume(str)
	local fieldtype = baseFieldType
	while token == '*' do
--DEBUG:print('...looking for ptr of type', fieldtype)
		fieldtype = getptrtype(fieldtype)
--DEBUG:print('...making ptr type', fieldtype)
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
			count = assert(oldtonumber(token))
			assert(count > 0, "can we allow non-positive-sized arrays?")
			fieldtype = getArrayType(fieldtype, count)
		end

		str, token, tokentype = consume(str)
		assert(token == ']')
		str, token, tokentype = consume(str)
	end

	assert(not str or str:match'^%s*$', 'done parsing type with this left: '..tostring(str))
--DEBUG:print('parseType got', fieldtype, gotVarArray)
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
	local ctype = CType{
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
assert(debug.getmetatable(nestedtype) == CType)
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
assert(debug.getmetatable(baseFieldType) == CType)
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
					local count = assert(oldtonumber(token))
					assert(count > 0, "can we allow non-positive-sized arrays?")
					-- TODO shouldn't we be modifying field.type to be an array-type with array 'count' ?
					fieldtype = getArrayType(fieldtype, count)
					field.type = fieldtype

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

-- TODO would be nice to treat enums as constants / define's ...
-- using the ext.load shim layer maybe ...
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
		ctype = CType{
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
			value = tonumber(value)
			if not value then
				error("failed to parse enum as number: "..token)
			end

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
				CType{
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
	if debug.getmetatable(ctype)
	and debug.getmetatable(ctype).isCType
	then
		ctype = debug.getmetatable(ctype).type
	end

	local didHandleVarArray
	if type(ctype) == 'string' then
		ctype, gotVarArray = parseType(ctype, allowVarArray)
		if gotVarArray then
			local count = assert(oldtonumber((...)))
			ctype = getArrayType(ctype, count)
			didHandleVarArray = true
		end
		assert(debug.getmetatable(ctype) == CType, "ctypes[] entry is not a CType")
	else
		assert(debug.getmetatable(ctype) == CType, "toctype got an unknown arg "..tostring(ctype))
	end
	return ctype, didHandleVarArray
end

-- TODO move this up or down?
function type(o)
	return (getTypeAndMT(o))
end

-- casts a string, cdata, or CType to a CType
local function toctypefromdata(ctype)
--DEBUG:print('toctypefromdata', ctype)
	local t, mt = getTypeAndMT(ctype)
	if t == 'cdata'
	and mt.isCData
	then
		ctype = assert(mt.type)
	end
	return toctype(ctype)
end

-- convert string, cdata, or ctype to ctype
function ffi.typeof(x)
	local t = type(x)
	if t ~= 'cdata'
	and t ~= 'string'
	then
		error('bad argument to ffi.typeof (ctype expected, got '..t..')')
	end
--DEBUG:print('ffi.typeof result', x)
	return CTypeProxy((toctypefromdata(x)))
end

function ffi.sizeof(ctype)
--DEBUG:print('ffi.sizeof', ctype)
	ctype = toctypefromdata(ctype)
assert(ctype.size, "need to calculate a size")
--DEBUG:print('ffi.sizeof('..tostring(ctype)..') = '..ctype.size)
	return ctype.size
end

-- metatable assigned *after* init for CData
local CData = setmetatable({}, {
	__call = function(mt, ctype, addr)
		-- NOTICE unlike most class()'s, 'o' doesn't yet have access to its mt during construction
		local o = {}	--

		-- now 'o's __index will be overridden so it can be treated like a C pointer
		local omt = {}
		for k,v in pairs(mt) do
			omt[k] = v
		end

		-- hide these from user ... but how?
		omt.type = ctype or ctypes.uint8_t
		omt.addr = assert(addr)
		omt.isCData = true

		return setmetatable(o, omt)
	end,
})

CData.__metatable = 'ffi'

-- hmm __index is overridden for the user's api
-- so that means I can't use self: for CData ...
function CData:__index(key)
--print('CData.__index', 'self', key)	-- , self calsl tostring calls index inf loop ...
	local mt = debug.getmetatable(self)
--print('mt', mt)
	local ctype = mt.type
--print('ctype', ctype)
	assert(debug.getmetatable(ctype) == CType)
	local ctypemt = ctype.mt

	if ctype.baseType then
		if ctype.arrayCount then
			-- array ...
			local index = oldtonumber(key) or error("expected key to be integer, found "..require 'ext.tolua'(key))
			local fieldType = mt.type.baseType
			local fieldAddr = mt.addr + index * ctype.baseType.size
			if fieldType.isPrimitive then
				return fieldType.get(memview, fieldAddr)
			else
				return CData(fieldType, fieldAddr)
			end
		else
			-- typedef
			error("don't allow pointers to hold typedefs")
		end
	elseif ctype.fields then
		-- struct/union
		local field = ctype.fieldForName[key]
		if field then
			local fieldType = field.type
			local fieldAddr = mt.addr + field.offset
			if fieldType.isPrimitive then
				return fieldType.get(memview, fieldAddr)
			else
				-- TODO the returned type should be a ref-type ... indicating not to copy upon assign ...
				return CData(fieldType, fieldAddr)
			end
		end
	else
		error("can't index cdata of type "..tostring(mt.type))
	end

	if ctypemt then
		local index = ctypemt.__index
--DEBUG:print('calling __index', index)
		if type(index) == 'function' then
			return index(self, key)
		elseif type(index) == 'table' then
			return index[key]
		else
			error(tostring(ctype).." has unknown __index type "..type(index))
		end
	else
		error("in type "..ctype.name.." couldn't find field "..tostring(key))
	end
end

function CData:__newindex(key, value)
--DEBUG:print('CData:__newindex', key, value)
	local mt = debug.getmetatable(self)
	local ctype = mt.type

	local valuetype = type(value)
	local valuemt = debug.getmetatable(value)
--DEBUG:print('CData:__newindex self=', self, 'ctype', ctype, 'key', key, 'value', value)
	if ctype.baseType then
		if ctype.arrayCount then
--DEBUG:print('...array assignment')
			-- array
			local index = oldtonumber(key) or error("expected key to be integer, found "..require 'ext.tolua'(key))
			local fieldType = ctype.baseType
			local fieldAddr = mt.addr + index * ctype.baseType.size
--DEBUG:print('...fieldType', fieldType.isPrimitive, fieldType.isPointer, 'valuetype', valuetype)
			if fieldType.isPrimitive then

				if valuetype == 'cdata'
				and valuemt.isCData
				then
					-- TODO here ... ffi.copy between the two ...
					-- but only if the types can be coerced first ...
					local valueType = valuemt.type
					assert(valueType.isPrimitive, "can't assign a non-primitive type "..tostring(valueType).." to a primitive type "..tostring(fieldType))
					value = valueType.get(memview, valuemt.addr)
				elseif valuetype == 'number' then
				elseif valuetype == 'boolean' then
					value = value and 1 or 0
				elseif valuetype == 'nil' then
					value = 0
				else
					--[[ do I need this here?
					if valuetype == 'string'
					and fieldType.isPointer
					and (fieldType.name == 'uint8_t' or fieldType.name == 'int8_t')
					then
						-- copy the lua-string to js-mem and return a pointer to it
						local ptr = ffi.stringBuffer(value)
						value = debug.getmetatable(ptr).addr
						-- here and below as well?
					else
					--]] do
						error("can't assign type '"..valuetype.."' to primitive c array type "..tostring(ctype))
					end
				end

--DEBUG:		assert(xpcall(function()
				fieldType.set(memview, fieldAddr, value)
--DEBUG:		end, function(err)
--DEBUG:			return 'setting '..tostring(fieldType.name)..' addr='..tostring(fieldAddr)..' value='..tostring(value)..' buffersize='..tostring(memview.byteLength)..'\n'
--DEBUG:				..tostring(err)..'\n'
--DEBUG:				..debug.traceback()
--DEBUG:		end))
				return
			elseif fieldType.isPointer
			and valuetype == 'string'
			then
				-- copy the lua-string to js-mem and return a pointer to it
--DEBUG:print('...assigning string to ptr, got src', ptr)
				value = pushString(value)
				memSetPtr(fieldAddr, value)
				return
			else
				error("can't assign type '"..valuetype.."' to non-primitive type fieldType="..tostring(fieldType))
			end
		else
			-- typedef
			error("don't allow pointers to hold typedefs")
		end
	elseif ctype.fields then
--DEBUG:print('...struct assignment')
		-- struct/union
		local field = ctype.fieldForName[key]
		if field then
			local fieldType = field.type
			local fieldAddr = mt.addr + field.offset
			if fieldType.isPrimitive then
				fieldType.set(memview, fieldAddr, value)
				return
			else
				error("cannot convert '"..type(value).."' to '"..tostring(field.type).."'")
			end
		end
	else
		error("can't assign cdata of type "..tostring(mt.type))
	end

	if ctype.mt and ctype.mt.__newindex then
		return ctype.mt.__newindex(self, key, value)
	end

	error("in type "..ctype.name.." couldn't find field "..tostring(key))
--DEBUG:print('...assign done')
end

function CData:__tostring()
--DEBUG:print('CData:__tostring')
	local mt = debug.getmetatable(self)
	local ctype = mt.type

	if ctype.mt and ctype.mt.__tostring then
		return ctype.mt.__tostring(self)
	end

--DEBUG:print('...ctype', ctype)
--DEBUG:print('...addr', mt.addr)
	local value
	if ctype.isPrimitive then
		assert(ctype ~= ctypes.void, "how did you get a void type?")
		value = ctype.get(memview, mt.addr)
--DEBUG:print('...prim value', value)
	elseif ctype.isPointer then
--DEBUG:print('...ptr value')
		if mt.addr == 0 then
			value = 'NULL'
		else
			-- [[
			local intptrtype = assert(getctype'intptr_t')
			value = intptrtype.get(memview, mt.addr)
			value = ('0x%08x'):format(value)
			--]]
			--[[
			-- "TypeError: Invalid value used as weak map key"
			value = ('0x%x'):format(memview:getBigUint64(mt.addr))
			--]]
			--[[ only for 64bit addresses
			value = ('0x%08x%08x'):format(memGetPtr(mt.addr + 4), memGetPtr(mt.addr))
			--]]
		end
	else
--DEBUG:print('...else value')
		value = ('0x%08x'):format(mt.addr)
	end
	return 'cdata<'..ctype.name..'>: '..tostring(value)
end

function CData:add(index)
	local mt = debug.getmetatable(self)
	return CData(
		mt.type,
		mt.addr + index * mt.type.size
	)
end

function CData.__add(a,b)
	local ma = debug.getmetatable(a)
	local mb = debug.getmetatable(b)
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

-- tonumber(cdata ptr) returns nil
-- but tonumber(cdata prim) returns the number value
function ffi.cast(ctype, src)
--DEBUG:print('ffi.cast', ctype, src)
	ctype = toctype(ctype)

	local srctype = type(src)
	local srcmt = debug.getmetatable(src)
--DEBUG:print('...srctype', srctype)
	if srctype == 'string' then
		-- in luajit doing this gives you access to the string's own underlying buffer
		-- TODO eventually pull that out of Fengari
		-- until then, make a new buffer and return the pointer to it
		src = ffi.stringBuffer(src)
		local srcmt = debug.getmetatable(src)
		return CData(ctype, srcmt.addr)
	--[[
	elseif srctype == 'nil' then
		return CData(ctype, 0)
	else	-- expect it to be cdata
		local srcmt = debug.getmetatable(src)
		return CData(ctype, srcmt.addr)
	--]]
	else
		-- if it's a ptr then just change the ptr type
		-- TODO this is going to grow into full on emulated memory management very quickly
		if ctype.isPointer then
			local value
			if srctype == 'number' then
				value = src
			elseif srctype == 'nil' then
				value = 0
			elseif srctype == 'cdata'
			and srcmt.isCData
			then
				value = srcmt.addr
--DEBUG:print('value', value)
				if srcmt.type.isPointer then
					value = memGetPtr(value)
--DEBUG:print('...get ptr contents', value)
				end
			else
				error("idk how to assign srctype "..srctype)
			end
			local result = ffi.new(ctype)
			memSetPtr(debug.getmetatable(result).addr, value)
			return result
		else
			-- same as ffi.new?
			return ffi.new(ctype, src)
		end
	end
end

function ffi.new(ctype, ...)
--DEBUG:print('ffi.new', ctype, ...)
	local didHandleVarArray
	ctype, didHandleVarArray = toctype(ctype, true, ...)

	assert(ctype ~= ctypes.void, "you can't new void")

	-- TODO return a pointer?
	-- or how will sizeof handle pointers?
	-- or should I return a pointer-to-fixed-size-array, which auto converts to pointer to base type upon arithmetic?
--DEBUG:print('ffi.new for type', ctype.name, 'allocating', ctype.size)
	local addr = malloc(ctype.size)
	local ptr = CData(ctype, addr)
	if not didHandleVarArray and select('#', ...) > 0 then
--DEBUG:print('ffi.new assigning', ctype, addr, ...)
		ctype:assign(addr, ...)
	end
--DEBUG:print('ffi.new returning', ptr)
	return ptr
end

-- string-to-lua here
-- TODO ptr has to be a MemoryBlob
function ffi.string(ptr, len)
--DEBUG:print('ffi.string', ptr, len)
	if ptr == ffi.null then return '(null)' end
	local tptr = type(ptr)
	if tptr == 'string' then
		-- TODO if len > #ptr then ... pad with zeroes?
		if len then return ptr:sub(1,len) end
		return ptr
	end
	assert(type(ptr) == 'cdata')
	local ptrmt = assert(debug.getmetatable(ptr))
	assert(ptrmt.isCData)
	local ptrctype = ptrmt.type
	local addr
	if ptrctype.arrayCount then
		addr = ptrmt.addr
	elseif ptrctype.isPointer then
		addr = memGetPtr(ptrmt.addr)	-- get the ptr's value from mem
	else
		error("idk how to ffi.string this ctype "..tostring(ptrctype))
	end
--DEBUG:print('...addr', addr)
	if not len then len = strlen(addr) end
--DEBUG:print('...len', len)
	return tostring(js.new(js.global.TextDecoder):decode(
		js.new(js.global.DataView, membuf, addr, len)
	))
end

-- not in the luajit ffi api
-- lua-string/js-string to cdata
-- alloc, push string.  return a newly alloc'd pointer pointing to it
-- since the lua layer needs the new ptr cdata object to be made
-- or TODO how about I just return the char[?] array instead of a char* pointing to it? and handle coercion of array/pointer elsewhere?
function ffi.stringBuffer(str)
--DEBUG:print('ffi.stringBuffer', str)
	str = tostring(str)
--DEBUG:print('...after tostring', str)
	local dst = ffi.new('char[?]', #str+1)
	ffi.copy(dst, str)
	-- which of these will worK? should all of them?
	--[[
	return ffi.cast('char*', dst)
	--]]
	--[[
	return ffi.new('char*', dst)
	--]]
	-- [[
	local p = ffi.new'char*'
	memSetPtr(debug.getmetatable(p).addr, debug.getmetatable(dst).addr)
	--]]
	return p
end

function ffi.metatype(ctype, mt)
--DEBUG:print('ffi.metatype', ctype, mt)
	if type(ctype) == 'string' then
		-- TODO parseType instead of getctype to handle spaces/aliases
		ctype = assert(getctype(ctype), "couldn't find type "..ctype)
--DEBUG:print('...got ctype', ctype)
	end
	assert(debug.getmetatable(ctype) == CType, "ffi.sizeof object is not a ctype")

	assert(ctype.fields, "can only call ctype on structs/unions")

	-- only metatype on structs/unions
	if ctype.mt then
		error("already called ffi.metatype on type "..tostring(ctype.name))
	end
	-- modify it to include __call ...
	local copy = {}
	for k,v in pairs(mt) do
--DEBUG:print('copying', k, v)
		copy[k] = v
	end
	mt = copy

	-- TODO store old __index
	-- and give this a new __index
	-- which first looks up any field names, tries to write to them
	-- and if it fails then goes to __index

	ctype.mt = mt
--DEBUG:print('returning ctype.mt', ctype.mt)
	--return ctype.mt
	return CTypeProxy(ctype)
end

local function cdataToHex(d)
	local mt = debug.getmetatable(d)
	local s = {}
	for i=mt.addr,mt.addr + mt.type.size-1 do
		table.insert(s, ('%02x'):format(memview:getUint8(i)))
	end
	return table.concat(s)
end

local function getMemSub(jsarray, addr, count)
	return js.new(jsarray, membuf, addr, count)
end

local function memcpy(dstaddr, srcaddr, len)
	getMemSub(js.global.Uint8Array, dstaddr, len):set(
		getMemSub(js.global.Uint8Array, srcaddr, len)
	)
end

-- count is in number of jsarray elements, so divide bytes by sizeof whatever that is
-- TODO better name, this isn't a DataView is it ...
function ffi.getDataView(jsarray, data, count)
--DEBUG:print('ffi.getDataView', jsarray, data, count)
	local addr = getAddr(data)
	local result = getMemSub(jsarray, addr, count)
	return result
end


function ffi.copy(dst, src, len)
--DEBUG:print('ffi.copy', cdataToHex(dst), cdataToHex(src), len)
	local dstaddr = getAddr(dst)
	if type(src) == 'string' then
		-- convert from lua string to js buffer
		len = len or #src+1	-- ...including the newline
		for i=1,len do
			memview:setUint8(dstaddr + i-1, src:byte(i) or 0)
		end
	else
		assert(len, "expected len")	-- or can't it coerce size from cdata?
		-- construct a temporary object just to copy bytes.  why is javascript so retarded?
		memcpy(dstaddr, getAddr(src), len)
	end
--DEBUG:print('ffi.copy finished', cdataToHex(dst), cdataToHex(src), len)
end

function ffi.fill(dst, len, value)
	local addr = getAddr(dst)
	value = value or 0
	-- what type/size does luajit ffi fill with?  uint8? 16? 32? 64?
	js.new(js.global.Uint8Array, membuf, addr, len):fill(value, 0, len)
end

function tonumber(x, ...)
	local mt = debug.getmetatable(x)
	if type(x) == 'cdata'
	and mt.isCData
	then
		local ctype = mt.type
		if ctype.isPrimitive then
			return ctype.get(memview, mt.addr)
		else
			return nil
		end
	else
		return oldtonumber(x, ...)
	end
end

--[[
because nil and anything else (userdata, object, etc) will always be false in vanilla lua ...
--]]
ffi.null = ffi.new'void*'

return ffi
