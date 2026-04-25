---@meta

---@class UW_TransformStep_C : UMTTransformStepWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Title UW_Title_C
local UW_TransformStep_C = {}

---@param InText FText
function UW_TransformStep_C:SetTitleText(InText) end
---@param EntryPoint int32
function UW_TransformStep_C:ExecuteUbergraph_W_TransformStep(EntryPoint) end


