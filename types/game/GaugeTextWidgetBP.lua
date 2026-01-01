---@meta

---@class UGaugeTextWidgetBP_C : UGaugeTextWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Text UTextBlock
local UGaugeTextWidgetBP_C = {}

---@param InText FText
function UGaugeTextWidgetBP_C:SetText(InText) end
---@param EntryPoint int32
function UGaugeTextWidgetBP_C:ExecuteUbergraph_GaugeTextWidgetBP(EntryPoint) end


