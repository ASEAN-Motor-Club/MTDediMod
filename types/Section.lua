---@meta

---@class USection_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Content UNamedSlot
---@field SectionBG_01 USectionBG_01_C
---@field W_SubTitle UW_SubTitle_C
---@field SectionTitle FText
local USection_C = {}

---@param IsDesignTime boolean
function USection_C:PreConstruct(IsDesignTime) end
---@param EntryPoint int32
function USection_C:ExecuteUbergraph_Section(EntryPoint) end


