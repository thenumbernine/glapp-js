-- needed by png
local ffi = require 'ffi'

ffi.cdef[[
struct FILE;
FILE *fopen (const char * __filename, const char * __modes);
int fclose (FILE *__stream);
size_t fread (void * __ptr, size_t __size, size_t __n, FILE * __stream);
]]

return setmetatable({}, {
	__index = ffi.C,
})
