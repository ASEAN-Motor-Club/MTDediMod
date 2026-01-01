---@meta

---@class ALamp_06__C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_06__C = {}

function ALamp_06__C:OnTurnOnChanged() end
function ALamp_06__C:UserConstructionScript() end
function ALamp_06__C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_06__C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_06__C:ExecuteUbergraph_Lamp_06_(EntryPoint) end


