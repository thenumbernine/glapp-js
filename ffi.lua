local ffi = {}

ffi.os = 'Web'
ffi.arch = 'x64'

-- put ffi.cdef functions here
ffi.C = {}

function ffi.cdef(str)
	-- TODO c tokenizer here
	print("TODO ffi.cdef("..tostring(str)..")")
end

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
-- NOTICE this field deviates from luajit ffi
local ctypes = {}

local function addprim(name, size)
	ctypes[name] = {name = name, size = size}
end

addprim('char', 1)
addprim('sigend char', 1)
addprim('unsigned char', 1)
addprim('short', 2)
addprim('sigend short', 2)
addprim('unsigned short', 2)
addprim('int', 4)
addprim('sigend int', 4)
addprim('unsigned int', 4)
addprim('intptr_t', 8)
addprim('float', 4)
addprim('double', 4)
addprim('long double', 8)
addprim('int8_t', 1)
addprim('uint8_t', 1)
addprim('int16_t', 2)
addprim('uint16_t', 2)
addprim('int32_t', 4)
addprim('uint32_t', 4)
addprim('int64_t', 8)
addprim('uint64_t', 8)

ffi.typedefs = {}

ffi.ctype = setmetatable({}, {
	__call = function(mt, name, ...)
		local o = setmetatable({}, mt)
		o.name = name
		ctypes[o.name] = o
		-- ... is fields
		-- calculate size here
		o.fields = {...}
		o.size = 0
		-- TODO alignment ...
		for _,field in ipairs(o.fields) do
			o.size = o.size + ffi.sizeof(field.type)
		end
		o.size = math.max(1, o.size)
		return o
	end,
})
ffi.ctype.__index = ffi.ctype

function ffi.sizeof(typename)
	-- TODO proper tokenizer for C types
	typename = typename:match'^%s*(.-)%s*$' or typename
	local base, ar = typename:match'^(.+)%s*%[(%d+)%]$'
	if base then
		return tonumber(ar) * ffi.sizeof(base)
	end

	while true do
		local typedef = ffi.typedefs[typename]
		if not typedef then break end
		typename = typedef
	end

	local ctype = ctypes[typename]
	if not ctype then
		error("don't know ctype "..require 'ext.tolua'(typename))
	end

	return ctype.size
end

local ffiblob = setmetatable({}, {
	__call = function(mt, typename, count, gen)
		local o = setmetatable({}, mt)
		o.typename = typename
		local size = count * ffi.sizeof(typename)
		o.size = size
		o.buffer = js.new(js.global.Uint8Array, size)
		if gen then
			for i=0,size-1 do
				o.buffer[i] = gen(i)
			end
		end
		return o
	end,
})
ffiblob.__index = ffiblob 

function ffi.new(typename, value)
	typename = typename:match'^%s*(.-)%s*$' or typename
	local base = typename:match'^(.+)%s*%[%?%]$'
	if base then
		return ffiblob(base, value)
	end

	-- TODO translate typedefs here first
	return ffiblob(typename, 1)
end

-- TODO ptr has to be a ffiblob
local function strlen(buffer)
	for i=0,buffer.length-1 do
		if buffer[i] == 0 then
			return i
		end
	end
	return buffer.length
end

-- string-to-lua here
-- TODO ptr has to be a ffiblob
function ffi.string(ptr)
	if ptr == ffi.null then
		return '(null)'
	end
	return tostring(js.new(js.global.TextDecoder):decode(
		ptr.buffer:subarray(0, strlen(ptr.buffer))
	))
end

-- lua-string to ffiblob
function ffi.stringBuffer(str)
	str = tostring(str)
	-- ... starting to think I should just allocate all my ffi memory as a giant js buffer 
	return ffiblob('char', #str+1, function(i)
		return str:byte(i+1) or 0
	end)
end

--[[
because nil and anything else (userdata, object, etc) will always be false in vanilla lua ...
--]]
ffi.null = {}

return ffi
