---@meta

---@class AContainerDropper_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AContainerDropper_C = {}

---@param bShow boolean
function AContainerDropper_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AContainerDropper_C:ExecuteUbergraph_ContainerDropper(EntryPoint) end


