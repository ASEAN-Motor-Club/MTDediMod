---@meta

---@class AMine_LimestoneRockQuarry_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AMine_LimestoneRockQuarry_C = {}

---@param bShow boolean
function AMine_LimestoneRockQuarry_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AMine_LimestoneRockQuarry_C:ExecuteUbergraph_Mine_LimestoneRockQuarry(EntryPoint) end


