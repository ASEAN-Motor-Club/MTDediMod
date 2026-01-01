---@meta

---@class ARaceEventSection_C : AMotorTownRaceSection
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Box UBoxComponent
---@field Cube UStaticMeshComponent
---@field Scene USceneComponent
local ARaceEventSection_C = {}

---@param bActive boolean
function ARaceEventSection_C:SetActiveGate(bActive) end
---@param bCheckered boolean
function ARaceEventSection_C:SetCheckeredFlag(bCheckered) end
---@param Alpha float
function ARaceEventSection_C:SetGateAlpha(Alpha) end
---@param EntryPoint int32
function ARaceEventSection_C:ExecuteUbergraph_RaceEventSection(EntryPoint) end


