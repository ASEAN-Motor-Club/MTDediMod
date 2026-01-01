---@meta

---@class AStore_SantaCabin_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AStore_SantaCabin_C = {}

---@param bShow boolean
function AStore_SantaCabin_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AStore_SantaCabin_C:ExecuteUbergraph_Store_SantaCabin(EntryPoint) end


