---@meta

---@class ADomeLight_LargeCircle_C : AMTVehicleInteriorLight
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Light USpotLightComponent
---@field SM_FrontDomeLight UStaticMeshComponent
local ADomeLight_LargeCircle_C = {}

---@param bOn boolean
function ADomeLight_LargeCircle_C:ReceiveSetLightOn(bOn) end
---@param EntryPoint int32
function ADomeLight_LargeCircle_C:ExecuteUbergraph_DomeLight_LargeCircle(EntryPoint) end


