---@meta

---@class AProxy_TrailerRefri_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Audio UAudioComponent
---@field MTLightControl UMTLightControlComponent
---@field MTInteractable UMTInteractableComponent
---@field TrailerRef UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
local AProxy_TrailerRefri_C = {}

function AProxy_TrailerRefri_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function AProxy_TrailerRefri_C:ReceiveTick(DeltaSeconds) end
---@param OtherActor AActor
function AProxy_TrailerRefri_C:ReceiveActorBeginOverlap(OtherActor) end
---@param EntryPoint int32
function AProxy_TrailerRefri_C:ExecuteUbergraph_Proxy_TrailerRefri(EntryPoint) end


