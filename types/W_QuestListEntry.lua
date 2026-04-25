---@meta

---@class UW_QuestListEntry_C : UQuestListEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Icon UWB_Icon_Base_C
local UW_QuestListEntry_C = {}

---@param IsDesignTime boolean
function UW_QuestListEntry_C:PreConstruct(IsDesignTime) end
function UW_QuestListEntry_C:Construct() end
---@param EntryPoint int32
function UW_QuestListEntry_C:ExecuteUbergraph_W_QuestListEntry(EntryPoint) end


