---@meta

---@class AFactory_Limestone_Drop_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Limestone_Drop_C = {}

---@param bShow boolean
function AFactory_Limestone_Drop_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Limestone_Drop_C:ExecuteUbergraph_Factory_Limestone_Drop(EntryPoint) end


