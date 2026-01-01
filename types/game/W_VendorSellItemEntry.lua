---@meta

---@class UW_VendorSellItemEntry_C : UVendorSellItemEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
local UW_VendorSellItemEntry_C = {}

---@param bIsSelected boolean
function UW_VendorSellItemEntry_C:CustomEvent(bIsSelected) end
---@param ListItemObject UObject
function UW_VendorSellItemEntry_C:OnListItemObjectSet(ListItemObject) end
---@param EntryPoint int32
function UW_VendorSellItemEntry_C:ExecuteUbergraph_W_VendorSellItemEntry(EntryPoint) end


