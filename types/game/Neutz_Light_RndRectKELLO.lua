---@meta

---@class ANeutz_Light_RndRectKELLO_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Cover UStaticMeshComponent
---@field MountColl1 UBoxComponent
---@field MTInteractable UMTInteractableComponent
---@field MountColl UBoxComponent
---@field MTLightControl UMTLightControlComponent
---@field DefaultSceneRoot USceneComponent
local ANeutz_Light_RndRectKELLO_C = {}

---@param DeltaSeconds float
function ANeutz_Light_RndRectKELLO_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ANeutz_Light_RndRectKELLO_C:ExecuteUbergraph_Neutz_Light_RndRectKELLO(EntryPoint) end


