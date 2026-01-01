---@meta

---@class UScaleByDensity_C : UPCGBlueprintElement
---@field ['Scale Min'] double
---@field ['Scale Max'] double
---@field ['Density Exp'] double
local UScaleByDensity_C = {}

---@param InContext FPCGContext
---@param InData UPCGPointData
---@param InPoint FPCGPoint
---@param OutPoint FPCGPoint
---@param OutMetadata UPCGMetadata
---@param Iteration int64
---@return boolean
function UScaleByDensity_C:PointLoopBody(InContext, InData, InPoint, OutPoint, OutMetadata, Iteration) end
---@param InContext FPCGContext
---@param Input FPCGDataCollection
---@param Output FPCGDataCollection
function UScaleByDensity_C:ExecuteWithContext(InContext, Input, Output) end


