---@meta

---@class ASprinkler_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FX_Sprinkler UParticleSystemComponent
---@field IsRotation boolean
---@field IsTurnedOn boolean
local ASprinkler_01_C = {}

---@param DeltaSeconds float
function ASprinkler_01_C:ReceiveTick(DeltaSeconds) end
function ASprinkler_01_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function ASprinkler_01_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function ASprinkler_01_C:ExecuteUbergraph_Sprinkler_01(EntryPoint) end


