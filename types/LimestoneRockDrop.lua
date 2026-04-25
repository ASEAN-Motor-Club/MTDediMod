---@meta

---@class ALimestoneRockDrop_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ALimestoneRockDrop_C = {}

---@param bShow boolean
function ALimestoneRockDrop_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ALimestoneRockDrop_C:ExecuteUbergraph_LimestoneRockDrop(EntryPoint) end


