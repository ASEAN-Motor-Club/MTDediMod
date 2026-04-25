---@meta

---@class AGeometryCollectionActor : AActor
---@field GeometryCollectionComponent UGeometryCollectionComponent
---@field GeometryCollectionDebugDrawComponent UGeometryCollectionDebugDrawComponent
local AGeometryCollectionActor = {}

---@param Start FVector
---@param End FVector
---@param OutHit FHitResult
---@return boolean
function AGeometryCollectionActor:RaycastSingle(Start, End, OutHit) end


---@class AGeometryCollectionDebugDrawActor : AActor
---@field WarningMessage FGeometryCollectionDebugDrawWarningMessage
---@field SelectedRigidBody FGeometryCollectionDebugDrawActorSelectedRigidBody
---@field bDebugDrawWholeCollection boolean
---@field bDebugDrawHierarchy boolean
---@field bDebugDrawClustering boolean
---@field HideGeometry EGeometryCollectionDebugDrawActorHideGeometry
---@field bShowRigidBodyId boolean
---@field bShowRigidBodyCollision boolean
---@field bCollisionAtOrigin boolean
---@field bShowRigidBodyTransform boolean
---@field bShowRigidBodyInertia boolean
---@field bShowRigidBodyVelocity boolean
---@field bShowRigidBodyForce boolean
---@field bShowRigidBodyInfos boolean
---@field bShowTransformIndex boolean
---@field bShowTransform boolean
---@field bShowParent boolean
---@field bShowLevel boolean
---@field bShowConnectivityEdges boolean
---@field bShowGeometryIndex boolean
---@field bShowGeometryTransform boolean
---@field bShowBoundingBox boolean
---@field bShowFaces boolean
---@field bShowFaceIndices boolean
---@field bShowFaceNormals boolean
---@field bShowSingleFace boolean
---@field SingleFaceIndex int32
---@field bShowVertices boolean
---@field bShowVertexIndices boolean
---@field bShowVertexNormals boolean
---@field bUseActiveVisualization boolean
---@field PointThickness float
---@field LineThickness float
---@field bTextShadow boolean
---@field TextScale float
---@field NormalScale float
---@field AxisScale float
---@field ArrowScale float
---@field RigidBodyIdColor FColor
---@field RigidBodyTransformScale float
---@field RigidBodyCollisionColor FColor
---@field RigidBodyInertiaColor FColor
---@field RigidBodyVelocityColor FColor
---@field RigidBodyForceColor FColor
---@field RigidBodyInfoColor FColor
---@field TransformIndexColor FColor
---@field TransformScale float
---@field LevelColor FColor
---@field ParentColor FColor
---@field ConnectivityEdgeThickness float
---@field GeometryIndexColor FColor
---@field GeometryTransformScale float
---@field BoundingBoxColor FColor
---@field FaceColor FColor
---@field FaceIndexColor FColor
---@field FaceNormalColor FColor
---@field SingleFaceColor FColor
---@field VertexColor FColor
---@field VertexIndexColor FColor
---@field VertexNormalColor FColor
---@field SpriteComponent UBillboardComponent
local AGeometryCollectionDebugDrawActor = {}



---@class AGeometryCollectionISMPoolActor : AActor
---@field ISMPoolComp UGeometryCollectionISMPoolComponent
---@field ISMPoolDebugDrawComp UGeometryCollectionISMPoolDebugDrawComponent
local AGeometryCollectionISMPoolActor = {}



---@class AGeometryCollectionRenderLevelSetActor : AActor
---@field TargetVolumeTexture UVolumeTexture
---@field RayMarchMaterial UMaterial
---@field SurfaceTolerance float
---@field Isovalue float
---@field Enabled boolean
---@field RenderVolumeBoundingBox boolean
local AGeometryCollectionRenderLevelSetActor = {}



---@class FChaosBreakingEventData
---@field Location FVector
---@field Velocity FVector
---@field Mass float
local FChaosBreakingEventData = {}



---@class FChaosBreakingEventRequestSettings
---@field MaxNumberOfResults int32
---@field MinRadius float
---@field MinSpeed float
---@field MinMass float
---@field MaxDistance float
---@field SortMethod EChaosBreakingSortMethod
local FChaosBreakingEventRequestSettings = {}



---@class FChaosCollisionEventData
---@field Location FVector
---@field Normal FVector
---@field Velocity1 FVector
---@field Velocity2 FVector
---@field Mass1 float
---@field Mass2 float
---@field Impulse FVector
local FChaosCollisionEventData = {}



---@class FChaosCollisionEventRequestSettings
---@field MaxNumberResults int32
---@field MinMass float
---@field MinSpeed float
---@field MinImpulse float
---@field MaxDistance float
---@field SortMethod EChaosCollisionSortMethod
local FChaosCollisionEventRequestSettings = {}



---@class FChaosRemovalEventData
---@field Location FVector
---@field Mass float
---@field ParticleIndex int32
local FChaosRemovalEventData = {}



---@class FChaosRemovalEventRequestSettings
---@field MaxNumberOfResults int32
---@field MinMass float
---@field MaxDistance float
---@field SortMethod EChaosRemovalSortMethod
local FChaosRemovalEventRequestSettings = {}



---@class FChaosTrailingEventData
---@field Location FVector
---@field Velocity FVector
---@field AngularVelocity FVector
---@field Mass float
---@field ParticleIndex int32
local FChaosTrailingEventData = {}



---@class FChaosTrailingEventRequestSettings
---@field MaxNumberOfResults int32
---@field MinMass float
---@field MinSpeed float
---@field MinAngularSpeed float
---@field MaxDistance float
---@field SortMethod EChaosTrailingSortMethod
local FChaosTrailingEventRequestSettings = {}



---@class FGeomComponentCacheParameters
---@field CacheMode EGeometryCollectionCacheType
---@field TargetCache UGeometryCollectionCache
---@field ReverseCacheBeginTime float
---@field SaveCollisionData boolean
---@field DoGenerateCollisionData boolean
---@field CollisionDataSizeMax int32
---@field DoCollisionDataSpatialHash boolean
---@field CollisionDataSpatialHashRadius float
---@field MaxCollisionPerCell int32
---@field SaveBreakingData boolean
---@field DoGenerateBreakingData boolean
---@field BreakingDataSizeMax int32
---@field DoBreakingDataSpatialHash boolean
---@field BreakingDataSpatialHashRadius float
---@field MaxBreakingPerCell int32
---@field SaveTrailingData boolean
---@field DoGenerateTrailingData boolean
---@field TrailingDataSizeMax int32
---@field TrailingMinSpeedThreshold float
---@field TrailingMinVolumeThreshold float
local FGeomComponentCacheParameters = {}



---@class FGeometryCollectionAutoInstanceMesh
---@field Mesh UStaticMesh
---@field Materials TArray<UMaterialInterface>
---@field NumInstances int32
---@field CustomData TArray<float>
local FGeometryCollectionAutoInstanceMesh = {}



---@class FGeometryCollectionCollisionParticleData
---@field CollisionParticlesFraction float
---@field MaximumCollisionParticles int32
local FGeometryCollectionCollisionParticleData = {}



---@class FGeometryCollectionCollisionTypeData
---@field CollisionType ECollisionTypeEnum
---@field ImplicitType EImplicitTypeEnum
---@field LevelSet FGeometryCollectionLevelSetData
---@field CollisionParticles FGeometryCollectionCollisionParticleData
---@field CollisionObjectReductionPercentage float
---@field CollisionMarginFraction float
local FGeometryCollectionCollisionTypeData = {}



---@class FGeometryCollectionDamagePropagationData
---@field bEnabled boolean
---@field BreakDamagePropagationFactor float
---@field ShockDamagePropagationFactor float
local FGeometryCollectionDamagePropagationData = {}



---@class FGeometryCollectionDebugDrawActorSelectedRigidBody
---@field ID int32
---@field Solver AChaosSolverActor
---@field GeometryCollection AGeometryCollectionActor
local FGeometryCollectionDebugDrawActorSelectedRigidBody = {}



---@class FGeometryCollectionDebugDrawWarningMessage
local FGeometryCollectionDebugDrawWarningMessage = {}


---@class FGeometryCollectionEmbeddedExemplar
---@field StaticMeshExemplar FSoftObjectPath
---@field StartCullDistance float
---@field EndCullDistance float
---@field InstanceCount int32
local FGeometryCollectionEmbeddedExemplar = {}



---@class FGeometryCollectionLevelSetData
---@field MinLevelSetResolution int32
---@field MaxLevelSetResolution int32
---@field MinClusterLevelSetResolution int32
---@field MaxClusterLevelSetResolution int32
local FGeometryCollectionLevelSetData = {}



---@class FGeometryCollectionProxyMeshData
---@field ProxyMeshes TArray<UStaticMesh>
local FGeometryCollectionProxyMeshData = {}



---@class FGeometryCollectionRenderResourceSizeInfo
---@field MeshResourcesSize uint64
---@field NaniteResourcesSize uint64
local FGeometryCollectionRenderResourceSizeInfo = {}



---@class FGeometryCollectionRepData
local FGeometryCollectionRepData = {}


---@class FGeometryCollectionRepDynamicData
local FGeometryCollectionRepDynamicData = {}


---@class FGeometryCollectionRepStateData
local FGeometryCollectionRepStateData = {}


---@class FGeometryCollectionSizeSpecificData
---@field MaxSize float
---@field CollisionShapes TArray<FGeometryCollectionCollisionTypeData>
---@field DamageThreshold int32
local FGeometryCollectionSizeSpecificData = {}



---@class FGeometryCollectionSource
---@field SourceGeometryObject FSoftObjectPath
---@field LocalTransform FTransform
---@field SourceMaterial TArray<UMaterialInterface>
---@field InstanceCustomData TArray<float>
---@field bAddInternalMaterials boolean
---@field bSplitComponents boolean
---@field bSetInternalFromMaterialIndex boolean
local FGeometryCollectionSource = {}



---@class IGeometryCollectionCustomDataInterface : IInterface
local IGeometryCollectionCustomDataInterface = {}


---@class IGeometryCollectionExternalRenderInterface : IInterface
local IGeometryCollectionExternalRenderInterface = {}


---@class UChaosDestructionListener : USceneComponent
---@field bIsCollisionEventListeningEnabled boolean
---@field bIsBreakingEventListeningEnabled boolean
---@field bIsTrailingEventListeningEnabled boolean
---@field bIsRemovalEventListeningEnabled boolean
---@field CollisionEventRequestSettings FChaosCollisionEventRequestSettings
---@field BreakingEventRequestSettings FChaosBreakingEventRequestSettings
---@field TrailingEventRequestSettings FChaosTrailingEventRequestSettings
---@field RemovalEventRequestSettings FChaosRemovalEventRequestSettings
---@field ChaosSolverActors TSet<AChaosSolverActor>
---@field GeometryCollectionActors TSet<AGeometryCollectionActor>
---@field OnCollisionEvents FChaosDestructionListenerOnCollisionEvents
---@field OnBreakingEvents FChaosDestructionListenerOnBreakingEvents
---@field OnTrailingEvents FChaosDestructionListenerOnTrailingEvents
---@field OnRemovalEvents FChaosDestructionListenerOnRemovalEvents
local UChaosDestructionListener = {}

---@param TrailingEvents TArray<FChaosTrailingEventData>
---@param SortMethod EChaosTrailingSortMethod
function UChaosDestructionListener:SortTrailingEvents(TrailingEvents, SortMethod) end
---@param RemovalEvents TArray<FChaosRemovalEventData>
---@param SortMethod EChaosRemovalSortMethod
function UChaosDestructionListener:SortRemovalEvents(RemovalEvents, SortMethod) end
---@param CollisionEvents TArray<FChaosCollisionEventData>
---@param SortMethod EChaosCollisionSortMethod
function UChaosDestructionListener:SortCollisionEvents(CollisionEvents, SortMethod) end
---@param BreakingEvents TArray<FChaosBreakingEventData>
---@param SortMethod EChaosBreakingSortMethod
function UChaosDestructionListener:SortBreakingEvents(BreakingEvents, SortMethod) end
---@param InSettings FChaosTrailingEventRequestSettings
function UChaosDestructionListener:SetTrailingEventRequestSettings(InSettings) end
---@param bIsEnabled boolean
function UChaosDestructionListener:SetTrailingEventEnabled(bIsEnabled) end
---@param InSettings FChaosRemovalEventRequestSettings
function UChaosDestructionListener:SetRemovalEventRequestSettings(InSettings) end
---@param bIsEnabled boolean
function UChaosDestructionListener:SetRemovalEventEnabled(bIsEnabled) end
---@param InSettings FChaosCollisionEventRequestSettings
function UChaosDestructionListener:SetCollisionEventRequestSettings(InSettings) end
---@param bIsEnabled boolean
function UChaosDestructionListener:SetCollisionEventEnabled(bIsEnabled) end
---@param InSettings FChaosBreakingEventRequestSettings
function UChaosDestructionListener:SetBreakingEventRequestSettings(InSettings) end
---@param bIsEnabled boolean
function UChaosDestructionListener:SetBreakingEventEnabled(bIsEnabled) end
---@param GeometryCollectionActor AGeometryCollectionActor
function UChaosDestructionListener:RemoveGeometryCollectionActor(GeometryCollectionActor) end
---@param ChaosSolverActor AChaosSolverActor
function UChaosDestructionListener:RemoveChaosSolverActor(ChaosSolverActor) end
---@return boolean
function UChaosDestructionListener:IsEventListening() end
---@param GeometryCollectionActor AGeometryCollectionActor
function UChaosDestructionListener:AddGeometryCollectionActor(GeometryCollectionActor) end
---@param ChaosSolverActor AChaosSolverActor
function UChaosDestructionListener:AddChaosSolverActor(ChaosSolverActor) end


---@class UGeometryCollection : UObject
---@field EnableClustering boolean
---@field ClusterGroupIndex int32
---@field MaxClusterLevel int32
---@field DamageModel EDamageModelTypeEnum
---@field DamageThreshold TArray<float>
---@field bUseSizeSpecificDamageThreshold boolean
---@field bUseMaterialDamageModifiers boolean
---@field PerClusterOnlyDamageThreshold boolean
---@field DamagePropagationData FGeometryCollectionDamagePropagationData
---@field ClusterConnectionType EClusterConnectionTypeEnum
---@field ConnectionGraphBoundsFilteringMargin float
---@field Materials TArray<UMaterialInterface>
---@field EmbeddedGeometryExemplar TArray<FGeometryCollectionEmbeddedExemplar>
---@field bUseFullPrecisionUVs boolean
---@field bStripOnCook boolean
---@field bStripRenderDataOnCook boolean
---@field CustomRendererType UClass
---@field RootProxyData FGeometryCollectionProxyMeshData
---@field AutoInstanceMeshes TArray<FGeometryCollectionAutoInstanceMesh>
---@field EnableNanite boolean
---@field bEnableNaniteFallback boolean
---@field bConvertVertexColorsToSRGB boolean
---@field PhysicsMaterial UPhysicalMaterial
---@field bDensityFromPhysicsMaterial boolean
---@field CachedDensityFromPhysicsMaterialInGCm3 float
---@field bMassAsDensity boolean
---@field Mass float
---@field MinimumMassClamp float
---@field bImportCollisionFromSource boolean
---@field bOptimizeConvexes boolean
---@field bScaleOnRemoval boolean
---@field bRemoveOnMaxSleep boolean
---@field MaximumSleepTime FVector2D
---@field RemovalDuration FVector2D
---@field bSlowMovingAsSleeping boolean
---@field SlowMovingVelocityThreshold float
---@field SizeSpecificData TArray<FGeometryCollectionSizeSpecificData>
---@field EnableRemovePiecesOnFracture boolean
---@field RemoveOnFractureMaterials TArray<UMaterialInterface>
---@field DataflowAsset UDataflow
---@field DataflowTerminal FString
---@field Overrides TMap<FString, FString>
---@field PersistentGuid FGuid
---@field StateGuid FGuid
---@field RootIndex int32
---@field BreadthFirstTransformIndices TArray<int32>
---@field AutoInstanceTransformRemapIndices TArray<int32>
---@field BoneSelectedMaterialIndex int32
---@field AssetUserData TArray<UAssetUserData>
local UGeometryCollection = {}

---@param bValue boolean
function UGeometryCollection:SetEnableNanite(bValue) end
---@param bValue boolean
function UGeometryCollection:SetConvertVertexColorsToSRGB(bValue) end


---@class UGeometryCollectionBlueprintLibrary : UBlueprintFunctionLibrary
local UGeometryCollectionBlueprintLibrary = {}

---@param GeometryCollectionComponent UGeometryCollectionComponent
---@param CustomDataIndex int32
---@param CustomDataValue float
function UGeometryCollectionBlueprintLibrary:SetISMPoolCustomInstanceData(GeometryCollectionComponent, CustomDataIndex, CustomDataValue) end
---@param GeometryCollectionComponent UGeometryCollectionComponent
---@param CustomDataName FName
---@param CustomDataValue float
function UGeometryCollectionBlueprintLibrary:SetCustomInstanceDataByName(GeometryCollectionComponent, CustomDataName, CustomDataValue) end
---@param GeometryCollectionComponent UGeometryCollectionComponent
---@param CustomDataIndex int32
---@param CustomDataValue float
function UGeometryCollectionBlueprintLibrary:SetCustomInstanceDataByIndex(GeometryCollectionComponent, CustomDataIndex, CustomDataValue) end


---@class UGeometryCollectionCache : UObject
---@field RecordedData FRecordedTransformTrack
---@field SupportedCollection UGeometryCollection
---@field CompatibleCollectionState FGuid
local UGeometryCollectionCache = {}



---@class UGeometryCollectionComponent : UMeshComponent
---@field ChaosSolverActor AChaosSolverActor
---@field RestCollection UGeometryCollection
---@field InitializationFields TArray<AFieldSystemActor>
---@field Simulating boolean
---@field ObjectType EObjectStateTypeEnum
---@field GravityGroupIndex int32
---@field OneWayInteractionLevel int32
---@field bDensityFromPhysicsMaterial boolean
---@field bForceMotionBlur boolean
---@field EnableClustering boolean
---@field ClusterGroupIndex int32
---@field MaxClusterLevel int32
---@field MaxSimulatedLevel int32
---@field DamageModel EDamageModelTypeEnum
---@field DamageThreshold TArray<float>
---@field bUseSizeSpecificDamageThreshold boolean
---@field bUseMaterialDamageModifiers boolean
---@field DamagePropagationData FGeometryCollectionDamagePropagationData
---@field bEnableDamageFromCollision boolean
---@field bAllowRemovalOnSleep boolean
---@field bAllowRemovalOnBreak boolean
---@field bForceUpdateActiveTransforms boolean
---@field ClusterConnectionType EClusterConnectionTypeEnum
---@field CollisionGroup int32
---@field CollisionSampleFraction float
---@field LinearEtherDrag float
---@field PhysicalMaterial UChaosPhysicalMaterial
---@field InitialVelocityType EInitialVelocityTypeEnum
---@field InitialLinearVelocity FVector
---@field InitialAngularVelocity FVector
---@field PhysicalMaterialOverride UPhysicalMaterial
---@field CacheParameters FGeomComponentCacheParameters
---@field RestTransforms TArray<FTransform>
---@field NotifyGeometryCollectionPhysicsStateChange FGeometryCollectionComponentNotifyGeometryCollectionPhysicsStateChange
---@field NotifyGeometryCollectionPhysicsLoadingStateChange FGeometryCollectionComponentNotifyGeometryCollectionPhysicsLoadingStateChange
---@field OnChaosBreakEvent FGeometryCollectionComponentOnChaosBreakEvent
---@field OnChaosRemovalEvent FGeometryCollectionComponentOnChaosRemovalEvent
---@field OnChaosCrumblingEvent FGeometryCollectionComponentOnChaosCrumblingEvent
---@field DesiredCacheTime float
---@field CachePlayback boolean
---@field OnChaosPhysicsCollision FGeometryCollectionComponentOnChaosPhysicsCollision
---@field bNotifyBreaks boolean
---@field bNotifyCollisions boolean
---@field bNotifyTrailing boolean
---@field bNotifyRemovals boolean
---@field bNotifyCrumblings boolean
---@field bCrumblingEventIncludesChildren boolean
---@field bNotifyGlobalBreaks boolean
---@field bNotifyGlobalCollisions boolean
---@field bNotifyGlobalRemovals boolean
---@field bNotifyGlobalCrumblings boolean
---@field bGlobalCrumblingEventIncludesChildren boolean
---@field bStoreVelocities boolean
---@field bIsCurrentlyNavigationRelevant boolean
---@field bShowBoneColors boolean
---@field bUpdateComponentTransformToRootBone boolean
---@field bUseRootProxyForNavigation boolean
---@field bUpdateNavigationInTick boolean
---@field bEnableReplication boolean
---@field bEnableAbandonAfterLevel boolean
---@field AbandonedCollisionProfileName FName
---@field ISMPool AGeometryCollectionISMPoolActor
---@field CustomRendererType UClass
---@field bOverrideCustomRenderer boolean
---@field bAutoAssignISMPool boolean
---@field bUseStaticMeshCollisionForTraces boolean
---@field ReplicationAbandonClusterLevel int32
---@field CustomRenderer TScriptInterface<IGeometryCollectionExternalRenderInterface>
---@field CollisionProfilePerLevel TArray<FName>
---@field ReplicationAbandonAfterLevel int32
---@field ReplicationMaxPositionAndVelocityCorrectionLevel int32
---@field RepData FGeometryCollectionRepData
---@field RepStateData FGeometryCollectionRepStateData
---@field RepDynamicData FGeometryCollectionRepDynamicData
---@field DummyBodySetup UBodySetup
---@field EventDispatcher UChaosGameplayEventDispatcher
---@field EmbeddedGeometryComponents TArray<UInstancedStaticMeshComponent>
---@field AngularEtherDrag float
local UGeometryCollectionComponent = {}

---@param bInUseStaticMeshCollisionForTraces boolean
function UGeometryCollectionComponent:SetUseStaticMeshCollisionForTraces(bInUseStaticMeshCollisionForTraces) end
---@param bInUseMaterialDamageModifiers boolean
function UGeometryCollectionComponent:SetUseMaterialDamageModifiers(bInUseMaterialDamageModifiers) end
---@param InSolverActor AChaosSolverActor
function UGeometryCollectionComponent:SetSolverActor(InSolverActor) end
---@param Index int32
---@param RootProxyTransform FTransform
function UGeometryCollectionComponent:SetRootProxyComponentSpaceTransform(Index, RootProxyTransform) end
---@param RestCollectionIn UGeometryCollection
---@param bApplyAssetDefaults boolean
function UGeometryCollectionComponent:SetRestCollection(RestCollectionIn, bApplyAssetDefaults) end
---@param BoneIds TArray<int32>
---@param ProfileName FName
function UGeometryCollectionComponent:SetPerParticleCollisionProfileName(BoneIds, ProfileName) end
---@param ProfileNames TArray<FName>
function UGeometryCollectionComponent:SetPerLevelCollisionProfileNames(ProfileNames) end
---@param InOneWayInteractionLevel int32
function UGeometryCollectionComponent:SetOneWayInteractionLevel(InOneWayInteractionLevel) end
---@param bNewNotifyRemovals boolean
function UGeometryCollectionComponent:SetNotifyRemovals(bNewNotifyRemovals) end
---@param bNewNotifyGlobalRemovals boolean
function UGeometryCollectionComponent:SetNotifyGlobalRemovals(bNewNotifyGlobalRemovals) end
---@param bNewNotifyGlobalCrumblings boolean
---@param bGlobalNewCrumblingEventIncludesChildren boolean
function UGeometryCollectionComponent:SetNotifyGlobalCrumblings(bNewNotifyGlobalCrumblings, bGlobalNewCrumblingEventIncludesChildren) end
---@param bNewNotifyGlobalCollisions boolean
function UGeometryCollectionComponent:SetNotifyGlobalCollision(bNewNotifyGlobalCollisions) end
---@param bNewNotifyGlobalBreaks boolean
function UGeometryCollectionComponent:SetNotifyGlobalBreaks(bNewNotifyGlobalBreaks) end
---@param bNewNotifyCrumblings boolean
---@param bNewCrumblingEventIncludesChildren boolean
function UGeometryCollectionComponent:SetNotifyCrumblings(bNewNotifyCrumblings, bNewCrumblingEventIncludesChildren) end
---@param bNewNotifyBreaks boolean
function UGeometryCollectionComponent:SetNotifyBreaks(bNewNotifyBreaks) end
---@param Transforms TArray<FTransform>
---@param bOnlyLeaves boolean
function UGeometryCollectionComponent:SetLocalRestTransforms(Transforms, bOnlyLeaves) end
---@param InGravityGroupIndex int32
function UGeometryCollectionComponent:SetGravityGroupIndex(InGravityGroupIndex) end
---@param bValue boolean
function UGeometryCollectionComponent:SetEnableDamageFromCollision(bValue) end
---@param bInDensityFromPhysicsMaterial boolean
function UGeometryCollectionComponent:SetDensityFromPhysicsMaterial(bInDensityFromPhysicsMaterial) end
---@param InDamageThreshold TArray<float>
function UGeometryCollectionComponent:SetDamageThreshold(InDamageThreshold) end
---@param InDamagePropagationData FGeometryCollectionDamagePropagationData
function UGeometryCollectionComponent:SetDamagePropagationData(InDamagePropagationData) end
---@param InDamageModel EDamageModelTypeEnum
function UGeometryCollectionComponent:SetDamageModel(InDamageModel) end
---@param Box FBox
---@param Transform FTransform
---@param bAnchored boolean
---@param MaxLevel int32
function UGeometryCollectionComponent:SetAnchoredByTransformedBox(Box, Transform, bAnchored, MaxLevel) end
---@param Index int32
---@param bAnchored boolean
function UGeometryCollectionComponent:SetAnchoredByIndex(Index, bAnchored) end
---@param WorldSpaceBox FBox
---@param bAnchored boolean
---@param MaxLevel int32
function UGeometryCollectionComponent:SetAnchoredByBox(WorldSpaceBox, bAnchored, MaxLevel) end
---@param CollisionProfile FName
function UGeometryCollectionComponent:SetAbandonedParticleCollisionProfileName(CollisionProfile) end
function UGeometryCollectionComponent:RemoveAllAnchors() end
---@param CollisionInfo FChaosPhysicsCollisionInfo
function UGeometryCollectionComponent:ReceivePhysicsCollision(CollisionInfo) end
function UGeometryCollectionComponent:OnRep_RepStateData() end
function UGeometryCollectionComponent:OnRep_RepDynamicData() end
function UGeometryCollectionComponent:OnRep_RepData() end
---@param FracturedComponent UGeometryCollectionComponent
function UGeometryCollectionComponent:NotifyGeometryCollectionPhysicsStateChange__DelegateSignature(FracturedComponent) end
---@param FracturedComponent UGeometryCollectionComponent
function UGeometryCollectionComponent:NotifyGeometryCollectionPhysicsLoadingStateChange__DelegateSignature(FracturedComponent) end
---@return boolean
function UGeometryCollectionComponent:IsRootBroken() end
---@return boolean
function UGeometryCollectionComponent:GetUseStaticMeshCollisionForTraces() end
---@return AChaosSolverActor
function UGeometryCollectionComponent:GetSolverActor() end
---@return FTransform
function UGeometryCollectionComponent:GetRootInitialTransform() end
---@return int32
function UGeometryCollectionComponent:GetRootIndex() end
---@return FTransform
function UGeometryCollectionComponent:GetRootCurrentTransform() end
---@param ItemIndex int32
---@param OutMass float
---@param OutExtents FBox
function UGeometryCollectionComponent:GetMassAndExtents(ItemIndex, OutMass, OutExtents) end
---@param bInitialTransforms boolean
---@return TArray<FTransform>
function UGeometryCollectionComponent:GetLocalRestTransforms(bInitialTransforms) end
---@return FBox
function UGeometryCollectionComponent:GetLocalBounds() end
---@return TArray<FTransform>
function UGeometryCollectionComponent:GetInitialLocalRestTransforms() end
---@param ItemIndex int32
---@return int32
function UGeometryCollectionComponent:GetInitialLevel(ItemIndex) end
---@return FString
function UGeometryCollectionComponent:GetDebugInfo() end
---@return TArray<float>
function UGeometryCollectionComponent:GetDamageThreshold() end
---@param bForceBroken boolean
function UGeometryCollectionComponent:ForceBrokenForCustomRenderer(bForceBroken) end
---@param bEnable boolean
function UGeometryCollectionComponent:EnableRootProxyForCustomRenderer(bEnable) end
---@param ItemIndex int32
function UGeometryCollectionComponent:CrumbleCluster(ItemIndex) end
function UGeometryCollectionComponent:CrumbleActiveClusters() end
---@param Enabled boolean
---@param Target EGeometryCollectionPhysicsTypeEnum
---@param MetaData UFieldSystemMetaData
---@param Field UFieldNodeBase
function UGeometryCollectionComponent:ApplyPhysicsField(Enabled, Target, MetaData, Field) end
---@param ItemIndex int32
---@param LinearVelocity FVector
function UGeometryCollectionComponent:ApplyLinearVelocity(ItemIndex, LinearVelocity) end
---@param Radius float
---@param Position FVector
function UGeometryCollectionComponent:ApplyKinematicField(Radius, Position) end
---@param ItemIndex int32
---@param Location FVector
---@param Radius float
---@param PropagationDepth int32
---@param PropagationFactor float
---@param Strain float
function UGeometryCollectionComponent:ApplyInternalStrain(ItemIndex, Location, Radius, PropagationDepth, PropagationFactor, Strain) end
---@param ItemIndex int32
---@param Location FVector
---@param Radius float
---@param PropagationDepth int32
---@param PropagationFactor float
---@param Strain float
function UGeometryCollectionComponent:ApplyExternalStrain(ItemIndex, Location, Radius, PropagationDepth, PropagationFactor, Strain) end
---@param ItemIndex int32
---@param LinearVelocity FVector
function UGeometryCollectionComponent:ApplyBreakingLinearVelocity(ItemIndex, LinearVelocity) end
---@param ItemIndex int32
---@param AngularVelocity FVector
function UGeometryCollectionComponent:ApplyBreakingAngularVelocity(ItemIndex, AngularVelocity) end
function UGeometryCollectionComponent:ApplyAssetDefaults() end
---@param ItemIndex int32
---@param AngularVelocity FVector
function UGeometryCollectionComponent:ApplyAngularVelocity(ItemIndex, AngularVelocity) end


---@class UGeometryCollectionDebugDrawComponent : UActorComponent
---@field GeometryCollectionDebugDrawActor AGeometryCollectionDebugDrawActor
---@field GeometryCollectionRenderLevelSetActor AGeometryCollectionRenderLevelSetActor
local UGeometryCollectionDebugDrawComponent = {}



---@class UGeometryCollectionISMPoolComponent : USceneComponent
local UGeometryCollectionISMPoolComponent = {}


---@class UGeometryCollectionISMPoolDebugDrawComponent : UDebugDrawComponent
---@field bShowGlobalStats boolean
---@field bShowStats boolean
---@field bShowBounds boolean
---@field SelectedComponent UInstancedStaticMeshComponent
local UGeometryCollectionISMPoolDebugDrawComponent = {}



---@class UGeometryCollectionISMPoolRenderer : UObject
---@field CachedISMPoolComponent UGeometryCollectionISMPoolComponent
---@field LocalISMPoolComponent UGeometryCollectionISMPoolComponent
local UGeometryCollectionISMPoolRenderer = {}



---@class UGeometryCollectionISMPoolSubSystem : UWorldSubsystem
local UGeometryCollectionISMPoolSubSystem = {}

---@param InSource AActor
---@param Reason EEndPlayReason::Type
function UGeometryCollectionISMPoolSubSystem:OnActorEndPlay(InSource, Reason) end


---@class UGeometryCollectionRootProxyRenderer : UObject
---@field StaticMeshComponents TArray<UStaticMeshComponent>
local UGeometryCollectionRootProxyRenderer = {}



