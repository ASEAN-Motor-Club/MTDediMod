---@meta

---@class ANeutz_Sign_TIRFold_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTLightControl UMTLightControlComponent
---@field MTInteractable UMTInteractableComponent
---@field Sign1 UStaticMeshComponent
---@field MountColl UBoxComponent
---@field Sign UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
---@field Timeline_fYvalue_A9DC25B44A1B9BB44B459DAF9AEDD81A float
---@field Timeline__Direction_A9DC25B44A1B9BB44B459DAF9AEDD81A ETimelineDirection::Type
---@field Timeline UTimelineComponent
local ANeutz_Sign_TIRFold_C = {}

function ANeutz_Sign_TIRFold_C:Timeline__FinishedFunc() end
function ANeutz_Sign_TIRFold_C:Timeline__UpdateFunc() end
---@param DeltaSeconds float
function ANeutz_Sign_TIRFold_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ANeutz_Sign_TIRFold_C:ExecuteUbergraph_Neutz_Sign_TIRFold(EntryPoint) end


