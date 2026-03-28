---@meta

---@class AContainerCrane_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MoveCraneLift UAudioComponent
---@field MoveCraneLiftUpDown UAudioComponent
---@field CraneBeeps UAudioComponent
---@field SM_Prop_Container_01 UStaticMeshComponent
---@field SM_ContainerCrane_01_Lift_02 UStaticMeshComponent
---@field SM_ContainerCrane_01_Lift_01 UStaticMeshComponent
---@field SM_ContainerCrane_01_Wheel3 UStaticMeshComponent
---@field SM_ContainerCrane_01_Wheel2 UStaticMeshComponent
---@field SM_ContainerCrane_01_Wheel1 UStaticMeshComponent
---@field SM_ContainerCrane_01_Wheel UStaticMeshComponent
---@field SM_ContainerCrane_01 UStaticMeshComponent
---@field IsMoving boolean
---@field IsReverse boolean
---@field IsLifting boolean
---@field IsLiftMoving boolean
---@field Distance double
---@field ['Rest Time'] double
---@field Time double
---@field ['Move Speed'] double
---@field ['Set Distance'] double
---@field ['Lift Height'] double
---@field ['Lift Speed'] double
---@field ['Set Lift Distance'] double
---@field ['Set Lift Time'] double
---@field ['Delay Time'] double
---@field ['Lift Delay Time'] double
local AContainerCrane_01_C = {}

---@param InputAction boolean
---@param InputSound UAudioComponent
AContainerCrane_01_C['Play Sound'] = function(self, InputAction, InputSound) end
AContainerCrane_01_C['Update Prop'] = function(self, ) end
---@param IsFinished boolean
AContainerCrane_01_C['Lift Move'] = function(self, IsFinished) end
---@param Delta_Seconds double
---@param IsFinished boolean
AContainerCrane_01_C['Lift UpDown'] = function(self, Delta_Seconds, IsFinished) end
---@param Delta_Seconds double
---@param IsFinished boolean
function AContainerCrane_01_C:Move(Delta_Seconds, IsFinished) end
---@param DeltaSeconds float
function AContainerCrane_01_C:ReceiveTick(DeltaSeconds) end
function AContainerCrane_01_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AContainerCrane_01_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AContainerCrane_01_C:ExecuteUbergraph_ContainerCrane_01(EntryPoint) end


