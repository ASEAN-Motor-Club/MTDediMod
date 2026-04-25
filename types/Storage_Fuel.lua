---@meta

---@class AStorage_Fuel_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AStorage_Fuel_C = {}

---@param bShow boolean
function AStorage_Fuel_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AStorage_Fuel_C:ExecuteUbergraph_Storage_Fuel(EntryPoint) end


