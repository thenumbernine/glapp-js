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

local function getJSGL()
	return assert(js.global.gl, "WebGL isn't initialized")
end

function gl.glGetString(name)
	-- TODO initialize upon any dereference?
	local jsgl = getJSGL()
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

local function setError(err)
	if glerror ~= 0 then return end
	if err == 0 then return end
	glerror = err
end

function gl.glViewport(...)
	return js.global.gl:viewport(...)
end

local ResMap = class()

function ResMap:init(name)
	self.name = name
end

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

function ResMap:get(id)
	id = tonumber(id)
	local obj = self[id]
	if not obj then 
print(self.name, 'failed to find id', id)
		setError(gl.GL_INVALID_OPERATION) 
	end
	return obj
end

function ResMap:makeCreate(webglfuncname)
	return function(...)
		local jsgl = getJSGL()
		local id = self:getNextID()
print(self.name, 'making new at id', id)
		self[id] = {
			obj = jsgl[webglfuncname](jsgl, ...)
		}
		setError(jsgl:getError())
		return ffi.cast('GLuint', id)
	end
end

local programs = ResMap'programs'
gl.glCreateProgram = programs:makeCreate'createProgram'

-- make sure these match with webgl
gl.GL_FRAGMENT_SHADER = 35632
gl.GL_VERTEX_SHADER = 35633

local shaders = ResMap'shaders'
gl.glCreateShader = shaders:makeCreate'createShader'

function gl.glShaderSource(id, numStrs, strs, lens)
	local shader = shaders:get(id)
	if not shader then return end

	local s = table()
	for i=0,numStrs-1 do
		table.insert(s, ffi.string(strs[i], lens[i]))
	end
	local source = s:concat()

	local jsgl = getJSGL()
	jsgl:shaderSource(shader.obj, source)
	setError(jsgl:getError())
end

function gl.glCompileShader(id)
	local shader = shaders:get(id)
	if not shader then return end
	
	local jsgl = getJSGL()
	jsgl:compileShader(shader.obj)
	setError(jsgl:getError())
end

return gl
