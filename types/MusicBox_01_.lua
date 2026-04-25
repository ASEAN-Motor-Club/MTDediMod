---@meta

---@class AMusicBox_01__C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_Prop_Music_Box_01_Ballerina_01 UStaticMeshComponent
---@field SM_Prop_Music_Box_01_Stand_01 UStaticMeshComponent
---@field SM_Prop_Music_Box_01_Handle_01 UStaticMeshComponent
---@field SM_Prop_Music_Box_01_Lid_01 UStaticMeshComponent
local AMusicBox_01__C = {}

---@param DeltaSeconds float
function AMusicBox_01__C:ReceiveTick(DeltaSeconds) end
function AMusicBox_01__C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AMusicBox_01__C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AMusicBox_01__C:ExecuteUbergraph_MusicBox_01_(EntryPoint) end


