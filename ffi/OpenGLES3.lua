local js = require 'js'
local window = js.global
local ffi = require 'ffi'
local table = require 'ext.table'
local class = require 'ext.class'

ffi.cdef[[
enum {
	GL_GLES_PROTOTYPES = 1,			// not in webgl
	GL_ES_VERSION_2_0 = 1,			// not in webgl
	GL_DEPTH_BUFFER_BIT = 256,
	GL_STENCIL_BUFFER_BIT = 1024,
	GL_COLOR_BUFFER_BIT = 16384,
	GL_FALSE = 0,						// not in webgl
	GL_TRUE = 1,						// not in webgl
	GL_POINTS = 0,
	GL_LINES = 1,
	GL_LINE_LOOP = 2,
	GL_LINE_STRIP = 3,
	GL_TRIANGLES = 4,
	GL_TRIANGLE_STRIP = 5,
	GL_TRIANGLE_FAN = 6,
	GL_ZERO = 0,
	GL_ONE = 1,
	GL_SRC_COLOR = 768,
	GL_ONE_MINUS_SRC_COLOR = 769,
	GL_SRC_ALPHA = 770,
	GL_ONE_MINUS_SRC_ALPHA = 771,
	GL_DST_ALPHA = 772,
	GL_ONE_MINUS_DST_ALPHA = 773,
	GL_DST_COLOR = 774,
	GL_ONE_MINUS_DST_COLOR = 775,
	GL_SRC_ALPHA_SATURATE = 776,
	GL_FUNC_ADD = 32774,
	GL_BLEND_EQUATION = 32777,
	GL_BLEND_EQUATION_RGB = 32777,
	GL_BLEND_EQUATION_ALPHA = 34877,
	GL_FUNC_SUBTRACT = 32778,
	GL_FUNC_REVERSE_SUBTRACT = 32779,
	GL_BLEND_DST_RGB = 32968,
	GL_BLEND_SRC_RGB = 32969,
	GL_BLEND_DST_ALPHA = 32970,
	GL_BLEND_SRC_ALPHA = 32971,
	GL_CONSTANT_COLOR = 32769,
	GL_ONE_MINUS_CONSTANT_COLOR = 32770,
	GL_CONSTANT_ALPHA = 32771,
	GL_ONE_MINUS_CONSTANT_ALPHA = 32772,
	GL_BLEND_COLOR = 32773,
	GL_ARRAY_BUFFER = 34962,
	GL_ELEMENT_ARRAY_BUFFER = 34963,
	GL_ARRAY_BUFFER_BINDING = 34964,
	GL_ELEMENT_ARRAY_BUFFER_BINDING = 34965,
	GL_STREAM_DRAW = 35040,
	GL_STATIC_DRAW = 35044,
	GL_DYNAMIC_DRAW = 35048,
	GL_BUFFER_SIZE = 34660,
	GL_BUFFER_USAGE = 34661,
	GL_CURRENT_VERTEX_ATTRIB = 34342,
	GL_FRONT = 1028,
	GL_BACK = 1029,
	GL_FRONT_AND_BACK = 1032,
	GL_TEXTURE_2D = 3553,
	GL_CULL_FACE = 2884,
	GL_BLEND = 3042,
	GL_DITHER = 3024,
	GL_STENCIL_TEST = 2960,
	GL_DEPTH_TEST = 2929,
	GL_SCISSOR_TEST = 3089,
	GL_POLYGON_OFFSET_FILL = 32823,
	GL_SAMPLE_ALPHA_TO_COVERAGE = 32926,
	GL_SAMPLE_COVERAGE = 32928,
	GL_NO_ERROR = 0,
	GL_INVALID_ENUM = 1280,
	GL_INVALID_VALUE = 1281,
	GL_INVALID_OPERATION = 1282,
	GL_OUT_OF_MEMORY = 1285,
	GL_CW = 2304,
	GL_CCW = 2305,
	GL_LINE_WIDTH = 2849,
	GL_ALIASED_POINT_SIZE_RANGE = 33901,
	GL_ALIASED_LINE_WIDTH_RANGE = 33902,
	GL_CULL_FACE_MODE = 2885,
	GL_FRONT_FACE = 2886,
	GL_DEPTH_RANGE = 2928,
	GL_DEPTH_WRITEMASK = 2930,
	GL_DEPTH_CLEAR_VALUE = 2931,
	GL_DEPTH_FUNC = 2932,
	GL_STENCIL_CLEAR_VALUE = 2961,
	GL_STENCIL_FUNC = 2962,
	GL_STENCIL_FAIL = 2964,
	GL_STENCIL_PASS_DEPTH_FAIL = 2965,
	GL_STENCIL_PASS_DEPTH_PASS = 2966,
	GL_STENCIL_REF = 2967,
	GL_STENCIL_VALUE_MASK = 2963,
	GL_STENCIL_WRITEMASK = 2968,
	GL_STENCIL_BACK_FUNC = 34816,
	GL_STENCIL_BACK_FAIL = 34817,
	GL_STENCIL_BACK_PASS_DEPTH_FAIL = 34818,
	GL_STENCIL_BACK_PASS_DEPTH_PASS = 34819,
	GL_STENCIL_BACK_REF = 36003,
	GL_STENCIL_BACK_VALUE_MASK = 36004,
	GL_STENCIL_BACK_WRITEMASK = 36005,
	GL_VIEWPORT = 2978,
	GL_SCISSOR_BOX = 3088,
	GL_COLOR_CLEAR_VALUE = 3106,
	GL_COLOR_WRITEMASK = 3107,
	GL_UNPACK_ALIGNMENT = 3317,
	GL_PACK_ALIGNMENT = 3333,
	GL_MAX_TEXTURE_SIZE = 3379,
	GL_MAX_VIEWPORT_DIMS = 3386,
	GL_SUBPIXEL_BITS = 3408,
	GL_RED_BITS = 3410,
	GL_GREEN_BITS = 3411,
	GL_BLUE_BITS = 3412,
	GL_ALPHA_BITS = 3413,
	GL_DEPTH_BITS = 3414,
	GL_STENCIL_BITS = 3415,
	GL_POLYGON_OFFSET_UNITS = 10752,
	GL_POLYGON_OFFSET_FACTOR = 32824,
	GL_TEXTURE_BINDING_2D = 32873,
	GL_SAMPLE_BUFFERS = 32936,
	GL_SAMPLES = 32937,
	GL_SAMPLE_COVERAGE_VALUE = 32938,
	GL_SAMPLE_COVERAGE_INVERT = 32939,
	GL_NUM_COMPRESSED_TEXTURE_FORMATS = 34466,		// not in webgl
	GL_COMPRESSED_TEXTURE_FORMATS = 34467,
	GL_DONT_CARE = 4352,
	GL_FASTEST = 4353,
	GL_NICEST = 4354,
	GL_GENERATE_MIPMAP_HINT = 33170,
	GL_BYTE = 5120,
	GL_UNSIGNED_BYTE = 5121,
	GL_SHORT = 5122,
	GL_UNSIGNED_SHORT = 5123,
	GL_INT = 5124,
	GL_UNSIGNED_INT = 5125,
	GL_FLOAT = 5126,
	GL_FIXED = 5132,			// not in webgl
	GL_DEPTH_COMPONENT = 6402,
	GL_ALPHA = 6406,
	GL_RGB = 6407,
	GL_RGBA = 6408,
	GL_LUMINANCE = 6409,
	GL_LUMINANCE_ALPHA = 6410,
	GL_UNSIGNED_SHORT_4_4_4_4 = 32819,
	GL_UNSIGNED_SHORT_5_5_5_1 = 32820,
	GL_UNSIGNED_SHORT_5_6_5 = 33635,
	GL_FRAGMENT_SHADER = 35632,
	GL_VERTEX_SHADER = 35633,
	GL_MAX_VERTEX_ATTRIBS = 34921,
	GL_MAX_VERTEX_UNIFORM_VECTORS = 36347,
	GL_MAX_VARYING_VECTORS = 36348,
	GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = 35661,
	GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS = 35660,
	GL_MAX_TEXTURE_IMAGE_UNITS = 34930,
	GL_MAX_FRAGMENT_UNIFORM_VECTORS = 36349,
	GL_SHADER_TYPE = 35663,
	GL_DELETE_STATUS = 35712,
	GL_LINK_STATUS = 35714,
	GL_VALIDATE_STATUS = 35715,
	GL_ATTACHED_SHADERS = 35717,
	GL_ACTIVE_UNIFORMS = 35718,
	GL_ACTIVE_UNIFORM_MAX_LENGTH = 35719,		// not in webgl
	GL_ACTIVE_ATTRIBUTES = 35721,
	GL_ACTIVE_ATTRIBUTE_MAX_LENGTH = 35722,		// not in webgl
	GL_SHADING_LANGUAGE_VERSION = 35724,
	GL_CURRENT_PROGRAM = 35725,
	GL_NEVER = 512,
	GL_LESS = 513,
	GL_EQUAL = 514,
	GL_LEQUAL = 515,
	GL_GREATER = 516,
	GL_NOTEQUAL = 517,
	GL_GEQUAL = 518,
	GL_ALWAYS = 519,
	GL_KEEP = 7680,
	GL_REPLACE = 7681,
	GL_INCR = 7682,
	GL_DECR = 7683,
	GL_INVERT = 5386,
	GL_INCR_WRAP = 34055,
	GL_DECR_WRAP = 34056,
	GL_VENDOR = 7936,
	GL_RENDERER = 7937,
	GL_VERSION = 7938,
	GL_EXTENSIONS = 7939,			// not in webgl
	GL_NEAREST = 9728,
	GL_LINEAR = 9729,
	GL_NEAREST_MIPMAP_NEAREST = 9984,
	GL_LINEAR_MIPMAP_NEAREST = 9985,
	GL_NEAREST_MIPMAP_LINEAR = 9986,
	GL_LINEAR_MIPMAP_LINEAR = 9987,
	GL_TEXTURE_MAG_FILTER = 10240,
	GL_TEXTURE_MIN_FILTER = 10241,
	GL_TEXTURE_WRAP_S = 10242,
	GL_TEXTURE_WRAP_T = 10243,
	GL_TEXTURE = 5890,
	GL_TEXTURE_CUBE_MAP = 34067,
	GL_TEXTURE_BINDING_CUBE_MAP = 34068,
	GL_TEXTURE_CUBE_MAP_POSITIVE_X = 34069,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_X = 34070,
	GL_TEXTURE_CUBE_MAP_POSITIVE_Y = 34071,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_Y = 34072,
	GL_TEXTURE_CUBE_MAP_POSITIVE_Z = 34073,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_Z = 34074,
	GL_MAX_CUBE_MAP_TEXTURE_SIZE = 34076,
	GL_TEXTURE0 = 33984,
	GL_TEXTURE1 = 33985,
	GL_TEXTURE2 = 33986,
	GL_TEXTURE3 = 33987,
	GL_TEXTURE4 = 33988,
	GL_TEXTURE5 = 33989,
	GL_TEXTURE6 = 33990,
	GL_TEXTURE7 = 33991,
	GL_TEXTURE8 = 33992,
	GL_TEXTURE9 = 33993,
	GL_TEXTURE10 = 33994,
	GL_TEXTURE11 = 33995,
	GL_TEXTURE12 = 33996,
	GL_TEXTURE13 = 33997,
	GL_TEXTURE14 = 33998,
	GL_TEXTURE15 = 33999,
	GL_TEXTURE16 = 34000,
	GL_TEXTURE17 = 34001,
	GL_TEXTURE18 = 34002,
	GL_TEXTURE19 = 34003,
	GL_TEXTURE20 = 34004,
	GL_TEXTURE21 = 34005,
	GL_TEXTURE22 = 34006,
	GL_TEXTURE23 = 34007,
	GL_TEXTURE24 = 34008,
	GL_TEXTURE25 = 34009,
	GL_TEXTURE26 = 34010,
	GL_TEXTURE27 = 34011,
	GL_TEXTURE28 = 34012,
	GL_TEXTURE29 = 34013,
	GL_TEXTURE30 = 34014,
	GL_TEXTURE31 = 34015,
	GL_ACTIVE_TEXTURE = 34016,
	GL_REPEAT = 10497,
	GL_CLAMP_TO_EDGE = 33071,
	GL_MIRRORED_REPEAT = 33648,
	GL_FLOAT_VEC2 = 35664,
	GL_FLOAT_VEC3 = 35665,
	GL_FLOAT_VEC4 = 35666,
	GL_INT_VEC2 = 35667,
	GL_INT_VEC3 = 35668,
	GL_INT_VEC4 = 35669,
	GL_BOOL = 35670,
	GL_BOOL_VEC2 = 35671,
	GL_BOOL_VEC3 = 35672,
	GL_BOOL_VEC4 = 35673,
	GL_FLOAT_MAT2 = 35674,
	GL_FLOAT_MAT3 = 35675,
	GL_FLOAT_MAT4 = 35676,
	GL_SAMPLER_2D = 35678,
	GL_SAMPLER_CUBE = 35680,
	GL_VERTEX_ATTRIB_ARRAY_ENABLED = 34338,
	GL_VERTEX_ATTRIB_ARRAY_SIZE = 34339,
	GL_VERTEX_ATTRIB_ARRAY_STRIDE = 34340,
	GL_VERTEX_ATTRIB_ARRAY_TYPE = 34341,
	GL_VERTEX_ATTRIB_ARRAY_NORMALIZED = 34922,
	GL_VERTEX_ATTRIB_ARRAY_POINTER = 34373,
	GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 34975,
	GL_IMPLEMENTATION_COLOR_READ_TYPE = 35738,
	GL_IMPLEMENTATION_COLOR_READ_FORMAT = 35739,
	GL_COMPILE_STATUS = 35713,
	GL_INFO_LOG_LENGTH = 35716,				// not in webgl
	GL_SHADER_SOURCE_LENGTH = 35720,			// not in webgl
	GL_SHADER_COMPILER = 36346,				// not in webgl
	GL_SHADER_BINARY_FORMATS = 36344,			// not in webgl
	GL_NUM_SHADER_BINARY_FORMATS = 36345,		// not in webgl
	GL_LOW_FLOAT = 36336,
	GL_MEDIUM_FLOAT = 36337,
	GL_HIGH_FLOAT = 36338,
	GL_LOW_INT = 36339,
	GL_MEDIUM_INT = 36340,
	GL_HIGH_INT = 36341,
	GL_FRAMEBUFFER = 36160,
	GL_RENDERBUFFER = 36161,
	GL_RGBA4 = 32854,
	GL_RGB5_A1 = 32855,
	GL_RGB565 = 36194,
	GL_DEPTH_COMPONENT16 = 33189,
	GL_STENCIL_INDEX8 = 36168,
	GL_RENDERBUFFER_WIDTH = 36162,
	GL_RENDERBUFFER_HEIGHT = 36163,
	GL_RENDERBUFFER_INTERNAL_FORMAT = 36164,
	GL_RENDERBUFFER_RED_SIZE = 36176,
	GL_RENDERBUFFER_GREEN_SIZE = 36177,
	GL_RENDERBUFFER_BLUE_SIZE = 36178,
	GL_RENDERBUFFER_ALPHA_SIZE = 36179,
	GL_RENDERBUFFER_DEPTH_SIZE = 36180,
	GL_RENDERBUFFER_STENCIL_SIZE = 36181,
	GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 36048,
	GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 36049,
	GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 36050,
	GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 36051,
	GL_COLOR_ATTACHMENT0 = 36064,
	GL_DEPTH_ATTACHMENT = 36096,
	GL_STENCIL_ATTACHMENT = 36128,
	GL_NONE = 0,
	GL_FRAMEBUFFER_COMPLETE = 36053,
	GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 36054,
	GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 36055,
	GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS = 36057,
	GL_FRAMEBUFFER_UNSUPPORTED = 36061,
	GL_FRAMEBUFFER_BINDING = 36006,
	GL_RENDERBUFFER_BINDING = 36007,
	GL_MAX_RENDERBUFFER_SIZE = 34024,
	GL_INVALID_FRAMEBUFFER_OPERATION = 1286,
	GL_ES_VERSION_3_0 = 1,			// not in webgl
	GL_READ_BUFFER = 3074,
	GL_UNPACK_ROW_LENGTH = 3314,
	GL_UNPACK_SKIP_ROWS = 3315,
	GL_UNPACK_SKIP_PIXELS = 3316,
	GL_PACK_ROW_LENGTH = 3330,
	GL_PACK_SKIP_ROWS = 3331,
	GL_PACK_SKIP_PIXELS = 3332,
	GL_COLOR = 6144,
	GL_DEPTH = 6145,
	GL_STENCIL = 6146,
	GL_RED = 6403,
	GL_RGB8 = 32849,
	GL_RGBA8 = 32856,
	GL_RGB10_A2 = 32857,
	GL_TEXTURE_BINDING_3D = 32874,
	GL_UNPACK_SKIP_IMAGES = 32877,
	GL_UNPACK_IMAGE_HEIGHT = 32878,
	GL_TEXTURE_3D = 32879,
	GL_TEXTURE_WRAP_R = 32882,
	GL_MAX_3D_TEXTURE_SIZE = 32883,
	GL_UNSIGNED_INT_2_10_10_10_REV = 33640,
	GL_MAX_ELEMENTS_VERTICES = 33000,
	GL_MAX_ELEMENTS_INDICES = 33001,
	GL_TEXTURE_MIN_LOD = 33082,
	GL_TEXTURE_MAX_LOD = 33083,
	GL_TEXTURE_BASE_LEVEL = 33084,
	GL_TEXTURE_MAX_LEVEL = 33085,
	GL_MIN = 32775,
	GL_MAX = 32776,
	GL_DEPTH_COMPONENT24 = 33190,
	GL_MAX_TEXTURE_LOD_BIAS = 34045,
	GL_TEXTURE_COMPARE_MODE = 34892,
	GL_TEXTURE_COMPARE_FUNC = 34893,
	GL_CURRENT_QUERY = 34917,
	GL_QUERY_RESULT = 34918,
	GL_QUERY_RESULT_AVAILABLE = 34919,
	GL_BUFFER_MAPPED = 35004,				// not in webgl
	GL_BUFFER_MAP_POINTER = 35005,		// not in webgl
	GL_STREAM_READ = 35041,
	GL_STREAM_COPY = 35042,
	GL_STATIC_READ = 35045,
	GL_STATIC_COPY = 35046,
	GL_DYNAMIC_READ = 35049,
	GL_DYNAMIC_COPY = 35050,
	GL_MAX_DRAW_BUFFERS = 34852,
	GL_DRAW_BUFFER0 = 34853,
	GL_DRAW_BUFFER1 = 34854,
	GL_DRAW_BUFFER2 = 34855,
	GL_DRAW_BUFFER3 = 34856,
	GL_DRAW_BUFFER4 = 34857,
	GL_DRAW_BUFFER5 = 34858,
	GL_DRAW_BUFFER6 = 34859,
	GL_DRAW_BUFFER7 = 34860,
	GL_DRAW_BUFFER8 = 34861,
	GL_DRAW_BUFFER9 = 34862,
	GL_DRAW_BUFFER10 = 34863,
	GL_DRAW_BUFFER11 = 34864,
	GL_DRAW_BUFFER12 = 34865,
	GL_DRAW_BUFFER13 = 34866,
	GL_DRAW_BUFFER14 = 34867,
	GL_DRAW_BUFFER15 = 34868,
	GL_MAX_FRAGMENT_UNIFORM_COMPONENTS = 35657,
	GL_MAX_VERTEX_UNIFORM_COMPONENTS = 35658,
	GL_SAMPLER_3D = 35679,
	GL_SAMPLER_2D_SHADOW = 35682,
	GL_FRAGMENT_SHADER_DERIVATIVE_HINT = 35723,
	GL_PIXEL_PACK_BUFFER = 35051,
	GL_PIXEL_UNPACK_BUFFER = 35052,
	GL_PIXEL_PACK_BUFFER_BINDING = 35053,
	GL_PIXEL_UNPACK_BUFFER_BINDING = 35055,
	GL_FLOAT_MAT2x3 = 35685,
	GL_FLOAT_MAT2x4 = 35686,
	GL_FLOAT_MAT3x2 = 35687,
	GL_FLOAT_MAT3x4 = 35688,
	GL_FLOAT_MAT4x2 = 35689,
	GL_FLOAT_MAT4x3 = 35690,
	GL_SRGB = 35904,
	GL_SRGB8 = 35905,
	GL_SRGB8_ALPHA8 = 35907,
	GL_COMPARE_REF_TO_TEXTURE = 34894,
	GL_MAJOR_VERSION = 33307,			// not in webgl
	GL_MINOR_VERSION = 33308,			// not in webgl
	GL_NUM_EXTENSIONS = 33309,		// not in webgl
	GL_RGBA32F = 34836,
	GL_RGB32F = 34837,
	GL_RGBA16F = 34842,
	GL_RGB16F = 34843,
	GL_VERTEX_ATTRIB_ARRAY_INTEGER = 35069,
	GL_MAX_ARRAY_TEXTURE_LAYERS = 35071,
	GL_MIN_PROGRAM_TEXEL_OFFSET = 35076,
	GL_MAX_PROGRAM_TEXEL_OFFSET = 35077,
	GL_MAX_VARYING_COMPONENTS = 35659,
	GL_TEXTURE_2D_ARRAY = 35866,
	GL_TEXTURE_BINDING_2D_ARRAY = 35869,
	GL_R11F_G11F_B10F = 35898,
	GL_UNSIGNED_INT_10F_11F_11F_REV = 35899,
	GL_RGB9_E5 = 35901,
	GL_UNSIGNED_INT_5_9_9_9_REV = 35902,
	GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH = 35958,		// not in webgl
	GL_TRANSFORM_FEEDBACK_BUFFER_MODE = 35967,
	GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 35968,
	GL_TRANSFORM_FEEDBACK_VARYINGS = 35971,
	GL_TRANSFORM_FEEDBACK_BUFFER_START = 35972,
	GL_TRANSFORM_FEEDBACK_BUFFER_SIZE = 35973,
	GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 35976,
	GL_RASTERIZER_DISCARD = 35977,
	GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 35978,
	GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 35979,
	GL_INTERLEAVED_ATTRIBS = 35980,
	GL_SEPARATE_ATTRIBS = 35981,
	GL_TRANSFORM_FEEDBACK_BUFFER = 35982,
	GL_TRANSFORM_FEEDBACK_BUFFER_BINDING = 35983,
	GL_RGBA32UI = 36208,
	GL_RGB32UI = 36209,
	GL_RGBA16UI = 36214,
	GL_RGB16UI = 36215,
	GL_RGBA8UI = 36220,
	GL_RGB8UI = 36221,
	GL_RGBA32I = 36226,
	GL_RGB32I = 36227,
	GL_RGBA16I = 36232,
	GL_RGB16I = 36233,
	GL_RGBA8I = 36238,
	GL_RGB8I = 36239,
	GL_RED_INTEGER = 36244,
	GL_RGB_INTEGER = 36248,
	GL_RGBA_INTEGER = 36249,
	GL_SAMPLER_2D_ARRAY = 36289,
	GL_SAMPLER_2D_ARRAY_SHADOW = 36292,
	GL_SAMPLER_CUBE_SHADOW = 36293,
	GL_UNSIGNED_INT_VEC2 = 36294,
	GL_UNSIGNED_INT_VEC3 = 36295,
	GL_UNSIGNED_INT_VEC4 = 36296,
	GL_INT_SAMPLER_2D = 36298,
	GL_INT_SAMPLER_3D = 36299,
	GL_INT_SAMPLER_CUBE = 36300,
	GL_INT_SAMPLER_2D_ARRAY = 36303,
	GL_UNSIGNED_INT_SAMPLER_2D = 36306,
	GL_UNSIGNED_INT_SAMPLER_3D = 36307,
	GL_UNSIGNED_INT_SAMPLER_CUBE = 36308,
	GL_UNSIGNED_INT_SAMPLER_2D_ARRAY = 36311,
	GL_BUFFER_ACCESS_FLAGS = 37151,		// not in webgl
	GL_BUFFER_MAP_LENGTH = 37152,		// not in webgl
	GL_BUFFER_MAP_OFFSET = 37153,		// not in webgl
	GL_DEPTH_COMPONENT32F = 36012,
	GL_DEPTH32F_STENCIL8 = 36013,
	GL_FLOAT_32_UNSIGNED_INT_24_8_REV = 36269,
	GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 33296,
	GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 33297,
	GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE = 33298,
	GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 33299,
	GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 33300,
	GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 33301,
	GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 33302,
	GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 33303,
	GL_FRAMEBUFFER_DEFAULT = 33304,
	GL_FRAMEBUFFER_UNDEFINED = 33305,			// not in webgl
	GL_DEPTH_STENCIL_ATTACHMENT = 33306,
	GL_DEPTH_STENCIL = 34041,
	GL_UNSIGNED_INT_24_8 = 34042,
	GL_DEPTH24_STENCIL8 = 35056,
	GL_UNSIGNED_NORMALIZED = 35863,
	GL_DRAW_FRAMEBUFFER_BINDING = 36006,
	GL_READ_FRAMEBUFFER = 36008,
	GL_DRAW_FRAMEBUFFER = 36009,
	GL_READ_FRAMEBUFFER_BINDING = 36010,
	GL_RENDERBUFFER_SAMPLES = 36011,
	GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 36052,
	GL_MAX_COLOR_ATTACHMENTS = 36063,
	GL_COLOR_ATTACHMENT1 = 36065,
	GL_COLOR_ATTACHMENT2 = 36066,
	GL_COLOR_ATTACHMENT3 = 36067,
	GL_COLOR_ATTACHMENT4 = 36068,
	GL_COLOR_ATTACHMENT5 = 36069,
	GL_COLOR_ATTACHMENT6 = 36070,
	GL_COLOR_ATTACHMENT7 = 36071,
	GL_COLOR_ATTACHMENT8 = 36072,
	GL_COLOR_ATTACHMENT9 = 36073,
	GL_COLOR_ATTACHMENT10 = 36074,
	GL_COLOR_ATTACHMENT11 = 36075,
	GL_COLOR_ATTACHMENT12 = 36076,
	GL_COLOR_ATTACHMENT13 = 36077,
	GL_COLOR_ATTACHMENT14 = 36078,
	GL_COLOR_ATTACHMENT15 = 36079,
	GL_COLOR_ATTACHMENT16 = 36080,		// not in webgl
	GL_COLOR_ATTACHMENT17 = 36081,		// not in webgl
	GL_COLOR_ATTACHMENT18 = 36082,		// not in webgl
	GL_COLOR_ATTACHMENT19 = 36083,		// not in webgl
	GL_COLOR_ATTACHMENT20 = 36084,		// not in webgl
	GL_COLOR_ATTACHMENT21 = 36085,		// not in webgl
	GL_COLOR_ATTACHMENT22 = 36086,		// not in webgl
	GL_COLOR_ATTACHMENT23 = 36087,		// not in webgl
	GL_COLOR_ATTACHMENT24 = 36088,		// not in webgl
	GL_COLOR_ATTACHMENT25 = 36089,		// not in webgl
	GL_COLOR_ATTACHMENT26 = 36090,		// not in webgl
	GL_COLOR_ATTACHMENT27 = 36091,		// not in webgl
	GL_COLOR_ATTACHMENT28 = 36092,		// not in webgl
	GL_COLOR_ATTACHMENT29 = 36093,		// not in webgl
	GL_COLOR_ATTACHMENT30 = 36094,		// not in webgl
	GL_COLOR_ATTACHMENT31 = 36095,		// not in webgl
	GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 36182,
	GL_MAX_SAMPLES = 36183,
	GL_HALF_FLOAT = 5131,
	GL_MAP_READ_BIT = 1,					// not in webgl
	GL_MAP_WRITE_BIT = 2,					// not in webgl
	GL_MAP_INVALIDATE_RANGE_BIT = 4,		// not in webgl
	GL_MAP_INVALIDATE_BUFFER_BIT = 8,		// not in webgl
	GL_MAP_FLUSH_EXPLICIT_BIT = 16,		// not in webgl
	GL_MAP_UNSYNCHRONIZED_BIT = 32,		// not in webgl
	GL_RG = 33319,
	GL_RG_INTEGER = 33320,
	GL_R8 = 33321,
	GL_RG8 = 33323,
	GL_R16F = 33325,
	GL_R32F = 33326,
	GL_RG16F = 33327,
	GL_RG32F = 33328,
	GL_R8I = 33329,
	GL_R8UI = 33330,
	GL_R16I = 33331,
	GL_R16UI = 33332,
	GL_R32I = 33333,
	GL_R32UI = 33334,
	GL_RG8I = 33335,
	GL_RG8UI = 33336,
	GL_RG16I = 33337,
	GL_RG16UI = 33338,
	GL_RG32I = 33339,
	GL_RG32UI = 33340,
	GL_VERTEX_ARRAY_BINDING = 34229,
	GL_R8_SNORM = 36756,
	GL_RG8_SNORM = 36757,
	GL_RGB8_SNORM = 36758,
	GL_RGBA8_SNORM = 36759,
	GL_SIGNED_NORMALIZED = 36764,
	GL_PRIMITIVE_RESTART_FIXED_INDEX = 36201,		// not in webgl
	GL_COPY_READ_BUFFER = 36662,
	GL_COPY_WRITE_BUFFER = 36663,
	GL_COPY_READ_BUFFER_BINDING = 36662,
	GL_COPY_WRITE_BUFFER_BINDING = 36663,
	GL_UNIFORM_BUFFER = 35345,
	GL_UNIFORM_BUFFER_BINDING = 35368,
	GL_UNIFORM_BUFFER_START = 35369,
	GL_UNIFORM_BUFFER_SIZE = 35370,
	GL_MAX_VERTEX_UNIFORM_BLOCKS = 35371,
	GL_MAX_FRAGMENT_UNIFORM_BLOCKS = 35373,
	GL_MAX_COMBINED_UNIFORM_BLOCKS = 35374,
	GL_MAX_UNIFORM_BUFFER_BINDINGS = 35375,
	GL_MAX_UNIFORM_BLOCK_SIZE = 35376,
	GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 35377,
	GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 35379,
	GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT = 35380,
	GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH = 35381,		// not in webgl
	GL_ACTIVE_UNIFORM_BLOCKS = 35382,
	GL_UNIFORM_TYPE = 35383,
	GL_UNIFORM_SIZE = 35384,
	GL_UNIFORM_NAME_LENGTH = 35385,			// not in webgl
	GL_UNIFORM_BLOCK_INDEX = 35386,
	GL_UNIFORM_OFFSET = 35387,
	GL_UNIFORM_ARRAY_STRIDE = 35388,
	GL_UNIFORM_MATRIX_STRIDE = 35389,
	GL_UNIFORM_IS_ROW_MAJOR = 35390,
	GL_UNIFORM_BLOCK_BINDING = 35391,
	GL_UNIFORM_BLOCK_DATA_SIZE = 35392,
	GL_UNIFORM_BLOCK_NAME_LENGTH = 35393,			// not in webgl
	GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS = 35394,
	GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 35395,
	GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 35396,
	GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 35398,
	GL_INVALID_INDEX = 0xFFFFFFFF,							// 0xFFFFFFFFu	-- TODO seems fengari uses 32-bit ints, so idk that it can store this other than -1 ... maybe as cdata ?
	GL_MAX_VERTEX_OUTPUT_COMPONENTS = 37154,
	GL_MAX_FRAGMENT_INPUT_COMPONENTS = 37157,
	GL_MAX_SERVER_WAIT_TIMEOUT = 37137,
	GL_OBJECT_TYPE = 37138,
	GL_SYNC_CONDITION = 37139,
	GL_SYNC_STATUS = 37140,
	GL_SYNC_FLAGS = 37141,
	GL_SYNC_FENCE = 37142,
	GL_SYNC_GPU_COMMANDS_COMPLETE = 37143,
	GL_UNSIGNALED = 37144,
	GL_SIGNALED = 37145,
	GL_ALREADY_SIGNALED = 37146,
	GL_TIMEOUT_EXPIRED = 37147,
	GL_CONDITION_SATISFIED = 37148,
	GL_WAIT_FAILED = 37149,
	GL_SYNC_FLUSH_COMMANDS_BIT = 1,
	GL_VERTEX_ATTRIB_ARRAY_DIVISOR = 35070,
	GL_ANY_SAMPLES_PASSED = 35887,
	GL_ANY_SAMPLES_PASSED_CONSERVATIVE = 36202,
	GL_SAMPLER_BINDING = 35097,
	GL_RGB10_A2UI = 36975,
	GL_TEXTURE_SWIZZLE_R = 36418,		// not in webgl
	GL_TEXTURE_SWIZZLE_G = 36419,		// not in webgl
	GL_TEXTURE_SWIZZLE_B = 36420,		// not in webgl
	GL_TEXTURE_SWIZZLE_A = 36421,		// not in webgl
	GL_GREEN = 6404,			// not in webgl
	GL_BLUE = 6405,		// not in webgl
	GL_INT_2_10_10_10_REV = 36255,
	GL_TRANSFORM_FEEDBACK = 36386,
	GL_TRANSFORM_FEEDBACK_PAUSED = 36387,
	GL_TRANSFORM_FEEDBACK_ACTIVE = 36388,
	GL_TRANSFORM_FEEDBACK_BINDING = 36389,
	GL_PROGRAM_BINARY_RETRIEVABLE_HINT = 33367,				// not in webgl
	GL_PROGRAM_BINARY_LENGTH = 34625,							// not in webgl
	GL_NUM_PROGRAM_BINARY_FORMATS = 34814,					// not in webgl
	GL_PROGRAM_BINARY_FORMATS = 34815,						// not in webgl
	GL_COMPRESSED_R11_EAC = 37488,							// not in webgl
	GL_COMPRESSED_SIGNED_R11_EAC = 37489,						// not in webgl
	GL_COMPRESSED_RG11_EAC = 37490,							// not in webgl
	GL_COMPRESSED_SIGNED_RG11_EAC = 37491,					// not in webgl
	GL_COMPRESSED_RGB8_ETC2 = 37492,							// not in webgl
	GL_COMPRESSED_SRGB8_ETC2 = 37493,							// not in webgl
	GL_COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2 = 37494,		// not in webgl
	GL_COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2 = 37495,		// not in webgl
	GL_COMPRESSED_RGBA8_ETC2_EAC = 37496,						// not in webgl
	GL_COMPRESSED_SRGB8_ALPHA8_ETC2_EAC = 37497,				// not in webgl
	GL_TEXTURE_IMMUTABLE_FORMAT = 37167,
	GL_MAX_ELEMENT_INDEX = 36203,
	GL_NUM_SAMPLE_COUNTS = 37760,								// not in webgl
	GL_TEXTURE_IMMUTABLE_LEVELS = 33503,
};

typedef int32_t khronos_int32_t;
typedef uint32_t khronos_uint32_t;
typedef int64_t khronos_int64_t;
typedef uint64_t khronos_uint64_t;
typedef signed long int khronos_intptr_t;
typedef unsigned long int khronos_uintptr_t;
typedef signed long int khronos_ssize_t;
typedef unsigned long int khronos_usize_t;

typedef signed char khronos_int8_t;
typedef unsigned char khronos_uint8_t;
typedef signed short int khronos_int16_t;
typedef unsigned short int khronos_uint16_t;
typedef float khronos_float_t;
typedef khronos_uint64_t khronos_utime_nanoseconds_t;
typedef khronos_int64_t khronos_stime_nanoseconds_t;
typedef enum {
	KHRONOS_FALSE = 0,
	KHRONOS_TRUE = 1,
	KHRONOS_BOOLEAN_ENUM_FORCE_SIZE = 0x7FFFFFFF
} khronos_boolean_enum_t;

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
typedef khronos_int32_t GLfixed;
typedef struct __GLsync *GLsync;
typedef khronos_uint64_t GLuint64;
typedef khronos_int64_t GLint64;
typedef char GLchar;
typedef khronos_ssize_t GLsizeiptr;
typedef khronos_intptr_t GLintptr;
typedef khronos_uint16_t GLhalf;

]]

local gl = setmetatable({}, {
	__index = ffi.C,
})

local function jsbool(b)
	if b == 0 then return false end
	return not not b	-- not not b
end

local webgl
function gl.setWebGLContext(webgl_)
	webgl = webgl_
end

local glEmuMajorVersion = 3
local glEmuMinorVersion = 0

function gl.glGetString(name)
	-- TODO initialize upon any dereference?
	if name == gl.GL_VENDOR then
		return ffi.stringBuffer(webgl:getParameter(webgl.VENDOR))
	elseif name == gl.GL_RENDERER then
		return ffi.stringBuffer(webgl:getParameter(webgl.RENDERER))
	elseif name == gl.GL_VERSION then
		return ffi.stringBuffer(webgl:getParameter(webgl.VERSION))
	elseif name == gl.GL_MAJOR_VERSION then
		return ffi.stringBuffer(tostring(glEmuMajorVersion))	-- TODO what version should I return?  the GLES-equivalent version of 3.0?  or the GL-equivalent version of the GLES version?
	elseif name == gl.GL_MINOR_VERSION then
		return ffi.stringBuffer(tostring(glEmuMinorVersion))
	elseif name == gl.GL_SHADING_LANGUAGE_VERSION then
		-- TODO tempted to send something else since this string has so much extra crap in it
		local version = webgl:getParameter(webgl.SHADING_LANGUAGE_VERSION)
		-- ugh webgl why do you have to add your crap to this?
		local rest = version:match'^WebGL GLSL ES ([0-9%.]*)'
		if rest then
			version = rest:gsub('%.', '')
		end
		-- ok on my desktop GLES, this is giving me the desktop-GLSL version, which is up to 460  ... even tho I'm running GLES ...
		-- and then on desktop I have to translate GLSL version to GLSL-ES version
		-- on Chrome it gives me the GLSL-ES version which is up to 300
		-- so I guess I have to translate that here?
		-- or should I not need to there?
		-- what even is the correct behavior?
		if version == '320' then
			version = '460'
		elseif version >= '310' then
			version = '450'
		elseif version >= '300' then
			version = '430'
		elseif version >= '100' then
			version = '410'
		end
		return ffi.stringBuffer(version)
	elseif name == gl.GL_EXTENSIONS then
		local s = {}
		local ext = webgl:getSupportedExtensions()	-- js array
		for i=0,ext.length-1 do
			-- TODO convert any extension names here
			table.insert(s, ext[i])
		end
		return ffi.stringBuffer(table.concat(s, ' '))
	else
		return ffi.stringBuffer''
	end
	-- error? return null?
	return ffi.stringBuffer''
end

local glerror = gl.GL_NO_ERROR

function gl.glGetError()
	-- idk how to make precedence of whether mine or theirs sets first
	-- too bad there's no glSetError function ....
	if glerror ~= 0 then
		local res = glerror
		glerror = 0
		return res
	end
	return webgl:getError()
end

local function setError(err)
	if err == 0 then return end
	if glerror ~= 0 then return end
	glerror = err
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

function ResMap:get(id)
	id = assert(tonumber(id))	-- id should always be a GLuint
	return self[id]
end

function ResMap:makeCreate(webglfuncname)
	return function(...)
		local id = self:getNextID()
--DEBUG:print(webglfuncname..' id='..id)
		assert(self[id] == nil)
		self[id] = {
			type = webglfuncname,
			obj = webgl[webglfuncname](webgl, ...)
		}
		return id	--ffi.cast('GLuint', id)	-- luajit ffi will auto convert reads of int to luanumber ...
	end
end

function ResMap:makeGen(webglfuncname)
	local create = self:makeCreate(webglfuncname)
	return function(n, buffers)
		for i=1,n-1 do
			buffers[i] = create()
		end
	end
end

local res = ResMap()
gl.res = res	--debuggin

local function getObj(id)
	local entry = res:get(id)
	if not entry then return js.null end	-- webgl is stingy, needs null, not undefined
	return entry.obj
end

local function findObj(obj, objtype)
	for id,v in pairs(res) do
		if v.obj == obj then
			if type(objtype) == 'string' then
				assert(v.type == objtype)
			elseif type(objtype) == 'table' then
				assert(objtype[v.type])
			end
			return id, v
		end
	end
end

function gl.glBlendColor(...) return webgl:blendColor(...) end
function gl.glBlendEquation(...) return webgl:blendEquation(...) end
function gl.glBlendEquationSeparate(...) return webgl:blendEquationSeparate(...) end
function gl.glBlendFunc(...) return webgl:blendFunc(...) end
function gl.glBlendFuncSeparate(...) return webgl:blendFuncSeparate(...) end
function gl.glClear(...) return webgl:clear(...) end
function gl.glClearColor(...) return webgl:clearColor(...) end
function gl.glClearDepthf(...) return webgl:clearDepth(...) end
function gl.glClearStencil(...) return webgl:clearStencil(...) end
function gl.glColorMask(...) return webgl:colorMask(...) end
function gl.glCullFace(...) return webgl:cullFace(...) end
function gl.glDepthFunc(...) return webgl:depthFunc(...) end
function gl.glDepthMask(...) return webgl:depthMask(...) end
function gl.glDepthRangef(...) return webgl:depthRange(...) end
function gl.glDisable(...) return webgl:disable(...) end
function gl.glDrawArrays(...) return webgl:drawArrays(...) end

function gl.glDrawElements(mode, count, type, indices)
	indices = tonumber(ffi.cast('intptr_t', ffi.cast('void*', indices)))
	return webgl:drawElements(mode, count, type, indices)
end

function gl.glEnable(...) return webgl:enable(...) end
function gl.glFinish(...) return webgl:finish(...) end
function gl.glFlush(...) return webgl:flush(...) end
function gl.glFrontFace(...) return webgl:frontFace(...) end
function gl.glHint(...) return webgl:hint(...) end
function gl.glIsEnabled(...) return webgl:isEnabled(...) end
function gl.glLineWidth(...) return webgl:lineWidth(...) end
function gl.glPixelStorei(...) return webgl:pixelStorei(...) end
function gl.glPolygonOffset(...) return webgl:polygonOffset(...) end

-- copied from gl/types.lua ctypeForGLType
-- TODO store the js.global[jstype], and just call it directly instead of ffi.dataToArray
local op = require 'ext.op'
local ctypeForGLType = table{
	-- these types are per-channel
	GL_UNSIGNED_BYTE = 'Uint8Array',
	GL_BYTE = 'Int8Array',
	GL_UNSIGNED_SHORT = 'Uint16Array',
	GL_SHORT = 'Int16Array',
	GL_UNSIGNED_INT = 'Uint32Array',
	GL_INT = 'Int32Array',
	GL_FLOAT = 'Float32Array',
	-- these types incorporate all channels
	GL_HALF_FLOAT = 'Uint16Array',
	GL_UNSIGNED_BYTE_3_3_2 = 'Uint8Array',
	GL_UNSIGNED_BYTE_2_3_3_REV = 'Uint8Array',
	GL_UNSIGNED_SHORT_5_6_5 = 'Uint16Array',
	GL_UNSIGNED_SHORT_5_6_5_REV = 'Uint16Array',
	GL_UNSIGNED_SHORT_4_4_4_4 = 'Uint16Array',
	GL_UNSIGNED_SHORT_4_4_4_4_REV = 'Uint16Array',
	GL_UNSIGNED_SHORT_5_5_5_1 = 'Uint16Array',
	GL_UNSIGNED_SHORT_1_5_5_5_REV = 'Uint16Array',
	GL_UNSIGNED_INT_8_8_8_8 = 'Uint32Array',
	GL_UNSIGNED_INT_8_8_8_8_REV = 'Uint32Array',
	GL_UNSIGNED_INT_10_10_10_2 = 'Uint32Array',
	GL_UNSIGNED_INT_2_10_10_10_REV = 'Uint32Array',
}:map(function(v,k)
	-- some of these are not in GLES so ...
	-- luajit cdata doesn't let you test for existence with a simple nil value
	k = op.safeindex(gl, k)
	if not k then return end
	return v, k
end):setmetatable(nil)

local function jsTypeForGLType(type)
	return ctypeForGLType[type] or 'Uint8Array'
end

function gl.glReadPixels(x, y, width, height, format, type, pixels)
	-- if webgl:getParameter(gl.GL_PIXEL_PACK_BUFFER_BINDING) == js.null then	-- ... getting our stupid 'then' error
	-- TODO if 'pixels' is any kind of pointer ...
	pixels = ffi.cast('void*', pixels)
	if pixels == ffi.null or pixels == nil then
		-- if PIXEL_PACK_BUFFER is bound then we are reading into it, and 'pixels' is an offset
		return webgl:readPixels(x, y, width, height, format, type, tonumber(ffi.cast('intptr_t', pixels)))
	else
		-- otherwise pixels is an address in memory
		pixels = ffi.dataToArray(jsTypeForGLType(type), pixels)
		return webgl:readPixels(x, y, width, height, format, type, pixels)
	end
end

function gl.glSampleCoverage(...) return webgl:sampleCoverage(...) end
function gl.glScissor(...) return webgl:scissor(...) end
function gl.glStencilFunc(...) return webgl:stencilFunc(...) end
function gl.glStencilFuncSeparate(...) return webgl:stencilFuncSeparate(...) end
function gl.glStencilMask(...) return webgl:stencilMask(...) end
function gl.glStencilMaskSeparate(...) return webgl:stencilMaskSeparate(...) end
function gl.glStencilOp(...) return webgl:stencilOp(...) end
function gl.glStencilOpSeparate(...) return webgl:stencilOpSeparate(...) end
function gl.glViewport(...) return webgl:viewport(...) end

-- returns a function for a getter for the infos
-- function returned accepts (data, pname) first
-- its wrapped getter accepts (pname) first
local function makeGetter(infos, getter)
	return function(data, pname, ...)
		local v = getter(pname, ...)
		local info = infos[pname]
		if info then
			assert(not info.string, "can't get a string value")
			if info.array then
				-- what to do here if v == js.null?
				for i=0,info.array-1 do
					data[i] = v[i]
				end
				return
			elseif info.res then
				if v == js.null then
					v = 0
				else
					local id = findObj(v, info.res)
					if not id then error("somehow webgl returned a resource that I didn't have") end
					v = id
				end
			else
			end
		end
		if v == js.null then v = 0 end
		data[0] = v
	end
end

local getParameterInfo = {
	[gl.GL_ALIASED_LINE_WIDTH_RANGE] = {array=2},
	[gl.GL_ALIASED_POINT_SIZE_RANGE] = {array=2},
	[gl.GL_ARRAY_BUFFER_BINDING] = {res='createBuffer'},
	[gl.GL_BLEND_COLOR] = {array=4},
	[gl.GL_COLOR_CLEAR_VALUE] = {array=4},
	[gl.GL_COLOR_WRITEMASK] = {array=4},	--	sequence<GLboolean> (with 4 values)
	--gl.COMPRESSED_TEXTURE_FORMATS	Uint32Array
	[gl.GL_CURRENT_PROGRAM] = {res='createProgram'},
	[gl.GL_DEPTH_RANGE] = {array=2},
	[gl.GL_ELEMENT_ARRAY_BUFFER_BINDING] = {res='createBuffer'},
	[gl.GL_FRAMEBUFFER_BINDING] = {res='createFramebuffer'},
	[gl.GL_MAX_VIEWPORT_DIMS] = {array=2},
	[gl.GL_RENDERBUFFER_BINDING] = {res='createRenderbuffer'},
	[gl.GL_SCISSOR_BOX] = {array=4},
	[gl.GL_TEXTURE_BINDING_2D] = {res='createTexture'},
	[gl.GL_TEXTURE_BINDING_CUBE_MAP] = {res='createTexture'},
	[gl.GL_RENDERER] = {string=true},
	[gl.GL_VENDOR] = {string=true},
	[gl.GL_VERSION] = {string=true},
	[gl.GL_VIEWPORT] = {array=4},

	[gl.GL_COPY_READ_BUFFER_BINDING] = {res='createBuffer'},
	[gl.GL_COPY_WRITE_BUFFER_BINDING] = {res='createBuffer'},
	[gl.GL_DRAW_FRAMEBUFFER_BINDING] = {res='createFramebuffer'},
	[gl.GL_PIXEL_PACK_BUFFER_BINDING] = {res='createBuffer'},
	[gl.GL_PIXEL_UNPACK_BUFFER_BINDING] = {res='createBuffer'},
	[gl.GL_READ_FRAMEBUFFER_BINDING] = {res='createFramebuffer'},
	[gl.GL_SAMPLER_BINDING] = {res='createSampler'},
	[gl.GL_TEXTURE_BINDING_2D_ARRAY] = {res='createTexture'},
	[gl.GL_TEXTURE_BINDING_3D] = {res='createTexture'},
	[gl.GL_TRANSFORM_FEEDBACK_BINDING] = {res='createTransformFeedback'},
	[gl.GL_TRANSFORM_FEEDBACK_BUFFER_BINDING] = {res='createBuffer'},
	[gl.GL_UNIFORM_BUFFER_BINDING] = {res='createBuffer'},
	[gl.GL_VERTEX_ARRAY_BINDING] = {res='createVertexArray'}
}

local getParameterGetter = makeGetter(getParameterInfo, function(pname)
	-- not webgl api
	if pname == gl.GL_MAJOR_VERSION then
		return glEmuMajorVersion
	elseif pname == gl.GL_MINOR_VERSION then
		return glEmuMinorVersion
	else
	-- in webgl api:
		return webgl:getParameter(pname)
	end
end)
function gl.glGetFloatv(pname, data)
	return getParameterGetter(data, pname)	-- data first
end
gl.glGetIntegerv = gl.glGetFloatv
gl.glGetBooleanv = gl.glGetFloatv
gl.glGetDoublev = gl.glGetFloatv	-- not in webgl


gl.glCreateProgram = res:makeCreate'createProgram'

function gl.glDeleteProgram(program)
	return webgl:deleteProgram((findObj(program, 'createProgram')))
end

function gl.glIsProgram(buffer)
	local entry = select(2, findObj(buffer))
	if not entry then return gl.GL_FALSE end
	if entry.type ~= 'createProgram' then return gl.GL_FALSE end	-- my own check ... why use webgl's?
	return webgl:isProgram(entry.id)
end

function gl.glAttachShader(program, shader)
	webgl:attachShader(getObj(program), getObj(shader))
end

function gl.glDetachShader(program, shader)
-- TODO track attached shaders and delete from res[] if they fully detach?
	return webgl:detachShader(getObj(program), getObj(shader))
end

function gl.glGetAttachedShaders(program, maxCount, count, shaders)
	local jsshaders = webgl:getAttachedShaders(getObj(program))
	if count then count[0] = jsshaders.length end
	if shaders then
		for i=0,math.min(maxCount, jsshaders.length)-1 do
			shaders[i] = findObj(jsshaders[i], 'createShader')
		end
	end
end

function gl.glLinkProgram(program)
	return webgl:linkProgram(getObj(program))
end

function gl.glUseProgram(program)
	return webgl:useProgram(getObj(program))
end

function gl.glValidateProgram(program)
	return webgl:validateProgram(getObj(program))
end

function gl.glGetProgramiv(programID, pname, params)
	local programObj = getObj(programID)
	if pname == gl.GL_INFO_LOG_LENGTH then
		params[0] = #webgl:getProgramInfoLog(programObj)
	elseif pname == gl.GL_ACTIVE_UNIFORM_MAX_LENGTH then
		-- https://registry.khronos.org/OpenGL-Refpages/gl4/html/glGetActiveUniform.xhtml
		-- "The size of the character buffer required to store the longest uniform variable name in program can be obtained by calling glGetProgram with the value GL_ACTIVE_UNIFORM_MAX_LENGTH"
		-- I guess webgl doesn't have antything like this ...
		local maxlen = 0
		for i=0,webgl:getProgramParameter(programObj, gl.GL_ACTIVE_UNIFORMS)-1 do
			local uinfo = webgl:getActiveUniform(programObj, i)
			maxlen = math.max(maxlen, #uinfo.name)
		end
		params[0] = maxlen
	elseif pname == gl.GL_ACTIVE_ATTRIBUTE_MAX_LENGTH then
		local maxlen = 0
		for i=0,webgl:getProgramParameter(programObj, gl.GL_ACTIVE_ATTRIBUTES)-1 do
			local uinfo = webgl:getActiveAttrib(programObj, i)
			maxlen = math.max(maxlen, #uinfo.name)
		end
		params[0] = maxlen
	else
		params[0] = webgl:getProgramParameter(programObj, pname)
	end
end

function gl.glGetProgramInfoLog(program, bufSize, length, infoLog)
	local log = webgl:getProgramInfoLog(getObj(program))
	if not log then return  end

	length = ffi.cast('int32_t*', length)
	if length ~= ffi.null then
		length[0] = #log
	end
	infoLog = ffi.cast('char*', infoLog)
	if infoLog ~= ffi.null then
		ffi.copy(infoLog, log, bufSize)
	end
end

function gl.glGetActiveUniform(program, index, bufSize, length, size, type, name)
	local uinfo = webgl:getActiveUniform(getObj(program), index)
	length = ffi.cast('int32_t*', length)
	if length ~= ffi.null then
		length[0] = #uinfo.name
	end
	size = ffi.cast('int32_t*', size)
	if size ~= ffi.null then
		size[0] = uinfo.size
	end
	type = ffi.cast('int32_t*', type)
	if type ~= ffi.null then
		type[0] = uinfo.type
	end
	name = ffi.cast('char*', name)
	if name ~= ffi.null then
		ffi.copy(name, uinfo.name)
	end
end

-- TODO glGetUniformiv/glGetUniformfv

function gl.glGetUniformLocation(program, name)
	--[[
	return webgl:getUniformLocation(getObj(program), ffi.string(name)) or nil
	--]]
	-- [[ Because js is retarded, it throws an exception if the uniform isn't available.
	-- This apathetic design mentality of WebGL/JS is why my native run LuaJIT GLES bindings run 2x or more faster than WebGL+JS
	-- Sad I have to emulate it to get it to work in-browser ...
	local success, res = xpcall(function()
		return webgl:getUniformLocation(getObj(program), ffi.string(name))
	end, function() end)
	if not success then return nil end
	return res
	--]]
end

for n=1,4 do
	for _,t in ipairs{'f', 'i', 'ui'} do
		do
			local glname = 'glUniform'..n..t
			local webglname = 'uniform'..n..t
			gl[glname] = function(...) return webgl[webglname](webgl, ...) end
		end

		-- TODO 'location' is coming from lua,
		-- which should be holding a GLuint for the location
		-- but I'm seeing a WebGLUniformLocation object here ..
		-- but that's fine anyways cuz that's what should get passed to webgl...
		do
			local glname = 'glUniform'..n..t..'v'
			local webglname = 'uniform'..n..t..'v'
			local len = n	-- js typed arrays use # elements, not byte size ...
			local jsarrayctor = t == 'f' and 'Float32Array' or (
				t == 'i' and 'Int32Array' or 'Uint32Array'
			)
			gl[glname] = function(location, count, value)
				--assert(count == 1, "TODO")
				value = ffi.dataToArray(jsarrayctor, value, len * count)
				return webgl[webglname](webgl, location, value)
			end
		end
	end

	if n > 1 then
		local glname = 'glUniformMatrix'..n..'fv'
		local webglname = 'uniformMatrix'..n..'fv'
		local len = n * n
		gl[glname] = function(location, count, transpose, value)
			--assert(count == 1, "TODO")
			value = ffi.dataToArray('Float32Array', value, len * count)
			return webgl[webglname](webgl, location, jsbool(transpose), value)
		end
	end

	do
		local glname = 'glVertexAttrib'..n..'f'
		local webglname = 'vertexAttrib'..n..'f'
		gl[glname] = function(...) return webgl[webglname](webgl, ...) end
	end
	do
		local glname = 'glVertexAttrib'..n..'fv'
		local webglname = 'vertexAttrib'..n..'fv'
		gl[glname] = function(index, value)
			value = ffi.dataToArray('Float32Array', value, n)
			return webgl[webglname](webgl, index, value)
		end
	end
end

local getVertexAttribInfo = {
	[gl.GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING] = {res='createBuffer'},
	[gl.GL_CURRENT_VERTEX_ATTRIB] = {array=4},
}

local getVertexAttribGetter = makeGetter(getVertexAttribInfo, function(pname, index)
	return webgl:getVertexAttrib(index, pname)
end)
function gl.glGetVertexAttribfv(index, pname, data)
	return getVertexAttribGetter(data, pname, index)
end
gl.glGetVertexAttribiv = gl.glGetVertexAttribfv

function gl.glGetActiveAttrib(program, index, bufSize, length, size, type, name)
	local uinfo = webgl:getActiveAttrib(getObj(program), index)
	length = ffi.cast('int32_t*', length)
	if length ~= ffi.null then
		length[0] = #uinfo.name
	end
	size = ffi.cast('int32_t*', size)
	if size ~= ffi.null then
		size[0] = uinfo.size
	end
	type = ffi.cast('int32_t*', type)
	if type ~= ffi.null then
		type[0] = uinfo.type
	end
	name = ffi.cast('int32_t*', name)
	if name ~= ffi.null then
		ffi.copy(name, uinfo.name)
	end
end

function gl.glGetVertexAttribPointerv(index, pname, pointer)
	pointer[0] = ffi.cast('void*', webgl:getVertexAttribOffset(index, pname))
end

function gl.glGetAttribLocation(program, name)
	return webgl:getAttribLocation(getObj(program), ffi.string(name))
end

function gl.glBindAttribLocation(program, index, name)
	return webgl:bindAttribLocation(getObj(program), index, ffi.string(name))
end

-- TODO this doesn't translate directly from ES to WebGL
-- ES allows pointers to be passed when no buffers are bound ... right? idk about specss but it's functional on my desktop at least, similar to GL
-- WebGL only allows this to work with bound buffers
function gl.glVertexAttribPointer(index, size, ctype, normalized, stride, pointer)
	return webgl:vertexAttribPointer(index, size, ctype, jsbool(normalized), stride, tonumber(ffi.cast('intptr_t', pointer)))
end
function gl.glVertexAttribIPointer(index, size, ctype, stride, pointer)
	return webgl:vertexAttribIPointer(index, size, ctype, stride, tonumber(ffi.cast('intptr_t', pointer)))
end

function gl.glEnableVertexAttribArray(...) return webgl:enableVertexAttribArray(...) end
function gl.glDisableVertexAttribArray(...) return webgl:disableVertexAttribArray(...) end


gl.glCreateShader = res:makeCreate'createShader'

function gl.glDeleteShader(shader)
	return webgl:deleteShader((findObj(shader, 'createShader')))
end

function gl.glIsShader(buffer)
	local entry = select(2, findObj(buffer))
	if not entry then return gl.GL_FALSE end
	if entry.type ~= 'createShader' then return gl.GL_FALSE end	-- my own check ... why use webgl's?
	return webgl:isShader(entry.id)
end

function gl.glShaderBinary(count, shaders, binaryFormat, binary, length)
	error'not supported'
end

function gl.glShaderSource(shader, numStrs, strs, lens)
	local s = table()
	for i=0,numStrs-1 do
		table.insert(s, ffi.string(strs[i], lens[i]))
	end
	local source = s:concat()

	return webgl:shaderSource(getObj(shader), source)
end

function gl.glCompileShader(shader)
	return webgl:compileShader(getObj(shader))
end

function gl.glReleaseShaderCompiler() end	-- no equivalent webgl function

function gl.glGetShaderiv(shader, pname, params)
	-- in gles but not in webgl?
	-- or does gles not allow this also, is it just in gl but not gles?
	if pname == gl.GL_INFO_LOG_LENGTH then
		local log = webgl:getShaderInfoLog(getObj(shader))
		params[0] = #log
	elseif pname == gl.GL_SHADER_SOURCE_LENGTH then
		params[0] = #webgl:getShaderSource(getObj(shader))
	else
		params[0] = webgl:getShaderParameter(getObj(shader), pname)
	end
end

function gl.glGetShaderInfoLog(shader, bufSize, length, infoLog)
	local log = webgl:getShaderInfoLog(getObj(shader))
	if not log then  return end

	length = ffi.cast('int32_t*', length)
	if length ~= ffi.null then
		length[0] = #log
	end
	infoLog = ffi.cast('int32_t*', infoLog)
	if infoLog ~= ffi.null then
		ffi.copy(infoLog, log, math.min(#log+1, bufSize))
	end
end

function gl.glGetShaderSource(shader, bufSize, length, source)
	local src = webgl:getShaderSource(getObj(shader))
	if length then
		length[0] = #src
	end
	if source then
		ffi.copy(source, src, math.min(#src+1, bufSize))
	end
end

function gl.glGetShaderPrecisionFormat(shadertype, precisiontype, range, precision)
	local result = webgl:getShaderPrecisionFormat(shadertype, precisiontype)
	if range then
		range[0] = result.rangeMin
		range[1] = result.rangeMax
	end
	if precision then
		precision[0] = result.precision
	end
end

local createBuffer = res:makeCreate'createBuffer'
function gl.glGenBuffers(n, buffers)
	for i=0,n-1 do
		buffers[i] = createBuffer()
	end
end

function gl.glDeleteBuffers(n, buffers)
	for i=0,n-1 do
		webgl:deleteBuffer((findObj(buffers[i], 'createBuffer')))
	end
end

function gl.glIsBuffer(buffer)
	local entry = select(2, findObj(buffer))
	if not entry then return gl.GL_FALSE end
	if entry.type ~= 'createBuffer' then return gl.GL_FALSE end	-- my own check ... why use webgl's?
	return webgl:isBuffer(entry.id)
end

function gl.glBindBuffer(target, buffer)
	return webgl:bindBuffer(target, getObj(buffer))
end

function gl.glBufferData(target, size, data, usage)
	-- if we don't cast first then, for the case of arrays-of-types-with-ffi-metatypes, luaffifb calls the metatype __eq with the ffi.null object and it usually goes bad
	-- so to get around that ,cast to void* first:
	data = ffi.cast('void*', data)
	if data == ffi.null or data == nil then
		return webgl:bufferData(target, size, usage)
	else
		data = ffi.dataToArray('Uint8Array', data, size)
		return webgl:bufferData(target, data, usage)
	end
end

function gl.glBufferSubData(target, offset, size, data)
	data = ffi.cast('void*', data)
	if data == ffi.null or data == nil then
		return webgl:bufferSubData(target, offset)
	else
		data = ffi.dataToArray('Uint8Array', data, size)
		return webgl:bufferSubData(target, offset, data)
	end
end

local getBufferInfo = {}	-- no special array or objects here
local getBufferGetter = makeGetter(getBufferInfo, function(pname, target)
	return webgl:getBufferParameter(target, pname)
end)
function gl.glGetBufferParameteriv(target, pname, params)
	return getBufferGetter(params, pname, target)
end

local createVertexArray = res:makeCreate'createVertexArray'
function gl.glGenVertexArrays(n, arrays)
	for i=0,n-1 do
		arrays[i] = createVertexArray()
	end
end

function gl.glBindVertexArray(array)
	webgl:bindVertexArray(getObj(array))
end


local createTexture = res:makeCreate'createTexture'
function gl.glGenTextures(n, textures)
	for i=0,n-1 do
		textures[i] = createTexture()
	end
end

function gl.glDeleteTextures(n, textures)
	for i=0,n-1 do
		webgl:deleteTexture((findObj(textures[i], 'createTexture')))
	end
end

function gl.glIsTexture(buffer)
	local entry = select(2, findObj(buffer))
	if not entry then return gl.GL_FALSE end
	if entry.type ~= 'createTexture' then return gl.GL_FALSE end	-- my own check ... why use webgl's?
	return webgl:isTexture(entry.id)
end

function gl.glBindTexture(target, texture)
	return webgl:bindTexture(target, getObj(texture))
end

function gl.glTexImage2D(target, level, internalformat, width, height, border, format, type, pixels)
	pixels = ffi.dataToArray(jsTypeForGLType(type), pixels)
	return webgl:texImage2D(target, level, internalformat, width, height, border, format, type, pixels)
end

function gl.glTexSubImage2D(target, level, xoffset, yoffset, width, height, format, type, pixels)
	pixels = ffi.dataToArray(jsTypeForGLType(type), pixels)
	return webgl:texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, pixels)
end

function gl.glCompressedTexImage2D(target, level, internalformat, width, height, border, imageSize, data)
	data = ffi.dataToArray('Uint8Array', data)	-- will this have the same stupid problem as above, that data needs to be float32 vs uint8 in arbitrary situations?
	return webgl:compressedTexImage2D(target, level, internalformat, width, height, border, data)
end

function gl.glCompressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, imageSize, data)
	data = ffi.dataToArray('Uint8Array', data)
	return webgl:compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, data)
end

function gl.glCopyTexImage2D(...) return webgl:copyTexImage2D(...) end
function gl.glCopyTexSubImage2D(...) return webgl:copyTexSubImage2D(...) end
function gl.glActiveTexture(...) return webgl:activeTexture(...) end
function gl.glGenerateMipmap(...) return webgl:generateMipmap(...) end

function gl.glTexParameterf(...) return webgl:texParameterf(...) end
function gl.glTexParameteri(...) return webgl:texParameteri(...) end

function gl.glTexParameterfv(target, pname, params)
	return webgl:texParameterf(target, pname, params[0])
end
function gl.glTexParameteriv(target, pname, params)
	return webgl:texParameteri(target, pname, params[0])
end

local getTexInfo = {}	-- no arrays or objs present
local getTexGetter = makeGetter(getTexInfo, function(pname, target)
	return webgl:getTexParameter(target, pname)
end)
function gl.glGetTexParameteriv(target, pname, params)
	return getTexGetter(params, pname, target)
end
gl.glGetTexParameterfv = gl.glGetTexParameteriv


local createFramebuffer = res:makeCreate'createFramebuffer'
function gl.glGenFramebuffers(n, framebuffers)
	for i=0,n-1 do
		framebuffers[i] = createFramebuffer()
	end
end

function gl.glDeleteFramebuffers(n, framebuffers)
	for i=0,n-1 do
		webgl:deleteFramebuffer((findObj(framebuffers[i], 'createFramebuffer')))
	end
end

function gl.glIsFramebuffer(buffer)
	local entry = select(2, findObj(buffer))
	if not entry then return gl.GL_FALSE end
	if entry.type ~= 'createFramebuffer' then return gl.GL_FALSE end	-- my own check ... why use webgl's?
	return webgl:isFramebuffer(entry.id)
end

function gl.glBindFramebuffer(target, framebuffer)
	return webgl:bindFramebuffer(target, getObj(framebuffer))
end

function gl.glFramebufferTexture2D(target, attachment, textarget, texture, level)
	return webgl:framebufferTexture2D(target, attachment, textarget, getObj(texture), level)
end

function gl.glCheckFramebufferStatus(...) return webgl:checkFramebufferStatus(...) end

local getFramebufferAttachmentInfo = {
	[gl.GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME] = {res={createTexture=1, createRenderbuffer=1}},
}
local getFramebufferAttachmentGetter = makeGetter(getFramebufferAttachmentInfo, function(pname, target, attachment)
	return webgl:getFramebufferAttachment(target, attachment, pname)
end)
function gl.glGetFramebufferAttachmentParameteriv(target, attachment, pname, params)
	return getFramebufferAttachmentGetter(params, pname, target, attachment)
end


local createRenderbuffer = res:makeCreate'createRenderbuffer'
function gl.glGenRenderbuffers(n, renderbuffers)
	for i=0,n-1 do
		renderbuffers[i] = createRenderbuffer()
	end
end

function gl.glDeleteRenderbuffers(n, renderbuffers)
	for i=0,n-1 do
		webgl:deleteRenderbuffer((findObj(renderbuffers[i], 'createRenderbuffer')))
	end
end

function gl.glIsRenderbuffer(buffer)
	local entry = select(2, findObj(buffer))
	if not entry then return gl.GL_FALSE end
	if entry.type ~= 'createRenderbuffer' then return gl.GL_FALSE end	-- my own check ... why use webgl's?
	return webgl:isRenderbuffer(entry.id)
end

function gl.glBindRenderbuffer(target, renderbuffer)
	return webgl:bindRenderbuffer(target, getObj(renderbuffer))
end

function gl.glRenderbufferStorage(...) return webgl:renderbufferStorage(...) end

function gl.glFramebufferRenderbuffer(target, attachment, renderbuffertarget, renderbuffer)
	return webgl:framebufferRenderbuffer(target, attachment, renderbuffertarget, getObj(renderbuffer))
end

local getRenderbufferInfo = {}	-- nothing special, only returns single ints
local getRenderbufferGetter = makeGetter(getRenderbufferInfo, function(pname, target)
	return webgl:getRenderbufferParameter(target, pname)
end)
function gl.glGetRenderbufferParameteriv(target, pname, params)
	return getRenderbufferGetter(params, pname, target)
end


-- opengles3 / webgl2


function gl.glReadBuffer(...) return webgl:readBuffer(...) end

function gl.glDrawRangeElements(mode, indexStart, indexEnd, count, type, indices)
	indices = tonumber(ffi.cast('intptr_t', ffi.cast('void*', indices)))
	return webgl:drawRangeElements(mode, indexStart, indexEnd, count, type, indices)
end


function gl.glDrawArraysInstanced(...) return webgl:drawArraysInstanced(...) end

function gl.glTexImage3D(target, level, internalformat, width, height, depth, border, format, type, pixels)
	pixels = ffi.dataToArray(jsTypeForGLType(type), pixels)
	return webgl:texImage3D(target, level, internalformat, width, height, depth, border, format, type, pixels)
end

function gl.glTexSubImage3D(target, level, xoffset, yoffset, width, height, depth, format, type, pixels)
	pixels = ffi.dataToArray(jsTypeForGLType(type), pixels)
	return webgl:texSubImage3D(target, level, xoffset, yoffset, width, height, depth, format, type, pixels)
end

function gl.glCopyTexSubImage3D(...) return webgl:copyTexSubImage3D(...) end

function gl.glCompressedTexImage3D(target, level, internalformat, width, height, depth, border, imageSize, data)
	data = ffi.dataToArray('Uint8Array', data)	-- will this have the same stupid problem as above, that data needs to be float32 vs uint8 in arbitrary situations?
	return webgl:compressedTexImage3D(target, level, internalformat, width, height, depth, border, data)
end

function gl.glCompressedTexSubImage3D(target, level, xoffset, yoffset, width, height, depth, format, imageSize, data)
	data = ffi.dataToArray('Uint8Array', data)
	return webgl:compressedTexSubImage3D(target, level, xoffset, yoffset, width, height, depth, format, data)
end

local createQuery = res:makeCreate'createQuery'
function gl.glGenQueries(n, ids)
	for i=0,n-1 do
		ids[i] = createQuery()
	end
end

function gl.glDeleteQueries(n, ids)
	for i=0,n-1 do
		webgl:deleteQuery((findObj(ids[i], 'createQuery')))
	end
end

function gl.glIsQuery(buffer)
	local entry = select(2, findObj(buffer))
	if not entry then return gl.GL_FALSE end
	if entry.type ~= 'createQuery' then return gl.GL_FALSE end	-- my own check ... why use webgl's?
	return webgl:isQuery(entry.id)
end

function gl.glBeginQuery(target, id)
	return webgl:beginQuery(target, getObj(id))
end

function gl.glEndQuery(...) return webgl:endQuery(...) end

local getQueryInfo = {
}
local getQueryGetter = makeGetter(getQueryInfo, function(pname, target)
	return webgl:getQuery(target, pname)
end)
function gl.glGetQueryiv(target, pname, params)
	return getQueryGetter(params, pname, target)
end

function gl.glGetQueryObjectuiv(id, pname, params)
	params[0] = webgl:getQueryParameter(getObj(id), pname)
end

function gl.glUnmapBuffer(target) error'not supported' end	-- webgl equivalent?
function gl.glGetBufferPointerv(target, pname, params) error'not supported' end

function gl.glDrawBuffers(n, bufs)
	local ar = window:Array()
	for i=0,n-1 do
		ar[i] = bufs[i]
	end
	return webgl:drawBuffers(ar)
end

return gl
