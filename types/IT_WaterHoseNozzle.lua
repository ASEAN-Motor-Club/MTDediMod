---@meta

---@class AIT_WaterHoseNozzle_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Nozzle UStaticMeshComponent
---@field MTWaterSpray UMTWaterSprayComponent
local AIT_WaterHoseNozzle_C = {}

function AIT_WaterHoseNozzle_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_WaterHoseNozzle_C:ExecuteUbergraph_IT_WaterHoseNozzle(EntryPoint) end


