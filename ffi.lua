local ffi = {}

ffi.os = 'Web'
ffi.arch = 'x64'

-- put ffi.cdef functions here
ffi.C = {}

-- also in ext/table.lua
local tablemt = {__index = table}

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

-- TODO rename to struct/union?
ffi.ctype = setmetatable({}, {
	__call = function(mt, name)
		local o = setmetatable({}, mt)
		-- name is optional, it could be nameless for typedef'd or anonymous nested structs
		if not name then
			name = nextuniquename()
		end
		o.name = name
		ctypes[o.name] = o
		-- size is optional, it'll be computed for structs, it'll be manually set for primitives
		-- fields is optional, it will only exist for structs
		return o
	end,
})
ffi.ctype.__index = ffi.ctype
function ffi.ctype:calcSize()
	-- calculate size here
	self.size = 0
	-- TODO alignment ...
	for _,field in ipairs(self.fields) do
		assert(field.type)
		self.size = self.size + ffi.sizeof(field.type)
	end
	self.size = math.max(1, self.size)
end



local function addprim(name, size)
	local primtype = ffi.ctype(name)
	primtype.size = size
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

local function nexttoken(str)
	str = trim(str)
	if #str == 0 then return nil, '' end
	-- symbols, first-come first-serve, interpret largest to smallest
	for _,symbol in ipairs{'(', ')', '[', ']', '{', '}', ',', ';'} do
		if str:match('^'..patescape(symbol)) then
			return str:sub(#symbol+1), symbol, 'symbol'
		end
	end
	-- keywords
	for _,keyword in ipairs{'typedef', 'struct', 'union'} do
		if str:match('^'..keyword) and (str:match('^'..keyword..'$') or str:match('^'..keyword..'[^_a-zA-Z0-9]')) then
			return str:sub(#keyword+1), keyword, 'keyword'
		end
	end
	-- names
	local name = str:match('^([_a-zA-Z][_a-zA-Z0-9]*)')
	if name then
		return str:sub(#name+1), name, 'name'
	end
	-- numbers
	local d = str:match'^(%d+)'
	if d then
		return str:sub(#d+1), d, 'number'
	end
	
	error("unknown token "..str)
end

local function getctype(typename)
	while true do
		local typedef = ffi.typedefs[typename]
		if not typedef then break end
		typename = typedef
	end

	local ctype = ctypes[typename]
	if not ctype then
		error("don't know ctype "..require 'ext.tolua'(typename))
	end

	assert(getmetatable(ctype) == ffi.ctype, "got a non-ctype object when looking for "..typename)
	return ctype
end

-- assumes 'struct' or 'union' has already been parsed
-- doesn't assert closing ';' (since it could be used in typedef)
local function parsestruct(str, isunion)
	local ctype = ffi.ctype()
	ctype.fields = setmetatable({}, tablemt)
	ctype.isunion = isunion
	
	local token, tokentype
	str, token, tokentype = nexttoken(str)
	if tokentype == 'name' then
		ctype.name = token
		str, token, tokentype = nexttoken(str)
	end
	assert(token == '{')
	
	while true do
		str, token, tokentype = nexttoken(str)
		if token == '}' then break end

print('field first token', token, tokentype)
		if token == 'struct'
		or token == 'union'
		then
			-- nameless struct/union's within struct/union's ...
			-- or even if they have names, the names should get ignored?  
			-- or how long does the scope of the name of an inner struct in C last?
			
			local nestedtype
			str, nestedtype = parsestruct(str, token == 'union')
			assert(getmetatable(nestedtype) == ffi.ctype)
			ctype.fields:insert{name = '', type = nestedtype}	-- what kind of name should I use for nameless nested structs?
			
			str, token, tokentype = nexttoken(str)
			assert(token == ';', "expected ';', found "..tostring(token))
		else
			-- fields ...
			-- TODO this should be 'parsetype' and work just like variable declarations
			-- and should be interoperable with typedefs
			-- except typedefs can't use comma-separated list (can they?)
			assert(tokentype == 'name', "expected field type, found "..tostring(token)..", rest="..tostring(str))
			local fieldtype = assert(getctype(token), "failed to get ctype")
			assert(getmetatable(fieldtype) == ffi.ctype)
		
			while true do
				str, token, tokentype = nexttoken(str)
				assert(tokentype == 'name', "expected field name, found "..tostring(token)..", rest="..tostring(str))
				local fieldname = token
				local field = {name = fieldname, type = fieldtype}
				ctype.fields:insert(field)
				
				str, token, tokentype = nexttoken(str)
				while token == '[' do
					str, token, tokentype = nexttoken(str)
					assert(tokentype == 'number', "expected array size")
					local count = assert(tonumber(token))
					assert(count > 0, "can we allow non-positive-sized arrays?")
					field.count = count
				
					str, token, tokentype = nexttoken(str)
					assert(token == ']')
					
					str, token, tokentype = nexttoken(str)
				end

				if token == ';' then
					break
				else
					assert(token == ',', "expected , or ;")
				end
			end
		end
	end
	ctype:calcSize()
	
	return str, ctype
end

-- assumes comments and \'s are removed
local function parse(str)
	local token, tokentype
	while true do
		str, token, tokentype = nexttoken(str)
		if not str then return end	-- done

		if token == 'typedef' then
			-- next is either a previously declared typename or 'struct'/'union' followed by a struct/union def
			str, token, tokentype = nexttoken(str)
			
			local srctype
			if tokentype == 'name' then
				srctype = getctype(token)
			-- alright I'm reaching the limit of non-state-based tokenizers ... 
			elseif token == 'struct'
			or token == 'union'
			then
				str, srctype = parsestruct(str, token == 'union')
			end

			str, token, tokentype = nexttoken(str)
			assert(tokentype == 'name')
			assert(not ffi.typedefs[token], 'typedef '..token..' is already used')
			ffi.typedefs[token] = srctype.name

			str, token, tokentype = nexttoken(str)
			
			-- TODO ... token could be [
			-- in which case we don't just have a typedef
			--  we have a new ctype of only an array

			assert(token == ';')
		elseif token == 'union'
		or token == 'struct'
		then
			local ctype
			str, ctype = parsestruct(str, token == 'union')
			str, token, tokentype = nexttoken(str)
			assert(token == ';')
		end
	end
end

function ffi.cdef(str)
	print("ffi.cdef("..tostring(str)..")")
	
	-- TODO ... hmm ... luajit's lj_cparse ...
	-- I can compile that to emscripten ... 
	-- hmm ...
	str = removeCommentsAndApplyContinuations(str)
	local ast = parse(str)
end

function ffi.sizeof(ctype)
	if type(ctype) == 'string' then
		-- TODO proper tokenizer for C types
		local typename = trim(ctype)
		local base, ar = typename:match'^(.+)%s*%[(%d+)%]$'
		if base then
			return tonumber(ar) * ffi.sizeof(base)
		end
		ctype = assert(getctype(typename), "couldn't find ctype "..typename)
	else
		assert(getmetatable(ctype) == ffi.ctype, "ffi.sizeof object is not a ctype")
	end
	return ctype.size
end

local ffiblob = setmetatable({}, {
	__call = function(mt, typename, count, gen)
		local o = setmetatable({}, mt)
		o.typename = assert(typename, "expected typename")
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
	typename = trim(typename)
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
