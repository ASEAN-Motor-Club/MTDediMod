---@meta

---@class ALamp_03_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_03_C = {}

function ALamp_03_C:OnTurnOnChanged() end
function ALamp_03_C:UserConstructionScript() end
function ALamp_03_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_03_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_03_C:ExecuteUbergraph_Lamp_03(EntryPoint) end


