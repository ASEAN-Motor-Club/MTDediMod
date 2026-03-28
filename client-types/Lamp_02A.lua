---@meta

---@class ALamp_02A_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_02A_C = {}

function ALamp_02A_C:OnTurnOnChanged() end
function ALamp_02A_C:UserConstructionScript() end
function ALamp_02A_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_02A_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_02A_C:ExecuteUbergraph_Lamp_02A(EntryPoint) end


