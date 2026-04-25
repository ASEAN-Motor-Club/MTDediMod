---@meta

---@class UW_MFD_01_C : UDashboardMFDWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field ESC UTextBlock
---@field HandBrake UImage
---@field Headlight UImage
---@field LeftBlinker UImage
---@field LowFuel UImage
---@field OverHeat UImage
---@field RightBlinker UImage
---@field TCS UImage
---@field TCSOff UTextBlock
---@field OffColor FSlateColor
---@field GreenColor FSlateColor
---@field OrangeColor FSlateColor
---@field RedColor FSlateColor
---@field BlueColor FSlateColor
local UW_MFD_01_C = {}

---@param bOn boolean
function UW_MFD_01_C:ReceiveLeftTurnSignalLight(bOn) end
---@param bOn boolean
function UW_MFD_01_C:ReceiveRightTurnSignalLight(bOn) end
---@param bOn boolean
function UW_MFD_01_C:ReceiveESC(bOn) end
---@param bOn boolean
function UW_MFD_01_C:ReceiveHandbrake(bOn) end
---@param bOn boolean
function UW_MFD_01_C:ReceiveTCS(bOn) end
---@param bOn boolean
function UW_MFD_01_C:ReceiveTCSOff(bOn) end
---@param bOn boolean
function UW_MFD_01_C:ReceiveLowFuel(bOn) end
---@param bOn boolean
function UW_MFD_01_C:ReceiveOverHeat(bOn) end
---@param bOn boolean
---@param bHighBeam boolean
function UW_MFD_01_C:ReceiveHeadLight(bOn, bHighBeam) end
---@param Brush FSlateBrush
function UW_MFD_01_C:ReceiveFuelTypeIconBrush(Brush) end
---@param EntryPoint int32
function UW_MFD_01_C:ExecuteUbergraph_W_MFD_01(EntryPoint) end


