---@meta

---@class AMine_Coal_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AMine_Coal_C = {}

---@param bShow boolean
function AMine_Coal_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AMine_Coal_C:ExecuteUbergraph_Mine_Coal(EntryPoint) end


