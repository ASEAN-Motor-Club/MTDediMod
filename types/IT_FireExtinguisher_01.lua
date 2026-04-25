---@meta

---@class AIT_FireExtinguisher_01_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Nozzle UStaticMeshComponent
---@field MTWaterSpray UMTWaterSprayComponent
local AIT_FireExtinguisher_01_C = {}

function AIT_FireExtinguisher_01_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_FireExtinguisher_01_C:ExecuteUbergraph_IT_FireExtinguisher_01(EntryPoint) end


