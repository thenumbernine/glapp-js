-- needed by png
local ffi = require 'ffi'

-- I just copied this from some random posix ffi bindings in my lua-ffi-bindings project
-- TODO generate it from emscripten's musl-libc
ffi.cdef[[
typedef int64_t off_t; 	// what size should this be?
typedef int64_t fpos_t; 	// what size should this be?

struct FILE;
FILE *stdin;
FILE *stdout;
FILE *stderr;
int remove(const char *__filename);
int rename(const char *__old, const char *__new);
int renameat(int __oldfd, const char *__old, int __newfd, const char *__new);
int fclose(FILE *__stream);
FILE *tmpfile();
char *tmpnam(char[20]);
char *tmpnam_r(char __s[20]);
char *tempnam(const char *__dir, const char *__pfx);
int fflush(FILE *__stream);
int fflush_unlocked(FILE *__stream);
FILE *fopen(const char *__filename, const char *__modes);
FILE *freopen(const char *__filename, const char *__modes, FILE *__stream);
FILE *fdopen(int __fd, const char *__modes);
FILE *fmemopen(void *__s, size_t __len, const char *__modes);
FILE *open_memstream(char **__bufloc, size_t *__sizeloc);
void setbuf(FILE *__stream, char *__buf);
int setvbuf(FILE *__stream, char *__buf, int __modes, size_t __n);
void setbuffer(FILE *__stream, char *__buf, size_t __size);
void setlinebuf(FILE *__stream);
int fprintf(FILE *__stream, const char *__format, ...);
int printf(const char *__format, ...);
int sprintf(char *__s, const char *__format, ...);
int vfprintf(FILE *__s, const char *__format, ...);
int vprintf(const char *__format, ...);
int vsprintf(char *__s, const char *__format, ...);
int snprintf(char *__s, size_t __maxlen, const char *__format, ...);
int vsnprintf(char *__s, size_t __maxlen, const char *__format, ...);
int vasprintf(char **__ptr, const char *__f, ...);
int asprintf(char **__ptr, const char *__fmt, ...);
int vdprintf(int __fd, const char *__fmt, ...);
int dprintf(int __fd, const char *__fmt, ...);
int fscanf(FILE *__stream, const char *__format, ...);
int scanf(const char *__format, ...);
int sscanf(const char *__s, const char *__format, ...);
int fscanf(FILE *__stream, const char *__format, ...);
int scanf(const char *__format, ...);
int sscanf(const char *__s, const char *__format, ...);
int vfscanf(FILE *__s, const char *__format, ...);
int vscanf(const char *__format, ...);
int vsscanf(const char *__s, const char *__format, ...);
int vfscanf(FILE *__s, const char *__format, ...);
int vscanf(const char *__format, ...);
int vsscanf(const char *__s, const char *__format, ...);
int fgetc(FILE *__stream);
int getc(FILE *__stream);
int getchar();
int getc_unlocked(FILE *__stream);
int getchar_unlocked();
int fgetc_unlocked(FILE *__stream);
int fputc(int __c, FILE *__stream);
int putc(int __c, FILE *__stream);
int putchar(int __c);
int fputc_unlocked(int __c, FILE *__stream);
int putc_unlocked(int __c, FILE *__stream);
int putchar_unlocked(int __c);
int getw(FILE *__stream);
int putw(int __w, FILE *__stream);
char *fgets(char *__s, int __n, FILE *__stream);
ssize_t getdelim(char **__lineptr, size_t *__n, int __delimiter, FILE *__stream);
ssize_t getline(char **__lineptr, size_t *__n, FILE *__stream);
int fputs(const char *__s, FILE *__stream);
int puts(const char *__s);
int ungetc(int __c, FILE *__stream);
size_t fread(void *__ptr, size_t __size, size_t __n, FILE *__stream);
size_t fwrite(const void *__ptr, size_t __size, size_t __n, FILE *__s);
size_t fread_unlocked(void *__ptr, size_t __size, size_t __n, FILE *__stream);
size_t fwrite_unlocked(const void *__ptr, size_t __size, size_t __n, FILE *__stream);
int fseek(FILE *__stream, long int __off, int __whence);
long int ftell(FILE *__stream);
void rewind(FILE *__stream);
int fseeko(FILE *__stream, off_t __off, int __whence);
off_t ftello(FILE *__stream);
int fgetpos(FILE *__stream, fpos_t *__pos);
int fsetpos(FILE *__stream, const fpos_t *__pos);
void clearerr(FILE *__stream);
int feof(FILE *__stream);
int ferror(FILE *__stream);
void clearerr_unlocked(FILE *__stream);
int feof_unlocked(FILE *__stream);
int ferror_unlocked(FILE *__stream);
void perror(const char *__s);
int fileno(FILE *__stream);
int fileno_unlocked(FILE *__stream);
int pclose(FILE *__stream);
FILE *popen(const char *__command, const char *__modes);
char *ctermid(char *__s);
void flockfile(FILE *__stream);
int ftrylockfile(FILE *__stream);
void funlockfile(FILE *__stream);
]]

return setmetatable({}, {
__index = ffi.C, })
