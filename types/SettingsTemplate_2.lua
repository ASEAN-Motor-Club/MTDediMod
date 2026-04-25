---@meta

---@class USettingsTemplate_2_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field BackButton UW_BackButton_C
---@field BottomBotton UNamedSlot
---@field Button_0 UNamedSlot
---@field Control_0 UNamedSlot
---@field HelpTextBlock URichTextBlock
---@field HelpTextOverlay UOverlay
---@field ItemBG UItemBG_C
---@field LeftWindow UNamedSlot
---@field MenuBG UFullScreenMenuBG1_C
---@field MenuBG1 UMenuBG1_Round_C
---@field MenuTitleTextBlock UTextBlock
---@field MenuTitle FText
local USettingsTemplate_2_C = {}

---@return FText
function USettingsTemplate_2_C:Get_HelpTextBlock_Text() end
---@param Navigation EUINavigation
---@return UWidget
function USettingsTemplate_2_C:DoCustomNavigation_ToControlButton(Navigation) end
---@param Navigation EUINavigation
---@return UWidget
function USettingsTemplate_2_C:DoCustomNavigation_ToBackButton(Navigation) end
---@param IsDesignTime boolean
function USettingsTemplate_2_C:PreConstruct(IsDesignTime) end
function USettingsTemplate_2_C:Construct() end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function USettingsTemplate_2_C:Tick(MyGeometry, InDeltaTime) end
function USettingsTemplate_2_C:BndEvt__BackButton_K2Node_ComponentBoundEvent_0_OnMenuButtonClickedEvent__DelegateSignature() end
---@param EntryPoint int32
function USettingsTemplate_2_C:ExecuteUbergraph_SettingsTemplate_2(EntryPoint) end


