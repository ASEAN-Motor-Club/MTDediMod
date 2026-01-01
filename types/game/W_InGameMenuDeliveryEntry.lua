---@meta

---@class UW_InGameMenuDeliveryEntry_C : UDeliveryMissionListEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MenuBG3_NoRound_C_0 UMenuBG3_NoRound_C
local UW_InGameMenuDeliveryEntry_C = {}

---@return FSlateColor
function UW_InGameMenuDeliveryEntry_C:Get_MoneyBonusTextBlock_ColorAndOpacity() end
function UW_InGameMenuDeliveryEntry_C:Construct() end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_InGameMenuDeliveryEntry_C:Tick(MyGeometry, InDeltaTime) end
---@param bIsSelected boolean
function UW_InGameMenuDeliveryEntry_C:BP_OnItemSelectionChanged(bIsSelected) end
---@param ListItemObject UObject
function UW_InGameMenuDeliveryEntry_C:OnListItemObjectSet(ListItemObject) end
---@param EntryPoint int32
function UW_InGameMenuDeliveryEntry_C:ExecuteUbergraph_W_InGameMenuDeliveryEntry(EntryPoint) end


