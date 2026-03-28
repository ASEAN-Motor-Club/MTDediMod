---@meta

---@class ALogSupply_Oak_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ALogSupply_Oak_C = {}

---@param bShow boolean
function ALogSupply_Oak_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ALogSupply_Oak_C:ExecuteUbergraph_LogSupply_Oak(EntryPoint) end


