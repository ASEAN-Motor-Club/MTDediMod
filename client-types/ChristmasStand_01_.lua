---@meta

---@class AChristmasStand_01__C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FX_CandleFlame_01 UParticleSystemComponent
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local AChristmasStand_01__C = {}

function AChristmasStand_01__C:OnTurnOnChanged() end
function AChristmasStand_01__C:UserConstructionScript() end
function AChristmasStand_01__C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function AChristmasStand_01__C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AChristmasStand_01__C:ExecuteUbergraph_ChristmasStand_01_(EntryPoint) end


