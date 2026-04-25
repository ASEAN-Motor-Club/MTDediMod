---@meta

---@class AStore_Furniture_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AStore_Furniture_C = {}

---@param bShow boolean
function AStore_Furniture_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AStore_Furniture_C:ExecuteUbergraph_Store_Furniture(EntryPoint) end


