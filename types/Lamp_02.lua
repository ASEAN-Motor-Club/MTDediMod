---@meta

---@class ALamp_02_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_02_C = {}

function ALamp_02_C:OnTurnOnChanged() end
function ALamp_02_C:UserConstructionScript() end
function ALamp_02_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_02_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_02_C:ExecuteUbergraph_Lamp_02(EntryPoint) end


