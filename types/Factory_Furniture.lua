---@meta

---@class AFactory_Furniture_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Furniture_C = {}

---@param bShow boolean
function AFactory_Furniture_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Furniture_C:ExecuteUbergraph_Factory_Furniture(EntryPoint) end


