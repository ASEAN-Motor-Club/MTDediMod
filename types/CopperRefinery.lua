---@meta

---@class ACopperRefinery_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ACopperRefinery_C = {}

---@param bShow boolean
function ACopperRefinery_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ACopperRefinery_C:ExecuteUbergraph_CopperRefinery(EntryPoint) end


