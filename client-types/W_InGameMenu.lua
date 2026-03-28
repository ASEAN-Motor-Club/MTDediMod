---@meta

---@class UW_InGameMenu_C : UInGameMenuWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field DemoInfo URichTextBlock
---@field HelpButton UW_Button_C
---@field InGameMenuTemplate UInGameMenuTemplate1_C
---@field Jobs UW_Button_C
---@field OptionButton UW_Button_C
---@field RadioButton UW_Button_C
---@field W_Admin UW_Admin_C
---@field W_CharacterInfo UW_CharacterInfo_Horizontal_C
---@field W_CompanyList UW_CompanyList_C
---@field W_EventList UW_EventList_C
---@field W_Leaderboard UW_Leaderboard_C
---@field W_MenuPlayerList UW_MenuPlayerList_C
---@field W_QuestList UW_QuestList_C
---@field W_TownState UW_TownState_C
local UW_InGameMenu_C = {}

---@return ESlateVisibility
function UW_InGameMenu_C:VisibleAtDrivingGameType() end
---@return ESlateVisibility
function UW_InGameMenu_C:Get_VehicleChange_Visibility_0() end
---@return ESlateVisibility
function UW_InGameMenu_C:Get_StartRaceButton_Visibility_0() end
function UW_InGameMenu_C:BndEvt__StartRaceButton_K2Node_ComponentBoundEvent_2_OnMenuButtonClickedEvent__DelegateSignature() end
function UW_InGameMenu_C:BndEvt__OptionButton_K2Node_ComponentBoundEvent_3_OnMenuButtonClickedEvent__DelegateSignature() end
function UW_InGameMenu_C:BndEvt__VehicleSettingButton_K2Node_ComponentBoundEvent_5_OnMenuButtonClickedEvent__DelegateSignature() end
function UW_InGameMenu_C:BndEvt__TimeAttackSettingButton_K2Node_ComponentBoundEvent_6_OnMenuButtonClickedEvent__DelegateSignature() end
function UW_InGameMenu_C:BndEvt__AutocrossSettingButton_K2Node_ComponentBoundEvent_7_OnMenuButtonClickedEvent__DelegateSignature() end
function UW_InGameMenu_C:BndEvt__Jobs_K2Node_ComponentBoundEvent_4_OnMenuButtonClickedEvent__DelegateSignature() end
function UW_InGameMenu_C:BndEvt__RadioButton_K2Node_ComponentBoundEvent_8_MTButtonClickedEvent__DelegateSignature() end
function UW_InGameMenu_C:Construct() end
function UW_InGameMenu_C:BndEvt__W_InGameMenu_HelpButton_K2Node_ComponentBoundEvent_0_MTButtonEvent__DelegateSignature() end
---@param EntryPoint int32
function UW_InGameMenu_C:ExecuteUbergraph_W_InGameMenu(EntryPoint) end


