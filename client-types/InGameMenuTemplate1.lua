---@meta

---@class UInGameMenuTemplate1_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field BackButton UW_BackButton_C
---@field Background UFullScreenMenuBG1_C
---@field BackgroundBlur_58 UBackgroundBlur
---@field Button_0 UNamedSlot
---@field Button_1 UNamedSlot
---@field Button_2 UNamedSlot
---@field Button_3 UNamedSlot
---@field Button_4 UNamedSlot
---@field Button_5 UNamedSlot
---@field Button_6 UNamedSlot
---@field Button_7 UNamedSlot
---@field Button_8 UNamedSlot
---@field Button_9 UNamedSlot
---@field Content UNamedSlot
---@field LeftButtons UOverlay
---@field MenuBG UMenuBG1_Round_C
---@field MenuTitleTextBlock UTextBlock
---@field MoneyWidget UMoneyWidgetBP_C
---@field ShowBackButton boolean
---@field ShowBackground boolean
---@field ShowMoney boolean
---@field MenuTitle FText
---@field ShowLeftButtons boolean
local UInGameMenuTemplate1_C = {}

---@return ESlateVisibility
function UInGameMenuTemplate1_C:Get_LeftButtonsSizeBox_Visibility() end
---@return ESlateVisibility
function UInGameMenuTemplate1_C:Get_Background_Visibility_0() end
---@param Navigation EUINavigation
---@return UWidget
function UInGameMenuTemplate1_C:ToButton0(Navigation) end
---@param Navigation EUINavigation
---@return UWidget
function UInGameMenuTemplate1_C:ToContent(Navigation) end
---@return ESlateVisibility
function UInGameMenuTemplate1_C:Get_BackButton_Visibility_0() end
---@param IsDesignTime boolean
function UInGameMenuTemplate1_C:PreConstruct(IsDesignTime) end
function UInGameMenuTemplate1_C:Construct() end
function UInGameMenuTemplate1_C:BndEvt__BackButton_K2Node_ComponentBoundEvent_0_OnMenuButtonClickedEvent__DelegateSignature() end
---@param EntryPoint int32
function UInGameMenuTemplate1_C:ExecuteUbergraph_InGameMenuTemplate1(EntryPoint) end


