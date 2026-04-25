---@meta

---@class UCreatePointsGrid_C : UPCGBlueprintElement
---@field GridExtents FVector
---@field ['Cell Size'] FVector
---@field GridCenterPosition FVector
---@field Local boolean
---@field ['Local Inverse Transform'] boolean
---@field Volume boolean
---@field ['Coordinate Plane Axes'] PCGCoordinatePlaneAxes::Type
---@field ['Context PCGSpatial Data'] UPCGSpatialData
---@field Increments FIntVector
---@field IncrementSize FVector
---@field CullPointsOutsideVolume boolean
local UCreatePointsGrid_C = {}

---@return FLinearColor
function UCreatePointsGrid_C:NodeColorOverride() end
---@return boolean
function UCreatePointsGrid_C:IsCacheableOverride() end
---@return FName
function UCreatePointsGrid_C:NodeTitleOverride() end
---@param InContext FPCGContext
---@param Iteration int64
---@param InA UPCGSpatialData
---@param InB UPCGSpatialData
---@param OutPoint FPCGPoint
---@param OutMetadata UPCGMetadata
---@return boolean
function UCreatePointsGrid_C:IterationLoopBody(InContext, Iteration, InA, InB, OutPoint, OutMetadata) end
---@param InContext FPCGContext
---@param Input FPCGDataCollection
---@param Output FPCGDataCollection
function UCreatePointsGrid_C:ExecuteWithContext(InContext, Input, Output) end


