---@meta

---@class ALamp_10__C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FX_CandleFlame_01 UParticleSystemComponent
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_10__C = {}

function ALamp_10__C:OnTurnOnChanged() end
function ALamp_10__C:UserConstructionScript() end
function ALamp_10__C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_10__C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_10__C:ExecuteUbergraph_Lamp_10_(EntryPoint) end


