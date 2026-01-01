---@meta

---@class AFrontDomeLight_2m_C : AMTVehicleInteriorLight
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Right USpotLightComponent
---@field Left USpotLightComponent
---@field SM_FrontDomeLight UStaticMeshComponent
local AFrontDomeLight_2m_C = {}

---@param bOn boolean
function AFrontDomeLight_2m_C:ReceiveSetLightOn(bOn) end
---@param EntryPoint int32
function AFrontDomeLight_2m_C:ExecuteUbergraph_FrontDomeLight_2m(EntryPoint) end


