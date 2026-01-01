---@meta

---@class ALamp_8__C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_8__C = {}

function ALamp_8__C:OnTurnOnChanged() end
function ALamp_8__C:UserConstructionScript() end
function ALamp_8__C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_8__C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_8__C:ExecuteUbergraph_Lamp_8_(EntryPoint) end


