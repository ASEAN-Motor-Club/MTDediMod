---@meta

---@class ALiveFishSupplier_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ALiveFishSupplier_C = {}

---@param bShow boolean
function ALiveFishSupplier_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ALiveFishSupplier_C:ExecuteUbergraph_LiveFishSupplier(EntryPoint) end


