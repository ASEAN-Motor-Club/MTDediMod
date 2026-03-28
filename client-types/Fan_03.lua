---@meta

---@class AFan_03_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_Prop_WallFan_Blades_01 UStaticMeshComponent
---@field SM_Prop_WallFan_Top_01 UStaticMeshComponent
local AFan_03_C = {}

---@param DeltaSeconds float
function AFan_03_C:ReceiveTick(DeltaSeconds) end
function AFan_03_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AFan_03_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AFan_03_C:ExecuteUbergraph_Fan_03(EntryPoint) end


