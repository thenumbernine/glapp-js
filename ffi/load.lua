-- for now the emscripten build is baking all into one binary
-- maybe that'll change once dlopen/dlsym become more stable

local ffi = require 'ffi'

local ffi_load = setmetatable({}, {
	__call = function(self, reqname)
		-- dlopen(0) gives back the main module
		-- dlopen("c") gives back libc
		-- ... and I guess can I get other modules like sdl png etc? idk ...
		--ffi.load'c'	-- this gives libc
		return ffi.C	-- this gives the main module
	end,
})

return ffi_load
