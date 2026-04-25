---@meta

---@class AControlRigControlActor : AActor
---@field ActorToTrack AActor
---@field ControlRigClass TSubclassOf<UControlRig>
---@field bRefreshOnTick boolean
---@field bIsSelectable boolean
---@field MaterialOverride UMaterialInterface
---@field ColorParameter FString
---@field bCastShadows boolean
---@field ActorRootComponent USceneComponent
---@field ControlRig TSoftObjectPtr<UControlRig>
---@field ControlNames TArray<FName>
---@field ShapeTransforms TArray<FTransform>
---@field Components TArray<UStaticMeshComponent>
---@field Materials TArray<UMaterialInstanceDynamic>
---@field ColorParameterName FName
local AControlRigControlActor = {}

function AControlRigControlActor:ResetControlActor() end
function AControlRigControlActor:Refresh() end
function AControlRigControlActor:Clear() end


---@class AControlRigShapeActor : AActor
---@field ActorRootComponent USceneComponent
---@field StaticMeshComponent UStaticMeshComponent
---@field ControlRigIndex uint32
---@field ControlRig TWeakObjectPtr<UControlRig>
---@field ControlName FName
---@field ShapeName FName
---@field ColorParameterName FName
---@field bSelected boolean
---@field bHovered boolean
local AControlRigShapeActor = {}

---@param bInSelected boolean
function AControlRigShapeActor:SetSelected(bInSelected) end
---@param bInSelectable boolean
function AControlRigShapeActor:SetSelectable(bInSelectable) end
---@param bInHovered boolean
function AControlRigShapeActor:SetHovered(bInHovered) end
---@param InTransform FTransform
function AControlRigShapeActor:SetGlobalTransform(InTransform) end
---@param bInEnabled boolean
function AControlRigShapeActor:SetEnabled(bInEnabled) end
---@param NewTransform FTransform
function AControlRigShapeActor:OnTransformChanged(NewTransform) end
---@param bIsSelected boolean
function AControlRigShapeActor:OnSelectionChanged(bIsSelected) end
---@param bIsManipulating boolean
function AControlRigShapeActor:OnManipulatingChanged(bIsManipulating) end
---@param bIsSelected boolean
function AControlRigShapeActor:OnHoveredChanged(bIsSelected) end
---@param bIsEnabled boolean
function AControlRigShapeActor:OnEnabledChanged(bIsEnabled) end
---@return boolean
function AControlRigShapeActor:IsSelectedInEditor() end
---@return boolean
function AControlRigShapeActor:IsHovered() end
---@return boolean
function AControlRigShapeActor:IsEnabled() end
---@return FTransform
function AControlRigShapeActor:GetGlobalTransform() end


---@class FAimTarget
---@field Weight float
---@field Transform FTransform
---@field AlignVector FVector
local FAimTarget = {}



---@class FAnimNode_ControlRig : FAnimNode_ControlRigBase
---@field ControlRigClass TSubclassOf<UControlRig>
---@field DefaultControlRigClass TSubclassOf<UControlRig>
---@field ControlRig UControlRig
---@field ControlRigPerClass TMap<UClass, UControlRig>
---@field Alpha float
---@field AlphaInputType EAnimAlphaInputType
---@field bAlphaBoolEnabled boolean
---@field bSetRefPoseFromSkeleton boolean
---@field AlphaScaleBias FInputScaleBias
---@field AlphaBoolBlend FInputAlphaBoolBlend
---@field AlphaCurveName FName
---@field AlphaScaleBiasClamp FInputScaleBiasClamp
---@field InputMapping TMap<FName, FName>
---@field OutputMapping TMap<FName, FName>
---@field LODThreshold int32
local FAnimNode_ControlRig = {}



---@class FAnimNode_ControlRigBase : FAnimNode_CustomProperty
---@field Source FPoseLink
---@field bResetInputPoseToInitial boolean
---@field bTransferInputPose boolean
---@field bTransferInputCurves boolean
---@field bTransferPoseInGlobalSpace boolean
---@field InputBonesToTransfer TArray<FBoneReference>
---@field OutputBonesToTransfer TArray<FBoneReference>
---@field AssetUserData TArray<UAssetUserData>
---@field NodeMappingContainer TWeakObjectPtr<UNodeMappingContainer>
---@field InputSettings FControlRigIOSettings
---@field OutputSettings FControlRigIOSettings
---@field bExecute boolean
---@field EventQueue TArray<FControlRigAnimNodeEventName>
local FAnimNode_ControlRigBase = {}



---@class FAnimNode_ControlRigInputPose : FAnimNode_Base
---@field InputPose FPoseLink
local FAnimNode_ControlRigInputPose = {}



---@class FAnimNode_ControlRig_ExternalSource : FAnimNode_ControlRigBase
---@field ControlRig TWeakObjectPtr<UControlRig>
local FAnimNode_ControlRig_ExternalSource = {}



---@class FAnimationHierarchy : FNodeHierarchyWithUserData
---@field UserData TArray<FConstraintNodeData>
local FAnimationHierarchy = {}



---@class FBlendTarget
---@field Transform FTransform
---@field Weight float
local FBlendTarget = {}



---@class FCRSimContainer
---@field TimeStep float
---@field AccumulatedTime float
---@field TimeLeftForStep float
local FCRSimContainer = {}



---@class FCRSimLinearSpring
---@field SubjectA int32
---@field SubjectB int32
---@field Coefficient float
---@field Equilibrium float
local FCRSimLinearSpring = {}



---@class FCRSimPointConstraint
---@field Type ECRSimConstraintType
---@field SubjectA int32
---@field SubjectB int32
---@field DataA FVector
---@field DataB FVector
local FCRSimPointConstraint = {}



---@class FCRSimPointContainer : FCRSimContainer
---@field Points TArray<FRigVMSimPoint>
---@field Springs TArray<FCRSimLinearSpring>
---@field Forces TArray<FCRSimPointForce>
---@field CollisionVolumes TArray<FCRSimSoftCollision>
---@field Constraints TArray<FCRSimPointConstraint>
---@field PreviousStep TArray<FRigVMSimPoint>
local FCRSimPointContainer = {}



---@class FCRSimPointForce
---@field ForceType ECRSimPointForceType
---@field Vector FVector
---@field Coefficient float
---@field bNormalize boolean
local FCRSimPointForce = {}



---@class FCRSimSoftCollision
---@field Transform FTransform
---@field ShapeType ECRSimSoftCollisionType
---@field MinimumDistance float
---@field MaximumDistance float
---@field FalloffType ERigVMAnimEasingType
---@field Coefficient float
---@field bInverted boolean
local FCRSimSoftCollision = {}



---@class FCachedRigElement
---@field Key FRigElementKey
---@field Index uint16
---@field ContainerVersion int32
local FCachedRigElement = {}



---@class FChannelMapInfo
---@field ControlIndex int32
---@field TotalChannelIndex int32
---@field ChannelIndex int32
---@field ParentControlIndex int32
---@field ChannelTypeName FName
---@field bDoesHaveSpace boolean
---@field SpaceChannelIndex int32
---@field MaskIndex int32
---@field CategoryIndex int32
---@field ConstraintsIndex TArray<uint32>
local FChannelMapInfo = {}



---@class FConstraintNodeData
---@field RelativeParent FTransform
---@field ConstraintOffset FConstraintOffset
---@field LinkedNode FName
---@field Constraints TArray<FTransformConstraint>
local FConstraintNodeData = {}



---@class FConstraintParent
---@field Item FRigElementKey
---@field Weight float
local FConstraintParent = {}



---@class FConstraintTarget
---@field Transform FTransform
---@field Weight float
---@field bMaintainOffset boolean
---@field Filter FTransformFilter
local FConstraintTarget = {}



---@class FControlRigAnimInstanceProxy : FAnimInstanceProxy
local FControlRigAnimInstanceProxy = {}


---@class FControlRigAnimNodeEventName
---@field EventName FName
local FControlRigAnimNodeEventName = {}



---@class FControlRigComponentMappedBone
---@field Source FName
---@field Target FName
local FControlRigComponentMappedBone = {}



---@class FControlRigComponentMappedComponent
---@field Component USceneComponent
---@field ElementName FName
---@field ElementType ERigElementType
---@field Direction EControlRigComponentMapDirection
local FControlRigComponentMappedComponent = {}



---@class FControlRigComponentMappedCurve
---@field Source FName
---@field Target FName
local FControlRigComponentMappedCurve = {}



---@class FControlRigComponentMappedElement
---@field ComponentReference FSoftComponentReference
---@field TransformIndex int32
---@field TransformName FName
---@field ElementType ERigElementType
---@field ElementName FName
---@field Direction EControlRigComponentMapDirection
---@field Offset FTransform
---@field Weight float
---@field Space EControlRigComponentSpace
---@field SceneComponent USceneComponent
---@field ElementIndex int32
---@field SubIndex int32
local FControlRigComponentMappedElement = {}



---@class FControlRigControlPose
---@field CopyOfControls TArray<FRigControlCopy>
local FControlRigControlPose = {}



---@class FControlRigExecuteContext : FRigVMExecuteContext
local FControlRigExecuteContext = {}


---@class FControlRigIOSettings
---@field bUpdatePose boolean
---@field bUpdateCurves boolean
local FControlRigIOSettings = {}



---@class FControlRigLayerInstanceProxy : FAnimInstanceProxy
local FControlRigLayerInstanceProxy = {}


---@class FControlRigReference : FAnimNodeReference
local FControlRigReference = {}


---@class FControlRigSequenceObjectReference
---@field ControlRigClass TSubclassOf<UControlRig>
local FControlRigSequenceObjectReference = {}



---@class FControlRigSequenceObjectReferenceMap
---@field BindingIds TArray<FGuid>
---@field References TArray<FControlRigSequenceObjectReferences>
local FControlRigSequenceObjectReferenceMap = {}



---@class FControlRigSequenceObjectReferences
---@field Array TArray<FControlRigSequenceObjectReference>
local FControlRigSequenceObjectReferences = {}



---@class FControlRigSettingsPerPinBool
---@field Values TMap<FString, boolean>
local FControlRigSettingsPerPinBool = {}



---@class FControlRigShapeDefinition
---@field ShapeName FName
---@field StaticMesh TSoftObjectPtr<UStaticMesh>
---@field Transform FTransform
local FControlRigShapeDefinition = {}



---@class FControlRigTestDataFrame
---@field AbsoluteTime double
---@field DeltaTime double
---@field Variables TArray<FControlRigTestDataVariable>
---@field Pose FRigPose
local FControlRigTestDataFrame = {}



---@class FControlRigTestDataVariable
---@field Name FName
---@field CPPType FName
---@field Value FString
local FControlRigTestDataVariable = {}



---@class FControlRigValidationContext
local FControlRigValidationContext = {}


---@class FControlRotationOrder
---@field RotationOrder EEulerRotationOrder
---@field bOverrideSetting boolean
local FControlRotationOrder = {}



---@class FControlShapeActorCreationParam
local FControlShapeActorCreationParam = {}


---@class FEnumParameterNameAndCurve
---@field ParameterName FName
---@field ParameterCurve FMovieSceneByteChannel
local FEnumParameterNameAndCurve = {}



---@class FIntegerParameterNameAndCurve
---@field ParameterName FName
---@field ParameterCurve FMovieSceneIntegerChannel
local FIntegerParameterNameAndCurve = {}



---@class FModularRigConnections
---@field ConnectionList TArray<FModularRigSingleConnection>
local FModularRigConnections = {}



---@class FModularRigModel
---@field Modules TArray<FRigModuleReference>
---@field Connections FModularRigConnections
---@field Controller UObject
local FModularRigModel = {}



---@class FModularRigResolveResult
---@field Connector FRigElementKey
---@field Matches TArray<FRigElementResolveResult>
---@field Excluded TArray<FRigElementResolveResult>
---@field State EModularRigResolveState
---@field Message FText
local FModularRigResolveResult = {}



---@class FModularRigSettings
---@field bAutoResolve boolean
local FModularRigSettings = {}



---@class FModularRigSingleConnection
---@field Connector FRigElementKey
---@field Target FRigElementKey
local FModularRigSingleConnection = {}



---@class FMovieSceneControlRigInstanceData : FMovieSceneSequenceInstanceData
---@field bAdditive boolean
---@field bApplyBoneFilter boolean
---@field BoneFilter FInputBlendPose
---@field Weight FMovieSceneFloatChannel
---@field Operand FMovieSceneEvaluationOperand
local FMovieSceneControlRigInstanceData = {}



---@class FMovieSceneControlRigParameterTemplate : FMovieSceneParameterSectionTemplate
---@field Enums TArray<FEnumParameterNameAndCurve>
---@field Integers TArray<FIntegerParameterNameAndCurve>
---@field Spaces TArray<FSpaceControlNameAndChannel>
---@field Constraints TArray<FConstraintAndActiveChannel>
local FMovieSceneControlRigParameterTemplate = {}



---@class FMovieSceneControlRigSpaceBaseKey
---@field SpaceType EMovieSceneControlRigSpaceType
---@field ControlRigElement FRigElementKey
local FMovieSceneControlRigSpaceBaseKey = {}



---@class FMovieSceneControlRigSpaceChannel : FMovieSceneChannel
---@field KeyTimes TArray<FFrameNumber>
---@field KeyValues TArray<FMovieSceneControlRigSpaceBaseKey>
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneControlRigSpaceChannel = {}



---@class FRegionScaleFactors
---@field PositiveWidth float
---@field NegativeWidth float
---@field PositiveHeight float
---@field NegativeHeight float
local FRegionScaleFactors = {}



---@class FRigAndConnectionRule : FRigConnectionRule
---@field ChildRules TArray<FRigConnectionRuleStash>
local FRigAndConnectionRule = {}



---@class FRigBaseElement
---@field Key FRigElementKey
---@field Index int32
---@field SubIndex int32
---@field CreatedAtInstructionIndex int32
---@field bSelected boolean
local FRigBaseElement = {}



---@class FRigBaseMetadata
---@field Name FName
---@field Type ERigMetadataType
local FRigBaseMetadata = {}



---@class FRigBone : FRigElement
---@field ParentName FName
---@field ParentIndex int32
---@field InitialTransform FTransform
---@field GlobalTransform FTransform
---@field LocalTransform FTransform
---@field Dependents TArray<int32>
---@field Type ERigBoneType
local FRigBone = {}



---@class FRigBoneElement : FRigSingleParentElement
---@field BoneType ERigBoneType
local FRigBoneElement = {}



---@class FRigBoneHierarchy
---@field Bones TArray<FRigBone>
local FRigBoneHierarchy = {}



---@class FRigBoolArrayMetadata : FRigBaseMetadata
---@field Value TArray<boolean>
local FRigBoolArrayMetadata = {}



---@class FRigBoolMetadata : FRigBaseMetadata
---@field Value boolean
local FRigBoolMetadata = {}



---@class FRigChildOfPrimaryConnectionRule : FRigConnectionRule
local FRigChildOfPrimaryConnectionRule = {}


---@class FRigComputedTransform
local FRigComputedTransform = {}


---@class FRigConnectionRule
local FRigConnectionRule = {}


---@class FRigConnectionRuleStash
---@field ScriptStructPath FString
---@field ExportedText FString
local FRigConnectionRuleStash = {}



---@class FRigConnectorElement : FRigBaseElement
---@field Settings FRigConnectorSettings
local FRigConnectorElement = {}



---@class FRigConnectorSettings
---@field Description FString
---@field Type EConnectorType
---@field bOptional boolean
---@field Rules TArray<FRigConnectionRuleStash>
local FRigConnectorSettings = {}



---@class FRigConnectorState
---@field Name FName
---@field ResolvedTarget FRigElementKey
---@field Settings FRigConnectorSettings
local FRigConnectorState = {}



---@class FRigControl : FRigElement
---@field ControlType ERigControlType
---@field DisplayName FName
---@field ParentName FName
---@field ParentIndex int32
---@field SpaceName FName
---@field SpaceIndex int32
---@field OffsetTransform FTransform
---@field InitialValue FRigControlValue
---@field Value FRigControlValue
---@field PrimaryAxis ERigControlAxis
---@field bIsCurve boolean
---@field bAnimatable boolean
---@field bLimitTranslation boolean
---@field bLimitRotation boolean
---@field bLimitScale boolean
---@field bDrawLimits boolean
---@field MinimumValue FRigControlValue
---@field MaximumValue FRigControlValue
---@field bGizmoEnabled boolean
---@field bGizmoVisible boolean
---@field GizmoName FName
---@field GizmoTransform FTransform
---@field GizmoColor FLinearColor
---@field Dependents TArray<int32>
---@field bIsTransientControl boolean
---@field ControlEnum UEnum
local FRigControl = {}



---@class FRigControlCopy
---@field Name FName
---@field ControlType ERigControlType
---@field ParentKey FRigElementKey
---@field Value FRigControlValue
---@field OffsetTransform FTransform
---@field ParentTransform FTransform
---@field LocalTransform FTransform
---@field GlobalTransform FTransform
local FRigControlCopy = {}



---@class FRigControlElement : FRigMultiParentElement
---@field Settings FRigControlSettings
---@field PreferredEulerAngles FRigPreferredEulerAngles
local FRigControlElement = {}



---@class FRigControlElementCustomization
---@field AvailableSpaces TArray<FRigElementKey>
---@field RemovedSpaces TArray<FRigElementKey>
local FRigControlElementCustomization = {}



---@class FRigControlHierarchy
---@field Controls TArray<FRigControl>
local FRigControlHierarchy = {}



---@class FRigControlLimitEnabled
---@field bMinimum boolean
---@field bMaximum boolean
local FRigControlLimitEnabled = {}



---@class FRigControlModifiedContext
local FRigControlModifiedContext = {}


---@class FRigControlSettings
---@field AnimationType ERigControlAnimationType
---@field ControlType ERigControlType
---@field DisplayName FName
---@field PrimaryAxis ERigControlAxis
---@field bIsCurve boolean
---@field LimitEnabled TArray<FRigControlLimitEnabled>
---@field bDrawLimits boolean
---@field MinimumValue FRigControlValue
---@field MaximumValue FRigControlValue
---@field bShapeVisible boolean
---@field ShapeVisibility ERigControlVisibility
---@field ShapeName FName
---@field ShapeColor FLinearColor
---@field bIsTransientControl boolean
---@field ControlEnum UEnum
---@field Customization FRigControlElementCustomization
---@field DrivenControls TArray<FRigElementKey>
---@field bGroupWithParentControl boolean
---@field bRestrictSpaceSwitching boolean
---@field FilteredChannels TArray<ERigControlTransformChannel>
---@field PreferredRotationOrder EEulerRotationOrder
---@field bUsePreferredRotationOrder boolean
local FRigControlSettings = {}



---@class FRigControlValue
---@field FloatStorage FRigControlValueStorage
local FRigControlValue = {}



---@class FRigControlValueStorage
---@field Float00 float
---@field Float01 float
---@field Float02 float
---@field Float03 float
---@field Float10 float
---@field Float11 float
---@field Float12 float
---@field Float13 float
---@field Float20 float
---@field Float21 float
---@field Float22 float
---@field Float23 float
---@field Float30 float
---@field Float31 float
---@field Float32 float
---@field Float33 float
---@field Float00_2 float
---@field Float01_2 float
---@field Float02_2 float
---@field Float03_2 float
---@field Float10_2 float
---@field Float11_2 float
---@field Float12_2 float
---@field Float13_2 float
---@field Float20_2 float
---@field Float21_2 float
---@field Float22_2 float
---@field Float23_2 float
---@field Float30_2 float
---@field Float31_2 float
---@field Float32_2 float
---@field Float33_2 float
---@field bValid boolean
local FRigControlValueStorage = {}



---@class FRigCurrentAndInitialDirtyState
---@field Current FRigLocalAndGlobalDirtyState
---@field Initial FRigLocalAndGlobalDirtyState
local FRigCurrentAndInitialDirtyState = {}



---@class FRigCurrentAndInitialTransform
---@field Current FRigLocalAndGlobalTransform
---@field Initial FRigLocalAndGlobalTransform
local FRigCurrentAndInitialTransform = {}



---@class FRigCurve : FRigElement
---@field Value float
local FRigCurve = {}



---@class FRigCurveContainer
---@field Curves TArray<FRigCurve>
local FRigCurveContainer = {}



---@class FRigCurveElement : FRigBaseElement
local FRigCurveElement = {}


---@class FRigDispatchFactory : FRigVMDispatchFactory
local FRigDispatchFactory = {}


---@class FRigDispatch_AnimAttributeBase : FRigDispatchFactory
local FRigDispatch_AnimAttributeBase = {}


---@class FRigDispatch_GetAnimAttribute : FRigDispatch_AnimAttributeBase
local FRigDispatch_GetAnimAttribute = {}


---@class FRigDispatch_GetMetadata : FRigDispatch_MetadataBase
local FRigDispatch_GetMetadata = {}


---@class FRigDispatch_GetModuleMetadata : FRigDispatch_GetMetadata
local FRigDispatch_GetModuleMetadata = {}


---@class FRigDispatch_GetUserData : FRigDispatchFactory
local FRigDispatch_GetUserData = {}


---@class FRigDispatch_MetadataBase : FRigDispatchFactory
local FRigDispatch_MetadataBase = {}


---@class FRigDispatch_SetAnimAttribute : FRigDispatch_AnimAttributeBase
local FRigDispatch_SetAnimAttribute = {}


---@class FRigDispatch_SetMetadata : FRigDispatch_MetadataBase
local FRigDispatch_SetMetadata = {}


---@class FRigDispatch_SetModuleMetadata : FRigDispatch_SetMetadata
local FRigDispatch_SetModuleMetadata = {}


---@class FRigElement
---@field Name FName
---@field Index int32
local FRigElement = {}



---@class FRigElementKey
---@field Type ERigElementType
---@field Name FName
local FRigElementKey = {}



---@class FRigElementKeyArrayMetadata : FRigBaseMetadata
---@field Value TArray<FRigElementKey>
local FRigElementKeyArrayMetadata = {}



---@class FRigElementKeyCollection
---@field Keys TArray<FRigElementKey>
local FRigElementKeyCollection = {}



---@class FRigElementKeyMetadata : FRigBaseMetadata
---@field Value FRigElementKey
local FRigElementKeyMetadata = {}



---@class FRigElementParentConstraint
local FRigElementParentConstraint = {}


---@class FRigElementResolveResult
---@field Key FRigElementKey
---@field State ERigElementResolveState
---@field Message FText
local FRigElementResolveResult = {}



---@class FRigElementWeight
---@field Location float
---@field Rotation float
---@field Scale float
local FRigElementWeight = {}



---@class FRigEventContext
local FRigEventContext = {}


---@class FRigFloatArrayMetadata : FRigBaseMetadata
---@field Value TArray<float>
local FRigFloatArrayMetadata = {}



---@class FRigFloatMetadata : FRigBaseMetadata
---@field Value float
local FRigFloatMetadata = {}



---@class FRigHierarchyContainer
---@field BoneHierarchy FRigBoneHierarchy
---@field SpaceHierarchy FRigSpaceHierarchy
---@field ControlHierarchy FRigControlHierarchy
---@field CurveContainer FRigCurveContainer
local FRigHierarchyContainer = {}



---@class FRigHierarchyCopyPasteContent
---@field Elements TArray<FRigHierarchyCopyPasteContentPerElement>
---@field Types TArray<ERigElementType>
---@field Contents TArray<FString>
---@field LocalTransforms TArray<FTransform>
---@field GlobalTransforms TArray<FTransform>
local FRigHierarchyCopyPasteContent = {}



---@class FRigHierarchyCopyPasteContentPerElement
---@field Key FRigElementKey
---@field Content FString
---@field Parents TArray<FRigElementKey>
---@field ParentWeights TArray<FRigElementWeight>
---@field Poses TArray<FTransform>
---@field DirtyStates TArray<boolean>
local FRigHierarchyCopyPasteContentPerElement = {}



---@class FRigHierarchyRef
local FRigHierarchyRef = {}


---@class FRigHierarchySettings
---@field ProceduralElementLimit int32
local FRigHierarchySettings = {}



---@class FRigInfluenceEntry
---@field Source FRigElementKey
---@field AffectedList TArray<FRigElementKey>
local FRigInfluenceEntry = {}



---@class FRigInfluenceEntryModifier
---@field AffectedList TArray<FRigElementKey>
local FRigInfluenceEntryModifier = {}



---@class FRigInfluenceMap
---@field EventName FName
---@field Entries TArray<FRigInfluenceEntry>
---@field KeyToIndex TMap<FRigElementKey, int32>
local FRigInfluenceMap = {}



---@class FRigInfluenceMapPerEvent
---@field Maps TArray<FRigInfluenceMap>
---@field EventToIndex TMap<FName, int32>
local FRigInfluenceMapPerEvent = {}



---@class FRigInt32ArrayMetadata : FRigBaseMetadata
---@field Value TArray<int32>
local FRigInt32ArrayMetadata = {}



---@class FRigInt32Metadata : FRigBaseMetadata
---@field Value int32
local FRigInt32Metadata = {}



---@class FRigLinearColorArrayMetadata : FRigBaseMetadata
---@field Value TArray<FLinearColor>
local FRigLinearColorArrayMetadata = {}



---@class FRigLinearColorMetadata : FRigBaseMetadata
---@field Value FLinearColor
local FRigLinearColorMetadata = {}



---@class FRigLocalAndGlobalDirtyState
---@field Global FRigTransformDirtyState
---@field Local FRigTransformDirtyState
local FRigLocalAndGlobalDirtyState = {}



---@class FRigLocalAndGlobalTransform
---@field Local FRigComputedTransform
---@field Global FRigComputedTransform
local FRigLocalAndGlobalTransform = {}



---@class FRigModuleConnector
---@field Name FString
---@field Settings FRigConnectorSettings
local FRigModuleConnector = {}



---@class FRigModuleDescription
---@field Path FSoftObjectPath
---@field Settings FRigModuleSettings
local FRigModuleDescription = {}



---@class FRigModuleExecutionElement
---@field ModulePath FString
---@field EventName FName
---@field bExecuted boolean
local FRigModuleExecutionElement = {}



---@class FRigModuleIdentifier
---@field Name FString
---@field Type FString
local FRigModuleIdentifier = {}



---@class FRigModuleInstance
---@field Name FName
---@field RigPtr UControlRig
---@field ParentPath FString
---@field VariableBindings TMap<FName, FRigVMExternalVariable>
local FRigModuleInstance = {}



---@class FRigModuleReference
---@field Name FName
---@field ShortName FString
---@field bShortNameBasedOnPath boolean
---@field ParentPath FString
---@field Class TSoftClassPtr<UControlRig>
---@field Connections TMap<FRigElementKey, FRigElementKey>
---@field ConfigValues TMap<FName, FString>
---@field Bindings TMap<FName, FString>
---@field PreviousName FName
---@field PreviousParentPath FString
local FRigModuleReference = {}



---@class FRigModuleSettings
---@field Identifier FRigModuleIdentifier
---@field Icon FSoftObjectPath
---@field Category FString
---@field Keywords FString
---@field Description FString
---@field ExposedConnectors TArray<FRigModuleConnector>
local FRigModuleSettings = {}



---@class FRigMultiParentElement : FRigTransformElement
local FRigMultiParentElement = {}


---@class FRigNameArrayMetadata : FRigBaseMetadata
---@field Value TArray<FName>
local FRigNameArrayMetadata = {}



---@class FRigNameMetadata : FRigBaseMetadata
---@field Value FName
local FRigNameMetadata = {}



---@class FRigNullElement : FRigMultiParentElement
local FRigNullElement = {}


---@class FRigOrConnectionRule : FRigConnectionRule
---@field ChildRules TArray<FRigConnectionRuleStash>
local FRigOrConnectionRule = {}



---@class FRigPhysicsElement : FRigSingleParentElement
---@field Solver FRigPhysicsSolverID
---@field Settings FRigPhysicsSettings
local FRigPhysicsElement = {}



---@class FRigPhysicsSettings
---@field Mass float
local FRigPhysicsSettings = {}



---@class FRigPhysicsSolverDescription
---@field ID FRigPhysicsSolverID
---@field Name FName
local FRigPhysicsSolverDescription = {}



---@class FRigPhysicsSolverID
---@field Guid FGuid
local FRigPhysicsSolverID = {}



---@class FRigPose
---@field Elements TArray<FRigPoseElement>
---@field HierarchyTopologyVersion int32
---@field PoseHash int32
local FRigPose = {}



---@class FRigPoseElement
---@field Index FCachedRigElement
---@field GlobalTransform FTransform
---@field LocalTransform FTransform
---@field PreferredEulerAngle FVector
---@field ActiveParent FRigElementKey
---@field CurveValue float
local FRigPoseElement = {}



---@class FRigPreferredEulerAngles
---@field RotationOrder EEulerRotationOrder
---@field Current FVector
---@field Initial FVector
local FRigPreferredEulerAngles = {}



---@class FRigQuatArrayMetadata : FRigBaseMetadata
---@field Value TArray<FQuat>
local FRigQuatArrayMetadata = {}



---@class FRigQuatMetadata : FRigBaseMetadata
---@field Value FQuat
local FRigQuatMetadata = {}



---@class FRigReferenceElement : FRigSingleParentElement
local FRigReferenceElement = {}


---@class FRigRotatorArrayMetadata : FRigBaseMetadata
---@field Value TArray<FRotator>
local FRigRotatorArrayMetadata = {}



---@class FRigRotatorMetadata : FRigBaseMetadata
---@field Value FRotator
local FRigRotatorMetadata = {}



---@class FRigSingleParentElement : FRigTransformElement
local FRigSingleParentElement = {}


---@class FRigSocketElement : FRigSingleParentElement
local FRigSocketElement = {}


---@class FRigSocketState
---@field Name FName
---@field Parent FRigElementKey
---@field InitialLocalTransform FTransform
---@field Color FLinearColor
---@field Description FString
local FRigSocketState = {}



---@class FRigSpace : FRigElement
---@field SpaceType ERigSpaceType
---@field ParentName FName
---@field ParentIndex int32
---@field InitialTransform FTransform
---@field LocalTransform FTransform
local FRigSpace = {}



---@class FRigSpaceHierarchy
---@field Spaces TArray<FRigSpace>
local FRigSpaceHierarchy = {}



---@class FRigTagConnectionRule : FRigConnectionRule
---@field Tag FName
local FRigTagConnectionRule = {}



---@class FRigTransformArrayMetadata : FRigBaseMetadata
---@field Value TArray<FTransform>
local FRigTransformArrayMetadata = {}



---@class FRigTransformDirtyState
local FRigTransformDirtyState = {}


---@class FRigTransformElement : FRigBaseElement
local FRigTransformElement = {}


---@class FRigTransformMetadata : FRigBaseMetadata
---@field Value FTransform
local FRigTransformMetadata = {}



---@class FRigTransformStackEntry
---@field Key FRigElementKey
---@field EntryType ERigTransformStackEntryType
---@field TransformType ERigTransformType::Type
---@field OldTransform FTransform
---@field NewTransform FTransform
---@field bAffectChildren boolean
---@field Callstack TArray<FString>
local FRigTransformStackEntry = {}



---@class FRigTypeConnectionRule : FRigConnectionRule
---@field ElementType ERigElementType
local FRigTypeConnectionRule = {}



---@class FRigUnit : FRigVMStruct
local FRigUnit = {}


---@class FRigUnitMutable : FRigUnit
---@field ExecuteContext FControlRigExecuteContext
local FRigUnitMutable = {}



---@class FRigUnit_AddBoneTransform : FRigUnitMutable
---@field bone FName
---@field Transform FTransform
---@field Weight float
---@field bPostMultiply boolean
---@field bPropagateToChildren boolean
---@field CachedBone FCachedRigElement
local FRigUnit_AddBoneTransform = {}



---@class FRigUnit_AddParent : FRigUnit_DynamicHierarchyBaseMutable
---@field Child FRigElementKey
---@field Parent FRigElementKey
local FRigUnit_AddParent = {}



---@class FRigUnit_Add_FloatFloat : FRigUnit_BinaryFloatOp
local FRigUnit_Add_FloatFloat = {}


---@class FRigUnit_Add_VectorVector : FRigUnit_BinaryVectorOp
local FRigUnit_Add_VectorVector = {}


---@class FRigUnit_AimBone : FRigUnit_HighlevelBaseMutable
---@field bone FName
---@field Primary FRigUnit_AimBone_Target
---@field Secondary FRigUnit_AimBone_Target
---@field Weight float
---@field bPropagateToChildren boolean
---@field DebugSettings FRigUnit_AimBone_DebugSettings
---@field CachedBoneIndex FCachedRigElement
---@field PrimaryCachedSpace FCachedRigElement
---@field SecondaryCachedSpace FCachedRigElement
---@field bIsInitialized boolean
local FRigUnit_AimBone = {}



---@class FRigUnit_AimBoneMath : FRigUnit_HighlevelBase
---@field InputTransform FTransform
---@field Primary FRigUnit_AimItem_Target
---@field Secondary FRigUnit_AimItem_Target
---@field Weight float
---@field Result FTransform
---@field DebugSettings FRigUnit_AimBone_DebugSettings
---@field PrimaryCachedSpace FCachedRigElement
---@field SecondaryCachedSpace FCachedRigElement
---@field bIsInitialized boolean
local FRigUnit_AimBoneMath = {}



---@class FRigUnit_AimBone_DebugSettings
---@field bEnabled boolean
---@field Scale float
---@field WorldOffset FTransform
local FRigUnit_AimBone_DebugSettings = {}



---@class FRigUnit_AimBone_Target
---@field Weight float
---@field Axis FVector
---@field Target FVector
---@field Kind EControlRigVectorKind
---@field Space FName
local FRigUnit_AimBone_Target = {}



---@class FRigUnit_AimConstraint : FRigUnitMutable
---@field Joint FName
---@field AimMode EAimMode
---@field UpMode EAimMode
---@field AimVector FVector
---@field UpVector FVector
---@field AimTargets TArray<FAimTarget>
---@field UpTargets TArray<FAimTarget>
---@field WorkData FRigUnit_AimConstraint_WorkData
local FRigUnit_AimConstraint = {}



---@class FRigUnit_AimConstraintLocalSpaceOffset : FRigUnit_HighlevelBaseMutable
---@field Child FRigElementKey
---@field bMaintainOffset boolean
---@field Filter FFilterOptionPerAxis
---@field AimAxis FVector
---@field UpAxis FVector
---@field WorldUp FRigUnit_AimConstraint_WorldUp
---@field Parents TArray<FConstraintParent>
---@field AdvancedSettings FRigUnit_AimConstraint_AdvancedSettings
---@field Weight float
---@field WorldUpSpaceCache FCachedRigElement
---@field ChildCache FCachedRigElement
---@field ParentCaches TArray<FCachedRigElement>
---@field bIsInitialized boolean
local FRigUnit_AimConstraintLocalSpaceOffset = {}



---@class FRigUnit_AimConstraint_AdvancedSettings
---@field DebugSettings FRigUnit_AimBone_DebugSettings
---@field RotationOrderForFilter EEulerRotationOrder
local FRigUnit_AimConstraint_AdvancedSettings = {}



---@class FRigUnit_AimConstraint_WorkData
---@field ConstraintData TArray<FConstraintData>
local FRigUnit_AimConstraint_WorkData = {}



---@class FRigUnit_AimConstraint_WorldUp
---@field Target FVector
---@field Kind EControlRigVectorKind
---@field Space FRigElementKey
local FRigUnit_AimConstraint_WorldUp = {}



---@class FRigUnit_AimItem : FRigUnit_HighlevelBaseMutable
---@field Item FRigElementKey
---@field Primary FRigUnit_AimItem_Target
---@field Secondary FRigUnit_AimItem_Target
---@field Weight float
---@field DebugSettings FRigUnit_AimBone_DebugSettings
---@field CachedItem FCachedRigElement
---@field PrimaryCachedSpace FCachedRigElement
---@field SecondaryCachedSpace FCachedRigElement
---@field bIsInitialized boolean
local FRigUnit_AimItem = {}



---@class FRigUnit_AimItem_Target
---@field Weight float
---@field Axis FVector
---@field Target FVector
---@field Kind EControlRigVectorKind
---@field Space FRigElementKey
local FRigUnit_AimItem_Target = {}



---@class FRigUnit_ApplyFK : FRigUnitMutable
---@field Joint FName
---@field Transform FTransform
---@field Filter FTransformFilter
---@field ApplyTransformMode EApplyTransformMode
---@field ApplyTransformSpace ETransformSpaceMode
---@field BaseTransform FTransform
---@field BaseJoint FName
local FRigUnit_ApplyFK = {}



---@class FRigUnit_BeginExecution : FRigUnit
---@field ExecuteContext FControlRigExecuteContext
local FRigUnit_BeginExecution = {}



---@class FRigUnit_BinaryFloatOp : FRigUnit
---@field Argument0 float
---@field Argument1 float
---@field Result float
local FRigUnit_BinaryFloatOp = {}



---@class FRigUnit_BinaryQuaternionOp : FRigUnit
---@field Argument0 FQuat
---@field Argument1 FQuat
---@field Result FQuat
local FRigUnit_BinaryQuaternionOp = {}



---@class FRigUnit_BinaryTransformOp : FRigUnit
---@field Argument0 FTransform
---@field Argument1 FTransform
---@field Result FTransform
local FRigUnit_BinaryTransformOp = {}



---@class FRigUnit_BinaryVectorOp : FRigUnit
---@field Argument0 FVector
---@field Argument1 FVector
---@field Result FVector
local FRigUnit_BinaryVectorOp = {}



---@class FRigUnit_BlendTransform : FRigUnit
---@field Source FTransform
---@field Targets TArray<FBlendTarget>
---@field Result FTransform
local FRigUnit_BlendTransform = {}



---@class FRigUnit_BoneHarmonics : FRigUnit_HighlevelBaseMutable
---@field Bones TArray<FRigUnit_BoneHarmonics_BoneTarget>
---@field WaveSpeed FVector
---@field WaveFrequency FVector
---@field WaveAmplitude FVector
---@field WaveOffset FVector
---@field WaveNoise FVector
---@field WaveEase ERigVMAnimEasingType
---@field WaveMinimum float
---@field WaveMaximum float
---@field RotationOrder EEulerRotationOrder
---@field bPropagateToChildren boolean
---@field WorkData FRigUnit_BoneHarmonics_WorkData
local FRigUnit_BoneHarmonics = {}



---@class FRigUnit_BoneHarmonics_BoneTarget
---@field bone FName
---@field Ratio float
local FRigUnit_BoneHarmonics_BoneTarget = {}



---@class FRigUnit_BoneHarmonics_WorkData
---@field CachedItems TArray<FCachedRigElement>
---@field WaveTime FVector
local FRigUnit_BoneHarmonics_WorkData = {}



---@class FRigUnit_BoneName : FRigUnit
---@field bone FName
local FRigUnit_BoneName = {}



---@class FRigUnit_CCDIK : FRigUnit_HighlevelBaseMutable
---@field StartBone FName
---@field EffectorBone FName
---@field EffectorTransform FTransform
---@field Precision float
---@field Weight float
---@field MaxIterations int32
---@field bStartFromTail boolean
---@field BaseRotationLimit float
---@field RotationLimits TArray<FRigUnit_CCDIK_RotationLimit>
---@field bPropagateToChildren boolean
---@field WorkData FRigUnit_CCDIK_WorkData
local FRigUnit_CCDIK = {}



---@class FRigUnit_CCDIKItemArray : FRigUnit_HighlevelBaseMutable
---@field Items TArray<FRigElementKey>
---@field EffectorTransform FTransform
---@field Precision float
---@field Weight float
---@field MaxIterations int32
---@field bStartFromTail boolean
---@field BaseRotationLimit float
---@field RotationLimits TArray<FRigUnit_CCDIK_RotationLimitPerItem>
---@field bPropagateToChildren boolean
---@field WorkData FRigUnit_CCDIK_WorkData
local FRigUnit_CCDIKItemArray = {}



---@class FRigUnit_CCDIKPerItem : FRigUnit_HighlevelBaseMutable
---@field Items FRigElementKeyCollection
---@field EffectorTransform FTransform
---@field Precision float
---@field Weight float
---@field MaxIterations int32
---@field bStartFromTail boolean
---@field BaseRotationLimit float
---@field RotationLimits TArray<FRigUnit_CCDIK_RotationLimitPerItem>
---@field bPropagateToChildren boolean
---@field WorkData FRigUnit_CCDIK_WorkData
local FRigUnit_CCDIKPerItem = {}



---@class FRigUnit_CCDIK_RotationLimit
---@field bone FName
---@field Limit float
local FRigUnit_CCDIK_RotationLimit = {}



---@class FRigUnit_CCDIK_RotationLimitPerItem
---@field Item FRigElementKey
---@field Limit float
local FRigUnit_CCDIK_RotationLimitPerItem = {}



---@class FRigUnit_CCDIK_WorkData
---@field Chain TArray<FCCDIKChainLink>
---@field CachedItems TArray<FCachedRigElement>
---@field RotationLimitIndex TArray<int32>
---@field RotationLimitsPerItem TArray<float>
---@field CachedEffector FCachedRigElement
local FRigUnit_CCDIK_WorkData = {}



---@class FRigUnit_ChainHarmonics : FRigUnit_HighlevelBaseMutable
---@field ChainRoot FName
---@field Speed FVector
---@field Reach FRigUnit_ChainHarmonics_Reach
---@field Wave FRigUnit_ChainHarmonics_Wave
---@field WaveCurve FRuntimeFloatCurve
---@field Pendulum FRigUnit_ChainHarmonics_Pendulum
---@field bDrawDebug boolean
---@field DrawWorldOffset FTransform
---@field WorkData FRigUnit_ChainHarmonics_WorkData
local FRigUnit_ChainHarmonics = {}



---@class FRigUnit_ChainHarmonicsPerItem : FRigUnit_HighlevelBaseMutable
---@field ChainRoot FRigElementKey
---@field Speed FVector
---@field Reach FRigUnit_ChainHarmonics_Reach
---@field Wave FRigUnit_ChainHarmonics_Wave
---@field WaveCurve FRuntimeFloatCurve
---@field Pendulum FRigUnit_ChainHarmonics_Pendulum
---@field bDrawDebug boolean
---@field DrawWorldOffset FTransform
---@field WorkData FRigUnit_ChainHarmonics_WorkData
local FRigUnit_ChainHarmonicsPerItem = {}



---@class FRigUnit_ChainHarmonics_Pendulum
---@field bEnabled boolean
---@field PendulumStiffness float
---@field PendulumGravity FVector
---@field PendulumBlend float
---@field PendulumDrag float
---@field PendulumMinimum float
---@field PendulumMaximum float
---@field PendulumEase ERigVMAnimEasingType
---@field UnwindAxis FVector
---@field UnwindMinimum float
---@field UnwindMaximum float
local FRigUnit_ChainHarmonics_Pendulum = {}



---@class FRigUnit_ChainHarmonics_Reach
---@field bEnabled boolean
---@field ReachTarget FVector
---@field ReachAxis FVector
---@field ReachMinimum float
---@field ReachMaximum float
---@field ReachEase ERigVMAnimEasingType
local FRigUnit_ChainHarmonics_Reach = {}



---@class FRigUnit_ChainHarmonics_Wave
---@field bEnabled boolean
---@field WaveFrequency FVector
---@field WaveAmplitude FVector
---@field WaveOffset FVector
---@field WaveNoise FVector
---@field WaveMinimum float
---@field WaveMaximum float
---@field WaveEase ERigVMAnimEasingType
local FRigUnit_ChainHarmonics_Wave = {}



---@class FRigUnit_ChainHarmonics_WorkData
---@field Time FVector
---@field Items TArray<FCachedRigElement>
---@field Ratio TArray<float>
---@field LocalTip TArray<FVector>
---@field PendulumTip TArray<FVector>
---@field PendulumPosition TArray<FVector>
---@field PendulumVelocity TArray<FVector>
---@field HierarchyLine TArray<FVector>
---@field VelocityLines TArray<FVector>
local FRigUnit_ChainHarmonics_WorkData = {}



---@class FRigUnit_Clamp_Float : FRigUnit
---@field Value float
---@field Min float
---@field Max float
---@field Result float
local FRigUnit_Clamp_Float = {}



---@class FRigUnit_CollectionAddItem : FRigUnit_CollectionBase
---@field Collection FRigElementKeyCollection
---@field Item FRigElementKey
---@field Result FRigElementKeyCollection
local FRigUnit_CollectionAddItem = {}



---@class FRigUnit_CollectionBase : FRigUnit
local FRigUnit_CollectionBase = {}


---@class FRigUnit_CollectionBaseMutable : FRigUnitMutable
local FRigUnit_CollectionBaseMutable = {}


---@class FRigUnit_CollectionChain : FRigUnit_CollectionBase
---@field FirstItem FRigElementKey
---@field LastItem FRigElementKey
---@field Reverse boolean
---@field Collection FRigElementKeyCollection
local FRigUnit_CollectionChain = {}



---@class FRigUnit_CollectionChainArray : FRigUnit_CollectionBase
---@field FirstItem FRigElementKey
---@field LastItem FRigElementKey
---@field Reverse boolean
---@field Items TArray<FRigElementKey>
local FRigUnit_CollectionChainArray = {}



---@class FRigUnit_CollectionChildren : FRigUnit_CollectionBase
---@field Parent FRigElementKey
---@field bIncludeParent boolean
---@field bRecursive boolean
---@field TypeToSearch ERigElementType
---@field Collection FRigElementKeyCollection
local FRigUnit_CollectionChildren = {}



---@class FRigUnit_CollectionChildrenArray : FRigUnit_CollectionBase
---@field Parent FRigElementKey
---@field bIncludeParent boolean
---@field bRecursive boolean
---@field bDefaultChildren boolean
---@field TypeToSearch ERigElementType
---@field Items TArray<FRigElementKey>
local FRigUnit_CollectionChildrenArray = {}



---@class FRigUnit_CollectionCount : FRigUnit_CollectionBase
---@field Collection FRigElementKeyCollection
---@field Count int32
local FRigUnit_CollectionCount = {}



---@class FRigUnit_CollectionDifference : FRigUnit_CollectionBase
---@field A FRigElementKeyCollection
---@field B FRigElementKeyCollection
---@field Collection FRigElementKeyCollection
local FRigUnit_CollectionDifference = {}



---@class FRigUnit_CollectionGetAll : FRigUnit_CollectionBase
---@field TypeToSearch ERigElementType
---@field Items TArray<FRigElementKey>
local FRigUnit_CollectionGetAll = {}



---@class FRigUnit_CollectionGetItems : FRigUnit_CollectionBase
---@field Collection FRigElementKeyCollection
---@field Items TArray<FRigElementKey>
local FRigUnit_CollectionGetItems = {}



---@class FRigUnit_CollectionGetParentIndices : FRigUnit_CollectionBase
---@field Collection FRigElementKeyCollection
---@field ParentIndices TArray<int32>
local FRigUnit_CollectionGetParentIndices = {}



---@class FRigUnit_CollectionGetParentIndicesItemArray : FRigUnit_CollectionBase
---@field Items TArray<FRigElementKey>
---@field ParentIndices TArray<int32>
local FRigUnit_CollectionGetParentIndicesItemArray = {}



---@class FRigUnit_CollectionIntersection : FRigUnit_CollectionBase
---@field A FRigElementKeyCollection
---@field B FRigElementKeyCollection
---@field Collection FRigElementKeyCollection
local FRigUnit_CollectionIntersection = {}



---@class FRigUnit_CollectionItemAtIndex : FRigUnit_CollectionBase
---@field Collection FRigElementKeyCollection
---@field Index int32
---@field Item FRigElementKey
local FRigUnit_CollectionItemAtIndex = {}



---@class FRigUnit_CollectionItems : FRigUnit_CollectionBase
---@field Items TArray<FRigElementKey>
---@field bAllowDuplicates boolean
---@field Collection FRigElementKeyCollection
local FRigUnit_CollectionItems = {}



---@class FRigUnit_CollectionLoop : FRigUnit_CollectionBaseMutable
---@field BlockToRun FName
---@field Collection FRigElementKeyCollection
---@field Item FRigElementKey
---@field Index int32
---@field Count int32
---@field Ratio float
---@field Completed FControlRigExecuteContext
local FRigUnit_CollectionLoop = {}



---@class FRigUnit_CollectionNameSearch : FRigUnit_CollectionBase
---@field PartialName FName
---@field TypeToSearch ERigElementType
---@field Collection FRigElementKeyCollection
local FRigUnit_CollectionNameSearch = {}



---@class FRigUnit_CollectionNameSearchArray : FRigUnit_CollectionBase
---@field PartialName FName
---@field TypeToSearch ERigElementType
---@field Items TArray<FRigElementKey>
local FRigUnit_CollectionNameSearchArray = {}



---@class FRigUnit_CollectionReplaceItems : FRigUnit_CollectionBase
---@field Items FRigElementKeyCollection
---@field Old FName
---@field New FName
---@field RemoveInvalidItems boolean
---@field bAllowDuplicates boolean
---@field Collection FRigElementKeyCollection
local FRigUnit_CollectionReplaceItems = {}



---@class FRigUnit_CollectionReplaceItemsArray : FRigUnit_CollectionBase
---@field Items TArray<FRigElementKey>
---@field Old FName
---@field New FName
---@field RemoveInvalidItems boolean
---@field bAllowDuplicates boolean
---@field Result TArray<FRigElementKey>
local FRigUnit_CollectionReplaceItemsArray = {}



---@class FRigUnit_CollectionReverse : FRigUnit_CollectionBase
---@field Collection FRigElementKeyCollection
---@field Reversed FRigElementKeyCollection
local FRigUnit_CollectionReverse = {}



---@class FRigUnit_CollectionUnion : FRigUnit_CollectionBase
---@field A FRigElementKeyCollection
---@field B FRigElementKeyCollection
---@field bAllowDuplicates boolean
---@field Collection FRigElementKeyCollection
local FRigUnit_CollectionUnion = {}



---@class FRigUnit_ConnectorExecution : FRigUnit
---@field ExecuteContext FControlRigExecuteContext
local FRigUnit_ConnectorExecution = {}



---@class FRigUnit_Control : FRigUnit
---@field Transform FEulerTransform
---@field base FTransform
---@field InitTransform FTransform
---@field Result FTransform
---@field Filter FTransformFilter
---@field bIsInitialized boolean
local FRigUnit_Control = {}



---@class FRigUnit_ControlName : FRigUnit
---@field Control FName
local FRigUnit_ControlName = {}



---@class FRigUnit_Control_StaticMesh : FRigUnit_Control
---@field MeshTransform FTransform
local FRigUnit_Control_StaticMesh = {}



---@class FRigUnit_ConvertEulerTransform : FRigUnit
---@field Input FEulerTransform
---@field Result FTransform
local FRigUnit_ConvertEulerTransform = {}



---@class FRigUnit_ConvertQuaternion : FRigUnit
---@field Input FQuat
---@field Result FRotator
local FRigUnit_ConvertQuaternion = {}



---@class FRigUnit_ConvertQuaternionToVector : FRigUnit
---@field Input FQuat
---@field Result FVector
local FRigUnit_ConvertQuaternionToVector = {}



---@class FRigUnit_ConvertRotation : FRigUnit
---@field Input FRotator
---@field Result FQuat
local FRigUnit_ConvertRotation = {}



---@class FRigUnit_ConvertRotationToVector : FRigUnit
---@field Input FRotator
---@field Result FVector
local FRigUnit_ConvertRotationToVector = {}



---@class FRigUnit_ConvertTransform : FRigUnit
---@field Input FTransform
---@field Result FEulerTransform
local FRigUnit_ConvertTransform = {}



---@class FRigUnit_ConvertVectorRotation : FRigUnit_ConvertRotation
local FRigUnit_ConvertVectorRotation = {}


---@class FRigUnit_ConvertVectorToQuaternion : FRigUnit
---@field Input FVector
---@field Result FQuat
local FRigUnit_ConvertVectorToQuaternion = {}



---@class FRigUnit_ConvertVectorToRotation : FRigUnit
---@field Input FVector
---@field Result FRotator
local FRigUnit_ConvertVectorToRotation = {}



---@class FRigUnit_CurveExists : FRigUnit
---@field Curve FName
---@field Exists boolean
---@field CachedCurveIndex FCachedRigElement
local FRigUnit_CurveExists = {}



---@class FRigUnit_DebugArc : FRigUnit_DebugBaseMutable
---@field Transform FTransform
---@field Color FLinearColor
---@field Radius float
---@field MinimumDegrees float
---@field MaximumDegrees float
---@field Thickness float
---@field Detail int32
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugArc = {}



---@class FRigUnit_DebugArcItemSpace : FRigUnit_DebugBaseMutable
---@field Transform FTransform
---@field Color FLinearColor
---@field Radius float
---@field MinimumDegrees float
---@field MaximumDegrees float
---@field Thickness float
---@field Detail int32
---@field Space FRigElementKey
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugArcItemSpace = {}



---@class FRigUnit_DebugBase : FRigUnit
local FRigUnit_DebugBase = {}


---@class FRigUnit_DebugBaseMutable : FRigUnitMutable
local FRigUnit_DebugBaseMutable = {}


---@class FRigUnit_DebugBezier : FRigVMFunction_DebugBaseMutable
---@field Bezier FRigVMFourPointBezier
---@field MinimumU float
---@field MaximumU float
---@field Color FLinearColor
---@field Thickness float
---@field Detail int32
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugBezier = {}



---@class FRigUnit_DebugBezierItemSpace : FRigVMFunction_DebugBaseMutable
---@field Bezier FRigVMFourPointBezier
---@field MinimumU float
---@field MaximumU float
---@field Color FLinearColor
---@field Thickness float
---@field Detail int32
---@field Space FRigElementKey
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugBezierItemSpace = {}



---@class FRigUnit_DebugHierarchy : FRigVMFunction_DebugBase
---@field ExecuteContext FControlRigExecuteContext
---@field Items TArray<FRigElementKey>
---@field Scale float
---@field Color FLinearColor
---@field Thickness float
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugHierarchy = {}



---@class FRigUnit_DebugLine : FRigUnit_DebugBaseMutable
---@field A FVector
---@field B FVector
---@field Color FLinearColor
---@field Thickness float
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugLine = {}



---@class FRigUnit_DebugLineItemSpace : FRigUnit_DebugBaseMutable
---@field A FVector
---@field B FVector
---@field Color FLinearColor
---@field Thickness float
---@field Space FRigElementKey
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugLineItemSpace = {}



---@class FRigUnit_DebugLineStrip : FRigUnit_DebugBaseMutable
---@field Points TArray<FVector>
---@field Color FLinearColor
---@field Thickness float
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugLineStrip = {}



---@class FRigUnit_DebugLineStripItemSpace : FRigUnit_DebugBaseMutable
---@field Points TArray<FVector>
---@field Color FLinearColor
---@field Thickness float
---@field Space FRigElementKey
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugLineStripItemSpace = {}



---@class FRigUnit_DebugPose : FRigVMFunction_DebugBase
---@field ExecuteContext FControlRigExecuteContext
---@field Pose FRigPose
---@field Items TArray<FRigElementKey>
---@field Scale float
---@field Color FLinearColor
---@field Thickness float
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugPose = {}



---@class FRigUnit_DebugRectangle : FRigUnit_DebugBaseMutable
---@field Transform FTransform
---@field Color FLinearColor
---@field Scale float
---@field Thickness float
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugRectangle = {}



---@class FRigUnit_DebugRectangleItemSpace : FRigUnit_DebugBaseMutable
---@field Transform FTransform
---@field Color FLinearColor
---@field Scale float
---@field Thickness float
---@field Space FRigElementKey
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugRectangleItemSpace = {}



---@class FRigUnit_DebugTransform : FRigUnit_DebugBase
---@field Transform FTransform
---@field Mode ERigUnitDebugTransformMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugTransform = {}



---@class FRigUnit_DebugTransformArrayMutable : FRigUnit_DebugBaseMutable
---@field Transforms TArray<FTransform>
---@field Mode ERigUnitDebugTransformMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
---@field WorkData FRigUnit_DebugTransformArrayMutable_WorkData
local FRigUnit_DebugTransformArrayMutable = {}



---@class FRigUnit_DebugTransformArrayMutableItemSpace : FRigUnit_DebugBaseMutable
---@field Transforms TArray<FTransform>
---@field ParentIndices TArray<int32>
---@field Mode ERigUnitDebugTransformMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
---@field Space FRigElementKey
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugTransformArrayMutableItemSpace = {}



---@class FRigUnit_DebugTransformArrayMutable_WorkData
---@field DrawTransforms TArray<FTransform>
local FRigUnit_DebugTransformArrayMutable_WorkData = {}



---@class FRigUnit_DebugTransformMutable : FRigUnit_DebugBaseMutable
---@field Transform FTransform
---@field Mode ERigUnitDebugTransformMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugTransformMutable = {}



---@class FRigUnit_DebugTransformMutableItemSpace : FRigUnit_DebugBaseMutable
---@field Transform FTransform
---@field Mode ERigUnitDebugTransformMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
---@field Space FRigElementKey
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigUnit_DebugTransformMutableItemSpace = {}



---@class FRigUnit_DiscardMatches : FRigUnitMutable
---@field Excluded TArray<FRigElementKey>
---@field Message FString
local FRigUnit_DiscardMatches = {}



---@class FRigUnit_Distance_VectorVector : FRigUnit
---@field Argument0 FVector
---@field Argument1 FVector
---@field Result float
local FRigUnit_Distance_VectorVector = {}



---@class FRigUnit_DistributeRotation : FRigUnit_HighlevelBaseMutable
---@field StartBone FName
---@field EndBone FName
---@field Rotations TArray<FRigUnit_DistributeRotation_Rotation>
---@field RotationEaseType ERigVMAnimEasingType
---@field Weight float
---@field bPropagateToChildren boolean
---@field WorkData FRigUnit_DistributeRotation_WorkData
local FRigUnit_DistributeRotation = {}



---@class FRigUnit_DistributeRotationForCollection : FRigUnit_HighlevelBaseMutable
---@field Items FRigElementKeyCollection
---@field Rotations TArray<FRigUnit_DistributeRotation_Rotation>
---@field RotationEaseType ERigVMAnimEasingType
---@field Weight float
---@field WorkData FRigUnit_DistributeRotation_WorkData
local FRigUnit_DistributeRotationForCollection = {}



---@class FRigUnit_DistributeRotationForItemArray : FRigUnit_HighlevelBaseMutable
---@field Items TArray<FRigElementKey>
---@field Rotations TArray<FRigUnit_DistributeRotation_Rotation>
---@field RotationEaseType ERigVMAnimEasingType
---@field Weight float
---@field WorkData FRigUnit_DistributeRotation_WorkData
local FRigUnit_DistributeRotationForItemArray = {}



---@class FRigUnit_DistributeRotation_Rotation
---@field Rotation FQuat
---@field Ratio float
local FRigUnit_DistributeRotation_Rotation = {}



---@class FRigUnit_DistributeRotation_WorkData
---@field CachedItems TArray<FCachedRigElement>
---@field ItemRotationA TArray<int32>
---@field ItemRotationB TArray<int32>
---@field ItemRotationT TArray<float>
---@field ItemLocalTransforms TArray<FTransform>
local FRigUnit_DistributeRotation_WorkData = {}



---@class FRigUnit_Divide_FloatFloat : FRigUnit_BinaryFloatOp
local FRigUnit_Divide_FloatFloat = {}


---@class FRigUnit_Divide_VectorVector : FRigUnit_BinaryVectorOp
local FRigUnit_Divide_VectorVector = {}


---@class FRigUnit_DrawContainerGetInstruction : FRigUnit
---@field InstructionName FName
---@field Color FLinearColor
---@field Transform FTransform
local FRigUnit_DrawContainerGetInstruction = {}



---@class FRigUnit_DrawContainerSetColor : FRigUnitMutable
---@field InstructionName FName
---@field Color FLinearColor
local FRigUnit_DrawContainerSetColor = {}



---@class FRigUnit_DrawContainerSetThickness : FRigUnitMutable
---@field InstructionName FName
---@field Thickness float
local FRigUnit_DrawContainerSetThickness = {}



---@class FRigUnit_DrawContainerSetTransform : FRigUnitMutable
---@field InstructionName FName
---@field Transform FTransform
local FRigUnit_DrawContainerSetTransform = {}



---@class FRigUnit_DynamicHierarchyBase : FRigUnit
local FRigUnit_DynamicHierarchyBase = {}


---@class FRigUnit_DynamicHierarchyBaseMutable : FRigUnitMutable
local FRigUnit_DynamicHierarchyBaseMutable = {}


---@class FRigUnit_EndProfilingTimer : FRigVMFunction_DebugBaseMutable
---@field NumberOfMeasurements int32
---@field Prefix FString
---@field AccumulatedTime float
---@field MeasurementsLeft int32
---@field bIsInitialized boolean
local FRigUnit_EndProfilingTimer = {}



---@class FRigUnit_FABRIK : FRigUnit_HighlevelBaseMutable
---@field StartBone FName
---@field EffectorBone FName
---@field EffectorTransform FTransform
---@field Precision float
---@field Weight float
---@field bPropagateToChildren boolean
---@field MaxIterations int32
---@field WorkData FRigUnit_FABRIK_WorkData
---@field bSetEffectorTransform boolean
local FRigUnit_FABRIK = {}



---@class FRigUnit_FABRIKItemArray : FRigUnit_HighlevelBaseMutable
---@field Items TArray<FRigElementKey>
---@field EffectorTransform FTransform
---@field Precision float
---@field Weight float
---@field bPropagateToChildren boolean
---@field MaxIterations int32
---@field WorkData FRigUnit_FABRIK_WorkData
---@field bSetEffectorTransform boolean
local FRigUnit_FABRIKItemArray = {}



---@class FRigUnit_FABRIKPerItem : FRigUnit_HighlevelBaseMutable
---@field Items FRigElementKeyCollection
---@field EffectorTransform FTransform
---@field Precision float
---@field Weight float
---@field bPropagateToChildren boolean
---@field MaxIterations int32
---@field WorkData FRigUnit_FABRIK_WorkData
---@field bSetEffectorTransform boolean
local FRigUnit_FABRIKPerItem = {}



---@class FRigUnit_FABRIK_WorkData
---@field Chain TArray<FFABRIKChainLink>
---@field CachedItems TArray<FCachedRigElement>
---@field CachedEffector FCachedRigElement
local FRigUnit_FABRIK_WorkData = {}



---@class FRigUnit_FilterItemsByMetadataTags : FRigUnit
---@field Items TArray<FRigElementKey>
---@field Tags TArray<FName>
---@field NameSpace ERigMetaDataNameSpace
---@field Inclusive boolean
---@field Result TArray<FRigElementKey>
---@field CachedIndices TArray<FCachedRigElement>
local FRigUnit_FilterItemsByMetadataTags = {}



---@class FRigUnit_FindItemsWithMetadata : FRigUnit
---@field Name FName
---@field Type ERigMetadataType
---@field NameSpace ERigMetaDataNameSpace
---@field Items TArray<FRigElementKey>
local FRigUnit_FindItemsWithMetadata = {}



---@class FRigUnit_FindItemsWithMetadataTag : FRigUnit
---@field Tag FName
---@field NameSpace ERigMetaDataNameSpace
---@field Items TArray<FRigElementKey>
local FRigUnit_FindItemsWithMetadataTag = {}



---@class FRigUnit_FindItemsWithMetadataTagArray : FRigUnit
---@field Tags TArray<FName>
---@field NameSpace ERigMetaDataNameSpace
---@field Items TArray<FRigElementKey>
local FRigUnit_FindItemsWithMetadataTagArray = {}



---@class FRigUnit_FitChainToCurve : FRigUnit_HighlevelBaseMutable
---@field StartBone FName
---@field EndBone FName
---@field Bezier FRigVMFourPointBezier
---@field Alignment EControlRigCurveAlignment
---@field Minimum float
---@field Maximum float
---@field SamplingPrecision int32
---@field PrimaryAxis FVector
---@field SecondaryAxis FVector
---@field PoleVectorPosition FVector
---@field Rotations TArray<FRigUnit_FitChainToCurve_Rotation>
---@field RotationEaseType ERigVMAnimEasingType
---@field Weight float
---@field bPropagateToChildren boolean
---@field DebugSettings FRigUnit_FitChainToCurve_DebugSettings
---@field WorkData FRigUnit_FitChainToCurve_WorkData
local FRigUnit_FitChainToCurve = {}



---@class FRigUnit_FitChainToCurveItemArray : FRigUnit_HighlevelBaseMutable
---@field Items TArray<FRigElementKey>
---@field Bezier FRigVMFourPointBezier
---@field Alignment EControlRigCurveAlignment
---@field Minimum float
---@field Maximum float
---@field SamplingPrecision int32
---@field PrimaryAxis FVector
---@field SecondaryAxis FVector
---@field PoleVectorPosition FVector
---@field Rotations TArray<FRigUnit_FitChainToCurve_Rotation>
---@field RotationEaseType ERigVMAnimEasingType
---@field Weight float
---@field bPropagateToChildren boolean
---@field DebugSettings FRigUnit_FitChainToCurve_DebugSettings
---@field WorkData FRigUnit_FitChainToCurve_WorkData
local FRigUnit_FitChainToCurveItemArray = {}



---@class FRigUnit_FitChainToCurvePerItem : FRigUnit_HighlevelBaseMutable
---@field Items FRigElementKeyCollection
---@field Bezier FRigVMFourPointBezier
---@field Alignment EControlRigCurveAlignment
---@field Minimum float
---@field Maximum float
---@field SamplingPrecision int32
---@field PrimaryAxis FVector
---@field SecondaryAxis FVector
---@field PoleVectorPosition FVector
---@field Rotations TArray<FRigUnit_FitChainToCurve_Rotation>
---@field RotationEaseType ERigVMAnimEasingType
---@field Weight float
---@field bPropagateToChildren boolean
---@field DebugSettings FRigUnit_FitChainToCurve_DebugSettings
---@field WorkData FRigUnit_FitChainToCurve_WorkData
local FRigUnit_FitChainToCurvePerItem = {}



---@class FRigUnit_FitChainToCurve_DebugSettings
---@field bEnabled boolean
---@field Scale float
---@field CurveColor FLinearColor
---@field SegmentsColor FLinearColor
---@field WorldOffset FTransform
local FRigUnit_FitChainToCurve_DebugSettings = {}



---@class FRigUnit_FitChainToCurve_Rotation
---@field Rotation FQuat
---@field Ratio float
local FRigUnit_FitChainToCurve_Rotation = {}



---@class FRigUnit_FitChainToCurve_WorkData
---@field ChainLength float
---@field ItemPositions TArray<FVector>
---@field ItemSegments TArray<float>
---@field CurvePositions TArray<FVector>
---@field CurveSegments TArray<float>
---@field CachedItems TArray<FCachedRigElement>
---@field ItemRotationA TArray<int32>
---@field ItemRotationB TArray<int32>
---@field ItemRotationT TArray<float>
---@field ItemLocalTransforms TArray<FTransform>
local FRigUnit_FitChainToCurve_WorkData = {}



---@class FRigUnit_GetAnimationChannelBase : FRigUnit
---@field Control FName
---@field Channel FName
---@field bInitial boolean
---@field CachedChannelKey FRigElementKey
---@field CachedChannelHash int32
local FRigUnit_GetAnimationChannelBase = {}



---@class FRigUnit_GetAnimationChannelFromItemBase : FRigUnit
---@field Item FRigElementKey
---@field bInitial boolean
local FRigUnit_GetAnimationChannelFromItemBase = {}



---@class FRigUnit_GetBoneTransform : FRigUnit
---@field bone FName
---@field Space ERigVMTransformSpace
---@field Transform FTransform
---@field CachedBone FCachedRigElement
---@field bFirstUpdate boolean
local FRigUnit_GetBoneTransform = {}



---@class FRigUnit_GetBoolAnimationChannel : FRigUnit_GetAnimationChannelBase
---@field Value boolean
local FRigUnit_GetBoolAnimationChannel = {}



---@class FRigUnit_GetBoolAnimationChannelFromItem : FRigUnit_GetAnimationChannelFromItemBase
---@field Value boolean
local FRigUnit_GetBoolAnimationChannelFromItem = {}



---@class FRigUnit_GetCandidates : FRigUnit
---@field Connector FRigElementKey
---@field Candidates TArray<FRigElementKey>
local FRigUnit_GetCandidates = {}



---@class FRigUnit_GetControlBool : FRigUnit
---@field Control FName
---@field BoolValue boolean
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlBool = {}



---@class FRigUnit_GetControlColor : FRigUnit
---@field Control FName
---@field Color FLinearColor
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlColor = {}



---@class FRigUnit_GetControlDrivenList : FRigUnit
---@field Control FName
---@field Driven TArray<FRigElementKey>
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlDrivenList = {}



---@class FRigUnit_GetControlFloat : FRigUnit
---@field Control FName
---@field FloatValue float
---@field Minimum float
---@field Maximum float
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlFloat = {}



---@class FRigUnit_GetControlInitialTransform : FRigUnit
---@field Control FName
---@field Space ERigVMTransformSpace
---@field Transform FTransform
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlInitialTransform = {}



---@class FRigUnit_GetControlInteger : FRigUnit
---@field Control FName
---@field IntegerValue int32
---@field Minimum int32
---@field Maximum int32
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlInteger = {}



---@class FRigUnit_GetControlRotator : FRigUnit
---@field Control FName
---@field Space ERigVMTransformSpace
---@field Rotator FRotator
---@field Minimum FRotator
---@field Maximum FRotator
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlRotator = {}



---@class FRigUnit_GetControlTransform : FRigUnit
---@field Control FName
---@field Space ERigVMTransformSpace
---@field Transform FTransform
---@field Minimum FTransform
---@field Maximum FTransform
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlTransform = {}



---@class FRigUnit_GetControlVector : FRigUnit
---@field Control FName
---@field Space ERigVMTransformSpace
---@field Vector FVector
---@field Minimum FVector
---@field Maximum FVector
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlVector = {}



---@class FRigUnit_GetControlVector2D : FRigUnit
---@field Control FName
---@field Vector FVector2D
---@field Minimum FVector2D
---@field Maximum FVector2D
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlVector2D = {}



---@class FRigUnit_GetControlVisibility : FRigUnit
---@field Item FRigElementKey
---@field bVisible boolean
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetControlVisibility = {}



---@class FRigUnit_GetCurrentNameSpace : FRigUnit_RigModulesBase
---@field NameSpace FString
local FRigUnit_GetCurrentNameSpace = {}



---@class FRigUnit_GetCurveValue : FRigUnit
---@field Curve FName
---@field Valid boolean
---@field Value float
---@field CachedCurveIndex FCachedRigElement
local FRigUnit_GetCurveValue = {}



---@class FRigUnit_GetFloatAnimationChannel : FRigUnit_GetAnimationChannelBase
---@field Value float
local FRigUnit_GetFloatAnimationChannel = {}



---@class FRigUnit_GetFloatAnimationChannelFromItem : FRigUnit_GetAnimationChannelFromItemBase
---@field Value float
local FRigUnit_GetFloatAnimationChannelFromItem = {}



---@class FRigUnit_GetInitialBoneTransform : FRigUnit
---@field bone FName
---@field Space ERigVMTransformSpace
---@field Transform FTransform
---@field CachedBone FCachedRigElement
local FRigUnit_GetInitialBoneTransform = {}



---@class FRigUnit_GetIntAnimationChannel : FRigUnit_GetAnimationChannelBase
---@field Value int32
local FRigUnit_GetIntAnimationChannel = {}



---@class FRigUnit_GetIntAnimationChannelFromItem : FRigUnit_GetAnimationChannelFromItemBase
---@field Value int32
local FRigUnit_GetIntAnimationChannelFromItem = {}



---@class FRigUnit_GetItemNameSpace : FRigUnit_RigModulesBase
---@field Item FRigElementKey
---@field HasNameSpace boolean
---@field NameSpace FString
local FRigUnit_GetItemNameSpace = {}



---@class FRigUnit_GetItemShortName : FRigUnit_RigModulesBase
---@field Item FRigElementKey
---@field ShortName FName
local FRigUnit_GetItemShortName = {}



---@class FRigUnit_GetItemsInNameSpace : FRigUnit_RigModulesBase
---@field TypeToSearch ERigElementType
---@field Items TArray<FRigElementKey>
local FRigUnit_GetItemsInNameSpace = {}



---@class FRigUnit_GetJointTransform : FRigUnitMutable
---@field Joint FName
---@field Type ETransformGetterType
---@field TransformSpace ETransformSpaceMode
---@field BaseTransform FTransform
---@field BaseJoint FName
---@field Output FTransform
local FRigUnit_GetJointTransform = {}



---@class FRigUnit_GetMetadataTags : FRigUnit
---@field Item FRigElementKey
---@field Tags TArray<FName>
---@field CachedIndex FCachedRigElement
local FRigUnit_GetMetadataTags = {}



---@class FRigUnit_GetRelativeBoneTransform : FRigUnit
---@field bone FName
---@field Space FName
---@field Transform FTransform
---@field CachedBone FCachedRigElement
---@field CachedSpace FCachedRigElement
local FRigUnit_GetRelativeBoneTransform = {}



---@class FRigUnit_GetRelativeTransform : FRigUnit_BinaryTransformOp
local FRigUnit_GetRelativeTransform = {}


---@class FRigUnit_GetRelativeTransformForItem : FRigUnit
---@field Child FRigElementKey
---@field bChildInitial boolean
---@field Parent FRigElementKey
---@field bParentInitial boolean
---@field RelativeTransform FTransform
---@field CachedChild FCachedRigElement
---@field CachedParent FCachedRigElement
local FRigUnit_GetRelativeTransformForItem = {}



---@class FRigUnit_GetRotatorAnimationChannel : FRigUnit_GetAnimationChannelBase
---@field Value FRotator
local FRigUnit_GetRotatorAnimationChannel = {}



---@class FRigUnit_GetRotatorAnimationChannelFromItem : FRigUnit_GetAnimationChannelFromItemBase
---@field Value FRotator
local FRigUnit_GetRotatorAnimationChannelFromItem = {}



---@class FRigUnit_GetShapeTransform : FRigUnit
---@field Control FName
---@field Transform FTransform
---@field CachedControlIndex FCachedRigElement
local FRigUnit_GetShapeTransform = {}



---@class FRigUnit_GetSpaceTransform : FRigUnit
---@field Space FName
---@field SpaceType ERigVMTransformSpace
---@field Transform FTransform
---@field CachedSpaceIndex FCachedRigElement
local FRigUnit_GetSpaceTransform = {}



---@class FRigUnit_GetTransform : FRigUnit
---@field Item FRigElementKey
---@field Space ERigVMTransformSpace
---@field bInitial boolean
---@field Transform FTransform
---@field CachedIndex FCachedRigElement
local FRigUnit_GetTransform = {}



---@class FRigUnit_GetTransformAnimationChannel : FRigUnit_GetAnimationChannelBase
---@field Value FTransform
local FRigUnit_GetTransformAnimationChannel = {}



---@class FRigUnit_GetTransformAnimationChannelFromItem : FRigUnit_GetAnimationChannelFromItemBase
---@field Value FTransform
local FRigUnit_GetTransformAnimationChannelFromItem = {}



---@class FRigUnit_GetTransformArray : FRigUnit
---@field Items FRigElementKeyCollection
---@field Space ERigVMTransformSpace
---@field bInitial boolean
---@field Transforms TArray<FTransform>
---@field CachedIndex TArray<FCachedRigElement>
local FRigUnit_GetTransformArray = {}



---@class FRigUnit_GetTransformItemArray : FRigUnit
---@field Items TArray<FRigElementKey>
---@field Space ERigVMTransformSpace
---@field bInitial boolean
---@field Transforms TArray<FTransform>
---@field CachedIndex TArray<FCachedRigElement>
local FRigUnit_GetTransformItemArray = {}



---@class FRigUnit_GetVector2DAnimationChannel : FRigUnit_GetAnimationChannelBase
---@field Value FVector2D
local FRigUnit_GetVector2DAnimationChannel = {}



---@class FRigUnit_GetVector2DAnimationChannelFromItem : FRigUnit_GetAnimationChannelFromItemBase
---@field Value FVector2D
local FRigUnit_GetVector2DAnimationChannelFromItem = {}



---@class FRigUnit_GetVectorAnimationChannel : FRigUnit_GetAnimationChannelBase
---@field Value FVector
local FRigUnit_GetVectorAnimationChannel = {}



---@class FRigUnit_GetVectorAnimationChannelFromItem : FRigUnit_GetAnimationChannelFromItemBase
---@field Value FVector
local FRigUnit_GetVectorAnimationChannelFromItem = {}



---@class FRigUnit_Harmonics_TargetItem
---@field Item FRigElementKey
---@field Ratio float
local FRigUnit_Harmonics_TargetItem = {}



---@class FRigUnit_HasMetadata : FRigUnit
---@field Item FRigElementKey
---@field Name FName
---@field Type ERigMetadataType
---@field NameSpace ERigMetaDataNameSpace
---@field found boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_HasMetadata = {}



---@class FRigUnit_HasMetadataTag : FRigUnit
---@field Item FRigElementKey
---@field Tag FName
---@field NameSpace ERigMetaDataNameSpace
---@field found boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_HasMetadataTag = {}



---@class FRigUnit_HasMetadataTagArray : FRigUnit
---@field Item FRigElementKey
---@field Tags TArray<FName>
---@field NameSpace ERigMetaDataNameSpace
---@field found boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_HasMetadataTagArray = {}



---@class FRigUnit_HierarchyAddAnimationChannel2DLimitSettings : FRigUnit_HierarchyAddAnimationChannelEmptyLimitSettings
---@field X FRigControlLimitEnabled
---@field Y FRigControlLimitEnabled
local FRigUnit_HierarchyAddAnimationChannel2DLimitSettings = {}



---@class FRigUnit_HierarchyAddAnimationChannelBool : FRigUnit_HierarchyAddElement
---@field InitialValue boolean
---@field MinimumValue boolean
---@field MaximumValue boolean
---@field LimitsEnabled FRigUnit_HierarchyAddAnimationChannelEmptyLimitSettings
local FRigUnit_HierarchyAddAnimationChannelBool = {}



---@class FRigUnit_HierarchyAddAnimationChannelEmptyLimitSettings
local FRigUnit_HierarchyAddAnimationChannelEmptyLimitSettings = {}


---@class FRigUnit_HierarchyAddAnimationChannelFloat : FRigUnit_HierarchyAddElement
---@field InitialValue float
---@field MinimumValue float
---@field MaximumValue float
---@field LimitsEnabled FRigUnit_HierarchyAddAnimationChannelSingleLimitSettings
local FRigUnit_HierarchyAddAnimationChannelFloat = {}



---@class FRigUnit_HierarchyAddAnimationChannelInteger : FRigUnit_HierarchyAddElement
---@field InitialValue int32
---@field MinimumValue int32
---@field MaximumValue int32
---@field LimitsEnabled FRigUnit_HierarchyAddAnimationChannelSingleLimitSettings
---@field ControlEnum UEnum
local FRigUnit_HierarchyAddAnimationChannelInteger = {}



---@class FRigUnit_HierarchyAddAnimationChannelRotator : FRigUnit_HierarchyAddElement
---@field InitialValue FRotator
---@field MinimumValue FRotator
---@field MaximumValue FRotator
---@field LimitsEnabled FRigUnit_HierarchyAddAnimationChannelRotatorLimitSettings
local FRigUnit_HierarchyAddAnimationChannelRotator = {}



---@class FRigUnit_HierarchyAddAnimationChannelRotatorLimitSettings : FRigUnit_HierarchyAddAnimationChannelEmptyLimitSettings
---@field Pitch FRigControlLimitEnabled
---@field Yaw FRigControlLimitEnabled
---@field Roll FRigControlLimitEnabled
local FRigUnit_HierarchyAddAnimationChannelRotatorLimitSettings = {}



---@class FRigUnit_HierarchyAddAnimationChannelScaleFloat : FRigUnit_HierarchyAddElement
---@field InitialValue float
---@field MinimumValue float
---@field MaximumValue float
---@field LimitsEnabled FRigUnit_HierarchyAddAnimationChannelSingleLimitSettings
local FRigUnit_HierarchyAddAnimationChannelScaleFloat = {}



---@class FRigUnit_HierarchyAddAnimationChannelScaleVector : FRigUnit_HierarchyAddElement
---@field InitialValue FVector
---@field MinimumValue FVector
---@field MaximumValue FVector
---@field LimitsEnabled FRigUnit_HierarchyAddAnimationChannelVectorLimitSettings
local FRigUnit_HierarchyAddAnimationChannelScaleVector = {}



---@class FRigUnit_HierarchyAddAnimationChannelSingleLimitSettings : FRigUnit_HierarchyAddAnimationChannelEmptyLimitSettings
---@field Enabled FRigControlLimitEnabled
local FRigUnit_HierarchyAddAnimationChannelSingleLimitSettings = {}



---@class FRigUnit_HierarchyAddAnimationChannelVector : FRigUnit_HierarchyAddElement
---@field InitialValue FVector
---@field MinimumValue FVector
---@field MaximumValue FVector
---@field LimitsEnabled FRigUnit_HierarchyAddAnimationChannelVectorLimitSettings
local FRigUnit_HierarchyAddAnimationChannelVector = {}



---@class FRigUnit_HierarchyAddAnimationChannelVector2D : FRigUnit_HierarchyAddElement
---@field InitialValue FVector2D
---@field MinimumValue FVector2D
---@field MaximumValue FVector2D
---@field LimitsEnabled FRigUnit_HierarchyAddAnimationChannel2DLimitSettings
local FRigUnit_HierarchyAddAnimationChannelVector2D = {}



---@class FRigUnit_HierarchyAddAnimationChannelVectorLimitSettings : FRigUnit_HierarchyAddAnimationChannelEmptyLimitSettings
---@field X FRigControlLimitEnabled
---@field Y FRigControlLimitEnabled
---@field Z FRigControlLimitEnabled
local FRigUnit_HierarchyAddAnimationChannelVectorLimitSettings = {}



---@class FRigUnit_HierarchyAddBone : FRigUnit_HierarchyAddElement
---@field Transform FTransform
---@field Space ERigVMTransformSpace
local FRigUnit_HierarchyAddBone = {}



---@class FRigUnit_HierarchyAddControlElement : FRigUnit_HierarchyAddElement
---@field OffsetTransform FTransform
---@field OffsetSpace ERigVMTransformSpace
local FRigUnit_HierarchyAddControlElement = {}



---@class FRigUnit_HierarchyAddControlFloat : FRigUnit_HierarchyAddControlElement
---@field InitialValue float
---@field Settings FRigUnit_HierarchyAddControlFloat_Settings
local FRigUnit_HierarchyAddControlFloat = {}



---@class FRigUnit_HierarchyAddControlFloat_LimitSettings
---@field Limit FRigControlLimitEnabled
---@field MinValue float
---@field MaxValue float
---@field bDrawLimits boolean
local FRigUnit_HierarchyAddControlFloat_LimitSettings = {}



---@class FRigUnit_HierarchyAddControlFloat_Settings : FRigUnit_HierarchyAddControl_Settings
---@field PrimaryAxis ERigControlAxis
---@field bIsScale boolean
---@field Limits FRigUnit_HierarchyAddControlFloat_LimitSettings
---@field Shape FRigUnit_HierarchyAddControl_ShapeSettings
---@field Proxy FRigUnit_HierarchyAddControl_ProxySettings
local FRigUnit_HierarchyAddControlFloat_Settings = {}



---@class FRigUnit_HierarchyAddControlInteger : FRigUnit_HierarchyAddControlElement
---@field InitialValue int32
---@field Settings FRigUnit_HierarchyAddControlInteger_Settings
local FRigUnit_HierarchyAddControlInteger = {}



---@class FRigUnit_HierarchyAddControlInteger_LimitSettings
---@field Limit FRigControlLimitEnabled
---@field MinValue int32
---@field MaxValue int32
---@field bDrawLimits boolean
local FRigUnit_HierarchyAddControlInteger_LimitSettings = {}



---@class FRigUnit_HierarchyAddControlInteger_Settings : FRigUnit_HierarchyAddControl_Settings
---@field PrimaryAxis ERigControlAxis
---@field ControlEnum UEnum
---@field Limits FRigUnit_HierarchyAddControlInteger_LimitSettings
---@field Shape FRigUnit_HierarchyAddControl_ShapeSettings
---@field Proxy FRigUnit_HierarchyAddControl_ProxySettings
local FRigUnit_HierarchyAddControlInteger_Settings = {}



---@class FRigUnit_HierarchyAddControlRotator : FRigUnit_HierarchyAddControlElement
---@field InitialValue FRotator
---@field Settings FRigUnit_HierarchyAddControlRotator_Settings
local FRigUnit_HierarchyAddControlRotator = {}



---@class FRigUnit_HierarchyAddControlRotator_LimitSettings
---@field LimitPitch FRigControlLimitEnabled
---@field LimitYaw FRigControlLimitEnabled
---@field LimitRoll FRigControlLimitEnabled
---@field MinValue FRotator
---@field MaxValue FRotator
---@field bDrawLimits boolean
local FRigUnit_HierarchyAddControlRotator_LimitSettings = {}



---@class FRigUnit_HierarchyAddControlRotator_Settings : FRigUnit_HierarchyAddControl_Settings
---@field InitialSpace ERigVMTransformSpace
---@field Limits FRigUnit_HierarchyAddControlRotator_LimitSettings
---@field Shape FRigUnit_HierarchyAddControl_ShapeSettings
---@field Proxy FRigUnit_HierarchyAddControl_ProxySettings
---@field FilteredChannels TArray<ERigControlTransformChannel>
local FRigUnit_HierarchyAddControlRotator_Settings = {}



---@class FRigUnit_HierarchyAddControlTransform : FRigUnit_HierarchyAddControlElement
---@field InitialValue FTransform
---@field Settings FRigUnit_HierarchyAddControlTransform_Settings
local FRigUnit_HierarchyAddControlTransform = {}



---@class FRigUnit_HierarchyAddControlTransform_LimitSettings
---@field LimitTranslationX FRigControlLimitEnabled
---@field LimitTranslationY FRigControlLimitEnabled
---@field LimitTranslationZ FRigControlLimitEnabled
---@field LimitPitch FRigControlLimitEnabled
---@field LimitYaw FRigControlLimitEnabled
---@field LimitRoll FRigControlLimitEnabled
---@field LimitScaleX FRigControlLimitEnabled
---@field LimitScaleY FRigControlLimitEnabled
---@field LimitScaleZ FRigControlLimitEnabled
---@field MinValue FEulerTransform
---@field MaxValue FEulerTransform
---@field bDrawLimits boolean
local FRigUnit_HierarchyAddControlTransform_LimitSettings = {}



---@class FRigUnit_HierarchyAddControlTransform_Settings : FRigUnit_HierarchyAddControl_Settings
---@field InitialSpace ERigVMTransformSpace
---@field bUsePreferredRotationOrder boolean
---@field PreferredRotationOrder EEulerRotationOrder
---@field Limits FRigUnit_HierarchyAddControlTransform_LimitSettings
---@field Shape FRigUnit_HierarchyAddControl_ShapeSettings
---@field Proxy FRigUnit_HierarchyAddControl_ProxySettings
---@field FilteredChannels TArray<ERigControlTransformChannel>
local FRigUnit_HierarchyAddControlTransform_Settings = {}



---@class FRigUnit_HierarchyAddControlVector : FRigUnit_HierarchyAddControlElement
---@field InitialValue FVector
---@field Settings FRigUnit_HierarchyAddControlVector_Settings
local FRigUnit_HierarchyAddControlVector = {}



---@class FRigUnit_HierarchyAddControlVector2D : FRigUnit_HierarchyAddControlElement
---@field InitialValue FVector2D
---@field Settings FRigUnit_HierarchyAddControlVector2D_Settings
local FRigUnit_HierarchyAddControlVector2D = {}



---@class FRigUnit_HierarchyAddControlVector2D_LimitSettings
---@field LimitX FRigControlLimitEnabled
---@field LimitY FRigControlLimitEnabled
---@field MinValue FVector2D
---@field MaxValue FVector2D
---@field bDrawLimits boolean
local FRigUnit_HierarchyAddControlVector2D_LimitSettings = {}



---@class FRigUnit_HierarchyAddControlVector2D_Settings : FRigUnit_HierarchyAddControl_Settings
---@field PrimaryAxis ERigControlAxis
---@field Limits FRigUnit_HierarchyAddControlVector2D_LimitSettings
---@field Shape FRigUnit_HierarchyAddControl_ShapeSettings
---@field Proxy FRigUnit_HierarchyAddControl_ProxySettings
---@field FilteredChannels TArray<ERigControlTransformChannel>
local FRigUnit_HierarchyAddControlVector2D_Settings = {}



---@class FRigUnit_HierarchyAddControlVector_LimitSettings
---@field LimitX FRigControlLimitEnabled
---@field LimitY FRigControlLimitEnabled
---@field LimitZ FRigControlLimitEnabled
---@field MinValue FVector
---@field MaxValue FVector
---@field bDrawLimits boolean
local FRigUnit_HierarchyAddControlVector_LimitSettings = {}



---@class FRigUnit_HierarchyAddControlVector_Settings : FRigUnit_HierarchyAddControl_Settings
---@field InitialSpace ERigVMTransformSpace
---@field bIsPosition boolean
---@field Limits FRigUnit_HierarchyAddControlVector_LimitSettings
---@field Shape FRigUnit_HierarchyAddControl_ShapeSettings
---@field Proxy FRigUnit_HierarchyAddControl_ProxySettings
---@field FilteredChannels TArray<ERigControlTransformChannel>
local FRigUnit_HierarchyAddControlVector_Settings = {}



---@class FRigUnit_HierarchyAddControl_ProxySettings
---@field bIsProxy boolean
---@field DrivenControls TArray<FRigElementKey>
---@field ShapeVisibility ERigControlVisibility
local FRigUnit_HierarchyAddControl_ProxySettings = {}



---@class FRigUnit_HierarchyAddControl_Settings
---@field DisplayName FName
local FRigUnit_HierarchyAddControl_Settings = {}



---@class FRigUnit_HierarchyAddControl_ShapeSettings
---@field bVisible boolean
---@field Name FName
---@field Color FLinearColor
---@field Transform FTransform
local FRigUnit_HierarchyAddControl_ShapeSettings = {}



---@class FRigUnit_HierarchyAddElement : FRigUnit_DynamicHierarchyBaseMutable
---@field Parent FRigElementKey
---@field Name FName
---@field Item FRigElementKey
local FRigUnit_HierarchyAddElement = {}



---@class FRigUnit_HierarchyAddNull : FRigUnit_HierarchyAddElement
---@field Transform FTransform
---@field Space ERigVMTransformSpace
local FRigUnit_HierarchyAddNull = {}



---@class FRigUnit_HierarchyAddPhysicsJoint : FRigUnit_HierarchyAddElement
---@field Transform FTransform
---@field Solver FRigPhysicsSolverID
---@field Settings FRigPhysicsSettings
local FRigUnit_HierarchyAddPhysicsJoint = {}



---@class FRigUnit_HierarchyAddPhysicsSolver : FRigUnit_DynamicHierarchyBaseMutable
---@field Name FName
---@field Solver FRigPhysicsSolverID
local FRigUnit_HierarchyAddPhysicsSolver = {}



---@class FRigUnit_HierarchyAddSocket : FRigUnit_HierarchyAddElement
---@field Transform FTransform
---@field Space ERigVMTransformSpace
---@field Color FLinearColor
---@field Description FString
local FRigUnit_HierarchyAddSocket = {}



---@class FRigUnit_HierarchyBase : FRigUnit
local FRigUnit_HierarchyBase = {}


---@class FRigUnit_HierarchyBaseMutable : FRigUnitMutable
local FRigUnit_HierarchyBaseMutable = {}


---@class FRigUnit_HierarchyCreatePoseItemArray : FRigUnit_HierarchyBase
---@field Entries TArray<FRigUnit_HierarchyCreatePoseItemArray_Entry>
---@field Pose FRigPose
local FRigUnit_HierarchyCreatePoseItemArray = {}



---@class FRigUnit_HierarchyCreatePoseItemArray_Entry
---@field Item FRigElementKey
---@field LocalTransform FTransform
---@field GlobalTransform FTransform
---@field UseEulerAngles boolean
---@field EulerAngles FVector
---@field CurveValue float
local FRigUnit_HierarchyCreatePoseItemArray_Entry = {}



---@class FRigUnit_HierarchyGetChainItemArray : FRigUnit_HierarchyBase
---@field Start FRigElementKey
---@field End FRigElementKey
---@field bIncludeStart boolean
---@field bIncludeEnd boolean
---@field bReverse boolean
---@field Chain TArray<FRigElementKey>
---@field CachedStart FCachedRigElement
---@field CachedEnd FCachedRigElement
---@field CachedChain FRigElementKeyCollection
local FRigUnit_HierarchyGetChainItemArray = {}



---@class FRigUnit_HierarchyGetChildren : FRigUnit_HierarchyBase
---@field Parent FRigElementKey
---@field bIncludeParent boolean
---@field bRecursive boolean
---@field Children FRigElementKeyCollection
---@field CachedParent FCachedRigElement
---@field CachedChildren FRigElementKeyCollection
local FRigUnit_HierarchyGetChildren = {}



---@class FRigUnit_HierarchyGetParent : FRigUnit_HierarchyBase
---@field Child FRigElementKey
---@field bDefaultParent boolean
---@field Parent FRigElementKey
---@field CachedChild FCachedRigElement
---@field CachedParent FCachedRigElement
local FRigUnit_HierarchyGetParent = {}



---@class FRigUnit_HierarchyGetParentWeights : FRigUnit_DynamicHierarchyBase
---@field Child FRigElementKey
---@field Weights TArray<FRigElementWeight>
---@field Parents FRigElementKeyCollection
local FRigUnit_HierarchyGetParentWeights = {}



---@class FRigUnit_HierarchyGetParentWeightsArray : FRigUnit_DynamicHierarchyBase
---@field Child FRigElementKey
---@field Weights TArray<FRigElementWeight>
---@field Parents TArray<FRigElementKey>
local FRigUnit_HierarchyGetParentWeightsArray = {}



---@class FRigUnit_HierarchyGetParents : FRigUnit_HierarchyBase
---@field Child FRigElementKey
---@field bIncludeChild boolean
---@field bReverse boolean
---@field Parents FRigElementKeyCollection
---@field CachedChild FCachedRigElement
---@field CachedParents FRigElementKeyCollection
local FRigUnit_HierarchyGetParents = {}



---@class FRigUnit_HierarchyGetParentsItemArray : FRigUnit_HierarchyBase
---@field Child FRigElementKey
---@field bIncludeChild boolean
---@field bReverse boolean
---@field bDefaultParent boolean
---@field Parents TArray<FRigElementKey>
---@field CachedChild FCachedRigElement
---@field CachedParents FRigElementKeyCollection
local FRigUnit_HierarchyGetParentsItemArray = {}



---@class FRigUnit_HierarchyGetPose : FRigUnit_HierarchyBase
---@field Initial boolean
---@field ElementType ERigElementType
---@field ItemsToGet FRigElementKeyCollection
---@field Pose FRigPose
local FRigUnit_HierarchyGetPose = {}



---@class FRigUnit_HierarchyGetPoseItemArray : FRigUnit_HierarchyBase
---@field Initial boolean
---@field ElementType ERigElementType
---@field ItemsToGet TArray<FRigElementKey>
---@field Pose FRigPose
local FRigUnit_HierarchyGetPoseItemArray = {}



---@class FRigUnit_HierarchyGetShapeSettings : FRigUnit_DynamicHierarchyBase
---@field Item FRigElementKey
---@field Settings FRigUnit_HierarchyAddControl_ShapeSettings
local FRigUnit_HierarchyGetShapeSettings = {}



---@class FRigUnit_HierarchyGetSiblings : FRigUnit_HierarchyBase
---@field Item FRigElementKey
---@field bIncludeItem boolean
---@field Siblings FRigElementKeyCollection
---@field CachedItem FCachedRigElement
---@field CachedSiblings FRigElementKeyCollection
local FRigUnit_HierarchyGetSiblings = {}



---@class FRigUnit_HierarchyGetSiblingsItemArray : FRigUnit_HierarchyBase
---@field Item FRigElementKey
---@field bIncludeItem boolean
---@field bDefaultSiblings boolean
---@field Siblings TArray<FRigElementKey>
---@field CachedItem FCachedRigElement
---@field CachedSiblings FRigElementKeyCollection
local FRigUnit_HierarchyGetSiblingsItemArray = {}



---@class FRigUnit_HierarchyImportFromSkeleton : FRigUnit_DynamicHierarchyBaseMutable
---@field NameSpace FName
---@field bIncludeCurves boolean
---@field Items TArray<FRigElementKey>
local FRigUnit_HierarchyImportFromSkeleton = {}



---@class FRigUnit_HierarchyRemoveElement : FRigUnit_DynamicHierarchyBaseMutable
---@field Item FRigElementKey
---@field bSuccess boolean
local FRigUnit_HierarchyRemoveElement = {}



---@class FRigUnit_HierarchyReset : FRigUnit_DynamicHierarchyBaseMutable
local FRigUnit_HierarchyReset = {}


---@class FRigUnit_HierarchySetParentWeights : FRigUnit_DynamicHierarchyBaseMutable
---@field Child FRigElementKey
---@field Weights TArray<FRigElementWeight>
local FRigUnit_HierarchySetParentWeights = {}



---@class FRigUnit_HierarchySetPose : FRigUnit_HierarchyBaseMutable
---@field Pose FRigPose
---@field ElementType ERigElementType
---@field Space ERigVMTransformSpace
---@field ItemsToSet FRigElementKeyCollection
---@field Weight float
local FRigUnit_HierarchySetPose = {}



---@class FRigUnit_HierarchySetPoseItemArray : FRigUnit_HierarchyBaseMutable
---@field Pose FRigPose
---@field ElementType ERigElementType
---@field Space ERigVMTransformSpace
---@field ItemsToSet TArray<FRigElementKey>
---@field Weight float
local FRigUnit_HierarchySetPoseItemArray = {}



---@class FRigUnit_HierarchySetShapeSettings : FRigUnit_DynamicHierarchyBaseMutable
---@field Item FRigElementKey
---@field Settings FRigUnit_HierarchyAddControl_ShapeSettings
local FRigUnit_HierarchySetShapeSettings = {}



---@class FRigUnit_HighlevelBase : FRigUnit
local FRigUnit_HighlevelBase = {}


---@class FRigUnit_HighlevelBaseMutable : FRigUnitMutable
local FRigUnit_HighlevelBaseMutable = {}


---@class FRigUnit_InteractionExecution : FRigUnit
---@field ExecuteContext FControlRigExecuteContext
local FRigUnit_InteractionExecution = {}



---@class FRigUnit_InverseExecution : FRigUnit
---@field ExecuteContext FControlRigExecuteContext
local FRigUnit_InverseExecution = {}



---@class FRigUnit_InverseQuaterion : FRigUnit_UnaryQuaternionOp
local FRigUnit_InverseQuaterion = {}


---@class FRigUnit_IsInteracting : FRigUnit
---@field bIsInteracting boolean
---@field bIsTranslating boolean
---@field bIsRotating boolean
---@field bIsScaling boolean
---@field Items TArray<FRigElementKey>
local FRigUnit_IsInteracting = {}



---@class FRigUnit_IsItemInCurrentNameSpace : FRigUnit_RigModulesBase
---@field Item FRigElementKey
---@field Result boolean
local FRigUnit_IsItemInCurrentNameSpace = {}



---@class FRigUnit_Item : FRigUnit
---@field Item FRigElementKey
local FRigUnit_Item = {}



---@class FRigUnit_ItemArray : FRigUnit
---@field Items TArray<FRigElementKey>
local FRigUnit_ItemArray = {}



---@class FRigUnit_ItemBase : FRigUnit
local FRigUnit_ItemBase = {}


---@class FRigUnit_ItemBaseMutable : FRigUnitMutable
local FRigUnit_ItemBaseMutable = {}


---@class FRigUnit_ItemEquals : FRigUnit_ItemBase
---@field A FRigElementKey
---@field B FRigElementKey
---@field Result boolean
local FRigUnit_ItemEquals = {}



---@class FRigUnit_ItemExists : FRigUnit_ItemBase
---@field Item FRigElementKey
---@field Exists boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_ItemExists = {}



---@class FRigUnit_ItemHarmonics : FRigUnit_HighlevelBaseMutable
---@field Targets TArray<FRigUnit_Harmonics_TargetItem>
---@field WaveSpeed FVector
---@field WaveFrequency FVector
---@field WaveAmplitude FVector
---@field WaveOffset FVector
---@field WaveNoise FVector
---@field WaveEase ERigVMAnimEasingType
---@field WaveMinimum float
---@field WaveMaximum float
---@field RotationOrder EEulerRotationOrder
---@field WorkData FRigUnit_BoneHarmonics_WorkData
local FRigUnit_ItemHarmonics = {}



---@class FRigUnit_ItemNotEquals : FRigUnit_ItemBase
---@field A FRigElementKey
---@field B FRigElementKey
---@field Result boolean
local FRigUnit_ItemNotEquals = {}



---@class FRigUnit_ItemReplace : FRigUnit_ItemBase
---@field Item FRigElementKey
---@field Old FName
---@field New FName
---@field Result FRigElementKey
local FRigUnit_ItemReplace = {}



---@class FRigUnit_ItemToName : FRigUnit_ItemBase
---@field Value FRigElementKey
---@field Result FName
local FRigUnit_ItemToName = {}



---@class FRigUnit_ItemTypeEquals : FRigUnit_ItemBase
---@field A FRigElementKey
---@field B FRigElementKey
---@field Result boolean
local FRigUnit_ItemTypeEquals = {}



---@class FRigUnit_ItemTypeNotEquals : FRigUnit_ItemBase
---@field A FRigElementKey
---@field B FRigElementKey
---@field Result boolean
local FRigUnit_ItemTypeNotEquals = {}



---@class FRigUnit_MapRange_Float : FRigUnit
---@field Value float
---@field MinIn float
---@field MaxIn float
---@field MinOut float
---@field MaxOut float
---@field Result float
local FRigUnit_MapRange_Float = {}



---@class FRigUnit_ModifyBoneTransforms : FRigUnit_HighlevelBaseMutable
---@field BoneToModify TArray<FRigUnit_ModifyBoneTransforms_PerBone>
---@field Weight float
---@field WeightMinimum float
---@field WeightMaximum float
---@field Mode EControlRigModifyBoneMode
---@field WorkData FRigUnit_ModifyBoneTransforms_WorkData
local FRigUnit_ModifyBoneTransforms = {}



---@class FRigUnit_ModifyBoneTransforms_PerBone
---@field bone FName
---@field Transform FTransform
local FRigUnit_ModifyBoneTransforms_PerBone = {}



---@class FRigUnit_ModifyBoneTransforms_WorkData : FRigUnit_ModifyTransforms_WorkData
local FRigUnit_ModifyBoneTransforms_WorkData = {}


---@class FRigUnit_ModifyTransforms : FRigUnit_HighlevelBaseMutable
---@field ItemToModify TArray<FRigUnit_ModifyTransforms_PerItem>
---@field Weight float
---@field WeightMinimum float
---@field WeightMaximum float
---@field Mode EControlRigModifyBoneMode
---@field WorkData FRigUnit_ModifyTransforms_WorkData
local FRigUnit_ModifyTransforms = {}



---@class FRigUnit_ModifyTransforms_PerItem
---@field Item FRigElementKey
---@field Transform FTransform
local FRigUnit_ModifyTransforms_PerItem = {}



---@class FRigUnit_ModifyTransforms_WorkData
---@field CachedItems TArray<FCachedRigElement>
local FRigUnit_ModifyTransforms_WorkData = {}



---@class FRigUnit_MultiFABRIK : FRigUnit_HighlevelBaseMutable
---@field RootBone FName
---@field Effectors TArray<FRigUnit_MultiFABRIK_EndEffector>
---@field Precision float
---@field bPropagateToChildren boolean
---@field MaxIterations int32
---@field WorkData FRigUnit_MultiFABRIK_WorkData
---@field bIsInitialized boolean
local FRigUnit_MultiFABRIK = {}



---@class FRigUnit_MultiFABRIK_EndEffector
---@field bone FName
---@field Location FVector
local FRigUnit_MultiFABRIK_EndEffector = {}



---@class FRigUnit_MultiFABRIK_WorkData
local FRigUnit_MultiFABRIK_WorkData = {}


---@class FRigUnit_MultiplyQuaternion : FRigUnit_BinaryQuaternionOp
local FRigUnit_MultiplyQuaternion = {}


---@class FRigUnit_MultiplyTransform : FRigUnit_BinaryTransformOp
local FRigUnit_MultiplyTransform = {}


---@class FRigUnit_Multiply_FloatFloat : FRigUnit_BinaryFloatOp
local FRigUnit_Multiply_FloatFloat = {}


---@class FRigUnit_Multiply_VectorVector : FRigUnit_BinaryVectorOp
local FRigUnit_Multiply_VectorVector = {}


---@class FRigUnit_OffsetTransformForItem : FRigUnitMutable
---@field Item FRigElementKey
---@field OffsetTransform FTransform
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_OffsetTransformForItem = {}



---@class FRigUnit_ParentConstraint : FRigUnit_HighlevelBaseMutable
---@field Child FRigElementKey
---@field bMaintainOffset boolean
---@field Filter FTransformFilter
---@field Parents TArray<FConstraintParent>
---@field AdvancedSettings FRigUnit_ParentConstraint_AdvancedSettings
---@field Weight float
---@field ChildCache FCachedRigElement
---@field ParentCaches TArray<FCachedRigElement>
local FRigUnit_ParentConstraint = {}



---@class FRigUnit_ParentConstraintMath : FRigUnit_HighlevelBase
---@field Input FTransform
---@field Parents TArray<FConstraintParent>
---@field AdvancedSettings FRigUnit_ParentConstraintMath_AdvancedSettings
---@field Output FTransform
---@field ParentCaches TArray<FCachedRigElement>
local FRigUnit_ParentConstraintMath = {}



---@class FRigUnit_ParentConstraintMath_AdvancedSettings
---@field InterpolationType EConstraintInterpType
local FRigUnit_ParentConstraintMath_AdvancedSettings = {}



---@class FRigUnit_ParentConstraint_AdvancedSettings
---@field InterpolationType EConstraintInterpType
---@field RotationOrderForFilter EEulerRotationOrder
local FRigUnit_ParentConstraint_AdvancedSettings = {}



---@class FRigUnit_ParentSwitchConstraint : FRigUnitMutable
---@field Subject FRigElementKey
---@field ParentIndex int32
---@field Parents FRigElementKeyCollection
---@field InitialGlobalTransform FTransform
---@field Weight float
---@field Transform FTransform
---@field Switched boolean
---@field CachedSubject FCachedRigElement
---@field CachedParent FCachedRigElement
---@field RelativeOffset FTransform
local FRigUnit_ParentSwitchConstraint = {}



---@class FRigUnit_ParentSwitchConstraintArray : FRigUnitMutable
---@field Subject FRigElementKey
---@field ParentIndex int32
---@field Parents TArray<FRigElementKey>
---@field InitialGlobalTransform FTransform
---@field Weight float
---@field Transform FTransform
---@field Switched boolean
---@field CachedSubject FCachedRigElement
---@field CachedParent FCachedRigElement
---@field RelativeOffset FTransform
local FRigUnit_ParentSwitchConstraintArray = {}



---@class FRigUnit_PointSimulation : FRigVMFunction_SimBaseMutable
---@field Points TArray<FRigVMSimPoint>
---@field Links TArray<FCRSimLinearSpring>
---@field Forces TArray<FCRSimPointForce>
---@field CollisionVolumes TArray<FCRSimSoftCollision>
---@field SimulatedStepsPerSecond float
---@field IntegratorType ERigVMSimPointIntegrateType
---@field VerletBlend float
---@field BoneTargets TArray<FRigUnit_PointSimulation_BoneTarget>
---@field bLimitLocalPosition boolean
---@field bPropagateToChildren boolean
---@field PrimaryAimAxis FVector
---@field SecondaryAimAxis FVector
---@field DebugSettings FRigUnit_PointSimulation_DebugSettings
---@field Bezier FRigVMFourPointBezier
---@field WorkData FRigUnit_PointSimulation_WorkData
local FRigUnit_PointSimulation = {}



---@class FRigUnit_PointSimulation_BoneTarget
---@field bone FName
---@field TranslationPoint int32
---@field PrimaryAimPoint int32
---@field SecondaryAimPoint int32
local FRigUnit_PointSimulation_BoneTarget = {}



---@class FRigUnit_PointSimulation_DebugSettings
---@field bEnabled boolean
---@field Scale float
---@field CollisionScale float
---@field bDrawPointsAsSpheres boolean
---@field Color FLinearColor
---@field WorldOffset FTransform
local FRigUnit_PointSimulation_DebugSettings = {}



---@class FRigUnit_PointSimulation_WorkData
---@field Simulation FCRSimPointContainer
---@field BoneIndices TArray<FCachedRigElement>
local FRigUnit_PointSimulation_WorkData = {}



---@class FRigUnit_PoseGetCurve : FRigUnit_HierarchyBase
---@field Pose FRigPose
---@field Curve FName
---@field Valid boolean
---@field CurveValue float
---@field CachedPoseElementIndex int32
---@field CachedPoseHash int32
local FRigUnit_PoseGetCurve = {}



---@class FRigUnit_PoseGetDelta : FRigUnit_HierarchyBase
---@field PoseA FRigPose
---@field PoseB FRigPose
---@field PositionThreshold float
---@field RotationThreshold float
---@field ScaleThreshold float
---@field CurveThreshold float
---@field ElementType ERigElementType
---@field Space ERigVMTransformSpace
---@field ItemsToCompare FRigElementKeyCollection
---@field PosesAreEqual boolean
---@field ItemsWithDelta FRigElementKeyCollection
local FRigUnit_PoseGetDelta = {}



---@class FRigUnit_PoseGetItems : FRigUnit_HierarchyBase
---@field Pose FRigPose
---@field ElementType ERigElementType
---@field Items FRigElementKeyCollection
local FRigUnit_PoseGetItems = {}



---@class FRigUnit_PoseGetItemsItemArray : FRigUnit_HierarchyBase
---@field Pose FRigPose
---@field ElementType ERigElementType
---@field Items TArray<FRigElementKey>
local FRigUnit_PoseGetItemsItemArray = {}



---@class FRigUnit_PoseGetTransform : FRigUnit_HierarchyBase
---@field Pose FRigPose
---@field Item FRigElementKey
---@field Space ERigVMTransformSpace
---@field Valid boolean
---@field Transform FTransform
---@field CurveValue float
---@field CachedPoseElementIndex int32
---@field CachedPoseHash int32
local FRigUnit_PoseGetTransform = {}



---@class FRigUnit_PoseGetTransformArray : FRigUnit_HierarchyBase
---@field Pose FRigPose
---@field Space ERigVMTransformSpace
---@field Valid boolean
---@field Transforms TArray<FTransform>
local FRigUnit_PoseGetTransformArray = {}



---@class FRigUnit_PoseIsEmpty : FRigUnit_HierarchyBase
---@field Pose FRigPose
---@field IsEmpty boolean
local FRigUnit_PoseIsEmpty = {}



---@class FRigUnit_PoseLoop : FRigUnit_HierarchyBaseMutable
---@field BlockToRun FName
---@field Pose FRigPose
---@field Item FRigElementKey
---@field GlobalTransform FTransform
---@field LocalTransform FTransform
---@field CurveValue float
---@field Index int32
---@field Count int32
---@field Ratio float
---@field Completed FControlRigExecuteContext
local FRigUnit_PoseLoop = {}



---@class FRigUnit_PositionConstraint : FRigUnit_HighlevelBaseMutable
---@field Child FRigElementKey
---@field bMaintainOffset boolean
---@field Filter FFilterOptionPerAxis
---@field Parents TArray<FConstraintParent>
---@field Weight float
local FRigUnit_PositionConstraint = {}



---@class FRigUnit_PositionConstraintLocalSpaceOffset : FRigUnit_HighlevelBaseMutable
---@field Child FRigElementKey
---@field bMaintainOffset boolean
---@field Filter FFilterOptionPerAxis
---@field Parents TArray<FConstraintParent>
---@field Weight float
---@field ChildCache FCachedRigElement
---@field ParentCaches TArray<FCachedRigElement>
local FRigUnit_PositionConstraintLocalSpaceOffset = {}



---@class FRigUnit_PostBeginExecution : FRigUnit
---@field ExecuteContext FControlRigExecuteContext
local FRigUnit_PostBeginExecution = {}



---@class FRigUnit_PostPrepareForExecution : FRigUnit
---@field ExecuteContext FControlRigExecuteContext
local FRigUnit_PostPrepareForExecution = {}



---@class FRigUnit_PreBeginExecution : FRigUnit
---@field ExecuteContext FControlRigExecuteContext
local FRigUnit_PreBeginExecution = {}



---@class FRigUnit_PrepareForExecution : FRigUnit
---@field ExecuteContext FControlRigExecuteContext
local FRigUnit_PrepareForExecution = {}



---@class FRigUnit_ProjectTransformToNewParent : FRigUnit
---@field Child FRigElementKey
---@field bChildInitial boolean
---@field OldParent FRigElementKey
---@field bOldParentInitial boolean
---@field NewParent FRigElementKey
---@field bNewParentInitial boolean
---@field Transform FTransform
---@field CachedChild FCachedRigElement
---@field CachedOldParent FCachedRigElement
---@field CachedNewParent FCachedRigElement
local FRigUnit_ProjectTransformToNewParent = {}



---@class FRigUnit_PropagateTransform : FRigUnitMutable
---@field Item FRigElementKey
---@field bRecomputeGlobal boolean
---@field bApplyToChildren boolean
---@field bRecursive boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_PropagateTransform = {}



---@class FRigUnit_QuaternionFromAxisAndAngle : FRigUnit
---@field Axis FVector
---@field Angle float
---@field Result FQuat
local FRigUnit_QuaternionFromAxisAndAngle = {}



---@class FRigUnit_QuaternionToAngle : FRigUnit
---@field Axis FVector
---@field Argument FQuat
---@field Angle float
local FRigUnit_QuaternionToAngle = {}



---@class FRigUnit_QuaternionToAxisAndAngle : FRigUnit
---@field Argument FQuat
---@field Axis FVector
---@field Angle float
local FRigUnit_QuaternionToAxisAndAngle = {}



---@class FRigUnit_RemoveAllMetadata : FRigUnitMutable
---@field Item FRigElementKey
---@field NameSpace ERigMetaDataNameSpace
---@field Removed boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_RemoveAllMetadata = {}



---@class FRigUnit_RemoveMetadata : FRigUnitMutable
---@field Item FRigElementKey
---@field Name FName
---@field NameSpace ERigMetaDataNameSpace
---@field Removed boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_RemoveMetadata = {}



---@class FRigUnit_RemoveMetadataTag : FRigUnitMutable
---@field Item FRigElementKey
---@field Tag FName
---@field NameSpace ERigMetaDataNameSpace
---@field Removed boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_RemoveMetadataTag = {}



---@class FRigUnit_ResolveConnector : FRigUnit_RigModulesBase
---@field Connector FRigElementKey
---@field SkipSocket boolean
---@field Result FRigElementKey
---@field bIsConnected boolean
local FRigUnit_ResolveConnector = {}



---@class FRigUnit_RigModulesBase : FRigUnit
local FRigUnit_RigModulesBase = {}


---@class FRigUnit_RigModulesBaseMutable : FRigUnitMutable
local FRigUnit_RigModulesBaseMutable = {}


---@class FRigUnit_RotationConstraint : FRigUnit_HighlevelBaseMutable
---@field Child FRigElementKey
---@field bMaintainOffset boolean
---@field Filter FFilterOptionPerAxis
---@field Parents TArray<FConstraintParent>
---@field AdvancedSettings FRigUnit_RotationConstraint_AdvancedSettings
---@field Weight float
local FRigUnit_RotationConstraint = {}



---@class FRigUnit_RotationConstraintLocalSpaceOffset : FRigUnit_HighlevelBaseMutable
---@field Child FRigElementKey
---@field bMaintainOffset boolean
---@field Filter FFilterOptionPerAxis
---@field Parents TArray<FConstraintParent>
---@field AdvancedSettings FRigUnit_RotationConstraint_AdvancedSettings
---@field Weight float
---@field ChildCache FCachedRigElement
---@field ParentCaches TArray<FCachedRigElement>
local FRigUnit_RotationConstraintLocalSpaceOffset = {}



---@class FRigUnit_RotationConstraint_AdvancedSettings
---@field InterpolationType EConstraintInterpType
---@field RotationOrderForFilter EEulerRotationOrder
local FRigUnit_RotationConstraint_AdvancedSettings = {}



---@class FRigUnit_ScaleConstraint : FRigUnit_HighlevelBaseMutable
---@field Child FRigElementKey
---@field bMaintainOffset boolean
---@field Filter FFilterOptionPerAxis
---@field Parents TArray<FConstraintParent>
---@field Weight float
local FRigUnit_ScaleConstraint = {}



---@class FRigUnit_ScaleConstraintLocalSpaceOffset : FRigUnit_HighlevelBaseMutable
---@field Child FRigElementKey
---@field bMaintainOffset boolean
---@field Filter FFilterOptionPerAxis
---@field Parents TArray<FConstraintParent>
---@field Weight float
---@field ChildCache FCachedRigElement
---@field ParentCaches TArray<FCachedRigElement>
local FRigUnit_ScaleConstraintLocalSpaceOffset = {}



---@class FRigUnit_SendEvent : FRigUnitMutable
---@field Event ERigEvent
---@field Item FRigElementKey
---@field OffsetInSeconds float
---@field bEnable boolean
---@field bOnlyDuringInteraction boolean
local FRigUnit_SendEvent = {}



---@class FRigUnit_SequenceExecution : FRigUnit
---@field ExecuteContext FControlRigExecuteContext
---@field A FControlRigExecuteContext
---@field B FControlRigExecuteContext
---@field C FControlRigExecuteContext
---@field D FControlRigExecuteContext
local FRigUnit_SequenceExecution = {}



---@class FRigUnit_SetAnimationChannelBase : FRigUnit_GetAnimationChannelBase
---@field ExecuteContext FControlRigExecuteContext
local FRigUnit_SetAnimationChannelBase = {}



---@class FRigUnit_SetAnimationChannelBaseFromItem : FRigUnit_GetAnimationChannelFromItemBase
---@field ExecuteContext FControlRigExecuteContext
local FRigUnit_SetAnimationChannelBaseFromItem = {}



---@class FRigUnit_SetBoneInitialTransform : FRigUnitMutable
---@field bone FName
---@field Transform FTransform
---@field Result FTransform
---@field Space ERigVMTransformSpace
---@field bPropagateToChildren boolean
---@field CachedBone FCachedRigElement
local FRigUnit_SetBoneInitialTransform = {}



---@class FRigUnit_SetBoneRotation : FRigUnitMutable
---@field bone FName
---@field Rotation FQuat
---@field Space ERigVMTransformSpace
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedBone FCachedRigElement
local FRigUnit_SetBoneRotation = {}



---@class FRigUnit_SetBoneTransform : FRigUnitMutable
---@field bone FName
---@field Transform FTransform
---@field Result FTransform
---@field Space ERigVMTransformSpace
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedBone FCachedRigElement
local FRigUnit_SetBoneTransform = {}



---@class FRigUnit_SetBoneTranslation : FRigUnitMutable
---@field bone FName
---@field Translation FVector
---@field Space ERigVMTransformSpace
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedBone FCachedRigElement
local FRigUnit_SetBoneTranslation = {}



---@class FRigUnit_SetBoolAnimationChannel : FRigUnit_SetAnimationChannelBase
---@field Value boolean
local FRigUnit_SetBoolAnimationChannel = {}



---@class FRigUnit_SetBoolAnimationChannelFromItem : FRigUnit_SetAnimationChannelBaseFromItem
---@field Value boolean
local FRigUnit_SetBoolAnimationChannelFromItem = {}



---@class FRigUnit_SetChannelHosts : FRigUnit_DynamicHierarchyBaseMutable
---@field Channel FRigElementKey
---@field Hosts TArray<FRigElementKey>
local FRigUnit_SetChannelHosts = {}



---@class FRigUnit_SetControlBool : FRigUnitMutable
---@field Control FName
---@field BoolValue boolean
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetControlBool = {}



---@class FRigUnit_SetControlColor : FRigUnitMutable
---@field Control FName
---@field Color FLinearColor
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetControlColor = {}



---@class FRigUnit_SetControlDrivenList : FRigUnitMutable
---@field Control FName
---@field Driven TArray<FRigElementKey>
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetControlDrivenList = {}



---@class FRigUnit_SetControlFloat : FRigUnitMutable
---@field Control FName
---@field Weight float
---@field FloatValue float
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetControlFloat = {}



---@class FRigUnit_SetControlInteger : FRigUnitMutable
---@field Control FName
---@field Weight int32
---@field IntegerValue int32
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetControlInteger = {}



---@class FRigUnit_SetControlOffset : FRigUnitMutable
---@field Control FName
---@field Offset FTransform
---@field Space ERigVMTransformSpace
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetControlOffset = {}



---@class FRigUnit_SetControlRotator : FRigUnitMutable
---@field Control FName
---@field Weight float
---@field Rotator FRotator
---@field Space ERigVMTransformSpace
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetControlRotator = {}



---@class FRigUnit_SetControlTransform : FRigUnitMutable
---@field Control FName
---@field Weight float
---@field Transform FTransform
---@field Space ERigVMTransformSpace
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetControlTransform = {}



---@class FRigUnit_SetControlVector : FRigUnitMutable
---@field Control FName
---@field Weight float
---@field Vector FVector
---@field Space ERigVMTransformSpace
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetControlVector = {}



---@class FRigUnit_SetControlVector2D : FRigUnitMutable
---@field Control FName
---@field Weight float
---@field Vector FVector2D
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetControlVector2D = {}



---@class FRigUnit_SetControlVisibility : FRigUnitMutable
---@field Item FRigElementKey
---@field Pattern FString
---@field bVisible boolean
---@field CachedControlIndices TArray<FCachedRigElement>
local FRigUnit_SetControlVisibility = {}



---@class FRigUnit_SetCurveValue : FRigUnitMutable
---@field Curve FName
---@field Value float
---@field CachedCurveIndex FCachedRigElement
local FRigUnit_SetCurveValue = {}



---@class FRigUnit_SetDefaultMatch : FRigUnitMutable
---@field Default FRigElementKey
local FRigUnit_SetDefaultMatch = {}



---@class FRigUnit_SetDefaultParent : FRigUnit_DynamicHierarchyBaseMutable
---@field Child FRigElementKey
---@field Parent FRigElementKey
local FRigUnit_SetDefaultParent = {}



---@class FRigUnit_SetFloatAnimationChannel : FRigUnit_SetAnimationChannelBase
---@field Value float
local FRigUnit_SetFloatAnimationChannel = {}



---@class FRigUnit_SetFloatAnimationChannelFromItem : FRigUnit_SetAnimationChannelBaseFromItem
---@field Value float
local FRigUnit_SetFloatAnimationChannelFromItem = {}



---@class FRigUnit_SetIntAnimationChannel : FRigUnit_SetAnimationChannelBase
---@field Value int32
local FRigUnit_SetIntAnimationChannel = {}



---@class FRigUnit_SetIntAnimationChannelFromItem : FRigUnit_SetAnimationChannelBaseFromItem
---@field Value int32
local FRigUnit_SetIntAnimationChannelFromItem = {}



---@class FRigUnit_SetMetadataTag : FRigUnitMutable
---@field Item FRigElementKey
---@field Tag FName
---@field NameSpace ERigMetaDataNameSpace
---@field CachedIndex FCachedRigElement
local FRigUnit_SetMetadataTag = {}



---@class FRigUnit_SetMetadataTagArray : FRigUnitMutable
---@field Item FRigElementKey
---@field Tags TArray<FName>
---@field NameSpace ERigMetaDataNameSpace
---@field CachedIndex FCachedRigElement
local FRigUnit_SetMetadataTagArray = {}



---@class FRigUnit_SetMultiControlBool : FRigUnitMutable
---@field Entries TArray<FRigUnit_SetMultiControlBool_Entry>
---@field CachedControlIndices TArray<FCachedRigElement>
local FRigUnit_SetMultiControlBool = {}



---@class FRigUnit_SetMultiControlBool_Entry
---@field Control FName
---@field BoolValue boolean
local FRigUnit_SetMultiControlBool_Entry = {}



---@class FRigUnit_SetMultiControlFloat : FRigUnitMutable
---@field Entries TArray<FRigUnit_SetMultiControlFloat_Entry>
---@field Weight float
---@field CachedControlIndices TArray<FCachedRigElement>
local FRigUnit_SetMultiControlFloat = {}



---@class FRigUnit_SetMultiControlFloat_Entry
---@field Control FName
---@field FloatValue float
local FRigUnit_SetMultiControlFloat_Entry = {}



---@class FRigUnit_SetMultiControlInteger : FRigUnitMutable
---@field Entries TArray<FRigUnit_SetMultiControlInteger_Entry>
---@field Weight float
---@field CachedControlIndices TArray<FCachedRigElement>
local FRigUnit_SetMultiControlInteger = {}



---@class FRigUnit_SetMultiControlInteger_Entry
---@field Control FName
---@field IntegerValue int32
local FRigUnit_SetMultiControlInteger_Entry = {}



---@class FRigUnit_SetMultiControlRotator : FRigUnitMutable
---@field Entries TArray<FRigUnit_SetMultiControlRotator_Entry>
---@field Weight float
---@field CachedControlIndices TArray<FCachedRigElement>
local FRigUnit_SetMultiControlRotator = {}



---@class FRigUnit_SetMultiControlRotator_Entry
---@field Control FName
---@field Rotator FRotator
---@field Space ERigVMTransformSpace
local FRigUnit_SetMultiControlRotator_Entry = {}



---@class FRigUnit_SetMultiControlVector2D : FRigUnitMutable
---@field Entries TArray<FRigUnit_SetMultiControlVector2D_Entry>
---@field Weight float
---@field CachedControlIndices TArray<FCachedRigElement>
local FRigUnit_SetMultiControlVector2D = {}



---@class FRigUnit_SetMultiControlVector2D_Entry
---@field Control FName
---@field Vector FVector2D
local FRigUnit_SetMultiControlVector2D_Entry = {}



---@class FRigUnit_SetRelativeBoneTransform : FRigUnitMutable
---@field bone FName
---@field Space FName
---@field Transform FTransform
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedBone FCachedRigElement
---@field CachedSpaceIndex FCachedRigElement
local FRigUnit_SetRelativeBoneTransform = {}



---@class FRigUnit_SetRelativeRotationForItem : FRigUnitMutable
---@field Child FRigElementKey
---@field Parent FRigElementKey
---@field bParentInitial boolean
---@field Value FQuat
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedChild FCachedRigElement
---@field CachedParent FCachedRigElement
local FRigUnit_SetRelativeRotationForItem = {}



---@class FRigUnit_SetRelativeTransformForItem : FRigUnitMutable
---@field Child FRigElementKey
---@field Parent FRigElementKey
---@field bParentInitial boolean
---@field Value FTransform
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedChild FCachedRigElement
---@field CachedParent FCachedRigElement
local FRigUnit_SetRelativeTransformForItem = {}



---@class FRigUnit_SetRelativeTranslationForItem : FRigUnitMutable
---@field Child FRigElementKey
---@field Parent FRigElementKey
---@field bParentInitial boolean
---@field Value FVector
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedChild FCachedRigElement
---@field CachedParent FCachedRigElement
local FRigUnit_SetRelativeTranslationForItem = {}



---@class FRigUnit_SetRotation : FRigUnitMutable
---@field Item FRigElementKey
---@field Space ERigVMTransformSpace
---@field bInitial boolean
---@field Value FQuat
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_SetRotation = {}



---@class FRigUnit_SetRotatorAnimationChannel : FRigUnit_SetAnimationChannelBase
---@field Value FRotator
local FRigUnit_SetRotatorAnimationChannel = {}



---@class FRigUnit_SetRotatorAnimationChannelFromItem : FRigUnit_SetAnimationChannelBaseFromItem
---@field Value FRotator
local FRigUnit_SetRotatorAnimationChannelFromItem = {}



---@class FRigUnit_SetScale : FRigUnitMutable
---@field Item FRigElementKey
---@field Space ERigVMTransformSpace
---@field bInitial boolean
---@field Scale FVector
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_SetScale = {}



---@class FRigUnit_SetShapeTransform : FRigUnitMutable
---@field Control FName
---@field Transform FTransform
---@field CachedControlIndex FCachedRigElement
local FRigUnit_SetShapeTransform = {}



---@class FRigUnit_SetSpaceInitialTransform : FRigUnitMutable
---@field SpaceName FName
---@field Transform FTransform
---@field Result FTransform
---@field Space ERigVMTransformSpace
---@field CachedSpaceIndex FCachedRigElement
local FRigUnit_SetSpaceInitialTransform = {}



---@class FRigUnit_SetSpaceTransform : FRigUnitMutable
---@field Space FName
---@field Weight float
---@field Transform FTransform
---@field SpaceType ERigVMTransformSpace
---@field CachedSpaceIndex FCachedRigElement
local FRigUnit_SetSpaceTransform = {}



---@class FRigUnit_SetTransform : FRigUnitMutable
---@field Item FRigElementKey
---@field Space ERigVMTransformSpace
---@field bInitial boolean
---@field Value FTransform
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_SetTransform = {}



---@class FRigUnit_SetTransformAnimationChannel : FRigUnit_SetAnimationChannelBase
---@field Value FTransform
local FRigUnit_SetTransformAnimationChannel = {}



---@class FRigUnit_SetTransformAnimationChannelFromItem : FRigUnit_SetAnimationChannelBaseFromItem
---@field Value FTransform
local FRigUnit_SetTransformAnimationChannelFromItem = {}



---@class FRigUnit_SetTransformArray : FRigUnitMutable
---@field Items FRigElementKeyCollection
---@field Space ERigVMTransformSpace
---@field bInitial boolean
---@field Transforms TArray<FTransform>
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedIndex TArray<FCachedRigElement>
local FRigUnit_SetTransformArray = {}



---@class FRigUnit_SetTransformItemArray : FRigUnitMutable
---@field Items TArray<FRigElementKey>
---@field Space ERigVMTransformSpace
---@field bInitial boolean
---@field Transforms TArray<FTransform>
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedIndex TArray<FCachedRigElement>
local FRigUnit_SetTransformItemArray = {}



---@class FRigUnit_SetTranslation : FRigUnitMutable
---@field Item FRigElementKey
---@field Space ERigVMTransformSpace
---@field bInitial boolean
---@field Value FVector
---@field Weight float
---@field bPropagateToChildren boolean
---@field CachedIndex FCachedRigElement
local FRigUnit_SetTranslation = {}



---@class FRigUnit_SetVector2DAnimationChannel : FRigUnit_SetAnimationChannelBase
---@field Value FVector2D
local FRigUnit_SetVector2DAnimationChannel = {}



---@class FRigUnit_SetVector2DAnimationChannelFromItem : FRigUnit_SetAnimationChannelBaseFromItem
---@field Value FVector2D
local FRigUnit_SetVector2DAnimationChannelFromItem = {}



---@class FRigUnit_SetVectorAnimationChannel : FRigUnit_SetAnimationChannelBase
---@field Value FVector
local FRigUnit_SetVectorAnimationChannel = {}



---@class FRigUnit_SetVectorAnimationChannelFromItem : FRigUnit_SetAnimationChannelBaseFromItem
---@field Value FVector
local FRigUnit_SetVectorAnimationChannelFromItem = {}



---@class FRigUnit_SetupShapeLibraryFromUserData : FRigUnitMutable
---@field NameSpace FString
---@field Path FString
---@field LibraryName FString
---@field LogShapeLibraries boolean
local FRigUnit_SetupShapeLibraryFromUserData = {}



---@class FRigUnit_ShapeExists : FRigUnit
---@field ShapeName FName
---@field Result boolean
local FRigUnit_ShapeExists = {}



---@class FRigUnit_SlideChain : FRigUnit_HighlevelBaseMutable
---@field StartBone FName
---@field EndBone FName
---@field SlideAmount float
---@field bPropagateToChildren boolean
---@field WorkData FRigUnit_SlideChain_WorkData
local FRigUnit_SlideChain = {}



---@class FRigUnit_SlideChainItemArray : FRigUnit_HighlevelBaseMutable
---@field Items TArray<FRigElementKey>
---@field SlideAmount float
---@field bPropagateToChildren boolean
---@field WorkData FRigUnit_SlideChain_WorkData
local FRigUnit_SlideChainItemArray = {}



---@class FRigUnit_SlideChainPerItem : FRigUnit_HighlevelBaseMutable
---@field Items FRigElementKeyCollection
---@field SlideAmount float
---@field bPropagateToChildren boolean
---@field WorkData FRigUnit_SlideChain_WorkData
local FRigUnit_SlideChainPerItem = {}



---@class FRigUnit_SlideChain_WorkData
---@field ChainLength float
---@field ItemSegments TArray<float>
---@field CachedItems TArray<FCachedRigElement>
---@field Transforms TArray<FTransform>
---@field BlendedTransforms TArray<FTransform>
local FRigUnit_SlideChain_WorkData = {}



---@class FRigUnit_SpaceName : FRigUnit
---@field Space FName
local FRigUnit_SpaceName = {}



---@class FRigUnit_SphereTraceByObjectTypes : FRigUnit
---@field Start FVector
---@field End FVector
---@field ObjectTypes TArray<EObjectTypeQuery>
---@field Radius float
---@field bHit boolean
---@field HitLocation FVector
---@field HitNormal FVector
---@field WorkData FRigUnit_SphereTrace_WorkData
local FRigUnit_SphereTraceByObjectTypes = {}



---@class FRigUnit_SphereTraceByTraceChannel : FRigUnit
---@field Start FVector
---@field End FVector
---@field TraceChannel ETraceTypeQuery
---@field Radius float
---@field bHit boolean
---@field HitLocation FVector
---@field HitNormal FVector
---@field WorkData FRigUnit_SphereTrace_WorkData
local FRigUnit_SphereTraceByTraceChannel = {}



---@class FRigUnit_SphereTraceWorld : FRigUnit
---@field Start FVector
---@field End FVector
---@field Channel ECollisionChannel
---@field Radius float
---@field bHit boolean
---@field HitLocation FVector
---@field HitNormal FVector
---@field WorkData FRigUnit_SphereTrace_WorkData
local FRigUnit_SphereTraceWorld = {}



---@class FRigUnit_SphereTrace_WorkData
---@field Hash uint32
---@field bHit boolean
---@field HitLocation FVector
---@field HitNormal FVector
local FRigUnit_SphereTrace_WorkData = {}



---@class FRigUnit_SphericalPoseReader : FRigUnit_HighlevelBaseMutable
---@field OutputParam float
---@field DriverItem FRigElementKey
---@field DriverAxis FVector
---@field RotationOffset FVector
---@field ActiveRegionSize float
---@field ActiveRegionScaleFactors FRegionScaleFactors
---@field FalloffSize float
---@field FalloffRegionScaleFactors FRegionScaleFactors
---@field FlipWidthScaling boolean
---@field FlipHeightScaling boolean
---@field OptionalParentItem FRigElementKey
---@field Debug FSphericalPoseReaderDebugSettings
---@field InnerRegion FSphericalRegion
---@field OuterRegion FSphericalRegion
---@field DriverNormal FVector
---@field Driver2D FVector
---@field DriverCache FCachedRigElement
---@field OptionalParentCache FCachedRigElement
---@field LocalDriverTransformInit FTransform
---@field CachedRotationOffset FVector
---@field bCachedInitTransforms boolean
local FRigUnit_SphericalPoseReader = {}



---@class FRigUnit_SpringIK : FRigUnit_HighlevelBaseMutable
---@field StartBone FName
---@field EndBone FName
---@field HierarchyStrength float
---@field EffectorStrength float
---@field EffectorRatio float
---@field RootStrength float
---@field RootRatio float
---@field Damping float
---@field PoleVector FVector
---@field bFlipPolePlane boolean
---@field PoleVectorKind EControlRigVectorKind
---@field PoleVectorSpace FName
---@field PrimaryAxis FVector
---@field SecondaryAxis FVector
---@field bLiveSimulation boolean
---@field Iterations int32
---@field bLimitLocalPosition boolean
---@field bPropagateToChildren boolean
---@field DebugSettings FRigUnit_SpringIK_DebugSettings
---@field WorkData FRigUnit_SpringIK_WorkData
local FRigUnit_SpringIK = {}



---@class FRigUnit_SpringIK_DebugSettings
---@field bEnabled boolean
---@field Scale float
---@field Color FLinearColor
---@field WorldOffset FTransform
local FRigUnit_SpringIK_DebugSettings = {}



---@class FRigUnit_SpringIK_WorkData
---@field CachedBones TArray<FCachedRigElement>
---@field CachedPoleVector FCachedRigElement
---@field Transforms TArray<FTransform>
---@field Simulation FCRSimPointContainer
local FRigUnit_SpringIK_WorkData = {}



---@class FRigUnit_SpringInterp : FRigVMFunction_SimBase
---@field Current float
---@field Target float
---@field Stiffness float
---@field CriticalDamping float
---@field Mass float
---@field Result float
---@field SpringState FFloatSpringState
local FRigUnit_SpringInterp = {}



---@class FRigUnit_SpringInterpQuaternionV2 : FRigVMFunction_SimBase
---@field Target FQuat
---@field Strength float
---@field CriticalDamping float
---@field Torque FVector
---@field bUseCurrentInput boolean
---@field Current FQuat
---@field TargetVelocityAmount float
---@field bInitializeFromTarget boolean
---@field Result FQuat
---@field AngularVelocity FVector
---@field SimulatedResult FQuat
---@field SpringState FQuaternionSpringState
local FRigUnit_SpringInterpQuaternionV2 = {}



---@class FRigUnit_SpringInterpV2 : FRigVMFunction_SimBase
---@field Target float
---@field Strength float
---@field CriticalDamping float
---@field Force float
---@field bUseCurrentInput boolean
---@field Current float
---@field TargetVelocityAmount float
---@field bInitializeFromTarget boolean
---@field Result float
---@field Velocity float
---@field SimulatedResult float
---@field SpringState FFloatSpringState
local FRigUnit_SpringInterpV2 = {}



---@class FRigUnit_SpringInterpVector : FRigVMFunction_SimBase
---@field Current FVector
---@field Target FVector
---@field Stiffness float
---@field CriticalDamping float
---@field Mass float
---@field Result FVector
---@field SpringState FVectorSpringState
local FRigUnit_SpringInterpVector = {}



---@class FRigUnit_SpringInterpVectorV2 : FRigVMFunction_SimBase
---@field Target FVector
---@field Strength float
---@field CriticalDamping float
---@field Force FVector
---@field bUseCurrentInput boolean
---@field Current FVector
---@field TargetVelocityAmount float
---@field bInitializeFromTarget boolean
---@field Result FVector
---@field Velocity FVector
---@field SimulatedResult FVector
---@field SpringState FVectorSpringState
local FRigUnit_SpringInterpVectorV2 = {}



---@class FRigUnit_StartProfilingTimer : FRigVMFunction_DebugBaseMutable
local FRigUnit_StartProfilingTimer = {}


---@class FRigUnit_Subtract_FloatFloat : FRigUnit_BinaryFloatOp
local FRigUnit_Subtract_FloatFloat = {}


---@class FRigUnit_Subtract_VectorVector : FRigUnit_BinaryVectorOp
local FRigUnit_Subtract_VectorVector = {}


---@class FRigUnit_SwitchParent : FRigUnit_DynamicHierarchyBaseMutable
---@field Mode ERigSwitchParentMode
---@field Child FRigElementKey
---@field Parent FRigElementKey
---@field bMaintainGlobal boolean
local FRigUnit_SwitchParent = {}



---@class FRigUnit_ToRigSpace_Location : FRigUnit
---@field Value FVector
---@field Global FVector
local FRigUnit_ToRigSpace_Location = {}



---@class FRigUnit_ToRigSpace_Rotation : FRigUnit
---@field Value FQuat
---@field Global FQuat
local FRigUnit_ToRigSpace_Rotation = {}



---@class FRigUnit_ToRigSpace_Transform : FRigUnit
---@field Value FTransform
---@field Global FTransform
local FRigUnit_ToRigSpace_Transform = {}



---@class FRigUnit_ToSwingAndTwist : FRigUnit
---@field Input FQuat
---@field TwistAxis FVector
---@field Swing FQuat
---@field Twist FQuat
local FRigUnit_ToSwingAndTwist = {}



---@class FRigUnit_ToWorldSpace_Location : FRigUnit
---@field Value FVector
---@field World FVector
local FRigUnit_ToWorldSpace_Location = {}



---@class FRigUnit_ToWorldSpace_Rotation : FRigUnit
---@field Value FQuat
---@field World FQuat
local FRigUnit_ToWorldSpace_Rotation = {}



---@class FRigUnit_ToWorldSpace_Transform : FRigUnit
---@field Value FTransform
---@field World FTransform
local FRigUnit_ToWorldSpace_Transform = {}



---@class FRigUnit_TransformConstraint : FRigUnit_HighlevelBaseMutable
---@field bone FName
---@field BaseTransformSpace ETransformSpaceMode
---@field BaseTransform FTransform
---@field BaseBone FName
---@field Targets TArray<FConstraintTarget>
---@field bUseInitialTransforms boolean
---@field WorkData FRigUnit_TransformConstraint_WorkData
local FRigUnit_TransformConstraint = {}



---@class FRigUnit_TransformConstraintPerItem : FRigUnit_HighlevelBaseMutable
---@field Item FRigElementKey
---@field BaseTransformSpace ETransformSpaceMode
---@field BaseTransform FTransform
---@field BaseItem FRigElementKey
---@field Targets TArray<FConstraintTarget>
---@field bUseInitialTransforms boolean
---@field WorkData FRigUnit_TransformConstraint_WorkData
local FRigUnit_TransformConstraintPerItem = {}



---@class FRigUnit_TransformConstraint_WorkData
---@field ConstraintData TArray<FConstraintData>
---@field ConstraintDataToTargets TMap<int32, int32>
local FRigUnit_TransformConstraint_WorkData = {}



---@class FRigUnit_TwistBones : FRigUnit_HighlevelBaseMutable
---@field StartBone FName
---@field EndBone FName
---@field TwistAxis FVector
---@field PoleAxis FVector
---@field TwistEaseType ERigVMAnimEasingType
---@field Weight float
---@field bPropagateToChildren boolean
---@field WorkData FRigUnit_TwistBones_WorkData
local FRigUnit_TwistBones = {}



---@class FRigUnit_TwistBonesPerItem : FRigUnit_HighlevelBaseMutable
---@field Items FRigElementKeyCollection
---@field TwistAxis FVector
---@field PoleAxis FVector
---@field TwistEaseType ERigVMAnimEasingType
---@field Weight float
---@field bPropagateToChildren boolean
---@field WorkData FRigUnit_TwistBones_WorkData
local FRigUnit_TwistBonesPerItem = {}



---@class FRigUnit_TwistBones_WorkData
---@field CachedItems TArray<FCachedRigElement>
---@field ItemRatios TArray<float>
---@field ItemTransforms TArray<FTransform>
local FRigUnit_TwistBones_WorkData = {}



---@class FRigUnit_TwoBoneIKFK : FRigUnitMutable
---@field StartJoint FName
---@field EndJoint FName
---@field PoleTarget FVector
---@field Spin float
---@field EndEffector FTransform
---@field IKBlend float
---@field StartJointFKTransform FTransform
---@field MidJointFKTransform FTransform
---@field EndJointFKTransform FTransform
---@field PreviousFKIKBlend float
---@field StartJointIKTransform FTransform
---@field MidJointIKTransform FTransform
---@field EndJointIKTransform FTransform
---@field StartJointIndex int32
---@field MidJointIndex int32
---@field EndJointIndex int32
---@field UpperLimbLength float
---@field LowerLimbLength float
---@field bIsInitialized boolean
local FRigUnit_TwoBoneIKFK = {}



---@class FRigUnit_TwoBoneIKSimple : FRigUnit_HighlevelBaseMutable
---@field BoneA FName
---@field BoneB FName
---@field EffectorBone FName
---@field Effector FTransform
---@field PrimaryAxis FVector
---@field SecondaryAxis FVector
---@field SecondaryAxisWeight float
---@field PoleVector FVector
---@field PoleVectorKind EControlRigVectorKind
---@field PoleVectorSpace FName
---@field bEnableStretch boolean
---@field StretchStartRatio float
---@field StretchMaximumRatio float
---@field Weight float
---@field BoneALength float
---@field BoneBLength float
---@field bPropagateToChildren boolean
---@field DebugSettings FRigUnit_TwoBoneIKSimple_DebugSettings
---@field CachedBoneAIndex FCachedRigElement
---@field CachedBoneBIndex FCachedRigElement
---@field CachedEffectorBoneIndex FCachedRigElement
---@field CachedPoleVectorSpaceIndex FCachedRigElement
local FRigUnit_TwoBoneIKSimple = {}



---@class FRigUnit_TwoBoneIKSimplePerItem : FRigUnit_HighlevelBaseMutable
---@field ItemA FRigElementKey
---@field ItemB FRigElementKey
---@field EffectorItem FRigElementKey
---@field Effector FTransform
---@field PrimaryAxis FVector
---@field SecondaryAxis FVector
---@field SecondaryAxisWeight float
---@field PoleVector FVector
---@field PoleVectorKind EControlRigVectorKind
---@field PoleVectorSpace FRigElementKey
---@field bEnableStretch boolean
---@field StretchStartRatio float
---@field StretchMaximumRatio float
---@field Weight float
---@field ItemALength float
---@field ItemBLength float
---@field bPropagateToChildren boolean
---@field DebugSettings FRigUnit_TwoBoneIKSimple_DebugSettings
---@field CachedItemAIndex FCachedRigElement
---@field CachedItemBIndex FCachedRigElement
---@field CachedEffectorItemIndex FCachedRigElement
---@field CachedPoleVectorSpaceIndex FCachedRigElement
local FRigUnit_TwoBoneIKSimplePerItem = {}



---@class FRigUnit_TwoBoneIKSimpleTransforms : FRigUnit_HighlevelBase
---@field Root FTransform
---@field PoleVector FVector
---@field Effector FTransform
---@field PrimaryAxis FVector
---@field SecondaryAxis FVector
---@field SecondaryAxisWeight float
---@field bEnableStretch boolean
---@field StretchStartRatio float
---@field StretchMaximumRatio float
---@field BoneALength float
---@field BoneBLength float
---@field Elbow FTransform
local FRigUnit_TwoBoneIKSimpleTransforms = {}



---@class FRigUnit_TwoBoneIKSimpleVectors : FRigUnit_HighlevelBase
---@field Root FVector
---@field PoleVector FVector
---@field Effector FVector
---@field bEnableStretch boolean
---@field StretchStartRatio float
---@field StretchMaximumRatio float
---@field BoneALength float
---@field BoneBLength float
---@field Elbow FVector
local FRigUnit_TwoBoneIKSimpleVectors = {}



---@class FRigUnit_TwoBoneIKSimple_DebugSettings
---@field bEnabled boolean
---@field Scale float
---@field WorldOffset FTransform
local FRigUnit_TwoBoneIKSimple_DebugSettings = {}



---@class FRigUnit_UnaryQuaternionOp : FRigUnit
---@field Argument FQuat
---@field Result FQuat
local FRigUnit_UnaryQuaternionOp = {}



---@class FRigUnit_UnsetCurveValue : FRigUnitMutable
---@field Curve FName
---@field CachedCurveIndex FCachedRigElement
local FRigUnit_UnsetCurveValue = {}



---@class FRigUnit_VisualDebugQuat : FRigUnit_DebugBase
---@field Value FQuat
---@field bEnabled boolean
---@field Thickness float
---@field Scale float
---@field BoneSpace FName
local FRigUnit_VisualDebugQuat = {}



---@class FRigUnit_VisualDebugQuatItemSpace : FRigUnit_DebugBase
---@field Value FQuat
---@field bEnabled boolean
---@field Thickness float
---@field Scale float
---@field Space FRigElementKey
local FRigUnit_VisualDebugQuatItemSpace = {}



---@class FRigUnit_VisualDebugTransform : FRigUnit_DebugBase
---@field Value FTransform
---@field bEnabled boolean
---@field Thickness float
---@field Scale float
---@field BoneSpace FName
local FRigUnit_VisualDebugTransform = {}



---@class FRigUnit_VisualDebugTransformItemSpace : FRigUnit_DebugBase
---@field Value FTransform
---@field bEnabled boolean
---@field Thickness float
---@field Scale float
---@field Space FRigElementKey
local FRigUnit_VisualDebugTransformItemSpace = {}



---@class FRigUnit_VisualDebugVector : FRigUnit_DebugBase
---@field Value FVector
---@field bEnabled boolean
---@field Mode ERigUnitVisualDebugPointMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
---@field BoneSpace FName
local FRigUnit_VisualDebugVector = {}



---@class FRigUnit_VisualDebugVectorItemSpace : FRigUnit_DebugBase
---@field Value FVector
---@field bEnabled boolean
---@field Mode ERigUnitVisualDebugPointMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
---@field Space FRigElementKey
local FRigUnit_VisualDebugVectorItemSpace = {}



---@class FRigVectorArrayMetadata : FRigBaseMetadata
---@field Value TArray<FVector>
local FRigVectorArrayMetadata = {}



---@class FRigVectorMetadata : FRigBaseMetadata
---@field Value FVector
local FRigVectorMetadata = {}



---@class FSpaceControlNameAndChannel
---@field ControlName FName
---@field SpaceCurve FMovieSceneControlRigSpaceChannel
local FSpaceControlNameAndChannel = {}



---@class FSphericalPoseReaderDebugSettings
---@field bDrawDebug boolean
---@field bDraw2D boolean
---@field bDrawLocalAxes boolean
---@field DebugScale float
---@field DebugSegments int32
---@field DebugThickness float
local FSphericalPoseReaderDebugSettings = {}



---@class FSphericalRegion
local FSphericalRegion = {}


---@class FStructReference
local FStructReference = {}


---@class IRigHierarchyProvider : IInterface
local IRigHierarchyProvider = {}


---@class UAdditiveControlRig : UControlRig
local UAdditiveControlRig = {}


---@class UAnimNodeControlRigLibrary : UBlueprintFunctionLibrary
local UAnimNodeControlRigLibrary = {}

---@param Node FControlRigReference
---@param ControlRigClass TSubclassOf<UControlRig>
---@return FControlRigReference
function UAnimNodeControlRigLibrary:SetControlRigClass(Node, ControlRigClass) end
---@param Node FAnimNodeReference
---@param ControlRig FControlRigReference
---@param Result boolean
function UAnimNodeControlRigLibrary:ConvertToControlRigPure(Node, ControlRig, Result) end
---@param Node FAnimNodeReference
---@param Result EAnimNodeReferenceConversionResult
---@return FControlRigReference
function UAnimNodeControlRigLibrary:ConvertToControlRig(Node, Result) end


---@class UControlRig : URigVMHost
---@field ExecutionType ERigExecutionType
---@field HierarchySettings FRigHierarchySettings
---@field ControlCustomizations TMap<FRigElementKey, FRigControlElementCustomization>
---@field DynamicHierarchy URigHierarchy
---@field ShapeLibraries TArray<TSoftObjectPtr<UControlRigShapeLibrary>>
---@field ShapeLibraryNameMap TMap<FString, FString>
---@field RigVMExtendedExecuteContext FRigVMExtendedExecuteContext
---@field DataSourceRegistry UAnimationDataSourceRegistry
---@field Influences FRigInfluenceMapPerEvent
---@field ExternalVariableDataAssetLinks TMap<FName, UDataAssetLink>
---@field OnControlSelected_BP FControlRigOnControlSelected_BP
---@field bIsAdditive boolean
---@field RigModuleSettings FRigModuleSettings
---@field RigModuleNameSpace FString
local UControlRig = {}

---@return boolean
function UControlRig:SupportsBackwardsSolve() end
---@param InInteractionRigClass TSubclassOf<UControlRig>
function UControlRig:SetInteractionRigClass(InInteractionRigClass) end
---@param InInteractionRig UControlRig
function UControlRig:SetInteractionRig(InInteractionRig) end
---@param InControlName FName
---@param bSelect boolean
function UControlRig:SelectControl(InControlName, bSelect) end
function UControlRig:RequestConstruction() end
---@param Rig UControlRig
---@param Control FRigControlElement
---@param bSelected boolean
function UControlRig:OnControlSelectedBP__DelegateSignature(Rig, Control, bSelected) end
---@param InControlName FName
---@return boolean
function UControlRig:IsControlSelected(InControlName) end
---@return TSubclassOf<UControlRig>
function UControlRig:GetInteractionRigClass() end
---@return UControlRig
function UControlRig:GetInteractionRig() end
---@return AActor
function UControlRig:GetHostingActor() end
---@return URigHierarchy
function UControlRig:GetHierarchy() end
---@param Outer UObject
---@param OptionalClass TSubclassOf<UControlRig>
---@return TArray<UControlRig>
function UControlRig:FindControlRigs(Outer, OptionalClass) end
---@return TArray<FName>
function UControlRig:CurrentControlSelection() end
---@param ControlName FName
---@return UTransformableControlHandle
function UControlRig:CreateTransformableControlHandle(ControlName) end
---@return boolean
function UControlRig:ClearControlSelection() end
---@param InName FName
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return FRigPhysicsSolverID
function UControlRig:AddPhysicsSolver(InName, bSetupUndo, bPrintPythonCommand) end


---@class UControlRigAnimInstance : UAnimInstance
local UControlRigAnimInstance = {}


---@class UControlRigBlueprintGeneratedClass : URigVMBlueprintGeneratedClass
local UControlRigBlueprintGeneratedClass = {}


---@class UControlRigComponent : UPrimitiveComponent
---@field ControlRigClass TSubclassOf<UControlRig>
---@field OnPreInitializeDelegate FControlRigComponentOnPreInitializeDelegate
---@field OnPostInitializeDelegate FControlRigComponentOnPostInitializeDelegate
---@field OnPreConstructionDelegate FControlRigComponentOnPreConstructionDelegate
---@field OnPostConstructionDelegate FControlRigComponentOnPostConstructionDelegate
---@field OnPreForwardsSolveDelegate FControlRigComponentOnPreForwardsSolveDelegate
---@field OnPostForwardsSolveDelegate FControlRigComponentOnPostForwardsSolveDelegate
---@field UserDefinedElements TArray<FControlRigComponentMappedElement>
---@field MappedElements TArray<FControlRigComponentMappedElement>
---@field bEnableLazyEvaluation boolean
---@field LazyEvaluationPositionThreshold float
---@field LazyEvaluationRotationThreshold float
---@field LazyEvaluationScaleThreshold float
---@field bResetTransformBeforeTick boolean
---@field bResetInitialsBeforeConstruction boolean
---@field bUpdateRigOnTick boolean
---@field bUpdateInEditor boolean
---@field bDrawBones boolean
---@field bShowDebugDrawing boolean
---@field ControlRig UControlRig
local UControlRigComponent = {}

---@param DeltaTime float
function UControlRigComponent:Update(DeltaTime) end
---@param InObjectToBind UObject
function UControlRigComponent:SetObjectBinding(InObjectToBind) end
---@param NewMappedElements TArray<FControlRigComponentMappedElement>
function UControlRigComponent:SetMappedElements(NewMappedElements) end
---@param SpaceName FName
---@param InitialTransform FTransform
---@param Space EControlRigComponentSpace
function UControlRigComponent:SetInitialSpaceTransform(SpaceName, InitialTransform, Space) end
---@param BoneName FName
---@param InitialTransform FTransform
---@param Space EControlRigComponentSpace
---@param bPropagateToChildren boolean
function UControlRigComponent:SetInitialBoneTransform(BoneName, InitialTransform, Space, bPropagateToChildren) end
---@param ControlName FName
---@param Value FVector2D
function UControlRigComponent:SetControlVector2D(ControlName, Value) end
---@param ControlName FName
---@param Value FTransform
---@param Space EControlRigComponentSpace
function UControlRigComponent:SetControlTransform(ControlName, Value, Space) end
---@param ControlName FName
---@param Value FVector
---@param Space EControlRigComponentSpace
function UControlRigComponent:SetControlScale(ControlName, Value, Space) end
---@param ControlName FName
---@param Value FRotator
---@param Space EControlRigComponentSpace
function UControlRigComponent:SetControlRotator(ControlName, Value, Space) end
---@param InControlRigClass TSubclassOf<UControlRig>
function UControlRigComponent:SetControlRigClass(InControlRigClass) end
---@param ControlName FName
---@param Value FVector
---@param Space EControlRigComponentSpace
function UControlRigComponent:SetControlPosition(ControlName, Value, Space) end
---@param ControlName FName
---@param OffsetTransform FTransform
---@param Space EControlRigComponentSpace
function UControlRigComponent:SetControlOffset(ControlName, OffsetTransform, Space) end
---@param ControlName FName
---@param Value int32
function UControlRigComponent:SetControlInt(ControlName, Value) end
---@param ControlName FName
---@param Value float
function UControlRigComponent:SetControlFloat(ControlName, Value) end
---@param ControlName FName
---@param Value boolean
function UControlRigComponent:SetControlBool(ControlName, Value) end
---@param BoneName FName
---@param Transform FTransform
---@param Space EControlRigComponentSpace
---@param Weight float
---@param bPropagateToChildren boolean
function UControlRigComponent:SetBoneTransform(BoneName, Transform, Space, Weight, bPropagateToChildren) end
---@param InSkeletalMesh USkeletalMesh
function UControlRigComponent:SetBoneInitialTransformsFromSkeletalMesh(InSkeletalMesh) end
---@param Component UControlRigComponent
function UControlRigComponent:OnPreInitialize(Component) end
---@param Component UControlRigComponent
function UControlRigComponent:OnPreForwardsSolve(Component) end
---@param Component UControlRigComponent
function UControlRigComponent:OnPreConstruction(Component) end
---@param Component UControlRigComponent
function UControlRigComponent:OnPostInitialize(Component) end
---@param Component UControlRigComponent
function UControlRigComponent:OnPostForwardsSolve(Component) end
---@param Component UControlRigComponent
function UControlRigComponent:OnPostConstruction(Component) end
function UControlRigComponent:Initialize() end
---@param SpaceName FName
---@param Space EControlRigComponentSpace
---@return FTransform
function UControlRigComponent:GetSpaceTransform(SpaceName, Space) end
---@param SpaceName FName
---@param Space EControlRigComponentSpace
---@return FTransform
function UControlRigComponent:GetInitialSpaceTransform(SpaceName, Space) end
---@param BoneName FName
---@param Space EControlRigComponentSpace
---@return FTransform
function UControlRigComponent:GetInitialBoneTransform(BoneName, Space) end
---@param ElementType ERigElementType
---@return TArray<FName>
function UControlRigComponent:GetElementNames(ElementType) end
---@param ControlName FName
---@return FVector2D
function UControlRigComponent:GetControlVector2D(ControlName) end
---@param ControlName FName
---@param Space EControlRigComponentSpace
---@return FTransform
function UControlRigComponent:GetControlTransform(ControlName, Space) end
---@param ControlName FName
---@param Space EControlRigComponentSpace
---@return FVector
function UControlRigComponent:GetControlScale(ControlName, Space) end
---@param ControlName FName
---@param Space EControlRigComponentSpace
---@return FRotator
function UControlRigComponent:GetControlRotator(ControlName, Space) end
---@return UControlRig
function UControlRigComponent:GetControlRig() end
---@param ControlName FName
---@param Space EControlRigComponentSpace
---@return FVector
function UControlRigComponent:GetControlPosition(ControlName, Space) end
---@param ControlName FName
---@param Space EControlRigComponentSpace
---@return FTransform
function UControlRigComponent:GetControlOffset(ControlName, Space) end
---@param ControlName FName
---@return int32
function UControlRigComponent:GetControlInt(ControlName) end
---@param ControlName FName
---@return float
function UControlRigComponent:GetControlFloat(ControlName) end
---@param ControlName FName
---@return boolean
function UControlRigComponent:GetControlBool(ControlName) end
---@param BoneName FName
---@param Space EControlRigComponentSpace
---@return FTransform
function UControlRigComponent:GetBoneTransform(BoneName, Space) end
---@return float
function UControlRigComponent:GetAbsoluteTime() end
---@param Name FName
---@param ElementType ERigElementType
---@return boolean
function UControlRigComponent:DoesElementExist(Name, ElementType) end
function UControlRigComponent:ClearMappedElements() end
---@return boolean
function UControlRigComponent:CanExecute() end
---@param SkeletalMeshComponent USkeletalMeshComponent
---@param Bones TArray<FControlRigComponentMappedBone>
---@param Curves TArray<FControlRigComponentMappedCurve>
---@param InDirection EControlRigComponentMapDirection
function UControlRigComponent:AddMappedSkeletalMesh(SkeletalMeshComponent, Bones, Curves, InDirection) end
---@param NewMappedElements TArray<FControlRigComponentMappedElement>
function UControlRigComponent:AddMappedElements(NewMappedElements) end
---@param Components TArray<FControlRigComponentMappedComponent>
function UControlRigComponent:AddMappedComponents(Components) end
---@param SkeletalMeshComponent USkeletalMeshComponent
---@param InDirection EControlRigComponentMapDirection
function UControlRigComponent:AddMappedCompleteSkeletalMesh(SkeletalMeshComponent, InDirection) end


---@class UControlRigEditorSettings : URigVMEditorSettings
local UControlRigEditorSettings = {}


---@class UControlRigLayerInstance : UAnimInstance
local UControlRigLayerInstance = {}


---@class UControlRigNumericalValidationPass : UControlRigValidationPass
---@field bCheckControls boolean
---@field bCheckBones boolean
---@field bCheckCurves boolean
---@field TranslationPrecision float
---@field RotationPrecision float
---@field ScalePrecision float
---@field CurvePrecision float
---@field EventNameA FName
---@field EventNameB FName
---@field Pose FRigPose
local UControlRigNumericalValidationPass = {}



---@class UControlRigPoseAsset : UObject
---@field Pose FControlRigControlPose
local UControlRigPoseAsset = {}

---@param InControlRig UControlRig
---@param bDoMirror boolean
function UControlRigPoseAsset:SelectControls(InControlRig, bDoMirror) end
---@param InControlRig UControlRig
---@param bUseAll boolean
function UControlRigPoseAsset:SavePose(InControlRig, bUseAll) end
---@param CurrentName FName
---@param NewName FName
function UControlRigPoseAsset:ReplaceControlName(CurrentName, NewName) end
---@param InControlRig UControlRig
---@param bDoKey boolean
---@param bDoMirror boolean
function UControlRigPoseAsset:PastePose(InControlRig, bDoKey, bDoMirror) end
---@param InControlRig UControlRig
---@param OutPose FControlRigControlPose
function UControlRigPoseAsset:GetCurrentPose(InControlRig, OutPose) end
---@return TArray<FName>
function UControlRigPoseAsset:GetControlNames() end
---@param ControlRig UControlRig
---@param ControlName FName
---@return boolean
function UControlRigPoseAsset:DoesMirrorMatch(ControlRig, ControlName) end


---@class UControlRigPoseMirrorSettings : UObject
---@field RightSide FString
---@field LeftSide FString
---@field MirrorAxis EAxis::Type
---@field AxisToFlip EAxis::Type
local UControlRigPoseMirrorSettings = {}



---@class UControlRigPoseProjectSettings : UObject
---@field RootSaveDirs TArray<FDirectoryPath>
local UControlRigPoseProjectSettings = {}



---@class UControlRigSettings : UDeveloperSettings
local UControlRigSettings = {}


---@class UControlRigShapeLibrary : UObject
---@field DefaultShape FControlRigShapeDefinition
---@field DefaultMaterial TSoftObjectPtr<UMaterial>
---@field XRayMaterial TSoftObjectPtr<UMaterial>
---@field MaterialColorParameter FName
---@field Shapes TArray<FControlRigShapeDefinition>
local UControlRigShapeLibrary = {}



---@class UControlRigShapeLibraryLink : UNameSpacedUserData
---@field ShapeLibrary TSoftObjectPtr<UControlRigShapeLibrary>
---@field ShapeNames TArray<FName>
---@field ShapeLibraryCached UControlRigShapeLibrary
local UControlRigShapeLibraryLink = {}

---@param InShapeLibrary TSoftObjectPtr<UControlRigShapeLibrary>
function UControlRigShapeLibraryLink:SetShapeLibrary(InShapeLibrary) end
---@return TSoftObjectPtr<UControlRigShapeLibrary>
function UControlRigShapeLibraryLink:GetShapeLibrary() end


---@class UControlRigTestData : UObject
---@field ControlRigObjectPath FSoftObjectPath
---@field Initial FControlRigTestDataFrame
---@field InputFrames TArray<FControlRigTestDataFrame>
---@field OutputFrames TArray<FControlRigTestDataFrame>
---@field FramesToSkip TArray<int32>
---@field Tolerance double
local UControlRigTestData = {}

---@param InControlRig UControlRig
---@param bGroundTruth boolean
---@return boolean
function UControlRigTestData:SetupReplay(InControlRig, bGroundTruth) end
function UControlRigTestData:ReleaseReplay() end
---@param InControlRig UControlRig
---@param InRecordingDuration double
---@return boolean
function UControlRigTestData:Record(InControlRig, InRecordingDuration) end
---@return boolean
function UControlRigTestData:IsReplaying() end
---@return boolean
function UControlRigTestData:IsRecording() end
---@param bInput boolean
---@return FVector2D
function UControlRigTestData:GetTimeRange(bInput) end
---@return EControlRigTestDataPlaybackMode
function UControlRigTestData:GetPlaybackMode() end
---@param InSeconds double
---@param bInput boolean
---@return int32
function UControlRigTestData:GetFrameIndexForTime(InSeconds, bInput) end
---@param InDesiredPackagePath FString
---@param InBlueprintPathName FString
---@return UControlRigTestData
function UControlRigTestData:CreateNewAsset(InDesiredPackagePath, InBlueprintPathName) end


---@class UControlRigTransformWorkflowOptions : UControlRigWorkflowOptions
---@field TransformType ERigTransformType::Type
local UControlRigTransformWorkflowOptions = {}

---@param InSubject UObject
---@return TArray<FRigVMUserWorkflow>
function UControlRigTransformWorkflowOptions:ProvideWorkflows(InSubject) end


---@class UControlRigValidationPass : UObject
local UControlRigValidationPass = {}


---@class UControlRigValidator : UObject
---@field Passes TArray<UControlRigValidationPass>
local UControlRigValidator = {}



---@class UControlRigWorkflowOptions : URigVMUserWorkflowOptions
---@field Hierarchy URigHierarchy
---@field Selection TArray<FRigElementKey>
local UControlRigWorkflowOptions = {}

---@return boolean
function UControlRigWorkflowOptions:EnsureAtLeastOneRigElementSelected() end


---@class UDefault__ControlRigBlueprintGeneratedClass
local UDefault__ControlRigBlueprintGeneratedClass = {}


---@class UFKControlRig : UControlRig
---@field IsControlActive TArray<boolean>
---@field ApplyMode EControlRigFKRigExecuteMode
local UFKControlRig = {}



---@class UModularRig : UControlRig
---@field Modules TArray<FRigModuleInstance>
---@field ModularRigSettings FModularRigSettings
---@field ModularRigModel FModularRigModel
---@field ExecutionQueue TArray<FRigModuleExecutionElement>
local UModularRig = {}



---@class UModularRigController : UObject
local UModularRigController = {}

---@param InModulePath FString
---@param InVariableName FName
---@param bSetupUndo boolean
---@return boolean
function UModularRigController:UnBindModuleVariable(InModulePath, InVariableName, bSetupUndo) end
---@param InOldClass TSubclassOf<UControlRig>
---@param InNewClass TSubclassOf<UControlRig>
---@param bSetupUndo boolean
---@return boolean
function UModularRigController:SwapModulesOfClass(InOldClass, InNewClass, bSetupUndo) end
---@param InModulePath FString
---@param InNewClass TSubclassOf<UControlRig>
---@param bSetupUndo boolean
---@return boolean
function UModularRigController:SwapModuleClass(InModulePath, InNewClass, bSetupUndo) end
---@param InModulePath FString
---@param InNewShortName FString
---@param bSetupUndo boolean
---@return boolean
function UModularRigController:SetModuleShortName(InModulePath, InNewShortName, bSetupUndo) end
---@param InModulePaths TArray<FString>
---@return boolean
function UModularRigController:SetModuleSelection(InModulePaths) end
---@param InModulePath FString
---@param InVariableName FName
---@param InValue FString
---@param bSetupUndo boolean
---@return boolean
function UModularRigController:SetConfigValueInModule(InModulePath, InVariableName, InValue, bSetupUndo) end
---@param InModulePath FString
---@param InSelected boolean
---@return boolean
function UModularRigController:SelectModule(InModulePath, InSelected) end
---@param InModulePath FString
---@param InNewParentModulePath FString
---@param bSetupUndo boolean
---@return FString
function UModularRigController:ReparentModule(InModulePath, InNewParentModulePath, bSetupUndo) end
---@param InModulePath FString
---@param InNewName FName
---@param bSetupUndo boolean
---@return FString
function UModularRigController:RenameModule(InModulePath, InNewName, bSetupUndo) end
---@param InModulePath FString
---@param InSettings FRigVMMirrorSettings
---@param bSetupUndo boolean
---@return FString
function UModularRigController:MirrorModule(InModulePath, InSettings, bSetupUndo) end
---@return TArray<FString>
function UModularRigController:GetSelectedModules() end
---@param bSetupUndo boolean
---@return TArray<FRigElementKey>
function UModularRigController:DisconnectCyclicConnectors(bSetupUndo) end
---@param InConnectorKey FRigElementKey
---@param bDisconnectSubModules boolean
---@param bSetupUndo boolean
---@return boolean
function UModularRigController:DisconnectConnector(InConnectorKey, bDisconnectSubModules, bSetupUndo) end
---@param InModulePath FString
---@return boolean
function UModularRigController:DeselectModule(InModulePath) end
---@param InModulePath FString
---@param bSetupUndo boolean
---@return boolean
function UModularRigController:DeleteModule(InModulePath, bSetupUndo) end
---@param InConnectorKey FRigElementKey
---@param InTargetKey FRigElementKey
---@param bSetupUndo boolean
---@param bAutoResolveOtherConnectors boolean
---@param bCheckValidConnection boolean
---@return boolean
function UModularRigController:ConnectConnectorToElement(InConnectorKey, InTargetKey, bSetupUndo, bAutoResolveOtherConnectors, bCheckValidConnection) end
---@param InConnectorKey FRigElementKey
---@param InTargetKey FRigElementKey
---@param OutErrorMessage FText
---@return boolean
function UModularRigController:CanConnectConnectorToElement(InConnectorKey, InTargetKey, OutErrorMessage) end
---@param InModulePath FString
---@param InVariableName FName
---@param InSourcePath FString
---@param bSetupUndo boolean
---@return boolean
function UModularRigController:BindModuleVariable(InModulePath, InVariableName, InSourcePath, bSetupUndo) end
---@param InConnectorKeys TArray<FRigElementKey>
---@param bReplaceExistingConnections boolean
---@param bSetupUndo boolean
---@return boolean
function UModularRigController:AutoConnectSecondaryConnectors(InConnectorKeys, bReplaceExistingConnections, bSetupUndo) end
---@param InModulePaths TArray<FString>
---@param bReplaceExistingConnections boolean
---@param bSetupUndo boolean
---@return boolean
function UModularRigController:AutoConnectModules(InModulePaths, bReplaceExistingConnections, bSetupUndo) end
---@param InModuleName FName
---@param InClass TSubclassOf<UControlRig>
---@param InParentModulePath FString
---@param bSetupUndo boolean
---@return FString
function UModularRigController:AddModule(InModuleName, InClass, InParentModulePath, bSetupUndo) end


---@class UModularRigRuleManager : UObject
local UModularRigRuleManager = {}


---@class UMovieSceneControlRigParameterSection : UMovieSceneParameterSection
---@field ControlRig UControlRig
---@field ControlRigClass TSubclassOf<UControlRig>
---@field ControlsMask TArray<boolean>
---@field ControlNameMask TSet<FName>
---@field TransformMask FMovieSceneTransformMask
---@field Weight FMovieSceneFloatChannel
---@field ControlChannelMap TMap<FName, FChannelMapInfo>
---@field EnumParameterNamesAndCurves TArray<FEnumParameterNameAndCurve>
---@field IntegerParameterNamesAndCurves TArray<FIntegerParameterNameAndCurve>
---@field SpaceChannels TArray<FSpaceControlNameAndChannel>
---@field ConstraintsChannels TArray<FConstraintAndActiveChannel>
local UMovieSceneControlRigParameterSection = {}



---@class UMovieSceneControlRigParameterTrack : UMovieSceneNameableTrack
---@field SectionToKeyPerControl TMap<FName, TWeakObjectPtr<UMovieSceneSection>>
---@field ControlRig UControlRig
---@field SectionToKey UMovieSceneSection
---@field Sections TArray<UMovieSceneSection>
---@field TrackName FName
---@field ControlsRotationOrder TMap<FName, FControlRotationOrder>
---@field PriorityOrder int32
---@field GameWorldControlRigs TMap<TWeakObjectPtr<UWorld>, UControlRig>
local UMovieSceneControlRigParameterTrack = {}



---@class URigHierarchy : UObject
---@field ModifiedEventDynamic FRigHierarchyModifiedEventDynamic
---@field TopologyVersion uint32
---@field MetadataVersion uint32
---@field MetadataTagVersion uint16
---@field bEnableDirtyPropagation boolean
---@field TransformStackIndex int32
---@field HierarchyController URigHierarchyController
---@field RuleManager UModularRigRuleManager
---@field PreviousNameMap TMap<FRigElementKey, FRigElementKey>
---@field HierarchyForCacheValidation URigHierarchy
local URigHierarchy = {}

---@param InElementIndex int32
---@param bSetupUndo boolean
function URigHierarchy:UnsetCurveValueByIndex(InElementIndex, bSetupUndo) end
---@param InKey FRigElementKey
---@param bSetupUndo boolean
function URigHierarchy:UnsetCurveValue(InKey, bSetupUndo) end
---@param InChild FRigElementKey
---@param bInitial boolean
---@param bAffectChildren boolean
---@return boolean
function URigHierarchy:SwitchToWorldSpace(InChild, bInitial, bAffectChildren) end
---@param InChild FRigElementKey
---@param InParent FRigElementKey
---@param bInitial boolean
---@param bAffectChildren boolean
---@return boolean
function URigHierarchy:SwitchToParent(InChild, InParent, bInitial, bAffectChildren) end
---@param InChild FRigElementKey
---@param bInitial boolean
---@param bAffectChildren boolean
---@return boolean
function URigHierarchy:SwitchToDefaultParent(InChild, bInitial, bAffectChildren) end
---@param InKeys TArray<FRigElementKey>
---@return TArray<FRigElementKey>
function URigHierarchy:SortKeys(InKeys) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue FVector
---@return boolean
function URigHierarchy:SetVectorMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue TArray<FVector>
---@return boolean
function URigHierarchy:SetVectorArrayMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue FTransform
---@return boolean
function URigHierarchy:SetTransformMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue TArray<FTransform>
---@return boolean
function URigHierarchy:SetTransformArrayMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InTag FName
---@return boolean
function URigHierarchy:SetTag(InItem, InTag) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue FRotator
---@return boolean
function URigHierarchy:SetRotatorMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue TArray<FRotator>
---@return boolean
function URigHierarchy:SetRotatorArrayMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue FRigElementKey
---@return boolean
function URigHierarchy:SetRigElementKeyMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue TArray<FRigElementKey>
---@return boolean
function URigHierarchy:SetRigElementKeyArrayMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue FQuat
---@return boolean
function URigHierarchy:SetQuatMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue TArray<FQuat>
---@return boolean
function URigHierarchy:SetQuatArrayMetadata(InItem, InMetadataName, InValue) end
---@param InPose FRigPose
function URigHierarchy:SetPose_ForBlueprint(InPose) end
---@param InChild FRigElementKey
---@param InWeights TArray<FRigElementWeight>
---@param bInitial boolean
---@param bAffectChildren boolean
---@return boolean
function URigHierarchy:SetParentWeightArray(InChild, InWeights, bInitial, bAffectChildren) end
---@param InChild FRigElementKey
---@param InParent FRigElementKey
---@param InWeight FRigElementWeight
---@param bInitial boolean
---@param bAffectChildren boolean
---@return boolean
function URigHierarchy:SetParentWeight(InChild, InParent, InWeight, bInitial, bAffectChildren) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue FName
---@return boolean
function URigHierarchy:SetNameMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue TArray<FName>
---@return boolean
function URigHierarchy:SetNameArrayMetadata(InItem, InMetadataName, InValue) end
---@param InElementIndex int32
---@param InTransform FTransform
---@param bInitial boolean
---@param bAffectChildren boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommands boolean
function URigHierarchy:SetLocalTransformByIndex(InElementIndex, InTransform, bInitial, bAffectChildren, bSetupUndo, bPrintPythonCommands) end
---@param InKey FRigElementKey
---@param InTransform FTransform
---@param bInitial boolean
---@param bAffectChildren boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommands boolean
function URigHierarchy:SetLocalTransform(InKey, InTransform, bInitial, bAffectChildren, bSetupUndo, bPrintPythonCommands) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue FLinearColor
---@return boolean
function URigHierarchy:SetLinearColorMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue TArray<FLinearColor>
---@return boolean
function URigHierarchy:SetLinearColorArrayMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue int32
---@return boolean
function URigHierarchy:SetInt32Metadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue TArray<int32>
---@return boolean
function URigHierarchy:SetInt32ArrayMetadata(InItem, InMetadataName, InValue) end
---@param InElementIndex int32
---@param InTransform FTransform
---@param bInitial boolean
---@param bAffectChildren boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
function URigHierarchy:SetGlobalTransformByIndex(InElementIndex, InTransform, bInitial, bAffectChildren, bSetupUndo, bPrintPythonCommand) end
---@param InKey FRigElementKey
---@param InTransform FTransform
---@param bInitial boolean
---@param bAffectChildren boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
function URigHierarchy:SetGlobalTransform(InKey, InTransform, bInitial, bAffectChildren, bSetupUndo, bPrintPythonCommand) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue float
---@return boolean
function URigHierarchy:SetFloatMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue TArray<float>
---@return boolean
function URigHierarchy:SetFloatArrayMetadata(InItem, InMetadataName, InValue) end
---@param InElementIndex int32
---@param InValue float
---@param bSetupUndo boolean
function URigHierarchy:SetCurveValueByIndex(InElementIndex, InValue, bSetupUndo) end
---@param InKey FRigElementKey
---@param InValue float
---@param bSetupUndo boolean
function URigHierarchy:SetCurveValue(InKey, InValue, bSetupUndo) end
---@param InElementIndex int32
---@param bVisibility boolean
function URigHierarchy:SetControlVisibilityByIndex(InElementIndex, bVisibility) end
---@param InKey FRigElementKey
---@param bVisibility boolean
function URigHierarchy:SetControlVisibility(InKey, bVisibility) end
---@param InElementIndex int32
---@param InValue FRigControlValue
---@param InValueType ERigControlValueType
---@param bSetupUndo boolean
---@param bPrintPythonCommands boolean
function URigHierarchy:SetControlValueByIndex(InElementIndex, InValue, InValueType, bSetupUndo, bPrintPythonCommands) end
---@param InKey FRigElementKey
---@param InValue FRigControlValue
---@param InValueType ERigControlValueType
---@param bSetupUndo boolean
---@param bPrintPythonCommands boolean
function URigHierarchy:SetControlValue(InKey, InValue, InValueType, bSetupUndo, bPrintPythonCommands) end
---@param InElementIndex int32
---@param InTransform FTransform
---@param bInitial boolean
---@param bSetupUndo boolean
function URigHierarchy:SetControlShapeTransformByIndex(InElementIndex, InTransform, bInitial, bSetupUndo) end
---@param InKey FRigElementKey
---@param InTransform FTransform
---@param bInitial boolean
---@param bSetupUndo boolean
function URigHierarchy:SetControlShapeTransform(InKey, InTransform, bInitial, bSetupUndo) end
---@param InElementIndex int32
---@param InSettings FRigControlSettings
---@param bSetupUndo boolean
---@param bForce boolean
---@param bPrintPythonCommands boolean
function URigHierarchy:SetControlSettingsByIndex(InElementIndex, InSettings, bSetupUndo, bForce, bPrintPythonCommands) end
---@param InKey FRigElementKey
---@param InSettings FRigControlSettings
---@param bSetupUndo boolean
---@param bForce boolean
---@param bPrintPythonCommands boolean
function URigHierarchy:SetControlSettings(InKey, InSettings, bSetupUndo, bForce, bPrintPythonCommands) end
---@param InElementIndex int32
---@param InRotator FRotator
---@param bInitial boolean
---@param bFixEulerFlips boolean
function URigHierarchy:SetControlPreferredRotatorByIndex(InElementIndex, InRotator, bInitial, bFixEulerFlips) end
---@param InKey FRigElementKey
---@param InRotator FRotator
---@param bInitial boolean
---@param bFixEulerFlips boolean
function URigHierarchy:SetControlPreferredRotator(InKey, InRotator, bInitial, bFixEulerFlips) end
---@param InElementIndex int32
---@param InRotationOrder EEulerRotationOrder
function URigHierarchy:SetControlPreferredRotationOrderByIndex(InElementIndex, InRotationOrder) end
---@param InKey FRigElementKey
---@param InRotationOrder EEulerRotationOrder
function URigHierarchy:SetControlPreferredRotationOrder(InKey, InRotationOrder) end
---@param InElementIndex int32
---@param InEulerAngles FVector
---@param InRotationOrder EEulerRotationOrder
---@param bInitial boolean
---@param bFixEulerFlips boolean
function URigHierarchy:SetControlPreferredEulerAnglesByIndex(InElementIndex, InEulerAngles, InRotationOrder, bInitial, bFixEulerFlips) end
---@param InKey FRigElementKey
---@param InEulerAngles FVector
---@param InRotationOrder EEulerRotationOrder
---@param bInitial boolean
---@param bFixEulerFlips boolean
function URigHierarchy:SetControlPreferredEulerAngles(InKey, InEulerAngles, InRotationOrder, bInitial, bFixEulerFlips) end
---@param InElementIndex int32
---@param InTransform FTransform
---@param bInitial boolean
---@param bAffectChildren boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommands boolean
function URigHierarchy:SetControlOffsetTransformByIndex(InElementIndex, InTransform, bInitial, bAffectChildren, bSetupUndo, bPrintPythonCommands) end
---@param InKey FRigElementKey
---@param InTransform FTransform
---@param bInitial boolean
---@param bAffectChildren boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommands boolean
function URigHierarchy:SetControlOffsetTransform(InKey, InTransform, bInitial, bAffectChildren, bSetupUndo, bPrintPythonCommands) end
---@param InElementIndex int32
---@param InSettings FRigConnectorSettings
---@param bSetupUndo boolean
---@param bForce boolean
---@param bPrintPythonCommands boolean
function URigHierarchy:SetConnectorSettingsByIndex(InElementIndex, InSettings, bSetupUndo, bForce, bPrintPythonCommands) end
---@param InKey FRigElementKey
---@param InSettings FRigConnectorSettings
---@param bSetupUndo boolean
---@param bForce boolean
---@param bPrintPythonCommands boolean
function URigHierarchy:SetConnectorSettings(InKey, InSettings, bSetupUndo, bForce, bPrintPythonCommands) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue boolean
---@return boolean
function URigHierarchy:SetBoolMetadata(InItem, InMetadataName, InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param InValue TArray<boolean>
---@return boolean
function URigHierarchy:SetBoolArrayMetadata(InItem, InMetadataName, InValue) end
---@param InElement FRigElementKey
---@param InOffsetInSeconds float
---@param bAsynchronous boolean
function URigHierarchy:SendAutoKeyEvent(InElement, InOffsetInSeconds, bAsynchronous) end
---@param InStates TArray<FRigSocketState>
---@param bSetupUndoRedo boolean
---@return TArray<FRigElementKey>
function URigHierarchy:RestoreSocketsFromStates(InStates, bSetupUndoRedo) end
---@param InStates TArray<FRigConnectorState>
---@param bSetupUndoRedo boolean
---@return TArray<FRigElementKey>
function URigHierarchy:RestoreConnectorsFromStates(InStates, bSetupUndoRedo) end
function URigHierarchy:ResetToDefault() end
---@param InTypeFilter ERigElementType
function URigHierarchy:ResetPoseToInitial(InTypeFilter) end
function URigHierarchy:ResetCurveValues() end
function URigHierarchy:Reset() end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return boolean
function URigHierarchy:RemoveMetadata(InItem, InMetadataName) end
---@param InItem FRigElementKey
---@return boolean
function URigHierarchy:RemoveAllMetadata(InItem) end
---@return int32
function URigHierarchy:Num() end
---@param InValue FVector2D
---@return FRigControlValue
function URigHierarchy:MakeControlValueFromVector2D(InValue) end
---@param InValue FVector
---@return FRigControlValue
function URigHierarchy:MakeControlValueFromVector(InValue) end
---@param InValue FTransformNoScale
---@return FRigControlValue
function URigHierarchy:MakeControlValueFromTransformNoScale(InValue) end
---@param InValue FTransform
---@return FRigControlValue
function URigHierarchy:MakeControlValueFromTransform(InValue) end
---@param InValue FRotator
---@return FRigControlValue
function URigHierarchy:MakeControlValueFromRotator(InValue) end
---@param InValue int32
---@return FRigControlValue
function URigHierarchy:MakeControlValueFromInt(InValue) end
---@param InValue float
---@return FRigControlValue
function URigHierarchy:MakeControlValueFromFloat(InValue) end
---@param InValue FEulerTransform
---@return FRigControlValue
function URigHierarchy:MakeControlValueFromEulerTransform(InValue) end
---@param InValue boolean
---@return FRigControlValue
function URigHierarchy:MakeControlValueFromBool(InValue) end
---@param InElementIndex int32
---@return boolean
function URigHierarchy:IsValidIndex(InElementIndex) end
---@param InIndex int32
---@return boolean
function URigHierarchy:IsSelectedByIndex(InIndex) end
---@param InKey FRigElementKey
---@return boolean
function URigHierarchy:IsSelected(InKey) end
---@param InKey FRigElementKey
---@return boolean
function URigHierarchy:IsProcedural(InKey) end
---@param InChild FRigElementKey
---@param InParent FRigElementKey
---@return boolean
function URigHierarchy:IsParentedTo(InChild, InParent) end
---@param InElementIndex int32
---@return boolean
function URigHierarchy:IsCurveValueSetByIndex(InElementIndex) end
---@param InKey FRigElementKey
---@return boolean
function URigHierarchy:IsCurveValueSet(InKey) end
---@return boolean
function URigHierarchy:IsControllerAvailable() end
---@param InItem FRigElementKey
---@param InTag FName
---@return boolean
function URigHierarchy:HasTag(InItem, InTag) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param DefaultValue FVector
---@return FVector
function URigHierarchy:GetVectorMetadata(InItem, InMetadataName, DefaultValue) end
---@param InValue FRigControlValue
---@return FVector
function URigHierarchy:GetVectorFromControlValue(InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return TArray<FVector>
function URigHierarchy:GetVectorArrayMetadata(InItem, InMetadataName) end
---@param InValue FRigControlValue
---@return FVector2D
function URigHierarchy:GetVector2DFromControlValue(InValue) end
---@param InValue FRigControlValue
---@return FTransformNoScale
function URigHierarchy:GetTransformNoScaleFromControlValue(InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param DefaultValue FTransform
---@return FTransform
function URigHierarchy:GetTransformMetadata(InItem, InMetadataName, DefaultValue) end
---@param InValue FRigControlValue
---@return FTransform
function URigHierarchy:GetTransformFromControlValue(InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return TArray<FTransform>
function URigHierarchy:GetTransformArrayMetadata(InItem, InMetadataName) end
---@param InItem FRigElementKey
---@return TArray<FName>
function URigHierarchy:GetTags(InItem) end
---@return TArray<FRigSocketState>
function URigHierarchy:GetSocketStates() end
---@param bTraverse boolean
---@return TArray<FRigElementKey>
function URigHierarchy:GetSocketKeys(bTraverse) end
---@param InTypeFilter ERigElementType
---@return TArray<FRigElementKey>
function URigHierarchy:GetSelectedKeys(InTypeFilter) end
---@param bCreateIfNeeded boolean
---@return UModularRigRuleManager
function URigHierarchy:GetRuleManager(bCreateIfNeeded) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param DefaultValue FRotator
---@return FRotator
function URigHierarchy:GetRotatorMetadata(InItem, InMetadataName, DefaultValue) end
---@param InValue FRigControlValue
---@return FRotator
function URigHierarchy:GetRotatorFromControlValue(InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return TArray<FRotator>
function URigHierarchy:GetRotatorArrayMetadata(InItem, InMetadataName) end
---@return TArray<FRigElementKey>
function URigHierarchy:GetRootElementKeys() end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param DefaultValue FRigElementKey
---@return FRigElementKey
function URigHierarchy:GetRigElementKeyMetadata(InItem, InMetadataName, DefaultValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return TArray<FRigElementKey>
function URigHierarchy:GetRigElementKeyArrayMetadata(InItem, InMetadataName) end
---@param bTraverse boolean
---@return TArray<FRigElementKey>
function URigHierarchy:GetReferenceKeys(bTraverse) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param DefaultValue FQuat
---@return FQuat
function URigHierarchy:GetQuatMetadata(InItem, InMetadataName, DefaultValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return TArray<FQuat>
function URigHierarchy:GetQuatArrayMetadata(InItem, InMetadataName) end
---@param InKey FRigElementKey
---@return FRigElementKey
function URigHierarchy:GetPreviousParent(InKey) end
---@param InKey FRigElementKey
---@return FName
function URigHierarchy:GetPreviousName(InKey) end
---@param bInitial boolean
---@param bIncludeTransientControls boolean
---@return FRigPose
function URigHierarchy:GetPose(bInitial, bIncludeTransientControls) end
---@param bTraverse boolean
---@return TArray<FRigElementKey>
function URigHierarchy:GetPhysicsKeys(bTraverse) end
---@param InChild FRigElementKey
---@param bInitial boolean
---@return TArray<FRigElementWeight>
function URigHierarchy:GetParentWeightArray(InChild, bInitial) end
---@param InChild FRigElementKey
---@param InParent FRigElementKey
---@param bInitial boolean
---@return FRigElementWeight
function URigHierarchy:GetParentWeight(InChild, InParent, bInitial) end
---@param InElementIndex int32
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetParentTransformByIndex(InElementIndex, bInitial) end
---@param InKey FRigElementKey
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetParentTransform(InKey, bInitial) end
---@param InKey FRigElementKey
---@param bRecursive boolean
---@return TArray<FRigElementKey>
function URigHierarchy:GetParents(InKey, bRecursive) end
---@param InKey FRigElementKey
---@return int32
function URigHierarchy:GetNumberOfParents(InKey) end
---@param bTraverse boolean
---@return TArray<FRigElementKey>
function URigHierarchy:GetNullKeys(bTraverse) end
---@param InItem FRigElementKey
---@return FName
function URigHierarchy:GetNameSpaceFName(InItem) end
---@param InItem FRigElementKey
---@return FString
function URigHierarchy:GetNameSpace(InItem) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param DefaultValue FName
---@return FName
function URigHierarchy:GetNameMetadata(InItem, InMetadataName, DefaultValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return TArray<FName>
function URigHierarchy:GetNameArrayMetadata(InItem, InMetadataName) end
---@param InItem FRigElementKey
---@return FName
function URigHierarchy:GetModulePathFName(InItem) end
---@param InItem FRigElementKey
---@return FString
function URigHierarchy:GetModulePath(InItem) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return ERigMetadataType
function URigHierarchy:GetMetadataType(InItem, InMetadataName) end
---@param InItem FRigElementKey
---@return TArray<FName>
function URigHierarchy:GetMetadataNames(InItem) end
---@param InElementIndex int32
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetLocalTransformByIndex(InElementIndex, bInitial) end
---@param InKey FRigElementKey
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetLocalTransform(InKey, bInitial) end
---@param InKey FRigElementKey
---@return int32
function URigHierarchy:GetLocalIndex_ForBlueprint(InKey) end
---@param InElementIndex int32
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetLocalControlShapeTransformByIndex(InElementIndex, bInitial) end
---@param InKey FRigElementKey
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetLocalControlShapeTransform(InKey, bInitial) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param DefaultValue FLinearColor
---@return FLinearColor
function URigHierarchy:GetLinearColorMetadata(InItem, InMetadataName, DefaultValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return TArray<FLinearColor>
function URigHierarchy:GetLinearColorArrayMetadata(InItem, InMetadataName) end
---@param InElementIndices TArray<int32>
---@return TArray<FRigElementKey>
function URigHierarchy:GetKeys(InElementIndices) end
---@param InElementIndex int32
---@return FRigElementKey
function URigHierarchy:GetKey(InElementIndex) end
---@param InValue FRigControlValue
---@return int32
function URigHierarchy:GetIntFromControlValue(InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param DefaultValue int32
---@return int32
function URigHierarchy:GetInt32Metadata(InItem, InMetadataName, DefaultValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return TArray<int32>
function URigHierarchy:GetInt32ArrayMetadata(InItem, InMetadataName) end
---@param InKey FRigElementKey
---@return int32
function URigHierarchy:GetIndex_ForBlueprint(InKey) end
---@param InElementIndex int32
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetGlobalTransformByIndex(InElementIndex, bInitial) end
---@param InKey FRigElementKey
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetGlobalTransform(InKey, bInitial) end
---@param InElementIndex int32
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetGlobalControlShapeTransformByIndex(InElementIndex, bInitial) end
---@param InKey FRigElementKey
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetGlobalControlShapeTransform(InKey, bInitial) end
---@param InElementIndex int32
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetGlobalControlOffsetTransformByIndex(InElementIndex, bInitial) end
---@param InKey FRigElementKey
---@param bInitial boolean
---@return FTransform
function URigHierarchy:GetGlobalControlOffsetTransform(InKey, bInitial) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param DefaultValue float
---@return float
function URigHierarchy:GetFloatMetadata(InItem, InMetadataName, DefaultValue) end
---@param InValue FRigControlValue
---@return float
function URigHierarchy:GetFloatFromControlValue(InValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return TArray<float>
function URigHierarchy:GetFloatArrayMetadata(InItem, InMetadataName) end
---@param InKey FRigElementKey
---@return FRigElementKey
function URigHierarchy:GetFirstParent(InKey) end
---@param InValue FRigControlValue
---@return FEulerTransform
function URigHierarchy:GetEulerTransformFromControlValue(InValue) end
---@param InKey FRigElementKey
---@return FRigElementKey
function URigHierarchy:GetDefaultParent(InKey) end
---@param InElementIndex int32
---@return float
function URigHierarchy:GetCurveValueByIndex(InElementIndex) end
---@param InKey FRigElementKey
---@return float
function URigHierarchy:GetCurveValue(InKey) end
---@return TArray<FRigElementKey>
function URigHierarchy:GetCurveKeys() end
---@param InElementIndex int32
---@param InValueType ERigControlValueType
---@return FRigControlValue
function URigHierarchy:GetControlValueByIndex(InElementIndex, InValueType) end
---@param InKey FRigElementKey
---@param InValueType ERigControlValueType
---@return FRigControlValue
function URigHierarchy:GetControlValue(InKey, InValueType) end
---@param InElementIndex int32
---@param bInitial boolean
---@return FRotator
function URigHierarchy:GetControlPreferredRotatorByIndex(InElementIndex, bInitial) end
---@param InKey FRigElementKey
---@param bInitial boolean
---@return FRotator
function URigHierarchy:GetControlPreferredRotator(InKey, bInitial) end
---@param InElementIndex int32
---@param bFromSettings boolean
---@return EEulerRotationOrder
function URigHierarchy:GetControlPreferredEulerRotationOrderByIndex(InElementIndex, bFromSettings) end
---@param InKey FRigElementKey
---@param bFromSettings boolean
---@return EEulerRotationOrder
function URigHierarchy:GetControlPreferredEulerRotationOrder(InKey, bFromSettings) end
---@param InElementIndex int32
---@param InRotationOrder EEulerRotationOrder
---@param bInitial boolean
---@return FVector
function URigHierarchy:GetControlPreferredEulerAnglesByIndex(InElementIndex, InRotationOrder, bInitial) end
---@param InKey FRigElementKey
---@param InRotationOrder EEulerRotationOrder
---@param bInitial boolean
---@return FVector
function URigHierarchy:GetControlPreferredEulerAngles(InKey, InRotationOrder, bInitial) end
---@param bCreateIfNeeded boolean
---@return URigHierarchyController
function URigHierarchy:GetController(bCreateIfNeeded) end
---@param bTraverse boolean
---@return TArray<FRigElementKey>
function URigHierarchy:GetControlKeys(bTraverse) end
---@return TArray<FRigConnectorState>
function URigHierarchy:GetConnectorStates() end
---@param bTraverse boolean
---@return TArray<FRigElementKey>
function URigHierarchy:GetConnectorKeys(bTraverse) end
---@param InKey FRigElementKey
---@param bRecursive boolean
---@return TArray<FRigElementKey>
function URigHierarchy:GetChildren(InKey, bRecursive) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@param DefaultValue boolean
---@return boolean
function URigHierarchy:GetBoolMetadata(InItem, InMetadataName, DefaultValue) end
---@param InItem FRigElementKey
---@param InMetadataName FName
---@return TArray<boolean>
function URigHierarchy:GetBoolArrayMetadata(InItem, InMetadataName) end
---@param bTraverse boolean
---@return TArray<FRigElementKey>
function URigHierarchy:GetBoneKeys(bTraverse) end
---@param bTraverse boolean
---@return TArray<FRigElementKey>
function URigHierarchy:GetAllKeys_ForBlueprint(bTraverse) end
---@param InKey FRigElementKey
---@return FRigNullElement
function URigHierarchy:FindNull_ForBlueprintOnly(InKey) end
---@param InKey FRigElementKey
---@return FRigControlElement
function URigHierarchy:FindControl_ForBlueprintOnly(InKey) end
---@param InKey FRigElementKey
---@return FRigBoneElement
function URigHierarchy:FindBone_ForBlueprintOnly(InKey) end
---@param InHierarchy URigHierarchy
---@param bCurrent boolean
---@param bInitial boolean
---@param bWeights boolean
---@param bMatchPoseInGlobalIfNeeded boolean
function URigHierarchy:CopyPose(InHierarchy, bCurrent, bInitial, bWeights, bMatchPoseInGlobalIfNeeded) end
---@param InHierarchy URigHierarchy
function URigHierarchy:CopyHierarchy(InHierarchy) end
---@param InKey FRigElementKey
---@return boolean
function URigHierarchy:Contains_ForBlueprint(InKey) end


---@class URigHierarchyController : UObject
---@field bReportWarningsAndErrors boolean
local URigHierarchyController = {}

---@param InKeys TArray<FRigElementKey>
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:SetSelection(InKeys, bPrintPythonCommand) end
---@param InChild FRigElementKey
---@param InParent FRigElementKey
---@param bMaintainGlobalTransform boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:SetParent(InChild, InParent, bMaintainGlobalTransform, bSetupUndo, bPrintPythonCommand) end
---@param InHierarchy URigHierarchy
function URigHierarchyController:SetHierarchy(InHierarchy) end
---@param InControl FRigElementKey
---@param InDisplayName FName
---@param bRenameElement boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return FName
function URigHierarchyController:SetDisplayName(InControl, InDisplayName, bRenameElement, bSetupUndo, bPrintPythonCommand) end
---@param InKey FRigElementKey
---@param InSettings FRigControlSettings
---@param bSetupUndo boolean
---@return boolean
function URigHierarchyController:SetControlSettings(InKey, InSettings, bSetupUndo) end
---@param InControl FRigElementKey
---@param InSpace FRigElementKey
---@param InIndex int32
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:SetAvailableSpaceIndex(InControl, InSpace, InIndex, bSetupUndo, bPrintPythonCommand) end
---@param InKey FRigElementKey
---@param bSelect boolean
---@param bClearSelection boolean
---@return boolean
function URigHierarchyController:SelectElement(InKey, bSelect, bClearSelection) end
---@param InElement FRigElementKey
---@param InIndex int32
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:ReorderElement(InElement, InIndex, bSetupUndo, bPrintPythonCommand) end
---@param InElement FRigElementKey
---@param InName FName
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@param bClearSelection boolean
---@return FRigElementKey
function URigHierarchyController:RenameElement(InElement, InName, bSetupUndo, bPrintPythonCommand, bClearSelection) end
---@param InChild FRigElementKey
---@param InParent FRigElementKey
---@param bMaintainGlobalTransform boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:RemoveParent(InChild, InParent, bMaintainGlobalTransform, bSetupUndo, bPrintPythonCommand) end
---@param InElement FRigElementKey
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:RemoveElement(InElement, bSetupUndo, bPrintPythonCommand) end
---@param InChannel FRigElementKey
---@param InHost FRigElementKey
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:RemoveChannelHost(InChannel, InHost, bSetupUndo, bPrintPythonCommand) end
---@param InControl FRigElementKey
---@param InSpace FRigElementKey
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:RemoveAvailableSpace(InControl, InSpace, bSetupUndo, bPrintPythonCommand) end
---@param InChild FRigElementKey
---@param bMaintainGlobalTransform boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:RemoveAllParents(InChild, bMaintainGlobalTransform, bSetupUndo, bPrintPythonCommand) end
---@param InKeys TArray<FRigElementKey>
---@param InSettings FRigVMMirrorSettings
---@param bSelectNewElements boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommands boolean
---@return TArray<FRigElementKey>
function URigHierarchyController:MirrorElements(InKeys, InSettings, bSelectNewElements, bSetupUndo, bPrintPythonCommands) end
---@param InContent FString
---@param bReplaceExistingElements boolean
---@param bSelectNewElements boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommands boolean
---@return TArray<FRigElementKey>
function URigHierarchyController:ImportFromText(InContent, bReplaceExistingElements, bSelectNewElements, bSetupUndo, bPrintPythonCommands) end
---@param InSkeletalMesh USkeletalMesh
---@param InNameSpace FName
---@param bSelectCurves boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return TArray<FRigElementKey>
function URigHierarchyController:ImportCurvesFromSkeletalMesh(InSkeletalMesh, InNameSpace, bSelectCurves, bSetupUndo, bPrintPythonCommand) end
---@param InSkeleton USkeleton
---@param InNameSpace FName
---@param bSelectCurves boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return TArray<FRigElementKey>
function URigHierarchyController:ImportCurves(InSkeleton, InNameSpace, bSelectCurves, bSetupUndo, bPrintPythonCommand) end
---@param InSkeleton USkeleton
---@param InNameSpace FName
---@param bReplaceExistingBones boolean
---@param bRemoveObsoleteBones boolean
---@param bSelectBones boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return TArray<FRigElementKey>
function URigHierarchyController:ImportBones(InSkeleton, InNameSpace, bReplaceExistingBones, bRemoveObsoleteBones, bSelectBones, bSetupUndo, bPrintPythonCommand) end
---@return URigHierarchy
function URigHierarchyController:GetHierarchy() end
---@param InKey FRigElementKey
---@return FRigControlSettings
function URigHierarchyController:GetControlSettings(InKey) end
---@param InKeys TArray<FRigElementKey>
---@return FString
function URigHierarchyController:ExportToText(InKeys) end
---@return FString
function URigHierarchyController:ExportSelectionToText() end
---@param InKeys TArray<FRigElementKey>
---@param bSelectNewElements boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommands boolean
---@return TArray<FRigElementKey>
function URigHierarchyController:DuplicateElements(InKeys, bSelectNewElements, bSetupUndo, bPrintPythonCommands) end
---@param InKey FRigElementKey
---@return boolean
function URigHierarchyController:DeselectElement(InKey) end
---@return boolean
function URigHierarchyController:ClearSelection() end
---@param InName FName
---@param InParent FRigElementKey
---@param InTransform FTransform
---@param bTransformInGlobal boolean
---@param InColor FLinearColor
---@param InDescription FString
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return FRigElementKey
function URigHierarchyController:AddSocket(InName, InParent, InTransform, bTransformInGlobal, InColor, InDescription, bSetupUndo, bPrintPythonCommand) end
---@param InName FName
---@param InParent FRigElementKey
---@param InSolver FRigPhysicsSolverID
---@param InSettings FRigPhysicsSettings
---@param InLocalTransform FTransform
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return FRigElementKey
function URigHierarchyController:AddPhysicsElement(InName, InParent, InSolver, InSettings, InLocalTransform, bSetupUndo, bPrintPythonCommand) end
---@param InChild FRigElementKey
---@param InParent FRigElementKey
---@param InWeight float
---@param bMaintainGlobalTransform boolean
---@param bSetupUndo boolean
---@return boolean
function URigHierarchyController:AddParent(InChild, InParent, InWeight, bMaintainGlobalTransform, bSetupUndo) end
---@param InName FName
---@param InParent FRigElementKey
---@param InTransform FTransform
---@param bTransformInGlobal boolean
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return FRigElementKey
function URigHierarchyController:AddNull(InName, InParent, InTransform, bTransformInGlobal, bSetupUndo, bPrintPythonCommand) end
---@param InName FName
---@param InValue float
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return FRigElementKey
function URigHierarchyController:AddCurve(InName, InValue, bSetupUndo, bPrintPythonCommand) end
---@param InName FName
---@param InParent FRigElementKey
---@param InSettings FRigControlSettings
---@param InValue FRigControlValue
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return FRigElementKey
function URigHierarchyController:AddControl_ForBlueprint(InName, InParent, InSettings, InValue, bSetupUndo, bPrintPythonCommand) end
---@param InName FName
---@param InSettings FRigConnectorSettings
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return FRigElementKey
function URigHierarchyController:AddConnector(InName, InSettings, bSetupUndo, bPrintPythonCommand) end
---@param InChannel FRigElementKey
---@param InHost FRigElementKey
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:AddChannelHost(InChannel, InHost, bSetupUndo, bPrintPythonCommand) end
---@param InName FName
---@param InParent FRigElementKey
---@param InTransform FTransform
---@param bTransformInGlobal boolean
---@param InBoneType ERigBoneType
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return FRigElementKey
function URigHierarchyController:AddBone(InName, InParent, InTransform, bTransformInGlobal, InBoneType, bSetupUndo, bPrintPythonCommand) end
---@param InControl FRigElementKey
---@param InSpace FRigElementKey
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return boolean
function URigHierarchyController:AddAvailableSpace(InControl, InSpace, bSetupUndo, bPrintPythonCommand) end
---@param InName FName
---@param InParentControl FRigElementKey
---@param InSettings FRigControlSettings
---@param bSetupUndo boolean
---@param bPrintPythonCommand boolean
---@return FRigElementKey
function URigHierarchyController:AddAnimationChannel_ForBlueprint(InName, InParentControl, InSettings, bSetupUndo, bPrintPythonCommand) end


---@class UTransformableControlHandle : UTransformableHandle
---@field ControlRig TSoftObjectPtr<UControlRig>
---@field ControlName FName
local UTransformableControlHandle = {}



