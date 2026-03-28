---@meta

---@class AStore_LiveFishRestaurant_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AStore_LiveFishRestaurant_C = {}

---@param bShow boolean
function AStore_LiveFishRestaurant_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AStore_LiveFishRestaurant_C:ExecuteUbergraph_Store_LiveFishRestaurant(EntryPoint) end


