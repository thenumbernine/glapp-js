local ffi = require 'ffi'

ffi.typedefs['EGLDisplay'] = 'intptr_t'	-- void*
ffi.typedefs['EGLConfig'] = 'intptr_t'	-- void*
ffi.typedefs['EGLContext'] = 'intptr_t'	-- void*
ffi.typedefs['EGLint'] = 'int'

local egl = {}

egl.EGL_DEFAULT_DISPLAY = 0
egl.EGL_CLIENT_APIS = 12429
egl.EGL_VENDOR = 12371
egl.EGL_VERSION = 12372
egl.EGL_CLIENT_APIS = 12429
egl.EGL_EXTENSIONS = 12373

ffi.cdef_enum(
	{
		{EGL_BLUE_SIZE = 12322},
		{EGL_GREEN_SIZE = 12323},
		{EGL_RED_SIZE = 12324},
	},
	sdl
)

function egl.eglGetDisplay()
	return ffi.new('EGLDisplay')
end

function egl.eglInitialize()
	return 1
end

function egl.eglChooseConfig()
	return 1
end

function egl.eglCreateContext()
end

function egl.eglQueryString(dpy, name)
	if name == egl.EGL_CLIENT_APIS then
		return ffi.stringBuffer'WebGL'
	elseif name == egl.EGL_VENDOR then
		return ffi.stringBuffer'WebGL'
	elseif name == egl.EGL_CLIENT_APIS then
		return ffi.stringBuffer'WebGL'
	elseif name == egl.EGL_EXTENSIONS then
		return ffi.stringBuffer''
	else
		return ffi.null
	end
end

return egl
