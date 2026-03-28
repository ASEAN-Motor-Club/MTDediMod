---@meta

---@class AGameplayCameraActor : AActor
---@field CameraComponent UGameplayCameraComponent
local AGameplayCameraActor = {}

---@return UGameplayCameraComponent
function AGameplayCameraActor:GetCameraComponent() end


---@class AGameplayCameraSystemActor : AActor
---@field CameraSystemComponent UGameplayCameraSystemComponent
local AGameplayCameraSystemActor = {}

---@return UGameplayCameraSystemComponent
function AGameplayCameraSystemActor:GetCameraSystemComponent() end
---@param PlayerController APlayerController
---@param bForceSpawn boolean
---@return AGameplayCameraSystemActor
function AGameplayCameraSystemActor:GetAutoSpawnedCameraSystemActor(PlayerController, bForceSpawn) end
---@param PlayerController APlayerController
function AGameplayCameraSystemActor:AutoManageActiveViewTarget(PlayerController) end


---@class FBlueprintCameraDirectorActivateParams
---@field EvaluationContextOwner UObject
local FBlueprintCameraDirectorActivateParams = {}



---@class FBlueprintCameraDirectorDeactivateParams
---@field EvaluationContextOwner UObject
local FBlueprintCameraDirectorDeactivateParams = {}



---@class FBlueprintCameraDirectorEvaluationParams
---@field DeltaTime float
---@field EvaluationContextOwner UObject
local FBlueprintCameraDirectorEvaluationParams = {}



---@class FBlueprintCameraPose
---@field Location FVector
---@field Rotation FRotator
---@field TargetDistance double
---@field FieldOfView float
---@field FocalLength float
---@field Aperture float
---@field ShutterSpeed float
---@field FocusDistance float
---@field SensorWidth float
---@field SensorHeight float
---@field ISO float
---@field SqueezeFactor float
---@field DiaphragmBladeCount int32
---@field NearClippingPlane float
---@field FarClippingPlane float
---@field PhysicalCameraBlendWeight float
---@field EnablePhysicalCamera boolean
---@field ConstrainAspectRatio boolean
---@field OverrideAspectRatioAxisConstraint boolean
---@field AspectRatioAxisConstraint EAspectRatioAxisConstraint
local FBlueprintCameraPose = {}



---@class FBlueprintCameraVariableTable
local FBlueprintCameraVariableTable = {}


---@class FBooleanCameraParameter
---@field Value boolean
---@field Variable UBooleanCameraVariable
local FBooleanCameraParameter = {}



---@class FBooleanCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FBooleanCameraParameter
local FBooleanCameraRigParameterOverride = {}



---@class FBooleanCameraVariableReference
---@field Variable UBooleanCameraVariable
local FBooleanCameraVariableReference = {}



---@class FCameraDirectorStateTreeEvaluationData
---@field ActiveCameraRigs TArray<UCameraRigAsset>
---@field ActiveCameraRigProxies TArray<UCameraRigProxyAsset>
local FCameraDirectorStateTreeEvaluationData = {}



---@class FCameraFramingZone
---@field LeftMargin FDoubleCameraParameter
---@field TopMargin FDoubleCameraParameter
---@field RightMargin FDoubleCameraParameter
---@field BottomMargin FDoubleCameraParameter
local FCameraFramingZone = {}



---@class FCameraNodeEvaluatorAllocationInfo
---@field TotalSizeof int16
---@field MaxAlignof int16
local FCameraNodeEvaluatorAllocationInfo = {}



---@class FCameraParameterClamping
---@field MinValue double
---@field MaxValue double
---@field bClampMin boolean
---@field bClampMax boolean
local FCameraParameterClamping = {}



---@class FCameraParameterNormalization
---@field MaxValue double
---@field bNormalize boolean
local FCameraParameterNormalization = {}



---@class FCameraPose
---@field Location FVector3d
---@field Rotation FRotator3d
---@field TargetDistance double
---@field FieldOfView float
---@field FocalLength float
---@field Aperture float
---@field ShutterSpeed float
---@field FocusDistance float
---@field SensorWidth float
---@field SensorHeight float
---@field ISO float
---@field SqueezeFactor float
---@field DiaphragmBladeCount int32
---@field NearClippingPlane float
---@field FarClippingPlane float
---@field PhysicalCameraBlendWeight float
---@field EnablePhysicalCamera boolean
---@field ConstrainAspectRatio boolean
---@field OverrideAspectRatioAxisConstraint boolean
---@field AspectRatioAxisConstraint EAspectRatioAxisConstraint
local FCameraPose = {}



---@class FCameraRigAllocationInfo
---@field EvaluatorInfo FCameraNodeEvaluatorAllocationInfo
---@field VariableTableInfo FCameraVariableTableAllocationInfo
local FCameraRigAllocationInfo = {}



---@class FCameraRigAssetReference
---@field CameraRig UCameraRigAsset
---@field ParameterOverrides FCameraRigParameterOverrides
local FCameraRigAssetReference = {}



---@class FCameraRigInputSlotParameters
---@field bIsAccumulated boolean
---@field bIsPreBlended boolean
local FCameraRigInputSlotParameters = {}



---@class FCameraRigInterface
---@field DisplayName FString
---@field InterfaceParameters TArray<UCameraRigInterfaceParameter>
local FCameraRigInterface = {}



---@class FCameraRigParameterOverrideBase
---@field InterfaceParameterGuid FGuid
---@field PrivateVariableGuid FGuid
---@field InterfaceParameterName FString
---@field bInvalid boolean
local FCameraRigParameterOverrideBase = {}



---@class FCameraRigParameterOverrides
---@field BooleanOverrides TArray<FBooleanCameraRigParameterOverride>
---@field Integer32Overrides TArray<FInteger32CameraRigParameterOverride>
---@field FloatOverrides TArray<FFloatCameraRigParameterOverride>
---@field DoubleOverrides TArray<FDoubleCameraRigParameterOverride>
---@field Vector2fOverrides TArray<FVector2fCameraRigParameterOverride>
---@field Vector2dOverrides TArray<FVector2dCameraRigParameterOverride>
---@field Vector3fOverrides TArray<FVector3fCameraRigParameterOverride>
---@field Vector3dOverrides TArray<FVector3dCameraRigParameterOverride>
---@field Vector4fOverrides TArray<FVector4fCameraRigParameterOverride>
---@field Vector4dOverrides TArray<FVector4dCameraRigParameterOverride>
---@field Rotator3fOverrides TArray<FRotator3fCameraRigParameterOverride>
---@field Rotator3dOverrides TArray<FRotator3dCameraRigParameterOverride>
---@field Transform3fOverrides TArray<FTransform3fCameraRigParameterOverride>
---@field Transform3dOverrides TArray<FTransform3dCameraRigParameterOverride>
local FCameraRigParameterOverrides = {}



---@class FCameraRigProxyTableEntry
---@field CameraRigProxy UCameraRigProxyAsset
---@field CameraRig UCameraRigAsset
local FCameraRigProxyTableEntry = {}



---@class FCameraVariableDefinition
---@field VariableID FCameraVariableID
---@field VariableType ECameraVariableType
---@field bIsPrivate boolean
---@field bIsInput boolean
local FCameraVariableDefinition = {}



---@class FCameraVariableID
---@field Value uint32
local FCameraVariableID = {}



---@class FCameraVariableTableAllocationInfo
---@field VariableDefinitions TArray<FCameraVariableDefinition>
---@field AutoResetVariables TArray<UCameraVariableAsset>
local FCameraVariableTableAllocationInfo = {}



---@class FDoubleCameraParameter
---@field Value double
---@field Variable UDoubleCameraVariable
local FDoubleCameraParameter = {}



---@class FDoubleCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FDoubleCameraParameter
local FDoubleCameraRigParameterOverride = {}



---@class FDoubleCameraVariableReference
---@field Variable UDoubleCameraVariable
local FDoubleCameraVariableReference = {}



---@class FFloatCameraParameter
---@field Value float
---@field Variable UFloatCameraVariable
local FFloatCameraParameter = {}



---@class FFloatCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FFloatCameraParameter
local FFloatCameraRigParameterOverride = {}



---@class FFloatCameraVariableReference
---@field Variable UFloatCameraVariable
local FFloatCameraVariableReference = {}



---@class FGameplayCamerasActivateCameraRigTask : FGameplayCamerasStateTreeTask
---@field bRunOnce boolean
local FGameplayCamerasActivateCameraRigTask = {}



---@class FGameplayCamerasActivateCameraRigTaskInstanceData
---@field CameraRig UCameraRigAsset
local FGameplayCamerasActivateCameraRigTaskInstanceData = {}



---@class FGameplayCamerasActivateCameraRigViaProxyTask : FGameplayCamerasStateTreeTask
---@field bRunOnce boolean
local FGameplayCamerasActivateCameraRigViaProxyTask = {}



---@class FGameplayCamerasActivateCameraRigViaProxyTaskInstanceData
---@field CameraRigProxy UCameraRigProxyAsset
local FGameplayCamerasActivateCameraRigViaProxyTaskInstanceData = {}



---@class FGameplayCamerasStateTreeCondition : FStateTreeConditionBase
local FGameplayCamerasStateTreeCondition = {}


---@class FGameplayCamerasStateTreeTask : FStateTreeTaskBase
local FGameplayCamerasStateTreeTask = {}


---@class FInteger32CameraParameter
---@field Value int32
---@field Variable UInteger32CameraVariable
local FInteger32CameraParameter = {}



---@class FInteger32CameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FInteger32CameraParameter
local FInteger32CameraRigParameterOverride = {}



---@class FInteger32CameraVariableReference
---@field Variable UInteger32CameraVariable
local FInteger32CameraVariableReference = {}



---@class FRotator3dCameraParameter
---@field Value FRotator3d
---@field Variable URotator3dCameraVariable
local FRotator3dCameraParameter = {}



---@class FRotator3dCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FRotator3dCameraParameter
local FRotator3dCameraRigParameterOverride = {}



---@class FRotator3dCameraVariableReference
---@field Variable URotator3dCameraVariable
local FRotator3dCameraVariableReference = {}



---@class FRotator3fCameraParameter
---@field Value FRotator3f
---@field Variable URotator3fCameraVariable
local FRotator3fCameraParameter = {}



---@class FRotator3fCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FRotator3fCameraParameter
local FRotator3fCameraRigParameterOverride = {}



---@class FRotator3fCameraVariableReference
---@field Variable URotator3fCameraVariable
local FRotator3fCameraVariableReference = {}



---@class FTransform3dCameraParameter
---@field Value FTransform3d
---@field Variable UTransform3dCameraVariable
local FTransform3dCameraParameter = {}



---@class FTransform3dCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FTransform3dCameraParameter
local FTransform3dCameraRigParameterOverride = {}



---@class FTransform3dCameraVariableReference
---@field Variable UTransform3dCameraVariable
local FTransform3dCameraVariableReference = {}



---@class FTransform3fCameraParameter
---@field Value FTransform3f
---@field Variable UTransform3fCameraVariable
local FTransform3fCameraParameter = {}



---@class FTransform3fCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FTransform3fCameraParameter
local FTransform3fCameraRigParameterOverride = {}



---@class FTransform3fCameraVariableReference
---@field Variable UTransform3fCameraVariable
local FTransform3fCameraVariableReference = {}



---@class FVector2dCameraParameter
---@field Value FVector2D
---@field Variable UVector2dCameraVariable
local FVector2dCameraParameter = {}



---@class FVector2dCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FVector2dCameraParameter
local FVector2dCameraRigParameterOverride = {}



---@class FVector2dCameraVariableReference
---@field Variable UVector2dCameraVariable
local FVector2dCameraVariableReference = {}



---@class FVector2fCameraParameter
---@field Value FVector2f
---@field Variable UVector2fCameraVariable
local FVector2fCameraParameter = {}



---@class FVector2fCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FVector2fCameraParameter
local FVector2fCameraRigParameterOverride = {}



---@class FVector2fCameraVariableReference
---@field Variable UVector2fCameraVariable
local FVector2fCameraVariableReference = {}



---@class FVector3dCameraParameter
---@field Value FVector3d
---@field Variable UVector3dCameraVariable
local FVector3dCameraParameter = {}



---@class FVector3dCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FVector3dCameraParameter
local FVector3dCameraRigParameterOverride = {}



---@class FVector3dCameraVariableReference
---@field Variable UVector3dCameraVariable
local FVector3dCameraVariableReference = {}



---@class FVector3fCameraParameter
---@field Value FVector3f
---@field Variable UVector3fCameraVariable
local FVector3fCameraParameter = {}



---@class FVector3fCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FVector3fCameraParameter
local FVector3fCameraRigParameterOverride = {}



---@class FVector3fCameraVariableReference
---@field Variable UVector3fCameraVariable
local FVector3fCameraVariableReference = {}



---@class FVector4dCameraParameter
---@field Value FVector4d
---@field Variable UVector4dCameraVariable
local FVector4dCameraParameter = {}



---@class FVector4dCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FVector4dCameraParameter
local FVector4dCameraRigParameterOverride = {}



---@class FVector4dCameraVariableReference
---@field Variable UVector4dCameraVariable
local FVector4dCameraVariableReference = {}



---@class FVector4fCameraParameter
---@field Value FVector4f
---@field Variable UVector4fCameraVariable
local FVector4fCameraParameter = {}



---@class FVector4fCameraRigParameterOverride : FCameraRigParameterOverrideBase
---@field Value FVector4fCameraParameter
local FVector4fCameraRigParameterOverride = {}



---@class FVector4fCameraVariableReference
---@field Variable UVector4fCameraVariable
local FVector4fCameraVariableReference = {}



---@class IHasCameraBuildStatus : IInterface
local IHasCameraBuildStatus = {}


---@class IObjectTreeGraphObject : IInterface
local IObjectTreeGraphObject = {}


---@class IObjectTreeGraphRootObject : IInterface
local IObjectTreeGraphRootObject = {}


---@class UAccelerationDecelerationValueInterpolator : UCameraValueInterpolator
---@field Acceleration float
---@field MaxSpeed float
---@field Deceleration float
local UAccelerationDecelerationValueInterpolator = {}



---@class UActivateCameraRigFunctions : UBlueprintFunctionLibrary
local UActivateCameraRigFunctions = {}

---@param WorldContextObject UObject
---@param PlayerController APlayerController
---@param CameraRig UCameraRigAsset
function UActivateCameraRigFunctions:ActivatePersistentVisualCameraRig(WorldContextObject, PlayerController, CameraRig) end
---@param WorldContextObject UObject
---@param PlayerController APlayerController
---@param CameraRig UCameraRigAsset
function UActivateCameraRigFunctions:ActivatePersistentGlobalCameraRig(WorldContextObject, PlayerController, CameraRig) end
---@param WorldContextObject UObject
---@param PlayerController APlayerController
---@param CameraRig UCameraRigAsset
function UActivateCameraRigFunctions:ActivatePersistentBaseCameraRig(WorldContextObject, PlayerController, CameraRig) end


---@class UArrayCameraNode : UCameraNode
---@field Children TArray<UCameraNode>
local UArrayCameraNode = {}



---@class UAttachToPlayerPawnCameraNode : UCameraNode
---@field AttachToLocation FBooleanCameraParameter
---@field AttachToRotation FBooleanCameraParameter
local UAttachToPlayerPawnCameraNode = {}



---@class UAutoRotateInput2DCameraNode : UInput2DCameraNode
---@field Direction ECameraAutoRotateDirection
---@field WaitTime FFloatCameraParameter
---@field DeactivationThreshold FFloatCameraParameter
---@field Interpolator UCameraValueInterpolator
---@field FreezeControlRotation FBooleanCameraParameter
---@field EnableAutoRotate FBooleanCameraParameter
---@field AutoRotateYaw FBooleanCameraParameter
---@field AutoRotatePitch FBooleanCameraParameter
---@field InputNode UInput2DCameraNode
local UAutoRotateInput2DCameraNode = {}



---@class UBaseFramingCameraNode : UCameraNode
---@field TargetLocation FVector3dCameraVariableReference
---@field HorizontalFraming FDoubleCameraParameter
---@field VerticalFraming FDoubleCameraParameter
---@field ReframeDampingFactor FFloatCameraParameter
---@field LowReframeDampingFactor FFloatCameraParameter
---@field ReframeUnlockRadius FFloatCameraParameter
---@field DeadZone FCameraFramingZone
---@field SoftZone FCameraFramingZone
local UBaseFramingCameraNode = {}



---@class UBlendCameraNode : UCameraNode
local UBlendCameraNode = {}


---@class UBlendStackCameraNode : UCameraNode
---@field BlendStackType ECameraBlendStackType
local UBlendStackCameraNode = {}



---@class UBlendStackRootCameraNode : UCameraNode
---@field Blend UBlendCameraNode
---@field RootNode UCameraNode
local UBlendStackRootCameraNode = {}



---@class UBlueprintCameraDirector : UCameraDirector
---@field CameraDirectorEvaluatorClass TSubclassOf<UBlueprintCameraDirectorEvaluator>
---@field CameraRigProxyTable UCameraRigProxyTable
local UBlueprintCameraDirector = {}



---@class UBlueprintCameraDirectorEvaluator : UObject
local UBlueprintCameraDirectorEvaluator = {}

---@param InCameraPose FBlueprintCameraPose
function UBlueprintCameraDirectorEvaluator:SetInitialContextCameraPose(InCameraPose) end
---@param Params FBlueprintCameraDirectorEvaluationParams
function UBlueprintCameraDirectorEvaluator:RunCameraDirector(Params) end
---@return FBlueprintCameraVariableTable
function UBlueprintCameraDirectorEvaluator:GetInitialContextVariableTable() end
---@return FBlueprintCameraPose
function UBlueprintCameraDirectorEvaluator:GetInitialContextCameraPose() end
---@param CameraRig UCameraRigAsset
---@return UCameraRigAsset
function UBlueprintCameraDirectorEvaluator:GetCameraRig(CameraRig) end
---@param ActorClass TSubclassOf<AActor>
---@return AActor
function UBlueprintCameraDirectorEvaluator:FindEvaluationContextOwnerActor(ActorClass) end
---@param CameraRigPrefab UCameraRigAsset
function UBlueprintCameraDirectorEvaluator:DeactivatePersistentVisualCameraRig(CameraRigPrefab) end
---@param CameraRigPrefab UCameraRigAsset
function UBlueprintCameraDirectorEvaluator:DeactivatePersistentGlobalCameraRig(CameraRigPrefab) end
---@param CameraRigPrefab UCameraRigAsset
function UBlueprintCameraDirectorEvaluator:DeactivatePersistentBaseCameraRig(CameraRigPrefab) end
---@param Params FBlueprintCameraDirectorDeactivateParams
function UBlueprintCameraDirectorEvaluator:DeactivateCameraDirector(Params) end
---@param CameraRigPrefab UCameraRigAsset
function UBlueprintCameraDirectorEvaluator:ActivatePersistentVisualCameraRig(CameraRigPrefab) end
---@param CameraRigPrefab UCameraRigAsset
function UBlueprintCameraDirectorEvaluator:ActivatePersistentGlobalCameraRig(CameraRigPrefab) end
---@param CameraRigPrefab UCameraRigAsset
function UBlueprintCameraDirectorEvaluator:ActivatePersistentBaseCameraRig(CameraRigPrefab) end
---@param CameraRigProxy UCameraRigProxyAsset
function UBlueprintCameraDirectorEvaluator:ActivateCameraRigViaProxy(CameraRigProxy) end
---@param CameraRig UCameraRigAsset
function UBlueprintCameraDirectorEvaluator:ActivateCameraRigPrefab(CameraRig) end
---@param CameraRig UCameraRigAsset
function UBlueprintCameraDirectorEvaluator:ActivateCameraRig(CameraRig) end
---@param Params FBlueprintCameraDirectorActivateParams
function UBlueprintCameraDirectorEvaluator:ActivateCameraDirector(Params) end


---@class UBlueprintCameraNode : UCameraNode
---@field CameraNodeEvaluatorClass TSubclassOf<UBlueprintCameraNodeEvaluator>
local UBlueprintCameraNode = {}



---@class UBlueprintCameraNodeEvaluator : UObject
---@field bIsFirstFrame boolean
---@field EvaluationContextOwner UObject
---@field CameraPose FBlueprintCameraPose
---@field VariableTable FBlueprintCameraVariableTable
local UBlueprintCameraNodeEvaluator = {}

---@param DeltaTime float
function UBlueprintCameraNodeEvaluator:TickCameraNode(DeltaTime) end
---@param ActorClass TSubclassOf<AActor>
---@return AActor
function UBlueprintCameraNodeEvaluator:FindEvaluationContextOwnerActor(ActorClass) end


---@class UBlueprintCameraPoseFunctionLibrary : UBlueprintFunctionLibrary
local UBlueprintCameraPoseFunctionLibrary = {}

---@param CameraPose FBlueprintCameraPose
---@param Transform FTransform
---@return FBlueprintCameraPose
function UBlueprintCameraPoseFunctionLibrary:SetTransform(CameraPose, Transform) end
---@param CameraPose FBlueprintCameraPose
---@param TargetDistance double
---@return FBlueprintCameraPose
function UBlueprintCameraPoseFunctionLibrary:SetTargetDistance(CameraPose, TargetDistance) end
---@param CameraPose FBlueprintCameraPose
---@param Rotation FRotator
---@return FBlueprintCameraPose
function UBlueprintCameraPoseFunctionLibrary:SetRotation(CameraPose, Rotation) end
---@param CameraPose FBlueprintCameraPose
---@param Location FVector
---@return FBlueprintCameraPose
function UBlueprintCameraPoseFunctionLibrary:SetLocation(CameraPose, Location) end
---@param CameraPose FBlueprintCameraPose
---@param FocalLength float
---@return FBlueprintCameraPose
function UBlueprintCameraPoseFunctionLibrary:SetFocalLength(CameraPose, FocalLength) end
---@param CameraPose FBlueprintCameraPose
---@param FieldOfView float
---@return FBlueprintCameraPose
function UBlueprintCameraPoseFunctionLibrary:SetFieldOfView(CameraPose, FieldOfView) end
---@param CameraComponent UCineCameraComponent
---@return FBlueprintCameraPose
function UBlueprintCameraPoseFunctionLibrary:MakeCameraPoseFromCineCameraComponent(CameraComponent) end
---@param CameraComponent UCameraComponent
---@return FBlueprintCameraPose
function UBlueprintCameraPoseFunctionLibrary:MakeCameraPoseFromCameraComponent(CameraComponent) end
---@param CameraPose FBlueprintCameraPose
---@return FTransform
function UBlueprintCameraPoseFunctionLibrary:GetTransform(CameraPose) end
---@param CameraPose FBlueprintCameraPose
---@return double
function UBlueprintCameraPoseFunctionLibrary:GetTargetDistance(CameraPose) end
---@param CameraPose FBlueprintCameraPose
---@param TargetDistance double
---@return FVector
function UBlueprintCameraPoseFunctionLibrary:GetTargetAtDistance(CameraPose, TargetDistance) end
---@param CameraPose FBlueprintCameraPose
---@return FVector
function UBlueprintCameraPoseFunctionLibrary:GetTarget(CameraPose) end
---@param CameraPose FBlueprintCameraPose
---@return double
function UBlueprintCameraPoseFunctionLibrary:GetSensorAspectRatio(CameraPose) end
---@param CameraPose FBlueprintCameraPose
---@return FRotator
function UBlueprintCameraPoseFunctionLibrary:GetRotation(CameraPose) end
---@param CameraPose FBlueprintCameraPose
---@return FVector
function UBlueprintCameraPoseFunctionLibrary:GetLocation(CameraPose) end
---@param CameraPose FBlueprintCameraPose
---@return double
function UBlueprintCameraPoseFunctionLibrary:GetFocalLength(CameraPose) end
---@param CameraPose FBlueprintCameraPose
---@return double
function UBlueprintCameraPoseFunctionLibrary:GetFieldOfView(CameraPose) end
---@param CameraPose FBlueprintCameraPose
---@return double
function UBlueprintCameraPoseFunctionLibrary:GetEffectiveFieldOfView(CameraPose) end
---@param CameraPose FBlueprintCameraPose
---@return FRay
function UBlueprintCameraPoseFunctionLibrary:GetAimRay(CameraPose) end
---@param CameraPose FBlueprintCameraPose
---@return FVector
function UBlueprintCameraPoseFunctionLibrary:GetAimDir(CameraPose) end


---@class UBlueprintCameraVariableTableFunctionLibrary : UBlueprintFunctionLibrary
local UBlueprintCameraVariableTableFunctionLibrary = {}

---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UVector4dCameraVariable
---@param Value FVector4
function UBlueprintCameraVariableTableFunctionLibrary:SetVector4CameraVariable(VariableTable, Variable, Value) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UVector3dCameraVariable
---@param Value FVector
function UBlueprintCameraVariableTableFunctionLibrary:SetVector3CameraVariable(VariableTable, Variable, Value) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UVector2dCameraVariable
---@param Value FVector2D
function UBlueprintCameraVariableTableFunctionLibrary:SetVector2CameraVariable(VariableTable, Variable, Value) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UTransform3dCameraVariable
---@param Value FTransform
function UBlueprintCameraVariableTableFunctionLibrary:SetTransformCameraVariable(VariableTable, Variable, Value) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable URotator3dCameraVariable
---@param Value FRotator
function UBlueprintCameraVariableTableFunctionLibrary:SetRotatorCameraVariable(VariableTable, Variable, Value) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UInteger32CameraVariable
---@param Value int32
function UBlueprintCameraVariableTableFunctionLibrary:SetInteger32CameraVariable(VariableTable, Variable, Value) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UFloatCameraVariable
---@param Value float
function UBlueprintCameraVariableTableFunctionLibrary:SetFloatCameraVariable(VariableTable, Variable, Value) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UDoubleCameraVariable
---@param Value double
function UBlueprintCameraVariableTableFunctionLibrary:SetDoubleCameraVariable(VariableTable, Variable, Value) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UBooleanCameraVariable
---@param Value boolean
function UBlueprintCameraVariableTableFunctionLibrary:SetBooleanCameraVariable(VariableTable, Variable, Value) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UVector4dCameraVariable
---@return FVector4
function UBlueprintCameraVariableTableFunctionLibrary:GetVector4CameraVariable(VariableTable, Variable) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UVector3dCameraVariable
---@return FVector
function UBlueprintCameraVariableTableFunctionLibrary:GetVector3CameraVariable(VariableTable, Variable) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UVector2dCameraVariable
---@return FVector2D
function UBlueprintCameraVariableTableFunctionLibrary:GetVector2CameraVariable(VariableTable, Variable) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UTransform3dCameraVariable
---@return FTransform
function UBlueprintCameraVariableTableFunctionLibrary:GetTransformCameraVariable(VariableTable, Variable) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable URotator3dCameraVariable
---@return FRotator
function UBlueprintCameraVariableTableFunctionLibrary:GetRotatorCameraVariable(VariableTable, Variable) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UInteger32CameraVariable
---@return int32
function UBlueprintCameraVariableTableFunctionLibrary:GetInteger32CameraVariable(VariableTable, Variable) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UFloatCameraVariable
---@return float
function UBlueprintCameraVariableTableFunctionLibrary:GetFloatCameraVariable(VariableTable, Variable) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UDoubleCameraVariable
---@return double
function UBlueprintCameraVariableTableFunctionLibrary:GetDoubleCameraVariable(VariableTable, Variable) end
---@param VariableTable FBlueprintCameraVariableTable
---@param Variable UBooleanCameraVariable
---@return boolean
function UBlueprintCameraVariableTableFunctionLibrary:GetBooleanCameraVariable(VariableTable, Variable) end


---@class UBooleanCameraVariable : UCameraVariableAsset
---@field bDefaultValue boolean
local UBooleanCameraVariable = {}



---@class UBoomArmCameraNode : UCameraNode
---@field BoomOffset FVector3dCameraParameter
---@field BoomLengthInterpolator UCameraValueInterpolator
---@field MaxForwardInterpolationFactor FDoubleCameraParameter
---@field MaxBackwardInterpolationFactor FDoubleCameraParameter
---@field InputSlot UInput2DCameraNode
local UBoomArmCameraNode = {}



---@class UCameraAsset : UObject
---@field CameraDirector UCameraDirector
---@field CameraRigs TArray<UCameraRigAsset>
---@field EnterTransitions TArray<UCameraRigTransition>
---@field ExitTransitions TArray<UCameraRigTransition>
---@field BuildStatus ECameraBuildStatus
local UCameraAsset = {}



---@class UCameraDirector : UObject
local UCameraDirector = {}


---@class UCameraDirectorStateTreeSchema : UStateTreeSchema
---@field ContextDataDescs TArray<FStateTreeExternalDataDesc>
local UCameraDirectorStateTreeSchema = {}



---@class UCameraNode : UObject
---@field bIsEnabled boolean
local UCameraNode = {}



---@class UCameraRigAsset : UObject
---@field RootNode UCameraNode
---@field GameplayTags FGameplayTagContainer
---@field Interface FCameraRigInterface
---@field EnterTransitions TArray<UCameraRigTransition>
---@field ExitTransitions TArray<UCameraRigTransition>
---@field InitialOrientation ECameraRigInitialOrientation
---@field AllocationInfo FCameraRigAllocationInfo
---@field BuildStatus ECameraBuildStatus
---@field Guid FGuid
local UCameraRigAsset = {}



---@class UCameraRigCameraNode : UCameraNode
---@field CameraRigReference FCameraRigAssetReference
---@field CameraRig UCameraRigAsset
---@field BooleanOverrides TArray<FBooleanCameraRigParameterOverride>
---@field Integer32Overrides TArray<FInteger32CameraRigParameterOverride>
---@field FloatOverrides TArray<FFloatCameraRigParameterOverride>
---@field DoubleOverrides TArray<FDoubleCameraRigParameterOverride>
---@field Vector2fOverrides TArray<FVector2fCameraRigParameterOverride>
---@field Vector2dOverrides TArray<FVector2dCameraRigParameterOverride>
---@field Vector3fOverrides TArray<FVector3fCameraRigParameterOverride>
---@field Vector3dOverrides TArray<FVector3dCameraRigParameterOverride>
---@field Vector4fOverrides TArray<FVector4fCameraRigParameterOverride>
---@field Vector4dOverrides TArray<FVector4dCameraRigParameterOverride>
---@field Rotator3fOverrides TArray<FRotator3fCameraRigParameterOverride>
---@field Rotator3dOverrides TArray<FRotator3dCameraRigParameterOverride>
---@field Transform3fOverrides TArray<FTransform3fCameraRigParameterOverride>
---@field Transform3dOverrides TArray<FTransform3dCameraRigParameterOverride>
local UCameraRigCameraNode = {}



---@class UCameraRigInput1DSlot : UInput1DCameraNode
---@field InputSlotParameters FCameraRigInputSlotParameters
---@field clamp FCameraParameterClamping
---@field Normalize FCameraParameterNormalization
---@field BuiltInVariable EBuiltInDoubleCameraVariable
---@field CustomVariable FDoubleCameraVariableReference
---@field TransientVariableID FCameraVariableID
---@field VariableID FCameraVariableID
local UCameraRigInput1DSlot = {}



---@class UCameraRigInput2DSlot : UInput2DCameraNode
---@field InputSlotParameters FCameraRigInputSlotParameters
---@field ClampX FCameraParameterClamping
---@field ClampY FCameraParameterClamping
---@field NormalizeX FCameraParameterNormalization
---@field NormalizeY FCameraParameterNormalization
---@field BuiltInVariable EBuiltInVector2dCameraVariable
---@field CustomVariable FVector2dCameraVariableReference
---@field TransientVariableID FCameraVariableID
---@field VariableID FCameraVariableID
local UCameraRigInput2DSlot = {}



---@class UCameraRigInterfaceParameter : UObject
---@field Target UCameraNode
---@field TargetPropertyName FName
---@field InterfaceParameterName FString
---@field Guid FGuid
---@field PrivateVariable UCameraVariableAsset
local UCameraRigInterfaceParameter = {}



---@class UCameraRigParameterInterop : UBlueprintFunctionLibrary
local UCameraRigParameterInterop = {}

---@param VariableTable FBlueprintCameraVariableTable
---@param CameraRig UCameraRigAsset
---@param ParameterName FString
---@param ParameterValue FVector4
function UCameraRigParameterInterop:SetVector4Parameter(VariableTable, CameraRig, ParameterName, ParameterValue) end
---@param VariableTable FBlueprintCameraVariableTable
---@param CameraRig UCameraRigAsset
---@param ParameterName FString
---@param ParameterValue FVector
function UCameraRigParameterInterop:SetVector3Parameter(VariableTable, CameraRig, ParameterName, ParameterValue) end
---@param VariableTable FBlueprintCameraVariableTable
---@param CameraRig UCameraRigAsset
---@param ParameterName FString
---@param ParameterValue FVector2D
function UCameraRigParameterInterop:SetVector2Parameter(VariableTable, CameraRig, ParameterName, ParameterValue) end
---@param VariableTable FBlueprintCameraVariableTable
---@param CameraRig UCameraRigAsset
---@param ParameterName FString
---@param ParameterValue FTransform
function UCameraRigParameterInterop:SetTransformParameter(VariableTable, CameraRig, ParameterName, ParameterValue) end
---@param VariableTable FBlueprintCameraVariableTable
---@param CameraRig UCameraRigAsset
---@param ParameterName FString
---@param ParameterValue FRotator
function UCameraRigParameterInterop:SetRotatorParameter(VariableTable, CameraRig, ParameterName, ParameterValue) end
---@param VariableTable FBlueprintCameraVariableTable
---@param CameraRig UCameraRigAsset
---@param ParameterName FString
---@param ParameterValue int32
function UCameraRigParameterInterop:SetIntegerParameter(VariableTable, CameraRig, ParameterName, ParameterValue) end
---@param VariableTable FBlueprintCameraVariableTable
---@param CameraRig UCameraRigAsset
---@param ParameterName FString
---@param ParameterValue double
function UCameraRigParameterInterop:SetFloatParameter(VariableTable, CameraRig, ParameterName, ParameterValue) end
---@param VariableTable FBlueprintCameraVariableTable
---@param CameraRig UCameraRigAsset
---@param ParameterName FString
---@param ParameterValue double
function UCameraRigParameterInterop:SetDoubleParameter(VariableTable, CameraRig, ParameterName, ParameterValue) end
---@param VariableTable FBlueprintCameraVariableTable
---@param CameraRig UCameraRigAsset
---@param ParameterName FString
---@param bParameterValue boolean
function UCameraRigParameterInterop:SetBooleanParameter(VariableTable, CameraRig, ParameterName, bParameterValue) end


---@class UCameraRigProxyAsset : UObject
---@field Guid FGuid
local UCameraRigProxyAsset = {}



---@class UCameraRigProxyTable : UObject
---@field Entries TArray<FCameraRigProxyTableEntry>
local UCameraRigProxyTable = {}



---@class UCameraRigTransition : UObject
---@field Conditions TArray<UCameraRigTransitionCondition>
---@field Blend UBlendCameraNode
---@field InitialOrientation ECameraRigInitialOrientation
---@field bOverrideInitialOrientation boolean
---@field bAllowCameraRigMerging boolean
local UCameraRigTransition = {}



---@class UCameraRigTransitionCondition : UObject
local UCameraRigTransitionCondition = {}


---@class UCameraValueInterpolator : UObject
local UCameraValueInterpolator = {}


---@class UCameraVariableAsset : UObject
---@field bAutoReset boolean
---@field bIsPrivate boolean
---@field bIsInput boolean
---@field Guid FGuid
local UCameraVariableAsset = {}



---@class UCameraVariableCollection : UObject
---@field Variables TArray<UCameraVariableAsset>
local UCameraVariableCollection = {}



---@class UClippingPlanesCameraNode : UCameraNode
---@field NearPlane FDoubleCameraParameter
---@field FarPlane FDoubleCameraParameter
local UClippingPlanesCameraNode = {}



---@class UCollisionPushCameraNode : UCameraNode
---@field SafePosition ECollisionSafePosition
---@field CustomSafePosition FVector3dCameraVariableReference
---@field SafePositionOffset FVector3dCameraParameter
---@field SafePositionOffsetSpace ECollisionSafePositionOffsetSpace
---@field EnableCollision FBooleanCameraVariableReference
---@field CollisionSphereRadius FFloatCameraParameter
---@field CollisionChannel ECollisionChannel
---@field PushInterpolator UCameraValueInterpolator
---@field PullInterpolator UCameraValueInterpolator
---@field bRunAsyncCollision boolean
local UCollisionPushCameraNode = {}



---@class UCombinedCameraRigsCameraNode : UCameraNode
---@field CameraRigReferences TArray<FCameraRigAssetReference>
local UCombinedCameraRigsCameraNode = {}



---@class UControllerGameplayCameraEvaluationComponent : UActorComponent
---@field CameraSystemHost UGameplayCameraSystemHost
local UControllerGameplayCameraEvaluationComponent = {}



---@class UCriticalDamperValueInterpolator : UCameraValueInterpolator
---@field DampingFactor float
local UCriticalDamperValueInterpolator = {}



---@class UDampenPositionCameraNode : UCameraNode
---@field ForwardDampingFactor FFloatCameraParameter
---@field LateralDampingFactor FFloatCameraParameter
---@field VerticalDampingFactor FFloatCameraParameter
---@field DampenSpace ECameraNodeSpace
local UDampenPositionCameraNode = {}



---@class UDefaultRootCameraNode : URootCameraNode
---@field BaseLayer UBlendStackCameraNode
---@field MainLayer UBlendStackCameraNode
---@field GlobalLayer UBlendStackCameraNode
---@field VisualLayer UBlendStackCameraNode
local UDefaultRootCameraNode = {}



---@class UDollyFramingCameraNode : UBaseFramingCameraNode
---@field CanMoveLaterally FBooleanCameraParameter
---@field CanMoveVertically FBooleanCameraParameter
local UDollyFramingCameraNode = {}



---@class UDoubleCameraVariable : UCameraVariableAsset
---@field DefaultValue double
local UDoubleCameraVariable = {}



---@class UDoubleIIRValueInterpolator : UCameraValueInterpolator
---@field PrimarySpeed float
---@field IntermediateSpeed float
---@field bUseFixedStep boolean
local UDoubleIIRValueInterpolator = {}



---@class UFieldOfViewCameraNode : UCameraNode
---@field FieldOfView FFloatCameraParameter
local UFieldOfViewCameraNode = {}



---@class UFilmbackCameraNode : UCameraNode
---@field SensorWidth FFloatCameraParameter
---@field SensorHeight FFloatCameraParameter
---@field ISO FFloatCameraParameter
---@field ConstrainAspectRatio FBooleanCameraParameter
---@field OverrideAspectRatioAxisConstraint FBooleanCameraParameter
---@field AspectRatioAxisConstraint EAspectRatioAxisConstraint
local UFilmbackCameraNode = {}



---@class UFloatCameraVariable : UCameraVariableAsset
---@field DefaultValue float
local UFloatCameraVariable = {}



---@class UGameplayCameraComponent : USceneComponent
---@field Camera UCameraAsset
---@field AutoActivateForPlayer EAutoReceiveInput::Type
---@field CameraSystemHost UGameplayCameraSystemHost
local UGameplayCameraComponent = {}

---@param CameraPose FBlueprintCameraPose
function UGameplayCameraComponent:SetInitialPose(CameraPose) end
---@return FBlueprintCameraVariableTable
function UGameplayCameraComponent:GetInitialVariableTable() end
---@return FBlueprintCameraPose
function UGameplayCameraComponent:GetInitialPose() end
function UGameplayCameraComponent:DeactivateCamera() end
---@param PlayerIndex int32
function UGameplayCameraComponent:ActivateCameraForPlayerIndex(PlayerIndex) end
---@param PlayerController APlayerController
function UGameplayCameraComponent:ActivateCameraForPlayerController(PlayerController) end


---@class UGameplayCameraSystemComponent : USceneComponent
---@field AutoActivateForPlayer EAutoReceiveInput::Type
---@field bSetPlayerControllerRotation boolean
---@field CameraSystemHost UGameplayCameraSystemHost
---@field WeakPlayerController TWeakObjectPtr<APlayerController>
local UGameplayCameraSystemComponent = {}

---@param PlayerController APlayerController
---@return boolean
function UGameplayCameraSystemComponent:IsCameraSystemActiveForPlayController(PlayerController) end
---@param NextViewTarget AActor
function UGameplayCameraSystemComponent:DeactivateCameraSystem(NextViewTarget) end
---@param PlayerIndex int32
function UGameplayCameraSystemComponent:ActivateCameraSystemForPlayerIndex(PlayerIndex) end
---@param PlayerController APlayerController
function UGameplayCameraSystemComponent:ActivateCameraSystemForPlayerController(PlayerController) end


---@class UGameplayCameraSystemHost : UObject
local UGameplayCameraSystemHost = {}


---@class UGameplayCamerasSettings : UDeveloperSettings
---@field bAutoSpawnCameraSystemActor boolean
---@field bAutoSpawnCameraSystemActorSetsControlRotation boolean
---@field CombinedCameraRigNumThreshold int32
---@field DefaultIKAimingAngleTolerance double
---@field DefaultIKAimingDistanceTolerance double
---@field DefaultIKAimingMaxIterations uint8
---@field DefaultIKAimingMinDistance double
local UGameplayCamerasSettings = {}



---@class UGameplayControlRotationComponent : UActorComponent
---@field AxisActions TArray<UInputAction>
---@field AxisActionAngularSpeedThreshold float
---@field AxisActionMagnitudeThreshold float
---@field AutoActivateForPlayer EAutoReceiveInput::Type
---@field PlayerController APlayerController
---@field CameraSystemHost UGameplayCameraSystemHost
local UGameplayControlRotationComponent = {}

function UGameplayControlRotationComponent:DeactivateControlRotationManagement() end
---@param PlayerIndex int32
function UGameplayControlRotationComponent:ActivateControlRotationManagementForPlayerIndex(PlayerIndex) end
---@param PlayerController APlayerController
function UGameplayControlRotationComponent:ActivateControlRotationManagementForPlayerController(PlayerController) end


---@class UGameplayTagTransitionCondition : UCameraRigTransitionCondition
---@field PreviousGameplayTagQuery FGameplayTagQuery
---@field NextGameplayTagQuery FGameplayTagQuery
local UGameplayTagTransitionCondition = {}



---@class UIIRValueInterpolator : UCameraValueInterpolator
---@field Speed float
---@field bUseFixedStep boolean
local UIIRValueInterpolator = {}



---@class UInput1DCameraNode : UCameraNode
local UInput1DCameraNode = {}


---@class UInput2DCameraNode : UCameraNode
local UInput2DCameraNode = {}


---@class UInputAxisBinding2DCameraNode : UCameraRigInput2DSlot
---@field AxisActions TArray<UInputAction>
---@field RevertAxisX FBooleanCameraParameter
---@field RevertAxisY FBooleanCameraParameter
---@field Multiplier FVector2dCameraParameter
local UInputAxisBinding2DCameraNode = {}



---@class UInteger32CameraVariable : UCameraVariableAsset
---@field DefaultValue int32
local UInteger32CameraVariable = {}



---@class UIsCameraRigTransitionCondition : UCameraRigTransitionCondition
---@field PreviousCameraRig UCameraRigAsset
---@field NextCameraRig UCameraRigAsset
local UIsCameraRigTransitionCondition = {}



---@class ULensParametersCameraNode : UCameraNode
---@field FocalLength FFloatCameraParameter
---@field FocusDistance FFloatCameraParameter
---@field Aperture FFloatCameraParameter
---@field ShutterSpeed FFloatCameraParameter
---@field EnablePhysicalCamera FBooleanCameraParameter
local ULensParametersCameraNode = {}



---@class ULinearBlendCameraNode : USimpleFixedTimeBlendCameraNode
local ULinearBlendCameraNode = {}


---@class UOcclusionMaterialCameraNode : UCameraNode
---@field OcclusionTransparencyMaterial UMaterialInterface
---@field OcclusionSphereRadius FFloatCameraParameter
---@field OcclusionChannel ECollisionChannel
---@field OcclusionTargetPosition ECameraNodeOriginPosition
---@field OcclusionTargetOffsetSpace ECameraNodeSpace
---@field OcclusionTargetOffset FVector3dCameraParameter
local UOcclusionMaterialCameraNode = {}



---@class UOffsetCameraNode : UCameraNode
---@field TranslationOffset FVector3dCameraParameter
---@field RotationOffset FRotator3dCameraParameter
---@field OffsetSpace ECameraNodeSpace
local UOffsetCameraNode = {}



---@class UOrbitBlendCameraNode : UBlendCameraNode
---@field DrivingBlend USimpleBlendCameraNode
local UOrbitBlendCameraNode = {}



---@class UPanningFramingCameraNode : UBaseFramingCameraNode
---@field CanPanLaterally FBooleanCameraParameter
---@field CanPanVertically FBooleanCameraParameter
local UPanningFramingCameraNode = {}



---@class UPopBlendCameraNode : UBlendCameraNode
local UPopBlendCameraNode = {}


---@class UPopValueInterpolator : UCameraValueInterpolator
local UPopValueInterpolator = {}


---@class UPostProcessCameraNode : UCameraNode
---@field PostProcessSettings FPostProcessSettings
local UPostProcessCameraNode = {}



---@class UPriorityQueueCameraDirector : UCameraDirector
local UPriorityQueueCameraDirector = {}


---@class URootCameraNode : UCameraNode
local URootCameraNode = {}


---@class URotator3dCameraVariable : UCameraVariableAsset
---@field DefaultValue FRotator3d
local URotator3dCameraVariable = {}



---@class URotator3fCameraVariable : UCameraVariableAsset
---@field DefaultValue FRotator3f
local URotator3fCameraVariable = {}



---@class USimpleBlendCameraNode : UBlendCameraNode
local USimpleBlendCameraNode = {}


---@class USimpleFixedTimeBlendCameraNode : USimpleBlendCameraNode
---@field BlendTime float
local USimpleFixedTimeBlendCameraNode = {}



---@class USingleCameraDirector : UCameraDirector
---@field CameraRig UCameraRigAsset
local USingleCameraDirector = {}



---@class USmoothBlendCameraNode : USimpleFixedTimeBlendCameraNode
---@field BlendType ESmoothCameraBlendType
local USmoothBlendCameraNode = {}



---@class UStateTreeCameraDirector : UCameraDirector
---@field StateTreeReference FStateTreeReference
---@field CameraRigProxyTable UCameraRigProxyTable
local UStateTreeCameraDirector = {}



---@class UTargetRayCastCameraNode : UCameraNode
---@field TraceChannel ECollisionChannel
---@field AutoFocus FBooleanCameraParameter
local UTargetRayCastCameraNode = {}



---@class UTransform3dCameraVariable : UCameraVariableAsset
---@field DefaultValue FTransform3d
local UTransform3dCameraVariable = {}



---@class UTransform3fCameraVariable : UCameraVariableAsset
---@field DefaultValue FTransform3f
local UTransform3fCameraVariable = {}



---@class UVector2dCameraVariable : UCameraVariableAsset
---@field DefaultValue FVector2D
local UVector2dCameraVariable = {}



---@class UVector2fCameraVariable : UCameraVariableAsset
---@field DefaultValue FVector2f
local UVector2fCameraVariable = {}



---@class UVector3dCameraVariable : UCameraVariableAsset
---@field DefaultValue FVector3d
local UVector3dCameraVariable = {}



---@class UVector3fCameraVariable : UCameraVariableAsset
---@field DefaultValue FVector3f
local UVector3fCameraVariable = {}



---@class UVector4dCameraVariable : UCameraVariableAsset
---@field DefaultValue FVector4d
local UVector4dCameraVariable = {}



---@class UVector4fCameraVariable : UCameraVariableAsset
---@field DefaultValue FVector4f
local UVector4fCameraVariable = {}



