---@meta

---@class AWindmill_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_Prop_Windmill_Blades_01 UStaticMeshComponent
---@field SM_Prop_Windmill_Top_01 UStaticMeshComponent
local AWindmill_01_C = {}

---@param DeltaSeconds float
function AWindmill_01_C:ReceiveTick(DeltaSeconds) end
function AWindmill_01_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AWindmill_01_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AWindmill_01_C:ExecuteUbergraph_Windmill_01(EntryPoint) end


