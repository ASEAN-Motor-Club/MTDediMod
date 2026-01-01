---@meta

---@class AMaja_Reefer_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Fan2 UStaticMeshComponent
---@field Fan4 UStaticMeshComponent
---@field Fan1 UStaticMeshComponent
---@field Fan3 UStaticMeshComponent
---@field ACBlow UAudioComponent
---@field Diesel UAudioComponent
---@field MTLightControl UMTLightControlComponent
---@field MTInteractable UMTInteractableComponent
---@field TrailerRef UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
---@field Timeline_Rotation_DA051F9A4C6AF1CE37807AB37DD34C54 float
---@field Timeline__Direction_DA051F9A4C6AF1CE37807AB37DD34C54 ETimelineDirection::Type
---@field Timeline UTimelineComponent
local AMaja_Reefer_C = {}

function AMaja_Reefer_C:Timeline__FinishedFunc() end
function AMaja_Reefer_C:Timeline__UpdateFunc() end
---@param DeltaSeconds float
function AMaja_Reefer_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AMaja_Reefer_C:ExecuteUbergraph_Maja_Reefer(EntryPoint) end


