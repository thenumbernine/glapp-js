local ffi = require 'ffi'

ffi.cdef[[
struct timeval {
	long tv_sec;	//long int tv_sec;
	long tv_usec;	//long int tv_usec;
};
]]

-- with the wasm version, I can't just overwrite ffi.C ... I could metatable replace it ... that'd be slower ... or I could just compile my own stub C into the wasm ...
return {
-- tv : struct timeval[1]
--function ffi.C.gettimeofday(tv, tz)
	gettimeofday = function(tv, tz)
		--[[ Lua based
		tv.tv_sec = os.time()
		tv.tv_usec = 0
		--]]
		-- [[ js-based
		local now = js.dateNow()
		tv[0].tv_sec = now // 1000
		tv[0].tv_usec = 1000 * (now % 1000)
		--]]
		return 0
	end,
}
