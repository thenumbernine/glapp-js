local ffi = require 'ffi'

function ffi.C.strerror(errno)
	return 'error '..tostring(errno)
end
