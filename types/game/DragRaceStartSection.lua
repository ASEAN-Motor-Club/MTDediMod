---@meta

---@class ADragRaceStartSection_C : AMotorTownRaceSection
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Box UBoxComponent
---@field Scene USceneComponent
local ADragRaceStartSection_C = {}

---@param bActive boolean
function ADragRaceStartSection_C:SetActiveGate(bActive) end
---@param bCheckered boolean
function ADragRaceStartSection_C:SetCheckeredFlag(bCheckered) end
---@param Alpha float
function ADragRaceStartSection_C:SetGateAlpha(Alpha) end
---@param EntryPoint int32
function ADragRaceStartSection_C:ExecuteUbergraph_DragRaceStartSection(EntryPoint) end


