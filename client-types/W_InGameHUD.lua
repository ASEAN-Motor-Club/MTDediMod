---@meta

---@class UW_InGameHUD_C : UInGameHUDWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field ShowSystemMessage UWidgetAnimation
---@field Border1 UBorder
---@field FireImage UImage
---@field MenuBG2_RoundHighlight_C_0 UMenuBG2_RoundHighlight_C
---@field MenuBG3_NoRound UMenuBG3_NoRound_C
---@field MenuBG_NoRound_Highlight UMenuBG_NoRound_Highlight_C
---@field MenuBG_NoRound_Highlight_C UMenuBG_NoRound_Highlight_C
---@field MenuBG_NoRound_Highlight_C_0 UMenuBG_NoRound_Highlight_C
---@field RaceLapsWidgetBP URaceLapsWidgetBP_C
---@field RacePositionWidgetBP URacePositionWidgetBP_C
---@field W_CharacterFrame UW_CharacterFrame_C
local UW_InGameHUD_C = {}

function UW_InGameHUD_C:ReceiveShowSystemMessage() end
---@param EntryPoint int32
function UW_InGameHUD_C:ExecuteUbergraph_W_InGameHUD(EntryPoint) end


