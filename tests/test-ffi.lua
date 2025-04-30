local ffi = require 'ffi'
print('ffi', ffi)
print('ffi.C', ffi.C)
print('ffi.os', ffi.os)
print('ffi.arch', ffi.arch)

require 'ffi.req' 'c.stdlib'	-- malloc
print('ffi.C.malloc', ffi.C.malloc)
local ptr = ffi.C.malloc(10)
print('malloc:', ptr)

require 'ffi.req' 'c.sys.time'
local tv = ffi.new'struct timeval[1]'
print(ffi.C.gettimeofday)
ffi.C.gettimeofday(tv, nil)
print('gettimeofday:', tv[0].tv_sec, tv[0].tv_usec)
