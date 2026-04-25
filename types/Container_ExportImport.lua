---@meta

---@class AContainer_ExportImport_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AContainer_ExportImport_C = {}

---@param bShow boolean
function AContainer_ExportImport_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AContainer_ExportImport_C:ExecuteUbergraph_Container_ExportImport(EntryPoint) end


