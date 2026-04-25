---@meta

---@class A_Deprecated_BaseDoor_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MotorTownInteractable UMTInteractableComponent
---@field LeftDoor UStaticMeshComponent
---@field Scene USceneComponent
---@field Door_Angle_Degree_7573CD9D4A05BD06B0D9B1A79A817094 float
---@field Door_Angle__Direction_7573CD9D4A05BD06B0D9B1A79A817094 ETimelineDirection::Type
---@field ['Door Angle'] UTimelineComponent
---@field bOpened boolean
---@field DoorMesh UStaticMesh
local A_Deprecated_BaseDoor_C = {}

function A_Deprecated_BaseDoor_C:UserConstructionScript() end
A_Deprecated_BaseDoor_C['Door Angle__FinishedFunc'] = function(self, ) end
A_Deprecated_BaseDoor_C['Door Angle__UpdateFunc'] = function(self, ) end
A_Deprecated_BaseDoor_C['Toggle Open'] = function(self, ) end
---@param Interactor AActor
---@param Param1 float
function A_Deprecated_BaseDoor_C:HandleUse(Interactor, Param1) end
---@param EntryPoint int32
function A_Deprecated_BaseDoor_C:ExecuteUbergraph__Deprecated_BaseDoor(EntryPoint) end


