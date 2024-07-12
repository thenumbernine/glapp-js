local ffi = require 'ffi'
local table = require 'ext.table'
local class = require 'ext.class'

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

gl.GL_NO_ERROR = 0
gl.GL_INVALID_ENUM = 1280
gl.GL_INVALID_VALUE = 1281
gl.GL_INVALID_OPERATION = 1282
gl.GL_STACK_OVERFLOW = 1283
gl.GL_STACK_UNDERFLOW = 1284
gl.GL_OUT_OF_MEMORY = 1285

local glerror = gl.GL_NO_ERROR

function gl.glGetError()
	return glerror
end

function gl.glViewport(...)
	return js.global.gl:viewport(...)
end

local ResMap = class()

ResMap.maxn = table.maxn

function ResMap:getNextID()
	local maxn = self:maxn()
	for i=1,maxn do
		if not self[i] then
			return i
		end
	end
	maxn = maxn + 1
	return maxn
end

function ResMap:makeCreate()
	return function()
		local id = self:getNextID()
		self[id] = {}
		return ffi.cast('GLuint', id)
	end
end

local programs = ResMap()
gl.glCreateProgram = programs:makeCreate()

local shaders = ResMap()
gl.glCreateShader = shaders:makeCreate()

return gl
