---@meta

---@class UW_TabMenu_C : UTabMenuTemplateWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MenuBG1_Round UMenuBG1_Round_C
local UW_TabMenu_C = {}

---@param IsDesignTime boolean
function UW_TabMenu_C:PreConstruct(IsDesignTime) end
function UW_TabMenu_C:Construct() end
---@param EntryPoint int32
function UW_TabMenu_C:ExecuteUbergraph_W_TabMenu(EntryPoint) end


