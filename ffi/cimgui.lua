local ffi = require 'ffi'

ffi.cdef[[
struct ImVec2 {
	float x, y;
};
typedef struct ImVec2 ImVec2;
struct ImVec4 {
	float x, y, z, w;
};
typedef struct ImVec4 ImVec4;
]]

local ig = setmetatable({} {
	__index = ffi.C,
})

function ig.igCheckbox() end
function ig.igRadioButton_IntPtr() end

return ig
