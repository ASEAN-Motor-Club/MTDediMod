---@meta

---@class AProxy_AeroWing_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTInteractable UMTInteractableComponent
---@field MTLightControl UMTLightControlComponent
---@field AeroWingF UStaticMeshComponent
---@field AeroWingU UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
local AProxy_AeroWing_C = {}

---@param DeltaSeconds float
function AProxy_AeroWing_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AProxy_AeroWing_C:ExecuteUbergraph_Proxy_AeroWing(EntryPoint) end


