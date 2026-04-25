---@meta

---@class ALiquidSupplier_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_Bld_Silo_Small_01 UStaticMeshComponent
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ALiquidSupplier_C = {}

---@param bShow boolean
function ALiquidSupplier_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ALiquidSupplier_C:ExecuteUbergraph_LiquidSupplier(EntryPoint) end


