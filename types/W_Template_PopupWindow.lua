---@meta

---@class UW_Template_PopupWindow_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field CloseButton UW_CloseButton_C
---@field Content UNamedSlot
---@field DialogueTitleBG_C_0 UDialogueTitleBG_C
---@field PopupVerticalBox UVerticalBox
---@field TitleOverlay UOverlay
---@field TitleTextBlock UTextBlock
---@field TitleText FText
---@field bShowCloseButton boolean
local UW_Template_PopupWindow_C = {}

---@param IsDesignTime boolean
function UW_Template_PopupWindow_C:PreConstruct(IsDesignTime) end
function UW_Template_PopupWindow_C:BndEvt__W_Template_PopupWindow_CloseButton_K2Node_ComponentBoundEvent_1_MTButtonEvent__DelegateSignature() end
---@param New_Title_Text FText
UW_Template_PopupWindow_C['Set New Title Text'] = function(self, New_Title_Text) end
function UW_Template_PopupWindow_C:OnInitialized() end
UW_Template_PopupWindow_C['Focus Close Button'] = function(self, ) end
---@param EntryPoint int32
function UW_Template_PopupWindow_C:ExecuteUbergraph_W_Template_PopupWindow(EntryPoint) end


