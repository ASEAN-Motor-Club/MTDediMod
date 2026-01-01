---@meta

---@class AIT_Flashlight_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SpotLight USpotLightComponent
---@field SM_Wep_Attachment_Torch_01 UStaticMeshComponent
local AIT_Flashlight_C = {}

function AIT_Flashlight_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_Flashlight_C:ExecuteUbergraph_IT_Flashlight(EntryPoint) end


