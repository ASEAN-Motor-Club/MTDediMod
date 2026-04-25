---@meta

---@class AIT_CargoStrap_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_Wep_Attachment_Torch_02 UStaticMeshComponent
local AIT_CargoStrap_C = {}

function AIT_CargoStrap_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_CargoStrap_C:ExecuteUbergraph_IT_CargoStrap(EntryPoint) end


