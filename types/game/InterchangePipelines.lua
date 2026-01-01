---@meta

---@class FInterchangeLodSceneNodeContainer
---@field SceneNodes TArray<UInterchangeSceneNode>
local FInterchangeLodSceneNodeContainer = {}



---@class FInterchangeMeshGeometry
---@field MeshUid FString
---@field MeshNode UInterchangeMeshNode
---@field ReferencingMeshInstanceUids TArray<FString>
---@field AttachedSocketUids TArray<FString>
local FInterchangeMeshGeometry = {}



---@class FInterchangeMeshInstance
---@field MeshInstanceUid FString
---@field LodGroupNode UInterchangeSceneNode
---@field bReferenceSkinnedMesh boolean
---@field bReferenceMorphTarget boolean
---@field bHasMorphTargets boolean
---@field SceneNodePerLodIndex TMap<int32, FInterchangeLodSceneNodeContainer>
---@field ReferencingMeshGeometryUids TArray<FString>
local FInterchangeMeshInstance = {}



---@class FInterchangePipelineMeshesUtilitiesContext
---@field bConvertStaticMeshToSkeletalMesh boolean
---@field bConvertSkeletalMeshToStaticMesh boolean
---@field bConvertStaticsWithMorphTargetsToSkeletals boolean
---@field bImportMeshesInBoneHierarchy boolean
---@field bQueryGeometryOnlyIfNoInstance boolean
---@field bIgnoreStaticMeshes boolean
local FInterchangePipelineMeshesUtilitiesContext = {}



---@class UGLTFPipelineSettings : UDeveloperSettings
---@field MaterialParents TMap<FString, FSoftObjectPath>
local UGLTFPipelineSettings = {}



---@class UInterchangeGLTFPipeline : UInterchangePipelineBase
---@field PipelineDisplayName FString
local UInterchangeGLTFPipeline = {}



---@class UInterchangeGenericAnimationPipeline : UInterchangePipelineBase
---@field CommonSkeletalMeshesAndAnimationsProperties TWeakObjectPtr<UInterchangeGenericCommonSkeletalMeshesAndAnimationsProperties>
---@field CommonMeshesProperties TWeakObjectPtr<UInterchangeGenericCommonMeshesProperties>
---@field bImportAnimations boolean
---@field bImportBoneTracks boolean
---@field AnimationRange EInterchangeAnimationRange
---@field FrameImportRange FInt32Interval
---@field bUse30HzToBakeBoneAnimation boolean
---@field CustomBoneAnimationSampleRate int32
---@field bSnapToClosestFrameBoundary boolean
---@field bImportCustomAttribute boolean
---@field bAddCurveMetadataToSkeleton boolean
---@field bSetMaterialDriveParameterOnCustomAttribute boolean
---@field MaterialCurveSuffixes TArray<FString>
---@field bRemoveCurveRedundantKeys boolean
---@field bDoNotImportCurveWithZero boolean
---@field bDeleteExistingNonCurveCustomAttributes boolean
---@field bDeleteExistingCustomAttributeCurves boolean
---@field bDeleteExistingMorphTargetCurves boolean
---@field SourceAnimationName FString
---@field bSceneImport boolean
local UInterchangeGenericAnimationPipeline = {}



---@class UInterchangeGenericAssetsPipeline : UInterchangePipelineBase
---@field PipelineDisplayName FString
---@field ReimportStrategy EReimportStrategyFlags
---@field bUseSourceNameForAsset boolean
---@field AssetName FString
---@field ImportOffsetTranslation FVector
---@field ImportOffsetRotation FRotator
---@field ImportOffsetUniformScale float
---@field CommonMeshesProperties UInterchangeGenericCommonMeshesProperties
---@field CommonSkeletalMeshesAndAnimationsProperties UInterchangeGenericCommonSkeletalMeshesAndAnimationsProperties
---@field MeshPipeline UInterchangeGenericMeshPipeline
---@field AnimationPipeline UInterchangeGenericAnimationPipeline
---@field MaterialPipeline UInterchangeGenericMaterialPipeline
---@field ContentPathExistingSkeleton FSoftObjectPath
---@field bImportOnlyAnimationAdjusted boolean
local UInterchangeGenericAssetsPipeline = {}



---@class UInterchangeGenericCommonMeshesProperties : UInterchangePipelineBase
---@field ForceAllMeshAsType EInterchangeForceMeshType
---@field bAutoDetectMeshType boolean
---@field bImportLods boolean
---@field bBakeMeshes boolean
---@field bBakePivotMeshes boolean
---@field bKeepSectionsSeparate boolean
---@field VertexColorImportOption EInterchangeVertexColorImportOption
---@field VertexOverrideColor FColor
---@field bRecomputeNormals boolean
---@field bRecomputeTangents boolean
---@field bUseMikkTSpace boolean
---@field bComputeWeightedNormals boolean
---@field bUseHighPrecisionTangentBasis boolean
---@field bUseFullPrecisionUVs boolean
---@field bUseBackwardsCompatibleF16TruncUVs boolean
---@field bRemoveDegenerates boolean
local UInterchangeGenericCommonMeshesProperties = {}



---@class UInterchangeGenericCommonSkeletalMeshesAndAnimationsProperties : UInterchangePipelineBase
---@field bImportOnlyAnimations boolean
---@field Skeleton TWeakObjectPtr<USkeleton>
---@field bImportMeshesInBoneHierarchy boolean
---@field bUseT0AsRefPose boolean
---@field bConvertStaticsWithMorphTargetsToSkeletals boolean
local UInterchangeGenericCommonSkeletalMeshesAndAnimationsProperties = {}



---@class UInterchangeGenericLevelPipeline : UInterchangePipelineBase
---@field PipelineDisplayName FString
---@field ReimportPropertyStrategy EReimportStrategyFlags
---@field SceneHierarchyType EInterchangeSceneHierarchyType
---@field bDeleteMissingActors boolean
---@field bForceReimportDeletedActors boolean
---@field bForceReimportDeletedAssets boolean
---@field bDeleteMissingAssets boolean
---@field bUsePhysicalInsteadOfStandardPerspectiveCamera boolean
local UInterchangeGenericLevelPipeline = {}



---@class UInterchangeGenericMaterialPipeline : UInterchangePipelineBase
---@field PipelineDisplayName FString
---@field bImportMaterials boolean
---@field SearchLocation EInterchangeMaterialSearchLocation
---@field AssetName FString
---@field MaterialImport EInterchangeMaterialImportOption
---@field bIdentifyDuplicateMaterials boolean
---@field bCreateMaterialInstanceForParent boolean
---@field ParentMaterial FSoftObjectPath
---@field TexturePipeline UInterchangeGenericTexturePipeline
---@field BaseNodeContainer UInterchangeBaseNodeContainer
local UInterchangeGenericMaterialPipeline = {}



---@class UInterchangeGenericMeshPipeline : UInterchangePipelineBase
---@field CommonMeshesProperties TWeakObjectPtr<UInterchangeGenericCommonMeshesProperties>
---@field CommonSkeletalMeshesAndAnimationsProperties TWeakObjectPtr<UInterchangeGenericCommonSkeletalMeshesAndAnimationsProperties>
---@field bImportStaticMeshes boolean
---@field bCombineStaticMeshes boolean
---@field LODGroup FName
---@field bAutoComputeLODScreenSizes boolean
---@field LODScreenSizes TArray<float>
---@field bImportCollision boolean
---@field bCollision boolean
---@field bImportCollisionAccordingToMeshName boolean
---@field bOneConvexHullPerUCX boolean
---@field Collision EInterchangeMeshCollision
---@field bBuildNanite boolean
---@field bBuildReversedIndexBuffer boolean
---@field bGenerateLightmapUVs boolean
---@field bGenerateDistanceFieldAsIfTwoSided boolean
---@field bSupportFaceRemap boolean
---@field MinLightmapResolution int32
---@field SrcLightmapIndex int32
---@field DstLightmapIndex int32
---@field BuildScale3D FVector
---@field DistanceFieldResolutionScale float
---@field DistanceFieldReplacementMesh TWeakObjectPtr<UStaticMesh>
---@field MaxLumenMeshCards int32
---@field bImportSkeletalMeshes boolean
---@field SkeletalMeshImportContentType EInterchangeSkeletalMeshContentType
---@field LastSkeletalMeshImportContentType EInterchangeSkeletalMeshContentType
---@field bCombineSkeletalMeshes boolean
---@field bImportMorphTargets boolean
---@field bMergeMorphTargetsWithSameName boolean
---@field bImportVertexAttributes boolean
---@field bUpdateSkeletonReferencePose boolean
---@field bCreatePhysicsAsset boolean
---@field PhysicsAsset TWeakObjectPtr<UPhysicsAsset>
---@field bUseHighPrecisionSkinWeights boolean
---@field ThresholdPosition float
---@field ThresholdTangentNormal float
---@field ThresholdUV float
---@field MorphThresholdPosition float
---@field BoneInfluenceLimit int32
local UInterchangeGenericMeshPipeline = {}

---@param InbCombineSkeletalMeshes boolean
function UInterchangeGenericMeshPipeline:SetCombineSkeletalMeshes(InbCombineSkeletalMeshes) end
---@return boolean
function UInterchangeGenericMeshPipeline:GetCombineSkeletalMeshes() end


---@class UInterchangeGenericTexturePipeline : UInterchangePipelineBase
---@field PipelineDisplayName FString
---@field bImportTextures boolean
---@field AssetName FString
---@field bAllowNonPowerOfTwo boolean
---@field BaseNodeContainer UInterchangeBaseNodeContainer
local UInterchangeGenericTexturePipeline = {}



---@class UInterchangeMaterialXPipeline : UInterchangePipelineBase
local UInterchangeMaterialXPipeline = {}


---@class UInterchangePipelineMeshesUtilities : UObject
local UInterchangePipelineMeshesUtilities = {}

---@param Context FInterchangePipelineMeshesUtilitiesContext
function UInterchangePipelineMeshesUtilities:SetContext(Context) end
---@param MeshInstanceUid FString
---@return boolean
function UInterchangePipelineMeshesUtilities:IsValidMeshInstanceUid(MeshInstanceUid) end
---@param MeshGeometryUid FString
---@return boolean
function UInterchangePipelineMeshesUtilities:IsValidMeshGeometryUid(MeshGeometryUid) end
---@param MeshInstanceUid FString
---@return FString
function UInterchangePipelineMeshesUtilities:GetMeshInstanceSkeletonRootUid(MeshInstanceUid) end
---@param MeshInstanceUid FString
---@return FInterchangeMeshInstance
function UInterchangePipelineMeshesUtilities:GetMeshInstanceByUid(MeshInstanceUid) end
---@param MeshGeometryUid FString
---@return FString
function UInterchangePipelineMeshesUtilities:GetMeshGeometrySkeletonRootUid(MeshGeometryUid) end
---@param MeshGeometryUid FString
---@return FInterchangeMeshGeometry
function UInterchangePipelineMeshesUtilities:GetMeshGeometryByUid(MeshGeometryUid) end
---@param MeshInstanceUids TArray<FString>
function UInterchangePipelineMeshesUtilities:GetAllStaticMeshInstance(MeshInstanceUids) end
---@param MeshGeometryUids TArray<FString>
function UInterchangePipelineMeshesUtilities:GetAllStaticMeshGeometry(MeshGeometryUids) end
---@param MeshInstanceUids TArray<FString>
function UInterchangePipelineMeshesUtilities:GetAllSkinnedMeshInstance(MeshInstanceUids) end
---@param MeshGeometryUids TArray<FString>
function UInterchangePipelineMeshesUtilities:GetAllSkinnedMeshGeometry(MeshGeometryUids) end
---@param MeshGeometryUid FString
---@param MeshInstanceUids TArray<FString>
function UInterchangePipelineMeshesUtilities:GetAllMeshInstanceUidsUsingMeshGeometryUid(MeshGeometryUid, MeshInstanceUids) end
---@param MeshInstanceUids TArray<FString>
function UInterchangePipelineMeshesUtilities:GetAllMeshInstanceUids(MeshInstanceUids) end
---@param MeshGeometryUids TArray<FString>
function UInterchangePipelineMeshesUtilities:GetAllMeshGeometryNotInstanced(MeshGeometryUids) end
---@param MeshGeometryUids TArray<FString>
function UInterchangePipelineMeshesUtilities:GetAllMeshGeometry(MeshGeometryUids) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@return UInterchangePipelineMeshesUtilities
function UInterchangePipelineMeshesUtilities:CreateInterchangePipelineMeshesUtilities(BaseNodeContainer) end


---@class UMaterialXPipelineSettings : UDeveloperSettings
---@field PredefinedSurfaceShaders TMap<EInterchangeMaterialXShaders, FSoftObjectPath>
---@field PredefinedBSDF TMap<EInterchangeMaterialXBSDF, FSoftObjectPath>
---@field PredefinedEDF TMap<EInterchangeMaterialXEDF, FSoftObjectPath>
---@field PredefinedVDF TMap<EInterchangeMaterialXVDF, FSoftObjectPath>
local UMaterialXPipelineSettings = {}



