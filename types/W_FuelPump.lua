---@meta

---@class UW_FuelPump_C : UFuelPumpWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field W_Template_Fullscreen_Popup UW_Template_Fullscreen_Popup_C
local UW_FuelPump_C = {}

function UW_FuelPump_C:ReceiveStartInteraction() end
function UW_FuelPump_C:Construct() end
---@param EntryPoint int32
function UW_FuelPump_C:ExecuteUbergraph_W_FuelPump(EntryPoint) end


