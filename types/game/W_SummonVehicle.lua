---@meta

---@class UW_SummonVehicle_C : UParkingSpaceSummonWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FullScreenMenuBG1 UFullScreenMenuBG1_C
---@field W_Template_PopupWindow UW_Template_PopupWindow_C
---@field W_Title UW_Title_C
---@field W_Title_1 UW_Title_C
local UW_SummonVehicle_C = {}

function UW_SummonVehicle_C:Construct() end
---@param EntryPoint int32
function UW_SummonVehicle_C:ExecuteUbergraph_W_SummonVehicle(EntryPoint) end


