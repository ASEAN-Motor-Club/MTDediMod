---@meta

---@class UW_MuscleText_C : UGaugeTextWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Text UTextBlock
local UW_MuscleText_C = {}

---@param InText FText
function UW_MuscleText_C:SetText(InText) end
---@param Scale float
function UW_MuscleText_C:SetScale(Scale) end
---@param EntryPoint int32
function UW_MuscleText_C:ExecuteUbergraph_W_MuscleText(EntryPoint) end


