---@meta

---@class ANeutz_HornDoubleLeft_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Diesel_Horn UAudioComponent
---@field MTLightControl UMTLightControlComponent
---@field MTInteractable UMTInteractableComponent
---@field Horn UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
local ANeutz_HornDoubleLeft_C = {}

function ANeutz_HornDoubleLeft_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ANeutz_HornDoubleLeft_C:ReceiveTick(DeltaSeconds) end
---@param OtherActor AActor
function ANeutz_HornDoubleLeft_C:ReceiveActorBeginOverlap(OtherActor) end
---@param EntryPoint int32
function ANeutz_HornDoubleLeft_C:ExecuteUbergraph_Neutz_HornDoubleLeft(EntryPoint) end


