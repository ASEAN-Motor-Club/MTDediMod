---@meta

---@class AStraddleCarrier_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MoveCraneLiftUpDown UAudioComponent
---@field CraneBeeps UAudioComponent
---@field SM_Prop_Container_01 UStaticMeshComponent
---@field SM_StraddleCarrier_01_Lift UStaticMeshComponent
---@field SM_StraddleCarrier_01_Wheel3 UStaticMeshComponent
---@field SM_StraddleCarrier_01_Wheel2 UStaticMeshComponent
---@field SM_StraddleCarrier_01_Wheel1 UStaticMeshComponent
---@field SM_StraddleCarrier_01_Wheel UStaticMeshComponent
---@field SM_StraddleCarrier_01 UStaticMeshComponent
---@field IsMoving boolean
---@field IsReverse boolean
---@field IsLifting boolean
---@field Distance double
---@field ['Rest Time'] double
---@field Time double
---@field Speed double
---@field ['Set Distance'] double
---@field ['Lift Height'] double
---@field ['Lift Speed'] double
---@field ['Set Lift Distance'] double
---@field ['Set Lift Time'] double
---@field ['Delay Time'] double
local AStraddleCarrier_01_C = {}

---@param InputAction boolean
---@param InputSound UAudioComponent
AStraddleCarrier_01_C['Play Sound'] = function(self, InputAction, InputSound) end
AStraddleCarrier_01_C['Update Prop'] = function(self, ) end
---@param Delta_Seconds double
---@param IsFinished boolean
AStraddleCarrier_01_C['Lift Move'] = function(self, Delta_Seconds, IsFinished) end
---@param Delta_Seconds double
---@param IsFinished boolean
function AStraddleCarrier_01_C:Move(Delta_Seconds, IsFinished) end
---@param DeltaSeconds float
function AStraddleCarrier_01_C:ReceiveTick(DeltaSeconds) end
function AStraddleCarrier_01_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AStraddleCarrier_01_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AStraddleCarrier_01_C:ExecuteUbergraph_StraddleCarrier_01(EntryPoint) end


