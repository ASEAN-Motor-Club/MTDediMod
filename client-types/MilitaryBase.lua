---@meta

---@class AMilitaryBase_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AMilitaryBase_C = {}

---@param bShow boolean
function AMilitaryBase_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AMilitaryBase_C:ExecuteUbergraph_MilitaryBase(EntryPoint) end


