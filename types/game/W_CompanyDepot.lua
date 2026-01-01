---@meta

---@class UW_CompanyDepot_C : UCompanyDepotWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FullScreenMenuBG1 UFullScreenMenuBG1_C
---@field W_Template_PopupWindow_28 UW_Template_PopupWindow_C
local UW_CompanyDepot_C = {}

function UW_CompanyDepot_C:Construct() end
---@param VehicleName FText
function UW_CompanyDepot_C:ReceiveSetDepotName(VehicleName) end
---@param EntryPoint int32
function UW_CompanyDepot_C:ExecuteUbergraph_W_CompanyDepot(EntryPoint) end


