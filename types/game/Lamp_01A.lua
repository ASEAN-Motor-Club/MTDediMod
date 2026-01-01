---@meta

---@class ALamp_01A_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_01A_C = {}

function ALamp_01A_C:OnTurnOnChanged() end
function ALamp_01A_C:UserConstructionScript() end
function ALamp_01A_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_01A_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_01A_C:ExecuteUbergraph_Lamp_01A(EntryPoint) end


