local ffi = require 'ffi'
local table = require 'ext.table'

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
gl.GL_SHADING_LANGUAGE_VERSION = 35724

function gl.glGetString(name)
	-- TODO initialize upon any dereference?
	local jsgl = assert(js.global.gl, "WebGL isn't initialized")
	if name == gl.GL_VENDOR then
		return ffi.stringBuffer(jsgl:getParameter(jsgl.VENDOR))
	elseif name == gl.GL_RENDERER then
		return ffi.stringBuffer(jsgl:getParameter(jsgl.RENDERER))
	elseif name == gl.GL_VERSION then
		return ffi.stringBuffer(jsgl:getParameter(jsgl.VERSION))
	elseif name == gl.GL_SHADING_LANGUAGE_VERSION then
		return ffi.stringBuffer(jsgl:getParameter(jsgl.SHADING_LANGUAGE_VERSION))
	elseif name == gl.GL_EXTENSIONS then
		local s = {}
		local ext = jsgl:getSupportedExtensions()	-- js array
		for i=0,ext.length-1 do
			table.insert(s, ext[i])
		end
		return ffi.stringBuffer(table.concat(s, ' '))
	else
		return ffi.stringBuffer''
	end
	-- error? return null?
	return ffi.stringBuffer''
end

function gl.glViewport(...)
	return js.global.gl:viewport(...)
end

local programs = table()
local function getNextProgramID()
	local maxn = programs:maxn()
	for i=1,maxn do
		if not programs[i] then
			return i
		end
	end
	maxn = maxn + 1
	return maxn
end

function gl.glCreateProgram()
	local id = getNextProgramID()
	programs[id] = {}
	return ffi.cast('GLuint', id)
end

return gl
