---@meta

---@class ANiagaraActor : AActor
---@field NiagaraComponent UNiagaraComponent
---@field bDestroyOnSystemFinish boolean
local ANiagaraActor = {}

---@param bShouldDestroyOnSystemFinish boolean
function ANiagaraActor:SetDestroyOnSystemFinish(bShouldDestroyOnSystemFinish) end
---@param FinishedComponent UNiagaraComponent
function ANiagaraActor:OnNiagaraSystemFinished(FinishedComponent) end
---@return boolean
function ANiagaraActor:GetDestroyOnSystemFinish() end


---@class ANiagaraLensEffectBase : ANiagaraActor
---@field DesiredRelativeTransform FTransform
---@field BaseAuthoredFOV float
---@field bAllowMultipleInstances boolean
---@field bResetWhenRetriggered boolean
---@field EmittersToTreatAsSame TArray<TSubclassOf<AActor>>
---@field OwningCameraManager APlayerCameraManager
local ANiagaraLensEffectBase = {}



---@class ANiagaraPerfBaselineActor : AActor
---@field Controller UNiagaraBaselineController
---@field Label UTextRenderComponent
local ANiagaraPerfBaselineActor = {}



---@class ANiagaraPreviewBase : AActor
local ANiagaraPreviewBase = {}

---@param InSystem UNiagaraSystem
function ANiagaraPreviewBase:SetSystem(InSystem) end
---@param InXAxisText FText
---@param InYAxisText FText
function ANiagaraPreviewBase:SetLabelText(InXAxisText, InYAxisText) end


---@class ANiagaraPreviewGrid : AActor
---@field System UNiagaraSystem
---@field ResetMode ENiagaraPreviewGridResetMode
---@field PreviewAxisX UNiagaraPreviewAxis
---@field PreviewAxisY UNiagaraPreviewAxis
---@field PreviewClass TSubclassOf<ANiagaraPreviewBase>
---@field SpacingX float
---@field SpacingY float
---@field NumX int32
---@field NumY int32
---@field PreviewComponents TArray<UChildActorComponent>
local ANiagaraPreviewGrid = {}

---@param bPaused boolean
function ANiagaraPreviewGrid:SetPaused(bPaused) end
---@param OutPreviews TArray<UNiagaraComponent>
function ANiagaraPreviewGrid:GetPreviews(OutPreviews) end
function ANiagaraPreviewGrid:DeactivatePreviews() end
---@param bReset boolean
function ANiagaraPreviewGrid:ActivatePreviews(bReset) end


---@class FBasicParticleData
---@field Position FVector
---@field Size float
---@field Velocity FVector
local FBasicParticleData = {}



---@class FEmitterCompiledScriptPair
local FEmitterCompiledScriptPair = {}


---@class FMeshTriCoordinate
---@field Tri int32
---@field BaryCoord FVector3f
local FMeshTriCoordinate = {}



---@class FMovieSceneNiagaraBoolParameterSectionTemplate : FMovieSceneNiagaraParameterSectionTemplate
---@field BoolChannel FMovieSceneBoolChannel
local FMovieSceneNiagaraBoolParameterSectionTemplate = {}



---@class FMovieSceneNiagaraColorParameterSectionTemplate : FMovieSceneNiagaraParameterSectionTemplate
---@field RedChannel FMovieSceneFloatChannel
---@field GreenChannel FMovieSceneFloatChannel
---@field BlueChannel FMovieSceneFloatChannel
---@field AlphaChannel FMovieSceneFloatChannel
local FMovieSceneNiagaraColorParameterSectionTemplate = {}



---@class FMovieSceneNiagaraFloatParameterSectionTemplate : FMovieSceneNiagaraParameterSectionTemplate
---@field FloatChannel FMovieSceneFloatChannel
local FMovieSceneNiagaraFloatParameterSectionTemplate = {}



---@class FMovieSceneNiagaraIntegerParameterSectionTemplate : FMovieSceneNiagaraParameterSectionTemplate
---@field IntegerChannel FMovieSceneIntegerChannel
local FMovieSceneNiagaraIntegerParameterSectionTemplate = {}



---@class FMovieSceneNiagaraParameterSectionTemplate : FMovieSceneEvalTemplate
---@field Parameter FNiagaraVariable
local FMovieSceneNiagaraParameterSectionTemplate = {}



---@class FMovieSceneNiagaraSystemTrackImplementation : FMovieSceneTrackImplementation
---@field SpawnSectionStartFrame FFrameNumber
---@field SpawnSectionEndFrame FFrameNumber
---@field SpawnSectionStartBehavior ENiagaraSystemSpawnSectionStartBehavior
---@field SpawnSectionEvaluateBehavior ENiagaraSystemSpawnSectionEvaluateBehavior
---@field SpawnSectionEndBehavior ENiagaraSystemSpawnSectionEndBehavior
---@field AgeUpdateMode ENiagaraAgeUpdateMode
---@field bAllowScalability boolean
local FMovieSceneNiagaraSystemTrackImplementation = {}



---@class FMovieSceneNiagaraSystemTrackTemplate : FMovieSceneEvalTemplate
local FMovieSceneNiagaraSystemTrackTemplate = {}


---@class FMovieSceneNiagaraVectorParameterSectionTemplate : FMovieSceneNiagaraParameterSectionTemplate
---@field VectorChannels FMovieSceneFloatChannel
---@field ChannelsUsed int32
local FMovieSceneNiagaraVectorParameterSectionTemplate = {}



---@class FNCPool
---@field FreeElements TArray<FNCPoolElement>
local FNCPool = {}



---@class FNCPoolElement
---@field Component UNiagaraComponent
local FNCPoolElement = {}



---@class FNDCIsland
---@field Owner UNiagaraDataChannelHandler_Islands
---@field Bounds FBoxSphereBounds
---@field NiagaraSystems TArray<UNiagaraComponent>
local FNDCIsland = {}



---@class FNDCIslandDebugDrawSettings
---@field bEnabled boolean
---@field bShowIslandBounds boolean
local FNDCIslandDebugDrawSettings = {}



---@class FNDIArraySimCacheDataFrame
---@field NumElements int32
---@field DataOffset int32
local FNDIArraySimCacheDataFrame = {}



---@class FNDIDataChannelCompiledData
---@field FunctionInfo TArray<FNDIDataChannelFunctionInfo>
---@field GPUScriptParameterInfos TMap<FNiagaraCompileHash, FNDIDataChannel_GPUScriptParameterAccessInfo>
---@field TotalParams uint32
---@field bUsedByCPU boolean
---@field bUsedByGPU boolean
---@field bNeedsSpawnDataTable boolean
---@field bSpawnsParticles boolean
---@field bCallsWrite boolean
local FNDIDataChannelCompiledData = {}



---@class FNDIDataChannelFunctionInfo
---@field FunctionName FName
---@field Inputs TArray<FNiagaraVariableBase>
---@field Outputs TArray<FNiagaraVariableBase>
local FNDIDataChannelFunctionInfo = {}



---@class FNDIDataChannelWriteCompiledData : FNDIDataChannelCompiledData
---@field DataLayout FNiagaraDataSetCompiledData
local FNDIDataChannelWriteCompiledData = {}



---@class FNDIDataChannelWriteSimCacheFrame
---@field NumElements int32
---@field VariableData TArray<FNDIDataChannelWriteSimCacheFrameBuffer>
---@field bVisibleToGame boolean
---@field bVisibleToCPUSims boolean
---@field bVisibleToGPUSims boolean
local FNDIDataChannelWriteSimCacheFrame = {}



---@class FNDIDataChannelWriteSimCacheFrameBuffer
---@field Data TArray<uint8>
---@field Size int32
---@field SourceVar FNiagaraVariableBase
local FNDIDataChannelWriteSimCacheFrameBuffer = {}



---@class FNDIDataChannel_GPUScriptParameterAccessInfo
---@field SortedParameters TArray<FNiagaraVariableBase>
local FNDIDataChannel_GPUScriptParameterAccessInfo = {}



---@class FNDIMemoryBufferSimCacheDataFrame
---@field CpuBufferSize int32
---@field CpuDataOffset int32
---@field GpuBufferSize int32
---@field GpuDataOffset int32
local FNDIMemoryBufferSimCacheDataFrame = {}



---@class FNDIRenderTargetVolumeSimCacheFrame
---@field Size FIntVector
---@field Format EPixelFormat
---@field UncompressedSize int32
---@field CompressedSize int32
local FNDIRenderTargetVolumeSimCacheFrame = {}



---@class FNDIStaticMeshSectionFilter
---@field AllowedMaterialSlots TArray<int32>
local FNDIStaticMeshSectionFilter = {}



---@class FNiagaraAssetTagDefinition
---@field AssetTag FText
---@field AssetFlags int32
---@field Description FText
---@field DisplayType ENiagaraAssetTagDefinitionImportance
---@field Color FLinearColor
---@field TagGuid FGuid
local FNiagaraAssetTagDefinition = {}



---@class FNiagaraAssetTagDefinitionReference
---@field AssetTagDefinitionGuid FGuid
local FNiagaraAssetTagDefinitionReference = {}



---@class FNiagaraAssetVersion
---@field MajorVersion int32
---@field MinorVersion int32
---@field VersionGuid FGuid
---@field bIsVisibleInVersionSelector boolean
local FNiagaraAssetVersion = {}



---@class FNiagaraBakerCameraSettings
---@field ViewMode ENiagaraBakerViewMode
---@field ViewportLocation FVector
---@field ViewportRotation FRotator
---@field OrbitDistance float
---@field FOV float
---@field OrthoWidth float
---@field bUseAspectRatio boolean
---@field AspectRatio float
local FNiagaraBakerCameraSettings = {}



---@class FNiagaraBakerTextureSettings
---@field OutputName FName
---@field SourceBinding FNiagaraBakerTextureSource
---@field bUseFrameSize boolean
---@field FrameSize FIntPoint
---@field TextureSize FIntPoint
---@field GeneratedTexture UTexture2D
local FNiagaraBakerTextureSettings = {}



---@class FNiagaraBakerTextureSource
---@field DisplayString FString
---@field SourceName FName
local FNiagaraBakerTextureSource = {}



---@class FNiagaraBool
---@field Value int32
local FNiagaraBool = {}



---@class FNiagaraBoolParameterMetaData
---@field DisplayMode ENiagaraBoolDisplayMode
---@field OverrideNameTrue FName
---@field OverrideNameFalse FName
---@field IconOverrideTrue UTexture2D
---@field IconOverrideFalse UTexture2D
local FNiagaraBoolParameterMetaData = {}



---@class FNiagaraBoundParameter
---@field Parameter FNiagaraVariableBase
---@field SrcOffset int32
---@field DestOffset int32
local FNiagaraBoundParameter = {}



---@class FNiagaraCollisionEventPayload
---@field CollisionPos FVector
---@field CollisionNormal FVector
---@field CollisionVelocity FVector
---@field ParticleIndex int32
---@field PhysicalMaterialIndex int32
local FNiagaraCollisionEventPayload = {}



---@class FNiagaraCompileDependency
---@field LinkerErrorMessage FString
---@field NodeGuid FGuid
---@field PinGuid FGuid
---@field StackGuids TArray<FGuid>
---@field DependentVariable FNiagaraVariableBase
---@field bDependentVariableFromCustomIterationNamespace boolean
local FNiagaraCompileDependency = {}



---@class FNiagaraCompileHashVisitorDebugInfo
---@field Object FString
---@field PropertyKeys TArray<FString>
---@field PropertyValues TArray<FString>
local FNiagaraCompileHashVisitorDebugInfo = {}



---@class FNiagaraCompilerTag
---@field Variable FNiagaraVariable
---@field StringValue FString
local FNiagaraCompilerTag = {}



---@class FNiagaraComponentPropertyBinding
---@field AttributeBinding FNiagaraVariableAttributeBinding
---@field PropertyName FName
---@field PropertyType FNiagaraTypeDefinition
---@field MetadataSetterName FName
---@field PropertySetterParameterDefaults TMap<FString, FString>
local FNiagaraComponentPropertyBinding = {}



---@class FNiagaraCulledComponentInfo
local FNiagaraCulledComponentInfo = {}


---@class FNiagaraDataChannelGameDataLayout
---@field VariableIndices TMap<FNiagaraVariableBase, int32>
---@field LwcConverters TArray<FNiagaraLwcStructConverter>
local FNiagaraDataChannelGameDataLayout = {}



---@class FNiagaraDataChannelSearchParameters
---@field OwningComponent USceneComponent
---@field Location FVector
---@field bOverrideLocation boolean
local FNiagaraDataChannelSearchParameters = {}



---@class FNiagaraDataChannelVariable : FNiagaraVariableBase
local FNiagaraDataChannelVariable = {}


---@class FNiagaraDataInterfaceEmitterBinding
---@field BindingMode ENiagaraDataInterfaceEmitterBindingMode
---@field EmitterName FName
local FNiagaraDataInterfaceEmitterBinding = {}



---@class FNiagaraDataInterfaceSplineLUT
---@field Positions TArray<FVector>
---@field Scales TArray<FVector>
---@field Rotations TArray<FQuat>
---@field SplineLength float
---@field SplineDistanceStep float
---@field InvSplineDistanceStep float
---@field MaxIndex int32
local FNiagaraDataInterfaceSplineLUT = {}



---@class FNiagaraDataSetCompiledData
---@field Variables TArray<FNiagaraVariableBase>
---@field VariableLayouts TArray<FNiagaraVariableLayoutInfo>
---@field ID FNiagaraDataSetID
---@field TotalFloatComponents uint32
---@field TotalInt32Components uint32
---@field TotalHalfComponents uint32
---@field bRequiresPersistentIDs boolean
---@field SimTarget ENiagaraSimTarget
local FNiagaraDataSetCompiledData = {}



---@class FNiagaraDataSetID
---@field Name FName
---@field Type ENiagaraDataSetType
local FNiagaraDataSetID = {}



---@class FNiagaraDataSetProperties
---@field ID FNiagaraDataSetID
---@field Variables TArray<FNiagaraVariableBase>
local FNiagaraDataSetProperties = {}



---@class FNiagaraDebugHUDSettingsData
---@field bHudEnabled boolean
---@field bHudRenderingEnabled boolean
---@field bValidationEnabled boolean
---@field bOverviewEnabled boolean
---@field OverviewMode ENiagaraDebugHUDOverviewMode
---@field OverviewSortMode ENiagaraDebugHUDDOverviewSort
---@field bIncludeCascade boolean
---@field bShowRegisteredComponents boolean
---@field bOverviewShowFilteredSystemOnly boolean
---@field bShowGlobalBudgetInfo boolean
---@field bSystemFilterEnabled boolean
---@field SystemFilter FString
---@field bEmitterFilterEnabled boolean
---@field EmitterFilter FString
---@field bActorFilterEnabled boolean
---@field ActorFilter FString
---@field bComponentFilterEnabled boolean
---@field ComponentFilter FString
---@field bValidateSystemSimulationDataBuffers boolean
---@field bValidateParticleDataBuffers boolean
---@field bValidationLogErrors boolean
---@field ValidationAttributeDisplayTruncate int32
---@field SystemDebugVerbosity ENiagaraDebugHudVerbosity
---@field SystemEmitterVerbosity ENiagaraDebugHudVerbosity
---@field DataInterfaceVerbosity ENiagaraDebugHudVerbosity
---@field SystemVariables TArray<FNiagaraDebugHUDVariable>
---@field bSystemShowActiveOnlyInWorld boolean
---@field bShowParticleVariables boolean
---@field ParticlesVariables TArray<FNiagaraDebugHUDVariable>
---@field bEnableGpuParticleReadback boolean
---@field bShowParticleIndex boolean
---@field bShowParticlesVariablesWithSystem boolean
---@field bShowParticleVariablesVertical boolean
---@field bUseMaxParticlesToDisplay boolean
---@field MaxParticlesToDisplay int32
---@field bUseParticleDisplayClip boolean
---@field ParticleDisplayClip FVector2D
---@field bUseParticleDisplayCenterRadius boolean
---@field ParticleDisplayCenterRadius float
---@field PerfReportFrames int32
---@field PerfSampleMode ENiagaraDebugHUDPerfSampleMode
---@field PerfUnits ENiagaraDebugHUDPerfUnits
---@field bShowPerfColumGameThreadOnly boolean
---@field PerfGraphMode ENiagaraDebugHUDPerfGraphMode
---@field PerfHistoryFrames int32
---@field bUsePerfGraphTimeRange boolean
---@field PerfGraphTimeRange float
---@field PerfGraphSize FVector2D
---@field PerfGraphAxisColor FLinearColor
---@field SmoothingWidth int32
---@field OverviewFont ENiagaraDebugHudFont
---@field OverviewLocation FVector2D
---@field SystemTextOptions FNiagaraDebugHudTextOptions
---@field ParticleTextOptions FNiagaraDebugHudTextOptions
---@field bDrawBoundsEnabled boolean
---@field bDrawBoundsWireframe boolean
---@field DrawBoundsAlpha float
---@field DefaultBackgroundColor FLinearColor
---@field OverviewHeadingColor FLinearColor
---@field OverviewDetailColor FLinearColor
---@field OverviewDetailHighlightColor FLinearColor
---@field InWorldErrorTextColor FLinearColor
---@field InWorldTextColor FLinearColor
---@field MessageInfoTextColor FLinearColor
---@field MessageWarningTextColor FLinearColor
---@field MessageErrorTextColor FLinearColor
---@field SystemColorTableOpacity float
---@field SystemColorSeed uint32
---@field SystemColorHSVMin FVector
---@field SystemColorHSVMax FVector
---@field PlaybackMode ENiagaraDebugPlaybackMode
---@field bPlaybackRateEnabled boolean
---@field PlaybackRate float
---@field bLoopTimeEnabled boolean
---@field LoopTime float
local FNiagaraDebugHUDSettingsData = {}



---@class FNiagaraDebugHUDVariable
---@field bEnabled boolean
---@field Name FString
local FNiagaraDebugHUDVariable = {}



---@class FNiagaraDebugHudTextOptions
---@field Font ENiagaraDebugHudFont
---@field HorizontalAlignment ENiagaraDebugHudHAlign
---@field VerticalAlignment ENiagaraDebugHudVAlign
---@field ScreenOffset FVector2D
local FNiagaraDebugHudTextOptions = {}



---@class FNiagaraDebuggerAcceptConnection
---@field SessionId FGuid
---@field InstanceId FGuid
local FNiagaraDebuggerAcceptConnection = {}



---@class FNiagaraDebuggerConnectionClosed
---@field SessionId FGuid
---@field InstanceId FGuid
local FNiagaraDebuggerConnectionClosed = {}



---@class FNiagaraDebuggerExecuteConsoleCommand
---@field Command FString
---@field bRequiresWorld boolean
local FNiagaraDebuggerExecuteConsoleCommand = {}



---@class FNiagaraDebuggerOutlinerUpdate
---@field OutlinerData FNiagaraOutlinerData
local FNiagaraDebuggerOutlinerUpdate = {}



---@class FNiagaraDebuggerRequestConnection
---@field SessionId FGuid
---@field InstanceId FGuid
local FNiagaraDebuggerRequestConnection = {}



---@class FNiagaraDetailsLevelScaleOverrides
---@field Low float
---@field Medium float
---@field High float
---@field Epic float
---@field Cine float
local FNiagaraDetailsLevelScaleOverrides = {}



---@class FNiagaraDeviceProfileStateEntry
---@field ProfileName FName
---@field QualityLevelMask uint32
---@field SetQualityLevelMask uint32
local FNiagaraDeviceProfileStateEntry = {}



---@class FNiagaraDistributionBase
---@field Mode ENiagaraDistributionMode
---@field ParameterBinding FNiagaraVariableBase
local FNiagaraDistributionBase = {}



---@class FNiagaraDistributionColor : FNiagaraDistributionBase
---@field Values TArray<FLinearColor>
---@field ValuesTimeRange FVector2f
local FNiagaraDistributionColor = {}



---@class FNiagaraDistributionFloat : FNiagaraDistributionBase
---@field Values TArray<float>
---@field ValuesTimeRange FVector2f
local FNiagaraDistributionFloat = {}



---@class FNiagaraDistributionPosition : FNiagaraDistributionVector3
local FNiagaraDistributionPosition = {}


---@class FNiagaraDistributionRangeColor : FNiagaraDistributionBase
---@field Min FLinearColor
---@field Max FLinearColor
local FNiagaraDistributionRangeColor = {}



---@class FNiagaraDistributionRangeFloat : FNiagaraDistributionBase
---@field Min float
---@field Max float
local FNiagaraDistributionRangeFloat = {}



---@class FNiagaraDistributionRangeInt
---@field Mode ENiagaraDistributionMode
---@field ParameterBinding FNiagaraVariableBase
---@field Min int32
---@field Max int32
local FNiagaraDistributionRangeInt = {}



---@class FNiagaraDistributionRangeVector2 : FNiagaraDistributionBase
---@field Min FVector2f
---@field Max FVector2f
local FNiagaraDistributionRangeVector2 = {}



---@class FNiagaraDistributionRangeVector3 : FNiagaraDistributionBase
---@field Min FVector3f
---@field Max FVector3f
local FNiagaraDistributionRangeVector3 = {}



---@class FNiagaraDistributionVector2 : FNiagaraDistributionBase
---@field Values TArray<FVector2f>
---@field ValuesTimeRange FVector2f
local FNiagaraDistributionVector2 = {}



---@class FNiagaraDistributionVector3 : FNiagaraDistributionBase
---@field Values TArray<FVector3f>
---@field ValuesTimeRange FVector2f
local FNiagaraDistributionVector3 = {}



---@class FNiagaraDouble
---@field Value double
local FNiagaraDouble = {}



---@class FNiagaraDynamicMeshMaterial
---@field Material UMaterialInterface
---@field MaterialUserParamBinding FNiagaraUserParameterBinding
local FNiagaraDynamicMeshMaterial = {}



---@class FNiagaraDynamicMeshSection
---@field NumTriangles int32
---@field MaterialIndex int32
local FNiagaraDynamicMeshSection = {}



---@class FNiagaraEmitterCompiledData
---@field SpawnAttributes TArray<FName>
---@field EmitterSpawnIntervalVar FNiagaraVariable
---@field EmitterInterpSpawnStartDTVar FNiagaraVariable
---@field EmitterSpawnGroupVar FNiagaraVariable
---@field EmitterAgeVar FNiagaraVariable
---@field EmitterRandomSeedVar FNiagaraVariable
---@field EmitterInstanceSeedVar FNiagaraVariable
---@field EmitterTotalSpawnedParticlesVar FNiagaraVariable
---@field DataSetCompiledData FNiagaraDataSetCompiledData
local FNiagaraEmitterCompiledData = {}



---@class FNiagaraEmitterHandle
---@field Name FName
---@field ID FGuid
---@field IdName FName
---@field bIsEnabled boolean
---@field EmitterMode ENiagaraEmitterMode
---@field VersionedInstance FVersionedNiagaraEmitter
---@field StatelessEmitter UNiagaraStatelessEmitter
local FNiagaraEmitterHandle = {}



---@class FNiagaraEmitterID
---@field ID int32
local FNiagaraEmitterID = {}



---@class FNiagaraEmitterScalabilityOverride : FNiagaraEmitterScalabilitySettings
---@field bOverrideSpawnCountScale boolean
local FNiagaraEmitterScalabilityOverride = {}



---@class FNiagaraEmitterScalabilityOverrides
---@field Overrides TArray<FNiagaraEmitterScalabilityOverride>
local FNiagaraEmitterScalabilityOverrides = {}



---@class FNiagaraEmitterScalabilitySettings
---@field Platforms FNiagaraPlatformSet
---@field bScaleSpawnCount boolean
---@field SpawnCountScale float
local FNiagaraEmitterScalabilitySettings = {}



---@class FNiagaraEmitterScalabilitySettingsArray
---@field Settings TArray<FNiagaraEmitterScalabilitySettings>
local FNiagaraEmitterScalabilitySettingsArray = {}



---@class FNiagaraEmitterScriptProperties
---@field Script UNiagaraScript
---@field EventReceivers TArray<FNiagaraEventReceiverProperties>
---@field EventGenerators TArray<FNiagaraEventGeneratorProperties>
local FNiagaraEmitterScriptProperties = {}



---@class FNiagaraEmitterStateData
---@field InactiveResponse ENiagaraEmitterInactiveResponse
---@field LoopBehavior ENiagaraLoopBehavior
---@field LoopCount int32
---@field LoopDurationMode ENiagaraLoopDurationMode
---@field LoopDuration FNiagaraDistributionRangeFloat
---@field LoopDelay FNiagaraDistributionRangeFloat
---@field bLoopDelayEnabled boolean
---@field bRecalculateDurationEachLoop boolean
---@field bDelayFirstLoopOnly boolean
---@field bRecalculateDelayEachLoop boolean
---@field bEnableDistanceCulling boolean
---@field bEnableVisibilityCulling boolean
---@field bMinDistanceEnabled boolean
---@field bMaxDistanceEnabled boolean
---@field bResetAgeOnAwaken boolean
---@field MinDistance float
---@field MinDistanceReaction ENiagaraExecutionStateManagement
---@field MaxDistance float
---@field MaxDistanceReaction ENiagaraExecutionStateManagement
---@field VisibilityCullReaction ENiagaraExecutionStateManagement
---@field VisibilityCullDelay float
local FNiagaraEmitterStateData = {}



---@class FNiagaraEnumParameterMetaData
---@field OverrideName FName
---@field IconOverride UTexture2D
---@field bUseColorOverride boolean
---@field ColorOverride FLinearColor
local FNiagaraEnumParameterMetaData = {}



---@class FNiagaraEventGeneratorProperties
---@field MaxEventsPerFrame int32
---@field ID FName
---@field DataSetCompiledData FNiagaraDataSetCompiledData
local FNiagaraEventGeneratorProperties = {}



---@class FNiagaraEventReceiverProperties
---@field Name FName
---@field SourceEventGenerator FName
---@field SourceEmitter FName
local FNiagaraEventReceiverProperties = {}



---@class FNiagaraEventScriptProperties : FNiagaraEmitterScriptProperties
---@field ExecutionMode EScriptExecutionMode
---@field SpawnNumber uint32
---@field MaxEventsPerFrame uint32
---@field SourceEmitterID FGuid
---@field SourceEventName FName
---@field bRandomSpawnNumber boolean
---@field MinSpawnNumber uint32
---@field UpdateAttributeInitialValues boolean
local FNiagaraEventScriptProperties = {}



---@class FNiagaraExternalUObjectInfo
---@field Variable FNiagaraVariableBase
---@field ExternalName FName
local FNiagaraExternalUObjectInfo = {}



---@class FNiagaraFloat
---@field Value float
local FNiagaraFloat = {}



---@class FNiagaraFunctionSignature
---@field Name FName
---@field Inputs TArray<FNiagaraVariable>
---@field Outputs TArray<FNiagaraVariableBase>
---@field OwnerName FName
---@field bRequiresContext boolean
---@field bRequiresExecPin boolean
---@field bMemberFunction boolean
---@field bExperimental boolean
---@field bSupportsCPU boolean
---@field bSupportsGPU boolean
---@field bWriteFunction boolean
---@field bReadFunction boolean
---@field bSoftDeprecatedFunction boolean
---@field bIsCompileTagGenerator boolean
---@field bHidden boolean
---@field ModuleUsageBitmask int32
---@field MiscUsageBitMask uint16
---@field ContextStageIndex int32
---@field RequiredInputs int16
---@field RequiredOutputs int16
---@field FunctionSpecifiers TMap<FName, FName>
local FNiagaraFunctionSignature = {}



---@class FNiagaraGlobalBudgetScaling
---@field bCullByGlobalBudget boolean
---@field bScaleMaxDistanceByGlobalBudgetUse boolean
---@field bScaleMaxInstanceCountByGlobalBudgetUse boolean
---@field bScaleSystemInstanceCountByGlobalBudgetUse boolean
---@field MaxGlobalBudgetUsage float
---@field MaxDistanceScaleByGlobalBudgetUse FNiagaraLinearRamp
---@field MaxInstanceCountScaleByGlobalBudgetUse FNiagaraLinearRamp
---@field MaxSystemInstanceCountScaleByGlobalBudgetUse FNiagaraLinearRamp
local FNiagaraGlobalBudgetScaling = {}



---@class FNiagaraGraphViewSettings
---@field Location FVector2D
---@field Zoom float
---@field bIsValid boolean
local FNiagaraGraphViewSettings = {}



---@class FNiagaraHalf
---@field Value uint16
local FNiagaraHalf = {}



---@class FNiagaraHalfVector2
---@field X uint16
---@field Y uint16
local FNiagaraHalfVector2 = {}



---@class FNiagaraHalfVector3
---@field X uint16
---@field Y uint16
---@field Z uint16
local FNiagaraHalfVector3 = {}



---@class FNiagaraHalfVector4
---@field X uint16
---@field Y uint16
---@field Z uint16
---@field W uint16
local FNiagaraHalfVector4 = {}



---@class FNiagaraID
---@field Index int32
---@field AcquireTag int32
local FNiagaraID = {}



---@class FNiagaraInlineDynamicInputFormatToken
local FNiagaraInlineDynamicInputFormatToken = {}


---@class FNiagaraInputConditionMetadata
---@field InputName FName
---@field TargetValues TArray<FString>
local FNiagaraInputConditionMetadata = {}



---@class FNiagaraInputParameterCustomization
---@field WidgetType ENiagaraInputWidgetType
---@field bHasMinValue boolean
---@field MinValue float
---@field bHasMaxValue boolean
---@field MaxValue float
---@field bHasStepWidth boolean
---@field StepWidth float
---@field InputDropdownValues TArray<FWidgetNamedInputValue>
---@field EnumStyleDropdownValues TArray<FNiagaraWidgetNamedIntegerInputValue>
---@field MaxSegmentsPerRow int32
---@field SegmentValueOverrides TArray<FWidgetSegmentValueOverride>
---@field bBroadcastValueChangesOnCommitOnly boolean
local FNiagaraInputParameterCustomization = {}



---@class FNiagaraInt32
---@field Value int32
local FNiagaraInt32 = {}



---@class FNiagaraLinearRamp
---@field StartX float
---@field StartY float
---@field EndX float
---@field EndY float
local FNiagaraLinearRamp = {}



---@class FNiagaraLwcStructConverter
---@field LWCSize int32
---@field SWCSize int32
---@field ConversionSteps TArray<FNiagaraStructConversionStep>
local FNiagaraLwcStructConverter = {}



---@class FNiagaraMaterialAttributeBinding
---@field MaterialParameterName FName
---@field NiagaraVariable FNiagaraVariableBase
---@field ResolvedNiagaraVariable FNiagaraVariableBase
---@field NiagaraChildVariable FNiagaraVariableBase
local FNiagaraMaterialAttributeBinding = {}



---@class FNiagaraMatrix
---@field Row0 FVector4f
---@field Row1 FVector4f
---@field Row2 FVector4f
---@field Row3 FVector4f
local FNiagaraMatrix = {}



---@class FNiagaraMeshMICOverride
---@field OriginalMaterial UMaterialInterface
---@field ReplacementMaterial UMaterialInstanceConstant
local FNiagaraMeshMICOverride = {}



---@class FNiagaraMeshMaterialOverride
---@field ExplicitMat UMaterialInterface
---@field UserParamBinding FNiagaraUserParameterBinding
local FNiagaraMeshMaterialOverride = {}



---@class FNiagaraMeshRendererMeshProperties
---@field Mesh UStaticMesh
---@field MeshParameterBinding FNiagaraParameterBinding
---@field LODMode ENiagaraMeshLODMode
---@field LODLevel int32
---@field LODBias int32
---@field LODDistanceFactor float
---@field bUseLODRange boolean
---@field LODRange FIntVector2
---@field Scale FVector
---@field Rotation FRotator
---@field PivotOffset FVector
---@field PivotOffsetSpace ENiagaraMeshPivotOffsetSpace
local FNiagaraMeshRendererMeshProperties = {}



---@class FNiagaraMessageStore
local FNiagaraMessageStore = {}


---@class FNiagaraModuleDependency
---@field ID FName
---@field Type ENiagaraModuleDependencyType
---@field ScriptConstraint ENiagaraModuleDependencyScriptConstraint
---@field RequiredVersion FString
---@field OnlyEvaluateInScriptUsage int32
---@field Description FText
local FNiagaraModuleDependency = {}



---@class FNiagaraNumeric
local FNiagaraNumeric = {}


---@class FNiagaraOutlinerCaptureSettings
---@field bTriggerCapture boolean
---@field CaptureDelayFrames uint32
---@field bGatherPerfData boolean
---@field SimCacheCaptureFrames uint32
local FNiagaraOutlinerCaptureSettings = {}



---@class FNiagaraOutlinerData
---@field WorldData TMap<FString, FNiagaraOutlinerWorldData>
local FNiagaraOutlinerData = {}



---@class FNiagaraOutlinerEmitterInstanceData
---@field EmitterName FString
---@field SimTarget ENiagaraSimTarget
---@field ExecState ENiagaraExecutionState
---@field NumParticles int32
---@field bRequiresPersistentIDs boolean
local FNiagaraOutlinerEmitterInstanceData = {}



---@class FNiagaraOutlinerSystemData
---@field SystemInstances TArray<FNiagaraOutlinerSystemInstanceData>
---@field AveragePerFrameTime FNiagaraOutlinerTimingData
---@field MaxPerFrameTime FNiagaraOutlinerTimingData
---@field AveragePerInstanceTime FNiagaraOutlinerTimingData
---@field MaxPerInstanceTime FNiagaraOutlinerTimingData
local FNiagaraOutlinerSystemData = {}



---@class FNiagaraOutlinerSystemInstanceData
---@field ComponentName FString
---@field LWCTile FVector3f
---@field Emitters TArray<FNiagaraOutlinerEmitterInstanceData>
---@field ActualExecutionState ENiagaraExecutionState
---@field RequestedExecutionState ENiagaraExecutionState
---@field ScalabilityState FNiagaraScalabilityState
---@field bPendingKill boolean
---@field bUsingCullProxy boolean
---@field PoolMethod ENCPoolMethod
---@field AverageTime FNiagaraOutlinerTimingData
---@field MaxTime FNiagaraOutlinerTimingData
---@field TickGroup ETickingGroup
---@field GpuTickStage ENiagaraGpuComputeTickStage::Type
---@field bIsSolo boolean
---@field bRequiresGlobalDistanceField boolean
---@field bRequiresDepthBuffer boolean
---@field bRequiresEarlyViewData boolean
---@field bRequiresViewUniformBuffer boolean
---@field bRequiresRayTracingScene boolean
---@field bRequiresCurrentFrameNDC boolean
local FNiagaraOutlinerSystemInstanceData = {}



---@class FNiagaraOutlinerTimingData
---@field GameThread float
---@field RenderThread float
local FNiagaraOutlinerTimingData = {}



---@class FNiagaraOutlinerWorldData
---@field Systems TMap<FString, FNiagaraOutlinerSystemData>
---@field bHasBegunPlay boolean
---@field WorldType uint8
---@field NetMode uint8
---@field AveragePerFrameTime FNiagaraOutlinerTimingData
---@field MaxPerFrameTime FNiagaraOutlinerTimingData
local FNiagaraOutlinerWorldData = {}



---@class FNiagaraParameterBinding
---@field ResolvedParameter FNiagaraVariableBase
local FNiagaraParameterBinding = {}



---@class FNiagaraParameterBindingWithValue : FNiagaraParameterBinding
---@field DefaultValue TArray<uint8>
local FNiagaraParameterBindingWithValue = {}



---@class FNiagaraParameterDataSetBinding
---@field ParameterOffset int32
---@field DataSetComponentOffset int32
local FNiagaraParameterDataSetBinding = {}



---@class FNiagaraParameterDataSetBindingCollection
---@field FloatOffsets TArray<FNiagaraParameterDataSetBinding>
---@field Int32Offsets TArray<FNiagaraParameterDataSetBinding>
local FNiagaraParameterDataSetBindingCollection = {}



---@class FNiagaraParameterMap
local FNiagaraParameterMap = {}


---@class FNiagaraParameterStore
---@field Owner TWeakObjectPtr<UObject>
---@field SortedParameterOffsets TArray<FNiagaraVariableWithOffset>
---@field ParameterData TArray<uint8>
---@field DataInterfaces TArray<UNiagaraDataInterface>
---@field UObjects TArray<UObject>
---@field OriginalPositionData TArray<FNiagaraPositionSource>
local FNiagaraParameterStore = {}



---@class FNiagaraParameters
---@field Parameters TArray<FNiagaraVariable>
local FNiagaraParameters = {}



---@class FNiagaraPerfBaselineStats
---@field PerInstanceAvg_GT float
---@field PerInstanceAvg_RT float
---@field PerInstanceMax_GT float
---@field PerInstanceMax_RT float
local FNiagaraPerfBaselineStats = {}



---@class FNiagaraPlatformSet
---@field DeviceProfileStates TArray<FNiagaraDeviceProfileStateEntry>
---@field CVarConditions TArray<FNiagaraPlatformSetCVarCondition>
---@field QualityLevelMask int32
local FNiagaraPlatformSet = {}



---@class FNiagaraPlatformSetCVarCondition
---@field CVarName FName
---@field PassResponse ENiagaraCVarConditionResponse
---@field FailResponse ENiagaraCVarConditionResponse
---@field Value boolean
---@field MinInt int32
---@field MaxInt int32
---@field MinFloat float
---@field MaxFloat float
---@field bUseMinInt boolean
---@field bUseMaxInt boolean
---@field bUseMinFloat boolean
---@field bUseMaxFloat boolean
local FNiagaraPlatformSetCVarCondition = {}



---@class FNiagaraPlatformSetConflictEntry
---@field ProfileName FName
---@field QualityLevelMask int32
local FNiagaraPlatformSetConflictEntry = {}



---@class FNiagaraPlatformSetConflictInfo
---@field SetAIndex int32
---@field SetBIndex int32
---@field Conflicts TArray<FNiagaraPlatformSetConflictEntry>
local FNiagaraPlatformSetConflictInfo = {}



---@class FNiagaraPlatformSetRedirect
---@field ProfileNames TArray<FName>
---@field Mode ENiagaraDeviceProfileRedirectMode
---@field RedirectProfileName FName
---@field CVarConditionEnabled FNiagaraPlatformSetCVarCondition
---@field CVarConditionDisabled FNiagaraPlatformSetCVarCondition
local FNiagaraPlatformSetRedirect = {}



---@class FNiagaraPosition : FVector3f
local FNiagaraPosition = {}


---@class FNiagaraPositionSource
---@field Name FName
---@field Value FVector
local FNiagaraPositionSource = {}



---@class FNiagaraRandInfo
---@field Seed1 int32
---@field Seed2 int32
---@field Seed3 int32
local FNiagaraRandInfo = {}



---@class FNiagaraRendererMaterialParameters
---@field AttributeBindings TArray<FNiagaraMaterialAttributeBinding>
---@field ScalarParameters TArray<FNiagaraRendererMaterialScalarParameter>
---@field VectorParameters TArray<FNiagaraRendererMaterialVectorParameter>
---@field TextureParameters TArray<FNiagaraRendererMaterialTextureParameter>
---@field StaticBoolParameters TArray<FNiagaraRendererMaterialStaticBoolParameter>
local FNiagaraRendererMaterialParameters = {}



---@class FNiagaraRendererMaterialScalarParameter
---@field MaterialParameterName FName
---@field Value float
local FNiagaraRendererMaterialScalarParameter = {}



---@class FNiagaraRendererMaterialStaticBoolParameter
---@field MaterialParameterName FName
---@field StaticVariableName FName
local FNiagaraRendererMaterialStaticBoolParameter = {}



---@class FNiagaraRendererMaterialTextureParameter
---@field MaterialParameterName FName
---@field Texture UTexture
local FNiagaraRendererMaterialTextureParameter = {}



---@class FNiagaraRendererMaterialVectorParameter
---@field MaterialParameterName FName
---@field Value FLinearColor
local FNiagaraRendererMaterialVectorParameter = {}



---@class FNiagaraRequestSimpleClientInfoMessage
local FNiagaraRequestSimpleClientInfoMessage = {}


---@class FNiagaraResolvedUObjectInfo
---@field ReadVariableName FName
---@field ResolvedVariable FNiagaraVariableBase
---@field Object UObject
local FNiagaraResolvedUObjectInfo = {}



---@class FNiagaraResolvedUserDataInterfaceBinding
---@field UserParameterStoreDataInterfaceIndex int32
---@field ScriptParameterStoreDataInterfaceIndex int32
local FNiagaraResolvedUserDataInterfaceBinding = {}



---@class FNiagaraRibbonShapeCustomVertex
---@field Position FVector2f
---@field Normal FVector2f
---@field TextureV float
local FNiagaraRibbonShapeCustomVertex = {}



---@class FNiagaraRibbonUVSettings
---@field DistributionMode ENiagaraRibbonUVDistributionMode
---@field LeadingEdgeMode ENiagaraRibbonUVEdgeMode
---@field TrailingEdgeMode ENiagaraRibbonUVEdgeMode
---@field bEnablePerParticleUOverride boolean
---@field bEnablePerParticleVRangeOverride boolean
---@field TilingLength float
---@field Offset FVector2D
---@field Scale FVector2D
local FNiagaraRibbonUVSettings = {}



---@class FNiagaraScalabilityManager
---@field EffectType UNiagaraEffectType
---@field ManagedComponents TArray<UNiagaraComponent>
local FNiagaraScalabilityManager = {}



---@class FNiagaraScalabilityState
---@field Significance float
---@field LastVisibleTime float
---@field bNewlyRegistered boolean
---@field bNewlyRegisteredDirty boolean
---@field bCulled boolean
---@field bPreviousCulled boolean
---@field bCulledByDistance boolean
---@field bCulledByInstanceCount boolean
---@field bCulledByVisibility boolean
---@field bCulledByGlobalBudget boolean
local FNiagaraScalabilityState = {}



---@class FNiagaraScriptAsyncCompileData
---@field RapidIterationParameters TArray<FNiagaraVariable>
---@field NamedDataInterfaces TMap<FName, UNiagaraDataInterface>
local FNiagaraScriptAsyncCompileData = {}



---@class FNiagaraScriptDataInterfaceCompileInfo
---@field Name FName
---@field UserPtrIdx int32
---@field Type FNiagaraTypeDefinition
---@field RegisteredParameterMapRead FName
---@field RegisteredParameterMapWrite FName
---@field bIsPlaceholder boolean
---@field SourceEmitterName FString
local FNiagaraScriptDataInterfaceCompileInfo = {}



---@class FNiagaraScriptDataInterfaceInfo
---@field DataInterface UNiagaraDataInterface
---@field Name FName
---@field CompileName FName
---@field UserPtrIdx int32
---@field Type FNiagaraTypeDefinition
---@field RegisteredParameterMapRead FName
---@field RegisteredParameterMapWrite FName
---@field SourceEmitterName FString
local FNiagaraScriptDataInterfaceInfo = {}



---@class FNiagaraScriptDataUsageInfo
---@field bReadsAttributeData boolean
local FNiagaraScriptDataUsageInfo = {}



---@class FNiagaraScriptExecutionPaddingInfo
---@field SrcOffset uint16
---@field DestOffset uint16
---@field SrcSize uint16
---@field DestSize uint16
local FNiagaraScriptExecutionPaddingInfo = {}



---@class FNiagaraScriptExecutionParameterStore : FNiagaraParameterStore
---@field ParameterSize int32
---@field bInitialized boolean
local FNiagaraScriptExecutionParameterStore = {}



---@class FNiagaraScriptHighlight
---@field Color FLinearColor
---@field DisplayName FText
local FNiagaraScriptHighlight = {}



---@class FNiagaraScriptInstanceParameterStore : FNiagaraParameterStore
local FNiagaraScriptInstanceParameterStore = {}


---@class FNiagaraScriptResolvedDataInterfaceInfo
---@field Name FName
---@field CompileName FName
---@field ResolvedSourceEmitterName FString
---@field ResolvedVariable FNiagaraVariableBase
---@field ParameterStoreVariable FNiagaraVariableBase
---@field bIsInternal boolean
---@field ResolvedDataInterface UNiagaraDataInterface
---@field UserPtrIdx int32
local FNiagaraScriptResolvedDataInterfaceInfo = {}



---@class FNiagaraScriptUObjectCompileInfo
---@field Variable FNiagaraVariableBase
---@field Object UObject
---@field ObjectPath FSoftObjectPath
---@field RegisteredParameterMapRead FName
---@field RegisteredParameterMapWrites TArray<FName>
local FNiagaraScriptUObjectCompileInfo = {}



---@class FNiagaraScriptVariableBinding
---@field Name FName
local FNiagaraScriptVariableBinding = {}



---@class FNiagaraSimCacheCaptureParameters
---@field bAppendToSimCache boolean
---@field bCaptureFixedNumberOfFrames boolean
---@field NumFrames int32
---@field CaptureRate int32
---@field bUseTimeout boolean
---@field TimeoutFrameCount int32
---@field bCaptureAllFramesImmediatly boolean
---@field ImmediateCaptureDeltaTime float
local FNiagaraSimCacheCaptureParameters = {}



---@class FNiagaraSimCacheCreateParameters
---@field AttributeCaptureMode ENiagaraSimCacheAttributeCaptureMode
---@field bAllowRebasing boolean
---@field bAllowDataInterfaceCaching boolean
---@field bAllowInterpolation boolean
---@field bAllowVelocityExtrapolation boolean
---@field bAllowSerializeLargeCache boolean
---@field bIncludeDebugData boolean
---@field RebaseIncludeAttributes TArray<FName>
---@field RebaseExcludeAttributes TArray<FName>
---@field InterpolationIncludeAttributes TArray<FName>
---@field InterpolationExcludeAttributes TArray<FName>
---@field ExplicitCaptureAttributes TArray<FName>
local FNiagaraSimCacheCreateParameters = {}



---@class FNiagaraSimCacheDataBuffers
---@field NumInstances uint32
---@field IDAcquireTag uint32
---@field IDToIndexTableElements uint32
local FNiagaraSimCacheDataBuffers = {}



---@class FNiagaraSimCacheDataBuffersLayout
---@field LayoutName FName
---@field SimTarget ENiagaraSimTarget
---@field Variables TArray<FNiagaraSimCacheVariable>
---@field FloatCount uint16
---@field HalfCount uint16
---@field Int32Count uint16
---@field bLocalSpace boolean
---@field bAllowInterpolation boolean
---@field bAllowVelocityExtrapolation boolean
---@field RebaseVariableNames TArray<FName>
---@field InterpVariableNames TArray<FName>
---@field ComponentVelocity uint16
local FNiagaraSimCacheDataBuffersLayout = {}



---@class FNiagaraSimCacheDebugDataFrame
---@field DebugParameterStores TMap<FString, FNiagaraParameterStore>
local FNiagaraSimCacheDebugDataFrame = {}



---@class FNiagaraSimCacheEmitterFrame
---@field LocalBounds FBox
---@field TotalSpawnedParticles int32
---@field ParticleDataBuffers FNiagaraSimCacheDataBuffers
local FNiagaraSimCacheEmitterFrame = {}



---@class FNiagaraSimCacheFrame
---@field LocalToWorld FTransform
---@field LWCTile FVector3f
---@field SimulationAge float
---@field SimulationTickCount int32
---@field SystemData FNiagaraSimCacheSystemFrame
---@field EmitterData TArray<FNiagaraSimCacheEmitterFrame>
local FNiagaraSimCacheFrame = {}



---@class FNiagaraSimCacheLayout
---@field SystemLayout FNiagaraSimCacheDataBuffersLayout
---@field EmitterLayouts TArray<FNiagaraSimCacheDataBuffersLayout>
local FNiagaraSimCacheLayout = {}



---@class FNiagaraSimCacheSystemFrame
---@field LocalBounds FBox
---@field SystemDataBuffers FNiagaraSimCacheDataBuffers
local FNiagaraSimCacheSystemFrame = {}



---@class FNiagaraSimCacheVariable
---@field Variable FNiagaraVariableBase
---@field FloatOffset uint16
---@field FloatCount uint16
---@field HalfOffset uint16
---@field HalfCount uint16
---@field Int32Offset uint16
---@field Int32Count uint16
local FNiagaraSimCacheVariable = {}



---@class FNiagaraSimStageExecutionLoopData
---@field NumLoopsBinding FName
---@field NumLoops int32
---@field StartStageIndex int32
---@field EndStageIndex int32
local FNiagaraSimStageExecutionLoopData = {}



---@class FNiagaraSimStageExecutionLoopEditorData
local FNiagaraSimStageExecutionLoopEditorData = {}


---@class FNiagaraSimpleClientInfo
---@field Systems TArray<FString>
---@field Actors TArray<FString>
---@field Components TArray<FString>
---@field Emitters TArray<FString>
local FNiagaraSimpleClientInfo = {}



---@class FNiagaraSpawnInfo
---@field Count int32
---@field InterpStartDt float
---@field IntervalDt float
---@field SpawnGroup int32
local FNiagaraSpawnInfo = {}



---@class FNiagaraStackSection
---@field SectionIdentifier FName
---@field SectionDisplayName FText
---@field Categories TArray<FText>
---@field ToolTip FText
---@field bEnabled boolean
local FNiagaraStackSection = {}



---@class FNiagaraStatScope
---@field FullName FName
---@field FriendlyName FName
local FNiagaraStatScope = {}



---@class FNiagaraStatelessDynamicParameterSet
---@field bXChannelEnabled boolean
---@field bYChannelEnabled boolean
---@field bZChannelEnabled boolean
---@field bWChannelEnabled boolean
---@field XChannelDistribution FNiagaraDistributionFloat
---@field YChannelDistribution FNiagaraDistributionFloat
---@field ZChannelDistribution FNiagaraDistributionFloat
---@field WChannelDistribution FNiagaraDistributionFloat
local FNiagaraStatelessDynamicParameterSet = {}



---@class FNiagaraStatelessSpawnInfo
---@field Type ENiagaraStatelessSpawnInfoType
---@field SpawnTime float
---@field Amount FNiagaraDistributionRangeInt
---@field Rate FNiagaraDistributionRangeFloat
---@field bEnabled boolean
---@field bSpawnProbabilityEnabled boolean
---@field SpawnProbability FNiagaraDistributionRangeFloat
local FNiagaraStatelessSpawnInfo = {}



---@class FNiagaraStructConversionStep
---@field LWCBytes int32
---@field LWCOffset int32
---@field SimulationBytes int32
---@field SimulationOffset int32
---@field ConversionType ENiagaraStructConversionType
local FNiagaraStructConversionStep = {}



---@class FNiagaraSystemAsyncCompileResults
---@field RootObjects TArray<UObject>
---@field ExposedVariables TArray<FNiagaraVariable>
local FNiagaraSystemAsyncCompileResults = {}



---@class FNiagaraSystemCompiledData
---@field InstanceParamStore FNiagaraParameterStore
---@field DataSetCompiledData FNiagaraDataSetCompiledData
---@field SpawnInstanceParamsDataSetCompiledData FNiagaraDataSetCompiledData
---@field UpdateInstanceParamsDataSetCompiledData FNiagaraDataSetCompiledData
---@field SpawnInstanceGlobalBinding FNiagaraParameterDataSetBindingCollection
---@field SpawnInstanceSystemBinding FNiagaraParameterDataSetBindingCollection
---@field SpawnInstanceOwnerBinding FNiagaraParameterDataSetBindingCollection
---@field SpawnInstanceEmitterBindings TArray<FNiagaraParameterDataSetBindingCollection>
---@field UpdateInstanceGlobalBinding FNiagaraParameterDataSetBindingCollection
---@field UpdateInstanceSystemBinding FNiagaraParameterDataSetBindingCollection
---@field UpdateInstanceOwnerBinding FNiagaraParameterDataSetBindingCollection
---@field UpdateInstanceEmitterBindings TArray<FNiagaraParameterDataSetBindingCollection>
local FNiagaraSystemCompiledData = {}



---@class FNiagaraSystemScalabilityOverride : FNiagaraSystemScalabilitySettings
---@field bOverrideDistanceSettings boolean
---@field bOverrideInstanceCountSettings boolean
---@field bOverridePerSystemInstanceCountSettings boolean
---@field bOverrideVisibilitySettings boolean
---@field bOverrideGlobalBudgetScalingSettings boolean
---@field bOverrideCullProxySettings boolean
local FNiagaraSystemScalabilityOverride = {}



---@class FNiagaraSystemScalabilityOverrides
---@field Overrides TArray<FNiagaraSystemScalabilityOverride>
local FNiagaraSystemScalabilityOverrides = {}



---@class FNiagaraSystemScalabilitySettings
---@field Platforms FNiagaraPlatformSet
---@field bCullByDistance boolean
---@field bCullMaxInstanceCount boolean
---@field bCullPerSystemMaxInstanceCount boolean
---@field MaxDistance float
---@field bCullByMaxTimeWithoutRender boolean
---@field MaxInstances int32
---@field MaxSystemInstances int32
---@field MaxTimeWithoutRender float
---@field CullProxyMode ENiagaraCullProxyMode
---@field MaxSystemProxies int32
---@field VisibilityCulling FNiagaraSystemVisibilityCullingSettings
---@field BudgetScaling FNiagaraGlobalBudgetScaling
local FNiagaraSystemScalabilitySettings = {}



---@class FNiagaraSystemScalabilitySettingsArray
---@field Settings TArray<FNiagaraSystemScalabilitySettings>
local FNiagaraSystemScalabilitySettingsArray = {}



---@class FNiagaraSystemSimCacheCaptureReply
---@field ComponentName FName
---@field SimCacheData TArray<uint8>
local FNiagaraSystemSimCacheCaptureReply = {}



---@class FNiagaraSystemSimCacheCaptureRequest
---@field ComponentName FName
---@field CaptureDelayFrames uint32
---@field CaptureFrames uint32
local FNiagaraSystemSimCacheCaptureRequest = {}



---@class FNiagaraSystemStateData
---@field bRunSpawnScript boolean
---@field bRunUpdateScript boolean
---@field bIgnoreSystemState boolean
---@field bRecalculateDurationEachLoop boolean
---@field bLoopDelayEnabled boolean
---@field bDelayFirstLoopOnly boolean
---@field bRecalculateDelayEachLoop boolean
---@field InactiveResponse ENiagaraSystemInactiveResponse
---@field LoopBehavior ENiagaraLoopBehavior
---@field LoopDuration FNiagaraDistributionRangeFloat
---@field LoopCount int32
---@field LoopDelay FNiagaraDistributionRangeFloat
local FNiagaraSystemStateData = {}



---@class FNiagaraSystemUpdateContext
---@field ComponentsToReset TArray<UNiagaraComponent>
---@field ComponentsToReInit TArray<UNiagaraComponent>
---@field ComponentsToNotifySimDestroy TArray<UNiagaraComponent>
---@field ComponentsToDestroyInstance TArray<UNiagaraComponent>
---@field SystemSimsToDestroy TArray<UNiagaraSystem>
---@field SystemSimsToRecache TArray<UNiagaraSystem>
local FNiagaraSystemUpdateContext = {}



---@class FNiagaraSystemVisibilityCullingSettings
---@field bCullWhenNotRendered boolean
---@field bCullByViewFrustum boolean
---@field bAllowPreCullingByViewFrustum boolean
---@field MaxTimeOutsideViewFrustum float
---@field MaxTimeWithoutRender float
local FNiagaraSystemVisibilityCullingSettings = {}



---@class FNiagaraTypeDefinition
---@field ClassStructOrEnum UObject
---@field UnderlyingType uint16
---@field Flags uint8
local FNiagaraTypeDefinition = {}



---@class FNiagaraTypeDefinitionHandle
---@field RegisteredTypeIndex int32
local FNiagaraTypeDefinitionHandle = {}



---@class FNiagaraTypeLayoutInfo
---@field NumFloatComponents uint16
---@field NumInt32Components uint16
---@field NumHalfComponents uint16
---@field ComponentsOffsets TArray<uint32>
local FNiagaraTypeLayoutInfo = {}



---@class FNiagaraUObjectPropertyReaderRemap
---@field GraphName FName
---@field RemapName FName
local FNiagaraUObjectPropertyReaderRemap = {}



---@class FNiagaraUserParameterBinding
---@field Parameter FNiagaraVariable
local FNiagaraUserParameterBinding = {}



---@class FNiagaraUserRedirectionParameterStore : FNiagaraParameterStore
---@field UserParameterRedirects TMap<FNiagaraVariable, FNiagaraVariable>
local FNiagaraUserRedirectionParameterStore = {}



---@class FNiagaraVMExecutableByteCode
---@field Data TArray<uint8>
---@field UncompressedSize int32
local FNiagaraVMExecutableByteCode = {}



---@class FNiagaraVMExecutableData
---@field ByteCode FNiagaraVMExecutableByteCode
---@field OptimizedByteCode FNiagaraVMExecutableByteCode
---@field NumTempRegisters int32
---@field NumUserPtrs int32
---@field CompileTags TArray<FNiagaraCompilerTag>
---@field ScriptLiterals TArray<uint8>
---@field Attributes TArray<FNiagaraVariableBase>
---@field DataUsage FNiagaraScriptDataUsageInfo
---@field UObjectInfos TArray<FNiagaraScriptUObjectCompileInfo>
---@field DataInterfaceInfo TArray<FNiagaraScriptDataInterfaceCompileInfo>
---@field CalledVMExternalFunctions TArray<FVMExternalFunctionBindingInfo>
---@field ReadDataSets TArray<FNiagaraDataSetID>
---@field WriteDataSets TArray<FNiagaraDataSetProperties>
---@field StatScopes TArray<FNiagaraStatScope>
---@field ShaderScriptParametersMetadata FNiagaraShaderScriptParametersMetadata
---@field LastCompileStatus ENiagaraScriptCompileStatus
---@field SimulationStageMetaData TArray<FSimulationStageMetaData>
---@field ExperimentalContextData TArray<uint8>
---@field bReadsSignificanceIndex boolean
---@field bNeedsGPUContextInit boolean
local FNiagaraVMExecutableData = {}



---@class FNiagaraVMExecutableDataId
---@field CompilerVersionID FGuid
---@field ScriptUsageType ENiagaraScriptUsage
---@field ScriptUsageTypeID FGuid
---@field bUsesRapidIterationParams boolean
---@field bDisableDebugSwitches boolean
---@field bInterpolatedSpawn boolean
---@field bRequiresPersistentIDs boolean
---@field BaseScriptID FGuid
---@field BaseScriptCompileHash FNiagaraCompileHash
---@field ScriptVersionID FGuid
local FNiagaraVMExecutableDataId = {}



---@class FNiagaraVariable : FNiagaraVariableBase
---@field VarData TArray<uint8>
local FNiagaraVariable = {}



---@class FNiagaraVariableAttributeBinding
---@field RootVariable FNiagaraVariable
---@field ParamMapVariable FNiagaraVariableBase
---@field DataSetName FName
---@field BindingSourceMode ENiagaraBindingSource
---@field bBindingExistsOnSource boolean
---@field bIsCachedParticleValue boolean
local FNiagaraVariableAttributeBinding = {}



---@class FNiagaraVariableBase
---@field Name FName
---@field TypeDefHandle FNiagaraTypeDefinitionHandle
local FNiagaraVariableBase = {}



---@class FNiagaraVariableDataInterfaceBinding
---@field BoundVariable FNiagaraVariable
local FNiagaraVariableDataInterfaceBinding = {}



---@class FNiagaraVariableInfo
---@field Variable FNiagaraVariable
---@field Definition FText
---@field DataInterface UNiagaraDataInterface
local FNiagaraVariableInfo = {}



---@class FNiagaraVariableLayoutInfo
---@field FloatComponentStart uint16
---@field Int32ComponentStart uint16
---@field HalfComponentStart uint16
---@field LayoutInfo FNiagaraTypeLayoutInfo
local FNiagaraVariableLayoutInfo = {}



---@class FNiagaraVariableMetaData
---@field Description FText
---@field DisplayUnit EUnit
---@field bAdvancedDisplay boolean
---@field bDisplayInOverviewStack boolean
---@field InlineParameterSortPriority int32
---@field bOverrideColor boolean
---@field InlineParameterColorOverride FLinearColor
---@field InlineParameterEnumOverrides TArray<FNiagaraEnumParameterMetaData>
---@field bEnableBoolOverride boolean
---@field InlineParameterBoolOverride FNiagaraBoolParameterMetaData
---@field bInlineEditConditionToggle boolean
---@field EditCondition FNiagaraInputConditionMetadata
---@field VisibleCondition FNiagaraInputConditionMetadata
---@field PropertyMetaData TMap<FName, FString>
---@field AlternateAliases TArray<FName>
---@field WidgetCustomization FNiagaraInputParameterCustomization
---@field VariableGuid FGuid
---@field bIsStaticSwitch boolean
---@field StaticSwitchDefaultValue int32
---@field CategoryName FText
---@field ParentAttribute FName
---@field EditorSortPriority int32
local FNiagaraVariableMetaData = {}



---@class FNiagaraVariableWithOffset : FNiagaraVariableBase
---@field Offset int32
---@field StructConverter FNiagaraLwcStructConverter
local FNiagaraVariableWithOffset = {}



---@class FNiagaraVariant
---@field Object UObject
---@field DataInterface UNiagaraDataInterface
---@field Bytes TArray<uint8>
---@field CurrentMode ENiagaraVariantMode
local FNiagaraVariant = {}



---@class FNiagaraWidgetNamedIntegerInputValue
---@field DisplayName FText
---@field ToolTip FText
local FNiagaraWidgetNamedIntegerInputValue = {}



---@class FNiagaraWildcard
local FNiagaraWildcard = {}


---@class FNiagaraWorldManagerTickFunction : FTickFunction
local FNiagaraWorldManagerTickFunction = {}


---@class FParameterDefinitionsSubscription
local FParameterDefinitionsSubscription = {}


---@class FVMExternalFunctionBindingInfo
---@field Name FName
---@field OwnerName FName
---@field InputParamLocations TArray<boolean>
---@field NumOutputs int32
---@field FunctionSpecifiers TArray<FVMFunctionSpecifier>
---@field VariadicInputs TArray<FNiagaraVariableBase>
---@field VariadicOutputs TArray<FNiagaraVariableBase>
local FVMExternalFunctionBindingInfo = {}



---@class FVMFunctionSpecifier
---@field Key FName
---@field Value FName
local FVMFunctionSpecifier = {}



---@class FVersionedNiagaraEmitter
---@field Emitter UNiagaraEmitter
---@field Version FGuid
local FVersionedNiagaraEmitter = {}



---@class FVersionedNiagaraEmitterData
---@field Version FNiagaraAssetVersion
---@field bDeprecated boolean
---@field DeprecationMessage FText
---@field bLocalSpace boolean
---@field bDeterminism boolean
---@field RandomSeed int32
---@field bInterpolatedSpawning boolean
---@field SimTarget ENiagaraSimTarget
---@field CalculateBoundsMode ENiagaraEmitterCalculateBoundMode
---@field FixedBounds FBox
---@field bRequiresPersistentIDs boolean
---@field EventHandlerScriptProps TArray<FNiagaraEventScriptProperties>
---@field Platforms FNiagaraPlatformSet
---@field ScalabilityOverrides FNiagaraEmitterScalabilityOverrides
---@field MaxGPUParticlesSpawnPerFrame int32
---@field AllocationMode EParticleAllocationMode
---@field PreAllocationCount int32
---@field EmitterDependencies TArray<FNiagaraDataInterfaceEmitterBinding>
---@field UpdateScriptProps FNiagaraEmitterScriptProperties
---@field SpawnScriptProps FNiagaraEmitterScriptProperties
---@field RendererBindings FNiagaraParameterStore
---@field RendererBindingsExternalObjects TArray<FNiagaraExternalUObjectInfo>
---@field ResolvedDIBindings TMap<FNiagaraVariableBase, FNiagaraVariableBase>
---@field RendererProperties TArray<UNiagaraRendererProperties>
---@field SimulationStages TArray<UNiagaraSimulationStageBase>
---@field SimStageExecutionLoops TArray<FNiagaraSimStageExecutionLoopData>
---@field GPUComputeScript UNiagaraScript
---@field SharedEventGeneratorIds TArray<FName>
---@field CurrentScalabilitySettings FNiagaraEmitterScalabilitySettings
local FVersionedNiagaraEmitterData = {}



---@class FVersionedNiagaraScriptData
local FVersionedNiagaraScriptData = {}


---@class FWidgetNamedInputValue
---@field Value float
---@field DisplayName FText
---@field ToolTip FText
local FWidgetNamedInputValue = {}



---@class FWidgetSegmentValueOverride
---@field EnumIndexToOverride int32
---@field bOverrideDisplayName boolean
---@field DisplayNameOverride FText
---@field DisplayIcon UTexture2D
local FWidgetSegmentValueOverride = {}



---@class INiagaraParticleCallbackHandler : IInterface
local INiagaraParticleCallbackHandler = {}

---@param Data TArray<FBasicParticleData>
---@param NiagaraSystem UNiagaraSystem
---@param SimulationPositionOffset FVector
function INiagaraParticleCallbackHandler:ReceiveParticleData(Data, NiagaraSystem, SimulationPositionOffset) end


---@class INiagaraPhysicsAssetDICollectorInterface : IInterface
local INiagaraPhysicsAssetDICollectorInterface = {}


---@class INiagaraRenderableMeshInterface : IInterface
local INiagaraRenderableMeshInterface = {}


---@class INiagaraSimCacheCustomStorageInterface : IInterface
local INiagaraSimCacheCustomStorageInterface = {}


---@class UAsyncNiagaraCaptureSimCache : UCancellableAsyncAction
---@field CaptureSimCache UNiagaraSimCache
---@field CaptureComponent UNiagaraComponent
---@field CaptureComplete FAsyncNiagaraCaptureSimCacheCaptureComplete
local UAsyncNiagaraCaptureSimCache = {}

---@param bSuccess boolean
function UAsyncNiagaraCaptureSimCache:OnCaptureComplete__DelegateSignature(bSuccess) end
---@param SimCache UNiagaraSimCache
---@param CreateParameters FNiagaraSimCacheCreateParameters
---@param NiagaraComponent UNiagaraComponent
---@param OutSimCache UNiagaraSimCache
---@param CaptureRate int32
---@param bAdvanceSimulation boolean
---@param AdvanceDeltaTime float
---@return UAsyncNiagaraCaptureSimCache
function UAsyncNiagaraCaptureSimCache:CaptureNiagaraSimCacheUntilComplete(SimCache, CreateParameters, NiagaraComponent, OutSimCache, CaptureRate, bAdvanceSimulation, AdvanceDeltaTime) end
---@param SimCache UNiagaraSimCache
---@param CreateParameters FNiagaraSimCacheCreateParameters
---@param NiagaraComponent UNiagaraComponent
---@param OutSimCache UNiagaraSimCache
---@param NumFrames int32
---@param CaptureRate int32
---@param bAdvanceSimulation boolean
---@param AdvanceDeltaTime float
---@return UAsyncNiagaraCaptureSimCache
function UAsyncNiagaraCaptureSimCache:CaptureNiagaraSimCacheMultiFrame(SimCache, CreateParameters, NiagaraComponent, OutSimCache, NumFrames, CaptureRate, bAdvanceSimulation, AdvanceDeltaTime) end
---@param SimCache UNiagaraSimCache
---@param CreateParameters FNiagaraSimCacheCreateParameters
---@param NiagaraComponent UNiagaraComponent
---@param CaptureParameters FNiagaraSimCacheCaptureParameters
---@param OutSimCache UNiagaraSimCache
---@return UAsyncNiagaraCaptureSimCache
function UAsyncNiagaraCaptureSimCache:CaptureNiagaraSimCache(SimCache, CreateParameters, NiagaraComponent, CaptureParameters, OutSimCache) end


---@class UMovieSceneNiagaraBoolParameterTrack : UMovieSceneNiagaraParameterTrack
local UMovieSceneNiagaraBoolParameterTrack = {}


---@class UMovieSceneNiagaraColorParameterTrack : UMovieSceneNiagaraParameterTrack
local UMovieSceneNiagaraColorParameterTrack = {}


---@class UMovieSceneNiagaraFloatParameterTrack : UMovieSceneNiagaraParameterTrack
local UMovieSceneNiagaraFloatParameterTrack = {}


---@class UMovieSceneNiagaraIntegerParameterTrack : UMovieSceneNiagaraParameterTrack
local UMovieSceneNiagaraIntegerParameterTrack = {}


---@class UMovieSceneNiagaraParameterTrack : UMovieSceneNiagaraTrack
---@field Parameter FNiagaraVariable
local UMovieSceneNiagaraParameterTrack = {}



---@class UMovieSceneNiagaraSystemSpawnSection : UMovieSceneSection
---@field SectionStartBehavior ENiagaraSystemSpawnSectionStartBehavior
---@field SectionEvaluateBehavior ENiagaraSystemSpawnSectionEvaluateBehavior
---@field SectionEndBehavior ENiagaraSystemSpawnSectionEndBehavior
---@field AgeUpdateMode ENiagaraAgeUpdateMode
---@field bAllowScalability boolean
local UMovieSceneNiagaraSystemSpawnSection = {}



---@class UMovieSceneNiagaraSystemTrack : UMovieSceneNiagaraTrack
local UMovieSceneNiagaraSystemTrack = {}


---@class UMovieSceneNiagaraTrack : UMovieSceneNameableTrack
---@field Sections TArray<UMovieSceneSection>
local UMovieSceneNiagaraTrack = {}



---@class UMovieSceneNiagaraVectorParameterTrack : UMovieSceneNiagaraParameterTrack
---@field ChannelsUsed int32
local UMovieSceneNiagaraVectorParameterTrack = {}



---@class UNDIArraySimCacheData : UObject
---@field CpuFrameData TArray<FNDIArraySimCacheDataFrame>
---@field GpuFrameData TArray<FNDIArraySimCacheDataFrame>
---@field BufferData TArray<uint8>
local UNDIArraySimCacheData = {}



---@class UNDIDataChannelWriteSimCacheData : UObject
---@field FrameData TArray<FNDIDataChannelWriteSimCacheFrame>
---@field DataChannelReference FSoftObjectPath
---@field DataInterface UNiagaraDataInterfaceDataChannelWrite
local UNDIDataChannelWriteSimCacheData = {}



---@class UNDILandscapeSimCacheData : UObject
---@field HeightFieldTextures TArray<UTexture2D>
local UNDILandscapeSimCacheData = {}



---@class UNDIMemoryBufferSimCacheData : UObject
---@field FrameData TArray<FNDIMemoryBufferSimCacheDataFrame>
---@field BufferData TArray<uint32>
local UNDIMemoryBufferSimCacheData = {}



---@class UNDIRenderTargetVolumeSimCacheData : UObject
---@field CompressionType FName
---@field Frames TArray<FNDIRenderTargetVolumeSimCacheFrame>
local UNDIRenderTargetVolumeSimCacheData = {}



---@class UNDISimpleCounterSimCacheData : UObject
---@field Values TArray<int32>
local UNDISimpleCounterSimCacheData = {}



---@class UNiagaraAssetTagDefinitions : UObject
---@field DisplayName FText
---@field Description FText
---@field TagDefinitions TArray<FNiagaraAssetTagDefinition>
---@field bDisplayTagsAsFlatList boolean
---@field SortOrder int32
local UNiagaraAssetTagDefinitions = {}



---@class UNiagaraBakerOutput : UObject
---@field OutputName FString
local UNiagaraBakerOutput = {}



---@class UNiagaraBakerOutputSimCache : UNiagaraBakerOutput
---@field SimCacheAssetPathFormat FString
---@field CreateParameters FNiagaraSimCacheCreateParameters
local UNiagaraBakerOutputSimCache = {}



---@class UNiagaraBakerOutputSparseVolumeTexture : UNiagaraBakerOutput
---@field SourceBinding FNiagaraBakerTextureSource
---@field VolumeWorldSpaceSizeBinding FNiagaraParameterBinding
---@field SparseVolumeTextureAssetPathFormat FString
local UNiagaraBakerOutputSparseVolumeTexture = {}



---@class UNiagaraBakerOutputTexture2D : UNiagaraBakerOutput
---@field SourceBinding FNiagaraBakerTextureSource
---@field bGenerateAtlas boolean
---@field bGenerateFrames boolean
---@field bExportFrames boolean
---@field bSetTextureAddressX boolean
---@field bSetTextureAddressY boolean
---@field FrameSize FIntPoint
---@field AtlasTextureSize FIntPoint
---@field TextureAddressX TextureAddress
---@field TextureAddressY TextureAddress
---@field AtlasAssetPathFormat FString
---@field FramesAssetPathFormat FString
---@field FramesExportPathFormat FString
local UNiagaraBakerOutputTexture2D = {}



---@class UNiagaraBakerOutputVolumeTexture : UNiagaraBakerOutput
---@field SourceBinding FNiagaraBakerTextureSource
---@field bGenerateAtlas boolean
---@field bGenerateFrames boolean
---@field bExportFrames boolean
---@field AtlasAssetPathFormat FString
---@field FramesAssetPathFormat FString
---@field FramesExportPathFormat FString
local UNiagaraBakerOutputVolumeTexture = {}



---@class UNiagaraBakerSettings : UObject
---@field StartSeconds float
---@field DurationSeconds float
---@field FramesPerSecond int32
---@field bLockToSimulationFrameRate boolean
---@field bPreviewLooping boolean
---@field FramesPerDimension FIntPoint
---@field Outputs TArray<UNiagaraBakerOutput>
---@field CameraSettings TArray<FNiagaraBakerCameraSettings>
---@field CurrentCameraIndex int32
---@field BakeQualityLevel FName
---@field bRenderComponentOnly boolean
---@field OutputTextures TArray<FNiagaraBakerTextureSettings>
---@field CameraViewportMode ENiagaraBakerViewMode
---@field CameraViewportLocation FVector
---@field CameraViewportRotation FRotator
---@field CameraOrbitDistance float
---@field CameraFOV float
---@field CameraOrthoWidth float
---@field bUseCameraAspectRatio boolean
---@field CameraAspectRatio float
local UNiagaraBakerSettings = {}



---@class UNiagaraBaselineController : UObject
---@field TestDuration float
---@field EffectType UNiagaraEffectType
---@field Owner ANiagaraPerfBaselineActor
---@field System TSoftObjectPtr<UNiagaraSystem>
local UNiagaraBaselineController = {}

---@return boolean
function UNiagaraBaselineController:OnTickTest() end
---@param DeltaTime float
function UNiagaraBaselineController:OnOwnerTick(DeltaTime) end
---@param Stats FNiagaraPerfBaselineStats
function UNiagaraBaselineController:OnEndTest(Stats) end
function UNiagaraBaselineController:OnBeginTest() end
---@return UNiagaraSystem
function UNiagaraBaselineController:GetSystem() end


---@class UNiagaraBaselineController_Basic : UNiagaraBaselineController
---@field NumInstances int32
---@field SpawnedComponents TArray<UNiagaraComponent>
local UNiagaraBaselineController_Basic = {}



---@class UNiagaraComponent : UFXSystemComponent
---@field Asset UNiagaraSystem
---@field TickBehavior ENiagaraTickBehavior
---@field RandomSeedOffset int32
---@field OverrideParameters FNiagaraUserRedirectionParameterStore
---@field bEnableGpuComputeDebug boolean
---@field bOverrideWarmupSettings boolean
---@field WarmupTickCount int32
---@field WarmupTickDelta float
---@field bAutoDestroy boolean
---@field bRenderingEnabled boolean
---@field bAutoManageAttachment boolean
---@field bAutoAttachWeldSimulatedBodies boolean
---@field MaxTimeBeforeForceUpdateTransform float
---@field OcclusionQueryMode ENiagaraOcclusionQueryMode
---@field OnSystemFinished FNiagaraComponentOnSystemFinished
---@field AutoAttachParent TWeakObjectPtr<USceneComponent>
---@field AutoAttachSocketName FName
---@field AutoAttachLocationRule EAttachmentRule
---@field AutoAttachRotationRule EAttachmentRule
---@field AutoAttachScaleRule EAttachmentRule
---@field bAllowScalability boolean
---@field SimCache UNiagaraSimCache
---@field CullProxy UNiagaraCullProxyComponent
local UNiagaraComponent = {}

---@param InVariableName FName
---@param InValue FVector4
function UNiagaraComponent:SetVariableVec4(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FVector
function UNiagaraComponent:SetVariableVec3(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FVector2D
function UNiagaraComponent:SetVariableVec2(InVariableName, InValue) end
---@param InVariableName FName
---@param TextureRenderTarget UTextureRenderTarget
function UNiagaraComponent:SetVariableTextureRenderTarget(InVariableName, TextureRenderTarget) end
---@param InVariableName FName
---@param Texture UTexture
function UNiagaraComponent:SetVariableTexture(InVariableName, Texture) end
---@param InVariableName FName
---@param InValue UStaticMesh
function UNiagaraComponent:SetVariableStaticMesh(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FQuat
function UNiagaraComponent:SetVariableQuat(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FVector
function UNiagaraComponent:SetVariablePosition(InVariableName, InValue) end
---@param InVariableName FName
---@param Object UObject
function UNiagaraComponent:SetVariableObject(InVariableName, Object) end
---@param InVariableName FName
---@param InValue FMatrix
function UNiagaraComponent:SetVariableMatrix(InVariableName, InValue) end
---@param InVariableName FName
---@param Object UMaterialInterface
function UNiagaraComponent:SetVariableMaterial(InVariableName, Object) end
---@param InVariableName FName
---@param InValue FLinearColor
function UNiagaraComponent:SetVariableLinearColor(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue int32
function UNiagaraComponent:SetVariableInt(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue float
function UNiagaraComponent:SetVariableFloat(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue boolean
function UNiagaraComponent:SetVariableBool(InVariableName, InValue) end
---@param InVariableName FName
---@param Actor AActor
function UNiagaraComponent:SetVariableActor(InVariableName, Actor) end
---@param NewTickBehavior ENiagaraTickBehavior
function UNiagaraComponent:SetTickBehavior(NewTickBehavior) end
---@param LocalBounds FBox
function UNiagaraComponent:SetSystemFixedBounds(LocalBounds) end
---@param SimCache UNiagaraSimCache
---@param bResetSystem boolean
function UNiagaraComponent:SetSimCache(SimCache, bResetSystem) end
---@param InSeekDelta float
function UNiagaraComponent:SetSeekDelta(InSeekDelta) end
---@param bInRenderingEnabled boolean
function UNiagaraComponent:SetRenderingEnabled(bInRenderingEnabled) end
---@param NewRandomSeedOffset int32
function UNiagaraComponent:SetRandomSeedOffset(NewRandomSeedOffset) end
---@param bEnablePreviewLODDistance boolean
---@param PreviewLODDistance float
---@param PreviewMaxDistance float
function UNiagaraComponent:SetPreviewLODDistance(bEnablePreviewLODDistance, PreviewLODDistance, PreviewMaxDistance) end
---@param bInPaused boolean
function UNiagaraComponent:SetPaused(bInPaused) end
---@param Mode ENiagaraOcclusionQueryMode
function UNiagaraComponent:SetOcclusionQueryMode(Mode) end
---@param InVariableName FString
---@param InValue FVector4
function UNiagaraComponent:SetNiagaraVariableVec4(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue FVector
function UNiagaraComponent:SetNiagaraVariableVec3(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue FVector2D
function UNiagaraComponent:SetNiagaraVariableVec2(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue FQuat
function UNiagaraComponent:SetNiagaraVariableQuat(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue FVector
function UNiagaraComponent:SetNiagaraVariablePosition(InVariableName, InValue) end
---@param InVariableName FString
---@param Object UObject
function UNiagaraComponent:SetNiagaraVariableObject(InVariableName, Object) end
---@param InVariableName FString
---@param InValue FMatrix
function UNiagaraComponent:SetNiagaraVariableMatrix(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue FLinearColor
function UNiagaraComponent:SetNiagaraVariableLinearColor(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue int32
function UNiagaraComponent:SetNiagaraVariableInt(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue float
function UNiagaraComponent:SetNiagaraVariableFloat(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue boolean
function UNiagaraComponent:SetNiagaraVariableBool(InVariableName, InValue) end
---@param InVariableName FString
---@param Actor AActor
function UNiagaraComponent:SetNiagaraVariableActor(InVariableName, Actor) end
---@param InMaxTime float
function UNiagaraComponent:SetMaxSimTime(InMaxTime) end
---@param bLock boolean
function UNiagaraComponent:SetLockDesiredAgeDeltaTimeToSeekDelta(bLock) end
---@param bEnableDebug boolean
function UNiagaraComponent:SetGpuComputeDebug(bEnableDebug) end
---@param bInForceSolo boolean
function UNiagaraComponent:SetForceSolo(bInForceSolo) end
---@param bIsPlayerEffect boolean
function UNiagaraComponent:SetForceLocalPlayerEffect(bIsPlayerEffect) end
---@param EmitterName FName
---@param LocalBounds FBox
function UNiagaraComponent:SetEmitterFixedBounds(EmitterName, LocalBounds) end
---@param InDesiredAge float
function UNiagaraComponent:SetDesiredAge(InDesiredAge) end
---@param Dilation float
function UNiagaraComponent:SetCustomTimeDilation(Dilation) end
---@param bInCanRenderWhileSeeking boolean
function UNiagaraComponent:SetCanRenderWhileSeeking(bInCanRenderWhileSeeking) end
---@param bInAutoDestroy boolean
function UNiagaraComponent:SetAutoDestroy(bInAutoDestroy) end
---@param InAsset UNiagaraSystem
---@param bResetExistingOverrideParameters boolean
function UNiagaraComponent:SetAsset(InAsset, bResetExistingOverrideParameters) end
---@param bAllow boolean
function UNiagaraComponent:SetAllowScalability(bAllow) end
---@param InAgeUpdateMode ENiagaraAgeUpdateMode
function UNiagaraComponent:SetAgeUpdateMode(InAgeUpdateMode) end
---@param InDesiredAge float
function UNiagaraComponent:SeekToDesiredAge(InDesiredAge) end
function UNiagaraComponent:ResetSystem() end
function UNiagaraComponent:ReinitializeSystem() end
---@return boolean
function UNiagaraComponent:IsPaused() end
function UNiagaraComponent:InitForPerformanceBaseline() end
---@return ENiagaraTickBehavior
function UNiagaraComponent:GetTickBehavior() end
---@return FBox
function UNiagaraComponent:GetSystemFixedBounds() end
---@return UNiagaraSimCache
function UNiagaraComponent:GetSimCache() end
---@return float
function UNiagaraComponent:GetSeekDelta() end
---@return int32
function UNiagaraComponent:GetRandomSeedOffset() end
---@return boolean
function UNiagaraComponent:GetPreviewLODDistanceEnabled() end
---@return float
function UNiagaraComponent:GetPreviewLODDistance() end
---@return ENiagaraOcclusionQueryMode
function UNiagaraComponent:GetOcclusionQueryMode() end
---@return float
function UNiagaraComponent:GetMaxSimTime() end
---@return boolean
function UNiagaraComponent:GetLockDesiredAgeDeltaTimeToSeekDelta() end
---@return boolean
function UNiagaraComponent:GetForceSolo() end
---@return boolean
function UNiagaraComponent:GetForceLocalPlayerEffect() end
---@param EmitterName FName
---@return FBox
function UNiagaraComponent:GetEmitterFixedBounds(EmitterName) end
---@return float
function UNiagaraComponent:GetDesiredAge() end
---@param Name FString
---@return UNiagaraDataInterface
function UNiagaraComponent:GetDataInterface(Name) end
---@return float
function UNiagaraComponent:GetCustomTimeDilation() end
---@return UNiagaraSystem
function UNiagaraComponent:GetAsset() end
---@return boolean
function UNiagaraComponent:GetAllowScalability() end
---@return ENiagaraAgeUpdateMode
function UNiagaraComponent:GetAgeUpdateMode() end
function UNiagaraComponent:ClearSystemFixedBounds() end
---@param bResetSystem boolean
function UNiagaraComponent:ClearSimCache(bResetSystem) end
---@param EmitterName FName
function UNiagaraComponent:ClearEmitterFixedBounds(EmitterName) end
---@param SimulateTime float
---@param TickDeltaSeconds float
function UNiagaraComponent:AdvanceSimulationByTime(SimulateTime, TickDeltaSeconds) end
---@param TickCount int32
---@param TickDeltaSeconds float
function UNiagaraComponent:AdvanceSimulation(TickCount, TickDeltaSeconds) end


---@class UNiagaraComponentPool : UObject
---@field WorldParticleSystemPools TMap<UNiagaraSystem, FNCPool>
local UNiagaraComponentPool = {}



---@class UNiagaraComponentRendererProperties : UNiagaraRendererProperties
---@field ComponentType TSubclassOf<USceneComponent>
---@field ComponentCountLimit uint32
---@field EnabledBinding FNiagaraVariableAttributeBinding
---@field RendererVisibilityTagBinding FNiagaraVariableAttributeBinding
---@field bAssignComponentsOnParticleID boolean
---@field bCreateComponentFirstParticleFrame boolean
---@field bOnlyActivateNewlyAquiredComponents boolean
---@field RendererVisibility int32
---@field TemplateComponent USceneComponent
---@field PropertyBindings TArray<FNiagaraComponentPropertyBinding>
local UNiagaraComponentRendererProperties = {}



---@class UNiagaraConvertInPlaceUtilityBase : UObject
local UNiagaraConvertInPlaceUtilityBase = {}


---@class UNiagaraCullProxyComponent : UNiagaraComponent
---@field Instances TArray<FNiagaraCulledComponentInfo>
local UNiagaraCullProxyComponent = {}



---@class UNiagaraDIRigidMeshCollisionFunctionLibrary : UBlueprintFunctionLibrary
local UNiagaraDIRigidMeshCollisionFunctionLibrary = {}

---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param SourceActors TArray<AActor>
function UNiagaraDIRigidMeshCollisionFunctionLibrary:SetSourceActors(NiagaraSystem, OverrideName, SourceActors) end


---@class UNiagaraDataChannel : UObject
---@field ChannelVariables TArray<FNiagaraDataChannelVariable>
---@field bKeepPreviousFrameData boolean
---@field bEnforceTickGroupReadWriteOrder boolean
---@field FinalWriteTickGroup ETickingGroup
local UNiagaraDataChannel = {}



---@class UNiagaraDataChannelAsset : UObject
---@field DataChannel UNiagaraDataChannel
local UNiagaraDataChannelAsset = {}



---@class UNiagaraDataChannelHandler : UObject
---@field DataChannel TWeakObjectPtr<UNiagaraDataChannel>
---@field Writer UNiagaraDataChannelWriter
---@field Reader UNiagaraDataChannelReader
local UNiagaraDataChannelHandler = {}

---@return UNiagaraDataChannelWriter
function UNiagaraDataChannelHandler:GetDataChannelWriter() end
---@return UNiagaraDataChannelReader
function UNiagaraDataChannelHandler:GetDataChannelReader() end


---@class UNiagaraDataChannelHandler_Global : UNiagaraDataChannelHandler
local UNiagaraDataChannelHandler_Global = {}


---@class UNiagaraDataChannelHandler_Islands : UNiagaraDataChannelHandler
---@field ActiveIslands TArray<int32>
---@field FreeIslands TArray<int32>
---@field IslandPool TArray<FNDCIsland>
local UNiagaraDataChannelHandler_Islands = {}



---@class UNiagaraDataChannelLibrary : UBlueprintFunctionLibrary
local UNiagaraDataChannelLibrary = {}

---@param WorldContextObject UObject
---@param Channel UNiagaraDataChannelAsset
---@param SearchParams FNiagaraDataChannelSearchParameters
---@param bVisibleToBlueprint boolean
---@param bVisibleToNiagaraCPU boolean
---@param bVisibleToNiagaraGPU boolean
function UNiagaraDataChannelLibrary:WriteToNiagaraDataChannelSingle(WorldContextObject, Channel, SearchParams, bVisibleToBlueprint, bVisibleToNiagaraCPU, bVisibleToNiagaraGPU) end
---@param WorldContextObject UObject
---@param Channel UNiagaraDataChannelAsset
---@param SearchParams FNiagaraDataChannelSearchParameters
---@param Count int32
---@param bVisibleToGame boolean
---@param bVisibleToCPU boolean
---@param bVisibleToGPU boolean
---@param DebugSource FString
---@return UNiagaraDataChannelWriter
function UNiagaraDataChannelLibrary:WriteToNiagaraDataChannel(WorldContextObject, Channel, SearchParams, Count, bVisibleToGame, bVisibleToCPU, bVisibleToGPU, DebugSource) end
---@param WorldContextObject UObject
---@param Channel UNiagaraDataChannelAsset
---@param Index int32
---@param SearchParams FNiagaraDataChannelSearchParameters
---@param bReadPreviousFrame boolean
---@param ReadResult ENiagartaDataChannelReadResult
function UNiagaraDataChannelLibrary:ReadFromNiagaraDataChannelSingle(WorldContextObject, Channel, Index, SearchParams, bReadPreviousFrame, ReadResult) end
---@param WorldContextObject UObject
---@param Channel UNiagaraDataChannelAsset
---@param SearchParams FNiagaraDataChannelSearchParameters
---@param bReadPreviousFrame boolean
---@return UNiagaraDataChannelReader
function UNiagaraDataChannelLibrary:ReadFromNiagaraDataChannel(WorldContextObject, Channel, SearchParams, bReadPreviousFrame) end
---@param WorldContextObject UObject
---@param Channel UNiagaraDataChannelAsset
---@return UNiagaraDataChannelHandler
function UNiagaraDataChannelLibrary:GetNiagaraDataChannel(WorldContextObject, Channel) end
---@param WorldContextObject UObject
---@param Channel UNiagaraDataChannelAsset
---@param SearchParams FNiagaraDataChannelSearchParameters
---@param bReadPreviousFrame boolean
---@return int32
function UNiagaraDataChannelLibrary:GetDataChannelElementCount(WorldContextObject, Channel, SearchParams, bReadPreviousFrame) end


---@class UNiagaraDataChannelReader : UObject
---@field Owner UNiagaraDataChannelHandler
local UNiagaraDataChannelReader = {}

---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return FVector4
function UNiagaraDataChannelReader:ReadVector4(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return FVector2D
function UNiagaraDataChannelReader:ReadVector2D(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return FVector
function UNiagaraDataChannelReader:ReadVector(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return FNiagaraSpawnInfo
function UNiagaraDataChannelReader:ReadSpawnInfo(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return FQuat
function UNiagaraDataChannelReader:ReadQuat(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return FVector
function UNiagaraDataChannelReader:ReadPosition(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return FLinearColor
function UNiagaraDataChannelReader:ReadLinearColor(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return int32
function UNiagaraDataChannelReader:ReadInt(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return FNiagaraID
function UNiagaraDataChannelReader:ReadID(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return double
function UNiagaraDataChannelReader:ReadFloat(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return uint8
function UNiagaraDataChannelReader:ReadEnum(VarName, Index, IsValid) end
---@param VarName FName
---@param Index int32
---@param IsValid boolean
---@return boolean
function UNiagaraDataChannelReader:ReadBool(VarName, Index, IsValid) end
---@return int32
function UNiagaraDataChannelReader:Num() end
---@param SearchParams FNiagaraDataChannelSearchParameters
---@param bReadPrevFrameData boolean
---@return boolean
function UNiagaraDataChannelReader:InitAccess(SearchParams, bReadPrevFrameData) end


---@class UNiagaraDataChannelWriter : UObject
---@field Owner UNiagaraDataChannelHandler
local UNiagaraDataChannelWriter = {}

---@param VarName FName
---@param Index int32
---@param InData FVector4
function UNiagaraDataChannelWriter:WriteVector4(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData FVector2D
function UNiagaraDataChannelWriter:WriteVector2D(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData FVector
function UNiagaraDataChannelWriter:WriteVector(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData FNiagaraSpawnInfo
function UNiagaraDataChannelWriter:WriteSpawnInfo(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData FQuat
function UNiagaraDataChannelWriter:WriteQuat(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData FVector
function UNiagaraDataChannelWriter:WritePosition(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData FLinearColor
function UNiagaraDataChannelWriter:WriteLinearColor(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData int32
function UNiagaraDataChannelWriter:WriteInt(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData FNiagaraID
function UNiagaraDataChannelWriter:WriteID(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData double
function UNiagaraDataChannelWriter:WriteFloat(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData uint8
function UNiagaraDataChannelWriter:WriteEnum(VarName, Index, InData) end
---@param VarName FName
---@param Index int32
---@param InData boolean
function UNiagaraDataChannelWriter:WriteBool(VarName, Index, InData) end
---@return int32
function UNiagaraDataChannelWriter:Num() end
---@param SearchParams FNiagaraDataChannelSearchParameters
---@param Count int32
---@param bVisibleToGame boolean
---@param bVisibleToCPU boolean
---@param bVisibleToGPU boolean
---@param DebugSource FString
---@return boolean
function UNiagaraDataChannelWriter:InitWrite(SearchParams, Count, bVisibleToGame, bVisibleToCPU, bVisibleToGPU, DebugSource) end


---@class UNiagaraDataChannel_Global : UNiagaraDataChannel
local UNiagaraDataChannel_Global = {}


---@class UNiagaraDataChannel_Islands : UNiagaraDataChannel
---@field Mode ENiagraDataChannel_IslandMode
---@field InitialExtents FVector
---@field MaxExtents FVector
---@field PerElementExtents FVector
---@field Systems TArray<TSoftObjectPtr<UNiagaraSystem>>
---@field IslandPoolSize int32
---@field DebugDrawSettings FNDCIslandDebugDrawSettings
---@field SystemsInternal TArray<UNiagaraSystem>
local UNiagaraDataChannel_Islands = {}



---@class UNiagaraDataInterface : UNiagaraDataInterfaceBase
local UNiagaraDataInterface = {}


---@class UNiagaraDataInterface2DArrayTexture : UNiagaraDataInterface
---@field Texture UTexture
---@field TextureUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterface2DArrayTexture = {}



---@class UNiagaraDataInterfaceActorComponent : UNiagaraDataInterface
---@field SourceMode ENDIActorComponentSourceMode
---@field LocalPlayerIndex int32
---@field SourceActor TLazyObjectPtr<AActor>
---@field ActorOrComponentParameter FNiagaraUserParameterBinding
---@field bRequireCurrentFrameData boolean
local UNiagaraDataInterfaceActorComponent = {}



---@class UNiagaraDataInterfaceArray : UNiagaraDataInterfaceRWBase
---@field GpuSyncMode ENiagaraGpuSyncMode
---@field MaxElements int32
local UNiagaraDataInterfaceArray = {}



---@class UNiagaraDataInterfaceArrayBool : UNiagaraDataInterfaceArray
---@field BoolData TArray<boolean>
local UNiagaraDataInterfaceArrayBool = {}



---@class UNiagaraDataInterfaceArrayColor : UNiagaraDataInterfaceArray
---@field ColorData TArray<FLinearColor>
local UNiagaraDataInterfaceArrayColor = {}



---@class UNiagaraDataInterfaceArrayFloat : UNiagaraDataInterfaceArray
---@field FloatData TArray<float>
local UNiagaraDataInterfaceArrayFloat = {}



---@class UNiagaraDataInterfaceArrayFloat2 : UNiagaraDataInterfaceArray
---@field InternalFloatData TArray<FVector2f>
local UNiagaraDataInterfaceArrayFloat2 = {}



---@class UNiagaraDataInterfaceArrayFloat3 : UNiagaraDataInterfaceArray
---@field InternalFloatData TArray<FVector3f>
local UNiagaraDataInterfaceArrayFloat3 = {}



---@class UNiagaraDataInterfaceArrayFloat4 : UNiagaraDataInterfaceArray
---@field InternalFloatData TArray<FVector4f>
local UNiagaraDataInterfaceArrayFloat4 = {}



---@class UNiagaraDataInterfaceArrayFunctionLibrary : UBlueprintFunctionLibrary
local UNiagaraDataInterfaceArrayFunctionLibrary = {}

---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value FVector
---@param bSizeToFit boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayVectorValue(NiagaraSystem, OverrideName, Index, Value, bSizeToFit) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value FVector4
---@param bSizeToFit boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayVector4Value(NiagaraSystem, OverrideName, Index, Value, bSizeToFit) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<FVector4>
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayVector4(NiagaraSystem, OverrideName, ArrayData) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value FVector2D
---@param bSizeToFit boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayVector2DValue(NiagaraSystem, OverrideName, Index, Value, bSizeToFit) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<FVector2D>
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayVector2D(NiagaraSystem, OverrideName, ArrayData) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<FVector>
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayVector(NiagaraSystem, OverrideName, ArrayData) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value int32
---@param bSizeToFit boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayUInt8Value(NiagaraSystem, OverrideName, Index, Value, bSizeToFit) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<int32>
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayUInt8(NiagaraSystem, OverrideName, ArrayData) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value FQuat
---@param bSizeToFit boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayQuatValue(NiagaraSystem, OverrideName, Index, Value, bSizeToFit) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<FQuat>
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayQuat(NiagaraSystem, OverrideName, ArrayData) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value FVector
---@param bSizeToFit boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayPositionValue(NiagaraSystem, OverrideName, Index, Value, bSizeToFit) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<FVector>
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayPosition(NiagaraSystem, OverrideName, ArrayData) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value FMatrix
---@param bSizeToFit boolean
---@param bApplyLWCRebase boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayMatrixValue(NiagaraSystem, OverrideName, Index, Value, bSizeToFit, bApplyLWCRebase) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<FMatrix>
---@param bApplyLWCRebase boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayMatrix(NiagaraSystem, OverrideName, ArrayData, bApplyLWCRebase) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value int32
---@param bSizeToFit boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayInt32Value(NiagaraSystem, OverrideName, Index, Value, bSizeToFit) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<int32>
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayInt32(NiagaraSystem, OverrideName, ArrayData) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value float
---@param bSizeToFit boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayFloatValue(NiagaraSystem, OverrideName, Index, Value, bSizeToFit) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<float>
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayFloat(NiagaraSystem, OverrideName, ArrayData) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value FLinearColor
---@param bSizeToFit boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayColorValue(NiagaraSystem, OverrideName, Index, Value, bSizeToFit) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<FLinearColor>
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayColor(NiagaraSystem, OverrideName, ArrayData) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param Value boolean
---@param bSizeToFit boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayBoolValue(NiagaraSystem, OverrideName, Index, Value, bSizeToFit) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param ArrayData TArray<boolean>
function UNiagaraDataInterfaceArrayFunctionLibrary:SetNiagaraArrayBool(NiagaraSystem, OverrideName, ArrayData) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@return FVector
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayVectorValue(NiagaraSystem, OverrideName, Index) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@return FVector4
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayVector4Value(NiagaraSystem, OverrideName, Index) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@return TArray<FVector4>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayVector4(NiagaraSystem, OverrideName) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@return FVector2D
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayVector2DValue(NiagaraSystem, OverrideName, Index) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@return TArray<FVector2D>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayVector2D(NiagaraSystem, OverrideName) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@return TArray<FVector>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayVector(NiagaraSystem, OverrideName) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@return int32
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayUInt8Value(NiagaraSystem, OverrideName, Index) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@return TArray<int32>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayUInt8(NiagaraSystem, OverrideName) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@return FQuat
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayQuatValue(NiagaraSystem, OverrideName, Index) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@return TArray<FQuat>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayQuat(NiagaraSystem, OverrideName) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@return FVector
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayPositionValue(NiagaraSystem, OverrideName, Index) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@return TArray<FVector>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayPosition(NiagaraSystem, OverrideName) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@param bApplyLWCRebase boolean
---@return FMatrix
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayMatrixValue(NiagaraSystem, OverrideName, Index, bApplyLWCRebase) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param bApplyLWCRebase boolean
---@return TArray<FMatrix>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayMatrix(NiagaraSystem, OverrideName, bApplyLWCRebase) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@return int32
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayInt32Value(NiagaraSystem, OverrideName, Index) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@return TArray<int32>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayInt32(NiagaraSystem, OverrideName) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@return float
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayFloatValue(NiagaraSystem, OverrideName, Index) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@return TArray<float>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayFloat(NiagaraSystem, OverrideName) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@return FLinearColor
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayColorValue(NiagaraSystem, OverrideName, Index) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@return TArray<FLinearColor>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayColor(NiagaraSystem, OverrideName) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@param Index int32
---@return boolean
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayBoolValue(NiagaraSystem, OverrideName, Index) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FName
---@return TArray<boolean>
function UNiagaraDataInterfaceArrayFunctionLibrary:GetNiagaraArrayBool(NiagaraSystem, OverrideName) end


---@class UNiagaraDataInterfaceArrayInt32 : UNiagaraDataInterfaceArray
---@field IntData TArray<int32>
local UNiagaraDataInterfaceArrayInt32 = {}



---@class UNiagaraDataInterfaceArrayMatrix : UNiagaraDataInterfaceArray
---@field InternalMatrixData TArray<FMatrix44f>
local UNiagaraDataInterfaceArrayMatrix = {}



---@class UNiagaraDataInterfaceArrayNiagaraID : UNiagaraDataInterfaceArray
---@field IntData TArray<FNiagaraID>
local UNiagaraDataInterfaceArrayNiagaraID = {}



---@class UNiagaraDataInterfaceArrayPosition : UNiagaraDataInterfaceArray
---@field PositionData TArray<FNiagaraPosition>
local UNiagaraDataInterfaceArrayPosition = {}



---@class UNiagaraDataInterfaceArrayQuat : UNiagaraDataInterfaceArray
---@field InternalQuatData TArray<FQuat4f>
local UNiagaraDataInterfaceArrayQuat = {}



---@class UNiagaraDataInterfaceArrayUInt8 : UNiagaraDataInterfaceArray
---@field InternalIntData TArray<uint8>
local UNiagaraDataInterfaceArrayUInt8 = {}



---@class UNiagaraDataInterfaceAsyncGpuTrace : UNiagaraDataInterface
---@field MaxTracesPerParticle int32
---@field MaxRetraces int32
---@field TraceProvider ENDICollisionQuery_AsyncGpuTraceProvider::Type
local UNiagaraDataInterfaceAsyncGpuTrace = {}



---@class UNiagaraDataInterfaceAudioOscilloscope : UNiagaraDataInterface
---@field Submix USoundSubmix
---@field Resolution int32
---@field ScopeInMilliseconds float
local UNiagaraDataInterfaceAudioOscilloscope = {}



---@class UNiagaraDataInterfaceAudioPlayer : UNiagaraDataInterface
---@field SoundToPlay USoundBase
---@field Attenuation USoundAttenuation
---@field Concurrency USoundConcurrency
---@field ParameterNames TArray<FName>
---@field ConfigurationUserParameter FNiagaraUserParameterBinding
---@field bLimitPlaysPerTick boolean
---@field MaxPlaysPerTick int32
---@field bStopWhenComponentIsDestroyed boolean
---@field bAllowLoopingOneShotSounds boolean
local UNiagaraDataInterfaceAudioPlayer = {}



---@class UNiagaraDataInterfaceAudioPlayerSettings : UObject
---@field bOverrideConcurrency boolean
---@field Concurrency USoundConcurrency
---@field bOverrideAttenuationSettings boolean
---@field AttenuationSettings FSoundAttenuationSettings
local UNiagaraDataInterfaceAudioPlayerSettings = {}



---@class UNiagaraDataInterfaceAudioSpectrum : UNiagaraDataInterfaceAudioSubmix
---@field Resolution int32
---@field MinimumFrequency float
---@field MaximumFrequency float
---@field NoiseFloorDb float
local UNiagaraDataInterfaceAudioSpectrum = {}



---@class UNiagaraDataInterfaceAudioSubmix : UNiagaraDataInterface
---@field Submix USoundSubmix
local UNiagaraDataInterfaceAudioSubmix = {}



---@class UNiagaraDataInterfaceCamera : UNiagaraDataInterface
---@field PlayerControllerIndex int32
---@field bRequireCurrentFrameData boolean
local UNiagaraDataInterfaceCamera = {}



---@class UNiagaraDataInterfaceCollisionQuery : UNiagaraDataInterface
local UNiagaraDataInterfaceCollisionQuery = {}


---@class UNiagaraDataInterfaceColorCurve : UNiagaraDataInterfaceCurveBase
---@field RedCurve FRichCurve
---@field GreenCurve FRichCurve
---@field BlueCurve FRichCurve
---@field AlphaCurve FRichCurve
local UNiagaraDataInterfaceColorCurve = {}



---@class UNiagaraDataInterfaceConsoleVariable : UNiagaraDataInterface
local UNiagaraDataInterfaceConsoleVariable = {}


---@class UNiagaraDataInterfaceCubeTexture : UNiagaraDataInterface
---@field Texture UTexture
---@field TextureUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterfaceCubeTexture = {}



---@class UNiagaraDataInterfaceCurlNoise : UNiagaraDataInterface
---@field Seed uint32
local UNiagaraDataInterfaceCurlNoise = {}



---@class UNiagaraDataInterfaceCurve : UNiagaraDataInterfaceCurveBase
---@field Curve FRichCurve
local UNiagaraDataInterfaceCurve = {}



---@class UNiagaraDataInterfaceCurveBase : UNiagaraDataInterface
---@field ShaderLUT TArray<float>
---@field LUTMinTime float
---@field LUTMaxTime float
---@field LUTInvTimeRange float
---@field LUTNumSamplesMinusOne float
---@field bUseLUT boolean
---@field bExposeCurve boolean
---@field ExposedName FName
---@field ExposedTexture UTexture2D
local UNiagaraDataInterfaceCurveBase = {}



---@class UNiagaraDataInterfaceDataChannelRead : UNiagaraDataInterfaceRWBase
---@field Channel UNiagaraDataChannelAsset
---@field bReadCurrentFrame boolean
---@field bUpdateSourceDataEveryTick boolean
---@field bOverrideSpawnGroupToDataChannelIndex boolean
---@field CompiledData FNDIDataChannelCompiledData
local UNiagaraDataInterfaceDataChannelRead = {}



---@class UNiagaraDataInterfaceDataChannelWrite : UNiagaraDataInterface
---@field AllocationMode ENiagaraDataChannelAllocationMode
---@field AllocationCount uint32
---@field bPublishToGame boolean
---@field bPublishToCPU boolean
---@field bPublishToGPU boolean
---@field bUpdateDestinationDataEveryTick boolean
---@field Channel UNiagaraDataChannelAsset
---@field CompiledData FNDIDataChannelWriteCompiledData
local UNiagaraDataInterfaceDataChannelWrite = {}



---@class UNiagaraDataInterfaceDebugDraw : UNiagaraDataInterface
---@field OverrideMaxLineInstances uint32
local UNiagaraDataInterfaceDebugDraw = {}



---@class UNiagaraDataInterfaceDynamicMesh : UNiagaraDataInterface
---@field Sections TArray<FNiagaraDynamicMeshSection>
---@field Materials TArray<FNiagaraDynamicMeshMaterial>
---@field NumVertices int32
---@field NumTexCoords int32
---@field bHasColors boolean
---@field bHasTangentBasis boolean
---@field bClearTrianglesPerFrame boolean
---@field DefaultBounds FBox
local UNiagaraDataInterfaceDynamicMesh = {}



---@class UNiagaraDataInterfaceEmitterProperties : UNiagaraDataInterface
---@field EmitterBinding FNiagaraDataInterfaceEmitterBinding
local UNiagaraDataInterfaceEmitterProperties = {}



---@class UNiagaraDataInterfaceExport : UNiagaraDataInterface
---@field CallbackHandlerParameter FNiagaraUserParameterBinding
---@field GPUAllocationMode ENDIExport_GPUAllocationMode
---@field GPUAllocationFixedSize int32
---@field GPUAllocationPerParticleSize float
local UNiagaraDataInterfaceExport = {}



---@class UNiagaraDataInterfaceGBuffer : UNiagaraDataInterface
local UNiagaraDataInterfaceGBuffer = {}


---@class UNiagaraDataInterfaceGrid2D : UNiagaraDataInterfaceRWBase
---@field ClearBeforeNonIterationStage boolean
---@field NumCellsX int32
---@field NumCellsY int32
---@field NumCellsMaxAxis int32
---@field NumAttributes int32
---@field SetGridFromMaxAxis boolean
---@field WorldBBoxSize FVector2D
local UNiagaraDataInterfaceGrid2D = {}



---@class UNiagaraDataInterfaceGrid2DCollection : UNiagaraDataInterfaceGrid2D
---@field RenderTargetUserParameter FNiagaraUserParameterBinding
---@field OverrideBufferFormat ENiagaraGpuBufferFormat
---@field bOverrideFormat boolean
---@field ManagedRenderTargets TMap<uint64, UTextureRenderTarget2DArray>
local UNiagaraDataInterfaceGrid2DCollection = {}

---@param Component UNiagaraComponent
---@param SizeX int32
---@param SizeY int32
function UNiagaraDataInterfaceGrid2DCollection:GetTextureSize(Component, SizeX, SizeY) end
---@param Component UNiagaraComponent
---@param SizeX int32
---@param SizeY int32
function UNiagaraDataInterfaceGrid2DCollection:GetRawTextureSize(Component, SizeX, SizeY) end
---@param Component UNiagaraComponent
---@param Dest UTextureRenderTarget2D
---@param AttributeIndex int32
---@return boolean
function UNiagaraDataInterfaceGrid2DCollection:FillTexture2D(Component, Dest, AttributeIndex) end
---@param Component UNiagaraComponent
---@param Dest UTextureRenderTarget2D
---@param TilesX int32
---@param TilesY int32
---@return boolean
function UNiagaraDataInterfaceGrid2DCollection:FillRawTexture2D(Component, Dest, TilesX, TilesY) end


---@class UNiagaraDataInterfaceGrid2DCollectionReader : UNiagaraDataInterfaceGrid2DCollection
---@field EmitterName FString
---@field DIName FString
local UNiagaraDataInterfaceGrid2DCollectionReader = {}



---@class UNiagaraDataInterfaceGrid3D : UNiagaraDataInterfaceRWBase
---@field ClearBeforeNonIterationStage boolean
---@field NumCells FIntVector
---@field CellSize float
---@field NumCellsMaxAxis int32
---@field SetResolutionMethod ESetResolutionMethod
---@field WorldBBoxSize FVector
local UNiagaraDataInterfaceGrid3D = {}



---@class UNiagaraDataInterfaceGrid3DCollection : UNiagaraDataInterfaceGrid3D
---@field NumAttributes int32
---@field RenderTargetUserParameter FNiagaraUserParameterBinding
---@field OverrideBufferFormat ENiagaraGpuBufferFormat
---@field bOverrideFormat boolean
local UNiagaraDataInterfaceGrid3DCollection = {}

---@param Component UNiagaraComponent
---@param SizeX int32
---@param SizeY int32
---@param SizeZ int32
function UNiagaraDataInterfaceGrid3DCollection:GetTextureSize(Component, SizeX, SizeY, SizeZ) end
---@param Component UNiagaraComponent
---@param SizeX int32
---@param SizeY int32
---@param SizeZ int32
function UNiagaraDataInterfaceGrid3DCollection:GetRawTextureSize(Component, SizeX, SizeY, SizeZ) end
---@param Component UNiagaraComponent
---@param Dest UVolumeTexture
---@param AttributeIndex int32
---@return boolean
function UNiagaraDataInterfaceGrid3DCollection:FillVolumeTexture(Component, Dest, AttributeIndex) end
---@param Component UNiagaraComponent
---@param Dest UVolumeTexture
---@param TilesX int32
---@param TilesY int32
---@param TileZ int32
---@return boolean
function UNiagaraDataInterfaceGrid3DCollection:FillRawVolumeTexture(Component, Dest, TilesX, TilesY, TileZ) end


---@class UNiagaraDataInterfaceGrid3DCollectionReader : UNiagaraDataInterfaceGrid3DCollection
---@field EmitterName FString
---@field DIName FString
local UNiagaraDataInterfaceGrid3DCollectionReader = {}



---@class UNiagaraDataInterfaceIntRenderTarget2D : UNiagaraDataInterfaceRWBase
---@field Size FIntPoint
---@field RenderTargetUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterfaceIntRenderTarget2D = {}



---@class UNiagaraDataInterfaceLandscape : UNiagaraDataInterface
---@field SourceLandscape AActor
---@field SourceMode ENDILandscape_SourceMode
---@field PhysicalMaterials TArray<UPhysicalMaterial>
---@field bVirtualTexturesSupported boolean
local UNiagaraDataInterfaceLandscape = {}



---@class UNiagaraDataInterfaceMemoryBuffer : UNiagaraDataInterface
---@field DefaultNumElements int32
---@field GpuSyncMode ENiagaraGpuSyncMode
local UNiagaraDataInterfaceMemoryBuffer = {}



---@class UNiagaraDataInterfaceMeshRendererInfo : UNiagaraDataInterface
---@field MeshRenderer UNiagaraMeshRendererProperties
local UNiagaraDataInterfaceMeshRendererInfo = {}



---@class UNiagaraDataInterfaceNeighborGrid3D : UNiagaraDataInterfaceGrid3D
---@field MaxNeighborsPerCell uint32
local UNiagaraDataInterfaceNeighborGrid3D = {}



---@class UNiagaraDataInterfaceOcclusion : UNiagaraDataInterface
local UNiagaraDataInterfaceOcclusion = {}


---@class UNiagaraDataInterfaceParticleRead : UNiagaraDataInterfaceRWBase
---@field EmitterBinding FNiagaraDataInterfaceEmitterBinding
local UNiagaraDataInterfaceParticleRead = {}



---@class UNiagaraDataInterfacePhysicsAsset : UNiagaraDataInterface
---@field DefaultSource UPhysicsAsset
---@field SoftSourceActor TSoftObjectPtr<AActor>
---@field MeshUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterfacePhysicsAsset = {}



---@class UNiagaraDataInterfacePlatformSet : UNiagaraDataInterface
---@field Platforms FNiagaraPlatformSet
local UNiagaraDataInterfacePlatformSet = {}



---@class UNiagaraDataInterfaceRWBase : UNiagaraDataInterface
local UNiagaraDataInterfaceRWBase = {}


---@class UNiagaraDataInterfaceRasterizationGrid3D : UNiagaraDataInterfaceGrid3D
---@field NumAttributes int32
---@field Precision float
---@field ResetValue int32
local UNiagaraDataInterfaceRasterizationGrid3D = {}



---@class UNiagaraDataInterfaceRenderTarget2D : UNiagaraDataInterfaceRWBase
---@field Size FIntPoint
---@field MipMapGeneration ENiagaraMipMapGeneration
---@field MipMapGenerationType ENiagaraMipMapGenerationType
---@field OverrideRenderTargetFormat ETextureRenderTargetFormat
---@field OverrideRenderTargetFilter TextureFilter
---@field bInheritUserParameterSettings boolean
---@field bOverrideFormat boolean
---@field RenderTargetUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterfaceRenderTarget2D = {}



---@class UNiagaraDataInterfaceRenderTarget2DArray : UNiagaraDataInterfaceRWBase
---@field Size FIntVector
---@field OverrideRenderTargetFormat ETextureRenderTargetFormat
---@field OverrideRenderTargetFilter TextureFilter
---@field bInheritUserParameterSettings boolean
---@field bOverrideFormat boolean
---@field RenderTargetUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterfaceRenderTarget2DArray = {}



---@class UNiagaraDataInterfaceRenderTargetCube : UNiagaraDataInterfaceRWBase
---@field Size int32
---@field OverrideRenderTargetFormat ETextureRenderTargetFormat
---@field OverrideRenderTargetFilter TextureFilter
---@field bInheritUserParameterSettings boolean
---@field bOverrideFormat boolean
---@field RenderTargetUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterfaceRenderTargetCube = {}



---@class UNiagaraDataInterfaceRenderTargetVolume : UNiagaraDataInterfaceRWBase
---@field Size FIntVector
---@field OverrideRenderTargetFormat ETextureRenderTargetFormat
---@field OverrideRenderTargetFilter TextureFilter
---@field bInheritUserParameterSettings boolean
---@field bOverrideFormat boolean
---@field RenderTargetUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterfaceRenderTargetVolume = {}



---@class UNiagaraDataInterfaceRigidMeshCollisionQuery : UNiagaraDataInterface
---@field ActorTags TArray<FName>
---@field ComponentTags TArray<FName>
---@field SourceActors TArray<TSoftObjectPtr<AActor>>
---@field OnlyUseMoveable boolean
---@field UseComplexCollisions boolean
---@field bFilterByObjectType boolean
---@field GlobalSearchAllowed boolean
---@field GlobalSearchForced boolean
---@field GlobalSearchFallback_Unscripted boolean
---@field MaxNumPrimitives int32
local UNiagaraDataInterfaceRigidMeshCollisionQuery = {}



---@class UNiagaraDataInterfaceSceneCapture2D : UNiagaraDataInterface
---@field SourceMode ENDISceneCapture2DSourceMode
---@field SceneCaptureUserParameter FNiagaraUserParameterBinding
---@field bAutoMoveWithComponent boolean
---@field AutoMoveOffsetLocationMode ENDISceneCapture2DOffsetMode
---@field AutoMoveOffsetLocation FVector
---@field AutoMoveOffsetRotationMode ENDISceneCapture2DOffsetMode
---@field AutoMoveOffsetRotation FRotator
---@field ManagedCaptureSource ESceneCaptureSource
---@field ManagedTextureSize FIntPoint
---@field ManagedTextureFormat ETextureRenderTargetFormat
---@field ManagedProjectionType ECameraProjectionMode::Type
---@field ManagedFOVAngle float
---@field ManagedOrthoWidth float
---@field bManagedCaptureEveryFrame boolean
---@field bManagedCaptureOnMovement boolean
---@field ManagedShowOnlyActors TArray<AActor>
---@field ManagedCaptureComponents TMap<uint64, USceneCaptureComponent2D>
local UNiagaraDataInterfaceSceneCapture2D = {}

---@param NiagaraSystem UNiagaraComponent
---@param ParameterName FName
---@param ShowOnlyActors TArray<AActor>
function UNiagaraDataInterfaceSceneCapture2D:SetSceneCapture2DManagedShowOnlyActors(NiagaraSystem, ParameterName, ShowOnlyActors) end


---@class UNiagaraDataInterfaceSimCacheReader : UNiagaraDataInterface
---@field SimCacheBinding FNiagaraUserParameterBinding
---@field SimCache UNiagaraSimCache
---@field EmitterBinding FName
local UNiagaraDataInterfaceSimCacheReader = {}



---@class UNiagaraDataInterfaceSimpleCounter : UNiagaraDataInterfaceRWBase
---@field GpuSyncMode ENiagaraGpuSyncMode
---@field InitialValue int32
local UNiagaraDataInterfaceSimpleCounter = {}



---@class UNiagaraDataInterfaceSkeletalMesh : UNiagaraDataInterface
---@field SourceMode ENDISkeletalMesh_SourceMode
---@field DefaultMesh USkeletalMesh
---@field SoftSourceActor TSoftObjectPtr<AActor>
---@field ComponentTags TArray<FName>
---@field SourceComponent USkeletalMeshComponent
---@field MeshUserParameter FNiagaraUserParameterBinding
---@field SkinningMode ENDISkeletalMesh_SkinningMode
---@field SamplingRegions TArray<FName>
---@field WholeMeshLOD int32
---@field FilteredBones TArray<FName>
---@field FilteredSockets TArray<FName>
---@field ExcludeBoneName FName
---@field bExcludeBone boolean
---@field UvSetIndex int32
---@field bRequireCurrentFrameData boolean
---@field bReadDeformedGeometry boolean
local UNiagaraDataInterfaceSkeletalMesh = {}

---@param InSource AActor
---@param Reason EEndPlayReason::Type
function UNiagaraDataInterfaceSkeletalMesh:OnSourceEndPlay(InSource, Reason) end


---@class UNiagaraDataInterfaceSocketReader : UNiagaraDataInterface
---@field SourceMode ENDISocketReaderSourceMode
---@field FilteredSockets TArray<FName>
---@field SourceActor TLazyObjectPtr<AActor>
---@field SourceAsset UObject
---@field AttachComponentClass UClass
---@field AttachComponentTag FName
---@field ObjectParameterBinding FNiagaraUserParameterBinding
---@field bUpdateSocketsPerFrame boolean
---@field bRequireCurrentFrameData boolean
local UNiagaraDataInterfaceSocketReader = {}



---@class UNiagaraDataInterfaceSparseVolumeTexture : UNiagaraDataInterface
---@field SparseVolumeTexture USparseVolumeTexture
---@field SparseVolumeTextureUserParameter FNiagaraUserParameterBinding
---@field BlockingStreamingRequests boolean
local UNiagaraDataInterfaceSparseVolumeTexture = {}



---@class UNiagaraDataInterfaceSpline : UNiagaraDataInterface
---@field SoftSourceActor TSoftObjectPtr<AActor>
---@field SplineUserParameter FNiagaraUserParameterBinding
---@field bUseLUT boolean
---@field NumLUTSteps int32
local UNiagaraDataInterfaceSpline = {}



---@class UNiagaraDataInterfaceSpriteRendererInfo : UNiagaraDataInterface
---@field SpriteRenderer UNiagaraSpriteRendererProperties
local UNiagaraDataInterfaceSpriteRendererInfo = {}



---@class UNiagaraDataInterfaceStaticMesh : UNiagaraDataInterface
---@field SourceMode ENDIStaticMesh_SourceMode
---@field DefaultMesh UStaticMesh
---@field SoftSourceActor TSoftObjectPtr<AActor>
---@field SourceComponent UStaticMeshComponent
---@field SectionFilter FNDIStaticMeshSectionFilter
---@field bCaptureTransformsPerFrame boolean
---@field bUsePhysicsBodyVelocity boolean
---@field bAllowSamplingFromStreamingLODs boolean
---@field LODIndex int32
---@field LODIndexUserParameter FNiagaraUserParameterBinding
---@field MeshParameterBinding FNiagaraUserParameterBinding
---@field InstanceIndex int32
---@field FilteredSockets TArray<FName>
local UNiagaraDataInterfaceStaticMesh = {}

---@param NiagaraSystem UNiagaraComponent
---@param UserParameterName FName
---@param NewInstanceIndex int32
function UNiagaraDataInterfaceStaticMesh:SetNiagaraStaticMeshDIInstanceIndex(NiagaraSystem, UserParameterName, NewInstanceIndex) end
---@param InSource AActor
---@param Reason EEndPlayReason::Type
function UNiagaraDataInterfaceStaticMesh:OnSourceEndPlay(InSource, Reason) end


---@class UNiagaraDataInterfaceTexture : UNiagaraDataInterface
---@field Texture UTexture
---@field TextureUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterfaceTexture = {}



---@class UNiagaraDataInterfaceUObjectPropertyReader : UNiagaraDataInterface
---@field SourceMode ENDIObjectPropertyReaderSourceMode
---@field UObjectParameterBinding FNiagaraUserParameterBinding
---@field PropertyRemap TArray<FNiagaraUObjectPropertyReaderRemap>
---@field SourceActor TSoftObjectPtr<AActor>
---@field SourceActorComponentClass UClass
local UNiagaraDataInterfaceUObjectPropertyReader = {}

---@param NiagaraComponent UNiagaraComponent
---@param UserParameterName FName
---@param GraphName FName
---@param RemapName FName
function UNiagaraDataInterfaceUObjectPropertyReader:SetUObjectReaderPropertyRemap(NiagaraComponent, UserParameterName, GraphName, RemapName) end


---@class UNiagaraDataInterfaceVector2DCurve : UNiagaraDataInterfaceCurveBase
---@field XCurve FRichCurve
---@field YCurve FRichCurve
local UNiagaraDataInterfaceVector2DCurve = {}



---@class UNiagaraDataInterfaceVector4Curve : UNiagaraDataInterfaceCurveBase
---@field XCurve FRichCurve
---@field YCurve FRichCurve
---@field ZCurve FRichCurve
---@field WCurve FRichCurve
local UNiagaraDataInterfaceVector4Curve = {}



---@class UNiagaraDataInterfaceVectorCurve : UNiagaraDataInterfaceCurveBase
---@field XCurve FRichCurve
---@field YCurve FRichCurve
---@field ZCurve FRichCurve
local UNiagaraDataInterfaceVectorCurve = {}



---@class UNiagaraDataInterfaceVectorField : UNiagaraDataInterface
---@field Field UVectorField
---@field bTileX boolean
---@field bTileY boolean
---@field bTileZ boolean
local UNiagaraDataInterfaceVectorField = {}



---@class UNiagaraDataInterfaceVirtualTexture : UNiagaraDataInterface
---@field Texture URuntimeVirtualTexture
---@field TextureUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterfaceVirtualTexture = {}



---@class UNiagaraDataInterfaceVolumeCache : UNiagaraDataInterface
---@field VolumeCache UVolumeCache
local UNiagaraDataInterfaceVolumeCache = {}



---@class UNiagaraDataInterfaceVolumeTexture : UNiagaraDataInterface
---@field Texture UTexture
---@field TextureUserParameter FNiagaraUserParameterBinding
local UNiagaraDataInterfaceVolumeTexture = {}



---@class UNiagaraDebugHUDSettings : UObject
---@field Data FNiagaraDebugHUDSettingsData
local UNiagaraDebugHUDSettings = {}



---@class UNiagaraDecalRendererProperties : UNiagaraRendererProperties
---@field Material UMaterialInterface
---@field MaterialParameterBinding FNiagaraParameterBinding
---@field SourceMode ENiagaraRendererSourceDataMode
---@field RendererVisibility int32
---@field DecalScreenSizeFade float
---@field PositionBinding FNiagaraVariableAttributeBinding
---@field DecalOrientationBinding FNiagaraVariableAttributeBinding
---@field DecalSizeBinding FNiagaraVariableAttributeBinding
---@field DecalFadeBinding FNiagaraVariableAttributeBinding
---@field DecalSortOrderBinding FNiagaraVariableAttributeBinding
---@field DecalColorBinding FNiagaraVariableAttributeBinding
---@field DecalVisibleBinding FNiagaraVariableAttributeBinding
---@field RendererVisibilityTagBinding FNiagaraVariableAttributeBinding
---@field MaterialParameters FNiagaraRendererMaterialParameters
local UNiagaraDecalRendererProperties = {}



---@class UNiagaraEditorDataBase : UObject
local UNiagaraEditorDataBase = {}


---@class UNiagaraEditorParametersAdapterBase : UObject
local UNiagaraEditorParametersAdapterBase = {}


---@class UNiagaraEffectType : UObject
---@field bAllowCullingForLocalPlayers boolean
---@field UpdateFrequency ENiagaraScalabilityUpdateFrequency
---@field CullReaction ENiagaraCullReaction
---@field SignificanceHandler UNiagaraSignificanceHandler
---@field DetailLevelScalabilitySettings TArray<FNiagaraSystemScalabilitySettings>
---@field SystemScalabilitySettings FNiagaraSystemScalabilitySettingsArray
---@field EmitterScalabilitySettings FNiagaraEmitterScalabilitySettingsArray
---@field PerformanceBaselineController UNiagaraBaselineController
---@field PerfBaselineStats FNiagaraPerfBaselineStats
---@field PerfBaselineVersion FGuid
local UNiagaraEffectType = {}



---@class UNiagaraEmitter : UObject
---@field ExposedVersion FGuid
---@field bVersioningEnabled boolean
---@field VersionData TArray<FVersionedNiagaraEmitterData>
---@field UniqueEmitterName FString
local UNiagaraEmitter = {}



---@class UNiagaraEventReceiverEmitterAction : UObject
local UNiagaraEventReceiverEmitterAction = {}


---@class UNiagaraEventReceiverEmitterAction_SpawnParticles : UNiagaraEventReceiverEmitterAction
---@field NumParticles uint32
local UNiagaraEventReceiverEmitterAction_SpawnParticles = {}



---@class UNiagaraFunctionLibrary : UBlueprintFunctionLibrary
local UNiagaraFunctionLibrary = {}

---@param SpawnParams FFXSystemSpawnParameters
---@return UNiagaraComponent
function UNiagaraFunctionLibrary:SpawnSystemAttachedWithParams(SpawnParams) end
---@param SystemTemplate UNiagaraSystem
---@param AttachToComponent USceneComponent
---@param AttachPointName FName
---@param Location FVector
---@param Rotation FRotator
---@param LocationType EAttachLocation::Type
---@param bAutoDestroy boolean
---@param bAutoActivate boolean
---@param PoolingMethod ENCPoolMethod
---@param bPreCullCheck boolean
---@return UNiagaraComponent
function UNiagaraFunctionLibrary:SpawnSystemAttached(SystemTemplate, AttachToComponent, AttachPointName, Location, Rotation, LocationType, bAutoDestroy, bAutoActivate, PoolingMethod, bPreCullCheck) end
---@param SpawnParams FFXSystemSpawnParameters
---@return UNiagaraComponent
function UNiagaraFunctionLibrary:SpawnSystemAtLocationWithParams(SpawnParams) end
---@param WorldContextObject UObject
---@param SystemTemplate UNiagaraSystem
---@param Location FVector
---@param Rotation FRotator
---@param Scale FVector
---@param bAutoDestroy boolean
---@param bAutoActivate boolean
---@param PoolingMethod ENCPoolMethod
---@param bPreCullCheck boolean
---@return UNiagaraComponent
function UNiagaraFunctionLibrary:SpawnSystemAtLocation(WorldContextObject, SystemTemplate, Location, Rotation, Scale, bAutoDestroy, bAutoActivate, PoolingMethod, bPreCullCheck) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FString
---@param Texture UVolumeTexture
function UNiagaraFunctionLibrary:SetVolumeTextureObject(NiagaraSystem, OverrideName, Texture) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FString
---@param Texture UTexture
function UNiagaraFunctionLibrary:SetTextureObject(NiagaraSystem, OverrideName, Texture) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FString
---@param Texture UTexture2DArray
function UNiagaraFunctionLibrary:SetTexture2DArrayObject(NiagaraSystem, OverrideName, Texture) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FString
---@param SamplingRegions TArray<FName>
function UNiagaraFunctionLibrary:SetSkeletalMeshDataInterfaceSamplingRegions(NiagaraSystem, OverrideName, SamplingRegions) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FString
---@param FilteredSockets TArray<FName>
function UNiagaraFunctionLibrary:SetSkeletalMeshDataInterfaceFilteredSockets(NiagaraSystem, OverrideName, FilteredSockets) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FString
---@param FilteredBones TArray<FName>
function UNiagaraFunctionLibrary:SetSkeletalMeshDataInterfaceFilteredBones(NiagaraSystem, OverrideName, FilteredBones) end
---@param NiagaraSystem UNiagaraComponent
---@param DIName FName
---@param ManagedCaptureSource ESceneCaptureSource
---@param ManagedTextureSize FIntPoint
---@param ManagedTextureFormat ETextureRenderTargetFormat
---@param ManagedProjectionType ECameraProjectionMode::Type
---@param ManagedFOVAngle float
---@param ManagedOrthoWidth float
---@param bManagedCaptureEveryFrame boolean
---@param bManagedCaptureOnMovement boolean
---@param ShowOnlyActors TArray<AActor>
function UNiagaraFunctionLibrary:SetSceneCapture2DDataInterfaceManagedMode(NiagaraSystem, DIName, ManagedCaptureSource, ManagedTextureSize, ManagedTextureFormat, ManagedProjectionType, ManagedFOVAngle, ManagedOrthoWidth, bManagedCaptureEveryFrame, bManagedCaptureOnMovement, ShowOnlyActors) end
---@param WorldContextObject UObject
---@param Primitive UPrimitiveComponent
---@param CollisionGroup int32
function UNiagaraFunctionLibrary:SetComponentNiagaraGPURayTracedCollisionGroup(WorldContextObject, Primitive, CollisionGroup) end
---@param WorldContextObject UObject
---@param Actor AActor
---@param CollisionGroup int32
function UNiagaraFunctionLibrary:SetActorNiagaraGPURayTracedCollisionGroup(WorldContextObject, Actor, CollisionGroup) end
---@param WorldContextObject UObject
---@param CollisionGroup int32
function UNiagaraFunctionLibrary:ReleaseNiagaraGPURayTracedCollisionGroup(WorldContextObject, CollisionGroup) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FString
---@param StaticMeshComponent UStaticMeshComponent
function UNiagaraFunctionLibrary:OverrideSystemUserVariableStaticMeshComponent(NiagaraSystem, OverrideName, StaticMeshComponent) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FString
---@param StaticMesh UStaticMesh
function UNiagaraFunctionLibrary:OverrideSystemUserVariableStaticMesh(NiagaraSystem, OverrideName, StaticMesh) end
---@param NiagaraSystem UNiagaraComponent
---@param OverrideName FString
---@param SkeletalMeshComponent USkeletalMeshComponent
function UNiagaraFunctionLibrary:OverrideSystemUserVariableSkeletalMeshComponent(NiagaraSystem, OverrideName, SkeletalMeshComponent) end
---@param WorldContextObject UObject
---@param Collection UNiagaraParameterCollection
---@return UNiagaraParameterCollectionInstance
function UNiagaraFunctionLibrary:GetNiagaraParameterCollection(WorldContextObject, Collection) end
---@param WorldContextObject UObject
---@return int32
function UNiagaraFunctionLibrary:AcquireNiagaraGPURayTracedCollisionGroup(WorldContextObject) end


---@class UNiagaraLightRendererProperties : UNiagaraRendererProperties
---@field SourceMode ENiagaraRendererSourceDataMode
---@field bUseInverseSquaredFalloff boolean
---@field bAffectsTranslucency boolean
---@field bAlphaScalesBrightness boolean
---@field bOverrideInverseExposureBlend boolean
---@field RadiusScale float
---@field DefaultExponent float
---@field SpecularScale float
---@field DiffuseScale float
---@field ColorAdd FVector3f
---@field InverseExposureBlend float
---@field RendererVisibility int32
---@field LightRenderingEnabledBinding FNiagaraVariableAttributeBinding
---@field LightExponentBinding FNiagaraVariableAttributeBinding
---@field PositionBinding FNiagaraVariableAttributeBinding
---@field ColorBinding FNiagaraVariableAttributeBinding
---@field RadiusBinding FNiagaraVariableAttributeBinding
---@field VolumetricScatteringBinding FNiagaraVariableAttributeBinding
---@field RendererVisibilityTagBinding FNiagaraVariableAttributeBinding
---@field SpecularScaleBinding FNiagaraVariableAttributeBinding
---@field DiffuseScaleBinding FNiagaraVariableAttributeBinding
local UNiagaraLightRendererProperties = {}



---@class UNiagaraMeshRendererProperties : UNiagaraRendererProperties
---@field Meshes TArray<FNiagaraMeshRendererMeshProperties>
---@field SourceMode ENiagaraRendererSourceDataMode
---@field SortMode ENiagaraSortMode
---@field SortPrecision ENiagaraRendererSortPrecision
---@field GpuTranslucentLatency ENiagaraRendererGpuTranslucentLatency
---@field bOverrideMaterials boolean
---@field bUseHeterogeneousVolumes boolean
---@field bSortOnlyWhenTranslucent boolean
---@field bSubImageBlend boolean
---@field bEnableFrustumCulling boolean
---@field bEnableCameraDistanceCulling boolean
---@field bEnableMeshFlipbook boolean
---@field bLockedAxisEnable boolean
---@field bCastShadows boolean
---@field OverrideMaterials TArray<FNiagaraMeshMaterialOverride>
---@field MICOverrideMaterials TArray<FNiagaraMeshMICOverride>
---@field SubImageSize FVector2D
---@field LockedAxis FVector
---@field MeshBoundsScale FVector
---@field FacingMode ENiagaraMeshFacingMode
---@field LockedAxisSpace ENiagaraMeshLockedAxisSpace
---@field MinCameraDistance float
---@field MaxCameraDistance float
---@field RendererVisibility uint32
---@field PositionBinding FNiagaraVariableAttributeBinding
---@field ColorBinding FNiagaraVariableAttributeBinding
---@field VelocityBinding FNiagaraVariableAttributeBinding
---@field MeshOrientationBinding FNiagaraVariableAttributeBinding
---@field ScaleBinding FNiagaraVariableAttributeBinding
---@field SubImageIndexBinding FNiagaraVariableAttributeBinding
---@field DynamicMaterialBinding FNiagaraVariableAttributeBinding
---@field DynamicMaterial1Binding FNiagaraVariableAttributeBinding
---@field DynamicMaterial2Binding FNiagaraVariableAttributeBinding
---@field DynamicMaterial3Binding FNiagaraVariableAttributeBinding
---@field MaterialRandomBinding FNiagaraVariableAttributeBinding
---@field CustomSortingBinding FNiagaraVariableAttributeBinding
---@field NormalizedAgeBinding FNiagaraVariableAttributeBinding
---@field CameraOffsetBinding FNiagaraVariableAttributeBinding
---@field RendererVisibilityTagBinding FNiagaraVariableAttributeBinding
---@field MeshIndexBinding FNiagaraVariableAttributeBinding
---@field MaterialParameters FNiagaraRendererMaterialParameters
---@field PrevPositionBinding FNiagaraVariableAttributeBinding
---@field PrevScaleBinding FNiagaraVariableAttributeBinding
---@field PrevMeshOrientationBinding FNiagaraVariableAttributeBinding
---@field PrevCameraOffsetBinding FNiagaraVariableAttributeBinding
---@field PrevVelocityBinding FNiagaraVariableAttributeBinding
---@field MaterialParamValidMask uint32
local UNiagaraMeshRendererProperties = {}



---@class UNiagaraMessageDataBase : UObject
local UNiagaraMessageDataBase = {}


---@class UNiagaraParameterCollection : UObject
---@field NameSpace FName
---@field Parameters TArray<FNiagaraVariable>
---@field SourceMaterialCollection UMaterialParameterCollection
---@field DefaultInstance UNiagaraParameterCollectionInstance
---@field CompileId FGuid
local UNiagaraParameterCollection = {}



---@class UNiagaraParameterCollectionInstance : UObject
---@field Collection UNiagaraParameterCollection
---@field OverridenParameters TArray<FNiagaraVariable>
---@field ParameterStorage FNiagaraParameterStore
---@field SourceMaterialCollectionInstance UMaterialParameterCollectionInstance
local UNiagaraParameterCollectionInstance = {}

---@param InVariableName FString
---@param InValue FVector
function UNiagaraParameterCollectionInstance:SetVectorParameter(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue FVector4
function UNiagaraParameterCollectionInstance:SetVector4Parameter(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue FVector2D
function UNiagaraParameterCollectionInstance:SetVector2DParameter(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue FQuat
function UNiagaraParameterCollectionInstance:SetQuatParameter(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue int32
function UNiagaraParameterCollectionInstance:SetIntParameter(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue float
function UNiagaraParameterCollectionInstance:SetFloatParameter(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue FLinearColor
function UNiagaraParameterCollectionInstance:SetColorParameter(InVariableName, InValue) end
---@param InVariableName FString
---@param InValue boolean
function UNiagaraParameterCollectionInstance:SetBoolParameter(InVariableName, InValue) end
---@param InVariableName FString
---@return FVector
function UNiagaraParameterCollectionInstance:GetVectorParameter(InVariableName) end
---@param InVariableName FString
---@return FVector4
function UNiagaraParameterCollectionInstance:GetVector4Parameter(InVariableName) end
---@param InVariableName FString
---@return FVector2D
function UNiagaraParameterCollectionInstance:GetVector2DParameter(InVariableName) end
---@param InVariableName FString
---@return FQuat
function UNiagaraParameterCollectionInstance:GetQuatParameter(InVariableName) end
---@param InVariableName FString
---@return int32
function UNiagaraParameterCollectionInstance:GetIntParameter(InVariableName) end
---@param InVariableName FString
---@return float
function UNiagaraParameterCollectionInstance:GetFloatParameter(InVariableName) end
---@param InVariableName FString
---@return FLinearColor
function UNiagaraParameterCollectionInstance:GetColorParameter(InVariableName) end
---@param InVariableName FString
---@return boolean
function UNiagaraParameterCollectionInstance:GetBoolParameter(InVariableName) end


---@class UNiagaraParameterDefinitionsBase : UObject
local UNiagaraParameterDefinitionsBase = {}


---@class UNiagaraPrecompileContainer : UObject
---@field Scripts TArray<UNiagaraScript>
---@field System UNiagaraSystem
local UNiagaraPrecompileContainer = {}



---@class UNiagaraPreviewAxis : UObject
local UNiagaraPreviewAxis = {}

---@return int32
function UNiagaraPreviewAxis:Num() end
---@param PreviewComponent UNiagaraComponent
---@param PreviewIndex int32
---@param bIsXAxis boolean
---@param OutLabelText FString
function UNiagaraPreviewAxis:ApplyToPreview(PreviewComponent, PreviewIndex, bIsXAxis, OutLabelText) end


---@class UNiagaraPreviewAxis_InterpParamBase : UNiagaraPreviewAxis
---@field Param FName
---@field Count int32
local UNiagaraPreviewAxis_InterpParamBase = {}



---@class UNiagaraPreviewAxis_InterpParamFloat : UNiagaraPreviewAxis_InterpParamBase
---@field Min float
---@field Max float
local UNiagaraPreviewAxis_InterpParamFloat = {}



---@class UNiagaraPreviewAxis_InterpParamInt32 : UNiagaraPreviewAxis_InterpParamBase
---@field Min int32
---@field Max int32
local UNiagaraPreviewAxis_InterpParamInt32 = {}



---@class UNiagaraPreviewAxis_InterpParamLinearColor : UNiagaraPreviewAxis_InterpParamBase
---@field Min FLinearColor
---@field Max FLinearColor
local UNiagaraPreviewAxis_InterpParamLinearColor = {}



---@class UNiagaraPreviewAxis_InterpParamVector : UNiagaraPreviewAxis_InterpParamBase
---@field Min FVector
---@field Max FVector
local UNiagaraPreviewAxis_InterpParamVector = {}



---@class UNiagaraPreviewAxis_InterpParamVector2D : UNiagaraPreviewAxis_InterpParamBase
---@field Min FVector2D
---@field Max FVector2D
local UNiagaraPreviewAxis_InterpParamVector2D = {}



---@class UNiagaraPreviewAxis_InterpParamVector4 : UNiagaraPreviewAxis_InterpParamBase
---@field Min FVector4
---@field Max FVector4
local UNiagaraPreviewAxis_InterpParamVector4 = {}



---@class UNiagaraRendererProperties : UNiagaraMergeable
---@field Platforms FNiagaraPlatformSet
---@field SortOrderHint int32
---@field MotionVectorSetting ENiagaraRendererMotionVectorSetting
---@field bIsEnabled boolean
---@field bAllowInCullProxies boolean
---@field RendererEnabledBinding FNiagaraVariableAttributeBinding
---@field OuterEmitterVersion FGuid
local UNiagaraRendererProperties = {}



---@class UNiagaraRibbonRendererProperties : UNiagaraRendererProperties
---@field Material UMaterialInterface
---@field MaterialUserParamBinding FNiagaraUserParameterBinding
---@field UV0Settings FNiagaraRibbonUVSettings
---@field UV1Settings FNiagaraRibbonUVSettings
---@field FacingMode ENiagaraRibbonFacingMode
---@field MaxNumRibbons int32
---@field DrawDirection ENiagaraRibbonDrawDirection
---@field Shape ENiagaraRibbonShapeMode
---@field bEnableAccurateGeometry boolean
---@field bUseMaterialBackfaceCulling boolean
---@field bUseGeometryNormals boolean
---@field bUseGPUInit boolean
---@field bUseConstantFactor boolean
---@field bScreenSpaceTessellation boolean
---@field bLinkOrderUseUniqueID boolean
---@field bCastShadows boolean
---@field WidthSegmentationCount int32
---@field MultiPlaneCount int32
---@field TubeSubdivisions int32
---@field CustomVertices TArray<FNiagaraRibbonShapeCustomVertex>
---@field TessellationMode ENiagaraRibbonTessellationMode
---@field CurveTension float
---@field TessellationFactor int32
---@field TessellationAngle float
---@field PositionBinding FNiagaraVariableAttributeBinding
---@field ColorBinding FNiagaraVariableAttributeBinding
---@field VelocityBinding FNiagaraVariableAttributeBinding
---@field NormalizedAgeBinding FNiagaraVariableAttributeBinding
---@field RibbonTwistBinding FNiagaraVariableAttributeBinding
---@field RibbonWidthBinding FNiagaraVariableAttributeBinding
---@field RibbonFacingBinding FNiagaraVariableAttributeBinding
---@field RibbonIdBinding FNiagaraVariableAttributeBinding
---@field RibbonLinkOrderBinding FNiagaraVariableAttributeBinding
---@field MaterialRandomBinding FNiagaraVariableAttributeBinding
---@field DynamicMaterialBinding FNiagaraVariableAttributeBinding
---@field DynamicMaterial1Binding FNiagaraVariableAttributeBinding
---@field DynamicMaterial2Binding FNiagaraVariableAttributeBinding
---@field DynamicMaterial3Binding FNiagaraVariableAttributeBinding
---@field RibbonUVDistance FNiagaraVariableAttributeBinding
---@field U0OverrideBinding FNiagaraVariableAttributeBinding
---@field V0RangeOverrideBinding FNiagaraVariableAttributeBinding
---@field U1OverrideBinding FNiagaraVariableAttributeBinding
---@field V1RangeOverrideBinding FNiagaraVariableAttributeBinding
---@field MaterialParameters FNiagaraRendererMaterialParameters
---@field PrevPositionBinding FNiagaraVariableAttributeBinding
---@field PrevRibbonWidthBinding FNiagaraVariableAttributeBinding
---@field PrevRibbonFacingBinding FNiagaraVariableAttributeBinding
---@field PrevRibbonTwistBinding FNiagaraVariableAttributeBinding
---@field MaterialParamValidMask uint32
local UNiagaraRibbonRendererProperties = {}



---@class UNiagaraScratchPadContainer : UObject
local UNiagaraScratchPadContainer = {}


---@class UNiagaraScript : UNiagaraScriptBase
---@field Usage ENiagaraScriptUsage
---@field UsageId FGuid
---@field RapidIterationParameters FNiagaraParameterStore
---@field ScriptExecutionParamStore FNiagaraScriptExecutionParameterStore
---@field ScriptExecutionBoundParameters TArray<FNiagaraBoundParameter>
---@field CachedScriptVMId FNiagaraVMExecutableDataId
---@field CachedScriptVM FNiagaraVMExecutableData
---@field CachedParameterCollectionReferences TArray<UNiagaraParameterCollection>
---@field ResolvedDataInterfaces TArray<FNiagaraScriptResolvedDataInterfaceInfo>
---@field ResolvedUserDataInterfaceBindings TArray<FNiagaraResolvedUserDataInterfaceBinding>
---@field ResolvedUObjectInfos TArray<FNiagaraResolvedUObjectInfo>
local UNiagaraScript = {}

function UNiagaraScript:RaiseOnGPUCompilationComplete() end


---@class UNiagaraScriptSourceBase : UObject
local UNiagaraScriptSourceBase = {}


---@class UNiagaraSettings : UDeveloperSettings
---@field bSystemsSupportLargeWorldCoordinates boolean
---@field bEnforceStrictStackTypes boolean
---@field bExperimentalVMEnabled boolean
---@field bAccurateQuatInterpolation boolean
---@field InvalidNamespaceWriteSeverity ENiagaraCompileErrorSeverity
---@field bLimitDeltaTime boolean
---@field MaxDeltaTimePerTick float
---@field DefaultEffectType FSoftObjectPath
---@field bAllowCreateActorFromSystemWithNoEffectType boolean
---@field PositionPinTypeColor FLinearColor
---@field ByteCodeStripOption ENiagaraStripScriptByteCodeOption
---@field QualityLevels TArray<FText>
---@field ComponentRendererWarningsPerClass TMap<FString, FText>
---@field DefaultRenderTargetFormat ETextureRenderTargetFormat
---@field DefaultGridFormat ENiagaraGpuBufferFormat
---@field DefaultRendererMotionVectorSetting ENiagaraDefaultRendererMotionVectorSetting
---@field DefaultPixelCoverageMode ENiagaraDefaultRendererPixelCoverageMode
---@field DefaultSortPrecision ENiagaraDefaultSortPrecision
---@field DefaultGpuTranslucentLatency ENiagaraDefaultGpuTranslucentLatency
---@field DefaultLightInverseExposureBlend float
---@field NDISkelMesh_SupportReadingDeformedGeometry boolean
---@field NDISkelMesh_Support16BitIndexWeight boolean
---@field NDISkelMesh_GpuMaxInfluences ENDISkelMesh_GpuMaxInfluences::Type
---@field NDISkelMesh_GpuUniformSamplingFormat ENDISkelMesh_GpuUniformSamplingFormat::Type
---@field NDISkelMesh_AdjacencyTriangleIndexFormat ENDISkelMesh_AdjacencyTriangleIndexFormat::Type
---@field NDIStaticMesh_AllowDistanceFields boolean
---@field NDICollisionQuery_AsyncGpuTraceProviderOrder TArray<ENDICollisionQuery_AsyncGpuTraceProvider::Type>
---@field SimCacheAuxiliaryFileBasePath FString
---@field SimCacheMaxCPUMemoryVolumetrics int64
---@field PlatformSetRedirects TArray<FNiagaraPlatformSetRedirect>
local UNiagaraSettings = {}



---@class UNiagaraSignificanceHandler : UObject
local UNiagaraSignificanceHandler = {}


---@class UNiagaraSignificanceHandlerAge : UNiagaraSignificanceHandler
local UNiagaraSignificanceHandlerAge = {}


---@class UNiagaraSignificanceHandlerDistance : UNiagaraSignificanceHandler
local UNiagaraSignificanceHandlerDistance = {}


---@class UNiagaraSimCache : UObject
---@field CacheGuid FGuid
---@field SoftNiagaraSystem TSoftObjectPtr<UNiagaraSystem>
---@field StartSeconds float
---@field DurationSeconds float
---@field CreateParameters FNiagaraSimCacheCreateParameters
---@field bNeedsReadComponentMappingRecache boolean
---@field CacheLayout FNiagaraSimCacheLayout
---@field CacheFrames TArray<FNiagaraSimCacheFrame>
---@field DataInterfaceStorage TMap<FNiagaraVariableBase, UObject>
---@field DebugData UNiagaraSimCacheDebugData
local UNiagaraSimCache = {}

---@param OutValues TArray<FVector>
---@param AttributeName FName
---@param EmitterName FName
---@param FrameIndex int32
function UNiagaraSimCache:ReadVectorAttribute(OutValues, AttributeName, EmitterName, FrameIndex) end
---@param OutValues TArray<FVector4>
---@param AttributeName FName
---@param EmitterName FName
---@param FrameIndex int32
function UNiagaraSimCache:ReadVector4Attribute(OutValues, AttributeName, EmitterName, FrameIndex) end
---@param OutValues TArray<FVector2D>
---@param AttributeName FName
---@param EmitterName FName
---@param FrameIndex int32
function UNiagaraSimCache:ReadVector2Attribute(OutValues, AttributeName, EmitterName, FrameIndex) end
---@param OutValues TArray<FQuat>
---@param Quat FQuat
---@param AttributeName FName
---@param EmitterName FName
---@param FrameIndex int32
function UNiagaraSimCache:ReadQuatAttributeWithRebase(OutValues, Quat, AttributeName, EmitterName, FrameIndex) end
---@param OutValues TArray<FQuat>
---@param AttributeName FName
---@param EmitterName FName
---@param bLocalSpaceToWorld boolean
---@param FrameIndex int32
function UNiagaraSimCache:ReadQuatAttribute(OutValues, AttributeName, EmitterName, bLocalSpaceToWorld, FrameIndex) end
---@param OutValues TArray<FVector>
---@param Transform FTransform
---@param AttributeName FName
---@param EmitterName FName
---@param FrameIndex int32
function UNiagaraSimCache:ReadPositionAttributeWithRebase(OutValues, Transform, AttributeName, EmitterName, FrameIndex) end
---@param OutValues TArray<FVector>
---@param AttributeName FName
---@param EmitterName FName
---@param bLocalSpaceToWorld boolean
---@param FrameIndex int32
function UNiagaraSimCache:ReadPositionAttribute(OutValues, AttributeName, EmitterName, bLocalSpaceToWorld, FrameIndex) end
---@param OutValues TArray<int32>
---@param AttributeName FName
---@param EmitterName FName
---@param FrameIndex int32
function UNiagaraSimCache:ReadIntAttribute(OutValues, AttributeName, EmitterName, FrameIndex) end
---@param OutValues TArray<FNiagaraID>
---@param AttributeName FName
---@param EmitterName FName
---@param FrameIndex int32
function UNiagaraSimCache:ReadIDAttribute(OutValues, AttributeName, EmitterName, FrameIndex) end
---@param OutValues TArray<float>
---@param AttributeName FName
---@param EmitterName FName
---@param FrameIndex int32
function UNiagaraSimCache:ReadFloatAttribute(OutValues, AttributeName, EmitterName, FrameIndex) end
---@param RequestedType UClass
---@param AttributeName FName
---@param FrameIndex int32
---@return UObject
function UNiagaraSimCache:ReadDataInterfaceAs(RequestedType, AttributeName, FrameIndex) end
---@param OutValues TArray<FLinearColor>
---@param AttributeName FName
---@param EmitterName FName
---@param FrameIndex int32
function UNiagaraSimCache:ReadColorAttribute(OutValues, AttributeName, EmitterName, FrameIndex) end
---@return boolean
function UNiagaraSimCache:IsEmpty() end
---@return boolean
function UNiagaraSimCache:IsCacheValid() end
---@return float
function UNiagaraSimCache:GetStartSeconds() end
---@return int32
function UNiagaraSimCache:GetNumFrames() end
---@return int32
function UNiagaraSimCache:GetNumEmitters() end
---@return TArray<FName>
function UNiagaraSimCache:GetEmitterNames() end
---@param EmitterIndex int32
---@return FName
function UNiagaraSimCache:GetEmitterName(EmitterIndex) end
---@return ENiagaraSimCacheAttributeCaptureMode
function UNiagaraSimCache:GetAttributeCaptureMode() end


---@class UNiagaraSimCacheDebugData : UObject
---@field Frames TArray<FNiagaraSimCacheDebugDataFrame>
local UNiagaraSimCacheDebugData = {}



---@class UNiagaraSimCacheFunctionLibrary : UBlueprintFunctionLibrary
local UNiagaraSimCacheFunctionLibrary = {}

---@param WorldContextObject UObject
---@return UNiagaraSimCache
function UNiagaraSimCacheFunctionLibrary:CreateNiagaraSimCache(WorldContextObject) end
---@param SimCache UNiagaraSimCache
---@param CreateParameters FNiagaraSimCacheCreateParameters
---@param NiagaraComponent UNiagaraComponent
---@param OutSimCache UNiagaraSimCache
---@param bAdvanceSimulation boolean
---@param AdvanceDeltaTime float
---@return boolean
function UNiagaraSimCacheFunctionLibrary:CaptureNiagaraSimCacheImmediate(SimCache, CreateParameters, NiagaraComponent, OutSimCache, bAdvanceSimulation, AdvanceDeltaTime) end


---@class UNiagaraSimulationStageBase : UNiagaraMergeable
---@field Script UNiagaraScript
---@field SimulationStageName FName
---@field bEnabled boolean
local UNiagaraSimulationStageBase = {}



---@class UNiagaraSimulationStageGeneric : UNiagaraSimulationStageBase
---@field EnabledBinding FNiagaraVariableAttributeBinding
---@field IterationSource ENiagaraIterationSource
---@field NumIterations FNiagaraParameterBindingWithValue
---@field ExecuteBehavior ENiagaraSimStageExecuteBehavior
---@field bDisablePartialParticleUpdate boolean
---@field DataInterface FNiagaraVariableDataInterfaceBinding
---@field bParticleIterationStateEnabled boolean
---@field ParticleIterationStateBinding FNiagaraVariableAttributeBinding
---@field ParticleIterationStateRange FIntPoint
---@field bGpuDispatchForceLinear boolean
---@field bOverrideGpuDispatchNumThreads boolean
---@field OverrideGpuDispatchNumThreadsX FNiagaraParameterBindingWithValue
---@field OverrideGpuDispatchNumThreadsY FNiagaraParameterBindingWithValue
---@field OverrideGpuDispatchNumThreadsZ FNiagaraParameterBindingWithValue
---@field DirectDispatchType ENiagaraGpuDispatchType
---@field DirectDispatchElementType ENiagaraDirectDispatchElementType
---@field ElementCountX FNiagaraParameterBindingWithValue
---@field ElementCountY FNiagaraParameterBindingWithValue
---@field ElementCountZ FNiagaraParameterBindingWithValue
local UNiagaraSimulationStageGeneric = {}



---@class UNiagaraSpriteRendererProperties : UNiagaraRendererProperties
---@field Material UMaterialInterface
---@field MaterialUserParamBinding FNiagaraUserParameterBinding
---@field SourceMode ENiagaraRendererSourceDataMode
---@field Alignment ENiagaraSpriteAlignment
---@field FacingMode ENiagaraSpriteFacingMode
---@field SortMode ENiagaraSortMode
---@field MacroUVRadius float
---@field PivotInUVSpace FVector2D
---@field SubImageSize FVector2D
---@field bSubImageBlend boolean
---@field bRemoveHMDRollInVR boolean
---@field bSortOnlyWhenTranslucent boolean
---@field bEnableCameraDistanceCulling boolean
---@field bCastShadows boolean
---@field SortPrecision ENiagaraRendererSortPrecision
---@field GpuTranslucentLatency ENiagaraRendererGpuTranslucentLatency
---@field PixelCoverageMode ENiagaraRendererPixelCoverageMode
---@field PixelCoverageBlend float
---@field MinFacingCameraBlendDistance float
---@field MaxFacingCameraBlendDistance float
---@field MinCameraDistance float
---@field MaxCameraDistance float
---@field RendererVisibility uint32
---@field PositionBinding FNiagaraVariableAttributeBinding
---@field ColorBinding FNiagaraVariableAttributeBinding
---@field VelocityBinding FNiagaraVariableAttributeBinding
---@field SpriteRotationBinding FNiagaraVariableAttributeBinding
---@field SpriteSizeBinding FNiagaraVariableAttributeBinding
---@field SpriteFacingBinding FNiagaraVariableAttributeBinding
---@field SpriteAlignmentBinding FNiagaraVariableAttributeBinding
---@field SubImageIndexBinding FNiagaraVariableAttributeBinding
---@field DynamicMaterialBinding FNiagaraVariableAttributeBinding
---@field DynamicMaterial1Binding FNiagaraVariableAttributeBinding
---@field DynamicMaterial2Binding FNiagaraVariableAttributeBinding
---@field DynamicMaterial3Binding FNiagaraVariableAttributeBinding
---@field CameraOffsetBinding FNiagaraVariableAttributeBinding
---@field UVScaleBinding FNiagaraVariableAttributeBinding
---@field PivotOffsetBinding FNiagaraVariableAttributeBinding
---@field MaterialRandomBinding FNiagaraVariableAttributeBinding
---@field CustomSortingBinding FNiagaraVariableAttributeBinding
---@field NormalizedAgeBinding FNiagaraVariableAttributeBinding
---@field RendererVisibilityTagBinding FNiagaraVariableAttributeBinding
---@field MaterialParameters FNiagaraRendererMaterialParameters
---@field PrevPositionBinding FNiagaraVariableAttributeBinding
---@field PrevVelocityBinding FNiagaraVariableAttributeBinding
---@field PrevSpriteRotationBinding FNiagaraVariableAttributeBinding
---@field PrevSpriteSizeBinding FNiagaraVariableAttributeBinding
---@field PrevSpriteFacingBinding FNiagaraVariableAttributeBinding
---@field PrevSpriteAlignmentBinding FNiagaraVariableAttributeBinding
---@field PrevCameraOffsetBinding FNiagaraVariableAttributeBinding
---@field PrevPivotOffsetBinding FNiagaraVariableAttributeBinding
---@field MaterialParamValidMask uint32
local UNiagaraSpriteRendererProperties = {}



---@class UNiagaraStatelessEmitter : UObject
---@field UniqueEmitterName FString
---@field EmitterTemplateClass UClass
---@field bDeterministic boolean
---@field AllowedFeatureMask uint32
---@field RandomSeed int32
---@field FixedBounds FBox
---@field EmitterState FNiagaraEmitterStateData
---@field SpawnInfos TArray<FNiagaraStatelessSpawnInfo>
---@field Modules TArray<UNiagaraStatelessModule>
---@field RendererProperties TArray<UNiagaraRendererProperties>
---@field Platforms FNiagaraPlatformSet
---@field ScalabilityOverrides FNiagaraEmitterScalabilityOverrides
---@field ParticleDataSetCompiledData FNiagaraDataSetCompiledData
---@field ComponentOffsets TArray<int32>
---@field CachedParameterCollectionReferences TArray<UNiagaraParameterCollection>
local UNiagaraStatelessEmitter = {}



---@class UNiagaraStatelessEmitterDefault : UNiagaraStatelessEmitterTemplate
local UNiagaraStatelessEmitterDefault = {}


---@class UNiagaraStatelessEmitterExample1 : UNiagaraStatelessEmitterTemplate
local UNiagaraStatelessEmitterExample1 = {}


---@class UNiagaraStatelessEmitterTemplate : UObject
local UNiagaraStatelessEmitterTemplate = {}


---@class UNiagaraStatelessModule : UNiagaraMergeable
---@field bModuleEnabled boolean
local UNiagaraStatelessModule = {}



---@class UNiagaraStatelessModule_AccelerationForce : UNiagaraStatelessModule
---@field AccelerationDistribution FNiagaraDistributionRangeVector3
---@field CoordinateSpace ENiagaraCoordinateSpace
local UNiagaraStatelessModule_AccelerationForce = {}



---@class UNiagaraStatelessModule_AddVelocity : UNiagaraStatelessModule
---@field VelocityType ENSM_VelocityType
---@field LinearVelocityDistribution FNiagaraDistributionRangeVector3
---@field LinearVelocityScale float
---@field ConeVelocityDistribution FNiagaraDistributionRangeFloat
---@field ConeRotation FRotator
---@field ConeAngle float
---@field InnerCone float
---@field PointVelocityDistribution FNiagaraDistributionRangeFloat
---@field PointOrigin FVector3f
---@field bSpeedFalloffFromConeAxisEnabled boolean
---@field SpeedFalloffFromConeAxis float
---@field CoordinateSpace ENiagaraCoordinateSpace
local UNiagaraStatelessModule_AddVelocity = {}



---@class UNiagaraStatelessModule_CalculateAccurateVelocity : UNiagaraStatelessModule
local UNiagaraStatelessModule_CalculateAccurateVelocity = {}


---@class UNiagaraStatelessModule_CameraOffset : UNiagaraStatelessModule
---@field CameraOffsetDistribution FNiagaraDistributionFloat
local UNiagaraStatelessModule_CameraOffset = {}



---@class UNiagaraStatelessModule_CurlNoiseForce : UNiagaraStatelessModule
---@field NoiseAmplitude float
---@field NoiseFrequency float
---@field NoiseMode ENSM_NoiseMode
---@field NoiseTexture UObject
local UNiagaraStatelessModule_CurlNoiseForce = {}



---@class UNiagaraStatelessModule_Drag : UNiagaraStatelessModule
---@field DragDistribution FNiagaraDistributionRangeFloat
local UNiagaraStatelessModule_Drag = {}



---@class UNiagaraStatelessModule_DynamicMaterialParameters : UNiagaraStatelessModule
---@field bParameter0Enabled boolean
---@field bParameter1Enabled boolean
---@field bParameter2Enabled boolean
---@field bParameter3Enabled boolean
---@field Parameter0 FNiagaraStatelessDynamicParameterSet
---@field Parameter1 FNiagaraStatelessDynamicParameterSet
---@field Parameter2 FNiagaraStatelessDynamicParameterSet
---@field Parameter3 FNiagaraStatelessDynamicParameterSet
local UNiagaraStatelessModule_DynamicMaterialParameters = {}



---@class UNiagaraStatelessModule_GravityForce : UNiagaraStatelessModule
---@field GravityDistribution FNiagaraDistributionRangeVector3
local UNiagaraStatelessModule_GravityForce = {}



---@class UNiagaraStatelessModule_InitialMeshOrientation : UNiagaraStatelessModule
---@field MeshOrientationMode ENSMInitialMeshOrientationMode
---@field OrientationVector FNiagaraDistributionRangeVector3
---@field MeshAxisToOrient FNiagaraDistributionRangeVector3
---@field Rotation FNiagaraDistributionRangeVector3
local UNiagaraStatelessModule_InitialMeshOrientation = {}



---@class UNiagaraStatelessModule_InitializeParticle : UNiagaraStatelessModule
---@field LifetimeDistribution FNiagaraDistributionRangeFloat
---@field ColorDistribution FNiagaraDistributionRangeColor
---@field MassDistribution FNiagaraDistributionRangeFloat
---@field SpriteSizeDistribution FNiagaraDistributionRangeVector2
---@field SpriteRotationDistribution FNiagaraDistributionRangeFloat
---@field MeshScaleDistribution FNiagaraDistributionRangeVector3
---@field bWriteRibbonWidth boolean
---@field RibbonWidthDistribution FNiagaraDistributionRangeFloat
---@field InitialPositionDistribution FNiagaraDistributionPosition
local UNiagaraStatelessModule_InitializeParticle = {}



---@class UNiagaraStatelessModule_MeshIndex : UNiagaraStatelessModule
---@field MeshIndex FNiagaraDistributionRangeInt
---@field MeshIndexWeight TArray<float>
local UNiagaraStatelessModule_MeshIndex = {}

---@return boolean
function UNiagaraStatelessModule_MeshIndex:NeedsMeshIndexWeights() end


---@class UNiagaraStatelessModule_MeshRotationRate : UNiagaraStatelessModule
---@field RotationRateDistribution FNiagaraDistributionRangeVector3
local UNiagaraStatelessModule_MeshRotationRate = {}



---@class UNiagaraStatelessModule_RotateAroundPoint : UNiagaraStatelessModule
---@field RateMin float
---@field RateMax float
---@field RadiusMin float
---@field RadiusMax float
---@field InitialPhaseMin float
---@field InitialPhaseMax float
local UNiagaraStatelessModule_RotateAroundPoint = {}



---@class UNiagaraStatelessModule_ScaleColor : UNiagaraStatelessModule
---@field ScaleDistribution FNiagaraDistributionColor
local UNiagaraStatelessModule_ScaleColor = {}



---@class UNiagaraStatelessModule_ScaleMeshSize : UNiagaraStatelessModule
---@field ScaleDistribution FNiagaraDistributionVector3
---@field ScaleCurveRange FNiagaraParameterBindingWithValue
local UNiagaraStatelessModule_ScaleMeshSize = {}

---@return boolean
function UNiagaraStatelessModule_ScaleMeshSize:UseScaleCurveRange() end


---@class UNiagaraStatelessModule_ScaleMeshSizeBySpeed : UNiagaraStatelessModule
---@field VelocityThreshold FNiagaraDistributionRangeFloat
---@field MinScaleFactor FNiagaraDistributionRangeVector3
---@field MaxScaleFactor FNiagaraDistributionRangeVector3
---@field bSampleScaleFactorByCurve boolean
---@field SampleFactorCurve FNiagaraDistributionFloat
local UNiagaraStatelessModule_ScaleMeshSizeBySpeed = {}



---@class UNiagaraStatelessModule_ScaleSpriteSize : UNiagaraStatelessModule
---@field ScaleDistribution FNiagaraDistributionVector2
---@field ScaleCurveRange FNiagaraParameterBindingWithValue
local UNiagaraStatelessModule_ScaleSpriteSize = {}

---@return boolean
function UNiagaraStatelessModule_ScaleSpriteSize:UseScaleCurveRange() end


---@class UNiagaraStatelessModule_ScaleSpriteSizeBySpeed : UNiagaraStatelessModule
---@field VelocityThreshold FNiagaraDistributionRangeFloat
---@field MinScaleFactor FNiagaraDistributionRangeVector2
---@field MaxScaleFactor FNiagaraDistributionRangeVector2
---@field bSampleScaleFactorByCurve boolean
---@field SampleFactorCurve FNiagaraDistributionFloat
local UNiagaraStatelessModule_ScaleSpriteSizeBySpeed = {}



---@class UNiagaraStatelessModule_ShapeLocation : UNiagaraStatelessModule
---@field ShapePrimitive ENSM_ShapePrimitive
---@field BoxSize FVector3f
---@field bBoxSurfaceOnly boolean
---@field BoxSurfaceThicknessMin float
---@field BoxSurfaceThicknessMax float
---@field PlaneSize FVector2f
---@field CylinderHeight float
---@field CylinderRadius float
---@field CylinderHeightMidpoint float
---@field RingRadius float
---@field DiscCoverage float
---@field RingUDistribution float
---@field SphereMin float
---@field SphereMax float
local UNiagaraStatelessModule_ShapeLocation = {}



---@class UNiagaraStatelessModule_SolveVelocitiesAndForces : UNiagaraStatelessModule
local UNiagaraStatelessModule_SolveVelocitiesAndForces = {}


---@class UNiagaraStatelessModule_SpriteFacingAndAlignment : UNiagaraStatelessModule
---@field bSpriteFacingEnabled boolean
---@field bSpriteAlignmentEnabled boolean
---@field SpriteFacing FVector3f
---@field SpriteAlignment FVector3f
local UNiagaraStatelessModule_SpriteFacingAndAlignment = {}



---@class UNiagaraStatelessModule_SpriteRotationRate : UNiagaraStatelessModule
---@field RotationRateDistribution FNiagaraDistributionRangeFloat
local UNiagaraStatelessModule_SpriteRotationRate = {}



---@class UNiagaraStatelessModule_SubUVAnimation : UNiagaraStatelessModule
---@field NumFrames int32
---@field bStartFrameRangeOverride_Enabled boolean
---@field bEndFrameRangeOverride_Enabled boolean
---@field StartFrameRangeOverride int32
---@field EndFrameRangeOverride int32
---@field AnimationMode ENSMSubUVAnimation_Mode
---@field LoopsPerSecond float
---@field RandomChangeInterval float
local UNiagaraStatelessModule_SubUVAnimation = {}



---@class UNiagaraSystem : UFXSystemAsset
---@field bSupportLargeWorldCoordinates boolean
---@field bOverrideCastShadow boolean
---@field bOverrideReceivesDecals boolean
---@field bOverrideRenderCustomDepth boolean
---@field bOverrideCustomDepthStencilValue boolean
---@field bOverrideCustomDepthStencilWriteMask boolean
---@field bOverrideTranslucencySortPriority boolean
---@field bOverrideTranslucencySortDistanceOffset boolean
---@field bCastShadow boolean
---@field bReceivesDecals boolean
---@field bRenderCustomDepth boolean
---@field bDisableExperimentalVM boolean
---@field bInitialOwnerVelocityFromActor boolean
---@field CustomDepthStencilWriteMask ERendererStencilMask
---@field CustomDepthStencilValue int32
---@field TranslucencySortPriority int32
---@field TranslucencySortDistanceOffset float
---@field bDumpDebugSystemInfo boolean
---@field bDumpDebugEmitterInfo boolean
---@field bRequireCurrentFrameData boolean
---@field bOverrideScalabilitySettings boolean
---@field bFixedBounds boolean
---@field EffectType UNiagaraEffectType
---@field bOverrideAllowCullingForLocalPlayers boolean
---@field bAllowCullingForLocalPlayersOverride boolean
---@field SystemScalabilityOverrides FNiagaraSystemScalabilityOverrides
---@field Platforms FNiagaraPlatformSet
---@field EmitterHandles TArray<FNiagaraEmitterHandle>
---@field ParameterCollectionOverrides TArray<UNiagaraParameterCollectionInstance>
---@field SystemSpawnScript UNiagaraScript
---@field SystemUpdateScript UNiagaraScript
---@field SystemCompiledData FNiagaraSystemCompiledData
---@field ExposedParameters FNiagaraUserRedirectionParameterStore
---@field FixedBounds FBox
---@field bNeedsGPUContextInitForDataInterfaces boolean
---@field bDeterminism boolean
---@field bFixedTickDelta boolean
---@field RandomSeed int32
---@field WarmupTime float
---@field WarmupTickCount int32
---@field WarmupTickDelta float
---@field FixedTickDeltaTime float
---@field bAllowSystemStateFastPath boolean
---@field bSystemStateFastPathEnabled boolean
---@field SystemStateData FNiagaraSystemStateData
local UNiagaraSystem = {}



---@class UNiagaraValidationRule : UObject
local UNiagaraValidationRule = {}


---@class UNiagaraValidationRuleSet : UObject
---@field ValidationRules TArray<UNiagaraValidationRule>
local UNiagaraValidationRuleSet = {}



---@class UNiagaraVolumeRendererProperties : UNiagaraRendererProperties
---@field Material UMaterialInterface
---@field MaterialParameterBinding FNiagaraParameterBinding
---@field RendererVisibility int32
---@field StepFactor float
---@field LightingDownsampleFactor float
---@field ShadowStepFactor float
---@field ShadowBiasFactor float
---@field RendererVisibilityTagBinding FNiagaraVariableAttributeBinding
---@field VolumeResolutionMaxAxisBinding FNiagaraVariableAttributeBinding
---@field VolumeWorldSpaceSizeBinding FNiagaraVariableAttributeBinding
---@field MaterialParameters FNiagaraRendererMaterialParameters
local UNiagaraVolumeRendererProperties = {}



---@class UVolumeCache : UObject
---@field FilePath FString
---@field CacheType EVolumeCacheType
---@field Resolution FIntVector
---@field FrameRangeStart int32
---@field FrameRangeEnd int32
local UVolumeCache = {}



