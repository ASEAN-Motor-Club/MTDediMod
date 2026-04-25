---@meta

---@class AMechanicLift_01_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field ['Hydraulic Sound'] UAudioComponent
---@field MotorTownInteractable UMTInteractableComponent
---@field SM_Prop_MechanicLift_01 UStaticMeshComponent
---@field Lift UStaticMeshComponent
---@field MovingPart USceneComponent
---@field Scene USceneComponent
---@field Timeline_0_Height_7986EACC48C63A70787DCAAE740ED472 float
---@field Timeline_0__Direction_7986EACC48C63A70787DCAAE740ED472 ETimelineDirection::Type
---@field Timeline_0 UTimelineComponent
---@field bDown boolean
---@field bStop boolean
local AMechanicLift_01_C = {}

function AMechanicLift_01_C:OnRep_bStop() end
function AMechanicLift_01_C:HandleStopChanged() end
function AMechanicLift_01_C:Timeline_0__FinishedFunc() end
function AMechanicLift_01_C:Timeline_0__UpdateFunc() end
function AMechanicLift_01_C:Up() end
function AMechanicLift_01_C:Down() end
---@param Interactor AActor
---@param Param1 float
function AMechanicLift_01_C:HandleUse(Interactor, Param1) end
function AMechanicLift_01_C:Server_HandleUse() end
function AMechanicLift_01_C:Stop() end
function AMechanicLift_01_C:MulticastHandleUse() end
---@param EntryPoint int32
function AMechanicLift_01_C:ExecuteUbergraph_MechanicLift_01(EntryPoint) end


