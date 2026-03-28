---@meta

---@class ALamp_09_B__C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_09_B__C = {}

function ALamp_09_B__C:OnTurnOnChanged() end
function ALamp_09_B__C:UserConstructionScript() end
function ALamp_09_B__C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_09_B__C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_09_B__C:ExecuteUbergraph_Lamp_09_B_(EntryPoint) end


