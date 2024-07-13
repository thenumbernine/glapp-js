local ffi = require 'ffi'
local table = require 'ext.table'
local class = require 'ext.class'

ffi.cdef[[
///khrplatform
typedef int32_t khronos_int32_t;
typedef uint32_t khronos_uint32_t;
typedef int64_t khronos_int64_t;
typedef uint64_t khronos_uint64_t;
//enum { KHRONOS_SUPPORT_INT64 = 1 };
//enum { KHRONOS_SUPPORT_FLOAT = 1 };
typedef signed char khronos_int8_t;
typedef unsigned char khronos_uint8_t;
// TODO errors on this one ...
// TODO FIXME tried to redefine int ...
//typedef signed short int khronos_int16_t;
typedef short khronos_int16_t;
//typedef unsigned short int khronos_uint16_t;
typedef unsigned short khronos_uint16_t;
//typedef signed long int khronos_intptr_t;
typedef long khronos_intptr_t;
//typedef unsigned long int khronos_uintptr_t;
typedef unsigned long khronos_uintptr_t;
//typedef signed long int khronos_ssize_t;
typedef long khronos_ssize_t;
typedef unsigned long khronos_usize_t;
typedef float khronos_float_t;
typedef khronos_uint64_t khronos_utime_nanoseconds_t;
typedef khronos_int64_t khronos_stime_nanoseconds_t;
//enum { KHRONOS_MAX_ENUM = 2147483647 };
//typedef enum { KHRONOS_FALSE = 0, KHRONOS_TRUE = 1, KHRONOS_BOOLEAN_ENUM_FORCE_SIZE = 0x7FFFFFFF } khronos_boolean_enum_t;

//gles3
typedef khronos_int8_t GLbyte;
typedef khronos_float_t GLclampf;
typedef khronos_int32_t GLfixed;
typedef khronos_int16_t GLshort;
typedef khronos_uint16_t GLushort;
typedef void GLvoid;
//typedef struct __GLsync *GLsync;
typedef khronos_int64_t GLint64;
typedef khronos_uint64_t GLuint64;
typedef unsigned int GLenum;
typedef unsigned int GLuint;
typedef char GLchar;
typedef khronos_float_t GLfloat;
typedef khronos_ssize_t GLsizeiptr;
typedef khronos_intptr_t GLintptr;
typedef unsigned int GLbitfield;
typedef int GLint;
typedef unsigned char GLboolean;
typedef int GLsizei;
typedef khronos_uint8_t GLubyte;
typedef khronos_uint16_t GLhalf;

// these are in desktop GL but not GLES
typedef double GLdouble;
typedef double GLclampd;
]]

local gl = {}

gl.GL_GLES_PROTOTYPES = 1
gl.GL_ES_VERSION_2_0 = 1
gl.GL_DEPTH_BUFFER_BIT = 256
gl.GL_STENCIL_BUFFER_BIT = 1024
gl.GL_COLOR_BUFFER_BIT = 16384
gl.GL_FALSE = 0
gl.GL_TRUE = 1
gl.GL_POINTS = 0
gl.GL_LINES = 1
gl.GL_LINE_LOOP = 2
gl.GL_LINE_STRIP = 3
gl.GL_TRIANGLES = 4
gl.GL_TRIANGLE_STRIP = 5
gl.GL_TRIANGLE_FAN = 6
gl.GL_ZERO = 0
gl.GL_ONE = 1
gl.GL_SRC_COLOR = 768
gl.GL_ONE_MINUS_SRC_COLOR = 769
gl.GL_SRC_ALPHA = 770
gl.GL_ONE_MINUS_SRC_ALPHA = 771
gl.GL_DST_ALPHA = 772
gl.GL_ONE_MINUS_DST_ALPHA = 773
gl.GL_DST_COLOR = 774
gl.GL_ONE_MINUS_DST_COLOR = 775
gl.GL_SRC_ALPHA_SATURATE = 776
gl.GL_FUNC_ADD = 32774
gl.GL_BLEND_EQUATION = 32777
gl.GL_BLEND_EQUATION_RGB = 32777
gl.GL_BLEND_EQUATION_ALPHA = 34877
gl.GL_FUNC_SUBTRACT = 32778
gl.GL_FUNC_REVERSE_SUBTRACT = 32779
gl.GL_BLEND_DST_RGB = 32968
gl.GL_BLEND_SRC_RGB = 32969
gl.GL_BLEND_DST_ALPHA = 32970
gl.GL_BLEND_SRC_ALPHA = 32971
gl.GL_CONSTANT_COLOR = 32769
gl.GL_ONE_MINUS_CONSTANT_COLOR = 32770
gl.GL_CONSTANT_ALPHA = 32771
gl.GL_ONE_MINUS_CONSTANT_ALPHA = 32772
gl.GL_BLEND_COLOR = 32773
gl.GL_ARRAY_BUFFER = 34962
gl.GL_ELEMENT_ARRAY_BUFFER = 34963
gl.GL_ARRAY_BUFFER_BINDING = 34964
gl.GL_ELEMENT_ARRAY_BUFFER_BINDING = 34965
gl.GL_STREAM_DRAW = 35040
gl.GL_STATIC_DRAW = 35044
gl.GL_DYNAMIC_DRAW = 35048
gl.GL_BUFFER_SIZE = 34660
gl.GL_BUFFER_USAGE = 34661
gl.GL_CURRENT_VERTEX_ATTRIB = 34342
gl.GL_FRONT = 1028
gl.GL_BACK = 1029
gl.GL_FRONT_AND_BACK = 1032
gl.GL_TEXTURE_2D = 3553
gl.GL_CULL_FACE = 2884
gl.GL_BLEND = 3042
gl.GL_DITHER = 3024
gl.GL_STENCIL_TEST = 2960
gl.GL_DEPTH_TEST = 2929
gl.GL_SCISSOR_TEST = 3089
gl.GL_POLYGON_OFFSET_FILL = 32823
gl.GL_SAMPLE_ALPHA_TO_COVERAGE = 32926
gl.GL_SAMPLE_COVERAGE = 32928
gl.GL_NO_ERROR = 0
gl.GL_INVALID_ENUM = 1280
gl.GL_INVALID_VALUE = 1281
gl.GL_INVALID_OPERATION = 1282
gl.GL_OUT_OF_MEMORY = 1285
gl.GL_CW = 2304
gl.GL_CCW = 2305
gl.GL_LINE_WIDTH = 2849
gl.GL_ALIASED_POINT_SIZE_RANGE = 33901
gl.GL_ALIASED_LINE_WIDTH_RANGE = 33902
gl.GL_CULL_FACE_MODE = 2885
gl.GL_FRONT_FACE = 2886
gl.GL_DEPTH_RANGE = 2928
gl.GL_DEPTH_WRITEMASK = 2930
gl.GL_DEPTH_CLEAR_VALUE = 2931
gl.GL_DEPTH_FUNC = 2932
gl.GL_STENCIL_CLEAR_VALUE = 2961
gl.GL_STENCIL_FUNC = 2962
gl.GL_STENCIL_FAIL = 2964
gl.GL_STENCIL_PASS_DEPTH_FAIL = 2965
gl.GL_STENCIL_PASS_DEPTH_PASS = 2966
gl.GL_STENCIL_REF = 2967
gl.GL_STENCIL_VALUE_MASK = 2963
gl.GL_STENCIL_WRITEMASK = 2968
gl.GL_STENCIL_BACK_FUNC = 34816
gl.GL_STENCIL_BACK_FAIL = 34817
gl.GL_STENCIL_BACK_PASS_DEPTH_FAIL = 34818
gl.GL_STENCIL_BACK_PASS_DEPTH_PASS = 34819
gl.GL_STENCIL_BACK_REF = 36003
gl.GL_STENCIL_BACK_VALUE_MASK = 36004
gl.GL_STENCIL_BACK_WRITEMASK = 36005
gl.GL_VIEWPORT = 2978
gl.GL_SCISSOR_BOX = 3088
gl.GL_COLOR_CLEAR_VALUE = 3106
gl.GL_COLOR_WRITEMASK = 3107
gl.GL_UNPACK_ALIGNMENT = 3317
gl.GL_PACK_ALIGNMENT = 3333
gl.GL_MAX_TEXTURE_SIZE = 3379
gl.GL_MAX_VIEWPORT_DIMS = 3386
gl.GL_SUBPIXEL_BITS = 3408
gl.GL_RED_BITS = 3410
gl.GL_GREEN_BITS = 3411
gl.GL_BLUE_BITS = 3412
gl.GL_ALPHA_BITS = 3413
gl.GL_DEPTH_BITS = 3414
gl.GL_STENCIL_BITS = 3415
gl.GL_POLYGON_OFFSET_UNITS = 10752
gl.GL_POLYGON_OFFSET_FACTOR = 32824
gl.GL_TEXTURE_BINDING_2D = 32873
gl.GL_SAMPLE_BUFFERS = 32936
gl.GL_SAMPLES = 32937
gl.GL_SAMPLE_COVERAGE_VALUE = 32938
gl.GL_SAMPLE_COVERAGE_INVERT = 32939
gl.GL_NUM_COMPRESSED_TEXTURE_FORMATS = 34466
gl.GL_COMPRESSED_TEXTURE_FORMATS = 34467
gl.GL_DONT_CARE = 4352
gl.GL_FASTEST = 4353
gl.GL_NICEST = 4354
gl.GL_GENERATE_MIPMAP_HINT = 33170
gl.GL_BYTE = 5120
gl.GL_UNSIGNED_BYTE = 5121
gl.GL_SHORT = 5122
gl.GL_UNSIGNED_SHORT = 5123
gl.GL_INT = 5124
gl.GL_UNSIGNED_INT = 5125
gl.GL_FLOAT = 5126
gl.GL_FIXED = 5132
gl.GL_DEPTH_COMPONENT = 6402
gl.GL_ALPHA = 6406
gl.GL_RGB = 6407
gl.GL_RGBA = 6408
gl.GL_LUMINANCE = 6409
gl.GL_LUMINANCE_ALPHA = 6410
gl.GL_UNSIGNED_SHORT_4_4_4_4 = 32819
gl.GL_UNSIGNED_SHORT_5_5_5_1 = 32820
gl.GL_UNSIGNED_SHORT_5_6_5 = 33635
gl.GL_FRAGMENT_SHADER = 35632
gl.GL_VERTEX_SHADER = 35633
gl.GL_MAX_VERTEX_ATTRIBS = 34921
gl.GL_MAX_VERTEX_UNIFORM_VECTORS = 36347
gl.GL_MAX_VARYING_VECTORS = 36348
gl.GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = 35661
gl.GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS = 35660
gl.GL_MAX_TEXTURE_IMAGE_UNITS = 34930
gl.GL_MAX_FRAGMENT_UNIFORM_VECTORS = 36349
gl.GL_SHADER_TYPE = 35663
gl.GL_DELETE_STATUS = 35712
gl.GL_LINK_STATUS = 35714
gl.GL_VALIDATE_STATUS = 35715
gl.GL_ATTACHED_SHADERS = 35717
gl.GL_ACTIVE_UNIFORMS = 35718
gl.GL_ACTIVE_UNIFORM_MAX_LENGTH = 35719
gl.GL_ACTIVE_ATTRIBUTES = 35721
gl.GL_ACTIVE_ATTRIBUTE_MAX_LENGTH = 35722
gl.GL_SHADING_LANGUAGE_VERSION = 35724
gl.GL_CURRENT_PROGRAM = 35725
gl.GL_NEVER = 512
gl.GL_LESS = 513
gl.GL_EQUAL = 514
gl.GL_LEQUAL = 515
gl.GL_GREATER = 516
gl.GL_NOTEQUAL = 517
gl.GL_GEQUAL = 518
gl.GL_ALWAYS = 519
gl.GL_KEEP = 7680
gl.GL_REPLACE = 7681
gl.GL_INCR = 7682
gl.GL_DECR = 7683
gl.GL_INVERT = 5386
gl.GL_INCR_WRAP = 34055
gl.GL_DECR_WRAP = 34056
gl.GL_VENDOR = 7936
gl.GL_RENDERER = 7937
gl.GL_VERSION = 7938
gl.GL_EXTENSIONS = 7939
gl.GL_NEAREST = 9728
gl.GL_LINEAR = 9729
gl.GL_NEAREST_MIPMAP_NEAREST = 9984
gl.GL_LINEAR_MIPMAP_NEAREST = 9985
gl.GL_NEAREST_MIPMAP_LINEAR = 9986
gl.GL_LINEAR_MIPMAP_LINEAR = 9987
gl.GL_TEXTURE_MAG_FILTER = 10240
gl.GL_TEXTURE_MIN_FILTER = 10241
gl.GL_TEXTURE_WRAP_S = 10242
gl.GL_TEXTURE_WRAP_T = 10243
gl.GL_TEXTURE = 5890
gl.GL_TEXTURE_CUBE_MAP = 34067
gl.GL_TEXTURE_BINDING_CUBE_MAP = 34068
gl.GL_TEXTURE_CUBE_MAP_POSITIVE_X = 34069
gl.GL_TEXTURE_CUBE_MAP_NEGATIVE_X = 34070
gl.GL_TEXTURE_CUBE_MAP_POSITIVE_Y = 34071
gl.GL_TEXTURE_CUBE_MAP_NEGATIVE_Y = 34072
gl.GL_TEXTURE_CUBE_MAP_POSITIVE_Z = 34073
gl.GL_TEXTURE_CUBE_MAP_NEGATIVE_Z = 34074
gl.GL_MAX_CUBE_MAP_TEXTURE_SIZE = 34076
gl.GL_TEXTURE0 = 33984
gl.GL_TEXTURE1 = 33985
gl.GL_TEXTURE2 = 33986
gl.GL_TEXTURE3 = 33987
gl.GL_TEXTURE4 = 33988
gl.GL_TEXTURE5 = 33989
gl.GL_TEXTURE6 = 33990
gl.GL_TEXTURE7 = 33991
gl.GL_TEXTURE8 = 33992
gl.GL_TEXTURE9 = 33993
gl.GL_TEXTURE10 = 33994
gl.GL_TEXTURE11 = 33995
gl.GL_TEXTURE12 = 33996
gl.GL_TEXTURE13 = 33997
gl.GL_TEXTURE14 = 33998
gl.GL_TEXTURE15 = 33999
gl.GL_TEXTURE16 = 34000
gl.GL_TEXTURE17 = 34001
gl.GL_TEXTURE18 = 34002
gl.GL_TEXTURE19 = 34003
gl.GL_TEXTURE20 = 34004
gl.GL_TEXTURE21 = 34005
gl.GL_TEXTURE22 = 34006
gl.GL_TEXTURE23 = 34007
gl.GL_TEXTURE24 = 34008
gl.GL_TEXTURE25 = 34009
gl.GL_TEXTURE26 = 34010
gl.GL_TEXTURE27 = 34011
gl.GL_TEXTURE28 = 34012
gl.GL_TEXTURE29 = 34013
gl.GL_TEXTURE30 = 34014
gl.GL_TEXTURE31 = 34015
gl.GL_ACTIVE_TEXTURE = 34016
gl.GL_REPEAT = 10497
gl.GL_CLAMP_TO_EDGE = 33071
gl.GL_MIRRORED_REPEAT = 33648
gl.GL_FLOAT_VEC2 = 35664
gl.GL_FLOAT_VEC3 = 35665
gl.GL_FLOAT_VEC4 = 35666
gl.GL_INT_VEC2 = 35667
gl.GL_INT_VEC3 = 35668
gl.GL_INT_VEC4 = 35669
gl.GL_BOOL = 35670
gl.GL_BOOL_VEC2 = 35671
gl.GL_BOOL_VEC3 = 35672
gl.GL_BOOL_VEC4 = 35673
gl.GL_FLOAT_MAT2 = 35674
gl.GL_FLOAT_MAT3 = 35675
gl.GL_FLOAT_MAT4 = 35676
gl.GL_SAMPLER_2D = 35678
gl.GL_SAMPLER_CUBE = 35680
gl.GL_VERTEX_ATTRIB_ARRAY_ENABLED = 34338
gl.GL_VERTEX_ATTRIB_ARRAY_SIZE = 34339
gl.GL_VERTEX_ATTRIB_ARRAY_STRIDE = 34340
gl.GL_VERTEX_ATTRIB_ARRAY_TYPE = 34341
gl.GL_VERTEX_ATTRIB_ARRAY_NORMALIZED = 34922
gl.GL_VERTEX_ATTRIB_ARRAY_POINTER = 34373
gl.GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 34975
gl.GL_IMPLEMENTATION_COLOR_READ_TYPE = 35738
gl.GL_IMPLEMENTATION_COLOR_READ_FORMAT = 35739
gl.GL_COMPILE_STATUS = 35713
gl.GL_INFO_LOG_LENGTH = 35716
gl.GL_SHADER_SOURCE_LENGTH = 35720
gl.GL_SHADER_COMPILER = 36346
gl.GL_SHADER_BINARY_FORMATS = 36344
gl.GL_NUM_SHADER_BINARY_FORMATS = 36345
gl.GL_LOW_FLOAT = 36336
gl.GL_MEDIUM_FLOAT = 36337
gl.GL_HIGH_FLOAT = 36338
gl.GL_LOW_INT = 36339
gl.GL_MEDIUM_INT = 36340
gl.GL_HIGH_INT = 36341
gl.GL_FRAMEBUFFER = 36160
gl.GL_RENDERBUFFER = 36161
gl.GL_RGBA4 = 32854
gl.GL_RGB5_A1 = 32855
gl.GL_RGB565 = 36194
gl.GL_DEPTH_COMPONENT16 = 33189
gl.GL_STENCIL_INDEX8 = 36168
gl.GL_RENDERBUFFER_WIDTH = 36162
gl.GL_RENDERBUFFER_HEIGHT = 36163
gl.GL_RENDERBUFFER_INTERNAL_FORMAT = 36164
gl.GL_RENDERBUFFER_RED_SIZE = 36176
gl.GL_RENDERBUFFER_GREEN_SIZE = 36177
gl.GL_RENDERBUFFER_BLUE_SIZE = 36178
gl.GL_RENDERBUFFER_ALPHA_SIZE = 36179
gl.GL_RENDERBUFFER_DEPTH_SIZE = 36180
gl.GL_RENDERBUFFER_STENCIL_SIZE = 36181
gl.GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 36048
gl.GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 36049
gl.GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 36050
gl.GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 36051
gl.GL_COLOR_ATTACHMENT0 = 36064
gl.GL_DEPTH_ATTACHMENT = 36096
gl.GL_STENCIL_ATTACHMENT = 36128
gl.GL_NONE = 0
gl.GL_FRAMEBUFFER_COMPLETE = 36053
gl.GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 36054
gl.GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 36055
gl.GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS = 36057
gl.GL_FRAMEBUFFER_UNSUPPORTED = 36061
gl.GL_FRAMEBUFFER_BINDING = 36006
gl.GL_RENDERBUFFER_BINDING = 36007
gl.GL_MAX_RENDERBUFFER_SIZE = 34024
gl.GL_INVALID_FRAMEBUFFER_OPERATION = 1286
gl.GL_ES_VERSION_3_0 = 1
gl.GL_READ_BUFFER = 3074
gl.GL_UNPACK_ROW_LENGTH = 3314
gl.GL_UNPACK_SKIP_ROWS = 3315
gl.GL_UNPACK_SKIP_PIXELS = 3316
gl.GL_PACK_ROW_LENGTH = 3330
gl.GL_PACK_SKIP_ROWS = 3331
gl.GL_PACK_SKIP_PIXELS = 3332
gl.GL_COLOR = 6144
gl.GL_DEPTH = 6145
gl.GL_STENCIL = 6146
gl.GL_RED = 6403
gl.GL_RGB8 = 32849
gl.GL_RGBA8 = 32856
gl.GL_RGB10_A2 = 32857
gl.GL_TEXTURE_BINDING_3D = 32874
gl.GL_UNPACK_SKIP_IMAGES = 32877
gl.GL_UNPACK_IMAGE_HEIGHT = 32878
gl.GL_TEXTURE_3D = 32879
gl.GL_TEXTURE_WRAP_R = 32882
gl.GL_MAX_3D_TEXTURE_SIZE = 32883
gl.GL_UNSIGNED_INT_2_10_10_10_REV = 33640
gl.GL_MAX_ELEMENTS_VERTICES = 33000
gl.GL_MAX_ELEMENTS_INDICES = 33001
gl.GL_TEXTURE_MIN_LOD = 33082
gl.GL_TEXTURE_MAX_LOD = 33083
gl.GL_TEXTURE_BASE_LEVEL = 33084
gl.GL_TEXTURE_MAX_LEVEL = 33085
gl.GL_MIN = 32775
gl.GL_MAX = 32776
gl.GL_DEPTH_COMPONENT24 = 33190
gl.GL_MAX_TEXTURE_LOD_BIAS = 34045
gl.GL_TEXTURE_COMPARE_MODE = 34892
gl.GL_TEXTURE_COMPARE_FUNC = 34893
gl.GL_CURRENT_QUERY = 34917
gl.GL_QUERY_RESULT = 34918
gl.GL_QUERY_RESULT_AVAILABLE = 34919
gl.GL_BUFFER_MAPPED = 35004
gl.GL_BUFFER_MAP_POINTER = 35005
gl.GL_STREAM_READ = 35041
gl.GL_STREAM_COPY = 35042
gl.GL_STATIC_READ = 35045
gl.GL_STATIC_COPY = 35046
gl.GL_DYNAMIC_READ = 35049
gl.GL_DYNAMIC_COPY = 35050
gl.GL_MAX_DRAW_BUFFERS = 34852
gl.GL_DRAW_BUFFER0 = 34853
gl.GL_DRAW_BUFFER1 = 34854
gl.GL_DRAW_BUFFER2 = 34855
gl.GL_DRAW_BUFFER3 = 34856
gl.GL_DRAW_BUFFER4 = 34857
gl.GL_DRAW_BUFFER5 = 34858
gl.GL_DRAW_BUFFER6 = 34859
gl.GL_DRAW_BUFFER7 = 34860
gl.GL_DRAW_BUFFER8 = 34861
gl.GL_DRAW_BUFFER9 = 34862
gl.GL_DRAW_BUFFER10 = 34863
gl.GL_DRAW_BUFFER11 = 34864
gl.GL_DRAW_BUFFER12 = 34865
gl.GL_DRAW_BUFFER13 = 34866
gl.GL_DRAW_BUFFER14 = 34867
gl.GL_DRAW_BUFFER15 = 34868
gl.GL_MAX_FRAGMENT_UNIFORM_COMPONENTS = 35657
gl.GL_MAX_VERTEX_UNIFORM_COMPONENTS = 35658
gl.GL_SAMPLER_3D = 35679
gl.GL_SAMPLER_2D_SHADOW = 35682
gl.GL_FRAGMENT_SHADER_DERIVATIVE_HINT = 35723
gl.GL_PIXEL_PACK_BUFFER = 35051
gl.GL_PIXEL_UNPACK_BUFFER = 35052
gl.GL_PIXEL_PACK_BUFFER_BINDING = 35053
gl.GL_PIXEL_UNPACK_BUFFER_BINDING = 35055
gl.GL_FLOAT_MAT2x3 = 35685
gl.GL_FLOAT_MAT2x4 = 35686
gl.GL_FLOAT_MAT3x2 = 35687
gl.GL_FLOAT_MAT3x4 = 35688
gl.GL_FLOAT_MAT4x2 = 35689
gl.GL_FLOAT_MAT4x3 = 35690
gl.GL_SRGB = 35904
gl.GL_SRGB8 = 35905
gl.GL_SRGB8_ALPHA8 = 35907
gl.GL_COMPARE_REF_TO_TEXTURE = 34894
gl.GL_MAJOR_VERSION = 33307
gl.GL_MINOR_VERSION = 33308
gl.GL_NUM_EXTENSIONS = 33309
gl.GL_RGBA32F = 34836
gl.GL_RGB32F = 34837
gl.GL_RGBA16F = 34842
gl.GL_RGB16F = 34843
gl.GL_VERTEX_ATTRIB_ARRAY_INTEGER = 35069
gl.GL_MAX_ARRAY_TEXTURE_LAYERS = 35071
gl.GL_MIN_PROGRAM_TEXEL_OFFSET = 35076
gl.GL_MAX_PROGRAM_TEXEL_OFFSET = 35077
gl.GL_MAX_VARYING_COMPONENTS = 35659
gl.GL_TEXTURE_2D_ARRAY = 35866
gl.GL_TEXTURE_BINDING_2D_ARRAY = 35869
gl.GL_R11F_G11F_B10F = 35898
gl.GL_UNSIGNED_INT_10F_11F_11F_REV = 35899
gl.GL_RGB9_E5 = 35901
gl.GL_UNSIGNED_INT_5_9_9_9_REV = 35902
gl.GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH = 35958
gl.GL_TRANSFORM_FEEDBACK_BUFFER_MODE = 35967
gl.GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 35968
gl.GL_TRANSFORM_FEEDBACK_VARYINGS = 35971
gl.GL_TRANSFORM_FEEDBACK_BUFFER_START = 35972
gl.GL_TRANSFORM_FEEDBACK_BUFFER_SIZE = 35973
gl.GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 35976
gl.GL_RASTERIZER_DISCARD = 35977
gl.GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 35978
gl.GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 35979
gl.GL_INTERLEAVED_ATTRIBS = 35980
gl.GL_SEPARATE_ATTRIBS = 35981
gl.GL_TRANSFORM_FEEDBACK_BUFFER = 35982
gl.GL_TRANSFORM_FEEDBACK_BUFFER_BINDING = 35983
gl.GL_RGBA32UI = 36208
gl.GL_RGB32UI = 36209
gl.GL_RGBA16UI = 36214
gl.GL_RGB16UI = 36215
gl.GL_RGBA8UI = 36220
gl.GL_RGB8UI = 36221
gl.GL_RGBA32I = 36226
gl.GL_RGB32I = 36227
gl.GL_RGBA16I = 36232
gl.GL_RGB16I = 36233
gl.GL_RGBA8I = 36238
gl.GL_RGB8I = 36239
gl.GL_RED_INTEGER = 36244
gl.GL_RGB_INTEGER = 36248
gl.GL_RGBA_INTEGER = 36249
gl.GL_SAMPLER_2D_ARRAY = 36289
gl.GL_SAMPLER_2D_ARRAY_SHADOW = 36292
gl.GL_SAMPLER_CUBE_SHADOW = 36293
gl.GL_UNSIGNED_INT_VEC2 = 36294
gl.GL_UNSIGNED_INT_VEC3 = 36295
gl.GL_UNSIGNED_INT_VEC4 = 36296
gl.GL_INT_SAMPLER_2D = 36298
gl.GL_INT_SAMPLER_3D = 36299
gl.GL_INT_SAMPLER_CUBE = 36300
gl.GL_INT_SAMPLER_2D_ARRAY = 36303
gl.GL_UNSIGNED_INT_SAMPLER_2D = 36306
gl.GL_UNSIGNED_INT_SAMPLER_3D = 36307
gl.GL_UNSIGNED_INT_SAMPLER_CUBE = 36308
gl.GL_UNSIGNED_INT_SAMPLER_2D_ARRAY = 36311
gl.GL_BUFFER_ACCESS_FLAGS = 37151
gl.GL_BUFFER_MAP_LENGTH = 37152
gl.GL_BUFFER_MAP_OFFSET = 37153
gl.GL_DEPTH_COMPONENT32F = 36012
gl.GL_DEPTH32F_STENCIL8 = 36013
gl.GL_FLOAT_32_UNSIGNED_INT_24_8_REV = 36269
gl.GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 33296
gl.GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 33297
gl.GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE = 33298
gl.GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 33299
gl.GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 33300
gl.GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 33301
gl.GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 33302
gl.GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 33303
gl.GL_FRAMEBUFFER_DEFAULT = 33304
gl.GL_FRAMEBUFFER_UNDEFINED = 33305
gl.GL_DEPTH_STENCIL_ATTACHMENT = 33306
gl.GL_DEPTH_STENCIL = 34041
gl.GL_UNSIGNED_INT_24_8 = 34042
gl.GL_DEPTH24_STENCIL8 = 35056
gl.GL_UNSIGNED_NORMALIZED = 35863
gl.GL_DRAW_FRAMEBUFFER_BINDING = 36006
gl.GL_READ_FRAMEBUFFER = 36008
gl.GL_DRAW_FRAMEBUFFER = 36009
gl.GL_READ_FRAMEBUFFER_BINDING = 36010
gl.GL_RENDERBUFFER_SAMPLES = 36011
gl.GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 36052
gl.GL_MAX_COLOR_ATTACHMENTS = 36063
gl.GL_COLOR_ATTACHMENT1 = 36065
gl.GL_COLOR_ATTACHMENT2 = 36066
gl.GL_COLOR_ATTACHMENT3 = 36067
gl.GL_COLOR_ATTACHMENT4 = 36068
gl.GL_COLOR_ATTACHMENT5 = 36069
gl.GL_COLOR_ATTACHMENT6 = 36070
gl.GL_COLOR_ATTACHMENT7 = 36071
gl.GL_COLOR_ATTACHMENT8 = 36072
gl.GL_COLOR_ATTACHMENT9 = 36073
gl.GL_COLOR_ATTACHMENT10 = 36074
gl.GL_COLOR_ATTACHMENT11 = 36075
gl.GL_COLOR_ATTACHMENT12 = 36076
gl.GL_COLOR_ATTACHMENT13 = 36077
gl.GL_COLOR_ATTACHMENT14 = 36078
gl.GL_COLOR_ATTACHMENT15 = 36079
gl.GL_COLOR_ATTACHMENT16 = 36080
gl.GL_COLOR_ATTACHMENT17 = 36081
gl.GL_COLOR_ATTACHMENT18 = 36082
gl.GL_COLOR_ATTACHMENT19 = 36083
gl.GL_COLOR_ATTACHMENT20 = 36084
gl.GL_COLOR_ATTACHMENT21 = 36085
gl.GL_COLOR_ATTACHMENT22 = 36086
gl.GL_COLOR_ATTACHMENT23 = 36087
gl.GL_COLOR_ATTACHMENT24 = 36088
gl.GL_COLOR_ATTACHMENT25 = 36089
gl.GL_COLOR_ATTACHMENT26 = 36090
gl.GL_COLOR_ATTACHMENT27 = 36091
gl.GL_COLOR_ATTACHMENT28 = 36092
gl.GL_COLOR_ATTACHMENT29 = 36093
gl.GL_COLOR_ATTACHMENT30 = 36094
gl.GL_COLOR_ATTACHMENT31 = 36095
gl.GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 36182
gl.GL_MAX_SAMPLES = 36183
gl.GL_HALF_FLOAT = 5131
gl.GL_MAP_READ_BIT = 1
gl.GL_MAP_WRITE_BIT = 2
gl.GL_MAP_INVALIDATE_RANGE_BIT = 4
gl.GL_MAP_INVALIDATE_BUFFER_BIT = 8
gl.GL_MAP_FLUSH_EXPLICIT_BIT = 16
gl.GL_MAP_UNSYNCHRONIZED_BIT = 32
gl.GL_RG = 33319
gl.GL_RG_INTEGER = 33320
gl.GL_R8 = 33321
gl.GL_RG8 = 33323
gl.GL_R16F = 33325
gl.GL_R32F = 33326
gl.GL_RG16F = 33327
gl.GL_RG32F = 33328
gl.GL_R8I = 33329
gl.GL_R8UI = 33330
gl.GL_R16I = 33331
gl.GL_R16UI = 33332
gl.GL_R32I = 33333
gl.GL_R32UI = 33334
gl.GL_RG8I = 33335
gl.GL_RG8UI = 33336
gl.GL_RG16I = 33337
gl.GL_RG16UI = 33338
gl.GL_RG32I = 33339
gl.GL_RG32UI = 33340
gl.GL_VERTEX_ARRAY_BINDING = 34229
gl.GL_R8_SNORM = 36756
gl.GL_RG8_SNORM = 36757
gl.GL_RGB8_SNORM = 36758
gl.GL_RGBA8_SNORM = 36759
gl.GL_SIGNED_NORMALIZED = 36764
gl.GL_PRIMITIVE_RESTART_FIXED_INDEX = 36201
gl.GL_COPY_READ_BUFFER = 36662
gl.GL_COPY_WRITE_BUFFER = 36663
gl.GL_COPY_READ_BUFFER_BINDING = 36662
gl.GL_COPY_WRITE_BUFFER_BINDING = 36663
gl.GL_UNIFORM_BUFFER = 35345
gl.GL_UNIFORM_BUFFER_BINDING = 35368
gl.GL_UNIFORM_BUFFER_START = 35369
gl.GL_UNIFORM_BUFFER_SIZE = 35370
gl.GL_MAX_VERTEX_UNIFORM_BLOCKS = 35371
gl.GL_MAX_FRAGMENT_UNIFORM_BLOCKS = 35373
gl.GL_MAX_COMBINED_UNIFORM_BLOCKS = 35374
gl.GL_MAX_UNIFORM_BUFFER_BINDINGS = 35375
gl.GL_MAX_UNIFORM_BLOCK_SIZE = 35376
gl.GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 35377
gl.GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 35379
gl.GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT = 35380
gl.GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH = 35381
gl.GL_ACTIVE_UNIFORM_BLOCKS = 35382
gl.GL_UNIFORM_TYPE = 35383
gl.GL_UNIFORM_SIZE = 35384
gl.GL_UNIFORM_NAME_LENGTH = 35385
gl.GL_UNIFORM_BLOCK_INDEX = 35386
gl.GL_UNIFORM_OFFSET = 35387
gl.GL_UNIFORM_ARRAY_STRIDE = 35388
gl.GL_UNIFORM_MATRIX_STRIDE = 35389
gl.GL_UNIFORM_IS_ROW_MAJOR = 35390
gl.GL_UNIFORM_BLOCK_BINDING = 35391
gl.GL_UNIFORM_BLOCK_DATA_SIZE = 35392
gl.GL_UNIFORM_BLOCK_NAME_LENGTH = 35393
gl.GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS = 35394
gl.GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 35395
gl.GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 35396
gl.GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 35398
gl.GL_INVALID_INDEX = 0xFFFFFFFF	-- 0xFFFFFFFFu
gl.GL_MAX_VERTEX_OUTPUT_COMPONENTS = 37154
gl.GL_MAX_FRAGMENT_INPUT_COMPONENTS = 37157
gl.GL_MAX_SERVER_WAIT_TIMEOUT = 37137
gl.GL_OBJECT_TYPE = 37138
gl.GL_SYNC_CONDITION = 37139
gl.GL_SYNC_STATUS = 37140
gl.GL_SYNC_FLAGS = 37141
gl.GL_SYNC_FENCE = 37142
gl.GL_SYNC_GPU_COMMANDS_COMPLETE = 37143
gl.GL_UNSIGNALED = 37144
gl.GL_SIGNALED = 37145
gl.GL_ALREADY_SIGNALED = 37146
gl.GL_TIMEOUT_EXPIRED = 37147
gl.GL_CONDITION_SATISFIED = 37148
gl.GL_WAIT_FAILED = 37149
gl.GL_SYNC_FLUSH_COMMANDS_BIT = 1
gl.GL_VERTEX_ATTRIB_ARRAY_DIVISOR = 35070
gl.GL_ANY_SAMPLES_PASSED = 35887
gl.GL_ANY_SAMPLES_PASSED_CONSERVATIVE = 36202
gl.GL_SAMPLER_BINDING = 35097
gl.GL_RGB10_A2UI = 36975
gl.GL_TEXTURE_SWIZZLE_R = 36418
gl.GL_TEXTURE_SWIZZLE_G = 36419
gl.GL_TEXTURE_SWIZZLE_B = 36420
gl.GL_TEXTURE_SWIZZLE_A = 36421
gl.GL_GREEN = 6404
gl.GL_BLUE = 6405
gl.GL_INT_2_10_10_10_REV = 36255
gl.GL_TRANSFORM_FEEDBACK = 36386
gl.GL_TRANSFORM_FEEDBACK_PAUSED = 36387
gl.GL_TRANSFORM_FEEDBACK_ACTIVE = 36388
gl.GL_TRANSFORM_FEEDBACK_BINDING = 36389
gl.GL_PROGRAM_BINARY_RETRIEVABLE_HINT = 33367
gl.GL_PROGRAM_BINARY_LENGTH = 34625
gl.GL_NUM_PROGRAM_BINARY_FORMATS = 34814
gl.GL_PROGRAM_BINARY_FORMATS = 34815
gl.GL_COMPRESSED_R11_EAC = 37488
gl.GL_COMPRESSED_SIGNED_R11_EAC = 37489
gl.GL_COMPRESSED_RG11_EAC = 37490
gl.GL_COMPRESSED_SIGNED_RG11_EAC = 37491
gl.GL_COMPRESSED_RGB8_ETC2 = 37492
gl.GL_COMPRESSED_SRGB8_ETC2 = 37493
gl.GL_COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2 = 37494
gl.GL_COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2 = 37495
gl.GL_COMPRESSED_RGBA8_ETC2_EAC = 37496
gl.GL_COMPRESSED_SRGB8_ALPHA8_ETC2_EAC = 37497
gl.GL_TEXTURE_IMMUTABLE_FORMAT = 37167
gl.GL_MAX_ELEMENT_INDEX = 36203
gl.GL_NUM_SAMPLE_COUNTS = 37760
gl.GL_TEXTURE_IMMUTABLE_LEVELS = 33503



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

local glerror = gl.GL_NO_ERROR

function gl.glGetError()
	-- idk how to make precedence of whether mine or theirs sets first
	-- too bad there's no glSetError function ....
	if glerror ~= 0 then return glerror end
	return getJSGL():getError()
end

local function setError(err)
	if glerror ~= 0 then return end
	if err == 0 then return end
	glerror = err
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
--DEBUG:print(self.name, 'failed to find id', id)
		setError(gl.GL_INVALID_OPERATION)
	end
	return obj
end

function ResMap:makeCreate(webglfuncname)
	return function(...)
		local jsgl = getJSGL()
		local id = self:getNextID()
--DEBUG:print(self.name, 'making new at id', id)
		assert(self[id] == nil)
		self[id] = {
			obj = jsgl[webglfuncname](jsgl, ...)
		}
		setError(jsgl:getError())
		return ffi.cast('GLuint', id)
	end
end

function gl.glViewport(...) return getJSGL():viewport(...) end
function gl.glClearColor(...) return getJSGL():clearColor(...) end
function gl.glClear(...) return getJSGL():clear(...) end
function gl.glDrawArrays(...) return getJSGL():drawArrays(...) end

local programs = ResMap'programs'
local shaders = ResMap'shaders'
local buffers = ResMap'buffers'

gl.glCreateProgram = programs:makeCreate'createProgram'

function gl.glAttachShader(programID, shaderID)
	local program = programs:get(programID)
	if not program then return end

	local shader = shaders:get(shaderID)
	if not shader then return end

	getJSGL():attachShader(program.obj, shader.obj)
end

function gl.glDetachShader(programID, shaderID)
	local program = programs:get(programID)
	if not program then return end

	local shader = shaders:get(shaderID)
	if not shader then return end

	getJSGL():detachShader(program.obj, shader.obj)
end

function gl.glLinkProgram(id)
	local program = programs:get(id)
	if not program then return end

	getJSGL():linkProgram(program.obj)
end

function gl.glUseProgram(id)
	local program = programs:get(id)
	if not program then return end

	getJSGL():useProgram(program.obj)
end

function gl.glGetProgramiv(id, pname, params)
	local program = programs:get(id)
	if not program then return end

	if pname == gl.GL_ACTIVE_ATOMIC_COUNTER_BUFFERS then
		setError(gl.GL_INVALID_ENUM)
	elseif pname == gl.GL_INFO_LOG_LENGTH then
		params[0] = #getJSGL():getProgramInfoLog(program.obj)
	elseif pname == gl.GL_ACTIVE_UNIFORM_MAX_LENGTH then
		-- https://registry.khronos.org/OpenGL-Refpages/gl4/html/glGetActiveUniform.xhtml
		-- "The size of the character buffer required to store the longest uniform variable name in program can be obtained by calling glGetProgram with the value GL_ACTIVE_UNIFORM_MAX_LENGTH"
		-- I guess webgl doesn't have antything like this ...
		local maxlen = 0
		for i=0,getJSGL():getProgramParameter(program.obj, gl.GL_ACTIVE_UNIFORMS)-1 do
			local uinfo = getJSGL():getActiveUniform(program.obj, i)
			maxlen = math.max(maxlen, #uinfo.name)
		end
		params[0] = maxlen
	elseif pname == gl.GL_ACTIVE_ATTRIBUTE_MAX_LENGTH then
		local maxlen = 0
		for i=0,getJSGL():getProgramParameter(program.obj, gl.GL_ACTIVE_ATTRIBUTES)-1 do
			local uinfo = getJSGL():getActiveAttrib(program.obj, i)
			maxlen = math.max(maxlen, #uinfo.name)
		end
		params[0] = maxlen
	else
		params[0] = getJSGL():getProgramParameter(program.obj, pname)
	end
end

function gl.glGetProgramInfoLog(id, bufSize, length, infoLog)
	local program = programs:get(id)
	if not program then return end

	local log = getJSGL():getProgramInfoLog(program.obj)
	if not log then return  end

	if length ~= ffi.null then
		length[0] = #log
	end
	if infoLog == ffi.null then
		ffi.copy(infoLog, log, bufSize)
	end
end

function gl.glGetActiveUniform(id, index, bufSize, length, size, type, name)
	local program = programs:get(id)
	if not program then return end

	local uinfo = getJSGL():getActiveUniform(program.obj, index)
	if length ~= ffi.null then
		length[0] = #uinfo.name
	end
	if size ~= ffi.null then
		size[0] = uinfo.size
	end
	if type ~= ffi.null then
		type[0] = uinfo.type
	end
	if name ~= ffi.null then
		ffi.copy(name, uinfo.name)
	end
end

function gl.glGetUniformLocation(id, name)
	local program = programs:get(id)
	return program and getJSGL():getUniformLocation(program.obj, ffi.string(name)) or nil
end

for n=1,4 do
	for _,t in ipairs{'f', 'i'} do
		do
			local glname = 'glUniform'..n..t
			local webglname = 'uniform'..n..t
			gl[glname] = function(...)
				local jsgl = getJSGL()
				return jsgl[webglname](jsgl, ...)
			end
		end

		do
			local glname = 'glUniform'..n..t..'v'
			local webglname = 'uniform'..n..t..'v'
			local len = n * 4
			gl[glname] = function(location, count, value)
				-- if it's an array ... coerce somewhere ...

				local buffer = ffi.getDataView(
					t == 'f' and js.global.Float32Array or js.global.Int32Array,
					value,
					len * count
				)
				local jsgl = getJSGL()
				assert(count == 1, "TODO")
				return jsgl[webglname](jsgl, location, buffer)
			end
		end
	end

	do
		local glname = 'glUniformMatrix'..n..'fv'
		local webglname = 'uniformMatrix'..n..'fv'
		local len = n * n * 4
		gl[glname] = function(location, count, transpose, value)
			assert(type(value) == 'cdata')
			-- if it's an array ... coerce somewhere ...
			local buffer = ffi.getDataView(
				js.global.Float32Array,
				value,
				len * count
			)
			local jsgl = getJSGL()
			assert(count == 1, "TODO")
			return jsgl[webglname](jsgl, location, transpose, buffer)
		end
	end
end

function gl.glGetActiveAttrib(id, index, bufSize, length, size, type, name)
	local program = programs:get(id)
	if not program then return end

	local uinfo = getJSGL():getActiveAttrib(program.obj, index)
	if length ~= ffi.null then
		length[0] = #uinfo.name
	end
	if size ~= ffi.null then
		size[0] = uinfo.size
	end
	if type ~= ffi.null then
		type[0] = uinfo.type
	end
	if name ~= ffi.null then
		ffi.copy(name, uinfo.name)
	end
end

function gl.glGetAttribLocation(id, name)
	local program = programs:get(id)
	return program and getJSGL():getAttribLocation(program.obj, ffi.string(name)) or nil
end

-- TODO this doesn't translate directly from ES to WebGL
-- ES allows pointers to be passed when no buffers are bound ... right? idk about specss but it's functional on my desktop at least, similar to GL
-- WebGL only allows this to work with bound buffers
function gl.glVertexAttribPointer(index, size, ctype, normalized, stride, pointer)
	return getJSGL():vertexAttribPointer(index, size, ctype, normalized, stride, tonumber(ffi.cast('intptr_t', pointer)))
end

function gl.glEnableVertexAttribArray(...) return getJSGL():enableVertexAttribArray(...) end
function gl.glDisableVertexAttribArray(...) return getJSGL():disableVertexAttribArray(...) end


gl.glCreateShader = shaders:makeCreate'createShader'

function gl.glShaderSource(id, numStrs, strs, lens)
	local shader = shaders:get(id)
	if not shader then return end

	local s = table()
	for i=0,numStrs-1 do
		table.insert(s, ffi.string(strs[i], lens[i]))
	end
	local source = s:concat()

	getJSGL():shaderSource(shader.obj, source)
end

function gl.glCompileShader(id)
	local shader = shaders:get(id)
	if not shader then return end

	getJSGL():compileShader(shader.obj)
end

function gl.glGetShaderiv(id, pname, params)
	local shader = shaders:get(id)
	if not shader then return end

	-- in gles but not in webgl?
	-- or does gles not allow this also, is it just in gl but not gles?
	if pname == gl.GL_INFO_LOG_LENGTH then
		local log = getJSGL():getShaderInfoLog(shader.obj)
		params[0] = #log
	elseif pname == gl.GL_SHADER_SOURCE_LENGTH then
		params[0] = #getJSGL():getShaderSource(shader.obj)
	else
		params[0] = getJSGL():getShaderParameter(shader.obj, pname)
	end
end

function gl.glGetShaderInfoLog(id, bufSize, length, infoLog)
	local shader = shaders:get(id)
	if not shader then return end

	local log = getJSGL():getShaderInfoLog(shader.obj)
	if not log then  return end

	if length ~= ffi.null then
		length[0] = #log
	end
	if infoLog == ffi.null then
		ffi.copy(infoLog, log, bufSize)
	end
end

local createBuffer = buffers:makeCreate'createBuffer'
function gl.glGenBuffers(n, buffers)
	for i=0,n-1 do
		buffers[i] = createBuffer()
	end
end

function gl.glBindBuffer(target, bufferID)
	local buffer = buffers:get(bufferID)
	if not buffer then return end
	return getJSGL():bindBuffer(target, buffer.obj)
end

function gl.glBufferData(target, size, data, usage)
	if data == ffi.null then
		return getJSGL():bufferData(target, size, usage)
	else
		return getJSGL():bufferData(
			target,
			ffi.getDataView(js.global.Uint8Array, data, size),
			usage
		)
	end
end

-- [[ debugging
gl.programs = programs
gl.shaders = shaders
gl.buffers = buffers
--]]

return gl
