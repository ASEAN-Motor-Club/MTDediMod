---@meta

---@class AFactory_Plastic_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Plastic_C = {}

---@param bShow boolean
function AFactory_Plastic_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Plastic_C:ExecuteUbergraph_Factory_Plastic(EntryPoint) end


