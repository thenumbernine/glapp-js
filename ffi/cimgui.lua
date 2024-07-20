local ffi = require 'ffi'

ffi.cdef[[

/* ironic is supporting bit-shift operator in your cdef parser but not in your grammar */
typedef enum { ImGuiWindowFlags_None, ImGuiWindowFlags_NoTitleBar, ImGuiWindowFlags_NoResize, ImGuiWindowFlags_NoMove, ImGuiWindowFlags_NoScrollbar, ImGuiWindowFlags_NoScrollWithMouse, ImGuiWindowFlags_NoCollapse, ImGuiWindowFlags_AlwaysAutoResize, ImGuiWindowFlags_NoBackground, ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoMouseInputs, ImGuiWindowFlags_MenuBar, ImGuiWindowFlags_HorizontalScrollbar, ImGuiWindowFlags_NoFocusOnAppearing, ImGuiWindowFlags_NoBringToFrontOnFocus, ImGuiWindowFlags_AlwaysVerticalScrollbar, ImGuiWindowFlags_AlwaysHorizontalScrollbar, ImGuiWindowFlags_NoNavInputs, ImGuiWindowFlags_NoNavFocus, ImGuiWindowFlags_UnsavedDocument, ImGuiWindowFlags_NoDocking, ImGuiWindowFlags_NoNav, ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_NoInputs, ImGuiWindowFlags_NavFlattened, ImGuiWindowFlags_ChildWindow, ImGuiWindowFlags_Tooltip, ImGuiWindowFlags_Popup, ImGuiWindowFlags_Modal, ImGuiWindowFlags_ChildMenu, ImGuiWindowFlags_DockNodeHost, }ImGuiWindowFlags_;
typedef enum { ImGuiChildFlags_None, ImGuiChildFlags_Border, ImGuiChildFlags_AlwaysUseWindowPadding, ImGuiChildFlags_ResizeX, ImGuiChildFlags_ResizeY, ImGuiChildFlags_AutoResizeX, ImGuiChildFlags_AutoResizeY, ImGuiChildFlags_AlwaysAutoResize, ImGuiChildFlags_FrameStyle, }ImGuiChildFlags_;
typedef enum { ImGuiInputTextFlags_None, ImGuiInputTextFlags_CharsDecimal, ImGuiInputTextFlags_CharsHexadecimal, ImGuiInputTextFlags_CharsUppercase, ImGuiInputTextFlags_CharsNoBlank, ImGuiInputTextFlags_AutoSelectAll, ImGuiInputTextFlags_EnterReturnsTrue, ImGuiInputTextFlags_CallbackCompletion, ImGuiInputTextFlags_CallbackHistory, ImGuiInputTextFlags_CallbackAlways, ImGuiInputTextFlags_CallbackCharFilter, ImGuiInputTextFlags_AllowTabInput, ImGuiInputTextFlags_CtrlEnterForNewLine, ImGuiInputTextFlags_NoHorizontalScroll, ImGuiInputTextFlags_AlwaysOverwrite, ImGuiInputTextFlags_ReadOnly, ImGuiInputTextFlags_Password, ImGuiInputTextFlags_NoUndoRedo, ImGuiInputTextFlags_CharsScientific, ImGuiInputTextFlags_CallbackResize, ImGuiInputTextFlags_CallbackEdit, ImGuiInputTextFlags_EscapeClearsAll, }ImGuiInputTextFlags_;
typedef enum { ImGuiTreeNodeFlags_None, ImGuiTreeNodeFlags_Selected, ImGuiTreeNodeFlags_Framed, ImGuiTreeNodeFlags_AllowOverlap, ImGuiTreeNodeFlags_NoTreePushOnOpen, ImGuiTreeNodeFlags_NoAutoOpenOnLog, ImGuiTreeNodeFlags_DefaultOpen, ImGuiTreeNodeFlags_OpenOnDoubleClick, ImGuiTreeNodeFlags_OpenOnArrow, ImGuiTreeNodeFlags_Leaf, ImGuiTreeNodeFlags_Bullet, ImGuiTreeNodeFlags_FramePadding, ImGuiTreeNodeFlags_SpanAvailWidth, ImGuiTreeNodeFlags_SpanFullWidth, ImGuiTreeNodeFlags_SpanAllColumns, ImGuiTreeNodeFlags_NavLeftJumpsBackHere, ImGuiTreeNodeFlags_CollapsingHeader, }ImGuiTreeNodeFlags_;
typedef enum { ImGuiPopupFlags_None, ImGuiPopupFlags_MouseButtonLeft, ImGuiPopupFlags_MouseButtonRight, ImGuiPopupFlags_MouseButtonMiddle, ImGuiPopupFlags_MouseButtonMask_, ImGuiPopupFlags_MouseButtonDefault_, ImGuiPopupFlags_NoReopen, ImGuiPopupFlags_NoOpenOverExistingPopup, ImGuiPopupFlags_NoOpenOverItems, ImGuiPopupFlags_AnyPopupId, ImGuiPopupFlags_AnyPopupLevel, ImGuiPopupFlags_AnyPopup, }ImGuiPopupFlags_;
typedef enum { ImGuiSelectableFlags_None, ImGuiSelectableFlags_DontClosePopups, ImGuiSelectableFlags_SpanAllColumns, ImGuiSelectableFlags_AllowDoubleClick, ImGuiSelectableFlags_Disabled, ImGuiSelectableFlags_AllowOverlap, }ImGuiSelectableFlags_;
typedef enum { ImGuiComboFlags_None, ImGuiComboFlags_PopupAlignLeft, ImGuiComboFlags_HeightSmall, ImGuiComboFlags_HeightRegular, ImGuiComboFlags_HeightLarge, ImGuiComboFlags_HeightLargest, ImGuiComboFlags_NoArrowButton, ImGuiComboFlags_NoPreview, ImGuiComboFlags_WidthFitPreview, ImGuiComboFlags_HeightMask_, }ImGuiComboFlags_;
typedef enum { ImGuiTabBarFlags_None, ImGuiTabBarFlags_Reorderable, ImGuiTabBarFlags_AutoSelectNewTabs, ImGuiTabBarFlags_TabListPopupButton, ImGuiTabBarFlags_NoCloseWithMiddleMouseButton, ImGuiTabBarFlags_NoTabListScrollingButtons, ImGuiTabBarFlags_NoTooltip, ImGuiTabBarFlags_FittingPolicyResizeDown, ImGuiTabBarFlags_FittingPolicyScroll, ImGuiTabBarFlags_FittingPolicyMask_, ImGuiTabBarFlags_FittingPolicyDefault_, }ImGuiTabBarFlags_;
typedef enum { ImGuiTabItemFlags_None, ImGuiTabItemFlags_UnsavedDocument, ImGuiTabItemFlags_SetSelected, ImGuiTabItemFlags_NoCloseWithMiddleMouseButton, ImGuiTabItemFlags_NoPushId, ImGuiTabItemFlags_NoTooltip, ImGuiTabItemFlags_NoReorder, ImGuiTabItemFlags_Leading, ImGuiTabItemFlags_Trailing, ImGuiTabItemFlags_NoAssumedClosure, }ImGuiTabItemFlags_;
typedef enum { ImGuiFocusedFlags_None, ImGuiFocusedFlags_ChildWindows, ImGuiFocusedFlags_RootWindow, ImGuiFocusedFlags_AnyWindow, ImGuiFocusedFlags_NoPopupHierarchy, ImGuiFocusedFlags_DockHierarchy, ImGuiFocusedFlags_RootAndChildWindows, }ImGuiFocusedFlags_;
typedef enum { ImGuiHoveredFlags_None, ImGuiHoveredFlags_ChildWindows, ImGuiHoveredFlags_RootWindow, ImGuiHoveredFlags_AnyWindow, ImGuiHoveredFlags_NoPopupHierarchy, ImGuiHoveredFlags_DockHierarchy, ImGuiHoveredFlags_AllowWhenBlockedByPopup, ImGuiHoveredFlags_AllowWhenBlockedByActiveItem, ImGuiHoveredFlags_AllowWhenOverlappedByItem, ImGuiHoveredFlags_AllowWhenOverlappedByWindow, ImGuiHoveredFlags_AllowWhenDisabled, ImGuiHoveredFlags_NoNavOverride, ImGuiHoveredFlags_AllowWhenOverlapped, ImGuiHoveredFlags_RectOnly, ImGuiHoveredFlags_RootAndChildWindows, ImGuiHoveredFlags_ForTooltip, ImGuiHoveredFlags_Stationary, ImGuiHoveredFlags_DelayNone, ImGuiHoveredFlags_DelayShort, ImGuiHoveredFlags_DelayNormal, ImGuiHoveredFlags_NoSharedDelay, }ImGuiHoveredFlags_;
typedef enum { ImGuiDockNodeFlags_None, ImGuiDockNodeFlags_KeepAliveOnly, ImGuiDockNodeFlags_NoDockingOverCentralNode, ImGuiDockNodeFlags_PassthruCentralNode, ImGuiDockNodeFlags_NoDockingSplit, ImGuiDockNodeFlags_NoResize, ImGuiDockNodeFlags_AutoHideTabBar, ImGuiDockNodeFlags_NoUndocking, }ImGuiDockNodeFlags_;
typedef enum { ImGuiDragDropFlags_None, ImGuiDragDropFlags_SourceNoPreviewTooltip, ImGuiDragDropFlags_SourceNoDisableHover, ImGuiDragDropFlags_SourceNoHoldToOpenOthers, ImGuiDragDropFlags_SourceAllowNullID, ImGuiDragDropFlags_SourceExtern, ImGuiDragDropFlags_SourceAutoExpirePayload, ImGuiDragDropFlags_AcceptBeforeDelivery, ImGuiDragDropFlags_AcceptNoDrawDefaultRect, ImGuiDragDropFlags_AcceptNoPreviewTooltip, ImGuiDragDropFlags_AcceptPeekOnly, }ImGuiDragDropFlags_;
typedef enum { ImGuiDataType_S8, ImGuiDataType_U8, ImGuiDataType_S16, ImGuiDataType_U16, ImGuiDataType_S32, ImGuiDataType_U32, ImGuiDataType_S64, ImGuiDataType_U64, ImGuiDataType_Float, ImGuiDataType_Double, ImGuiDataType_COUNT }ImGuiDataType_;
typedef enum { ImGuiDir_None, ImGuiDir_Left, ImGuiDir_Right, ImGuiDir_Up, ImGuiDir_Down, ImGuiDir_COUNT }ImGuiDir_;
typedef enum { ImGuiSortDirection_None, ImGuiSortDirection_Ascending, ImGuiSortDirection_Descending = 2 }ImGuiSortDirection_;
typedef enum { ImGuiKey_None, ImGuiKey_Tab, ImGuiKey_LeftArrow, ImGuiKey_RightArrow, ImGuiKey_UpArrow, ImGuiKey_DownArrow, ImGuiKey_PageUp, ImGuiKey_PageDown, ImGuiKey_Home, ImGuiKey_End, ImGuiKey_Insert, ImGuiKey_Delete, ImGuiKey_Backspace, ImGuiKey_Space, ImGuiKey_Enter, ImGuiKey_Escape, ImGuiKey_LeftCtrl, ImGuiKey_LeftShift, ImGuiKey_LeftAlt, ImGuiKey_LeftSuper, ImGuiKey_RightCtrl, ImGuiKey_RightShift, ImGuiKey_RightAlt, ImGuiKey_RightSuper, ImGuiKey_Menu, ImGuiKey_0, ImGuiKey_1, ImGuiKey_2, ImGuiKey_3, ImGuiKey_4, ImGuiKey_5, ImGuiKey_6, ImGuiKey_7, ImGuiKey_8, ImGuiKey_9, ImGuiKey_A, ImGuiKey_B, ImGuiKey_C, ImGuiKey_D, ImGuiKey_E, ImGuiKey_F, ImGuiKey_G, ImGuiKey_H, ImGuiKey_I, ImGuiKey_J, ImGuiKey_K, ImGuiKey_L, ImGuiKey_M, ImGuiKey_N, ImGuiKey_O, ImGuiKey_P, ImGuiKey_Q, ImGuiKey_R, ImGuiKey_S, ImGuiKey_T, ImGuiKey_U, ImGuiKey_V, ImGuiKey_W, ImGuiKey_X, ImGuiKey_Y, ImGuiKey_Z, ImGuiKey_F1, ImGuiKey_F2, ImGuiKey_F3, ImGuiKey_F4, ImGuiKey_F5, ImGuiKey_F6, ImGuiKey_F7, ImGuiKey_F8, ImGuiKey_F9, ImGuiKey_F10, ImGuiKey_F11, ImGuiKey_F12, ImGuiKey_F13, ImGuiKey_F14, ImGuiKey_F15, ImGuiKey_F16, ImGuiKey_F17, ImGuiKey_F18, ImGuiKey_F19, ImGuiKey_F20, ImGuiKey_F21, ImGuiKey_F22, ImGuiKey_F23, ImGuiKey_F24, ImGuiKey_Apostrophe, ImGuiKey_Comma, ImGuiKey_Minus, ImGuiKey_Period, ImGuiKey_Slash, ImGuiKey_Semicolon, ImGuiKey_Equal, ImGuiKey_LeftBracket, ImGuiKey_Backslash, ImGuiKey_RightBracket, ImGuiKey_GraveAccent, ImGuiKey_CapsLock, ImGuiKey_ScrollLock, ImGuiKey_NumLock, ImGuiKey_PrintScreen, ImGuiKey_Pause, ImGuiKey_Keypad0, ImGuiKey_Keypad1, ImGuiKey_Keypad2, ImGuiKey_Keypad3, ImGuiKey_Keypad4, ImGuiKey_Keypad5, ImGuiKey_Keypad6, ImGuiKey_Keypad7, ImGuiKey_Keypad8, ImGuiKey_Keypad9, ImGuiKey_KeypadDecimal, ImGuiKey_KeypadDivide, ImGuiKey_KeypadMultiply, ImGuiKey_KeypadSubtract, ImGuiKey_KeypadAdd, ImGuiKey_KeypadEnter, ImGuiKey_KeypadEqual, ImGuiKey_AppBack, ImGuiKey_AppForward, ImGuiKey_GamepadStart, ImGuiKey_GamepadBack, ImGuiKey_GamepadFaceLeft, ImGuiKey_GamepadFaceRight, ImGuiKey_GamepadFaceUp, ImGuiKey_GamepadFaceDown, ImGuiKey_GamepadDpadLeft, ImGuiKey_GamepadDpadRight, ImGuiKey_GamepadDpadUp, ImGuiKey_GamepadDpadDown, ImGuiKey_GamepadL1, ImGuiKey_GamepadR1, ImGuiKey_GamepadL2, ImGuiKey_GamepadR2, ImGuiKey_GamepadL3, ImGuiKey_GamepadR3, ImGuiKey_GamepadLStickLeft, ImGuiKey_GamepadLStickRight, ImGuiKey_GamepadLStickUp, ImGuiKey_GamepadLStickDown, ImGuiKey_GamepadRStickLeft, ImGuiKey_GamepadRStickRight, ImGuiKey_GamepadRStickUp, ImGuiKey_GamepadRStickDown, ImGuiKey_MouseLeft, ImGuiKey_MouseRight, ImGuiKey_MouseMiddle, ImGuiKey_MouseX1, ImGuiKey_MouseX2, ImGuiKey_MouseWheelX, ImGuiKey_MouseWheelY, ImGuiKey_ReservedForModCtrl, ImGuiKey_ReservedForModShift, ImGuiKey_ReservedForModAlt, ImGuiKey_ReservedForModSuper, ImGuiKey_COUNT, ImGuiMod_None, ImGuiMod_Ctrl, ImGuiMod_Shift, ImGuiMod_Alt, ImGuiMod_Super, ImGuiMod_Shortcut, ImGuiMod_Mask_, ImGuiKey_NamedKey_BEGIN, ImGuiKey_NamedKey_END, ImGuiKey_NamedKey_COUNT, ImGuiKey_KeysData_SIZE, ImGuiKey_KeysData_OFFSET, }ImGuiKey;
typedef enum { ImGuiConfigFlags_None, ImGuiConfigFlags_NavEnableKeyboard, ImGuiConfigFlags_NavEnableGamepad, ImGuiConfigFlags_NavEnableSetMousePos, ImGuiConfigFlags_NavNoCaptureKeyboard, ImGuiConfigFlags_NoMouse, ImGuiConfigFlags_NoMouseCursorChange, ImGuiConfigFlags_DockingEnable, ImGuiConfigFlags_ViewportsEnable, ImGuiConfigFlags_DpiEnableScaleViewports, ImGuiConfigFlags_DpiEnableScaleFonts, ImGuiConfigFlags_IsSRGB, ImGuiConfigFlags_IsTouchScreen, }ImGuiConfigFlags_;
typedef enum { ImGuiBackendFlags_None, ImGuiBackendFlags_HasGamepad, ImGuiBackendFlags_HasMouseCursors, ImGuiBackendFlags_HasSetMousePos, ImGuiBackendFlags_RendererHasVtxOffset, ImGuiBackendFlags_PlatformHasViewports, ImGuiBackendFlags_HasMouseHoveredViewport, ImGuiBackendFlags_RendererHasViewports, }ImGuiBackendFlags_;
typedef enum { ImGuiCol_Text, ImGuiCol_TextDisabled, ImGuiCol_WindowBg, ImGuiCol_ChildBg, ImGuiCol_PopupBg, ImGuiCol_Border, ImGuiCol_BorderShadow, ImGuiCol_FrameBg, ImGuiCol_FrameBgHovered, ImGuiCol_FrameBgActive, ImGuiCol_TitleBg, ImGuiCol_TitleBgActive, ImGuiCol_TitleBgCollapsed, ImGuiCol_MenuBarBg, ImGuiCol_ScrollbarBg, ImGuiCol_ScrollbarGrab, ImGuiCol_ScrollbarGrabHovered, ImGuiCol_ScrollbarGrabActive, ImGuiCol_CheckMark, ImGuiCol_SliderGrab, ImGuiCol_SliderGrabActive, ImGuiCol_Button, ImGuiCol_ButtonHovered, ImGuiCol_ButtonActive, ImGuiCol_Header, ImGuiCol_HeaderHovered, ImGuiCol_HeaderActive, ImGuiCol_Separator, ImGuiCol_SeparatorHovered, ImGuiCol_SeparatorActive, ImGuiCol_ResizeGrip, ImGuiCol_ResizeGripHovered, ImGuiCol_ResizeGripActive, ImGuiCol_Tab, ImGuiCol_TabHovered, ImGuiCol_TabActive, ImGuiCol_TabUnfocused, ImGuiCol_TabUnfocusedActive, ImGuiCol_DockingPreview, ImGuiCol_DockingEmptyBg, ImGuiCol_PlotLines, ImGuiCol_PlotLinesHovered, ImGuiCol_PlotHistogram, ImGuiCol_PlotHistogramHovered, ImGuiCol_TableHeaderBg, ImGuiCol_TableBorderStrong, ImGuiCol_TableBorderLight, ImGuiCol_TableRowBg, ImGuiCol_TableRowBgAlt, ImGuiCol_TextSelectedBg, ImGuiCol_DragDropTarget, ImGuiCol_NavHighlight, ImGuiCol_NavWindowingHighlight, ImGuiCol_NavWindowingDimBg, ImGuiCol_ModalWindowDimBg, ImGuiCol_COUNT }ImGuiCol_;
typedef enum { ImGuiStyleVar_Alpha, ImGuiStyleVar_DisabledAlpha, ImGuiStyleVar_WindowPadding, ImGuiStyleVar_WindowRounding, ImGuiStyleVar_WindowBorderSize, ImGuiStyleVar_WindowMinSize, ImGuiStyleVar_WindowTitleAlign, ImGuiStyleVar_ChildRounding, ImGuiStyleVar_ChildBorderSize, ImGuiStyleVar_PopupRounding, ImGuiStyleVar_PopupBorderSize, ImGuiStyleVar_FramePadding, ImGuiStyleVar_FrameRounding, ImGuiStyleVar_FrameBorderSize, ImGuiStyleVar_ItemSpacing, ImGuiStyleVar_ItemInnerSpacing, ImGuiStyleVar_IndentSpacing, ImGuiStyleVar_CellPadding, ImGuiStyleVar_ScrollbarSize, ImGuiStyleVar_ScrollbarRounding, ImGuiStyleVar_GrabMinSize, ImGuiStyleVar_GrabRounding, ImGuiStyleVar_TabRounding, ImGuiStyleVar_TabBorderSize, ImGuiStyleVar_TabBarBorderSize, ImGuiStyleVar_TableAngledHeadersAngle, ImGuiStyleVar_ButtonTextAlign, ImGuiStyleVar_SelectableTextAlign, ImGuiStyleVar_SeparatorTextBorderSize, ImGuiStyleVar_SeparatorTextAlign, ImGuiStyleVar_SeparatorTextPadding, ImGuiStyleVar_DockingSeparatorSize, ImGuiStyleVar_COUNT }ImGuiStyleVar_;
typedef enum { ImGuiButtonFlags_None, ImGuiButtonFlags_MouseButtonLeft, ImGuiButtonFlags_MouseButtonRight, ImGuiButtonFlags_MouseButtonMiddle, ImGuiButtonFlags_MouseButtonMask_, ImGuiButtonFlags_MouseButtonDefault_, }ImGuiButtonFlags_;
typedef enum { ImGuiColorEditFlags_None, ImGuiColorEditFlags_NoAlpha, ImGuiColorEditFlags_NoPicker, ImGuiColorEditFlags_NoOptions, ImGuiColorEditFlags_NoSmallPreview, ImGuiColorEditFlags_NoInputs, ImGuiColorEditFlags_NoTooltip, ImGuiColorEditFlags_NoLabel, ImGuiColorEditFlags_NoSidePreview, ImGuiColorEditFlags_NoDragDrop, ImGuiColorEditFlags_NoBorder, ImGuiColorEditFlags_AlphaBar, ImGuiColorEditFlags_AlphaPreview, ImGuiColorEditFlags_AlphaPreviewHalf, ImGuiColorEditFlags_HDR, ImGuiColorEditFlags_DisplayRGB, ImGuiColorEditFlags_DisplayHSV, ImGuiColorEditFlags_DisplayHex, ImGuiColorEditFlags_Uint8, ImGuiColorEditFlags_Float, ImGuiColorEditFlags_PickerHueBar, ImGuiColorEditFlags_PickerHueWheel, ImGuiColorEditFlags_InputRGB, ImGuiColorEditFlags_InputHSV, ImGuiColorEditFlags_DefaultOptions_, ImGuiColorEditFlags_DisplayMask_, ImGuiColorEditFlags_DataTypeMask_, ImGuiColorEditFlags_PickerMask_, ImGuiColorEditFlags_InputMask_, }ImGuiColorEditFlags_;
typedef enum { ImGuiSliderFlags_None, ImGuiSliderFlags_AlwaysClamp, ImGuiSliderFlags_Logarithmic, ImGuiSliderFlags_NoRoundToFormat, ImGuiSliderFlags_NoInput, ImGuiSliderFlags_InvalidMask_, }ImGuiSliderFlags_;
typedef enum { ImGuiMouseButton_Left, ImGuiMouseButton_Right, ImGuiMouseButton_Middle, ImGuiMouseButton_COUNT = 5 }ImGuiMouseButton_;
typedef enum { ImGuiMouseCursor_None, ImGuiMouseCursor_Arrow, ImGuiMouseCursor_TextInput, ImGuiMouseCursor_ResizeAll, ImGuiMouseCursor_ResizeNS, ImGuiMouseCursor_ResizeEW, ImGuiMouseCursor_ResizeNESW, ImGuiMouseCursor_ResizeNWSE, ImGuiMouseCursor_Hand, ImGuiMouseCursor_NotAllowed, ImGuiMouseCursor_COUNT }ImGuiMouseCursor_;
typedef enum { ImGuiMouseSource_Mouse, ImGuiMouseSource_TouchScreen, ImGuiMouseSource_Pen, ImGuiMouseSource_COUNT, }ImGuiMouseSource;
typedef enum { ImGuiCond_None, ImGuiCond_Always, ImGuiCond_Once, ImGuiCond_FirstUseEver, ImGuiCond_Appearing, }ImGuiCond_;
typedef enum { ImGuiTableFlags_None, ImGuiTableFlags_Resizable, ImGuiTableFlags_Reorderable, ImGuiTableFlags_Hideable, ImGuiTableFlags_Sortable, ImGuiTableFlags_NoSavedSettings, ImGuiTableFlags_ContextMenuInBody, ImGuiTableFlags_RowBg, ImGuiTableFlags_BordersInnerH, ImGuiTableFlags_BordersOuterH, ImGuiTableFlags_BordersInnerV, ImGuiTableFlags_BordersOuterV, ImGuiTableFlags_BordersH, ImGuiTableFlags_BordersV, ImGuiTableFlags_BordersInner, ImGuiTableFlags_BordersOuter, ImGuiTableFlags_Borders, ImGuiTableFlags_NoBordersInBody, ImGuiTableFlags_NoBordersInBodyUntilResize, ImGuiTableFlags_SizingFixedFit, ImGuiTableFlags_SizingFixedSame, ImGuiTableFlags_SizingStretchProp, ImGuiTableFlags_SizingStretchSame, ImGuiTableFlags_NoHostExtendX, ImGuiTableFlags_NoHostExtendY, ImGuiTableFlags_NoKeepColumnsVisible, ImGuiTableFlags_PreciseWidths, ImGuiTableFlags_NoClip, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_NoPadOuterX, ImGuiTableFlags_NoPadInnerX, ImGuiTableFlags_ScrollX, ImGuiTableFlags_ScrollY, ImGuiTableFlags_SortMulti, ImGuiTableFlags_SortTristate, ImGuiTableFlags_HighlightHoveredColumn, ImGuiTableFlags_SizingMask_, }ImGuiTableFlags_;
typedef enum { ImGuiTableColumnFlags_None, ImGuiTableColumnFlags_Disabled, ImGuiTableColumnFlags_DefaultHide, ImGuiTableColumnFlags_DefaultSort, ImGuiTableColumnFlags_WidthStretch, ImGuiTableColumnFlags_WidthFixed, ImGuiTableColumnFlags_NoResize, ImGuiTableColumnFlags_NoReorder, ImGuiTableColumnFlags_NoHide, ImGuiTableColumnFlags_NoClip, ImGuiTableColumnFlags_NoSort, ImGuiTableColumnFlags_NoSortAscending, ImGuiTableColumnFlags_NoSortDescending, ImGuiTableColumnFlags_NoHeaderLabel, ImGuiTableColumnFlags_NoHeaderWidth, ImGuiTableColumnFlags_PreferSortAscending, ImGuiTableColumnFlags_PreferSortDescending, ImGuiTableColumnFlags_IndentEnable, ImGuiTableColumnFlags_IndentDisable, ImGuiTableColumnFlags_AngledHeader, ImGuiTableColumnFlags_IsEnabled, ImGuiTableColumnFlags_IsVisible, ImGuiTableColumnFlags_IsSorted, ImGuiTableColumnFlags_IsHovered, ImGuiTableColumnFlags_WidthMask_, ImGuiTableColumnFlags_IndentMask_, ImGuiTableColumnFlags_StatusMask_, ImGuiTableColumnFlags_NoDirectResize_, }ImGuiTableColumnFlags_;
typedef enum { ImGuiTableRowFlags_None, ImGuiTableRowFlags_Headers, }ImGuiTableRowFlags_;
typedef enum { ImGuiTableBgTarget_None, ImGuiTableBgTarget_RowBg0, ImGuiTableBgTarget_RowBg1, ImGuiTableBgTarget_CellBg, }ImGuiTableBgTarget_;

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

-- these NewFrame functions are called in this order
function ig.ImGui_ImplOpenGL3_NewFrame() end
function ig.ImGui_ImplSDL2_NewFrame() end
function ig.igNewFrame() 
	js.imguiNewFrame()
end

-- end of frame in order
function ig.igRender()
	js.imguiRender()
end
function ig.igGetDrawData() end
function ig.ImGui_ImplOpenGL3_RenderDrawData() end

function ig.igText(...)
	return js.imguiText(...)
end

function ig.igSliderFloat(label, v, ...)
	-- 'v' is cdata, it is where things get written upon succes ...
	local p = ffi.dataToArray('Float32Array', v, 1)
	return js.imguiInputFloat(label, p, ...)
end

function ig.igInputFloat(label, v, ...)
	-- 'v' is cdata, it is where things get written upon succes ...
	local p = ffi.dataToArray('Float32Array', v, 1)
	return js.imguiInputFloat(label, p, ...)
end

function ig.igInputInt(label, v, ...)
	-- 'v' is cdata, it is where things get written upon succes ...
	local p = ffi.dataToArray('Int32Array', v, 1)
	return js.imguiInputInt(label, p, ...)
end

function ig.igInputText() end

function ig.igButton(...)
	return js.imguiButton(...)
end

ig.igColorButton = ig.igButton

function ig.igGetMainViewport()
	local canvas = js.global.canvas	-- assigned in createCanvas right now
	return {
		WorkPos = ffi.new('ImVec2', 0, 0),
		WorkSize = ffi.new('ImVec2', canvas.width, canvas.height),
	}
end
function ig.igColorPicker3() end

function ig.igNewLine() end
function ig.igSameLine() end
function ig.igSeparator() end
function ig.igSeparatorText() end
function ig.igSetNextWindowPos() end
function ig.igSetNextWindowSize() end
function ig.igSetWindowFontScale() end
function ig.igSetNextWindowBgAlpha() end

function ig.igCheckbox() end
function ig.igRadioButton_IntPtr() end
function ig.igIsItemHovered() end
function ig.igSetMouseCursor() end
function ig.igSetCursorPosY() end
function ig.igSetCursorPosX() end

function ig.igStyleColorsDark() end
function ig.igPushStyleVar_Float() end
function ig.igPopStyleVar() end

function ig.igCalcTextSize() end

function ig.igBegin() end
function ig.igEnd() end
function ig.igBeginPopupEx() end
function ig.igEndPopup() end
function ig.igCloseCurrentPopup() end
function ig.igOpenPopup_ID() end
function ig.igOpenPopup_Str() end

function ig.igBeginPopupModal() end

function ig.igBeginTooltip() end
function ig.igEndTooltip() end

function ig.igBeginTable() end
function ig.igEndTable() end
function ig.igTableSetupColumn() end
function ig.igTableHeadersRow() end
function ig.igTableGetSortSpecs() end
function ig.igTableNextRow() end
function ig.igTableNextColumn() end

function ig.igPushID_Int(i) end
function ig.igPushID_Str(s) end
function ig.igPopID() end

function ig.igPushFont() end
function ig.igPopFont() end
function ig.ImFontAtlas_ImFontAtlas() end
function ig.ImFontAtlas_AddFontFromFileTTF() end
function ig.ImFontAtlas_Build() return true end

function ig.igCreateContext() end
function ig.igDestroyContext() end
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
