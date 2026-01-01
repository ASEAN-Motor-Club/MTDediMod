---@meta

---@class UW_QuestFrameEntry_C : UQuestFrameEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Icon UWB_Icon_Base_C
local UW_QuestFrameEntry_C = {}

---@param IsDesignTime boolean
function UW_QuestFrameEntry_C:PreConstruct(IsDesignTime) end
function UW_QuestFrameEntry_C:Construct() end
---@param bIsDestination boolean
function UW_QuestFrameEntry_C:ReceiveSetAsDestination(bIsDestination) end
---@param EntryPoint int32
function UW_QuestFrameEntry_C:ExecuteUbergraph_W_QuestFrameEntry(EntryPoint) end


