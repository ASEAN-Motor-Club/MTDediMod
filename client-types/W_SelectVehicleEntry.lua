---@meta

---@class UW_SelectVehicleEntry_C : USelectVehicleEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
local UW_SelectVehicleEntry_C = {}

---@param ListItemObject UObject
function UW_SelectVehicleEntry_C:OnListItemObjectSet(ListItemObject) end
---@param bIsSelected boolean
function UW_SelectVehicleEntry_C:BP_OnItemSelectionChanged(bIsSelected) end
---@param EntryPoint int32
function UW_SelectVehicleEntry_C:ExecuteUbergraph_W_SelectVehicleEntry(EntryPoint) end


