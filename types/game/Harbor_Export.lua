---@meta

---@class AHarbor_Export_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AHarbor_Export_C = {}

---@param bShow boolean
function AHarbor_Export_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AHarbor_Export_C:ExecuteUbergraph_Harbor_Export(EntryPoint) end


