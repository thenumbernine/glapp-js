local ffi = require 'ffi'

ffi.cdef[[
size_t strlen (const char *__s);
char *strerror (int __errnum);
]]
