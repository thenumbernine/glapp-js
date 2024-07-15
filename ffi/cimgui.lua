local ffi = require 'ffi'

ffi.cdef[[

enum {
ImGuiConfigFlags_NavEnableKeyboard,
ImGuiConfigFlags_NavEnableGamepad,
};

struct ImVec2 {
	float x, y;
};
typedef struct ImVec2 ImVec2;
struct ImVec4 {
	float x, y, z, w;
};
typedef struct ImVec4 ImVec4;
]]

local ig = setmetatable({}, {
	__index = ffi.C,
})

function ig.igCreateContext() end
function ig.igDestroyContext() end
function ig.igCheckbox() end
function ig.igRadioButton_IntPtr() end
function ig.igStyleColorsDark() end
function ig.ImFontAtlas_ImFontAtlas() end
function ig.ImFontAtlas_AddFontFromFileTTF() end
function ig.ImFontAtlas_Build() return true end
function ig.ImGui_ImplSDL2_InitForOpenGL() end
function ig.ImGui_ImplSDL2_Shutdown() end
function ig.ImGui_ImplSDL2_ProcessEvent() end
function ig.ImGui_ImplOpenGL3_Init() end
function ig.ImGui_ImplOpenGL3_Shutdown() end

function ig.igGetIO()
	-- TODO imgui cdata
	return {
		[0] = {
			ConfigFlags = 0,
			WantCaptureMouse = false,
			WantCaptureKeyboard = false,
		},
	}
end

return ig
