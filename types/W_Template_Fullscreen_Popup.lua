---@meta

---@class UW_Template_Fullscreen_Popup_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field CloseButton UW_CloseButton_C
---@field Content UNamedSlot
---@field DialogueTitleBG_C_0 UDialogueTitleBG_C
---@field FullScreenMenuBG1 UFullScreenMenuBG1_C
---@field PopupVerticalBox UVerticalBox
---@field TitleOverlay UOverlay
---@field TitleTextBlock UTextBlock
---@field TitleText FText
---@field bBackgroundImage boolean
---@field PopupSize FVector2D
local UW_Template_Fullscreen_Popup_C = {}

---@return ESlateVisibility
function UW_Template_Fullscreen_Popup_C:GetVisibility_0() end
---@param IsDesignTime boolean
function UW_Template_Fullscreen_Popup_C:PreConstruct(IsDesignTime) end
function UW_Template_Fullscreen_Popup_C:Construct() end
function UW_Template_Fullscreen_Popup_C:BndEvt__OKButton_K2Node_ComponentBoundEvent_0_OnMenuButtonClickedEvent__DelegateSignature() end
---@param New_Title_Text FText
UW_Template_Fullscreen_Popup_C['Set New Title Text'] = function(self, New_Title_Text) end
---@param EntryPoint int32
function UW_Template_Fullscreen_Popup_C:ExecuteUbergraph_W_Template_Fullscreen_Popup(EntryPoint) end


