---@meta

---@class UW_FrameRateText_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FPSTextBlock UTextBlock
---@field SmoothedDeltaSeconds double
local UW_FrameRateText_C = {}

---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_FrameRateText_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UW_FrameRateText_C:ExecuteUbergraph_W_FrameRateText(EntryPoint) end


