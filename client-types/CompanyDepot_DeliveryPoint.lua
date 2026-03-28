---@meta

---@class ACompanyDepot_DeliveryPoint_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ACompanyDepot_DeliveryPoint_C = {}

---@param bShow boolean
function ACompanyDepot_DeliveryPoint_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ACompanyDepot_DeliveryPoint_C:ExecuteUbergraph_CompanyDepot_DeliveryPoint(EntryPoint) end


