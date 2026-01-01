---@meta

---@class AFrontDomeLight_03_C : AMTVehicleInteriorLight
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Right USpotLightComponent
---@field SM_FrontDomeLight UStaticMeshComponent
local AFrontDomeLight_03_C = {}

---@param bOn boolean
function AFrontDomeLight_03_C:ReceiveSetLightOn(bOn) end
---@param EntryPoint int32
function AFrontDomeLight_03_C:ExecuteUbergraph_FrontDomeLight_03(EntryPoint) end


