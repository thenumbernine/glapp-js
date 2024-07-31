local ffi = require 'ffi'
local table = require 'ext.table'

ffi.enum{
	'SDL_JOYSTICK_TYPE_UNKNOWN',
	'SDL_JOYSTICK_TYPE_GAMECONTROLLER',
	'SDL_JOYSTICK_TYPE_WHEEL',
	'SDL_JOYSTICK_TYPE_ARCADE_STICK',
	'SDL_JOYSTICK_TYPE_FLIGHT_STICK',
	'SDL_JOYSTICK_TYPE_DANCE_PAD',
	'SDL_JOYSTICK_TYPE_GUITAR',
	'SDL_JOYSTICK_TYPE_DRUM_KIT',
	'SDL_JOYSTICK_TYPE_ARCADE_PAD',
	'SDL_JOYSTICK_TYPE_THROTTLE',
}
ffi.enum{
	{SDL_JOYSTICK_POWER_UNKNOWN = -1},
	'SDL_JOYSTICK_POWER_EMPTY',
	'SDL_JOYSTICK_POWER_LOW',
	'SDL_JOYSTICK_POWER_MEDIUM',
	'SDL_JOYSTICK_POWER_FULL',
	'SDL_JOYSTICK_POWER_WIRED',
	'SDL_JOYSTICK_POWER_MAX',
}
ffi.enum{
	{SDL_TOUCH_DEVICE_INVALID = -1},
	'SDL_TOUCH_DEVICE_DIRECT',
	'SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE',
	'SDL_TOUCH_DEVICE_INDIRECT_RELATIVE',
}
ffi.enum{ SDL_TOUCH_MOUSEID = -1 }
ffi.enum{ SDL_MOUSE_TOUCHID = -1 }
ffi.enum{ {SDL_INIT_VIDEO = 0x20} }
ffi.enum{ {SDL_INIT_JOYSTICK = 0x00000200} }
ffi.enum{ {SDL_DISABLE = 0} }
ffi.enum{ {SDL_ENABLE = 1} }
ffi.enum{ {SDL_WINDOWPOS_CENTERED = 0x2fff0000} }
ffi.enum{ {SDL_FALSE = 0}, {SDL_TRUE = 1} }
ffi.enum{ {SDLK_SCANCODE_MASK = 1073741824} }
ffi.enum{
	{SDL_SCANCODE_UNKNOWN = 0},
	{SDL_SCANCODE_A = 4},
	{SDL_SCANCODE_B = 5},
	{SDL_SCANCODE_C = 6},
	{SDL_SCANCODE_D = 7},
	{SDL_SCANCODE_E = 8},
	{SDL_SCANCODE_F = 9},
	{SDL_SCANCODE_G = 10},
	{SDL_SCANCODE_H = 11},
	{SDL_SCANCODE_I = 12},
	{SDL_SCANCODE_J = 13},
	{SDL_SCANCODE_K = 14},
	{SDL_SCANCODE_L = 15},
	{SDL_SCANCODE_M = 16},
	{SDL_SCANCODE_N = 17},
	{SDL_SCANCODE_O = 18},
	{SDL_SCANCODE_P = 19},
	{SDL_SCANCODE_Q = 20},
	{SDL_SCANCODE_R = 21},
	{SDL_SCANCODE_S = 22},
	{SDL_SCANCODE_T = 23},
	{SDL_SCANCODE_U = 24},
	{SDL_SCANCODE_V = 25},
	{SDL_SCANCODE_W = 26},
	{SDL_SCANCODE_X = 27},
	{SDL_SCANCODE_Y = 28},
	{SDL_SCANCODE_Z = 29},
	{SDL_SCANCODE_1 = 30},
	{SDL_SCANCODE_2 = 31},
	{SDL_SCANCODE_3 = 32},
	{SDL_SCANCODE_4 = 33},
	{SDL_SCANCODE_5 = 34},
	{SDL_SCANCODE_6 = 35},
	{SDL_SCANCODE_7 = 36},
	{SDL_SCANCODE_8 = 37},
	{SDL_SCANCODE_9 = 38},
	{SDL_SCANCODE_0 = 39},
	{SDL_SCANCODE_RETURN = 40},
	{SDL_SCANCODE_ESCAPE = 41},
	{SDL_SCANCODE_BACKSPACE = 42},
	{SDL_SCANCODE_TAB = 43},
	{SDL_SCANCODE_SPACE = 44},
	{SDL_SCANCODE_MINUS = 45},
	{SDL_SCANCODE_EQUALS = 46},
	{SDL_SCANCODE_LEFTBRACKET = 47},
	{SDL_SCANCODE_RIGHTBRACKET = 48},
	{SDL_SCANCODE_BACKSLASH = 49},
	{SDL_SCANCODE_NONUSHASH = 50},
	{SDL_SCANCODE_SEMICOLON = 51},
	{SDL_SCANCODE_APOSTROPHE = 52},
	{SDL_SCANCODE_GRAVE = 53},
	{SDL_SCANCODE_COMMA = 54},
	{SDL_SCANCODE_PERIOD = 55},
	{SDL_SCANCODE_SLASH = 56},
	{SDL_SCANCODE_CAPSLOCK = 57},
	{SDL_SCANCODE_F1 = 58},
	{SDL_SCANCODE_F2 = 59},
	{SDL_SCANCODE_F3 = 60},
	{SDL_SCANCODE_F4 = 61},
	{SDL_SCANCODE_F5 = 62},
	{SDL_SCANCODE_F6 = 63},
	{SDL_SCANCODE_F7 = 64},
	{SDL_SCANCODE_F8 = 65},
	{SDL_SCANCODE_F9 = 66},
	{SDL_SCANCODE_F10 = 67},
	{SDL_SCANCODE_F11 = 68},
	{SDL_SCANCODE_F12 = 69},
	{SDL_SCANCODE_PRINTSCREEN = 70},
	{SDL_SCANCODE_SCROLLLOCK = 71},
	{SDL_SCANCODE_PAUSE = 72},
	{SDL_SCANCODE_INSERT = 73},
	{SDL_SCANCODE_HOME = 74},
	{SDL_SCANCODE_PAGEUP = 75},
	{SDL_SCANCODE_DELETE = 76},
	{SDL_SCANCODE_END = 77},
	{SDL_SCANCODE_PAGEDOWN = 78},
	{SDL_SCANCODE_RIGHT = 79},
	{SDL_SCANCODE_LEFT = 80},
	{SDL_SCANCODE_DOWN = 81},
	{SDL_SCANCODE_UP = 82},
	{SDL_SCANCODE_NUMLOCKCLEAR = 83},
	{SDL_SCANCODE_KP_DIVIDE = 84},
	{SDL_SCANCODE_KP_MULTIPLY = 85},
	{SDL_SCANCODE_KP_MINUS = 86},
	{SDL_SCANCODE_KP_PLUS = 87},
	{SDL_SCANCODE_KP_ENTER = 88},
	{SDL_SCANCODE_KP_1 = 89},
	{SDL_SCANCODE_KP_2 = 90},
	{SDL_SCANCODE_KP_3 = 91},
	{SDL_SCANCODE_KP_4 = 92},
	{SDL_SCANCODE_KP_5 = 93},
	{SDL_SCANCODE_KP_6 = 94},
	{SDL_SCANCODE_KP_7 = 95},
	{SDL_SCANCODE_KP_8 = 96},
	{SDL_SCANCODE_KP_9 = 97},
	{SDL_SCANCODE_KP_0 = 98},
	{SDL_SCANCODE_KP_PERIOD = 99},
	{SDL_SCANCODE_NONUSBACKSLASH = 100},
	{SDL_SCANCODE_APPLICATION = 101},
	{SDL_SCANCODE_POWER = 102},
	{SDL_SCANCODE_KP_EQUALS = 103},
	{SDL_SCANCODE_F13 = 104},
	{SDL_SCANCODE_F14 = 105},
	{SDL_SCANCODE_F15 = 106},
	{SDL_SCANCODE_F16 = 107},
	{SDL_SCANCODE_F17 = 108},
	{SDL_SCANCODE_F18 = 109},
	{SDL_SCANCODE_F19 = 110},
	{SDL_SCANCODE_F20 = 111},
	{SDL_SCANCODE_F21 = 112},
	{SDL_SCANCODE_F22 = 113},
	{SDL_SCANCODE_F23 = 114},
	{SDL_SCANCODE_F24 = 115},
	{SDL_SCANCODE_EXECUTE = 116},
	{SDL_SCANCODE_HELP = 117},
	{SDL_SCANCODE_MENU = 118},
	{SDL_SCANCODE_SELECT = 119},
	{SDL_SCANCODE_STOP = 120},
	{SDL_SCANCODE_AGAIN = 121},
	{SDL_SCANCODE_UNDO = 122},
	{SDL_SCANCODE_CUT = 123},
	{SDL_SCANCODE_COPY = 124},
	{SDL_SCANCODE_PASTE = 125},
	{SDL_SCANCODE_FIND = 126},
	{SDL_SCANCODE_MUTE = 127},
	{SDL_SCANCODE_VOLUMEUP = 128},
	{SDL_SCANCODE_VOLUMEDOWN = 129},
	{SDL_SCANCODE_KP_COMMA = 133},
	{SDL_SCANCODE_KP_EQUALSAS400 = 134},
	{SDL_SCANCODE_INTERNATIONAL1 = 135},
	{SDL_SCANCODE_INTERNATIONAL2 = 136},
	{SDL_SCANCODE_INTERNATIONAL3 = 137},
	{SDL_SCANCODE_INTERNATIONAL4 = 138},
	{SDL_SCANCODE_INTERNATIONAL5 = 139},
	{SDL_SCANCODE_INTERNATIONAL6 = 140},
	{SDL_SCANCODE_INTERNATIONAL7 = 141},
	{SDL_SCANCODE_INTERNATIONAL8 = 142},
	{SDL_SCANCODE_INTERNATIONAL9 = 143},
	{SDL_SCANCODE_LANG1 = 144},
	{SDL_SCANCODE_LANG2 = 145},
	{SDL_SCANCODE_LANG3 = 146},
	{SDL_SCANCODE_LANG4 = 147},
	{SDL_SCANCODE_LANG5 = 148},
	{SDL_SCANCODE_LANG6 = 149},
	{SDL_SCANCODE_LANG7 = 150},
	{SDL_SCANCODE_LANG8 = 151},
	{SDL_SCANCODE_LANG9 = 152},
	{SDL_SCANCODE_ALTERASE = 153},
	{SDL_SCANCODE_SYSREQ = 154},
	{SDL_SCANCODE_CANCEL = 155},
	{SDL_SCANCODE_CLEAR = 156},
	{SDL_SCANCODE_PRIOR = 157},
	{SDL_SCANCODE_RETURN2 = 158},
	{SDL_SCANCODE_SEPARATOR = 159},
	{SDL_SCANCODE_OUT = 160},
	{SDL_SCANCODE_OPER = 161},
	{SDL_SCANCODE_CLEARAGAIN = 162},
	{SDL_SCANCODE_CRSEL = 163},
	{SDL_SCANCODE_EXSEL = 164},
	{SDL_SCANCODE_KP_00 = 176},
	{SDL_SCANCODE_KP_000 = 177},
	{SDL_SCANCODE_THOUSANDSSEPARATOR = 178},
	{SDL_SCANCODE_DECIMALSEPARATOR = 179},
	{SDL_SCANCODE_CURRENCYUNIT = 180},
	{SDL_SCANCODE_CURRENCYSUBUNIT = 181},
	{SDL_SCANCODE_KP_LEFTPAREN = 182},
	{SDL_SCANCODE_KP_RIGHTPAREN = 183},
	{SDL_SCANCODE_KP_LEFTBRACE = 184},
	{SDL_SCANCODE_KP_RIGHTBRACE = 185},
	{SDL_SCANCODE_KP_TAB = 186},
	{SDL_SCANCODE_KP_BACKSPACE = 187},
	{SDL_SCANCODE_KP_A = 188},
	{SDL_SCANCODE_KP_B = 189},
	{SDL_SCANCODE_KP_C = 190},
	{SDL_SCANCODE_KP_D = 191},
	{SDL_SCANCODE_KP_E = 192},
	{SDL_SCANCODE_KP_F = 193},
	{SDL_SCANCODE_KP_XOR = 194},
	{SDL_SCANCODE_KP_POWER = 195},
	{SDL_SCANCODE_KP_PERCENT = 196},
	{SDL_SCANCODE_KP_LESS = 197},
	{SDL_SCANCODE_KP_GREATER = 198},
	{SDL_SCANCODE_KP_AMPERSAND = 199},
	{SDL_SCANCODE_KP_DBLAMPERSAND = 200},
	{SDL_SCANCODE_KP_VERTICALBAR = 201},
	{SDL_SCANCODE_KP_DBLVERTICALBAR = 202},
	{SDL_SCANCODE_KP_COLON = 203},
	{SDL_SCANCODE_KP_HASH = 204},
	{SDL_SCANCODE_KP_SPACE = 205},
	{SDL_SCANCODE_KP_AT = 206},
	{SDL_SCANCODE_KP_EXCLAM = 207},
	{SDL_SCANCODE_KP_MEMSTORE = 208},
	{SDL_SCANCODE_KP_MEMRECALL = 209},
	{SDL_SCANCODE_KP_MEMCLEAR = 210},
	{SDL_SCANCODE_KP_MEMADD = 211},
	{SDL_SCANCODE_KP_MEMSUBTRACT = 212},
	{SDL_SCANCODE_KP_MEMMULTIPLY = 213},
	{SDL_SCANCODE_KP_MEMDIVIDE = 214},
	{SDL_SCANCODE_KP_PLUSMINUS = 215},
	{SDL_SCANCODE_KP_CLEAR = 216},
	{SDL_SCANCODE_KP_CLEARENTRY = 217},
	{SDL_SCANCODE_KP_BINARY = 218},
	{SDL_SCANCODE_KP_OCTAL = 219},
	{SDL_SCANCODE_KP_DECIMAL = 220},
	{SDL_SCANCODE_KP_HEXADECIMAL = 221},
	{SDL_SCANCODE_LCTRL = 224},
	{SDL_SCANCODE_LSHIFT = 225},
	{SDL_SCANCODE_LALT = 226},
	{SDL_SCANCODE_LGUI = 227},
	{SDL_SCANCODE_RCTRL = 228},
	{SDL_SCANCODE_RSHIFT = 229},
	{SDL_SCANCODE_RALT = 230},
	{SDL_SCANCODE_RGUI = 231},
	{SDL_SCANCODE_MODE = 257},
	{SDL_SCANCODE_AUDIONEXT = 258},
	{SDL_SCANCODE_AUDIOPREV = 259},
	{SDL_SCANCODE_AUDIOSTOP = 260},
	{SDL_SCANCODE_AUDIOPLAY = 261},
	{SDL_SCANCODE_AUDIOMUTE = 262},
	{SDL_SCANCODE_MEDIASELECT = 263},
	{SDL_SCANCODE_WWW = 264},
	{SDL_SCANCODE_MAIL = 265},
	{SDL_SCANCODE_CALCULATOR = 266},
	{SDL_SCANCODE_COMPUTER = 267},
	{SDL_SCANCODE_AC_SEARCH = 268},
	{SDL_SCANCODE_AC_HOME = 269},
	{SDL_SCANCODE_AC_BACK = 270},
	{SDL_SCANCODE_AC_FORWARD = 271},
	{SDL_SCANCODE_AC_STOP = 272},
	{SDL_SCANCODE_AC_REFRESH = 273},
	{SDL_SCANCODE_AC_BOOKMARKS = 274},
	{SDL_SCANCODE_BRIGHTNESSDOWN = 275},
	{SDL_SCANCODE_BRIGHTNESSUP = 276},
	{SDL_SCANCODE_DISPLAYSWITCH = 277},
	{SDL_SCANCODE_KBDILLUMTOGGLE = 278},
	{SDL_SCANCODE_KBDILLUMDOWN = 279},
	{SDL_SCANCODE_KBDILLUMUP = 280},
	{SDL_SCANCODE_EJECT = 281},
	{SDL_SCANCODE_SLEEP = 282},
	{SDL_SCANCODE_APP1 = 283},
	{SDL_SCANCODE_APP2 = 284},
	{SDL_SCANCODE_AUDIOREWIND = 285},
	{SDL_SCANCODE_AUDIOFASTFORWARD = 286},
	{SDL_SCANCODE_SOFTLEFT = 287},
	{SDL_SCANCODE_SOFTRIGHT = 288},
	{SDL_SCANCODE_CALL = 289},
	{SDL_SCANCODE_ENDCALL = 290},
	{SDL_NUM_SCANCODES = 512}
}
ffi.enum{
	{SDLK_UNKNOWN = 0},
	{SDLK_RETURN = ('\r'):byte()},
	{SDLK_ESCAPE = ('\x1B'):byte()},
	{SDLK_BACKSPACE = ('\b'):byte()},
	{SDLK_TAB = ('\t'):byte()},
	{SDLK_SPACE = (' '):byte()},
	{SDLK_EXCLAIM = ('!'):byte()},
	{SDLK_QUOTEDBL = ('"'):byte()},
	{SDLK_HASH = ('#'):byte()},
	{SDLK_PERCENT = ('%'):byte()},
	{SDLK_DOLLAR = ('$'):byte()},
	{SDLK_AMPERSAND = ('&'):byte()},
	{SDLK_QUOTE = ('\''):byte()},
	{SDLK_LEFTPAREN = ('('):byte()},
	{SDLK_RIGHTPAREN = (')'):byte()},
	{SDLK_ASTERISK = ('*'):byte()},
	{SDLK_PLUS = ('+'):byte()},
	{SDLK_COMMA = (','):byte()},
	{SDLK_MINUS = ('-'):byte()},
	{SDLK_PERIOD = ('.'):byte()},
	{SDLK_SLASH = ('/'):byte()},
	{SDLK_0 = ('0'):byte()},
	{SDLK_1 = ('1'):byte()},
	{SDLK_2 = ('2'):byte()},
	{SDLK_3 = ('3'):byte()},
	{SDLK_4 = ('4'):byte()},
	{SDLK_5 = ('5'):byte()},
	{SDLK_6 = ('6'):byte()},
	{SDLK_7 = ('7'):byte()},
	{SDLK_8 = ('8'):byte()},
	{SDLK_9 = ('9'):byte()},
	{SDLK_COLON = (':'):byte()},
	{SDLK_SEMICOLON = (';'):byte()},
	{SDLK_LESS = ('<'):byte()},
	{SDLK_EQUALS = ('='):byte()},
	{SDLK_GREATER = ('>'):byte()},
	{SDLK_QUESTION = ('?'):byte()},
	{SDLK_AT = ('@'):byte()},
	{SDLK_LEFTBRACKET = ('['):byte()},
	{SDLK_BACKSLASH = ('\\'):byte()},
	{SDLK_RIGHTBRACKET = (']'):byte()},
	{SDLK_CARET = ('^'):byte()},
	{SDLK_UNDERSCORE = ('_'):byte()},
	{SDLK_BACKQUOTE = ('`'):byte()},
	{SDLK_a = ('a'):byte()},
	{SDLK_b = ('b'):byte()},
	{SDLK_c = ('c'):byte()},
	{SDLK_d = ('d'):byte()},
	{SDLK_e = ('e'):byte()},
	{SDLK_f = ('f'):byte()},
	{SDLK_g = ('g'):byte()},
	{SDLK_h = ('h'):byte()},
	{SDLK_i = ('i'):byte()},
	{SDLK_j = ('j'):byte()},
	{SDLK_k = ('k'):byte()},
	{SDLK_l = ('l'):byte()},
	{SDLK_m = ('m'):byte()},
	{SDLK_n = ('n'):byte()},
	{SDLK_o = ('o'):byte()},
	{SDLK_p = ('p'):byte()},
	{SDLK_q = ('q'):byte()},
	{SDLK_r = ('r'):byte()},
	{SDLK_s = ('s'):byte()},
	{SDLK_t = ('t'):byte()},
	{SDLK_u = ('u'):byte()},
	{SDLK_v = ('v'):byte()},
	{SDLK_w = ('w'):byte()},
	{SDLK_x = ('x'):byte()},
	{SDLK_y = ('y'):byte()},
	{SDLK_z = ('z'):byte()},
	{SDLK_CAPSLOCK = 1073741881},	--(SDL_SCANCODE_CAPSLOCK | (1<<30)) ,
	'SDLK_F1',						--(SDL_SCANCODE_F1 | (1<<30)) ,
	'SDLK_F2',						--(SDL_SCANCODE_F2 | (1<<30)) ,
	'SDLK_F3',						--(SDL_SCANCODE_F3 | (1<<30)) ,
	'SDLK_F4',						--(SDL_SCANCODE_F4 | (1<<30)) ,
	'SDLK_F5',						--(SDL_SCANCODE_F5 | (1<<30)) ,
	'SDLK_F6',						--(SDL_SCANCODE_F6 | (1<<30)) ,
	'SDLK_F7',						--(SDL_SCANCODE_F7 | (1<<30)) ,
	'SDLK_F8',						--(SDL_SCANCODE_F8 | (1<<30)) ,
	'SDLK_F9',						--(SDL_SCANCODE_F9 | (1<<30)) ,
	'SDLK_F10',						--(SDL_SCANCODE_F10 | (1<<30)) ,
	'SDLK_F11',						--(SDL_SCANCODE_F11 | (1<<30)) ,
	'SDLK_F12',						--(SDL_SCANCODE_F12 | (1<<30)) ,
	'SDLK_PRINTSCREEN',				--(SDL_SCANCODE_PRINTSCREEN | (1<<30)) ,
	'SDLK_SCROLLLOCK',				--(SDL_SCANCODE_SCROLLLOCK | (1<<30)) ,
	'SDLK_PAUSE',						--(SDL_SCANCODE_PAUSE | (1<<30)) ,
	'SDLK_INSERT',					--(SDL_SCANCODE_INSERT | (1<<30)) ,
	'SDLK_HOME',						--(SDL_SCANCODE_HOME | (1<<30)) ,
	'SDLK_PAGEUP',					--(SDL_SCANCODE_PAGEUP | (1<<30)) ,
	{SDLK_DELETE = ('\x7F'):byte()},
	{SDLK_END = 1073741901},	--(SDL_SCANCODE_END | (1<<30)) ,
	'SDLK_PAGEDOWN', 					--(SDL_SCANCODE_PAGEDOWN | (1<<30)) ,
	'SDLK_RIGHT', 					--(SDL_SCANCODE_RIGHT | (1<<30)) ,
	'SDLK_LEFT', 						--(SDL_SCANCODE_LEFT | (1<<30)) ,
	'SDLK_DOWN', 						--(SDL_SCANCODE_DOWN | (1<<30)) ,
	'SDLK_UP', 						--(SDL_SCANCODE_UP | (1<<30)) ,
	'SDLK_NUMLOCKCLEAR',				--(SDL_SCANCODE_NUMLOCKCLEAR | (1<<30)) ,
	'SDLK_KP_DIVIDE',					--(SDL_SCANCODE_KP_DIVIDE | (1<<30)) ,
	'SDLK_KP_MULTIPLY',				--(SDL_SCANCODE_KP_MULTIPLY | (1<<30)) ,
	'SDLK_KP_MINUS',					--(SDL_SCANCODE_KP_MINUS | (1<<30)) ,
	'SDLK_KP_PLUS',					--(SDL_SCANCODE_KP_PLUS | (1<<30)) ,
	'SDLK_KP_ENTER',					--(SDL_SCANCODE_KP_ENTER | (1<<30)) ,
	'SDLK_KP_1',						--(SDL_SCANCODE_KP_1 | (1<<30)) ,
	'SDLK_KP_2',						--(SDL_SCANCODE_KP_2 | (1<<30)) ,
	'SDLK_KP_3',						--(SDL_SCANCODE_KP_3 | (1<<30)) ,
	'SDLK_KP_4',						--(SDL_SCANCODE_KP_4 | (1<<30)) ,
	'SDLK_KP_5',						--(SDL_SCANCODE_KP_5 | (1<<30)) ,
	'SDLK_KP_6',						--(SDL_SCANCODE_KP_6 | (1<<30)) ,
	'SDLK_KP_7',						--(SDL_SCANCODE_KP_7 | (1<<30)) ,
	'SDLK_KP_8',						--(SDL_SCANCODE_KP_8 | (1<<30)) ,
	'SDLK_KP_9',						--(SDL_SCANCODE_KP_9 | (1<<30)) ,
	'SDLK_KP_0',						--(SDL_SCANCODE_KP_0 | (1<<30)) ,
	'SDLK_KP_PERIOD',					--(SDL_SCANCODE_KP_PERIOD | (1<<30)) ,

	{SDLK_APPLICATION = 1073741925},	--(SDL_SCANCODE_APPLICATION | (1<<30)) ,
	'SDLK_POWER',						--(SDL_SCANCODE_POWER | (1<<30)) ,
	'SDLK_KP_EQUALS',					--(SDL_SCANCODE_KP_EQUALS | (1<<30)) ,
	'SDLK_F13',						--(SDL_SCANCODE_F13 | (1<<30)) ,
	'SDLK_F14',						--(SDL_SCANCODE_F14 | (1<<30)) ,
	'SDLK_F15',						--(SDL_SCANCODE_F15 | (1<<30)) ,
	'SDLK_F16',						--(SDL_SCANCODE_F16 | (1<<30)) ,
	'SDLK_F17',						--(SDL_SCANCODE_F17 | (1<<30)) ,
	'SDLK_F18',						--(SDL_SCANCODE_F18 | (1<<30)) ,
	'SDLK_F19',						--(SDL_SCANCODE_F19 | (1<<30)) ,
	'SDLK_F20',						--(SDL_SCANCODE_F20 | (1<<30)) ,
	'SDLK_F21',						--(SDL_SCANCODE_F21 | (1<<30)) ,
	'SDLK_F22',						--(SDL_SCANCODE_F22 | (1<<30)) ,
	'SDLK_F23',						--(SDL_SCANCODE_F23 | (1<<30)) ,
	'SDLK_F24',						--(SDL_SCANCODE_F24 | (1<<30)) ,
	'SDLK_EXECUTE',					--(SDL_SCANCODE_EXECUTE | (1<<30)) ,
	'SDLK_HELP',						--(SDL_SCANCODE_HELP | (1<<30)) ,
	'SDLK_MENU',						--(SDL_SCANCODE_MENU | (1<<30)) ,
	'SDLK_SELECT',					--(SDL_SCANCODE_SELECT | (1<<30)) ,
	'SDLK_STOP',						--(SDL_SCANCODE_STOP | (1<<30)) ,
	'SDLK_AGAIN',						--(SDL_SCANCODE_AGAIN | (1<<30)) ,
	'SDLK_UNDO',						--(SDL_SCANCODE_UNDO | (1<<30)) ,
	'SDLK_CUT',						--(SDL_SCANCODE_CUT | (1<<30)) ,
	'SDLK_COPY',						--(SDL_SCANCODE_COPY | (1<<30)) ,
	'SDLK_PASTE',						--(SDL_SCANCODE_PASTE | (1<<30)) ,
	'SDLK_FIND',						--(SDL_SCANCODE_FIND | (1<<30)) ,
	'SDLK_MUTE',						--(SDL_SCANCODE_MUTE | (1<<30)) ,
	'SDLK_VOLUMEUP',					--(SDL_SCANCODE_VOLUMEUP | (1<<30)) ,
	'SDLK_VOLUMEDOWN',				--(SDL_SCANCODE_VOLUMEDOWN | (1<<30)) ,
	'SDLK_KP_COMMA',					--(SDL_SCANCODE_KP_COMMA | (1<<30)) ,
	'SDLK_KP_EQUALSAS400',			--(SDL_SCANCODE_KP_EQUALSAS400 | (1<<30)) ,

	{SDLK_ALTERASE = 1073741977},		--(SDL_SCANCODE_ALTERASE | (1<<30)) ,
	'SDLK_SYSREQ',					--(SDL_SCANCODE_SYSREQ | (1<<30)) ,
	'SDLK_CANCEL',					--(SDL_SCANCODE_CANCEL | (1<<30)) ,
	'SDLK_CLEAR',						--(SDL_SCANCODE_CLEAR | (1<<30)) ,
	'SDLK_PRIOR',						--(SDL_SCANCODE_PRIOR | (1<<30)) ,
	'SDLK_RETURN2',					--(SDL_SCANCODE_RETURN2 | (1<<30)) ,
	'SDLK_SEPARATOR',					--(SDL_SCANCODE_SEPARATOR | (1<<30)) ,
	'SDLK_OUT',						--(SDL_SCANCODE_OUT | (1<<30)) ,
	'SDLK_OPER',						--(SDL_SCANCODE_OPER | (1<<30)) ,
	'SDLK_CLEARAGAIN',				--(SDL_SCANCODE_CLEARAGAIN | (1<<30)) ,
	'SDLK_CRSEL',						--(SDL_SCANCODE_CRSEL | (1<<30)) ,
	'SDLK_EXSEL',						--(SDL_SCANCODE_EXSEL | (1<<30)) ,
	'SDLK_KP_00',						--(SDL_SCANCODE_KP_00 | (1<<30)) ,
	'SDLK_KP_000',					--(SDL_SCANCODE_KP_000 | (1<<30)) ,
	'SDLK_THOUSANDSSEPARATOR',		--(SDL_SCANCODE_THOUSANDSSEPARATOR | (1<<30)) ,
	'SDLK_DECIMALSEPARATOR',			--(SDL_SCANCODE_DECIMALSEPARATOR | (1<<30)) ,
	'SDLK_CURRENCYUNIT',				--(SDL_SCANCODE_CURRENCYUNIT | (1<<30)) ,
	'SDLK_CURRENCYSUBUNIT',			--(SDL_SCANCODE_CURRENCYSUBUNIT | (1<<30)) ,
	'SDLK_KP_LEFTPAREN',				--(SDL_SCANCODE_KP_LEFTPAREN | (1<<30)) ,
	'SDLK_KP_RIGHTPAREN',				--(SDL_SCANCODE_KP_RIGHTPAREN | (1<<30)) ,
	'SDLK_KP_LEFTBRACE',				--(SDL_SCANCODE_KP_LEFTBRACE | (1<<30)) ,
	'SDLK_KP_RIGHTBRACE',				--(SDL_SCANCODE_KP_RIGHTBRACE | (1<<30)) ,
	'SDLK_KP_TAB',					--(SDL_SCANCODE_KP_TAB | (1<<30)) ,
	'SDLK_KP_BACKSPACE',				--(SDL_SCANCODE_KP_BACKSPACE | (1<<30)) ,
	'SDLK_KP_A',						--(SDL_SCANCODE_KP_A | (1<<30)) ,
	'SDLK_KP_B',						--(SDL_SCANCODE_KP_B | (1<<30)) ,
	'SDLK_KP_C',						--(SDL_SCANCODE_KP_C | (1<<30)) ,
	'SDLK_KP_D',						--(SDL_SCANCODE_KP_D | (1<<30)) ,
	'SDLK_KP_E',						--(SDL_SCANCODE_KP_E | (1<<30)) ,
	'SDLK_KP_F',						--(SDL_SCANCODE_KP_F | (1<<30)) ,
	'SDLK_KP_XOR',					--(SDL_SCANCODE_KP_XOR | (1<<30)) ,
	'SDLK_KP_POWER',					--(SDL_SCANCODE_KP_POWER | (1<<30)) ,
	'SDLK_KP_PERCENT',				--(SDL_SCANCODE_KP_PERCENT | (1<<30)) ,
	'SDLK_KP_LESS',					--(SDL_SCANCODE_KP_LESS | (1<<30)) ,
	'SDLK_KP_GREATER',				--(SDL_SCANCODE_KP_GREATER | (1<<30)) ,
	'SDLK_KP_AMPERSAND',				--(SDL_SCANCODE_KP_AMPERSAND | (1<<30)) ,
	'SDLK_KP_DBLAMPERSAND',			--(SDL_SCANCODE_KP_DBLAMPERSAND | (1<<30)) ,
	'SDLK_KP_VERTICALBAR',			--(SDL_SCANCODE_KP_VERTICALBAR | (1<<30)) ,
	'SDLK_KP_DBLVERTICALBAR',			--(SDL_SCANCODE_KP_DBLVERTICALBAR | (1<<30)) ,
	'SDLK_KP_COLON',					--(SDL_SCANCODE_KP_COLON | (1<<30)) ,
	'SDLK_KP_HASH',					--(SDL_SCANCODE_KP_HASH | (1<<30)) ,
	'SDLK_KP_SPACE',					--(SDL_SCANCODE_KP_SPACE | (1<<30)) ,
	'SDLK_KP_AT',						--(SDL_SCANCODE_KP_AT | (1<<30)) ,
	'SDLK_KP_EXCLAM',					--(SDL_SCANCODE_KP_EXCLAM | (1<<30)) ,
	'SDLK_KP_MEMSTORE',				--(SDL_SCANCODE_KP_MEMSTORE | (1<<30)) ,
	'SDLK_KP_MEMRECALL',				--(SDL_SCANCODE_KP_MEMRECALL | (1<<30)) ,
	'SDLK_KP_MEMCLEAR',				--(SDL_SCANCODE_KP_MEMCLEAR | (1<<30)) ,
	'SDLK_KP_MEMADD',					--(SDL_SCANCODE_KP_MEMADD | (1<<30)) ,
	'SDLK_KP_MEMSUBTRACT',			--(SDL_SCANCODE_KP_MEMSUBTRACT | (1<<30)) ,
	'SDLK_KP_MEMMULTIPLY',			--(SDL_SCANCODE_KP_MEMMULTIPLY | (1<<30)) ,
	'SDLK_KP_MEMDIVIDE',				--(SDL_SCANCODE_KP_MEMDIVIDE | (1<<30)) ,
	'SDLK_KP_PLUSMINUS',				--(SDL_SCANCODE_KP_PLUSMINUS | (1<<30)) ,
	'SDLK_KP_CLEAR',					--(SDL_SCANCODE_KP_CLEAR | (1<<30)) ,
	'SDLK_KP_CLEARENTRY',				--(SDL_SCANCODE_KP_CLEARENTRY | (1<<30)) ,
	'SDLK_KP_BINARY',					--(SDL_SCANCODE_KP_BINARY | (1<<30)) ,
	'SDLK_KP_OCTAL',					--(SDL_SCANCODE_KP_OCTAL | (1<<30)) ,
	'SDLK_KP_DECIMAL',				--(SDL_SCANCODE_KP_DECIMAL | (1<<30)) ,
	'SDLK_KP_HEXADECIMAL',			--(SDL_SCANCODE_KP_HEXADECIMAL | (1<<30)) ,
	'SDLK_LCTRL',						--(SDL_SCANCODE_LCTRL | (1<<30)) ,
	'SDLK_LSHIFT',					--(SDL_SCANCODE_LSHIFT | (1<<30)) ,
	'SDLK_LALT',						--(SDL_SCANCODE_LALT | (1<<30)) ,
	'SDLK_LGUI',						--(SDL_SCANCODE_LGUI | (1<<30)) ,
	'SDLK_RCTRL',						--(SDL_SCANCODE_RCTRL | (1<<30)) ,
	'SDLK_RSHIFT',					--(SDL_SCANCODE_RSHIFT | (1<<30)) ,
	'SDLK_RALT',						--(SDL_SCANCODE_RALT | (1<<30)) ,
	'SDLK_RGUI',						--(SDL_SCANCODE_RGUI | (1<<30)) ,
	'SDLK_MODE',						--(SDL_SCANCODE_MODE | (1<<30)) ,
	'SDLK_AUDIONEXT',					--(SDL_SCANCODE_AUDIONEXT | (1<<30)) ,
	'SDLK_AUDIOPREV',					--(SDL_SCANCODE_AUDIOPREV | (1<<30)) ,
	'SDLK_AUDIOSTOP',					--(SDL_SCANCODE_AUDIOSTOP | (1<<30)) ,
	'SDLK_AUDIOPLAY',					--(SDL_SCANCODE_AUDIOPLAY | (1<<30)) ,
	'SDLK_AUDIOMUTE',					--(SDL_SCANCODE_AUDIOMUTE | (1<<30)) ,
	'SDLK_MEDIASELECT',				--(SDL_SCANCODE_MEDIASELECT | (1<<30)) ,
	'SDLK_WWW',						--(SDL_SCANCODE_WWW | (1<<30)) ,
	'SDLK_MAIL',						--(SDL_SCANCODE_MAIL | (1<<30)) ,
	'SDLK_CALCULATOR',				--(SDL_SCANCODE_CALCULATOR | (1<<30)) ,
	'SDLK_COMPUTER',					--(SDL_SCANCODE_COMPUTER | (1<<30)) ,
	'SDLK_AC_SEARCH',					--(SDL_SCANCODE_AC_SEARCH | (1<<30)) ,
	'SDLK_AC_HOME',					--(SDL_SCANCODE_AC_HOME | (1<<30)) ,
	'SDLK_AC_BACK',					--(SDL_SCANCODE_AC_BACK | (1<<30)) ,
	'SDLK_AC_FORWARD',				--(SDL_SCANCODE_AC_FORWARD | (1<<30)) ,
	'SDLK_AC_STOP',					--(SDL_SCANCODE_AC_STOP | (1<<30)) ,
	'SDLK_AC_REFRESH',				--(SDL_SCANCODE_AC_REFRESH | (1<<30)) ,
	'SDLK_AC_BOOKMARKS',				--(SDL_SCANCODE_AC_BOOKMARKS | (1<<30)) ,
	'SDLK_BRIGHTNESSDOWN',			--(SDL_SCANCODE_BRIGHTNESSDOWN | (1<<30)) ,
	'SDLK_BRIGHTNESSUP',				--(SDL_SCANCODE_BRIGHTNESSUP | (1<<30)) ,
	'SDLK_DISPLAYSWITCH',				--(SDL_SCANCODE_DISPLAYSWITCH | (1<<30)) ,
	'SDLK_KBDILLUMTOGGLE',			--(SDL_SCANCODE_KBDILLUMTOGGLE | (1<<30)) ,
	'SDLK_KBDILLUMDOWN',				--(SDL_SCANCODE_KBDILLUMDOWN | (1<<30)) ,
	'SDLK_KBDILLUMUP',				--(SDL_SCANCODE_KBDILLUMUP | (1<<30)) ,
	'SDLK_EJECT',						--(SDL_SCANCODE_EJECT | (1<<30)) ,
	'SDLK_SLEEP',						--(SDL_SCANCODE_SLEEP | (1<<30)) ,
	'SDLK_APP1',						--(SDL_SCANCODE_APP1 | (1<<30)) ,
	'SDLK_APP2',						--(SDL_SCANCODE_APP2 | (1<<30)) ,
	'SDLK_AUDIOREWIND',				--(SDL_SCANCODE_AUDIOREWIND | (1<<30)) ,
	'SDLK_AUDIOFASTFORWARD',			--(SDL_SCANCODE_AUDIOFASTFORWARD | (1<<30)) ,
	'SDLK_SOFTLEFT',					--(SDL_SCANCODE_SOFTLEFT | (1<<30)) ,
	'SDLK_SOFTRIGHT',					--(SDL_SCANCODE_SOFTRIGHT | (1<<30)) ,
	'SDLK_CALL',						--(SDL_SCANCODE_CALL | (1<<30)) ,
	'SDLK_ENDCALL',					--(SDL_SCANCODE_ENDCALL | (1<<30))
}
ffi.enum{
	{KMOD_NONE = 0x0000},
	{KMOD_LSHIFT = 0x0001},
	{KMOD_RSHIFT = 0x0002},
	{KMOD_LCTRL = 0x0040},
	{KMOD_RCTRL = 0x0080},
	{KMOD_LALT = 0x0100},
	{KMOD_RALT = 0x0200},
	{KMOD_LGUI = 0x0400},
	{KMOD_RGUI = 0x0800},
	{KMOD_NUM = 0x1000},
	{KMOD_CAPS = 0x2000},
	{KMOD_MODE = 0x4000},
	{KMOD_SCROLL = 0x8000},
	{KMOD_CTRL = 0x00c0},				--KMOD_LCTRL | KMOD_RCTRL,
	{KMOD_SHIFT = 0x0003},			--KMOD_LSHIFT | KMOD_RSHIFT,
	{KMOD_ALT = 0x0300},				--KMOD_LALT | KMOD_RALT,
	{KMOD_GUI = 0x0c00},				--KMOD_LGUI | KMOD_RGUI,
	{KMOD_RESERVED = 0x8000},			--KMOD_SCROLL
}
ffi.enum{ {SDL_RELEASED = 0} }
ffi.enum{ {SDL_PRESSED = 1} }
ffi.enum{
	{SDL_FIRSTEVENT = 0},
	{SDL_QUIT = 0x100},
	'SDL_APP_TERMINATING',
	'SDL_APP_LOWMEMORY',
	'SDL_APP_WILLENTERBACKGROUND',
	'SDL_APP_DIDENTERBACKGROUND',
	'SDL_APP_WILLENTERFOREGROUND',
	'SDL_APP_DIDENTERFOREGROUND',
	'SDL_LOCALECHANGED',
	{SDL_DISPLAYEVENT = 0x150},
	{SDL_WINDOWEVENT = 0x200},
	'SDL_SYSWMEVENT',
	{SDL_KEYDOWN = 0x300},
	'SDL_KEYUP',
	'SDL_TEXTEDITING',
	'SDL_TEXTINPUT',
	'SDL_KEYMAPCHANGED',
	'SDL_TEXTEDITING_EXT',
	{SDL_MOUSEMOTION = 0x400},
	'SDL_MOUSEBUTTONDOWN',
	'SDL_MOUSEBUTTONUP',
	'SDL_MOUSEWHEEL',
	{SDL_JOYAXISMOTION = 0x600},
	'SDL_JOYBALLMOTION',
	'SDL_JOYHATMOTION',
	'SDL_JOYBUTTONDOWN',
	'SDL_JOYBUTTONUP',
	'SDL_JOYDEVICEADDED',
	'SDL_JOYDEVICEREMOVED',
	'SDL_JOYBATTERYUPDATED',
	{SDL_CONTROLLERAXISMOTION = 0x650},
	'SDL_CONTROLLERBUTTONDOWN',
	'SDL_CONTROLLERBUTTONUP',
	'SDL_CONTROLLERDEVICEADDED',
	'SDL_CONTROLLERDEVICEREMOVED',
	'SDL_CONTROLLERDEVICEREMAPPED',
	'SDL_CONTROLLERTOUCHPADDOWN',
	'SDL_CONTROLLERTOUCHPADMOTION',
	'SDL_CONTROLLERTOUCHPADUP',
	'SDL_CONTROLLERSENSORUPDATE',
	{SDL_FINGERDOWN = 0x700},
	'SDL_FINGERUP',
	'SDL_FINGERMOTION',
	{SDL_DOLLARGESTURE = 0x800},
	'SDL_DOLLARRECORD',
	'SDL_MULTIGESTURE',
	{SDL_CLIPBOARDUPDATE = 0x900},
	{SDL_DROPFILE = 0x1000},
	'SDL_DROPTEXT',
	'SDL_DROPBEGIN',
	'SDL_DROPCOMPLETE',
	{SDL_AUDIODEVICEADDED = 0x1100},
	'SDL_AUDIODEVICEREMOVED',
	{SDL_SENSORUPDATE = 0x1200},
	{SDL_RENDER_TARGETS_RESET = 0x2000},
	'SDL_RENDER_DEVICE_RESET',
	{SDL_POLLSENTINEL = 0x7F00},
	{SDL_USEREVENT = 0x8000},
	{SDL_LASTEVENT = 0xFFFF}
}
ffi.enum{
	{SDL_WINDOW_FULLSCREEN = 0x00000001},
	{SDL_WINDOW_OPENGL = 0x00000002},
	{SDL_WINDOW_SHOWN = 0x00000004},
	{SDL_WINDOW_HIDDEN = 0x00000008},
	{SDL_WINDOW_BORDERLESS = 0x00000010},
	{SDL_WINDOW_RESIZABLE = 0x00000020},
	{SDL_WINDOW_MINIMIZED = 0x00000040},
	{SDL_WINDOW_MAXIMIZED = 0x00000080},
	{SDL_WINDOW_MOUSE_GRABBED = 0x00000100},
	{SDL_WINDOW_INPUT_FOCUS = 0x00000200},
	{SDL_WINDOW_MOUSE_FOCUS = 0x00000400},
	{SDL_WINDOW_FULLSCREEN_DESKTOP = 0x00001001},	--( SDL_WINDOW_FULLSCREEN | 0x00001000 ),
	{SDL_WINDOW_FOREIGN = 0x00000800},
	{SDL_WINDOW_ALLOW_HIGHDPI = 0x00002000},
	{SDL_WINDOW_MOUSE_CAPTURE = 0x00004000},
	{SDL_WINDOW_ALWAYS_ON_TOP = 0x00008000},
	{SDL_WINDOW_SKIP_TASKBAR = 0x00010000},
	{SDL_WINDOW_UTILITY = 0x00020000},
	{SDL_WINDOW_TOOLTIP = 0x00040000},
	{SDL_WINDOW_POPUP_MENU = 0x00080000},
	{SDL_WINDOW_KEYBOARD_GRABBED = 0x00100000},
	{SDL_WINDOW_VULKAN = 0x10000000},
	{SDL_WINDOW_METAL = 0x20000000},
	{SDL_WINDOW_INPUT_GRABBED = 0x00000100},	--SDL_WINDOW_MOUSE_GRABBED
}
ffi.enum{ {SDL_WINDOWPOS_UNDEFINED_MASK = 0x1FFF0000} }
ffi.enum{ {SDL_WINDOWPOS_CENTERED_MASK = 0x2FFF0000} }
ffi.enum{
	'SDL_WINDOWEVENT_NONE',
	'SDL_WINDOWEVENT_SHOWN',
	'SDL_WINDOWEVENT_HIDDEN',
	'SDL_WINDOWEVENT_EXPOSED',
	'SDL_WINDOWEVENT_MOVED',
	'SDL_WINDOWEVENT_RESIZED',
	'SDL_WINDOWEVENT_SIZE_CHANGED',
	'SDL_WINDOWEVENT_MINIMIZED',
	'SDL_WINDOWEVENT_MAXIMIZED',
	'SDL_WINDOWEVENT_RESTORED',
	'SDL_WINDOWEVENT_ENTER',
	'SDL_WINDOWEVENT_LEAVE',
	'SDL_WINDOWEVENT_FOCUS_GAINED',
	'SDL_WINDOWEVENT_FOCUS_LOST',
	'SDL_WINDOWEVENT_CLOSE',
	'SDL_WINDOWEVENT_TAKE_FOCUS',
	'SDL_WINDOWEVENT_HIT_TEST',
	'SDL_WINDOWEVENT_ICCPROF_CHANGED',
	'SDL_WINDOWEVENT_DISPLAY_CHANGED',
}
ffi.enum{
	'SDL_DISPLAYEVENT_NONE',
	'SDL_DISPLAYEVENT_ORIENTATION',
	'SDL_DISPLAYEVENT_CONNECTED',
	'SDL_DISPLAYEVENT_DISCONNECTED',
	'SDL_DISPLAYEVENT_MOVED',
}
ffi.enum{
	'SDL_ORIENTATION_UNKNOWN',
	'SDL_ORIENTATION_LANDSCAPE',
	'SDL_ORIENTATION_LANDSCAPE_FLIPPED',
	'SDL_ORIENTATION_PORTRAIT',
	'SDL_ORIENTATION_PORTRAIT_FLIPPED',
}
ffi.enum{
	'SDL_FLASH_CANCEL',
	'SDL_FLASH_BRIEFLY',
	'SDL_FLASH_UNTIL_FOCUSED',
}
ffi.enum{
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
	'SDL_GL_CONTEXT_EGL',
	'SDL_GL_CONTEXT_FLAGS',
	'SDL_GL_CONTEXT_PROFILE_MASK',
	'SDL_GL_SHARE_WITH_CURRENT_CONTEXT',
	'SDL_GL_FRAMEBUFFER_SRGB_CAPABLE',
	'SDL_GL_CONTEXT_RELEASE_BEHAVIOR',
	'SDL_GL_CONTEXT_RESET_NOTIFICATION',
	'SDL_GL_CONTEXT_NO_ERROR',
	'SDL_GL_FLOATBUFFERS',
}
ffi.enum{
	{SDL_GL_CONTEXT_PROFILE_CORE = 0x0001},
	{SDL_GL_CONTEXT_PROFILE_COMPATIBILITY = 0x0002},
	{SDL_GL_CONTEXT_PROFILE_ES = 0x0004}
}
ffi.enum{
	{SDL_GL_CONTEXT_DEBUG_FLAG = 0x0001},
	{SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = 0x0002},
	{SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG = 0x0004},
	{SDL_GL_CONTEXT_RESET_ISOLATION_FLAG = 0x0008}
}
ffi.enum{
	{SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE = 0x0000},
	{SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH = 0x0001}
}
ffi.enum{
	{SDL_GL_CONTEXT_RESET_NO_NOTIFICATION = 0x0000},
	{SDL_GL_CONTEXT_RESET_LOSE_CONTEXT = 0x0001}
}
ffi.enum{ {SDL_BUTTON_LEFT = 1} }
ffi.enum{ {SDL_BUTTON_MIDDLE = 2} }
ffi.enum{ {SDL_BUTTON_RIGHT = 3} }
ffi.enum{ {SDL_BUTTON_X1 = 4} }
ffi.enum{ {SDL_BUTTON_X2 = 5} }
ffi.enum{ {SDL_BUTTON_LMASK = 1} }
ffi.enum{ {SDL_BUTTON_MMASK = 2} }
ffi.enum{ {SDL_BUTTON_RMASK = 4} }
ffi.enum{ {SDL_BUTTON_X1MASK = 8} }
ffi.enum{ {SDL_BUTTON_X2MASK = 16} }
ffi.enum{ {SDL_MAJOR_VERSION = 2} }
ffi.enum{ {SDL_MINOR_VERSION = 28} }
ffi.enum{ {SDL_PATCHLEVEL = 3} }
ffi.enum{ {SDL_COMPILEDVERSION = 4803} }
ffi.enum{ {SDL_TEXTEDITINGEVENT_TEXT_SIZE = 32} }
ffi.enum{ {SDL_TEXTINPUTEVENT_TEXT_SIZE = 32} }
ffi.enum{
	{SDL_WINDOW_FULLSCREEN = 0x00000001},
	{SDL_WINDOW_OPENGL = 0x00000002},
	{SDL_WINDOW_SHOWN = 0x00000004},
	{SDL_WINDOW_HIDDEN = 0x00000008},
	{SDL_WINDOW_BORDERLESS = 0x00000010},
	{SDL_WINDOW_RESIZABLE = 0x00000020},
	{SDL_WINDOW_MINIMIZED = 0x00000040},
	{SDL_WINDOW_MAXIMIZED = 0x00000080},
	{SDL_WINDOW_INPUT_GRABBED = 0x00000100},
	{SDL_WINDOW_INPUT_FOCUS = 0x00000200},
	{SDL_WINDOW_MOUSE_FOCUS = 0x00000400},
	{SDL_WINDOW_FOREIGN = 0x00000800},
}

ffi.enum{
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
}

ffi.typedefs{
	{Sint8 = 'int8_t'},
	{Uint8 = 'uint8_t'},
	{Sint16 = 'int16_t'},
	{Uint16 = 'uint16_t'},
	{Sint32 = 'int32_t'},
	{Uint32 = 'uint32_t'},
	{Sint64 = 'int64_t'},
	{Uint64 = 'uint64_t'},
	{SDL_JoystickID = 'Sint32'},
	{SDL_JoystickType = 'int'},
	{SDL_JoystickPowerLevel = 'int'},
	{SDL_TouchID = 'Sint64'},
	{SDL_FingerID = 'Sint64'},
	{SDL_TouchDeviceType = 'int'},
}

ffi.cdef[[
struct SDL_Window {};
struct SDL_Thread {};
struct SDL_Renderer {};
struct SDL_Texture {};
struct SDL_iconv_t {};
struct SDL_SysWMmsg {};
struct SDL_Cursor {};
struct SDL_Joystick {};

typedef struct SDL_Finger {
	SDL_FingerID id;
	float x;
	float y;
	float pressure;
} SDL_Finger;
]]

ffi.typedefs{
	{SDL_GestureID = 'Sint64'},
	{SDL_bool = 'int'},
	{SDL_Keycode = 'Sint32'},
	{SDL_Scancode = 'int'},
	{SDL_KeyCode = 'int'},
	{SDL_Keymod = 'int'},
}

ffi.cdef[[
typedef struct SDL_Keysym {
	SDL_Scancode scancode;
	SDL_Keycode sym;
	Uint16 mod;
	Uint32 unused;
} SDL_Keysym;
typedef struct {
	Uint32 format;
	int w;
	int h;
	int refresh_rate;
	void *driverdata;
} SDL_DisplayMode;
]]

ffi.typedefs{
	{SDL_EventType = 'int'},
	{SDL_Window = 'struct SDL_Window'},
	{SDL_WindowFlags = 'int'},
	{SDL_WindowEventID = 'int'},
	{SDL_DisplayEventID = 'int'},
	{SDL_DisplayOrientation = 'int'},
	{SDL_FlashOperation = 'int'},
	{SDL_GLContext = 'void*'},
	{SDL_GLattr = 'int'},
	{SDL_GLprofile = 'int'},
	{SDL_GLcontextFlag = 'int'},
	{SDL_GLcontextReleaseFlag = 'int'},
	{SDL_GLContextResetNotification = 'int'},
}

ffi.cdef[[
typedef struct SDL_version {
	Uint8 major;
	Uint8 minor;
	Uint8 patch;
} SDL_version;
typedef struct SDL_CommonEvent {
	Uint32 type;
	Uint32 timestamp;
} SDL_CommonEvent;
typedef struct SDL_DisplayEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 display;
	Uint8 event;
	Uint8 padding1;
	Uint8 padding2;
	Uint8 padding3;
	Sint32 data1;
} SDL_DisplayEvent;
typedef struct SDL_WindowEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Uint8 event;
	Uint8 padding1;
	Uint8 padding2;
	Uint8 padding3;
	Sint32 data1;
	Sint32 data2;
} SDL_WindowEvent;
typedef struct SDL_KeyboardEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Uint8 state;
	Uint8 repeat;
	Uint8 padding2;
	Uint8 padding3;
	SDL_Keysym keysym;
} SDL_KeyboardEvent;
typedef struct SDL_TextEditingEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	char text[32];
	Sint32 start;
	Sint32 length;
} SDL_TextEditingEvent;
typedef struct SDL_TextEditingExtEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	char* text;
	Sint32 start;
	Sint32 length;
} SDL_TextEditingExtEvent;
typedef struct SDL_TextInputEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	char text[32];
} SDL_TextInputEvent;
typedef struct SDL_MouseMotionEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Uint32 which;
	Uint32 state;
	Sint32 x;
	Sint32 y;
	Sint32 xrel;
	Sint32 yrel;
} SDL_MouseMotionEvent;
typedef struct SDL_MouseButtonEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Uint32 which;
	Uint8 button;
	Uint8 state;
	Uint8 clicks;
	Uint8 padding1;
	Sint32 x;
	Sint32 y;
} SDL_MouseButtonEvent;
typedef struct SDL_MouseWheelEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Uint32 which;
	Sint32 x;
	Sint32 y;
	Uint32 direction;
	float preciseX;
	float preciseY;
	Sint32 mouseX;
	Sint32 mouseY;
} SDL_MouseWheelEvent;
typedef struct SDL_JoyAxisEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_JoystickID which;
	Uint8 axis;
	Uint8 padding1;
	Uint8 padding2;
	Uint8 padding3;
	Sint16 value;
	Uint16 padding4;
} SDL_JoyAxisEvent;
typedef struct SDL_JoyBallEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_JoystickID which;
	Uint8 ball;
	Uint8 padding1;
	Uint8 padding2;
	Uint8 padding3;
	Sint16 xrel;
	Sint16 yrel;
} SDL_JoyBallEvent;
typedef struct SDL_JoyHatEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_JoystickID which;
	Uint8 hat;
	Uint8 value;
	Uint8 padding1;
	Uint8 padding2;
} SDL_JoyHatEvent;
typedef struct SDL_JoyButtonEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_JoystickID which;
	Uint8 button;
	Uint8 state;
	Uint8 padding1;
	Uint8 padding2;
} SDL_JoyButtonEvent;
typedef struct SDL_JoyDeviceEvent {
	Uint32 type;
	Uint32 timestamp;
	Sint32 which;
} SDL_JoyDeviceEvent;
typedef struct SDL_JoyBatteryEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_JoystickID which;
	SDL_JoystickPowerLevel level;
} SDL_JoyBatteryEvent;
typedef struct SDL_ControllerAxisEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_JoystickID which;
	Uint8 axis;
	Uint8 padding1;
	Uint8 padding2;
	Uint8 padding3;
	Sint16 value;
	Uint16 padding4;
} SDL_ControllerAxisEvent;
typedef struct SDL_ControllerButtonEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_JoystickID which;
	Uint8 button;
	Uint8 state;
	Uint8 padding1;
	Uint8 padding2;
} SDL_ControllerButtonEvent;
typedef struct SDL_ControllerDeviceEvent {
	Uint32 type;
	Uint32 timestamp;
	Sint32 which;
} SDL_ControllerDeviceEvent;
typedef struct SDL_ControllerTouchpadEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_JoystickID which;
	Sint32 touchpad;
	Sint32 finger;
	float x;
	float y;
	float pressure;
} SDL_ControllerTouchpadEvent;
typedef struct SDL_ControllerSensorEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_JoystickID which;
	Sint32 sensor;
	float data[3];
	Uint64 timestamp_us;
} SDL_ControllerSensorEvent;
typedef struct SDL_AudioDeviceEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 which;
	Uint8 iscapture;
	Uint8 padding1;
	Uint8 padding2;
	Uint8 padding3;
} SDL_AudioDeviceEvent;
typedef struct SDL_TouchFingerEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_TouchID touchId;
	SDL_FingerID fingerId;
	float x;
	float y;
	float dx;
	float dy;
	float pressure;
	Uint32 windowID;
} SDL_TouchFingerEvent;
typedef struct SDL_MultiGestureEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_TouchID touchId;
	float dTheta;
	float dDist;
	float x;
	float y;
	Uint16 numFingers;
	Uint16 padding;
} SDL_MultiGestureEvent;
typedef struct SDL_DollarGestureEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_TouchID touchId;
	SDL_GestureID gestureId;
	Uint32 numFingers;
	float error;
	float x;
	float y;
} SDL_DollarGestureEvent;
typedef struct SDL_DropEvent {
	Uint32 type;
	Uint32 timestamp;
	char *file;
	Uint32 windowID;
} SDL_DropEvent;
typedef struct SDL_SensorEvent {
	Uint32 type;
	Uint32 timestamp;
	Sint32 which;
	float data[6];
	Uint64 timestamp_us;
} SDL_SensorEvent;
typedef struct SDL_QuitEvent {
	Uint32 type;
	Uint32 timestamp;
} SDL_QuitEvent;
typedef struct SDL_OSEvent {
	Uint32 type;
	Uint32 timestamp;
} SDL_OSEvent;
typedef struct SDL_UserEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Sint32 code;
	void *data1;
	void *data2;
} SDL_UserEvent;
struct SDL_SysWMmsg;
typedef struct SDL_SysWMmsg SDL_SysWMmsg;
typedef struct SDL_SysWMEvent {
	Uint32 type;
	Uint32 timestamp;
	SDL_SysWMmsg *msg;
} SDL_SysWMEvent;
typedef union SDL_Event {
	Uint32 type;
	SDL_CommonEvent common;
	SDL_DisplayEvent display;
	SDL_WindowEvent window;
	SDL_KeyboardEvent key;
	SDL_TextEditingEvent edit;
	SDL_TextEditingExtEvent editExt;
	SDL_TextInputEvent text;
	SDL_MouseMotionEvent motion;
	SDL_MouseButtonEvent button;
	SDL_MouseWheelEvent wheel;
	SDL_JoyAxisEvent jaxis;
	SDL_JoyBallEvent jball;
	SDL_JoyHatEvent jhat;
	SDL_JoyButtonEvent jbutton;
	SDL_JoyDeviceEvent jdevice;
	SDL_JoyBatteryEvent jbattery;
	SDL_ControllerAxisEvent caxis;
	SDL_ControllerButtonEvent cbutton;
	SDL_ControllerDeviceEvent cdevice;
	SDL_ControllerTouchpadEvent ctouchpad;
	SDL_ControllerSensorEvent csensor;
	SDL_AudioDeviceEvent adevice;
	SDL_SensorEvent sensor;
	SDL_QuitEvent quit;
	SDL_UserEvent user;
	SDL_SysWMEvent syswm;
	SDL_TouchFingerEvent tfinger;
	SDL_MultiGestureEvent mgesture;
	SDL_DollarGestureEvent dgesture;
	SDL_DropEvent drop;
	Uint8 padding[56];	//[sizeof(void *) <= 8 ? 56 : sizeof(void *) == 16 ? 64 : 3 * sizeof(void *)];
} SDL_Event;
]]

local vector = require 'ffi.cpp.vector-lua'

local sdl = setmetatable({}, {
	__index = ffi.C,
})

-- store these in ffi.C as well?
-- how does luajit ffi.load know when to put symbols in ffi.C vs in the table returned?
-- or is the table returned always ffi.C?

function sdl.SDL_Init() return 0 end
function sdl.SDL_Quit() return 0 end

function sdl.SDL_GetError() end	-- TODO return a ffiblob / ptr of a string of the error

local canvas
local eventQueue = vector'SDL_Event'

local mouseMovedSinceLastPoll = true
local mouseAtLastPollX = 0
local mouseAtLastPollY = 0
local mouseX = 0
local mouseY = 0
local mouseButtonFlags = 0	-- SDL_BUTTON_*MASK flags

local function setMousePos(x, y)
	mouseX = x
	mouseY = y
end

local function setMouseFlags(jsbuttons)
	mouseButtonFlags = 0
	-- https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/buttons
	-- this says 1 = primary, 2 = right, 4 = middle
	if jsbuttons & 1 ~= 0 then mouseButtonFlags = mouseButtonFlags | sdl.SDL_BUTTON_LMASK end
	if jsbuttons & 2 ~= 0 then mouseButtonFlags = mouseButtonFlags | sdl.SDL_BUTTON_RMASK end
	if jsbuttons & 4 ~= 0 then mouseButtonFlags = mouseButtonFlags | sdl.SDL_BUTTON_MMASK end
end

local function jsKeyEventMod(jsev)
	local mod = 0
	-- TODO SDL KMOD uses LSHIFT and RSHIFT but browsers only care about SHIFT so ... I'd have to track them myself ...
	if jsev.shiftKey then mod = mod | sdl.KMOD_SHIFT end
	if jsev.ctrlKey then mod = mod | sdl.KMOD_CTRL end
	if jsev.altKey then mod = mod | sdl.KMOD_ALT end
	if jsev.metaKey then mod = mod | sdl.KMOD_META end
	return mod
end

-- I like fengari so much
-- wasmoon doesn't give you stack traces for errors within JS callbacks
local function xpwrap(cb)
	return function(...)
		assert(xpcall(cb, function(err)
			print(err)
			print(debug.traceback())
		end, ...))
	end
end

local jsKeyCodeToSDLKeySym = {
	Enter = sdl.SDLK_RETURN,
	Escape = sdl.SDLK_ESCAPE,
	Backspace = sdl.SDLK_BACKSPACE,
	Tab = sdl.SDLK_TAB,
	Space = sdl.SDLK_SPACE,
--	sdl.SDLK_EXCLAIM,
--	sdl.SDLK_QUOTEDBL,
--	sdl.SDLK_HASH,
--	sdl.SDLK_PERCENT,
--	sdl.SDLK_DOLLAR,
--	sdl.SDLK_AMPERSAND,
--	sdl.SDLK_QUOTE,
--	sdl.SDLK_LEFTPAREN,
--	sdl.SDLK_RIGHTPAREN,
--	sdl.SDLK_ASTERISK,
--	sdl.SDLK_PLUS,
	Comma = sdl.SDLK_COMMA,
	Minus = sdl.SDLK_MINUS,
	Period = sdl.SDLK_PERIOD,
	Slash = sdl.SDLK_SLASH,
	Digit0 = sdl.SDLK_0,
	Digit1 = sdl.SDLK_1,
	Digit2 = sdl.SDLK_2,
	Digit3 = sdl.SDLK_3,
	Digit4 = sdl.SDLK_4,
	Digit5 = sdl.SDLK_5,
	Digit6 = sdl.SDLK_6,
	Digit7 = sdl.SDLK_7,
	Digit8 = sdl.SDLK_8,
	Digit9 = sdl.SDLK_9,
--	sdl.SDLK_COLON,
	Colon = sdl.SDLK_SEMICOLON,
--	sdl.SDLK_LESS,
	Equal = sdl.SDLK_EQUALS,
--	sdl.SDLK_GREATER,
--	sdl.SDLK_QUESTION,
--	sdl.SDLK_AT,
	BracketLeft = sdl.SDLK_LEFTBRACKET,
	Backslash = sdl.SDLK_BACKSLASH,
	BracketRight = sdl.SDLK_RIGHTBRACKET,
--	sdl.SDLK_CARET,
--	sdl.SDLK_UNDERSCORE,
	Backquote = sdl.SDLK_BACKQUOTE,
	a = sdl.SDLK_a,
	b = sdl.SDLK_b,
	c = sdl.SDLK_c,
	d = sdl.SDLK_d,
	e = sdl.SDLK_e,
	f = sdl.SDLK_f,
	g = sdl.SDLK_g,
	h = sdl.SDLK_h,
	i = sdl.SDLK_i,
	j = sdl.SDLK_j,
	k = sdl.SDLK_k,
	l = sdl.SDLK_l,
	m = sdl.SDLK_m,
	n = sdl.SDLK_n,
	o = sdl.SDLK_o,
	p = sdl.SDLK_p,
	q = sdl.SDLK_q,
	r = sdl.SDLK_r,
	s = sdl.SDLK_s,
	t = sdl.SDLK_t,
	u = sdl.SDLK_u,
	v = sdl.SDLK_v,
	w = sdl.SDLK_w,
	x = sdl.SDLK_x,
	y = sdl.SDLK_y,
	z = sdl.SDLK_z,
	CapsLock = sdl.SDLK_CAPSLOCK,
	F1 = sdl.SDLK_F1,
	F2 = sdl.SDLK_F2,
	F3 = sdl.SDLK_F3,
	F4 = sdl.SDLK_F4,
	F5 = sdl.SDLK_F5,
	F6 = sdl.SDLK_F6,
	F7 = sdl.SDLK_F7,
	F8 = sdl.SDLK_F8,
	F9 = sdl.SDLK_F9,
	F10 = sdl.SDLK_F10,
	F11 = sdl.SDLK_F11,
	F12 = sdl.SDLK_F12,
--	sdl.SDLK_PRINTSCREEN,
--	sdl.SDLK_SCROLLLOCK,
--	sdl.SDLK_PAUSE,
	Insert = sdl.SDLK_INSERT,
	Home = sdl.SDLK_HOME,
	PageUp = sdl.SDLK_PAGEUP,
	Delete = sdl.SDLK_DELETE,
	End = sdl.SDLK_END,
	PageDown = sdl.SDLK_PAGEDOWN,
	ArrowRight = sdl.SDLK_RIGHT,
	ArrowLeft = sdl.SDLK_LEFT,
	ArrowDown = sdl.SDLK_DOWN,
	ArrowUp = sdl.SDLK_UP,
	NumLock = sdl.SDLK_NUMLOCKCLEAR,
	NumpadDivide = sdl.SDLK_KP_DIVIDE,
	NumpadMultiply = sdl.SDLK_KP_MULTIPLY,
	NumpadSubtract = sdl.SDLK_KP_MINUS,
	NumpadAdd = sdl.SDLK_KP_PLUS,
	NumpadEnter = sdl.SDLK_KP_ENTER,
	Numpad1 = sdl.SDLK_KP_1,
	Numpad2 = sdl.SDLK_KP_2,
	Numpad3 = sdl.SDLK_KP_3,
	Numpad4 = sdl.SDLK_KP_4,
	Numpad5 = sdl.SDLK_KP_5,
	Numpad6 = sdl.SDLK_KP_6,
	Numpad7 = sdl.SDLK_KP_7,
	Numpad8 = sdl.SDLK_KP_8,
	Numpad9 = sdl.SDLK_KP_9,
	Numpad0 = sdl.SDLK_KP_0,
	NumpadDecimal = sdl.SDLK_KP_PERIOD,
--	sdl.SDLK_APPLICATION,
--	sdl.SDLK_POWER,
--	sdl.SDLK_KP_EQUALS,
--	sdl.SDLK_F13,
--	sdl.SDLK_F14,
--	sdl.SDLK_F15,
--	sdl.SDLK_F16,
--	sdl.SDLK_F17,
--	sdl.SDLK_F18,
--	sdl.SDLK_F19,
--	sdl.SDLK_F20,
--	sdl.SDLK_F21,
--	sdl.SDLK_F22,
--	sdl.SDLK_F23,
--	sdl.SDLK_F24,
--	sdl.SDLK_EXECUTE,
--	sdl.SDLK_HELP,
--	sdl.SDLK_MENU,
--	sdl.SDLK_SELECT,
--	sdl.SDLK_STOP,
--	sdl.SDLK_AGAIN,
--	sdl.SDLK_UNDO,
--	sdl.SDLK_CUT,
--	sdl.SDLK_COPY,
--	sdl.SDLK_PASTE,
--	sdl.SDLK_FIND,
--	sdl.SDLK_MUTE,
--	sdl.SDLK_VOLUMEUP,
--	sdl.SDLK_VOLUMEDOWN,
--	sdl.SDLK_KP_COMMA,
--	sdl.SDLK_KP_EQUALSAS400,
--	sdl.SDLK_ALTERASE,
--	sdl.SDLK_SYSREQ,
--	sdl.SDLK_CANCEL,
--	sdl.SDLK_CLEAR,
--	sdl.SDLK_PRIOR,
--	sdl.SDLK_RETURN2,
--	sdl.SDLK_SEPARATOR,
--	sdl.SDLK_OUT,
--	sdl.SDLK_OPER,
--	sdl.SDLK_CLEARAGAIN,
--	sdl.SDLK_CRSEL,
--	sdl.SDLK_EXSEL,
--	sdl.SDLK_KP_00,
--	sdl.SDLK_KP_000,
--	sdl.SDLK_THOUSANDSSEPARATOR,
--	sdl.SDLK_DECIMALSEPARATOR,
--	sdl.SDLK_CURRENCYUNIT,
--	sdl.SDLK_CURRENCYSUBUNIT,
--	sdl.SDLK_KP_LEFTPAREN,
--	sdl.SDLK_KP_RIGHTPAREN,
--	sdl.SDLK_KP_LEFTBRACE,
--	sdl.SDLK_KP_RIGHTBRACE,
--	sdl.SDLK_KP_TAB,
--	sdl.SDLK_KP_BACKSPACE,
--	sdl.SDLK_KP_A,
--	sdl.SDLK_KP_B,
--	sdl.SDLK_KP_C,
--	sdl.SDLK_KP_D,
--	sdl.SDLK_KP_E,
--	sdl.SDLK_KP_F,
--	sdl.SDLK_KP_XOR,
--	sdl.SDLK_KP_POWER,
--	sdl.SDLK_KP_PERCENT,
--	sdl.SDLK_KP_LESS,
--	sdl.SDLK_KP_GREATER,
--	sdl.SDLK_KP_AMPERSAND,
--	sdl.SDLK_KP_DBLAMPERSAND,
--	sdl.SDLK_KP_VERTICALBAR,
--	sdl.SDLK_KP_DBLVERTICALBAR,
--	sdl.SDLK_KP_COLON,
--	sdl.SDLK_KP_HASH,
--	sdl.SDLK_KP_SPACE,
--	sdl.SDLK_KP_AT,
--	sdl.SDLK_KP_EXCLAM,
--	sdl.SDLK_KP_MEMSTORE,
--	sdl.SDLK_KP_MEMRECALL,
--	sdl.SDLK_KP_MEMCLEAR,
--	sdl.SDLK_KP_MEMADD,
--	sdl.SDLK_KP_MEMSUBTRACT,
--	sdl.SDLK_KP_MEMMULTIPLY,
--	sdl.SDLK_KP_MEMDIVIDE,
--	sdl.SDLK_KP_PLUSMINUS,
--	sdl.SDLK_KP_CLEAR,
--	sdl.SDLK_KP_CLEARENTRY,
--	sdl.SDLK_KP_BINARY,
--	sdl.SDLK_KP_OCTAL,
--	sdl.SDLK_KP_DECIMAL,
--	sdl.SDLK_KP_HEXADECIMAL,
	ControlLeft = sdl.SDLK_LCTRL,
	ShiftLeft = sdl.SDLK_LSHIFT,
	AltLeft = sdl.SDLK_LALT,
--	sdl.SDLK_LGUI,
	ControlRight = sdl.SDLK_RCTRL,
	ShiftRight = sdl.SDLK_RSHIFT,
	AltRight = sdl.SDLK_RALT,
--	sdl.SDLK_RGUI,
--	sdl.SDLK_MODE,
--	sdl.SDLK_AUDIONEXT,
--	sdl.SDLK_AUDIOPREV,
--	sdl.SDLK_AUDIOSTOP,
--	sdl.SDLK_AUDIOPLAY,
--	sdl.SDLK_AUDIOMUTE,
--	sdl.SDLK_MEDIASELECT,
--	sdl.SDLK_WWW,
--	sdl.SDLK_MAIL,
--	sdl.SDLK_CALCULATOR,
--	sdl.SDLK_COMPUTER,
--	sdl.SDLK_AC_SEARCH,
--	sdl.SDLK_AC_HOME,
--	sdl.SDLK_AC_BACK,
--	sdl.SDLK_AC_FORWARD,
--	sdl.SDLK_AC_STOP,
--	sdl.SDLK_AC_REFRESH,
--	sdl.SDLK_AC_BOOKMARKS,
--	sdl.SDLK_BRIGHTNESSDOWN,
--	sdl.SDLK_BRIGHTNESSUP,
--	sdl.SDLK_DISPLAYSWITCH,
--	sdl.SDLK_KBDILLUMTOGGLE,
--	sdl.SDLK_KBDILLUMDOWN,
--	sdl.SDLK_KBDILLUMUP,
--	sdl.SDLK_EJECT,
--	sdl.SDLK_SLEEP,
--	sdl.SDLK_APP1,
--	sdl.SDLK_APP2,
--	sdl.SDLK_AUDIOREWIND,
--	sdl.SDLK_AUDIOFASTFORWARD,
--	sdl.SDLK_SOFTLEFT,
--	sdl.SDLK_SOFTRIGHT,
--	sdl.SDLK_CALL,
--	sdl.SDLK_ENDCALL,
}

local lastWindowWidth
local lastWindowHeight
function sdl.SDL_CreateWindow(title, x, y, w, h, flags)
--DEBUG:print('SDL_CreateWindow', title, x, y, w, h, flags)
	lastWindowWidth = nil
	lastWindowHeight = nil
	local window = js.global
	window:scrollTo(0,1)

	local document = window.document
	document.title = title

	canvas = js.createCanvas()

	window:addEventListener('keyup', xpwrap(function(jsev)
		local sdlev = eventQueue:emplace_back()
		sdlev.type = sdl.SDL_KEYUP
		sdlev.key.timestamp = os.time()
		sdlev.key.windowID = 0	-- TODO SDL windowID
		sdlev.key.state = 0
		sdlev.key['repeat'] = jsev['repeat'] and 1 or 0
		sdlev.key.keysym.scancode = jsev.keyCode
		sdlev.key.keysym.sym = jsKeyCodeToSDLKeySym[jsev.code] or sdl.SDLK_UNKNOWN
		sdlev.key.keysym.mod = jsKeyEventMod(jsev)
	end))
	window:addEventListener('keydown', xpwrap(function(jsev)
		local sdlev = eventQueue:emplace_back()
		sdlev.type = sdl.SDL_KEYDOWN
		sdlev.key.timestamp = os.time()
		sdlev.key.windowID = 0	-- TODO SDL windowID
		sdlev.key.state = 1
		sdlev.key['repeat'] = jsev['repeat'] and 1 or 0
		sdlev.key.keysym.scancode = jsev.keyCode
		sdlev.key.keysym.sym = jsKeyCodeToSDLKeySym[jsev.code] or sdl.SDLK_UNKNOWN
		sdlev.key.keysym.mod = jsKeyEventMod(jsev)
	end))

	-- i'm not capturing right-clicks, and idk why ...
	window:addEventListener('contextmenu', function(jsev)
		jsev:preventDefault()
		return false
	end)

	window:addEventListener('mousemove', xpwrap(function(jsev)
		mouseMovedSinceLastPoll = true
		setMousePos(jsev.pageX, jsev.pageY)
	end))
	window:addEventListener('mousedown', xpwrap(function(jsev)
		setMousePos(jsev.pageX, jsev.pageY)
		setMouseFlags(jsev.buttons)

		local sdlbutton
		-- https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/button
		-- this says (contrary to the 'buttons' order, that 0 = main, 1 = middle, 2 = right)
		if jsev.button == 0 then
			sdlbutton = sdl.SDL_BUTTON_LEFT
		elseif jsev.button == 1 then
			sdlbutton = sdl.SDL_BUTTON_MIDDLE
		elseif jsev.button == 2 then
			sdlbutton = sdl.SDL_BUTTON_RIGHT
		end

		local sdlev = eventQueue:emplace_back()
		sdlev.type = sdl.SDL_MOUSEBUTTONDOWN
		sdlev.button.timestamp = os.time()
		sdlev.button.windowID = 0
		sdlev.button.which = 0
		sdlev.button.button = sdlbutton
		sdlev.button.state = 1	--mouseButtonFlags
		sdlev.button.clicks = 1
		sdlev.button.x = mouseX
		sdlev.button.y = mouseY
	end))
	window:addEventListener('mouseup', xpwrap(function(jsev)
		setMousePos(jsev.pageX, jsev.pageY)
		setMouseFlags(jsev.buttons)

		local sdlev = eventQueue:emplace_back()
		sdlev.type = sdl.SDL_MOUSEBUTTONUP
		sdlev.button.timestamp = os.time()
		sdlev.button.windowID = 0
		sdlev.button.which = 0
		sdlev.button.button = sdlbutton
		sdlev.button.state = 0	--mouseButtonFlags
		sdlev.button.clicks = 1
		sdlev.button.x = mouseX
		sdlev.button.y = mouseY
	end))
	--[[
	window:addEventListener('click', function(jsev)
	end)
	--]]
	--[[ SDL_MOUSEWHEEL
	window:addEventListener('mousewheel', function(jsev)
	end)
	window:addEventListener('DOMMouseScroll', function(jsev)
	end)
	--]]
	--[[ should I pass additional SDL touch events?
	-- SDL_FINGERDOWN SDL_FINGERUP SDL_FINGERMOTION
	window:addEventListener('touchstart', function(jsev) end)
	window:addEventListener('touchmove', function(jsev) end)
	window:addEventListener('touchend', function(jsev) end)
	window:addEventListener('touchcancel', function(jsev) end)
	--]]

	coroutine.yield(sdl.mainthread)

	return ffi.new'SDL_Window'
end
function sdl.SDL_DestroyWindow(sdlWindow) return 0 end
function sdl.SDL_SetWindowSize(sdlWindow, width, height) end

function sdl.SDL_SetWindowTitle(sdlWindow, title)
	js.global.document.title = title
end

local webgl
-- oof, this returns on-stack a SDL_GLContext ... how to handle that ...
function sdl.SDL_GL_CreateContext(sdlWindow)
	local contextName
	local webGLNames = {
		'webgl2',
		'webgl',
		'experimental-webgl',
	}
	for i,name in ipairs(webGLNames) do
		xpcall(function()
--DEBUG:print('trying to init gl context of type', name)
			webgl = canvas:getContext(name)
			contextName = name
		end, function(err)
			print('canvas:getContext('..name..') failed with exception '..err)
		end)
		if webgl then
--DEBUG:print('...got gl')
			break
		end
	end
	if not webgl then
		error "Couldn't initialize WebGL =("
	end

	-- behind the scenes hack
	require 'gl'.setWebGLContext(webgl)

	-- close any old webgl context, store the new webgl context.
	js.webglInit(webgl)

	-- if you request a webgl extension that's not there then it throws an exception
	-- and if wasmoon lua->js calls throw exceptions, wasmoon gives you a nonsense error and stops
	-- so "safecall" these
	for _, ext in ipairs{
		'OES_element_index_uint',
		'OES_standard_derivatives',
		'OES_texture_float',		-- needed for webgl framebuffer+rgba32f
		'OES_texture_float_linear',
		'EXT_color_buffer_float',	-- needed for webgl2 framebuffer+rgba32f
	} do
		print(ext, js.safecall(webgl.getExtension, webgl, ext))
	end

	coroutine.yield(sdl.mainthread)

	return ffi.new'SDL_GLContext'
end

function sdl.SDL_GL_DeleteContext(ctx) return 0 end
function sdl.SDL_GL_SetAttribute(key, value) return 0 end
function sdl.SDL_GL_SetSwapInterval(enable) return 0 end

function sdl.SDL_GetVersion(version)
	version.major = 2
	version.minor = 0
	version.patch = 0
end

function sdl.SDL_GetMouseState(x, y)
	x[0] = mouseX
	y[0] = mouseY
	return mouseButtonFlags
end

-- double buffering isn't a thing in WebGL eh?
function sdl.SDL_GL_SwapWindow(window)
	-- give up control to the browser again
	coroutine.yield(sdl.mainthread)
	-- and a new frame loop starts ...

	-- jump through webgl bs
	webgl:colorMask(false, false, false, true)
	webgl:clear(webgl.COLOR_BUFFER_BIT)
	webgl:colorMask(true, true, true, true)

	-- test for resize events based on canvas size
	if canvas then
		local width =  canvas.offsetWidth
		local height = canvas.offsetHeight
		if width ~= lastWindowWidth or height ~= lastWindowHeight then
			lastWindowWidth = width
			lastWindowHeight = height

			-- push resize event
			local sdlev = eventQueue:emplace_back()
			sdlev.type = sdl.SDL_WINDOWEVENT
			sdlev.window.timestamp = os.time()
			sdlev.window.windowID = 0	-- TODO SDL windowID
			sdlev.window.event = sdl.SDL_WINDOWEVENT_SIZE_CHANGED
			sdlev.window.data1 = width
			sdlev.window.data2 = height
		end
	end
end

-- returns the # of events
-- either this or SDL_GL_SwapWindow should be our coroutine yield ...
function sdl.SDL_PollEvent(event)

	-- see if there's any mouse motion
	if mouseMovedSinceLastPoll then
		mouseMovedSinceLastPoll = false
		local sdlev = eventQueue:emplace_back()
		sdlev[0].type = sdl.SDL_MOUSEMOTION
		sdlev[0].motion.timestamp = os.time()
		sdlev[0].motion.windowID = 0	-- TODO SDL windowID
		sdlev[0].motion.which = 0
		sdlev[0].motion.state = mouseButtonFlags
		sdlev[0].motion.x = mouseX
		sdlev[0].motion.y = mouseY
		sdlev[0].motion.xrel = mouseX - mouseAtLastPollX
		sdlev[0].motion.yrel = mouseY - mouseAtLastPollY

		mouseAtLastPollX = mouseX
		mouseAtLastPollY = mouseY
	end

	-- return our events
	if #eventQueue > 0 then
		local srcEvent = eventQueue:back()
		eventQueue:resize(#eventQueue-1)	-- pop_back function?
		ffi.copy(event, srcEvent, ffi.sizeof'SDL_Event')
		return 1
	end
	return 0
end

return sdl
