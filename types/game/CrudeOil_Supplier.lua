---@meta

---@class ACrudeOil_Supplier_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ACrudeOil_Supplier_C = {}

---@param bShow boolean
function ACrudeOil_Supplier_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ACrudeOil_Supplier_C:ExecuteUbergraph_CrudeOil_Supplier(EntryPoint) end


