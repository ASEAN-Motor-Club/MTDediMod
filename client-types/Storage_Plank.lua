---@meta

---@class AStorage_Plank_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AStorage_Plank_C = {}

---@param bShow boolean
function AStorage_Plank_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AStorage_Plank_C:ExecuteUbergraph_Storage_Plank(EntryPoint) end


