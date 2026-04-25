---@meta

---@class AExport_Coal_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AExport_Coal_C = {}

---@param bShow boolean
function AExport_Coal_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AExport_Coal_C:ExecuteUbergraph_Export_Coal(EntryPoint) end


