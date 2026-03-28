---@meta

---@class ARoadSign_DirectionPlate_C : AMTBreakable
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Arrow UStaticMeshComponent
---@field Widget2 UWidgetComponent
---@field Widget1 UWidgetComponent
---@field SignData FMTRoadSignDirectionData
local ARoadSign_DirectionPlate_C = {}

function ARoadSign_DirectionPlate_C:ApplySignData() end
function ARoadSign_DirectionPlate_C:UserConstructionScript() end
function ARoadSign_DirectionPlate_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function ARoadSign_DirectionPlate_C:ExecuteUbergraph_RoadSign_DirectionPlate(EntryPoint) end


