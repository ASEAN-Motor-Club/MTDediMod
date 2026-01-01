---@meta

---@class ADomeLight_LargeCircle2_C : AMTVehicleInteriorLight
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Light USpotLightComponent
---@field SM_FrontDomeLight UStaticMeshComponent
local ADomeLight_LargeCircle2_C = {}

---@param bOn boolean
function ADomeLight_LargeCircle2_C:ReceiveSetLightOn(bOn) end
---@param EntryPoint int32
function ADomeLight_LargeCircle2_C:ExecuteUbergraph_DomeLight_LargeCircle2(EntryPoint) end


