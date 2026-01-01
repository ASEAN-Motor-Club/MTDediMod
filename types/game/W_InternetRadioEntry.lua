---@meta

---@class UW_InternetRadioEntry_C : UInternetRadioEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Background UListItemBG_01_C
local UW_InternetRadioEntry_C = {}

---@param ListItemObject UObject
function UW_InternetRadioEntry_C:OnListItemObjectSet(ListItemObject) end
---@param bIsSelected boolean
function UW_InternetRadioEntry_C:BP_OnItemSelectionChanged(bIsSelected) end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_InternetRadioEntry_C:Tick(MyGeometry, InDeltaTime) end
function UW_InternetRadioEntry_C:Construct() end
---@param EntryPoint int32
function UW_InternetRadioEntry_C:ExecuteUbergraph_W_InternetRadioEntry(EntryPoint) end


