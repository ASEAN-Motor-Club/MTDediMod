---@meta

---@class UEmptyTemplate_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field BackButton UW_BackButton_C
---@field Background UFullScreenMenuBG1_C
---@field Blur UBackgroundBlur
---@field Content UNamedSlot
---@field MenuTitleTextBlock UTextBlock
---@field MoneyWidget UMoneyWidgetBP_C
---@field ShowBackButton boolean
---@field ShowBackground boolean
---@field ShowMoney boolean
---@field bUseBlur boolean
---@field MenuTitle FText
---@field OnCustomBack FEmptyTemplate_COnCustomBack
---@field bCustomBackHandler boolean
local UEmptyTemplate_C = {}

---@return ESlateVisibility
function UEmptyTemplate_C:Get_Background_Visibility_0() end
---@param Navigation EUINavigation
---@return UWidget
function UEmptyTemplate_C:ToButton0(Navigation) end
---@param Navigation EUINavigation
---@return UWidget
function UEmptyTemplate_C:ToContent(Navigation) end
---@return ESlateVisibility
function UEmptyTemplate_C:Get_BackButton_Visibility_0() end
---@param IsDesignTime boolean
function UEmptyTemplate_C:PreConstruct(IsDesignTime) end
function UEmptyTemplate_C:Construct() end
function UEmptyTemplate_C:BndEvt__BackButton_K2Node_ComponentBoundEvent_0_OnMenuButtonClickedEvent__DelegateSignature() end
---@param EntryPoint int32
function UEmptyTemplate_C:ExecuteUbergraph_EmptyTemplate(EntryPoint) end
function UEmptyTemplate_C:OnCustomBack__DelegateSignature() end


