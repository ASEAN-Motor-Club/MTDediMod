---@meta

---@class AArrowSign_C : AMTBreakable
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Third_Sign UChildActorComponent
---@field Second_Sign UChildActorComponent
---@field First_Sign UChildActorComponent
---@field SignData_First FMTRoadSignDirectionData
---@field SignData_Second FMTRoadSignDirectionData
---@field SignData_Third FMTRoadSignDirectionData
---@field Use_SecondSign boolean
---@field Use_ThirdSign boolean
local AArrowSign_C = {}

---@param AsArrowSignPlate AArrowSign_Plate_C
---@param SignActor USceneComponent
function AArrowSign_C:ForwardRotation(AsArrowSignPlate, SignActor) end
function AArrowSign_C:UserConstructionScript() end
function AArrowSign_C:ReceiveBeginPlay() end
AArrowSign_C['Apply Sign Data'] = function(self, ) end
---@param EntryPoint int32
function AArrowSign_C:ExecuteUbergraph_ArrowSign(EntryPoint) end


