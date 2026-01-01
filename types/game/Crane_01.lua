---@meta

---@class ACrane_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field CraneBeeps UAudioComponent
---@field MoveCraneWinch UAudioComponent
---@field MoveCraneControler UAudioComponent
---@field MoveCraneElevator UAudioComponent
---@field SM_Bld_Crane_01_Winch_Base UStaticMeshComponent
---@field SM_Bld_Crane_01_Winch_Control UStaticMeshComponent
---@field SM_Prop_Container_01 UStaticMeshComponent
---@field SM_Bld_Crane_01_Winch_Claw_2 UStaticMeshComponent
---@field SM_Bld_Crane_01_Winch_Claw_1 UStaticMeshComponent
---@field SM_Bld_Crane_01_Winch_Cables UStaticMeshComponent
---@field SM_Bld_Crane_01_Arm UStaticMeshComponent
---@field SM_Bld_Crane_01_Elevator UStaticMeshComponent
---@field SM_Bld_Crane_01_Arm_Cables UStaticMeshComponent
---@field SM_Bld_Crane_01_Arm_Brackets_Down UStaticMeshComponent
---@field SM_Bld_Crane_01 UStaticMeshComponent
---@field IsCraneMoving boolean
---@field IsCraneForward boolean
---@field ['Crane Time'] double
---@field ['Crane Moving Time'] double
---@field ['Crane From'] double
---@field ['Crane To'] double
---@field IsElevatorMoving boolean
---@field IsElevatorUpward boolean
---@field ['Elevator Time'] double
---@field ['Elevator Moving Time'] double
---@field IsWinchMoving boolean
---@field IsWinchReverse boolean
---@field ['Winch Time'] double
---@field ['Winch Moving Time'] double
---@field ['Winch Height From'] double
---@field ['Winch Height To'] double
---@field ['Cable Scale From'] double
---@field ['Cable Scale To'] double
---@field IsControlerMoving boolean
---@field IsControlerForward boolean
---@field ['Controler Time'] double
---@field ['Controler Moving Time'] double
---@field ['Controler From'] double
---@field ['Controler To'] double
---@field ['Controler Finish Delay'] double
---@field ['Elevator Height From'] double
---@field ['Elevator Height To'] double
---@field ['Elevator Finish Delay'] double
---@field IsContainerOn boolean
---@field RepeatInterval double
---@field DelayElevator double
local ACrane_01_C = {}

---@param InputAction boolean
---@param InputSound UAudioComponent
ACrane_01_C['Play Sound'] = function(self, InputAction, InputSound) end
---@param Delta_Seconds double
---@param IsFinished boolean
ACrane_01_C['Crane Move'] = function(self, Delta_Seconds, IsFinished) end
---@param IsForward boolean
ACrane_01_C['Crane Start'] = function(self, IsForward) end
---@param Delta_Seconds double
---@param IsFinished boolean
ACrane_01_C['Winch Move'] = function(self, Delta_Seconds, IsFinished) end
---@param bPickUpContainer boolean
ACrane_01_C['Winch Start'] = function(self, bPickUpContainer) end
---@param Delta_Seconds double
---@param IsFinished boolean
ACrane_01_C['Controller Move'] = function(self, Delta_Seconds, IsFinished) end
---@param IsForward boolean
---@param FinishDelay double
ACrane_01_C['Controller Start'] = function(self, IsForward, FinishDelay) end
---@param Delta_Seconds double
---@param IsFinished boolean
ACrane_01_C['Elevator Move'] = function(self, Delta_Seconds, IsFinished) end
---@param Upward boolean
---@param FinishDelay double
ACrane_01_C['Elevator Start'] = function(self, Upward, FinishDelay) end
---@param DeltaSeconds float
function ACrane_01_C:ReceiveTick(DeltaSeconds) end
function ACrane_01_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function ACrane_01_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function ACrane_01_C:ExecuteUbergraph_Crane_01(EntryPoint) end


