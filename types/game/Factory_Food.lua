---@meta

---@class AFactory_Food_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Food_C = {}

---@param bShow boolean
function AFactory_Food_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Food_C:ExecuteUbergraph_Factory_Food(EntryPoint) end


