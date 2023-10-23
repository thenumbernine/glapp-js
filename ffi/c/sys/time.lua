local ffi = require 'ffi'


ffi.ctype(
	'struct timeval'
)

-- tv : struct timeval[1]
function ffi.C.gettimeofday(tv)
end
