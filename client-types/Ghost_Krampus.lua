---@meta

---@class AGhost_Krampus_C : AMTAICharacter_C
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTGhost UMTGhostComponent
local AGhost_Krampus_C = {}

---@param OtherActor AActor
function AGhost_Krampus_C:ReceiveActorBeginOverlap(OtherActor) end
---@param EntryPoint int32
function AGhost_Krampus_C:ExecuteUbergraph_Ghost_Krampus(EntryPoint) end


