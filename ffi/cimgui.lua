local ffi = require 'ffi'
require 'ffi.c.string'	-- strlen

ffi.cdef[[
enum{
	ImGuiWindowFlags_None = 0,
	ImGuiWindowFlags_NoTitleBar = 1,
	ImGuiWindowFlags_NoResize = 2,
	ImGuiWindowFlags_NoMove = 4,
	ImGuiWindowFlags_NoScrollbar = 8,
	ImGuiWindowFlags_NoScrollWithMouse = 16,
	ImGuiWindowFlags_NoCollapse = 32,
	ImGuiWindowFlags_AlwaysAutoResize = 64,
	ImGuiWindowFlags_NoBackground = 128,
	ImGuiWindowFlags_NoSavedSettings = 256,
	ImGuiWindowFlags_NoMouseInputs = 512,
	ImGuiWindowFlags_MenuBar = 1024,
	ImGuiWindowFlags_HorizontalScrollbar = 2048,
	ImGuiWindowFlags_NoFocusOnAppearing = 4096,
	ImGuiWindowFlags_NoBringToFrontOnFocus = 8192,
	ImGuiWindowFlags_AlwaysVerticalScrollbar = 16384,
	ImGuiWindowFlags_AlwaysHorizontalScrollbar = 32768,
	ImGuiWindowFlags_NoNavInputs = 65536,
	ImGuiWindowFlags_NoNavFocus = 131072,
	ImGuiWindowFlags_UnsavedDocument = 262144,
	ImGuiWindowFlags_NoDocking = 524288,
	ImGuiWindowFlags_NoNav = 196608,
	ImGuiWindowFlags_NoDecoration = 43,
	ImGuiWindowFlags_NoInputs = 197120,
	ImGuiWindowFlags_NavFlattened = 8388608,
	ImGuiWindowFlags_ChildWindow = 16777216,
	ImGuiWindowFlags_Tooltip = 33554432,
	ImGuiWindowFlags_Popup = 67108864,
	ImGuiWindowFlags_Modal = 134217728,
	ImGuiWindowFlags_ChildMenu = 268435456,
	ImGuiWindowFlags_DockNodeHost = 536870912,
	ImGuiChildFlags_None = 0,
	ImGuiChildFlags_Border = 1,
	ImGuiChildFlags_AlwaysUseWindowPadding = 2,
	ImGuiChildFlags_ResizeX = 4,
	ImGuiChildFlags_ResizeY = 8,
	ImGuiChildFlags_AutoResizeX = 16,
	ImGuiChildFlags_AutoResizeY = 32,
	ImGuiChildFlags_AlwaysAutoResize = 64,
	ImGuiChildFlags_FrameStyle = 128,
	ImGuiInputTextFlags_None = 0,
	ImGuiInputTextFlags_CharsDecimal = 1,
	ImGuiInputTextFlags_CharsHexadecimal = 2,
	ImGuiInputTextFlags_CharsUppercase = 4,
	ImGuiInputTextFlags_CharsNoBlank = 8,
	ImGuiInputTextFlags_AutoSelectAll = 16,
	ImGuiInputTextFlags_EnterReturnsTrue = 32,
	ImGuiInputTextFlags_CallbackCompletion = 64,
	ImGuiInputTextFlags_CallbackHistory = 128,
	ImGuiInputTextFlags_CallbackAlways = 256,
	ImGuiInputTextFlags_CallbackCharFilter = 512,
	ImGuiInputTextFlags_AllowTabInput = 1024,
	ImGuiInputTextFlags_CtrlEnterForNewLine = 2048,
	ImGuiInputTextFlags_NoHorizontalScroll = 4096,
	ImGuiInputTextFlags_AlwaysOverwrite = 8192,
	ImGuiInputTextFlags_ReadOnly = 16384,
	ImGuiInputTextFlags_Password = 32768,
	ImGuiInputTextFlags_NoUndoRedo = 65536,
	ImGuiInputTextFlags_CharsScientific = 131072,
	ImGuiInputTextFlags_CallbackResize = 262144,
	ImGuiInputTextFlags_CallbackEdit = 524288,
	ImGuiInputTextFlags_EscapeClearsAll = 1048576,
	ImGuiTreeNodeFlags_None = 0,
	ImGuiTreeNodeFlags_Selected = 1,
	ImGuiTreeNodeFlags_Framed = 2,
	ImGuiTreeNodeFlags_AllowOverlap = 4,
	ImGuiTreeNodeFlags_NoTreePushOnOpen = 8,
	ImGuiTreeNodeFlags_NoAutoOpenOnLog = 16,
	ImGuiTreeNodeFlags_DefaultOpen = 32,
	ImGuiTreeNodeFlags_OpenOnDoubleClick = 64,
	ImGuiTreeNodeFlags_OpenOnArrow = 128,
	ImGuiTreeNodeFlags_Leaf = 256,
	ImGuiTreeNodeFlags_Bullet = 512,
	ImGuiTreeNodeFlags_FramePadding = 1024,
	ImGuiTreeNodeFlags_SpanAvailWidth = 2048,
	ImGuiTreeNodeFlags_SpanFullWidth = 4096,
	ImGuiTreeNodeFlags_SpanAllColumns = 8192,
	ImGuiTreeNodeFlags_NavLeftJumpsBackHere = 16384,
	ImGuiTreeNodeFlags_CollapsingHeader = 26,
	ImGuiPopupFlags_None = 0,
	ImGuiPopupFlags_MouseButtonLeft = 0,
	ImGuiPopupFlags_MouseButtonRight = 1,
	ImGuiPopupFlags_MouseButtonMiddle = 2,
	ImGuiPopupFlags_MouseButtonMask_ = 31,
	ImGuiPopupFlags_MouseButtonDefault_ = 1,
	ImGuiPopupFlags_NoReopen = 32,
	ImGuiPopupFlags_NoOpenOverExistingPopup = 128,
	ImGuiPopupFlags_NoOpenOverItems = 256,
	ImGuiPopupFlags_AnyPopupId = 1024,
	ImGuiPopupFlags_AnyPopupLevel = 2048,
	ImGuiPopupFlags_AnyPopup = 3072,
	ImGuiSelectableFlags_None = 0,
	ImGuiSelectableFlags_DontClosePopups = 1,
	ImGuiSelectableFlags_SpanAllColumns = 2,
	ImGuiSelectableFlags_AllowDoubleClick = 4,
	ImGuiSelectableFlags_Disabled = 8,
	ImGuiSelectableFlags_AllowOverlap = 16,
	ImGuiComboFlags_None = 0,
	ImGuiComboFlags_PopupAlignLeft = 1,
	ImGuiComboFlags_HeightSmall = 2,
	ImGuiComboFlags_HeightRegular = 4,
	ImGuiComboFlags_HeightLarge = 8,
	ImGuiComboFlags_HeightLargest = 16,
	ImGuiComboFlags_NoArrowButton = 32,
	ImGuiComboFlags_NoPreview = 64,
	ImGuiComboFlags_WidthFitPreview = 128,
	ImGuiComboFlags_HeightMask_ = 30,
	ImGuiTabBarFlags_None = 0,
	ImGuiTabBarFlags_Reorderable = 1,
	ImGuiTabBarFlags_AutoSelectNewTabs = 2,
	ImGuiTabBarFlags_TabListPopupButton = 4,
	ImGuiTabBarFlags_NoCloseWithMiddleMouseButton = 8,
	ImGuiTabBarFlags_NoTabListScrollingButtons = 16,
	ImGuiTabBarFlags_NoTooltip = 32,
	ImGuiTabBarFlags_FittingPolicyResizeDown = 64,
	ImGuiTabBarFlags_FittingPolicyScroll = 128,
	ImGuiTabBarFlags_FittingPolicyMask_ = 192,
	ImGuiTabBarFlags_FittingPolicyDefault_ = 64,
	ImGuiTabItemFlags_None = 0,
	ImGuiTabItemFlags_UnsavedDocument = 1,
	ImGuiTabItemFlags_SetSelected = 2,
	ImGuiTabItemFlags_NoCloseWithMiddleMouseButton = 4,
	ImGuiTabItemFlags_NoPushId = 8,
	ImGuiTabItemFlags_NoTooltip = 16,
	ImGuiTabItemFlags_NoReorder = 32,
	ImGuiTabItemFlags_Leading = 64,
	ImGuiTabItemFlags_Trailing = 128,
	ImGuiTabItemFlags_NoAssumedClosure = 256,
	ImGuiFocusedFlags_None = 0,
	ImGuiFocusedFlags_ChildWindows = 1,
	ImGuiFocusedFlags_RootWindow = 2,
	ImGuiFocusedFlags_AnyWindow = 4,
	ImGuiFocusedFlags_NoPopupHierarchy = 8,
	ImGuiFocusedFlags_DockHierarchy = 16,
	ImGuiFocusedFlags_RootAndChildWindows = 3,
	ImGuiHoveredFlags_None = 0,
	ImGuiHoveredFlags_ChildWindows = 1,
	ImGuiHoveredFlags_RootWindow = 2,
	ImGuiHoveredFlags_AnyWindow = 4,
	ImGuiHoveredFlags_NoPopupHierarchy = 8,
	ImGuiHoveredFlags_DockHierarchy = 16,
	ImGuiHoveredFlags_AllowWhenBlockedByPopup = 32,
	ImGuiHoveredFlags_AllowWhenBlockedByActiveItem = 128,
	ImGuiHoveredFlags_AllowWhenOverlappedByItem = 256,
	ImGuiHoveredFlags_AllowWhenOverlappedByWindow = 512,
	ImGuiHoveredFlags_AllowWhenDisabled = 1024,
	ImGuiHoveredFlags_NoNavOverride = 2048,
	ImGuiHoveredFlags_AllowWhenOverlapped = 768,
	ImGuiHoveredFlags_RectOnly = 928,
	ImGuiHoveredFlags_RootAndChildWindows = 3,
	ImGuiHoveredFlags_ForTooltip = 4096,
	ImGuiHoveredFlags_Stationary = 8192,
	ImGuiHoveredFlags_DelayNone = 16384,
	ImGuiHoveredFlags_DelayShort = 32768,
	ImGuiHoveredFlags_DelayNormal = 65536,
	ImGuiHoveredFlags_NoSharedDelay = 131072,
	ImGuiDockNodeFlags_None = 0,
	ImGuiDockNodeFlags_KeepAliveOnly = 1,
	ImGuiDockNodeFlags_NoDockingOverCentralNode = 4,
	ImGuiDockNodeFlags_PassthruCentralNode = 8,
	ImGuiDockNodeFlags_NoDockingSplit = 16,
	ImGuiDockNodeFlags_NoResize = 32,
	ImGuiDockNodeFlags_AutoHideTabBar = 64,
	ImGuiDockNodeFlags_NoUndocking = 128,
	ImGuiDragDropFlags_None = 0,
	ImGuiDragDropFlags_SourceNoPreviewTooltip = 1,
	ImGuiDragDropFlags_SourceNoDisableHover = 2,
	ImGuiDragDropFlags_SourceNoHoldToOpenOthers = 4,
	ImGuiDragDropFlags_SourceAllowNullID = 8,
	ImGuiDragDropFlags_SourceExtern = 16,
	ImGuiDragDropFlags_SourceAutoExpirePayload = 32,
	ImGuiDragDropFlags_AcceptBeforeDelivery = 1024,
	ImGuiDragDropFlags_AcceptNoDrawDefaultRect = 2048,
	ImGuiDragDropFlags_AcceptNoPreviewTooltip = 4096,
	ImGuiDragDropFlags_AcceptPeekOnly = 3072,
};
enum {
	ImGuiDataType_S8,
	ImGuiDataType_U8,
	ImGuiDataType_S16,
	ImGuiDataType_U16,
	ImGuiDataType_S32,
	ImGuiDataType_U32,
	ImGuiDataType_S64,
	ImGuiDataType_U64,
	ImGuiDataType_Float,
	ImGuiDataType_Double,
	ImGuiDataType_COUNT,
	ImGuiDataType_String,
	ImGuiDataType_Pointer,
	ImGuiDataType_ID,
};
enum {
	ImGuiDir_None = -1,
	ImGuiDir_Left = 0,
	ImGuiDir_Right = 1,
	ImGuiDir_Up = 2,
	ImGuiDir_Down = 3,
	ImGuiDir_COUNT,
	ImGuiSortDirection_None = 0,
	ImGuiSortDirection_Ascending = 1,
	ImGuiSortDirection_Descending = 2,
	ImGuiKey_None = 0,
	ImGuiKey_Tab = 512,
	ImGuiKey_LeftArrow = 513,
	ImGuiKey_RightArrow = 514,
	ImGuiKey_UpArrow = 515,
	ImGuiKey_DownArrow = 516,
	ImGuiKey_PageUp = 517,
	ImGuiKey_PageDown = 518,
	ImGuiKey_Home = 519,
	ImGuiKey_End = 520,
	ImGuiKey_Insert = 521,
	ImGuiKey_Delete = 522,
	ImGuiKey_Backspace = 523,
	ImGuiKey_Space = 524,
	ImGuiKey_Enter = 525,
	ImGuiKey_Escape = 526,
	ImGuiKey_LeftCtrl = 527,
	ImGuiKey_LeftShift = 528,
	ImGuiKey_LeftAlt = 529,
	ImGuiKey_LeftSuper = 530,
	ImGuiKey_RightCtrl = 531,
	ImGuiKey_RightShift = 532,
	ImGuiKey_RightAlt = 533,
	ImGuiKey_RightSuper = 534,
	ImGuiKey_Menu = 535,
	ImGuiKey_0 = 536,
	ImGuiKey_1 = 537,
	ImGuiKey_2 = 538,
	ImGuiKey_3 = 539,
	ImGuiKey_4 = 540,
	ImGuiKey_5 = 541,
	ImGuiKey_6 = 542,
	ImGuiKey_7 = 543,
	ImGuiKey_8 = 544,
	ImGuiKey_9 = 545,
	ImGuiKey_A = 546,
	ImGuiKey_B = 547,
	ImGuiKey_C = 548,
	ImGuiKey_D = 549,
	ImGuiKey_E = 550,
	ImGuiKey_F = 551,
	ImGuiKey_G = 552,
	ImGuiKey_H = 553,
	ImGuiKey_I = 554,
	ImGuiKey_J = 555,
	ImGuiKey_K = 556,
	ImGuiKey_L = 557,
	ImGuiKey_M = 558,
	ImGuiKey_N = 559,
	ImGuiKey_O = 560,
	ImGuiKey_P = 561,
	ImGuiKey_Q = 562,
	ImGuiKey_R = 563,
	ImGuiKey_S = 564,
	ImGuiKey_T = 565,
	ImGuiKey_U = 566,
	ImGuiKey_V = 567,
	ImGuiKey_W = 568,
	ImGuiKey_X = 569,
	ImGuiKey_Y = 570,
	ImGuiKey_Z = 571,
	ImGuiKey_F1 = 572,
	ImGuiKey_F2 = 573,
	ImGuiKey_F3 = 574,
	ImGuiKey_F4 = 575,
	ImGuiKey_F5 = 576,
	ImGuiKey_F6 = 577,
	ImGuiKey_F7 = 578,
	ImGuiKey_F8 = 579,
	ImGuiKey_F9 = 580,
	ImGuiKey_F10 = 581,
	ImGuiKey_F11 = 582,
	ImGuiKey_F12 = 583,
	ImGuiKey_F13 = 584,
	ImGuiKey_F14 = 585,
	ImGuiKey_F15 = 586,
	ImGuiKey_F16 = 587,
	ImGuiKey_F17 = 588,
	ImGuiKey_F18 = 589,
	ImGuiKey_F19 = 590,
	ImGuiKey_F20 = 591,
	ImGuiKey_F21 = 592,
	ImGuiKey_F22 = 593,
	ImGuiKey_F23 = 594,
	ImGuiKey_F24 = 595,
	ImGuiKey_Apostrophe = 596,
	ImGuiKey_Comma = 597,
	ImGuiKey_Minus = 598,
	ImGuiKey_Period = 599,
	ImGuiKey_Slash = 600,
	ImGuiKey_Semicolon = 601,
	ImGuiKey_Equal = 602,
	ImGuiKey_LeftBracket = 603,
	ImGuiKey_Backslash = 604,
	ImGuiKey_RightBracket = 605,
	ImGuiKey_GraveAccent = 606,
	ImGuiKey_CapsLock = 607,
	ImGuiKey_ScrollLock = 608,
	ImGuiKey_NumLock = 609,
	ImGuiKey_PrintScreen = 610,
	ImGuiKey_Pause = 611,
	ImGuiKey_Keypad0 = 612,
	ImGuiKey_Keypad1 = 613,
	ImGuiKey_Keypad2 = 614,
	ImGuiKey_Keypad3 = 615,
	ImGuiKey_Keypad4 = 616,
	ImGuiKey_Keypad5 = 617,
	ImGuiKey_Keypad6 = 618,
	ImGuiKey_Keypad7 = 619,
	ImGuiKey_Keypad8 = 620,
	ImGuiKey_Keypad9 = 621,
	ImGuiKey_KeypadDecimal = 622,
	ImGuiKey_KeypadDivide = 623,
	ImGuiKey_KeypadMultiply = 624,
	ImGuiKey_KeypadSubtract = 625,
	ImGuiKey_KeypadAdd = 626,
	ImGuiKey_KeypadEnter = 627,
	ImGuiKey_KeypadEqual = 628,
	ImGuiKey_AppBack = 629,
	ImGuiKey_AppForward = 630,
	ImGuiKey_GamepadStart = 631,
	ImGuiKey_GamepadBack = 632,
	ImGuiKey_GamepadFaceLeft = 633,
	ImGuiKey_GamepadFaceRight = 634,
	ImGuiKey_GamepadFaceUp = 635,
	ImGuiKey_GamepadFaceDown = 636,
	ImGuiKey_GamepadDpadLeft = 637,
	ImGuiKey_GamepadDpadRight = 638,
	ImGuiKey_GamepadDpadUp = 639,
	ImGuiKey_GamepadDpadDown = 640,
	ImGuiKey_GamepadL1 = 641,
	ImGuiKey_GamepadR1 = 642,
	ImGuiKey_GamepadL2 = 643,
	ImGuiKey_GamepadR2 = 644,
	ImGuiKey_GamepadL3 = 645,
	ImGuiKey_GamepadR3 = 646,
	ImGuiKey_GamepadLStickLeft = 647,
	ImGuiKey_GamepadLStickRight = 648,
	ImGuiKey_GamepadLStickUp = 649,
	ImGuiKey_GamepadLStickDown = 650,
	ImGuiKey_GamepadRStickLeft = 651,
	ImGuiKey_GamepadRStickRight = 652,
	ImGuiKey_GamepadRStickUp = 653,
	ImGuiKey_GamepadRStickDown = 654,
	ImGuiKey_MouseLeft = 655,
	ImGuiKey_MouseRight = 656,
	ImGuiKey_MouseMiddle = 657,
	ImGuiKey_MouseX1 = 658,
	ImGuiKey_MouseX2 = 659,
	ImGuiKey_MouseWheelX = 660,
	ImGuiKey_MouseWheelY = 661,
	ImGuiKey_ReservedForModCtrl = 662,
	ImGuiKey_ReservedForModShift = 663,
	ImGuiKey_ReservedForModAlt = 664,
	ImGuiKey_ReservedForModSuper = 665,
	ImGuiKey_COUNT = 666,
	ImGuiMod_None = 0,
	ImGuiMod_Ctrl = 4096,
	ImGuiMod_Shift = 8192,
	ImGuiMod_Alt = 16384,
	ImGuiMod_Super = 32768,
	ImGuiMod_Shortcut = 2048,
	ImGuiMod_Mask_ = 0xF800,
	ImGuiKey_NamedKey_BEGIN = 512,
	ImGuiKey_NamedKey_END = 666,
	ImGuiKey_NamedKey_COUNT = 154,
	ImGuiKey_KeysData_SIZE = 154,
	ImGuiKey_KeysData_OFFSET = 512,
	ImGuiConfigFlags_None = 0,
	ImGuiConfigFlags_NavEnableKeyboard = 1,
	ImGuiConfigFlags_NavEnableGamepad = 2,
	ImGuiConfigFlags_NavEnableSetMousePos = 4,
	ImGuiConfigFlags_NavNoCaptureKeyboard = 8,
	ImGuiConfigFlags_NoMouse = 16,
	ImGuiConfigFlags_NoMouseCursorChange = 32,
	ImGuiConfigFlags_DockingEnable = 64,
	ImGuiConfigFlags_ViewportsEnable = 1024,
	ImGuiConfigFlags_DpiEnableScaleViewports = 16384,
	ImGuiConfigFlags_DpiEnableScaleFonts = 32768,
	ImGuiConfigFlags_IsSRGB = 1048576,
	ImGuiConfigFlags_IsTouchScreen = 2097152,
	ImGuiBackendFlags_None = 0,
	ImGuiBackendFlags_HasGamepad = 1,
	ImGuiBackendFlags_HasMouseCursors = 2,
	ImGuiBackendFlags_HasSetMousePos = 4,
	ImGuiBackendFlags_RendererHasVtxOffset = 8,
	ImGuiBackendFlags_PlatformHasViewports = 1024,
	ImGuiBackendFlags_HasMouseHoveredViewport = 2048,
	ImGuiBackendFlags_RendererHasViewports = 4096,
};
enum {
	ImGuiCol_Text,
	ImGuiCol_TextDisabled,
	ImGuiCol_WindowBg,
	ImGuiCol_ChildBg,
	ImGuiCol_PopupBg,
	ImGuiCol_Border,
	ImGuiCol_BorderShadow,
	ImGuiCol_FrameBg,
	ImGuiCol_FrameBgHovered,
	ImGuiCol_FrameBgActive,
	ImGuiCol_TitleBg,
	ImGuiCol_TitleBgActive,
	ImGuiCol_TitleBgCollapsed,
	ImGuiCol_MenuBarBg,
	ImGuiCol_ScrollbarBg,
	ImGuiCol_ScrollbarGrab,
	ImGuiCol_ScrollbarGrabHovered,
	ImGuiCol_ScrollbarGrabActive,
	ImGuiCol_CheckMark,
	ImGuiCol_SliderGrab,
	ImGuiCol_SliderGrabActive,
	ImGuiCol_Button,
	ImGuiCol_ButtonHovered,
	ImGuiCol_ButtonActive,
	ImGuiCol_Header,
	ImGuiCol_HeaderHovered,
	ImGuiCol_HeaderActive,
	ImGuiCol_Separator,
	ImGuiCol_SeparatorHovered,
	ImGuiCol_SeparatorActive,
	ImGuiCol_ResizeGrip,
	ImGuiCol_ResizeGripHovered,
	ImGuiCol_ResizeGripActive,
	ImGuiCol_Tab,
	ImGuiCol_TabHovered,
	ImGuiCol_TabActive,
	ImGuiCol_TabUnfocused,
	ImGuiCol_TabUnfocusedActive,
	ImGuiCol_DockingPreview,
	ImGuiCol_DockingEmptyBg,
	ImGuiCol_PlotLines,
	ImGuiCol_PlotLinesHovered,
	ImGuiCol_PlotHistogram,
	ImGuiCol_PlotHistogramHovered,
	ImGuiCol_TableHeaderBg,
	ImGuiCol_TableBorderStrong,
	ImGuiCol_TableBorderLight,
	ImGuiCol_TableRowBg,
	ImGuiCol_TableRowBgAlt,
	ImGuiCol_TextSelectedBg,
	ImGuiCol_DragDropTarget,
	ImGuiCol_NavHighlight,
	ImGuiCol_NavWindowingHighlight,
	ImGuiCol_NavWindowingDimBg,
	ImGuiCol_ModalWindowDimBg,
	ImGuiCol_COUNT,
};
enum {
	ImGuiStyleVar_Alpha,
	ImGuiStyleVar_DisabledAlpha,
	ImGuiStyleVar_WindowPadding,
	ImGuiStyleVar_WindowRounding,
	ImGuiStyleVar_WindowBorderSize,
	ImGuiStyleVar_WindowMinSize,
	ImGuiStyleVar_WindowTitleAlign,
	ImGuiStyleVar_ChildRounding,
	ImGuiStyleVar_ChildBorderSize,
	ImGuiStyleVar_PopupRounding,
	ImGuiStyleVar_PopupBorderSize,
	ImGuiStyleVar_FramePadding,
	ImGuiStyleVar_FrameRounding,
	ImGuiStyleVar_FrameBorderSize,
	ImGuiStyleVar_ItemSpacing,
	ImGuiStyleVar_ItemInnerSpacing,
	ImGuiStyleVar_IndentSpacing,
	ImGuiStyleVar_CellPadding,
	ImGuiStyleVar_ScrollbarSize,
	ImGuiStyleVar_ScrollbarRounding,
	ImGuiStyleVar_GrabMinSize,
	ImGuiStyleVar_GrabRounding,
	ImGuiStyleVar_TabRounding,
	ImGuiStyleVar_TabBorderSize,
	ImGuiStyleVar_TabBarBorderSize,
	ImGuiStyleVar_TableAngledHeadersAngle,
	ImGuiStyleVar_ButtonTextAlign,
	ImGuiStyleVar_SelectableTextAlign,
	ImGuiStyleVar_SeparatorTextBorderSize,
	ImGuiStyleVar_SeparatorTextAlign,
	ImGuiStyleVar_SeparatorTextPadding,
	ImGuiStyleVar_DockingSeparatorSize,
	ImGuiStyleVar_COUNT,
};
enum {
	ImGuiButtonFlags_None = 0,
	ImGuiButtonFlags_MouseButtonLeft = 1,
	ImGuiButtonFlags_MouseButtonRight = 2,
	ImGuiButtonFlags_MouseButtonMiddle = 4,
	ImGuiButtonFlags_MouseButtonMask_ = 7,
	ImGuiButtonFlags_MouseButtonDefault_ = 1,
	ImGuiColorEditFlags_None = 0,
	ImGuiColorEditFlags_NoAlpha = 2,
	ImGuiColorEditFlags_NoPicker = 4,
	ImGuiColorEditFlags_NoOptions = 8,
	ImGuiColorEditFlags_NoSmallPreview = 16,
	ImGuiColorEditFlags_NoInputs = 32,
	ImGuiColorEditFlags_NoTooltip = 64,
	ImGuiColorEditFlags_NoLabel = 128,
	ImGuiColorEditFlags_NoSidePreview = 256,
	ImGuiColorEditFlags_NoDragDrop = 512,
	ImGuiColorEditFlags_NoBorder = 1024,
	ImGuiColorEditFlags_AlphaBar = 65536,
	ImGuiColorEditFlags_AlphaPreview = 131072,
	ImGuiColorEditFlags_AlphaPreviewHalf = 262144,
	ImGuiColorEditFlags_HDR = 524288,
	ImGuiColorEditFlags_DisplayRGB = 1048576,
	ImGuiColorEditFlags_DisplayHSV = 2097152,
	ImGuiColorEditFlags_DisplayHex = 4194304,
	ImGuiColorEditFlags_Uint8 = 8388608,
	ImGuiColorEditFlags_Float = 16777216,
	ImGuiColorEditFlags_PickerHueBar = 33554432,
	ImGuiColorEditFlags_PickerHueWheel = 67108864,
	ImGuiColorEditFlags_InputRGB = 134217728,
	ImGuiColorEditFlags_InputHSV = 268435456,
	ImGuiColorEditFlags_DefaultOptions_ = 177209344,
	ImGuiColorEditFlags_DisplayMask_ = 7340032,
	ImGuiColorEditFlags_DataTypeMask_ = 25165824,
	ImGuiColorEditFlags_PickerMask_ = 100663296,
	ImGuiColorEditFlags_InputMask_ = 402653184,
	ImGuiSliderFlags_None = 0,
	ImGuiSliderFlags_AlwaysClamp = 16,
	ImGuiSliderFlags_Logarithmic = 32,
	ImGuiSliderFlags_NoRoundToFormat = 64,
	ImGuiSliderFlags_NoInput = 128,
	ImGuiSliderFlags_InvalidMask_ = 0x7000000F,
	ImGuiMouseButton_Left = 0,
	ImGuiMouseButton_Right = 1,
	ImGuiMouseButton_Middle = 2,
	ImGuiMouseButton_COUNT = 5,
	ImGuiMouseCursor_None = -1,
	ImGuiMouseCursor_Arrow = 0,
	ImGuiMouseCursor_TextInput,
	ImGuiMouseCursor_ResizeAll,
	ImGuiMouseCursor_ResizeNS,
	ImGuiMouseCursor_ResizeEW,
	ImGuiMouseCursor_ResizeNESW,
	ImGuiMouseCursor_ResizeNWSE,
	ImGuiMouseCursor_Hand,
	ImGuiMouseCursor_NotAllowed,
	ImGuiMouseCursor_COUNT,
	ImGuiMouseSource_Mouse = 0,
	ImGuiMouseSource_TouchScreen = 1,
	ImGuiMouseSource_Pen = 2,
	ImGuiMouseSource_COUNT = 3,
	ImGuiCond_None = 0,
	ImGuiCond_Always = 1,
	ImGuiCond_Once = 2,
	ImGuiCond_FirstUseEver = 4,
	ImGuiCond_Appearing = 8,
	ImGuiTableFlags_None = 0,
	ImGuiTableFlags_Resizable = 1,
	ImGuiTableFlags_Reorderable = 2,
	ImGuiTableFlags_Hideable = 4,
	ImGuiTableFlags_Sortable = 8,
	ImGuiTableFlags_NoSavedSettings = 16,
	ImGuiTableFlags_ContextMenuInBody = 32,
	ImGuiTableFlags_RowBg = 64,
	ImGuiTableFlags_BordersInnerH = 128,
	ImGuiTableFlags_BordersOuterH = 256,
	ImGuiTableFlags_BordersInnerV = 512,
	ImGuiTableFlags_BordersOuterV = 1024,
	ImGuiTableFlags_BordersH = 384,
	ImGuiTableFlags_BordersV = 1536,
	ImGuiTableFlags_BordersInner = 640,
	ImGuiTableFlags_BordersOuter = 1280,
	ImGuiTableFlags_Borders = 1920,
	ImGuiTableFlags_NoBordersInBody = 2048,
	ImGuiTableFlags_NoBordersInBodyUntilResize = 4096,
	ImGuiTableFlags_SizingFixedFit = 8192,
	ImGuiTableFlags_SizingFixedSame = 16384,
	ImGuiTableFlags_SizingStretchProp = 24576,
	ImGuiTableFlags_SizingStretchSame = 32768,
	ImGuiTableFlags_NoHostExtendX = 65536,
	ImGuiTableFlags_NoHostExtendY = 131072,
	ImGuiTableFlags_NoKeepColumnsVisible = 262144,
	ImGuiTableFlags_PreciseWidths = 524288,
	ImGuiTableFlags_NoClip = 1048576,
	ImGuiTableFlags_PadOuterX = 2097152,
	ImGuiTableFlags_NoPadOuterX = 4194304,
	ImGuiTableFlags_NoPadInnerX = 8388608,
	ImGuiTableFlags_ScrollX = 16777216,
	ImGuiTableFlags_ScrollY = 33554432,
	ImGuiTableFlags_SortMulti = 67108864,
	ImGuiTableFlags_SortTristate = 134217728,
	ImGuiTableFlags_HighlightHoveredColumn = 268435456,
	ImGuiTableFlags_SizingMask_ = 81920,
	ImGuiTableColumnFlags_None = 0,
	ImGuiTableColumnFlags_Disabled = 1,
	ImGuiTableColumnFlags_DefaultHide = 2,
	ImGuiTableColumnFlags_DefaultSort = 4,
	ImGuiTableColumnFlags_WidthStretch = 8,
	ImGuiTableColumnFlags_WidthFixed = 16,
	ImGuiTableColumnFlags_NoResize = 32,
	ImGuiTableColumnFlags_NoReorder = 64,
	ImGuiTableColumnFlags_NoHide = 128,
	ImGuiTableColumnFlags_NoClip = 256,
	ImGuiTableColumnFlags_NoSort = 512,
	ImGuiTableColumnFlags_NoSortAscending = 1024,
	ImGuiTableColumnFlags_NoSortDescending = 2048,
	ImGuiTableColumnFlags_NoHeaderLabel = 4096,
	ImGuiTableColumnFlags_NoHeaderWidth = 8192,
	ImGuiTableColumnFlags_PreferSortAscending = 16384,
	ImGuiTableColumnFlags_PreferSortDescending = 32768,
	ImGuiTableColumnFlags_IndentEnable = 65536,
	ImGuiTableColumnFlags_IndentDisable = 131072,
	ImGuiTableColumnFlags_AngledHeader = 262144,
	ImGuiTableColumnFlags_IsEnabled = 16777216,
	ImGuiTableColumnFlags_IsVisible = 33554432,
	ImGuiTableColumnFlags_IsSorted = 67108864,
	ImGuiTableColumnFlags_IsHovered = 134217728,
	ImGuiTableColumnFlags_WidthMask_ = 24,
	ImGuiTableColumnFlags_IndentMask_ = 196608,
	ImGuiTableColumnFlags_StatusMask_ = 251658240,
	ImGuiTableColumnFlags_NoDirectResize_ = 1073741824,
	ImGuiTableRowFlags_None = 0,
	ImGuiTableRowFlags_Headers = 1,
	ImGuiTableBgTarget_None = 0,
	ImGuiTableBgTarget_RowBg0 = 1,
	ImGuiTableBgTarget_RowBg1 = 2,
	ImGuiTableBgTarget_CellBg = 3,
	ImDrawFlags_None = 0,
	ImDrawFlags_Closed = 1,
	ImDrawFlags_RoundCornersTopLeft = 16,
	ImDrawFlags_RoundCornersTopRight = 32,
	ImDrawFlags_RoundCornersBottomLeft = 64,
	ImDrawFlags_RoundCornersBottomRight = 128,
	ImDrawFlags_RoundCornersNone = 256,
	ImDrawFlags_RoundCornersTop = 48,
	ImDrawFlags_RoundCornersBottom = 192,
	ImDrawFlags_RoundCornersLeft = 80,
	ImDrawFlags_RoundCornersRight = 160,
	ImDrawFlags_RoundCornersAll = 240,
	ImDrawFlags_RoundCornersDefault_ = 240,
	ImDrawFlags_RoundCornersMask_ = 496,
	ImDrawListFlags_None = 0,
	ImDrawListFlags_AntiAliasedLines = 1,
	ImDrawListFlags_AntiAliasedLinesUseTex = 2,
	ImDrawListFlags_AntiAliasedFill = 4,
	ImDrawListFlags_AllowVtxOffset = 8,
	ImFontAtlasFlags_None = 0,
	ImFontAtlasFlags_NoPowerOfTwoHeight = 1,
	ImFontAtlasFlags_NoMouseCursors = 2,
	ImFontAtlasFlags_NoBakedLines = 4,
	ImGuiViewportFlags_None = 0,
	ImGuiViewportFlags_IsPlatformWindow = 1,
	ImGuiViewportFlags_IsPlatformMonitor = 2,
	ImGuiViewportFlags_OwnedByApp = 4,
	ImGuiViewportFlags_NoDecoration = 8,
	ImGuiViewportFlags_NoTaskBarIcon = 16,
	ImGuiViewportFlags_NoFocusOnAppearing = 32,
	ImGuiViewportFlags_NoFocusOnClick = 64,
	ImGuiViewportFlags_NoInputs = 128,
	ImGuiViewportFlags_NoRendererClear = 256,
	ImGuiViewportFlags_NoAutoMerge = 512,
	ImGuiViewportFlags_TopMost = 1024,
	ImGuiViewportFlags_CanHostOtherWindows = 2048,
	ImGuiViewportFlags_IsMinimized = 4096,
	ImGuiViewportFlags_IsFocused = 8192,
	ImGuiItemFlags_None = 0,
	ImGuiItemFlags_NoTabStop = 1,
	ImGuiItemFlags_ButtonRepeat = 2,
	ImGuiItemFlags_Disabled = 4,
	ImGuiItemFlags_NoNav = 8,
	ImGuiItemFlags_NoNavDefaultFocus = 16,
	ImGuiItemFlags_SelectableDontClosePopup = 32,
	ImGuiItemFlags_MixedValue = 64,
	ImGuiItemFlags_ReadOnly = 128,
	ImGuiItemFlags_NoWindowHoverableCheck = 256,
	ImGuiItemFlags_AllowOverlap = 512,
	ImGuiItemFlags_Inputable = 1024,
	ImGuiItemFlags_HasSelectionUserData = 2048,
	ImGuiItemStatusFlags_None = 0,
	ImGuiItemStatusFlags_HoveredRect = 1,
	ImGuiItemStatusFlags_HasDisplayRect = 2,
	ImGuiItemStatusFlags_Edited = 4,
	ImGuiItemStatusFlags_ToggledSelection = 8,
	ImGuiItemStatusFlags_ToggledOpen = 16,
	ImGuiItemStatusFlags_HasDeactivated = 32,
	ImGuiItemStatusFlags_Deactivated = 64,
	ImGuiItemStatusFlags_HoveredWindow = 128,
	ImGuiItemStatusFlags_Visible = 256,
	ImGuiItemStatusFlags_HasClipRect = 512,
	ImGuiHoveredFlags_DelayMask_ = 245760,
	ImGuiHoveredFlags_AllowedMaskForIsWindowHovered = 12479,
	ImGuiHoveredFlags_AllowedMaskForIsItemHovered = 262048,
	ImGuiInputTextFlags_Multiline = 67108864,
	ImGuiInputTextFlags_NoMarkEdited = 134217728,
	ImGuiInputTextFlags_MergedItem = 268435456,
	ImGuiInputTextFlags_LocalizeDecimalPoint = 536870912,
	ImGuiButtonFlags_PressedOnClick = 16,
	ImGuiButtonFlags_PressedOnClickRelease = 32,
	ImGuiButtonFlags_PressedOnClickReleaseAnywhere = 64,
	ImGuiButtonFlags_PressedOnRelease = 128,
	ImGuiButtonFlags_PressedOnDoubleClick = 256,
	ImGuiButtonFlags_PressedOnDragDropHold = 512,
	ImGuiButtonFlags_Repeat = 1024,
	ImGuiButtonFlags_FlattenChildren = 2048,
	ImGuiButtonFlags_AllowOverlap = 4096,
	ImGuiButtonFlags_DontClosePopups = 8192,
	ImGuiButtonFlags_AlignTextBaseLine = 32768,
	ImGuiButtonFlags_NoKeyModifiers = 65536,
	ImGuiButtonFlags_NoHoldingActiveId = 131072,
	ImGuiButtonFlags_NoNavFocus = 262144,
	ImGuiButtonFlags_NoHoveredOnFocus = 524288,
	ImGuiButtonFlags_NoSetKeyOwner = 1048576,
	ImGuiButtonFlags_NoTestKeyOwner = 2097152,
	ImGuiButtonFlags_PressedOnMask_ = 1008,
	ImGuiButtonFlags_PressedOnDefault_ = 32,
	ImGuiComboFlags_CustomPreview = 1048576,
	ImGuiSliderFlags_Vertical = 1048576,
	ImGuiSliderFlags_ReadOnly = 2097152,
	ImGuiSelectableFlags_NoHoldingActiveID = 1048576,
	ImGuiSelectableFlags_SelectOnNav = 2097152,
	ImGuiSelectableFlags_SelectOnClick = 4194304,
	ImGuiSelectableFlags_SelectOnRelease = 8388608,
	ImGuiSelectableFlags_SpanAvailWidth = 16777216,
	ImGuiSelectableFlags_SetNavIdOnHover = 33554432,
	ImGuiSelectableFlags_NoPadWithHalfSpacing = 67108864,
	ImGuiSelectableFlags_NoSetKeyOwner = 134217728,
	ImGuiTreeNodeFlags_ClipLabelForTrailingButton = 1048576,
	ImGuiTreeNodeFlags_UpsideDownArrow = 2097152,
	ImGuiSeparatorFlags_None = 0,
	ImGuiSeparatorFlags_Horizontal = 1,
	ImGuiSeparatorFlags_Vertical = 2,
	ImGuiSeparatorFlags_SpanAllColumns = 4,
	ImGuiFocusRequestFlags_None = 0,
	ImGuiFocusRequestFlags_RestoreFocusedChild = 1,
	ImGuiFocusRequestFlags_UnlessBelowModal = 2,
	ImGuiTextFlags_None = 0,
	ImGuiTextFlags_NoWidthForLargeClippedText = 1,
	ImGuiTooltipFlags_None = 0,
	ImGuiTooltipFlags_OverridePrevious = 2,
	ImGuiLayoutType_Horizontal = 0,
	ImGuiLayoutType_Vertical = 1,
	ImGuiLogType_None = 0,
	ImGuiLogType_TTY,
	ImGuiLogType_File,
	ImGuiLogType_Buffer,
	ImGuiLogType_Clipboard,
	ImGuiAxis_None = -1,
	ImGuiAxis_X = 0,
	ImGuiAxis_Y = 1,

};

enum {
	ImGuiPlotType_Lines,
	ImGuiPlotType_Histogram,

};

enum {
	ImGuiNextWindowDataFlags_None = 0,
	ImGuiNextWindowDataFlags_HasPos = 1,
	ImGuiNextWindowDataFlags_HasSize = 2,
	ImGuiNextWindowDataFlags_HasContentSize = 4,
	ImGuiNextWindowDataFlags_HasCollapsed = 8,
	ImGuiNextWindowDataFlags_HasSizeConstraint = 16,
	ImGuiNextWindowDataFlags_HasFocus = 32,
	ImGuiNextWindowDataFlags_HasBgAlpha = 64,
	ImGuiNextWindowDataFlags_HasScroll = 128,
	ImGuiNextWindowDataFlags_HasChildFlags = 256,
	ImGuiNextWindowDataFlags_HasViewport = 512,
	ImGuiNextWindowDataFlags_HasDock = 1024,
	ImGuiNextWindowDataFlags_HasWindowClass = 2048,
	ImGuiNextItemDataFlags_None = 0,
	ImGuiNextItemDataFlags_HasWidth = 1,
	ImGuiNextItemDataFlags_HasOpen = 2,
	ImGuiNextItemDataFlags_HasShortcut = 4,

};

enum {
	ImGuiPopupPositionPolicy_Default,
	ImGuiPopupPositionPolicy_ComboBox,
	ImGuiPopupPositionPolicy_Tooltip,
	ImGuiInputEventType_None = 0,
	ImGuiInputEventType_MousePos,
	ImGuiInputEventType_MouseWheel,
	ImGuiInputEventType_MouseButton,
	ImGuiInputEventType_MouseViewport,
	ImGuiInputEventType_Key,
	ImGuiInputEventType_Text,
	ImGuiInputEventType_Focus,
	ImGuiInputEventType_COUNT,
	ImGuiInputSource_None = 0,
	ImGuiInputSource_Mouse,
	ImGuiInputSource_Keyboard,
	ImGuiInputSource_Gamepad,
	ImGuiInputSource_COUNT,
	ImGuiInputFlags_None = 0,
	ImGuiInputFlags_Repeat = 1,
	ImGuiInputFlags_RepeatRateDefault = 2,
	ImGuiInputFlags_RepeatRateNavMove = 4,
	ImGuiInputFlags_RepeatRateNavTweak = 8,
	ImGuiInputFlags_RepeatUntilRelease = 16,
	ImGuiInputFlags_RepeatUntilKeyModsChange = 32,
	ImGuiInputFlags_RepeatUntilKeyModsChangeFromNone = 64,
	ImGuiInputFlags_RepeatUntilOtherKeyPress = 128,
	ImGuiInputFlags_CondHovered = 256,
	ImGuiInputFlags_CondActive = 512,
	ImGuiInputFlags_CondDefault_ = 768,
	ImGuiInputFlags_LockThisFrame = 1024,
	ImGuiInputFlags_LockUntilRelease = 2048,
	ImGuiInputFlags_RouteFocused = 4096,
	ImGuiInputFlags_RouteGlobalLow = 8192,
	ImGuiInputFlags_RouteGlobal = 16384,
	ImGuiInputFlags_RouteGlobalHigh = 32768,
	ImGuiInputFlags_RouteAlways = 65536,
	ImGuiInputFlags_RouteUnlessBgFocused = 131072,
	ImGuiInputFlags_RepeatRateMask_ = 14,
	ImGuiInputFlags_RepeatUntilMask_ = 240,
	ImGuiInputFlags_RepeatMask_ = 255,
	ImGuiInputFlags_CondMask_ = 768,
	ImGuiInputFlags_RouteMask_ = 61440,
	ImGuiInputFlags_SupportedByIsKeyPressed = 255,
	ImGuiInputFlags_SupportedByIsMouseClicked = 1,
	ImGuiInputFlags_SupportedByShortcut = 258303,
	ImGuiInputFlags_SupportedBySetKeyOwner = 3072,
	ImGuiInputFlags_SupportedBySetItemKeyOwner = 3840,
	ImGuiActivateFlags_None = 0,
	ImGuiActivateFlags_PreferInput = 1,
	ImGuiActivateFlags_PreferTweak = 2,
	ImGuiActivateFlags_TryToPreserveState = 4,
	ImGuiActivateFlags_FromTabbing = 8,
	ImGuiActivateFlags_FromShortcut = 16,
	ImGuiScrollFlags_None = 0,
	ImGuiScrollFlags_KeepVisibleEdgeX = 1,
	ImGuiScrollFlags_KeepVisibleEdgeY = 2,
	ImGuiScrollFlags_KeepVisibleCenterX = 4,
	ImGuiScrollFlags_KeepVisibleCenterY = 8,
	ImGuiScrollFlags_AlwaysCenterX = 16,
	ImGuiScrollFlags_AlwaysCenterY = 32,
	ImGuiScrollFlags_NoScrollParent = 64,
	ImGuiScrollFlags_MaskX_ = 21,
	ImGuiScrollFlags_MaskY_ = 42,
	ImGuiNavHighlightFlags_None = 0,
	ImGuiNavHighlightFlags_Compact = 2,
	ImGuiNavHighlightFlags_AlwaysDraw = 4,
	ImGuiNavHighlightFlags_NoRounding = 8,
	ImGuiNavMoveFlags_None = 0,
	ImGuiNavMoveFlags_LoopX = 1,
	ImGuiNavMoveFlags_LoopY = 2,
	ImGuiNavMoveFlags_WrapX = 4,
	ImGuiNavMoveFlags_WrapY = 8,
	ImGuiNavMoveFlags_WrapMask_ = 15,
	ImGuiNavMoveFlags_AllowCurrentNavId = 16,
	ImGuiNavMoveFlags_AlsoScoreVisibleSet = 32,
	ImGuiNavMoveFlags_ScrollToEdgeY = 64,
	ImGuiNavMoveFlags_Forwarded = 128,
	ImGuiNavMoveFlags_DebugNoResult = 256,
	ImGuiNavMoveFlags_FocusApi = 512,
	ImGuiNavMoveFlags_IsTabbing = 1024,
	ImGuiNavMoveFlags_IsPageMove = 2048,
	ImGuiNavMoveFlags_Activate = 4096,
	ImGuiNavMoveFlags_NoSelect = 8192,
	ImGuiNavMoveFlags_NoSetNavHighlight = 16384,
	ImGuiNavMoveFlags_NoClearActiveId = 32768,
	ImGuiNavLayer_Main = 0,
	ImGuiNavLayer_Menu = 1,
	ImGuiNavLayer_COUNT,
	ImGuiTypingSelectFlags_None = 0,
	ImGuiTypingSelectFlags_AllowBackspace = 1,
	ImGuiTypingSelectFlags_AllowSingleCharMode = 2,
	ImGuiOldColumnFlags_None = 0,
	ImGuiOldColumnFlags_NoBorder = 1,
	ImGuiOldColumnFlags_NoResize = 2,
	ImGuiOldColumnFlags_NoPreserveWidths = 4,
	ImGuiOldColumnFlags_NoForceWithinWindow = 8,
	ImGuiOldColumnFlags_GrowParentContentsSize = 16,
	ImGuiDockNodeFlags_DockSpace = 1024,
	ImGuiDockNodeFlags_CentralNode = 2048,
	ImGuiDockNodeFlags_NoTabBar = 4096,
	ImGuiDockNodeFlags_HiddenTabBar = 8192,
	ImGuiDockNodeFlags_NoWindowMenuButton = 16384,
	ImGuiDockNodeFlags_NoCloseButton = 32768,
	ImGuiDockNodeFlags_NoResizeX = 65536,
	ImGuiDockNodeFlags_NoResizeY = 131072,
	ImGuiDockNodeFlags_DockedWindowsInFocusRoute = 262144,
	ImGuiDockNodeFlags_NoDockingSplitOther = 524288,
	ImGuiDockNodeFlags_NoDockingOverMe = 1048576,
	ImGuiDockNodeFlags_NoDockingOverOther = 2097152,
	ImGuiDockNodeFlags_NoDockingOverEmpty = 4194304,
	ImGuiDockNodeFlags_NoDocking = 7864336,
	ImGuiDockNodeFlags_SharedFlagsInheritMask_ = 0xffffffff,
	ImGuiDockNodeFlags_NoResizeFlagsMask_ = 196640,
	ImGuiDockNodeFlags_LocalFlagsTransferMask_ = 260208,
	ImGuiDockNodeFlags_SavedFlagsMask_ = 261152,

};

enum {
	ImGuiDataAuthority_Auto,
	ImGuiDataAuthority_DockNode,
	ImGuiDataAuthority_Window,

};

enum {
	ImGuiDockNodeState_Unknown,
	ImGuiDockNodeState_HostWindowHiddenBecauseSingleWindow,
	ImGuiDockNodeState_HostWindowHiddenBecauseWindowsAreResizing,
	ImGuiDockNodeState_HostWindowVisible,

};

enum {
	ImGuiWindowDockStyleCol_Text,
	ImGuiWindowDockStyleCol_Tab,
	ImGuiWindowDockStyleCol_TabHovered,
	ImGuiWindowDockStyleCol_TabActive,
	ImGuiWindowDockStyleCol_TabUnfocused,
	ImGuiWindowDockStyleCol_TabUnfocusedActive,
	ImGuiWindowDockStyleCol_COUNT,
	ImGuiLocKey_VersionStr = 0,
	ImGuiLocKey_TableSizeOne = 1,
	ImGuiLocKey_TableSizeAllFit = 2,
	ImGuiLocKey_TableSizeAllDefault = 3,
	ImGuiLocKey_TableResetOrder = 4,
	ImGuiLocKey_WindowingMainMenuBar = 5,
	ImGuiLocKey_WindowingPopup = 6,
	ImGuiLocKey_WindowingUntitled = 7,
	ImGuiLocKey_DockingHideTabBar = 8,
	ImGuiLocKey_DockingHoldShiftToDock = 9,
	ImGuiLocKey_DockingDragToUndockOrMoveNode = 10,
	ImGuiLocKey_COUNT = 11,
	ImGuiDebugLogFlags_None = 0,
	ImGuiDebugLogFlags_EventActiveId = 1,
	ImGuiDebugLogFlags_EventFocus = 2,
	ImGuiDebugLogFlags_EventPopup = 4,
	ImGuiDebugLogFlags_EventNav = 8,
	ImGuiDebugLogFlags_EventClipper = 16,
	ImGuiDebugLogFlags_EventSelection = 32,
	ImGuiDebugLogFlags_EventIO = 64,
	ImGuiDebugLogFlags_EventInputRouting = 128,
	ImGuiDebugLogFlags_EventDocking = 256,
	ImGuiDebugLogFlags_EventViewport = 512,
	ImGuiDebugLogFlags_EventMask_ = 1023,
	ImGuiDebugLogFlags_OutputToTTY = 1048576,
	ImGuiDebugLogFlags_OutputToTestEngine = 2097152,

};

enum {
	ImGuiContextHookType_NewFramePre,
	ImGuiContextHookType_NewFramePost,
	ImGuiContextHookType_EndFramePre,
	ImGuiContextHookType_EndFramePost,
	ImGuiContextHookType_RenderPre,
	ImGuiContextHookType_RenderPost,
	ImGuiContextHookType_Shutdown,
	ImGuiContextHookType_PendingRemoval_,
	ImGuiTabBarFlags_DockNode = 1048576,
	ImGuiTabBarFlags_IsFocused = 2097152,
	ImGuiTabBarFlags_SaveSettings = 4194304,
	ImGuiTabItemFlags_SectionMask_ = 192,
	ImGuiTabItemFlags_NoCloseButton = 1048576,
	ImGuiTabItemFlags_Button = 2097152,
	ImGuiTabItemFlags_Unsorted = 4194304,
};

typedef int ImGuiWindowFlags_;
typedef int ImGuiChildFlags_;
typedef int ImGuiInputTextFlags_;
typedef int ImGuiTreeNodeFlags_;
typedef int ImGuiPopupFlags_;
typedef int ImGuiSelectableFlags_;
typedef int ImGuiComboFlags_;
typedef int ImGuiTabBarFlags_;
typedef int ImGuiTabItemFlags_;
typedef int ImGuiFocusedFlags_;
typedef int ImGuiHoveredFlags_;
typedef int ImGuiDockNodeFlags_;
typedef int ImGuiDragDropFlags_;
typedef int ImGuiDataType_;
typedef int ImGuiDataTypePrivate_;
typedef int ImGuiDir_;
typedef int ImGuiSortDirection_;
typedef int ImGuiKey;
typedef int ImGuiConfigFlags_;
typedef int ImGuiBackendFlags_;
typedef int ImGuiCol_;
typedef int ImGuiStyleVar_;
typedef int ImGuiButtonFlags_;
typedef int ImGuiColorEditFlags_;
typedef int ImGuiSliderFlags_;
typedef int ImGuiMouseButton_;
typedef int ImGuiMouseCursor_;
typedef int ImGuiMouseSource;
typedef int ImGuiCond_;
typedef int ImGuiTableFlags_;
typedef int ImGuiTableColumnFlags_;
typedef int ImGuiTableRowFlags_;
typedef int ImGuiTableBgTarget_;
typedef int ImGuiViewportFlags_;
typedef int ImGuiItemFlags_;
typedef int ImGuiItemStatusFlags_;
typedef int ImGuiHoveredFlagsPrivate_;
typedef int ImGuiInputTextFlagsPrivate_;
typedef int ImGuiButtonFlagsPrivate_;
typedef int ImGuiComboFlagsPrivate_;
typedef int ImGuiSliderFlagsPrivate_;
typedef int ImGuiSelectableFlagsPrivate_;
typedef int ImGuiTreeNodeFlagsPrivate_;
typedef int ImGuiSeparatorFlags_;
typedef int ImGuiFocusRequestFlags_;
typedef int ImGuiTextFlags_;
typedef int ImGuiTooltipFlags_;
typedef int ImGuiLayoutType_;
typedef int ImGuiLogType;
typedef int ImGuiAxis;
typedef int ImGuiPlotType;
typedef int ImGuiNextWindowDataFlags_;
typedef int ImGuiNextItemDataFlags_;
typedef int ImGuiPopupPositionPolicy;
typedef int ImGuiInputEventType;
typedef int ImGuiInputSource;
typedef int ImGuiInputFlags_;
typedef int ImGuiActivateFlags_;
typedef int ImGuiScrollFlags_;
typedef int ImGuiNavHighlightFlags_;
typedef int ImGuiNavMoveFlags_;
typedef int ImGuiNavLayer;
typedef int ImGuiTypingSelectFlags_;
typedef int ImGuiOldColumnFlags_;
typedef int ImGuiDockNodeFlagsPrivate_;
typedef int ImGuiDataAuthority_;
typedef int ImGuiDockNodeState;
typedef int ImGuiWindowDockStyleCol;
typedef int ImGuiLocKey;
typedef int ImGuiDebugLogFlags_;
typedef int ImGuiContextHookType;
typedef int ImGuiTabBarFlagsPrivate_;
typedef int ImGuiTabItemFlagsPrivate_;
typedef int ImDrawFlags_;
typedef int ImDrawListFlags_;
typedef int ImFontAtlasFlags_;

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
	js.imgui:newFrame()
end

-- end of frame in order
function ig.igRender()
	js.imgui:render()
end

function ig.igText(...)
	return js:imgui:text(...)
end

function ig.igButton(...)
	return js.imgui:button(...)
end

ig.igColorButton = ig.igButton

function ig.igInputFloat(label, v, ...)
	-- 'v' is cdata, it is where things get written upon succes ...
	--local v = ffi.dataToArray('Float32Array', v, 1);
	local changed = js.imgui:inputFloat(label, v[0], ...)
	if changed then
		-- before I was fasting the v ptr through to the js functions, and within that writing to v[0] ... which must've done some js magic under the hood? to be able to invoke the lua metamethod ... bad idea I guess?  i can't tell ...
		-- reading/writing lua numbers and reading js callback single-value returns is muuuch faster than the alternatives
		v[0] = js.imgui:lastValue()
	end
	return changed
end
ig.igSliderFloat = ig.igInputFloat

function ig.igInputInt(label, v, ...)
	-- 'v' is cdata, it is where things get written upon succes ...
	--local v = ffi.dataToArray('Int32Array', v, 1);
	local changed = js.imgui:inputInt(label, v[0], ...)
	if changed then
		v[0] = js.imgui:lastValue()
	end
	return changed
end
ig.igSliderInt = ig.igInputInt

function ig.igInputText(label, buf, bufsize, flags, callback, user_data)
	local str = ffi.string(buf, bufsize)
	local changed = js.imgui:inputText(label, str)
	if changed then
		ffi.copy(buf, js.imgui:lastValue(), bufsize)
	end
	return changed
end

--(const char* label,int* v,int v_button);
function ig.igRadioButton_IntPtr(label, result, radioValue)
	local radioGroup = tostring(result)	-- if a unique result determines our radio group ... then use the result's address ...
	local changed = js.imgui:inputRadio(label, result[0], radioValue, radioGroup)
	if changed then
		result[0] = radioValue
	end
	return changed
end

--(const char* label, int* current_item, const char* const items[], int itemCount, int popup_max_height_in_items)
function ig.igCombo_Str_arr(label, currentItem, items, itemCount, popupMaxHeight)
	local items = {}
	for i=1,itemCount do
		items[i] = ffi.string(items[i])
	end
	local changed = js.imgui:inputCombo(label, currentItem[0], items)
	if changed then
		currentItem[0] = js.imgui:lastValue()
	end
	return changed
end

--(const char* label, int* current_item, const char* itemsZeroSep, int popup_max_height_in_items)
function ig.igCombo_Str(label, currentItem, itemsZeroSep, popupMaxHeight)
	local p = ffi.cast('char*', itemsZeroSep)
	local items = {}
	while p[0] ~= 0 do
		table.insert(items, ffi.string(p))
		p = p + ffi.C.strlen(p) + 1
	end
	local changed = js.imgui:inputCombo(label, currentItem[0], items)
	if changed then
		currentItem[0] = js.imgui:lastValue()
	end
	return changed
end

--(const char* label, int* current_item, const char*(*getter)(void* user_data, int idx), void* user_data, int items_count, int popup_max_height_in_items)
function ig.igCombo_FnBoolPtr(label, currentItem, getter, userData, itemsCount, popupMaxHeight)
	local items = {}
	for i=0,itemsCount-1 do
		table.insert(items, ffi.string(getter(userData, i)))
	end
	local changed = js.imgui:inputCombo(label, currentItem[0], items)
	if changed then
		currentItem[0] = js.imgui:lastValue()
	end
	return changed
end

function ig.igGetMainViewport()
	local canvas = js.global.canvas	-- assigned in createCanvas right now
	return {
		WorkPos = ffi.new('ImVec2', 0, 0),
		WorkSize = ffi.new('ImVec2', canvas.width, canvas.height),
	}
end

function ig.igGetDrawData() end
function ig.ImGui_ImplOpenGL3_RenderDrawData() end

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
function ig.igIsItemHovered() end
function ig.igSetMouseCursor() end
function ig.igSetCursorPosY() end
function ig.igSetCursorPosX() end

function ig.igStyleColorsDark() end
function ig.igPushStyleVar_Float() end
function ig.igPopStyleVar() end

function ig.igCalcTextSize() end

function ig.igBeginMainMenuBar() end
function ig.igEndMainMenuBar() end
function ig.igBeginMenu() end
function ig.igEndMenu() end

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
