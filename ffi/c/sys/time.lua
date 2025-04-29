local js = require 'js'
local ffi = require 'ffi'

ffi.cdef[[
struct timeval {
	long tv_sec;	//long int tv_sec;
	long tv_usec;	//long int tv_usec;
};

// always getting a weird memory error with this one ...
int gettimeofday(struct timeval * __tv, void * __tz);
]]
