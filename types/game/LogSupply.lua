---@meta

---@class ALogSupply_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ALogSupply_C = {}

---@param bShow boolean
function ALogSupply_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ALogSupply_C:ExecuteUbergraph_LogSupply(EntryPoint) end


