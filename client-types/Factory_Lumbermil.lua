---@meta

---@class AFactory_Lumbermil_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Lumbermil_C = {}

---@param bShow boolean
function AFactory_Lumbermil_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Lumbermil_C:ExecuteUbergraph_Factory_Lumbermil(EntryPoint) end


