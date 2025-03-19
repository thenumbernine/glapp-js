local ffi = require 'ffi'

return {
	strerror = function(errno)
		return 'error '..tostring(errno)
	end,

	strlen = function(p)
		return ffi.strlenAddr(ffi.getAddr(p))
	end,
}
