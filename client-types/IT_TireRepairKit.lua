---@meta

---@class AIT_TireRepairKit_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Mesh UStaticMeshComponent
local AIT_TireRepairKit_C = {}

function AIT_TireRepairKit_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_TireRepairKit_C:ExecuteUbergraph_IT_TireRepairKit(EntryPoint) end


