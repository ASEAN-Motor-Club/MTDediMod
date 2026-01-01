---@meta

---@class AIT_Coolant_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Jerrycan UStaticMeshComponent
local AIT_Coolant_C = {}

function AIT_Coolant_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_Coolant_C:ExecuteUbergraph_IT_Coolant(EntryPoint) end


