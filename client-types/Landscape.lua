---@meta

---@class AControlPointMeshActor : AActor
---@field ControlPointMeshComponent UControlPointMeshComponent
local AControlPointMeshActor = {}



---@class ALandscape : ALandscapeProxy
local ALandscape = {}

---@param InWorldTransform FTransform
---@param InExtents FBox2D
---@param InWeightmapLayerNames TArray<FName>
---@param OutRenderTarget UTextureRenderTarget
---@return boolean
function ALandscape:RenderWeightmaps(InWorldTransform, InExtents, InWeightmapLayerNames, OutRenderTarget) end
---@param InWorldTransform FTransform
---@param InExtents FBox2D
---@param InWeightmapLayerName FName
---@param OutRenderTarget UTextureRenderTarget2D
---@return boolean
function ALandscape:RenderWeightmap(InWorldTransform, InExtents, InWeightmapLayerName, OutRenderTarget) end
---@param InWorldTransform FTransform
---@param InExtents FBox2D
---@param OutRenderTarget UTextureRenderTarget2D
---@return boolean
function ALandscape:RenderHeightmap(InWorldTransform, InExtents, OutRenderTarget) end
---@param bInIncludeVisibilityLayer boolean
---@return TArray<FName>
function ALandscape:GetTargetLayerNames(bInIncludeVisibilityLayer) end


---@class ALandscapeBlueprintBrushBase : AActor
---@field UpdateOnPropertyChange boolean
---@field AffectHeightmap boolean
---@field AffectWeightmap boolean
---@field AffectVisibilityLayer boolean
---@field AffectedWeightmapLayers TArray<FName>
local ALandscapeBlueprintBrushBase = {}

---@param bInUserTriggered boolean
function ALandscapeBlueprintBrushBase:RequestLandscapeUpdate(bInUserTriggered) end
---@param InParameters FLandscapeBrushParameters
---@return UTextureRenderTarget2D
function ALandscapeBlueprintBrushBase:RenderLayer(InParameters) end
---@param InIsHeightmap boolean
---@param InCombinedResult UTextureRenderTarget2D
---@param InWeightmapLayerName FName
---@return UTextureRenderTarget2D
function ALandscapeBlueprintBrushBase:Render(InIsHeightmap, InCombinedResult, InWeightmapLayerName) end
---@param InLandscapeTransform FTransform
---@param InLandscapeSize FIntPoint
---@param InLandscapeRenderTargetSize FIntPoint
function ALandscapeBlueprintBrushBase:Initialize(InLandscapeTransform, InLandscapeSize, InLandscapeRenderTargetSize) end
---@param OutStreamableAssets TArray<UObject>
function ALandscapeBlueprintBrushBase:GetBlueprintRenderDependencies(OutStreamableAssets) end


---@class ALandscapeGizmoActiveActor : ALandscapeGizmoActor
local ALandscapeGizmoActiveActor = {}


---@class ALandscapeGizmoActor : AActor
local ALandscapeGizmoActor = {}


---@class ALandscapeMeshProxyActor : AActor
---@field LandscapeMeshProxyComponent ULandscapeMeshProxyComponent
local ALandscapeMeshProxyActor = {}



---@class ALandscapeProxy : APartitionActor
---@field SplineComponent ULandscapeSplinesComponent
---@field LandscapeGuid FGuid
---@field OriginalLandscapeGuid FGuid
---@field bEnableNanite boolean
---@field PerLODOverrideMaterials TArray<FLandscapePerLODMaterialOverride>
---@field bDisableRuntimeGrassMapGeneration boolean
---@field LandscapeSectionOffset FIntPoint
---@field MaxLODLevel int32
---@field ComponentScreenSizeToUseSubSections float
---@field LOD0ScreenSize float
---@field LODGroupKey uint32
---@field LOD0DistributionSetting float
---@field LODDistributionSetting float
---@field ScalableLOD0ScreenSize FPerQualityLevelFloat
---@field ScalableLOD0DistributionSetting FPerQualityLevelFloat
---@field ScalableLODDistributionSetting FPerQualityLevelFloat
---@field bUseScalableLODSettings boolean
---@field LODBlendRange float
---@field StaticLightingLOD int32
---@field DefaultPhysMaterial UPhysicalMaterial
---@field StreamingDistanceMultiplier float
---@field LandscapeMaterial UMaterialInterface
---@field LandscapeHoleMaterial UMaterialInterface
---@field RuntimeVirtualTextures TArray<URuntimeVirtualTexture>
---@field bSetCreateRuntimeVirtualTextureVolumes boolean
---@field bVirtualTextureRenderWithQuad boolean
---@field bVirtualTextureRenderWithQuadHQ boolean
---@field VirtualTextureNumLods int32
---@field VirtualTextureLodBias int32
---@field VirtualTextureRenderPassType ERuntimeVirtualTextureMainPassType
---@field NegativeZBoundsExtension float
---@field PositiveZBoundsExtension float
---@field LandscapeComponents TArray<ULandscapeComponent>
---@field CollisionComponents TArray<ULandscapeHeightfieldCollisionComponent>
---@field FoliageComponents TArray<UHierarchicalInstancedStaticMeshComponent>
---@field NaniteComponent ULandscapeNaniteComponent
---@field NaniteComponents TArray<ULandscapeNaniteComponent>
---@field GrassTypesMaxDiscardDistance float
---@field StaticLightingResolution float
---@field CastShadow boolean
---@field bCastDynamicShadow boolean
---@field bCastStaticShadow boolean
---@field ShadowCacheInvalidationBehavior EShadowCacheInvalidationBehavior
---@field bCastContactShadow boolean
---@field bCastFarShadow boolean
---@field bCastHiddenShadow boolean
---@field bCastShadowAsTwoSided boolean
---@field bAffectDistanceFieldLighting boolean
---@field bAffectDynamicIndirectLighting boolean
---@field bAffectIndirectLightingWhileHidden boolean
---@field LightingChannels FLightingChannels
---@field bUseMaterialPositionOffsetInStaticLighting boolean
---@field NonNaniteVirtualShadowMapConstantDepthBias float
---@field NonNaniteVirtualShadowMapInvalidationHeightErrorThreshold float
---@field NonNaniteVirtualShadowMapInvalidationScreenSizeLimit float
---@field bHoldout boolean
---@field bRenderCustomDepth boolean
---@field CustomDepthStencilWriteMask ERendererStencilMask
---@field CustomDepthStencilValue int32
---@field LDMaxDrawDistance float
---@field LightmassSettings FLightmassPrimitiveSettings
---@field CollisionMipLevel int32
---@field SimpleCollisionMipLevel int32
---@field BodyInstance FBodyInstance
---@field bGenerateOverlapEvents boolean
---@field bBakeMaterialPositionOffsetIntoCollision boolean
---@field ComponentSizeQuads int32
---@field SubsectionSizeQuads int32
---@field NumSubsections int32
---@field bUsedForNavigation boolean
---@field bFillCollisionUnderLandscapeForNavmesh boolean
---@field NavigationGeometryGatheringMode ENavDataGatheringMode
---@field bUseDynamicMaterialInstance boolean
---@field bUseLandscapeForCullingInvisibleHLODVertices boolean
---@field bHasLayersContent boolean
---@field bUseCompressedHeightmapStorage boolean
---@field bStripPhysicsWhenCookedClient boolean
---@field bStripPhysicsWhenCookedServer boolean
---@field bStripGrassWhenCookedClient boolean
---@field bStripGrassWhenCookedServer boolean
---@field TargetLayers TMap<FName, FLandscapeTargetLayerSettings>
local ALandscapeProxy = {}

---@param InType ERuntimeVirtualTextureMainPassType
function ALandscapeProxy:SetVirtualTextureRenderPassType(InType) end
---@param ParameterName FName
---@param Value FLinearColor
function ALandscapeProxy:SetLandscapeMaterialVectorParameterValue(ParameterName, Value) end
---@param ParameterName FName
---@param Value UTexture
function ALandscapeProxy:SetLandscapeMaterialTextureParameterValue(ParameterName, Value) end
---@param ParameterName FName
---@param Value float
function ALandscapeProxy:SetLandscapeMaterialScalarParameterValue(ParameterName, Value) end
---@param InRenderTarget UTextureRenderTarget2D
---@param InExportHeightIntoRGChannel boolean
---@param InExportLandscapeProxies boolean
---@return boolean
function ALandscapeProxy:LandscapeExportHeightmapToRenderTarget(InRenderTarget, InExportHeightIntoRGChannel, InExportLandscapeProxies) end
---@return ALandscape
function ALandscapeProxy:GetLandscapeActor() end
---@param NewLandscapeMaterial UMaterialInterface
function ALandscapeProxy:EditorSetLandscapeMaterial(NewLandscapeMaterial) end
---@param InSplineComponent USplineComponent
---@param StartWidth float
---@param EndWidth float
---@param StartSideFalloff float
---@param EndSideFalloff float
---@param StartRoll float
---@param EndRoll float
---@param NumSubdivisions int32
---@param bRaiseHeights boolean
---@param bLowerHeights boolean
---@param PaintLayer ULandscapeLayerInfoObject
---@param EditLayerName FName
function ALandscapeProxy:EditorApplySpline(InSplineComponent, StartWidth, EndWidth, StartSideFalloff, EndSideFalloff, StartRoll, EndRoll, NumSubdivisions, bRaiseHeights, bLowerHeights, PaintLayer, EditLayerName) end
---@param InLODDistanceFactor float
function ALandscapeProxy:ChangeLODDistanceFactor(InLODDistanceFactor) end
---@param InComponentScreenSizeToUseSubSections float
function ALandscapeProxy:ChangeComponentScreenSizeToUseSubSections(InComponentScreenSizeToUseSubSections) end


---@class ALandscapeSplineActor : AActor
---@field LandscapeGuid FGuid
local ALandscapeSplineActor = {}



---@class ALandscapeSplineMeshesActor : APartitionActor
---@field StaticMeshComponents TArray<UStaticMeshComponent>
local ALandscapeSplineMeshesActor = {}



---@class ALandscapeStreamingProxy : ALandscapeProxy
---@field LandscapeActorRef TSoftObjectPtr<ALandscape>
---@field OverriddenSharedProperties TSet<FName>
local ALandscapeStreamingProxy = {}



---@class FForeignControlPointData
local FForeignControlPointData = {}


---@class FForeignSplineSegmentData
local FForeignSplineSegmentData = {}


---@class FForeignWorldSplineData
local FForeignWorldSplineData = {}


---@class FGizmoSelectData
local FGizmoSelectData = {}


---@class FGrassInput
---@field Name FName
---@field GrassType ULandscapeGrassType
---@field Input FExpressionInput
local FGrassInput = {}



---@class FGrassVariety
---@field GrassMesh UStaticMesh
---@field OverrideMaterials TArray<UMaterialInterface>
---@field GrassDensity FPerPlatformFloat
---@field GrassDensityQuality FPerQualityLevelFloat
---@field bUseGrid boolean
---@field PlacementJitter float
---@field StartCullDistance FPerPlatformInt
---@field StartCullDistanceQuality FPerQualityLevelInt
---@field EndCullDistance FPerPlatformInt
---@field EndCullDistanceQuality FPerQualityLevelInt
---@field MinLOD int32
---@field AllowedDensityRange FFloatInterval
---@field Scaling EGrassScaling
---@field ScaleX FFloatInterval
---@field ScaleY FFloatInterval
---@field ScaleZ FFloatInterval
---@field bWeightAttenuatesMaxScale boolean
---@field MaxScaleWeightAttenuation float
---@field RandomRotation boolean
---@field AlignToSurface boolean
---@field bUseLandscapeLightmap boolean
---@field LightingChannels FLightingChannels
---@field bReceivesDecals boolean
---@field bAffectDistanceFieldLighting boolean
---@field bCastDynamicShadow boolean
---@field bCastContactShadow boolean
---@field bKeepInstanceBufferCPUCopy boolean
---@field InstanceWorldPositionOffsetDisableDistance uint32
---@field ShadowCacheInvalidationBehavior EShadowCacheInvalidationBehavior
local FGrassVariety = {}



---@class FHeightmapData
---@field Texture UTexture2D
local FHeightmapData = {}



---@class FLandscapeBrushParameters
---@field RenderAreaWorldTransform FTransform
---@field RenderAreaSize FIntPoint
---@field CombinedResult UTextureRenderTarget2D
---@field LayerType ELandscapeToolTargetType
---@field WeightmapLayerName FName
local FLandscapeBrushParameters = {}



---@class FLandscapeComponentMaterialOverride
---@field LODIndex FPerPlatformInt
---@field Material UMaterialInterface
local FLandscapeComponentMaterialOverride = {}



---@class FLandscapeEditToolRenderData
---@field ToolMaterial UMaterialInterface
---@field GizmoMaterial UMaterialInterface
---@field SelectedType int32
---@field DebugChannelR int32
---@field DebugChannelG int32
---@field DebugChannelB int32
---@field DataTexture UTexture2D
---@field LayerContributionTexture UTexture2D
---@field DirtyTexture UTexture2D
local FLandscapeEditToolRenderData = {}



---@class FLandscapeEditorLayerSettings
local FLandscapeEditorLayerSettings = {}


---@class FLandscapeImportLayerInfo
local FLandscapeImportLayerInfo = {}


---@class FLandscapeInfoLayerSettings
---@field LayerInfoObj ULandscapeLayerInfoObject
---@field LayerName FName
local FLandscapeInfoLayerSettings = {}



---@class FLandscapeLayer
---@field Guid FGuid
---@field Name FName
---@field bVisible boolean
---@field bLocked boolean
---@field HeightmapAlpha float
---@field WeightmapAlpha float
---@field BlendMode ELandscapeBlendMode
---@field Brushes TArray<FLandscapeLayerBrush>
---@field WeightmapLayerAllocationBlend TMap<ULandscapeLayerInfoObject, boolean>
---@field EditLayer ULandscapeEditLayerBase
local FLandscapeLayer = {}



---@class FLandscapeLayerBrush
local FLandscapeLayerBrush = {}


---@class FLandscapeLayerComponentData
---@field HeightmapData FHeightmapData
---@field WeightmapData FWeightmapData
local FLandscapeLayerComponentData = {}



---@class FLandscapeMaterialTextureStreamingInfo
---@field TextureName FName
---@field TexelFactor float
local FLandscapeMaterialTextureStreamingInfo = {}



---@class FLandscapePerLODMaterialOverride
---@field LODIndex int32
---@field Material UMaterialInterface
local FLandscapePerLODMaterialOverride = {}



---@class FLandscapeProxyMaterialOverride
---@field LODIndex FPerPlatformInt
---@field Material UMaterialInterface
local FLandscapeProxyMaterialOverride = {}



---@class FLandscapeSplineConnection
---@field Segment ULandscapeSplineSegment
---@field End boolean
local FLandscapeSplineConnection = {}



---@class FLandscapeSplineInterpPoint
---@field Center FVector
---@field Left FVector
---@field Right FVector
---@field FalloffLeft FVector
---@field FalloffRight FVector
---@field LayerLeft FVector
---@field LayerRight FVector
---@field LayerFalloffLeft FVector
---@field LayerFalloffRight FVector
---@field StartEndFalloff float
local FLandscapeSplineInterpPoint = {}



---@class FLandscapeSplineMeshEntry
---@field Mesh UStaticMesh
---@field MaterialOverrides TArray<UMaterialInterface>
---@field bCenterH boolean
---@field CenterAdjust FVector2D
---@field bScaleToWidth boolean
---@field bNoZScaling boolean
---@field Scale FVector
---@field Orientation LandscapeSplineMeshOrientation
---@field ForwardAxis ESplineMeshAxis::Type
---@field UpAxis ESplineMeshAxis::Type
---@field Probability float
local FLandscapeSplineMeshEntry = {}



---@class FLandscapeSplineSegmentConnection
---@field ControlPoint ULandscapeSplineControlPoint
---@field TangentLen float
---@field SocketName FName
local FLandscapeSplineSegmentConnection = {}



---@class FLandscapeTargetLayerSettings
---@field LayerInfoObj ULandscapeLayerInfoObject
local FLandscapeTargetLayerSettings = {}



---@class FLandscapeTexture2DMipMap
---@field SizeX int32
---@field SizeY int32
---@field bCompressed boolean
local FLandscapeTexture2DMipMap = {}



---@class FLayerBlendInput
---@field LayerName FName
---@field BlendType ELandscapeLayerBlendType
---@field LayerInput FExpressionInput
---@field HeightInput FExpressionInput
---@field PreviewWeight float
---@field ConstLayerInput FVector
---@field ConstHeightInput float
local FLayerBlendInput = {}



---@class FMTSegmentRoadSide
---@field Key FName
---@field bRight boolean
---@field bLeft boolean
local FMTSegmentRoadSide = {}



---@class FPhysicalMaterialInput
---@field PhysicalMaterial UPhysicalMaterial
---@field Input FExpressionInput
local FPhysicalMaterialInput = {}



---@class FWeightmapData
---@field Textures TArray<UTexture2D>
---@field LayerAllocations TArray<FWeightmapLayerAllocationInfo>
---@field TextureUsages TArray<ULandscapeWeightmapUsage>
local FWeightmapData = {}



---@class FWeightmapLayerAllocationInfo
---@field LayerInfo ULandscapeLayerInfoObject
---@field WeightmapTextureIndex uint8
---@field WeightmapTextureChannel uint8
local FWeightmapLayerAllocationInfo = {}



---@class ILandscapeBrushRenderCallAdapter_GlobalMergeLegacySupport : IInterface
local ILandscapeBrushRenderCallAdapter_GlobalMergeLegacySupport = {}


---@class ILandscapeEditLayerRenderer : IInterface
local ILandscapeEditLayerRenderer = {}


---@class ILandscapeSplineInterface : IInterface
local ILandscapeSplineInterface = {}


---@class UControlPointMeshComponent : UStaticMeshComponent
---@field VirtualTextureMainPassMaxDrawDistance float
local UControlPointMeshComponent = {}



---@class ULandscapeComponent : UPrimitiveComponent
---@field SectionBaseX int32
---@field SectionBaseY int32
---@field ComponentSizeQuads int32
---@field SubsectionSizeQuads int32
---@field NumSubsections int32
---@field OverrideMaterial UMaterialInterface
---@field OverrideHoleMaterial UMaterialInterface
---@field MaterialInstances TArray<UMaterialInstanceConstant>
---@field MaterialInstancesDynamic TArray<UMaterialInstanceDynamic>
---@field LODIndexToMaterialIndex TArray<int8>
---@field XYOffsetmapTexture UTexture2D
---@field WeightmapScaleBias FVector4
---@field WeightmapSubsectionOffset float
---@field HeightmapScaleBias FVector4
---@field CachedLocalBox FBox
---@field MipToMipMaxDeltas TArray<double>
---@field CollisionComponentRef ULandscapeHeightfieldCollisionComponent
---@field bUserTriggeredChangeRequested boolean
---@field bNaniteActive boolean
---@field HeightmapTexture UTexture2D
---@field WeightmapLayerAllocations TArray<FWeightmapLayerAllocationInfo>
---@field WeightmapTextures TArray<UTexture2D>
---@field PerLODOverrideMaterials TArray<FLandscapePerLODMaterialOverride>
---@field GrassTypes TArray<ULandscapeGrassType>
---@field MapBuildDataId FGuid
---@field CollisionMipLevel int32
---@field SimpleCollisionMipLevel int32
---@field NegativeZBoundsExtension float
---@field PositiveZBoundsExtension float
---@field StaticLightingResolution float
---@field ForcedLOD int32
---@field LODBias int32
---@field StateId FGuid
---@field MobileMaterialInterfaces TArray<UMaterialInterface>
---@field MobileWeightmapTextures TArray<UTexture2D>
---@field MobileWeightmapTextureArray UTexture2DArray
---@field MobileWeightmapLayerAllocations TArray<FWeightmapLayerAllocationInfo>
local ULandscapeComponent = {}

---@param InLODBias int32
function ULandscapeComponent:SetLODBias(InLODBias) end
---@param InForcedLOD int32
function ULandscapeComponent:SetForcedLOD(InForcedLOD) end
---@param InIndex int32
---@return UMaterialInstanceDynamic
function ULandscapeComponent:GetMaterialInstanceDynamic(InIndex) end
---@param InLocation FVector
---@param InPaintLayerName FName
---@return float
function ULandscapeComponent:EditorGetPaintLayerWeightByNameAtLocation(InLocation, InPaintLayerName) end
---@param InLocation FVector
---@param PaintLayer ULandscapeLayerInfoObject
---@return float
function ULandscapeComponent:EditorGetPaintLayerWeightAtLocation(InLocation, PaintLayer) end


---@class ULandscapeDefaultEditLayerRenderer : UObject
local ULandscapeDefaultEditLayerRenderer = {}


---@class ULandscapeEditLayer : ULandscapeEditLayerPersistent
local ULandscapeEditLayer = {}


---@class ULandscapeEditLayerBase : UObject
---@field OwningLandscape TWeakObjectPtr<ALandscape>
local ULandscapeEditLayerBase = {}



---@class ULandscapeEditLayerPersistent : ULandscapeEditLayerBase
local ULandscapeEditLayerPersistent = {}


---@class ULandscapeEditLayerProcedural : ULandscapeEditLayerBase
local ULandscapeEditLayerProcedural = {}


---@class ULandscapeEditLayerSplines : ULandscapeEditLayerPersistent
local ULandscapeEditLayerSplines = {}


---@class ULandscapeEditResourcesSubsystem : UEngineSubsystem
---@field ScratchRenderTargets TArray<ULandscapeScratchRenderTarget>
local ULandscapeEditResourcesSubsystem = {}



---@class ULandscapeGizmoRenderComponent : UPrimitiveComponent
local ULandscapeGizmoRenderComponent = {}


---@class ULandscapeGrassType : UObject
---@field GrassVarieties TArray<FGrassVariety>
---@field bEnableDensityScaling boolean
---@field StateHash uint32
---@field GrassMesh UStaticMesh
---@field GrassDensity float
---@field PlacementJitter float
---@field StartCullDistance int32
---@field EndCullDistance int32
---@field RandomRotation boolean
---@field AlignToSurface boolean
local ULandscapeGrassType = {}



---@class ULandscapeHLODBuilder : UHLODBuilder
local ULandscapeHLODBuilder = {}


---@class ULandscapeHeightfieldCollisionComponent : UPrimitiveComponent
---@field ComponentLayerInfos TArray<ULandscapeLayerInfoObject>
---@field SectionBaseX int32
---@field SectionBaseY int32
---@field CollisionSizeQuads int32
---@field CollisionScale float
---@field SimpleCollisionSizeQuads int32
---@field CollisionQuadFlags TArray<uint8>
---@field HeightfieldGuid FGuid
---@field CachedLocalBox FBox
---@field RenderComponentRef ULandscapeComponent
---@field CookedPhysicalMaterials TArray<UPhysicalMaterial>
local ULandscapeHeightfieldCollisionComponent = {}

---@return ULandscapeComponent
function ULandscapeHeightfieldCollisionComponent:GetRenderComponent() end


---@class ULandscapeHeightmapNormalsEditLayerRenderer : UObject
local ULandscapeHeightmapNormalsEditLayerRenderer = {}


---@class ULandscapeInfo : UObject
---@field LandscapeActor TWeakObjectPtr<ALandscape>
---@field LandscapeGuid FGuid
---@field ComponentSizeQuads int32
---@field SubsectionSizeQuads int32
---@field ComponentNumSubsections int32
---@field StreamingProxies TArray<TWeakObjectPtr<ALandscapeStreamingProxy>>
local ULandscapeInfo = {}



---@class ULandscapeInfoMap : UObject
local ULandscapeInfoMap = {}


---@class ULandscapeLODStreamingProxy_DEPRECATED : UStreamableRenderAsset
local ULandscapeLODStreamingProxy_DEPRECATED = {}


---@class ULandscapeLayerInfoObject : UObject
---@field LayerName FName
---@field PhysMaterial UPhysicalMaterial
---@field Hardness float
---@field LayerUsageDebugColor FLinearColor
local ULandscapeLayerInfoObject = {}



---@class ULandscapeMaterialInstanceConstant : UMaterialInstanceConstant
---@field TextureStreamingInfo TArray<FLandscapeMaterialTextureStreamingInfo>
---@field bIsLayerThumbnail boolean
---@field bDisableTessellation boolean
---@field bMobile boolean
---@field bEditorToolUsage boolean
local ULandscapeMaterialInstanceConstant = {}



---@class ULandscapeMeshCollisionComponent : ULandscapeHeightfieldCollisionComponent
---@field MeshGuid FGuid
local ULandscapeMeshCollisionComponent = {}



---@class ULandscapeMeshProxyComponent : UStaticMeshComponent
---@field LandscapeGuid FGuid
---@field ProxyComponentBases TArray<FIntPoint>
---@field ProxyComponentCentersObjectSpace TArray<FVector>
---@field ComponentXVectorObjectSpace FVector
---@field ComponentYVectorObjectSpace FVector
---@field ComponentResolution int32
---@field ProxyLOD int8
---@field LODGroupKey uint32
local ULandscapeMeshProxyComponent = {}



---@class ULandscapeNaniteComponent : UStaticMeshComponent
---@field ProxyContentId FGuid
---@field bEnabled boolean
---@field SourceLandscapeComponents TArray<ULandscapeComponent>
local ULandscapeNaniteComponent = {}



---@class ULandscapeScratchRenderTarget : UObject
---@field RenderTarget UTextureRenderTarget
local ULandscapeScratchRenderTarget = {}



---@class ULandscapeSettings : UDeveloperSettings
---@field MaxNumberOfLayers int32
---@field bShowDialogForAutomaticLayerCreation boolean
---@field MaxComponents int32
---@field MaxImageImportCacheSizeMegaBytes uint32
---@field PaintStrengthGamma float
---@field bDisablePaintingStartupSlowdown boolean
---@field LandscapeDirtyingMode ELandscapeDirtyingMode
---@field SideResolutionLimit int32
---@field DefaultLandscapeMaterial TSoftObjectPtr<UMaterialInterface>
---@field DefaultLayerInfoObject TSoftObjectPtr<ULandscapeLayerInfoObject>
---@field BrushSizeUIMax float
---@field BrushSizeClampMax float
---@field HLODMaxTextureSize int32
---@field bRestrictiveMode boolean
local ULandscapeSettings = {}



---@class ULandscapeSplineControlPoint : UObject
---@field Location FVector
---@field Rotation FRotator
---@field Width float
---@field LayerWidthRatio float
---@field SideFalloff float
---@field LeftSideFalloffFactor float
---@field RightSideFalloffFactor float
---@field LeftSideLayerFalloffFactor float
---@field RightSideLayerFalloffFactor float
---@field EndFalloff float
---@field ConnectedSegments TArray<FLandscapeSplineConnection>
---@field Points TArray<FLandscapeSplineInterpPoint>
---@field Bounds FBox
---@field LocalMeshComponent UControlPointMeshComponent
local ULandscapeSplineControlPoint = {}



---@class ULandscapeSplineSegment : UObject
---@field Connections FLandscapeSplineSegmentConnection
---@field SplineInfo FInterpCurveVector
---@field Points TArray<FLandscapeSplineInterpPoint>
---@field Bounds FBox
---@field LocalMeshComponents TArray<USplineMeshComponent>
local ULandscapeSplineSegment = {}



---@class ULandscapeSplinesComponent : UPrimitiveComponent
---@field ControlPoints TArray<ULandscapeSplineControlPoint>
---@field Segments TArray<ULandscapeSplineSegment>
---@field CookedForeignMeshComponents TArray<UMeshComponent>
local ULandscapeSplinesComponent = {}

---@return TArray<USplineMeshComponent>
function ULandscapeSplinesComponent:GetSplineMeshComponents() end


---@class ULandscapeSubsystem : UTickableWorldSubsystem
---@field LandscapeActors TArray<ALandscape>
---@field Proxies TArray<ALandscapeProxy>
local ULandscapeSubsystem = {}



---@class ULandscapeTextureStorageProviderFactory : UTextureAllMipDataProviderFactory
local ULandscapeTextureStorageProviderFactory = {}


---@class ULandscapeWeightmapUsage : UObject
---@field ChannelUsage ULandscapeComponent
---@field LayerGuid FGuid
local ULandscapeWeightmapUsage = {}



---@class ULandscapeWeightmapWeightBlendedLayersRenderer : UObject
local ULandscapeWeightmapWeightBlendedLayersRenderer = {}


---@class UMaterialExpressionLandscapeGrassOutput : UMaterialExpressionCustomOutput
---@field GrassTypes TArray<FGrassInput>
local UMaterialExpressionLandscapeGrassOutput = {}



---@class UMaterialExpressionLandscapeLayerBlend : UMaterialExpression
---@field Layers TArray<FLayerBlendInput>
local UMaterialExpressionLandscapeLayerBlend = {}



---@class UMaterialExpressionLandscapeLayerCoords : UMaterialExpression
---@field MappingType ETerrainCoordMappingType
---@field CustomUVType ELandscapeCustomizedCoordType
---@field MappingScale float
---@field MappingRotation float
---@field MappingPanU float
---@field MappingPanV float
local UMaterialExpressionLandscapeLayerCoords = {}



---@class UMaterialExpressionLandscapeLayerSample : UMaterialExpression
---@field ParameterName FName
---@field PreviewWeight float
local UMaterialExpressionLandscapeLayerSample = {}



---@class UMaterialExpressionLandscapeLayerSwitch : UMaterialExpression
---@field LayerUsed FExpressionInput
---@field LayerNotUsed FExpressionInput
---@field ParameterName FName
---@field PreviewUsed boolean
local UMaterialExpressionLandscapeLayerSwitch = {}



---@class UMaterialExpressionLandscapeLayerWeight : UMaterialExpression
---@field base FExpressionInput
---@field Layer FExpressionInput
---@field ParameterName FName
---@field PreviewWeight float
---@field ConstBase FVector
local UMaterialExpressionLandscapeLayerWeight = {}



---@class UMaterialExpressionLandscapePhysicalMaterialOutput : UMaterialExpressionCustomOutput
---@field Inputs TArray<FPhysicalMaterialInput>
local UMaterialExpressionLandscapePhysicalMaterialOutput = {}



---@class UMaterialExpressionLandscapeVisibilityMask : UMaterialExpression
local UMaterialExpressionLandscapeVisibilityMask = {}


