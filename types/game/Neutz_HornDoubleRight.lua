---@meta

---@class ANeutz_HornDoubleRight_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Diesel_Horn UAudioComponent
---@field MTLightControl UMTLightControlComponent
---@field MTInteractable UMTInteractableComponent
---@field Horn UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
local ANeutz_HornDoubleRight_C = {}

function ANeutz_HornDoubleRight_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ANeutz_HornDoubleRight_C:ReceiveTick(DeltaSeconds) end
---@param OtherActor AActor
function ANeutz_HornDoubleRight_C:ReceiveActorBeginOverlap(OtherActor) end
---@param EntryPoint int32
function ANeutz_HornDoubleRight_C:ExecuteUbergraph_Neutz_HornDoubleRight(EntryPoint) end


