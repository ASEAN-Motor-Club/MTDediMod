---@meta

---@class A_Deprecated_BaseDoor_02_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MotorTownInteractable UMTInteractableComponent
---@field LeftDoor UStaticMeshComponent
---@field Scene USceneComponent
---@field Door_Angle_Degree_5BC14CFC4CEE0C5477E0F19FFCAE084F float
---@field Door_Angle__Direction_5BC14CFC4CEE0C5477E0F19FFCAE084F ETimelineDirection::Type
---@field ['Door Angle'] UTimelineComponent
---@field bOpened boolean
local A_Deprecated_BaseDoor_02_C = {}

A_Deprecated_BaseDoor_02_C['Door Angle__FinishedFunc'] = function(self, ) end
A_Deprecated_BaseDoor_02_C['Door Angle__UpdateFunc'] = function(self, ) end
A_Deprecated_BaseDoor_02_C['Toggle Open'] = function(self, ) end
---@param Interactor AActor
---@param Param1 float
function A_Deprecated_BaseDoor_02_C:HandleUse(Interactor, Param1) end
---@param EntryPoint int32
function A_Deprecated_BaseDoor_02_C:ExecuteUbergraph__Deprecated_BaseDoor_02(EntryPoint) end


