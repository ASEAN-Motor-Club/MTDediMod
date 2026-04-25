---@meta

---@class AGroomActor : AActor
---@field GroomComponent UGroomComponent
local AGroomActor = {}



---@class FFollicleMaskOptions
---@field Groom UGroomAsset
---@field Channel EFollicleMaskChannel
local FFollicleMaskOptions = {}



---@class FGoomBindingGroupInfo
---@field RenRootCount int32
---@field RenLODCount int32
---@field SimRootCount int32
---@field SimLODCount int32
local FGoomBindingGroupInfo = {}



---@class FGroomAnimationInfo
---@field NumFrames uint32
---@field SecondsPerFrame float
---@field Duration float
---@field StartTime float
---@field EndTime float
---@field StartFrame int32
---@field EndFrame int32
---@field Attributes EGroomCacheAttributes
local FGroomAnimationInfo = {}



---@class FGroomBuildSettings
---@field bOverrideGuides boolean
---@field HairToGuideDensity float
---@field InterpolationQuality EGroomInterpolationQuality
---@field InterpolationDistance EGroomInterpolationWeight
---@field bRandomizeGuide boolean
---@field bUseUniqueGuide boolean
local FGroomBuildSettings = {}



---@class FGroomCacheImportSettings
---@field bImportGroomCache boolean
---@field ImportType EGroomCacheImportType
---@field FrameStart int32
---@field FrameEnd int32
---@field bSkipEmptyFrames boolean
---@field bImportGroomAsset boolean
---@field GroomAsset FSoftObjectPath
---@field bOverrideConversionSettings boolean
---@field ConversionSettings FGroomConversionSettings
local FGroomCacheImportSettings = {}



---@class FGroomCacheInfo
---@field Version int32
---@field Type EGroomCacheType
---@field AnimationInfo FGroomAnimationInfo
local FGroomCacheInfo = {}



---@class FGroomConversionSettings
---@field Rotation FVector
---@field Scale FVector
local FGroomConversionSettings = {}



---@class FGroomHairGroupPreview
---@field GroupName FName
---@field GroupID int32
---@field CurveCount int32
---@field GuideCount int32
---@field Attributes uint32
---@field AttributeFlags uint32
---@field Flags uint32
---@field InterpolationSettings FHairGroupsInterpolation
local FGroomHairGroupPreview = {}



---@class FHairAdvancedRenderingSettings
---@field bUseStableRasterization boolean
---@field bScatterSceneLighting boolean
local FHairAdvancedRenderingSettings = {}



---@class FHairBendConstraint
---@field SolveBend boolean
---@field ProjectBend boolean
---@field BendDamping float
---@field BendStiffness float
---@field BendScale FRuntimeFloatCurve
local FHairBendConstraint = {}



---@class FHairCollisionConstraint
---@field SolveCollision boolean
---@field ProjectCollision boolean
---@field StaticFriction float
---@field KineticFriction float
---@field StrandsViscosity float
---@field GridDimension FIntVector
---@field CollisionRadius float
---@field RadiusScale FRuntimeFloatCurve
local FHairCollisionConstraint = {}



---@class FHairDecimationSettings
---@field CurveDecimation float
---@field VertexDecimation float
local FHairDecimationSettings = {}



---@class FHairDeformationSettings
---@field bEnableRigging boolean
---@field NumCurves int32
---@field NumPoints int32
local FHairDeformationSettings = {}



---@class FHairExternalForces
---@field GravityVector FVector
---@field AirDrag float
---@field AirVelocity FVector
local FHairExternalForces = {}



---@class FHairGeometrySettings
---@field HairWidth float
---@field HairWidth_Override boolean
---@field HairRootScale float
---@field HairTipScale float
local FHairGeometrySettings = {}



---@class FHairGroupCardsInfo
---@field NumCards int32
---@field NumCardVertices int32
local FHairGroupCardsInfo = {}



---@class FHairGroupCardsTextures
---@field Layout EHairTextureLayout
---@field Textures TArray<UTexture2D>
---@field DepthTexture UTexture2D
---@field CoverageTexture UTexture2D
---@field TangentTexture UTexture2D
---@field AttributeTexture UTexture2D
---@field AuxilaryDataTexture UTexture2D
---@field MaterialTexture UTexture2D
local FHairGroupCardsTextures = {}



---@class FHairGroupDesc
---@field HairLength float
---@field HairWidth float
---@field HairWidth_Override boolean
---@field HairRootScale float
---@field HairRootScale_Override boolean
---@field HairTipScale float
---@field HairTipScale_Override boolean
---@field HairShadowDensity float
---@field HairShadowDensity_Override boolean
---@field HairRaytracingRadiusScale float
---@field HairRaytracingRadiusScale_Override boolean
---@field bUseHairRaytracingGeometry boolean
---@field bUseHairRaytracingGeometry_Override boolean
---@field LODBias float
---@field bUseStableRasterization boolean
---@field bUseStableRasterization_Override boolean
---@field bScatterSceneLighting boolean
---@field bScatterSceneLighting_Override boolean
---@field bSupportVoxelization boolean
---@field bSupportVoxelization_Override boolean
---@field HairLengthScale float
---@field HairLengthScale_Override boolean
local FHairGroupDesc = {}



---@class FHairGroupInfo
---@field GroupID int32
---@field GroupName FName
---@field NumCurves int32
---@field NumGuides int32
---@field NumCurveVertices int32
---@field NumGuideVertices int32
---@field MaxCurveLength float
---@field Flags uint32
---@field LODInfos TArray<FHairGroupLODInfo>
local FHairGroupInfo = {}



---@class FHairGroupInfoWithVisibility : FHairGroupInfo
---@field bIsVisible boolean
local FHairGroupInfoWithVisibility = {}



---@class FHairGroupLODInfo
---@field NumPoints int32
---@field NumCurves int32
local FHairGroupLODInfo = {}



---@class FHairGroupsCardsSourceDescription
---@field Material UMaterialInterface
---@field MaterialSlotName FName
---@field SourceType EHairCardsSourceType
---@field ProceduralMesh UStaticMesh
---@field bInvertUV boolean
---@field GuideType EHairCardsGuideType
---@field ImportedMesh UStaticMesh
---@field Textures FHairGroupCardsTextures
---@field GroupIndex int32
---@field LODIndex int32
---@field CardsInfo FHairGroupCardsInfo
---@field ImportedMeshKey FString
local FHairGroupsCardsSourceDescription = {}



---@class FHairGroupsInterpolation
---@field DecimationSettings FHairDecimationSettings
---@field InterpolationSettings FHairInterpolationSettings
---@field RiggingSettings FHairDeformationSettings
local FHairGroupsInterpolation = {}



---@class FHairGroupsLOD
---@field LODs TArray<FHairLODSettings>
local FHairGroupsLOD = {}



---@class FHairGroupsMaterial
---@field Material UMaterialInterface
---@field SlotName FName
local FHairGroupsMaterial = {}



---@class FHairGroupsMeshesSourceDescription
---@field Material UMaterialInterface
---@field MaterialSlotName FName
---@field ImportedMesh UStaticMesh
---@field Textures FHairGroupCardsTextures
---@field GroupIndex int32
---@field LODIndex int32
---@field ImportedMeshKey FString
local FHairGroupsMeshesSourceDescription = {}



---@class FHairGroupsPhysics
---@field SolverSettings FHairSolverSettings
---@field ExternalForces FHairExternalForces
---@field MaterialConstraints FHairMaterialConstraints
---@field StrandsParameters FHairStrandsParameters
local FHairGroupsPhysics = {}



---@class FHairGroupsRendering
---@field MaterialSlotName FName
---@field Material UMaterialInterface
---@field GeometrySettings FHairGeometrySettings
---@field ShadowSettings FHairShadowSettings
---@field AdvancedSettings FHairAdvancedRenderingSettings
local FHairGroupsRendering = {}



---@class FHairInterpolationSettings
---@field GuideType EGroomGuideType
---@field bOverrideGuides boolean
---@field HairToGuideDensity float
---@field RiggedGuideNumCurves int32
---@field RiggedGuideNumPoints int32
---@field InterpolationQuality EHairInterpolationQuality
---@field InterpolationDistance EHairInterpolationWeight
---@field bRandomizeGuide boolean
---@field bUseUniqueGuide boolean
local FHairInterpolationSettings = {}



---@class FHairLODSettings
---@field CurveDecimation float
---@field VertexDecimation float
---@field AngularThreshold float
---@field ScreenSize float
---@field ThicknessScale float
---@field bVisible boolean
---@field GeometryType EGroomGeometryType
---@field BindingType EGroomBindingType
---@field Simulation EGroomOverrideType
---@field GlobalInterpolation EGroomOverrideType
local FHairLODSettings = {}



---@class FHairMaterialConstraints
---@field BendConstraint FHairBendConstraint
---@field StretchConstraint FHairStretchConstraint
---@field CollisionConstraint FHairCollisionConstraint
local FHairMaterialConstraints = {}



---@class FHairShadowSettings
---@field HairShadowDensity float
---@field HairRaytracingRadiusScale float
---@field bUseHairRaytracingGeometry boolean
---@field bVoxelize boolean
local FHairShadowSettings = {}



---@class FHairSimulationConstraints
---@field BendDamping float
---@field BendStiffness float
---@field StretchDamping float
---@field StretchStiffness float
---@field StaticFriction float
---@field KineticFriction float
---@field StrandsViscosity float
---@field CollisionRadius float
local FHairSimulationConstraints = {}



---@class FHairSimulationForces
---@field GravityVector FVector
---@field AirDrag float
---@field AirVelocity FVector
local FHairSimulationForces = {}



---@class FHairSimulationSettings
---@field bOverrideSettings boolean
---@field SimulationSetup FHairSimulationSetup
---@field SolverSettings FHairSimulationSolver
---@field ExternalForces FHairSimulationForces
---@field MaterialConstraints FHairSimulationConstraints
local FHairSimulationSettings = {}



---@class FHairSimulationSetup
---@field bResetSimulation boolean
---@field bDebugSimulation boolean
---@field bLocalSimulation boolean
---@field LinearVelocityScale float
---@field AngularVelocityScale float
---@field LocalBone FString
---@field TeleportDistance float
local FHairSimulationSetup = {}



---@class FHairSimulationSolver
---@field bEnableSimulation boolean
local FHairSimulationSolver = {}



---@class FHairSolverSettings
---@field EnableSimulation boolean
---@field NiagaraSolver EGroomNiagaraSolvers
---@field CustomSystem TSoftObjectPtr<UNiagaraSystem>
---@field GravityPreloading float
---@field SubSteps int32
---@field IterationCount int32
---@field bForceVisible boolean
local FHairSolverSettings = {}



---@class FHairStrandsParameters
---@field StrandsSize EGroomStrandsSize
---@field StrandsDensity float
---@field StrandsSmoothing float
---@field StrandsThickness float
---@field ThicknessScale FRuntimeFloatCurve
local FHairStrandsParameters = {}



---@class FHairStretchConstraint
---@field SolveStretch boolean
---@field ProjectStretch boolean
---@field StretchDamping float
---@field StretchStiffness float
---@field StretchScale FRuntimeFloatCurve
local FHairStretchConstraint = {}



---@class FMovieSceneGroomCacheParams
---@field GroomCache UGroomCache
---@field FirstLoopStartFrameOffset FFrameNumber
---@field StartFrameOffset FFrameNumber
---@field EndFrameOffset FFrameNumber
---@field PlayRate float
---@field bReverse boolean
local FMovieSceneGroomCacheParams = {}



---@class FMovieSceneGroomCacheSectionTemplate : FMovieSceneEvalTemplate
---@field Params FMovieSceneGroomCacheSectionTemplateParameters
local FMovieSceneGroomCacheSectionTemplate = {}



---@class FMovieSceneGroomCacheSectionTemplateParameters : FMovieSceneGroomCacheParams
---@field SectionStartTime FFrameNumber
---@field SectionEndTime FFrameNumber
local FMovieSceneGroomCacheSectionTemplateParameters = {}



---@class UGroomAsset : UObject
---@field LODMode EGroomLODMode
---@field AutoLODBias float
---@field HairGroupsInfo TArray<FHairGroupInfoWithVisibility>
---@field HairGroupsRendering TArray<FHairGroupsRendering>
---@field HairGroupsPhysics TArray<FHairGroupsPhysics>
---@field HairGroupsInterpolation TArray<FHairGroupsInterpolation>
---@field HairGroupsLOD TArray<FHairGroupsLOD>
---@field HairGroupsCards TArray<FHairGroupsCardsSourceDescription>
---@field HairGroupsMeshes TArray<FHairGroupsMeshesSourceDescription>
---@field HairGroupsMaterials TArray<FHairGroupsMaterial>
---@field EnableGlobalInterpolation boolean
---@field EnableSimulationCache boolean
---@field HairInterpolationType EGroomInterpolationType
---@field RiggedSkeletalMesh USkeletalMesh
---@field DeformedGroupSections TArray<int32>
---@field MinLOD FPerPlatformInt
---@field DisableBelowMinLodStripping FPerPlatformBool
---@field EffectiveLODBias TArray<float>
---@field AssetUserData TArray<UAssetUserData>
local UGroomAsset = {}

---@param In USkeletalMesh
function UGroomAsset:SetRiggedSkeletalMesh(In) end
---@param In EGroomInterpolationType
function UGroomAsset:SetHairInterpolationType(In) end
---@param In TArray<FHairGroupsRendering>
function UGroomAsset:SetHairGroupsRendering(In) end
---@param In TArray<FHairGroupsPhysics>
function UGroomAsset:SetHairGroupsPhysics(In) end
---@param In TArray<FHairGroupsMeshesSourceDescription>
function UGroomAsset:SetHairGroupsMeshes(In) end
---@param In TArray<FHairGroupsMaterial>
function UGroomAsset:SetHairGroupsMaterials(In) end
---@param In TArray<FHairGroupsLOD>
function UGroomAsset:SetHairGroupsLOD(In) end
---@param In TArray<FHairGroupsInterpolation>
function UGroomAsset:SetHairGroupsInterpolation(In) end
---@param In TArray<FHairGroupsCardsSourceDescription>
function UGroomAsset:SetHairGroupsCards(In) end
---@param In boolean
function UGroomAsset:SetEnableSimulationCache(In) end
---@param In boolean
function UGroomAsset:SetEnableGlobalInterpolation(In) end
---@param In TArray<int32>
function UGroomAsset:SetDeformedGroupSections(In) end
---@return USkeletalMesh
function UGroomAsset:GetRiggedSkeletalMesh() end
---@return EGroomInterpolationType
function UGroomAsset:GetHairInterpolationType() end
---@return TArray<FHairGroupsRendering>
function UGroomAsset:GetHairGroupsRendering() end
---@return TArray<FHairGroupsPhysics>
function UGroomAsset:GetHairGroupsPhysics() end
---@return TArray<FHairGroupsMeshesSourceDescription>
function UGroomAsset:GetHairGroupsMeshes() end
---@return TArray<FHairGroupsMaterial>
function UGroomAsset:GetHairGroupsMaterials() end
---@return TArray<FHairGroupsLOD>
function UGroomAsset:GetHairGroupsLOD() end
---@return TArray<FHairGroupsInterpolation>
function UGroomAsset:GetHairGroupsInterpolation() end
---@return TArray<FHairGroupsCardsSourceDescription>
function UGroomAsset:GetHairGroupsCards() end
---@return boolean
function UGroomAsset:GetEnableSimulationCache() end
---@return boolean
function UGroomAsset:GetEnableGlobalInterpolation() end
---@return TArray<int32>
function UGroomAsset:GetDeformedGroupSections() end


---@class UGroomAssetImportData : UAssetImportData
---@field ImportOptions UGroomImportOptions
---@field HairStrandsTexturesOptions UGroomCreateStrandsTexturesOptions
local UGroomAssetImportData = {}



---@class UGroomBindingAsset : UObject
---@field GroomBindingType EGroomBindingMeshType
---@field Groom UGroomAsset
---@field SourceSkeletalMesh USkeletalMesh
---@field TargetSkeletalMesh USkeletalMesh
---@field SourceGeometryCache UGeometryCache
---@field TargetGeometryCache UGeometryCache
---@field NumInterpolationPoints int32
---@field MatchingSection int32
---@field GroupInfos TArray<FGoomBindingGroupInfo>
local UGroomBindingAsset = {}

---@param InSkeletalMesh USkeletalMesh
function UGroomBindingAsset:SetTargetSkeletalMesh(InSkeletalMesh) end
---@param InGeometryCache UGeometryCache
function UGroomBindingAsset:SetTargetGeometryCache(InGeometryCache) end
---@param InSkeletalMesh USkeletalMesh
function UGroomBindingAsset:SetSourceSkeletalMesh(InSkeletalMesh) end
---@param InGeometryCache UGeometryCache
function UGroomBindingAsset:SetSourceGeometryCache(InGeometryCache) end
---@param InNumInterpolationPoints int32
function UGroomBindingAsset:SetNumInterpolationPoints(InNumInterpolationPoints) end
---@param InMatchingSection int32
function UGroomBindingAsset:SetMatchingSection(InMatchingSection) end
---@param InGroupInfos TArray<FGoomBindingGroupInfo>
function UGroomBindingAsset:SetGroupInfos(InGroupInfos) end
---@param InGroomBindingType EGroomBindingMeshType
function UGroomBindingAsset:SetGroomBindingType(InGroomBindingType) end
---@param InGroom UGroomAsset
function UGroomBindingAsset:SetGroom(InGroom) end
---@return USkeletalMesh
function UGroomBindingAsset:GetTargetSkeletalMesh() end
---@return UGeometryCache
function UGroomBindingAsset:GetTargetGeometryCache() end
---@return USkeletalMesh
function UGroomBindingAsset:GetSourceSkeletalMesh() end
---@return UGeometryCache
function UGroomBindingAsset:GetSourceGeometryCache() end
---@return int32
function UGroomBindingAsset:GetNumInterpolationPoints() end
---@return int32
function UGroomBindingAsset:GetMatchingSection() end
---@return TArray<FGoomBindingGroupInfo>
function UGroomBindingAsset:GetGroupInfos() end
---@return EGroomBindingMeshType
function UGroomBindingAsset:GetGroomBindingType() end
---@return UGroomAsset
function UGroomBindingAsset:GetGroom() end


---@class UGroomBindingAssetList : UObject
---@field Bindings TArray<UGroomBindingAsset>
local UGroomBindingAssetList = {}



---@class UGroomBlueprintLibrary : UBlueprintFunctionLibrary
local UGroomBlueprintLibrary = {}

---@param WorldContextObject UObject
---@return boolean
function UGroomBlueprintLibrary:IsHairStrandsSupportedInWorld(WorldContextObject) end
---@param InDesiredPackagePath FString
---@param InGroomAsset UGroomAsset
---@param InSkeletalMesh USkeletalMesh
---@param InNumInterpolationPoints int32
---@param InSourceSkeletalMeshForTransfer USkeletalMesh
---@param InMatchingSection int32
---@return UGroomBindingAsset
function UGroomBlueprintLibrary:CreateNewGroomBindingAssetWithPath(InDesiredPackagePath, InGroomAsset, InSkeletalMesh, InNumInterpolationPoints, InSourceSkeletalMeshForTransfer, InMatchingSection) end
---@param InGroomAsset UGroomAsset
---@param InSkeletalMesh USkeletalMesh
---@param InNumInterpolationPoints int32
---@param InSourceSkeletalMeshForTransfer USkeletalMesh
---@param InMatchingSection int32
---@return UGroomBindingAsset
function UGroomBlueprintLibrary:CreateNewGroomBindingAsset(InGroomAsset, InSkeletalMesh, InNumInterpolationPoints, InSourceSkeletalMeshForTransfer, InMatchingSection) end
---@param DesiredPackagePath FString
---@param GroomAsset UGroomAsset
---@param GeometryCache UGeometryCache
---@param NumInterpolationPoints int32
---@param SourceGeometryCacheForTransfer UGeometryCache
---@param MatchingSection int32
---@return UGroomBindingAsset
function UGroomBlueprintLibrary:CreateNewGeometryCacheGroomBindingAssetWithPath(DesiredPackagePath, GroomAsset, GeometryCache, NumInterpolationPoints, SourceGeometryCacheForTransfer, MatchingSection) end
---@param GroomAsset UGroomAsset
---@param GeometryCache UGeometryCache
---@param NumInterpolationPoints int32
---@param SourceGeometryCacheForTransfer UGeometryCache
---@param MatchingSection int32
---@return UGroomBindingAsset
function UGroomBlueprintLibrary:CreateNewGeometryCacheGroomBindingAsset(GroomAsset, GeometryCache, NumInterpolationPoints, SourceGeometryCacheForTransfer, MatchingSection) end


---@class UGroomCache : UObject
---@field AssetUserData TArray<UAssetUserData>
---@field GroomCacheInfo FGroomCacheInfo
local UGroomCache = {}



---@class UGroomCacheImportData : UAssetImportData
---@field Settings FGroomCacheImportSettings
local UGroomCacheImportData = {}



---@class UGroomCacheImportOptions : UObject
---@field ImportSettings FGroomCacheImportSettings
local UGroomCacheImportOptions = {}



---@class UGroomComponent : UMeshComponent
---@field GroomAsset UGroomAsset
---@field GroomCache UGroomCache
---@field NiagaraComponents TArray<UNiagaraComponent>
---@field SourceSkeletalMesh USkeletalMesh
---@field BindingAsset UGroomBindingAsset
---@field PhysicsAsset UPhysicsAsset
---@field SimulationSettings FHairSimulationSettings
---@field MeshDeformer UMeshDeformer
---@field MeshDeformerInstance UMeshDeformerInstance
---@field MeshDeformerInstanceSettings UMeshDeformerInstanceSettings
---@field Strands_DebugMaterial UMaterialInterface
---@field Strands_DefaultMaterial UMaterialInterface
---@field Cards_DefaultMaterial UMaterialInterface
---@field Meshes_DefaultMaterial UMaterialInterface
---@field AngularSpringsSystem UNiagaraSystem
---@field CosseratRodsSystem UNiagaraSystem
---@field AttachmentName FString
---@field GroomGroupsDesc TArray<FHairGroupDesc>
---@field bUseCards boolean
---@field bRunning boolean
---@field bLooping boolean
---@field bManualTick boolean
---@field ElapsedTime float
local UGroomComponent = {}

---@param InPhysicsAsset UPhysicsAsset
function UGroomComponent:SetPhysicsAsset(InPhysicsAsset) end
---@param InMeshDeformer UMeshDeformer
function UGroomComponent:SetMeshDeformer(InMeshDeformer) end
---@param bEnable boolean
function UGroomComponent:SetHairLengthScaleEnable(bEnable) end
---@param Scale float
function UGroomComponent:SetHairLengthScale(Scale) end
---@param InGroomCache UGroomCache
function UGroomComponent:SetGroomCache(InGroomCache) end
---@param Asset UGroomAsset
function UGroomComponent:SetGroomAsset(Asset) end
---@param bInEnableSimulation boolean
function UGroomComponent:SetEnableSimulation(bInEnableSimulation) end
---@param InBinding UGroomBindingAsset
function UGroomComponent:SetBindingAsset(InBinding) end
function UGroomComponent:ResetSimulation() end
function UGroomComponent:ResetCollisionComponents() end
---@param GroupIndex int32
---@return UNiagaraComponent
function UGroomComponent:GetNiagaraComponent(GroupIndex) end
---@return boolean
function UGroomComponent:GetIsHairLengthScaleEnabled() end
---@param SkeletalMeshComponent USkeletalMeshComponent
function UGroomComponent:AddCollisionComponent(SkeletalMeshComponent) end


---@class UGroomCreateBindingOptions : UObject
---@field GroomAsset TWeakObjectPtr<UGroomAsset>
---@field GroomBindingType EGroomBindingMeshType
---@field SourceSkeletalMesh USkeletalMesh
---@field TargetSkeletalMesh USkeletalMesh
---@field SourceGeometryCache UGeometryCache
---@field TargetGeometryCache UGeometryCache
---@field NumInterpolationPoints int32
---@field MatchingSection int32
local UGroomCreateBindingOptions = {}



---@class UGroomCreateFollicleMaskOptions : UObject
---@field Resolution int32
---@field RootRadius int32
---@field Grooms TArray<FFollicleMaskOptions>
local UGroomCreateFollicleMaskOptions = {}



---@class UGroomCreateStrandsTexturesOptions : UObject
---@field Layout EHairTextureLayout
---@field Resolution int32
---@field TraceType EStrandsTexturesTraceType
---@field TraceDistance float
---@field MeshType EStrandsTexturesMeshType
---@field StaticMesh UStaticMesh
---@field SkeletalMesh USkeletalMesh
---@field LODIndex int32
---@field SectionIndex int32
---@field UVChannelIndex int32
---@field GroupIndex TArray<int32>
---@field Dilation int32
local UGroomCreateStrandsTexturesOptions = {}



---@class UGroomHairGroupsPreview : UObject
---@field Groups TArray<FGroomHairGroupPreview>
local UGroomHairGroupsPreview = {}



---@class UGroomImportOptions : UObject
---@field ConversionSettings FGroomConversionSettings
---@field InterpolationSettings TArray<FHairGroupsInterpolation>
local UGroomImportOptions = {}



---@class UGroomPluginSettings : UObject
---@field GroomCacheLookAheadBuffer float
local UGroomPluginSettings = {}



---@class UHairCardGenerationSettings : UObject
local UHairCardGenerationSettings = {}


---@class UMovieSceneGroomCacheSection : UMovieSceneSection
---@field Params FMovieSceneGroomCacheParams
local UMovieSceneGroomCacheSection = {}



---@class UMovieSceneGroomCacheTrack : UMovieSceneNameableTrack
---@field AnimationSections TArray<UMovieSceneSection>
local UMovieSceneGroomCacheTrack = {}



---@class UNiagaraDataInterfaceHairStrands : UNiagaraDataInterface
---@field DefaultSource UGroomAsset
---@field SourceActor AActor
local UNiagaraDataInterfaceHairStrands = {}



---@class UNiagaraDataInterfacePressureGrid : UNiagaraDataInterfaceVelocityGrid
local UNiagaraDataInterfacePressureGrid = {}


---@class UNiagaraDataInterfaceVelocityGrid : UNiagaraDataInterfaceRWBase
---@field GridSize FIntVector
local UNiagaraDataInterfaceVelocityGrid = {}



