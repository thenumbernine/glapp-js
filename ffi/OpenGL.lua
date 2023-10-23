local ffi = require 'ffi'

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
