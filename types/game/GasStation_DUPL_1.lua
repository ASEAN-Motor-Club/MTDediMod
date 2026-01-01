---@meta

---@class AGasStation_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AGasStation_C = {}

---@param bShow boolean
function AGasStation_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AGasStation_C:ExecuteUbergraph_GasStation(EntryPoint) end


