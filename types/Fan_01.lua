---@meta

---@class AFan_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_Prop_Fan_01_Propeller UStaticMeshComponent
---@field SM_Prop_Fan_01_Casing UStaticMeshComponent
local AFan_01_C = {}

---@param DeltaSeconds float
function AFan_01_C:ReceiveTick(DeltaSeconds) end
function AFan_01_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AFan_01_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AFan_01_C:ExecuteUbergraph_Fan_01(EntryPoint) end


