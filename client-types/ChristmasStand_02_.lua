---@meta

---@class AChristmasStand_02__C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FX_CandleFlame_01 UParticleSystemComponent
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local AChristmasStand_02__C = {}

function AChristmasStand_02__C:OnTurnOnChanged() end
function AChristmasStand_02__C:UserConstructionScript() end
function AChristmasStand_02__C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function AChristmasStand_02__C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AChristmasStand_02__C:ExecuteUbergraph_ChristmasStand_02_(EntryPoint) end


