---@meta

---@class ADomeLight_Large2Way_C : AMTVehicleInteriorLight
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Light USpotLightComponent
---@field SM_FrontDomeLight UStaticMeshComponent
local ADomeLight_Large2Way_C = {}

---@param bOn boolean
function ADomeLight_Large2Way_C:ReceiveSetLightOn(bOn) end
---@param EntryPoint int32
function ADomeLight_Large2Way_C:ExecuteUbergraph_DomeLight_Large2Way(EntryPoint) end


