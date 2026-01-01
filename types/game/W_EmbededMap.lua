---@meta

---@class UW_EmbededMap_C : UWorldMapWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FocusBorder UImage
---@field MenuBG1_Round UMenuBG1_Round_C
local UW_EmbededMap_C = {}

---@return ESlateVisibility
function UW_EmbededMap_C:Get_FocusBorder_Visibility_0() end
---@param IsDesignTime boolean
function UW_EmbededMap_C:PreConstruct(IsDesignTime) end
---@param EntryPoint int32
function UW_EmbededMap_C:ExecuteUbergraph_W_EmbededMap(EntryPoint) end


