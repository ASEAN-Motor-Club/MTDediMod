---@meta

---@class AFactory_LimestoneProcessing_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_LimestoneProcessing_C = {}

---@param bShow boolean
function AFactory_LimestoneProcessing_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_LimestoneProcessing_C:ExecuteUbergraph_Factory_LimestoneProcessing(EntryPoint) end


