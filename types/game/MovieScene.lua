---@meta

---@class FActorForWorldTransforms
---@field Actor TWeakObjectPtr<AActor>
---@field Component TWeakObjectPtr<USceneComponent>
---@field SocketName FName
local FActorForWorldTransforms = {}



---@class FEasingComponentData
---@field Section UMovieSceneSection
local FEasingComponentData = {}



---@class FGeneratedMovieSceneKeyStruct
local FGeneratedMovieSceneKeyStruct = {}


---@class FMovieSceneAudioTriggerChannel : FMovieSceneChannel
---@field Times TArray<FFrameNumber>
---@field Values TArray<boolean>
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneAudioTriggerChannel = {}



---@class FMovieSceneBinding
---@field ObjectGuid FGuid
---@field BindingName FString
---@field Tracks TArray<UMovieSceneTrack>
local FMovieSceneBinding = {}



---@class FMovieSceneBindingOverrideData
---@field ObjectBindingID FMovieSceneObjectBindingID
---@field Object TSoftObjectPtr<UObject>
---@field bOverridesDefault boolean
local FMovieSceneBindingOverrideData = {}



---@class FMovieSceneBindingProxy
---@field BindingID FGuid
---@field Sequence UMovieSceneSequence
local FMovieSceneBindingProxy = {}



---@class FMovieSceneBindingReference
---@field ID FGuid
---@field Locator FUniversalObjectLocator
---@field ResolveFlags ELocatorResolveFlags
---@field CustomBinding UMovieSceneCustomBinding
local FMovieSceneBindingReference = {}



---@class FMovieSceneBindingReferences
---@field SortedReferences TArray<FMovieSceneBindingReference>
local FMovieSceneBindingReferences = {}



---@class FMovieSceneBindingResolveContext
---@field WorldContext UObject
---@field Binding FMovieSceneBindingProxy
local FMovieSceneBindingResolveContext = {}



---@class FMovieSceneBindingResolveParams
---@field Sequence UMovieSceneSequence
---@field ObjectBindingID FGuid
---@field SequenceID FMovieSceneSequenceID
---@field Context UObject
local FMovieSceneBindingResolveParams = {}



---@class FMovieSceneBindingResolveResult
---@field Object UObject
local FMovieSceneBindingResolveResult = {}



---@class FMovieSceneBoolChannel : FMovieSceneChannel
---@field PreInfinityExtrap ERichCurveExtrapolation
---@field PostInfinityExtrap ERichCurveExtrapolation
---@field Times TArray<FFrameNumber>
---@field DefaultValue boolean
---@field bHasDefaultValue boolean
---@field Values TArray<boolean>
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneBoolChannel = {}



---@class FMovieSceneByteChannel : FMovieSceneChannel
---@field PreInfinityExtrap ERichCurveExtrapolation
---@field PostInfinityExtrap ERichCurveExtrapolation
---@field Times TArray<FFrameNumber>
---@field DefaultValue uint8
---@field bHasDefaultValue boolean
---@field Values TArray<uint8>
---@field Enum UEnum
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneByteChannel = {}



---@class FMovieSceneChannel
local FMovieSceneChannel = {}


---@class FMovieSceneCompiledSequenceFlagStruct
---@field bParentSequenceRequiresLowerFence boolean
---@field bParentSequenceRequiresUpperFence boolean
local FMovieSceneCompiledSequenceFlagStruct = {}



---@class FMovieSceneConditionContainer
---@field Condition UMovieSceneCondition
local FMovieSceneConditionContainer = {}



---@class FMovieSceneConditionContext
---@field WorldContext UObject
---@field Binding FMovieSceneBindingProxy
---@field BoundObjects TArray<UObject>
local FMovieSceneConditionContext = {}



---@class FMovieSceneCustomTimeWarpGetterStruct
---@field Object UMovieSceneTimeWarpGetter
local FMovieSceneCustomTimeWarpGetterStruct = {}



---@class FMovieSceneDeterminismData
---@field Fences TArray<FMovieSceneDeterminismFence>
---@field bParentSequenceRequiresLowerFence boolean
---@field bParentSequenceRequiresUpperFence boolean
local FMovieSceneDeterminismData = {}



---@class FMovieSceneDeterminismFence
---@field FrameNumber FFrameNumber
---@field bInclusive boolean
local FMovieSceneDeterminismFence = {}



---@class FMovieSceneDoubleChannel : FMovieSceneChannel
---@field PreInfinityExtrap ERichCurveExtrapolation
---@field PostInfinityExtrap ERichCurveExtrapolation
---@field Times TArray<FFrameNumber>
---@field Values TArray<FMovieSceneDoubleValue>
---@field DefaultValue double
---@field bHasDefaultValue boolean
---@field KeyHandles FMovieSceneKeyHandleMap
---@field TickResolution FFrameRate
local FMovieSceneDoubleChannel = {}



---@class FMovieSceneDoubleValue
---@field Value double
---@field Tangent FMovieSceneTangentData
---@field InterpMode ERichCurveInterpMode
---@field TangentMode ERichCurveTangentMode
---@field PaddingByte uint8
local FMovieSceneDoubleValue = {}



---@class FMovieSceneDynamicBinding
---@field Function UFunction
---@field ResolveParamsProperty TFieldPath<FProperty>
local FMovieSceneDynamicBinding = {}



---@class FMovieSceneDynamicBindingContainer
---@field DynamicBinding FMovieSceneDynamicBinding
local FMovieSceneDynamicBindingContainer = {}



---@class FMovieSceneDynamicBindingPayloadVariable
---@field ObjectValue FSoftObjectPath
---@field Value FString
local FMovieSceneDynamicBindingPayloadVariable = {}



---@class FMovieSceneDynamicBindingResolveParams
---@field Sequence UMovieSceneSequence
---@field ObjectBindingID FGuid
---@field RootSequence UMovieSceneSequence
local FMovieSceneDynamicBindingResolveParams = {}



---@class FMovieSceneDynamicBindingResolveResult
---@field Object UObject
---@field bIsPossessedObject boolean
local FMovieSceneDynamicBindingResolveResult = {}



---@class FMovieSceneEasingSettings
---@field AutoEaseInDuration int32
---@field AutoEaseOutDuration int32
---@field EaseIn TScriptInterface<IMovieSceneEasingFunction>
---@field bManualEaseIn boolean
---@field ManualEaseInDuration int32
---@field EaseOut TScriptInterface<IMovieSceneEasingFunction>
---@field bManualEaseOut boolean
---@field ManualEaseOutDuration int32
local FMovieSceneEasingSettings = {}



---@class FMovieSceneEditorData
---@field ExpansionStates TMap<FString, FMovieSceneExpansionState>
---@field PinnedNodes TArray<FString>
---@field ViewStart double
---@field ViewEnd double
---@field WorkStart double
---@field WorkEnd double
---@field MarkedFrames TSet<FFrameNumber>
---@field WorkingRange FFloatRange
---@field ViewRange FFloatRange
local FMovieSceneEditorData = {}



---@class FMovieSceneEmptyStruct
local FMovieSceneEmptyStruct = {}


---@class FMovieSceneEntityComponentField
---@field PersistentEntityTree FMovieSceneEvaluationFieldEntityTree
---@field OneShotEntityTree FMovieSceneEvaluationFieldEntityTree
---@field Entities TArray<FMovieSceneEvaluationFieldEntity>
---@field EntityMetaData TArray<FMovieSceneEvaluationFieldEntityMetaData>
---@field SharedMetaData TArray<FMovieSceneEvaluationFieldSharedEntityMetaData>
local FMovieSceneEntityComponentField = {}



---@class FMovieSceneEntitySystemGraph
---@field Nodes FMovieSceneEntitySystemGraphNodes
local FMovieSceneEntitySystemGraph = {}



---@class FMovieSceneEntitySystemGraphNode
---@field System UMovieSceneEntitySystem
local FMovieSceneEntitySystemGraphNode = {}



---@class FMovieSceneEntitySystemGraphNodes
local FMovieSceneEntitySystemGraphNodes = {}


---@class FMovieSceneEvalTemplate : FMovieSceneEvalTemplateBase
---@field CompletionMode EMovieSceneCompletionMode
---@field SourceSectionPtr TWeakObjectPtr<UMovieSceneSection>
local FMovieSceneEvalTemplate = {}



---@class FMovieSceneEvalTemplateBase
local FMovieSceneEvalTemplateBase = {}


---@class FMovieSceneEvalTemplatePtr
local FMovieSceneEvalTemplatePtr = {}


---@class FMovieSceneEvaluationField
---@field Ranges TArray<FMovieSceneFrameRange>
---@field Groups TArray<FMovieSceneEvaluationGroup>
---@field MetaData TArray<FMovieSceneEvaluationMetaData>
local FMovieSceneEvaluationField = {}



---@class FMovieSceneEvaluationFieldEntity
---@field Key FMovieSceneEvaluationFieldEntityKey
---@field SharedMetaDataIndex int32
local FMovieSceneEvaluationFieldEntity = {}



---@class FMovieSceneEvaluationFieldEntityKey
---@field EntityOwner TWeakObjectPtr<UObject>
---@field EntityID uint32
local FMovieSceneEvaluationFieldEntityKey = {}



---@class FMovieSceneEvaluationFieldEntityMetaData
---@field Condition TSoftObjectPtr<UMovieSceneCondition>
---@field OverrideBoundPropertyPath FString
---@field ForcedTime FFrameNumber
---@field Flags ESectionEvaluationFlags
---@field bEvaluateInSequencePreRoll boolean
---@field bEvaluateInSequencePostRoll boolean
local FMovieSceneEvaluationFieldEntityMetaData = {}



---@class FMovieSceneEvaluationFieldEntityTree
local FMovieSceneEvaluationFieldEntityTree = {}


---@class FMovieSceneEvaluationFieldSegmentPtr : FMovieSceneEvaluationFieldTrackPtr
---@field SegmentID FMovieSceneSegmentIdentifier
local FMovieSceneEvaluationFieldSegmentPtr = {}



---@class FMovieSceneEvaluationFieldSharedEntityMetaData
---@field ObjectBindingID FGuid
local FMovieSceneEvaluationFieldSharedEntityMetaData = {}



---@class FMovieSceneEvaluationFieldTrackPtr
---@field SequenceID FMovieSceneSequenceID
---@field TrackIdentifier FMovieSceneTrackIdentifier
local FMovieSceneEvaluationFieldTrackPtr = {}



---@class FMovieSceneEvaluationGroup
---@field LUTIndices TArray<FMovieSceneEvaluationGroupLUTIndex>
---@field TrackLUT TArray<FMovieSceneFieldEntry_EvaluationTrack>
---@field SectionLUT TArray<FMovieSceneFieldEntry_ChildTemplate>
local FMovieSceneEvaluationGroup = {}



---@class FMovieSceneEvaluationGroupLUTIndex
---@field NumInitPtrs int32
---@field NumEvalPtrs int32
local FMovieSceneEvaluationGroupLUTIndex = {}



---@class FMovieSceneEvaluationHookComponent
---@field Interface TScriptInterface<IMovieSceneEvaluationHook>
local FMovieSceneEvaluationHookComponent = {}



---@class FMovieSceneEvaluationHookEvent
---@field Hook FMovieSceneEvaluationHookComponent
local FMovieSceneEvaluationHookEvent = {}



---@class FMovieSceneEvaluationHookEventContainer
---@field Events TArray<FMovieSceneEvaluationHookEvent>
local FMovieSceneEvaluationHookEventContainer = {}



---@class FMovieSceneEvaluationInstanceKey
local FMovieSceneEvaluationInstanceKey = {}


---@class FMovieSceneEvaluationKey
---@field SequenceID FMovieSceneSequenceID
---@field TrackIdentifier FMovieSceneTrackIdentifier
---@field SectionIndex uint32
local FMovieSceneEvaluationKey = {}



---@class FMovieSceneEvaluationMetaData
---@field ActiveSequences TArray<FMovieSceneSequenceID>
---@field ActiveEntities TArray<FMovieSceneOrderedEvaluationKey>
local FMovieSceneEvaluationMetaData = {}



---@class FMovieSceneEvaluationOperand
---@field ObjectBindingID FGuid
---@field SequenceID FMovieSceneSequenceID
local FMovieSceneEvaluationOperand = {}



---@class FMovieSceneEvaluationTemplate
---@field Tracks TMap<FMovieSceneTrackIdentifier, FMovieSceneEvaluationTrack>
---@field SequenceSignature FGuid
---@field TemplateSerialNumber FMovieSceneEvaluationTemplateSerialNumber
---@field TemplateLedger FMovieSceneTemplateGenerationLedger
local FMovieSceneEvaluationTemplate = {}



---@class FMovieSceneEvaluationTemplateSerialNumber
---@field Value uint32
local FMovieSceneEvaluationTemplateSerialNumber = {}



---@class FMovieSceneEvaluationTrack
---@field ObjectBindingID FGuid
---@field EvaluationPriority uint16
---@field EvaluationMethod EEvaluationMethod
---@field SourceTrack TWeakObjectPtr<UMovieSceneTrack>
---@field ChildTemplates TArray<FMovieSceneEvalTemplatePtr>
---@field TrackTemplate FMovieSceneTrackImplementationPtr
---@field EvaluationGroup FName
---@field bEvaluateInPreroll boolean
---@field bEvaluateInPostroll boolean
---@field bTearDownPriority boolean
local FMovieSceneEvaluationTrack = {}



---@class FMovieSceneExpansionState
---@field bExpanded boolean
local FMovieSceneExpansionState = {}



---@class FMovieSceneFieldEntry_ChildTemplate
---@field ChildIndex uint16
---@field Flags ESectionEvaluationFlags
---@field ForcedTime FFrameNumber
local FMovieSceneFieldEntry_ChildTemplate = {}



---@class FMovieSceneFieldEntry_EvaluationTrack
---@field TrackPtr FMovieSceneEvaluationFieldTrackPtr
---@field NumChildren uint16
local FMovieSceneFieldEntry_EvaluationTrack = {}



---@class FMovieSceneFixedPlayRateStruct
---@field PlayRate double
local FMovieSceneFixedPlayRateStruct = {}



---@class FMovieSceneFloatChannel : FMovieSceneChannel
---@field PreInfinityExtrap ERichCurveExtrapolation
---@field PostInfinityExtrap ERichCurveExtrapolation
---@field Times TArray<FFrameNumber>
---@field Values TArray<FMovieSceneFloatValue>
---@field DefaultValue float
---@field bHasDefaultValue boolean
---@field KeyHandles FMovieSceneKeyHandleMap
---@field TickResolution FFrameRate
local FMovieSceneFloatChannel = {}



---@class FMovieSceneFloatValue
---@field Value float
---@field Tangent FMovieSceneTangentData
---@field InterpMode ERichCurveInterpMode
---@field TangentMode ERichCurveTangentMode
---@field PaddingByte uint8
local FMovieSceneFloatValue = {}



---@class FMovieSceneFrameRange
local FMovieSceneFrameRange = {}


---@class FMovieSceneIntegerChannel : FMovieSceneChannel
---@field PreInfinityExtrap ERichCurveExtrapolation
---@field PostInfinityExtrap ERichCurveExtrapolation
---@field bInterpolateLinearKeys boolean
---@field Times TArray<FFrameNumber>
---@field DefaultValue int32
---@field bHasDefaultValue boolean
---@field Values TArray<int32>
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneIntegerChannel = {}



---@class FMovieSceneInverseNestedSequenceTransform
---@field TimeScale FMovieSceneTimeWarpVariant
---@field Offset FFrameTime
local FMovieSceneInverseNestedSequenceTransform = {}



---@class FMovieSceneInverseSequenceTransform
---@field LinearTransform FMovieSceneTimeTransform
---@field NestedTransforms TArray<FMovieSceneInverseNestedSequenceTransform>
local FMovieSceneInverseSequenceTransform = {}



---@class FMovieSceneKeyHandleMap : FKeyHandleLookupTable
local FMovieSceneKeyHandleMap = {}


---@class FMovieSceneKeyStruct
local FMovieSceneKeyStruct = {}


---@class FMovieSceneKeyTimeStruct : FMovieSceneKeyStruct
---@field Time FFrameNumber
local FMovieSceneKeyTimeStruct = {}



---@class FMovieSceneMarkedFrame
---@field FrameNumber FFrameNumber
---@field Label FString
---@field bIsDeterminismFence boolean
---@field bIsInclusiveTime boolean
local FMovieSceneMarkedFrame = {}



---@class FMovieSceneNestedSequenceTransform
---@field TimeScale FMovieSceneTimeWarpVariant
---@field Offset FFrameTime
local FMovieSceneNestedSequenceTransform = {}



---@class FMovieSceneNumericVariant
local FMovieSceneNumericVariant = {}


---@class FMovieSceneObjectBindingID
---@field Guid FGuid
---@field SequenceID int32
---@field ResolveParentIndex int32
local FMovieSceneObjectBindingID = {}



---@class FMovieSceneObjectBindingIDs
---@field Ids TArray<FMovieSceneObjectBindingID>
local FMovieSceneObjectBindingIDs = {}



---@class FMovieSceneObjectPathChannel : FMovieSceneChannel
---@field PropertyClass UClass
---@field Times TArray<FFrameNumber>
---@field Values TArray<FMovieSceneObjectPathChannelKeyValue>
---@field DefaultValue FMovieSceneObjectPathChannelKeyValue
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneObjectPathChannel = {}



---@class FMovieSceneObjectPathChannelKeyValue
---@field SoftPtr TSoftObjectPtr<UObject>
---@field HardPtr UObject
local FMovieSceneObjectPathChannelKeyValue = {}



---@class FMovieSceneOrderedEvaluationKey
---@field Key FMovieSceneEvaluationKey
---@field SetupIndex uint16
---@field TearDownIndex uint16
local FMovieSceneOrderedEvaluationKey = {}



---@class FMovieScenePossessable
---@field Tags TArray<FName>
---@field DynamicBinding FMovieSceneDynamicBinding
---@field Guid FGuid
---@field Name FString
---@field ParentGuid FGuid
---@field SpawnableObjectBindingID FMovieSceneObjectBindingID
local FMovieScenePossessable = {}



---@class FMovieScenePropertyBinding
---@field PropertyName FName
---@field PropertyPath FName
---@field bCanUseClassLookup boolean
local FMovieScenePropertyBinding = {}



---@class FMovieScenePropertySectionData
---@field PropertyName FName
---@field PropertyPath FString
local FMovieScenePropertySectionData = {}



---@class FMovieScenePropertySectionTemplate : FMovieSceneEvalTemplate
---@field PropertyData FMovieScenePropertySectionData
local FMovieScenePropertySectionTemplate = {}



---@class FMovieSceneRootEvaluationTemplateInstance
---@field EntitySystemLinker UMovieSceneEntitySystemLinker
local FMovieSceneRootEvaluationTemplateInstance = {}



---@class FMovieSceneSectionEvalOptions
---@field bCanEditCompletionMode boolean
---@field CompletionMode EMovieSceneCompletionMode
local FMovieSceneSectionEvalOptions = {}



---@class FMovieSceneSectionGroup
---@field Sections TArray<TWeakObjectPtr<UMovieSceneSection>>
local FMovieSceneSectionGroup = {}



---@class FMovieSceneSectionParameters
---@field StartFrameOffset FFrameNumber
---@field bCanLoop boolean
---@field EndFrameOffset FFrameNumber
---@field FirstLoopStartFrameOffset FFrameNumber
---@field TimeScale FMovieSceneTimeWarpVariant
---@field HierarchicalBias int32
---@field Flags EMovieSceneSubSectionFlags
---@field StartOffset float
---@field PrerollTime float
---@field PostrollTime float
local FMovieSceneSectionParameters = {}



---@class FMovieSceneSectionTimingParametersFrames
---@field PlayRate FMovieSceneTimeWarpVariant
---@field InnerStartOffset FFrameNumber
---@field InnerEndOffset FFrameNumber
---@field FirstLoopStartOffset FFrameNumber
---@field bLoop boolean
---@field bClamp boolean
---@field bReverse boolean
local FMovieSceneSectionTimingParametersFrames = {}



---@class FMovieSceneSectionTimingParametersSeconds
---@field PlayRate FMovieSceneTimeWarpVariant
---@field InnerStartOffset float
---@field InnerEndOffset float
---@field FirstLoopStartOffset float
---@field bLoop boolean
---@field bClamp boolean
---@field bReverse boolean
local FMovieSceneSectionTimingParametersSeconds = {}



---@class FMovieSceneSegment
local FMovieSceneSegment = {}


---@class FMovieSceneSegmentIdentifier
---@field IdentifierIndex int32
local FMovieSceneSegmentIdentifier = {}



---@class FMovieSceneSequenceHierarchy
---@field RootNode FMovieSceneSequenceHierarchyNode
---@field Tree FMovieSceneSubSequenceTree
---@field RootTransform FMovieSceneSequenceTransform
---@field SubSequences TMap<FMovieSceneSequenceID, FMovieSceneSubSequenceData>
---@field Hierarchy TMap<FMovieSceneSequenceID, FMovieSceneSequenceHierarchyNode>
---@field AccumulatedNetworkMask EMovieSceneServerClientMask
local FMovieSceneSequenceHierarchy = {}



---@class FMovieSceneSequenceHierarchyNode
---@field ParentID FMovieSceneSequenceID
---@field Children TArray<FMovieSceneSequenceID>
local FMovieSceneSequenceHierarchyNode = {}



---@class FMovieSceneSequenceID
---@field Value uint32
local FMovieSceneSequenceID = {}



---@class FMovieSceneSequenceInstanceData
local FMovieSceneSequenceInstanceData = {}


---@class FMovieSceneSequenceInstanceDataPtr
local FMovieSceneSequenceInstanceDataPtr = {}


---@class FMovieSceneSequenceLoopCount
---@field Value int32
local FMovieSceneSequenceLoopCount = {}



---@class FMovieSceneSequencePlayToParams
---@field bExclusive boolean
local FMovieSceneSequencePlayToParams = {}



---@class FMovieSceneSequencePlaybackParams
---@field Frame FFrameTime
---@field Time float
---@field MarkedFrame FString
---@field Timecode FTimecode
---@field PositionType EMovieScenePositionType
---@field UpdateMethod EUpdatePositionMethod
---@field bHasJumped boolean
local FMovieSceneSequencePlaybackParams = {}



---@class FMovieSceneSequencePlaybackSettings
---@field bAutoPlay boolean
---@field LoopCount FMovieSceneSequenceLoopCount
---@field TickInterval FMovieSceneSequenceTickInterval
---@field PlayRate float
---@field StartTime float
---@field bRandomStartTime boolean
---@field bDisableMovementInput boolean
---@field bDisableLookAtInput boolean
---@field bHidePlayer boolean
---@field bHideHud boolean
---@field bDisableCameraCuts boolean
---@field FinishCompletionStateOverride EMovieSceneCompletionModeOverride
---@field bPauseAtEnd boolean
---@field bInheritTickIntervalFromOwner boolean
---@field bDynamicWeighting boolean
local FMovieSceneSequencePlaybackSettings = {}



---@class FMovieSceneSequenceReplProperties
---@field LastKnownPosition FFrameTime
---@field LastKnownStatus EMovieScenePlayerStatus::Type
---@field LastKnownNumLoops int32
---@field LastKnownSerialNumber int32
local FMovieSceneSequenceReplProperties = {}



---@class FMovieSceneSequenceTickInterval
---@field TickIntervalSeconds float
---@field EvaluationBudgetMicroseconds float
---@field bTickWhenPaused boolean
---@field bAllowRounding boolean
local FMovieSceneSequenceTickInterval = {}



---@class FMovieSceneSequenceTransform
---@field LinearTransform FMovieSceneTimeTransform
---@field NestedTransforms TArray<FMovieSceneNestedSequenceTransform>
local FMovieSceneSequenceTransform = {}



---@class FMovieSceneSpawnable
---@field SpawnTransform FTransform
---@field Tags TArray<FName>
---@field bContinuouslyRespawn boolean
---@field bNetAddressableName boolean
---@field DynamicBinding FMovieSceneDynamicBinding
---@field Guid FGuid
---@field Name FString
---@field ObjectTemplate UObject
---@field ChildPossessables TArray<FGuid>
---@field Ownership ESpawnOwnership
---@field LevelName FName
local FMovieSceneSpawnable = {}



---@class FMovieSceneSubSectionData
---@field Section TWeakObjectPtr<UMovieSceneSubSection>
---@field ObjectBindingID FGuid
---@field Flags ESectionEvaluationFlags
local FMovieSceneSubSectionData = {}



---@class FMovieSceneSubSectionOriginOverrideMask
---@field Mask uint32
local FMovieSceneSubSectionOriginOverrideMask = {}



---@class FMovieSceneSubSequenceData
---@field Sequence FSoftObjectPath
---@field OuterToInnerTransform FMovieSceneSequenceTransform
---@field RootToSequenceTransform FMovieSceneSequenceTransform
---@field TickResolution FFrameRate
---@field DeterministicSequenceID FMovieSceneSequenceID
---@field PlayRange FMovieSceneFrameRange
---@field ParentPlayRange FMovieSceneFrameRange
---@field PreRollRange FMovieSceneFrameRange
---@field PostRollRange FMovieSceneFrameRange
---@field HierarchicalBias int16
---@field AccumulatedFlags EMovieSceneSubSectionFlags
---@field bCanLoop boolean
---@field InstanceData FMovieSceneSequenceInstanceDataPtr
---@field SectionPath FName
---@field Condition UMovieSceneCondition
---@field SubSectionSignature FGuid
local FMovieSceneSubSequenceData = {}



---@class FMovieSceneSubSequenceTree
local FMovieSceneSubSequenceTree = {}


---@class FMovieSceneSubSequenceTreeEntry
local FMovieSceneSubSequenceTreeEntry = {}


---@class FMovieSceneTangentData
---@field ArriveTangent float
---@field LeaveTangent float
---@field ArriveTangentWeight float
---@field LeaveTangentWeight float
---@field TangentWeightMode ERichCurveTangentWeightMode
local FMovieSceneTangentData = {}



---@class FMovieSceneTemplateGenerationLedger
---@field LastTrackIdentifier FMovieSceneTrackIdentifier
---@field TrackSignatureToTrackIdentifier TMap<FGuid, FMovieSceneTrackIdentifier>
---@field SubSectionRanges TMap<FGuid, FMovieSceneFrameRange>
local FMovieSceneTemplateGenerationLedger = {}



---@class FMovieSceneTimeTransform
---@field TimeScale float
---@field Offset FFrameTime
local FMovieSceneTimeTransform = {}



---@class FMovieSceneTimeWarpChannel : FMovieSceneDoubleChannel
---@field Owner UMovieScene
local FMovieSceneTimeWarpChannel = {}



---@class FMovieSceneTimeWarpClamp
---@field Max FFrameNumber
local FMovieSceneTimeWarpClamp = {}



---@class FMovieSceneTimeWarpClampFloat
---@field Max float
local FMovieSceneTimeWarpClampFloat = {}



---@class FMovieSceneTimeWarpFixedFrame
---@field FrameNumber FFrameNumber
local FMovieSceneTimeWarpFixedFrame = {}



---@class FMovieSceneTimeWarpFrameRate
---@field FrameRateNumerator uint8
---@field FrameRateDenominator uint8
local FMovieSceneTimeWarpFrameRate = {}



---@class FMovieSceneTimeWarpLoop
---@field Duration FFrameNumber
local FMovieSceneTimeWarpLoop = {}



---@class FMovieSceneTimeWarpLoopFloat
---@field Duration float
local FMovieSceneTimeWarpLoopFloat = {}



---@class FMovieSceneTimeWarpVariant
---@field Variant FMovieSceneNumericVariant
local FMovieSceneTimeWarpVariant = {}



---@class FMovieSceneTimeWarping
---@field Start FFrameNumber
---@field End FFrameNumber
local FMovieSceneTimeWarping = {}



---@class FMovieSceneTimecodeSource
---@field Timecode FTimecode
local FMovieSceneTimecodeSource = {}



---@class FMovieSceneTrackDisplayOptions
---@field bShowVerticalFrames boolean
local FMovieSceneTrackDisplayOptions = {}



---@class FMovieSceneTrackEvalOptions
---@field bCanEvaluateNearestSection boolean
---@field bEvalNearestSection boolean
---@field bEvaluateInPreroll boolean
---@field bEvaluateInPostroll boolean
---@field bEvaluateNearestSection boolean
local FMovieSceneTrackEvalOptions = {}



---@class FMovieSceneTrackEvaluationField
---@field Entries TArray<FMovieSceneTrackEvaluationFieldEntry>
local FMovieSceneTrackEvaluationField = {}



---@class FMovieSceneTrackEvaluationFieldEntry
---@field Section UMovieSceneSection
---@field Range FFrameNumberRange
---@field ForcedTime FFrameNumber
---@field Flags ESectionEvaluationFlags
---@field LegacySortOrder int16
local FMovieSceneTrackEvaluationFieldEntry = {}



---@class FMovieSceneTrackIdentifier
---@field Value uint32
local FMovieSceneTrackIdentifier = {}



---@class FMovieSceneTrackImplementation : FMovieSceneEvalTemplateBase
local FMovieSceneTrackImplementation = {}


---@class FMovieSceneTrackImplementationPtr
local FMovieSceneTrackImplementationPtr = {}


---@class FMovieSceneTrackInstanceComponent
---@field Owner UMovieSceneSection
---@field TrackInstanceClass TSubclassOf<UMovieSceneTrackInstance>
local FMovieSceneTrackInstanceComponent = {}



---@class FMovieSceneTrackInstanceEntry
---@field BoundObject UObject
---@field TrackInstance UMovieSceneTrackInstance
local FMovieSceneTrackInstanceEntry = {}



---@class FMovieSceneTrackInstanceInput
---@field Section UMovieSceneSection
local FMovieSceneTrackInstanceInput = {}



---@class FMovieSceneTrackLabels
---@field Strings TArray<FString>
local FMovieSceneTrackLabels = {}



---@class FMovieSceneTrackRowMetadata
---@field ConditionContainer FMovieSceneConditionContainer
local FMovieSceneTrackRowMetadata = {}



---@class FMovieSceneTransformBreadcrumbs
---@field Breadcrumbs TArray<FFrameTime>
---@field Mode EMovieSceneBreadcrumbMode
local FMovieSceneTransformBreadcrumbs = {}



---@class FMovieSceneWarpCounter : FMovieSceneTransformBreadcrumbs
local FMovieSceneWarpCounter = {}


---@class FOptionalMovieSceneBlendType
---@field BlendType EMovieSceneBlendType
---@field bIsValid boolean
local FOptionalMovieSceneBlendType = {}



---@class FSectionEvaluationData
---@field ImplIndex int32
---@field ForcedTime FFrameNumber
---@field Flags ESectionEvaluationFlags
local FSectionEvaluationData = {}



---@class FTestMovieSceneEvalTemplate : FMovieSceneEvalTemplate
local FTestMovieSceneEvalTemplate = {}


---@class FTrackInstanceInputComponent
---@field Section UMovieSceneSection
---@field OutputIndex int32
local FTrackInstanceInputComponent = {}



---@class IMovieSceneBindingEventReceiverInterface : IInterface
local IMovieSceneBindingEventReceiverInterface = {}

---@param Player UMovieSceneSequencePlayer
---@param BindingID FMovieSceneObjectBindingID
function IMovieSceneBindingEventReceiverInterface:OnObjectUnboundBySequencer(Player, BindingID) end
---@param Player UMovieSceneSequencePlayer
---@param BindingID FMovieSceneObjectBindingID
function IMovieSceneBindingEventReceiverInterface:OnObjectBoundBySequencer(Player, BindingID) end


---@class IMovieSceneBindingOwnerInterface : IInterface
local IMovieSceneBindingOwnerInterface = {}


---@class IMovieSceneBlenderSystemSupport : IInterface
local IMovieSceneBlenderSystemSupport = {}


---@class IMovieSceneBoundObjectProxy : IInterface
local IMovieSceneBoundObjectProxy = {}

---@param ResolvedObject UObject
---@return UObject
function IMovieSceneBoundObjectProxy:BP_GetBoundObjectForSequencer(ResolvedObject) end


---@class IMovieSceneCachedTrack : IInterface
local IMovieSceneCachedTrack = {}


---@class IMovieSceneChannelOverrideProvider : IInterface
local IMovieSceneChannelOverrideProvider = {}


---@class IMovieSceneChannelOwner : IInterface
local IMovieSceneChannelOwner = {}


---@class IMovieSceneCustomClockSource : IInterface
local IMovieSceneCustomClockSource = {}

---@param DeltaSeconds float
---@param InPlayRate float
function IMovieSceneCustomClockSource:OnTick(DeltaSeconds, InPlayRate) end
---@param InStopTime FQualifiedFrameTime
function IMovieSceneCustomClockSource:OnStopPlaying(InStopTime) end
---@param InStartTime FQualifiedFrameTime
function IMovieSceneCustomClockSource:OnStartPlaying(InStartTime) end
---@param InCurrentTime FQualifiedFrameTime
---@param InPlayRate float
---@return FFrameTime
function IMovieSceneCustomClockSource:OnRequestCurrentTime(InCurrentTime, InPlayRate) end


---@class IMovieSceneDeterminismSource : IInterface
local IMovieSceneDeterminismSource = {}


---@class IMovieSceneEasingFunction : IInterface
local IMovieSceneEasingFunction = {}

---@param Interp float
---@return float
function IMovieSceneEasingFunction:OnEvaluate(Interp) end


---@class IMovieSceneEntityProvider : IInterface
local IMovieSceneEntityProvider = {}


---@class IMovieSceneEvaluationHook : IInterface
local IMovieSceneEvaluationHook = {}


---@class IMovieSceneKeyProxy : IInterface
local IMovieSceneKeyProxy = {}


---@class IMovieSceneMetaDataInterface : IInterface
local IMovieSceneMetaDataInterface = {}


---@class IMovieScenePlaybackClient : IInterface
local IMovieScenePlaybackClient = {}


---@class IMovieScenePreAnimatedStateSystemInterface : IInterface
local IMovieScenePreAnimatedStateSystemInterface = {}


---@class IMovieSceneSequencePlayerObserver : IInterface
local IMovieSceneSequencePlayerObserver = {}


---@class IMovieSceneSequenceTickManagerClient : IInterface
local IMovieSceneSequenceTickManagerClient = {}


---@class IMovieSceneTrackTemplateProducer : IInterface
local IMovieSceneTrackTemplateProducer = {}


---@class IMovieSceneValueDecomposer : IInterface
local IMovieSceneValueDecomposer = {}


---@class INodeAndChannelMappings : IInterface
local INodeAndChannelMappings = {}


---@class UBuiltInDynamicBindingResolverLibrary : UBlueprintFunctionLibrary
local UBuiltInDynamicBindingResolverLibrary = {}

---@param WorldContextObject UObject
---@param PlayerControllerIndex int32
---@return FMovieSceneDynamicBindingResolveResult
function UBuiltInDynamicBindingResolverLibrary:ResolveToPlayerPawn(WorldContextObject, PlayerControllerIndex) end


---@class UMovieScene : UMovieSceneSignedObject
---@field Spawnables TArray<FMovieSceneSpawnable>
---@field Possessables TArray<FMovieScenePossessable>
---@field ObjectBindings TArray<FMovieSceneBinding>
---@field BindingGroups TMap<FName, FMovieSceneObjectBindingIDs>
---@field Tracks TArray<UMovieSceneTrack>
---@field CameraCutTrack UMovieSceneTrack
---@field SelectionRange FMovieSceneFrameRange
---@field PlaybackRange FMovieSceneFrameRange
---@field TickResolution FFrameRate
---@field DisplayRate FFrameRate
---@field EvaluationType EMovieSceneEvaluationType
---@field ClockSource EUpdateClockSource
---@field CustomClockSourcePath FSoftObjectPath
---@field MarkedFrames TArray<FMovieSceneMarkedFrame>
---@field GeneratedConditions TArray<UMovieSceneGroupCondition>
local UMovieScene = {}



---@class UMovieSceneBindingLifetimeSection : UMovieSceneSection
local UMovieSceneBindingLifetimeSection = {}


---@class UMovieSceneBindingLifetimeSystem : UMovieSceneEntitySystem
local UMovieSceneBindingLifetimeSystem = {}


---@class UMovieSceneBindingLifetimeTrack : UMovieSceneTrack
---@field Sections TArray<UMovieSceneSection>
local UMovieSceneBindingLifetimeTrack = {}



---@class UMovieSceneBindingOverrides : UObject
---@field BindingData TArray<FMovieSceneBindingOverrideData>
local UMovieSceneBindingOverrides = {}



---@class UMovieSceneBlenderSystem : UMovieSceneEntitySystem
local UMovieSceneBlenderSystem = {}


---@class UMovieSceneBoolSection : UMovieSceneSection
---@field DefaultValue boolean
---@field BoolCurve FMovieSceneBoolChannel
local UMovieSceneBoolSection = {}



---@class UMovieSceneBoundSceneComponentInstantiator : UMovieSceneEntityInstantiatorSystem
local UMovieSceneBoundSceneComponentInstantiator = {}


---@class UMovieSceneBuiltInEasingFunction : UObject
---@field Type EMovieSceneBuiltInEasing
local UMovieSceneBuiltInEasingFunction = {}



---@class UMovieSceneCachePreAnimatedStateSystem : UMovieSceneEntityInstantiatorSystem
local UMovieSceneCachePreAnimatedStateSystem = {}


---@class UMovieSceneChannelOverrideContainer : UMovieSceneSignedObject
local UMovieSceneChannelOverrideContainer = {}


---@class UMovieSceneCompiledData : UObject
---@field EvaluationTemplate FMovieSceneEvaluationTemplate
---@field Hierarchy FMovieSceneSequenceHierarchy
---@field EntityComponentField FMovieSceneEntityComponentField
---@field TrackTemplateField FMovieSceneEvaluationField
---@field DeterminismFences TArray<FMovieSceneDeterminismFence>
---@field CompiledSignature FGuid
---@field CompilerVersion FGuid
---@field AccumulatedMask EMovieSceneSequenceCompilerMask
---@field AllocatedMask EMovieSceneSequenceCompilerMask
---@field AccumulatedFlags EMovieSceneSequenceFlags
local UMovieSceneCompiledData = {}



---@class UMovieSceneCompiledDataManager : UObject
---@field Hierarchies TMap<int32, FMovieSceneSequenceHierarchy>
---@field TrackTemplates TMap<int32, FMovieSceneEvaluationTemplate>
---@field TrackTemplateFields TMap<int32, FMovieSceneEvaluationField>
---@field EntityComponentFields TMap<int32, FMovieSceneEntityComponentField>
local UMovieSceneCompiledDataManager = {}



---@class UMovieSceneCondition : UMovieSceneSignedObject
---@field bInvert boolean
local UMovieSceneCondition = {}

---@return EMovieSceneConditionScope
function UMovieSceneCondition:BP_GetScope() end
---@return EMovieSceneConditionCheckFrequency
function UMovieSceneCondition:BP_GetCheckFrequency() end
---@param ConditionContext FMovieSceneConditionContext
---@return boolean
function UMovieSceneCondition:BP_EvaluateCondition(ConditionContext) end


---@class UMovieSceneCustomBinding : UObject
local UMovieSceneCustomBinding = {}

---@return int32
function UMovieSceneCustomBinding:GetBaseEnginePriority() end
---@return int32
function UMovieSceneCustomBinding:GetBaseCustomPriority() end


---@class UMovieSceneEasingExternalCurve : UObject
---@field Curve UCurveFloat
local UMovieSceneEasingExternalCurve = {}



---@class UMovieSceneEntityGroupingSystem : UMovieSceneEntitySystem
local UMovieSceneEntityGroupingSystem = {}


---@class UMovieSceneEntityInstantiatorSystem : UMovieSceneEntitySystem
local UMovieSceneEntityInstantiatorSystem = {}


---@class UMovieSceneEntitySystem : UObject
---@field Linker UMovieSceneEntitySystemLinker
local UMovieSceneEntitySystem = {}



---@class UMovieSceneEntitySystemLinker : UObject
---@field SystemGraph FMovieSceneEntitySystemGraph
local UMovieSceneEntitySystemLinker = {}



---@class UMovieSceneEvalTimeSystem : UMovieSceneEntitySystem
local UMovieSceneEvalTimeSystem = {}


---@class UMovieSceneEvaluationHookSystem : UMovieSceneEntitySystem
---@field PendingEventsByRootInstance TMap<FMovieSceneEvaluationInstanceKey, FMovieSceneEvaluationHookEventContainer>
local UMovieSceneEvaluationHookSystem = {}



---@class UMovieSceneFolder : UObject
---@field FolderName FName
---@field ChildFolders TArray<UMovieSceneFolder>
---@field ChildTracks TArray<UMovieSceneTrack>
---@field ChildObjectBindingStrings TArray<FString>
local UMovieSceneFolder = {}



---@class UMovieSceneGenericBoundObjectInstantiator : UMovieSceneEntityInstantiatorSystem
local UMovieSceneGenericBoundObjectInstantiator = {}


---@class UMovieSceneGroupCondition : UMovieSceneCondition
---@field Operator EMovieSceneGroupConditionOperator
---@field SubConditions TArray<FMovieSceneConditionContainer>
local UMovieSceneGroupCondition = {}



---@class UMovieSceneHookSection : UMovieSceneSection
---@field bRequiresRangedHook boolean
---@field bRequiresTriggerHooks boolean
local UMovieSceneHookSection = {}



---@class UMovieSceneMetaData : UObject
---@field Author FString
---@field Created FDateTime
---@field Notes FString
local UMovieSceneMetaData = {}

---@param InNotes FString
function UMovieSceneMetaData:SetNotes(InNotes) end
---@param InCreated FDateTime
function UMovieSceneMetaData:SetCreated(InCreated) end
---@param InAuthor FString
function UMovieSceneMetaData:SetAuthor(InAuthor) end
---@return FString
function UMovieSceneMetaData:GetNotes() end
---@return FDateTime
function UMovieSceneMetaData:GetCreated() end
---@return FString
function UMovieSceneMetaData:GetAuthor() end


---@class UMovieSceneNameableTrack : UMovieSceneTrack
local UMovieSceneNameableTrack = {}


---@class UMovieSceneNodeGroup : UObject
local UMovieSceneNodeGroup = {}


---@class UMovieSceneNodeGroupCollection : UObject
local UMovieSceneNodeGroupCollection = {}


---@class UMovieSceneNumericVariantGetter : UMovieSceneSignedObject
---@field ReferenceToSelf UMovieSceneNumericVariantGetter
local UMovieSceneNumericVariantGetter = {}



---@class UMovieScenePlayRateCurve : UMovieSceneTimeWarpGetter
---@field PlayRate FMovieSceneTimeWarpChannel
local UMovieScenePlayRateCurve = {}



---@class UMovieSceneReplaceableBindingBase : UMovieSceneCustomBinding
local UMovieSceneReplaceableBindingBase = {}


---@class UMovieSceneRestorePreAnimatedStateSystem : UMovieSceneEntityInstantiatorSystem
local UMovieSceneRestorePreAnimatedStateSystem = {}


---@class UMovieSceneRootInstantiatorSystem : UMovieSceneEntityInstantiatorSystem
local UMovieSceneRootInstantiatorSystem = {}


---@class UMovieSceneSection : UMovieSceneSignedObject
---@field EvalOptions FMovieSceneSectionEvalOptions
---@field Easing FMovieSceneEasingSettings
---@field SectionRange FMovieSceneFrameRange
---@field ConditionContainer FMovieSceneConditionContainer
---@field PreRollFrames FFrameNumber
---@field PostRollFrames FFrameNumber
---@field RowIndex int32
---@field OverlapPriority int32
---@field bIsActive boolean
---@field bIsLocked boolean
---@field StartTime float
---@field EndTime float
---@field PrerollTime float
---@field PostrollTime float
---@field bIsInfinite boolean
---@field bSupportsInfiniteRange boolean
---@field BlendType FOptionalMovieSceneBlendType
local UMovieSceneSection = {}

---@param NewRowIndex int32
function UMovieSceneSection:SetRowIndex(NewRowIndex) end
---@param InPreRollFrames int32
function UMovieSceneSection:SetPreRollFrames(InPreRollFrames) end
---@param InPostRollFrames int32
function UMovieSceneSection:SetPostRollFrames(InPostRollFrames) end
---@param NewPriority int32
function UMovieSceneSection:SetOverlapPriority(NewPriority) end
---@param bInIsLocked boolean
function UMovieSceneSection:SetIsLocked(bInIsLocked) end
---@param bInIsActive boolean
function UMovieSceneSection:SetIsActive(bInIsActive) end
---@param InCompletionMode EMovieSceneCompletionMode
function UMovieSceneSection:SetCompletionMode(InCompletionMode) end
---@param InColorTint FColor
function UMovieSceneSection:SetColorTint(InColorTint) end
---@param InBlendType EMovieSceneBlendType
function UMovieSceneSection:SetBlendType(InBlendType) end
---@return boolean
function UMovieSceneSection:IsLocked() end
---@return boolean
function UMovieSceneSection:IsActive() end
---@return int32
function UMovieSceneSection:GetRowIndex() end
---@return int32
function UMovieSceneSection:GetPreRollFrames() end
---@return int32
function UMovieSceneSection:GetPostRollFrames() end
---@return int32
function UMovieSceneSection:GetOverlapPriority() end
---@return EMovieSceneCompletionMode
function UMovieSceneSection:GetCompletionMode() end
---@return FColor
function UMovieSceneSection:GetColorTint() end
---@return FOptionalMovieSceneBlendType
function UMovieSceneSection:GetBlendType() end


---@class UMovieSceneSectionChannelOverrideRegistry : UObject
---@field Overrides TMap<FName, UMovieSceneChannelOverrideContainer>
local UMovieSceneSectionChannelOverrideRegistry = {}



---@class UMovieSceneSequence : UMovieSceneSignedObject
---@field CompiledData UMovieSceneCompiledData
---@field DefaultCompletionMode EMovieSceneCompletionMode
---@field bParentContextsAreSignificant boolean
---@field bPlayableDirectly boolean
---@field SequenceFlags EMovieSceneSequenceFlags
local UMovieSceneSequence = {}

---@return FMovieSceneTimecodeSource
function UMovieSceneSequence:GetEarliestTimecodeSource() end
---@param InBindingName FName
---@return TArray<FMovieSceneObjectBindingID>
function UMovieSceneSequence:FindBindingsByTag(InBindingName) end
---@param InBindingName FName
---@return FMovieSceneObjectBindingID
function UMovieSceneSequence:FindBindingByTag(InBindingName) end


---@class UMovieSceneSequencePlayer : UObject
---@field Observer TScriptInterface<IMovieSceneSequencePlayerObserver>
---@field OnPlay FMovieSceneSequencePlayerOnPlay
---@field OnPlayReverse FMovieSceneSequencePlayerOnPlayReverse
---@field OnStop FMovieSceneSequencePlayerOnStop
---@field OnPause FMovieSceneSequencePlayerOnPause
---@field OnFinished FMovieSceneSequencePlayerOnFinished
---@field status EMovieScenePlayerStatus::Type
---@field bReversePlayback boolean
---@field Sequence UMovieSceneSequence
---@field StartTime FFrameNumber
---@field DurationFrames int32
---@field DurationSubFrames float
---@field CurrentNumLoops int32
---@field SerialNumber int32
---@field PlaybackSettings FMovieSceneSequencePlaybackSettings
---@field RootTemplateInstance FMovieSceneRootEvaluationTemplateInstance
---@field NetSyncProps FMovieSceneSequenceReplProperties
---@field PlaybackClient TScriptInterface<IMovieScenePlaybackClient>
---@field TickManager UMovieSceneSequenceTickManager
local UMovieSceneSequencePlayer = {}

function UMovieSceneSequencePlayer:StopAtCurrentTime() end
function UMovieSceneSequencePlayer:Stop() end
---@param InWeight double
function UMovieSceneSequencePlayer:SetWeight(InWeight) end
---@param StartTime float
---@param Duration float
function UMovieSceneSequencePlayer:SetTimeRange(StartTime, Duration) end
---@param PlayRate float
function UMovieSceneSequencePlayer:SetPlayRate(PlayRate) end
---@param PlaybackParams FMovieSceneSequencePlaybackParams
function UMovieSceneSequencePlayer:SetPlaybackPosition(PlaybackParams) end
---@param HideHud boolean
function UMovieSceneSequencePlayer:SetHideHud(HideHud) end
---@param FrameRate FFrameRate
function UMovieSceneSequencePlayer:SetFrameRate(FrameRate) end
---@param StartFrame int32
---@param Duration int32
---@param SubFrames float
function UMovieSceneSequencePlayer:SetFrameRange(StartFrame, Duration, SubFrames) end
---@param bInDisableCameraCuts boolean
function UMovieSceneSequencePlayer:SetDisableCameraCuts(bInDisableCameraCuts) end
---@param CompletionModeOverride EMovieSceneCompletionModeOverride
function UMovieSceneSequencePlayer:SetCompletionModeOverride(CompletionModeOverride) end
function UMovieSceneSequencePlayer:Scrub() end
---@param StoppedTime FFrameTime
---@param NewSerialNumber int32
function UMovieSceneSequencePlayer:RPC_OnStopEvent(StoppedTime, NewSerialNumber) end
---@param StoppedTime FFrameTime
---@param NewSerialNumber int32
function UMovieSceneSequencePlayer:RPC_OnFinishPlaybackEvent(StoppedTime, NewSerialNumber) end
---@param Method EUpdatePositionMethod
---@param RelevantTime FFrameTime
---@param NewSerialNumber int32
function UMovieSceneSequencePlayer:RPC_ExplicitServerUpdateEvent(Method, RelevantTime, NewSerialNumber) end
function UMovieSceneSequencePlayer:RestoreState() end
---@param ObjectBinding FMovieSceneObjectBindingID
function UMovieSceneSequencePlayer:RequestInvalidateBinding(ObjectBinding) end
function UMovieSceneSequencePlayer:RemoveWeight() end
---@param PlaybackParams FMovieSceneSequencePlaybackParams
---@param PlayToParams FMovieSceneSequencePlayToParams
function UMovieSceneSequencePlayer:PlayTo(PlaybackParams, PlayToParams) end
function UMovieSceneSequencePlayer:PlayReverse() end
---@param NumLoops int32
function UMovieSceneSequencePlayer:PlayLooping(NumLoops) end
function UMovieSceneSequencePlayer:Play() end
function UMovieSceneSequencePlayer:Pause() end
---@return boolean
function UMovieSceneSequencePlayer:IsReversed() end
---@return boolean
function UMovieSceneSequencePlayer:IsPlaying() end
---@return boolean
function UMovieSceneSequencePlayer:IsPaused() end
function UMovieSceneSequencePlayer:GoToEndAndStop() end
---@return FQualifiedFrameTime
function UMovieSceneSequencePlayer:GetStartTime() end
---@param bAddClientInfo boolean
---@return FString
function UMovieSceneSequencePlayer:GetSequenceName(bAddClientInfo) end
---@return UMovieSceneSequence
function UMovieSceneSequencePlayer:GetSequence() end
---@return float
function UMovieSceneSequencePlayer:GetPlayRate() end
---@param InObject UObject
---@return TArray<FMovieSceneObjectBindingID>
function UMovieSceneSequencePlayer:GetObjectBindings(InObject) end
---@return boolean
function UMovieSceneSequencePlayer:GetHideHud() end
---@return FFrameRate
function UMovieSceneSequencePlayer:GetFrameRate() end
---@return int32
function UMovieSceneSequencePlayer:GetFrameDuration() end
---@return FQualifiedFrameTime
function UMovieSceneSequencePlayer:GetEndTime() end
---@return FQualifiedFrameTime
function UMovieSceneSequencePlayer:GetDuration() end
---@return boolean
function UMovieSceneSequencePlayer:GetDisableCameraCuts() end
---@return FQualifiedFrameTime
function UMovieSceneSequencePlayer:GetCurrentTime() end
---@return EMovieSceneCompletionModeOverride
function UMovieSceneSequencePlayer:GetCompletionModeOverride() end
---@param ObjectBinding FMovieSceneObjectBindingID
---@return TArray<UObject>
function UMovieSceneSequencePlayer:GetBoundObjects(ObjectBinding) end
function UMovieSceneSequencePlayer:ChangePlaybackDirection() end


---@class UMovieSceneSequenceTickManager : UObject
local UMovieSceneSequenceTickManager = {}


---@class UMovieSceneSignedObject : UObject
---@field Signature FGuid
local UMovieSceneSignedObject = {}



---@class UMovieSceneSpawnSection : UMovieSceneBoolSection
local UMovieSceneSpawnSection = {}


---@class UMovieSceneSpawnTrack : UMovieSceneTrack
---@field Sections TArray<UMovieSceneSection>
---@field ObjectGuid FGuid
local UMovieSceneSpawnTrack = {}



---@class UMovieSceneSpawnableBindingBase : UMovieSceneCustomBinding
---@field SpawnOwnership ESpawnOwnership
---@field bContinuouslyRespawn boolean
local UMovieSceneSpawnableBindingBase = {}



---@class UMovieSceneSpawnablesSystem : UMovieSceneEntitySystem
local UMovieSceneSpawnablesSystem = {}


---@class UMovieSceneSubSection : UMovieSceneSection
---@field Parameters FMovieSceneSectionParameters
---@field StartOffset float
---@field TimeScale float
---@field PrerollTime float
---@field NetworkMask uint8
---@field OriginOverrideMask FMovieSceneSubSectionOriginOverrideMask
---@field Translation FMovieSceneDoubleChannel
---@field Rotation FMovieSceneDoubleChannel
---@field SubSequence UMovieSceneSequence
local UMovieSceneSubSection = {}

---@param Sequence UMovieSceneSequence
function UMovieSceneSubSection:SetSequence(Sequence) end
---@return UMovieSceneSequence
function UMovieSceneSubSection:GetSequence() end


---@class UMovieSceneSubTrack : UMovieSceneNameableTrack
---@field Sections TArray<UMovieSceneSection>
local UMovieSceneSubTrack = {}



---@class UMovieSceneTimeWarpCurve : UMovieSceneTimeWarpGetter
---@field Channel FMovieSceneTimeWarpChannel
local UMovieSceneTimeWarpCurve = {}



---@class UMovieSceneTimeWarpGetter : UMovieSceneNumericVariantGetter
---@field bMuted boolean
local UMovieSceneTimeWarpGetter = {}



---@class UMovieSceneTimeWarpSection : UMovieSceneSection
---@field TimeWarp FMovieSceneTimeWarpVariant
local UMovieSceneTimeWarpSection = {}



---@class UMovieSceneTimeWarpTrack : UMovieSceneTrack
---@field bIsActiveTimeWarp boolean
---@field Sections TArray<UMovieSceneSection>
local UMovieSceneTimeWarpTrack = {}



---@class UMovieSceneTrack : UMovieSceneSignedObject
---@field EvalOptions FMovieSceneTrackEvalOptions
---@field ConditionContainer FMovieSceneConditionContainer
---@field bIsEvalDisabled boolean
---@field RowsDisabled TArray<int32>
---@field EvaluationFieldGuid FGuid
---@field EvaluationField FMovieSceneTrackEvaluationField
---@field TrackRowMetadata TMap<int32, FMovieSceneTrackRowMetadata>
local UMovieSceneTrack = {}



---@class UMovieSceneTrackInstance : UObject
---@field WeakAnimatedObject TWeakObjectPtr<UObject>
---@field bIsRootTrackInstance boolean
---@field PrivateLinker UMovieSceneEntitySystemLinker
---@field Inputs TArray<FMovieSceneTrackInstanceInput>
local UMovieSceneTrackInstance = {}



---@class UMovieSceneTrackInstanceInstantiator : UMovieSceneEntityInstantiatorSystem
local UMovieSceneTrackInstanceInstantiator = {}


---@class UMovieSceneTrackInstanceSystem : UMovieSceneEntitySystem
---@field Instantiator UMovieSceneTrackInstanceInstantiator
local UMovieSceneTrackInstanceSystem = {}



---@class UTestMovieSceneEvalHookSection : UMovieSceneHookSection
local UTestMovieSceneEvalHookSection = {}


---@class UTestMovieSceneEvalHookTrack : UMovieSceneTrack
---@field SectionArray TArray<UMovieSceneSection>
local UTestMovieSceneEvalHookTrack = {}



---@class UTestMovieSceneSection : UMovieSceneSection
local UTestMovieSceneSection = {}


---@class UTestMovieSceneSequence : UMovieSceneSequence
---@field MovieScene UMovieScene
local UTestMovieSceneSequence = {}



---@class UTestMovieSceneSubSection : UMovieSceneSubSection
local UTestMovieSceneSubSection = {}


---@class UTestMovieSceneSubTrack : UMovieSceneSubTrack
---@field SectionArray TArray<UMovieSceneSection>
local UTestMovieSceneSubTrack = {}



---@class UTestMovieSceneTrack : UMovieSceneTrack
---@field bHighPassFilter boolean
---@field SectionArray TArray<UMovieSceneSection>
local UTestMovieSceneTrack = {}



