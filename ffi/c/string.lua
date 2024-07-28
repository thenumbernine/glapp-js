local ffi = require 'ffi'

function ffi.C.strerror(errno)
	return 'error '..tostring(errno)
end

function ffi.C.strlen(p)
	return ffi.strlenAddr(ffi.getAddr(p))
end
