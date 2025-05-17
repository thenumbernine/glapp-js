-- HERE for GL4ES
-- provide just the stuff in GL up to whatever GLES3-equivalent is
-- and then OpenGLES3 for the rest because I'm lazy?
-- or thats a bad idea
-- idk

--- ... 
-- getting lots of webgl "WebGL: INVALID_OPERATION: drawArrays: no buffer is bound to enabled attribute" errors ...
-- maybe I will just can this whole idea ... and try to fix the stupid bugs left in the emscripten legacy gl support 

local ffi = require 'ffi'

ffi.cdef[[
/* + BEGIN C:/Program Files (x86)/Windows Kits/10/include/10.0.22621.0/um/GL/gl.h */
/* #pragma region Desktop Family */
typedef unsigned int GLenum;
typedef unsigned char GLboolean;
typedef unsigned int GLbitfield;
typedef signed char GLbyte;
typedef short GLshort;
typedef int GLint;
typedef int GLsizei;
typedef unsigned char GLubyte;
typedef unsigned short GLushort;
typedef unsigned int GLuint;
typedef float GLfloat;
typedef float GLclampf;
typedef double GLdouble;
typedef double GLclampd;
typedef void GLvoid;
enum { GL_VERSION_1_1 = 1 };
enum { GL_ACCUM = 256 };
enum { GL_LOAD = 257 };
enum { GL_RETURN = 258 };
enum { GL_MULT = 259 };
enum { GL_ADD = 260 };
enum { GL_NEVER = 512 };
enum { GL_LESS = 513 };
enum { GL_EQUAL = 514 };
enum { GL_LEQUAL = 515 };
enum { GL_GREATER = 516 };
enum { GL_NOTEQUAL = 517 };
enum { GL_GEQUAL = 518 };
enum { GL_ALWAYS = 519 };
enum { GL_CURRENT_BIT = 1 };
enum { GL_POINT_BIT = 2 };
enum { GL_LINE_BIT = 4 };
enum { GL_POLYGON_BIT = 8 };
enum { GL_POLYGON_STIPPLE_BIT = 16 };
enum { GL_PIXEL_MODE_BIT = 32 };
enum { GL_LIGHTING_BIT = 64 };
enum { GL_FOG_BIT = 128 };
enum { GL_DEPTH_BUFFER_BIT = 256 };
enum { GL_ACCUM_BUFFER_BIT = 512 };
enum { GL_STENCIL_BUFFER_BIT = 1024 };
enum { GL_VIEWPORT_BIT = 2048 };
enum { GL_TRANSFORM_BIT = 4096 };
enum { GL_ENABLE_BIT = 8192 };
enum { GL_COLOR_BUFFER_BIT = 16384 };
enum { GL_HINT_BIT = 32768 };
enum { GL_EVAL_BIT = 65536 };
enum { GL_LIST_BIT = 131072 };
enum { GL_TEXTURE_BIT = 262144 };
enum { GL_SCISSOR_BIT = 524288 };
enum { GL_ALL_ATTRIB_BITS = 1048575 };
enum { GL_POINTS = 0 };
enum { GL_LINES = 1 };
enum { GL_LINE_LOOP = 2 };
enum { GL_LINE_STRIP = 3 };
enum { GL_TRIANGLES = 4 };
enum { GL_TRIANGLE_STRIP = 5 };
enum { GL_TRIANGLE_FAN = 6 };
enum { GL_QUADS = 7 };
enum { GL_QUAD_STRIP = 8 };
enum { GL_POLYGON = 9 };
enum { GL_ZERO = 0 };
enum { GL_ONE = 1 };
enum { GL_SRC_COLOR = 768 };
enum { GL_ONE_MINUS_SRC_COLOR = 769 };
enum { GL_SRC_ALPHA = 770 };
enum { GL_ONE_MINUS_SRC_ALPHA = 771 };
enum { GL_DST_ALPHA = 772 };
enum { GL_ONE_MINUS_DST_ALPHA = 773 };
enum { GL_DST_COLOR = 774 };
enum { GL_ONE_MINUS_DST_COLOR = 775 };
enum { GL_SRC_ALPHA_SATURATE = 776 };
enum { GL_TRUE = 1 };
enum { GL_FALSE = 0 };
enum { GL_CLIP_PLANE0 = 12288 };
enum { GL_CLIP_PLANE1 = 12289 };
enum { GL_CLIP_PLANE2 = 12290 };
enum { GL_CLIP_PLANE3 = 12291 };
enum { GL_CLIP_PLANE4 = 12292 };
enum { GL_CLIP_PLANE5 = 12293 };
enum { GL_BYTE = 5120 };
enum { GL_UNSIGNED_BYTE = 5121 };
enum { GL_SHORT = 5122 };
enum { GL_UNSIGNED_SHORT = 5123 };
enum { GL_INT = 5124 };
enum { GL_UNSIGNED_INT = 5125 };
enum { GL_FLOAT = 5126 };
enum { GL_2_BYTES = 5127 };
enum { GL_3_BYTES = 5128 };
enum { GL_4_BYTES = 5129 };
enum { GL_DOUBLE = 5130 };
enum { GL_NONE = 0 };
enum { GL_FRONT_LEFT = 1024 };
enum { GL_FRONT_RIGHT = 1025 };
enum { GL_BACK_LEFT = 1026 };
enum { GL_BACK_RIGHT = 1027 };
enum { GL_FRONT = 1028 };
enum { GL_BACK = 1029 };
enum { GL_LEFT = 1030 };
enum { GL_RIGHT = 1031 };
enum { GL_FRONT_AND_BACK = 1032 };
enum { GL_AUX0 = 1033 };
enum { GL_AUX1 = 1034 };
enum { GL_AUX2 = 1035 };
enum { GL_AUX3 = 1036 };
enum { GL_NO_ERROR = 0 };
enum { GL_INVALID_ENUM = 1280 };
enum { GL_INVALID_VALUE = 1281 };
enum { GL_INVALID_OPERATION = 1282 };
enum { GL_STACK_OVERFLOW = 1283 };
enum { GL_STACK_UNDERFLOW = 1284 };
enum { GL_OUT_OF_MEMORY = 1285 };
enum { GL_2D = 1536 };
enum { GL_3D = 1537 };
enum { GL_3D_COLOR = 1538 };
enum { GL_3D_COLOR_TEXTURE = 1539 };
enum { GL_4D_COLOR_TEXTURE = 1540 };
enum { GL_PASS_THROUGH_TOKEN = 1792 };
enum { GL_POINT_TOKEN = 1793 };
enum { GL_LINE_TOKEN = 1794 };
enum { GL_POLYGON_TOKEN = 1795 };
enum { GL_BITMAP_TOKEN = 1796 };
enum { GL_DRAW_PIXEL_TOKEN = 1797 };
enum { GL_COPY_PIXEL_TOKEN = 1798 };
enum { GL_LINE_RESET_TOKEN = 1799 };
enum { GL_EXP = 2048 };
enum { GL_EXP2 = 2049 };
enum { GL_CW = 2304 };
enum { GL_CCW = 2305 };
enum { GL_COEFF = 2560 };
enum { GL_ORDER = 2561 };
enum { GL_DOMAIN = 2562 };
enum { GL_CURRENT_COLOR = 2816 };
enum { GL_CURRENT_INDEX = 2817 };
enum { GL_CURRENT_NORMAL = 2818 };
enum { GL_CURRENT_TEXTURE_COORDS = 2819 };
enum { GL_CURRENT_RASTER_COLOR = 2820 };
enum { GL_CURRENT_RASTER_INDEX = 2821 };
enum { GL_CURRENT_RASTER_TEXTURE_COORDS = 2822 };
enum { GL_CURRENT_RASTER_POSITION = 2823 };
enum { GL_CURRENT_RASTER_POSITION_VALID = 2824 };
enum { GL_CURRENT_RASTER_DISTANCE = 2825 };
enum { GL_POINT_SMOOTH = 2832 };
enum { GL_POINT_SIZE = 2833 };
enum { GL_POINT_SIZE_RANGE = 2834 };
enum { GL_POINT_SIZE_GRANULARITY = 2835 };
enum { GL_LINE_SMOOTH = 2848 };
enum { GL_LINE_WIDTH = 2849 };
enum { GL_LINE_WIDTH_RANGE = 2850 };
enum { GL_LINE_WIDTH_GRANULARITY = 2851 };
enum { GL_LINE_STIPPLE = 2852 };
enum { GL_LINE_STIPPLE_PATTERN = 2853 };
enum { GL_LINE_STIPPLE_REPEAT = 2854 };
enum { GL_LIST_MODE = 2864 };
enum { GL_MAX_LIST_NESTING = 2865 };
enum { GL_LIST_BASE = 2866 };
enum { GL_LIST_INDEX = 2867 };
enum { GL_POLYGON_MODE = 2880 };
enum { GL_POLYGON_SMOOTH = 2881 };
enum { GL_POLYGON_STIPPLE = 2882 };
enum { GL_EDGE_FLAG = 2883 };
enum { GL_CULL_FACE = 2884 };
enum { GL_CULL_FACE_MODE = 2885 };
enum { GL_FRONT_FACE = 2886 };
enum { GL_LIGHTING = 2896 };
enum { GL_LIGHT_MODEL_LOCAL_VIEWER = 2897 };
enum { GL_LIGHT_MODEL_TWO_SIDE = 2898 };
enum { GL_LIGHT_MODEL_AMBIENT = 2899 };
enum { GL_SHADE_MODEL = 2900 };
enum { GL_COLOR_MATERIAL_FACE = 2901 };
enum { GL_COLOR_MATERIAL_PARAMETER = 2902 };
enum { GL_COLOR_MATERIAL = 2903 };
enum { GL_FOG = 2912 };
enum { GL_FOG_INDEX = 2913 };
enum { GL_FOG_DENSITY = 2914 };
enum { GL_FOG_START = 2915 };
enum { GL_FOG_END = 2916 };
enum { GL_FOG_MODE = 2917 };
enum { GL_FOG_COLOR = 2918 };
enum { GL_DEPTH_RANGE = 2928 };
enum { GL_DEPTH_TEST = 2929 };
enum { GL_DEPTH_WRITEMASK = 2930 };
enum { GL_DEPTH_CLEAR_VALUE = 2931 };
enum { GL_DEPTH_FUNC = 2932 };
enum { GL_ACCUM_CLEAR_VALUE = 2944 };
enum { GL_STENCIL_TEST = 2960 };
enum { GL_STENCIL_CLEAR_VALUE = 2961 };
enum { GL_STENCIL_FUNC = 2962 };
enum { GL_STENCIL_VALUE_MASK = 2963 };
enum { GL_STENCIL_FAIL = 2964 };
enum { GL_STENCIL_PASS_DEPTH_FAIL = 2965 };
enum { GL_STENCIL_PASS_DEPTH_PASS = 2966 };
enum { GL_STENCIL_REF = 2967 };
enum { GL_STENCIL_WRITEMASK = 2968 };
enum { GL_MATRIX_MODE = 2976 };
enum { GL_NORMALIZE = 2977 };
enum { GL_VIEWPORT = 2978 };
enum { GL_MODELVIEW_STACK_DEPTH = 2979 };
enum { GL_PROJECTION_STACK_DEPTH = 2980 };
enum { GL_TEXTURE_STACK_DEPTH = 2981 };
enum { GL_MODELVIEW_MATRIX = 2982 };
enum { GL_PROJECTION_MATRIX = 2983 };
enum { GL_TEXTURE_MATRIX = 2984 };
enum { GL_ATTRIB_STACK_DEPTH = 2992 };
enum { GL_CLIENT_ATTRIB_STACK_DEPTH = 2993 };
enum { GL_ALPHA_TEST = 3008 };
enum { GL_ALPHA_TEST_FUNC = 3009 };
enum { GL_ALPHA_TEST_REF = 3010 };
enum { GL_DITHER = 3024 };
enum { GL_BLEND_DST = 3040 };
enum { GL_BLEND_SRC = 3041 };
enum { GL_BLEND = 3042 };
enum { GL_LOGIC_OP_MODE = 3056 };
enum { GL_INDEX_LOGIC_OP = 3057 };
enum { GL_COLOR_LOGIC_OP = 3058 };
enum { GL_AUX_BUFFERS = 3072 };
enum { GL_DRAW_BUFFER = 3073 };
enum { GL_READ_BUFFER = 3074 };
enum { GL_SCISSOR_BOX = 3088 };
enum { GL_SCISSOR_TEST = 3089 };
enum { GL_INDEX_CLEAR_VALUE = 3104 };
enum { GL_INDEX_WRITEMASK = 3105 };
enum { GL_COLOR_CLEAR_VALUE = 3106 };
enum { GL_COLOR_WRITEMASK = 3107 };
enum { GL_INDEX_MODE = 3120 };
enum { GL_RGBA_MODE = 3121 };
enum { GL_DOUBLEBUFFER = 3122 };
enum { GL_STEREO = 3123 };
enum { GL_RENDER_MODE = 3136 };
enum { GL_PERSPECTIVE_CORRECTION_HINT = 3152 };
enum { GL_POINT_SMOOTH_HINT = 3153 };
enum { GL_LINE_SMOOTH_HINT = 3154 };
enum { GL_POLYGON_SMOOTH_HINT = 3155 };
enum { GL_FOG_HINT = 3156 };
enum { GL_TEXTURE_GEN_S = 3168 };
enum { GL_TEXTURE_GEN_T = 3169 };
enum { GL_TEXTURE_GEN_R = 3170 };
enum { GL_TEXTURE_GEN_Q = 3171 };
enum { GL_PIXEL_MAP_I_TO_I = 3184 };
enum { GL_PIXEL_MAP_S_TO_S = 3185 };
enum { GL_PIXEL_MAP_I_TO_R = 3186 };
enum { GL_PIXEL_MAP_I_TO_G = 3187 };
enum { GL_PIXEL_MAP_I_TO_B = 3188 };
enum { GL_PIXEL_MAP_I_TO_A = 3189 };
enum { GL_PIXEL_MAP_R_TO_R = 3190 };
enum { GL_PIXEL_MAP_G_TO_G = 3191 };
enum { GL_PIXEL_MAP_B_TO_B = 3192 };
enum { GL_PIXEL_MAP_A_TO_A = 3193 };
enum { GL_PIXEL_MAP_I_TO_I_SIZE = 3248 };
enum { GL_PIXEL_MAP_S_TO_S_SIZE = 3249 };
enum { GL_PIXEL_MAP_I_TO_R_SIZE = 3250 };
enum { GL_PIXEL_MAP_I_TO_G_SIZE = 3251 };
enum { GL_PIXEL_MAP_I_TO_B_SIZE = 3252 };
enum { GL_PIXEL_MAP_I_TO_A_SIZE = 3253 };
enum { GL_PIXEL_MAP_R_TO_R_SIZE = 3254 };
enum { GL_PIXEL_MAP_G_TO_G_SIZE = 3255 };
enum { GL_PIXEL_MAP_B_TO_B_SIZE = 3256 };
enum { GL_PIXEL_MAP_A_TO_A_SIZE = 3257 };
enum { GL_UNPACK_SWAP_BYTES = 3312 };
enum { GL_UNPACK_LSB_FIRST = 3313 };
enum { GL_UNPACK_ROW_LENGTH = 3314 };
enum { GL_UNPACK_SKIP_ROWS = 3315 };
enum { GL_UNPACK_SKIP_PIXELS = 3316 };
enum { GL_UNPACK_ALIGNMENT = 3317 };
enum { GL_PACK_SWAP_BYTES = 3328 };
enum { GL_PACK_LSB_FIRST = 3329 };
enum { GL_PACK_ROW_LENGTH = 3330 };
enum { GL_PACK_SKIP_ROWS = 3331 };
enum { GL_PACK_SKIP_PIXELS = 3332 };
enum { GL_PACK_ALIGNMENT = 3333 };
enum { GL_MAP_COLOR = 3344 };
enum { GL_MAP_STENCIL = 3345 };
enum { GL_INDEX_SHIFT = 3346 };
enum { GL_INDEX_OFFSET = 3347 };
enum { GL_RED_SCALE = 3348 };
enum { GL_RED_BIAS = 3349 };
enum { GL_ZOOM_X = 3350 };
enum { GL_ZOOM_Y = 3351 };
enum { GL_GREEN_SCALE = 3352 };
enum { GL_GREEN_BIAS = 3353 };
enum { GL_BLUE_SCALE = 3354 };
enum { GL_BLUE_BIAS = 3355 };
enum { GL_ALPHA_SCALE = 3356 };
enum { GL_ALPHA_BIAS = 3357 };
enum { GL_DEPTH_SCALE = 3358 };
enum { GL_DEPTH_BIAS = 3359 };
enum { GL_MAX_EVAL_ORDER = 3376 };
enum { GL_MAX_LIGHTS = 3377 };
enum { GL_MAX_CLIP_PLANES = 3378 };
enum { GL_MAX_TEXTURE_SIZE = 3379 };
enum { GL_MAX_PIXEL_MAP_TABLE = 3380 };
enum { GL_MAX_ATTRIB_STACK_DEPTH = 3381 };
enum { GL_MAX_MODELVIEW_STACK_DEPTH = 3382 };
enum { GL_MAX_NAME_STACK_DEPTH = 3383 };
enum { GL_MAX_PROJECTION_STACK_DEPTH = 3384 };
enum { GL_MAX_TEXTURE_STACK_DEPTH = 3385 };
enum { GL_MAX_VIEWPORT_DIMS = 3386 };
enum { GL_MAX_CLIENT_ATTRIB_STACK_DEPTH = 3387 };
enum { GL_SUBPIXEL_BITS = 3408 };
enum { GL_INDEX_BITS = 3409 };
enum { GL_RED_BITS = 3410 };
enum { GL_GREEN_BITS = 3411 };
enum { GL_BLUE_BITS = 3412 };
enum { GL_ALPHA_BITS = 3413 };
enum { GL_DEPTH_BITS = 3414 };
enum { GL_STENCIL_BITS = 3415 };
enum { GL_ACCUM_RED_BITS = 3416 };
enum { GL_ACCUM_GREEN_BITS = 3417 };
enum { GL_ACCUM_BLUE_BITS = 3418 };
enum { GL_ACCUM_ALPHA_BITS = 3419 };
enum { GL_NAME_STACK_DEPTH = 3440 };
enum { GL_AUTO_NORMAL = 3456 };
enum { GL_MAP1_COLOR_4 = 3472 };
enum { GL_MAP1_INDEX = 3473 };
enum { GL_MAP1_NORMAL = 3474 };
enum { GL_MAP1_TEXTURE_COORD_1 = 3475 };
enum { GL_MAP1_TEXTURE_COORD_2 = 3476 };
enum { GL_MAP1_TEXTURE_COORD_3 = 3477 };
enum { GL_MAP1_TEXTURE_COORD_4 = 3478 };
enum { GL_MAP1_VERTEX_3 = 3479 };
enum { GL_MAP1_VERTEX_4 = 3480 };
enum { GL_MAP2_COLOR_4 = 3504 };
enum { GL_MAP2_INDEX = 3505 };
enum { GL_MAP2_NORMAL = 3506 };
enum { GL_MAP2_TEXTURE_COORD_1 = 3507 };
enum { GL_MAP2_TEXTURE_COORD_2 = 3508 };
enum { GL_MAP2_TEXTURE_COORD_3 = 3509 };
enum { GL_MAP2_TEXTURE_COORD_4 = 3510 };
enum { GL_MAP2_VERTEX_3 = 3511 };
enum { GL_MAP2_VERTEX_4 = 3512 };
enum { GL_MAP1_GRID_DOMAIN = 3536 };
enum { GL_MAP1_GRID_SEGMENTS = 3537 };
enum { GL_MAP2_GRID_DOMAIN = 3538 };
enum { GL_MAP2_GRID_SEGMENTS = 3539 };
enum { GL_TEXTURE_1D = 3552 };
enum { GL_TEXTURE_2D = 3553 };
enum { GL_FEEDBACK_BUFFER_POINTER = 3568 };
enum { GL_FEEDBACK_BUFFER_SIZE = 3569 };
enum { GL_FEEDBACK_BUFFER_TYPE = 3570 };
enum { GL_SELECTION_BUFFER_POINTER = 3571 };
enum { GL_SELECTION_BUFFER_SIZE = 3572 };
enum { GL_TEXTURE_WIDTH = 4096 };
enum { GL_TEXTURE_HEIGHT = 4097 };
enum { GL_TEXTURE_INTERNAL_FORMAT = 4099 };
enum { GL_TEXTURE_BORDER_COLOR = 4100 };
enum { GL_TEXTURE_BORDER = 4101 };
enum { GL_DONT_CARE = 4352 };
enum { GL_FASTEST = 4353 };
enum { GL_NICEST = 4354 };
enum { GL_LIGHT0 = 16384 };
enum { GL_LIGHT1 = 16385 };
enum { GL_LIGHT2 = 16386 };
enum { GL_LIGHT3 = 16387 };
enum { GL_LIGHT4 = 16388 };
enum { GL_LIGHT5 = 16389 };
enum { GL_LIGHT6 = 16390 };
enum { GL_LIGHT7 = 16391 };
enum { GL_AMBIENT = 4608 };
enum { GL_DIFFUSE = 4609 };
enum { GL_SPECULAR = 4610 };
enum { GL_POSITION = 4611 };
enum { GL_SPOT_DIRECTION = 4612 };
enum { GL_SPOT_EXPONENT = 4613 };
enum { GL_SPOT_CUTOFF = 4614 };
enum { GL_CONSTANT_ATTENUATION = 4615 };
enum { GL_LINEAR_ATTENUATION = 4616 };
enum { GL_QUADRATIC_ATTENUATION = 4617 };
enum { GL_COMPILE = 4864 };
enum { GL_COMPILE_AND_EXECUTE = 4865 };
enum { GL_CLEAR = 5376 };
enum { GL_AND = 5377 };
enum { GL_AND_REVERSE = 5378 };
enum { GL_COPY = 5379 };
enum { GL_AND_INVERTED = 5380 };
enum { GL_NOOP = 5381 };
enum { GL_XOR = 5382 };
enum { GL_OR = 5383 };
enum { GL_NOR = 5384 };
enum { GL_EQUIV = 5385 };
enum { GL_INVERT = 5386 };
enum { GL_OR_REVERSE = 5387 };
enum { GL_COPY_INVERTED = 5388 };
enum { GL_OR_INVERTED = 5389 };
enum { GL_NAND = 5390 };
enum { GL_SET = 5391 };
enum { GL_EMISSION = 5632 };
enum { GL_SHININESS = 5633 };
enum { GL_AMBIENT_AND_DIFFUSE = 5634 };
enum { GL_COLOR_INDEXES = 5635 };
enum { GL_MODELVIEW = 5888 };
enum { GL_PROJECTION = 5889 };
enum { GL_TEXTURE = 5890 };
enum { GL_COLOR = 6144 };
enum { GL_DEPTH = 6145 };
enum { GL_STENCIL = 6146 };
enum { GL_COLOR_INDEX = 6400 };
enum { GL_STENCIL_INDEX = 6401 };
enum { GL_DEPTH_COMPONENT = 6402 };
enum { GL_RED = 6403 };
enum { GL_GREEN = 6404 };
enum { GL_BLUE = 6405 };
enum { GL_ALPHA = 6406 };
enum { GL_RGB = 6407 };
enum { GL_RGBA = 6408 };
enum { GL_LUMINANCE = 6409 };
enum { GL_LUMINANCE_ALPHA = 6410 };
enum { GL_BITMAP = 6656 };
enum { GL_POINT = 6912 };
enum { GL_LINE = 6913 };
enum { GL_FILL = 6914 };
enum { GL_RENDER = 7168 };
enum { GL_FEEDBACK = 7169 };
enum { GL_SELECT = 7170 };
enum { GL_FLAT = 7424 };
enum { GL_SMOOTH = 7425 };
enum { GL_KEEP = 7680 };
enum { GL_REPLACE = 7681 };
enum { GL_INCR = 7682 };
enum { GL_DECR = 7683 };
enum { GL_VENDOR = 7936 };
enum { GL_RENDERER = 7937 };
enum { GL_VERSION = 7938 };
enum { GL_EXTENSIONS = 7939 };
enum { GL_S = 8192 };
enum { GL_T = 8193 };
enum { GL_R = 8194 };
enum { GL_Q = 8195 };
enum { GL_MODULATE = 8448 };
enum { GL_DECAL = 8449 };
enum { GL_TEXTURE_ENV_MODE = 8704 };
enum { GL_TEXTURE_ENV_COLOR = 8705 };
enum { GL_TEXTURE_ENV = 8960 };
enum { GL_EYE_LINEAR = 9216 };
enum { GL_OBJECT_LINEAR = 9217 };
enum { GL_SPHERE_MAP = 9218 };
enum { GL_TEXTURE_GEN_MODE = 9472 };
enum { GL_OBJECT_PLANE = 9473 };
enum { GL_EYE_PLANE = 9474 };
enum { GL_NEAREST = 9728 };
enum { GL_LINEAR = 9729 };
enum { GL_NEAREST_MIPMAP_NEAREST = 9984 };
enum { GL_LINEAR_MIPMAP_NEAREST = 9985 };
enum { GL_NEAREST_MIPMAP_LINEAR = 9986 };
enum { GL_LINEAR_MIPMAP_LINEAR = 9987 };
enum { GL_TEXTURE_MAG_FILTER = 10240 };
enum { GL_TEXTURE_MIN_FILTER = 10241 };
enum { GL_TEXTURE_WRAP_S = 10242 };
enum { GL_TEXTURE_WRAP_T = 10243 };
enum { GL_CLAMP = 10496 };
enum { GL_REPEAT = 10497 };
enum { GL_CLIENT_PIXEL_STORE_BIT = 1 };
enum { GL_CLIENT_VERTEX_ARRAY_BIT = 2 };
enum { GL_CLIENT_ALL_ATTRIB_BITS = 4294967295 };
enum { GL_POLYGON_OFFSET_FACTOR = 32824 };
enum { GL_POLYGON_OFFSET_UNITS = 10752 };
enum { GL_POLYGON_OFFSET_POINT = 10753 };
enum { GL_POLYGON_OFFSET_LINE = 10754 };
enum { GL_POLYGON_OFFSET_FILL = 32823 };
enum { GL_ALPHA4 = 32827 };
enum { GL_ALPHA8 = 32828 };
enum { GL_ALPHA12 = 32829 };
enum { GL_ALPHA16 = 32830 };
enum { GL_LUMINANCE4 = 32831 };
enum { GL_LUMINANCE8 = 32832 };
enum { GL_LUMINANCE12 = 32833 };
enum { GL_LUMINANCE16 = 32834 };
enum { GL_LUMINANCE4_ALPHA4 = 32835 };
enum { GL_LUMINANCE6_ALPHA2 = 32836 };
enum { GL_LUMINANCE8_ALPHA8 = 32837 };
enum { GL_LUMINANCE12_ALPHA4 = 32838 };
enum { GL_LUMINANCE12_ALPHA12 = 32839 };
enum { GL_LUMINANCE16_ALPHA16 = 32840 };
enum { GL_INTENSITY = 32841 };
enum { GL_INTENSITY4 = 32842 };
enum { GL_INTENSITY8 = 32843 };
enum { GL_INTENSITY12 = 32844 };
enum { GL_INTENSITY16 = 32845 };
enum { GL_R3_G3_B2 = 10768 };
enum { GL_RGB4 = 32847 };
enum { GL_RGB5 = 32848 };
enum { GL_RGB8 = 32849 };
enum { GL_RGB10 = 32850 };
enum { GL_RGB12 = 32851 };
enum { GL_RGB16 = 32852 };
enum { GL_RGBA2 = 32853 };
enum { GL_RGBA4 = 32854 };
enum { GL_RGB5_A1 = 32855 };
enum { GL_RGBA8 = 32856 };
enum { GL_RGB10_A2 = 32857 };
enum { GL_RGBA12 = 32858 };
enum { GL_RGBA16 = 32859 };
enum { GL_TEXTURE_RED_SIZE = 32860 };
enum { GL_TEXTURE_GREEN_SIZE = 32861 };
enum { GL_TEXTURE_BLUE_SIZE = 32862 };
enum { GL_TEXTURE_ALPHA_SIZE = 32863 };
enum { GL_TEXTURE_LUMINANCE_SIZE = 32864 };
enum { GL_TEXTURE_INTENSITY_SIZE = 32865 };
enum { GL_PROXY_TEXTURE_1D = 32867 };
enum { GL_PROXY_TEXTURE_2D = 32868 };
enum { GL_TEXTURE_PRIORITY = 32870 };
enum { GL_TEXTURE_RESIDENT = 32871 };
enum { GL_TEXTURE_BINDING_1D = 32872 };
enum { GL_TEXTURE_BINDING_2D = 32873 };
enum { GL_VERTEX_ARRAY = 32884 };
enum { GL_NORMAL_ARRAY = 32885 };
enum { GL_COLOR_ARRAY = 32886 };
enum { GL_INDEX_ARRAY = 32887 };
enum { GL_TEXTURE_COORD_ARRAY = 32888 };
enum { GL_EDGE_FLAG_ARRAY = 32889 };
enum { GL_VERTEX_ARRAY_SIZE = 32890 };
enum { GL_VERTEX_ARRAY_TYPE = 32891 };
enum { GL_VERTEX_ARRAY_STRIDE = 32892 };
enum { GL_NORMAL_ARRAY_TYPE = 32894 };
enum { GL_NORMAL_ARRAY_STRIDE = 32895 };
enum { GL_COLOR_ARRAY_SIZE = 32897 };
enum { GL_COLOR_ARRAY_TYPE = 32898 };
enum { GL_COLOR_ARRAY_STRIDE = 32899 };
enum { GL_INDEX_ARRAY_TYPE = 32901 };
enum { GL_INDEX_ARRAY_STRIDE = 32902 };
enum { GL_TEXTURE_COORD_ARRAY_SIZE = 32904 };
enum { GL_TEXTURE_COORD_ARRAY_TYPE = 32905 };
enum { GL_TEXTURE_COORD_ARRAY_STRIDE = 32906 };
enum { GL_EDGE_FLAG_ARRAY_STRIDE = 32908 };
enum { GL_VERTEX_ARRAY_POINTER = 32910 };
enum { GL_NORMAL_ARRAY_POINTER = 32911 };
enum { GL_COLOR_ARRAY_POINTER = 32912 };
enum { GL_INDEX_ARRAY_POINTER = 32913 };
enum { GL_TEXTURE_COORD_ARRAY_POINTER = 32914 };
enum { GL_EDGE_FLAG_ARRAY_POINTER = 32915 };
enum { GL_V2F = 10784 };
enum { GL_V3F = 10785 };
enum { GL_C4UB_V2F = 10786 };
enum { GL_C4UB_V3F = 10787 };
enum { GL_C3F_V3F = 10788 };
enum { GL_N3F_V3F = 10789 };
enum { GL_C4F_N3F_V3F = 10790 };
enum { GL_T2F_V3F = 10791 };
enum { GL_T4F_V4F = 10792 };
enum { GL_T2F_C4UB_V3F = 10793 };
enum { GL_T2F_C3F_V3F = 10794 };
enum { GL_T2F_N3F_V3F = 10795 };
enum { GL_T2F_C4F_N3F_V3F = 10796 };
enum { GL_T4F_C4F_N3F_V4F = 10797 };
enum { GL_EXT_vertex_array = 1 };
enum { GL_EXT_bgra = 1 };
enum { GL_EXT_paletted_texture = 1 };
enum { GL_WIN_swap_hint = 1 };
enum { GL_WIN_draw_range_elements = 1 };
enum { GL_VERTEX_ARRAY_EXT = 32884 };
enum { GL_NORMAL_ARRAY_EXT = 32885 };
enum { GL_COLOR_ARRAY_EXT = 32886 };
enum { GL_INDEX_ARRAY_EXT = 32887 };
enum { GL_TEXTURE_COORD_ARRAY_EXT = 32888 };
enum { GL_EDGE_FLAG_ARRAY_EXT = 32889 };
enum { GL_VERTEX_ARRAY_SIZE_EXT = 32890 };
enum { GL_VERTEX_ARRAY_TYPE_EXT = 32891 };
enum { GL_VERTEX_ARRAY_STRIDE_EXT = 32892 };
enum { GL_VERTEX_ARRAY_COUNT_EXT = 32893 };
enum { GL_NORMAL_ARRAY_TYPE_EXT = 32894 };
enum { GL_NORMAL_ARRAY_STRIDE_EXT = 32895 };
enum { GL_NORMAL_ARRAY_COUNT_EXT = 32896 };
enum { GL_COLOR_ARRAY_SIZE_EXT = 32897 };
enum { GL_COLOR_ARRAY_TYPE_EXT = 32898 };
enum { GL_COLOR_ARRAY_STRIDE_EXT = 32899 };
enum { GL_COLOR_ARRAY_COUNT_EXT = 32900 };
enum { GL_INDEX_ARRAY_TYPE_EXT = 32901 };
enum { GL_INDEX_ARRAY_STRIDE_EXT = 32902 };
enum { GL_INDEX_ARRAY_COUNT_EXT = 32903 };
enum { GL_TEXTURE_COORD_ARRAY_SIZE_EXT = 32904 };
enum { GL_TEXTURE_COORD_ARRAY_TYPE_EXT = 32905 };
enum { GL_TEXTURE_COORD_ARRAY_STRIDE_EXT = 32906 };
enum { GL_TEXTURE_COORD_ARRAY_COUNT_EXT = 32907 };
enum { GL_EDGE_FLAG_ARRAY_STRIDE_EXT = 32908 };
enum { GL_EDGE_FLAG_ARRAY_COUNT_EXT = 32909 };
enum { GL_VERTEX_ARRAY_POINTER_EXT = 32910 };
enum { GL_NORMAL_ARRAY_POINTER_EXT = 32911 };
enum { GL_COLOR_ARRAY_POINTER_EXT = 32912 };
enum { GL_INDEX_ARRAY_POINTER_EXT = 32913 };
enum { GL_TEXTURE_COORD_ARRAY_POINTER_EXT = 32914 };
enum { GL_EDGE_FLAG_ARRAY_POINTER_EXT = 32915 };
enum { GL_DOUBLE_EXT = 5130 };
enum { GL_BGR_EXT = 32992 };
enum { GL_BGRA_EXT = 32993 };
enum { GL_COLOR_TABLE_FORMAT_EXT = 32984 };
enum { GL_COLOR_TABLE_WIDTH_EXT = 32985 };
enum { GL_COLOR_TABLE_RED_SIZE_EXT = 32986 };
enum { GL_COLOR_TABLE_GREEN_SIZE_EXT = 32987 };
enum { GL_COLOR_TABLE_BLUE_SIZE_EXT = 32988 };
enum { GL_COLOR_TABLE_ALPHA_SIZE_EXT = 32989 };
enum { GL_COLOR_TABLE_LUMINANCE_SIZE_EXT = 32990 };
enum { GL_COLOR_TABLE_INTENSITY_SIZE_EXT = 32991 };
enum { GL_COLOR_INDEX1_EXT = 32994 };
enum { GL_COLOR_INDEX2_EXT = 32995 };
enum { GL_COLOR_INDEX4_EXT = 32996 };
enum { GL_COLOR_INDEX8_EXT = 32997 };
enum { GL_COLOR_INDEX12_EXT = 32998 };
enum { GL_COLOR_INDEX16_EXT = 32999 };
enum { GL_MAX_ELEMENTS_VERTICES_WIN = 33000 };
enum { GL_MAX_ELEMENTS_INDICES_WIN = 33001 };
enum { GL_PHONG_WIN = 33002 };
enum { GL_PHONG_HINT_WIN = 33003 };
enum { GL_FOG_SPECULAR_TEXTURE_WIN = 33004 };
enum { GL_LOGIC_OP = 3057 };
enum { GL_TEXTURE_COMPONENTS = 4099 };
void gl4es_glAccum (GLenum op, GLfloat value);
void gl4es_glAlphaFunc (GLenum func, GLclampf ref);
GLboolean gl4es_glAreTexturesResident (GLsizei n, const GLuint *textures, GLboolean *residences);
void gl4es_glArrayElement (GLint i);
void gl4es_glBegin (GLenum mode);
void gl4es_glBindTexture (GLenum target, GLuint texture);
void gl4es_glBitmap (GLsizei width, GLsizei height, GLfloat xorig, GLfloat yorig, GLfloat xmove, GLfloat ymove, const GLubyte *bitmap);
void gl4es_glBlendFunc (GLenum sfactor, GLenum dfactor);
void gl4es_glCallList (GLuint list);
void gl4es_glCallLists (GLsizei n, GLenum type, const GLvoid *lists);
void gl4es_glClear (GLbitfield mask);
void gl4es_glClearAccum (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
void gl4es_glClearColor (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
void gl4es_glClearDepth (GLclampd depth);
void gl4es_glClearIndex (GLfloat c);
void gl4es_glClearStencil (GLint s);
void gl4es_glClipPlane (GLenum plane, const GLdouble *equation);
void gl4es_glColor3b (GLbyte red, GLbyte green, GLbyte blue);
void gl4es_glColor3bv (const GLbyte *v);
void gl4es_glColor3d (GLdouble red, GLdouble green, GLdouble blue);
void gl4es_glColor3dv (const GLdouble *v);
void gl4es_glColor3f (GLfloat red, GLfloat green, GLfloat blue);
void gl4es_glColor3fv (const GLfloat *v);
void gl4es_glColor3i (GLint red, GLint green, GLint blue);
void gl4es_glColor3iv (const GLint *v);
void gl4es_glColor3s (GLshort red, GLshort green, GLshort blue);
void gl4es_glColor3sv (const GLshort *v);
void gl4es_glColor3ub (GLubyte red, GLubyte green, GLubyte blue);
void gl4es_glColor3ubv (const GLubyte *v);
void gl4es_glColor3ui (GLuint red, GLuint green, GLuint blue);
void gl4es_glColor3uiv (const GLuint *v);
void gl4es_glColor3us (GLushort red, GLushort green, GLushort blue);
void gl4es_glColor3usv (const GLushort *v);
void gl4es_glColor4b (GLbyte red, GLbyte green, GLbyte blue, GLbyte alpha);
void gl4es_glColor4bv (const GLbyte *v);
void gl4es_glColor4d (GLdouble red, GLdouble green, GLdouble blue, GLdouble alpha);
void gl4es_glColor4dv (const GLdouble *v);
void gl4es_glColor4f (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
void gl4es_glColor4fv (const GLfloat *v);
void gl4es_glColor4i (GLint red, GLint green, GLint blue, GLint alpha);
void gl4es_glColor4iv (const GLint *v);
void gl4es_glColor4s (GLshort red, GLshort green, GLshort blue, GLshort alpha);
void gl4es_glColor4sv (const GLshort *v);
void gl4es_glColor4ub (GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha);
void gl4es_glColor4ubv (const GLubyte *v);
void gl4es_glColor4ui (GLuint red, GLuint green, GLuint blue, GLuint alpha);
void gl4es_glColor4uiv (const GLuint *v);
void gl4es_glColor4us (GLushort red, GLushort green, GLushort blue, GLushort alpha);
void gl4es_glColor4usv (const GLushort *v);
void gl4es_glColorMask (GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
void gl4es_glColorMaterial (GLenum face, GLenum mode);
void gl4es_glColorPointer (GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void gl4es_glCopyPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum type);
void gl4es_glCopyTexImage1D (GLenum target, GLint level, GLenum internalFormat, GLint x, GLint y, GLsizei width, GLint border);
void gl4es_glCopyTexImage2D (GLenum target, GLint level, GLenum internalFormat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
void gl4es_glCopyTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
void gl4es_glCopyTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
void gl4es_glCullFace (GLenum mode);
void gl4es_glDeleteLists (GLuint list, GLsizei range);
void gl4es_glDeleteTextures (GLsizei n, const GLuint *textures);
void gl4es_glDepthFunc (GLenum func);
void gl4es_glDepthMask (GLboolean flag);
void gl4es_glDepthRange (GLclampd zNear, GLclampd zFar);
void gl4es_glDisable (GLenum cap);
void gl4es_glDisableClientState (GLenum array);
void gl4es_glDrawArrays (GLenum mode, GLint first, GLsizei count);
void gl4es_glDrawBuffer (GLenum mode);
void gl4es_glDrawElements (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices);
void gl4es_glDrawPixels (GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
void gl4es_glEdgeFlag (GLboolean flag);
void gl4es_glEdgeFlagPointer (GLsizei stride, const GLvoid *pointer);
void gl4es_glEdgeFlagv (const GLboolean *flag);
void gl4es_glEnable (GLenum cap);
void gl4es_glEnableClientState (GLenum array);
void gl4es_glEnd (void);
void gl4es_glEndList (void);
void gl4es_glEvalCoord1d (GLdouble u);
void gl4es_glEvalCoord1dv (const GLdouble *u);
void gl4es_glEvalCoord1f (GLfloat u);
void gl4es_glEvalCoord1fv (const GLfloat *u);
void gl4es_glEvalCoord2d (GLdouble u, GLdouble v);
void gl4es_glEvalCoord2dv (const GLdouble *u);
void gl4es_glEvalCoord2f (GLfloat u, GLfloat v);
void gl4es_glEvalCoord2fv (const GLfloat *u);
void gl4es_glEvalMesh1 (GLenum mode, GLint i1, GLint i2);
void gl4es_glEvalMesh2 (GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2);
void gl4es_glEvalPoint1 (GLint i);
void gl4es_glEvalPoint2 (GLint i, GLint j);
void gl4es_glFeedbackBuffer (GLsizei size, GLenum type, GLfloat *buffer);
void gl4es_glFinish (void);
void gl4es_glFlush (void);
void gl4es_glFogf (GLenum pname, GLfloat param);
void gl4es_glFogfv (GLenum pname, const GLfloat *params);
void gl4es_glFogi (GLenum pname, GLint param);
void gl4es_glFogiv (GLenum pname, const GLint *params);
void gl4es_glFrontFace (GLenum mode);
void gl4es_glFrustum (GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
GLuint gl4es_glGenLists (GLsizei range);
void gl4es_glGenTextures (GLsizei n, GLuint *textures);
void gl4es_glGetBooleanv (GLenum pname, GLboolean *params);
void gl4es_glGetClipPlane (GLenum plane, GLdouble *equation);
void gl4es_glGetDoublev (GLenum pname, GLdouble *params);
GLenum gl4es_glGetError (void);
void gl4es_glGetFloatv (GLenum pname, GLfloat *params);
void gl4es_glGetIntegerv (GLenum pname, GLint *params);
void gl4es_glGetLightfv (GLenum light, GLenum pname, GLfloat *params);
void gl4es_glGetLightiv (GLenum light, GLenum pname, GLint *params);
void gl4es_glGetMapdv (GLenum target, GLenum query, GLdouble *v);
void gl4es_glGetMapfv (GLenum target, GLenum query, GLfloat *v);
void gl4es_glGetMapiv (GLenum target, GLenum query, GLint *v);
void gl4es_glGetMaterialfv (GLenum face, GLenum pname, GLfloat *params);
void gl4es_glGetMaterialiv (GLenum face, GLenum pname, GLint *params);
void gl4es_glGetPixelMapfv (GLenum map, GLfloat *values);
void gl4es_glGetPixelMapuiv (GLenum map, GLuint *values);
void gl4es_glGetPixelMapusv (GLenum map, GLushort *values);
void gl4es_glGetPointerv (GLenum pname, GLvoid* *params);
void gl4es_glGetPolygonStipple (GLubyte *mask);
const GLubyte * gl4es_glGetString (GLenum name);
void gl4es_glGetTexEnvfv (GLenum target, GLenum pname, GLfloat *params);
void gl4es_glGetTexEnviv (GLenum target, GLenum pname, GLint *params);
void gl4es_glGetTexGendv (GLenum coord, GLenum pname, GLdouble *params);
void gl4es_glGetTexGenfv (GLenum coord, GLenum pname, GLfloat *params);
void gl4es_glGetTexGeniv (GLenum coord, GLenum pname, GLint *params);
void gl4es_glGetTexImage (GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels);
void gl4es_glGetTexLevelParameterfv (GLenum target, GLint level, GLenum pname, GLfloat *params);
void gl4es_glGetTexLevelParameteriv (GLenum target, GLint level, GLenum pname, GLint *params);
void gl4es_glGetTexParameterfv (GLenum target, GLenum pname, GLfloat *params);
void gl4es_glGetTexParameteriv (GLenum target, GLenum pname, GLint *params);
void gl4es_glHint (GLenum target, GLenum mode);
void gl4es_glIndexMask (GLuint mask);
void gl4es_glIndexPointer (GLenum type, GLsizei stride, const GLvoid *pointer);
void gl4es_glIndexd (GLdouble c);
void gl4es_glIndexdv (const GLdouble *c);
void gl4es_glIndexf (GLfloat c);
void gl4es_glIndexfv (const GLfloat *c);
void gl4es_glIndexi (GLint c);
void gl4es_glIndexiv (const GLint *c);
void gl4es_glIndexs (GLshort c);
void gl4es_glIndexsv (const GLshort *c);
void gl4es_glIndexub (GLubyte c);
void gl4es_glIndexubv (const GLubyte *c);
void gl4es_glInitNames (void);
void gl4es_glInterleavedArrays (GLenum format, GLsizei stride, const GLvoid *pointer);
GLboolean gl4es_glIsEnabled (GLenum cap);
GLboolean gl4es_glIsList (GLuint list);
GLboolean gl4es_glIsTexture (GLuint texture);
void gl4es_glLightModelf (GLenum pname, GLfloat param);
void gl4es_glLightModelfv (GLenum pname, const GLfloat *params);
void gl4es_glLightModeli (GLenum pname, GLint param);
void gl4es_glLightModeliv (GLenum pname, const GLint *params);
void gl4es_glLightf (GLenum light, GLenum pname, GLfloat param);
void gl4es_glLightfv (GLenum light, GLenum pname, const GLfloat *params);
void gl4es_glLighti (GLenum light, GLenum pname, GLint param);
void gl4es_glLightiv (GLenum light, GLenum pname, const GLint *params);
void gl4es_glLineStipple (GLint factor, GLushort pattern);
void gl4es_glLineWidth (GLfloat width);
void gl4es_glListBase (GLuint base);
void gl4es_glLoadIdentity (void);
void gl4es_glLoadMatrixd (const GLdouble *m);
void gl4es_glLoadMatrixf (const GLfloat *m);
void gl4es_glLoadName (GLuint name);
void gl4es_glLogicOp (GLenum opcode);
void gl4es_glMap1d (GLenum target, GLdouble u1, GLdouble u2, GLint stride, GLint order, const GLdouble *points);
void gl4es_glMap1f (GLenum target, GLfloat u1, GLfloat u2, GLint stride, GLint order, const GLfloat *points);
void gl4es_glMap2d (GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, const GLdouble *points);
void gl4es_glMap2f (GLenum target, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, const GLfloat *points);
void gl4es_glMapGrid1d (GLint un, GLdouble u1, GLdouble u2);
void gl4es_glMapGrid1f (GLint un, GLfloat u1, GLfloat u2);
void gl4es_glMapGrid2d (GLint un, GLdouble u1, GLdouble u2, GLint vn, GLdouble v1, GLdouble v2);
void gl4es_glMapGrid2f (GLint un, GLfloat u1, GLfloat u2, GLint vn, GLfloat v1, GLfloat v2);
void gl4es_glMaterialf (GLenum face, GLenum pname, GLfloat param);
void gl4es_glMaterialfv (GLenum face, GLenum pname, const GLfloat *params);
void gl4es_glMateriali (GLenum face, GLenum pname, GLint param);
void gl4es_glMaterialiv (GLenum face, GLenum pname, const GLint *params);
void gl4es_glMatrixMode (GLenum mode);
void gl4es_glMultMatrixd (const GLdouble *m);
void gl4es_glMultMatrixf (const GLfloat *m);
void gl4es_glNewList (GLuint list, GLenum mode);
void gl4es_glNormal3b (GLbyte nx, GLbyte ny, GLbyte nz);
void gl4es_glNormal3bv (const GLbyte *v);
void gl4es_glNormal3d (GLdouble nx, GLdouble ny, GLdouble nz);
void gl4es_glNormal3dv (const GLdouble *v);
void gl4es_glNormal3f (GLfloat nx, GLfloat ny, GLfloat nz);
void gl4es_glNormal3fv (const GLfloat *v);
void gl4es_glNormal3i (GLint nx, GLint ny, GLint nz);
void gl4es_glNormal3iv (const GLint *v);
void gl4es_glNormal3s (GLshort nx, GLshort ny, GLshort nz);
void gl4es_glNormal3sv (const GLshort *v);
void gl4es_glNormalPointer (GLenum type, GLsizei stride, const GLvoid *pointer);
void gl4es_glOrtho (GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
void gl4es_glPassThrough (GLfloat token);
void gl4es_glPixelMapfv (GLenum map, GLsizei mapsize, const GLfloat *values);
void gl4es_glPixelMapuiv (GLenum map, GLsizei mapsize, const GLuint *values);
void gl4es_glPixelMapusv (GLenum map, GLsizei mapsize, const GLushort *values);
void gl4es_glPixelStoref (GLenum pname, GLfloat param);
void gl4es_glPixelStorei (GLenum pname, GLint param);
void gl4es_glPixelTransferf (GLenum pname, GLfloat param);
void gl4es_glPixelTransferi (GLenum pname, GLint param);
void gl4es_glPixelZoom (GLfloat xfactor, GLfloat yfactor);
void gl4es_glPointSize (GLfloat size);
void gl4es_glPolygonMode (GLenum face, GLenum mode);
void gl4es_glPolygonOffset (GLfloat factor, GLfloat units);
void gl4es_glPolygonStipple (const GLubyte *mask);
void gl4es_glPopAttrib (void);
void gl4es_glPopClientAttrib (void);
void gl4es_glPopMatrix (void);
void gl4es_glPopName (void);
void gl4es_glPrioritizeTextures (GLsizei n, const GLuint *textures, const GLclampf *priorities);
void gl4es_glPushAttrib (GLbitfield mask);
void gl4es_glPushClientAttrib (GLbitfield mask);
void gl4es_glPushMatrix (void);
void gl4es_glPushName (GLuint name);
void gl4es_glRasterPos2d (GLdouble x, GLdouble y);
void gl4es_glRasterPos2dv (const GLdouble *v);
void gl4es_glRasterPos2f (GLfloat x, GLfloat y);
void gl4es_glRasterPos2fv (const GLfloat *v);
void gl4es_glRasterPos2i (GLint x, GLint y);
void gl4es_glRasterPos2iv (const GLint *v);
void gl4es_glRasterPos2s (GLshort x, GLshort y);
void gl4es_glRasterPos2sv (const GLshort *v);
void gl4es_glRasterPos3d (GLdouble x, GLdouble y, GLdouble z);
void gl4es_glRasterPos3dv (const GLdouble *v);
void gl4es_glRasterPos3f (GLfloat x, GLfloat y, GLfloat z);
void gl4es_glRasterPos3fv (const GLfloat *v);
void gl4es_glRasterPos3i (GLint x, GLint y, GLint z);
void gl4es_glRasterPos3iv (const GLint *v);
void gl4es_glRasterPos3s (GLshort x, GLshort y, GLshort z);
void gl4es_glRasterPos3sv (const GLshort *v);
void gl4es_glRasterPos4d (GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void gl4es_glRasterPos4dv (const GLdouble *v);
void gl4es_glRasterPos4f (GLfloat x, GLfloat y, GLfloat z, GLfloat w);
void gl4es_glRasterPos4fv (const GLfloat *v);
void gl4es_glRasterPos4i (GLint x, GLint y, GLint z, GLint w);
void gl4es_glRasterPos4iv (const GLint *v);
void gl4es_glRasterPos4s (GLshort x, GLshort y, GLshort z, GLshort w);
void gl4es_glRasterPos4sv (const GLshort *v);
void gl4es_glReadBuffer (GLenum mode);
void gl4es_glReadPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
void gl4es_glRectd (GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2);
void gl4es_glRectdv (const GLdouble *v1, const GLdouble *v2);
void gl4es_glRectf (GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2);
void gl4es_glRectfv (const GLfloat *v1, const GLfloat *v2);
void gl4es_glRecti (GLint x1, GLint y1, GLint x2, GLint y2);
void gl4es_glRectiv (const GLint *v1, const GLint *v2);
void gl4es_glRects (GLshort x1, GLshort y1, GLshort x2, GLshort y2);
void gl4es_glRectsv (const GLshort *v1, const GLshort *v2);
GLint gl4es_glRenderMode (GLenum mode);
void gl4es_glRotated (GLdouble angle, GLdouble x, GLdouble y, GLdouble z);
void gl4es_glRotatef (GLfloat angle, GLfloat x, GLfloat y, GLfloat z);
void gl4es_glScaled (GLdouble x, GLdouble y, GLdouble z);
void gl4es_glScalef (GLfloat x, GLfloat y, GLfloat z);
void gl4es_glScissor (GLint x, GLint y, GLsizei width, GLsizei height);
void gl4es_glSelectBuffer (GLsizei size, GLuint *buffer);
void gl4es_glShadeModel (GLenum mode);
void gl4es_glStencilFunc (GLenum func, GLint ref, GLuint mask);
void gl4es_glStencilMask (GLuint mask);
void gl4es_glStencilOp (GLenum fail, GLenum zfail, GLenum zpass);
void gl4es_glTexCoord1d (GLdouble s);
void gl4es_glTexCoord1dv (const GLdouble *v);
void gl4es_glTexCoord1f (GLfloat s);
void gl4es_glTexCoord1fv (const GLfloat *v);
void gl4es_glTexCoord1i (GLint s);
void gl4es_glTexCoord1iv (const GLint *v);
void gl4es_glTexCoord1s (GLshort s);
void gl4es_glTexCoord1sv (const GLshort *v);
void gl4es_glTexCoord2d (GLdouble s, GLdouble t);
void gl4es_glTexCoord2dv (const GLdouble *v);
void gl4es_glTexCoord2f (GLfloat s, GLfloat t);
void gl4es_glTexCoord2fv (const GLfloat *v);
void gl4es_glTexCoord2i (GLint s, GLint t);
void gl4es_glTexCoord2iv (const GLint *v);
void gl4es_glTexCoord2s (GLshort s, GLshort t);
void gl4es_glTexCoord2sv (const GLshort *v);
void gl4es_glTexCoord3d (GLdouble s, GLdouble t, GLdouble r);
void gl4es_glTexCoord3dv (const GLdouble *v);
void gl4es_glTexCoord3f (GLfloat s, GLfloat t, GLfloat r);
void gl4es_glTexCoord3fv (const GLfloat *v);
void gl4es_glTexCoord3i (GLint s, GLint t, GLint r);
void gl4es_glTexCoord3iv (const GLint *v);
void gl4es_glTexCoord3s (GLshort s, GLshort t, GLshort r);
void gl4es_glTexCoord3sv (const GLshort *v);
void gl4es_glTexCoord4d (GLdouble s, GLdouble t, GLdouble r, GLdouble q);
void gl4es_glTexCoord4dv (const GLdouble *v);
void gl4es_glTexCoord4f (GLfloat s, GLfloat t, GLfloat r, GLfloat q);
void gl4es_glTexCoord4fv (const GLfloat *v);
void gl4es_glTexCoord4i (GLint s, GLint t, GLint r, GLint q);
void gl4es_glTexCoord4iv (const GLint *v);
void gl4es_glTexCoord4s (GLshort s, GLshort t, GLshort r, GLshort q);
void gl4es_glTexCoord4sv (const GLshort *v);
void gl4es_glTexCoordPointer (GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void gl4es_glTexEnvf (GLenum target, GLenum pname, GLfloat param);
void gl4es_glTexEnvfv (GLenum target, GLenum pname, const GLfloat *params);
void gl4es_glTexEnvi (GLenum target, GLenum pname, GLint param);
void gl4es_glTexEnviv (GLenum target, GLenum pname, const GLint *params);
void gl4es_glTexGend (GLenum coord, GLenum pname, GLdouble param);
void gl4es_glTexGendv (GLenum coord, GLenum pname, const GLdouble *params);
void gl4es_glTexGenf (GLenum coord, GLenum pname, GLfloat param);
void gl4es_glTexGenfv (GLenum coord, GLenum pname, const GLfloat *params);
void gl4es_glTexGeni (GLenum coord, GLenum pname, GLint param);
void gl4es_glTexGeniv (GLenum coord, GLenum pname, const GLint *params);
void gl4es_glTexImage1D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void gl4es_glTexImage2D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void gl4es_glTexParameterf (GLenum target, GLenum pname, GLfloat param);
void gl4es_glTexParameterfv (GLenum target, GLenum pname, const GLfloat *params);
void gl4es_glTexParameteri (GLenum target, GLenum pname, GLint param);
void gl4es_glTexParameteriv (GLenum target, GLenum pname, const GLint *params);
void gl4es_glTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const GLvoid *pixels);
void gl4es_glTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
void gl4es_glTranslated (GLdouble x, GLdouble y, GLdouble z);
void gl4es_glTranslatef (GLfloat x, GLfloat y, GLfloat z);
void gl4es_glVertex2d (GLdouble x, GLdouble y);
void gl4es_glVertex2dv (const GLdouble *v);
void gl4es_glVertex2f (GLfloat x, GLfloat y);
void gl4es_glVertex2fv (const GLfloat *v);
void gl4es_glVertex2i (GLint x, GLint y);
void gl4es_glVertex2iv (const GLint *v);
void gl4es_glVertex2s (GLshort x, GLshort y);
void gl4es_glVertex2sv (const GLshort *v);
void gl4es_glVertex3d (GLdouble x, GLdouble y, GLdouble z);
void gl4es_glVertex3dv (const GLdouble *v);
void gl4es_glVertex3f (GLfloat x, GLfloat y, GLfloat z);
void gl4es_glVertex3fv (const GLfloat *v);
void gl4es_glVertex3i (GLint x, GLint y, GLint z);
void gl4es_glVertex3iv (const GLint *v);
void gl4es_glVertex3s (GLshort x, GLshort y, GLshort z);
void gl4es_glVertex3sv (const GLshort *v);
void gl4es_glVertex4d (GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void gl4es_glVertex4dv (const GLdouble *v);
void gl4es_glVertex4f (GLfloat x, GLfloat y, GLfloat z, GLfloat w);
void gl4es_glVertex4fv (const GLfloat *v);
void gl4es_glVertex4i (GLint x, GLint y, GLint z, GLint w);
void gl4es_glVertex4iv (const GLint *v);
void gl4es_glVertex4s (GLshort x, GLshort y, GLshort z, GLshort w);
void gl4es_glVertex4sv (const GLshort *v);
void gl4es_glVertexPointer (GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void gl4es_glViewport (GLint x, GLint y, GLsizei width, GLsizei height);
typedef void ( * PFNGLARRAYELEMENTEXTPROC) (GLint i);
typedef void ( * PFNGLDRAWARRAYSEXTPROC) (GLenum mode, GLint first, GLsizei count);
typedef void ( * PFNGLVERTEXPOINTEREXTPROC) (GLint size, GLenum type, GLsizei stride, GLsizei count, const GLvoid *pointer);
typedef void ( * PFNGLNORMALPOINTEREXTPROC) (GLenum type, GLsizei stride, GLsizei count, const GLvoid *pointer);
typedef void ( * PFNGLCOLORPOINTEREXTPROC) (GLint size, GLenum type, GLsizei stride, GLsizei count, const GLvoid *pointer);
typedef void ( * PFNGLINDEXPOINTEREXTPROC) (GLenum type, GLsizei stride, GLsizei count, const GLvoid *pointer);
typedef void ( * PFNGLTEXCOORDPOINTEREXTPROC) (GLint size, GLenum type, GLsizei stride, GLsizei count, const GLvoid *pointer);
typedef void ( * PFNGLEDGEFLAGPOINTEREXTPROC) (GLsizei stride, GLsizei count, const GLboolean *pointer);
typedef void ( * PFNGLGETPOINTERVEXTPROC) (GLenum pname, GLvoid* *params);
typedef void ( * PFNGLARRAYELEMENTARRAYEXTPROC)(GLenum mode, GLsizei count, const GLvoid* pi);
typedef void ( * PFNGLDRAWRANGEELEMENTSWINPROC) (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const GLvoid *indices);
typedef void ( * PFNGLADDSWAPHINTRECTWINPROC) (GLint x, GLint y, GLsizei width, GLsizei height);
typedef void ( * PFNGLCOLORTABLEEXTPROC) (GLenum target, GLenum internalFormat, GLsizei width, GLenum format, GLenum type, const GLvoid *data);
typedef void ( * PFNGLCOLORSUBTABLEEXTPROC) (GLenum target, GLsizei start, GLsizei count, GLenum format, GLenum type, const GLvoid *data);
typedef void ( * PFNGLGETCOLORTABLEEXTPROC) (GLenum target, GLenum format, GLenum type, GLvoid *data);
typedef void ( * PFNGLGETCOLORTABLEPARAMETERIVEXTPROC) (GLenum target, GLenum pname, GLint *params);
typedef void ( * PFNGLGETCOLORTABLEPARAMETERFVEXTPROC) (GLenum target, GLenum pname, GLfloat *params);
/* #pragma endregion */
/* + END   C:/Program Files (x86)/Windows Kits/10/include/10.0.22621.0/um/GL/gl.h */


/* and this is a subset of glext.h hopefully up to version 3 */
]] require 'ffi.KHR.khrplatform' ffi.cdef[[
enum { GL_VERSION_1_2 = 1 };
enum { GL_UNSIGNED_BYTE_3_3_2 = 32818 };
enum { GL_UNSIGNED_SHORT_4_4_4_4 = 32819 };
enum { GL_UNSIGNED_SHORT_5_5_5_1 = 32820 };
enum { GL_UNSIGNED_INT_8_8_8_8 = 32821 };
enum { GL_UNSIGNED_INT_10_10_10_2 = 32822 };
enum { GL_TEXTURE_BINDING_3D = 32874 };
enum { GL_PACK_SKIP_IMAGES = 32875 };
enum { GL_PACK_IMAGE_HEIGHT = 32876 };
enum { GL_UNPACK_SKIP_IMAGES = 32877 };
enum { GL_UNPACK_IMAGE_HEIGHT = 32878 };
enum { GL_TEXTURE_3D = 32879 };
enum { GL_PROXY_TEXTURE_3D = 32880 };
enum { GL_TEXTURE_DEPTH = 32881 };
enum { GL_TEXTURE_WRAP_R = 32882 };
enum { GL_MAX_3D_TEXTURE_SIZE = 32883 };
enum { GL_UNSIGNED_BYTE_2_3_3_REV = 33634 };
enum { GL_UNSIGNED_SHORT_5_6_5 = 33635 };
enum { GL_UNSIGNED_SHORT_5_6_5_REV = 33636 };
enum { GL_UNSIGNED_SHORT_4_4_4_4_REV = 33637 };
enum { GL_UNSIGNED_SHORT_1_5_5_5_REV = 33638 };
enum { GL_UNSIGNED_INT_8_8_8_8_REV = 33639 };
enum { GL_UNSIGNED_INT_2_10_10_10_REV = 33640 };
enum { GL_BGR = 32992 };
enum { GL_BGRA = 32993 };
enum { GL_MAX_ELEMENTS_VERTICES = 33000 };
enum { GL_MAX_ELEMENTS_INDICES = 33001 };
enum { GL_CLAMP_TO_EDGE = 33071 };
enum { GL_TEXTURE_MIN_LOD = 33082 };
enum { GL_TEXTURE_MAX_LOD = 33083 };
enum { GL_TEXTURE_BASE_LEVEL = 33084 };
enum { GL_TEXTURE_MAX_LEVEL = 33085 };
enum { GL_SMOOTH_POINT_SIZE_RANGE = 2834 };
enum { GL_SMOOTH_POINT_SIZE_GRANULARITY = 2835 };
enum { GL_SMOOTH_LINE_WIDTH_RANGE = 2850 };
enum { GL_SMOOTH_LINE_WIDTH_GRANULARITY = 2851 };
enum { GL_ALIASED_LINE_WIDTH_RANGE = 33902 };
enum { GL_RESCALE_NORMAL = 32826 };
enum { GL_LIGHT_MODEL_COLOR_CONTROL = 33272 };
enum { GL_SINGLE_COLOR = 33273 };
enum { GL_SEPARATE_SPECULAR_COLOR = 33274 };
enum { GL_ALIASED_POINT_SIZE_RANGE = 33901 };
typedef void ( * PFNGLDRAWRANGEELEMENTSPROC) (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const void *indices);
typedef void ( * PFNGLTEXIMAGE3DPROC) (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, const void *pixels);
typedef void ( * PFNGLTEXSUBIMAGE3DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const void *pixels);
typedef void ( * PFNGLCOPYTEXSUBIMAGE3DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
extern void gl4es_glDrawRangeElements (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const void *indices);
extern void gl4es_glTexImage3D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, const void *pixels);
extern void gl4es_glTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const void *pixels);
extern void gl4es_glCopyTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
enum { GL_VERSION_1_3 = 1 };
enum { GL_TEXTURE0 = 33984 };
enum { GL_TEXTURE1 = 33985 };
enum { GL_TEXTURE2 = 33986 };
enum { GL_TEXTURE3 = 33987 };
enum { GL_TEXTURE4 = 33988 };
enum { GL_TEXTURE5 = 33989 };
enum { GL_TEXTURE6 = 33990 };
enum { GL_TEXTURE7 = 33991 };
enum { GL_TEXTURE8 = 33992 };
enum { GL_TEXTURE9 = 33993 };
enum { GL_TEXTURE10 = 33994 };
enum { GL_TEXTURE11 = 33995 };
enum { GL_TEXTURE12 = 33996 };
enum { GL_TEXTURE13 = 33997 };
enum { GL_TEXTURE14 = 33998 };
enum { GL_TEXTURE15 = 33999 };
enum { GL_TEXTURE16 = 34000 };
enum { GL_TEXTURE17 = 34001 };
enum { GL_TEXTURE18 = 34002 };
enum { GL_TEXTURE19 = 34003 };
enum { GL_TEXTURE20 = 34004 };
enum { GL_TEXTURE21 = 34005 };
enum { GL_TEXTURE22 = 34006 };
enum { GL_TEXTURE23 = 34007 };
enum { GL_TEXTURE24 = 34008 };
enum { GL_TEXTURE25 = 34009 };
enum { GL_TEXTURE26 = 34010 };
enum { GL_TEXTURE27 = 34011 };
enum { GL_TEXTURE28 = 34012 };
enum { GL_TEXTURE29 = 34013 };
enum { GL_TEXTURE30 = 34014 };
enum { GL_TEXTURE31 = 34015 };
enum { GL_ACTIVE_TEXTURE = 34016 };
enum { GL_MULTISAMPLE = 32925 };
enum { GL_SAMPLE_ALPHA_TO_COVERAGE = 32926 };
enum { GL_SAMPLE_ALPHA_TO_ONE = 32927 };
enum { GL_SAMPLE_COVERAGE = 32928 };
enum { GL_SAMPLE_BUFFERS = 32936 };
enum { GL_SAMPLES = 32937 };
enum { GL_SAMPLE_COVERAGE_VALUE = 32938 };
enum { GL_SAMPLE_COVERAGE_INVERT = 32939 };
enum { GL_TEXTURE_CUBE_MAP = 34067 };
enum { GL_TEXTURE_BINDING_CUBE_MAP = 34068 };
enum { GL_TEXTURE_CUBE_MAP_POSITIVE_X = 34069 };
enum { GL_TEXTURE_CUBE_MAP_NEGATIVE_X = 34070 };
enum { GL_TEXTURE_CUBE_MAP_POSITIVE_Y = 34071 };
enum { GL_TEXTURE_CUBE_MAP_NEGATIVE_Y = 34072 };
enum { GL_TEXTURE_CUBE_MAP_POSITIVE_Z = 34073 };
enum { GL_TEXTURE_CUBE_MAP_NEGATIVE_Z = 34074 };
enum { GL_PROXY_TEXTURE_CUBE_MAP = 34075 };
enum { GL_MAX_CUBE_MAP_TEXTURE_SIZE = 34076 };
enum { GL_COMPRESSED_RGB = 34029 };
enum { GL_COMPRESSED_RGBA = 34030 };
enum { GL_TEXTURE_COMPRESSION_HINT = 34031 };
enum { GL_TEXTURE_COMPRESSED_IMAGE_SIZE = 34464 };
enum { GL_TEXTURE_COMPRESSED = 34465 };
enum { GL_NUM_COMPRESSED_TEXTURE_FORMATS = 34466 };
enum { GL_COMPRESSED_TEXTURE_FORMATS = 34467 };
enum { GL_CLAMP_TO_BORDER = 33069 };
enum { GL_CLIENT_ACTIVE_TEXTURE = 34017 };
enum { GL_MAX_TEXTURE_UNITS = 34018 };
enum { GL_TRANSPOSE_MODELVIEW_MATRIX = 34019 };
enum { GL_TRANSPOSE_PROJECTION_MATRIX = 34020 };
enum { GL_TRANSPOSE_TEXTURE_MATRIX = 34021 };
enum { GL_TRANSPOSE_COLOR_MATRIX = 34022 };
enum { GL_MULTISAMPLE_BIT = 536870912 };
enum { GL_NORMAL_MAP = 34065 };
enum { GL_REFLECTION_MAP = 34066 };
enum { GL_COMPRESSED_ALPHA = 34025 };
enum { GL_COMPRESSED_LUMINANCE = 34026 };
enum { GL_COMPRESSED_LUMINANCE_ALPHA = 34027 };
enum { GL_COMPRESSED_INTENSITY = 34028 };
enum { GL_COMBINE = 34160 };
enum { GL_COMBINE_RGB = 34161 };
enum { GL_COMBINE_ALPHA = 34162 };
enum { GL_SOURCE0_RGB = 34176 };
enum { GL_SOURCE1_RGB = 34177 };
enum { GL_SOURCE2_RGB = 34178 };
enum { GL_SOURCE0_ALPHA = 34184 };
enum { GL_SOURCE1_ALPHA = 34185 };
enum { GL_SOURCE2_ALPHA = 34186 };
enum { GL_OPERAND0_RGB = 34192 };
enum { GL_OPERAND1_RGB = 34193 };
enum { GL_OPERAND2_RGB = 34194 };
enum { GL_OPERAND0_ALPHA = 34200 };
enum { GL_OPERAND1_ALPHA = 34201 };
enum { GL_OPERAND2_ALPHA = 34202 };
enum { GL_RGB_SCALE = 34163 };
enum { GL_ADD_SIGNED = 34164 };
enum { GL_INTERPOLATE = 34165 };
enum { GL_SUBTRACT = 34023 };
enum { GL_CONSTANT = 34166 };
enum { GL_PRIMARY_COLOR = 34167 };
enum { GL_PREVIOUS = 34168 };
enum { GL_DOT3_RGB = 34478 };
enum { GL_DOT3_RGBA = 34479 };
typedef void ( * PFNGLACTIVETEXTUREPROC) (GLenum texture);
typedef void ( * PFNGLSAMPLECOVERAGEPROC) (GLfloat value, GLboolean invert);
typedef void ( * PFNGLCOMPRESSEDTEXIMAGE3DPROC) (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const void *data);
typedef void ( * PFNGLCOMPRESSEDTEXIMAGE2DPROC) (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const void *data);
typedef void ( * PFNGLCOMPRESSEDTEXIMAGE1DPROC) (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const void *data);
typedef void ( * PFNGLCOMPRESSEDTEXSUBIMAGE3DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const void *data);
typedef void ( * PFNGLCOMPRESSEDTEXSUBIMAGE2DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const void *data);
typedef void ( * PFNGLCOMPRESSEDTEXSUBIMAGE1DPROC) (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const void *data);
typedef void ( * PFNGLGETCOMPRESSEDTEXIMAGEPROC) (GLenum target, GLint level, void *img);
typedef void ( * PFNGLCLIENTACTIVETEXTUREPROC) (GLenum texture);
typedef void ( * PFNGLMULTITEXCOORD1DPROC) (GLenum target, GLdouble s);
typedef void ( * PFNGLMULTITEXCOORD1DVPROC) (GLenum target, const GLdouble *v);
typedef void ( * PFNGLMULTITEXCOORD1FPROC) (GLenum target, GLfloat s);
typedef void ( * PFNGLMULTITEXCOORD1FVPROC) (GLenum target, const GLfloat *v);
typedef void ( * PFNGLMULTITEXCOORD1IPROC) (GLenum target, GLint s);
typedef void ( * PFNGLMULTITEXCOORD1IVPROC) (GLenum target, const GLint *v);
typedef void ( * PFNGLMULTITEXCOORD1SPROC) (GLenum target, GLshort s);
typedef void ( * PFNGLMULTITEXCOORD1SVPROC) (GLenum target, const GLshort *v);
typedef void ( * PFNGLMULTITEXCOORD2DPROC) (GLenum target, GLdouble s, GLdouble t);
typedef void ( * PFNGLMULTITEXCOORD2DVPROC) (GLenum target, const GLdouble *v);
typedef void ( * PFNGLMULTITEXCOORD2FPROC) (GLenum target, GLfloat s, GLfloat t);
typedef void ( * PFNGLMULTITEXCOORD2FVPROC) (GLenum target, const GLfloat *v);
typedef void ( * PFNGLMULTITEXCOORD2IPROC) (GLenum target, GLint s, GLint t);
typedef void ( * PFNGLMULTITEXCOORD2IVPROC) (GLenum target, const GLint *v);
typedef void ( * PFNGLMULTITEXCOORD2SPROC) (GLenum target, GLshort s, GLshort t);
typedef void ( * PFNGLMULTITEXCOORD2SVPROC) (GLenum target, const GLshort *v);
typedef void ( * PFNGLMULTITEXCOORD3DPROC) (GLenum target, GLdouble s, GLdouble t, GLdouble r);
typedef void ( * PFNGLMULTITEXCOORD3DVPROC) (GLenum target, const GLdouble *v);
typedef void ( * PFNGLMULTITEXCOORD3FPROC) (GLenum target, GLfloat s, GLfloat t, GLfloat r);
typedef void ( * PFNGLMULTITEXCOORD3FVPROC) (GLenum target, const GLfloat *v);
typedef void ( * PFNGLMULTITEXCOORD3IPROC) (GLenum target, GLint s, GLint t, GLint r);
typedef void ( * PFNGLMULTITEXCOORD3IVPROC) (GLenum target, const GLint *v);
typedef void ( * PFNGLMULTITEXCOORD3SPROC) (GLenum target, GLshort s, GLshort t, GLshort r);
typedef void ( * PFNGLMULTITEXCOORD3SVPROC) (GLenum target, const GLshort *v);
typedef void ( * PFNGLMULTITEXCOORD4DPROC) (GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q);
typedef void ( * PFNGLMULTITEXCOORD4DVPROC) (GLenum target, const GLdouble *v);
typedef void ( * PFNGLMULTITEXCOORD4FPROC) (GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q);
typedef void ( * PFNGLMULTITEXCOORD4FVPROC) (GLenum target, const GLfloat *v);
typedef void ( * PFNGLMULTITEXCOORD4IPROC) (GLenum target, GLint s, GLint t, GLint r, GLint q);
typedef void ( * PFNGLMULTITEXCOORD4IVPROC) (GLenum target, const GLint *v);
typedef void ( * PFNGLMULTITEXCOORD4SPROC) (GLenum target, GLshort s, GLshort t, GLshort r, GLshort q);
typedef void ( * PFNGLMULTITEXCOORD4SVPROC) (GLenum target, const GLshort *v);
typedef void ( * PFNGLLOADTRANSPOSEMATRIXFPROC) (const GLfloat *m);
typedef void ( * PFNGLLOADTRANSPOSEMATRIXDPROC) (const GLdouble *m);
typedef void ( * PFNGLMULTTRANSPOSEMATRIXFPROC) (const GLfloat *m);
typedef void ( * PFNGLMULTTRANSPOSEMATRIXDPROC) (const GLdouble *m);
extern void gl4es_glActiveTexture (GLenum texture);
extern void gl4es_glSampleCoverage (GLfloat value, GLboolean invert);
extern void gl4es_glCompressedTexImage3D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const void *data);
extern void gl4es_glCompressedTexImage2D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const void *data);
extern void gl4es_glCompressedTexImage1D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const void *data);
extern void gl4es_glCompressedTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const void *data);
extern void gl4es_glCompressedTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const void *data);
extern void gl4es_glCompressedTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const void *data);
extern void gl4es_glGetCompressedTexImage (GLenum target, GLint level, void *img);
extern void gl4es_glClientActiveTexture (GLenum texture);
extern void gl4es_glMultiTexCoord1d (GLenum target, GLdouble s);
extern void gl4es_glMultiTexCoord1dv (GLenum target, const GLdouble *v);
extern void gl4es_glMultiTexCoord1f (GLenum target, GLfloat s);
extern void gl4es_glMultiTexCoord1fv (GLenum target, const GLfloat *v);
extern void gl4es_glMultiTexCoord1i (GLenum target, GLint s);
extern void gl4es_glMultiTexCoord1iv (GLenum target, const GLint *v);
extern void gl4es_glMultiTexCoord1s (GLenum target, GLshort s);
extern void gl4es_glMultiTexCoord1sv (GLenum target, const GLshort *v);
extern void gl4es_glMultiTexCoord2d (GLenum target, GLdouble s, GLdouble t);
extern void gl4es_glMultiTexCoord2dv (GLenum target, const GLdouble *v);
extern void gl4es_glMultiTexCoord2f (GLenum target, GLfloat s, GLfloat t);
extern void gl4es_glMultiTexCoord2fv (GLenum target, const GLfloat *v);
extern void gl4es_glMultiTexCoord2i (GLenum target, GLint s, GLint t);
extern void gl4es_glMultiTexCoord2iv (GLenum target, const GLint *v);
extern void gl4es_glMultiTexCoord2s (GLenum target, GLshort s, GLshort t);
extern void gl4es_glMultiTexCoord2sv (GLenum target, const GLshort *v);
extern void gl4es_glMultiTexCoord3d (GLenum target, GLdouble s, GLdouble t, GLdouble r);
extern void gl4es_glMultiTexCoord3dv (GLenum target, const GLdouble *v);
extern void gl4es_glMultiTexCoord3f (GLenum target, GLfloat s, GLfloat t, GLfloat r);
extern void gl4es_glMultiTexCoord3fv (GLenum target, const GLfloat *v);
extern void gl4es_glMultiTexCoord3i (GLenum target, GLint s, GLint t, GLint r);
extern void gl4es_glMultiTexCoord3iv (GLenum target, const GLint *v);
extern void gl4es_glMultiTexCoord3s (GLenum target, GLshort s, GLshort t, GLshort r);
extern void gl4es_glMultiTexCoord3sv (GLenum target, const GLshort *v);
extern void gl4es_glMultiTexCoord4d (GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q);
extern void gl4es_glMultiTexCoord4dv (GLenum target, const GLdouble *v);
extern void gl4es_glMultiTexCoord4f (GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q);
extern void gl4es_glMultiTexCoord4fv (GLenum target, const GLfloat *v);
extern void gl4es_glMultiTexCoord4i (GLenum target, GLint s, GLint t, GLint r, GLint q);
extern void gl4es_glMultiTexCoord4iv (GLenum target, const GLint *v);
extern void gl4es_glMultiTexCoord4s (GLenum target, GLshort s, GLshort t, GLshort r, GLshort q);
extern void gl4es_glMultiTexCoord4sv (GLenum target, const GLshort *v);
extern void gl4es_glLoadTransposeMatrixf (const GLfloat *m);
extern void gl4es_glLoadTransposeMatrixd (const GLdouble *m);
extern void gl4es_glMultTransposeMatrixf (const GLfloat *m);
extern void gl4es_glMultTransposeMatrixd (const GLdouble *m);
enum { GL_VERSION_1_4 = 1 };
enum { GL_BLEND_DST_RGB = 32968 };
enum { GL_BLEND_SRC_RGB = 32969 };
enum { GL_BLEND_DST_ALPHA = 32970 };
enum { GL_BLEND_SRC_ALPHA = 32971 };
enum { GL_POINT_FADE_THRESHOLD_SIZE = 33064 };
enum { GL_DEPTH_COMPONENT16 = 33189 };
enum { GL_DEPTH_COMPONENT24 = 33190 };
enum { GL_DEPTH_COMPONENT32 = 33191 };
enum { GL_MIRRORED_REPEAT = 33648 };
enum { GL_MAX_TEXTURE_LOD_BIAS = 34045 };
enum { GL_TEXTURE_LOD_BIAS = 34049 };
enum { GL_INCR_WRAP = 34055 };
enum { GL_DECR_WRAP = 34056 };
enum { GL_TEXTURE_DEPTH_SIZE = 34890 };
enum { GL_TEXTURE_COMPARE_MODE = 34892 };
enum { GL_TEXTURE_COMPARE_FUNC = 34893 };
enum { GL_POINT_SIZE_MIN = 33062 };
enum { GL_POINT_SIZE_MAX = 33063 };
enum { GL_POINT_DISTANCE_ATTENUATION = 33065 };
enum { GL_GENERATE_MIPMAP = 33169 };
enum { GL_GENERATE_MIPMAP_HINT = 33170 };
enum { GL_FOG_COORDINATE_SOURCE = 33872 };
enum { GL_FOG_COORDINATE = 33873 };
enum { GL_FRAGMENT_DEPTH = 33874 };
enum { GL_CURRENT_FOG_COORDINATE = 33875 };
enum { GL_FOG_COORDINATE_ARRAY_TYPE = 33876 };
enum { GL_FOG_COORDINATE_ARRAY_STRIDE = 33877 };
enum { GL_FOG_COORDINATE_ARRAY_POINTER = 33878 };
enum { GL_FOG_COORDINATE_ARRAY = 33879 };
enum { GL_COLOR_SUM = 33880 };
enum { GL_CURRENT_SECONDARY_COLOR = 33881 };
enum { GL_SECONDARY_COLOR_ARRAY_SIZE = 33882 };
enum { GL_SECONDARY_COLOR_ARRAY_TYPE = 33883 };
enum { GL_SECONDARY_COLOR_ARRAY_STRIDE = 33884 };
enum { GL_SECONDARY_COLOR_ARRAY_POINTER = 33885 };
enum { GL_SECONDARY_COLOR_ARRAY = 33886 };
enum { GL_TEXTURE_FILTER_CONTROL = 34048 };
enum { GL_DEPTH_TEXTURE_MODE = 34891 };
enum { GL_COMPARE_R_TO_TEXTURE = 34894 };
enum { GL_BLEND_COLOR = 32773 };
enum { GL_BLEND_EQUATION = 32777 };
enum { GL_CONSTANT_COLOR = 32769 };
enum { GL_ONE_MINUS_CONSTANT_COLOR = 32770 };
enum { GL_CONSTANT_ALPHA = 32771 };
enum { GL_ONE_MINUS_CONSTANT_ALPHA = 32772 };
enum { GL_FUNC_ADD = 32774 };
enum { GL_FUNC_REVERSE_SUBTRACT = 32779 };
enum { GL_FUNC_SUBTRACT = 32778 };
enum { GL_MIN = 32775 };
enum { GL_MAX = 32776 };
typedef void ( * PFNGLBLENDFUNCSEPARATEPROC) (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha);
typedef void ( * PFNGLMULTIDRAWARRAYSPROC) (GLenum mode, const GLint *first, const GLsizei *count, GLsizei drawcount);
typedef void ( * PFNGLMULTIDRAWELEMENTSPROC) (GLenum mode, const GLsizei *count, GLenum type, const void *const*indices, GLsizei drawcount);
typedef void ( * PFNGLPOINTPARAMETERFPROC) (GLenum pname, GLfloat param);
typedef void ( * PFNGLPOINTPARAMETERFVPROC) (GLenum pname, const GLfloat *params);
typedef void ( * PFNGLPOINTPARAMETERIPROC) (GLenum pname, GLint param);
typedef void ( * PFNGLPOINTPARAMETERIVPROC) (GLenum pname, const GLint *params);
typedef void ( * PFNGLFOGCOORDFPROC) (GLfloat coord);
typedef void ( * PFNGLFOGCOORDFVPROC) (const GLfloat *coord);
typedef void ( * PFNGLFOGCOORDDPROC) (GLdouble coord);
typedef void ( * PFNGLFOGCOORDDVPROC) (const GLdouble *coord);
typedef void ( * PFNGLFOGCOORDPOINTERPROC) (GLenum type, GLsizei stride, const void *pointer);
typedef void ( * PFNGLSECONDARYCOLOR3BPROC) (GLbyte red, GLbyte green, GLbyte blue);
typedef void ( * PFNGLSECONDARYCOLOR3BVPROC) (const GLbyte *v);
typedef void ( * PFNGLSECONDARYCOLOR3DPROC) (GLdouble red, GLdouble green, GLdouble blue);
typedef void ( * PFNGLSECONDARYCOLOR3DVPROC) (const GLdouble *v);
typedef void ( * PFNGLSECONDARYCOLOR3FPROC) (GLfloat red, GLfloat green, GLfloat blue);
typedef void ( * PFNGLSECONDARYCOLOR3FVPROC) (const GLfloat *v);
typedef void ( * PFNGLSECONDARYCOLOR3IPROC) (GLint red, GLint green, GLint blue);
typedef void ( * PFNGLSECONDARYCOLOR3IVPROC) (const GLint *v);
typedef void ( * PFNGLSECONDARYCOLOR3SPROC) (GLshort red, GLshort green, GLshort blue);
typedef void ( * PFNGLSECONDARYCOLOR3SVPROC) (const GLshort *v);
typedef void ( * PFNGLSECONDARYCOLOR3UBPROC) (GLubyte red, GLubyte green, GLubyte blue);
typedef void ( * PFNGLSECONDARYCOLOR3UBVPROC) (const GLubyte *v);
typedef void ( * PFNGLSECONDARYCOLOR3UIPROC) (GLuint red, GLuint green, GLuint blue);
typedef void ( * PFNGLSECONDARYCOLOR3UIVPROC) (const GLuint *v);
typedef void ( * PFNGLSECONDARYCOLOR3USPROC) (GLushort red, GLushort green, GLushort blue);
typedef void ( * PFNGLSECONDARYCOLOR3USVPROC) (const GLushort *v);
typedef void ( * PFNGLSECONDARYCOLORPOINTERPROC) (GLint size, GLenum type, GLsizei stride, const void *pointer);
typedef void ( * PFNGLWINDOWPOS2DPROC) (GLdouble x, GLdouble y);
typedef void ( * PFNGLWINDOWPOS2DVPROC) (const GLdouble *v);
typedef void ( * PFNGLWINDOWPOS2FPROC) (GLfloat x, GLfloat y);
typedef void ( * PFNGLWINDOWPOS2FVPROC) (const GLfloat *v);
typedef void ( * PFNGLWINDOWPOS2IPROC) (GLint x, GLint y);
typedef void ( * PFNGLWINDOWPOS2IVPROC) (const GLint *v);
typedef void ( * PFNGLWINDOWPOS2SPROC) (GLshort x, GLshort y);
typedef void ( * PFNGLWINDOWPOS2SVPROC) (const GLshort *v);
typedef void ( * PFNGLWINDOWPOS3DPROC) (GLdouble x, GLdouble y, GLdouble z);
typedef void ( * PFNGLWINDOWPOS3DVPROC) (const GLdouble *v);
typedef void ( * PFNGLWINDOWPOS3FPROC) (GLfloat x, GLfloat y, GLfloat z);
typedef void ( * PFNGLWINDOWPOS3FVPROC) (const GLfloat *v);
typedef void ( * PFNGLWINDOWPOS3IPROC) (GLint x, GLint y, GLint z);
typedef void ( * PFNGLWINDOWPOS3IVPROC) (const GLint *v);
typedef void ( * PFNGLWINDOWPOS3SPROC) (GLshort x, GLshort y, GLshort z);
typedef void ( * PFNGLWINDOWPOS3SVPROC) (const GLshort *v);
typedef void ( * PFNGLBLENDCOLORPROC) (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
typedef void ( * PFNGLBLENDEQUATIONPROC) (GLenum mode);
extern void gl4es_glBlendFuncSeparate (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha);
extern void gl4es_glMultiDrawArrays (GLenum mode, const GLint *first, const GLsizei *count, GLsizei drawcount);
extern void gl4es_glMultiDrawElements (GLenum mode, const GLsizei *count, GLenum type, const void *const*indices, GLsizei drawcount);
extern void gl4es_glPointParameterf (GLenum pname, GLfloat param);
extern void gl4es_glPointParameterfv (GLenum pname, const GLfloat *params);
extern void gl4es_glPointParameteri (GLenum pname, GLint param);
extern void gl4es_glPointParameteriv (GLenum pname, const GLint *params);
extern void gl4es_glFogCoordf (GLfloat coord);
extern void gl4es_glFogCoordfv (const GLfloat *coord);
extern void gl4es_glFogCoordd (GLdouble coord);
extern void gl4es_glFogCoorddv (const GLdouble *coord);
extern void gl4es_glFogCoordPointer (GLenum type, GLsizei stride, const void *pointer);
extern void gl4es_glSecondaryColor3b (GLbyte red, GLbyte green, GLbyte blue);
extern void gl4es_glSecondaryColor3bv (const GLbyte *v);
extern void gl4es_glSecondaryColor3d (GLdouble red, GLdouble green, GLdouble blue);
extern void gl4es_glSecondaryColor3dv (const GLdouble *v);
extern void gl4es_glSecondaryColor3f (GLfloat red, GLfloat green, GLfloat blue);
extern void gl4es_glSecondaryColor3fv (const GLfloat *v);
extern void gl4es_glSecondaryColor3i (GLint red, GLint green, GLint blue);
extern void gl4es_glSecondaryColor3iv (const GLint *v);
extern void gl4es_glSecondaryColor3s (GLshort red, GLshort green, GLshort blue);
extern void gl4es_glSecondaryColor3sv (const GLshort *v);
extern void gl4es_glSecondaryColor3ub (GLubyte red, GLubyte green, GLubyte blue);
extern void gl4es_glSecondaryColor3ubv (const GLubyte *v);
extern void gl4es_glSecondaryColor3ui (GLuint red, GLuint green, GLuint blue);
extern void gl4es_glSecondaryColor3uiv (const GLuint *v);
extern void gl4es_glSecondaryColor3us (GLushort red, GLushort green, GLushort blue);
extern void gl4es_glSecondaryColor3usv (const GLushort *v);
extern void gl4es_glSecondaryColorPointer (GLint size, GLenum type, GLsizei stride, const void *pointer);
extern void gl4es_glWindowPos2d (GLdouble x, GLdouble y);
extern void gl4es_glWindowPos2dv (const GLdouble *v);
extern void gl4es_glWindowPos2f (GLfloat x, GLfloat y);
extern void gl4es_glWindowPos2fv (const GLfloat *v);
extern void gl4es_glWindowPos2i (GLint x, GLint y);
extern void gl4es_glWindowPos2iv (const GLint *v);
extern void gl4es_glWindowPos2s (GLshort x, GLshort y);
extern void gl4es_glWindowPos2sv (const GLshort *v);
extern void gl4es_glWindowPos3d (GLdouble x, GLdouble y, GLdouble z);
extern void gl4es_glWindowPos3dv (const GLdouble *v);
extern void gl4es_glWindowPos3f (GLfloat x, GLfloat y, GLfloat z);
extern void gl4es_glWindowPos3fv (const GLfloat *v);
extern void gl4es_glWindowPos3i (GLint x, GLint y, GLint z);
extern void gl4es_glWindowPos3iv (const GLint *v);
extern void gl4es_glWindowPos3s (GLshort x, GLshort y, GLshort z);
extern void gl4es_glWindowPos3sv (const GLshort *v);
extern void gl4es_glBlendColor (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
extern void gl4es_glBlendEquation (GLenum mode);
enum { GL_VERSION_1_5 = 1 };
typedef khronos_ssize_t GLsizeiptr;
typedef khronos_intptr_t GLintptr;
enum { GL_BUFFER_SIZE = 34660 };
enum { GL_BUFFER_USAGE = 34661 };
enum { GL_QUERY_COUNTER_BITS = 34916 };
enum { GL_CURRENT_QUERY = 34917 };
enum { GL_QUERY_RESULT = 34918 };
enum { GL_QUERY_RESULT_AVAILABLE = 34919 };
enum { GL_ARRAY_BUFFER = 34962 };
enum { GL_ELEMENT_ARRAY_BUFFER = 34963 };
enum { GL_ARRAY_BUFFER_BINDING = 34964 };
enum { GL_ELEMENT_ARRAY_BUFFER_BINDING = 34965 };
enum { GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 34975 };
enum { GL_READ_ONLY = 35000 };
enum { GL_WRITE_ONLY = 35001 };
enum { GL_READ_WRITE = 35002 };
enum { GL_BUFFER_ACCESS = 35003 };
enum { GL_BUFFER_MAPPED = 35004 };
enum { GL_BUFFER_MAP_POINTER = 35005 };
enum { GL_STREAM_DRAW = 35040 };
enum { GL_STREAM_READ = 35041 };
enum { GL_STREAM_COPY = 35042 };
enum { GL_STATIC_DRAW = 35044 };
enum { GL_STATIC_READ = 35045 };
enum { GL_STATIC_COPY = 35046 };
enum { GL_DYNAMIC_DRAW = 35048 };
enum { GL_DYNAMIC_READ = 35049 };
enum { GL_DYNAMIC_COPY = 35050 };
enum { GL_SAMPLES_PASSED = 35092 };
enum { GL_SRC1_ALPHA = 34185 };
enum { GL_VERTEX_ARRAY_BUFFER_BINDING = 34966 };
enum { GL_NORMAL_ARRAY_BUFFER_BINDING = 34967 };
enum { GL_COLOR_ARRAY_BUFFER_BINDING = 34968 };
enum { GL_INDEX_ARRAY_BUFFER_BINDING = 34969 };
enum { GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING = 34970 };
enum { GL_EDGE_FLAG_ARRAY_BUFFER_BINDING = 34971 };
enum { GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING = 34972 };
enum { GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING = 34973 };
enum { GL_WEIGHT_ARRAY_BUFFER_BINDING = 34974 };
enum { GL_FOG_COORD_SRC = 33872 };
enum { GL_FOG_COORD = 33873 };
enum { GL_CURRENT_FOG_COORD = 33875 };
enum { GL_FOG_COORD_ARRAY_TYPE = 33876 };
enum { GL_FOG_COORD_ARRAY_STRIDE = 33877 };
enum { GL_FOG_COORD_ARRAY_POINTER = 33878 };
enum { GL_FOG_COORD_ARRAY = 33879 };
enum { GL_FOG_COORD_ARRAY_BUFFER_BINDING = 34973 };
enum { GL_SRC0_RGB = 34176 };
enum { GL_SRC1_RGB = 34177 };
enum { GL_SRC2_RGB = 34178 };
enum { GL_SRC0_ALPHA = 34184 };
enum { GL_SRC2_ALPHA = 34186 };
typedef void ( * PFNGLGENQUERIESPROC) (GLsizei n, GLuint *ids);
typedef void ( * PFNGLDELETEQUERIESPROC) (GLsizei n, const GLuint *ids);
typedef GLboolean ( * PFNGLISQUERYPROC) (GLuint id);
typedef void ( * PFNGLBEGINQUERYPROC) (GLenum target, GLuint id);
typedef void ( * PFNGLENDQUERYPROC) (GLenum target);
typedef void ( * PFNGLGETQUERYIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef void ( * PFNGLGETQUERYOBJECTIVPROC) (GLuint id, GLenum pname, GLint *params);
typedef void ( * PFNGLGETQUERYOBJECTUIVPROC) (GLuint id, GLenum pname, GLuint *params);
typedef void ( * PFNGLBINDBUFFERPROC) (GLenum target, GLuint buffer);
typedef void ( * PFNGLDELETEBUFFERSPROC) (GLsizei n, const GLuint *buffers);
typedef void ( * PFNGLGENBUFFERSPROC) (GLsizei n, GLuint *buffers);
typedef GLboolean ( * PFNGLISBUFFERPROC) (GLuint buffer);
typedef void ( * PFNGLBUFFERDATAPROC) (GLenum target, GLsizeiptr size, const void *data, GLenum usage);
typedef void ( * PFNGLBUFFERSUBDATAPROC) (GLenum target, GLintptr offset, GLsizeiptr size, const void *data);
typedef void ( * PFNGLGETBUFFERSUBDATAPROC) (GLenum target, GLintptr offset, GLsizeiptr size, void *data);
typedef void *( * PFNGLMAPBUFFERPROC) (GLenum target, GLenum access);
typedef GLboolean ( * PFNGLUNMAPBUFFERPROC) (GLenum target);
typedef void ( * PFNGLGETBUFFERPARAMETERIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef void ( * PFNGLGETBUFFERPOINTERVPROC) (GLenum target, GLenum pname, void **params);
extern void gl4es_glGenQueries (GLsizei n, GLuint *ids);
extern void gl4es_glDeleteQueries (GLsizei n, const GLuint *ids);
extern GLboolean gl4es_glIsQuery (GLuint id);
extern void gl4es_glBeginQuery (GLenum target, GLuint id);
extern void gl4es_glEndQuery (GLenum target);
extern void gl4es_glGetQueryiv (GLenum target, GLenum pname, GLint *params);
extern void gl4es_glGetQueryObjectiv (GLuint id, GLenum pname, GLint *params);
extern void gl4es_glGetQueryObjectuiv (GLuint id, GLenum pname, GLuint *params);
extern void gl4es_glBindBuffer (GLenum target, GLuint buffer);
extern void gl4es_glDeleteBuffers (GLsizei n, const GLuint *buffers);
extern void gl4es_glGenBuffers (GLsizei n, GLuint *buffers);
extern GLboolean gl4es_glIsBuffer (GLuint buffer);
extern void gl4es_glBufferData (GLenum target, GLsizeiptr size, const void *data, GLenum usage);
extern void gl4es_glBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, const void *data);
extern void gl4es_glGetBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, void *data);
extern void * gl4es_glMapBuffer (GLenum target, GLenum access);
extern GLboolean gl4es_glUnmapBuffer (GLenum target);
extern void gl4es_glGetBufferParameteriv (GLenum target, GLenum pname, GLint *params);
extern void gl4es_glGetBufferPointerv (GLenum target, GLenum pname, void **params);
enum { GL_VERSION_2_0 = 1 };
typedef char GLchar;
enum { GL_BLEND_EQUATION_RGB = 32777 };
enum { GL_VERTEX_ATTRIB_ARRAY_ENABLED = 34338 };
enum { GL_VERTEX_ATTRIB_ARRAY_SIZE = 34339 };
enum { GL_VERTEX_ATTRIB_ARRAY_STRIDE = 34340 };
enum { GL_VERTEX_ATTRIB_ARRAY_TYPE = 34341 };
enum { GL_CURRENT_VERTEX_ATTRIB = 34342 };
enum { GL_VERTEX_PROGRAM_POINT_SIZE = 34370 };
enum { GL_VERTEX_ATTRIB_ARRAY_POINTER = 34373 };
enum { GL_STENCIL_BACK_FUNC = 34816 };
enum { GL_STENCIL_BACK_FAIL = 34817 };
enum { GL_STENCIL_BACK_PASS_DEPTH_FAIL = 34818 };
enum { GL_STENCIL_BACK_PASS_DEPTH_PASS = 34819 };
enum { GL_MAX_DRAW_BUFFERS = 34852 };
enum { GL_DRAW_BUFFER0 = 34853 };
enum { GL_DRAW_BUFFER1 = 34854 };
enum { GL_DRAW_BUFFER2 = 34855 };
enum { GL_DRAW_BUFFER3 = 34856 };
enum { GL_DRAW_BUFFER4 = 34857 };
enum { GL_DRAW_BUFFER5 = 34858 };
enum { GL_DRAW_BUFFER6 = 34859 };
enum { GL_DRAW_BUFFER7 = 34860 };
enum { GL_DRAW_BUFFER8 = 34861 };
enum { GL_DRAW_BUFFER9 = 34862 };
enum { GL_DRAW_BUFFER10 = 34863 };
enum { GL_DRAW_BUFFER11 = 34864 };
enum { GL_DRAW_BUFFER12 = 34865 };
enum { GL_DRAW_BUFFER13 = 34866 };
enum { GL_DRAW_BUFFER14 = 34867 };
enum { GL_DRAW_BUFFER15 = 34868 };
enum { GL_BLEND_EQUATION_ALPHA = 34877 };
enum { GL_MAX_VERTEX_ATTRIBS = 34921 };
enum { GL_VERTEX_ATTRIB_ARRAY_NORMALIZED = 34922 };
enum { GL_MAX_TEXTURE_IMAGE_UNITS = 34930 };
enum { GL_FRAGMENT_SHADER = 35632 };
enum { GL_VERTEX_SHADER = 35633 };
enum { GL_MAX_FRAGMENT_UNIFORM_COMPONENTS = 35657 };
enum { GL_MAX_VERTEX_UNIFORM_COMPONENTS = 35658 };
enum { GL_MAX_VARYING_FLOATS = 35659 };
enum { GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS = 35660 };
enum { GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = 35661 };
enum { GL_SHADER_TYPE = 35663 };
enum { GL_FLOAT_VEC2 = 35664 };
enum { GL_FLOAT_VEC3 = 35665 };
enum { GL_FLOAT_VEC4 = 35666 };
enum { GL_INT_VEC2 = 35667 };
enum { GL_INT_VEC3 = 35668 };
enum { GL_INT_VEC4 = 35669 };
enum { GL_BOOL = 35670 };
enum { GL_BOOL_VEC2 = 35671 };
enum { GL_BOOL_VEC3 = 35672 };
enum { GL_BOOL_VEC4 = 35673 };
enum { GL_FLOAT_MAT2 = 35674 };
enum { GL_FLOAT_MAT3 = 35675 };
enum { GL_FLOAT_MAT4 = 35676 };
enum { GL_SAMPLER_1D = 35677 };
enum { GL_SAMPLER_2D = 35678 };
enum { GL_SAMPLER_3D = 35679 };
enum { GL_SAMPLER_CUBE = 35680 };
enum { GL_SAMPLER_1D_SHADOW = 35681 };
enum { GL_SAMPLER_2D_SHADOW = 35682 };
enum { GL_DELETE_STATUS = 35712 };
enum { GL_COMPILE_STATUS = 35713 };
enum { GL_LINK_STATUS = 35714 };
enum { GL_VALIDATE_STATUS = 35715 };
enum { GL_INFO_LOG_LENGTH = 35716 };
enum { GL_ATTACHED_SHADERS = 35717 };
enum { GL_ACTIVE_UNIFORMS = 35718 };
enum { GL_ACTIVE_UNIFORM_MAX_LENGTH = 35719 };
enum { GL_SHADER_SOURCE_LENGTH = 35720 };
enum { GL_ACTIVE_ATTRIBUTES = 35721 };
enum { GL_ACTIVE_ATTRIBUTE_MAX_LENGTH = 35722 };
enum { GL_FRAGMENT_SHADER_DERIVATIVE_HINT = 35723 };
enum { GL_SHADING_LANGUAGE_VERSION = 35724 };
enum { GL_CURRENT_PROGRAM = 35725 };
enum { GL_POINT_SPRITE_COORD_ORIGIN = 36000 };
enum { GL_LOWER_LEFT = 36001 };
enum { GL_UPPER_LEFT = 36002 };
enum { GL_STENCIL_BACK_REF = 36003 };
enum { GL_STENCIL_BACK_VALUE_MASK = 36004 };
enum { GL_STENCIL_BACK_WRITEMASK = 36005 };
enum { GL_VERTEX_PROGRAM_TWO_SIDE = 34371 };
enum { GL_POINT_SPRITE = 34913 };
enum { GL_COORD_REPLACE = 34914 };
enum { GL_MAX_TEXTURE_COORDS = 34929 };
typedef void ( * PFNGLBLENDEQUATIONSEPARATEPROC) (GLenum modeRGB, GLenum modeAlpha);
typedef void ( * PFNGLDRAWBUFFERSPROC) (GLsizei n, const GLenum *bufs);
typedef void ( * PFNGLSTENCILOPSEPARATEPROC) (GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass);
typedef void ( * PFNGLSTENCILFUNCSEPARATEPROC) (GLenum face, GLenum func, GLint ref, GLuint mask);
typedef void ( * PFNGLSTENCILMASKSEPARATEPROC) (GLenum face, GLuint mask);
typedef void ( * PFNGLATTACHSHADERPROC) (GLuint program, GLuint shader);
typedef void ( * PFNGLBINDATTRIBLOCATIONPROC) (GLuint program, GLuint index, const GLchar *name);
typedef void ( * PFNGLCOMPILESHADERPROC) (GLuint shader);
typedef GLuint ( * PFNGLCREATEPROGRAMPROC) (void);
typedef GLuint ( * PFNGLCREATESHADERPROC) (GLenum type);
typedef void ( * PFNGLDELETEPROGRAMPROC) (GLuint program);
typedef void ( * PFNGLDELETESHADERPROC) (GLuint shader);
typedef void ( * PFNGLDETACHSHADERPROC) (GLuint program, GLuint shader);
typedef void ( * PFNGLDISABLEVERTEXATTRIBARRAYPROC) (GLuint index);
typedef void ( * PFNGLENABLEVERTEXATTRIBARRAYPROC) (GLuint index);
typedef void ( * PFNGLGETACTIVEATTRIBPROC) (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
typedef void ( * PFNGLGETACTIVEUNIFORMPROC) (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
typedef void ( * PFNGLGETATTACHEDSHADERSPROC) (GLuint program, GLsizei maxCount, GLsizei *count, GLuint *shaders);
typedef GLint ( * PFNGLGETATTRIBLOCATIONPROC) (GLuint program, const GLchar *name);
typedef void ( * PFNGLGETPROGRAMIVPROC) (GLuint program, GLenum pname, GLint *params);
typedef void ( * PFNGLGETPROGRAMINFOLOGPROC) (GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
typedef void ( * PFNGLGETSHADERIVPROC) (GLuint shader, GLenum pname, GLint *params);
typedef void ( * PFNGLGETSHADERINFOLOGPROC) (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
typedef void ( * PFNGLGETSHADERSOURCEPROC) (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *source);
typedef GLint ( * PFNGLGETUNIFORMLOCATIONPROC) (GLuint program, const GLchar *name);
typedef void ( * PFNGLGETUNIFORMFVPROC) (GLuint program, GLint location, GLfloat *params);
typedef void ( * PFNGLGETUNIFORMIVPROC) (GLuint program, GLint location, GLint *params);
typedef void ( * PFNGLGETVERTEXATTRIBDVPROC) (GLuint index, GLenum pname, GLdouble *params);
typedef void ( * PFNGLGETVERTEXATTRIBFVPROC) (GLuint index, GLenum pname, GLfloat *params);
typedef void ( * PFNGLGETVERTEXATTRIBIVPROC) (GLuint index, GLenum pname, GLint *params);
typedef void ( * PFNGLGETVERTEXATTRIBPOINTERVPROC) (GLuint index, GLenum pname, void **pointer);
typedef GLboolean ( * PFNGLISPROGRAMPROC) (GLuint program);
typedef GLboolean ( * PFNGLISSHADERPROC) (GLuint shader);
typedef void ( * PFNGLLINKPROGRAMPROC) (GLuint program);
typedef void ( * PFNGLSHADERSOURCEPROC) (GLuint shader, GLsizei count, const GLchar *const*string, const GLint *length);
typedef void ( * PFNGLUSEPROGRAMPROC) (GLuint program);
typedef void ( * PFNGLUNIFORM1FPROC) (GLint location, GLfloat v0);
typedef void ( * PFNGLUNIFORM2FPROC) (GLint location, GLfloat v0, GLfloat v1);
typedef void ( * PFNGLUNIFORM3FPROC) (GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
typedef void ( * PFNGLUNIFORM4FPROC) (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
typedef void ( * PFNGLUNIFORM1IPROC) (GLint location, GLint v0);
typedef void ( * PFNGLUNIFORM2IPROC) (GLint location, GLint v0, GLint v1);
typedef void ( * PFNGLUNIFORM3IPROC) (GLint location, GLint v0, GLint v1, GLint v2);
typedef void ( * PFNGLUNIFORM4IPROC) (GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
typedef void ( * PFNGLUNIFORM1FVPROC) (GLint location, GLsizei count, const GLfloat *value);
typedef void ( * PFNGLUNIFORM2FVPROC) (GLint location, GLsizei count, const GLfloat *value);
typedef void ( * PFNGLUNIFORM3FVPROC) (GLint location, GLsizei count, const GLfloat *value);
typedef void ( * PFNGLUNIFORM4FVPROC) (GLint location, GLsizei count, const GLfloat *value);
typedef void ( * PFNGLUNIFORM1IVPROC) (GLint location, GLsizei count, const GLint *value);
typedef void ( * PFNGLUNIFORM2IVPROC) (GLint location, GLsizei count, const GLint *value);
typedef void ( * PFNGLUNIFORM3IVPROC) (GLint location, GLsizei count, const GLint *value);
typedef void ( * PFNGLUNIFORM4IVPROC) (GLint location, GLsizei count, const GLint *value);
typedef void ( * PFNGLUNIFORMMATRIX2FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void ( * PFNGLUNIFORMMATRIX3FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void ( * PFNGLUNIFORMMATRIX4FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void ( * PFNGLVALIDATEPROGRAMPROC) (GLuint program);
typedef void ( * PFNGLVERTEXATTRIB1DPROC) (GLuint index, GLdouble x);
typedef void ( * PFNGLVERTEXATTRIB1DVPROC) (GLuint index, const GLdouble *v);
typedef void ( * PFNGLVERTEXATTRIB1FPROC) (GLuint index, GLfloat x);
typedef void ( * PFNGLVERTEXATTRIB1FVPROC) (GLuint index, const GLfloat *v);
typedef void ( * PFNGLVERTEXATTRIB1SPROC) (GLuint index, GLshort x);
typedef void ( * PFNGLVERTEXATTRIB1SVPROC) (GLuint index, const GLshort *v);
typedef void ( * PFNGLVERTEXATTRIB2DPROC) (GLuint index, GLdouble x, GLdouble y);
typedef void ( * PFNGLVERTEXATTRIB2DVPROC) (GLuint index, const GLdouble *v);
typedef void ( * PFNGLVERTEXATTRIB2FPROC) (GLuint index, GLfloat x, GLfloat y);
typedef void ( * PFNGLVERTEXATTRIB2FVPROC) (GLuint index, const GLfloat *v);
typedef void ( * PFNGLVERTEXATTRIB2SPROC) (GLuint index, GLshort x, GLshort y);
typedef void ( * PFNGLVERTEXATTRIB2SVPROC) (GLuint index, const GLshort *v);
typedef void ( * PFNGLVERTEXATTRIB3DPROC) (GLuint index, GLdouble x, GLdouble y, GLdouble z);
typedef void ( * PFNGLVERTEXATTRIB3DVPROC) (GLuint index, const GLdouble *v);
typedef void ( * PFNGLVERTEXATTRIB3FPROC) (GLuint index, GLfloat x, GLfloat y, GLfloat z);
typedef void ( * PFNGLVERTEXATTRIB3FVPROC) (GLuint index, const GLfloat *v);
typedef void ( * PFNGLVERTEXATTRIB3SPROC) (GLuint index, GLshort x, GLshort y, GLshort z);
typedef void ( * PFNGLVERTEXATTRIB3SVPROC) (GLuint index, const GLshort *v);
typedef void ( * PFNGLVERTEXATTRIB4NBVPROC) (GLuint index, const GLbyte *v);
typedef void ( * PFNGLVERTEXATTRIB4NIVPROC) (GLuint index, const GLint *v);
typedef void ( * PFNGLVERTEXATTRIB4NSVPROC) (GLuint index, const GLshort *v);
typedef void ( * PFNGLVERTEXATTRIB4NUBPROC) (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w);
typedef void ( * PFNGLVERTEXATTRIB4NUBVPROC) (GLuint index, const GLubyte *v);
typedef void ( * PFNGLVERTEXATTRIB4NUIVPROC) (GLuint index, const GLuint *v);
typedef void ( * PFNGLVERTEXATTRIB4NUSVPROC) (GLuint index, const GLushort *v);
typedef void ( * PFNGLVERTEXATTRIB4BVPROC) (GLuint index, const GLbyte *v);
typedef void ( * PFNGLVERTEXATTRIB4DPROC) (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
typedef void ( * PFNGLVERTEXATTRIB4DVPROC) (GLuint index, const GLdouble *v);
typedef void ( * PFNGLVERTEXATTRIB4FPROC) (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
typedef void ( * PFNGLVERTEXATTRIB4FVPROC) (GLuint index, const GLfloat *v);
typedef void ( * PFNGLVERTEXATTRIB4IVPROC) (GLuint index, const GLint *v);
typedef void ( * PFNGLVERTEXATTRIB4SPROC) (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w);
typedef void ( * PFNGLVERTEXATTRIB4SVPROC) (GLuint index, const GLshort *v);
typedef void ( * PFNGLVERTEXATTRIB4UBVPROC) (GLuint index, const GLubyte *v);
typedef void ( * PFNGLVERTEXATTRIB4UIVPROC) (GLuint index, const GLuint *v);
typedef void ( * PFNGLVERTEXATTRIB4USVPROC) (GLuint index, const GLushort *v);
typedef void ( * PFNGLVERTEXATTRIBPOINTERPROC) (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void *pointer);
extern void gl4es_glBlendEquationSeparate (GLenum modeRGB, GLenum modeAlpha);
extern void gl4es_glDrawBuffers (GLsizei n, const GLenum *bufs);
extern void gl4es_glStencilOpSeparate (GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass);
extern void gl4es_glStencilFuncSeparate (GLenum face, GLenum func, GLint ref, GLuint mask);
extern void gl4es_glStencilMaskSeparate (GLenum face, GLuint mask);
extern void gl4es_glAttachShader (GLuint program, GLuint shader);
extern void gl4es_glBindAttribLocation (GLuint program, GLuint index, const GLchar *name);
extern void gl4es_glCompileShader (GLuint shader);
extern GLuint gl4es_glCreateProgram (void);
extern GLuint gl4es_glCreateShader (GLenum type);
extern void gl4es_glDeleteProgram (GLuint program);
extern void gl4es_glDeleteShader (GLuint shader);
extern void gl4es_glDetachShader (GLuint program, GLuint shader);
extern void gl4es_glDisableVertexAttribArray (GLuint index);
extern void gl4es_glEnableVertexAttribArray (GLuint index);
extern void gl4es_glGetActiveAttrib (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
extern void gl4es_glGetActiveUniform (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
extern void gl4es_glGetAttachedShaders (GLuint program, GLsizei maxCount, GLsizei *count, GLuint *shaders);
extern GLint gl4es_glGetAttribLocation (GLuint program, const GLchar *name);
extern void gl4es_glGetProgramiv (GLuint program, GLenum pname, GLint *params);
extern void gl4es_glGetProgramInfoLog (GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
extern void gl4es_glGetShaderiv (GLuint shader, GLenum pname, GLint *params);
extern void gl4es_glGetShaderInfoLog (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
extern void gl4es_glGetShaderSource (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *source);
extern GLint gl4es_glGetUniformLocation (GLuint program, const GLchar *name);
extern void gl4es_glGetUniformfv (GLuint program, GLint location, GLfloat *params);
extern void gl4es_glGetUniformiv (GLuint program, GLint location, GLint *params);
extern void gl4es_glGetVertexAttribdv (GLuint index, GLenum pname, GLdouble *params);
extern void gl4es_glGetVertexAttribfv (GLuint index, GLenum pname, GLfloat *params);
extern void gl4es_glGetVertexAttribiv (GLuint index, GLenum pname, GLint *params);
extern void gl4es_glGetVertexAttribPointerv (GLuint index, GLenum pname, void **pointer);
extern GLboolean gl4es_glIsProgram (GLuint program);
extern GLboolean gl4es_glIsShader (GLuint shader);
extern void gl4es_glLinkProgram (GLuint program);
extern void gl4es_glShaderSource (GLuint shader, GLsizei count, const GLchar *const*string, const GLint *length);
extern void gl4es_glUseProgram (GLuint program);
extern void gl4es_glUniform1f (GLint location, GLfloat v0);
extern void gl4es_glUniform2f (GLint location, GLfloat v0, GLfloat v1);
extern void gl4es_glUniform3f (GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
extern void gl4es_glUniform4f (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
extern void gl4es_glUniform1i (GLint location, GLint v0);
extern void gl4es_glUniform2i (GLint location, GLint v0, GLint v1);
extern void gl4es_glUniform3i (GLint location, GLint v0, GLint v1, GLint v2);
extern void gl4es_glUniform4i (GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
extern void gl4es_glUniform1fv (GLint location, GLsizei count, const GLfloat *value);
extern void gl4es_glUniform2fv (GLint location, GLsizei count, const GLfloat *value);
extern void gl4es_glUniform3fv (GLint location, GLsizei count, const GLfloat *value);
extern void gl4es_glUniform4fv (GLint location, GLsizei count, const GLfloat *value);
extern void gl4es_glUniform1iv (GLint location, GLsizei count, const GLint *value);
extern void gl4es_glUniform2iv (GLint location, GLsizei count, const GLint *value);
extern void gl4es_glUniform3iv (GLint location, GLsizei count, const GLint *value);
extern void gl4es_glUniform4iv (GLint location, GLsizei count, const GLint *value);
extern void gl4es_glUniformMatrix2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
extern void gl4es_glUniformMatrix3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
extern void gl4es_glUniformMatrix4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
extern void gl4es_glValidateProgram (GLuint program);
extern void gl4es_glVertexAttrib1d (GLuint index, GLdouble x);
extern void gl4es_glVertexAttrib1dv (GLuint index, const GLdouble *v);
extern void gl4es_glVertexAttrib1f (GLuint index, GLfloat x);
extern void gl4es_glVertexAttrib1fv (GLuint index, const GLfloat *v);
extern void gl4es_glVertexAttrib1s (GLuint index, GLshort x);
extern void gl4es_glVertexAttrib1sv (GLuint index, const GLshort *v);
extern void gl4es_glVertexAttrib2d (GLuint index, GLdouble x, GLdouble y);
extern void gl4es_glVertexAttrib2dv (GLuint index, const GLdouble *v);
extern void gl4es_glVertexAttrib2f (GLuint index, GLfloat x, GLfloat y);
extern void gl4es_glVertexAttrib2fv (GLuint index, const GLfloat *v);
extern void gl4es_glVertexAttrib2s (GLuint index, GLshort x, GLshort y);
extern void gl4es_glVertexAttrib2sv (GLuint index, const GLshort *v);
extern void gl4es_glVertexAttrib3d (GLuint index, GLdouble x, GLdouble y, GLdouble z);
extern void gl4es_glVertexAttrib3dv (GLuint index, const GLdouble *v);
extern void gl4es_glVertexAttrib3f (GLuint index, GLfloat x, GLfloat y, GLfloat z);
extern void gl4es_glVertexAttrib3fv (GLuint index, const GLfloat *v);
extern void gl4es_glVertexAttrib3s (GLuint index, GLshort x, GLshort y, GLshort z);
extern void gl4es_glVertexAttrib3sv (GLuint index, const GLshort *v);
extern void gl4es_glVertexAttrib4Nbv (GLuint index, const GLbyte *v);
extern void gl4es_glVertexAttrib4Niv (GLuint index, const GLint *v);
extern void gl4es_glVertexAttrib4Nsv (GLuint index, const GLshort *v);
extern void gl4es_glVertexAttrib4Nub (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w);
extern void gl4es_glVertexAttrib4Nubv (GLuint index, const GLubyte *v);
extern void gl4es_glVertexAttrib4Nuiv (GLuint index, const GLuint *v);
extern void gl4es_glVertexAttrib4Nusv (GLuint index, const GLushort *v);
extern void gl4es_glVertexAttrib4bv (GLuint index, const GLbyte *v);
extern void gl4es_glVertexAttrib4d (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
extern void gl4es_glVertexAttrib4dv (GLuint index, const GLdouble *v);
extern void gl4es_glVertexAttrib4f (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
extern void gl4es_glVertexAttrib4fv (GLuint index, const GLfloat *v);
extern void gl4es_glVertexAttrib4iv (GLuint index, const GLint *v);
extern void gl4es_glVertexAttrib4s (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w);
extern void gl4es_glVertexAttrib4sv (GLuint index, const GLshort *v);
extern void gl4es_glVertexAttrib4ubv (GLuint index, const GLubyte *v);
extern void gl4es_glVertexAttrib4uiv (GLuint index, const GLuint *v);
extern void gl4es_glVertexAttrib4usv (GLuint index, const GLushort *v);
extern void gl4es_glVertexAttribPointer (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void *pointer);
]]

local wrapper = setmetatable({}, {__index = ffi.C}) -- require 'ffi.OpenGLES3' ... all the same in emscripten build
-- now assign our gl4es_gl* to gl*
for k in ([[
glAccum
glAlphaFunc
glAreTexturesResident
glArrayElement
glBegin
glBindTexture
glBitmap
glBlendFunc
glCallList
glCallLists
glClear
glClearAccum
glClearColor
glClearDepth
glClearIndex
glClearStencil
glClipPlane
glColor3b
glColor3bv
glColor3d
glColor3dv
glColor3f
glColor3fv
glColor3i
glColor3iv
glColor3s
glColor3sv
glColor3ub
glColor3ubv
glColor3ui
glColor3uiv
glColor3us
glColor3usv
glColor4b
glColor4bv
glColor4d
glColor4dv
glColor4f
glColor4fv
glColor4i
glColor4iv
glColor4s
glColor4sv
glColor4ub
glColor4ubv
glColor4ui
glColor4uiv
glColor4us
glColor4usv
glColorMask
glColorMaterial
glColorPointer
glCopyPixels
glCopyTexImage1D
glCopyTexImage2D
glCopyTexSubImage1D
glCopyTexSubImage2D
glCullFace
glDeleteLists
glDeleteTextures
glDepthFunc
glDepthMask
glDepthRange
glDisable
glDisableClientState
glDrawArrays
glDrawBuffer
glDrawElements
glDrawPixels
glEdgeFlag
glEdgeFlagPointer
glEdgeFlagv
glEnable
glEnableClientState
glEnd
glEndList
glEvalCoord1d
glEvalCoord1dv
glEvalCoord1f
glEvalCoord1fv
glEvalCoord2d
glEvalCoord2dv
glEvalCoord2f
glEvalCoord2fv
glEvalMesh1
glEvalMesh2
glEvalPoint1
glEvalPoint2
glFeedbackBuffer
glFinish
glFlush
glFogf
glFogfv
glFogi
glFogiv
glFrontFace
glFrustum
glGenLists
glGenTextures
glGetBooleanv
glGetClipPlane
glGetDoublev
glGetError
glGetFloatv
glGetIntegerv
glGetLightfv
glGetLightiv
glGetMapdv
glGetMapfv
glGetMapiv
glGetMaterialfv
glGetMaterialiv
glGetPixelMapfv
glGetPixelMapuiv
glGetPixelMapusv
glGetPointerv
glGetPolygonStipple
glGetString
glGetTexEnvfv
glGetTexEnviv
glGetTexGendv
glGetTexGenfv
glGetTexGeniv
glGetTexImage
glGetTexLevelParameterfv
glGetTexLevelParameteriv
glGetTexParameterfv
glGetTexParameteriv
glHint
glIndexMask
glIndexPointer
glIndexd
glIndexdv
glIndexf
glIndexfv
glIndexi
glIndexiv
glIndexs
glIndexsv
glIndexub
glIndexubv
glInitNames
glInterleavedArrays
glIsEnabled
glIsList
glIsTexture
glLightModelf
glLightModelfv
glLightModeli
glLightModeliv
glLightf
glLightfv
glLighti
glLightiv
glLineStipple
glLineWidth
glListBase
glLoadIdentity
glLoadMatrixd
glLoadMatrixf
glLoadName
glLogicOp
glMap1d
glMap1f
glMap2d
glMap2f
glMapGrid1d
glMapGrid1f
glMapGrid2d
glMapGrid2f
glMaterialf
glMaterialfv
glMateriali
glMaterialiv
glMatrixMode
glMultMatrixd
glMultMatrixf
glNewList
glNormal3b
glNormal3bv
glNormal3d
glNormal3dv
glNormal3f
glNormal3fv
glNormal3i
glNormal3iv
glNormal3s
glNormal3sv
glNormalPointer
glOrtho
glPassThrough
glPixelMapfv
glPixelMapuiv
glPixelMapusv
glPixelStoref
glPixelStorei
glPixelTransferf
glPixelTransferi
glPixelZoom
glPointSize
glPolygonMode
glPolygonOffset
glPolygonStipple
glPopAttrib
glPopClientAttrib
glPopMatrix
glPopName
glPrioritizeTextures
glPushAttrib
glPushClientAttrib
glPushMatrix
glPushName
glRasterPos2d
glRasterPos2dv
glRasterPos2f
glRasterPos2fv
glRasterPos2i
glRasterPos2iv
glRasterPos2s
glRasterPos2sv
glRasterPos3d
glRasterPos3dv
glRasterPos3f
glRasterPos3fv
glRasterPos3i
glRasterPos3iv
glRasterPos3s
glRasterPos3sv
glRasterPos4d
glRasterPos4dv
glRasterPos4f
glRasterPos4fv
glRasterPos4i
glRasterPos4iv
glRasterPos4s
glRasterPos4sv
glReadBuffer
glReadPixels
glRectd
glRectdv
glRectf
glRectfv
glRecti
glRectiv
glRects
glRectsv
glRenderMode
glRotated
glRotatef
glScaled
glScalef
glScissor
glSelectBuffer
glShadeModel
glStencilFunc
glStencilMask
glStencilOp
glTexCoord1d
glTexCoord1dv
glTexCoord1f
glTexCoord1fv
glTexCoord1i
glTexCoord1iv
glTexCoord1s
glTexCoord1sv
glTexCoord2d
glTexCoord2dv
glTexCoord2f
glTexCoord2fv
glTexCoord2i
glTexCoord2iv
glTexCoord2s
glTexCoord2sv
glTexCoord3d
glTexCoord3dv
glTexCoord3f
glTexCoord3fv
glTexCoord3i
glTexCoord3iv
glTexCoord3s
glTexCoord3sv
glTexCoord4d
glTexCoord4dv
glTexCoord4f
glTexCoord4fv
glTexCoord4i
glTexCoord4iv
glTexCoord4s
glTexCoord4sv
glTexCoordPointer
glTexEnvf
glTexEnvfv
glTexEnvi
glTexEnviv
glTexGend
glTexGendv
glTexGenf
glTexGenfv
glTexGeni
glTexGeniv
glTexImage1D
glTexImage2D
glTexParameterf
glTexParameterfv
glTexParameteri
glTexParameteriv
glTexSubImage1D
glTexSubImage2D
glTranslated
glTranslatef
glVertex2d
glVertex2dv
glVertex2f
glVertex2fv
glVertex2i
glVertex2iv
glVertex2s
glVertex2sv
glVertex3d
glVertex3dv
glVertex3f
glVertex3fv
glVertex3i
glVertex3iv
glVertex3s
glVertex3sv
glVertex4d
glVertex4dv
glVertex4f
glVertex4fv
glVertex4i
glVertex4iv
glVertex4s
glVertex4sv
glVertexPointer
glViewport


glDrawRangeElements
glTexImage3D
glTexSubImage3D
glCopyTexSubImage3D
glActiveTexture
glSampleCoverage
glCompressedTexImage3D
glCompressedTexImage2D
glCompressedTexImage1D
glCompressedTexSubImage3D
glCompressedTexSubImage2D
glCompressedTexSubImage1D
glGetCompressedTexImage
glClientActiveTexture
glMultiTexCoord1d
glMultiTexCoord1dv
glMultiTexCoord1f
glMultiTexCoord1fv
glMultiTexCoord1i
glMultiTexCoord1iv
glMultiTexCoord1s
glMultiTexCoord1sv
glMultiTexCoord2d
glMultiTexCoord2dv
glMultiTexCoord2f
glMultiTexCoord2fv
glMultiTexCoord2i
glMultiTexCoord2iv
glMultiTexCoord2s
glMultiTexCoord2sv
glMultiTexCoord3d
glMultiTexCoord3dv
glMultiTexCoord3f
glMultiTexCoord3fv
glMultiTexCoord3i
glMultiTexCoord3iv
glMultiTexCoord3s
glMultiTexCoord3sv
glMultiTexCoord4d
glMultiTexCoord4dv
glMultiTexCoord4f
glMultiTexCoord4fv
glMultiTexCoord4i
glMultiTexCoord4iv
glMultiTexCoord4s
glMultiTexCoord4sv
glLoadTransposeMatrixf
glLoadTransposeMatrixd
glMultTransposeMatrixf
glMultTransposeMatrixd
glBlendFuncSeparate
glMultiDrawArrays
glMultiDrawElements
glPointParameterf
glPointParameterfv
glPointParameteri
glPointParameteriv
glFogCoordf
glFogCoordfv
glFogCoordd
glFogCoorddv
glFogCoordPointer
glSecondaryColor3b
glSecondaryColor3bv
glSecondaryColor3d
glSecondaryColor3dv
glSecondaryColor3f
glSecondaryColor3fv
glSecondaryColor3i
glSecondaryColor3iv
glSecondaryColor3s
glSecondaryColor3sv
glSecondaryColor3ub
glSecondaryColor3ubv
glSecondaryColor3ui
glSecondaryColor3uiv
glSecondaryColor3us
glSecondaryColor3usv
glSecondaryColorPointer
glWindowPos2d
glWindowPos2dv
glWindowPos2f
glWindowPos2fv
glWindowPos2i
glWindowPos2iv
glWindowPos2s
glWindowPos2sv
glWindowPos3d
glWindowPos3dv
glWindowPos3f
glWindowPos3fv
glWindowPos3i
glWindowPos3iv
glWindowPos3s
glWindowPos3sv
glBlendColor
glBlendEquation
glGenQueries
glDeleteQueries
glIsQuery
glBeginQuery
glEndQuery
glGetQueryiv
glGetQueryObjectiv
glGetQueryObjectuiv
glBindBuffer
glDeleteBuffers
glGenBuffers
glIsBuffer
glBufferData
glBufferSubData
glGetBufferSubData
glMapBuffer
glUnmapBuffer
glGetBufferParameteriv
glGetBufferPointerv
glBlendEquationSeparate
glDrawBuffers
glStencilOpSeparate
glStencilFuncSeparate
glStencilMaskSeparate
glAttachShader
glBindAttribLocation
glCompileShader
glCreateProgram
glCreateShader
glDeleteProgram
glDeleteShader
glDetachShader
glDisableVertexAttribArray
glEnableVertexAttribArray
glGetActiveAttrib
glGetActiveUniform
glGetAttachedShaders
glGetAttribLocation
glGetProgramiv
glGetProgramInfoLog
glGetShaderiv
glGetShaderInfoLog
glGetShaderSource
glGetUniformLocation
glGetUniformfv
glGetUniformiv
glGetVertexAttribdv
glGetVertexAttribfv
glGetVertexAttribiv
glGetVertexAttribPointerv
glIsProgram
glIsShader
glLinkProgram
glShaderSource
glUseProgram
glUniform1f
glUniform2f
glUniform3f
glUniform4f
glUniform1i
glUniform2i
glUniform3i
glUniform4i
glUniform1fv
glUniform2fv
glUniform3fv
glUniform4fv
glUniform1iv
glUniform2iv
glUniform3iv
glUniform4iv
glUniformMatrix2fv
glUniformMatrix3fv
glUniformMatrix4fv
glValidateProgram
glVertexAttrib1d
glVertexAttrib1dv
glVertexAttrib1f
glVertexAttrib1fv
glVertexAttrib1s
glVertexAttrib1sv
glVertexAttrib2d
glVertexAttrib2dv
glVertexAttrib2f
glVertexAttrib2fv
glVertexAttrib2s
glVertexAttrib2sv
glVertexAttrib3d
glVertexAttrib3dv
glVertexAttrib3f
glVertexAttrib3fv
glVertexAttrib3s
glVertexAttrib3sv
glVertexAttrib4Nbv
glVertexAttrib4Niv
glVertexAttrib4Nsv
glVertexAttrib4Nub
glVertexAttrib4Nubv
glVertexAttrib4Nuiv
glVertexAttrib4Nusv
glVertexAttrib4bv
glVertexAttrib4d
glVertexAttrib4dv
glVertexAttrib4f
glVertexAttrib4fv
glVertexAttrib4iv
glVertexAttrib4s
glVertexAttrib4sv
glVertexAttrib4ubv
glVertexAttrib4uiv
glVertexAttrib4usv
glVertexAttribPointer


]]):gmatch'%S+' do
	wrapper[k] = wrapper['gl4es_'..k]
end

require 'ffi.OpenGLES3'	-- should I add this on there too?

return wrapper
