local ffi = require 'ffi'

ffi.cdef[[

// fengari-specific:
struct SDL_Window {};
struct SDL_Thread {};
struct SDL_Renderer {};
struct SDL_Texture {};
struct SDL_iconv_t {};
struct SDL_SysWMmsg {};
struct SDL_Cursor {};
struct SDL_Joystick {};

	enum { SDL_INIT_VIDEO = 0x20 };
	enum { SDL_INIT_JOYSTICK = 0x00000200 };
	enum { SDL_DISABLE = 0 };
	enum { SDL_ENABLE = 1 };
	enum { SDL_WINDOWPOS_CENTERED = 0x2fff0000 };

typedef enum
{
    SDL_FALSE = 0,
    SDL_TRUE = 1
} SDL_bool;

/**
 * \brief A signed 8-bit integer type.
 */
typedef int8_t Sint8;
/**
 * \brief An unsigned 8-bit integer type.
 */
typedef uint8_t Uint8;
/**
 * \brief A signed 16-bit integer type.
 */
typedef int16_t Sint16;
/**
 * \brief An unsigned 16-bit integer type.
 */
typedef uint16_t Uint16;
/**
 * \brief A signed 32-bit integer type.
 */
typedef int32_t Sint32;
/**
 * \brief An unsigned 32-bit integer type.
 */
typedef uint32_t Uint32;

/**
 * \brief A signed 64-bit integer type.
 */
typedef int64_t Sint64;
/**
 * \brief An unsigned 64-bit integer type.
 */
typedef uint64_t Uint64;

typedef Sint32 SDL_JoystickID;

	enum {
		SDL_BUTTON_LEFT		= 1,
		SDL_BUTTON_MIDDLE	= 2,
		SDL_BUTTON_RIGHT	= 3,
		SDL_BUTTON_X1		= 6,
		SDL_BUTTON_X2		= 7,
		SDL_HAT_CENTERED    = 0x00,
		SDL_HAT_UP      	= 0x01,
		SDL_HAT_RIGHT       = 0x02,
		SDL_HAT_DOWN        = 0x04,
		SDL_HAT_LEFT        = 0x08,
		SDL_HAT_RIGHTUP     = 0x03,
		SDL_HAT_RIGHTDOWN   = 0x06,
		SDL_HAT_LEFTUP      = 0x09,
		SDL_HAT_LEFTDOWN    = 0x0c,
	};

	extern  uint8_t              SDL_numjoysticks;

	typedef unsigned long        SDL_threadID;
	typedef uint16_t             SDL_AudioFormat;
	typedef uint32_t             SDL_AudioDeviceID;
	typedef int64_t              SDL_GestureID;
	typedef int64_t              SDL_TouchID;
	typedef int64_t              SDL_FingerID;
	typedef int32_t              SDL_Keycode;
	typedef int                  SDL_TimerID;
	typedef void*                SDL_GLContext;

	typedef struct SDL_Window    SDL_Window;
	typedef        SDL_Window*   SDL_WindowID;
	typedef struct SDL_Thread    SDL_Thread;
	typedef struct SDL_Renderer  SDL_Renderer;
	typedef struct SDL_Texture   SDL_Texture;
	typedef struct SDL_iconv_t*  SDL_iconv_t;
	typedef struct SDL_SysWMmsg  SDL_SysWMmsg;
	typedef struct SDL_Cursor    SDL_Cursor;
	typedef struct SDL_Joystick  SDL_Joystick;
]]

--[[
	typedef void              (* SDL_AudioCallback)(    void *userdata, uint8_t* stream, int len );
	typedef uint32_t          (* SDL_OldTimerCallback)( uint32_t interval );
	typedef uint32_t          (* SDL_TimerCallback)(    uint32_t interval, void *param );
--]]
ffi.cdef[[
typedef void* SDL_AudioCallback;
typedef void* SDL_OldTimerCallback;
typedef void* SDL_TimerCallback;
]]

ffi.cdef[[
	enum {
	   SDL_SWSURFACE               = 0x00000000,
	   SDL_SRCALPHA                = 0x00010000,
	   SDL_SRCCOLORKEY             = 0x00020000,
	   SDL_ANYFORMAT               = 0x00100000,
	   SDL_HWPALETTE               = 0x00200000,
	   SDL_DOUBLEBUF               = 0x00400000,
	   SDL_FULLSCREEN              = 0x00800000,
	   SDL_RESIZABLE               = 0x01000000,
	   SDL_NOFRAME                 = 0x02000000,
	   SDL_OPENGL                  = 0x04000000,
	   SDL_HWSURFACE               = 0x08000001,
	   SDL_ASYNCBLIT               = 0x08000000,
	   SDL_RLEACCELOK              = 0x08000000,
	   SDL_HWACCEL                 = 0x08000000,
	   SDL_APPMOUSEFOCUS           = 0x01,
	   SDL_APPINPUTFOCUS           = 0x02,
	   SDL_APPACTIVE               = 0x04,
	   SDL_LOGPAL                  = 0x01,
	   SDL_PHYSPAL                 = 0x02,
	   SDL_BUTTON_WHEELUP          = 4,
	   SDL_BUTTON_WHEELDOWN        = 5,
	   SDL_DEFAULT_REPEAT_DELAY    = 500,
	   SDL_DEFAULT_REPEAT_INTERVAL = 30,
	};

	typedef enum SDL_WindowFlags {
	   SDL_WINDOW_FULLSCREEN    = 0x00000001,
	   SDL_WINDOW_OPENGL        = 0x00000002,
	   SDL_WINDOW_SHOWN         = 0x00000004,
	   SDL_WINDOW_HIDDEN        = 0x00000008,
	   SDL_WINDOW_BORDERLESS    = 0x00000010,
	   SDL_WINDOW_RESIZABLE     = 0x00000020,
	   SDL_WINDOW_MINIMIZED     = 0x00000040,
	   SDL_WINDOW_MAXIMIZED     = 0x00000080,
	   SDL_WINDOW_INPUT_GRABBED = 0x00000100,
	   SDL_WINDOW_INPUT_FOCUS   = 0x00000200,
	   SDL_WINDOW_MOUSE_FOCUS   = 0x00000400,
	   SDL_WINDOW_FOREIGN       = 0x00000800
	} SDL_WindowFlags;

	typedef enum SDL_WindowEventID {
	   SDL_WINDOWEVENT_NONE,
	   SDL_WINDOWEVENT_SHOWN,
	   SDL_WINDOWEVENT_HIDDEN,
	   SDL_WINDOWEVENT_EXPOSED,
	   SDL_WINDOWEVENT_MOVED,
	   SDL_WINDOWEVENT_RESIZED,
	   SDL_WINDOWEVENT_SIZE_CHANGED,
	   SDL_WINDOWEVENT_MINIMIZED,
	   SDL_WINDOWEVENT_MAXIMIZED,
	   SDL_WINDOWEVENT_RESTORED,
	   SDL_WINDOWEVENT_ENTER,
	   SDL_WINDOWEVENT_LEAVE,
	   SDL_WINDOWEVENT_FOCUS_GAINED,
	   SDL_WINDOWEVENT_FOCUS_LOST,
	   SDL_WINDOWEVENT_CLOSE
	} SDL_WindowEventID;

	typedef enum SDL_assert_state {
	   SDL_ASSERTION_RETRY,
	   SDL_ASSERTION_BREAK,
	   SDL_ASSERTION_ABORT,
	   SDL_ASSERTION_IGNORE,
	   SDL_ASSERTION_ALWAYS_IGNORE,
	} SDL_assert_state;

	typedef enum SDL_ThreadPriority {
	   SDL_THREAD_PRIORITY_LOW,
	   SDL_THREAD_PRIORITY_NORMAL,
	   SDL_THREAD_PRIORITY_HIGH
	} SDL_ThreadPriority;

	typedef enum SDL_AudioStatus {
	   SDL_AUDIO_STOPPED = 0,
	   SDL_AUDIO_PLAYING,
	   SDL_AUDIO_PAUSED
	} SDL_AudioStatus;

	enum {
	   SDL_PIXELTYPE_UNKNOWN,
	   SDL_PIXELTYPE_INDEX1,
	   SDL_PIXELTYPE_INDEX4,
	   SDL_PIXELTYPE_INDEX8,
	   SDL_PIXELTYPE_PACKED8,
	   SDL_PIXELTYPE_PACKED16,
	   SDL_PIXELTYPE_PACKED32,
	   SDL_PIXELTYPE_ARRAYU8,
	   SDL_PIXELTYPE_ARRAYU16,
	   SDL_PIXELTYPE_ARRAYU32,
	   SDL_PIXELTYPE_ARRAYF16,
	   SDL_PIXELTYPE_ARRAYF32
	};

	enum {
	   SDL_BITMAPORDER_NONE,
	   SDL_BITMAPORDER_4321,
	   SDL_BITMAPORDER_1234
	};

	enum {
	   SDL_PACKEDORDER_NONE,
	   SDL_PACKEDORDER_XRGB,
	   SDL_PACKEDORDER_RGBX,
	   SDL_PACKEDORDER_ARGB,
	   SDL_PACKEDORDER_RGBA,
	   SDL_PACKEDORDER_XBGR,
	   SDL_PACKEDORDER_BGRX,
	   SDL_PACKEDORDER_ABGR,
	   SDL_PACKEDORDER_BGRA
	};

	enum {
	   SDL_ARRAYORDER_NONE,
	   SDL_ARRAYORDER_RGB,
	   SDL_ARRAYORDER_RGBA,
	   SDL_ARRAYORDER_ARGB,
	   SDL_ARRAYORDER_BGR,
	   SDL_ARRAYORDER_BGRA,
	   SDL_ARRAYORDER_ABGR
	};

	enum {
	   SDL_PACKEDLAYOUT_NONE,
	   SDL_PACKEDLAYOUT_332,
	   SDL_PACKEDLAYOUT_4444,
	   SDL_PACKEDLAYOUT_1555,
	   SDL_PACKEDLAYOUT_5551,
	   SDL_PACKEDLAYOUT_565,
	   SDL_PACKEDLAYOUT_8888,
	   SDL_PACKEDLAYOUT_2101010,
	   SDL_PACKEDLAYOUT_1010102
	};

	enum {
		SDL_PIXELFORMAT_UNKNOWN = 0x0,
		SDL_PIXELFORMAT_INDEX1LSB = 0x81100100,
		SDL_PIXELFORMAT_INDEX1MSB = 0x81200100,
		SDL_PIXELFORMAT_INDEX4LSB = 0x82100400,
		SDL_PIXELFORMAT_INDEX4MSB = 0x82200400,
		SDL_PIXELFORMAT_INDEX8 = 0x83000801,
		SDL_PIXELFORMAT_RGB332 = 0x84110801,
		SDL_PIXELFORMAT_RGB444 = 0x85120c02,
		SDL_PIXELFORMAT_RGB555 = 0x85130f02,
		SDL_PIXELFORMAT_BGR555 = 0x85530f02,
		SDL_PIXELFORMAT_ARGB4444 = 0x85321002,
		SDL_PIXELFORMAT_RGBA4444 = 0x85421002,
		SDL_PIXELFORMAT_ABGR4444 = 0x85721002,
		SDL_PIXELFORMAT_BGRA4444 = 0x85821002,
		SDL_PIXELFORMAT_ARGB1555 = 0x85331002,
		SDL_PIXELFORMAT_RGBA5551 = 0x85441002,
		SDL_PIXELFORMAT_ABGR1555 = 0x85731002,
		SDL_PIXELFORMAT_BGRA5551 = 0x85841002,
		SDL_PIXELFORMAT_RGB565 = 0x85151002,
		SDL_PIXELFORMAT_BGR565 = 0x85551002,
		SDL_PIXELFORMAT_RGB24 = 0x87101803,
		SDL_PIXELFORMAT_BGR24 = 0x87401803,
		SDL_PIXELFORMAT_RGB888 = 0x86161804,
		SDL_PIXELFORMAT_BGR888 = 0x86561804,
		SDL_PIXELFORMAT_ARGB8888 = 0x86362004,
		SDL_PIXELFORMAT_RGBA8888 = 0x86462004,
		SDL_PIXELFORMAT_ABGR8888 = 0x86762004,
		SDL_PIXELFORMAT_BGRA8888 = 0x86862004,
		SDL_PIXELFORMAT_ARGB2101010 = 0x86372004,
		SDL_PIXELFORMAT_YV12 = 0x32315659,
		SDL_PIXELFORMAT_IYUV = 0x56555949,
		SDL_PIXELFORMAT_YUY2 = 0x32595559,
		SDL_PIXELFORMAT_UYVY = 0x59565955,
		SDL_PIXELFORMAT_YVYU = 0x55595659,
	};

	typedef enum SDL_scancode {
	   SDL_SCANCODE_UNKNOWN = 0,
	   SDL_SCANCODE_A = 4,
	   SDL_SCANCODE_B = 5,
	   SDL_SCANCODE_C = 6,
	   SDL_SCANCODE_D = 7,
	   SDL_SCANCODE_E = 8,
	   SDL_SCANCODE_F = 9,
	   SDL_SCANCODE_G = 10,
	   SDL_SCANCODE_H = 11,
	   SDL_SCANCODE_I = 12,
	   SDL_SCANCODE_J = 13,
	   SDL_SCANCODE_K = 14,
	   SDL_SCANCODE_L = 15,
	   SDL_SCANCODE_M = 16,
	   SDL_SCANCODE_N = 17,
	   SDL_SCANCODE_O = 18,
	   SDL_SCANCODE_P = 19,
	   SDL_SCANCODE_Q = 20,
	   SDL_SCANCODE_R = 21,
	   SDL_SCANCODE_S = 22,
	   SDL_SCANCODE_T = 23,
	   SDL_SCANCODE_U = 24,
	   SDL_SCANCODE_V = 25,
	   SDL_SCANCODE_W = 26,
	   SDL_SCANCODE_X = 27,
	   SDL_SCANCODE_Y = 28,
	   SDL_SCANCODE_Z = 29,
	   SDL_SCANCODE_1 = 30,
	   SDL_SCANCODE_2 = 31,
	   SDL_SCANCODE_3 = 32,
	   SDL_SCANCODE_4 = 33,
	   SDL_SCANCODE_5 = 34,
	   SDL_SCANCODE_6 = 35,
	   SDL_SCANCODE_7 = 36,
	   SDL_SCANCODE_8 = 37,
	   SDL_SCANCODE_9 = 38,
	   SDL_SCANCODE_0 = 39,
	   SDL_SCANCODE_RETURN = 40,
	   SDL_SCANCODE_ESCAPE = 41,
	   SDL_SCANCODE_BACKSPACE = 42,
	   SDL_SCANCODE_TAB = 43,
	   SDL_SCANCODE_SPACE = 44,
	   SDL_SCANCODE_MINUS = 45,
	   SDL_SCANCODE_EQUALS = 46,
	   SDL_SCANCODE_LEFTBRACKET = 47,
	   SDL_SCANCODE_RIGHTBRACKET = 48,
	   SDL_SCANCODE_BACKSLASH = 49,
	   SDL_SCANCODE_NONUSHASH = 50,
	   SDL_SCANCODE_SEMICOLON = 51,
	   SDL_SCANCODE_APOSTROPHE = 52,
	   SDL_SCANCODE_GRAVE = 53,
	   SDL_SCANCODE_COMMA = 54,
	   SDL_SCANCODE_PERIOD = 55,
	   SDL_SCANCODE_SLASH = 56,
	   SDL_SCANCODE_CAPSLOCK = 57,
	   SDL_SCANCODE_F1 = 58,
	   SDL_SCANCODE_F2 = 59,
	   SDL_SCANCODE_F3 = 60,
	   SDL_SCANCODE_F4 = 61,
	   SDL_SCANCODE_F5 = 62,
	   SDL_SCANCODE_F6 = 63,
	   SDL_SCANCODE_F7 = 64,
	   SDL_SCANCODE_F8 = 65,
	   SDL_SCANCODE_F9 = 66,
	   SDL_SCANCODE_F10 = 67,
	   SDL_SCANCODE_F11 = 68,
	   SDL_SCANCODE_F12 = 69,
	   SDL_SCANCODE_PRINTSCREEN = 70,
	   SDL_SCANCODE_SCROLLLOCK = 71,
	   SDL_SCANCODE_PAUSE = 72,
	   SDL_SCANCODE_INSERT = 73,
	   SDL_SCANCODE_HOME = 74,
	   SDL_SCANCODE_PAGEUP = 75,
	   SDL_SCANCODE_DELETE = 76,
	   SDL_SCANCODE_END = 77,
	   SDL_SCANCODE_PAGEDOWN = 78,
	   SDL_SCANCODE_RIGHT = 79,
	   SDL_SCANCODE_LEFT = 80,
	   SDL_SCANCODE_DOWN = 81,
	   SDL_SCANCODE_UP = 82,
	   SDL_SCANCODE_NUMLOCKCLEAR = 83,
	   SDL_SCANCODE_KP_DIVIDE = 84,
	   SDL_SCANCODE_KP_MULTIPLY = 85,
	   SDL_SCANCODE_KP_MINUS = 86,
	   SDL_SCANCODE_KP_PLUS = 87,
	   SDL_SCANCODE_KP_ENTER = 88,
	   SDL_SCANCODE_KP_1 = 89,
	   SDL_SCANCODE_KP_2 = 90,
	   SDL_SCANCODE_KP_3 = 91,
	   SDL_SCANCODE_KP_4 = 92,
	   SDL_SCANCODE_KP_5 = 93,
	   SDL_SCANCODE_KP_6 = 94,
	   SDL_SCANCODE_KP_7 = 95,
	   SDL_SCANCODE_KP_8 = 96,
	   SDL_SCANCODE_KP_9 = 97,
	   SDL_SCANCODE_KP_0 = 98,
	   SDL_SCANCODE_KP_PERIOD = 99,
	   SDL_SCANCODE_NONUSBACKSLASH = 100,
	   SDL_SCANCODE_APPLICATION = 101,
	   SDL_SCANCODE_POWER = 102,
	   SDL_SCANCODE_KP_EQUALS = 103,
	   SDL_SCANCODE_F13 = 104,
	   SDL_SCANCODE_F14 = 105,
	   SDL_SCANCODE_F15 = 106,
	   SDL_SCANCODE_F16 = 107,
	   SDL_SCANCODE_F17 = 108,
	   SDL_SCANCODE_F18 = 109,
	   SDL_SCANCODE_F19 = 110,
	   SDL_SCANCODE_F20 = 111,
	   SDL_SCANCODE_F21 = 112,
	   SDL_SCANCODE_F22 = 113,
	   SDL_SCANCODE_F23 = 114,
	   SDL_SCANCODE_F24 = 115,
	   SDL_SCANCODE_EXECUTE = 116,
	   SDL_SCANCODE_HELP = 117,
	   SDL_SCANCODE_MENU = 118,
	   SDL_SCANCODE_SELECT = 119,
	   SDL_SCANCODE_STOP = 120,
	   SDL_SCANCODE_AGAIN = 121,
	   SDL_SCANCODE_UNDO = 122,
	   SDL_SCANCODE_CUT = 123,
	   SDL_SCANCODE_COPY = 124,
	   SDL_SCANCODE_PASTE = 125,
	   SDL_SCANCODE_FIND = 126,
	   SDL_SCANCODE_MUTE = 127,
	   SDL_SCANCODE_VOLUMEUP = 128,
	   SDL_SCANCODE_VOLUMEDOWN = 129,
	   SDL_SCANCODE_KP_COMMA = 133,
	   SDL_SCANCODE_KP_EQUALSAS400 = 134,
	   SDL_SCANCODE_INTERNATIONAL1 = 135,
	   SDL_SCANCODE_INTERNATIONAL2 = 136,
	   SDL_SCANCODE_INTERNATIONAL3 = 137,
	   SDL_SCANCODE_INTERNATIONAL4 = 138,
	   SDL_SCANCODE_INTERNATIONAL5 = 139,
	   SDL_SCANCODE_INTERNATIONAL6 = 140,
	   SDL_SCANCODE_INTERNATIONAL7 = 141,
	   SDL_SCANCODE_INTERNATIONAL8 = 142,
	   SDL_SCANCODE_INTERNATIONAL9 = 143,
	   SDL_SCANCODE_LANG1 = 144,
	   SDL_SCANCODE_LANG2 = 145,
	   SDL_SCANCODE_LANG3 = 146,
	   SDL_SCANCODE_LANG4 = 147,
	   SDL_SCANCODE_LANG5 = 148,
	   SDL_SCANCODE_LANG6 = 149,
	   SDL_SCANCODE_LANG7 = 150,
	   SDL_SCANCODE_LANG8 = 151,
	   SDL_SCANCODE_LANG9 = 152,
	   SDL_SCANCODE_ALTERASE = 153,
	   SDL_SCANCODE_SYSREQ = 154,
	   SDL_SCANCODE_CANCEL = 155,
	   SDL_SCANCODE_CLEAR = 156,
	   SDL_SCANCODE_PRIOR = 157,
	   SDL_SCANCODE_RETURN2 = 158,
	   SDL_SCANCODE_SEPARATOR = 159,
	   SDL_SCANCODE_OUT = 160,
	   SDL_SCANCODE_OPER = 161,
	   SDL_SCANCODE_CLEARAGAIN = 162,
	   SDL_SCANCODE_CRSEL = 163,
	   SDL_SCANCODE_EXSEL = 164,
	   SDL_SCANCODE_KP_00 = 176,
	   SDL_SCANCODE_KP_000 = 177,
	   SDL_SCANCODE_THOUSANDSSEPARATOR = 178,
	   SDL_SCANCODE_DECIMALSEPARATOR   = 179,
	   SDL_SCANCODE_CURRENCYUNIT       = 180,
	   SDL_SCANCODE_CURRENCYSUBUNIT    = 181,
	   SDL_SCANCODE_KP_LEFTPAREN       = 182,
	   SDL_SCANCODE_KP_RIGHTPAREN      = 183,
	   SDL_SCANCODE_KP_LEFTBRACE       = 184,
	   SDL_SCANCODE_KP_RIGHTBRACE      = 185,
	   SDL_SCANCODE_KP_TAB             = 186,
	   SDL_SCANCODE_KP_BACKSPACE       = 187,
	   SDL_SCANCODE_KP_A               = 188,
	   SDL_SCANCODE_KP_B               = 189,
	   SDL_SCANCODE_KP_C               = 190,
	   SDL_SCANCODE_KP_D               = 191,
	   SDL_SCANCODE_KP_E               = 192,
	   SDL_SCANCODE_KP_F               = 193,
	   SDL_SCANCODE_KP_XOR             = 194,
	   SDL_SCANCODE_KP_POWER           = 195,
	   SDL_SCANCODE_KP_PERCENT         = 196,
	   SDL_SCANCODE_KP_LESS            = 197,
	   SDL_SCANCODE_KP_GREATER         = 198,
	   SDL_SCANCODE_KP_AMPERSAND       = 199,
	   SDL_SCANCODE_KP_DBLAMPERSAND    = 200,
	   SDL_SCANCODE_KP_VERTICALBAR     = 201,
	   SDL_SCANCODE_KP_DBLVERTICALBAR  = 202,
	   SDL_SCANCODE_KP_COLON = 203,
	   SDL_SCANCODE_KP_HASH = 204,
	   SDL_SCANCODE_KP_SPACE = 205,
	   SDL_SCANCODE_KP_AT = 206,
	   SDL_SCANCODE_KP_EXCLAM = 207,
	   SDL_SCANCODE_KP_MEMSTORE = 208,
	   SDL_SCANCODE_KP_MEMRECALL = 209,
	   SDL_SCANCODE_KP_MEMCLEAR = 210,
	   SDL_SCANCODE_KP_MEMADD = 211,
	   SDL_SCANCODE_KP_MEMSUBTRACT = 212,
	   SDL_SCANCODE_KP_MEMMULTIPLY = 213,
	   SDL_SCANCODE_KP_MEMDIVIDE = 214,
	   SDL_SCANCODE_KP_PLUSMINUS = 215,
	   SDL_SCANCODE_KP_CLEAR = 216,
	   SDL_SCANCODE_KP_CLEARENTRY = 217,
	   SDL_SCANCODE_KP_BINARY = 218,
	   SDL_SCANCODE_KP_OCTAL = 219,
	   SDL_SCANCODE_KP_DECIMAL = 220,
	   SDL_SCANCODE_KP_HEXADECIMAL = 221,
	   SDL_SCANCODE_LCTRL = 224,
	   SDL_SCANCODE_LSHIFT = 225,
	   SDL_SCANCODE_LALT = 226,
	   SDL_SCANCODE_LGUI = 227,
	   SDL_SCANCODE_RCTRL = 228,
	   SDL_SCANCODE_RSHIFT = 229,
	   SDL_SCANCODE_RALT = 230,
	   SDL_SCANCODE_RGUI = 231,
	   SDL_SCANCODE_MODE = 257,
	   SDL_SCANCODE_AUDIONEXT = 258,
	   SDL_SCANCODE_AUDIOPREV = 259,
	   SDL_SCANCODE_AUDIOSTOP = 260,
	   SDL_SCANCODE_AUDIOPLAY = 261,
	   SDL_SCANCODE_AUDIOMUTE = 262,
	   SDL_SCANCODE_MEDIASELECT = 263,
	   SDL_SCANCODE_WWW = 264,
	   SDL_SCANCODE_MAIL = 265,
	   SDL_SCANCODE_CALCULATOR = 266,
	   SDL_SCANCODE_COMPUTER = 267,
	   SDL_SCANCODE_AC_SEARCH = 268,
	   SDL_SCANCODE_AC_HOME = 269,
	   SDL_SCANCODE_AC_BACK = 270,
	   SDL_SCANCODE_AC_FORWARD = 271,
	   SDL_SCANCODE_AC_STOP = 272,
	   SDL_SCANCODE_AC_REFRESH = 273,
	   SDL_SCANCODE_AC_BOOKMARKS = 274,
	   SDL_SCANCODE_BRIGHTNESSDOWN = 275,
	   SDL_SCANCODE_BRIGHTNESSUP = 276,
	   SDL_SCANCODE_DISPLAYSWITCH = 277,
	   SDL_SCANCODE_KBDILLUMTOGGLE = 278,
	   SDL_SCANCODE_KBDILLUMDOWN = 279,
	   SDL_SCANCODE_KBDILLUMUP = 280,
	   SDL_SCANCODE_EJECT = 281,
	   SDL_SCANCODE_SLEEP = 282,
	   SDL_NUM_SCANCODES = 512
	} SDL_Scancode;

	enum {
		SDLK_UNKNOWN = 0x0,
		SDLK_RETURN = 0xd,
		SDLK_ESCAPE = 0x1b,
		SDLK_BACKSPACE = 0x8,
		SDLK_TAB = 0x9,
		SDLK_SPACE = 0x20,
		SDLK_EXCLAIM = 0x21,
		SDLK_QUOTEDBL = 0x22,
		SDLK_HASH = 0x23,
		SDLK_PERCENT = 0x25,
		SDLK_DOLLAR = 0x24,
		SDLK_AMPERSAND = 0x26,
		SDLK_QUOTE = 0x27,
		SDLK_LEFTPAREN = 0x28,
		SDLK_RIGHTPAREN = 0x29,
		SDLK_ASTERISK = 0x2a,
		SDLK_PLUS = 0x2b,
		SDLK_COMMA = 0x2c,
		SDLK_MINUS = 0x2d,
		SDLK_PERIOD = 0x2e,
		SDLK_SLASH = 0x2f,
		SDLK_0 = 0x30,
		SDLK_1 = 0x31,
		SDLK_2 = 0x32,
		SDLK_3 = 0x33,
		SDLK_4 = 0x34,
		SDLK_5 = 0x35,
		SDLK_6 = 0x36,
		SDLK_7 = 0x37,
		SDLK_8 = 0x38,
		SDLK_9 = 0x39,
		SDLK_COLON = 0x3a,
		SDLK_SEMICOLON = 0x3b,
		SDLK_LESS = 0x3c,
		SDLK_EQUALS = 0x3d,
		SDLK_GREATER = 0x3e,
		SDLK_QUESTION = 0x3f,
		SDLK_AT = 0x40,
		SDLK_LEFTBRACKET = 0x5b,
		SDLK_BACKSLASH = 0x5c,
		SDLK_RIGHTBRACKET = 0x5d,
		SDLK_CARET = 0x5e,
		SDLK_UNDERSCORE = 0x5f,
		SDLK_BACKQUOTE = 0x60,
		SDLK_a = 0x61,
		SDLK_b = 0x62,
		SDLK_c = 0x63,
		SDLK_d = 0x64,
		SDLK_e = 0x65,
		SDLK_f = 0x66,
		SDLK_g = 0x67,
		SDLK_h = 0x68,
		SDLK_i = 0x69,
		SDLK_j = 0x6a,
		SDLK_k = 0x6b,
		SDLK_l = 0x6c,
		SDLK_m = 0x6d,
		SDLK_n = 0x6e,
		SDLK_o = 0x6f,
		SDLK_p = 0x70,
		SDLK_q = 0x71,
		SDLK_r = 0x72,
		SDLK_s = 0x73,
		SDLK_t = 0x74,
		SDLK_u = 0x75,
		SDLK_v = 0x76,
		SDLK_w = 0x77,
		SDLK_x = 0x78,
		SDLK_y = 0x79,
		SDLK_z = 0x7a,
		SDLK_CAPSLOCK = 0x40000039,
		SDLK_F1 = 0x4000003a,
		SDLK_F2 = 0x4000003b,
		SDLK_F3 = 0x4000003c,
		SDLK_F4 = 0x4000003d,
		SDLK_F5 = 0x4000003e,
		SDLK_F6 = 0x4000003f,
		SDLK_F7 = 0x40000040,
		SDLK_F8 = 0x40000041,
		SDLK_F9 = 0x40000042,
		SDLK_F10 = 0x40000043,
		SDLK_F11 = 0x40000044,
		SDLK_F12 = 0x40000045,
		SDLK_PRINTSCREEN = 0x40000046,
		SDLK_SCROLLLOCK = 0x40000047,
		SDLK_PAUSE = 0x40000048,
		SDLK_INSERT = 0x40000049,
		SDLK_HOME = 0x4000004a,
		SDLK_PAGEUP = 0x4000004b,
		SDLK_DELETE = 0x7f,
		SDLK_END = 0x4000004d,
		SDLK_PAGEDOWN = 0x4000004e,
		SDLK_RIGHT = 0x4000004f,
		SDLK_LEFT = 0x40000050,
		SDLK_DOWN = 0x40000051,
		SDLK_UP = 0x40000052,
		SDLK_NUMLOCKCLEAR = 0x40000053,
		SDLK_KP_DIVIDE = 0x40000054,
		SDLK_KP_MULTIPLY = 0x40000055,
		SDLK_KP_MINUS = 0x40000056,
		SDLK_KP_PLUS = 0x40000057,
		SDLK_KP_ENTER = 0x40000058,
		SDLK_KP_1 = 0x40000059,
		SDLK_KP_2 = 0x4000005a,
		SDLK_KP_3 = 0x4000005b,
		SDLK_KP_4 = 0x4000005c,
		SDLK_KP_5 = 0x4000005d,
		SDLK_KP_6 = 0x4000005e,
		SDLK_KP_7 = 0x4000005f,
		SDLK_KP_8 = 0x40000060,
		SDLK_KP_9 = 0x40000061,
		SDLK_KP_0 = 0x40000062,
		SDLK_KP_PERIOD = 0x40000063,
		SDLK_APPLICATION = 0x40000065,
		SDLK_POWER = 0x40000066,
		SDLK_KP_EQUALS = 0x40000067,
		SDLK_F13 = 0x40000068,
		SDLK_F14 = 0x40000069,
		SDLK_F15 = 0x4000006a,
		SDLK_F16 = 0x4000006b,
		SDLK_F17 = 0x4000006c,
		SDLK_F18 = 0x4000006d,
		SDLK_F19 = 0x4000006e,
		SDLK_F20 = 0x4000006f,
		SDLK_F21 = 0x40000070,
		SDLK_F22 = 0x40000071,
		SDLK_F23 = 0x40000072,
		SDLK_F24 = 0x40000073,
		SDLK_EXECUTE = 0x40000074,
		SDLK_HELP = 0x40000075,
		SDLK_MENU = 0x40000076,
		SDLK_SELECT = 0x40000077,
		SDLK_STOP = 0x40000078,
		SDLK_AGAIN = 0x40000079,
		SDLK_UNDO = 0x4000007a,
		SDLK_CUT = 0x4000007b,
		SDLK_COPY = 0x4000007c,
		SDLK_PASTE = 0x4000007d,
		SDLK_FIND = 0x4000007e,
		SDLK_MUTE = 0x4000007f,
		SDLK_VOLUMEUP = 0x40000080,
		SDLK_VOLUMEDOWN = 0x40000081,
		SDLK_KP_COMMA = 0x40000085,
		SDLK_KP_EQUALSAS400 = 0x40000086,
		SDLK_ALTERASE = 0x40000099,
		SDLK_SYSREQ = 0x4000009a,
		SDLK_CANCEL = 0x4000009b,
		SDLK_CLEAR = 0x4000009c,
		SDLK_PRIOR = 0x4000009d,
		SDLK_RETURN2 = 0x4000009e,
		SDLK_SEPARATOR = 0x4000009f,
		SDLK_OUT = 0x400000a0,
		SDLK_OPER = 0x400000a1,
		SDLK_CLEARAGAIN = 0x400000a2,
		SDLK_CRSEL = 0x400000a3,
		SDLK_EXSEL = 0x400000a4,
		SDLK_KP_00 = 0x400000b0,
		SDLK_KP_000 = 0x400000b1,
		SDLK_THOUSANDSSEPARATOR = 0x400000b2,
		SDLK_DECIMALSEPARATOR = 0x400000b3,
		SDLK_CURRENCYUNIT = 0x400000b4,
		SDLK_CURRENCYSUBUNIT = 0x400000b5,
		SDLK_KP_LEFTPAREN = 0x400000b6,
		SDLK_KP_RIGHTPAREN = 0x400000b7,
		SDLK_KP_LEFTBRACE = 0x400000b8,
		SDLK_KP_RIGHTBRACE = 0x400000b9,
		SDLK_KP_TAB = 0x400000ba,
		SDLK_KP_BACKSPACE = 0x400000bb,
		SDLK_KP_A = 0x400000bc,
		SDLK_KP_B = 0x400000bd,
		SDLK_KP_C = 0x400000be,
		SDLK_KP_D = 0x400000bf,
		SDLK_KP_E = 0x400000c0,
		SDLK_KP_F = 0x400000c1,
		SDLK_KP_XOR = 0x400000c2,
		SDLK_KP_POWER = 0x400000c3,
		SDLK_KP_PERCENT = 0x400000c4,
		SDLK_KP_LESS = 0x400000c5,
		SDLK_KP_GREATER = 0x400000c6,
		SDLK_KP_AMPERSAND = 0x400000c7,
		SDLK_KP_DBLAMPERSAND = 0x400000c8,
		SDLK_KP_VERTICALBAR = 0x400000c9,
		SDLK_KP_DBLVERTICALBAR = 0x400000ca,
		SDLK_KP_COLON = 0x400000cb,
		SDLK_KP_HASH = 0x400000cc,
		SDLK_KP_SPACE = 0x400000cd,
		SDLK_KP_AT = 0x400000ce,
		SDLK_KP_EXCLAM = 0x400000cf,
		SDLK_KP_MEMSTORE = 0x400000d0,
		SDLK_KP_MEMRECALL = 0x400000d1,
		SDLK_KP_MEMCLEAR = 0x400000d2,
		SDLK_KP_MEMADD = 0x400000d3,
		SDLK_KP_MEMSUBTRACT = 0x400000d4,
		SDLK_KP_MEMMULTIPLY = 0x400000d5,
		SDLK_KP_MEMDIVIDE = 0x400000d6,
		SDLK_KP_PLUSMINUS = 0x400000d7,
		SDLK_KP_CLEAR = 0x400000d8,
		SDLK_KP_CLEARENTRY = 0x400000d9,
		SDLK_KP_BINARY = 0x400000da,
		SDLK_KP_OCTAL = 0x400000db,
		SDLK_KP_DECIMAL = 0x400000dc,
		SDLK_KP_HEXADECIMAL = 0x400000dd,
		SDLK_LCTRL = 0x400000e0,
		SDLK_LSHIFT = 0x400000e1,
		SDLK_LALT = 0x400000e2,
		SDLK_LGUI = 0x400000e3,
		SDLK_RCTRL = 0x400000e4,
		SDLK_RSHIFT = 0x400000e5,
		SDLK_RALT = 0x400000e6,
		SDLK_RGUI = 0x400000e7,
		SDLK_MODE = 0x40000101,
		SDLK_AUDIONEXT = 0x40000102,
		SDLK_AUDIOPREV = 0x40000103,
		SDLK_AUDIOSTOP = 0x40000104,
		SDLK_AUDIOPLAY = 0x40000105,
		SDLK_AUDIOMUTE = 0x40000106,
		SDLK_MEDIASELECT = 0x40000107,
		SDLK_WWW = 0x40000108,
		SDLK_MAIL = 0x40000109,
		SDLK_CALCULATOR = 0x4000010a,
		SDLK_COMPUTER = 0x4000010b,
		SDLK_AC_SEARCH = 0x4000010c,
		SDLK_AC_HOME = 0x4000010d,
		SDLK_AC_BACK = 0x4000010e,
		SDLK_AC_FORWARD = 0x4000010f,
		SDLK_AC_STOP = 0x40000110,
		SDLK_AC_REFRESH = 0x40000111,
		SDLK_AC_BOOKMARKS = 0x40000112,
		SDLK_BRIGHTNESSDOWN = 0x40000113,
		SDLK_BRIGHTNESSUP = 0x40000114,
		SDLK_DISPLAYSWITCH = 0x40000115,
		SDLK_KBDILLUMTOGGLE = 0x40000116,
		SDLK_KBDILLUMDOWN = 0x40000117,
		SDLK_KBDILLUMUP = 0x40000118,
		SDLK_EJECT = 0x40000119,
		SDLK_SLEEP = 0x4000011a,
	};

	typedef enum SDL_Keymod {
	   KMOD_NONE     = 0x0000,
	   KMOD_LSHIFT   = 0x0001,
	   KMOD_RSHIFT   = 0x0002,
	   KMOD_LCTRL    = 0x0040,
	   KMOD_RCTRL    = 0x0080,
	   KMOD_LALT     = 0x0100,
	   KMOD_RALT     = 0x0200,
	   KMOD_LGUI     = 0x0400,
	   KMOD_RGUI     = 0x0800,
	   KMOD_NUM      = 0x1000,
	   KMOD_CAPS     = 0x2000,
	   KMOD_MODE     = 0x4000,
	   KMOD_RESERVED = 0x8000,
		KMOD_CTRL = 0xc0,
		KMOD_SHIFT = 0x3,
		KMOD_ALT = 0x300,
		KMOD_GUI = 0xc00,
	} SDL_Keymod;

	typedef enum {
	   SDL_BLENDMODE_NONE  = 0x00000000,
	   SDL_BLENDMODE_BLEND = 0x00000001,
	   SDL_BLENDMODE_ADD   = 0x00000002,
	   SDL_BLENDMODE_MOD   = 0x00000004
	} SDL_BlendMode;

	typedef enum {
	   SDL_HINT_DEFAULT,
	   SDL_HINT_NORMAL,
	   SDL_HINT_OVERRIDE
	} SDL_HintPriority;

	typedef enum SDL_PowerState {
	   SDL_POWERSTATE_UNKNOWN,
	   SDL_POWERSTATE_ON_BATTERY,
	   SDL_POWERSTATE_NO_BATTERY,
	   SDL_POWERSTATE_CHARGING,
	   SDL_POWERSTATE_CHARGED
	} SDL_PowerState;

	typedef struct SDL_version {
	   uint8_t major;
	   uint8_t minor;
	   uint8_t patch;
	} SDL_version;

	typedef struct SDL_Keysym {
	   SDL_Scancode scancode;
	   SDL_Keycode sym;
	   uint16_t mod;
	   uint32_t unicode;
	} SDL_Keysym;

	typedef enum SDL_SYSWM_TYPE {
	   SDL_SYSWM_UNKNOWN,
	   SDL_SYSWM_WINDOWS,
	   SDL_SYSWM_X11,
	   SDL_SYSWM_DIRECTFB,
	   SDL_SYSWM_COCOA,
	   SDL_SYSWM_UIKIT,
	} SDL_SYSWM_TYPE;

	enum {
	   SDL_LOG_CATEGORY_APPLICATION,
	   SDL_LOG_CATEGORY_ERROR,
	   SDL_LOG_CATEGORY_SYSTEM,
	   SDL_LOG_CATEGORY_AUDIO,
	   SDL_LOG_CATEGORY_VIDEO,
	   SDL_LOG_CATEGORY_RENDER,
	   SDL_LOG_CATEGORY_INPUT,
	   SDL_LOG_CATEGORY_RESERVED1,
	   SDL_LOG_CATEGORY_RESERVED2,
	   SDL_LOG_CATEGORY_RESERVED3,
	   SDL_LOG_CATEGORY_RESERVED4,
	   SDL_LOG_CATEGORY_RESERVED5,
	   SDL_LOG_CATEGORY_RESERVED6,
	   SDL_LOG_CATEGORY_RESERVED7,
	   SDL_LOG_CATEGORY_RESERVED8,
	   SDL_LOG_CATEGORY_RESERVED9,
	   SDL_LOG_CATEGORY_RESERVED10,
	   SDL_LOG_CATEGORY_CUSTOM
	};

	typedef enum SDL_LogPriority {
	   SDL_LOG_PRIORITY_VERBOSE = 1,
	   SDL_LOG_PRIORITY_DEBUG,
	   SDL_LOG_PRIORITY_INFO,
	   SDL_LOG_PRIORITY_WARN,
	   SDL_LOG_PRIORITY_ERROR,
	   SDL_LOG_PRIORITY_CRITICAL,
	   SDL_NUM_LOG_PRIORITIES
	} SDL_LogPriority;

	typedef struct SDL_DisplayMode {
	   uint32_t format;
	   int      w, h, refresh_rate;
	   void*    driverdata;
	} SDL_DisplayMode;

	typedef enum SDL_GLattr {
	   SDL_GL_RED_SIZE,
	   SDL_GL_GREEN_SIZE,
	   SDL_GL_BLUE_SIZE,
	   SDL_GL_ALPHA_SIZE,
	   SDL_GL_BUFFER_SIZE,
	   SDL_GL_DOUBLEBUFFER,
	   SDL_GL_DEPTH_SIZE,
	   SDL_GL_STENCIL_SIZE,
	   SDL_GL_ACCUM_RED_SIZE,
	   SDL_GL_ACCUM_GREEN_SIZE,
	   SDL_GL_ACCUM_BLUE_SIZE,
	   SDL_GL_ACCUM_ALPHA_SIZE,
	   SDL_GL_STEREO,
	   SDL_GL_MULTISAMPLEBUFFERS,
	   SDL_GL_MULTISAMPLESAMPLES,
	   SDL_GL_ACCELERATED_VISUAL,
	   SDL_GL_RETAINED_BACKING,
	   SDL_GL_CONTEXT_MAJOR_VERSION,
	   SDL_GL_CONTEXT_MINOR_VERSION
	} SDL_GLattr;

	typedef enum SDL_GrabMode {
	   SDL_GRAB_QUERY = -1,
	   SDL_GRAB_OFF = 0,
	   SDL_GRAB_ON = 1
	} SDL_GrabMode;

	typedef enum SDL_RendererFlags {
	   SDL_RENDERER_SOFTWARE     = 0x00000001,
	   SDL_RENDERER_ACCELERATED  = 0x00000002,
	   SDL_RENDERER_PRESENTVSYNC = 0x00000004
	} SDL_RendererFlags;

	typedef enum SDL_TextureAccess {
	   SDL_TEXTUREACCESS_STATIC,
	   SDL_TEXTUREACCESS_STREAMING
	} SDL_TextureAccess;

	typedef enum SDL_TextureModulate {
	   SDL_TEXTUREMODULATE_NONE = 0x00000000,
	   SDL_TEXTUREMODULATE_COLOR = 0x00000001,
	   SDL_TEXTUREMODULATE_ALPHA = 0x00000002
	} SDL_TextureModulate;

	typedef struct SDL_RendererInfo {
	   const char *name;
	   uint32_t flags;
	   uint32_t num_texture_formats;
	   uint32_t texture_formats[16];
	   int max_texture_width;
	   int max_texture_height;
	} SDL_RendererInfo;

	typedef struct SDL_SysWMinfo {
	   SDL_version    version;
	   SDL_SYSWM_TYPE subsystem;
	   union info {
	 struct win {
	         void* window; // HWND
	 } win;
	 struct x11 {
	         void* display; // Display*
	         void* window;  // Window
	 } x11;
	 struct dfb {
	         void* dfb;     // IDirectFB*
	         void* window;  // IDirectFBWindow*
	         void* surface; // IDirectFBSurface*
	 } dfb;
	 struct cocoa {
	         void* window;  // NSWindow*
	 } cocoa;
	 struct uikit {
	    void* window; // UIWindow*
	 } uikit;
	 int dummy;
	   } info;
	} SDL_SysWMinfo;

	typedef struct SDL_Point {
	   int x, y;
	} SDL_Point;

	typedef struct SDL_Rect {
	   int x, y, w, h;
	} SDL_Rect;

	typedef struct SDL_Color {
	   uint8_t r, g, b;
	   uint8_t unused;
	} SDL_Color;

	typedef struct SDL_Palette {
	   int        ncolors;
	   SDL_Color* colors;
	   uint32_t   version;
	   int        refcount;
	} SDL_Palette;

	typedef struct SDL_PixelFormat {
	   uint32_t format;
	   SDL_Palette *palette;
	   uint8_t BitsPerPixel;
	   uint8_t BytesPerPixel;
	   uint8_t padding[2];
	   uint32_t Rmask;
	   uint32_t Gmask;
	   uint32_t Bmask;
	   uint32_t Amask;
	   uint8_t Rloss;
	   uint8_t Gloss;
	   uint8_t Bloss;
	   uint8_t Aloss;
	   uint8_t Rshift;
	   uint8_t Gshift;
	   uint8_t Bshift;
	   uint8_t Ashift;
	   int refcount;
	   struct SDL_PixelFormat *next;
	} SDL_PixelFormat;

	typedef struct SDL_assert_data {
	   int          always_ignore;
	   unsigned int trigger_count;
	   const char*  condition;
	   const char*  filename;
	   int linenum;
	   const char*  function_;
	   const struct SDL_assert_data *next;
	} SDL_assert_data;

	typedef struct SDL_RWops {
	   long   (* seek)(  struct SDL_RWops* context,     long offset, int whence );
	   size_t (* read)(  struct SDL_RWops* context,       void* ptr, size_t size, size_t maxnum );
	   size_t (* write)( struct SDL_RWops* context, const void* ptr, size_t size, size_t num );
	   int    (* close)( struct SDL_RWops* context );
	   uint32_t type;
	   union {
	 struct {
	    SDL_bool append;
	    void *h;
	    struct {
	       void *data;
	       size_t size;
	       size_t left;
	    } buffer;
	 } windowsio;
	 struct {
	    uint8_t *base;
	    uint8_t *here;
	    uint8_t *stop;
	 } mem;
	 struct {
	    void *data1;
	 } unknown;
	   } hidden;
	} SDL_RWops;

	typedef struct SDL_AudioSpec {
	   int               freq;
	   SDL_AudioFormat   format;
	   uint8_t           channels;
	   uint8_t           silence;
	   uint16_t          samples;
	   uint16_t          padding;
	   uint32_t          size;
	   SDL_AudioCallback callback;
	   void*             userdata;
	} SDL_AudioSpec;

	struct SDL_AudioCVT;
	typedef void (* SDL_AudioFilter)( struct SDL_AudioCVT * cvt, SDL_AudioFormat format );
	typedef struct SDL_AudioCVT {
	   int             needed;
	   SDL_AudioFormat src_format;
	   SDL_AudioFormat dst_format;
	   double          rate_incr;
	   uint8_t*        buf;
	   int             len;
	   int             len_cvt;
	   int             len_mult;
	   double          len_ratio;
	   SDL_AudioFilter filters[10];
	   int             filter_index;
	} SDL_AudioCVT;

	typedef struct SDL_Surface {
	   uint32_t            flags;
	   SDL_PixelFormat*    format;
	   int                 w, h, pitch;
	   void*               pixels;
	   void*               userdata;
	   int                 locked;
	   void*               lock_data;
	   SDL_Rect            clip_rect;
	   struct SDL_BlitMap* map;
	   int                 refcount;
	} SDL_Surface;

	typedef uintptr_t         (* pfnSDL_CurrentBeginThread) (void *, unsigned, unsigned (* func) (void *), void *arg, unsigned, unsigned *threadID );
	typedef void              (* pfnSDL_CurrentEndThread) (unsigned code);
	typedef int               (* SDL_ThreadFunction) (void *data);
	typedef SDL_assert_state  (* SDL_AssertionHandler )( const SDL_assert_data* data, void* userdata );

	typedef struct SDL_Finger {
	   SDL_FingerID id;
	   uint16_t     x, y;
	   uint16_t     pressure;
	   uint16_t     xdelta, ydelta;
	   uint16_t     last_x, last_y,last_pressure;
	   SDL_bool     down;
	} SDL_Finger;

	typedef struct SDL_Touch {
	   void (*FreeTouch) (struct SDL_Touch * touch);
	   float pressure_max, pressure_min;
	   float x_max, x_min, y_max, y_min;
	   uint16_t xres,yres,pressureres;
	   float native_xres,native_yres,native_pressureres;
	   float tilt;
	   float rotation;
	   SDL_TouchID id;
	   SDL_Window *focus;
	   char *name;
	   uint8_t buttonstate;
	   SDL_bool relative_mode;
	   SDL_bool flush_motion;
	   int num_fingers;
	   int max_fingers;
	   SDL_Finger** fingers;
	   void *driverdata;
	} SDL_Touch;

	enum {
		SDL_RELEASED = 0,
		SDL_PRESSED = 1,
	};

/**
 * \brief The types of events that can be delivered.
 */
typedef enum
{
    SDL_FIRSTEVENT     = 0,     /**< Unused (do not remove) */

    /* Application events */
    SDL_QUIT           = 0x100, /**< User-requested quit */

    /* These application events have special meaning on iOS, see README-ios.md for details */
    SDL_APP_TERMINATING,        /**< The application is being terminated by the OS
                                     Called on iOS in applicationWillTerminate()
                                     Called on Android in onDestroy()
                                */
    SDL_APP_LOWMEMORY,          /**< The application is low on memory, free memory if possible.
                                     Called on iOS in applicationDidReceiveMemoryWarning()
                                     Called on Android in onLowMemory()
                                */
    SDL_APP_WILLENTERBACKGROUND, /**< The application is about to enter the background
                                     Called on iOS in applicationWillResignActive()
                                     Called on Android in onPause()
                                */
    SDL_APP_DIDENTERBACKGROUND, /**< The application did enter the background and may not get CPU for some time
                                     Called on iOS in applicationDidEnterBackground()
                                     Called on Android in onPause()
                                */
    SDL_APP_WILLENTERFOREGROUND, /**< The application is about to enter the foreground
                                     Called on iOS in applicationWillEnterForeground()
                                     Called on Android in onResume()
                                */
    SDL_APP_DIDENTERFOREGROUND, /**< The application is now interactive
                                     Called on iOS in applicationDidBecomeActive()
                                     Called on Android in onResume()
                                */

    /* Window events */
    SDL_WINDOWEVENT    = 0x200, /**< Window state change */
    SDL_SYSWMEVENT,             /**< System specific event */

    /* Keyboard events */
    SDL_KEYDOWN        = 0x300, /**< Key pressed */
    SDL_KEYUP,                  /**< Key released */
    SDL_TEXTEDITING,            /**< Keyboard text editing (composition) */
    SDL_TEXTINPUT,              /**< Keyboard text input */
    SDL_KEYMAPCHANGED,          /**< Keymap changed due to a system event such as an
                                     input language or keyboard layout change.
                                */

    /* Mouse events */
    SDL_MOUSEMOTION    = 0x400, /**< Mouse moved */
    SDL_MOUSEBUTTONDOWN,        /**< Mouse button pressed */
    SDL_MOUSEBUTTONUP,          /**< Mouse button released */
    SDL_MOUSEWHEEL,             /**< Mouse wheel motion */

    /* Joystick events */
    SDL_JOYAXISMOTION  = 0x600, /**< Joystick axis motion */
    SDL_JOYBALLMOTION,          /**< Joystick trackball motion */
    SDL_JOYHATMOTION,           /**< Joystick hat position change */
    SDL_JOYBUTTONDOWN,          /**< Joystick button pressed */
    SDL_JOYBUTTONUP,            /**< Joystick button released */
    SDL_JOYDEVICEADDED,         /**< A new joystick has been inserted into the system */
    SDL_JOYDEVICEREMOVED,       /**< An opened joystick has been removed */

    /* Game controller events */
    SDL_CONTROLLERAXISMOTION  = 0x650, /**< Game controller axis motion */
    SDL_CONTROLLERBUTTONDOWN,          /**< Game controller button pressed */
    SDL_CONTROLLERBUTTONUP,            /**< Game controller button released */
    SDL_CONTROLLERDEVICEADDED,         /**< A new Game controller has been inserted into the system */
    SDL_CONTROLLERDEVICEREMOVED,       /**< An opened Game controller has been removed */
    SDL_CONTROLLERDEVICEREMAPPED,      /**< The controller mapping was updated */

    /* Touch events */
    SDL_FINGERDOWN      = 0x700,
    SDL_FINGERUP,
    SDL_FINGERMOTION,

    /* Gesture events */
    SDL_DOLLARGESTURE   = 0x800,
    SDL_DOLLARRECORD,
    SDL_MULTIGESTURE,

    /* Clipboard events */
    SDL_CLIPBOARDUPDATE = 0x900, /**< The clipboard changed */

    /* Drag and drop events */
    SDL_DROPFILE        = 0x1000, /**< The system requests a file open */

    /* Audio hotplug events */
    SDL_AUDIODEVICEADDED = 0x1100, /**< A new audio device is available */
    SDL_AUDIODEVICEREMOVED,        /**< An audio device has been removed. */

    /* Render events */
    SDL_RENDER_TARGETS_RESET = 0x2000, /**< The render targets have been reset and their contents need to be updated */
    SDL_RENDER_DEVICE_RESET, /**< The device has been reset and all textures need to be recreated */

    /** Events ::SDL_USEREVENT through ::SDL_LASTEVENT are for your use,
     *  and should be allocated with SDL_RegisterEvents()
     */
    SDL_USEREVENT    = 0x8000,

    /**
     *  This last event is only for bounding internal arrays
     */
    SDL_LASTEVENT    = 0xFFFF
} SDL_EventType;

/**
 *  \brief Fields shared by every event
 */
typedef struct SDL_CommonEvent
{
    Uint32 type;
    Uint32 timestamp;
} SDL_CommonEvent;

/**
 *  \brief Window state change event data (event.window.*)
 */
typedef struct SDL_WindowEvent
{
    Uint32 type;        /**< ::SDL_WINDOWEVENT */
    Uint32 timestamp;
    Uint32 windowID;    /**< The associated window */
    Uint8 event;        /**< ::SDL_WindowEventID */
    Uint8 padding1;
    Uint8 padding2;
    Uint8 padding3;
    Sint32 data1;       /**< event dependent data */
    Sint32 data2;       /**< event dependent data */
} SDL_WindowEvent;

/**
 *  \brief Keyboard button event structure (event.key.*)
 */
typedef struct SDL_KeyboardEvent
{
    Uint32 type;        /**< ::SDL_KEYDOWN or ::SDL_KEYUP */
    Uint32 timestamp;
    Uint32 windowID;    /**< The window with keyboard focus, if any */
    Uint8 state;        /**< ::SDL_PRESSED or ::SDL_RELEASED */
    Uint8 repeat;       /**< Non-zero if this is a key repeat */
    Uint8 padding2;
    Uint8 padding3;
    SDL_Keysym keysym;  /**< The key that was pressed or released */
} SDL_KeyboardEvent;

enum { SDL_TEXTEDITINGEVENT_TEXT_SIZE = 32 };
/**
 *  \brief Keyboard text editing event structure (event.edit.*)
 */
typedef struct SDL_TextEditingEvent
{
    Uint32 type;                                /**< ::SDL_TEXTEDITING */
    Uint32 timestamp;
    Uint32 windowID;                            /**< The window with keyboard focus, if any */
    char text[SDL_TEXTEDITINGEVENT_TEXT_SIZE];  /**< The editing text */
    Sint32 start;                               /**< The start cursor of selected editing text */
    Sint32 length;                              /**< The length of selected editing text */
} SDL_TextEditingEvent;


enum { SDL_TEXTINPUTEVENT_TEXT_SIZE = 32 };
/**
 *  \brief Keyboard text input event structure (event.text.*)
 */
typedef struct SDL_TextInputEvent
{
    Uint32 type;                              /**< ::SDL_TEXTINPUT */
    Uint32 timestamp;
    Uint32 windowID;                          /**< The window with keyboard focus, if any */
    char text[SDL_TEXTINPUTEVENT_TEXT_SIZE];  /**< The input text */
} SDL_TextInputEvent;

/**
 *  \brief Mouse motion event structure (event.motion.*)
 */
typedef struct SDL_MouseMotionEvent
{
    Uint32 type;        /**< ::SDL_MOUSEMOTION */
    Uint32 timestamp;
    Uint32 windowID;    /**< The window with mouse focus, if any */
    Uint32 which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    Uint32 state;       /**< The current button state */
    Sint32 x;           /**< X coordinate, relative to window */
    Sint32 y;           /**< Y coordinate, relative to window */
    Sint32 xrel;        /**< The relative motion in the X direction */
    Sint32 yrel;        /**< The relative motion in the Y direction */
} SDL_MouseMotionEvent;

/**
 *  \brief Mouse button event structure (event.button.*)
 */
typedef struct SDL_MouseButtonEvent
{
    Uint32 type;        /**< ::SDL_MOUSEBUTTONDOWN or ::SDL_MOUSEBUTTONUP */
    Uint32 timestamp;
    Uint32 windowID;    /**< The window with mouse focus, if any */
    Uint32 which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    Uint8 button;       /**< The mouse button index */
    Uint8 state;        /**< ::SDL_PRESSED or ::SDL_RELEASED */
    Uint8 clicks;       /**< 1 for single-click, 2 for double-click, etc. */
    Uint8 padding1;
    Sint32 x;           /**< X coordinate, relative to window */
    Sint32 y;           /**< Y coordinate, relative to window */
} SDL_MouseButtonEvent;

/**
 *  \brief Mouse wheel event structure (event.wheel.*)
 */
typedef struct SDL_MouseWheelEvent
{
    Uint32 type;        /**< ::SDL_MOUSEWHEEL */
    Uint32 timestamp;
    Uint32 windowID;    /**< The window with mouse focus, if any */
    Uint32 which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    Sint32 x;           /**< The amount scrolled horizontally, positive to the right and negative to the left */
    Sint32 y;           /**< The amount scrolled vertically, positive away from the user and negative toward the user */
    Uint32 direction;   /**< Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back */
} SDL_MouseWheelEvent;

/**
 *  \brief Joystick axis motion event structure (event.jaxis.*)
 */
typedef struct SDL_JoyAxisEvent
{
    Uint32 type;        /**< ::SDL_JOYAXISMOTION */
    Uint32 timestamp;
    SDL_JoystickID which; /**< The joystick instance id */
    Uint8 axis;         /**< The joystick axis index */
    Uint8 padding1;
    Uint8 padding2;
    Uint8 padding3;
    Sint16 value;       /**< The axis value (range: -32768 to 32767) */
    Uint16 padding4;
} SDL_JoyAxisEvent;

/**
 *  \brief Joystick trackball motion event structure (event.jball.*)
 */
typedef struct SDL_JoyBallEvent
{
    Uint32 type;        /**< ::SDL_JOYBALLMOTION */
    Uint32 timestamp;
    SDL_JoystickID which; /**< The joystick instance id */
    Uint8 ball;         /**< The joystick trackball index */
    Uint8 padding1;
    Uint8 padding2;
    Uint8 padding3;
    Sint16 xrel;        /**< The relative motion in the X direction */
    Sint16 yrel;        /**< The relative motion in the Y direction */
} SDL_JoyBallEvent;

/**
 *  \brief Joystick hat position change event structure (event.jhat.*)
 */
typedef struct SDL_JoyHatEvent
{
    Uint32 type;        /**< ::SDL_JOYHATMOTION */
    Uint32 timestamp;
    SDL_JoystickID which; /**< The joystick instance id */
    Uint8 hat;          /**< The joystick hat index */
    Uint8 value;        /**< The hat position value.
                         *   \sa ::SDL_HAT_LEFTUP ::SDL_HAT_UP ::SDL_HAT_RIGHTUP
                         *   \sa ::SDL_HAT_LEFT ::SDL_HAT_CENTERED ::SDL_HAT_RIGHT
                         *   \sa ::SDL_HAT_LEFTDOWN ::SDL_HAT_DOWN ::SDL_HAT_RIGHTDOWN
                         *
                         *   Note that zero means the POV is centered.
                         */
    Uint8 padding1;
    Uint8 padding2;
} SDL_JoyHatEvent;

/**
 *  \brief Joystick button event structure (event.jbutton.*)
 */
typedef struct SDL_JoyButtonEvent
{
    Uint32 type;        /**< ::SDL_JOYBUTTONDOWN or ::SDL_JOYBUTTONUP */
    Uint32 timestamp;
    SDL_JoystickID which; /**< The joystick instance id */
    Uint8 button;       /**< The joystick button index */
    Uint8 state;        /**< ::SDL_PRESSED or ::SDL_RELEASED */
    Uint8 padding1;
    Uint8 padding2;
} SDL_JoyButtonEvent;

/**
 *  \brief Joystick device event structure (event.jdevice.*)
 */
typedef struct SDL_JoyDeviceEvent
{
    Uint32 type;        /**< ::SDL_JOYDEVICEADDED or ::SDL_JOYDEVICEREMOVED */
    Uint32 timestamp;
    Sint32 which;       /**< The joystick device index for the ADDED event, instance id for the REMOVED event */
} SDL_JoyDeviceEvent;


/**
 *  \brief Game controller axis motion event structure (event.caxis.*)
 */
typedef struct SDL_ControllerAxisEvent
{
    Uint32 type;        /**< ::SDL_CONTROLLERAXISMOTION */
    Uint32 timestamp;
    SDL_JoystickID which; /**< The joystick instance id */
    Uint8 axis;         /**< The controller axis (SDL_GameControllerAxis) */
    Uint8 padding1;
    Uint8 padding2;
    Uint8 padding3;
    Sint16 value;       /**< The axis value (range: -32768 to 32767) */
    Uint16 padding4;
} SDL_ControllerAxisEvent;


/**
 *  \brief Game controller button event structure (event.cbutton.*)
 */
typedef struct SDL_ControllerButtonEvent
{
    Uint32 type;        /**< ::SDL_CONTROLLERBUTTONDOWN or ::SDL_CONTROLLERBUTTONUP */
    Uint32 timestamp;
    SDL_JoystickID which; /**< The joystick instance id */
    Uint8 button;       /**< The controller button (SDL_GameControllerButton) */
    Uint8 state;        /**< ::SDL_PRESSED or ::SDL_RELEASED */
    Uint8 padding1;
    Uint8 padding2;
} SDL_ControllerButtonEvent;


/**
 *  \brief Controller device event structure (event.cdevice.*)
 */
typedef struct SDL_ControllerDeviceEvent
{
    Uint32 type;        /**< ::SDL_CONTROLLERDEVICEADDED, ::SDL_CONTROLLERDEVICEREMOVED, or ::SDL_CONTROLLERDEVICEREMAPPED */
    Uint32 timestamp;
    Sint32 which;       /**< The joystick device index for the ADDED event, instance id for the REMOVED or REMAPPED event */
} SDL_ControllerDeviceEvent;

/**
 *  \brief Audio device event structure (event.adevice.*)
 */
typedef struct SDL_AudioDeviceEvent
{
    Uint32 type;        /**< ::SDL_AUDIODEVICEADDED, or ::SDL_AUDIODEVICEREMOVED */
    Uint32 timestamp;
    Uint32 which;       /**< The audio device index for the ADDED event (valid until next SDL_GetNumAudioDevices() call), SDL_AudioDeviceID for the REMOVED event */
    Uint8 iscapture;    /**< zero if an output device, non-zero if a capture device. */
    Uint8 padding1;
    Uint8 padding2;
    Uint8 padding3;
} SDL_AudioDeviceEvent;


/**
 *  \brief Touch finger event structure (event.tfinger.*)
 */
typedef struct SDL_TouchFingerEvent
{
    Uint32 type;        /**< ::SDL_FINGERMOTION or ::SDL_FINGERDOWN or ::SDL_FINGERUP */
    Uint32 timestamp;
    SDL_TouchID touchId; /**< The touch device id */
    SDL_FingerID fingerId;
    float x;            /**< Normalized in the range 0...1 */
    float y;            /**< Normalized in the range 0...1 */
    float dx;           /**< Normalized in the range -1...1 */
    float dy;           /**< Normalized in the range -1...1 */
    float pressure;     /**< Normalized in the range 0...1 */
} SDL_TouchFingerEvent;


/**
 *  \brief Multiple Finger Gesture Event (event.mgesture.*)
 */
typedef struct SDL_MultiGestureEvent
{
    Uint32 type;        /**< ::SDL_MULTIGESTURE */
    Uint32 timestamp;
    SDL_TouchID touchId; /**< The touch device index */
    float dTheta;
    float dDist;
    float x;
    float y;
    Uint16 numFingers;
    Uint16 padding;
} SDL_MultiGestureEvent;


/**
 * \brief Dollar Gesture Event (event.dgesture.*)
 */
typedef struct SDL_DollarGestureEvent
{
    Uint32 type;        /**< ::SDL_DOLLARGESTURE or ::SDL_DOLLARRECORD */
    Uint32 timestamp;
    SDL_TouchID touchId; /**< The touch device id */
    SDL_GestureID gestureId;
    Uint32 numFingers;
    float error;
    float x;            /**< Normalized center of gesture */
    float y;            /**< Normalized center of gesture */
} SDL_DollarGestureEvent;


/**
 *  \brief An event used to request a file open by the system (event.drop.*)
 *         This event is enabled by default, you can disable it with SDL_EventState().
 *  \note If this event is enabled, you must free the filename in the event.
 */
typedef struct SDL_DropEvent
{
    Uint32 type;        /**< ::SDL_DROPFILE */
    Uint32 timestamp;
    char *file;         /**< The file name, which should be freed with SDL_free() */
} SDL_DropEvent;


/**
 *  \brief The "quit requested" event
 */
typedef struct SDL_QuitEvent
{
    Uint32 type;        /**< ::SDL_QUIT */
    Uint32 timestamp;
} SDL_QuitEvent;

/**
 *  \brief OS Specific event
 */
typedef struct SDL_OSEvent
{
    Uint32 type;        /**< ::SDL_QUIT */
    Uint32 timestamp;
} SDL_OSEvent;

/**
 *  \brief A user-defined event type (event.user.*)
 */
typedef struct SDL_UserEvent
{
    Uint32 type;        /**< ::SDL_USEREVENT through ::SDL_LASTEVENT-1 */
    Uint32 timestamp;
    Uint32 windowID;    /**< The associated window if any */
    Sint32 code;        /**< User defined event code */
    void *data1;        /**< User defined data pointer */
    void *data2;        /**< User defined data pointer */
} SDL_UserEvent;


struct SDL_SysWMmsg;
typedef struct SDL_SysWMmsg SDL_SysWMmsg;

/**
 *  \brief A video driver dependent system event (event.syswm.*)
 *         This event is disabled by default, you can enable it with SDL_EventState()
 *
 *  \note If you want to use this event, you should include SDL_syswm.h.
 */
typedef struct SDL_SysWMEvent
{
    Uint32 type;        /**< ::SDL_SYSWMEVENT */
    Uint32 timestamp;
    SDL_SysWMmsg *msg;  /**< driver dependent data, defined in SDL_syswm.h */
} SDL_SysWMEvent;

/**
 *  \brief General event structure
 */
typedef union SDL_Event
{
    Uint32 type;                    /**< Event type, shared with all events */
    SDL_CommonEvent common;         /**< Common event data */
    SDL_WindowEvent window;         /**< Window event data */
    SDL_KeyboardEvent key;          /**< Keyboard event data */
    SDL_TextEditingEvent edit;      /**< Text editing event data */
    SDL_TextInputEvent text;        /**< Text input event data */
    SDL_MouseMotionEvent motion;    /**< Mouse motion event data */
    SDL_MouseButtonEvent button;    /**< Mouse button event data */
    SDL_MouseWheelEvent wheel;      /**< Mouse wheel event data */
    SDL_JoyAxisEvent jaxis;         /**< Joystick axis event data */
    SDL_JoyBallEvent jball;         /**< Joystick ball event data */
    SDL_JoyHatEvent jhat;           /**< Joystick hat event data */
    SDL_JoyButtonEvent jbutton;     /**< Joystick button event data */
    SDL_JoyDeviceEvent jdevice;     /**< Joystick device change event data */
    SDL_ControllerAxisEvent caxis;      /**< Game Controller axis event data */
    SDL_ControllerButtonEvent cbutton;  /**< Game Controller button event data */
    SDL_ControllerDeviceEvent cdevice;  /**< Game Controller device event data */
    SDL_AudioDeviceEvent adevice;   /**< Audio device event data */
    SDL_QuitEvent quit;             /**< Quit request event data */
    SDL_UserEvent user;             /**< Custom event data */
    SDL_SysWMEvent syswm;           /**< System dependent window event data */
    SDL_TouchFingerEvent tfinger;   /**< Touch finger event data */
    SDL_MultiGestureEvent mgesture; /**< Gesture event data */
    SDL_DollarGestureEvent dgesture; /**< Gesture event data */
    SDL_DropEvent drop;             /**< Drag and drop event data */

    /* This is necessary for ABI compatibility between Visual C++ and GCC
       Visual C++ will respect the push pack pragma and use 52 bytes for
       this structure, and GCC will use the alignment of the largest datatype
       within the union, which is 8 bytes.

       So... we'll add padding to force the size to be 56 bytes for both.
    */
    Uint8 padding[56];
} SDL_Event;



	typedef enum SDL_eventaction {
	   SDL_ADDEVENT,
	   SDL_PEEKEVENT,
	   SDL_GETEVENT
	} SDL_eventaction;

	typedef struct SDL_VideoInfo {
	   uint32_t hw_available:1;
	   uint32_t wm_available:1;
	   uint32_t UnusedBits1:6;
	   uint32_t UnusedBits2:1;
	   uint32_t blit_hw:1;
	   uint32_t blit_hw_CC:1;
	   uint32_t blit_hw_A:1;
	   uint32_t blit_sw:1;
	   uint32_t blit_sw_CC:1;
	   uint32_t blit_sw_A:1;
	   uint32_t blit_fill:1;
	   uint32_t UnusedBits3:16;
	   uint32_t video_mem;
	   SDL_PixelFormat *vfmt;
	   int current_w;
	   int current_h;
	} SDL_VideoInfo;

	typedef struct SDL_Overlay {
	   uint32_t format;
	   int w, h, planes;
	   uint16_t *pitches;
	   uint8_t **pixels;
	   struct private_yuvhwfuncs *hwfuncs;
	   struct private_yuvhwdata *hwdata;
	   uint32_t hw_overlay:1;
	   uint32_t UnusedBits:31;
	} SDL_Overlay;



]]

--[[ TODO support these?
	typedef int  (* SDL_EventFilter       )( void* userdata, SDL_Event* );
	typedef void (* SDL_LogOutputFunction )( void* userdata, int category, SDL_LogPriority, const char* message );
--]]

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

-- returns the # of events
function SDL_PollEvent(event)
	return 0
end

return sdl
