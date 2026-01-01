---@meta

---@class FAbsDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FAbsDataflowNode = {}



---@class FAddCustomCollectionAttributeDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field GroupName EStandardGroupNameEnum
---@field CustomGroupName FString
---@field AttrName FString
---@field CustomAttributeType ECustomAttributeTypeEnum
---@field NumElements int32
local FAddCustomCollectionAttributeDataflowNode = {}



---@class FAddDataflowNode : FDataflowNode
---@field FloatA float
---@field FloatB float
---@field ReturnValue float
local FAddDataflowNode = {}



---@class FAddMaterialToCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field FaceSelection FDataflowFaceSelection
---@field Materials TArray<UMaterial>
---@field OutsideMaterial UMaterial
---@field InsideMaterial UMaterial
---@field bAssignOutsideMaterial boolean
---@field bAssignInsideMaterial boolean
local FAddMaterialToCollectionDataflowNode = {}



---@class FAppendCollectionAssetsDataflowNode : FDataflowNode
---@field Collection1 FManagedArrayCollection
---@field Collection2 FManagedArrayCollection
---@field GeometryGroupGuidsOut1 TArray<FString>
---@field GeometryGroupGuidsOut2 TArray<FString>
local FAppendCollectionAssetsDataflowNode = {}



---@class FArcCosDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FArcCosDataflowNode = {}



---@class FArcSinDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FArcSinDataflowNode = {}



---@class FArcTan2DataflowNode : FDataflowNode
---@field Y float
---@field X float
---@field ReturnValue float
local FArcTan2DataflowNode = {}



---@class FArcTanDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FArcTanDataflowNode = {}



---@class FAutoClusterDataflowNode : FDataflowNode
---@field ClusterSizeMethod EClusterSizeMethodEnum
---@field ClusterSites int32
---@field ClusterFraction float
---@field SiteSize float
---@field ClusterGridWidth int32
---@field ClusterGridDepth int32
---@field ClusterGridHeight int32
---@field DriftIterations int32
---@field MinimumSize float
---@field bPreferConvexity boolean
---@field ConcavityTolerance float
---@field AutoCluster boolean
---@field EnforceSiteParameters boolean
---@field AvoidIsolated boolean
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FAutoClusterDataflowNode = {}



---@class FBakeTransformsInCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
local FBakeTransformsInCollectionDataflowNode = {}



---@class FBlueprintToCollectionDataflowNode : FDataflowNode
---@field Blueprint UBlueprint
---@field bSplitComponents boolean
---@field Collection FManagedArrayCollection
---@field Materials TArray<UMaterial>
---@field MaterialInstances TArray<UMaterialInterface>
---@field InstancedMeshes TArray<FGeometryCollectionAutoInstanceMesh>
local FBlueprintToCollectionDataflowNode = {}



---@class FBoolArrayToFaceSelectionDataflowNode : FDataflowNode
---@field BoolAttributeData TArray<boolean>
---@field FaceSelection FDataflowFaceSelection
local FBoolArrayToFaceSelectionDataflowNode = {}



---@class FBoolToIntDataflowNode : FDataflowNode
---@field bool boolean
---@field Int int32
local FBoolToIntDataflowNode = {}



---@class FBoolToStringDataflowNode : FDataflowNode
---@field bool boolean
---@field String FString
local FBoolToStringDataflowNode = {}



---@class FBoundingBoxDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field BoundingBox FBox
local FBoundingBoxDataflowNode = {}



---@class FBoxFalloffFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field Box FBox
---@field Transform FTransform
---@field Magnitude float
---@field MinRange float
---@field MaxRange float
---@field Default float
---@field FalloffType EDataflowFieldFalloffType
---@field FieldFloatResult TArray<float>
---@field FieldRemap TArray<int32>
---@field FieldSelectionMask FDataflowVertexSelection
---@field NumSamplePositions int32
local FBoxFalloffFieldDataflowNode = {}



---@class FBoxToMeshDataflowNode : FDataflowNode
---@field Box FBox
---@field Mesh UDynamicMesh
---@field TriangleCount int32
local FBoxToMeshDataflowNode = {}



---@class FBranchCollectionDataflowNode : FDataflowNode
---@field TrueCollection FManagedArrayCollection
---@field FalseCollection FManagedArrayCollection
---@field bCondition boolean
---@field ChosenCollection FManagedArrayCollection
local FBranchCollectionDataflowNode = {}



---@class FBranchFloatDataflowNode : FDataflowNode
---@field A float
---@field B float
---@field bCondition boolean
---@field ReturnValue float
local FBranchFloatDataflowNode = {}



---@class FBranchIntDataflowNode : FDataflowNode
---@field A int32
---@field B int32
---@field bCondition boolean
---@field ReturnValue int32
local FBranchIntDataflowNode = {}



---@class FBranchMeshDataflowNode : FDataflowNode
---@field MeshA UDynamicMesh
---@field MeshB UDynamicMesh
---@field bCondition boolean
---@field Mesh UDynamicMesh
local FBranchMeshDataflowNode = {}



---@class FBrickCutterDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field BoundingBox FBox
---@field TransformSelection FDataflowTransformSelection
---@field Transform FTransform
---@field Bond EFractureBrickBondEnum
---@field BrickLength float
---@field BrickHeight float
---@field BrickDepth float
---@field RandomSeed int32
---@field ChanceToFracture float
---@field SplitIslands boolean
---@field Grout float
---@field Amplitude float
---@field Frequency float
---@field Persistence float
---@field Lacunarity float
---@field OctaveNumber int32
---@field PointSpacing float
---@field AddSamplesForCollision boolean
---@field CollisionSampleSpacing float
---@field NewGeometryTransformSelection FDataflowTransformSelection
local FBrickCutterDataflowNode = {}



---@class FCeilDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FCeilDataflowNode = {}



---@class FClampDataflowNode : FDataflowNode
---@field float float
---@field Min float
---@field Max float
---@field ReturnValue float
local FClampDataflowNode = {}



---@class FClearConvexHullsDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FClearConvexHullsDataflowNode = {}



---@class FCloseGeometryOnCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
local FCloseGeometryOnCollectionDataflowNode = {}



---@class FClusterDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FClusterDataflowNode = {}



---@class FClusterFlattenDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field OptionalTransformSelection FDataflowTransformSelection
local FClusterFlattenDataflowNode = {}



---@class FClusterIsolatedRootsDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
local FClusterIsolatedRootsDataflowNode = {}



---@class FClusterMagnetDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field Iterations int32
local FClusterMagnetDataflowNode = {}



---@class FClusterMergeDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FClusterMergeDataflowNode = {}



---@class FClusterMergeToNeighborsDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field NeighborSelectionMethod EClusterNeighborSelectionMethodEnum
---@field MinVolumeCubeRoot float
---@field bOnlyToConnected boolean
---@field bOnlySameParent boolean
local FClusterMergeToNeighborsDataflowNode = {}



---@class FClusterUnclusterDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FClusterUnclusterDataflowNode = {}



---@class FCollectionFaceSelectionCustomDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field FaceIndicies FString
---@field FaceSelection FDataflowFaceSelection
local FCollectionFaceSelectionCustomDataflowNode = {}



---@class FCollectionFaceSelectionInvertDataflowNode : FDataflowNode
---@field FaceSelection FDataflowFaceSelection
local FCollectionFaceSelectionInvertDataflowNode = {}



---@class FCollectionSelectionByAttrDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field AttributeKey FCollectionAttributeKey
---@field Group ESelectionByAttrGroup
---@field Attribute FString
---@field Operation ESelectionByAttrOperation
---@field Value FString
---@field VertexSelection FDataflowVertexSelection
---@field FaceSelection FDataflowFaceSelection
---@field TransformSelection FDataflowTransformSelection
---@field GeometrySelection FDataflowGeometrySelection
---@field MaterialSelection FDataflowMaterialSelection
local FCollectionSelectionByAttrDataflowNode = {}



---@class FCollectionSelectionConvertDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field FaceSelection FDataflowFaceSelection
---@field VertexSelection FDataflowVertexSelection
---@field bAllElementsMustBeSelected boolean
local FCollectionSelectionConvertDataflowNode = {}



---@class FCollectionSetPivotDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field Transform FTransform
local FCollectionSetPivotDataflowNode = {}



---@class FCollectionToMeshDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field bCenterPivot boolean
---@field Mesh UDynamicMesh
local FCollectionToMeshDataflowNode = {}



---@class FCollectionTransformSelectionAllDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionAllDataflowNode = {}



---@class FCollectionTransformSelectionByFloatAttrDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field GroupName FString
---@field AttrName FString
---@field Min float
---@field Max float
---@field RangeSetting ERangeSettingEnum
---@field bInclusive boolean
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionByFloatAttrDataflowNode = {}



---@class FCollectionTransformSelectionByIntAttrDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field GroupName FString
---@field AttrName FString
---@field Min int32
---@field Max int32
---@field RangeSetting ERangeSettingEnum
---@field bInclusive boolean
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionByIntAttrDataflowNode = {}



---@class FCollectionTransformSelectionByPercentageDataflowNode : FDataflowNode
---@field TransformSelection FDataflowTransformSelection
---@field Percentage int32
---@field bDeterministic boolean
---@field RandomSeed float
local FCollectionTransformSelectionByPercentageDataflowNode = {}



---@class FCollectionTransformSelectionBySizeDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field SizeMin float
---@field SizeMax float
---@field RangeSetting ERangeSettingEnum
---@field bInclusive boolean
---@field bUseRelativeSize boolean
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionBySizeDataflowNode = {}



---@class FCollectionTransformSelectionByVolumeDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field VolumeMin float
---@field VolumeMax float
---@field RangeSetting ERangeSettingEnum
---@field bInclusive boolean
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionByVolumeDataflowNode = {}



---@class FCollectionTransformSelectionChildrenDataflowNode : FDataflowNode
---@field TransformSelection FDataflowTransformSelection
---@field Collection FManagedArrayCollection
local FCollectionTransformSelectionChildrenDataflowNode = {}



---@class FCollectionTransformSelectionClusterDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionClusterDataflowNode = {}



---@class FCollectionTransformSelectionClusterDataflowNode_v2 : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionClusterDataflowNode_v2 = {}



---@class FCollectionTransformSelectionContactDataflowNode : FDataflowNode
---@field TransformSelection FDataflowTransformSelection
---@field Collection FManagedArrayCollection
---@field bAllowContactInParentLevels boolean
local FCollectionTransformSelectionContactDataflowNode = {}



---@class FCollectionTransformSelectionCustomDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field BoneIndicies FString
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionCustomDataflowNode = {}



---@class FCollectionTransformSelectionFromIndexArrayDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field BoneIndices TArray<int32>
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionFromIndexArrayDataflowNode = {}



---@class FCollectionTransformSelectionInBoxDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field Box FBox
---@field Transform FTransform
---@field Type ESelectSubjectTypeEnum
---@field bAllVerticesMustContainedInBox boolean
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionInBoxDataflowNode = {}



---@class FCollectionTransformSelectionInSphereDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field Sphere FSphere
---@field Transform FTransform
---@field Type ESelectSubjectTypeEnum
---@field bAllVerticesMustContainedInSphere boolean
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionInSphereDataflowNode = {}



---@class FCollectionTransformSelectionInfoDataflowNode : FDataflowNode
---@field TransformSelection FDataflowTransformSelection
---@field Collection FManagedArrayCollection
---@field String FString
local FCollectionTransformSelectionInfoDataflowNode = {}



---@class FCollectionTransformSelectionInvertDataflowNode : FDataflowNode
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionInvertDataflowNode = {}



---@class FCollectionTransformSelectionLeafDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionLeafDataflowNode = {}



---@class FCollectionTransformSelectionLevelDataflowNode : FDataflowNode
---@field TransformSelection FDataflowTransformSelection
---@field Collection FManagedArrayCollection
local FCollectionTransformSelectionLevelDataflowNode = {}



---@class FCollectionTransformSelectionNoneDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionNoneDataflowNode = {}



---@class FCollectionTransformSelectionParentDataflowNode : FDataflowNode
---@field TransformSelection FDataflowTransformSelection
---@field Collection FManagedArrayCollection
local FCollectionTransformSelectionParentDataflowNode = {}



---@class FCollectionTransformSelectionRandomDataflowNode : FDataflowNode
---@field bDeterministic boolean
---@field RandomSeed float
---@field RandomThreshold float
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionRandomDataflowNode = {}



---@class FCollectionTransformSelectionRootDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionRootDataflowNode = {}



---@class FCollectionTransformSelectionSetOperationDataflowNode : FDataflowNode
---@field Operation ESetOperationEnum
---@field TransformSelectionA FDataflowTransformSelection
---@field TransformSelectionB FDataflowTransformSelection
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionSetOperationDataflowNode = {}



---@class FCollectionTransformSelectionSiblingsDataflowNode : FDataflowNode
---@field TransformSelection FDataflowTransformSelection
---@field Collection FManagedArrayCollection
local FCollectionTransformSelectionSiblingsDataflowNode = {}



---@class FCollectionTransformSelectionTargetLevelDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TargetLevel int32
---@field bSkipEmbedded boolean
---@field TransformSelection FDataflowTransformSelection
local FCollectionTransformSelectionTargetLevelDataflowNode = {}



---@class FCollectionVertexSelectionByPercentageDataflowNode : FDataflowNode
---@field VertexSelection FDataflowVertexSelection
---@field Percentage int32
---@field bDeterministic boolean
---@field RandomSeed float
local FCollectionVertexSelectionByPercentageDataflowNode = {}



---@class FCollectionVertexSelectionCustomDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field VertexIndicies FString
---@field VertexSelection FDataflowVertexSelection
local FCollectionVertexSelectionCustomDataflowNode = {}



---@class FCollectionVertexSelectionSetOperationDataflowNode : FDataflowNode
---@field Operation ESetOperationEnum
---@field VertexSelectionA FDataflowVertexSelection
---@field VertexSelectionB FDataflowVertexSelection
---@field VertexSelection FDataflowVertexSelection
local FCollectionVertexSelectionSetOperationDataflowNode = {}



---@class FCompareFloatDataflowNode : FDataflowNode
---@field Operation ECompareOperationEnum
---@field FloatA float
---@field FloatB float
---@field Result boolean
local FCompareFloatDataflowNode = {}



---@class FCompareIntDataflowNode : FDataflowNode
---@field Operation ECompareOperationEnum
---@field IntA int32
---@field IntB int32
---@field Result boolean
local FCompareIntDataflowNode = {}



---@class FConvexHullToMeshDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field OptionalSelectionFilter FDataflowTransformSelection
---@field Mesh UDynamicMesh
local FConvexHullToMeshDataflowNode = {}



---@class FCosDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FCosDataflowNode = {}



---@class FCreateColorArrayFromFloatArrayDataflowNode : FDataflowNode
---@field FloatArray TArray<float>
---@field ColorArray TArray<FLinearColor>
---@field bNormalizeInput boolean
---@field Color FLinearColor
local FCreateColorArrayFromFloatArrayDataflowNode = {}



---@class FCreateGeometryCollectionFromSourcesDataflowNode : FDataflowNode
---@field Sources TArray<FGeometryCollectionSource>
---@field Collection FManagedArrayCollection
---@field Materials TArray<UMaterial>
---@field MaterialInstances TArray<UMaterialInterface>
---@field InstancedMeshes TArray<FGeometryCollectionAutoInstanceMesh>
local FCreateGeometryCollectionFromSourcesDataflowNode = {}



---@class FCreateLeafConvexHullsDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field OptionalSelectionFilter FDataflowTransformSelection
---@field GenerateMethod EGenerateConvexMethod
---@field IntersectIfComputedIsSmallerByFactor float
---@field MinExternalVolumeToIntersect float
---@field bComputeIntersectionsBeforeHull boolean
---@field SimplificationDistanceThreshold float
---@field ConvexDecompositionSettings FDataflowConvexDecompositionSettings
local FCreateLeafConvexHullsDataflowNode = {}



---@class FCreateNonOverlappingConvexHullsDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field CanExceedFraction float
---@field SimplificationDistanceThreshold float
---@field OverlapRemovalMethod EConvexOverlapRemovalMethodEnum
---@field OverlapRemovalShrinkPercent float
---@field CanRemoveFraction float
local FCreateNonOverlappingConvexHullsDataflowNode = {}



---@class FCrossProductDataflowNode : FDataflowNode
---@field VectorA FVector
---@field VectorB FVector
---@field ReturnValue FVector
local FCrossProductDataflowNode = {}



---@class FCubeDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FCubeDataflowNode = {}



---@class FDataflowConvexDecompositionSettings
---@field MinSizeToDecompose float
---@field MaxGeoToHullVolumeRatioToDecompose float
---@field ErrorTolerance float
---@field MaxHullsPerGeometry int32
---@field MinThicknessTolerance float
---@field NumAdditionalSplits int32
local FDataflowConvexDecompositionSettings = {}



---@class FDataflowSphereCovering
local FDataflowSphereCovering = {}


---@class FDegreesToRadiansDataflowNode : FDataflowNode
---@field Degrees float
---@field Radians float
local FDegreesToRadiansDataflowNode = {}



---@class FDistanceDataflowNode : FDataflowNode
---@field PointA FVector
---@field PointB FVector
---@field ReturnValue float
local FDistanceDataflowNode = {}



---@class FDivideDataflowNode : FSafeDivideDataflowNode
local FDivideDataflowNode = {}


---@class FDivisionDataflowNode : FDataflowNode
---@field Dividend float
---@field Divisor float
---@field Remainder float
---@field ReturnValue int32
local FDivisionDataflowNode = {}



---@class FDotProductDataflowNode : FDataflowNode
---@field VectorA FVector
---@field VectorB FVector
---@field ReturnValue float
local FDotProductDataflowNode = {}



---@class FEFitDataflowNode : FDataflowNode
---@field float float
---@field OldMin float
---@field OldMax float
---@field NewMin float
---@field NewMax float
---@field ReturnValue float
local FEFitDataflowNode = {}



---@class FExpDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FExpDataflowNode = {}



---@class FExpandBoundingBoxDataflowNode : FDataflowNode
---@field BoundingBox FBox
---@field Min FVector
---@field Max FVector
---@field Center FVector
---@field HalfExtents FVector
---@field Volume float
local FExpandBoundingBoxDataflowNode = {}



---@class FExpandVectorDataflowNode : FDataflowNode
---@field Vector FVector
---@field X float
---@field Y float
---@field Z float
local FExpandVectorDataflowNode = {}



---@class FExplodedViewDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field UniformScale float
---@field Scale FVector
local FExplodedViewDataflowNode = {}



---@class FFieldMakeDenseFloatArrayDataflowNode : FDataflowNode
---@field FieldFloatInput TArray<float>
---@field FieldRemap TArray<int32>
---@field NumSamplePositions int32
---@field Default float
---@field FieldFloatResult TArray<float>
local FFieldMakeDenseFloatArrayDataflowNode = {}



---@class FFitDataflowNode : FDataflowNode
---@field float float
---@field OldMin float
---@field OldMax float
---@field NewMin float
---@field NewMax float
---@field ReturnValue float
local FFitDataflowNode = {}



---@class FFixTinyGeoDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field MergeType EFixTinyGeoMergeType
---@field bOnFractureLevel boolean
---@field bOnlyClusters boolean
---@field bOnlySameParent boolean
---@field bFractureLevelIsAll boolean
---@field NeighborSelection EFixTinyGeoNeighborSelectionMethod
---@field bOnlyToConnected boolean
---@field UseBoneSelection EFixTinyGeoUseBoneSelection
---@field SelectionMethod EFixTinyGeoGeometrySelectionMethod
---@field MinVolumeCubeRoot float
---@field RelativeVolume float
---@field AddSamplesForCollision boolean
---@field CollisionSampleSpacing float
local FFixTinyGeoDataflowNode = {}



---@class FFloatArrayComputeStatisticsDataflowNode : FDataflowNode
---@field FloatArray TArray<float>
---@field TransformSelection FDataflowTransformSelection
---@field OperationName EStatisticsOperationEnum
---@field Value float
---@field Indices TArray<int32>
local FFloatArrayComputeStatisticsDataflowNode = {}



---@class FFloatArrayNormalizeDataflowNode : FDataflowNode
---@field InFloatArray TArray<float>
---@field Selection FDataflowVertexSelection
---@field MinRange float
---@field MaxRange float
---@field OutFloatArray TArray<float>
local FFloatArrayNormalizeDataflowNode = {}



---@class FFloatArrayToIntArrayDataflowNode : FDataflowNode
---@field Function EFloatArrayToIntArrayFunctionEnum
---@field FloatArray TArray<float>
---@field IntArray TArray<int32>
local FFloatArrayToIntArrayDataflowNode = {}



---@class FFloatArrayToVertexSelectionDataflowNode : FDataflowNode
---@field FloatArray TArray<float>
---@field Operation ECompareOperation1Enum
---@field Threshold float
---@field VertexSelection FDataflowVertexSelection
local FFloatArrayToVertexSelectionDataflowNode = {}



---@class FFloatMathExpressionDataflowNode : FDataflowNode
---@field A float
---@field B float
---@field C float
---@field D float
---@field Expression FString
---@field ReturnValue float
local FFloatMathExpressionDataflowNode = {}



---@class FFloatToDoubleDataflowNode : FDataflowNode
---@field float float
---@field Double double
local FFloatToDoubleDataflowNode = {}



---@class FFloatToIntDataflowNode : FDataflowNode
---@field Function EFloatToIntFunctionEnum
---@field float float
---@field Int int32
local FFloatToIntDataflowNode = {}



---@class FFloatToStringDataflowNode : FDataflowNode
---@field float float
---@field String FString
local FFloatToStringDataflowNode = {}



---@class FFloorDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FFloorDataflowNode = {}



---@class FFracDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FFracDataflowNode = {}



---@class FGenerateClusterConvexHullsFromChildrenHullsDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field SphereCovering FDataflowSphereCovering
---@field ConvexCount int32
---@field ErrorTolerance double
---@field bPreferExternalCollisionShapes boolean
---@field OptionalSelectionFilter FDataflowTransformSelection
---@field bProtectNegativeSpace boolean
---@field SampleMethod ENegativeSpaceSampleMethodDataflowEnum
---@field bRequireSearchSampleCoverage boolean
---@field bOnlyConnectedToHull boolean
---@field TargetNumSamples int32
---@field MinSampleSpacing double
---@field NegativeSpaceTolerance double
---@field MinRadius double
local FGenerateClusterConvexHullsFromChildrenHullsDataflowNode = {}



---@class FGenerateClusterConvexHullsFromLeafHullsDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field SphereCovering FDataflowSphereCovering
---@field ConvexCount int32
---@field ErrorTolerance double
---@field bPreferExternalCollisionShapes boolean
---@field AllowMerges EAllowConvexMergeMethod
---@field OptionalSelectionFilter FDataflowTransformSelection
---@field bProtectNegativeSpace boolean
---@field SampleMethod ENegativeSpaceSampleMethodDataflowEnum
---@field bRequireSearchSampleCoverage boolean
---@field bOnlyConnectedToHull boolean
---@field TargetNumSamples int32
---@field MinSampleSpacing double
---@field NegativeSpaceTolerance double
---@field MinRadius double
local FGenerateClusterConvexHullsFromLeafHullsDataflowNode = {}



---@class FGeometryCollectionSetKinematicVertexSelectionNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field VertexSelection FDataflowVertexSelection
local FGeometryCollectionSetKinematicVertexSelectionNode = {}



---@class FGeometryCollectionTerminalDataflowNode : FDataflowTerminalNode
---@field Collection FManagedArrayCollection
---@field Materials TArray<UMaterial>
---@field MaterialInstances TArray<UMaterialInterface>
---@field InstancedMeshes TArray<FGeometryCollectionAutoInstanceMesh>
local FGeometryCollectionTerminalDataflowNode = {}



---@class FGeometryCollectionToCollectionDataflowNode : FDataflowNode
---@field GeometryCollection UGeometryCollection
---@field Collection FManagedArrayCollection
---@field Materials TArray<UMaterial>
---@field MaterialInstances TArray<UMaterialInterface>
---@field InstancedMeshes TArray<FGeometryCollectionAutoInstanceMesh>
local FGeometryCollectionToCollectionDataflowNode = {}



---@class FGeometryCollectionTransferVertexAttributeNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field FromCollection FManagedArrayCollection
---@field AttributeKey FCollectionAttributeKey
---@field BoundingVolumeType EDataflowTransferVertexAttributeNodeBoundingVolume
---@field SourceScale EDataflowTransferVertexAttributeNodeSourceScale
---@field Falloff EDataflowTransferVertexAttributeNodeFalloff
---@field FalloffThreshold float
---@field EdgeMultiplier float
---@field BoundMultiplier float
local FGeometryCollectionTransferVertexAttributeNode = {}



---@class FGeometryCollectionTransferVertexSkinWeightsNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field FromCollection FManagedArrayCollection
---@field BoundingVolumeType EDataflowTransferVertexAttributeNodeBoundingVolume
---@field SourceScale EDataflowTransferVertexAttributeNodeSourceScale
---@field Falloff EDataflowTransferVertexAttributeNodeFalloff
---@field FalloffThreshold float
---@field EdgeMultiplier float
---@field BoundMultiplier float
local FGeometryCollectionTransferVertexSkinWeightsNode = {}



---@class FGeometryCollectionVertexScalarToVertexIndicesNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field AttributeKey FCollectionAttributeKey
---@field SelectionThreshold float
---@field VertexIndices TArray<int32>
local FGeometryCollectionVertexScalarToVertexIndicesNode = {}



---@class FGeometrySelectionToVertexSelectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field GeometryIndices FString
---@field GeometrySelection FDataflowGeometrySelection
---@field VertexSelection FDataflowVertexSelection
local FGeometrySelectionToVertexSelectionDataflowNode = {}



---@class FGetArrayElementDataflowNode : FDataflowNode
---@field Index int32
---@field Points TArray<FVector>
---@field Point FVector
local FGetArrayElementDataflowNode = {}



---@class FGetBoolOverrideFromAssetDataflowNode : FDataflowOverrideNode
---@field bool boolean
---@field BoolDefault boolean
local FGetBoolOverrideFromAssetDataflowNode = {}



---@class FGetBoundingBoxesFromCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field BoundingBoxes TArray<FBox>
local FGetBoundingBoxesFromCollectionDataflowNode = {}



---@class FGetBoxLengthsDataflowNode : FDataflowNode
---@field Boxes TArray<FBox>
---@field Lengths TArray<float>
---@field MeasurementMethod EBoxLengthMeasurementMethod
local FGetBoxLengthsDataflowNode = {}



---@class FGetCentroidsFromCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field Centroids TArray<FVector>
local FGetCentroidsFromCollectionDataflowNode = {}



---@class FGetCollectionAttributeDataTypedDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field AttributeKey FCollectionAttributeKey
---@field GroupName EStandardGroupNameEnum
---@field CustomGroupName FString
---@field AttrName FString
---@field BoolAttributeData TArray<boolean>
---@field FloatAttributeData TArray<float>
---@field DoubleAttributeData TArray<double>
---@field Int32AttributeData TArray<int32>
---@field StringAttributeData TArray<FString>
---@field Vector3fAttributeData TArray<FVector3f>
---@field Vector3dAttributeData TArray<FVector3d>
---@field LinearColorAttributeData TArray<FLinearColor>
local FGetCollectionAttributeDataTypedDataflowNode = {}



---@class FGetCollectionFromAssetDataflowNode : FDataflowNode
---@field CollectionAsset UGeometryCollection
---@field Collection FManagedArrayCollection
local FGetCollectionFromAssetDataflowNode = {}



---@class FGetConvexHullVolumeDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field Volume float
---@field bSumChildrenForClustersWithoutHulls boolean
---@field bVolumeOfUnion boolean
local FGetConvexHullVolumeDataflowNode = {}



---@class FGetFloatArrayElementDataflowNode : FDataflowNode
---@field Index int32
---@field FloatArray TArray<float>
---@field FloatValue float
local FGetFloatArrayElementDataflowNode = {}



---@class FGetFloatOverrideFromAssetDataflowNode : FDataflowOverrideNode
---@field float float
---@field FloatDefault float
local FGetFloatOverrideFromAssetDataflowNode = {}



---@class FGetGeometryCollectionAssetDataflowNode : FDataflowNode
---@field Asset UGeometryCollection
local FGetGeometryCollectionAssetDataflowNode = {}



---@class FGetGeometryCollectionSourcesDataflowNode : FDataflowNode
---@field Asset UGeometryCollection
---@field Sources TArray<FGeometryCollectionSource>
local FGetGeometryCollectionSourcesDataflowNode = {}



---@class FGetIntOverrideFromAssetDataflowNode : FDataflowOverrideNode
---@field Int int32
---@field IntDefault int32
local FGetIntOverrideFromAssetDataflowNode = {}



---@class FGetMaterialFromMaterialsArrayDataflowNode : FDataflowNode
---@field Materials TArray<UMaterial>
---@field Material UMaterial
---@field MaterialIdx int32
local FGetMaterialFromMaterialsArrayDataflowNode = {}



---@class FGetMeshDataDataflowNode : FDataflowNode
---@field Mesh UDynamicMesh
---@field vertexcount int32
---@field EdgeCount int32
---@field TriangleCount int32
local FGetMeshDataDataflowNode = {}



---@class FGetNumArrayElementsDataflowNode : FDataflowNode
---@field FloatArray TArray<float>
---@field IntArray TArray<int32>
---@field Points TArray<FVector>
---@field Vector3fArray TArray<FVector3f>
---@field NumElements int32
local FGetNumArrayElementsDataflowNode = {}



---@class FGetNumElementsInCollectionGroupDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field GroupName EStandardGroupNameEnum
---@field CustomGroupName FString
---@field NumElements int32
local FGetNumElementsInCollectionGroupDataflowNode = {}



---@class FGetRootIndexFromCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field RootIndex int32
local FGetRootIndexFromCollectionDataflowNode = {}



---@class FGetSchemaDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field String FString
local FGetSchemaDataflowNode = {}



---@class FGetStringOverrideFromAssetDataflowNode : FDataflowOverrideNode
---@field String FString
---@field StringDefault FString
local FGetStringOverrideFromAssetDataflowNode = {}



---@class FGridScatterPointsDataflowNode : FDataflowNode
---@field NumberOfPointsInX int32
---@field NumberOfPointsInY int32
---@field NumberOfPointsInZ int32
---@field RandomSeed int32
---@field MaxRandomDisplacementX float
---@field MaxRandomDisplacementY float
---@field MaxRandomDisplacementZ float
---@field BoundingBox FBox
---@field Points TArray<FVector>
local FGridScatterPointsDataflowNode = {}



---@class FHashStringDataflowNode : FDataflowNode
---@field String FString
---@field Hash int32
local FHashStringDataflowNode = {}



---@class FHashVectorDataflowNode : FDataflowNode
---@field Vector FVector
---@field Hash int32
local FHashVectorDataflowNode = {}



---@class FIntToBoolDataflowNode : FDataflowNode
---@field Int int32
---@field bool boolean
local FIntToBoolDataflowNode = {}



---@class FIntToDoubleDataflowNode : FDataflowNode
---@field Int int32
---@field Double double
local FIntToDoubleDataflowNode = {}



---@class FIntToFloatDataflowNode : FDataflowNode
---@field Int int32
---@field float float
local FIntToFloatDataflowNode = {}



---@class FIntToStringDataflowNode : FDataflowNode
---@field Int int32
---@field String FString
local FIntToStringDataflowNode = {}



---@class FInverseSqrtDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FInverseSqrtDataflowNode = {}



---@class FInvertTransformDataflowNode : FDataflowNode
---@field InTransform FTransform
---@field OutTransform FTransform
local FInvertTransformDataflowNode = {}



---@class FIsNearlyZeroDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue boolean
local FIsNearlyZeroDataflowNode = {}



---@class FLengthDataflowNode : FDataflowNode
---@field Vector FVector
---@field ReturnValue float
local FLengthDataflowNode = {}



---@class FLerpDataflowNode : FDataflowNode
---@field A float
---@field B float
---@field Alpha float
---@field ReturnValue float
local FLerpDataflowNode = {}



---@class FLogDataflowNode : FDataflowNode
---@field base float
---@field A float
---@field ReturnValue float
local FLogDataflowNode = {}



---@class FLogStringDataflowNode : FDataflowNode
---@field bPrintToLog boolean
---@field String FString
local FLogStringDataflowNode = {}



---@class FLogeDataflowNode : FDataflowNode
---@field A float
---@field ReturnValue float
local FLogeDataflowNode = {}



---@class FMakeBoxDataflowNode : FDataflowNode
---@field DataType EMakeBoxDataTypeEnum
---@field Min FVector
---@field Max FVector
---@field Center FVector
---@field Size FVector
---@field Box FBox
local FMakeBoxDataflowNode = {}



---@class FMakeDataflowConvexDecompositionSettingsNode : FDataflowNode
---@field MinSizeToDecompose float
---@field MaxGeoToHullVolumeRatioToDecompose float
---@field ErrorTolerance float
---@field MaxHullsPerGeometry int32
---@field MinThicknessTolerance float
---@field NumAdditionalSplits int32
---@field DecompositionSettings FDataflowConvexDecompositionSettings
local FMakeDataflowConvexDecompositionSettingsNode = {}



---@class FMakeFloatArrayDataflowNode : FDataflowNode
---@field NumElements int32
---@field Value float
---@field FloatArray TArray<float>
local FMakeFloatArrayDataflowNode = {}



---@class FMakeLiteralBoolDataflowNode : FDataflowNode
---@field Value boolean
---@field bool boolean
local FMakeLiteralBoolDataflowNode = {}



---@class FMakeLiteralFloatDataflowNode : FDataflowNode
---@field Value float
---@field float float
local FMakeLiteralFloatDataflowNode = {}



---@class FMakeLiteralIntDataflowNode : FDataflowNode
---@field Value int32
---@field Int int32
local FMakeLiteralIntDataflowNode = {}



---@class FMakeLiteralStringDataflowNode : FDataflowNode
---@field Value FString
---@field String FString
local FMakeLiteralStringDataflowNode = {}



---@class FMakeLiteralVectorDataflowNode : FDataflowNode
---@field X float
---@field Y float
---@field Z float
---@field Vector FVector
local FMakeLiteralVectorDataflowNode = {}



---@class FMakeMaterialDataflowNode : FDataflowNode
---@field InMaterial UMaterial
---@field Material UMaterial
local FMakeMaterialDataflowNode = {}



---@class FMakeMaterialsArrayDataflowNode : FDataflowNode
---@field Materials TArray<UMaterial>
local FMakeMaterialsArrayDataflowNode = {}



---@class FMakePointsDataflowNode : FDataflowNode
---@field Point TArray<FVector>
---@field Points TArray<FVector>
local FMakePointsDataflowNode = {}



---@class FMakeQuaternionDataflowNode : FDataflowNode
---@field X float
---@field Y float
---@field Z float
---@field W float
---@field Quaternion FQuat
local FMakeQuaternionDataflowNode = {}



---@class FMakeSphereDataflowNode : FDataflowNode
---@field Center FVector
---@field Radius float
---@field Sphere FSphere
local FMakeSphereDataflowNode = {}



---@class FMakeTransformDataflowNode : FDataflowNode
---@field InTranslation FVector
---@field InRotation FVector
---@field InScale FVector
---@field OutTransform FTransform
local FMakeTransformDataflowNode = {}



---@class FMaterialsInfoDataflowNode : FDataflowNode
---@field Materials TArray<UMaterial>
---@field String FString
local FMaterialsInfoDataflowNode = {}



---@class FMathConstantsDataflowNode : FDataflowNode
---@field Constant EMathConstantsEnum
---@field ReturnValue float
local FMathConstantsDataflowNode = {}



---@class FMathExpressionDataflowNode : FDataflowNode
---@field A FDataflowNumericTypes
---@field B FDataflowNumericTypes
---@field C FDataflowNumericTypes
---@field D FDataflowNumericTypes
---@field Expression FString
---@field ReturnValue FDataflowNumericTypes
local FMathExpressionDataflowNode = {}



---@class FMax3DataflowNode : FDataflowNode
---@field FloatA float
---@field FloatB float
---@field FloatC float
---@field ReturnValue float
local FMax3DataflowNode = {}



---@class FMaxDataflowNode : FDataflowNode
---@field FloatA float
---@field FloatB float
---@field ReturnValue float
local FMaxDataflowNode = {}



---@class FMergeConvexHullsDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field SphereCovering FDataflowSphereCovering
---@field MaxConvexCount int32
---@field ErrorTolerance double
---@field OptionalSelectionFilter FDataflowTransformSelection
---@field bProtectNegativeSpace boolean
---@field bComputeNegativeSpacePerBone boolean
---@field SampleMethod ENegativeSpaceSampleMethodDataflowEnum
---@field bRequireSearchSampleCoverage boolean
---@field bOnlyConnectedToHull boolean
---@field TargetNumSamples int32
---@field MinSampleSpacing double
---@field NegativeSpaceTolerance double
---@field MinRadius double
local FMergeConvexHullsDataflowNode = {}



---@class FMergeInCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FMergeInCollectionDataflowNode = {}



---@class FMeshAppendDataflowNode : FDataflowNode
---@field Mesh1 UDynamicMesh
---@field Mesh2 UDynamicMesh
---@field Mesh UDynamicMesh
local FMeshAppendDataflowNode = {}



---@class FMeshBooleanDataflowNode : FDataflowNode
---@field Operation EMeshBooleanOperationEnum
---@field Mesh1 UDynamicMesh
---@field Mesh2 UDynamicMesh
---@field Mesh UDynamicMesh
local FMeshBooleanDataflowNode = {}



---@class FMeshCopyToPointsDataflowNode : FDataflowNode
---@field Points TArray<FVector>
---@field MeshToCopy UDynamicMesh
---@field Scale float
---@field Mesh UDynamicMesh
local FMeshCopyToPointsDataflowNode = {}



---@class FMeshCutterDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field BoundingBox FBox
---@field TransformSelection FDataflowTransformSelection
---@field Transform FTransform
---@field CuttingStaticMesh UStaticMesh
---@field bUseHiRes boolean
---@field LODLevel int32
---@field CutDistribution EMeshCutterCutDistribution
---@field NumberToScatter int32
---@field GridX int32
---@field GridY int32
---@field GridZ int32
---@field Variability float
---@field MinScaleFactor float
---@field MaxScaleFactor float
---@field bRandomOrientation boolean
---@field RollRange float
---@field PitchRange float
---@field YawRange float
---@field RandomSeed int32
---@field ChanceToFracture float
---@field SplitIslands boolean
---@field AddSamplesForCollision boolean
---@field CollisionSampleSpacing float
---@field NewGeometryTransformSelection FDataflowTransformSelection
local FMeshCutterDataflowNode = {}



---@class FMeshInfoDataflowNode : FDataflowNode
---@field Mesh UDynamicMesh
---@field InfoString FString
local FMeshInfoDataflowNode = {}



---@class FMeshToCollectionDataflowNode : FDataflowNode
---@field Mesh UDynamicMesh
---@field Collection FManagedArrayCollection
local FMeshToCollectionDataflowNode = {}



---@class FMeshToOBJStringDebugDataflowNode : FDataflowNode
---@field Mesh UDynamicMesh
---@field bInvertFaces boolean
---@field StringOBJ FString
local FMeshToOBJStringDebugDataflowNode = {}



---@class FMin3DataflowNode : FDataflowNode
---@field FloatA float
---@field FloatB float
---@field FloatC float
---@field ReturnValue float
local FMin3DataflowNode = {}



---@class FMinDataflowNode : FDataflowNode
---@field FloatA float
---@field FloatB float
---@field ReturnValue float
local FMinDataflowNode = {}



---@class FMultiplyDataflowNode : FDataflowNode
---@field FloatA float
---@field FloatB float
---@field ReturnValue float
local FMultiplyDataflowNode = {}



---@class FMultiplyTransformDataflowNode : FDataflowNode
---@field InLeftTransform FTransform
---@field InRightTransform FTransform
---@field OutTransform FTransform
local FMultiplyTransformDataflowNode = {}



---@class FNegateDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FNegateDataflowNode = {}



---@class FNoiseFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field MinRange float
---@field MaxRange float
---@field Transform FTransform
---@field FieldFloatResult TArray<float>
---@field FieldRemap TArray<int32>
---@field NumSamplePositions int32
local FNoiseFieldDataflowNode = {}



---@class FNonUniformPointSamplingDataflowNode : FDataflowNode
---@field TargetMesh UDynamicMesh
---@field SamplingRadius float
---@field MaxNumSamples int32
---@field SubSampleDensity float
---@field RandomSeed int32
---@field MaxSamplingRadius float
---@field SizeDistribution ENonUniformSamplingDistributionMode
---@field SizeDistributionPower float
---@field SamplePoints TArray<FVector>
---@field SampleRadii TArray<float>
---@field SampleTriangleIDs TArray<int32>
---@field SampleBarycentricCoords TArray<FVector>
---@field NumSamplePoints int32
local FNonUniformPointSamplingDataflowNode = {}



---@class FNormalizeDataflowNode : FDataflowNode
---@field VectorA FVector
---@field Tolerance float
---@field ReturnValue FVector
local FNormalizeDataflowNode = {}



---@class FNormalizeToRangeDataflowNode : FDataflowNode
---@field float float
---@field RangeMin float
---@field RangeMax float
---@field ReturnValue float
local FNormalizeToRangeDataflowNode = {}



---@class FOneMinusDataflowNode : FDataflowNode
---@field A float
---@field ReturnValue float
local FOneMinusDataflowNode = {}



---@class FPlaneCutterDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field BoundingBox FBox
---@field TransformSelection FDataflowTransformSelection
---@field NumPlanes int32
---@field RandomSeed float
---@field Grout float
---@field Amplitude float
---@field Frequency float
---@field Persistence float
---@field Lacunarity float
---@field OctaveNumber int32
---@field PointSpacing float
---@field AddSamplesForCollision boolean
---@field CollisionSampleSpacing float
local FPlaneCutterDataflowNode = {}



---@class FPlaneCutterDataflowNode_v2 : FDataflowNode
---@field Collection FManagedArrayCollection
---@field BoundingBox FBox
---@field TransformSelection FDataflowTransformSelection
---@field Transform FTransform
---@field NumPlanes int32
---@field RandomSeed int32
---@field ChanceToFracture float
---@field SplitIslands boolean
---@field Grout float
---@field Amplitude float
---@field Frequency float
---@field Persistence float
---@field Lacunarity float
---@field OctaveNumber int32
---@field PointSpacing float
---@field AddSamplesForCollision boolean
---@field CollisionSampleSpacing float
---@field NewGeometryTransformSelection FDataflowTransformSelection
local FPlaneCutterDataflowNode_v2 = {}



---@class FPlaneFalloffFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field Position FVector
---@field Normal FVector
---@field Distance float
---@field Translation FVector
---@field Magnitude float
---@field MinRange float
---@field MaxRange float
---@field Default float
---@field FalloffType EDataflowFieldFalloffType
---@field FieldFloatResult TArray<float>
---@field FieldRemap TArray<int32>
---@field FieldSelectionMask FDataflowVertexSelection
---@field NumSamplePositions int32
local FPlaneFalloffFieldDataflowNode = {}



---@class FPointsToMeshDataflowNode : FDataflowNode
---@field Points TArray<FVector>
---@field Mesh UDynamicMesh
---@field TriangleCount int32
local FPointsToMeshDataflowNode = {}



---@class FPowDataflowNode : FDataflowNode
---@field base float
---@field exp float
---@field ReturnValue float
local FPowDataflowNode = {}



---@class FPrintStringDataflowNode : FDataflowNode
---@field bPrintToScreen boolean
---@field bPrintToLog boolean
---@field Color FColor
---@field Duration float
---@field String FString
local FPrintStringDataflowNode = {}



---@class FProximityDataflowNode : FDataflowNode
---@field ProximityMethod EProximityMethodEnum
---@field DistanceThreshold float
---@field ContactThreshold float
---@field FilterContactMethod EProximityContactFilteringMethodEnum
---@field bUseAsConnectionGraph boolean
---@field ContactAreaMethod EConnectionContactAreaMethodEnum
---@field bRecomputeConvexHulls boolean
---@field Collection FManagedArrayCollection
local FProximityDataflowNode = {}



---@class FPruneInCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FPruneInCollectionDataflowNode = {}



---@class FRadialFalloffFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field Sphere FSphere
---@field Translation FVector
---@field Magnitude float
---@field MinRange float
---@field MaxRange float
---@field Default float
---@field FalloffType EDataflowFieldFalloffType
---@field FieldFloatResult TArray<float>
---@field FieldRemap TArray<int32>
---@field FieldSelectionMask FDataflowVertexSelection
---@field NumSamplePositions int32
local FRadialFalloffFieldDataflowNode = {}



---@class FRadialIntMaskFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field Sphere FSphere
---@field Translation FVector
---@field InteriorValue int32
---@field ExteriorValue int32
---@field SetMaskConditionType EDataflowSetMaskConditionType
---@field FieldIntResult TArray<int32>
---@field FieldRemap TArray<int32>
---@field NumSamplePositions int32
local FRadialIntMaskFieldDataflowNode = {}



---@class FRadialScatterPointsDataflowNode : FDataflowNode
---@field Center FVector
---@field Normal FVector
---@field Radius float
---@field AngularSteps int32
---@field RadialSteps int32
---@field AngleOffset float
---@field Variability float
---@field RandomSeed float
---@field Points TArray<FVector>
local FRadialScatterPointsDataflowNode = {}



---@class FRadialScatterPointsDataflowNode_v2 : FDataflowNode
---@field BoundingBox FBox
---@field Center FVector
---@field Normal FVector
---@field RandomSeed int32
---@field AngularSteps int32
---@field AngleOffset float
---@field AngularNoise float
---@field Radius float
---@field RadialSteps int32
---@field RadialStepExponent float
---@field RadialMinStep float
---@field RadialNoise float
---@field RadialVariability float
---@field AngularVariability float
---@field AxialVariability float
---@field Points TArray<FVector>
local FRadialScatterPointsDataflowNode_v2 = {}



---@class FRadialVectorFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field Magnitude float
---@field Position FVector
---@field FieldVectorResult TArray<FVector>
---@field FieldRemap TArray<int32>
---@field NumSamplePositions int32
local FRadialVectorFieldDataflowNode = {}



---@class FRadiansToDegreesDataflowNode : FDataflowNode
---@field Radians float
---@field Degrees float
local FRadiansToDegreesDataflowNode = {}



---@class FRandomFloatDataflowNode : FDataflowNode
---@field bDeterministic boolean
---@field RandomSeed float
---@field ReturnValue float
local FRandomFloatDataflowNode = {}



---@class FRandomFloatInRangeDataflowNode : FDataflowNode
---@field bDeterministic boolean
---@field RandomSeed float
---@field Min float
---@field Max float
---@field ReturnValue float
local FRandomFloatInRangeDataflowNode = {}



---@class FRandomUnitVectorDataflowNode : FDataflowNode
---@field bDeterministic boolean
---@field RandomSeed float
---@field ReturnValue FVector
local FRandomUnitVectorDataflowNode = {}



---@class FRandomUnitVectorInConeDataflowNode : FDataflowNode
---@field bDeterministic boolean
---@field RandomSeed float
---@field ConeDirection FVector
---@field ConeHalfAngle float
---@field ReturnValue FVector
local FRandomUnitVectorInConeDataflowNode = {}



---@class FRandomVectorFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field Magnitude float
---@field FieldVectorResult TArray<FVector>
---@field FieldRemap TArray<int32>
---@field NumSamplePositions int32
local FRandomVectorFieldDataflowNode = {}



---@class FRandomizeFloatArrayDataflowNode : FDataflowNode
---@field FloatArray TArray<float>
---@field RandomRangeMin float
---@field RandomRangeMax float
---@field RandomSeed int32
local FRandomizeFloatArrayDataflowNode = {}



---@class FReAssignMaterialInCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field FaceSelection FDataflowFaceSelection
---@field Materials TArray<UMaterial>
---@field OutsideMaterialIdx int32
---@field InsideMaterialIdx int32
---@field bAssignOutsideMaterial boolean
---@field bAssignInsideMaterial boolean
local FReAssignMaterialInCollectionDataflowNode = {}



---@class FRecomputeNormalsInGeometryCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field bOnlyTangents boolean
---@field bRecomputeSharpEdges boolean
---@field SharpEdgeAngleThreshold float
---@field bOnlyInternalSurfaces boolean
local FRecomputeNormalsInGeometryCollectionDataflowNode = {}



---@class FRemoveFloatArrayElementDataflowNode : FDataflowNode
---@field Index int32
---@field bPreserveOrder boolean
---@field FloatArray TArray<float>
local FRemoveFloatArrayElementDataflowNode = {}



---@class FRemoveOnBreakDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field bEnabledRemoval boolean
---@field PostBreakTimer FVector2f
---@field RemovalTimer FVector2f
---@field bClusterCrumbling boolean
local FRemoveOnBreakDataflowNode = {}



---@class FResampleGeometryCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field AddSamplesForCollision boolean
---@field CollisionSampleSpacing float
local FResampleGeometryCollectionDataflowNode = {}



---@class FRoundDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FRoundDataflowNode = {}



---@class FSafeDivideDataflowNode : FDataflowNode
---@field FloatA float
---@field FloatB float
---@field ReturnValue float
local FSafeDivideDataflowNode = {}



---@class FSafeReciprocalDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FSafeReciprocalDataflowNode = {}



---@class FScaleVectorDataflowNode : FDataflowNode
---@field Vector FVector
---@field Scale float
---@field ScaledVector FVector
local FScaleVectorDataflowNode = {}



---@class FSelectFloatArrayIndicesInRangeDataflowNode : FDataflowNode
---@field Values TArray<float>
---@field Min float
---@field Max float
---@field RangeSetting ERangeSettingEnum
---@field bInclusive boolean
---@field Indices TArray<int32>
local FSelectFloatArrayIndicesInRangeDataflowNode = {}



---@class FSelectionToVertexListDataflowNode : FDataflowNode
---@field VertexSelection FDataflowVertexSelection
---@field VertexList TArray<int32>
local FSelectionToVertexListDataflowNode = {}



---@class FSetAnchorStateDataflowNode : FDataflowNode
---@field AnchorState EAnchorStateEnum
---@field bSetNotSelectedBonesToOppositeState boolean
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
local FSetAnchorStateDataflowNode = {}



---@class FSetCollectionAttributeDataTypedDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field AttributeKey FCollectionAttributeKey
---@field GroupName EStandardGroupNameEnum
---@field CustomGroupName FString
---@field AttrName FString
---@field BoolAttributeData TArray<boolean>
---@field FloatAttributeData TArray<float>
---@field DoubleAttributeData TArray<double>
---@field Int32AttributeData TArray<int32>
---@field StringAttributeData TArray<FString>
---@field Vector3fAttributeData TArray<FVector3f>
---@field Vector3dAttributeData TArray<FVector3d>
---@field LinearColorAttributeData TArray<FLinearColor>
local FSetCollectionAttributeDataTypedDataflowNode = {}



---@class FSetMaterialInMaterialsArrayDataflowNode : FDataflowNode
---@field Materials TArray<UMaterial>
---@field Material UMaterial
---@field Operation ESetMaterialOperationTypeEnum
---@field MaterialIdx int32
local FSetMaterialInMaterialsArrayDataflowNode = {}



---@class FSetVertexColorFromFloatArrayDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field FloatArray TArray<float>
---@field bNormalizeInput boolean
---@field Color FLinearColor
local FSetVertexColorFromFloatArrayDataflowNode = {}



---@class FSetVertexColorFromVertexIndicesDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field VertexIndicesIn TArray<int32>
---@field SelectedColor FLinearColor
local FSetVertexColorFromVertexIndicesDataflowNode = {}



---@class FSetVertexColorFromVertexSelectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field VertexSelection FDataflowVertexSelection
---@field SelectedColor FLinearColor
local FSetVertexColorFromVertexSelectionDataflowNode = {}



---@class FSetVisibilityInCollectionDataflowNode : FDataflowNode
---@field Visibility EVisibiltyOptionsEnum
---@field Collection FManagedArrayCollection
---@field TransformSelection FDataflowTransformSelection
---@field FaceSelection FDataflowFaceSelection
local FSetVisibilityInCollectionDataflowNode = {}



---@class FSignDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FSignDataflowNode = {}



---@class FSimplifyConvexHullsDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field OptionalSelectionFilter FDataflowTransformSelection
---@field SimplifyMethod EConvexHullSimplifyMethod
---@field SimplificationAngleThreshold float
---@field SimplificationDistanceThreshold float
---@field MinTargetTriangleCount int32
---@field bUseExistingVertices boolean
local FSimplifyConvexHullsDataflowNode = {}



---@class FSinDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FSinDataflowNode = {}



---@class FSkeletalMeshToCollectionDataflowNode : FDataflowNode
---@field SkeletalMesh USkeletalMesh
---@field Collection FManagedArrayCollection
---@field bImportTransformOnly boolean
local FSkeletalMeshToCollectionDataflowNode = {}



---@class FSkeletonToCollectionDataflowNode : FDataflowNode
---@field Skeleton USkeleton
---@field Collection FManagedArrayCollection
local FSkeletonToCollectionDataflowNode = {}



---@class FSliceCutterDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field BoundingBox FBox
---@field TransformSelection FDataflowTransformSelection
---@field SlicesX int32
---@field SlicesY int32
---@field SlicesZ int32
---@field SliceAngleVariation float
---@field SliceOffsetVariation float
---@field RandomSeed int32
---@field ChanceToFracture float
---@field SplitIslands boolean
---@field Grout float
---@field Amplitude float
---@field Frequency float
---@field Persistence float
---@field Lacunarity float
---@field OctaveNumber int32
---@field PointSpacing float
---@field AddSamplesForCollision boolean
---@field CollisionSampleSpacing float
---@field NewGeometryTransformSelection FDataflowTransformSelection
local FSliceCutterDataflowNode = {}



---@class FSphereCoveringCountSpheresNode : FDataflowNode
---@field SphereCovering FDataflowSphereCovering
---@field NumSpheres int32
local FSphereCoveringCountSpheresNode = {}



---@class FSphereCoveringToMeshDataflowNode : FDataflowNode
---@field SphereCovering FDataflowSphereCovering
---@field VerticesAlongEachSide int32
---@field Mesh UDynamicMesh
local FSphereCoveringToMeshDataflowNode = {}



---@class FSquareDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FSquareDataflowNode = {}



---@class FSquareRootDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FSquareRootDataflowNode = {}



---@class FStaticMeshToCollectionDataflowNode : FDataflowNode
---@field StaticMesh UStaticMesh
---@field MeshTransform FTransform
---@field bSetInternalFromMaterialIndex boolean
---@field bSplitComponents boolean
---@field Collection FManagedArrayCollection
---@field Materials TArray<UMaterial>
---@field MaterialInstances TArray<UMaterialInterface>
---@field InstancedMeshes TArray<FGeometryCollectionAutoInstanceMesh>
local FStaticMeshToCollectionDataflowNode = {}



---@class FStaticMeshToMeshDataflowNode : FDataflowNode
---@field StaticMesh UStaticMesh
---@field bUseHiRes boolean
---@field LODLevel int32
---@field Mesh UDynamicMesh
local FStaticMeshToMeshDataflowNode = {}



---@class FStringAppendDataflowNode : FDataflowNode
---@field String1 FString
---@field String2 FString
---@field String FString
local FStringAppendDataflowNode = {}



---@class FSubtractDataflowNode : FDataflowNode
---@field FloatA float
---@field FloatB float
---@field ReturnValue float
local FSubtractDataflowNode = {}



---@class FSumScalarFieldDataflowNode : FDataflowNode
---@field FieldFloatLeft TArray<float>
---@field FieldRemapLeft TArray<int32>
---@field FieldFloatRight TArray<float>
---@field FieldRemapRight TArray<int32>
---@field Magnitude float
---@field Operation EDataflowFloatFieldOperationType
---@field bSwapInputs boolean
---@field FieldFloatResult TArray<float>
---@field FieldRemap TArray<int32>
local FSumScalarFieldDataflowNode = {}



---@class FSumVectorFieldDataflowNode : FDataflowNode
---@field FieldFloat TArray<float>
---@field FieldFloatRemap TArray<int32>
---@field FieldVectorLeft TArray<FVector>
---@field FieldRemapLeft TArray<int32>
---@field FieldVectorRight TArray<FVector>
---@field FieldRemapRight TArray<int32>
---@field Magnitude float
---@field Operation EDataflowVectorFieldOperationType
---@field bSwapVectorInputs boolean
---@field FieldVectorResult TArray<FVector>
---@field FieldRemap TArray<int32>
local FSumVectorFieldDataflowNode = {}



---@class FTanDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FTanDataflowNode = {}



---@class FTransformCollectionAttributeDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field TransformIn FTransform
---@field LocalTransform FTransform
---@field GroupName FString
---@field AttributeName FString
local FTransformCollectionAttributeDataflowNode = {}



---@class FTransformCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field Translate FVector
---@field RotationOrder ERotationOrderEnum
---@field Rotate FVector
---@field Scale FVector
---@field UniformScale float
---@field RotatePivot FVector
---@field ScalePivot FVector
---@field bInvertTransformation boolean
local FTransformCollectionDataflowNode = {}



---@class FTransformMeshDataflowNode : FDataflowNode
---@field Mesh UDynamicMesh
---@field Translate FVector
---@field RotationOrder ERotationOrderEnum
---@field Rotate FVector
---@field Scale FVector
---@field UniformScale float
---@field RotatePivot FVector
---@field ScalePivot FVector
---@field bInvertTransformation boolean
local FTransformMeshDataflowNode = {}



---@class FTriangleBoundaryIndicesNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field BoundaryIndicesOut TArray<int32>
local FTriangleBoundaryIndicesNode = {}



---@class FTruncDataflowNode : FDataflowNode
---@field float float
---@field ReturnValue float
local FTruncDataflowNode = {}



---@class FUniformIntegerFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field Magnitude int32
---@field FieldIntResult TArray<int32>
---@field FieldRemap TArray<int32>
---@field NumSamplePositions int32
local FUniformIntegerFieldDataflowNode = {}



---@class FUniformPointSamplingDataflowNode : FDataflowNode
---@field TargetMesh UDynamicMesh
---@field SamplingRadius float
---@field MaxNumSamples int32
---@field SubSampleDensity float
---@field RandomSeed int32
---@field SamplePoints TArray<FVector>
---@field SampleTriangleIDs TArray<int32>
---@field SampleBarycentricCoords TArray<FVector>
---@field NumSamplePoints int32
local FUniformPointSamplingDataflowNode = {}



---@class FUniformScalarFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field Magnitude float
---@field FieldFloatResult TArray<float>
---@field FieldRemap TArray<int32>
---@field NumSamplePositions int32
local FUniformScalarFieldDataflowNode = {}



---@class FUniformScatterPointsDataflowNode : FDataflowNode
---@field MinNumberOfPoints int32
---@field MaxNumberOfPoints int32
---@field RandomSeed float
---@field BoundingBox FBox
---@field Points TArray<FVector>
local FUniformScatterPointsDataflowNode = {}



---@class FUniformScatterPointsDataflowNode_v2 : FDataflowNode
---@field MinNumberOfPoints int32
---@field MaxNumberOfPoints int32
---@field RandomSeed int32
---@field BoundingBox FBox
---@field Points TArray<FVector>
local FUniformScatterPointsDataflowNode_v2 = {}



---@class FUniformVectorFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field Magnitude float
---@field Direction FVector
---@field FieldVectorResult TArray<FVector>
---@field FieldRemap TArray<int32>
---@field NumSamplePositions int32
local FUniformVectorFieldDataflowNode = {}



---@class FUnionIntArraysDataflowNode : FDataflowNode
---@field InArray1 TArray<int32>
---@field InArray2 TArray<int32>
---@field OutArray TArray<int32>
local FUnionIntArraysDataflowNode = {}



---@class FUpdateVolumeAttributesDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
local FUpdateVolumeAttributesDataflowNode = {}



---@class FValidateGeometryCollectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field bRemoveUnreferencedGeometry boolean
---@field bRemoveClustersOfOne boolean
---@field bRemoveDanglingClusters boolean
local FValidateGeometryCollectionDataflowNode = {}



---@class FVectorArrayNormalizeDataflowNode : FDataflowNode
---@field InVectorArray TArray<FVector>
---@field Selection FDataflowVertexSelection
---@field Magnitude float
---@field OutVectorArray TArray<FVector>
local FVectorArrayNormalizeDataflowNode = {}



---@class FVectorToStringDataflowNode : FDataflowNode
---@field Vector FVector
---@field String FString
local FVectorToStringDataflowNode = {}



---@class FVertexWeightedPointSamplingDataflowNode : FDataflowNode
---@field TargetMesh UDynamicMesh
---@field VertexWeights TArray<float>
---@field SamplingRadius float
---@field MaxNumSamples int32
---@field SubSampleDensity float
---@field RandomSeed int32
---@field MaxSamplingRadius float
---@field SizeDistribution ENonUniformSamplingDistributionMode
---@field SizeDistributionPower float
---@field WeightMode ENonUniformSamplingWeightMode
---@field bInvertWeights boolean
---@field SamplePoints TArray<FVector>
---@field SampleRadii TArray<float>
---@field SampleTriangleIDs TArray<int32>
---@field SampleBarycentricCoords TArray<FVector>
---@field NumSamplePoints int32
local FVertexWeightedPointSamplingDataflowNode = {}



---@class FVoronoiFractureDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field Points TArray<FVector>
---@field TransformSelection FDataflowTransformSelection
---@field RandomSeed float
---@field ChanceToFracture float
---@field GroupFracture boolean
---@field Grout float
---@field Amplitude float
---@field Frequency float
---@field Persistence float
---@field Lacunarity float
---@field OctaveNumber int32
---@field PointSpacing float
---@field AddSamplesForCollision boolean
---@field CollisionSampleSpacing float
local FVoronoiFractureDataflowNode = {}



---@class FVoronoiFractureDataflowNode_v2 : FDataflowNode
---@field Collection FManagedArrayCollection
---@field Points TArray<FVector>
---@field TransformSelection FDataflowTransformSelection
---@field Transform FTransform
---@field RandomSeed int32
---@field ChanceToFracture float
---@field SplitIslands boolean
---@field Grout float
---@field Amplitude float
---@field Frequency float
---@field Persistence float
---@field Lacunarity float
---@field OctaveNumber int32
---@field PointSpacing float
---@field AddSamplesForCollision boolean
---@field CollisionSampleSpacing float
---@field NewGeometryTransformSelection FDataflowTransformSelection
local FVoronoiFractureDataflowNode_v2 = {}



---@class FWaveScalarFieldDataflowNode : FDataflowNode
---@field SamplePositions TArray<FVector3f>
---@field SampleIndices FDataflowVertexSelection
---@field Magnitude float
---@field Position FVector
---@field Translation FVector
---@field WaveLength float
---@field Period float
---@field FunctionType EDataflowWaveFunctionType
---@field FalloffType EDataflowFieldFalloffType
---@field FieldFloatResult TArray<float>
---@field FieldRemap TArray<int32>
---@field NumSamplePositions int32
local FWaveScalarFieldDataflowNode = {}



---@class FWrapDataflowNode : FDataflowNode
---@field float float
---@field Min float
---@field Max float
---@field ReturnValue float
local FWrapDataflowNode = {}



---@class FWriteStringToFile : FDataflowNode
---@field FilePath FString
---@field FileContents FString
local FWriteStringToFile = {}



