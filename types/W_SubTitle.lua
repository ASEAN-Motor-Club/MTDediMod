---@meta

---@class UW_SubTitle_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field TextBlock_70 UTextBlock
---@field TitleText FText
local UW_SubTitle_C = {}

---@param Text FText
function UW_SubTitle_C:SetTitleText(Text) end
---@param IsDesignTime boolean
function UW_SubTitle_C:PreConstruct(IsDesignTime) end
---@param EntryPoint int32
function UW_SubTitle_C:ExecuteUbergraph_W_SubTitle(EntryPoint) end


