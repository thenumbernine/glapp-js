local ffi = require 'ffi'
local __errno_location = 0
return setmetatable({
	errno = function()
		return __errno_location
	end,
}, {
	__index = ffi.C,
})
