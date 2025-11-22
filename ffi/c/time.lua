local ffi = require 'ffi'

-- this needs to match whatever emscripten's libc uses
ffi.cdef[[
typedef unsigned long time_t;
]]

-- I define one in file scope of ext.timer
ffi.cdef[[
struct tm {
	int tm_sec;
	int tm_min;
	int tm_hour;
	int tm_mday;
	int tm_mon;
	int tm_year;
	int tm_wday;
	int tm_yday;
	int tm_isdst;
	long int tm_gmtoff;
	const char *tm_zone;
};
]]
