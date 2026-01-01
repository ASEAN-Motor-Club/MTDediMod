---@meta

---@class UW_PopupTitle_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field DialogueTitleBG_C_0 UDialogueTitleBG_C
---@field TitleOverlay UOverlay
---@field TitleTextBlock UTextBlock
---@field TitleText FText
local UW_PopupTitle_C = {}

---@param IsDesignTime boolean
function UW_PopupTitle_C:PreConstruct(IsDesignTime) end
---@param EntryPoint int32
function UW_PopupTitle_C:ExecuteUbergraph_W_PopupTitle(EntryPoint) end


