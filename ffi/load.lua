-- for now the emscripten build is baking all into one binary
-- maybe that'll change once dlopen/dlsym become more stable

local ffi = require 'ffi'

local ffi_load = setmetatable({}, {
	__call = function(self, reqname)
		return ffi.load'c'
	end,
})

return ffi_load
