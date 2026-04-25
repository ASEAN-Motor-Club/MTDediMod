---@meta

---@class UW_DrivingHUD_C : UDrivingHUDWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MenuBG1_Round UMenuBG1_Round_C
---@field SteeringBackground UImage
---@field W_HShifter13 UW_HShifter13_C
local UW_DrivingHUD_C = {}

function UW_DrivingHUD_C:Get_LowFuel_Visibility_0() end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_DrivingHUD_C:Tick(MyGeometry, InDeltaTime) end
function UW_DrivingHUD_C:Construct() end
---@param EntryPoint int32
function UW_DrivingHUD_C:ExecuteUbergraph_W_DrivingHUD(EntryPoint) end


