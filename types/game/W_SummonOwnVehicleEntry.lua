---@meta

---@class UW_SummonOwnVehicleEntry_C : USummonOwnVehicleEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
local UW_SummonOwnVehicleEntry_C = {}

---@param InFocusEvent FFocusEvent
function UW_SummonOwnVehicleEntry_C:OnRemovedFromFocusPath(InFocusEvent) end
---@param InFocusEvent FFocusEvent
function UW_SummonOwnVehicleEntry_C:OnAddedToFocusPath(InFocusEvent) end
---@param bIsSelected boolean
function UW_SummonOwnVehicleEntry_C:BP_OnItemSelectionChanged(bIsSelected) end
---@param EntryPoint int32
function UW_SummonOwnVehicleEntry_C:ExecuteUbergraph_W_SummonOwnVehicleEntry(EntryPoint) end


