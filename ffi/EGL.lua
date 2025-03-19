local ffi = require 'ffi'

ffi.cdef[[
enum{
	EGL_DEFAULT_DISPLAY = 0,
	EGL_CLIENT_APIS = 12429,
	EGL_VENDOR = 12371,
	EGL_VERSION = 12372,
	EGL_CLIENT_APIS = 12429,
	EGL_EXTENSIONS = 12373,
	EGL_BLUE_SIZE = 12322,
	EGL_GREEN_SIZE = 12323,
	EGL_RED_SIZE = 12324,
};

typedef intptr_t EGLDisplay;	-- void*
typedef intptr_t EGLConfig;	-- void*
typedef intptr_t EGLContext;	-- void*
typedef int EGLint;
]]

local egl = setmetatable({}, {
	__index = ffi.C,
})

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
