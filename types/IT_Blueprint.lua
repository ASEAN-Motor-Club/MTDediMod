---@meta

---@class AIT_Blueprint_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Hook UStaticMeshComponent
local AIT_Blueprint_C = {}

function AIT_Blueprint_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_Blueprint_C:ExecuteUbergraph_IT_Blueprint(EntryPoint) end


