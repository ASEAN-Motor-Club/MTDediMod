---@meta

---@class ALamp_04__C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_04__C = {}

function ALamp_04__C:OnTurnOnChanged() end
function ALamp_04__C:UserConstructionScript() end
function ALamp_04__C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_04__C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_04__C:ExecuteUbergraph_Lamp_04_(EntryPoint) end


