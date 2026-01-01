---@meta

---@class AInvisibleLight_Base_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field DefaultSceneRoot USceneComponent
---@field bIsTurnedOn boolean
---@field LightMaterialIndex int32
local AInvisibleLight_Base_C = {}

function AInvisibleLight_Base_C:OnTurnOnChanged() end
function AInvisibleLight_Base_C:UserConstructionScript() end
function AInvisibleLight_Base_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function AInvisibleLight_Base_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AInvisibleLight_Base_C:ExecuteUbergraph_InvisibleLight_Base(EntryPoint) end


