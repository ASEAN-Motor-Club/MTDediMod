---@meta

---@class ALamp_05__C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_05__C = {}

function ALamp_05__C:OnTurnOnChanged() end
function ALamp_05__C:UserConstructionScript() end
function ALamp_05__C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_05__C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_05__C:ExecuteUbergraph_Lamp_05_(EntryPoint) end


