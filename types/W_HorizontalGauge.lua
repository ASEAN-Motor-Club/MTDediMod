---@meta

---@class UW_HorizontalGauge_C : UProgressBarGaugeWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field IconImage UImage
---@field IconImageBrush FSlateBrush
local UW_HorizontalGauge_C = {}

---@param IsDesignTime boolean
function UW_HorizontalGauge_C:PreConstruct(IsDesignTime) end
function UW_HorizontalGauge_C:Construct() end
---@param Brush FSlateBrush
function UW_HorizontalGauge_C:ReceiveSetIconBrush(Brush) end
---@param EntryPoint int32
function UW_HorizontalGauge_C:ExecuteUbergraph_W_HorizontalGauge(EntryPoint) end


