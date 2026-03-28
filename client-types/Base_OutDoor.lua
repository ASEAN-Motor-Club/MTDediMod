---@meta

---@class ABase_OutDoor_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MotorTownInteractable UMTInteractableComponent
---@field LeftDoor UStaticMeshComponent
---@field Scene USceneComponent
---@field Door_Angle_Degree_3EE72326463C7118CF7B8E8C50BE8D13 float
---@field Door_Angle__Direction_3EE72326463C7118CF7B8E8C50BE8D13 ETimelineDirection::Type
---@field ['Door Angle'] UTimelineComponent
---@field bOpened boolean
---@field DoorMesh UStaticMesh
---@field bOpenClockwise boolean
local ABase_OutDoor_C = {}

function ABase_OutDoor_C:UserConstructionScript() end
ABase_OutDoor_C['Door Angle__FinishedFunc'] = function(self, ) end
ABase_OutDoor_C['Door Angle__UpdateFunc'] = function(self, ) end
ABase_OutDoor_C['Toggle Open'] = function(self, ) end
---@param Interactor AActor
---@param Param1 float
function ABase_OutDoor_C:HandleUse(Interactor, Param1) end
---@param EntryPoint int32
function ABase_OutDoor_C:ExecuteUbergraph_Base_OutDoor(EntryPoint) end


