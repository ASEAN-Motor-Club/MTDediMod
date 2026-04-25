---@meta

---@class UW_HUDVerticalGauge_C : UProgressBarGaugeWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field IconImage UImage
---@field IconImageBrush FSlateBrush
local UW_HUDVerticalGauge_C = {}

---@param IsDesignTime boolean
function UW_HUDVerticalGauge_C:PreConstruct(IsDesignTime) end
function UW_HUDVerticalGauge_C:Construct() end
---@param Brush FSlateBrush
function UW_HUDVerticalGauge_C:ReceiveSetIconBrush(Brush) end
---@param EntryPoint int32
function UW_HUDVerticalGauge_C:ExecuteUbergraph_W_HUDVerticalGauge(EntryPoint) end


