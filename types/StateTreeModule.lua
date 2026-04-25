---@meta

---@class FCompactEventDesc
---@field PayloadStruct UScriptStruct
---@field Tag FGameplayTag
local FCompactEventDesc = {}



---@class FCompactStateTransition
---@field RequiredEvent FCompactEventDesc
---@field ConditionsBegin uint16
---@field State FStateTreeStateHandle
---@field Delay FStateTreeRandomTimeDuration
---@field Trigger EStateTreeTransitionTrigger
---@field Priority EStateTreeTransitionPriority
---@field Fallback EStateTreeSelectionFallback
---@field ConditionsNum uint8
---@field bTransitionEnabled boolean
---@field bConsumeEventOnSelect boolean
local FCompactStateTransition = {}



---@class FCompactStateTreeParameters
---@field Parameters FInstancedPropertyBag
local FCompactStateTreeParameters = {}



---@class FCompactStateTreeState
---@field RequiredEventToEnter FCompactEventDesc
---@field Name FName
---@field Tag FGameplayTag
---@field LinkedAsset UStateTree
---@field LinkedState FStateTreeStateHandle
---@field Parent FStateTreeStateHandle
---@field ChildrenBegin uint16
---@field ChildrenEnd uint16
---@field EnterConditionsBegin uint16
---@field UtilityConsiderationsBegin uint16
---@field TransitionsBegin uint16
---@field TasksBegin uint16
---@field ParameterTemplateIndex FStateTreeIndex16
---@field ParameterDataHandle FStateTreeDataHandle
---@field ParameterBindingsBatch FStateTreeIndex16
---@field EventDataIndex FStateTreeIndex16
---@field EnterConditionsNum uint8
---@field UtilityConsiderationsNum uint8
---@field TransitionsNum uint8
---@field TasksNum uint8
---@field InstanceDataNum uint8
---@field Depth uint8
---@field Type EStateTreeStateType
---@field SelectionBehavior EStateTreeStateSelectionBehavior
---@field bHasTransitionTasks boolean
---@field bHasStateChangeConditions boolean
---@field bCheckPrerequisitesWhenActivatingChildDirectly boolean
---@field Weight float
---@field bEnabled boolean
---@field bConsumeEventOnSelect boolean
local FCompactStateTreeState = {}



---@class FGameplayTagContainerMatchCondition : FStateTreeConditionCommonBase
---@field MatchType EGameplayContainerMatchType
---@field bExactMatch boolean
---@field bInvert boolean
local FGameplayTagContainerMatchCondition = {}



---@class FGameplayTagContainerMatchConditionInstanceData
---@field TagContainer FGameplayTagContainer
---@field OtherContainer FGameplayTagContainer
local FGameplayTagContainerMatchConditionInstanceData = {}



---@class FGameplayTagMatchCondition : FStateTreeConditionCommonBase
---@field bExactMatch boolean
---@field bInvert boolean
local FGameplayTagMatchCondition = {}



---@class FGameplayTagMatchConditionInstanceData
---@field TagContainer FGameplayTagContainer
---@field Tag FGameplayTag
local FGameplayTagMatchConditionInstanceData = {}



---@class FGameplayTagQueryCondition : FStateTreeConditionCommonBase
---@field TagQuery FGameplayTagQuery
---@field bInvert boolean
local FGameplayTagQueryCondition = {}



---@class FGameplayTagQueryConditionInstanceData
---@field TagContainer FGameplayTagContainer
local FGameplayTagQueryConditionInstanceData = {}



---@class FRecordedStateTreeExecutionFrame
---@field StateTree UStateTree
---@field RootState FStateTreeStateHandle
---@field ActiveStates FStateTreeActiveStates
---@field bIsGlobalFrame boolean
local FRecordedStateTreeExecutionFrame = {}



---@class FRecordedStateTreeTransitionResult
---@field NextActiveFrames TArray<FRecordedStateTreeExecutionFrame>
---@field NextActiveFrameEvents TArray<FStateTreeEvent>
---@field SourceState FStateTreeStateHandle
---@field TargetState FStateTreeStateHandle
---@field Priority EStateTreeTransitionPriority
---@field SourceStateTree UStateTree
---@field SourceRootState FStateTreeStateHandle
local FRecordedStateTreeTransitionResult = {}



---@class FStateTreeAbsoluteFloatPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeAbsoluteFloatPropertyFunction = {}


---@class FStateTreeAbsoluteIntPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeAbsoluteIntPropertyFunction = {}


---@class FStateTreeActiveStates
---@field States FStateTreeStateHandle
---@field NumStates uint8
local FStateTreeActiveStates = {}



---@class FStateTreeAddFloatPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeAddFloatPropertyFunction = {}


---@class FStateTreeAddIntPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeAddIntPropertyFunction = {}


---@class FStateTreeAnyEnum
---@field Value uint32
---@field Enum UEnum
local FStateTreeAnyEnum = {}



---@class FStateTreeBindableStructDesc
---@field Struct UStruct
---@field Name FName
---@field DataHandle FStateTreeDataHandle
---@field DataSource EStateTreeBindableStructSource
local FStateTreeBindableStructDesc = {}



---@class FStateTreeBlueprintConditionWrapper : FStateTreeConditionBase
---@field ConditionClass TSubclassOf<UStateTreeConditionBlueprintBase>
local FStateTreeBlueprintConditionWrapper = {}



---@class FStateTreeBlueprintConsiderationWrapper : FStateTreeConsiderationBase
---@field ConsiderationClass TSubclassOf<UStateTreeConsiderationBlueprintBase>
local FStateTreeBlueprintConsiderationWrapper = {}



---@class FStateTreeBlueprintEvaluatorWrapper : FStateTreeEvaluatorBase
---@field EvaluatorClass TSubclassOf<UStateTreeEvaluatorBlueprintBase>
local FStateTreeBlueprintEvaluatorWrapper = {}



---@class FStateTreeBlueprintPropertyRef : FStateTreePropertyRef
---@field RefType EStateTreePropertyRefType
---@field bIsRefToArray boolean
---@field bIsOptional boolean
---@field TypeObject UObject
local FStateTreeBlueprintPropertyRef = {}



---@class FStateTreeBlueprintTaskWrapper : FStateTreeTaskBase
---@field TaskClass TSubclassOf<UStateTreeTaskBlueprintBase>
local FStateTreeBlueprintTaskWrapper = {}



---@class FStateTreeBooleanAndPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeBooleanAndPropertyFunction = {}


---@class FStateTreeBooleanNotOperationPropertyFunctionInstanceData
---@field bInput boolean
---@field bResult boolean
local FStateTreeBooleanNotOperationPropertyFunctionInstanceData = {}



---@class FStateTreeBooleanNotPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeBooleanNotPropertyFunction = {}


---@class FStateTreeBooleanOperationPropertyFunctionInstanceData
---@field bLeft boolean
---@field bRight boolean
---@field bResult boolean
local FStateTreeBooleanOperationPropertyFunctionInstanceData = {}



---@class FStateTreeBooleanOrPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeBooleanOrPropertyFunction = {}


---@class FStateTreeBooleanXOrPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeBooleanXOrPropertyFunction = {}


---@class FStateTreeCompareBoolCondition : FStateTreeConditionCommonBase
---@field bInvert boolean
local FStateTreeCompareBoolCondition = {}



---@class FStateTreeCompareBoolConditionInstanceData
---@field bLeft boolean
---@field bRight boolean
local FStateTreeCompareBoolConditionInstanceData = {}



---@class FStateTreeCompareDistanceCondition : FStateTreeConditionCommonBase
---@field bInvert boolean
---@field Operator EGenericAICheck
local FStateTreeCompareDistanceCondition = {}



---@class FStateTreeCompareDistanceConditionInstanceData
---@field Source FVector
---@field Target FVector
---@field Distance double
local FStateTreeCompareDistanceConditionInstanceData = {}



---@class FStateTreeCompareEnumCondition : FStateTreeConditionCommonBase
---@field bInvert boolean
local FStateTreeCompareEnumCondition = {}



---@class FStateTreeCompareEnumConditionInstanceData
---@field Left FStateTreeAnyEnum
---@field Right FStateTreeAnyEnum
local FStateTreeCompareEnumConditionInstanceData = {}



---@class FStateTreeCompareFloatCondition : FStateTreeConditionCommonBase
---@field bInvert boolean
---@field Operator EGenericAICheck
local FStateTreeCompareFloatCondition = {}



---@class FStateTreeCompareFloatConditionInstanceData
---@field Left double
---@field Right double
local FStateTreeCompareFloatConditionInstanceData = {}



---@class FStateTreeCompareIntCondition : FStateTreeConditionCommonBase
---@field bInvert boolean
---@field Operator EGenericAICheck
local FStateTreeCompareIntCondition = {}



---@class FStateTreeCompareIntConditionInstanceData
---@field Left int32
---@field Right int32
local FStateTreeCompareIntConditionInstanceData = {}



---@class FStateTreeConditionBase : FStateTreeNodeBase
---@field Operand EStateTreeExpressionOperand
---@field DeltaIndent int8
---@field EvaluationMode EStateTreeConditionEvaluationMode
local FStateTreeConditionBase = {}



---@class FStateTreeConditionCommonBase : FStateTreeConditionBase
local FStateTreeConditionCommonBase = {}


---@class FStateTreeConsiderationBase : FStateTreeNodeBase
---@field Operand EStateTreeExpressionOperand
---@field DeltaIndent int8
local FStateTreeConsiderationBase = {}



---@class FStateTreeConsiderationCommonBase : FStateTreeConsiderationBase
local FStateTreeConsiderationCommonBase = {}


---@class FStateTreeConsiderationResponseCurve
---@field CurveInfo FRuntimeFloatCurve
local FStateTreeConsiderationResponseCurve = {}



---@class FStateTreeConstantConsideration : FStateTreeConsiderationCommonBase
local FStateTreeConstantConsideration = {}


---@class FStateTreeConstantConsiderationInstanceData
---@field Constant float
local FStateTreeConstantConsiderationInstanceData = {}



---@class FStateTreeDataHandle
---@field Source EStateTreeDataSourceType
---@field Index uint16
---@field StateHandle FStateTreeStateHandle
local FStateTreeDataHandle = {}



---@class FStateTreeDebugTextTask : FStateTreeTaskCommonBase
---@field Text FString
---@field TextColor FColor
---@field FontScale float
---@field Offset FVector
---@field bEnabled boolean
local FStateTreeDebugTextTask = {}



---@class FStateTreeDebugTextTaskInstanceData
---@field ReferenceActor AActor
local FStateTreeDebugTextTaskInstanceData = {}



---@class FStateTreeDelayTask : FStateTreeTaskCommonBase
local FStateTreeDelayTask = {}


---@class FStateTreeDelayTaskInstanceData
---@field Duration float
---@field RandomDeviation float
---@field bRunForever boolean
local FStateTreeDelayTaskInstanceData = {}



---@class FStateTreeDivideFloatPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeDivideFloatPropertyFunction = {}


---@class FStateTreeDivideIntPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeDivideIntPropertyFunction = {}


---@class FStateTreeEditorPropertyPath
---@field StructID FGuid
---@field Path TArray<FString>
local FStateTreeEditorPropertyPath = {}



---@class FStateTreeEnumInputConsideration : FStateTreeConsiderationCommonBase
---@field EnumValueScorePairs FStateTreeEnumValueScorePairs
local FStateTreeEnumInputConsideration = {}



---@class FStateTreeEnumInputConsiderationInstanceData
---@field Input FStateTreeAnyEnum
local FStateTreeEnumInputConsiderationInstanceData = {}



---@class FStateTreeEnumValueScorePair
---@field EnumValue int64
---@field Score float
local FStateTreeEnumValueScorePair = {}



---@class FStateTreeEnumValueScorePairs
---@field Data TArray<FStateTreeEnumValueScorePair>
local FStateTreeEnumValueScorePairs = {}



---@class FStateTreeEvaluatorBase : FStateTreeNodeBase
local FStateTreeEvaluatorBase = {}


---@class FStateTreeEvaluatorCommonBase : FStateTreeEvaluatorBase
local FStateTreeEvaluatorCommonBase = {}


---@class FStateTreeEvent
---@field Tag FGameplayTag
---@field Payload FInstancedStruct
---@field Origin FName
local FStateTreeEvent = {}



---@class FStateTreeEventQueue
---@field SharedEvents TArray<FStateTreeSharedEvent>
local FStateTreeEventQueue = {}



---@class FStateTreeExecutionFrame
---@field StateTree UStateTree
---@field RootState FStateTreeStateHandle
---@field ActiveStates FStateTreeActiveStates
---@field ExternalDataBaseIndex FStateTreeIndex16
---@field GlobalInstanceIndexBase FStateTreeIndex16
---@field ActiveInstanceIndexBase FStateTreeIndex16
---@field StateParameterDataHandle FStateTreeDataHandle
---@field GlobalParameterDataHandle FStateTreeDataHandle
---@field bIsGlobalFrame boolean
local FStateTreeExecutionFrame = {}



---@class FStateTreeExecutionState
---@field ActiveFrames TArray<FStateTreeExecutionFrame>
---@field DelayedTransitions TArray<FStateTreeTransitionDelayedState>
---@field EnterStateFailedFrameIndex FStateTreeIndex16
---@field EnterStateFailedTaskIndex FStateTreeIndex16
---@field LastTickStatus EStateTreeRunStatus
---@field TreeRunStatus EStateTreeRunStatus
---@field RequestedStop EStateTreeRunStatus
---@field CurrentPhase EStateTreeUpdatePhase
---@field CompletedFrameIndex FStateTreeIndex16
---@field CompletedStateHandle FStateTreeStateHandle
---@field StateChangeCount uint16
---@field RandomStream FRandomStream
local FStateTreeExecutionState = {}



---@class FStateTreeExternalDataDesc
---@field Struct UStruct
---@field Name FName
---@field Handle FStateTreeExternalDataHandle
---@field Requirement EStateTreeExternalDataRequirement
local FStateTreeExternalDataDesc = {}



---@class FStateTreeExternalDataHandle
---@field DataHandle FStateTreeDataHandle
local FStateTreeExternalDataHandle = {}



---@class FStateTreeFloatCombinaisonPropertyFunctionInstanceData
---@field Left float
---@field Right float
---@field Result float
local FStateTreeFloatCombinaisonPropertyFunctionInstanceData = {}



---@class FStateTreeFloatInputConsideration : FStateTreeConsiderationCommonBase
---@field ResponseCurve FStateTreeConsiderationResponseCurve
local FStateTreeFloatInputConsideration = {}



---@class FStateTreeFloatInputConsiderationInstanceData
---@field Input float
---@field Interval FFloatInterval
local FStateTreeFloatInputConsiderationInstanceData = {}



---@class FStateTreeIndex16
---@field Value uint16
local FStateTreeIndex16 = {}



---@class FStateTreeIndex8
---@field Value uint8
local FStateTreeIndex8 = {}



---@class FStateTreeInstanceData
local FStateTreeInstanceData = {}


---@class FStateTreeInstanceObjectWrapper
---@field InstanceObject UObject
local FStateTreeInstanceObjectWrapper = {}



---@class FStateTreeInstanceStorage
---@field InstanceStructs FInstancedStructContainer
---@field ExecutionState FStateTreeExecutionState
---@field TemporaryInstances TArray<FStateTreeTemporaryInstanceData>
---@field TransitionRequests TArray<FStateTreeTransitionRequest>
---@field GlobalParameters FInstancedPropertyBag
local FStateTreeInstanceStorage = {}



---@class FStateTreeIntCombinaisonPropertyFunctionInstanceData
---@field Left int32
---@field Right int32
---@field Result int32
local FStateTreeIntCombinaisonPropertyFunctionInstanceData = {}



---@class FStateTreeInvertFloatPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeInvertFloatPropertyFunction = {}


---@class FStateTreeInvertIntPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeInvertIntPropertyFunction = {}


---@class FStateTreeMakeIntervalPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeMakeIntervalPropertyFunction = {}


---@class FStateTreeMakeIntervalPropertyFunctionInstanceData
---@field Min float
---@field Max float
---@field Result FFloatInterval
local FStateTreeMakeIntervalPropertyFunctionInstanceData = {}



---@class FStateTreeMultiplyFloatPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeMultiplyFloatPropertyFunction = {}


---@class FStateTreeMultiplyIntPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeMultiplyIntPropertyFunction = {}


---@class FStateTreeNodeBase
---@field Name FName
---@field BindingsBatch FStateTreeIndex16
---@field InstanceTemplateIndex FStateTreeIndex16
---@field InstanceDataHandle FStateTreeDataHandle
local FStateTreeNodeBase = {}



---@class FStateTreeNodeIdToIndex
---@field ID FGuid
---@field Index FStateTreeIndex16
local FStateTreeNodeIdToIndex = {}



---@class FStateTreeObjectEqualsCondition : FStateTreeConditionCommonBase
---@field bInvert boolean
local FStateTreeObjectEqualsCondition = {}



---@class FStateTreeObjectEqualsConditionInstanceData
---@field Left UObject
---@field Right UObject
local FStateTreeObjectEqualsConditionInstanceData = {}



---@class FStateTreeObjectIsChildOfClassCondition : FStateTreeConditionCommonBase
---@field bInvert boolean
local FStateTreeObjectIsChildOfClassCondition = {}



---@class FStateTreeObjectIsChildOfClassConditionInstanceData
---@field Object UObject
---@field Class UClass
local FStateTreeObjectIsChildOfClassConditionInstanceData = {}



---@class FStateTreeObjectIsValidCondition : FStateTreeConditionCommonBase
---@field bInvert boolean
local FStateTreeObjectIsValidCondition = {}



---@class FStateTreeObjectIsValidConditionInstanceData
---@field Object UObject
local FStateTreeObjectIsValidConditionInstanceData = {}



---@class FStateTreePropertyAccess
---@field SourceIndirection FStateTreePropertyIndirection
---@field SourceStructType UStruct
---@field SourceDataHandle FStateTreeDataHandle
local FStateTreePropertyAccess = {}



---@class FStateTreePropertyBinding
---@field SourcePath FStateTreePropertySegment
---@field TargetPath FStateTreePropertySegment
---@field SourceStructIndex FStateTreeIndex16
---@field CopyType EStateTreePropertyCopyType
local FStateTreePropertyBinding = {}



---@class FStateTreePropertyBindings
---@field SourceStructs TArray<FStateTreeBindableStructDesc>
---@field CopyBatches TArray<FStateTreePropertyCopyBatch>
---@field PropertyPathBindings TArray<FStateTreePropertyPathBinding>
---@field PropertyCopies TArray<FStateTreePropertyCopy>
---@field PropertyReferencePaths TArray<FStateTreePropertyRefPath>
---@field PropertyAccesses TArray<FStateTreePropertyAccess>
---@field PropertyIndirections TArray<FStateTreePropertyIndirection>
local FStateTreePropertyBindings = {}



---@class FStateTreePropertyCopy
---@field SourceIndirection FStateTreePropertyIndirection
---@field TargetIndirection FStateTreePropertyIndirection
---@field SourceStructType UStruct
---@field CopySize int32
---@field SourceDataHandle FStateTreeDataHandle
---@field Type EStateTreePropertyCopyType
---@field SourceStructIndex FStateTreeIndex16
local FStateTreePropertyCopy = {}



---@class FStateTreePropertyCopyBatch
---@field TargetStruct FStateTreeBindableStructDesc
---@field BindingsBegin FStateTreeIndex16
---@field BindingsEnd FStateTreeIndex16
---@field PropertyFunctionsBegin FStateTreeIndex16
---@field PropertyFunctionsEnd FStateTreeIndex16
local FStateTreePropertyCopyBatch = {}



---@class FStateTreePropertyFunctionBase : FStateTreeNodeBase
local FStateTreePropertyFunctionBase = {}


---@class FStateTreePropertyFunctionCommonBase : FStateTreePropertyFunctionBase
local FStateTreePropertyFunctionCommonBase = {}


---@class FStateTreePropertyIndirection
---@field ArrayIndex FStateTreeIndex16
---@field Offset uint16
---@field NextIndex FStateTreeIndex16
---@field Type EStateTreePropertyAccessType
---@field InstanceStruct UStruct
local FStateTreePropertyIndirection = {}



---@class FStateTreePropertyPath
---@field Segments TArray<FStateTreePropertyPathSegment>
local FStateTreePropertyPath = {}



---@class FStateTreePropertyPathBinding
---@field SourcePropertyPath FStateTreePropertyPath
---@field TargetPropertyPath FStateTreePropertyPath
---@field SourceDataHandle FStateTreeDataHandle
local FStateTreePropertyPathBinding = {}



---@class FStateTreePropertyPathSegment
---@field Name FName
---@field ArrayIndex int32
---@field InstanceStruct UStruct
local FStateTreePropertyPathSegment = {}



---@class FStateTreePropertyRef
---@field RefAccessIndex FStateTreeIndex16
local FStateTreePropertyRef = {}



---@class FStateTreePropertyRefPath
---@field SourcePropertyPath FStateTreePropertyPath
---@field SourceDataHandle FStateTreeDataHandle
local FStateTreePropertyRefPath = {}



---@class FStateTreePropertySegment
---@field Name FName
---@field ArrayIndex FStateTreeIndex16
---@field NextIndex FStateTreeIndex16
---@field Type EStateTreePropertyAccessType
local FStateTreePropertySegment = {}



---@class FStateTreeRandomCondition : FStateTreeConditionCommonBase
local FStateTreeRandomCondition = {}


---@class FStateTreeRandomConditionInstanceData
---@field Threshold float
local FStateTreeRandomConditionInstanceData = {}



---@class FStateTreeRandomTimeDuration
---@field Duration uint16
---@field RandomVariance uint16
local FStateTreeRandomTimeDuration = {}



---@class FStateTreeReference
---@field StateTree UStateTree
---@field Parameters FInstancedPropertyBag
---@field PropertyOverrides TArray<FGuid>
local FStateTreeReference = {}



---@class FStateTreeReferenceOverrideItem
---@field StateTag FGameplayTag
---@field StateTreeReference FStateTreeReference
local FStateTreeReferenceOverrideItem = {}



---@class FStateTreeReferenceOverrides
---@field OverrideItems TArray<FStateTreeReferenceOverrideItem>
local FStateTreeReferenceOverrides = {}



---@class FStateTreeRunParallelStateTreeTask : FStateTreeTaskCommonBase
---@field StateTreeOverrideTag FGameplayTag
local FStateTreeRunParallelStateTreeTask = {}



---@class FStateTreeRunParallelStateTreeTaskInstanceData
---@field StateTree FStateTreeReference
---@field TreeInstanceData FStateTreeInstanceData
---@field RunningStateTree UStateTree
local FStateTreeRunParallelStateTreeTaskInstanceData = {}



---@class FStateTreeSharedEvent
local FStateTreeSharedEvent = {}


---@class FStateTreeSingleFloatPropertyFunctionInstanceData
---@field Input float
---@field Result float
local FStateTreeSingleFloatPropertyFunctionInstanceData = {}



---@class FStateTreeSingleIntPropertyFunctionInstanceData
---@field Input int32
---@field Result int32
local FStateTreeSingleIntPropertyFunctionInstanceData = {}



---@class FStateTreeStateHandle
---@field Index uint16
local FStateTreeStateHandle = {}



---@class FStateTreeStateIdToHandle
---@field ID FGuid
---@field Handle FStateTreeStateHandle
local FStateTreeStateIdToHandle = {}



---@class FStateTreeStateLink
---@field StateHandle FStateTreeStateHandle
local FStateTreeStateLink = {}



---@class FStateTreeStructRef
local FStateTreeStructRef = {}


---@class FStateTreeSubtractFloatPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeSubtractFloatPropertyFunction = {}


---@class FStateTreeSubtractIntPropertyFunction : FStateTreePropertyFunctionCommonBase
local FStateTreeSubtractIntPropertyFunction = {}


---@class FStateTreeTaskBase : FStateTreeNodeBase
---@field bTaskEnabled boolean
---@field TransitionHandlingPriority EStateTreeTransitionPriority
local FStateTreeTaskBase = {}



---@class FStateTreeTaskCommonBase : FStateTreeTaskBase
local FStateTreeTaskCommonBase = {}


---@class FStateTreeTemporaryInstanceData
---@field StateTree UStateTree
---@field RootState FStateTreeStateHandle
---@field DataHandle FStateTreeDataHandle
---@field OwnerNodeIndex FStateTreeIndex16
---@field Instance FInstancedStruct
local FStateTreeTemporaryInstanceData = {}



---@class FStateTreeTransitionDelayedState
---@field StateTree UStateTree
---@field TransitionIndex FStateTreeIndex16
---@field TimeLeft float
---@field CapturedEvent FStateTreeSharedEvent
---@field CapturedEventHash uint32
local FStateTreeTransitionDelayedState = {}



---@class FStateTreeTransitionIdToIndex
---@field ID FGuid
---@field Index FStateTreeIndex16
local FStateTreeTransitionIdToIndex = {}



---@class FStateTreeTransitionRequest
---@field SourceState FStateTreeStateHandle
---@field SourceStateTree UStateTree
---@field SourceRootState FStateTreeStateHandle
---@field TargetState FStateTreeStateHandle
---@field Priority EStateTreeTransitionPriority
local FStateTreeTransitionRequest = {}



---@class FStateTreeTransitionResult
---@field NextActiveFrames TArray<FStateTreeExecutionFrame>
---@field CurrentRunStatus EStateTreeRunStatus
---@field SourceState FStateTreeStateHandle
---@field TargetState FStateTreeStateHandle
---@field CurrentState FStateTreeStateHandle
---@field ChangeType EStateTreeStateChangeType
---@field Priority EStateTreeTransitionPriority
---@field SourceStateTree UStateTree
---@field SourceRootState FStateTreeStateHandle
local FStateTreeTransitionResult = {}



---@class FStateTreeTransitionSource
local FStateTreeTransitionSource = {}


---@class IStateTreeSchemaProvider : IInterface
local IStateTreeSchemaProvider = {}


---@class UStateTree : UDataAsset
---@field LastCompiledEditorDataHash uint32
---@field Schema UStateTreeSchema
---@field States TArray<FCompactStateTreeState>
---@field Transitions TArray<FCompactStateTransition>
---@field Nodes FInstancedStructContainer
---@field DefaultInstanceData FStateTreeInstanceData
---@field SharedInstanceData FStateTreeInstanceData
---@field ContextDataDescs TArray<FStateTreeExternalDataDesc>
---@field PropertyBindings FStateTreePropertyBindings
---@field IDToStateMappings TArray<FStateTreeStateIdToHandle>
---@field IDToNodeMappings TArray<FStateTreeNodeIdToIndex>
---@field IDToTransitionMappings TArray<FStateTreeTransitionIdToIndex>
---@field Parameters FInstancedPropertyBag
---@field NumContextData uint16
---@field NumGlobalInstanceData uint16
---@field EvaluatorsBegin uint16
---@field EvaluatorsNum uint16
---@field GlobalTasksBegin uint16
---@field GlobalTasksNum uint16
---@field bHasGlobalTransitionTasks boolean
---@field ExternalDataDescs TArray<FStateTreeExternalDataDesc>
local UStateTree = {}



---@class UStateTreeConditionBlueprintBase : UStateTreeNodeBlueprintBase
local UStateTreeConditionBlueprintBase = {}

---@return boolean
function UStateTreeConditionBlueprintBase:ReceiveTestCondition() end


---@class UStateTreeConsiderationBlueprintBase : UStateTreeNodeBlueprintBase
local UStateTreeConsiderationBlueprintBase = {}

---@return float
function UStateTreeConsiderationBlueprintBase:ReceiveGetScore() end


---@class UStateTreeEvaluatorBlueprintBase : UStateTreeNodeBlueprintBase
local UStateTreeEvaluatorBlueprintBase = {}

function UStateTreeEvaluatorBlueprintBase:ReceiveTreeStop() end
function UStateTreeEvaluatorBlueprintBase:ReceiveTreeStart() end
---@param DeltaTime float
function UStateTreeEvaluatorBlueprintBase:ReceiveTick(DeltaTime) end


---@class UStateTreeNodeBlueprintBase : UObject
---@field CachedOwner UObject
---@field CachedFrameStateTree UStateTree
local UStateTreeNodeBlueprintBase = {}

---@param Event FStateTreeEvent
function UStateTreeNodeBlueprintBase:SendEvent(Event) end
---@param TargetState FStateTreeStateLink
---@param Priority EStateTreeTransitionPriority
function UStateTreeNodeBlueprintBase:RequestTransition(TargetState, Priority) end
---@param Formatting EStateTreeNodeFormatting
---@return FText
function UStateTreeNodeBlueprintBase:ReceiveGetDescription(Formatting) end
---@param PropertyRef FStateTreeBlueprintPropertyRef
---@return boolean
function UStateTreeNodeBlueprintBase:IsPropertyRefValid(PropertyRef) end
---@param PropertyRef FStateTreeBlueprintPropertyRef
function UStateTreeNodeBlueprintBase:GetPropertyReference(PropertyRef) end
---@param PropertyName FName
---@return FText
function UStateTreeNodeBlueprintBase:GetPropertyDescriptionByPropertyName(PropertyName) end


---@class UStateTreeSchema : UObject
local UStateTreeSchema = {}


---@class UStateTreeSettings : UDeveloperSettings
---@field bAutoStartDebuggerTracesOnNonEditorTargets boolean
local UStateTreeSettings = {}



---@class UStateTreeTaskBlueprintBase : UStateTreeNodeBlueprintBase
---@field bShouldStateChangeOnReselect boolean
---@field bShouldCallTickOnlyOnEvents boolean
---@field bShouldCopyBoundPropertiesOnTick boolean
---@field bShouldCopyBoundPropertiesOnExitState boolean
local UStateTreeTaskBlueprintBase = {}

---@param DeltaTime float
---@return EStateTreeRunStatus
function UStateTreeTaskBlueprintBase:ReceiveTick(DeltaTime) end
---@param CompletionStatus EStateTreeRunStatus
---@param CompletedActiveStates FStateTreeActiveStates
function UStateTreeTaskBlueprintBase:ReceiveStateCompleted(CompletionStatus, CompletedActiveStates) end
---@param DeltaTime float
function UStateTreeTaskBlueprintBase:ReceiveLatentTick(DeltaTime) end
---@param Transition FStateTreeTransitionResult
function UStateTreeTaskBlueprintBase:ReceiveLatentEnterState(Transition) end
---@param Transition FStateTreeTransitionResult
function UStateTreeTaskBlueprintBase:ReceiveExitState(Transition) end
---@param Transition FStateTreeTransitionResult
---@return EStateTreeRunStatus
function UStateTreeTaskBlueprintBase:ReceiveEnterState(Transition) end
---@param bSucceeded boolean
function UStateTreeTaskBlueprintBase:FinishTask(bSucceeded) end


