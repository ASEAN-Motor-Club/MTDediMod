---@meta

---@class FXRDeviceId
---@field SystemName FName
---@field DeviceID int32
local FXRDeviceId = {}



---@class FXRHMDData
---@field bValid boolean
---@field deviceName FName
---@field ApplicationInstanceID FGuid
---@field TrackingStatus ETrackingStatus
---@field Position FVector
---@field Rotation FQuat
local FXRHMDData = {}



---@class FXRHandTrackingState
---@field bValid boolean
---@field deviceName FName
---@field ApplicationInstanceID FGuid
---@field XRSpaceType EXRSpaceType
---@field Hand EControllerHand
---@field TrackingStatus ETrackingStatus
---@field HandKeyLocations TArray<FVector>
---@field HandKeyRotations TArray<FQuat>
---@field HandKeyRadii TArray<float>
local FXRHandTrackingState = {}



---@class FXRMotionControllerData
---@field bValid boolean
---@field deviceName FName
---@field ApplicationInstanceID FGuid
---@field DeviceVisualType EXRVisualType
---@field HandIndex EControllerHand
---@field TrackingStatus ETrackingStatus
---@field GripPosition FVector
---@field GripRotation FQuat
---@field AimPosition FVector
---@field AimRotation FQuat
---@field PalmPosition FVector
---@field PalmRotation FQuat
---@field HandKeyPositions TArray<FVector>
---@field HandKeyRotations TArray<FQuat>
---@field HandKeyRadii TArray<float>
---@field bIsGrasped boolean
local FXRMotionControllerData = {}



---@class FXRMotionControllerState
---@field bValid boolean
---@field deviceName FName
---@field ApplicationInstanceID FGuid
---@field XRSpaceType EXRSpaceType
---@field Hand EControllerHand
---@field TrackingStatus ETrackingStatus
---@field XRControllerPoseType EXRControllerPoseType
---@field ControllerLocation FVector
---@field ControllerRotation FQuat
---@field GripUnrealSpaceLocation FVector
---@field GripUnrealSpaceRotation FQuat
local FXRMotionControllerState = {}



---@class UHandKeypointConversion : UBlueprintFunctionLibrary
local UHandKeypointConversion = {}

---@param Input EHandKeypoint
---@return int32
function UHandKeypointConversion:Conv_HandKeypointToInt32(Input) end


---@class UMotionControllerComponent : UPrimitiveComponent
---@field PlayerIndex int32
---@field MotionSource FName
---@field bDisableLowLatencyUpdate boolean
---@field CurrentTrackingStatus ETrackingStatus
local UMotionControllerComponent = {}

---@param NewSource EControllerHand
function UMotionControllerComponent:SetTrackingSource(NewSource) end
---@param NewSource FName
function UMotionControllerComponent:SetTrackingMotionSource(NewSource) end
---@param NewPlayer int32
function UMotionControllerComponent:SetAssociatedPlayerIndex(NewPlayer) end
function UMotionControllerComponent:OnMotionControllerUpdated() end
---@return boolean
function UMotionControllerComponent:IsTracked() end
---@return EControllerHand
function UMotionControllerComponent:GetTrackingSource() end
---@param InName FName
---@param bValueFound boolean
---@return float
function UMotionControllerComponent:GetParameterValue(InName, bValueFound) end
---@param OutLinearVelocity FVector
---@return boolean
function UMotionControllerComponent:GetLinearVelocity(OutLinearVelocity) end
---@param OutLinearAcceleration FVector
---@return boolean
function UMotionControllerComponent:GetLinearAcceleration(OutLinearAcceleration) end
---@param jointIndex int32
---@param bValueFound boolean
---@return FVector
function UMotionControllerComponent:GetHandJointPosition(jointIndex, bValueFound) end
---@param OutAngularVelocity FRotator
---@return boolean
function UMotionControllerComponent:GetAngularVelocity(OutAngularVelocity) end


