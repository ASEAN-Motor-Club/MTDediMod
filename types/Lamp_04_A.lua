---@meta

---@class ALamp_04_A_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_04_A_C = {}

function ALamp_04_A_C:OnTurnOnChanged() end
function ALamp_04_A_C:UserConstructionScript() end
function ALamp_04_A_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_04_A_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_04_A_C:ExecuteUbergraph_Lamp_04_A(EntryPoint) end


