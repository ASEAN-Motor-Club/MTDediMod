---@meta

---@class AArrowSign_Plate_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Widget3 UWidgetComponent
---@field Widget2 UWidgetComponent
---@field Widget1 UWidgetComponent
---@field SignData FMTRoadSignDirectionData
local AArrowSign_Plate_C = {}

function AArrowSign_Plate_C:ApplySignData() end
function AArrowSign_Plate_C:UserConstructionScript() end
function AArrowSign_Plate_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AArrowSign_Plate_C:ExecuteUbergraph_ArrowSign_Plate(EntryPoint) end


