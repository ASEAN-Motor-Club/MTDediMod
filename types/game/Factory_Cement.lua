---@meta

---@class AFactory_Cement_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Cement_C = {}

---@param bShow boolean
function AFactory_Cement_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Cement_C:ExecuteUbergraph_Factory_Cement(EntryPoint) end


