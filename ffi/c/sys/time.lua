local ffi = require 'ffi'
ffi.cdef[[
struct timeval {
	long tv_sec;	//long int tv_sec;
	long tv_usec;	//long int tv_usec;
};

int gettimeofday(struct timeval * __tv, void * __tz);
]]
