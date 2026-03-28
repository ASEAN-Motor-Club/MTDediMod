---@meta

---@class AIT_Jerrycan_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Jerrycan UStaticMeshComponent
local AIT_Jerrycan_C = {}

function AIT_Jerrycan_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_Jerrycan_C:ExecuteUbergraph_IT_Jerrycan(EntryPoint) end


