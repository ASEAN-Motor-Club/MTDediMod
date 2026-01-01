---@meta

---@class AConstructionSite_HousingBuilding_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AConstructionSite_HousingBuilding_C = {}

---@param bShow boolean
function AConstructionSite_HousingBuilding_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AConstructionSite_HousingBuilding_C:ExecuteUbergraph_ConstructionSite_HousingBuilding(EntryPoint) end


