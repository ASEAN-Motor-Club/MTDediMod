---@meta

---@class ASpikePad_01_C : AMTSpikePad
---@field UberGraphFrame FPointerToUberGraphFrame
---@field OverlapBox UBoxComponent
---@field SM_Prop_Barrier_SpikePad_Spikes_03 UStaticMeshComponent
---@field SM_Prop_Barrier_SpikePad_03 UStaticMeshComponent
local ASpikePad_01_C = {}

---@param OtherActor AActor
function ASpikePad_01_C:ReceiveActorBeginOverlap(OtherActor) end
---@param EntryPoint int32
function ASpikePad_01_C:ExecuteUbergraph_SpikePad_01(EntryPoint) end


