---@meta

---@class UW_MFD_EV_Arrival_C : UDashboardMFDWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field ChargeGauge UProgressBar
---@field DigitalSpeedometer UW_DigitalSpeedometer_C
---@field ESC UTextBlock
---@field FuelGauge UW_HorizontalGauge_C
---@field HandBrake UImage
---@field Headlight UImage
---@field Image_154 UImage
---@field LeftBlinker UImage
---@field LowFuel UImage
---@field OverHeat UImage
---@field PowerGauge UProgressBar
---@field RightBlinker UImage
---@field TCS UImage
---@field TCSOff UTextBlock
---@field OffColor FSlateColor
---@field GreenColor FSlateColor
---@field OrangeColor FSlateColor
---@field RedColor FSlateColor
---@field BlueColor FSlateColor
---@field EVPowerPercentage float
local UW_MFD_EV_Arrival_C = {}

---@param bOn boolean
function UW_MFD_EV_Arrival_C:ReceiveLeftTurnSignalLight(bOn) end
---@param bOn boolean
function UW_MFD_EV_Arrival_C:ReceiveRightTurnSignalLight(bOn) end
---@param bOn boolean
function UW_MFD_EV_Arrival_C:ReceiveESC(bOn) end
---@param bOn boolean
function UW_MFD_EV_Arrival_C:ReceiveHandbrake(bOn) end
---@param bOn boolean
function UW_MFD_EV_Arrival_C:ReceiveTCS(bOn) end
---@param bOn boolean
function UW_MFD_EV_Arrival_C:ReceiveTCSOff(bOn) end
---@param bOn boolean
function UW_MFD_EV_Arrival_C:ReceiveLowFuel(bOn) end
---@param bOn boolean
function UW_MFD_EV_Arrival_C:ReceiveOverHeat(bOn) end
---@param bOn boolean
---@param bHighBeam boolean
function UW_MFD_EV_Arrival_C:ReceiveHeadLight(bOn, bHighBeam) end
---@param InVehicle AMTVehicle
function UW_MFD_EV_Arrival_C:ReceiveSetVehicle(InVehicle) end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_MFD_EV_Arrival_C:Tick(MyGeometry, InDeltaTime) end
---@param Brush FSlateBrush
function UW_MFD_EV_Arrival_C:ReceiveFuelTypeIconBrush(Brush) end
---@param EntryPoint int32
function UW_MFD_EV_Arrival_C:ExecuteUbergraph_W_MFD_EV_Arrival(EntryPoint) end


