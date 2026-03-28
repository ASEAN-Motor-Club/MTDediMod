---@meta

---@class AIT_Cone_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Cone UStaticMeshComponent
local AIT_Cone_C = {}

function AIT_Cone_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_Cone_C:ExecuteUbergraph_IT_Cone(EntryPoint) end


