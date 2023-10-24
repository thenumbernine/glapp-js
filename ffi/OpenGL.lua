local ffi = require 'ffi'

ffi.cdef[[
typedef unsigned int GLenum;
typedef unsigned char GLboolean;
typedef unsigned int GLbitfield;
typedef void GLvoid;
typedef signed char GLbyte;
typedef short GLshort;
typedef int GLint;
typedef unsigned char GLubyte;
typedef unsigned short GLushort;
typedef unsigned int GLuint;
typedef int GLsizei;
typedef float GLfloat;
typedef float GLclampf;
typedef double GLdouble;
typedef double GLclampd;
]]

local gl = {}

gl.GL_VENDOR = 7936
gl.GL_RENDERER = 7937 
gl.GL_VERSION = 7938 
gl.GL_EXTENSIONS = 7939 

function gl.glGetString(name)
	if name == gl.GL_VENDOR then
		return ffi.stringBuffer'WebGL'
	elseif name == gl.GL_RENDERER then
		return ffi.stringBuffer'WebGL'
	elseif name == gl.GL_VERSION then
		return ffi.stringBuffer'WebGL'
	elseif name == gl.GL_EXTENSIONS then
	else
		return ffi.stringBuffer''
	end
	-- error? return null?
	return ffi.stringBuffer''
end

function gl.glViewport(...)
	return js.global.gl:viewport(...)
end

return gl
