---@meta

---@class AIT_SuperFlashlight_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SpotLight USpotLightComponent
---@field SM_Wep_Attachment_Torch_02 UStaticMeshComponent
local AIT_SuperFlashlight_C = {}

function AIT_SuperFlashlight_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_SuperFlashlight_C:ExecuteUbergraph_IT_SuperFlashlight(EntryPoint) end


