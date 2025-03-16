local ffi = require 'ffi'

function ffi.C.malloc(size)
	return ffi.cast('void*', ffi.mallocAddr(size))
end

ffi.C.free = ffi.free
