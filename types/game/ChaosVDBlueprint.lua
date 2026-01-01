---@meta

---@class UChaosVDRuntimeBlueprintLibrary : UBlueprintFunctionLibrary
local UChaosVDRuntimeBlueprintLibrary = {}

---@param WorldContext UObject
---@param InStartLocation FVector
---@param InVector FVector
---@param Tag FName
---@param Color FLinearColor
function UChaosVDRuntimeBlueprintLibrary:RecordDebugDrawVector(WorldContext, InStartLocation, InVector, Tag, Color) end
---@param WorldContext UObject
---@param InCenter FVector
---@param Radius float
---@param Tag FName
---@param Color FLinearColor
function UChaosVDRuntimeBlueprintLibrary:RecordDebugDrawSphere(WorldContext, InCenter, Radius, Tag, Color) end
---@param WorldContext UObject
---@param InStartLocation FVector
---@param InEndLocation FVector
---@param Tag FName
---@param Color FLinearColor
function UChaosVDRuntimeBlueprintLibrary:RecordDebugDrawLine(WorldContext, InStartLocation, InEndLocation, Tag, Color) end
---@param WorldContext UObject
---@param InBox FBox
---@param Tag FName
---@param Color FLinearColor
function UChaosVDRuntimeBlueprintLibrary:RecordDebugDrawBox(WorldContext, InBox, Tag, Color) end


