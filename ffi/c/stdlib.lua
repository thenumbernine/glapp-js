local ffi = require 'ffi'

--[[
-- TODO for some reason this won't work with the luaffifb -> dlsym -> emscripten, neither malloc nor _malloc
-- so for now I'm just overriding the one package that i used it, in ext.gcmem
-- but it'd be nice to get dlsym working with malloc & free
-- I might have to write vanilla lua function wrappers push & pop state ...
ffi.cdef[[
void * malloc(int n);
void free(void *);
]]
--]]
return {
	malloc = function(n)
		return ffi.cast('void*', ffi.new('uint8_t[?]', 
			-- disheartening that ffi.new needs tonumber
			-- TODO FIXME in luaffifb
			tonumber(n)
		))
	end,
	free = function(ptr)
	end,
}
