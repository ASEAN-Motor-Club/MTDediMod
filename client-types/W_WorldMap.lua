---@meta

---@class UW_WorldMap_C : UWorldMapWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field CloseButton UW_CloseButton_C
---@field MenuBG1_Round UMenuBG1_Round_C
---@field MenuBG1_Round_C_0 UMenuBG1_Round_C
local UW_WorldMap_C = {}

---@param IsDesignTime boolean
function UW_WorldMap_C:PreConstruct(IsDesignTime) end
function UW_WorldMap_C:BndEvt__MainMenuButtonWidgetBP_K2Node_ComponentBoundEvent_0_OnMenuButtonClickedEvent__DelegateSignature() end
---@param EntryPoint int32
function UW_WorldMap_C:ExecuteUbergraph_W_WorldMap(EntryPoint) end


