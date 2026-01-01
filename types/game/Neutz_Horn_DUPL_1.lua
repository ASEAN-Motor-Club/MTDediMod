---@meta

---@class ANeutz_Horn_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Diesel_Horn UAudioComponent
---@field MTLightControl UMTLightControlComponent
---@field MTInteractable UMTInteractableComponent
---@field Horn UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
local ANeutz_Horn_C = {}

function ANeutz_Horn_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ANeutz_Horn_C:ReceiveTick(DeltaSeconds) end
---@param OtherActor AActor
function ANeutz_Horn_C:ReceiveActorBeginOverlap(OtherActor) end
---@param EntryPoint int32
function ANeutz_Horn_C:ExecuteUbergraph_Neutz_Horn(EntryPoint) end


