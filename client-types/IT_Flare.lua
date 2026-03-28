---@meta

---@class AIT_Flare_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTComponentLOD UMTComponentLODComponent
---@field NS_Flare UNiagaraComponent
---@field Mesh UStaticMeshComponent
local AIT_Flare_C = {}

function AIT_Flare_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_Flare_C:ExecuteUbergraph_IT_Flare(EntryPoint) end


