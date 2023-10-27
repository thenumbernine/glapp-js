local ffi = require 'ffi'

ffi.cdef[[
typedef struct SDL_Event { int unknown; } SDL_Event;
typedef struct SDL_GLContext { int unknown; } SDL_GLContext;
typedef struct SDL_Window { int unknown; } SDL_Window;

typedef struct SDL_version {
   uint8_t major;
   uint8_t minor;
   uint8_t patch;
} SDL_version;
]]


local sdl = {}

-- TODO would be nice to treat these as constants / define's ...

ffi.cdef_enum(
	{
		{SDL_WINDOW_FULLSCREEN    = 0x00000001},
		{SDL_WINDOW_OPENGL        = 0x00000002},
		{SDL_WINDOW_SHOWN         = 0x00000004},
		{SDL_WINDOW_HIDDEN        = 0x00000008},
		{SDL_WINDOW_BORDERLESS    = 0x00000010},
		{SDL_WINDOW_RESIZABLE     = 0x00000020},
		{SDL_WINDOW_MINIMIZED     = 0x00000040},
		{SDL_WINDOW_MAXIMIZED     = 0x00000080},
		{SDL_WINDOW_INPUT_GRABBED = 0x00000100},
		{SDL_WINDOW_INPUT_FOCUS   = 0x00000200},
		{SDL_WINDOW_MOUSE_FOCUS   = 0x00000400},
		{SDL_WINDOW_FOREIGN       = 0x00000800},
	},
	sdl
)

ffi.cdef_enum(
	{
		'SDL_GL_RED_SIZE',
		'SDL_GL_GREEN_SIZE',
		'SDL_GL_BLUE_SIZE',
		'SDL_GL_ALPHA_SIZE',
		'SDL_GL_BUFFER_SIZE',
		'SDL_GL_DOUBLEBUFFER',
		'SDL_GL_DEPTH_SIZE',
		'SDL_GL_STENCIL_SIZE',
		'SDL_GL_ACCUM_RED_SIZE',
		'SDL_GL_ACCUM_GREEN_SIZE',
		'SDL_GL_ACCUM_BLUE_SIZE',
		'SDL_GL_ACCUM_ALPHA_SIZE',
		'SDL_GL_STEREO',
		'SDL_GL_MULTISAMPLEBUFFERS',
		'SDL_GL_MULTISAMPLESAMPLES',
		'SDL_GL_ACCELERATED_VISUAL',
		'SDL_GL_RETAINED_BACKING',
		'SDL_GL_CONTEXT_MAJOR_VERSION',
		'SDL_GL_CONTEXT_MINOR_VERSION',
	},
	sdl
)

-- store these in ffi.C as well?
-- how does luajit ffi.load know when to put symbols in ffi.C vs in the table returned?
-- or is the table returned always ffi.C?

function sdl.SDL_Init() return 0 end
function sdl.SDL_Quit() return 0 end

function sdl.SDL_GetError() end	-- TODO return a ffiblob / ptr of a string of the error

local canvas

function sdl.SDL_CreateWindow(title, x, y, w, h, flags)
print('SDL_CreateWindow', title, x, y, w, h, flags)	
	local window = js.global.window

	window:scrollTo(0,1)
	if not canvas then
		canvas = js.global.document:createElement'canvas'
		window.canvas = canvas
		js.global.document.body:prepend(canvas)
	end

	canvas.style.left = 0
	canvas.style.top = 0
	canvas.style.position = 'absolute'
	
	local resize = function(e)
		canvas.width = window.innerWidth
		canvas.height = window.innerHeight
		
		-- TODO new SDL event ...
	end
	window:addEventListener('resize', resize)
	--also call resize after init is done
	window:setTimeout(resize, 0)

	return ffi.new'SDL_Window'
end
function sdl.SDL_DestroyWindow(window) return 0 end
function sdl.SDL_SetWindowSize(window, width, height)
end

-- oof, this returns on-stack a SDL_GLContext ... how to handle that ...
function sdl.SDL_GL_CreateContext(window)
	local gl
	local contextName
	local webGLNames = {
		'webgl2',
		'webgl',
		'experimental-webgl',
	}
	for i,name in ipairs(webGLNames) do
		xpcall(function()
			--console.log('trying to init gl context of type', this.webGLNames[i]);
			gl = canvas:getContext(name)
			contextName = name
		end, function(err)
			--console.log('failed with exception', e);
		end)
		if gl then break end
	end
	if not gl then
		error "Couldn't initialize WebGL =("
	end
	-- TODO need a better way to talk to ffi.OpenGL ...
	js.global.window.gl = gl

	return ffi.new'SDL_GLContext'
end

function sdl.SDL_GL_DeleteContext(ctx) return 0 end
function sdl.SDL_GL_SetAttribute(key, value) return 0 end
function sdl.SDL_GL_SetSwapInterval(enable) return 0 end

function sdl.SDL_GetVersion(version)
	version[0].major = 2
	version[0].minor = 0
	version[0].patch = 0
end

return sdl
