---@meta

---@class AMine_CopperOre_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AMine_CopperOre_C = {}

---@param bShow boolean
function AMine_CopperOre_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AMine_CopperOre_C:ExecuteUbergraph_Mine_CopperOre(EntryPoint) end


