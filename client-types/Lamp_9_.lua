---@meta

---@class ALamp_9__C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_9__C = {}

function ALamp_9__C:OnTurnOnChanged() end
function ALamp_9__C:UserConstructionScript() end
function ALamp_9__C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_9__C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_9__C:ExecuteUbergraph_Lamp_9_(EntryPoint) end


