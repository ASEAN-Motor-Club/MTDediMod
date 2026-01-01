---@meta

---@class ANeutz_HornMusical_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Cue_Basuri UAudioComponent
---@field MTLightControl UMTLightControlComponent
---@field MTInteractable UMTInteractableComponent
---@field Horn UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
local ANeutz_HornMusical_C = {}

function ANeutz_HornMusical_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ANeutz_HornMusical_C:ReceiveTick(DeltaSeconds) end
---@param OtherActor AActor
function ANeutz_HornMusical_C:ReceiveActorBeginOverlap(OtherActor) end
---@param EntryPoint int32
function ANeutz_HornMusical_C:ExecuteUbergraph_Neutz_HornMusical(EntryPoint) end


