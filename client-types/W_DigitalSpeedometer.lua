---@meta

---@class UW_DigitalSpeedometer_C : UDigitalSpeedometerWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Vehicle_0 AMTVehicle
local UW_DigitalSpeedometer_C = {}

---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_DigitalSpeedometer_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UW_DigitalSpeedometer_C:ExecuteUbergraph_W_DigitalSpeedometer(EntryPoint) end


