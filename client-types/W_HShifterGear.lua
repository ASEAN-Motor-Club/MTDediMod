---@meta

---@class UW_HShifterGear_C : UShifterGearWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Fill UImage
---@field FrameImage UImage
---@field GearNameTextBlock UTextBlock
---@field GearName FText
local UW_HShifterGear_C = {}

---@param IsDesignTime boolean
function UW_HShifterGear_C:PreConstruct(IsDesignTime) end
---@param bSelected boolean
function UW_HShifterGear_C:ReceiveSelectedChanged(bSelected) end
---@param bLow boolean
function UW_HShifterGear_C:ReceiveRangeSelected(bLow) end
---@param EntryPoint int32
function UW_HShifterGear_C:ExecuteUbergraph_W_HShifterGear(EntryPoint) end


