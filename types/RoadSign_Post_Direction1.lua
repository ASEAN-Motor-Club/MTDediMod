---@meta

---@class ARoadSign_Post_Direction1_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Third_Sign UChildActorComponent
---@field Third_Support UStaticMeshComponent
---@field Second_Support UStaticMeshComponent
---@field Second_Sign UChildActorComponent
---@field First_Sign UChildActorComponent
---@field First_Support UStaticMeshComponent
---@field SignData_First FMTRoadSignDirectionData
---@field SignData_Second FMTRoadSignDirectionData
---@field SignData_Third FMTRoadSignDirectionData
---@field Use_SecondSign boolean
---@field Use_ThirdSign boolean
local ARoadSign_Post_Direction1_C = {}

function ARoadSign_Post_Direction1_C:UserConstructionScript() end
function ARoadSign_Post_Direction1_C:ReceiveBeginPlay() end
ARoadSign_Post_Direction1_C['Apply Sign Data'] = function(self, ) end
---@param EntryPoint int32
function ARoadSign_Post_Direction1_C:ExecuteUbergraph_RoadSign_Post_Direction1(EntryPoint) end


