---@meta

---@class UW_GameUserSettings_C : UGameUserSettingsWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Assist UW_Button_C
---@field Control UW_Button_C
---@field Gameplay UW_Button_C
---@field Graphic UW_Button_C
---@field InGameMenuTemplate UInGameMenuTemplate1_C
---@field Sound UW_Button_C
local UW_GameUserSettings_C = {}

function UW_GameUserSettings_C:BndEvt__Graphic_K2Node_ComponentBoundEvent_1_OnMenuButtonClickedEvent__DelegateSignature() end
function UW_GameUserSettings_C:BndEvt__Control_K2Node_ComponentBoundEvent_0_OnMenuButtonClickedEvent__DelegateSignature() end
function UW_GameUserSettings_C:BndEvt__Sound_K2Node_ComponentBoundEvent_2_OnMenuButtonClickedEvent__DelegateSignature() end
function UW_GameUserSettings_C:BndEvt__Aid_K2Node_ComponentBoundEvent_3_MTButtonClickedEvent__DelegateSignature() end
function UW_GameUserSettings_C:BndEvt__Gameplay_K2Node_ComponentBoundEvent_4_MTButtonClickedEvent__DelegateSignature() end
---@param EntryPoint int32
function UW_GameUserSettings_C:ExecuteUbergraph_W_GameUserSettings(EntryPoint) end


