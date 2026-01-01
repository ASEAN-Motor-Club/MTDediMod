---@meta

---@class AMine_IronOre_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AMine_IronOre_C = {}

---@param bShow boolean
function AMine_IronOre_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AMine_IronOre_C:ExecuteUbergraph_Mine_IronOre(EntryPoint) end


