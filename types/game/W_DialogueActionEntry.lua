---@meta

---@class UW_DialogueActionEntry_C : UDialogueActionEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Background UListItemBG_01_C
local UW_DialogueActionEntry_C = {}

---@param bIsSelected boolean
function UW_DialogueActionEntry_C:CustomEvent(bIsSelected) end
---@param ListItemObject UObject
function UW_DialogueActionEntry_C:OnListItemObjectSet(ListItemObject) end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_DialogueActionEntry_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UW_DialogueActionEntry_C:ExecuteUbergraph_W_DialogueActionEntry(EntryPoint) end


