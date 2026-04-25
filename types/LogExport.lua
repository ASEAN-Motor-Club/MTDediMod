---@meta

---@class ALogExport_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ALogExport_C = {}

---@param bShow boolean
function ALogExport_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ALogExport_C:ExecuteUbergraph_LogExport(EntryPoint) end


