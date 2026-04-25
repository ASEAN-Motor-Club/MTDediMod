---@meta

---@class AExport_Harbor_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AExport_Harbor_C = {}

---@param bShow boolean
function AExport_Harbor_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AExport_Harbor_C:ExecuteUbergraph_Export_Harbor(EntryPoint) end


