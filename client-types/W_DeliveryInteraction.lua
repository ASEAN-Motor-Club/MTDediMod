---@meta

---@class UW_DeliveryInteraction_C : UDeliveryMissionInteractionWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field CancelButton UW_BackButton_C
---@field ListBG UItemBG_C
---@field MenuBG1_Round UMenuBG1_Round_C
---@field MenuBG1_Round_1 UMenuBG1_Round_C
---@field MenuBG1_Round_114 UMenuBG1_Round_C
---@field MenuBG3_BlurOnly UMenuBG3_BlurOnly_C
---@field MenuBG3_BlurOnly_C_0 UMenuBG3_BlurOnly_C
---@field PaymentScaleHelpButton UW_Button_C
---@field Title UW_PopupTitle_C
---@field W_Title_1 UW_Title_C
---@field W_Title_2 UW_Title_C
---@field W_Title_3 UW_Title_C
---@field W_Title_4 UW_Title_C
---@field W_Title_177 UW_Title_C
local UW_DeliveryInteraction_C = {}

function UW_DeliveryInteraction_C:Construct() end
function UW_DeliveryInteraction_C:BndEvt__CancelButton_K2Node_ComponentBoundEvent_0_MTButtonClickedEvent__DelegateSignature() end
---@param Title FText
function UW_DeliveryInteraction_C:SetTitle(Title) end
function UW_DeliveryInteraction_C:BndEvt__W_DeliveryInteraction_PaymentScaleHelpButton_K2Node_ComponentBoundEvent_1_MTButtonEvent__DelegateSignature() end
---@param EntryPoint int32
function UW_DeliveryInteraction_C:ExecuteUbergraph_W_DeliveryInteraction(EntryPoint) end


