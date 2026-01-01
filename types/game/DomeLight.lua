---@meta

---@class ADomeLight_C : AMTVehicleInteriorLight
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Light USpotLightComponent
---@field SM_FrontDomeLight UStaticMeshComponent
local ADomeLight_C = {}

---@param bOn boolean
function ADomeLight_C:ReceiveSetLightOn(bOn) end
---@param EntryPoint int32
function ADomeLight_C:ExecuteUbergraph_DomeLight(EntryPoint) end


