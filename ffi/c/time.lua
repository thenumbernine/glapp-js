local ffi = require 'ffi'

-- this needs to match whatever emscripten's libc uses
ffi.cdef[[
typedef unsigned long time_t;
]]
