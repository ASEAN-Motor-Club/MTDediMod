---@meta

---@class UW_DestinationMarker2_C : UARMarkerWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Bar UImage
local UW_DestinationMarker2_C = {}

---@param IsDesignTime boolean
function UW_DestinationMarker2_C:PreConstruct(IsDesignTime) end
---@param IconType EMTIconType
---@param bInDisabled boolean
function UW_DestinationMarker2_C:ReceiveSetIconType(IconType, bInDisabled) end
---@param EntryPoint int32
function UW_DestinationMarker2_C:ExecuteUbergraph_W_DestinationMarker2(EntryPoint) end


