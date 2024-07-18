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

local imguiDiv
local idsThisFrame = {}

-- these NewFrame functions are called in this order
function ig.ImGui_ImplOpenGL3_NewFrame() end
function ig.ImGui_ImplSDL2_NewFrame() end
function ig.igNewFrame() 
	-- TODO make sure imguiDiv is attached too? or trust it's not tampered with ...
	if not imguiDiv then
		local document = js.global.document
		--imguiDiv = document:createElement'div'	-- stupid wasmoon error
		imguiDiv = js.createElement'div'
		document.body.appendChild(imguiDiv)
	end
	
	for k in pairs(idsThisFrame) do
		idsThisFrame[k] = nil
	end
end

local function makeOrCreate(idsuffix, tag)
	local id = 'imgui_'..idsuffix -- ... plus id stack
	local document = js.global.document
	local dom = document:getElementById(id)	-- stupid wasmoon error
	--local dom = js.getElementById(id)
	if dom then 
		-- TODO and make sure the dom tag is correct 
		return dom
	end
	--dom = document:createElement'span'	-- stupid wasmoon error
	dom = js.createElement'span'
	imguiDiv:appendChild(dom)
	return dom
end

function ig.igText(fmt, ...)
	assert(select('#', ...) == 0, "haven't got formatted-text yet")
	-- TODO does imgui use fmt or the post-formatted-string as the id?
	makeOrCreate(fmt).innerText = fmt
end

function ig.igSliderFloat()
end


function ig.igInputInt() end
function ig.igInputFloat() end
function ig.igButton() end
function ig.igSameLine() end

function ig.igRender() end
function ig.igGetDrawData() end
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
function ig.ImGui_ImplOpenGL3_RenderDrawData() end

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
