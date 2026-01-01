---@meta

---@class ASildeDoor_01_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MotorTownInteractable UMTInteractableComponent
---@field LeftDoor UStaticMeshComponent
---@field Scene USceneComponent
---@field Door_Move_Degree_CC75C676443DEDC883AE24B6150FFD5B float
---@field Door_Move__Direction_CC75C676443DEDC883AE24B6150FFD5B ETimelineDirection::Type
---@field ['Door Move'] UTimelineComponent
---@field bOpened boolean
---@field DoorMesh UStaticMesh
local ASildeDoor_01_C = {}

function ASildeDoor_01_C:UserConstructionScript() end
ASildeDoor_01_C['Door Move__FinishedFunc'] = function(self, ) end
ASildeDoor_01_C['Door Move__UpdateFunc'] = function(self, ) end
ASildeDoor_01_C['Toggle Open'] = function(self, ) end
---@param Interactor AActor
---@param Param1 float
function ASildeDoor_01_C:HandleUse(Interactor, Param1) end
---@param EntryPoint int32
function ASildeDoor_01_C:ExecuteUbergraph_SildeDoor_01(EntryPoint) end


