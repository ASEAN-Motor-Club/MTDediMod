---@meta

---@class APlane_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field BoxForLevelStreaming UBoxComponent
---@field Aircraft UAudioComponent
---@field SM_Plane_01_Propeller UStaticMeshComponent
---@field SM_Plane_01 UStaticMeshComponent
---@field IsFlying boolean
---@field IsEngineOn boolean
---@field ['Rest Time'] double
---@field ['Curve Length'] double
---@field ['Flight Time'] double
---@field ['Prop Speed'] double
---@field ['Flight Move Curve'] UCurveVector
---@field ['Flight Rotation Curve'] UCurveVector
---@field ['Flight Scale Curve'] UCurveVector
local APlane_01_C = {}

---@param InputAction boolean
---@param InputSound UAudioComponent
APlane_01_C['Play Sound'] = function(self, InputAction, InputSound) end
---@param Delta_Seconds double
APlane_01_C['Update Prop'] = function(self, Delta_Seconds) end
---@param In_Time double
function APlane_01_C:Flight(In_Time) end
---@param DeltaSeconds float
function APlane_01_C:ReceiveTick(DeltaSeconds) end
function APlane_01_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function APlane_01_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function APlane_01_C:ExecuteUbergraph_Plane_01(EntryPoint) end


