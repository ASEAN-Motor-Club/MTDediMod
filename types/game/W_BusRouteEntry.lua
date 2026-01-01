---@meta

---@class UW_BusRouteEntry_C : UBusRouteEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
local UW_BusRouteEntry_C = {}

function UW_BusRouteEntry_C:Construct() end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_BusRouteEntry_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UW_BusRouteEntry_C:ExecuteUbergraph_W_BusRouteEntry(EntryPoint) end


