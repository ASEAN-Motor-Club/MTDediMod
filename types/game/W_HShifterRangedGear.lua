---@meta

---@class UW_HShifterRangedGear_C : UShifterGearWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Fill_High UImage
---@field Fill_Low UImage
---@field FrameImage UImage
---@field GearNameHTextBlock UTextBlock
---@field GearNameLTextBlock UTextBlock
---@field HH UTextBlock
---@field HighSplitter UVerticalBox
---@field HL UTextBlock
---@field LH UTextBlock
---@field LL UTextBlock
---@field LowSplitter UVerticalBox
---@field GearNameH FText
---@field GearNameL FText
---@field bHasHighSpliiter boolean
---@field bHasLowSpliiter boolean
local UW_HShifterRangedGear_C = {}

---@param IsDesignTime boolean
function UW_HShifterRangedGear_C:PreConstruct(IsDesignTime) end
---@param bSelected boolean
function UW_HShifterRangedGear_C:ReceiveSelectedChanged(bSelected) end
---@param bLow boolean
function UW_HShifterRangedGear_C:ReceiveRangeSelected(bLow) end
---@param bLow boolean
function UW_HShifterRangedGear_C:ReceiveSplitterSelected(bLow) end
---@param EntryPoint int32
function UW_HShifterRangedGear_C:ExecuteUbergraph_W_HShifterRangedGear(EntryPoint) end


