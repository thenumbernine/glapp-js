local ffi = require 'ffi'

ffi.cdef[[
void * malloc(int n);
void free(void *);
]]
