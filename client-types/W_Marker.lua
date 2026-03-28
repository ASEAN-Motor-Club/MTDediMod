---@meta

---@class UW_Marker_C : UARMarkerWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Bar UImage
local UW_Marker_C = {}

---@param IsDesignTime boolean
function UW_Marker_C:PreConstruct(IsDesignTime) end
---@param IconType EMTIconType
---@param bInDisabled boolean
function UW_Marker_C:ReceiveSetIconType(IconType, bInDisabled) end
---@param EntryPoint int32
function UW_Marker_C:ExecuteUbergraph_W_Marker(EntryPoint) end


