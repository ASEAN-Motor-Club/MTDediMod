---@meta

---@class ALamp_11_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field bIsTurnedOn boolean
local ALamp_11_C = {}

function ALamp_11_C:OnTurnOnChanged() end
function ALamp_11_C:UserConstructionScript() end
function ALamp_11_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ALamp_11_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALamp_11_C:ExecuteUbergraph_Lamp_11(EntryPoint) end


