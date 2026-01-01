---@meta

---@class AMaja_Police_RadarStatic_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Radar UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
local AMaja_Police_RadarStatic_C = {}

---@param DeltaSeconds float
function AMaja_Police_RadarStatic_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AMaja_Police_RadarStatic_C:ExecuteUbergraph_Maja_Police_RadarStatic(EntryPoint) end


