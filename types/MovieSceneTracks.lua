---@meta

---@class FBoolParameterNameAndCurve
---@field ParameterName FName
---@field ParameterCurve FMovieSceneBoolChannel
local FBoolParameterNameAndCurve = {}



---@class FColorMaterialParameterInfoAndCurves
---@field ParameterInfo FMaterialParameterInfo
---@field RedCurve FMovieSceneFloatChannel
---@field GreenCurve FMovieSceneFloatChannel
---@field BlueCurve FMovieSceneFloatChannel
---@field AlphaCurve FMovieSceneFloatChannel
local FColorMaterialParameterInfoAndCurves = {}



---@class FColorParameterNameAndCurves
---@field ParameterName FName
---@field RedCurve FMovieSceneFloatChannel
---@field GreenCurve FMovieSceneFloatChannel
---@field BlueCurve FMovieSceneFloatChannel
---@field AlphaCurve FMovieSceneFloatChannel
local FColorParameterNameAndCurves = {}



---@class FComponentMaterialInfo
---@field MaterialSlotName FName
---@field MaterialSlotIndex int32
---@field MaterialType EComponentMaterialType
local FComponentMaterialInfo = {}



---@class FConstraintComponentData
---@field ConstraintID FGuid
local FConstraintComponentData = {}



---@class FEventPayload
---@field EventName FName
---@field Parameters FMovieSceneEventParameters
local FEventPayload = {}



---@class FLevelVisibilityComponentData
---@field Section UMovieSceneLevelVisibilitySection
local FLevelVisibilityComponentData = {}



---@class FMovieScene3DLocationKeyStruct : FMovieSceneKeyStruct
---@field Location FVector
---@field Time FFrameNumber
local FMovieScene3DLocationKeyStruct = {}



---@class FMovieScene3DPathSectionTemplate : FMovieSceneEvalTemplate
---@field PathBindingID FMovieSceneObjectBindingID
---@field TimingCurve FMovieSceneFloatChannel
---@field FrontAxisEnum MovieScene3DPathSection_Axis
---@field UpAxisEnum MovieScene3DPathSection_Axis
---@field bFollow boolean
---@field bReverse boolean
---@field bForceUpright boolean
local FMovieScene3DPathSectionTemplate = {}



---@class FMovieScene3DRotationKeyStruct : FMovieSceneKeyStruct
---@field Rotation FRotator
---@field Time FFrameNumber
local FMovieScene3DRotationKeyStruct = {}



---@class FMovieScene3DScaleKeyStruct : FMovieSceneKeyStruct
---@field Scale FVector3f
---@field Time FFrameNumber
local FMovieScene3DScaleKeyStruct = {}



---@class FMovieScene3DTransformKeyStruct : FMovieSceneKeyStruct
---@field Location FVector
---@field Rotation FRotator
---@field Scale FVector3f
---@field Time FFrameNumber
local FMovieScene3DTransformKeyStruct = {}



---@class FMovieSceneActorReferenceData : FMovieSceneChannel
---@field KeyTimes TArray<FFrameNumber>
---@field DefaultValue FMovieSceneActorReferenceKey
---@field KeyValues TArray<FMovieSceneActorReferenceKey>
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneActorReferenceData = {}



---@class FMovieSceneActorReferenceKey
---@field Object FMovieSceneObjectBindingID
---@field ComponentName FName
---@field SocketName FName
local FMovieSceneActorReferenceKey = {}



---@class FMovieSceneActorReferenceSectionTemplate : FMovieSceneEvalTemplate
---@field PropertyData FMovieScenePropertySectionData
---@field ActorReferenceData FMovieSceneActorReferenceData
local FMovieSceneActorReferenceSectionTemplate = {}



---@class FMovieSceneAudioComponentData
---@field Section UMovieSceneAudioSection
local FMovieSceneAudioComponentData = {}



---@class FMovieSceneAudioInputData
---@field FloatInputs FName
---@field StringInput FName
---@field BoolInput FName
---@field IntInput FName
local FMovieSceneAudioInputData = {}



---@class FMovieSceneBaseCacheParams
---@field FirstLoopStartFrameOffset FFrameNumber
---@field StartFrameOffset FFrameNumber
---@field EndFrameOffset FFrameNumber
---@field PlayRate float
---@field bReverse boolean
local FMovieSceneBaseCacheParams = {}



---@class FMovieSceneBaseCacheSectionTemplateParameters
---@field SectionStartTime FFrameNumber
---@field SectionEndTime FFrameNumber
local FMovieSceneBaseCacheSectionTemplateParameters = {}



---@class FMovieSceneBoolPropertySectionTemplate : FMovieScenePropertySectionTemplate
---@field BoolCurve FMovieSceneBoolChannel
local FMovieSceneBoolPropertySectionTemplate = {}



---@class FMovieSceneCVarOverrides
---@field ValuesByCVar TMap<FString, FString>
local FMovieSceneCVarOverrides = {}



---@class FMovieSceneCameraShakeComponentData
---@field SectionData FMovieSceneCameraShakeSectionData
---@field SectionStartTime FFrameNumber
---@field SectionEndTime FFrameNumber
---@field SectionSignature FGuid
local FMovieSceneCameraShakeComponentData = {}



---@class FMovieSceneCameraShakeInstanceData
---@field ShakeInstance UCameraShakeBase
---@field SectionSignature FGuid
---@field bManagedByPreviewer boolean
local FMovieSceneCameraShakeInstanceData = {}



---@class FMovieSceneCameraShakeSectionData
---@field ShakeClass TSubclassOf<UCameraShakeBase>
---@field PlayScale float
---@field PlaySpace ECameraShakePlaySpace
---@field UserDefinedPlaySpace FRotator
local FMovieSceneCameraShakeSectionData = {}



---@class FMovieSceneCameraShakeSourceTrigger
---@field ShakeClass TSubclassOf<UCameraShakeBase>
---@field PlayScale float
---@field PlaySpace ECameraShakePlaySpace
---@field UserDefinedPlaySpace FRotator
local FMovieSceneCameraShakeSourceTrigger = {}



---@class FMovieSceneCameraShakeSourceTriggerChannel : FMovieSceneChannel
---@field KeyTimes TArray<FFrameNumber>
---@field KeyValues TArray<FMovieSceneCameraShakeSourceTrigger>
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneCameraShakeSourceTriggerChannel = {}



---@class FMovieSceneColorKeyStruct : FMovieSceneKeyStruct
---@field Color FLinearColor
---@field Time FFrameNumber
local FMovieSceneColorKeyStruct = {}



---@class FMovieSceneConsoleVariableCollection
---@field Interface TScriptInterface<IMovieSceneConsoleVariableTrackInterface>
---@field bOnlyIncludeChecked boolean
local FMovieSceneConsoleVariableCollection = {}



---@class FMovieSceneDataLayerComponentData
---@field Section UMovieSceneDataLayerSection
local FMovieSceneDataLayerComponentData = {}



---@class FMovieSceneDirectorBlueprintConditionData
---@field Function UFunction
---@field ConditionContextProperty TFieldPath<FProperty>
local FMovieSceneDirectorBlueprintConditionData = {}



---@class FMovieSceneDirectorBlueprintConditionPayloadVariable
---@field ObjectValue FSoftObjectPath
---@field Value FString
local FMovieSceneDirectorBlueprintConditionPayloadVariable = {}



---@class FMovieSceneDoublePerlinNoiseChannel : FMovieSceneChannel
---@field PerlinNoiseParams FPerlinNoiseParams
local FMovieSceneDoublePerlinNoiseChannel = {}



---@class FMovieSceneDoubleVectorKeyStructBase : FMovieSceneKeyStruct
---@field Time FFrameNumber
local FMovieSceneDoubleVectorKeyStructBase = {}



---@class FMovieSceneEvent
---@field Ptrs FMovieSceneEventPtrs
local FMovieSceneEvent = {}



---@class FMovieSceneEventChannel : FMovieSceneChannel
---@field KeyTimes TArray<FFrameNumber>
---@field KeyValues TArray<FMovieSceneEvent>
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneEventChannel = {}



---@class FMovieSceneEventParameters
local FMovieSceneEventParameters = {}


---@class FMovieSceneEventPayloadVariable
---@field ObjectValue FSoftObjectPath
---@field Value FString
local FMovieSceneEventPayloadVariable = {}



---@class FMovieSceneEventPtrs
---@field Function UFunction
---@field BoundObjectProperty TFieldPath<FProperty>
local FMovieSceneEventPtrs = {}



---@class FMovieSceneEventSectionData : FMovieSceneChannel
---@field Times TArray<FFrameNumber>
---@field KeyValues TArray<FEventPayload>
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneEventSectionData = {}



---@class FMovieSceneEventSectionTemplate : FMovieSceneEvalTemplate
---@field EventData FMovieSceneEventSectionData
---@field bFireEventsWhenForwards boolean
---@field bFireEventsWhenBackwards boolean
local FMovieSceneEventSectionTemplate = {}



---@class FMovieSceneEventTriggerData
---@field Ptrs FMovieSceneEventPtrs
---@field ObjectBindingID FGuid
local FMovieSceneEventTriggerData = {}



---@class FMovieSceneFloatPerlinNoiseChannel : FMovieSceneChannel
---@field PerlinNoiseParams FPerlinNoiseParams
local FMovieSceneFloatPerlinNoiseChannel = {}



---@class FMovieSceneFloatVectorKeyStructBase : FMovieSceneKeyStruct
---@field Time FFrameNumber
local FMovieSceneFloatVectorKeyStructBase = {}



---@class FMovieSceneParameterSectionTemplate : FMovieSceneEvalTemplate
---@field Scalars TArray<FScalarParameterNameAndCurve>
---@field Bools TArray<FBoolParameterNameAndCurve>
---@field Vector2Ds TArray<FVector2DParameterNameAndCurves>
---@field Vectors TArray<FVectorParameterNameAndCurves>
---@field Colors TArray<FColorParameterNameAndCurves>
---@field Transforms TArray<FTransformParameterNameAndCurves>
local FMovieSceneParameterSectionTemplate = {}



---@class FMovieSceneParticleChannel : FMovieSceneByteChannel
local FMovieSceneParticleChannel = {}


---@class FMovieSceneParticleParameterSectionTemplate : FMovieSceneParameterSectionTemplate
local FMovieSceneParticleParameterSectionTemplate = {}


---@class FMovieSceneParticleSectionTemplate : FMovieSceneEvalTemplate
---@field ParticleKeys FMovieSceneParticleChannel
local FMovieSceneParticleSectionTemplate = {}



---@class FMovieScenePreAnimatedMaterialParameters
---@field PreviousMaterial UMaterialInterface
---@field SoftPreviousMaterial TSoftObjectPtr<UMaterialInterface>
local FMovieScenePreAnimatedMaterialParameters = {}



---@class FMovieSceneSkeletalAnimRootMotionTrackParams
local FMovieSceneSkeletalAnimRootMotionTrackParams = {}


---@class FMovieSceneSkeletalAnimationComponentData
---@field Section UMovieSceneSkeletalAnimationSection
local FMovieSceneSkeletalAnimationComponentData = {}



---@class FMovieSceneSkeletalAnimationParams
---@field Animation UAnimSequenceBase
---@field FirstLoopStartFrameOffset FFrameNumber
---@field StartFrameOffset FFrameNumber
---@field EndFrameOffset FFrameNumber
---@field PlayRate FMovieSceneTimeWarpVariant
---@field bReverse boolean
---@field SlotName FName
---@field MirrorDataTable UMirrorDataTable
---@field Weight FMovieSceneFloatChannel
---@field bSkipAnimNotifiers boolean
---@field bForceCustomMode boolean
---@field SwapRootBone ESwapRootBone
---@field StartOffset float
---@field EndOffset float
local FMovieSceneSkeletalAnimationParams = {}



---@class FMovieSceneStringChannel : FMovieSceneChannel
---@field Times TArray<FFrameNumber>
---@field Values TArray<FString>
---@field DefaultValue FString
---@field bHasDefaultValue boolean
---@field KeyHandles FMovieSceneKeyHandleMap
local FMovieSceneStringChannel = {}



---@class FMovieSceneTransformMask
---@field Mask uint32
local FMovieSceneTransformMask = {}



---@class FMovieSceneVector2DKeyStruct : FMovieSceneDoubleVectorKeyStructBase
---@field Vector FVector2D
local FMovieSceneVector2DKeyStruct = {}



---@class FMovieSceneVector2fKeyStruct : FMovieSceneFloatVectorKeyStructBase
---@field Vector FVector2f
local FMovieSceneVector2fKeyStruct = {}



---@class FMovieSceneVector3dKeyStruct : FMovieSceneDoubleVectorKeyStructBase
---@field Vector FVector3d
local FMovieSceneVector3dKeyStruct = {}



---@class FMovieSceneVector3fKeyStruct : FMovieSceneFloatVectorKeyStructBase
---@field Vector FVector3f
local FMovieSceneVector3fKeyStruct = {}



---@class FMovieSceneVector4dKeyStruct : FMovieSceneDoubleVectorKeyStructBase
---@field Vector FVector4d
local FMovieSceneVector4dKeyStruct = {}



---@class FMovieSceneVector4fKeyStruct : FMovieSceneFloatVectorKeyStructBase
---@field Vector FVector4f
local FMovieSceneVector4fKeyStruct = {}



---@class FPerlinNoiseParams
---@field Frequency float
---@field Amplitude double
---@field Offset float
local FPerlinNoiseParams = {}



---@class FScalarMaterialParameterInfoAndCurve
---@field ParameterInfo FMaterialParameterInfo
---@field ParameterCurve FMovieSceneFloatChannel
local FScalarMaterialParameterInfoAndCurve = {}



---@class FScalarParameterNameAndCurve
---@field ParameterName FName
---@field ParameterCurve FMovieSceneFloatChannel
local FScalarParameterNameAndCurve = {}



---@class FTransformParameterNameAndCurves
---@field ParameterName FName
---@field Translation FMovieSceneFloatChannel
---@field Rotation FMovieSceneFloatChannel
---@field Scale FMovieSceneFloatChannel
local FTransformParameterNameAndCurves = {}



---@class FVector2DParameterNameAndCurves
---@field ParameterName FName
---@field XCurve FMovieSceneFloatChannel
---@field YCurve FMovieSceneFloatChannel
local FVector2DParameterNameAndCurves = {}



---@class FVectorParameterNameAndCurves
---@field ParameterName FName
---@field XCurve FMovieSceneFloatChannel
---@field YCurve FMovieSceneFloatChannel
---@field ZCurve FMovieSceneFloatChannel
local FVectorParameterNameAndCurves = {}



---@class IMovieSceneConsoleVariableTrackInterface : IInterface
local IMovieSceneConsoleVariableTrackInterface = {}


---@class IMovieSceneConstrainedSection : IInterface
local IMovieSceneConstrainedSection = {}


---@class IMovieSceneParameterSectionExtender : IInterface
local IMovieSceneParameterSectionExtender = {}


---@class IMovieSceneSectionsToKey : IInterface
local IMovieSceneSectionsToKey = {}


---@class IMovieSceneTransformOrigin : IInterface
local IMovieSceneTransformOrigin = {}

---@return FTransform
function IMovieSceneTransformOrigin:BP_GetTransformOrigin() end


---@class UBoolChannelEvaluatorSystem : UMovieSceneEntitySystem
local UBoolChannelEvaluatorSystem = {}


---@class UByteChannelEvaluatorSystem : UMovieSceneEntitySystem
local UByteChannelEvaluatorSystem = {}


---@class UDoubleChannelEvaluatorSystem : UMovieSceneEntitySystem
local UDoubleChannelEvaluatorSystem = {}


---@class UDoublePerlinNoiseChannelEvaluatorSystem : UMovieSceneEntitySystem
local UDoublePerlinNoiseChannelEvaluatorSystem = {}


---@class UFloatChannelEvaluatorSystem : UMovieSceneEntitySystem
local UFloatChannelEvaluatorSystem = {}


---@class UFloatPerlinNoiseChannelEvaluatorSystem : UMovieSceneEntitySystem
local UFloatPerlinNoiseChannelEvaluatorSystem = {}


---@class UIntegerChannelEvaluatorSystem : UMovieSceneEntitySystem
local UIntegerChannelEvaluatorSystem = {}


---@class UMovieScene3DAttachSection : UMovieScene3DConstraintSection
---@field AttachSocketName FName
---@field AttachComponentName FName
---@field AttachmentLocationRule EAttachmentRule
---@field AttachmentRotationRule EAttachmentRule
---@field AttachmentScaleRule EAttachmentRule
---@field DetachmentLocationRule EDetachmentRule
---@field DetachmentRotationRule EDetachmentRule
---@field DetachmentScaleRule EDetachmentRule
local UMovieScene3DAttachSection = {}



---@class UMovieScene3DAttachTrack : UMovieScene3DConstraintTrack
local UMovieScene3DAttachTrack = {}


---@class UMovieScene3DConstraintSection : UMovieSceneSection
---@field ConstraintID FGuid
---@field ConstraintBindingID FMovieSceneObjectBindingID
local UMovieScene3DConstraintSection = {}

---@param InConstraintBindingID FMovieSceneObjectBindingID
function UMovieScene3DConstraintSection:SetConstraintBindingID(InConstraintBindingID) end
---@return FMovieSceneObjectBindingID
function UMovieScene3DConstraintSection:GetConstraintBindingID() end


---@class UMovieScene3DConstraintTrack : UMovieSceneTrack
---@field ConstraintSections TArray<UMovieSceneSection>
local UMovieScene3DConstraintTrack = {}



---@class UMovieScene3DPathSection : UMovieScene3DConstraintSection
---@field TimingCurve FMovieSceneFloatChannel
---@field FrontAxisEnum MovieScene3DPathSection_Axis
---@field UpAxisEnum MovieScene3DPathSection_Axis
---@field bFollow boolean
---@field bReverse boolean
---@field bForceUpright boolean
local UMovieScene3DPathSection = {}



---@class UMovieScene3DPathTrack : UMovieScene3DConstraintTrack
local UMovieScene3DPathTrack = {}


---@class UMovieScene3DTransformPropertySystem : UMovieScenePropertySystem
local UMovieScene3DTransformPropertySystem = {}


---@class UMovieScene3DTransformSection : UMovieSceneSection
---@field TransformMask FMovieSceneTransformMask
---@field Translation FMovieSceneDoubleChannel
---@field Rotation FMovieSceneDoubleChannel
---@field Scale FMovieSceneDoubleChannel
---@field ManualWeight FMovieSceneFloatChannel
---@field OverrideRegistry UMovieSceneSectionChannelOverrideRegistry
---@field Constraints UMovieScene3DTransformSectionConstraints
---@field bUseQuaternionInterpolation boolean
local UMovieScene3DTransformSection = {}



---@class UMovieScene3DTransformSectionConstraints : UObject
---@field ConstraintsChannels TArray<FConstraintAndActiveChannel>
local UMovieScene3DTransformSectionConstraints = {}



---@class UMovieScene3DTransformTrack : UMovieScenePropertyTrack
---@field BlenderSystemClass TSubclassOf<UMovieSceneBlenderSystem>
local UMovieScene3DTransformTrack = {}



---@class UMovieSceneActorReferenceSection : UMovieSceneSection
---@field ActorReferenceData FMovieSceneActorReferenceData
---@field ActorGuidIndexCurve FIntegralCurve
---@field ActorGuidStrings TArray<FString>
local UMovieSceneActorReferenceSection = {}



---@class UMovieSceneActorReferenceTrack : UMovieScenePropertyTrack
local UMovieSceneActorReferenceTrack = {}


---@class UMovieSceneAsyncAction_SequencePrediction : UBlueprintAsyncActionBase
---@field Result FMovieSceneAsyncAction_SequencePredictionResult
---@field Failure FMovieSceneAsyncAction_SequencePredictionFailure
---@field SequencePlayer UMovieSceneSequencePlayer
---@field SceneComponent USceneComponent
local UMovieSceneAsyncAction_SequencePrediction = {}

---@param Player UMovieSceneSequencePlayer
---@param TargetComponent USceneComponent
---@param TimeInSeconds float
---@return UMovieSceneAsyncAction_SequencePrediction
function UMovieSceneAsyncAction_SequencePrediction:PredictWorldTransformAtTime(Player, TargetComponent, TimeInSeconds) end
---@param Player UMovieSceneSequencePlayer
---@param TargetComponent USceneComponent
---@param FrameTime FFrameTime
---@return UMovieSceneAsyncAction_SequencePrediction
function UMovieSceneAsyncAction_SequencePrediction:PredictWorldTransformAtFrame(Player, TargetComponent, FrameTime) end
---@param Player UMovieSceneSequencePlayer
---@param TargetComponent USceneComponent
---@param TimeInSeconds float
---@return UMovieSceneAsyncAction_SequencePrediction
function UMovieSceneAsyncAction_SequencePrediction:PredictLocalTransformAtTime(Player, TargetComponent, TimeInSeconds) end
---@param Player UMovieSceneSequencePlayer
---@param TargetComponent USceneComponent
---@param FrameTime FFrameTime
---@return UMovieSceneAsyncAction_SequencePrediction
function UMovieSceneAsyncAction_SequencePrediction:PredictLocalTransformAtFrame(Player, TargetComponent, FrameTime) end


---@class UMovieSceneAudioSection : UMovieSceneSection
---@field Sound USoundBase
---@field StartFrameOffset FFrameNumber
---@field StartOffset float
---@field AudioStartTime float
---@field AudioDilationFactor float
---@field AudioVolume float
---@field SoundVolume FMovieSceneFloatChannel
---@field PitchMultiplier FMovieSceneFloatChannel
---@field Inputs_Float TMap<FName, FMovieSceneFloatChannel>
---@field Inputs_String TMap<FName, FMovieSceneStringChannel>
---@field Inputs_Bool TMap<FName, FMovieSceneBoolChannel>
---@field Inputs_Int TMap<FName, FMovieSceneIntegerChannel>
---@field Inputs_Trigger TMap<FName, FMovieSceneAudioTriggerChannel>
---@field AttachActorData FMovieSceneActorReferenceData
---@field bLooping boolean
---@field bSuppressSubtitles boolean
---@field bOverrideAttenuation boolean
---@field AttenuationSettings USoundAttenuation
---@field OnQueueSubtitles FMovieSceneAudioSectionOnQueueSubtitles
---@field OnAudioFinished FMovieSceneAudioSectionOnAudioFinished
---@field OnAudioPlaybackPercent FMovieSceneAudioSectionOnAudioPlaybackPercent
local UMovieSceneAudioSection = {}

---@param bInSuppressSubtitles boolean
function UMovieSceneAudioSection:SetSuppressSubtitles(bInSuppressSubtitles) end
---@param InStartOffset FFrameNumber
function UMovieSceneAudioSection:SetStartOffset(InStartOffset) end
---@param InSound USoundBase
function UMovieSceneAudioSection:SetSound(InSound) end
---@param bInOverrideAttenuation boolean
function UMovieSceneAudioSection:SetOverrideAttenuation(bInOverrideAttenuation) end
---@param bInLooping boolean
function UMovieSceneAudioSection:SetLooping(bInLooping) end
---@param InAttenuationSettings USoundAttenuation
function UMovieSceneAudioSection:SetAttenuationSettings(InAttenuationSettings) end
---@return boolean
function UMovieSceneAudioSection:GetSuppressSubtitles() end
---@return FFrameNumber
function UMovieSceneAudioSection:GetStartOffset() end
---@return USoundBase
function UMovieSceneAudioSection:GetSound() end
---@return boolean
function UMovieSceneAudioSection:GetOverrideAttenuation() end
---@return boolean
function UMovieSceneAudioSection:GetLooping() end
---@return USoundAttenuation
function UMovieSceneAudioSection:GetAttenuationSettings() end


---@class UMovieSceneAudioSystem : UMovieSceneEntitySystem
local UMovieSceneAudioSystem = {}


---@class UMovieSceneAudioTrack : UMovieSceneNameableTrack
---@field AudioSections TArray<UMovieSceneSection>
local UMovieSceneAudioTrack = {}



---@class UMovieSceneBaseCacheSection : UMovieSceneSection
local UMovieSceneBaseCacheSection = {}


---@class UMovieSceneBaseValueEvaluatorSystem : UMovieSceneEntitySystem
local UMovieSceneBaseValueEvaluatorSystem = {}


---@class UMovieSceneBoolPropertySystem : UMovieScenePropertySystem
local UMovieSceneBoolPropertySystem = {}


---@class UMovieSceneBoolTrack : UMovieScenePropertyTrack
local UMovieSceneBoolTrack = {}


---@class UMovieSceneBytePropertySystem : UMovieScenePropertySystem
local UMovieSceneBytePropertySystem = {}


---@class UMovieSceneByteSection : UMovieSceneSection
---@field ByteCurve FMovieSceneByteChannel
local UMovieSceneByteSection = {}



---@class UMovieSceneByteTrack : UMovieScenePropertyTrack
---@field Enum UEnum
local UMovieSceneByteTrack = {}



---@class UMovieSceneCVarSection : UMovieSceneSection
---@field ConsoleVariableCollections TArray<FMovieSceneConsoleVariableCollection>
---@field ConsoleVariables FMovieSceneCVarOverrides
local UMovieSceneCVarSection = {}

---@param InString FString
function UMovieSceneCVarSection:SetFromString(InString) end
---@return FString
function UMovieSceneCVarSection:GetString() end


---@class UMovieSceneCVarTrack : UMovieSceneNameableTrack
---@field Sections TArray<UMovieSceneSection>
local UMovieSceneCVarTrack = {}



---@class UMovieSceneCVarTrackInstance : UMovieSceneTrackInstance
local UMovieSceneCVarTrackInstance = {}


---@class UMovieSceneCameraCutSection : UMovieSceneSection
---@field bLockPreviousCamera boolean
---@field CameraGuid FGuid
---@field CameraBindingID FMovieSceneObjectBindingID
---@field InitialCameraCutTransform FTransform
---@field bHasInitialCameraCutTransform boolean
local UMovieSceneCameraCutSection = {}

---@param InCameraBindingID FMovieSceneObjectBindingID
function UMovieSceneCameraCutSection:SetCameraBindingID(InCameraBindingID) end
---@return FMovieSceneObjectBindingID
function UMovieSceneCameraCutSection:GetCameraBindingID() end


---@class UMovieSceneCameraCutTrack : UMovieSceneNameableTrack
---@field bCanBlend boolean
---@field Sections TArray<UMovieSceneSection>
---@field bAutoArrangeSections boolean
local UMovieSceneCameraCutTrack = {}



---@class UMovieSceneCameraCutTrackInstance : UMovieSceneTrackInstance
local UMovieSceneCameraCutTrackInstance = {}


---@class UMovieSceneCameraShakeEvaluatorSystem : UMovieSceneEntitySystem
local UMovieSceneCameraShakeEvaluatorSystem = {}


---@class UMovieSceneCameraShakeInstantiatorSystem : UMovieSceneEntitySystem
local UMovieSceneCameraShakeInstantiatorSystem = {}


---@class UMovieSceneCameraShakeSection : UMovieSceneSection
---@field ShakeData FMovieSceneCameraShakeSectionData
---@field ShakeClass TSubclassOf<UCameraShakeBase>
---@field PlayScale float
---@field PlaySpace ECameraShakePlaySpace
---@field UserDefinedPlaySpace FRotator
local UMovieSceneCameraShakeSection = {}



---@class UMovieSceneCameraShakeSourceShakeSection : UMovieSceneSection
---@field ShakeData FMovieSceneCameraShakeSectionData
local UMovieSceneCameraShakeSourceShakeSection = {}



---@class UMovieSceneCameraShakeSourceShakeTrack : UMovieSceneNameableTrack
---@field CameraShakeSections TArray<UMovieSceneSection>
local UMovieSceneCameraShakeSourceShakeTrack = {}



---@class UMovieSceneCameraShakeSourceTriggerSection : UMovieSceneSection
---@field Channel FMovieSceneCameraShakeSourceTriggerChannel
local UMovieSceneCameraShakeSourceTriggerSection = {}



---@class UMovieSceneCameraShakeSourceTriggerTrack : UMovieSceneTrack
---@field Sections TArray<UMovieSceneSection>
local UMovieSceneCameraShakeSourceTriggerTrack = {}



---@class UMovieSceneCameraShakeTrack : UMovieSceneNameableTrack
---@field CameraShakeSections TArray<UMovieSceneSection>
local UMovieSceneCameraShakeTrack = {}



---@class UMovieSceneCinematicShotSection : UMovieSceneSubSection
---@field ShotDisplayName FString
---@field DisplayName FText
local UMovieSceneCinematicShotSection = {}

---@param InShotDisplayName FString
function UMovieSceneCinematicShotSection:SetShotDisplayName(InShotDisplayName) end
---@return FString
function UMovieSceneCinematicShotSection:GetShotDisplayName() end


---@class UMovieSceneCinematicShotTrack : UMovieSceneSubTrack
local UMovieSceneCinematicShotTrack = {}


---@class UMovieSceneColorPropertySystem : UMovieScenePropertySystem
local UMovieSceneColorPropertySystem = {}


---@class UMovieSceneColorSection : UMovieSceneSection
---@field RedCurve FMovieSceneFloatChannel
---@field GreenCurve FMovieSceneFloatChannel
---@field BlueCurve FMovieSceneFloatChannel
---@field AlphaCurve FMovieSceneFloatChannel
local UMovieSceneColorSection = {}



---@class UMovieSceneColorTrack : UMovieScenePropertyTrack
---@field bIsSlateColor boolean
local UMovieSceneColorTrack = {}



---@class UMovieSceneComponentAttachmentInvalidatorSystem : UMovieSceneEntityInstantiatorSystem
local UMovieSceneComponentAttachmentInvalidatorSystem = {}


---@class UMovieSceneComponentAttachmentSystem : UMovieSceneEntityInstantiatorSystem
local UMovieSceneComponentAttachmentSystem = {}


---@class UMovieSceneComponentMaterialParameterSection : UMovieSceneSection
---@field ScalarParameterInfosAndCurves TArray<FScalarMaterialParameterInfoAndCurve>
---@field ColorParameterInfosAndCurves TArray<FColorMaterialParameterInfoAndCurves>
local UMovieSceneComponentMaterialParameterSection = {}

---@param InParameterInfo FMaterialParameterInfo
---@return boolean
function UMovieSceneComponentMaterialParameterSection:RemoveScalarParameter(InParameterInfo) end
---@param InParameterInfo FMaterialParameterInfo
---@return boolean
function UMovieSceneComponentMaterialParameterSection:RemoveColorParameter(InParameterInfo) end
---@param InParameterInfo FMaterialParameterInfo
---@param InTime FFrameNumber
---@param InValue float
---@param InLayerName FString
---@param InAssetName FString
function UMovieSceneComponentMaterialParameterSection:AddScalarParameterKey(InParameterInfo, InTime, InValue, InLayerName, InAssetName) end
---@param InParameterInfo FMaterialParameterInfo
---@param InTime FFrameNumber
---@param InValue FLinearColor
---@param InLayerName FString
---@param InAssetName FString
---@param InChannelNames FParameterChannelNames
function UMovieSceneComponentMaterialParameterSection:AddColorParameterKey(InParameterInfo, InTime, InValue, InLayerName, InAssetName, InChannelNames) end


---@class UMovieSceneComponentMaterialSystem : UMovieSceneEntitySystem
local UMovieSceneComponentMaterialSystem = {}


---@class UMovieSceneComponentMaterialTrack : UMovieSceneMaterialTrack
---@field MaterialInfo FComponentMaterialInfo
local UMovieSceneComponentMaterialTrack = {}



---@class UMovieSceneComponentMobilitySystem : UMovieSceneEntityInstantiatorSystem
local UMovieSceneComponentMobilitySystem = {}


---@class UMovieSceneComponentTransformSystem : UMovieScenePropertySystem
local UMovieSceneComponentTransformSystem = {}


---@class UMovieSceneConstraintSystem : UMovieSceneEntitySystem
local UMovieSceneConstraintSystem = {}


---@class UMovieSceneCustomPrimitiveDataSection : UMovieSceneParameterSection
local UMovieSceneCustomPrimitiveDataSection = {}


---@class UMovieSceneCustomPrimitiveDataSystem : UMovieSceneEntitySystem
---@field DoubleBlenderSystem UMovieScenePiecewiseDoubleBlenderSystem
local UMovieSceneCustomPrimitiveDataSystem = {}



---@class UMovieSceneCustomPrimitiveDataTrack : UMovieSceneNameableTrack
---@field Sections TArray<UMovieSceneSection>
---@field SectionToKey UMovieSceneSection
local UMovieSceneCustomPrimitiveDataTrack = {}



---@class UMovieSceneDataLayerSection : UMovieSceneSection
---@field DataLayerAssets TArray<UDataLayerAsset>
---@field DesiredState EDataLayerRuntimeState
---@field PrerollState EDataLayerRuntimeState
---@field bFlushOnActivated boolean
---@field bFlushOnUnload boolean
local UMovieSceneDataLayerSection = {}

---@param InPrerollState EDataLayerRuntimeState
function UMovieSceneDataLayerSection:SetPrerollState(InPrerollState) end
---@param bFlushOnUnload boolean
function UMovieSceneDataLayerSection:SetFlushOnUnload(bFlushOnUnload) end
---@param bFlushOnActivated boolean
function UMovieSceneDataLayerSection:SetFlushOnActivated(bFlushOnActivated) end
---@param InDesiredState EDataLayerRuntimeState
function UMovieSceneDataLayerSection:SetDesiredState(InDesiredState) end
---@param InDataLayerAssets TArray<UDataLayerAsset>
function UMovieSceneDataLayerSection:SetDataLayerAssets(InDataLayerAssets) end
---@return boolean
function UMovieSceneDataLayerSection:HasPreRoll() end
---@return EDataLayerRuntimeState
function UMovieSceneDataLayerSection:GetPrerollState() end
---@return boolean
function UMovieSceneDataLayerSection:GetFlushOnUnload() end
---@return boolean
function UMovieSceneDataLayerSection:GetFlushOnActivated() end
---@return EDataLayerRuntimeState
function UMovieSceneDataLayerSection:GetDesiredState() end
---@return TArray<UDataLayerAsset>
function UMovieSceneDataLayerSection:GetDataLayerAssets() end


---@class UMovieSceneDataLayerSystem : UMovieSceneEntitySystem
local UMovieSceneDataLayerSystem = {}


---@class UMovieSceneDataLayerTrack : UMovieSceneNameableTrack
---@field Sections TArray<UMovieSceneSection>
local UMovieSceneDataLayerTrack = {}



---@class UMovieSceneDecomposerTestObject : UObject
---@field FloatProperty float
local UMovieSceneDecomposerTestObject = {}



---@class UMovieSceneDeferredComponentMovementSystem : UMovieSceneEntitySystem
local UMovieSceneDeferredComponentMovementSystem = {}


---@class UMovieSceneDirectorBlueprintCondition : UMovieSceneCondition
---@field DirectorBlueprintConditionData FMovieSceneDirectorBlueprintConditionData
---@field Scope EMovieSceneConditionScope
---@field CheckFrequency EMovieSceneConditionCheckFrequency
local UMovieSceneDirectorBlueprintCondition = {}



---@class UMovieSceneDoublePerlinNoiseChannelContainer : UMovieSceneChannelOverrideContainer
---@field PerlinNoiseChannel FMovieSceneDoublePerlinNoiseChannel
local UMovieSceneDoublePerlinNoiseChannelContainer = {}



---@class UMovieSceneDoublePropertySystem : UMovieScenePropertySystem
local UMovieSceneDoublePropertySystem = {}


---@class UMovieSceneDoubleSection : UMovieSceneSection
---@field DoubleCurve FMovieSceneDoubleChannel
local UMovieSceneDoubleSection = {}



---@class UMovieSceneDoubleTrack : UMovieScenePropertyTrack
local UMovieSceneDoubleTrack = {}


---@class UMovieSceneDoubleVectorPropertySystem : UMovieScenePropertySystem
local UMovieSceneDoubleVectorPropertySystem = {}


---@class UMovieSceneDoubleVectorSection : UMovieSceneSection
---@field Curves FMovieSceneDoubleChannel
---@field ChannelsUsed int32
local UMovieSceneDoubleVectorSection = {}



---@class UMovieSceneDoubleVectorTrack : UMovieScenePropertyTrack
---@field NumChannelsUsed int32
local UMovieSceneDoubleVectorTrack = {}



---@class UMovieSceneEnumPropertySystem : UMovieScenePropertySystem
local UMovieSceneEnumPropertySystem = {}


---@class UMovieSceneEnumSection : UMovieSceneSection
---@field EnumCurve FMovieSceneByteChannel
local UMovieSceneEnumSection = {}



---@class UMovieSceneEnumTrack : UMovieScenePropertyTrack
---@field Enum UEnum
local UMovieSceneEnumTrack = {}



---@class UMovieSceneEulerTransformPropertySystem : UMovieScenePropertySystem
local UMovieSceneEulerTransformPropertySystem = {}


---@class UMovieSceneEulerTransformTrack : UMovieScenePropertyTrack
local UMovieSceneEulerTransformTrack = {}


---@class UMovieSceneEventRepeaterSection : UMovieSceneEventSectionBase
---@field Event FMovieSceneEvent
local UMovieSceneEventRepeaterSection = {}



---@class UMovieSceneEventSection : UMovieSceneSection
---@field Events FNameCurve
---@field EventData FMovieSceneEventSectionData
local UMovieSceneEventSection = {}



---@class UMovieSceneEventSectionBase : UMovieSceneSection
local UMovieSceneEventSectionBase = {}


---@class UMovieSceneEventSystem : UMovieSceneEntitySystem
local UMovieSceneEventSystem = {}


---@class UMovieSceneEventTrack : UMovieSceneNameableTrack
---@field bFireEventsWhenForwards boolean
---@field bFireEventsWhenBackwards boolean
---@field EventPosition EFireEventsAtPosition
---@field Sections TArray<UMovieSceneSection>
local UMovieSceneEventTrack = {}



---@class UMovieSceneEventTriggerSection : UMovieSceneEventSectionBase
---@field EventChannel FMovieSceneEventChannel
local UMovieSceneEventTriggerSection = {}



---@class UMovieSceneFadeSection : UMovieSceneSection
---@field FloatCurve FMovieSceneFloatChannel
---@field FadeColor FLinearColor
---@field bFadeAudio boolean
local UMovieSceneFadeSection = {}



---@class UMovieSceneFadeSystem : UMovieSceneEntitySystem
local UMovieSceneFadeSystem = {}


---@class UMovieSceneFadeTrack : UMovieSceneFloatTrack
local UMovieSceneFadeTrack = {}


---@class UMovieSceneFloatPerlinNoiseChannelContainer : UMovieSceneChannelOverrideContainer
---@field PerlinNoiseChannel FMovieSceneFloatPerlinNoiseChannel
local UMovieSceneFloatPerlinNoiseChannelContainer = {}



---@class UMovieSceneFloatPropertySystem : UMovieScenePropertySystem
local UMovieSceneFloatPropertySystem = {}


---@class UMovieSceneFloatSection : UMovieSceneSection
---@field FloatCurve FMovieSceneFloatChannel
---@field OverrideRegistry UMovieSceneSectionChannelOverrideRegistry
local UMovieSceneFloatSection = {}



---@class UMovieSceneFloatTrack : UMovieScenePropertyTrack
local UMovieSceneFloatTrack = {}


---@class UMovieSceneFloatVectorPropertySystem : UMovieScenePropertySystem
local UMovieSceneFloatVectorPropertySystem = {}


---@class UMovieSceneFloatVectorSection : UMovieSceneSection
---@field Curves FMovieSceneFloatChannel
---@field ChannelsUsed int32
local UMovieSceneFloatVectorSection = {}



---@class UMovieSceneFloatVectorTrack : UMovieScenePropertyTrack
---@field NumChannelsUsed int32
local UMovieSceneFloatVectorTrack = {}



---@class UMovieSceneHierarchicalBiasSystem : UMovieSceneEntityInstantiatorSystem
---@field GroupingSystem UMovieSceneEntityGroupingSystem
local UMovieSceneHierarchicalBiasSystem = {}



---@class UMovieSceneHierarchicalEasingFinalizationSystem : UMovieSceneEntityInstantiatorSystem
local UMovieSceneHierarchicalEasingFinalizationSystem = {}


---@class UMovieSceneHierarchicalEasingInstantiatorSystem : UMovieSceneEntityInstantiatorSystem
---@field EvaluatorSystem UWeightAndEasingEvaluatorSystem
local UMovieSceneHierarchicalEasingInstantiatorSystem = {}



---@class UMovieSceneInitialValueSystem : UMovieSceneEntityInstantiatorSystem
local UMovieSceneInitialValueSystem = {}


---@class UMovieSceneIntegerPropertySystem : UMovieScenePropertySystem
local UMovieSceneIntegerPropertySystem = {}


---@class UMovieSceneIntegerSection : UMovieSceneSection
---@field IntegerCurve FMovieSceneIntegerChannel
local UMovieSceneIntegerSection = {}



---@class UMovieSceneIntegerTrack : UMovieScenePropertyTrack
local UMovieSceneIntegerTrack = {}


---@class UMovieSceneInterrogatedPropertyInstantiatorSystem : UMovieSceneEntityInstantiatorSystem
local UMovieSceneInterrogatedPropertyInstantiatorSystem = {}


---@class UMovieSceneLevelVisibilitySection : UMovieSceneSection
---@field Visibility ELevelVisibility
---@field LevelNames TArray<FName>
local UMovieSceneLevelVisibilitySection = {}

---@param InVisibility ELevelVisibility
function UMovieSceneLevelVisibilitySection:SetVisibility(InVisibility) end
---@param InLevelNames TArray<FName>
function UMovieSceneLevelVisibilitySection:SetLevelNames(InLevelNames) end
---@return ELevelVisibility
function UMovieSceneLevelVisibilitySection:GetVisibility() end
---@return TArray<FName>
function UMovieSceneLevelVisibilitySection:GetLevelNames() end


---@class UMovieSceneLevelVisibilitySystem : UMovieSceneEntitySystem
local UMovieSceneLevelVisibilitySystem = {}


---@class UMovieSceneLevelVisibilityTrack : UMovieSceneNameableTrack
---@field Sections TArray<UMovieSceneSection>
local UMovieSceneLevelVisibilityTrack = {}



---@class UMovieSceneMaterialParameterCollectionSystem : UMovieSceneEntitySystem
local UMovieSceneMaterialParameterCollectionSystem = {}


---@class UMovieSceneMaterialParameterCollectionTrack : UMovieSceneMaterialTrack
---@field MPC UMaterialParameterCollection
local UMovieSceneMaterialParameterCollectionTrack = {}



---@class UMovieSceneMaterialParameterEvaluationSystem : UMovieSceneEntitySystem
local UMovieSceneMaterialParameterEvaluationSystem = {}


---@class UMovieSceneMaterialParameterInstantiatorSystem : UMovieSceneEntityInstantiatorSystem
---@field DoubleBlenderSystem UMovieScenePiecewiseDoubleBlenderSystem
local UMovieSceneMaterialParameterInstantiatorSystem = {}



---@class UMovieSceneMaterialTrack : UMovieSceneNameableTrack
---@field Sections TArray<UMovieSceneSection>
---@field SectionToKey UMovieSceneSection
local UMovieSceneMaterialTrack = {}



---@class UMovieSceneMotionVectorSimulationSystem : UMovieSceneEntitySystem
local UMovieSceneMotionVectorSimulationSystem = {}


---@class UMovieSceneObjectPropertySection : UMovieSceneSection
---@field ObjectChannel FMovieSceneObjectPathChannel
local UMovieSceneObjectPropertySection = {}



---@class UMovieSceneObjectPropertySystem : UMovieScenePropertySystem
local UMovieSceneObjectPropertySystem = {}


---@class UMovieSceneObjectPropertyTrack : UMovieScenePropertyTrack
---@field PropertyClass UClass
local UMovieSceneObjectPropertyTrack = {}



---@class UMovieSceneParameterSection : UMovieSceneSection
---@field BoolParameterNamesAndCurves TArray<FBoolParameterNameAndCurve>
---@field ScalarParameterNamesAndCurves TArray<FScalarParameterNameAndCurve>
---@field Vector2DParameterNamesAndCurves TArray<FVector2DParameterNameAndCurves>
---@field VectorParameterNamesAndCurves TArray<FVectorParameterNameAndCurves>
---@field ColorParameterNamesAndCurves TArray<FColorParameterNameAndCurves>
---@field TransformParameterNamesAndCurves TArray<FTransformParameterNameAndCurves>
local UMovieSceneParameterSection = {}

---@param InParameterName FName
---@return boolean
function UMovieSceneParameterSection:RemoveVectorParameter(InParameterName) end
---@param InParameterName FName
---@return boolean
function UMovieSceneParameterSection:RemoveVector2DParameter(InParameterName) end
---@param InParameterName FName
---@return boolean
function UMovieSceneParameterSection:RemoveTransformParameter(InParameterName) end
---@param InParameterName FName
---@return boolean
function UMovieSceneParameterSection:RemoveScalarParameter(InParameterName) end
---@param InParameterName FName
---@return boolean
function UMovieSceneParameterSection:RemoveColorParameter(InParameterName) end
---@param InParameterName FName
---@return boolean
function UMovieSceneParameterSection:RemoveBoolParameter(InParameterName) end
---@param ParameterNames TSet<FName>
function UMovieSceneParameterSection:GetParameterNames(ParameterNames) end
---@param InParameterName FName
---@param InTime FFrameNumber
---@param InValue FVector
function UMovieSceneParameterSection:AddVectorParameterKey(InParameterName, InTime, InValue) end
---@param InParameterName FName
---@param InTime FFrameNumber
---@param InValue FVector2D
function UMovieSceneParameterSection:AddVector2DParameterKey(InParameterName, InTime, InValue) end
---@param InParameterName FName
---@param InTime FFrameNumber
---@param InValue FTransform
function UMovieSceneParameterSection:AddTransformParameterKey(InParameterName, InTime, InValue) end
---@param InParameterName FName
---@param InTime FFrameNumber
---@param InValue float
function UMovieSceneParameterSection:AddScalarParameterKey(InParameterName, InTime, InValue) end
---@param InParameterName FName
---@param InTime FFrameNumber
---@param InValue FLinearColor
function UMovieSceneParameterSection:AddColorParameterKey(InParameterName, InTime, InValue) end
---@param InParameterName FName
---@param InTime FFrameNumber
---@param InValue boolean
function UMovieSceneParameterSection:AddBoolParameterKey(InParameterName, InTime, InValue) end


---@class UMovieScenePartialEvaluationTestObject : UObject
---@field FloatProperty float
---@field VectorProperty FVector
local UMovieScenePartialEvaluationTestObject = {}



---@class UMovieSceneParticleParameterTrack : UMovieSceneNameableTrack
---@field Sections TArray<UMovieSceneSection>
local UMovieSceneParticleParameterTrack = {}



---@class UMovieSceneParticleSection : UMovieSceneSection
---@field ParticleKeys FMovieSceneParticleChannel
local UMovieSceneParticleSection = {}



---@class UMovieSceneParticleTrack : UMovieSceneNameableTrack
---@field ParticleSections TArray<UMovieSceneSection>
local UMovieSceneParticleTrack = {}



---@class UMovieScenePiecewiseBoolBlenderSystem : UMovieSceneBlenderSystem
local UMovieScenePiecewiseBoolBlenderSystem = {}


---@class UMovieScenePiecewiseByteBlenderSystem : UMovieSceneBlenderSystem
local UMovieScenePiecewiseByteBlenderSystem = {}


---@class UMovieScenePiecewiseDoubleBlenderSystem : UMovieSceneBlenderSystem
local UMovieScenePiecewiseDoubleBlenderSystem = {}


---@class UMovieScenePiecewiseEnumBlenderSystem : UMovieSceneBlenderSystem
local UMovieScenePiecewiseEnumBlenderSystem = {}


---@class UMovieScenePiecewiseIntegerBlenderSystem : UMovieSceneBlenderSystem
local UMovieScenePiecewiseIntegerBlenderSystem = {}


---@class UMovieScenePlatformCondition : UMovieSceneCondition
---@field ValidPlatforms TArray<FName>
local UMovieScenePlatformCondition = {}



---@class UMovieScenePostEvalEventSystem : UMovieSceneEventSystem
local UMovieScenePostEvalEventSystem = {}


---@class UMovieScenePostSpawnEventSystem : UMovieSceneEventSystem
local UMovieScenePostSpawnEventSystem = {}


---@class UMovieScenePreSpawnEventSystem : UMovieSceneEventSystem
local UMovieScenePreSpawnEventSystem = {}


---@class UMovieScenePredictionSystem : UMovieSceneEntitySystem
---@field PendingPredictions TArray<UMovieSceneAsyncAction_SequencePrediction>
---@field ProcessingPredictions TArray<UMovieSceneAsyncAction_SequencePrediction>
local UMovieScenePredictionSystem = {}



---@class UMovieScenePrimitiveMaterialSection : UMovieSceneSection
---@field MaterialChannel FMovieSceneObjectPathChannel
local UMovieScenePrimitiveMaterialSection = {}



---@class UMovieScenePrimitiveMaterialTrack : UMovieScenePropertyTrack
---@field MaterialInfo FComponentMaterialInfo
local UMovieScenePrimitiveMaterialTrack = {}



---@class UMovieScenePropertyInstantiatorSystem : UMovieSceneEntityInstantiatorSystem
local UMovieScenePropertyInstantiatorSystem = {}


---@class UMovieScenePropertySystem : UMovieSceneEntitySystem
---@field InstantiatorSystem UMovieScenePropertyInstantiatorSystem
local UMovieScenePropertySystem = {}



---@class UMovieScenePropertyTrack : UMovieSceneNameableTrack
---@field SectionToKey UMovieSceneSection
---@field PropertyBinding FMovieScenePropertyBinding
---@field Sections TArray<UMovieSceneSection>
local UMovieScenePropertyTrack = {}



---@class UMovieSceneQuaternionBlenderSystem : UMovieSceneBlenderSystem
local UMovieSceneQuaternionBlenderSystem = {}


---@class UMovieSceneQuaternionInterpolationRotationSystem : UMovieSceneEntitySystem
local UMovieSceneQuaternionInterpolationRotationSystem = {}


---@class UMovieSceneReplaceableActorBinding : UMovieSceneReplaceableBindingBase
local UMovieSceneReplaceableActorBinding = {}


---@class UMovieSceneReplaceableActorBinding_BPBase : UMovieSceneReplaceableBindingBase
---@field CustomBindingPriority int32
---@field PreviewSpawnableType TSubclassOf<UMovieSceneSpawnableBindingBase>
local UMovieSceneReplaceableActorBinding_BPBase = {}

---@param SourceObject UObject
---@return boolean
function UMovieSceneReplaceableActorBinding_BPBase:BP_SupportsBindingCreationFromObject(SourceObject) end
---@param ResolveContext FMovieSceneBindingResolveContext
---@return FMovieSceneBindingResolveResult
function UMovieSceneReplaceableActorBinding_BPBase:BP_ResolveRuntimeBinding(ResolveContext) end
---@param SourceObject UObject
---@param OwnerMovieScene UMovieScene
function UMovieSceneReplaceableActorBinding_BPBase:BP_InitReplaceableBinding(SourceObject, OwnerMovieScene) end


---@class UMovieSceneReplaceableDirectorBlueprintBinding : UMovieSceneReplaceableBindingBase
---@field DynamicBinding FMovieSceneDynamicBinding
---@field PreviewSpawnableType TSubclassOf<UMovieSceneSpawnableBindingBase>
local UMovieSceneReplaceableDirectorBlueprintBinding = {}



---@class UMovieSceneRotatorPropertySystem : UMovieScenePropertySystem
local UMovieSceneRotatorPropertySystem = {}


---@class UMovieSceneRotatorSection : UMovieSceneSection
---@field Rotation FMovieSceneDoubleChannel
local UMovieSceneRotatorSection = {}



---@class UMovieSceneRotatorTrack : UMovieScenePropertyTrack
local UMovieSceneRotatorTrack = {}


---@class UMovieSceneScalabilityCondition : UMovieSceneCondition
---@field Group EMovieSceneScalabilityConditionGroup
---@field Operator EMovieSceneScalabilityConditionOperator
---@field Level EMovieSceneScalabilityConditionLevel
local UMovieSceneScalabilityCondition = {}



---@class UMovieSceneSkeletalAnimationSection : UMovieSceneSection
---@field Params FMovieSceneSkeletalAnimationParams
---@field AnimSequence UAnimSequence
---@field Animation UAnimSequenceBase
---@field StartOffset float
---@field EndOffset float
---@field PlayRate float
---@field bReverse boolean
---@field SlotName FName
---@field StartLocationOffset FVector
---@field StartRotationOffset FRotator
---@field MatchedBoneName FName
---@field MatchedLocationOffset FVector
---@field MatchedRotationOffset FRotator
---@field bMatchWithPrevious boolean
---@field bMatchTranslation boolean
---@field bMatchIncludeZHeight boolean
---@field bMatchRotationYaw boolean
---@field bMatchRotationPitch boolean
---@field bMatchRotationRoll boolean
---@field bDebugForceTickPose boolean
local UMovieSceneSkeletalAnimationSection = {}



---@class UMovieSceneSkeletalAnimationSystem : UMovieSceneEntitySystem
local UMovieSceneSkeletalAnimationSystem = {}


---@class UMovieSceneSkeletalAnimationTrack : UMovieSceneNameableTrack
---@field AnimationSections TArray<UMovieSceneSection>
---@field bUseLegacySectionIndexBlend boolean
---@field RootMotionParams FMovieSceneSkeletalAnimRootMotionTrackParams
---@field bBlendFirstChildOfRoot boolean
---@field SwapRootBone ESwapRootBone
local UMovieSceneSkeletalAnimationTrack = {}

---@param InValue ESwapRootBone
function UMovieSceneSkeletalAnimationTrack:SetSwapRootBone(InValue) end
---@return ESwapRootBone
function UMovieSceneSkeletalAnimationTrack:GetSwapRootBone() end


---@class UMovieSceneSlomoSection : UMovieSceneSection
---@field FloatCurve FMovieSceneFloatChannel
local UMovieSceneSlomoSection = {}



---@class UMovieSceneSlomoSystem : UMovieSceneEntitySystem
local UMovieSceneSlomoSystem = {}


---@class UMovieSceneSlomoTrack : UMovieSceneFloatTrack
local UMovieSceneSlomoTrack = {}


---@class UMovieSceneSpawnableActorBinding : UMovieSceneSpawnableActorBindingBase
---@field ActorTemplate AActor
local UMovieSceneSpawnableActorBinding = {}



---@class UMovieSceneSpawnableActorBindingBase : UMovieSceneSpawnableBindingBase
---@field bNetAddressableName boolean
---@field LevelName FName
local UMovieSceneSpawnableActorBindingBase = {}



---@class UMovieSceneSpawnableDirectorBlueprintBinding : UMovieSceneSpawnableBindingBase
---@field DynamicBinding FMovieSceneDynamicBinding
local UMovieSceneSpawnableDirectorBlueprintBinding = {}



---@class UMovieSceneStringPropertySystem : UMovieScenePropertySystem
local UMovieSceneStringPropertySystem = {}


---@class UMovieSceneStringSection : UMovieSceneSection
---@field StringCurve FMovieSceneStringChannel
local UMovieSceneStringSection = {}



---@class UMovieSceneStringTrack : UMovieScenePropertyTrack
local UMovieSceneStringTrack = {}


---@class UMovieSceneTestSequence : UMovieSceneSequence
---@field MovieScene UMovieScene
---@field BoundObjects TArray<UObject>
---@field BindingGuids TArray<FGuid>
local UMovieSceneTestSequence = {}



---@class UMovieSceneTransformOriginInstantiatorSystem : UMovieSceneEntitySystem
local UMovieSceneTransformOriginInstantiatorSystem = {}


---@class UMovieSceneTransformOriginSystem : UMovieSceneEntitySystem
local UMovieSceneTransformOriginSystem = {}


---@class UMovieSceneTransformTrack : UMovieScenePropertyTrack
local UMovieSceneTransformTrack = {}


---@class UMovieSceneVisibilitySection : UMovieSceneBoolSection
local UMovieSceneVisibilitySection = {}


---@class UMovieSceneVisibilitySystem : UMovieSceneEntityInstantiatorSystem
local UMovieSceneVisibilitySystem = {}


---@class UMovieSceneVisibilityTrack : UMovieScenePropertyTrack
local UMovieSceneVisibilityTrack = {}


---@class UObjectPathChannelEvaluatorSystem : UMovieSceneEntitySystem
local UObjectPathChannelEvaluatorSystem = {}


---@class UStringChannelEvaluatorSystem : UMovieSceneEntitySystem
local UStringChannelEvaluatorSystem = {}


---@class UWeightAndEasingEvaluatorSystem : UMovieSceneEntitySystem
local UWeightAndEasingEvaluatorSystem = {}


