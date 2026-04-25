---@meta

---@class UBoundsModifier_C : UPCGBlueprintElement
---@field ['Use Absolute Scale'] boolean
---@field BoundsMinScale FVector
---@field BoundsMaxScale FVector
---@field Steepness float
local UBoundsModifier_C = {}

---@param InContext FPCGContext
---@param InData UPCGPointData
---@param InPoint FPCGPoint
---@param OutPoint FPCGPoint
---@param OutMetadata UPCGMetadata
---@param Iteration int64
---@return boolean
function UBoundsModifier_C:PointLoopBody(InContext, InData, InPoint, OutPoint, OutMetadata, Iteration) end
---@param InContext FPCGContext
---@param Input FPCGDataCollection
---@param Output FPCGDataCollection
function UBoundsModifier_C:ExecuteWithContext(InContext, Input, Output) end


