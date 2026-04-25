---@meta

---@class ACopperConcentrator_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ACopperConcentrator_C = {}

---@param bShow boolean
function ACopperConcentrator_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ACopperConcentrator_C:ExecuteUbergraph_CopperConcentrator(EntryPoint) end


