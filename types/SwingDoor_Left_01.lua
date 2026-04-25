---@meta

---@class ASwingDoor_Left_01_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MotorTownInteractable UMTInteractableComponent
---@field LeftDoor UStaticMeshComponent
---@field Scene USceneComponent
---@field Door_Angle_Degree_46B5F4CF4CA19DED5788978DC5E6DC32 float
---@field Door_Angle__Direction_46B5F4CF4CA19DED5788978DC5E6DC32 ETimelineDirection::Type
---@field ['Door Angle'] UTimelineComponent
---@field bOpened boolean
local ASwingDoor_Left_01_C = {}

ASwingDoor_Left_01_C['Door Angle__FinishedFunc'] = function(self, ) end
ASwingDoor_Left_01_C['Door Angle__UpdateFunc'] = function(self, ) end
ASwingDoor_Left_01_C['Toggle Open'] = function(self, ) end
---@param Interactor AActor
---@param Param1 float
function ASwingDoor_Left_01_C:HandleUse(Interactor, Param1) end
---@param EntryPoint int32
function ASwingDoor_Left_01_C:ExecuteUbergraph_SwingDoor_Left_01(EntryPoint) end


