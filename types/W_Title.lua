---@meta

---@class UW_Title_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Border_24 UBorder
---@field TextBlock_70 UTextBlock
---@field TitleText FText
local UW_Title_C = {}

---@param Text FText
function UW_Title_C:SetTitleText(Text) end
---@param IsDesignTime boolean
function UW_Title_C:PreConstruct(IsDesignTime) end
---@param EntryPoint int32
function UW_Title_C:ExecuteUbergraph_W_Title(EntryPoint) end


