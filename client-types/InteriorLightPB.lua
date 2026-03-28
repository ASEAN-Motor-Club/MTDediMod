---@meta

---@class AInteriorLightPB_C : AMTVehicleInteriorLight
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Light3 USpotLightComponent
---@field Light2 USpotLightComponent
---@field Light1 USpotLightComponent
---@field SM_FrontDomeLight UStaticMeshComponent
local AInteriorLightPB_C = {}

---@param bOn boolean
function AInteriorLightPB_C:ReceiveSetLightOn(bOn) end
---@param EntryPoint int32
function AInteriorLightPB_C:ExecuteUbergraph_InteriorLightPB(EntryPoint) end


