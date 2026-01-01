---@meta

---@class A_Base_RotatingLight_01_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SpotLight USpotLightComponent
---@field Light UStaticMeshComponent
---@field MTInteractable UMTInteractableComponent
---@field MTLightControl UMTLightControlComponent
---@field Case UStaticMeshComponent
---@field Scene USceneComponent
local A_Base_RotatingLight_01_C = {}

function A_Base_RotatingLight_01_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function A_Base_RotatingLight_01_C:ReceiveTick(DeltaSeconds) end
---@param EndPlayReason EEndPlayReason::Type
function A_Base_RotatingLight_01_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function A_Base_RotatingLight_01_C:ExecuteUbergraph__Base_RotatingLight_01(EntryPoint) end


