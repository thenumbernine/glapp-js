local ffi = require 'ffi'

ffi.cdef[[
struct timeval {
	long int tv_sec;
	long int tv_usec;
};
]]

-- tv : struct timeval[1]
function ffi.C.gettimeofday(tv, tz)
	tv.tv_sec = os.time()	-- long int
	tv.tv_usec = 0			-- long int
end
