---@meta

---@class AFrontDomeLight_C : AMTVehicleInteriorLight
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Right USpotLightComponent
---@field Left USpotLightComponent
---@field SM_FrontDomeLight UStaticMeshComponent
local AFrontDomeLight_C = {}

---@param bOn boolean
function AFrontDomeLight_C:ReceiveSetLightOn(bOn) end
---@param EntryPoint int32
function AFrontDomeLight_C:ExecuteUbergraph_FrontDomeLight(EntryPoint) end


