---@meta

---@class UW_TowRequestControlPanel_C : UTowRequestControlPanelWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field W_Template_PopupWindow UW_Template_PopupWindow_C
---@field FocusInitialized boolean
local UW_TowRequestControlPanel_C = {}

---@param IsDesignTime boolean
function UW_TowRequestControlPanel_C:PreConstruct(IsDesignTime) end
function UW_TowRequestControlPanel_C:Construct() end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_TowRequestControlPanel_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UW_TowRequestControlPanel_C:ExecuteUbergraph_W_TowRequestControlPanel(EntryPoint) end


