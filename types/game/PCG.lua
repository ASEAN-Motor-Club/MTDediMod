---@meta

---@class APCGPartitionActor : APartitionActor
---@field PCGGuid FGuid
---@field LocalToOriginal TMap<UPCGComponent, TSoftObjectPtr<UPCGComponent>>
---@field LoadedPreviewComponents TMap<UPCGComponent, TSoftObjectPtr<UPCGComponent>>
---@field PCGGridSize uint32
---@field bUse2DGrid boolean
---@field RuntimeGridDescriptorHash uint32
local APCGPartitionActor = {}

---@param LocalComponent UPCGComponent
---@return UPCGComponent
function APCGPartitionActor:GetOriginalComponent(LocalComponent) end
---@param OriginalComponent UPCGComponent
---@return UPCGComponent
function APCGPartitionActor:GetLocalComponent(OriginalComponent) end


---@class APCGUnitTestDummyActor : AActor
---@field IntProperty int32
---@field FloatProperty float
---@field Int64Property int64
---@field DoubleProperty double
---@field BoolProperty boolean
---@field NameProperty FName
---@field StringProperty FString
---@field EnumProperty EPCGUnitTestDummyEnum
---@field VectorProperty FVector
---@field Vector4Property FVector4
---@field TransformProperty FTransform
---@field RotatorProperty FRotator
---@field QuatProperty FQuat
---@field SoftObjectPathProperty FSoftObjectPath
---@field SoftClassPathProperty FSoftClassPath
---@field ClassProperty TSubclassOf<AActor>
---@field ObjectProperty UPCGDummyGetPropertyTest
---@field Vector2Property FVector2D
---@field ColorProperty FColor
---@field LinearColorProperty FLinearColor
---@field PCGColorProperty FPCGTestMyColorStruct
---@field ArrayOfIntsProperty TArray<int32>
---@field ArrayOfVectorsProperty TArray<FVector>
---@field ArrayOfStructsProperty TArray<FPCGTestMyColorStruct>
---@field ArrayOfObjectsProperty TArray<UPCGDummyGetPropertyTest>
---@field DummyStruct FPCGDummyGetPropertyStruct
---@field SetOfIntsProperty TArray<int32>
local APCGUnitTestDummyActor = {}



---@class APCGVolume : AVolume
---@field PCGComponent UPCGComponent
local APCGVolume = {}



---@class APCGWorldActor : AActor
---@field PartitionGridSize uint32
---@field LandscapeCacheObject UPCGLandscapeCache
local APCGWorldActor = {}



---@class FDeterminismTestResult
---@field Index int64
---@field TestResultTitle FName
---@field TestResultName FString
---@field Seed int32
---@field DataTypesTested EPCGDataType
---@field TestResults TMap<FName, EDeterminismLevel>
---@field AdditionalDetails TArray<FString>
---@field bFlagRaised boolean
local FDeterminismTestResult = {}



---@class FEnumSelector
---@field Class UEnum
---@field Value int64
local FEnumSelector = {}



---@class FPCGActorPropertyOverride
---@field InputSource FPCGAttributePropertyInputSelector
---@field PropertyTarget FString
local FPCGActorPropertyOverride = {}



---@class FPCGActorSelectorSettings
---@field ActorFilter EPCGActorFilter
---@field bMustOverlapSelf boolean
---@field bIncludeChildren boolean
---@field bDisableFilter boolean
---@field ActorSelection EPCGActorSelection
---@field ActorSelectionTag FName
---@field ActorSelectionClass TSubclassOf<AActor>
---@field ActorReferenceSelector FPCGAttributePropertyInputSelector
---@field bSelectMultiple boolean
---@field bIgnoreSelfAndChildren boolean
---@field bShowActorFilter boolean
---@field bShowIncludeChildren boolean
---@field bShowActorSelection boolean
---@field bShowActorSelectionClass boolean
---@field bShowSelectMultiple boolean
---@field bShowIgnoreSelfAndChildren boolean
local FPCGActorSelectorSettings = {}



---@class FPCGAssetExporterParameters
---@field bOpenSaveDialog boolean
---@field AssetName FString
---@field AssetPath FString
---@field bSaveOnExportEnded boolean
local FPCGAssetExporterParameters = {}



---@class FPCGAttributeExtractorTestStruct
---@field DepthStruct FPCGAttributeExtractorTestStructDepth1
---@field Object UPCGAttributeExtractorTestObject
local FPCGAttributeExtractorTestStruct = {}



---@class FPCGAttributeExtractorTestStructDepth1
---@field Depth2Struct FPCGAttributeExtractorTestStructDepth2
---@field FloatValue float
local FPCGAttributeExtractorTestStructDepth1 = {}



---@class FPCGAttributeExtractorTestStructDepth2
---@field IntValue int32
local FPCGAttributeExtractorTestStructDepth2 = {}



---@class FPCGAttributeFilterThresholdSettings
---@field bInclusive boolean
---@field bUseConstantThreshold boolean
---@field ThresholdAttribute FPCGAttributePropertyInputSelector
---@field bUseSpatialQuery boolean
---@field AttributeTypes FPCGMetadataTypesConstantStruct
local FPCGAttributeFilterThresholdSettings = {}



---@class FPCGAttributePropertyInputSelector : FPCGAttributePropertySelector
local FPCGAttributePropertyInputSelector = {}


---@class FPCGAttributePropertyOutputNoSourceSelector : FPCGAttributePropertySelector
local FPCGAttributePropertyOutputNoSourceSelector = {}


---@class FPCGAttributePropertyOutputSelector : FPCGAttributePropertySelector
local FPCGAttributePropertyOutputSelector = {}


---@class FPCGAttributePropertySelector
---@field Selection EPCGAttributePropertySelection
---@field AttributeName FName
---@field PointProperty EPCGPointProperties
---@field ExtraProperty EPCGExtraProperties
---@field ExtraNames TArray<FString>
local FPCGAttributePropertySelector = {}



---@class FPCGComponentInstanceData : FActorComponentInstanceData
---@field SourceComponent UPCGComponent
local FPCGComponentInstanceData = {}



---@class FPCGComponentSelectorSettings
---@field ComponentSelection EPCGComponentSelection
---@field ComponentSelectionTag FName
---@field ComponentSelectionClass TSubclassOf<UActorComponent>
---@field bShowComponentSelection boolean
---@field bShowComponentSelectionClass boolean
local FPCGComponentSelectorSettings = {}



---@class FPCGComputeGraphs
---@field ComputeGraphs TArray<UPCGComputeGraph>
local FPCGComputeGraphs = {}



---@class FPCGContext
local FPCGContext = {}


---@class FPCGCrc
---@field Value uint32
---@field bValid boolean
local FPCGCrc = {}



---@class FPCGDataCollection
---@field TaggedData TArray<FPCGTaggedData>
---@field bCancelExecutionOnEmpty boolean
local FPCGDataCollection = {}



---@class FPCGDataForGPU
---@field InputPins TSet<TSoftObjectPtr<UPCGPin>>
---@field InputPinLabelAliases TMap<TSoftObjectPtr<UPCGPin>, FName>
---@field InputDataCollection FPCGDataCollection
local FPCGDataForGPU = {}



---@class FPCGDataTableRowToParamDataTestStruct
---@field Name FName
---@field String FString
---@field I32 int32
---@field I64 int64
---@field F32 float
---@field F64 double
---@field v2 FVector2D
---@field V3 FVector
---@field V4 FVector4
---@field SoftPath FSoftObjectPath
local FPCGDataTableRowToParamDataTestStruct = {}



---@class FPCGDebugVisualizationSettings
---@field PointScale float
---@field ScaleMethod EPCGDebugVisScaleMethod
---@field PointMesh TSoftObjectPtr<UStaticMesh>
---@field MaterialOverride TSoftObjectPtr<UMaterialInterface>
local FPCGDebugVisualizationSettings = {}



---@class FPCGDeterminismSettings
---@field bNativeTests boolean
---@field bUseBlueprintDeterminismTest boolean
---@field DeterminismTestBlueprint TSubclassOf<UPCGDeterminismTestBlueprintBase>
local FPCGDeterminismSettings = {}



---@class FPCGDummyGetPropertyLevel2Struct
---@field DoubleArrayProperty TArray<double>
local FPCGDummyGetPropertyLevel2Struct = {}



---@class FPCGDummyGetPropertyStruct
---@field IntArrayProperty TArray<int32>
---@field FloatProperty float
---@field Level2Struct FPCGDummyGetPropertyLevel2Struct
local FPCGDummyGetPropertyStruct = {}



---@class FPCGGrammarSelection
---@field bGrammarAsAttribute boolean
---@field GrammarString FString
---@field GrammarAttribute FPCGAttributePropertyInputSelector
local FPCGGrammarSelection = {}



---@class FPCGGraphTask
---@field Inputs TArray<FPCGGraphTaskInput>
---@field ElementSource EPCGElementSource
---@field NodePtr TSoftObjectPtr<UPCGNode>
---@field CookedSettings UPCGSettings
---@field NodeID uint64
---@field CompiledTaskId uint64
---@field ParentID uint64
---@field PinDependency FPCGPinDependencyExpression
---@field StackIndex int32
local FPCGGraphTask = {}



---@class FPCGGraphTaskInput
---@field TaskId uint64
---@field UpstreamPin TOptional<FPCGPinProperties>
---@field DownstreamPin TOptional<FPCGPinProperties>
---@field bProvideData boolean
---@field bIsUsedMultipleTimes boolean
local FPCGGraphTaskInput = {}



---@class FPCGGraphTasks
---@field GraphTasks TArray<FPCGGraphTask>
local FPCGGraphTasks = {}



---@class FPCGGridCellDescriptor
---@field Descriptor FPCGGridDescriptor
---@field GridCoords FIntVector
local FPCGGridCellDescriptor = {}



---@class FPCGGridDescriptor
---@field GridSize uint32
---@field bIs2DGrid boolean
---@field bIsRuntime boolean
---@field RuntimeHash uint32
local FPCGGridDescriptor = {}



---@class FPCGKernelAttributeIDAndType
---@field ID int32
---@field Type EPCGKernelAttributeType
local FPCGKernelAttributeIDAndType = {}



---@class FPCGKernelAttributeKey
---@field Name FName
---@field Type EPCGKernelAttributeType
local FPCGKernelAttributeKey = {}



---@class FPCGLandscapeDataProps
---@field bGetHeightOnly boolean
---@field bGetLayerWeights boolean
---@field bGetActorReference boolean
---@field bGetPhysicalMaterial boolean
---@field bGetComponentCoordinates boolean
local FPCGLandscapeDataProps = {}



---@class FPCGLandscapeLayerWeight
---@field Name FName
---@field Weight float
local FPCGLandscapeLayerWeight = {}



---@class FPCGMatchAndSetByAttributeEntry
---@field ValueToMatch FPCGMetadataTypesConstantStruct
---@field Value FPCGMetadataTypesConstantStruct
local FPCGMatchAndSetByAttributeEntry = {}



---@class FPCGMatchAndSetWeightedByCategoryEntryList
---@field CategoryValue FPCGMetadataTypesConstantStruct
---@field bIsDefault boolean
---@field WeightedEntries TArray<FPCGMatchAndSetWeightedEntry>
local FPCGMatchAndSetWeightedByCategoryEntryList = {}



---@class FPCGMatchAndSetWeightedEntry
---@field Value FPCGMetadataTypesConstantStruct
---@field Weight int32
local FPCGMatchAndSetWeightedEntry = {}



---@class FPCGMeshInstanceList
---@field Descriptor FPCGSoftISMComponentDescriptor
---@field Instances TArray<FTransform>
---@field PointData TWeakObjectPtr<UPCGPointData>
---@field InstancesIndices TArray<int32>
local FPCGMeshInstanceList = {}



---@class FPCGMeshSelectorWeightedEntry
---@field Descriptor FPCGSoftISMComponentDescriptor
---@field Weight int32
local FPCGMeshSelectorWeightedEntry = {}



---@class FPCGMetadataTypesConstantStruct
---@field Type EPCGMetadataTypes
---@field StringMode EPCGMetadataTypesConstantStructStringMode
---@field FloatValue float
---@field Int32Value int32
---@field DoubleValue double
---@field IntValue int64
---@field Vector2Value FVector2D
---@field VectorValue FVector
---@field Vector4Value FVector4
---@field QuatValue FQuat
---@field TransformValue FTransform
---@field StringValue FString
---@field BoolValue boolean
---@field RotatorValue FRotator
---@field NameValue FName
---@field SoftClassPathValue FSoftClassPath
---@field SoftObjectPathValue FSoftObjectPath
---@field bAllowsTypeChange boolean
local FPCGMetadataTypesConstantStruct = {}



---@class FPCGObjectPropertyOverrideDescription
---@field InputSource FPCGAttributePropertyInputSelector
---@field PropertyTarget FString
local FPCGObjectPropertyOverrideDescription = {}



---@class FPCGOverrideInstancedPropertyBag
---@field Parameters FInstancedPropertyBag
---@field PropertiesIDsOverridden TSet<FGuid>
local FPCGOverrideInstancedPropertyBag = {}



---@class FPCGPackedCustomData
---@field NumCustomDataFloats int32
---@field CustomData TArray<float>
local FPCGPackedCustomData = {}



---@class FPCGPartitionActorRecord
---@field GridGuid FGuid
---@field GridSize uint32
---@field GridCoords FIntVector
local FPCGPartitionActorRecord = {}



---@class FPCGPinDependencyExpression
---@field Expression TArray<uint64>
local FPCGPinDependencyExpression = {}



---@class FPCGPinProperties
---@field Label FName
---@field Usage EPCGPinUsage
---@field AllowedTypes EPCGDataType
---@field bAllowMultipleData boolean
---@field PinStatus EPCGPinStatus
---@field bInvisiblePin boolean
---@field bAllowMultipleConnections boolean
local FPCGPinProperties = {}



---@class FPCGPinPropertiesGPU : FPCGPinProperties
---@field PropertiesGPU FPCGPinPropertiesGPUStruct
local FPCGPinPropertiesGPU = {}



---@class FPCGPinPropertiesGPUStruct
---@field InitializationMode EPCGPinInitMode
---@field PinsToInititalizeFrom TArray<FName>
---@field DataCountMode EPCGDataCountMode
---@field DataMultiplicity EPCGDataMultiplicity
---@field DataCount int32
---@field ElementCountMode EPCGElementCountMode
---@field ElementMultiplicity EPCGElementMultiplicity
---@field ElementCount int32
---@field AttributeInheritanceMode EPCGAttributeInheritanceMode
---@field CreatedKernelAttributeKeys TArray<FPCGKernelAttributeKey>
local FPCGPinPropertiesGPUStruct = {}



---@class FPCGPoint
---@field Transform FTransform
---@field Density float
---@field BoundsMin FVector
---@field BoundsMax FVector
---@field Color FVector4
---@field Steepness float
---@field Seed int32
---@field MetadataEntry int64
local FPCGPoint = {}



---@class FPCGPreConfiguredSettingsInfo
---@field PreconfiguredIndex int32
---@field Label FText
local FPCGPreConfiguredSettingsInfo = {}



---@class FPCGProceduralISMComponentDescriptor
---@field Hash uint32
---@field StaticMesh UStaticMesh
---@field OverrideMaterials TArray<UMaterialInterface>
---@field OverlayMaterial UMaterialInterface
---@field RuntimeVirtualTextures TArray<URuntimeVirtualTexture>
---@field NumInstances int32
---@field NumCustomFloats int32
---@field LocalBounds FBox
---@field InstanceStartCullDistance int32
---@field InstanceEndCullDistance int32
---@field ComponentTags TArray<FName>
---@field Mobility EComponentMobility::Type
---@field VirtualTextureRenderPassType ERuntimeVirtualTextureMainPassType
---@field LightingChannels FLightingChannels
---@field CustomDepthStencilWriteMask ERendererStencilMask
---@field VirtualTextureCullMips int32
---@field TranslucencySortPriority int32
---@field CustomDepthStencilValue int32
---@field bCastShadow boolean
---@field bEmissiveLightSource boolean
---@field bCastDynamicShadow boolean
---@field bCastStaticShadow boolean
---@field bCastContactShadow boolean
---@field bCastShadowAsTwoSided boolean
---@field bCastHiddenShadow boolean
---@field bReceivesDecals boolean
---@field bUseAsOccluder boolean
---@field bRenderCustomDepth boolean
---@field bEvaluateWorldPositionOffset boolean
---@field bReverseCulling boolean
---@field WorldPositionOffsetDisableDistance int32
---@field ShadowCacheInvalidationBehavior EShadowCacheInvalidationBehavior
---@field DetailMode EDetailMode
local FPCGProceduralISMComponentDescriptor = {}



---@class FPCGProjectionParams
---@field bProjectPositions boolean
---@field bProjectRotations boolean
---@field bProjectScales boolean
---@field ColorBlendMode EPCGProjectionColorBlendMode
---@field AttributeList FString
---@field AttributeMode EPCGMetadataFilterMode
---@field AttributeMergeOperation EPCGMetadataOp
---@field TagMergeOperation EPCGProjectionTagMergeMode
local FPCGProjectionParams = {}



---@class FPCGPropertyAliases
---@field Aliases TArray<FName>
local FPCGPropertyAliases = {}



---@class FPCGRuntimeGenerationRadii
---@field GenerationRadius double
---@field GenerationRadius400 double
---@field GenerationRadius800 double
---@field GenerationRadius1600 double
---@field GenerationRadius3200 double
---@field GenerationRadius6400 double
---@field GenerationRadius12800 double
---@field GenerationRadius25600 double
---@field GenerationRadius51200 double
---@field GenerationRadius102400 double
---@field GenerationRadius204800 double
---@field CleanupRadiusMultiplier double
local FPCGRuntimeGenerationRadii = {}



---@class FPCGSelectGrammarCriteriaAttributeNames
---@field KeyAttributeName FName
---@field ComparatorAttributeName FName
---@field FirstValueAttributeName FName
---@field SecondValueAttributeName FName
---@field GrammarAttributeName FName
local FPCGSelectGrammarCriteriaAttributeNames = {}



---@class FPCGSelectGrammarCriterion
---@field Key FName
---@field Comparator EPCGSelectGrammarComparator
---@field FirstValue double
---@field SecondValue double
---@field Grammar FString
local FPCGSelectGrammarCriterion = {}



---@class FPCGSelectionKey
---@field ActorFilter EPCGActorFilter
---@field Selection EPCGActorSelection
---@field Tag FName
---@field SelectionClass UClass
---@field ObjectPath FSoftObjectPath
---@field OptionalExtraDependency UClass
local FPCGSelectionKey = {}



---@class FPCGSelfPruningParameters
---@field PruningType EPCGSelfPruningType
---@field ComparisonSource FPCGAttributePropertyInputSelector
---@field RadiusSimilarityFactor float
---@field bRandomizedPruning boolean
---@field bUseCollisionAttribute boolean
---@field CollisionAttribute FPCGAttributePropertyInputSelector
---@field CollisionQueryFlag EPCGCollisionQueryFlag
local FPCGSelfPruningParameters = {}



---@class FPCGSettingsOverridableParam
---@field Label FName
---@field PropertiesNames TArray<FName>
---@field PropertyClass UStruct
---@field MapOfAliases TMap<int32, FPCGPropertyAliases>
---@field bHasNameClash boolean
local FPCGSettingsOverridableParam = {}



---@class FPCGSoftISMComponentDescriptor : FSoftISMComponentDescriptor
---@field ComponentTags TArray<FName>
local FPCGSoftISMComponentDescriptor = {}



---@class FPCGSpawnerPrimitives
---@field Primitives TArray<UPrimitiveComponent>
---@field PrimitiveMeshBounds TArray<FBox>
---@field SelectionCDF TArray<float>
---@field NumCustomFloats uint32
---@field AttributeIdOffsetStrides TArray<FUintVector4>
---@field SelectorAttributeId int32
---@field PrimitiveStringKeys TArray<int32>
---@field NumInstancesAllPrimitives uint32
local FPCGSpawnerPrimitives = {}



---@class FPCGSplineMeshParams
---@field ForwardAxis EPCGSplineMeshForwardAxis
---@field bScaleMeshToBounds boolean
---@field bScaleMeshToLandscapeSplineFullWidth boolean
---@field SplineUpDir FVector
---@field NaniteClusterBoundsScale float
---@field SplineBoundaryMin float
---@field SplineBoundaryMax float
---@field bSmoothInterpRollScale boolean
---@field StartPosition FVector
---@field StartTangent FVector
---@field StartRollDegrees float
---@field StartScale FVector2D
---@field EndPosition FVector
---@field EndTangent FVector
---@field EndRollDegrees float
---@field EndScale FVector2D
local FPCGSplineMeshParams = {}



---@class FPCGSplineSamplerParams
---@field Dimension EPCGSplineSamplingDimension
---@field Mode EPCGSplineSamplingMode
---@field Fill EPCGSplineSamplingFill
---@field SubdivisionsPerSegment int32
---@field DistanceIncrement float
---@field NumSamples int32
---@field NumPlanarSubdivisions int32
---@field NumHeightSubdivisions int32
---@field StartOffset float
---@field EndOffset float
---@field MaxRandomOffsetNormalized float
---@field bFitToCurve boolean
---@field InteriorSampleSpacing float
---@field InteriorBorderSampleSpacing float
---@field bTreatSplineAsPolyline boolean
---@field InteriorOrientation EPCGSplineSamplingInteriorOrientation
---@field bProjectOntoSurface boolean
---@field InteriorDensityFalloffCurve FRuntimeFloatCurve
---@field bComputeDirectionDelta boolean
---@field NextDirectionDeltaAttribute FName
---@field bComputeCurvature boolean
---@field CurvatureAttribute FName
---@field bComputeSegmentIndex boolean
---@field SegmentIndexAttribute FName
---@field bComputeSubsegmentIndex boolean
---@field SubsegmentIndexAttribute FName
---@field bComputeTangents boolean
---@field ArriveTangentAttribute FName
---@field LeaveTangentAttribute FName
---@field bComputeAlpha boolean
---@field AlphaAttribute FName
---@field bComputeDistance boolean
---@field DistanceAttribute FName
---@field bComputeInputKey boolean
---@field InputKeyAttribute FName
---@field bUnbounded boolean
---@field PointSteepness float
---@field SeedingMode EPCGSplineSamplingSeedingMode
---@field bSeedFromLocalPosition boolean
---@field bSeedFrom2DPosition boolean
local FPCGSplineSamplerParams = {}



---@class FPCGSplineStruct
---@field SplineCurves FSplineCurves
---@field Transform FTransform
---@field DefaultUpVector FVector
---@field ReparamStepsPerSegment int32
---@field bClosedLoop boolean
---@field LocalBounds FBoxSphereBounds
---@field Bounds FBoxSphereBounds
local FPCGSplineStruct = {}



---@class FPCGStack
---@field StackFrames TArray<FPCGStackFrame>
local FPCGStack = {}



---@class FPCGStackContext
---@field Stacks TArray<FPCGStack>
---@field CurrentStackIndex int32
local FPCGStackContext = {}



---@class FPCGStackFrame
---@field Object TSoftObjectPtr<UObject>
---@field LoopIndex int32
local FPCGStackFrame = {}



---@class FPCGStaticMeshSpawnerContext : FPCGContext
local FPCGStaticMeshSpawnerContext = {}


---@class FPCGSubdivisionModuleAttributeNames
---@field SymbolAttributeName FName
---@field SizeAttributeName FName
---@field bProvideScalable boolean
---@field ScalableAttributeName FName
---@field bProvideDebugColor boolean
---@field DebugColorAttributeName FName
local FPCGSubdivisionModuleAttributeNames = {}



---@class FPCGSubdivisionSubmodule
---@field Symbol FName
---@field Size double
---@field bScalable boolean
---@field DebugColor FVector4
local FPCGSubdivisionSubmodule = {}



---@class FPCGTaggedData
---@field Data UPCGData
---@field Tags TSet<FString>
---@field Pin FName
---@field bPinlessData boolean
---@field bIsUsedMultipleTimes boolean
local FPCGTaggedData = {}



---@class FPCGTestMyColorStruct
---@field B double
---@field G double
---@field R double
---@field A double
local FPCGTestMyColorStruct = {}



---@class FPCGWeightedByCategoryEntryList
---@field CategoryEntry FString
---@field IsDefault boolean
---@field WeightedMeshEntries TArray<FPCGMeshSelectorWeightedEntry>
local FPCGWeightedByCategoryEntryList = {}



---@class FPCGWorldCommonQueryParams
---@field bIgnorePCGHits boolean
---@field bIgnoreSelfHits boolean
---@field CollisionChannel ECollisionChannel
---@field bTraceComplex boolean
---@field ActorTagFilter EPCGWorldQueryFilterByTag
---@field ActorTagsList FString
---@field SelectLandscapeHits EPCGWorldQuerySelectLandscapeHits
---@field bGetReferenceToActorHit boolean
---@field bGetReferenceToPhysicalMaterial boolean
---@field ParsedActorTagsList TSet<FName>
local FPCGWorldCommonQueryParams = {}



---@class FPCGWorldRayHitQueryParams : FPCGWorldRaycastQueryParams
---@field bOverrideDefaultParams boolean
---@field RayOrigin FVector
---@field RayDirection FVector
---@field RayLength double
local FPCGWorldRayHitQueryParams = {}



---@class FPCGWorldRaycastQueryParams : FPCGWorldCommonQueryParams
---@field bIgnoreBackfaceHits boolean
---@field bGetImpact boolean
---@field bGetImpactPoint boolean
---@field bGetImpactNormal boolean
---@field bGetReflection boolean
---@field bGetDistance boolean
---@field bGetLocalImpactPoint boolean
---@field bGetReferenceToRenderMaterial boolean
---@field bGetReferenceToStaticMesh boolean
---@field bGetFaceIndex boolean
---@field bGetUVCoords boolean
---@field bGetElementIndex boolean
---@field bApplyMetadataFromLandscape boolean
---@field RenderMaterialIndex int32
---@field UVChannel int32
local FPCGWorldRaycastQueryParams = {}



---@class FPCGWorldVolumetricQueryParams : FPCGWorldCommonQueryParams
---@field bSearchForOverlap boolean
local FPCGWorldVolumetricQueryParams = {}



---@class IPCGGenSourceBase : IInterface
local IPCGGenSourceBase = {}


---@class IPCGNodeSourceTextProvider : IInterface
local IPCGNodeSourceTextProvider = {}


---@class UPCGActorHelpers : UBlueprintFunctionLibrary
local UPCGActorHelpers = {}


---@class UPCGAddAttributeSettings : UPCGSettings
---@field InputSource FPCGAttributePropertyInputSelector
---@field OutputTarget FPCGAttributePropertyOutputSelector
---@field AttributeTypes FPCGMetadataTypesConstantStruct
---@field bCopyAllAttributes boolean
local UPCGAddAttributeSettings = {}



---@class UPCGAddComponentSettings : UPCGSettings
---@field bUseClassAttribute boolean
---@field ClassAttribute FPCGAttributePropertyInputSelector
---@field TemplateComponentClass TSubclassOf<UActorComponent>
---@field bAllowTemplateComponentEditing boolean
---@field TemplateComponent UActorComponent
---@field ActorReferenceAttribute FPCGAttributePropertyInputSelector
---@field ComponentReferenceAttribute FPCGAttributePropertyOutputNoSourceSelector
local UPCGAddComponentSettings = {}



---@class UPCGAddTagSettings : UPCGSettings
---@field TagsToAdd FString
---@field Prefix FString
---@field Suffix FString
---@field bIgnoreTagValueParsing boolean
---@field bTokenizeOnWhiteSpace boolean
local UPCGAddTagSettings = {}



---@class UPCGApplyOnActorSettings : UPCGSettings
---@field ObjectReferenceAttribute FPCGAttributePropertyInputSelector
---@field PropertyOverrideDescriptions TArray<FPCGObjectPropertyOverrideDescription>
---@field PostProcessFunctionNames TArray<FName>
---@field bSilenceErrorOnEmptyObjectPath boolean
---@field bSynchronousLoad boolean
local UPCGApplyOnActorSettings = {}



---@class UPCGApplyScaleToBoundsSettings : UPCGSettings
local UPCGApplyScaleToBoundsSettings = {}


---@class UPCGAssetExporter : UObject
local UPCGAssetExporter = {}

---@return TSubclassOf<UPCGDataAsset>
function UPCGAssetExporter:BP_GetAssetType() end
---@param Asset UPCGDataAsset
---@return boolean
function UPCGAssetExporter:BP_ExportToAsset(Asset) end


---@class UPCGAssetExporterUtils : UBlueprintFunctionLibrary
local UPCGAssetExporterUtils = {}

---@param PCGAssets TArray<FAssetData>
---@param Parameters FPCGAssetExporterParameters
function UPCGAssetExporterUtils:UpdateAssets(PCGAssets, Parameters) end
---@param Exporter UPCGAssetExporter
---@param Parameters FPCGAssetExporterParameters
---@return UPackage
function UPCGAssetExporterUtils:CreateAsset(Exporter, Parameters) end


---@class UPCGAttractSettings : UPCGSettings
---@field Mode EPCGAttractMode
---@field AttractorIndexAttribute FPCGAttributePropertyInputSelector
---@field Distance double
---@field bRemoveUnattractedPoints boolean
---@field TargetAttribute FPCGAttributePropertyInputSelector
---@field bUseSourceWeight boolean
---@field SourceWeightAttribute FPCGAttributePropertyInputSelector
---@field bUseTargetWeight boolean
---@field TargetWeightAttribute FPCGAttributePropertyInputSelector
---@field Weight double
---@field SourceAndTargetAttributeMapping TMap<FPCGAttributePropertyInputSelector, FPCGAttributePropertyInputSelector>
---@field bOutputAttractIndex boolean
---@field OutputAttractIndexAttribute FPCGAttributePropertyOutputNoSourceSelector
local UPCGAttractSettings = {}



---@class UPCGAttributeCastSettings : UPCGSettings
---@field InputSource FPCGAttributePropertyInputSelector
---@field OutputType EPCGMetadataTypes
---@field OutputTarget FPCGAttributePropertyOutputSelector
local UPCGAttributeCastSettings = {}



---@class UPCGAttributeExtractorTestObject : UObject
---@field DoubleValue double
local UPCGAttributeExtractorTestObject = {}



---@class UPCGAttributeFilteringRangeSettings : UPCGSettings
---@field TargetAttribute FPCGAttributePropertyInputSelector
---@field MinThreshold FPCGAttributeFilterThresholdSettings
---@field MaxThreshold FPCGAttributeFilterThresholdSettings
---@field bWarnOnDataMissingAttribute boolean
---@field bHasSpatialToPointDeprecation boolean
local UPCGAttributeFilteringRangeSettings = {}



---@class UPCGAttributeFilteringSettings : UPCGSettings
---@field Operator EPCGAttributeFilterOperator
---@field TargetAttribute FPCGAttributePropertyInputSelector
---@field bUseConstantThreshold boolean
---@field ThresholdAttribute FPCGAttributePropertyInputSelector
---@field bUseSpatialQuery boolean
---@field AttributeTypes FPCGMetadataTypesConstantStruct
---@field bWarnOnDataMissingAttribute boolean
---@field bHasSpatialToPointDeprecation boolean
local UPCGAttributeFilteringSettings = {}



---@class UPCGAttributeGetFromIndexSettings : UPCGSettings
---@field Index int32
local UPCGAttributeGetFromIndexSettings = {}



---@class UPCGAttributeGetFromPointIndexSettings : UPCGSettings
---@field InputSource FPCGAttributePropertyInputSelector
---@field Index int32
---@field OutputAttributeName FName
local UPCGAttributeGetFromPointIndexSettings = {}



---@class UPCGAttributeNoiseSettings : UPCGSettings
---@field InputSource FPCGAttributePropertyInputSelector
---@field OutputTarget FPCGAttributePropertyOutputSelector
---@field Mode EPCGAttributeNoiseMode
---@field NoiseMin float
---@field NoiseMax float
---@field bInvertSource boolean
---@field bClampResult boolean
---@field bHasSpatialToPointDeprecation boolean
local UPCGAttributeNoiseSettings = {}



---@class UPCGAttributePropertySelectorBlueprintHelpers : UBlueprintFunctionLibrary
local UPCGAttributePropertySelectorBlueprintHelpers = {}

---@param Selector FPCGAttributePropertySelector
---@param InPointProperty EPCGPointProperties
---@return boolean
function UPCGAttributePropertySelectorBlueprintHelpers:SetPointProperty(Selector, InPointProperty) end
---@param Selector FPCGAttributePropertySelector
---@param InExtraProperty EPCGExtraProperties
---@return boolean
function UPCGAttributePropertySelectorBlueprintHelpers:SetExtraProperty(Selector, InExtraProperty) end
---@param Selector FPCGAttributePropertySelector
---@param InAttributeName FName
---@return boolean
function UPCGAttributePropertySelectorBlueprintHelpers:SetAttributeName(Selector, InAttributeName) end
---@param Selector FPCGAttributePropertySelector
---@return EPCGAttributePropertySelection
function UPCGAttributePropertySelectorBlueprintHelpers:GetSelection(Selector) end
---@param Selector FPCGAttributePropertySelector
---@return EPCGPointProperties
function UPCGAttributePropertySelectorBlueprintHelpers:GetPointProperty(Selector) end
---@param Selector FPCGAttributePropertySelector
---@return FName
function UPCGAttributePropertySelectorBlueprintHelpers:GetName(Selector) end
---@param Selector FPCGAttributePropertySelector
---@return EPCGExtraProperties
function UPCGAttributePropertySelectorBlueprintHelpers:GetExtraProperty(Selector) end
---@param Selector FPCGAttributePropertySelector
---@return TArray<FString>
function UPCGAttributePropertySelectorBlueprintHelpers:GetExtraNames(Selector) end
---@param Selector FPCGAttributePropertySelector
---@return FName
function UPCGAttributePropertySelectorBlueprintHelpers:GetAttributeName(Selector) end
---@param OutputSelector FPCGAttributePropertyOutputSelector
---@param InputSelector FPCGAttributePropertyInputSelector
---@return FPCGAttributePropertyOutputSelector
function UPCGAttributePropertySelectorBlueprintHelpers:CopyAndFixSource(OutputSelector, InputSelector) end
---@param Selector FPCGAttributePropertyInputSelector
---@param InData UPCGData
---@return FPCGAttributePropertyInputSelector
function UPCGAttributePropertySelectorBlueprintHelpers:CopyAndFixLast(Selector, InData) end


---@class UPCGAttributeReduceSettings : UPCGSettings
---@field InputSource FPCGAttributePropertyInputSelector
---@field OutputAttributeName FName
---@field Operation EPCGAttributeReduceOperation
---@field JoinDelimiter FString
---@field bMergeOutputAttributes boolean
local UPCGAttributeReduceSettings = {}



---@class UPCGAttributeRemapSettings : UPCGMetadataSettingsBase
---@field InputSource FPCGAttributePropertyInputSelector
---@field InRangeMin double
---@field InRangeMax double
---@field OutRangeMin double
---@field OutRangeMax double
---@field bClampToUnitRange boolean
---@field bIgnoreValuesOutsideInputRange boolean
---@field bAllowInverseRange boolean
local UPCGAttributeRemapSettings = {}



---@class UPCGAttributeRemoveDuplicatesSettings : UPCGSettings
---@field AttributeSelectors TArray<FPCGAttributePropertyInputSelector>
---@field AttributeNamesToRemoveDuplicates FString
local UPCGAttributeRemoveDuplicatesSettings = {}



---@class UPCGAttributeSelectSettings : UPCGSettings
---@field InputSource FPCGAttributePropertyInputSelector
---@field OutputAttributeName FName
---@field Operation EPCGAttributeSelectOperation
---@field Axis EPCGAttributeSelectAxis
---@field CustomAxis FVector4
local UPCGAttributeSelectSettings = {}



---@class UPCGAttributeTransferSettings : UPCGCopyAttributesSettings
local UPCGAttributeTransferSettings = {}


---@class UPCGBadOutputsNodeSettings : UPCGSettings
local UPCGBadOutputsNodeSettings = {}


---@class UPCGBaseSubgraphNode : UPCGNode
local UPCGBaseSubgraphNode = {}


---@class UPCGBaseSubgraphSettings : UPCGSettings
local UPCGBaseSubgraphSettings = {}


---@class UPCGBaseTextureData : UPCGSurfaceData
---@field bUseDensitySourceChannel boolean
---@field ColorChannel EPCGTextureColorChannel
---@field Filter EPCGTextureFilter
---@field TexelSize float
---@field bUseAdvancedTiling boolean
---@field Tiling FVector2D
---@field CenterOffset FVector2D
---@field Rotation float
---@field bUseTileBounds boolean
---@field TileBounds FBox2D
---@field ColorData TArray<FLinearColor>
---@field Bounds FBox
---@field Height int32
---@field Width int32
local UPCGBaseTextureData = {}

---@param DensityFunction EPCGTextureDensityFunction
function UPCGBaseTextureData:SetDensityFunctionEquivalent(DensityFunction) end
---@return EPCGTextureDensityFunction
function UPCGBaseTextureData:GetDensityFunctionEquivalent() end


---@class UPCGBlueprintElement : UObject
---@field bIsCacheable boolean
---@field bComputeFullDataCrc boolean
---@field bRequiresGameThread boolean
---@field CustomInputPins TArray<FPCGPinProperties>
---@field CustomOutputPins TArray<FPCGPinProperties>
---@field bHasDefaultInPin boolean
---@field bHasDefaultOutPin boolean
---@field bHasDynamicPins boolean
local UPCGBlueprintElement = {}

---@param InContext FPCGContext
---@param InData UPCGPointData
---@param InPoint FPCGPoint
---@param OutMetadata UPCGMetadata
---@param Iteration int64
---@return TArray<FPCGPoint>
function UPCGBlueprintElement:VariableLoopBody(InContext, InData, InPoint, OutMetadata, Iteration) end
---@param InContext FPCGContext
---@param InData UPCGPointData
---@param OutData UPCGPointData
---@param OptionalOutData UPCGPointData
function UPCGBlueprintElement:VariableLoop(InContext, InData, OutData, OptionalOutData) end
---@param InContext FPCGContext
---@param InData UPCGPointData
---@param InPoint FPCGPoint
---@param OutPoint FPCGPoint
---@param OutMetadata UPCGMetadata
---@param Iteration int64
---@return boolean
function UPCGBlueprintElement:PointLoopBody(InContext, InData, InPoint, OutPoint, OutMetadata, Iteration) end
---@param InContext FPCGContext
---@param InData UPCGPointData
---@param OutData UPCGPointData
---@param OptionalOutData UPCGPointData
function UPCGBlueprintElement:PointLoop(InContext, InData, OutData, OptionalOutData) end
---@return EPCGSettingsType
function UPCGBlueprintElement:NodeTypeOverride() end
---@return FName
function UPCGBlueprintElement:NodeTitleOverride() end
---@return FLinearColor
function UPCGBlueprintElement:NodeColorOverride() end
---@param InContext FPCGContext
---@param InOuterData UPCGPointData
---@param InInnerData UPCGPointData
---@param InOuterPoint FPCGPoint
---@param InInnerPoint FPCGPoint
---@param OutPoint FPCGPoint
---@param OutMetadata UPCGMetadata
---@param OuterIteration int64
---@param InnerIteration int64
---@return boolean
function UPCGBlueprintElement:NestedLoopBody(InContext, InOuterData, InInnerData, InOuterPoint, InInnerPoint, OutPoint, OutMetadata, OuterIteration, InnerIteration) end
---@param InContext FPCGContext
---@param InOuterData UPCGPointData
---@param InInnerData UPCGPointData
---@param OutData UPCGPointData
---@param OptionalOutData UPCGPointData
function UPCGBlueprintElement:NestedLoop(InContext, InOuterData, InInnerData, OutData, OptionalOutData) end
---@param InContext FPCGContext
---@param Iteration int64
---@param InA UPCGSpatialData
---@param InB UPCGSpatialData
---@param OutPoint FPCGPoint
---@param OutMetadata UPCGMetadata
---@return boolean
function UPCGBlueprintElement:IterationLoopBody(InContext, Iteration, InA, InB, OutPoint, OutMetadata) end
---@param InContext FPCGContext
---@param NumIterations int64
---@param OutData UPCGPointData
---@param OptionalA UPCGSpatialData
---@param OptionalB UPCGSpatialData
---@param OptionalOutData UPCGPointData
function UPCGBlueprintElement:IterationLoop(InContext, NumIterations, OutData, OptionalA, OptionalB, OptionalOutData) end
---@return boolean
function UPCGBlueprintElement:IsCacheableOverride() end
---@param InContext FPCGContext
---@return int32
function UPCGBlueprintElement:GetSeed(InContext) end
---@param InContext FPCGContext
---@return FRandomStream
function UPCGBlueprintElement:GetRandomStream(InContext) end
---@return TArray<FPCGPinProperties>
function UPCGBlueprintElement:GetOutputPins() end
---@param InPinLabel FName
---@param OutFoundPin FPCGPinProperties
---@return boolean
function UPCGBlueprintElement:GetOutputPinByLabel(InPinLabel, OutFoundPin) end
---@return TArray<FPCGPinProperties>
function UPCGBlueprintElement:GetInputPins() end
---@param InPinLabel FName
---@param OutFoundPin FPCGPinProperties
---@return boolean
function UPCGBlueprintElement:GetInputPinByLabel(InPinLabel, OutFoundPin) end
---@return FPCGContext
function UPCGBlueprintElement:GetContext() end
---@param InContext FPCGContext
---@param Input FPCGDataCollection
---@param Output FPCGDataCollection
function UPCGBlueprintElement:ExecuteWithContext(InContext, Input, Output) end
---@param Input FPCGDataCollection
---@param Output FPCGDataCollection
function UPCGBlueprintElement:Execute(Input, Output) end
---@param InSettings UPCGSettings
---@param InPin UPCGPin
---@return int32
function UPCGBlueprintElement:DynamicPinTypesOverride(InSettings, InPin) end
---@return TSet<FName>
function UPCGBlueprintElement:CustomOutputLabels() end
---@return TSet<FName>
function UPCGBlueprintElement:CustomInputLabels() end
---@param InPreconfigureInfo FPCGPreConfiguredSettingsInfo
function UPCGBlueprintElement:ApplyPreconfiguredSettings(InPreconfigureInfo) end


---@class UPCGBlueprintHelpers : UBlueprintFunctionLibrary
local UPCGBlueprintHelpers = {}

---@param InPoint FPCGPoint
function UPCGBlueprintHelpers:SetSeedFromPosition(InPoint) end
---@param InPoint FPCGPoint
---@param InLocalCenter FVector
function UPCGBlueprintHelpers:SetLocalCenter(InPoint, InLocalCenter) end
---@param InPoint FPCGPoint
---@param InExtents FVector
function UPCGBlueprintHelpers:SetExtents(InPoint, InExtents) end
---@param InComponent UPCGComponent
---@param bFlushCache boolean
function UPCGBlueprintHelpers:RefreshPCGRuntimeComponent(InComponent, bFlushCache) end
---@param InPoint FPCGPoint
---@return FBox
function UPCGBlueprintHelpers:GetTransformedBounds(InPoint) end
---@param Context FPCGContext
---@return int64
function UPCGBlueprintHelpers:GetTaskId(Context) end
---@param Context FPCGContext
---@param SpatialData UPCGSpatialData
---@return AActor
function UPCGBlueprintHelpers:GetTargetActor(Context, SpatialData) end
---@param Context FPCGContext
---@return UPCGSettings
function UPCGBlueprintHelpers:GetSettings(Context) end
---@param InPointA FPCGPoint
---@param InPointB FPCGPoint
---@param OptionalSettings UPCGSettings
---@param OptionalComponent UPCGComponent
---@return FRandomStream
function UPCGBlueprintHelpers:GetRandomStreamFromTwoPoints(InPointA, InPointB, OptionalSettings, OptionalComponent) end
---@param InPoint FPCGPoint
---@param OptionalSettings UPCGSettings
---@param OptionalComponent UPCGComponent
---@return FRandomStream
function UPCGBlueprintHelpers:GetRandomStreamFromPoint(InPoint, OptionalSettings, OptionalComponent) end
---@param Context FPCGContext
---@return UPCGComponent
function UPCGBlueprintHelpers:GetOriginalComponent(Context) end
---@param InPoint FPCGPoint
---@return FVector
function UPCGBlueprintHelpers:GetLocalCenter(InPoint) end
---@param WorldContextObject UObject
---@param Location FVector
---@return TArray<FPCGLandscapeLayerWeight>
function UPCGBlueprintHelpers:GetInterpolatedPCGLandscapeLayerWeights(WorldContextObject, Location) end
---@param Context FPCGContext
---@return UPCGData
function UPCGBlueprintHelpers:GetInputData(Context) end
---@param InPoint FPCGPoint
---@return FVector
function UPCGBlueprintHelpers:GetExtents(InPoint) end
---@param Context FPCGContext
---@return UPCGComponent
function UPCGBlueprintHelpers:GetComponent(Context) end
---@param InActor AActor
---@param bIgnorePCGCreatedComponents boolean
---@return FBox
function UPCGBlueprintHelpers:GetActorLocalBoundsPCG(InActor, bIgnorePCGCreatedComponents) end
---@param Context FPCGContext
---@return UPCGData
function UPCGBlueprintHelpers:GetActorData(Context) end
---@param InActor AActor
---@param bIgnorePCGCreatedComponents boolean
---@return FBox
function UPCGBlueprintHelpers:GetActorBoundsPCG(InActor, bIgnorePCGCreatedComponents) end
---@return boolean
function UPCGBlueprintHelpers:FlushPCGCache() end
---@param InData UPCGData
---@param Context FPCGContext
---@param bInitializeMetadata boolean
---@return UPCGData
function UPCGBlueprintHelpers:DuplicateData(InData, Context, bInitializeMetadata) end
---@param InActor AActor
---@param bParseActor boolean
---@return UPCGData
function UPCGBlueprintHelpers:CreatePCGDataFromActor(InActor, bParseActor) end
---@param InPosition FVector
---@return int32
function UPCGBlueprintHelpers:ComputeSeedFromPosition(InPosition) end


---@class UPCGBlueprintPinHelpers : UBlueprintFunctionLibrary
local UPCGBlueprintPinHelpers = {}

---@param Label FName
---@param bAllowMultipleData boolean
---@param bAllowMultipleConnections boolean
---@param bIsAdvancedPin boolean
---@param AllowedType EPCGExclusiveDataType
---@return FPCGPinProperties
function UPCGBlueprintPinHelpers:MakePinProperty(Label, bAllowMultipleData, bAllowMultipleConnections, bIsAdvancedPin, AllowedType) end
---@param AllowedTypes int32
---@param TypeToCheck EPCGExclusiveDataType
---@return boolean
function UPCGBlueprintPinHelpers:IsOfType(AllowedTypes, TypeToCheck) end
---@param AllowedTypes int32
---@param TypeToCheck EPCGExclusiveDataType
---@return boolean
function UPCGBlueprintPinHelpers:IsExactlySameType(AllowedTypes, TypeToCheck) end
---@param InExclusiveDataType EPCGExclusiveDataType
---@return int32
function UPCGBlueprintPinHelpers:GetCorrespondingDataType(InExclusiveDataType) end
---@param PinProperty FPCGPinProperties
---@param Label FName
---@param bAllowMultipleData boolean
---@param bAllowMultipleConnections boolean
---@param bIsAdvancedPin boolean
---@param AllowedType EPCGExclusiveDataType
function UPCGBlueprintPinHelpers:BreakPinProperty(PinProperty, Label, bAllowMultipleData, bAllowMultipleConnections, bIsAdvancedPin, AllowedType) end


---@class UPCGBlueprintSettings : UPCGSettings
---@field BlueprintElementType TSubclassOf<UPCGBlueprintElement>
---@field BlueprintElementInstance UPCGBlueprintElement
local UPCGBlueprintSettings = {}

---@param InElementType TSubclassOf<UPCGBlueprintElement>
---@param ElementInstance UPCGBlueprintElement
function UPCGBlueprintSettings:SetElementType(InElementType, ElementInstance) end
---@return TSubclassOf<UPCGBlueprintElement>
function UPCGBlueprintSettings:GetElementType() end


---@class UPCGBlurSettings : UPCGSettings
---@field InputSource FPCGAttributePropertyInputSelector
---@field OutputTarget FPCGAttributePropertyOutputSelector
---@field NumIterations int32
---@field SearchDistance double
---@field BlurMode EPCGBlurElementMode
---@field bUseCustomStandardDeviation boolean
---@field CustomStandardDeviation double
local UPCGBlurSettings = {}



---@class UPCGBooleanSelectSettings : UPCGSettings
---@field bUseInputB boolean
local UPCGBooleanSelectSettings = {}



---@class UPCGBoundsFromMeshSettings : UPCGSettings
---@field MeshAttribute FPCGAttributePropertyInputSelector
---@field bSilenceAttributeNotFoundErrors boolean
---@field bSynchronousLoad boolean
local UPCGBoundsFromMeshSettings = {}



---@class UPCGBoundsModifierSettings : UPCGSettings
---@field Mode EPCGBoundsModifierMode
---@field BoundsMin FVector
---@field BoundsMax FVector
---@field bAffectSteepness boolean
---@field Steepness float
local UPCGBoundsModifierSettings = {}



---@class UPCGBranchSettings : UPCGSettings
---@field bOutputToB boolean
local UPCGBranchSettings = {}



---@class UPCGCleanSplineSettings : UPCGSettings
---@field bFuseColocatedControlPoints boolean
---@field ColocationDistanceThreshold double
---@field bUseSplineLocalSpace boolean
---@field FuseMode EPCGControlPointFuseMode
---@field bRemoveCollinearControlPoints boolean
---@field CollinearAngleThreshold double
---@field bUseRadians boolean
local UPCGCleanSplineSettings = {}



---@class UPCGClusterSettings : UPCGSettings
---@field Algorithm EPCGClusterAlgorithm
---@field NumClusters int32
---@field ClusterAttribute FName
---@field MaxIterations int32
---@field Tolerance double
---@field bOutputFinalCentroids boolean
local UPCGClusterSettings = {}



---@class UPCGCollapsePointsSettings : UPCGSettings
---@field DistanceThreshold double
---@field Mode EPCGCollapseMode
---@field ComparisonMode EPCGCollapseComparisonMode
---@field VisitOrder EPCGCollapseVisitOrder
---@field VisitOrderAttribute FPCGAttributePropertyInputSelector
---@field bUseMergeWeightAttribute boolean
---@field MergeWeightAttribute FPCGAttributePropertyInputSelector
---@field AttributesToMerge TArray<FPCGAttributePropertyOutputNoSourceSelector>
local UPCGCollapsePointsSettings = {}



---@class UPCGCollapseSettings : UPCGSettings
local UPCGCollapseSettings = {}


---@class UPCGCollisionShapeData : UPCGSpatialDataWithPointCache
---@field Transform FTransform
---@field CachedBounds FBox
---@field CachedStrictBounds FBox
local UPCGCollisionShapeData = {}



---@class UPCGCollisionWrapperData : UPCGSpatialData
---@field PointData UPCGPointData
---@field CollisionSelector FPCGAttributePropertyInputSelector
---@field CollisionQueryFlag EPCGCollisionQueryFlag
local UPCGCollisionWrapperData = {}



---@class UPCGCombinePointsSettings : UPCGSettings
---@field bCenterPivot boolean
---@field bUseFirstPointTransform boolean
---@field PointTransform FTransform
local UPCGCombinePointsSettings = {}



---@class UPCGComponent : UActorComponent
---@field Seed int32
---@field LandscapeTagsHasAny TArray<FName>
---@field bActivated boolean
---@field bIsComponentPartitioned boolean
---@field GenerationTrigger EPCGComponentGenerationTrigger
---@field bGenerateOnDropWhenTriggerOnDemand boolean
---@field bOverrideGenerationRadii boolean
---@field GenerationRadii FPCGRuntimeGenerationRadii
---@field SchedulingPolicyClass TSubclassOf<UPCGSchedulingPolicyBase>
---@field SchedulingPolicy UPCGSchedulingPolicyBase
---@field OnPCGGraphStartGeneratingExternal FPCGComponentOnPCGGraphStartGeneratingExternal
---@field OnPCGGraphCancelledExternal FPCGComponentOnPCGGraphCancelledExternal
---@field OnPCGGraphGeneratedExternal FPCGComponentOnPCGGraphGeneratedExternal
---@field OnPCGGraphCleanedExternal FPCGComponentOnPCGGraphCleanedExternal
---@field bGenerated boolean
---@field bRuntimeGenerated boolean
---@field PostGenerateFunctionNames TArray<FName>
---@field GraphInstance UPCGGraphInstance
---@field GenerationGridSize uint32
---@field CurrentEditingMode EPCGEditorDirtyMode
---@field SerializedEditingMode EPCGEditorDirtyMode
---@field InputType EPCGComponentInput
---@field bParseActorComponents boolean
---@field RuntimeGridDescriptorHash uint32
---@field CachedPCGData UPCGData
---@field CachedInputData UPCGData
---@field CachedActorData UPCGData
---@field CachedLandscapeData UPCGData
---@field CachedLandscapeHeightData UPCGData
---@field GeneratedResources TArray<UPCGManagedResource>
---@field LastGeneratedBounds FBox
---@field GeneratedGraphOutput FPCGDataCollection
---@field PerPinGeneratedOutput TMap<FString, FPCGDataCollection>
---@field bIsComponentLocal boolean
---@field bProceduralInstancesInUse boolean
local UPCGComponent = {}

---@param InGraph UPCGGraphInterface
function UPCGComponent:SetGraph(InGraph) end
---@param InEditingMode EPCGEditorDirtyMode
---@param InSerializedEditingMode EPCGEditorDirtyMode
function UPCGComponent:SetEditingMode(InEditingMode, InSerializedEditingMode) end
function UPCGComponent:NotifyPropertiesChangedFromBlueprint() end
---@return EPCGEditorDirtyMode
function UPCGComponent:GetSerializedEditingMode() end
---@return FPCGDataCollection
function UPCGComponent:GetGeneratedGraphOutput() end
---@return EPCGEditorDirtyMode
function UPCGComponent:GetEditingMode() end
---@param bForce boolean
function UPCGComponent:GenerateLocal(bForce) end
---@param bForce boolean
function UPCGComponent:Generate(bForce) end
---@param TemplateActor UClass
---@return AActor
function UPCGComponent:ClearPCGLink(TemplateActor) end
---@param bRemoveComponents boolean
---@param bSave boolean
function UPCGComponent:CleanupLocal(bRemoveComponents, bSave) end
---@param bRemoveComponents boolean
---@param bSave boolean
function UPCGComponent:Cleanup(bRemoveComponents, bSave) end
---@param InResource UPCGManagedResource
function UPCGComponent:AddToManagedResources(InResource) end
---@param InComponents TArray<UActorComponent>
function UPCGComponent:AddComponentsToManagedResources(InComponents) end
---@param InActors TArray<AActor>
function UPCGComponent:AddActorsToManagedResources(InActors) end


---@class UPCGComputeDataInterface : UComputeDataInterface
---@field OutputPinLabel FName
---@field OutputPinLabelAlias FName
---@field DownstreamInputPinLabelAliases TArray<FName>
local UPCGComputeDataInterface = {}



---@class UPCGComputeGraph : UComputeGraph
---@field PinsReceivingDataFromCPU TArray<TSoftObjectPtr<UPCGPin>>
---@field InputPinLabelAliases TMap<TSoftObjectPtr<UPCGPin>, FName>
---@field OutputCPUPinToInputGPUPinAlias TMap<TSoftObjectPtr<UPCGPin>, FName>
---@field KernelToNode TArray<TSoftObjectPtr<UPCGNode>>
---@field StaticMeshSpawners TArray<TSoftObjectPtr<UPCGSettings>>
---@field bLogDataDescriptions boolean
---@field GlobalAttributeLookupTable TMap<FName, FPCGKernelAttributeIDAndType>
---@field StringTable TArray<FString>
local UPCGComputeGraph = {}



---@class UPCGComputeGraphSettings : UPCGSettings
---@field ComputeGraphIndex int32
local UPCGComputeGraphSettings = {}



---@class UPCGComputeKernelSource : UComputeKernelSource
---@field Source FString
local UPCGComputeKernelSource = {}



---@class UPCGConvertToAttributeSetSettings : UPCGSettings
local UPCGConvertToAttributeSetSettings = {}


---@class UPCGConvertToPointDataSettings : UPCGCollapseSettings
local UPCGConvertToPointDataSettings = {}


---@class UPCGConvexHull2DSettings : UPCGSettings
local UPCGConvexHull2DSettings = {}


---@class UPCGCopyAttributesSettings : UPCGSettings
---@field Operation EPCGCopyAttributesOperation
---@field bCopyAllAttributes boolean
---@field InputSource FPCGAttributePropertyInputSelector
---@field OutputTarget FPCGAttributePropertyOutputSelector
local UPCGCopyAttributesSettings = {}



---@class UPCGCopyPointsDataInterface : UPCGComputeDataInterface
---@field Settings UPCGSettings
local UPCGCopyPointsDataInterface = {}



---@class UPCGCopyPointsDataProvider : UComputeDataProvider
---@field Settings UPCGCopyPointsSettings
local UPCGCopyPointsDataProvider = {}



---@class UPCGCopyPointsSettings : UPCGSettings
---@field RotationInheritance EPCGCopyPointsInheritanceMode
---@field ScaleInheritance EPCGCopyPointsInheritanceMode
---@field ColorInheritance EPCGCopyPointsInheritanceMode
---@field SeedInheritance EPCGCopyPointsInheritanceMode
---@field AttributeInheritance EPCGCopyPointsMetadataInheritanceMode
---@field TagInheritance EPCGCopyPointsTagInheritanceMode
---@field bCopyEachSourceOnEveryTarget boolean
local UPCGCopyPointsSettings = {}



---@class UPCGCreateAttributeSetSettings : UPCGSettings
---@field AttributeTypes FPCGMetadataTypesConstantStruct
---@field OutputTarget FPCGAttributePropertyOutputNoSourceSelector
local UPCGCreateAttributeSetSettings = {}



---@class UPCGCreateCollisionDataSettings : UPCGSettings
---@field CollisionAttribute FPCGAttributePropertyInputSelector
---@field CollisionQueryFlag EPCGCollisionQueryFlag
---@field bWarnIfAttributeCouldNotBeUsed boolean
---@field bSynchronousLoad boolean
local UPCGCreateCollisionDataSettings = {}



---@class UPCGCreatePointsGridSettings : UPCGSettings
---@field GridExtents FVector
---@field CellSize FVector
---@field PointSteepness float
---@field CoordinateSpace EPCGCoordinateSpace
---@field bSetPointsBounds boolean
---@field bCullPointsOutsideVolume boolean
---@field PointPosition EPCGPointPosition
local UPCGCreatePointsGridSettings = {}



---@class UPCGCreatePointsSettings : UPCGSettings
---@field PointsToCreate TArray<FPCGPoint>
---@field CoordinateSpace EPCGCoordinateSpace
---@field bCullPointsOutsideVolume boolean
local UPCGCreatePointsSettings = {}



---@class UPCGCreatePointsSphereSettings : UPCGSettings
---@field SphereGeneration EPCGSphereGeneration
---@field CoordinateSpace EPCGCoordinateSpace
---@field PointOrientation EPCGSpherePointOrientation
---@field Origin FVector
---@field Radius double
---@field GeodesicSubdivisions int32
---@field Theta double
---@field Phi double
---@field LatitudinalSegments int32
---@field LongitudinalSegments int32
---@field SampleCount int32
---@field PoissonDistance double
---@field PoissonMaxAttempts int32
---@field LatitudinalStartAngle double
---@field LatitudinalEndAngle double
---@field LongitudinalStartAngle double
---@field LongitudinalEndAngle double
---@field Jitter double
---@field PointSteepness float
---@field bCullPointsOutsideVolume boolean
local UPCGCreatePointsSphereSettings = {}



---@class UPCGCreateSplineSettings : UPCGSettings
---@field Mode EPCGCreateSplineMode
---@field bClosedLoop boolean
---@field bLinear boolean
---@field bApplyCustomTangents boolean
---@field ArriveTangentAttribute FName
---@field LeaveTangentAttribute FName
---@field TargetActor TSoftObjectPtr<AActor>
---@field PostProcessFunctionNames TArray<FName>
local UPCGCreateSplineSettings = {}



---@class UPCGCreateSurfaceFromSplineSettings : UPCGSettings
local UPCGCreateSurfaceFromSplineSettings = {}


---@class UPCGCreateTargetActor : UPCGSettings
---@field TemplateActor AActor
---@field AttachOptions EPCGAttachOptions
---@field RootActor TSoftObjectPtr<AActor>
---@field ActorLabel FString
---@field ActorPivot FTransform
---@field PropertyOverrideDescriptions TArray<FPCGObjectPropertyOverrideDescription>
---@field PostProcessFunctionNames TArray<FName>
---@field TemplateActorClass TSubclassOf<AActor>
---@field bAllowTemplateActorEditing boolean
local UPCGCreateTargetActor = {}



---@class UPCGCullPointsOutsideActorBoundsSettings : UPCGSettings
---@field BoundsExpansion float
---@field Mode EPCGCullPointsMode
local UPCGCullPointsOutsideActorBoundsSettings = {}



---@class UPCGCustomComputeKernelDataProvider : UComputeDataProvider
local UPCGCustomComputeKernelDataProvider = {}


---@class UPCGCustomHLSLSettings : UPCGSettings
---@field KernelType EPCGKernelType
---@field PointCount int32
---@field DispatchThreadCount EPCGDispatchThreadCount
---@field ThreadCountMultiplier int32
---@field FixedThreadCount int32
---@field ThreadCountInputPinLabels TArray<FName>
---@field InputPins TArray<FPCGPinProperties>
---@field OutputPins TArray<FPCGPinPropertiesGPU>
---@field bMuteUnwrittenPinDataErrors boolean
---@field ShaderFunctions FString
---@field ShaderSource FString
---@field InputDeclarations FString
---@field OutputDeclarations FString
---@field HelperDeclarations FString
local UPCGCustomHLSLSettings = {}



---@class UPCGCustomKernelDataInterface : UComputeDataInterface
---@field Settings UPCGSettings
local UPCGCustomKernelDataInterface = {}



---@class UPCGData : UObject
---@field UID uint64
local UPCGData = {}



---@class UPCGDataAsset : UObject
---@field Data FPCGDataCollection
---@field Name FString
local UPCGDataAsset = {}



---@class UPCGDataBinding : UObject
---@field SourceComponent TWeakObjectPtr<UPCGComponent>
---@field OutputDataCollection FPCGDataCollection
---@field Graph UPCGComputeGraph
---@field DataForGPU FPCGDataForGPU
---@field MeshSpawnersToPrimitives TMap<UPCGSettings, FPCGSpawnerPrimitives>
---@field GlobalAttributeLookupTable TMap<FName, FPCGKernelAttributeIDAndType>
---@field StringTable TArray<FString>
local UPCGDataBinding = {}



---@class UPCGDataCollectionDataInterface : UPCGComputeDataInterface
---@field ProducerSettings UPCGSettings
---@field bRequiresReadback boolean
local UPCGDataCollectionDataInterface = {}



---@class UPCGDataCollectionDataProvider : UComputeDataProvider
---@field ProducerSettings UPCGSettings
local UPCGDataCollectionDataProvider = {}



---@class UPCGDataCollectionExporter : UPCGAssetExporter
---@field Data FPCGDataCollection
local UPCGDataCollectionExporter = {}



---@class UPCGDataCollectionUploadDataInterface : UPCGDataCollectionDataInterface
local UPCGDataCollectionUploadDataInterface = {}


---@class UPCGDataFromActorSettings : UPCGSettings
---@field ActorSelector FPCGActorSelectorSettings
---@field ComponentSelector FPCGComponentSelectorSettings
---@field Mode EPCGGetDataFromActorMode
---@field bIgnorePCGGeneratedComponents boolean
---@field bAlsoOutputSinglePointData boolean
---@field bComponentsMustOverlapSelf boolean
---@field bGetDataOnAllGrids boolean
---@field AllowedGrids int32
---@field bMergeSinglePointData boolean
---@field ExpectedPins TArray<FName>
---@field PropertyName FName
---@field bSilenceSanitizedAttributeNameWarnings boolean
---@field bDisplayModeSettings boolean
local UPCGDataFromActorSettings = {}



---@class UPCGDataFunctionLibrary : UBlueprintFunctionLibrary
local UPCGDataFunctionLibrary = {}

---@param InCollection FPCGDataCollection
---@param InTag FString
---@param OutTaggedData TArray<FPCGTaggedData>
---@param InDataTypeClass TSubclassOf<UPCGData>
---@return TArray<UPCGData>
function UPCGDataFunctionLibrary:GetTypedInputsByTag(InCollection, InTag, OutTaggedData, InDataTypeClass) end
---@param InCollection FPCGDataCollection
---@param InPinLabel FName
---@param OutTaggedData TArray<FPCGTaggedData>
---@param InDataTypeClass TSubclassOf<UPCGData>
---@return TArray<UPCGData>
function UPCGDataFunctionLibrary:GetTypedInputsByPinLabel(InCollection, InPinLabel, OutTaggedData, InDataTypeClass) end
---@param InCollection FPCGDataCollection
---@param InPin FPCGPinProperties
---@param OutTaggedData TArray<FPCGTaggedData>
---@param InDataTypeClass TSubclassOf<UPCGData>
---@return TArray<UPCGData>
function UPCGDataFunctionLibrary:GetTypedInputsByPin(InCollection, InPin, OutTaggedData, InDataTypeClass) end
---@param InCollection FPCGDataCollection
---@param OutTaggedData TArray<FPCGTaggedData>
---@param InDataTypeClass TSubclassOf<UPCGData>
---@return TArray<UPCGData>
function UPCGDataFunctionLibrary:GetTypedInputs(InCollection, OutTaggedData, InDataTypeClass) end
---@param InCollection FPCGDataCollection
---@param InTag FString
---@return TArray<FPCGTaggedData>
function UPCGDataFunctionLibrary:GetParamsByTag(InCollection, InTag) end
---@param InCollection FPCGDataCollection
---@param InPinLabel FName
---@return TArray<FPCGTaggedData>
function UPCGDataFunctionLibrary:GetParamsByPinLabel(InCollection, InPinLabel) end
---@param InCollection FPCGDataCollection
---@return TArray<FPCGTaggedData>
function UPCGDataFunctionLibrary:GetParams(InCollection) end
---@param InCollection FPCGDataCollection
---@param InTag FString
---@return TArray<FPCGTaggedData>
function UPCGDataFunctionLibrary:GetInputsByTag(InCollection, InTag) end
---@param InCollection FPCGDataCollection
---@param InPinLabel FName
---@return TArray<FPCGTaggedData>
function UPCGDataFunctionLibrary:GetInputsByPinLabel(InCollection, InPinLabel) end
---@param InCollection FPCGDataCollection
---@return TArray<FPCGTaggedData>
function UPCGDataFunctionLibrary:GetInputs(InCollection) end
---@param InCollection FPCGDataCollection
---@return TArray<FPCGTaggedData>
function UPCGDataFunctionLibrary:GetAllSettings(InCollection) end
---@param InCollection FPCGDataCollection
---@param InData UPCGData
---@param InPinLabel FName
---@param InTags TArray<FString>
function UPCGDataFunctionLibrary:AddToCollection(InCollection, InData, InPinLabel, InTags) end


---@class UPCGDataNumSettings : UPCGSettings
---@field OutputAttributeName FName
local UPCGDataNumSettings = {}



---@class UPCGDataProviderDataCollectionUpload : UPCGDataCollectionDataProvider
local UPCGDataProviderDataCollectionUpload = {}


---@class UPCGDataTableRowToParamDataSettings : UPCGSettings
---@field RowName FName
---@field DataTable TSoftObjectPtr<UDataTable>
---@field bSynchronousLoad boolean
local UPCGDataTableRowToParamDataSettings = {}



---@class UPCGDebugDataInterface : UComputeDataInterface
local UPCGDebugDataInterface = {}


---@class UPCGDebugDataProvider : UComputeDataProvider
local UPCGDebugDataProvider = {}


---@class UPCGDebugDrawComponent : UDebugDrawComponent
local UPCGDebugDrawComponent = {}


---@class UPCGDebugSettings : UPCGSettings
---@field TargetActor TSoftObjectPtr<AActor>
local UPCGDebugSettings = {}



---@class UPCGDeleteAttributesSettings : UPCGSettings
---@field Operation EPCGAttributeFilterOperation
---@field Operator EPCGStringMatchingOperator
---@field SelectedAttributes FString
---@field bTokenizeOnWhiteSpace boolean
local UPCGDeleteAttributesSettings = {}



---@class UPCGDeleteTagsSettings : UPCGSettings
---@field Operation EPCGTagFilterOperation
---@field Operator EPCGStringMatchingOperator
---@field SelectedTags FString
---@field bTokenizeOnWhiteSpace boolean
local UPCGDeleteTagsSettings = {}



---@class UPCGDensityFilterSettings : UPCGSettings
---@field LowerBound float
---@field UpperBound float
---@field bInvertFilter boolean
local UPCGDensityFilterSettings = {}



---@class UPCGDensityRemapSettings : UPCGSettings
---@field InRangeMin float
---@field InRangeMax float
---@field OutRangeMin float
---@field OutRangeMax float
---@field bExcludeValuesOutsideInputRange boolean
local UPCGDensityRemapSettings = {}



---@class UPCGDeterminismTestBlueprintBase : UObject
local UPCGDeterminismTestBlueprintBase = {}

---@param InPCGNode UPCGNode
---@param InOutTestResult FDeterminismTestResult
function UPCGDeterminismTestBlueprintBase:ExecuteTest(InPCGNode, InOutTestResult) end


---@class UPCGDifferenceData : UPCGSpatialDataWithPointCache
---@field bDiffMetadata boolean
---@field Source UPCGSpatialData
---@field Difference UPCGSpatialData
---@field DifferencesUnion UPCGUnionData
---@field DensityFunction EPCGDifferenceDensityFunction
local UPCGDifferenceData = {}

---@param InDensityFunction EPCGDifferenceDensityFunction
function UPCGDifferenceData:SetDensityFunction(InDensityFunction) end
---@param InDifference UPCGSpatialData
function UPCGDifferenceData:K2_AddDifference(InDifference) end
---@param InData UPCGSpatialData
function UPCGDifferenceData:Initialize(InData) end


---@class UPCGDifferenceSettings : UPCGSettings
---@field DensityFunction EPCGDifferenceDensityFunction
---@field Mode EPCGDifferenceMode
---@field bDiffMetadata boolean
---@field bKeepZeroDensityPoints boolean
local UPCGDifferenceSettings = {}



---@class UPCGDistanceSettings : UPCGSettings
---@field bOutputToAttribute boolean
---@field OutputAttribute FPCGAttributePropertySelector
---@field bOutputDistanceVector boolean
---@field bSetDensity boolean
---@field MaximumDistance double
---@field SourceShape PCGDistanceShape
---@field TargetShape PCGDistanceShape
---@field bCheckSourceAgainstRespectiveTarget boolean
local UPCGDistanceSettings = {}



---@class UPCGDummyGetPropertyTest : UObject
---@field Int64Property int64
---@field DoubleProperty double
local UPCGDummyGetPropertyTest = {}



---@class UPCGDuplicateCrossSectionsSettings : UPCGSubdivisionBaseSettings
---@field bExtrudeVectorAsAttribute boolean
---@field ExtrudeVector FVector
---@field ExtrudeVectorAttribute FPCGAttributePropertyInputSelector
---@field bOutputSplineIndexAttribute boolean
---@field SplineIndexAttributeName FName
local UPCGDuplicateCrossSectionsSettings = {}



---@class UPCGDuplicatePointSettings : UPCGSettings
---@field Iterations int32
---@field Direction FVector
---@field bDirectionAppliedInRelativeSpace boolean
---@field bOutputSourcePoint boolean
---@field PointTransform FTransform
local UPCGDuplicatePointSettings = {}



---@class UPCGEdge : UObject
---@field InboundLabel FName
---@field InboundNode UPCGNode
---@field OutboundLabel FName
---@field OutboundNode UPCGNode
---@field InputPin UPCGPin
---@field OutputPin UPCGPin
local UPCGEdge = {}



---@class UPCGElevationIsolinesSettings : UPCGSettings
---@field ElevationStart double
---@field ElevationEnd double
---@field ElevationIncrement double
---@field Resolution double
---@field bAddTagOnOutputForSameElevation boolean
---@field bProjectSurfaceNormal boolean
---@field bOutputAsSpline boolean
---@field bLinearSpline boolean
local UPCGElevationIsolinesSettings = {}



---@class UPCGEngineSettings : UDeveloperSettingsBackedByCVars
---@field VolumeScale FVector
---@field bGenerateOnDrop boolean
---@field bDisplayCullingStateWhenDebugging boolean
local UPCGEngineSettings = {}



---@class UPCGExternalDataSettings : UPCGSettings
---@field AttributeMapping TMap<FString, FPCGAttributePropertyInputSelector>
local UPCGExternalDataSettings = {}



---@class UPCGFilterByAttributeSettings : UPCGFilterDataBaseSettings
---@field Attribute FName
---@field Operator EPCGStringMatchingOperator
---@field bIgnoreProperties boolean
local UPCGFilterByAttributeSettings = {}



---@class UPCGFilterByIndexSettings : UPCGFilterDataBaseSettings
---@field bInvertFilter boolean
---@field SelectedIndices FString
local UPCGFilterByIndexSettings = {}



---@class UPCGFilterByTagSettings : UPCGFilterDataBaseSettings
---@field Operation EPCGFilterByTagOperation
---@field Operator EPCGStringMatchingOperator
---@field SelectedTags FString
---@field bTokenizeOnWhiteSpace boolean
local UPCGFilterByTagSettings = {}



---@class UPCGFilterByTypeSettings : UPCGFilterDataBaseSettings
---@field TargetType EPCGDataType
---@field bShowOutsideFilter boolean
local UPCGFilterByTypeSettings = {}



---@class UPCGFilterDataBaseSettings : UPCGSettings
local UPCGFilterDataBaseSettings = {}


---@class UPCGFilterElementsByIndexSettings : UPCGSettings
---@field bSelectIndicesByInput boolean
---@field IndexSelectionAttribute FPCGAttributePropertyInputSelector
---@field SelectedIndices FString
---@field bOutputDiscardedElements boolean
---@field bInvertFilter boolean
local UPCGFilterElementsByIndexSettings = {}



---@class UPCGFunctionPrototypes : UBlueprintFunctionLibrary
local UPCGFunctionPrototypes = {}

---@param Point FPCGPoint
---@param MetaData UPCGMetadata
function UPCGFunctionPrototypes:PrototypeWithPointAndMetadata(Point, MetaData) end
function UPCGFunctionPrototypes:PrototypeWithNoParams() end


---@class UPCGGatherSettings : UPCGSettings
local UPCGGatherSettings = {}


---@class UPCGGenSourceComponent : UActorComponent
local UPCGGenSourceComponent = {}


---@class UPCGGenSourceEditorCamera : UObject
local UPCGGenSourceEditorCamera = {}


---@class UPCGGenSourcePlayer : UObject
local UPCGGenSourcePlayer = {}


---@class UPCGGenSourceWPStreamingSource : UObject
local UPCGGenSourceWPStreamingSource = {}


---@class UPCGGenericUserParameterGetSettings : UPCGSettings
---@field PropertyPath FString
---@field bForceObjectAndStructExtraction boolean
---@field OutputAttributeName FName
---@field Source EPCGUserParameterSource
---@field bQuiet boolean
local UPCGGenericUserParameterGetSettings = {}



---@class UPCGGetActorPropertySettings : UPCGSettings
---@field ActorSelector FPCGActorSelectorSettings
---@field bSelectComponent boolean
---@field ComponentClass TSubclassOf<UActorComponent>
---@field bProcessAllComponents boolean
---@field bOutputComponentReference boolean
---@field PropertyName FName
---@field bForceObjectAndStructExtraction boolean
---@field OutputAttributeName FName
---@field bOutputActorReference boolean
---@field bAlwaysRequeryActors boolean
local UPCGGetActorPropertySettings = {}



---@class UPCGGetAttributesSettings : UPCGSettings
---@field bGetType boolean
---@field bGetDefaultValue boolean
local UPCGGetAttributesSettings = {}



---@class UPCGGetBoundsSettings : UPCGSettings
local UPCGGetBoundsSettings = {}


---@class UPCGGetLandscapeSettings : UPCGDataFromActorSettings
---@field SamplingProperties FPCGLandscapeDataProps
local UPCGGetLandscapeSettings = {}



---@class UPCGGetLoopIndexSettings : UPCGSettings
---@field bWarnIfCalledOutsideOfLoop boolean
local UPCGGetLoopIndexSettings = {}



---@class UPCGGetPCGComponentSettings : UPCGDataFromActorSettings
local UPCGGetPCGComponentSettings = {}


---@class UPCGGetPrimitiveSettings : UPCGDataFromActorSettings
local UPCGGetPrimitiveSettings = {}


---@class UPCGGetPropertyFromObjectPathSettings : UPCGSettings
---@field ObjectPathsToExtract TArray<FSoftObjectPath>
---@field InputSource FPCGAttributePropertyInputSelector
---@field PropertyName FName
---@field bForceObjectAndStructExtraction boolean
---@field OutputAttributeName FName
---@field bSynchronousLoad boolean
---@field bPersistAllData boolean
---@field bSilenceErrorOnEmptyObjectPath boolean
local UPCGGetPropertyFromObjectPathSettings = {}



---@class UPCGGetSplineSettings : UPCGDataFromActorSettings
local UPCGGetSplineSettings = {}


---@class UPCGGetTagsSettings : UPCGSettings
---@field bExtractTagValues boolean
local UPCGGetTagsSettings = {}



---@class UPCGGetVolumeSettings : UPCGDataFromActorSettings
local UPCGGetVolumeSettings = {}


---@class UPCGGraph : UPCGGraphInterface
---@field bLandscapeUsesMetadata boolean
---@field Nodes TArray<UPCGNode>
---@field InputNode UPCGNode
---@field OutputNode UPCGNode
---@field UserParameters FInstancedPropertyBag
---@field bUseHierarchicalGeneration boolean
---@field HiGenGridSize EPCGHiGenGrid
---@field HiGenExponential uint32
---@field bUse2DGrid boolean
---@field bIsEditorOnly boolean
---@field CookedCompilationData UPCGGraphCompilationData
---@field GenerationRadii FPCGRuntimeGenerationRadii
local UPCGGraph = {}

---@param InNodes TArray<UPCGNode>
function UPCGGraph:RemoveNodes(InNodes) end
---@param InNode UPCGNode
function UPCGGraph:RemoveNode(InNode) end
---@param From UPCGNode
---@param FromLabel FName
---@param To UPCGNode
---@param ToLabel FName
---@return boolean
function UPCGGraph:RemoveEdge(From, FromLabel, To, ToLabel) end
---@return UPCGNode
function UPCGGraph:GetOutputNode() end
---@return UPCGNode
function UPCGGraph:GetInputNode() end
---@param InSettingsClass TSubclassOf<UPCGSettings>
---@param DefaultNodeSettings UPCGSettings
---@return UPCGNode
function UPCGGraph:AddNodeOfType(InSettingsClass, DefaultNodeSettings) end
---@param InSettings UPCGSettings
---@return UPCGNode
function UPCGGraph:AddNodeInstance(InSettings) end
---@param InSettings UPCGSettings
---@param DefaultNodeSettings UPCGSettings
---@return UPCGNode
function UPCGGraph:AddNodeCopy(InSettings, DefaultNodeSettings) end
---@param From UPCGNode
---@param FromPinLabel FName
---@param To UPCGNode
---@param ToPinLabel FName
---@return UPCGNode
function UPCGGraph:AddEdge(From, FromPinLabel, To, ToPinLabel) end


---@class UPCGGraphAuthoringTestHelperSettings : UPCGSettings
local UPCGGraphAuthoringTestHelperSettings = {}


---@class UPCGGraphCompilationData : UObject
---@field Tasks TMap<uint32, FPCGGraphTasks>
---@field StackContexts TMap<uint32, FPCGStackContext>
---@field ComputeGraphs TMap<uint32, FPCGComputeGraphs>
local UPCGGraphCompilationData = {}



---@class UPCGGraphInputOutputSettings : UPCGSettings
---@field Pins TArray<FPCGPinProperties>
---@field PinLabels TSet<FName>
---@field CustomPins TArray<FPCGPinProperties>
---@field bHasAddedDefaultPin boolean
local UPCGGraphInputOutputSettings = {}



---@class UPCGGraphInstance : UPCGGraphInterface
---@field Graph UPCGGraphInterface
---@field ParametersOverrides FPCGOverrideInstancedPropertyBag
local UPCGGraphInstance = {}



---@class UPCGGraphInterface : UObject
local UPCGGraphInterface = {}

---@return UPCGGraph
function UPCGGraphInterface:GetMutablePCGGraph() end
---@return UPCGGraph
function UPCGGraphInterface:GetConstPCGGraph() end


---@class UPCGGraphParametersHelpers : UBlueprintFunctionLibrary
local UPCGGraphParametersHelpers = {}

---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value FVector
function UPCGGraphParametersHelpers:SetVectorParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value FVector4
function UPCGGraphParametersHelpers:SetVector4Parameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value FVector2D
function UPCGGraphParametersHelpers:SetVector2DParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value FTransform
function UPCGGraphParametersHelpers:SetTransformParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value FString
function UPCGGraphParametersHelpers:SetStringParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value FSoftObjectPath
function UPCGGraphParametersHelpers:SetSoftObjectPathParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value TSoftObjectPtr<UObject>
function UPCGGraphParametersHelpers:SetSoftObjectParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value TSoftClassPtr<UObject>
function UPCGGraphParametersHelpers:SetSoftClassParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value FRotator
function UPCGGraphParametersHelpers:SetRotatorParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value FQuat
function UPCGGraphParametersHelpers:SetQuaternionParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value UObject
function UPCGGraphParametersHelpers:SetObjectParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value FName
function UPCGGraphParametersHelpers:SetNameParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value int64
function UPCGGraphParametersHelpers:SetInt64Parameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value int32
function UPCGGraphParametersHelpers:SetInt32Parameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value float
function UPCGGraphParametersHelpers:SetFloatParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value uint8
---@param Enum UEnum
function UPCGGraphParametersHelpers:SetEnumParameter(GraphInterface, Name, Value, Enum) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value double
function UPCGGraphParametersHelpers:SetDoubleParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value UClass
function UPCGGraphParametersHelpers:SetClassParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param Value uint8
function UPCGGraphParametersHelpers:SetByteParameter(GraphInterface, Name, Value) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@param bValue boolean
function UPCGGraphParametersHelpers:SetBoolParameter(GraphInterface, Name, bValue) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return boolean
function UPCGGraphParametersHelpers:IsOverridden(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return FVector
function UPCGGraphParametersHelpers:GetVectorParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return FVector4
function UPCGGraphParametersHelpers:GetVector4Parameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return FVector2D
function UPCGGraphParametersHelpers:GetVector2DParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return FTransform
function UPCGGraphParametersHelpers:GetTransformParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return FString
function UPCGGraphParametersHelpers:GetStringParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return FSoftObjectPath
function UPCGGraphParametersHelpers:GetSoftObjectPathParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return TSoftObjectPtr<UObject>
function UPCGGraphParametersHelpers:GetSoftObjectParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return TSoftClassPtr<UObject>
function UPCGGraphParametersHelpers:GetSoftClassParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return FRotator
function UPCGGraphParametersHelpers:GetRotatorParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return FQuat
function UPCGGraphParametersHelpers:GetQuaternionParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return UObject
function UPCGGraphParametersHelpers:GetObjectParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return FName
function UPCGGraphParametersHelpers:GetNameParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return int64
function UPCGGraphParametersHelpers:GetInt64Parameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return int32
function UPCGGraphParametersHelpers:GetInt32Parameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return float
function UPCGGraphParametersHelpers:GetFloatParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return uint8
function UPCGGraphParametersHelpers:GetEnumParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return double
function UPCGGraphParametersHelpers:GetDoubleParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return UClass
function UPCGGraphParametersHelpers:GetClassParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return uint8
function UPCGGraphParametersHelpers:GetByteParameter(GraphInterface, Name) end
---@param GraphInterface UPCGGraphInterface
---@param Name FName
---@return boolean
function UPCGGraphParametersHelpers:GetBoolParameter(GraphInterface, Name) end


---@class UPCGGridLinkageSettings : UPCGSettings
---@field FromGrid EPCGHiGenGrid
---@field ToGrid EPCGHiGenGrid
---@field GenerationGrid EPCGHiGenGrid
---@field ResourceKey FString
---@field UpstreamPin TSoftObjectPtr<UPCGPin>
local UPCGGridLinkageSettings = {}



---@class UPCGHiGenGridSizeSettings : UPCGSettings
---@field HiGenGridSize EPCGHiGenGrid
local UPCGHiGenGridSizeSettings = {}



---@class UPCGIndirectionSettings : UPCGSettings
---@field ProxyInterfaceMode EPCGProxyInterfaceMode
---@field SettingsClass TSubclassOf<UPCGSettings>
---@field BlueprintElementClass TSubclassOf<UPCGBlueprintElement>
---@field Settings UPCGSettings
---@field bTagOutputsBasedOnOutputPins boolean
local UPCGIndirectionSettings = {}



---@class UPCGInnerIntersectionSettings : UPCGSettings
---@field DensityFunction EPCGIntersectionDensityFunction
---@field bKeepZeroDensityPoints boolean
local UPCGInnerIntersectionSettings = {}



---@class UPCGInstanceDataInterface : UPCGComputeDataInterface
---@field InputPinProvidingData FName
---@field ProducerSettings UPCGSettings
local UPCGInstanceDataInterface = {}



---@class UPCGInstanceDataPackerBase : UObject
local UPCGInstanceDataPackerBase = {}

---@param Context FPCGContext
---@param InSpatialData UPCGSpatialData
---@param InstanceList FPCGMeshInstanceList
---@param OutPackedCustomData FPCGPackedCustomData
function UPCGInstanceDataPackerBase:PackInstances(Context, InSpatialData, InstanceList, OutPackedCustomData) end
---@param InstanceList FPCGMeshInstanceList
---@param MetaData UPCGMetadata
---@param AttributeNames TArray<FName>
---@param OutPackedCustomData FPCGPackedCustomData
function UPCGInstanceDataPackerBase:PackCustomDataFromAttributes(InstanceList, MetaData, AttributeNames, OutPackedCustomData) end
---@param TypeId int32
---@param OutPackedCustomData FPCGPackedCustomData
---@return boolean
function UPCGInstanceDataPackerBase:AddTypeToPacking(TypeId, OutPackedCustomData) end


---@class UPCGInstanceDataPackerByAttribute : UPCGInstanceDataPackerBase
---@field AttributeSelectors TArray<FPCGAttributePropertyInputSelector>
local UPCGInstanceDataPackerByAttribute = {}



---@class UPCGInstanceDataPackerByRegex : UPCGInstanceDataPackerBase
---@field RegexPatterns TArray<FString>
local UPCGInstanceDataPackerByRegex = {}



---@class UPCGInstanceDataProvider : UComputeDataProvider
---@field Primitives TArray<UPrimitiveComponent>
---@field NumInstancesAllPrimitives uint32
---@field NumCustomFloatsPerInstance uint32
local UPCGInstanceDataProvider = {}



---@class UPCGIntersectionData : UPCGSpatialDataWithPointCache
---@field DensityFunction EPCGIntersectionDensityFunction
---@field A UPCGSpatialData
---@field B UPCGSpatialData
---@field CachedBounds FBox
---@field CachedStrictBounds FBox
local UPCGIntersectionData = {}

---@param InA UPCGSpatialData
---@param InB UPCGSpatialData
function UPCGIntersectionData:Initialize(InA, InB) end


---@class UPCGLandscapeCache : UObject
---@field SerializationMode EPCGLandscapeCacheSerializationMode
---@field CookedSerializedContents EPCGLandscapeCacheSerializationContents
---@field CachedLayerNames TSet<FName>
local UPCGLandscapeCache = {}

function UPCGLandscapeCache:PrimeCache() end
function UPCGLandscapeCache:ClearCache() end


---@class UPCGLandscapeData : UPCGSurfaceData
---@field Landscapes TArray<TSoftObjectPtr<ALandscapeProxy>>
---@field Bounds FBox
---@field DataProps FPCGLandscapeDataProps
local UPCGLandscapeData = {}



---@class UPCGLandscapeDataInterface : UPCGComputeDataInterface
local UPCGLandscapeDataInterface = {}


---@class UPCGLandscapeDataProvider : UComputeDataProvider
local UPCGLandscapeDataProvider = {}


---@class UPCGLandscapeSplineData : UPCGPolyLineData
---@field Spline TWeakObjectPtr<ULandscapeSplinesComponent>
local UPCGLandscapeSplineData = {}



---@class UPCGLoadDataAssetSettings : UPCGSettings
---@field Asset TSoftObjectPtr<UPCGDataAsset>
---@field Pins TArray<FPCGPinProperties>
---@field AssetName FString
---@field bLoadFromInput boolean
---@field AssetReferenceSelector FPCGAttributePropertyInputSelector
---@field InputIndexTag FName
---@field DataIndexTag FName
---@field bWarnIfNoAsset boolean
---@field bTagOutputsBasedOnOutputPins boolean
---@field bSynchronousLoad boolean
local UPCGLoadDataAssetSettings = {}



---@class UPCGLoadDataTableSettings : UPCGExternalDataSettings
---@field DataTable TSoftObjectPtr<UDataTable>
---@field OutputType EPCGExclusiveDataType
---@field bSynchronousLoad boolean
local UPCGLoadDataTableSettings = {}



---@class UPCGLoopSettings : UPCGSubgraphSettings
---@field bUseGraphDefaultPinUsage boolean
---@field LoopPins FString
---@field FeedbackPins FString
---@field bTokenizeOnWhiteSpace boolean
local UPCGLoopSettings = {}



---@class UPCGMakeConcreteSettings : UPCGSettings
local UPCGMakeConcreteSettings = {}


---@class UPCGManagedActors : UPCGManagedResource
---@field GeneratedActors TSet<TSoftObjectPtr<AActor>>
local UPCGManagedActors = {}



---@class UPCGManagedComponent : UPCGManagedComponentBase
---@field GeneratedComponent TSoftObjectPtr<UActorComponent>
local UPCGManagedComponent = {}

---@param InGeneratedComponent TSoftObjectPtr<UActorComponent>
function UPCGManagedComponent:SetGeneratedComponentFromBP(InGeneratedComponent) end


---@class UPCGManagedComponentBase : UPCGManagedResource
local UPCGManagedComponentBase = {}


---@class UPCGManagedComponentDefaultList : UPCGManagedComponentList
local UPCGManagedComponentDefaultList = {}


---@class UPCGManagedComponentList : UPCGManagedComponentBase
---@field GeneratedComponents TArray<TSoftObjectPtr<UActorComponent>>
local UPCGManagedComponentList = {}

---@param InGeneratedComponent TArray<TSoftObjectPtr<UActorComponent>>
function UPCGManagedComponentList:SetGeneratedComponentsFromBP(InGeneratedComponent) end


---@class UPCGManagedDebugDrawComponent : UPCGManagedComponent
local UPCGManagedDebugDrawComponent = {}


---@class UPCGManagedDebugStringMessageKey : UPCGManagedResource
---@field HashKey uint64
local UPCGManagedDebugStringMessageKey = {}



---@class UPCGManagedISMComponent : UPCGManagedComponent
---@field bHasDescriptor boolean
---@field Descriptor FISMComponentDescriptor
---@field bHasRootLocation boolean
---@field RootLocation FVector
---@field SettingsUID uint64
local UPCGManagedISMComponent = {}



---@class UPCGManagedProceduralISMComponent : UPCGManagedComponent
---@field Descriptor FPCGProceduralISMComponentDescriptor
---@field bHasRootLocation boolean
---@field RootLocation FVector
---@field SettingsUID uint64
local UPCGManagedProceduralISMComponent = {}



---@class UPCGManagedResource : UObject
---@field Crc FPCGCrc
---@field bIsMarkedUnused boolean
local UPCGManagedResource = {}



---@class UPCGManagedSplineMeshComponent : UPCGManagedComponent
---@field Descriptor FSplineMeshComponentDescriptor
---@field SplineMeshParams FPCGSplineMeshParams
---@field SettingsUID uint64
local UPCGManagedSplineMeshComponent = {}



---@class UPCGMatchAndSetAttributesSettings : UPCGSettings
---@field bMatchAttributes boolean
---@field InputAttribute FPCGAttributePropertyInputSelector
---@field MatchAttribute FName
---@field bKeepUnmatched boolean
---@field bFindNearest boolean
---@field MaxDistanceMode EPCGMatchMaxDistanceMode
---@field MaxDistanceForNearestMatch FPCGMetadataTypesConstantStruct
---@field MaxDistanceInputAttribute FPCGAttributePropertyInputSelector
---@field bUseInputWeightAttribute boolean
---@field InputWeightAttribute FPCGAttributePropertyInputSelector
---@field bUseWeightAttribute boolean
---@field WeightAttribute FName
---@field bWarnIfNoMatchData boolean
local UPCGMatchAndSetAttributesSettings = {}



---@class UPCGMatchAndSetBase : UObject
---@field Type EPCGMetadataTypes
---@field StringMode EPCGMetadataTypesConstantStructStringMode
local UPCGMatchAndSetBase = {}

---@param InPointData UPCGPointData
---@return boolean
function UPCGMatchAndSetBase:ValidatePreconditions(InPointData) end
---@param Context FPCGContext
---@param InSettings UPCGPointMatchAndSetSettings
---@param InPointData UPCGPointData
---@param OutPointData UPCGPointData
function UPCGMatchAndSetBase:MatchAndSet(Context, InSettings, InPointData, OutPointData) end


---@class UPCGMatchAndSetByAttribute : UPCGMatchAndSetBase
---@field MatchSourceAttribute FName
---@field MatchSourceType EPCGMetadataTypes
---@field MatchSourceStringMode EPCGMetadataTypesConstantStructStringMode
---@field Entries TArray<FPCGMatchAndSetByAttributeEntry>
local UPCGMatchAndSetByAttribute = {}



---@class UPCGMatchAndSetWeighted : UPCGMatchAndSetBase
---@field Entries TArray<FPCGMatchAndSetWeightedEntry>
---@field bShouldMutateSeed boolean
local UPCGMatchAndSetWeighted = {}



---@class UPCGMatchAndSetWeightedByCategory : UPCGMatchAndSetBase
---@field CategoryAttribute FName
---@field CategoryType EPCGMetadataTypes
---@field CategoryStringMode EPCGMetadataTypesConstantStructStringMode
---@field Categories TArray<FPCGMatchAndSetWeightedByCategoryEntryList>
---@field bShouldMutateSeed boolean
local UPCGMatchAndSetWeightedByCategory = {}



---@class UPCGMergeAttributesSettings : UPCGSettings
local UPCGMergeAttributesSettings = {}


---@class UPCGMergeSettings : UPCGSettings
---@field bMergeMetadata boolean
local UPCGMergeSettings = {}



---@class UPCGMeshSelectorBase : UObject
local UPCGMeshSelectorBase = {}


---@class UPCGMeshSelectorByAttribute : UPCGMeshSelectorBase
---@field AttributeName FName
---@field TemplateDescriptor FPCGSoftISMComponentDescriptor
---@field bUseAttributeMaterialOverrides boolean
---@field MaterialOverrideAttributes TArray<FName>
local UPCGMeshSelectorByAttribute = {}



---@class UPCGMeshSelectorWeighted : UPCGMeshSelectorBase
---@field MeshEntries TArray<FPCGMeshSelectorWeightedEntry>
---@field bUseAttributeMaterialOverrides boolean
---@field MaterialOverrideAttributes TArray<FName>
local UPCGMeshSelectorWeighted = {}



---@class UPCGMeshSelectorWeightedByCategory : UPCGMeshSelectorBase
---@field CategoryAttribute FName
---@field Entries TArray<FPCGWeightedByCategoryEntryList>
---@field bUseAttributeMaterialOverrides boolean
---@field MaterialOverrideAttributes TArray<FName>
local UPCGMeshSelectorWeightedByCategory = {}



---@class UPCGMetadata : UObject
---@field Parent UPCGMetadata
---@field OtherParents TSet<TWeakObjectPtr<UPCGMetadata>>
local UPCGMetadata = {}

---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param OutPoint FPCGPoint
function UPCGMetadata:SetPointAttributes(Point, MetaData, OutPoint) end
---@param Key int64
---@param InMetaData UPCGMetadata
---@param TargetKey int64
---@param OutKey int64
function UPCGMetadata:SetAttributesByKey(Key, InMetaData, TargetKey, OutKey) end
---@param TargetKey int64
---@param OutKey int64
function UPCGMetadata:ResetWeightedAttributesByKey(TargetKey, OutKey) end
---@param OutPoint FPCGPoint
function UPCGMetadata:ResetPointWeightedAttributes(OutPoint) end
---@param AttributeToRename FName
---@param NewAttributeName FName
---@return boolean
function UPCGMetadata:RenameAttribute(AttributeToRename, NewAttributeName) end
---@param PointA FPCGPoint
---@param MetadataA UPCGMetadata
---@param PointB FPCGPoint
---@param MetadataB UPCGMetadata
---@param TargetPoint FPCGPoint
---@param Op EPCGMetadataOp
function UPCGMetadata:MergePointAttributes(PointA, MetadataA, PointB, MetadataB, TargetPoint, Op) end
---@param KeyA int64
---@param MetadataA UPCGMetadata
---@param KeyB int64
---@param MetadataB UPCGMetadata
---@param TargetKey int64
---@param Op EPCGMetadataOp
---@param OutKey int64
function UPCGMetadata:MergeAttributesByKey(KeyA, MetadataA, KeyB, MetadataB, TargetKey, Op, OutKey) end
---@param InMetadataToCopy UPCGMetadata
---@param InFilteredAttributes TSet<FName>
---@param InOptionalEntriesToCopy TArray<int64>
---@param InFilterMode EPCGMetadataFilterMode
function UPCGMetadata:K2_InitializeAsCopyWithAttributeFilter(InMetadataToCopy, InFilteredAttributes, InOptionalEntriesToCopy, InFilterMode) end
---@param InMetadataToCopy UPCGMetadata
---@param InOptionalEntriesToCopy TArray<int64>
function UPCGMetadata:K2_InitializeAsCopy(InMetadataToCopy, InOptionalEntriesToCopy) end
---@param InParent UPCGMetadata
---@param InFilteredAttributes TSet<FName>
---@param InFilterMode EPCGMetadataFilterMode
---@param InMatchOperator EPCGStringMatchingOperator
function UPCGMetadata:InitializeWithAttributeFilter(InParent, InFilteredAttributes, InFilterMode, InMatchOperator) end
---@param InParent UPCGMetadata
function UPCGMetadata:Initialize(InParent) end
---@param InMetaData UPCGMetadata
---@return boolean
function UPCGMetadata:HasCommonAttributes(InMetaData) end
---@param AttributeName FName
---@return boolean
function UPCGMetadata:HasAttribute(AttributeName) end
---@return int64
function UPCGMetadata:GetItemCountForChild() end
---@param AttributeNames TArray<FName>
---@param AttributeTypes TArray<EPCGMetadataTypes>
function UPCGMetadata:GetAttributes(AttributeNames, AttributeTypes) end
---@return int32
function UPCGMetadata:GetAttributeCount() end
function UPCGMetadata:Flatten() end
---@param AttributeName FName
function UPCGMetadata:DeleteAttribute(AttributeName) end
---@param AttributeName FName
---@param DefaultValue FVector
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateVectorAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue FVector4
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateVector4Attribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue FVector2D
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateVector2Attribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue FTransform
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateTransformAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue FString
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateStringAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue FSoftObjectPath
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateSoftObjectPathAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue FSoftClassPath
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateSoftClassPathAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue FRotator
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateRotatorAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue FQuat
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateQuatAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue FName
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateNameAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue int64
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateInteger64Attribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue int32
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateInteger32Attribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue float
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateFloatAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue double
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateDoubleAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeName FName
---@param DefaultValue boolean
---@param bAllowsInterpolation boolean
---@param bOverrideParent boolean
---@return UPCGMetadata
function UPCGMetadata:CreateBoolAttribute(AttributeName, DefaultValue, bAllowsInterpolation, bOverrideParent) end
---@param AttributeToCopy FName
---@param NewAttributeName FName
---@param bKeepParent boolean
---@return boolean
function UPCGMetadata:CopyExistingAttribute(AttributeToCopy, NewAttributeName, bKeepParent) end
---@param InOther UPCGMetadata
function UPCGMetadata:CopyAttributes(InOther) end
---@param InOther UPCGMetadata
---@param AttributeToCopy FName
---@param NewAttributeName FName
function UPCGMetadata:CopyAttribute(InOther, AttributeToCopy, NewAttributeName) end
---@param AttributeToClear FName
function UPCGMetadata:ClearAttribute(AttributeToClear) end
---@param ParentEntryKey int64
---@return int64
function UPCGMetadata:AddEntry(ParentEntryKey) end
---@param InOther UPCGMetadata
---@param InFilteredAttributes TSet<FName>
---@param InFilterMode EPCGMetadataFilterMode
---@param InMatchOperator EPCGStringMatchingOperator
function UPCGMetadata:AddAttributesFiltered(InOther, InFilteredAttributes, InFilterMode, InMatchOperator) end
---@param InOther UPCGMetadata
function UPCGMetadata:AddAttributes(InOther) end
---@param InOther UPCGMetadata
---@param AttributeName FName
function UPCGMetadata:AddAttribute(InOther, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param Weight float
---@param bSetNonInterpolableAttributes boolean
---@param TargetKey int64
---@param OutKey int64
function UPCGMetadata:AccumulateWeightedAttributesByKey(Key, MetaData, Weight, bSetNonInterpolableAttributes, TargetKey, OutKey) end
---@param InPoint FPCGPoint
---@param InMetaData UPCGMetadata
---@param Weight float
---@param bSetNonInterpolableAttributes boolean
---@param OutPoint FPCGPoint
function UPCGMetadata:AccumulatePointWeightedAttributes(InPoint, InMetaData, Weight, bSetNonInterpolableAttributes, OutPoint) end


---@class UPCGMetadataAccessorHelpers : UBlueprintFunctionLibrary
local UPCGMetadataAccessorHelpers = {}

---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FVector
function UPCGMetadataAccessorHelpers:SetVectorAttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FVector
function UPCGMetadataAccessorHelpers:SetVectorAttribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FVector4
function UPCGMetadataAccessorHelpers:SetVector4AttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FVector4
function UPCGMetadataAccessorHelpers:SetVector4Attribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FVector2D
function UPCGMetadataAccessorHelpers:SetVector2AttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FVector2D
function UPCGMetadataAccessorHelpers:SetVector2Attribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FTransform
function UPCGMetadataAccessorHelpers:SetTransformAttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FTransform
function UPCGMetadataAccessorHelpers:SetTransformAttribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FString
function UPCGMetadataAccessorHelpers:SetStringAttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FString
function UPCGMetadataAccessorHelpers:SetStringAttribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FSoftObjectPath
function UPCGMetadataAccessorHelpers:SetSoftObjectPathAttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FSoftObjectPath
function UPCGMetadataAccessorHelpers:SetSoftObjectPathAttribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FSoftClassPath
function UPCGMetadataAccessorHelpers:SetSoftClassPathAttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FSoftClassPath
function UPCGMetadataAccessorHelpers:SetSoftClassPathAttribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FRotator
function UPCGMetadataAccessorHelpers:SetRotatorAttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FRotator
function UPCGMetadataAccessorHelpers:SetRotatorAttribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FQuat
function UPCGMetadataAccessorHelpers:SetQuatAttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FQuat
function UPCGMetadataAccessorHelpers:SetQuatAttribute(Point, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value FName
function UPCGMetadataAccessorHelpers:SetNameAttribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value int64
function UPCGMetadataAccessorHelpers:SetInteger64AttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value int64
function UPCGMetadataAccessorHelpers:SetInteger64Attribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value int32
function UPCGMetadataAccessorHelpers:SetInteger32AttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value int32
function UPCGMetadataAccessorHelpers:SetInteger32Attribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value float
function UPCGMetadataAccessorHelpers:SetFloatAttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value float
function UPCGMetadataAccessorHelpers:SetFloatAttribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value double
function UPCGMetadataAccessorHelpers:SetDoubleAttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value double
function UPCGMetadataAccessorHelpers:SetDoubleAttribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value boolean
function UPCGMetadataAccessorHelpers:SetBoolAttributeByMetadataKey(Key, MetaData, AttributeName, Value) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Value boolean
function UPCGMetadataAccessorHelpers:SetBoolAttribute(Point, MetaData, AttributeName, Value) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@param Object UObject
---@param PropertyName FName
---@return boolean
function UPCGMetadataAccessorHelpers:SetAttributeFromPropertyByMetadataKey(Key, MetaData, AttributeName, Object, PropertyName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param ParentPoint FPCGPoint
---@param ParentMetadata UPCGMetadata
function UPCGMetadataAccessorHelpers:InitializeMetadata(Point, MetaData, ParentPoint, ParentMetadata) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return boolean
function UPCGMetadataAccessorHelpers:HasAttributeSetByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return boolean
function UPCGMetadataAccessorHelpers:HasAttributeSet(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FVector
function UPCGMetadataAccessorHelpers:GetVectorAttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FVector
function UPCGMetadataAccessorHelpers:GetVectorAttribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FVector4
function UPCGMetadataAccessorHelpers:GetVector4AttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FVector4
function UPCGMetadataAccessorHelpers:GetVector4Attribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FVector2D
function UPCGMetadataAccessorHelpers:GetVector2AttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FVector2D
function UPCGMetadataAccessorHelpers:GetVector2Attribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FTransform
function UPCGMetadataAccessorHelpers:GetTransformAttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FTransform
function UPCGMetadataAccessorHelpers:GetTransformAttribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FString
function UPCGMetadataAccessorHelpers:GetStringAttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FString
function UPCGMetadataAccessorHelpers:GetStringAttribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FSoftObjectPath
function UPCGMetadataAccessorHelpers:GetSoftObjectPathAttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FSoftObjectPath
function UPCGMetadataAccessorHelpers:GetSoftObjectPathAttribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FSoftClassPath
function UPCGMetadataAccessorHelpers:GetSoftClassPathAttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FSoftClassPath
function UPCGMetadataAccessorHelpers:GetSoftClassPathAttribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FRotator
function UPCGMetadataAccessorHelpers:GetRotatorAttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FRotator
function UPCGMetadataAccessorHelpers:GetRotatorAttribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FQuat
function UPCGMetadataAccessorHelpers:GetQuatAttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FQuat
function UPCGMetadataAccessorHelpers:GetQuatAttribute(Point, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return FName
function UPCGMetadataAccessorHelpers:GetNameAttribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return int64
function UPCGMetadataAccessorHelpers:GetInteger64AttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return int64
function UPCGMetadataAccessorHelpers:GetInteger64Attribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return int32
function UPCGMetadataAccessorHelpers:GetInteger32AttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return int32
function UPCGMetadataAccessorHelpers:GetInteger32Attribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return float
function UPCGMetadataAccessorHelpers:GetFloatAttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return float
function UPCGMetadataAccessorHelpers:GetFloatAttribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return double
function UPCGMetadataAccessorHelpers:GetDoubleAttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return double
function UPCGMetadataAccessorHelpers:GetDoubleAttribute(Point, MetaData, AttributeName) end
---@param Key int64
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return boolean
function UPCGMetadataAccessorHelpers:GetBoolAttributeByMetadataKey(Key, MetaData, AttributeName) end
---@param Point FPCGPoint
---@param MetaData UPCGMetadata
---@param AttributeName FName
---@return boolean
function UPCGMetadataAccessorHelpers:GetBoolAttribute(Point, MetaData, AttributeName) end
---@param InPoint FPCGPoint
---@param OutPoint FPCGPoint
---@param bCopyMetadata boolean
---@param InMetaData UPCGMetadata
---@param OutMetadata UPCGMetadata
function UPCGMetadataAccessorHelpers:CopyPoint(InPoint, OutPoint, bCopyMetadata, InMetaData, OutMetadata) end


---@class UPCGMetadataBitwiseSettings : UPCGMetadataSettingsBase
---@field Operation EPCGMetadataBitwiseOperation
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
local UPCGMetadataBitwiseSettings = {}



---@class UPCGMetadataBooleanSettings : UPCGMetadataSettingsBase
---@field Operation EPCGMetadataBooleanOperation
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
local UPCGMetadataBooleanSettings = {}



---@class UPCGMetadataBreakTransformSettings : UPCGMetadataSettingsBase
---@field InputSource FPCGAttributePropertyInputSelector
local UPCGMetadataBreakTransformSettings = {}



---@class UPCGMetadataBreakVectorSettings : UPCGMetadataSettingsBase
---@field InputSource FPCGAttributePropertyInputSelector
local UPCGMetadataBreakVectorSettings = {}



---@class UPCGMetadataCompareSettings : UPCGMetadataSettingsBase
---@field Operation EPCGMetadataCompareOperation
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
---@field Tolerance double
local UPCGMetadataCompareSettings = {}



---@class UPCGMetadataMakeRotatorSettings : UPCGMetadataSettingsBase
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
---@field InputSource3 FPCGAttributePropertyInputSelector
---@field Operation EPCGMetadataMakeRotatorOp
local UPCGMetadataMakeRotatorSettings = {}



---@class UPCGMetadataMakeTransformSettings : UPCGMetadataSettingsBase
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
---@field InputSource3 FPCGAttributePropertyInputSelector
local UPCGMetadataMakeTransformSettings = {}



---@class UPCGMetadataMakeVectorSettings : UPCGMetadataSettingsBase
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
---@field InputSource3 FPCGAttributePropertyInputSelector
---@field InputSource4 FPCGAttributePropertyInputSelector
---@field OutputType EPCGMetadataTypes
---@field MakeVector3Op EPCGMetadataMakeVector3
---@field MakeVector4Op EPCGMetadataMakeVector4
local UPCGMetadataMakeVectorSettings = {}



---@class UPCGMetadataMathsSettings : UPCGMetadataSettingsBase
---@field Operation EPCGMetadataMathsOperation
---@field bForceRoundingOpToInt boolean
---@field bForceOpToDouble boolean
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
---@field InputSource3 FPCGAttributePropertyInputSelector
local UPCGMetadataMathsSettings = {}



---@class UPCGMetadataOperationSettings : UPCGCopyAttributesSettings
local UPCGMetadataOperationSettings = {}


---@class UPCGMetadataPartitionSettings : UPCGSettings
---@field PartitionAttributeSelectors TArray<FPCGAttributePropertyInputSelector>
---@field PartitionAttributeNames FString
---@field bTokenizeOnWhiteSpace boolean
---@field bAssignIndexPartition boolean
---@field bDoNotPartition boolean
---@field PartitionIndexAttributeName FName
local UPCGMetadataPartitionSettings = {}



---@class UPCGMetadataRenameSettings : UPCGSettings
---@field AttributeToRename FName
---@field NewAttributeName FName
local UPCGMetadataRenameSettings = {}



---@class UPCGMetadataRotatorSettings : UPCGMetadataSettingsBase
---@field Operation EPCGMetadataRotatorOperation
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
---@field InputSource3 FPCGAttributePropertyInputSelector
local UPCGMetadataRotatorSettings = {}



---@class UPCGMetadataSettingsBase : UPCGSettings
---@field OutputTarget FPCGAttributePropertyOutputSelector
---@field OutputDataFromPin FName
local UPCGMetadataSettingsBase = {}

---@return TArray<FName>
function UPCGMetadataSettingsBase:GetOutputDataFromPinOptions() end


---@class UPCGMetadataStringOpSettings : UPCGMetadataSettingsBase
---@field Operation EPCGMetadataStringOperation
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
---@field InputSource3 FPCGAttributePropertyInputSelector
local UPCGMetadataStringOpSettings = {}



---@class UPCGMetadataTransformSettings : UPCGMetadataSettingsBase
---@field Operation EPCGMetadataTransformOperation
---@field TransformLerpMode EPCGTransformLerpMode
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
---@field InputSource3 FPCGAttributePropertyInputSelector
local UPCGMetadataTransformSettings = {}



---@class UPCGMetadataTrigSettings : UPCGMetadataSettingsBase
---@field Operation EPCGMetadataTrigOperation
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
local UPCGMetadataTrigSettings = {}



---@class UPCGMetadataVectorSettings : UPCGMetadataSettingsBase
---@field Operation EPCGMetadataVectorOperation
---@field InputSource1 FPCGAttributePropertyInputSelector
---@field InputSource2 FPCGAttributePropertyInputSelector
---@field InputSource3 FPCGAttributePropertyInputSelector
local UPCGMetadataVectorSettings = {}



---@class UPCGMultiSelectSettings : UPCGSettings
---@field SelectionMode EPCGControlFlowSelectionMode
---@field IntegerSelection int32
---@field IntOptions TArray<int32>
---@field StringSelection FString
---@field StringOptions TArray<FString>
---@field EnumSelection FEnumSelector
---@field CachedPinLabels TArray<FName>
local UPCGMultiSelectSettings = {}



---@class UPCGMutateSeedSettings : UPCGSettings
local UPCGMutateSeedSettings = {}


---@class UPCGNamedRerouteBaseSettings : UPCGRerouteSettings
local UPCGNamedRerouteBaseSettings = {}


---@class UPCGNamedRerouteDeclarationSettings : UPCGNamedRerouteBaseSettings
local UPCGNamedRerouteDeclarationSettings = {}


---@class UPCGNamedRerouteUsageSettings : UPCGNamedRerouteBaseSettings
---@field Declaration UPCGNamedRerouteDeclarationSettings
local UPCGNamedRerouteUsageSettings = {}



---@class UPCGNode : UObject
---@field NodeTitle FName
---@field SettingsInterface UPCGSettingsInterface
---@field OutboundNodes TArray<UPCGNode>
---@field InboundEdges TArray<UPCGEdge>
---@field OutboundEdges TArray<UPCGEdge>
---@field InputPins TArray<UPCGPin>
---@field OutputPins TArray<UPCGPin>
local UPCGNode = {}

---@param FromPinLable FName
---@param To UPCGNode
---@param ToPinLabel FName
---@return boolean
function UPCGNode:RemoveEdgeTo(FromPinLable, To, ToPinLabel) end
---@return UPCGSettings
function UPCGNode:GetSettings() end
---@return UPCGGraph
function UPCGNode:GetGraph() end
---@param FromPinLabel FName
---@param To UPCGNode
---@param ToPinLabel FName
---@return UPCGNode
function UPCGNode:AddEdgeTo(FromPinLabel, To, ToPinLabel) end


---@class UPCGNormalToDensitySettings : UPCGSettings
---@field Normal FVector
---@field Offset double
---@field Strength double
---@field DensityMode PCGNormalToDensityMode
local UPCGNormalToDensitySettings = {}



---@class UPCGNumberOfElementsBaseSettings : UPCGSettings
---@field OutputAttributeName FName
local UPCGNumberOfElementsBaseSettings = {}



---@class UPCGNumberOfEntriesSettings : UPCGNumberOfElementsBaseSettings
local UPCGNumberOfEntriesSettings = {}


---@class UPCGNumberOfPointsSettings : UPCGNumberOfElementsBaseSettings
local UPCGNumberOfPointsSettings = {}


---@class UPCGOctreeQueries : UBlueprintFunctionLibrary
local UPCGOctreeQueries = {}

---@param InPointData UPCGPointData
---@param InCenter FVector
---@param InRadius double
---@return TArray<FPCGPoint>
function UPCGOctreeQueries:GetPointsInsideSphere(InPointData, InCenter, InRadius) end
---@param InPointData UPCGPointData
---@param InBounds FBox
---@return TArray<FPCGPoint>
function UPCGOctreeQueries:GetPointsInsideBounds(InPointData, InBounds) end
---@param InPointData UPCGPointData
---@param InPointIndex int32
---@param bOutFound boolean
---@param OutPoint FPCGPoint
---@param InSearchDistance double
function UPCGOctreeQueries:GetFarthestPointFromOtherPoint(InPointData, InPointIndex, bOutFound, OutPoint, InSearchDistance) end
---@param InPointData UPCGPointData
---@param InCenter FVector
---@param bOutFound boolean
---@param OutPoint FPCGPoint
---@param InSearchDistance double
function UPCGOctreeQueries:GetFarthestPoint(InPointData, InCenter, bOutFound, OutPoint, InSearchDistance) end
---@param InPointData UPCGPointData
---@param InPointIndex int32
---@param bOutFound boolean
---@param OutPoint FPCGPoint
---@param InSearchDistance double
function UPCGOctreeQueries:GetClosestPointFromOtherPoint(InPointData, InPointIndex, bOutFound, OutPoint, InSearchDistance) end
---@param InPointData UPCGPointData
---@param InCenter FVector
---@param bInDiscardCenter boolean
---@param bOutFound boolean
---@param OutPoint FPCGPoint
---@param InSearchDistance double
function UPCGOctreeQueries:GetClosestPoint(InPointData, InCenter, bInDiscardCenter, bOutFound, OutPoint, InSearchDistance) end


---@class UPCGOuterIntersectionSettings : UPCGSettingsWithDynamicInputs
---@field DensityFunction EPCGIntersectionDensityFunction
---@field bIgnorePinsWithNoInput boolean
---@field bKeepZeroDensityPoints boolean
local UPCGOuterIntersectionSettings = {}



---@class UPCGParamData : UPCGData
---@field MetaData UPCGMetadata
---@field NameMap TMap<FName, int64>
---@field bHasCachedLastSelector boolean
---@field CachedLastSelector FPCGAttributePropertyInputSelector
local UPCGParamData = {}

---@return UPCGMetadata
function UPCGParamData:MutableMetadata() end
---@param InName FName
---@return UPCGParamData
function UPCGParamData:K2_FilterParamsByName(InName) end
---@param InKey int64
---@return UPCGParamData
function UPCGParamData:K2_FilterParamsByKey(InKey) end
---@param InName FName
---@return int64
function UPCGParamData:FindOrAddMetadataKey(InName) end
---@param InName FName
---@return int64
function UPCGParamData:FindMetadataKey(InName) end
---@return UPCGMetadata
function UPCGParamData:ConstMetadata() end


---@class UPCGParseStringSettings : UPCGMetadataSettingsBase
---@field InputSource FPCGAttributePropertyInputSelector
---@field TargetType EPCGMetadataTypes
local UPCGParseStringSettings = {}



---@class UPCGPathfindingSettings : UPCGSettings
---@field SearchDistance double
---@field bStartLocationsAsInput boolean
---@field StartLocationAttribute FPCGAttributePropertyInputSelector
---@field Start FVector
---@field bGoalLocationsAsInput boolean
---@field GoalLocationAttribute FPCGAttributePropertyInputSelector
---@field Goal FVector
---@field HeuristicWeight double
---@field CostFunctionMode EPCGPathfindingCostFunctionMode
---@field CostAttribute FPCGAttributePropertyInputSelector
---@field MaximumFitnessPenaltyFactor double
---@field bUsePathTraces boolean
---@field PathTraceParams FPCGWorldRaycastQueryParams
---@field bAcceptPartialPath boolean
---@field bOutputAsSpline boolean
---@field SplineMode EPCGPathfindingSplineMode
---@field bCopyOriginatingPoints boolean
local UPCGPathfindingSettings = {}



---@class UPCGPin : UObject
---@field Node UPCGNode
---@field Label FName
---@field Edges TArray<UPCGEdge>
---@field Properties FPCGPinProperties
local UPCGPin = {}

---@param InTooltip FText
function UPCGPin:SetToolTip(InTooltip) end
---@return boolean
function UPCGPin:IsOutputPin() end
---@return boolean
function UPCGPin:IsConnected() end
---@return FText
function UPCGPin:GetTooltip() end


---@class UPCGPinPropertiesBlueprintHelpers : UBlueprintFunctionLibrary
local UPCGPinPropertiesBlueprintHelpers = {}

---@param PinProperties FPCGPinProperties
function UPCGPinPropertiesBlueprintHelpers:SetRequiredPin(PinProperties) end
---@param PinProperties FPCGPinProperties
function UPCGPinPropertiesBlueprintHelpers:SetNormalPin(PinProperties) end
---@param PinProperties FPCGPinProperties
---@param bAllowMultipleConnections boolean
function UPCGPinPropertiesBlueprintHelpers:SetAllowMultipleConnections(PinProperties, bAllowMultipleConnections) end
---@param PinProperties FPCGPinProperties
function UPCGPinPropertiesBlueprintHelpers:SetAdvancedPin(PinProperties) end
---@param PinProperties FPCGPinProperties
---@return boolean
function UPCGPinPropertiesBlueprintHelpers:IsRequiredPin(PinProperties) end
---@param PinProperties FPCGPinProperties
---@return boolean
function UPCGPinPropertiesBlueprintHelpers:IsNormalPin(PinProperties) end
---@param PinProperties FPCGPinProperties
---@return boolean
function UPCGPinPropertiesBlueprintHelpers:IsAdvancedPin(PinProperties) end
---@param PinProperties FPCGPinProperties
---@return boolean
function UPCGPinPropertiesBlueprintHelpers:AllowsMultipleConnections(PinProperties) end


---@class UPCGPointData : UPCGSpatialData
---@field Points TArray<FPCGPoint>
local UPCGPointData = {}

---@param InPoints TArray<FPCGPoint>
function UPCGPointData:SetPoints(InPoints) end
---@return boolean
function UPCGPointData:IsEmpty() end
---@return TArray<FPCGPoint>
function UPCGPointData:GetPointsCopy() end
---@return TArray<FPCGPoint>
function UPCGPointData:GetPoints() end
---@param Index int32
---@return FPCGPoint
function UPCGPointData:GetPoint(Index) end
---@return int32
function UPCGPointData:GetNumPoints() end
---@param InData UPCGPointData
---@param InDataIndices TArray<int32>
function UPCGPointData:CopyPointsFrom(InData, InDataIndices) end


---@class UPCGPointExtentsModifierSettings : UPCGSettings
---@field Extents FVector
---@field Mode EPCGPointExtentsModifierMode
local UPCGPointExtentsModifierSettings = {}



---@class UPCGPointFromMeshSettings : UPCGSettings
---@field StaticMesh TSoftObjectPtr<UStaticMesh>
---@field MeshPathAttributeName FName
---@field bSynchronousLoad boolean
local UPCGPointFromMeshSettings = {}



---@class UPCGPointMatchAndSetSettings : UPCGSettings
---@field MatchAndSetType TSubclassOf<UPCGMatchAndSetBase>
---@field MatchAndSetInstance UPCGMatchAndSetBase
---@field SetTarget FPCGAttributePropertyOutputSelector
---@field SetTargetType EPCGMetadataTypes
local UPCGPointMatchAndSetSettings = {}

---@param InMatchAndSetType TSubclassOf<UPCGMatchAndSetBase>
function UPCGPointMatchAndSetSettings:SetMatchAndSetType(InMatchAndSetType) end


---@class UPCGPointNeighborhoodSettings : UPCGSettings
---@field SearchDistance double
---@field bSetDistanceToAttribute boolean
---@field DistanceAttribute FName
---@field bSetAveragePositionToAttribute boolean
---@field AveragePositionAttribute FName
---@field SetDensity EPCGPointNeighborhoodDensityMode
---@field bSetAveragePosition boolean
---@field bSetAverageColor boolean
---@field bWeightedAverage boolean
local UPCGPointNeighborhoodSettings = {}



---@class UPCGPolyLineData : UPCGSpatialDataWithPointCache
local UPCGPolyLineData = {}


---@class UPCGPrimitiveData : UPCGSpatialDataWithPointCache
---@field VoxelSize FVector
---@field Primitive TWeakObjectPtr<UPrimitiveComponent>
---@field CachedBounds FBox
---@field CachedStrictBounds FBox
local UPCGPrimitiveData = {}



---@class UPCGPrintElementSettings : UPCGSettings
---@field PrintString FString
---@field Verbosity EPCGPrintVerbosity
---@field CustomPrefix FString
---@field bDisplayOnNode boolean
---@field bPrintPerComponent boolean
---@field bPrefixWithOwner boolean
---@field bPrefixWithComponent boolean
---@field bPrefixWithGraph boolean
---@field bPrefixWithNode boolean
---@field bEnablePrint boolean
local UPCGPrintElementSettings = {}



---@class UPCGPrintGrammarSettings : UPCGSettings
---@field Grammar FString
local UPCGPrintGrammarSettings = {}



---@class UPCGProceduralISMComponent : UStaticMeshComponent
---@field NumInstances int32
---@field NumCustomDataFloats int32
---@field LocalBounds FBox
---@field InstanceStartCullDistance int32
---@field InstanceEndCullDistance int32
local UPCGProceduralISMComponent = {}

---@param InNumInstances int32
function UPCGProceduralISMComponent:SetNumInstances(InNumInstances) end
---@param InNumCustomDataFloats int32
function UPCGProceduralISMComponent:SetNumCustomDataFloats(InNumCustomDataFloats) end
---@param InLocalBounds FBox
function UPCGProceduralISMComponent:SetLocalBounds(InLocalBounds) end
---@param InStartCullDistance int32
---@param InEndCullDistance int32
function UPCGProceduralISMComponent:SetCullDistances(InStartCullDistance, InEndCullDistance) end
---@return int32
function UPCGProceduralISMComponent:GetNumInstances() end
---@return int32
function UPCGProceduralISMComponent:GetNumCustomDataFloats() end
---@param OutStartCullDistance int32
---@param OutEndCullDistance int32
function UPCGProceduralISMComponent:GetCullDistances(OutStartCullDistance, OutEndCullDistance) end
function UPCGProceduralISMComponent:ClearInstances() end


---@class UPCGProjectionData : UPCGSpatialDataWithPointCache
---@field Source UPCGSpatialData
---@field Target UPCGSpatialData
---@field CachedBounds FBox
---@field CachedStrictBounds FBox
---@field ProjectionParams FPCGProjectionParams
local UPCGProjectionData = {}



---@class UPCGProjectionSettings : UPCGSettings
---@field ProjectionParams FPCGProjectionParams
---@field bForceCollapseToPoint boolean
---@field bKeepZeroDensityPoints boolean
local UPCGProjectionSettings = {}



---@class UPCGQualityBranchSettings : UPCGSettings
---@field bUseLowPin boolean
---@field bUseMediumPin boolean
---@field bUseHighPin boolean
---@field bUseEpicPin boolean
---@field bUseCinematicPin boolean
local UPCGQualityBranchSettings = {}



---@class UPCGQualitySelectSettings : UPCGSettings
---@field bUseLowPin boolean
---@field bUseMediumPin boolean
---@field bUseHighPin boolean
---@field bUseEpicPin boolean
---@field bUseCinematicPin boolean
local UPCGQualitySelectSettings = {}



---@class UPCGRandomChoiceSettings : UPCGSettings
---@field bFixedMode boolean
---@field FixedNumber int32
---@field Ratio float
---@field bOutputDiscardedEntries boolean
local UPCGRandomChoiceSettings = {}



---@class UPCGRenderTargetData : UPCGBaseTextureData
---@field RenderTarget UTextureRenderTarget2D
local UPCGRenderTargetData = {}

---@param InRenderTarget UTextureRenderTarget2D
---@param InTransform FTransform
function UPCGRenderTargetData:Initialize(InRenderTarget, InTransform) end


---@class UPCGReplaceTagsSettings : UPCGSettings
---@field SelectedTags FString
---@field ReplacedTags FString
---@field bTokenizeOnWhiteSpace boolean
local UPCGReplaceTagsSettings = {}



---@class UPCGRerouteSettings : UPCGSettings
local UPCGRerouteSettings = {}


---@class UPCGResetPointCenterSettings : UPCGSettings
---@field PointCenterLocation FVector
local UPCGResetPointCenterSettings = {}



---@class UPCGReverseSplineSettings : UPCGSettings
---@field Operation EPCGReverseSplineOperation
local UPCGReverseSplineSettings = {}



---@class UPCGSampleTextureSettings : UPCGSettings
---@field TextureMappingMethod EPCGTextureMappingMethod
---@field UVCoordinatesAttribute FPCGAttributePropertyInputSelector
---@field TilingMode EPCGTextureAddressMode
---@field DensityMergeFunction EPCGDensityMergeOperation
---@field bClampOutputDensity boolean
local UPCGSampleTextureSettings = {}



---@class UPCGSanityCheckPointDataSettings : UPCGSettings
---@field MinPointCount int32
---@field MaxPointCount int32
local UPCGSanityCheckPointDataSettings = {}



---@class UPCGSaveDataAssetSettings : UPCGSettings
---@field Pins TArray<FPCGPinProperties>
---@field CustomDataCollectionExporterClass TSubclassOf<UPCGDataCollectionExporter>
---@field Params FPCGAssetExporterParameters
---@field AssetDescription FString
---@field AssetColor FLinearColor
local UPCGSaveDataAssetSettings = {}



---@class UPCGSchedulingPolicyBase : UObject
local UPCGSchedulingPolicyBase = {}


---@class UPCGSchedulingPolicyDistanceAndDirection : UPCGSchedulingPolicyBase
---@field bUseDistance boolean
---@field DistanceWeight float
---@field bUseDirection boolean
---@field DirectionWeight float
local UPCGSchedulingPolicyDistanceAndDirection = {}



---@class UPCGSelectGrammarSettings : UPCGSettings
---@field bKeyAsAttribute boolean
---@field Key FName
---@field KeyAttribute FPCGAttributePropertyInputSelector
---@field ComparedValueAttribute FPCGAttributePropertyInputSelector
---@field bCriteriaAsInput boolean
---@field Criteria TArray<FPCGSelectGrammarCriterion>
---@field bCopyKeyForUnselectedGrammar boolean
---@field bRemapCriteriaAttributeNames boolean
---@field CriteriaAttributeNames FPCGSelectGrammarCriteriaAttributeNames
---@field OutputGrammarAttribute FPCGAttributePropertyOutputSelector
local UPCGSelectGrammarSettings = {}



---@class UPCGSelectPointsSettings : UPCGSettings
---@field Ratio float
local UPCGSelectPointsSettings = {}



---@class UPCGSelfPruningSettings : UPCGSettings
---@field Parameters FPCGSelfPruningParameters
local UPCGSelfPruningSettings = {}



---@class UPCGSettings : UPCGSettingsInterface
---@field Seed int32
---@field bUseSeed boolean
---@field CachedOverridableParams TArray<FPCGSettingsOverridableParam>
---@field bExecuteOnGPU boolean
---@field bDumpCookedHLSL boolean
---@field bDumpDataDescriptions boolean
---@field bPrintShaderDebugValues boolean
---@field DebugBufferSize int32
local UPCGSettings = {}

---@return boolean
function UPCGSettings:UseSeed() end
---@param PinLabel FName
---@return int32
function UPCGSettings:BP_GetTypeUnionOfIncidentEdges(PinLabel) end


---@class UPCGSettingsInstance : UPCGSettingsInterface
---@field Settings UPCGSettings
local UPCGSettingsInstance = {}



---@class UPCGSettingsInterface : UPCGData
---@field bEnabled boolean
---@field bDebug boolean
local UPCGSettingsInterface = {}



---@class UPCGSettingsWithDynamicInputs : UPCGSettings
---@field DynamicInputPinProperties TArray<FPCGPinProperties>
local UPCGSettingsWithDynamicInputs = {}



---@class UPCGSortAttributesSettings : UPCGSettings
---@field InputSource FPCGAttributePropertyInputSelector
---@field SortMethod EPCGSortMethod
local UPCGSortAttributesSettings = {}



---@class UPCGSortTagsSettings : UPCGSettings
---@field Tag FName
---@field SortMethod EPCGSortMethod
local UPCGSortTagsSettings = {}



---@class UPCGSpatialData : UPCGData
---@field TargetActor TWeakObjectPtr<AActor>
---@field bKeepZeroDensityPoints boolean
---@field MetaData UPCGMetadata
---@field bHasCachedLastSelector boolean
---@field CachedLastSelector FPCGAttributePropertyInputSelector
local UPCGSpatialData = {}

---@param Context FPCGContext
---@return UPCGPointData
function UPCGSpatialData:ToPointDataWithContext(Context) end
---@return UPCGPointData
function UPCGSpatialData:ToPointData() end
---@return UPCGMetadata
function UPCGSpatialData:MutableMetadata() end
---@param InOther UPCGSpatialData
---@return UPCGUnionData
function UPCGSpatialData:K2_UnionWith(InOther) end
---@param InOther UPCGSpatialData
---@return UPCGDifferenceData
function UPCGSpatialData:K2_Subtract(InOther) end
---@param Transform FTransform
---@param Bounds FBox
---@param OutPoint FPCGPoint
---@param OutMetadata UPCGMetadata
---@return boolean
function UPCGSpatialData:K2_SamplePoint(Transform, Bounds, OutPoint, OutMetadata) end
---@param InTransform FTransform
---@param InBounds FBox
---@param InParams FPCGProjectionParams
---@param OutPoint FPCGPoint
---@param OutMetadata UPCGMetadata
---@return boolean
function UPCGSpatialData:K2_ProjectPoint(InTransform, InBounds, InParams, OutPoint, OutMetadata) end
---@param InOther UPCGSpatialData
---@param InParams FPCGProjectionParams
---@return UPCGSpatialData
function UPCGSpatialData:K2_ProjectOn(InOther, InParams) end
---@param InOther UPCGSpatialData
---@return UPCGIntersectionData
function UPCGSpatialData:K2_IntersectWith(InOther) end
---@param InSource UPCGSpatialData
---@param InMetadataParentOverride UPCGMetadata
---@param bInheritMetadata boolean
---@param bInheritAttributes boolean
function UPCGSpatialData:InitializeFromData(InSource, InMetadataParentOverride, bInheritMetadata, bInheritAttributes) end
---@return boolean
function UPCGSpatialData:HasNonTrivialTransform() end
---@return FBox
function UPCGSpatialData:GetStrictBounds() end
---@return FVector
function UPCGSpatialData:GetNormal() end
---@return int32
function UPCGSpatialData:GetDimension() end
---@param InPosition FVector
---@return float
function UPCGSpatialData:GetDensityAtPosition(InPosition) end
---@return FBox
function UPCGSpatialData:GetBounds() end
---@return UPCGMetadata
function UPCGSpatialData:CreateEmptyMetadata() end
---@return UPCGMetadata
function UPCGSpatialData:ConstMetadata() end


---@class UPCGSpatialDataWithPointCache : UPCGSpatialData
---@field CachedPointData UPCGPointData
---@field CachedBoundedPointDataBoxes TArray<FBox>
---@field CachedBoundedPointData TArray<UPCGPointData>
local UPCGSpatialDataWithPointCache = {}



---@class UPCGSpatialNoiseSettings : UPCGSettings
---@field Mode PCGSpatialNoiseMode
---@field EdgeMask2DMode PCGSpatialNoiseMask2DMode
---@field Iterations int32
---@field bTiling boolean
---@field Brightness float
---@field Contrast float
---@field ValueTarget FPCGAttributePropertyOutputNoSourceSelector
---@field RandomOffset FVector
---@field Transform FTransform
---@field VoronoiCellRandomness double
---@field VoronoiCellIDTarget FPCGAttributePropertyOutputNoSourceSelector
---@field bVoronoiOrientSamplesToCellEdge boolean
---@field TiledVoronoiResolution int32
---@field TiledVoronoiEdgeBlendCellCount int32
---@field EdgeBlendDistance float
---@field EdgeBlendCurveOffset float
---@field EdgeBlendCurveIntensity float
---@field bForceNoUseSeed boolean
local UPCGSpatialNoiseSettings = {}



---@class UPCGSpawnActorNode : UPCGBaseSubgraphNode
local UPCGSpawnActorNode = {}


---@class UPCGSpawnActorSettings : UPCGBaseSubgraphSettings
---@field PostSpawnFunctionNames TArray<FName>
---@field Option EPCGSpawnActorOption
---@field bForceDisableActorParsing boolean
---@field GenerationTrigger EPCGSpawnActorGenerationTrigger
---@field bInheritActorTags boolean
---@field TagsToAddOnActors TArray<FName>
---@field TemplateActor AActor
---@field SpawnedActorPropertyOverrideDescriptions TArray<FPCGObjectPropertyOverrideDescription>
---@field RootActor TSoftObjectPtr<AActor>
---@field AttachOptions EPCGAttachOptions
---@field bSpawnByAttribute boolean
---@field SpawnAttribute FName
---@field bWarnOnIdenticalSpawn boolean
---@field TemplateActorClass TSubclassOf<AActor>
---@field bAllowTemplateActorEditing boolean
local UPCGSpawnActorSettings = {}



---@class UPCGSpawnSplineMeshSettings : UPCGSettings
---@field SplineMeshDescriptor FSoftSplineMeshComponentDescriptor
---@field SplineMeshParams FPCGSplineMeshParams
---@field TargetActor TSoftObjectPtr<AActor>
---@field PostProcessFunctionNames TArray<FName>
---@field bSynchronousLoad boolean
---@field SplineMeshOverrideDescriptions TArray<FPCGObjectPropertyOverrideDescription>
local UPCGSpawnSplineMeshSettings = {}



---@class UPCGSpawnSplineSettings : UPCGSettings
---@field SplineComponent TSubclassOf<USplineComponent>
---@field bSpawnComponentFromAttribute boolean
---@field SpawnComponentFromAttributeName FPCGAttributePropertyInputSelector
---@field TargetActor TSoftObjectPtr<AActor>
---@field PostProcessFunctionNames TArray<FName>
---@field PropertyOverrideDescriptions TArray<FPCGObjectPropertyOverrideDescription>
---@field bOutputSplineComponentReference boolean
---@field ComponentReferenceAttributeName FName
local UPCGSpawnSplineSettings = {}



---@class UPCGSplineData : UPCGPolyLineData
---@field SplineStruct FPCGSplineStruct
---@field CachedBounds FBox
local UPCGSplineData = {}



---@class UPCGSplineInteriorSurfaceData : UPCGSurfaceData
---@field SplineStruct FPCGSplineStruct
---@field CachedBounds FBox
---@field CachedSplinePoints TArray<FVector>
---@field CachedSplinePoints2D TArray<FVector2D>
local UPCGSplineInteriorSurfaceData = {}



---@class UPCGSplineProjectionData : UPCGProjectionData
---@field ProjectedPosition FInterpCurveVector2D
local UPCGSplineProjectionData = {}



---@class UPCGSplineSamplerSettings : UPCGSettings
---@field SamplerParams FPCGSplineSamplerParams
local UPCGSplineSamplerSettings = {}



---@class UPCGSplineToSegmentSettings : UPCGSettings
---@field bExtractTangents boolean
---@field bExtractAngles boolean
---@field bExtractConnectivityInfo boolean
---@field bExtractClockwiseInfo boolean
local UPCGSplineToSegmentSettings = {}



---@class UPCGSplitPointsSettings : UPCGSettings
---@field SplitPosition float
---@field SplitAxis EPCGSplitAxis
local UPCGSplitPointsSettings = {}



---@class UPCGStaticMeshSpawnerDataInterface : UPCGComputeDataInterface
---@field Settings UPCGSettings
local UPCGStaticMeshSpawnerDataInterface = {}



---@class UPCGStaticMeshSpawnerDataProvider : UComputeDataProvider
---@field Settings UPCGStaticMeshSpawnerSettings
---@field AttributeIdOffsetStrides TArray<FUintVector4>
---@field PrimitiveStringKeys TArray<int32>
---@field PrimitiveMeshBounds TArray<FBox>
---@field SelectionCDF TArray<float>
---@field SelectorAttributeId int32
---@field NumInputPoints int32
---@field SelectedMeshAttributeId int32
local UPCGStaticMeshSpawnerDataProvider = {}



---@class UPCGStaticMeshSpawnerSettings : UPCGSettings
---@field MeshSelectorType TSubclassOf<UPCGMeshSelectorBase>
---@field MeshSelectorParameters UPCGMeshSelectorBase
---@field bAllowDescriptorChanges boolean
---@field InstanceDataPackerType TSubclassOf<UPCGInstanceDataPackerBase>
---@field InstanceDataPackerParameters UPCGInstanceDataPackerBase
---@field StaticMeshComponentPropertyOverrides TArray<FPCGObjectPropertyOverrideDescription>
---@field OutAttributeName FName
---@field bApplyMeshBoundsToPoints boolean
---@field TargetActor TSoftObjectPtr<AActor>
---@field PostProcessFunctionNames TArray<FName>
---@field bSynchronousLoad boolean
---@field bSilenceOverrideAttributeNotFoundErrors boolean
---@field bWarnOnIdenticalSpawn boolean
local UPCGStaticMeshSpawnerSettings = {}

---@param InMeshSelectorType TSubclassOf<UPCGMeshSelectorBase>
function UPCGStaticMeshSpawnerSettings:SetMeshSelectorType(InMeshSelectorType) end
---@param InInstancePackerType TSubclassOf<UPCGInstanceDataPackerBase>
function UPCGStaticMeshSpawnerSettings:SetInstancePackerType(InInstancePackerType) end


---@class UPCGSubdivideSegmentSettings : UPCGSubdivisionBaseSettings
---@field SubdivisionAxis EPCGSplitAxis
---@field bFlipAxisAsAttribute boolean
---@field bShouldFlipAxis boolean
---@field FlipAxisAttribute FPCGAttributePropertyInputSelector
---@field bAcceptIncompleteSubdivision boolean
---@field bOutputModuleIndexAttribute boolean
---@field ModuleIndexAttributeName FName
---@field bOutputExtremityAttributes boolean
---@field IsFirstAttributeName FName
---@field IsFinalAttributeName FName
---@field bOutputExtremityNeighborIndexAttribute boolean
---@field ExtremityNeighborIndexAttributeName FName
local UPCGSubdivideSegmentSettings = {}



---@class UPCGSubdivideSplineSettings : UPCGSubdivisionBaseSettings
---@field bAcceptIncompleteSubdivision boolean
---@field bModuleHeightAsAttribute boolean
---@field ModuleHeight double
---@field ModuleHeightAttribute FPCGAttributePropertyInputSelector
---@field bOutputModuleIndexAttribute boolean
---@field ModuleIndexAttributeName FName
---@field bOutputExtremityAttributes boolean
---@field IsFirstAttributeName FName
---@field IsFinalAttributeName FName
local UPCGSubdivideSplineSettings = {}



---@class UPCGSubdivisionBaseSettings : UPCGSettings
---@field bModuleInfoAsInput boolean
---@field ModulesInfo TArray<FPCGSubdivisionSubmodule>
---@field ModulesInfoAttributeNames FPCGSubdivisionModuleAttributeNames
---@field GrammarSelection FPCGGrammarSelection
---@field bUseSeedAttribute boolean
---@field SeedAttribute FPCGAttributePropertyInputSelector
---@field bForwardAttributesFromModulesInfo boolean
---@field SymbolAttributeName FName
---@field bOutputSizeAttribute boolean
---@field SizeAttributeName FName
---@field bOutputScalableAttribute boolean
---@field ScalableAttributeName FName
---@field bOutputDebugColorAttribute boolean
---@field DebugColorAttributeName FName
local UPCGSubdivisionBaseSettings = {}



---@class UPCGSubgraphNode : UPCGBaseSubgraphNode
local UPCGSubgraphNode = {}


---@class UPCGSubgraphSettings : UPCGBaseSubgraphSettings
---@field SubgraphInstance UPCGGraphInstance
---@field SubgraphOverride UPCGGraphInterface
local UPCGSubgraphSettings = {}



---@class UPCGSubsystem : UTickableWorldSubsystem
local UPCGSubsystem = {}


---@class UPCGSurfaceData : UPCGSpatialDataWithPointCache
---@field Transform FTransform
---@field LocalBounds FBox
local UPCGSurfaceData = {}



---@class UPCGSurfaceSamplerSettings : UPCGSettings
---@field PointsPerSquaredMeter float
---@field PointExtents FVector
---@field Looseness float
---@field bUnbounded boolean
---@field bApplyDensityToPoints boolean
---@field PointSteepness float
local UPCGSurfaceSamplerSettings = {}



---@class UPCGSwitchSettings : UPCGSettings
---@field SelectionMode EPCGControlFlowSelectionMode
---@field IntegerSelection int32
---@field IntOptions TArray<int32>
---@field StringSelection FString
---@field StringOptions TArray<FString>
---@field EnumSelection FEnumSelector
local UPCGSwitchSettings = {}



---@class UPCGTagsToAttributeSetSettings : UPCGSettings
local UPCGTagsToAttributeSetSettings = {}


---@class UPCGTextureData : UPCGBaseTextureData
---@field Texture TWeakObjectPtr<UTexture>
---@field TextureIndex int32
---@field bSuccessfullyInitialized boolean
---@field bReadbackFromGPUInitiated boolean
local UPCGTextureData = {}



---@class UPCGTextureDataInterface : UPCGComputeDataInterface
local UPCGTextureDataInterface = {}


---@class UPCGTextureDataProvider : UComputeDataProvider
local UPCGTextureDataProvider = {}


---@class UPCGTextureSamplerSettings : UPCGSettings
---@field Transform FTransform
---@field bUseAbsoluteTransform boolean
---@field TextureArrayIndex int32
---@field bUseDensitySourceChannel boolean
---@field ColorChannel EPCGTextureColorChannel
---@field Filter EPCGTextureFilter
---@field TexelSize float
---@field bUseAdvancedTiling boolean
---@field Tiling FVector2D
---@field CenterOffset FVector2D
---@field Rotation float
---@field bUseTileBounds boolean
---@field TileBoundsMin FVector2D
---@field TileBoundsMax FVector2D
---@field bSynchronousLoad boolean
---@field Texture TSoftObjectPtr<UTexture>
local UPCGTextureSamplerSettings = {}

---@param DensityFunction EPCGTextureDensityFunction
function UPCGTextureSamplerSettings:SetDensityFunctionEquivalent(DensityFunction) end
---@return EPCGTextureDensityFunction
function UPCGTextureSamplerSettings:GetDensityFunctionEquivalent() end


---@class UPCGTransformPointsSettings : UPCGSettings
---@field bApplyToAttribute boolean
---@field AttributeName FName
---@field OffsetMin FVector
---@field OffsetMax FVector
---@field bAbsoluteOffset boolean
---@field RotationMin FRotator
---@field RotationMax FRotator
---@field bAbsoluteRotation boolean
---@field ScaleMin FVector
---@field ScaleMax FVector
---@field bAbsoluteScale boolean
---@field bUniformScale boolean
---@field bRecomputeSeed boolean
local UPCGTransformPointsSettings = {}



---@class UPCGTrivialSettings : UPCGSettings
local UPCGTrivialSettings = {}


---@class UPCGUnionData : UPCGSpatialDataWithPointCache
---@field Data TArray<UPCGSpatialData>
---@field FirstNonTrivialTransformData UPCGSpatialData
---@field UnionType EPCGUnionType
---@field DensityFunction EPCGUnionDensityFunction
---@field CachedBounds FBox
---@field CachedStrictBounds FBox
---@field CachedDimension int32
local UPCGUnionData = {}

---@param InA UPCGSpatialData
---@param InB UPCGSpatialData
function UPCGUnionData:Initialize(InA, InB) end
---@param InData UPCGSpatialData
function UPCGUnionData:AddData(InData) end


---@class UPCGUnionSettings : UPCGSettings
---@field Type EPCGUnionType
---@field DensityFunction EPCGUnionDensityFunction
local UPCGUnionSettings = {}



---@class UPCGUnitTestDummyComponent : UActorComponent
---@field IntProperty int32
local UPCGUnitTestDummyComponent = {}



---@class UPCGUserParameterGetSettings : UPCGSettings
---@field PropertyGuid FGuid
---@field PropertyName FName
---@field bForceObjectAndStructExtraction boolean
local UPCGUserParameterGetSettings = {}



---@class UPCGUserParametersData : UPCGData
---@field UserParameters FInstancedStruct
---@field UpstreamData TSoftObjectPtr<UPCGUserParametersData>
local UPCGUserParametersData = {}



---@class UPCGVisualizeAttributeSettings : UPCGSettings
---@field AttributeSource FPCGAttributePropertyInputSelector
---@field CustomPrefixString FString
---@field bPrefixWithIndex boolean
---@field bPrefixWithAttributeName boolean
---@field LocalOffset FVector
---@field Color FColor
---@field Duration double
---@field PointLimit int32
---@field bVisualizeEnabled boolean
local UPCGVisualizeAttributeSettings = {}



---@class UPCGVolumeData : UPCGSpatialDataWithPointCache
---@field VoxelSize FVector
---@field Volume TWeakObjectPtr<AVolume>
---@field Bounds FBox
---@field StrictBounds FBox
local UPCGVolumeData = {}



---@class UPCGVolumeSamplerSettings : UPCGSettings
---@field VoxelSize FVector
---@field bUnbounded boolean
---@field PointSteepness float
local UPCGVolumeSamplerSettings = {}



---@class UPCGWaitLandscapeReadySettings : UPCGSettings
local UPCGWaitLandscapeReadySettings = {}


---@class UPCGWorldQuerySettings : UPCGSettings
---@field QueryParams FPCGWorldVolumetricQueryParams
local UPCGWorldQuerySettings = {}



---@class UPCGWorldRayHitData : UPCGSurfaceData
---@field World TWeakObjectPtr<UWorld>
---@field OriginatingComponent TWeakObjectPtr<UPCGComponent>
---@field Bounds FBox
---@field QueryParams FPCGWorldRayHitQueryParams
local UPCGWorldRayHitData = {}



---@class UPCGWorldRayHitSettings : UPCGSettings
---@field QueryParams FPCGWorldRayHitQueryParams
local UPCGWorldRayHitSettings = {}



---@class UPCGWorldRaycastElementSettings : UPCGSettings
---@field RaycastMode EPCGWorldRaycastMode
---@field OriginInputAttribute FPCGAttributePropertyInputSelector
---@field bOverrideRayDirections boolean
---@field RayDirection FVector
---@field RayDirectionAttribute FPCGAttributePropertyInputSelector
---@field EndPointAttribute FPCGAttributePropertyInputSelector
---@field bOverrideRayLengths boolean
---@field RayLength double
---@field RayLengthAttribute FPCGAttributePropertyInputSelector
---@field WorldQueryParams FPCGWorldRaycastQueryParams
---@field bKeepOriginalPointOnMiss boolean
---@field bUnbounded boolean
local UPCGWorldRaycastElementSettings = {}



---@class UPCGWorldVolumetricData : UPCGVolumeData
---@field World TWeakObjectPtr<UWorld>
---@field OriginatingComponent TWeakObjectPtr<UPCGComponent>
---@field QueryParams FPCGWorldVolumetricQueryParams
local UPCGWorldVolumetricData = {}



