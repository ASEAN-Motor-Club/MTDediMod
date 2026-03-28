---@meta

---@class UW_SpinBoxString_C : USpinBoxString
---@field UberGraphFrame FPointerToUberGraphFrame
---@field DownButtonIcon UWB_Icon_Base_C
---@field SizeBox_0 USizeBox
---@field UpButtonIcon UWB_Icon_Base_C
---@field MinWidth double
local UW_SpinBoxString_C = {}

---@return FSlateColor
function UW_SpinBoxString_C:Get_TextBlock_ColorAndOpacity_0() end
---@param IsDesignTime boolean
function UW_SpinBoxString_C:PreConstruct(IsDesignTime) end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_SpinBoxString_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UW_SpinBoxString_C:ExecuteUbergraph_W_SpinBoxString(EntryPoint) end


