---@meta

---@class ARefinery_Fuel_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ARefinery_Fuel_C = {}

---@param bShow boolean
function ARefinery_Fuel_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ARefinery_Fuel_C:ExecuteUbergraph_Refinery_Fuel(EntryPoint) end


