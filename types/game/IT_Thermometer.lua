---@meta

---@class AIT_Thermometer_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_Wep_Attachment_Torch_01 UStaticMeshComponent
local AIT_Thermometer_C = {}

function AIT_Thermometer_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_Thermometer_C:ExecuteUbergraph_IT_Thermometer(EntryPoint) end


