---@meta

---@class ALamp_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_01_C = {}

function ALamp_01_C:OnTurnOnChanged() end
function ALamp_01_C:UserConstructionScript() end
function ALamp_01_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_01_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_01_C:ExecuteUbergraph_Lamp_01(EntryPoint) end


