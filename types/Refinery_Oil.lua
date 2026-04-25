---@meta

---@class ARefinery_Oil_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ARefinery_Oil_C = {}

---@param bShow boolean
function ARefinery_Oil_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ARefinery_Oil_C:ExecuteUbergraph_Refinery_Oil(EntryPoint) end


