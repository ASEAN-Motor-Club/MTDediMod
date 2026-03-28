---@meta

---@class AWindowDoor_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_Bld_Door_FrontDoor_Window_01 UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
---@field LeftDoor UStaticMeshComponent
---@field Scene USceneComponent
---@field Door_Angle_Degree_34BEE7C8464439E680A276B87000C37A float
---@field Door_Angle__Direction_34BEE7C8464439E680A276B87000C37A ETimelineDirection::Type
---@field ['Door Angle'] UTimelineComponent
---@field bOpened boolean
local AWindowDoor_C = {}

AWindowDoor_C['Door Angle__FinishedFunc'] = function(self, ) end
AWindowDoor_C['Door Angle__UpdateFunc'] = function(self, ) end
AWindowDoor_C['Toggle Open'] = function(self, ) end
---@param Interactor AActor
---@param Param1 float
function AWindowDoor_C:HandleUse(Interactor, Param1) end
---@param EntryPoint int32
function AWindowDoor_C:ExecuteUbergraph_WindowDoor(EntryPoint) end


