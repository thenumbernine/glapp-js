local ffi = require 'ffi'

ffi.cdef[[
struct timeval {
	long tv_sec;	//long int tv_sec;
	long tv_usec;	//long int tv_usec;
};
]]

-- tv : struct timeval[1]
function ffi.C.gettimeofday(tv, tz)
	--[[ Lua based
	tv.tv_sec = os.time()
	tv.tv_usec = 0
	--]]
	-- [[ js-based
	local now = js.global.Date.now()
	tv.tv_sec = now // 1000 
	tv.tv_usec = 1000 * (now % 1000)
	--]]
end
