---@meta

---@class USettingsTemplate_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field BackButton UW_BackButton_C
---@field Button_0 UNamedSlot
---@field Button_1 UNamedSlot
---@field Control_0 UNamedSlot
---@field Control_1 UNamedSlot
---@field Control_2 UNamedSlot
---@field Control_3 UNamedSlot
---@field Control_4 UNamedSlot
---@field Control_5 UNamedSlot
---@field Control_6 UNamedSlot
---@field Control_7 UNamedSlot
---@field Control_8 UNamedSlot
---@field Control_9 UNamedSlot
---@field Label_0 UNamedSlot
---@field Label_1 UNamedSlot
---@field Label_2 UNamedSlot
---@field Label_3 UNamedSlot
---@field Label_4 UNamedSlot
---@field Label_5 UNamedSlot
---@field Label_6 UNamedSlot
---@field Label_7 UNamedSlot
---@field Label_8 UNamedSlot
---@field Label_9 UNamedSlot
---@field MenuBG UFullScreenMenuBG1_C
---@field MenuTitleTextBlock UTextBlock
---@field MenuTitle FText
local USettingsTemplate_C = {}

---@param Navigation EUINavigation
---@return UWidget
function USettingsTemplate_C:DoCustomNavigation_ToControlButton(Navigation) end
---@param Navigation EUINavigation
---@return UWidget
function USettingsTemplate_C:DoCustomNavigation_ToBackButton(Navigation) end
---@param IsDesignTime boolean
function USettingsTemplate_C:PreConstruct(IsDesignTime) end
function USettingsTemplate_C:Construct() end
function USettingsTemplate_C:BndEvt__BackButton_K2Node_ComponentBoundEvent_0_OnMenuButtonClickedEvent__DelegateSignature() end
---@param EntryPoint int32
function USettingsTemplate_C:ExecuteUbergraph_SettingsTemplate(EntryPoint) end


