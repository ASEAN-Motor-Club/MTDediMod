---@meta

---@class UGaragePartEntryWidgetBP_C : UGaragePartEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
local UGaragePartEntryWidgetBP_C = {}

---@param MyGeometry FGeometry
---@param InDeltaTime float
function UGaragePartEntryWidgetBP_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UGaragePartEntryWidgetBP_C:ExecuteUbergraph_GaragePartEntryWidgetBP(EntryPoint) end


