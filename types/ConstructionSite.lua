---@meta

---@class AConstructionSite_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Billboard UBillboardComponent
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AConstructionSite_C = {}

---@param bShow boolean
function AConstructionSite_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AConstructionSite_C:ExecuteUbergraph_ConstructionSite(EntryPoint) end


