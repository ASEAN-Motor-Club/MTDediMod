---@meta

---@class UW_CompanyVehicle_C : UCompanyVehicleWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FullScreenMenuBG1 UFullScreenMenuBG1_C
---@field W_Template_PopupWindow_28 UW_Template_PopupWindow_C
---@field W_Title UW_Title_C
---@field W_Title_1 UW_Title_C
---@field W_Title_2 UW_Title_C
---@field W_Title_3 UW_Title_C
---@field W_Title_4 UW_Title_C
local UW_CompanyVehicle_C = {}

function UW_CompanyVehicle_C:Construct() end
---@param VehicleName FText
function UW_CompanyVehicle_C:ReceiveSetVehicleName(VehicleName) end
---@param EntryPoint int32
function UW_CompanyVehicle_C:ExecuteUbergraph_W_CompanyVehicle(EntryPoint) end


