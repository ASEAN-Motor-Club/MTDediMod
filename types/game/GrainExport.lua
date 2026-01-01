---@meta

---@class AGrainExport_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AGrainExport_C = {}

---@param bShow boolean
function AGrainExport_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AGrainExport_C:ExecuteUbergraph_GrainExport(EntryPoint) end


