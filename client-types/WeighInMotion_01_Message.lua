---@meta

---@class AWeighInMotion_01_Message_C : AMTWeighInMotion
---@field UberGraphFrame FPointerToUberGraphFrame
local AWeighInMotion_01_Message_C = {}

---@param OtherActor AActor
function AWeighInMotion_01_Message_C:ReceiveActorBeginOverlap(OtherActor) end
---@param EntryPoint int32
function AWeighInMotion_01_Message_C:ExecuteUbergraph_WeighInMotion_01_Message(EntryPoint) end


