---@meta

---@class FBakeMultiMeshDetailProperties
---@field SourceMesh UStaticMesh
---@field SourceTexture UTexture2D
---@field SourceTextureUVLayer int32
local FBakeMultiMeshDetailProperties = {}



---@class FBrushToolRadius
---@field SizeType EBrushToolSizeType
---@field AdaptiveSize float
---@field WorldRadius float
local FBrushToolRadius = {}



---@class FEditPivotTarget
---@field TransformProxy UTransformProxy
---@field TransformGizmo UCombinedTransformGizmo
local FEditPivotTarget = {}



---@class FPerlinLayerProperties
---@field Frequency float
---@field Intensity float
local FPerlinLayerProperties = {}



---@class FPhysicsBoxData
---@field Dimensions FVector
---@field Transform FTransform
---@field Element FKShapeElem
local FPhysicsBoxData = {}



---@class FPhysicsCapsuleData
---@field Radius float
---@field Length float
---@field Transform FTransform
---@field Element FKShapeElem
local FPhysicsCapsuleData = {}



---@class FPhysicsConvexData
---@field NumVertices int32
---@field NumFaces int32
---@field Element FKShapeElem
local FPhysicsConvexData = {}



---@class FPhysicsLevelSetData
---@field Element FKShapeElem
local FPhysicsLevelSetData = {}



---@class FPhysicsSphereData
---@field Radius float
---@field Transform FTransform
---@field Element FKShapeElem
local FPhysicsSphereData = {}



---@class FTransformMeshesTarget
---@field TransformProxy UTransformProxy
---@field TransformGizmo UCombinedTransformGizmo
local FTransformMeshesTarget = {}



---@class UAddPatchTool : USingleClickTool
---@field ShapeSettings UAddPatchToolProperties
---@field MaterialProperties UNewMeshMaterialProperties
---@field PreviewMesh UPreviewMesh
local UAddPatchTool = {}



---@class UAddPatchToolBuilder : UInteractiveToolBuilder
local UAddPatchToolBuilder = {}


---@class UAddPatchToolProperties : UInteractiveToolPropertySet
---@field Width float
---@field Rotation float
---@field Subdivisions int32
---@field Shift float
local UAddPatchToolProperties = {}



---@class UAlignObjectsTool : UMultiSelectionMeshEditingTool
---@field AlignProps UAlignObjectsToolProperties
local UAlignObjectsTool = {}



---@class UAlignObjectsToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UAlignObjectsToolBuilder = {}


---@class UAlignObjectsToolProperties : UInteractiveToolPropertySet
---@field AlignType EAlignObjectsAlignTypes
---@field AlignTo EAlignObjectsAlignToOptions
---@field BoxPosition EAlignObjectsBoxPoint
---@field bAlignX boolean
---@field bAlignY boolean
---@field bAlignZ boolean
local UAlignObjectsToolProperties = {}



---@class UBakeCurvatureMapToolProperties : UInteractiveToolPropertySet
---@field CurvatureType EBakeCurvatureTypeMode
---@field ColorMapping EBakeCurvatureColorMode
---@field ColorRangeMultiplier float
---@field MinRangeMultiplier float
---@field Clamping EBakeCurvatureClampMode
local UBakeCurvatureMapToolProperties = {}



---@class UBakeInputMeshProperties : UInteractiveToolPropertySet
---@field TargetStaticMesh UStaticMesh
---@field TargetSkeletalMesh USkeletalMesh
---@field TargetDynamicMesh AActor
---@field TargetUVLayer FString
---@field bHasTargetUVLayer boolean
---@field SourceStaticMesh UStaticMesh
---@field SourceSkeletalMesh USkeletalMesh
---@field SourceDynamicMesh AActor
---@field bHideSourceMesh boolean
---@field SourceNormalMap UTexture2D
---@field SourceNormalMapUVLayer FString
---@field SourceNormalSpace EBakeNormalSpace
---@field bHasSourceNormalMap boolean
---@field ProjectionDistance float
---@field bProjectionInWorldSpace boolean
---@field TargetUVLayerNamesList TArray<FString>
---@field SourceUVLayerNamesList TArray<FString>
local UBakeInputMeshProperties = {}

---@return TArray<FString>
function UBakeInputMeshProperties:GetTargetUVLayerNamesFunc() end
---@return TArray<FString>
function UBakeInputMeshProperties:GetSourceUVLayerNamesFunc() end


---@class UBakeMeshAttributeMapsResultToolProperties : UInteractiveToolPropertySet
---@field Result TMap<EBakeMapType, UTexture2D>
local UBakeMeshAttributeMapsResultToolProperties = {}



---@class UBakeMeshAttributeMapsTool : UBakeMeshAttributeMapsToolBase
---@field InputMeshSettings UBakeInputMeshProperties
---@field Settings UBakeMeshAttributeMapsToolProperties
---@field ResultSettings UBakeMeshAttributeMapsResultToolProperties
---@field UVShellSettings UBakeUVShellMapToolProperties
local UBakeMeshAttributeMapsTool = {}



---@class UBakeMeshAttributeMapsToolBase : UBakeMeshAttributeTool
---@field VisualizationProps UBakeVisualizationProperties
---@field PreviewMesh UPreviewMesh
---@field PreviewMaterial UMaterialInstanceDynamic
---@field BentNormalPreviewMaterial UMaterialInstanceDynamic
---@field CachedMaps TMap<EBakeMapType, UTexture2D>
---@field EmptyNormalMap UTexture2D
---@field EmptyColorMapBlack UTexture2D
---@field EmptyColorMapWhite UTexture2D
local UBakeMeshAttributeMapsToolBase = {}



---@class UBakeMeshAttributeMapsToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UBakeMeshAttributeMapsToolBuilder = {}


---@class UBakeMeshAttributeMapsToolProperties : UInteractiveToolPropertySet
---@field MapTypes int32
---@field MapPreview FString
---@field Resolution EBakeTextureResolution
---@field BitDepth EBakeTextureBitDepth
---@field SamplesPerPixel EBakeTextureSamplesPerPixel
---@field SampleFilterMask UTexture2D
---@field MapPreviewNamesList TArray<FString>
local UBakeMeshAttributeMapsToolProperties = {}

---@return TArray<FString>
function UBakeMeshAttributeMapsToolProperties:GetMapPreviewNamesFunc() end


---@class UBakeMeshAttributeTool : UMultiSelectionMeshEditingTool
---@field OcclusionSettings UBakeOcclusionMapToolProperties
---@field CurvatureSettings UBakeCurvatureMapToolProperties
---@field TextureSettings UBakeTexture2DProperties
---@field MultiTextureSettings UBakeMultiTexture2DProperties
---@field WorkingPreviewMaterial UMaterialInstanceDynamic
---@field ErrorPreviewMaterial UMaterialInstanceDynamic
local UBakeMeshAttributeTool = {}



---@class UBakeMeshAttributeVertexTool : UBakeMeshAttributeTool
---@field InputMeshSettings UBakeInputMeshProperties
---@field Settings UBakeMeshAttributeVertexToolProperties
---@field PreviewMesh UPreviewMesh
---@field PreviewMaterial UMaterialInstanceDynamic
---@field PreviewAlphaMaterial UMaterialInstanceDynamic
local UBakeMeshAttributeVertexTool = {}



---@class UBakeMeshAttributeVertexToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UBakeMeshAttributeVertexToolBuilder = {}


---@class UBakeMeshAttributeVertexToolProperties : UInteractiveToolPropertySet
---@field OutputMode EBakeVertexOutput
---@field OutputType int32
---@field OutputTypeR int32
---@field OutputTypeG int32
---@field OutputTypeB int32
---@field OutputTypeA int32
---@field PreviewMode EBakeVertexChannel
---@field bSplitAtNormalSeams boolean
---@field bSplitAtUVSeams boolean
local UBakeMeshAttributeVertexToolProperties = {}



---@class UBakeMultiMeshAttributeMapsTool : UBakeMeshAttributeMapsToolBase
---@field Settings UBakeMultiMeshAttributeMapsToolProperties
---@field InputMeshSettings UBakeMultiMeshInputToolProperties
---@field ResultSettings UBakeMeshAttributeMapsResultToolProperties
local UBakeMultiMeshAttributeMapsTool = {}



---@class UBakeMultiMeshAttributeMapsToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UBakeMultiMeshAttributeMapsToolBuilder = {}


---@class UBakeMultiMeshAttributeMapsToolProperties : UInteractiveToolPropertySet
---@field MapTypes int32
---@field MapPreview FString
---@field Resolution EBakeTextureResolution
---@field BitDepth EBakeTextureBitDepth
---@field SamplesPerPixel EBakeTextureSamplesPerPixel
---@field SampleFilterMask UTexture2D
---@field MapPreviewNamesList TArray<FString>
local UBakeMultiMeshAttributeMapsToolProperties = {}

---@return TArray<FString>
function UBakeMultiMeshAttributeMapsToolProperties:GetMapPreviewNamesFunc() end


---@class UBakeMultiMeshInputToolProperties : UInteractiveToolPropertySet
---@field TargetStaticMesh UStaticMesh
---@field TargetSkeletalMesh USkeletalMesh
---@field TargetDynamicMesh AActor
---@field TargetUVLayer FString
---@field SourceMeshes TArray<FBakeMultiMeshDetailProperties>
---@field ProjectionDistance float
---@field TargetUVLayerNamesList TArray<FString>
local UBakeMultiMeshInputToolProperties = {}

---@return TArray<FString>
function UBakeMultiMeshInputToolProperties:GetTargetUVLayerNamesFunc() end


---@class UBakeMultiTexture2DProperties : UInteractiveToolPropertySet
---@field MaterialIDSourceTextures TArray<UTexture2D>
---@field UVLayer FString
---@field UVLayerNamesList TArray<FString>
---@field AllSourceTextures TArray<UTexture2D>
local UBakeMultiTexture2DProperties = {}

---@return TArray<FString>
function UBakeMultiTexture2DProperties:GetUVLayerNamesFunc() end


---@class UBakeNormalMapToolProperties : UInteractiveToolPropertySet
local UBakeNormalMapToolProperties = {}


---@class UBakeOcclusionMapToolProperties : UInteractiveToolPropertySet
---@field OcclusionRays int32
---@field MaxDistance float
---@field SpreadAngle float
---@field BiasAngle float
---@field NormalSpace EBakeNormalSpace
local UBakeOcclusionMapToolProperties = {}



---@class UBakeTexture2DProperties : UInteractiveToolPropertySet
---@field SourceTexture UTexture2D
---@field UVLayer FString
---@field UVLayerNamesList TArray<FString>
local UBakeTexture2DProperties = {}

---@return TArray<FString>
function UBakeTexture2DProperties:GetUVLayerNamesFunc() end


---@class UBakeTransformTool : UMultiSelectionMeshEditingTool
---@field BasicProperties UBakeTransformToolProperties
local UBakeTransformTool = {}



---@class UBakeTransformToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UBakeTransformToolBuilder = {}


---@class UBakeTransformToolProperties : UInteractiveToolPropertySet
---@field bApplyToAllLODs boolean
---@field bBakeRotation boolean
---@field BakeScale EBakeScaleMethod
---@field bRecenterPivot boolean
---@field bAllowNoScale boolean
local UBakeTransformToolProperties = {}



---@class UBakeUVShellMapToolProperties : UInteractiveToolPropertySet
---@field UVLayer int32
---@field WireframeThickness float
---@field WireframeColor FLinearColor
---@field ShellColor FLinearColor
---@field BackgroundColor FLinearColor
local UBakeUVShellMapToolProperties = {}



---@class UBakeVisualizationProperties : UInteractiveToolPropertySet
---@field bPreviewAsMaterial boolean
---@field Brightness float
---@field AOMultiplier float
local UBakeVisualizationProperties = {}



---@class UBaseKelvinletBrushOpProps : UMeshSculptBrushOpProps
---@field Stiffness float
---@field Incompressiblity float
---@field BrushSteps int32
local UBaseKelvinletBrushOpProps = {}



---@class UBaseMeshFromSplinesTool : UInteractiveTool
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field MaterialProperties UNewMeshMaterialProperties
---@field Preview UMeshOpPreviewWithBackgroundCompute
---@field TargetWorld TWeakObjectPtr<UWorld>
---@field ActorsWithSplines TArray<TWeakObjectPtr<AActor>>
local UBaseMeshFromSplinesTool = {}



---@class UBaseMeshFromSplinesToolBuilder : UInteractiveToolBuilder
local UBaseMeshFromSplinesToolBuilder = {}


---@class UBasePlaneBrushOpProps : UMeshSculptBrushOpProps
local UBasePlaneBrushOpProps = {}


---@class UBaseSmoothBrushOpProps : UMeshSculptBrushOpProps
local UBaseSmoothBrushOpProps = {}


---@class UBrushRemeshProperties : URemeshProperties
---@field bEnableRemeshing boolean
---@field TriangleSize int32
---@field PreserveDetail int32
---@field Iterations int32
local UBrushRemeshProperties = {}



---@class UCollisionGeometryVisualizationProperties : UInteractiveToolPropertySet
---@field bShowCollision boolean
---@field bShowSolid boolean
---@field LineThickness float
---@field bShowHidden boolean
---@field bRandomColors boolean
---@field Color FColor
---@field LineMaterial UMaterialInterface
---@field LineMaterialShowingHidden UMaterialInterface
---@field TriangleMaterial UMaterialInterface
---@field bEnableShowCollision boolean
---@field bEnableShowSolid boolean
local UCollisionGeometryVisualizationProperties = {}



---@class UConvertMeshesTool : UInteractiveTool
---@field BasicProperties UConvertMeshesToolProperties
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field Inputs TArray<TWeakObjectPtr<UPrimitiveComponent>>
local UConvertMeshesTool = {}



---@class UConvertMeshesToolBuilder : UInteractiveToolBuilder
local UConvertMeshesToolBuilder = {}


---@class UConvertMeshesToolProperties : UInteractiveToolPropertySet
---@field bTransferMaterials boolean
---@field bShowTransferMaterials boolean
---@field bTransferCollision boolean
local UConvertMeshesToolProperties = {}



---@class UConvertToPolygonsOperatorFactory : UObject
---@field ConvertToPolygonsTool UConvertToPolygonsTool
local UConvertToPolygonsOperatorFactory = {}



---@class UConvertToPolygonsTool : USingleTargetWithSelectionTool
---@field Settings UConvertToPolygonsToolProperties
---@field CopyFromLayerProperties UPolygroupLayersProperties
---@field PreviewCompute UMeshOpPreviewWithBackgroundCompute
---@field PreviewGeometry UPreviewGeometry
---@field UnmodifiedAreaPreviewMesh UPreviewMesh
local UConvertToPolygonsTool = {}



---@class UConvertToPolygonsToolBuilder : USingleTargetWithSelectionToolBuilder
local UConvertToPolygonsToolBuilder = {}


---@class UConvertToPolygonsToolProperties : UInteractiveToolPropertySet
---@field ConversionMode EConvertToPolygonsMode
---@field AngleTolerance float
---@field bUseAverageGroupNormal boolean
---@field NumPoints int32
---@field bSplitExisting boolean
---@field bNormalWeighted boolean
---@field NormalWeighting float
---@field QuadAdjacencyWeight float
---@field QuadMetricClamp float
---@field QuadSearchRounds int32
---@field bRespectUVSeams boolean
---@field bRespectHardNormals boolean
---@field MinGroupSize int32
---@field bShowGroupColors boolean
---@field bCalculateNormals boolean
---@field GroupLayer FName
---@field OptionsList TArray<FString>
---@field bShowNewLayerName boolean
---@field NewLayerName FString
local UConvertToPolygonsToolProperties = {}

---@return TArray<FString>
function UConvertToPolygonsToolProperties:GetGroupOptionsList() end


---@class UCubeGridTool : UInteractiveTool
---@field GridGizmo UCombinedTransformGizmo
---@field GridGizmoAlignmentMechanic UDragAlignmentMechanic
---@field GridGizmoTransformProxy UTransformProxy
---@field LineSets UPreviewGeometry
---@field ClickDragBehavior UClickDragInputBehavior
---@field HoverBehavior UMouseHoverBehavior
---@field CtrlMiddleClickBehavior ULocalSingleClickInputBehavior
---@field MiddleClickDragBehavior ULocalClickDragInputBehavior
---@field Settings UCubeGridToolProperties
---@field ToolActions UCubeGridToolActions
---@field MaterialProperties UNewMeshMaterialProperties
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field Target UToolTarget
---@field Preview UMeshOpPreviewWithBackgroundCompute
local UCubeGridTool = {}



---@class UCubeGridToolActions : UInteractiveToolPropertySet
---@field GridSourceActor AActor
local UCubeGridToolActions = {}

function UCubeGridToolActions:SlideForward() end
function UCubeGridToolActions:SlideBack() end
function UCubeGridToolActions:ResetGridFromActor() end
function UCubeGridToolActions:Push() end
function UCubeGridToolActions:Pull() end
function UCubeGridToolActions:Flip() end
function UCubeGridToolActions:CornerMode() end
function UCubeGridToolActions:AcceptAndStartNew() end


---@class UCubeGridToolBuilder : UInteractiveToolWithToolTargetsBuilder
local UCubeGridToolBuilder = {}


---@class UCubeGridToolProperties : UInteractiveToolPropertySet
---@field GridFrameOrigin FVector
---@field GridFrameOrientation FRotator
---@field bShowGrid boolean
---@field bShowGizmo boolean
---@field GridPower uint8
---@field CurrentBlockSize double
---@field BlocksPerStep int32
---@field bPowerOfTwoBlockSizes boolean
---@field BlockBaseSize double
---@field bCrosswiseDiagonal boolean
---@field bKeepSideGroups boolean
---@field bShowSelectionMeasurements boolean
---@field PlaneTolerance double
---@field bHitUnrelatedGeometry boolean
---@field bHitGridGroundPlaneIfCloser boolean
---@field FaceSelectionMode ECubeGridToolFaceSelectionMode
---@field ToggleCornerMode FString
---@field PushPull FString
---@field ResizeGrid FString
---@field FlipSelection FString
---@field GridGizmo FString
---@field QuickShiftGizmo FString
---@field AlignGizmo FString
---@field bInCornerMode boolean
---@field bAllowedToEditGrid boolean
local UCubeGridToolProperties = {}



---@class UDeformMeshPolygonsTool : UMeshSurfacePointTool
---@field PreviewMeshActor AInternalToolFrameworkActor
---@field DynamicMeshComponent UDynamicMeshComponent
---@field TransformProps UDeformMeshPolygonsTransformProperties
local UDeformMeshPolygonsTool = {}



---@class UDeformMeshPolygonsToolBuilder : UMeshSurfacePointMeshEditingToolBuilder
local UDeformMeshPolygonsToolBuilder = {}


---@class UDeformMeshPolygonsTransformProperties : UInteractiveToolPropertySet
---@field DeformationStrategy EGroupTopologyDeformationStrategy
---@field TransformMode EQuickTransformerMode
---@field bSelectFaces boolean
---@field bSelectEdges boolean
---@field bSelectVertices boolean
---@field bShowWireframe boolean
---@field SelectedWeightScheme EWeightScheme
---@field HandleWeight double
---@field bPostFixHandles boolean
local UDeformMeshPolygonsTransformProperties = {}



---@class UDiffusionSmoothProperties : UInteractiveToolPropertySet
---@field SmoothingPerStep float
---@field Steps int32
---@field bPreserveUVs boolean
local UDiffusionSmoothProperties = {}



---@class UDisplaceMeshCommonProperties : UInteractiveToolPropertySet
---@field DisplacementType EDisplaceMeshToolDisplaceType
---@field DisplaceIntensity float
---@field RandomSeed int32
---@field SubdivisionType EDisplaceMeshToolSubdivisionType
---@field Subdivisions int32
---@field WeightMap FName
---@field WeightMapsList TArray<FString>
---@field bInvertWeightMap boolean
---@field bShowWireframe boolean
---@field bDisableSizeWarning boolean
local UDisplaceMeshCommonProperties = {}

---@return TArray<FString>
function UDisplaceMeshCommonProperties:GetWeightMapsFunc() end


---@class UDisplaceMeshDirectionalFilterProperties : UInteractiveToolPropertySet
---@field bEnableFilter boolean
---@field FilterDirection FVector
---@field FilterWidth float
local UDisplaceMeshDirectionalFilterProperties = {}



---@class UDisplaceMeshPerlinNoiseProperties : UInteractiveToolPropertySet
---@field PerlinLayerProperties TArray<FPerlinLayerProperties>
local UDisplaceMeshPerlinNoiseProperties = {}



---@class UDisplaceMeshSineWaveProperties : UInteractiveToolPropertySet
---@field SineWaveFrequency float
---@field SineWavePhaseShift float
---@field SineWaveDirection FVector
local UDisplaceMeshSineWaveProperties = {}



---@class UDisplaceMeshTextureMapProperties : UInteractiveToolPropertySet
---@field DisplacementMap UTexture2D
---@field Channel EDisplaceMeshToolChannelType
---@field DisplacementMapBaseValue float
---@field UVScale FVector2D
---@field UVOffset FVector2D
---@field bApplyAdjustmentCurve boolean
---@field AdjustmentCurve UCurveFloat
---@field bRecalcNormals boolean
local UDisplaceMeshTextureMapProperties = {}



---@class UDisplaceMeshTool : USingleTargetWithSelectionTool
---@field CommonProperties UDisplaceMeshCommonProperties
---@field DirectionalFilterProperties UDisplaceMeshDirectionalFilterProperties
---@field TextureMapProperties UDisplaceMeshTextureMapProperties
---@field NoiseProperties UDisplaceMeshPerlinNoiseProperties
---@field SineWaveProperties UDisplaceMeshSineWaveProperties
---@field SelectiveTessellationProperties USelectiveTessellationProperties
---@field ActiveContrastCurveTarget UCurveFloat
---@field MeshStatistics UMeshStatisticsProperties
---@field PreviewMeshActor AInternalToolFrameworkActor
---@field DynamicMeshComponent UDynamicMeshComponent
local UDisplaceMeshTool = {}



---@class UDisplaceMeshToolBuilder : USingleTargetWithSelectionToolBuilder
local UDisplaceMeshToolBuilder = {}


---@class UDrawPolyPathExtrudeProperties : UInteractiveToolPropertySet
---@field Direction EDrawPolyPathExtrudeDirection
local UDrawPolyPathExtrudeProperties = {}



---@class UDrawPolyPathProperties : UInteractiveToolPropertySet
---@field WidthMode EDrawPolyPathWidthMode
---@field Width float
---@field bRoundedCorners boolean
---@field RadiusMode EDrawPolyPathRadiusMode
---@field CornerRadius float
---@field RadialSlices int32
---@field bSinglePolyGroup boolean
---@field ExtrudeMode EDrawPolyPathExtrudeMode
---@field ExtrudeHeight float
---@field RampStartRatio float
local UDrawPolyPathProperties = {}



---@class UDrawPolyPathTool : UInteractiveTool
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field TransformProps UDrawPolyPathProperties
---@field ExtrudeProperties UDrawPolyPathExtrudeProperties
---@field MaterialProperties UNewMeshMaterialProperties
---@field PlaneMechanic UConstructionPlaneMechanic
---@field EditPreview UPolyEditPreviewMesh
---@field ExtrudeHeightMechanic UPlaneDistanceFromHitMechanic
---@field CurveDistMechanic USpatialCurveDistanceMechanic
---@field SurfacePathMechanic UCollectSurfacePathMechanic
local UDrawPolyPathTool = {}



---@class UDrawPolyPathToolBuilder : UInteractiveToolBuilder
local UDrawPolyPathToolBuilder = {}


---@class UDynamicMeshBrushProperties : UInteractiveToolPropertySet
---@field BrushSize FBrushToolRadius
---@field BrushFalloffAmount float
---@field Depth float
---@field bHitBackFaces boolean
local UDynamicMeshBrushProperties = {}



---@class UDynamicMeshBrushSculptProperties : UInteractiveToolPropertySet
---@field bIsRemeshingEnabled boolean
---@field PrimaryBrushType EDynamicMeshSculptBrushType
---@field PrimaryBrushSpeed float
---@field bPreserveUVFlow boolean
---@field bFreezeTarget boolean
---@field SmoothBrushSpeed float
---@field bDetailPreservingSmooth boolean
local UDynamicMeshBrushSculptProperties = {}



---@class UDynamicMeshBrushTool : UBaseBrushTool
---@field PreviewMesh UPreviewMesh
local UDynamicMeshBrushTool = {}



---@class UDynamicMeshSculptTool : UMeshSurfacePointTool
---@field BrushProperties UDynamicMeshBrushProperties
---@field SculptProperties UDynamicMeshBrushSculptProperties
---@field SculptMaxBrushProperties USculptMaxBrushProperties
---@field KelvinBrushProperties UKelvinBrushProperties
---@field RemeshProperties UBrushRemeshProperties
---@field GizmoProperties UFixedPlaneBrushProperties
---@field ViewProperties UMeshEditingViewProperties
---@field SculptToolActions UDynamicSculptToolActions
---@field BrushIndicator UBrushStampIndicator
---@field BrushIndicatorMaterial UMaterialInstanceDynamic
---@field BrushIndicatorMesh UPreviewMesh
---@field PreviewMeshActor AInternalToolFrameworkActor
---@field DynamicMeshComponent UOctreeDynamicMeshComponent
---@field ActiveOverrideMaterial UMaterialInstanceDynamic
---@field PlaneTransformGizmo UCombinedTransformGizmo
---@field PlaneTransformProxy UTransformProxy
local UDynamicMeshSculptTool = {}



---@class UDynamicMeshSculptToolBuilder : UMeshSurfacePointMeshEditingToolBuilder
local UDynamicMeshSculptToolBuilder = {}


---@class UDynamicSculptToolActions : UInteractiveToolPropertySet
local UDynamicSculptToolActions = {}

function UDynamicSculptToolActions:DiscardAttributes() end


---@class UEditNormalsOperatorFactory : UObject
---@field Tool UEditNormalsTool
local UEditNormalsOperatorFactory = {}



---@class UEditNormalsTool : UMultiSelectionMeshEditingTool
---@field BasicProperties UEditNormalsToolProperties
---@field PolygroupLayerProperties UPolygroupLayersProperties
---@field Previews TArray<UMeshOpPreviewWithBackgroundCompute>
---@field GeometrySelectionVizProperties UGeometrySelectionVisualizationProperties
---@field GeometrySelectionViz UPreviewGeometry
local UEditNormalsTool = {}



---@class UEditNormalsToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UEditNormalsToolBuilder = {}


---@class UEditNormalsToolProperties : UInteractiveToolPropertySet
---@field bRecomputeNormals boolean
---@field NormalCalculationMethod ENormalCalculationMethod
---@field bFixInconsistentNormals boolean
---@field bInvertNormals boolean
---@field SplitNormalMethod ESplitNormalMethod
---@field SharpEdgeAngleThreshold float
---@field bAllowSharpVertices boolean
---@field bToolHasSelection boolean
local UEditNormalsToolProperties = {}



---@class UEditPivotTool : UMultiSelectionMeshEditingTool
---@field TransformProps UEditPivotToolProperties
---@field EditPivotActions UEditPivotToolActionPropertySet
---@field ActiveGizmos TArray<FEditPivotTarget>
---@field DragAlignmentMechanic UDragAlignmentMechanic
local UEditPivotTool = {}



---@class UEditPivotToolActionPropertySet : UInteractiveToolPropertySet
---@field bUseWorldBox boolean
local UEditPivotToolActionPropertySet = {}

function UEditPivotToolActionPropertySet:WorldOrigin() end
function UEditPivotToolActionPropertySet:Top() end
function UEditPivotToolActionPropertySet:Right() end
function UEditPivotToolActionPropertySet:Left() end
function UEditPivotToolActionPropertySet:Front() end
function UEditPivotToolActionPropertySet:Center() end
function UEditPivotToolActionPropertySet:Bottom() end
function UEditPivotToolActionPropertySet:Back() end


---@class UEditPivotToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UEditPivotToolBuilder = {}


---@class UEditPivotToolProperties : UInteractiveToolPropertySet
---@field bApplyToAllLODs boolean
---@field bSnapDragPosition boolean
---@field bSnapDragRotation boolean
---@field RotationMode EEditPivotSnapDragRotationMode
local UEditPivotToolProperties = {}



---@class UEditUVIslandsTool : UMeshSurfacePointTool
---@field MaterialSettings UExistingMeshMaterialProperties
---@field CheckerMaterial UMaterialInstanceDynamic
---@field PreviewMeshActor AInternalToolFrameworkActor
---@field DynamicMeshComponent UDynamicMeshComponent
---@field SelectionMechanic UPolygonSelectionMechanic
---@field TransformGizmo UCombinedTransformGizmo
---@field TransformProxy UTransformProxy
local UEditUVIslandsTool = {}



---@class UEditUVIslandsToolBuilder : UMeshSurfacePointMeshEditingToolBuilder
local UEditUVIslandsToolBuilder = {}


---@class UEraseBrushOpProps : UMeshSculptBrushOpProps
---@field Strength float
---@field Falloff float
local UEraseBrushOpProps = {}



---@class UExtractCollisionGeometryTool : USingleSelectionMeshEditingTool
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field Settings UExtractCollisionToolProperties
---@field VizSettings UCollisionGeometryVisualizationProperties
---@field ObjectProps UPhysicsObjectToolPropertySet
---@field PreviewElements UPreviewGeometry
---@field PreviewMesh UPreviewMesh
local UExtractCollisionGeometryTool = {}



---@class UExtractCollisionGeometryToolBuilder : USingleSelectionMeshEditingToolBuilder
local UExtractCollisionGeometryToolBuilder = {}


---@class UExtractCollisionToolProperties : UInteractiveToolPropertySet
---@field CollisionType EExtractCollisionOutputType
---@field bOutputSeparateMeshes boolean
---@field bShowPreview boolean
---@field bShowInputMesh boolean
---@field bWeldEdges boolean
local UExtractCollisionToolProperties = {}



---@class UExtrudeMeshSelectionTool : USingleTargetWithSelectionTool
---@field ExtrudeProperties UExtrudeMeshSelectionToolProperties
---@field SourcePreview UPreviewMesh
---@field EditCompute UMeshOpPreviewWithBackgroundCompute
---@field TransformGizmo UCombinedTransformGizmo
---@field TransformProxy UTransformProxy
local UExtrudeMeshSelectionTool = {}



---@class UExtrudeMeshSelectionToolBuilder : USingleTargetWithSelectionToolBuilder
local UExtrudeMeshSelectionToolBuilder = {}


---@class UExtrudeMeshSelectionToolProperties : UInteractiveToolPropertySet
---@field InputMode EExtrudeMeshSelectionInteractionMode
---@field ExtrudeDistance double
---@field RegionMode EExtrudeMeshSelectionRegionModifierMode
---@field NumSubdivisions int32
---@field CreaseAngle double
---@field RaycastMaxDistance double
---@field bShellsToSolids boolean
---@field bInferGroupsFromNbrs boolean
---@field bGroupPerSubdivision boolean
---@field bReplaceSelectionGroups boolean
---@field UVScale double
---@field bUVIslandPerGroup boolean
---@field bInferMaterialID boolean
---@field SetMaterialID int32
---@field bShowInputMaterials boolean
local UExtrudeMeshSelectionToolProperties = {}



---@class UFixedPlaneBrushOpProps : UBasePlaneBrushOpProps
---@field Strength float
---@field Falloff float
---@field Depth float
---@field WhichSide EPlaneBrushSideMode
local UFixedPlaneBrushOpProps = {}



---@class UFixedPlaneBrushProperties : UInteractiveToolPropertySet
---@field bPropertySetEnabled boolean
---@field bShowGizmo boolean
---@field Position FVector
---@field Rotation FQuat
local UFixedPlaneBrushProperties = {}



---@class UFlattenBrushOpProps : UMeshSculptBrushOpProps
---@field Strength float
---@field Falloff float
---@field Depth float
---@field WhichSide EPlaneBrushSideMode
local UFlattenBrushOpProps = {}



---@class UGroupEraseBrushOpProps : UMeshSculptBrushOpProps
---@field Group int32
---@field bOnlyEraseCurrent boolean
local UGroupEraseBrushOpProps = {}



---@class UGroupPaintBrushFilterProperties : UInteractiveToolPropertySet
---@field PrimaryBrushType EMeshGroupPaintBrushType
---@field SubToolType EMeshGroupPaintInteractionType
---@field BrushSize float
---@field BrushAreaMode EMeshGroupPaintBrushAreaType
---@field bHitBackFaces boolean
---@field SetGroup int32
---@field bOnlySetUngrouped boolean
---@field EraseGroup int32
---@field bOnlyEraseCurrent boolean
---@field AngleThreshold float
---@field bUVSeams boolean
---@field bNormalSeams boolean
---@field VisibilityFilter EMeshGroupPaintVisibilityType
---@field MinTriVertCount int32
---@field bShowHitGroup boolean
---@field bShowAllGroups boolean
local UGroupPaintBrushFilterProperties = {}



---@class UGroupPaintBrushOpProps : UMeshSculptBrushOpProps
---@field Group int32
---@field bOnlyPaintUngrouped boolean
local UGroupPaintBrushOpProps = {}



---@class UHoleFillOperatorFactory : UObject
---@field FillTool UHoleFillTool
local UHoleFillOperatorFactory = {}



---@class UHoleFillStatisticsProperties : UInteractiveToolPropertySet
---@field InitialHoles FString
---@field SelectedHoles FString
---@field SuccessfulFills FString
---@field FailedFills FString
---@field RemainingHoles FString
local UHoleFillStatisticsProperties = {}



---@class UHoleFillTool : USingleSelectionMeshEditingTool
---@field SmoothHoleFillProperties USmoothHoleFillProperties
---@field Properties UHoleFillToolProperties
---@field Actions UHoleFillToolActions
---@field Statistics UHoleFillStatisticsProperties
---@field Preview UMeshOpPreviewWithBackgroundCompute
---@field SelectionMechanic UBoundarySelectionMechanic
local UHoleFillTool = {}



---@class UHoleFillToolActions : UInteractiveToolPropertySet
local UHoleFillToolActions = {}

function UHoleFillToolActions:SelectAll() end
function UHoleFillToolActions:Clear() end


---@class UHoleFillToolBuilder : USingleSelectionMeshEditingToolBuilder
local UHoleFillToolBuilder = {}


---@class UHoleFillToolProperties : UInteractiveToolPropertySet
---@field FillType EHoleFillOpFillType
---@field bRemoveIsolatedTriangles boolean
---@field bQuickFillSmallHoles boolean
local UHoleFillToolProperties = {}



---@class UImplicitOffsetProperties : UInteractiveToolPropertySet
---@field Smoothness float
---@field bPreserveUVs boolean
local UImplicitOffsetProperties = {}



---@class UImplicitSmoothProperties : UInteractiveToolPropertySet
---@field SmoothSpeed float
---@field Smoothness float
---@field bPreserveUVs boolean
---@field VolumeCorrection float
local UImplicitSmoothProperties = {}



---@class UInflateBrushOpProps : UMeshSculptBrushOpProps
---@field Strength float
---@field Falloff float
local UInflateBrushOpProps = {}



---@class UIterativeOffsetProperties : UInteractiveToolPropertySet
---@field Steps int32
---@field bOffsetBoundaries boolean
---@field SmoothingPerStep float
---@field bReprojectSmooth boolean
local UIterativeOffsetProperties = {}



---@class UIterativeSmoothProperties : UInteractiveToolPropertySet
---@field SmoothingPerStep float
---@field Steps int32
---@field bSmoothBoundary boolean
local UIterativeSmoothProperties = {}



---@class UKelvinBrushProperties : UInteractiveToolPropertySet
---@field FalloffDistance float
---@field Stiffness float
---@field Incompressiblity float
---@field BrushSteps int32
local UKelvinBrushProperties = {}



---@class ULatticeDeformerOperatorFactory : UObject
---@field LatticeDeformerTool ULatticeDeformerTool
local ULatticeDeformerOperatorFactory = {}



---@class ULatticeDeformerTool : UMultiTargetWithSelectionTool
---@field ControlPointsMechanic ULatticeControlPointsMechanic
---@field Settings ULatticeDeformerToolProperties
---@field Preview UMeshOpPreviewWithBackgroundCompute
---@field bLatticeDeformed boolean
local ULatticeDeformerTool = {}



---@class ULatticeDeformerToolBuilder : UMultiTargetWithSelectionToolBuilder
local ULatticeDeformerToolBuilder = {}


---@class ULatticeDeformerToolProperties : UInteractiveToolPropertySet
---@field XAxisResolution int32
---@field YAxisResolution int32
---@field ZAxisResolution int32
---@field Padding float
---@field InterpolationType ELatticeInterpolationType
---@field bDeformNormals boolean
---@field bCanChangeResolution boolean
---@field GizmoCoordinateSystem EToolContextCoordinateSystem
---@field bSetPivotMode boolean
---@field bSoftDeformation boolean
local ULatticeDeformerToolProperties = {}

function ULatticeDeformerToolProperties:Constrain() end
function ULatticeDeformerToolProperties:ClearConstraints() end


---@class UMeshAnalysisProperties : UInteractiveToolPropertySet
---@field SurfaceArea FString
---@field Volume FString
local UMeshAnalysisProperties = {}



---@class UMeshAttributePaintBrushOperationProperties : UInteractiveToolPropertySet
---@field BrushAction EBrushActionMode
local UMeshAttributePaintBrushOperationProperties = {}



---@class UMeshAttributePaintEditActions : UInteractiveToolPropertySet
local UMeshAttributePaintEditActions = {}


---@class UMeshAttributePaintTool : UDynamicMeshBrushTool
---@field BrushActionProps UMeshAttributePaintBrushOperationProperties
---@field AttribProps UMeshAttributePaintToolProperties
local UMeshAttributePaintTool = {}



---@class UMeshAttributePaintToolBuilder : UMeshSurfacePointMeshEditingToolBuilder
local UMeshAttributePaintToolBuilder = {}


---@class UMeshAttributePaintToolProperties : UInteractiveToolPropertySet
---@field Attribute FString
local UMeshAttributePaintToolProperties = {}

---@return TArray<FString>
function UMeshAttributePaintToolProperties:GetAttributeNames() end


---@class UMeshBoundaryToolBase : USingleSelectionMeshEditingTool
---@field SelectionMechanic UPolygonSelectionMechanic
local UMeshBoundaryToolBase = {}



---@class UMeshConstraintProperties : UInteractiveToolPropertySet
---@field bPreserveSharpEdges boolean
---@field MeshBoundaryConstraint EMeshBoundaryConstraint
---@field GroupBoundaryConstraint EGroupBoundaryConstraint
---@field MaterialBoundaryConstraint EMaterialBoundaryConstraint
---@field bPreventNormalFlips boolean
---@field bPreventTinyTriangles boolean
local UMeshConstraintProperties = {}

---@return boolean
function UMeshConstraintProperties:IsPreventTinyTrianglesEnabled() end
---@return boolean
function UMeshConstraintProperties:IsPreventNormalFlipsEnabled() end


---@class UMeshGroupPaintTool : UMeshSculptToolBase
---@field PolygroupLayerProperties UPolygroupLayersProperties
---@field FilterProperties UGroupPaintBrushFilterProperties
---@field PaintBrushOpProperties UGroupPaintBrushOpProps
---@field EraseBrushOpProperties UGroupEraseBrushOpProps
---@field FreezeActions UMeshGroupPaintToolFreezeActions
---@field PolyLassoMechanic UPolyLassoMarqueeMechanic
---@field PreviewMeshActor AInternalToolFrameworkActor
---@field DynamicMeshComponent UDynamicMeshComponent
---@field MeshElementsDisplay UMeshElementsVisualizer
local UMeshGroupPaintTool = {}



---@class UMeshGroupPaintToolActionPropertySet : UInteractiveToolPropertySet
local UMeshGroupPaintToolActionPropertySet = {}


---@class UMeshGroupPaintToolBuilder : UMeshSurfacePointMeshEditingToolBuilder
local UMeshGroupPaintToolBuilder = {}


---@class UMeshGroupPaintToolFreezeActions : UMeshGroupPaintToolActionPropertySet
local UMeshGroupPaintToolFreezeActions = {}

function UMeshGroupPaintToolFreezeActions:UnfreezeAll() end
function UMeshGroupPaintToolFreezeActions:ShrinkCurrent() end
function UMeshGroupPaintToolFreezeActions:GrowCurrent() end
function UMeshGroupPaintToolFreezeActions:FreezeOthers() end
function UMeshGroupPaintToolFreezeActions:FreezeCurrent() end
function UMeshGroupPaintToolFreezeActions:FloodFillCurrent() end
function UMeshGroupPaintToolFreezeActions:ClearCurrent() end
function UMeshGroupPaintToolFreezeActions:ClearAll() end


---@class UMeshInspectorMaterialProperties : UInteractiveToolPropertySet
---@field MaterialMode EMeshInspectorMaterialMode
---@field CheckerDensity float
---@field OverrideMaterial UMaterialInterface
---@field UVChannel FString
---@field UVChannelNamesList TArray<FString>
---@field bFlatShading boolean
---@field Color FLinearColor
---@field Opacity double
---@field TransparentMaterialColor FLinearColor
---@field bTwoSided boolean
---@field CheckerMaterial UMaterialInstanceDynamic
---@field ActiveCustomMaterial UMaterialInstanceDynamic
local UMeshInspectorMaterialProperties = {}

---@return TArray<FString>
function UMeshInspectorMaterialProperties:GetUVChannelNamesFunc() end


---@class UMeshInspectorProperties : UInteractiveToolPropertySet
---@field bWireframe boolean
---@field bBoundaryEdges boolean
---@field bBowtieVertices boolean
---@field bPolygonBorders boolean
---@field bUVSeams boolean
---@field bUVBowties boolean
---@field bMissingUVs boolean
---@field bNormalSeams boolean
---@field bTangentSeams boolean
---@field bNormalVectors boolean
---@field bTangentVectors boolean
---@field bDrawHiddenEdgesAndSeams boolean
---@field NormalLength float
---@field TangentLength float
---@field ShowIndices EMeshInspectorToolDrawIndexMode
local UMeshInspectorProperties = {}



---@class UMeshInspectorTool : USingleSelectionMeshEditingTool
---@field Settings UMeshInspectorProperties
---@field PolygroupLayerProperties UPolygroupLayersProperties
---@field MaterialSettings UMeshInspectorMaterialProperties
---@field PreviewMesh UPreviewMesh
---@field DrawnLineSet ULineSetComponent
---@field DefaultMaterial UMaterialInterface
local UMeshInspectorTool = {}



---@class UMeshInspectorToolBuilder : USingleSelectionMeshEditingToolBuilder
local UMeshInspectorToolBuilder = {}


---@class UMeshSculptBrushOpProps : UInteractiveToolPropertySet
local UMeshSculptBrushOpProps = {}


---@class UMeshSculptToolBase : UMeshSurfacePointTool
---@field BrushProperties USculptBrushProperties
---@field GizmoProperties UWorkPlaneProperties
---@field BrushOpPropSets TMap<int32, UMeshSculptBrushOpProps>
---@field SecondaryBrushOpPropSets TMap<int32, UMeshSculptBrushOpProps>
---@field ViewProperties UMeshEditingViewProperties
---@field ActiveOverrideMaterial UMaterialInstanceDynamic
---@field BrushIndicator UBrushStampIndicator
---@field bIsVolumetricIndicator boolean
---@field BrushIndicatorMaterial UMaterialInstanceDynamic
---@field BrushIndicatorMesh UPreviewMesh
---@field PlaneTransformGizmo UCombinedTransformGizmo
---@field PlaneTransformProxy UTransformProxy
local UMeshSculptToolBase = {}



---@class UMeshSelectionEditActions : UMeshSelectionToolActionPropertySet
local UMeshSelectionEditActions = {}

function UMeshSelectionEditActions:Shrink() end
function UMeshSelectionEditActions:SelectAll() end
function UMeshSelectionEditActions:OptimizeBorder() end
function UMeshSelectionEditActions:LargestTriCountPart() end
function UMeshSelectionEditActions:LargestAreaPart() end
function UMeshSelectionEditActions:Invert() end
function UMeshSelectionEditActions:Grow() end
function UMeshSelectionEditActions:FloodFill() end
function UMeshSelectionEditActions:ExpandToMaterials() end
function UMeshSelectionEditActions:Clear() end


---@class UMeshSelectionMeshEditActions : UMeshSelectionToolActionPropertySet
local UMeshSelectionMeshEditActions = {}

function UMeshSelectionMeshEditActions:SmoothBorder() end
function UMeshSelectionMeshEditActions:Separate() end
function UMeshSelectionMeshEditActions:FlipNormals() end
function UMeshSelectionMeshEditActions:Duplicate() end
function UMeshSelectionMeshEditActions:Disconnect() end
function UMeshSelectionMeshEditActions:Delete() end
function UMeshSelectionMeshEditActions:CreatePolygroup() end


---@class UMeshSelectionTool : UDynamicMeshBrushTool
---@field SelectionProps UMeshSelectionToolProperties
---@field SelectionActions UMeshSelectionEditActions
---@field EditActions UMeshSelectionToolActionPropertySet
---@field MeshStatisticsProperties UMeshStatisticsProperties
---@field MeshElementsDisplay UMeshElementsVisualizer
---@field UVChannelProperties UMeshUVChannelProperties
---@field PolygroupLayerProperties UPolygroupLayersProperties
---@field Selection UMeshSelectionSet
---@field SpawnedActors TArray<AActor>
local UMeshSelectionTool = {}



---@class UMeshSelectionToolActionPropertySet : UInteractiveToolPropertySet
local UMeshSelectionToolActionPropertySet = {}


---@class UMeshSelectionToolBuilder : UMeshSurfacePointMeshEditingToolBuilder
local UMeshSelectionToolBuilder = {}


---@class UMeshSelectionToolProperties : UInteractiveToolPropertySet
---@field SelectionMode EMeshSelectionToolPrimaryMode
---@field AngleTolerance float
---@field bHitBackFaces boolean
---@field bShowPoints boolean
---@field FaceColorMode EMeshFacesColorMode
local UMeshSelectionToolProperties = {}



---@class UMeshSpaceDeformerTool : USingleSelectionMeshEditingTool
---@field Settings UMeshSpaceDeformerToolProperties
---@field ToolActions UMeshSpaceDeformerToolActionPropertySet
---@field StateTarget UGizmoTransformChangeStateTarget
---@field DragAlignmentMechanic UDragAlignmentMechanic
---@field Preview UMeshOpPreviewWithBackgroundCompute
---@field OriginalMeshPreview UPreviewMesh
---@field IntervalGizmo UIntervalGizmo
---@field TransformGizmo UCombinedTransformGizmo
---@field TransformProxy UTransformProxy
---@field UpIntervalSource UGizmoLocalFloatParameterSource
---@field DownIntervalSource UGizmoLocalFloatParameterSource
---@field ForwardIntervalSource UGizmoLocalFloatParameterSource
local UMeshSpaceDeformerTool = {}



---@class UMeshSpaceDeformerToolActionPropertySet : UInteractiveToolPropertySet
local UMeshSpaceDeformerToolActionPropertySet = {}

function UMeshSpaceDeformerToolActionPropertySet:ShiftToCenter() end


---@class UMeshSpaceDeformerToolBuilder : USingleSelectionMeshEditingToolBuilder
local UMeshSpaceDeformerToolBuilder = {}


---@class UMeshSpaceDeformerToolProperties : UInteractiveToolPropertySet
---@field SelectedOperationType ENonlinearOperationType
---@field UpperBoundsInterval float
---@field LowerBoundsInterval float
---@field BendDegrees float
---@field TwistDegrees float
---@field FlareProfileType EFlareProfileType
---@field FlarePercentY float
---@field bLockXAndYFlaring boolean
---@field FlarePercentX float
---@field bLockBottom boolean
---@field bShowOriginalMesh boolean
---@field bDrawVisualization boolean
---@field bAlignToNormalOnCtrlClick boolean
local UMeshSpaceDeformerToolProperties = {}



---@class UMeshStatisticsProperties : UInteractiveToolPropertySet
---@field Mesh FString
---@field UV FString
---@field Attributes FString
local UMeshStatisticsProperties = {}



---@class UMeshSymmetryProperties : UInteractiveToolPropertySet
---@field bEnableSymmetry boolean
---@field bSymmetryCanBeEnabled boolean
local UMeshSymmetryProperties = {}



---@class UMeshVertexPaintTool : UMeshSculptToolBase
---@field PolygroupLayerProperties UPolygroupLayersProperties
---@field BasicProperties UVertexPaintBasicProperties
---@field FilterProperties UVertexPaintBrushFilterProperties
---@field PaintBrushOpProperties UVertexColorPaintBrushOpProps
---@field EraseBrushOpProperties UVertexColorPaintBrushOpProps
---@field QuickActions UMeshVertexPaintToolQuickActions
---@field UtilityActions UMeshVertexPaintToolUtilityActions
---@field PolyLassoMechanic UPolyLassoMarqueeMechanic
---@field PreviewMeshActor AInternalToolFrameworkActor
---@field DynamicMeshComponent UDynamicMeshComponent
---@field MeshElementsDisplay UMeshElementsVisualizer
local UMeshVertexPaintTool = {}



---@class UMeshVertexPaintToolActionPropertySet : UInteractiveToolPropertySet
local UMeshVertexPaintToolActionPropertySet = {}


---@class UMeshVertexPaintToolBuilder : UMeshSurfacePointMeshEditingToolBuilder
local UMeshVertexPaintToolBuilder = {}


---@class UMeshVertexPaintToolQuickActions : UMeshVertexPaintToolActionPropertySet
local UMeshVertexPaintToolQuickActions = {}

function UMeshVertexPaintToolQuickActions:PaintAll() end
function UMeshVertexPaintToolQuickActions:FillWhite() end
function UMeshVertexPaintToolQuickActions:FillBlack() end
function UMeshVertexPaintToolQuickActions:EraseAll() end


---@class UMeshVertexPaintToolUtilityActions : UMeshVertexPaintToolActionPropertySet
---@field Operation EMeshVertexPaintToolUtilityOperations
---@field SourceChannel EMeshVertexPaintColorChannel
---@field SourceValue float
---@field WeightMap FName
---@field WeightMapsList TArray<FString>
---@field TargetChannels FModelingToolsColorChannelFilter
---@field TargetChannel EMeshVertexPaintColorChannel
---@field bCopyToHiRes boolean
---@field CopyToLODName FString
---@field LODNamesList TArray<FString>
local UMeshVertexPaintToolUtilityActions = {}

---@return TArray<FString>
function UMeshVertexPaintToolUtilityActions:GetWeightMapsFunc() end
---@return TArray<FString>
function UMeshVertexPaintToolUtilityActions:GetLODNamesFunc() end
function UMeshVertexPaintToolUtilityActions:ApplySelectedOperation() end


---@class UMeshVertexSculptTool : UMeshSculptToolBase
---@field SculptProperties UVertexBrushSculptProperties
---@field AlphaProperties UVertexBrushAlphaProperties
---@field BrushAlpha UTexture2D
---@field SymmetryProperties UMeshSymmetryProperties
---@field PreviewMeshActor AInternalToolFrameworkActor
---@field DynamicMeshComponent UDynamicMeshComponent
local UMeshVertexSculptTool = {}



---@class UMeshVertexSculptToolBuilder : UMeshSurfacePointMeshEditingToolBuilder
local UMeshVertexSculptToolBuilder = {}


---@class UMirrorOperatorFactory : UObject
---@field MirrorTool UMirrorTool
local UMirrorOperatorFactory = {}



---@class UMirrorTool : UMultiSelectionMeshEditingTool
---@field Settings UMirrorToolProperties
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field HandleSourcesProperties UOnAcceptHandleSourcesProperties
---@field ToolActions UMirrorToolActionPropertySet
---@field MeshesToMirror TArray<UDynamicMeshReplacementChangeTarget>
---@field Previews TArray<UMeshOpPreviewWithBackgroundCompute>
---@field PlaneMechanic UConstructionPlaneMechanic
local UMirrorTool = {}



---@class UMirrorToolActionPropertySet : UInteractiveToolPropertySet
---@field bButtonsOnlyChangeOrientation boolean
local UMirrorToolActionPropertySet = {}

function UMirrorToolActionPropertySet:Up() end
function UMirrorToolActionPropertySet:ShiftToCenter() end
function UMirrorToolActionPropertySet:Right() end
function UMirrorToolActionPropertySet:Left() end
function UMirrorToolActionPropertySet:Forward() end
function UMirrorToolActionPropertySet:Down() end
function UMirrorToolActionPropertySet:Backward() end


---@class UMirrorToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UMirrorToolBuilder = {}


---@class UMirrorToolProperties : UInteractiveToolPropertySet
---@field OperationMode EMirrorOperationMode
---@field bCropAlongMirrorPlaneFirst boolean
---@field bSimplifyAlongCrop boolean
---@field bWeldVerticesOnMirrorPlane boolean
---@field PlaneTolerance double
---@field bAllowBowtieVertexCreation boolean
---@field bShowPreview boolean
---@field WriteTo EMirrorSaveMode
local UMirrorToolProperties = {}



---@class UMoveBrushOpProps : UMeshSculptBrushOpProps
---@field Strength float
---@field Falloff float
---@field Depth float
---@field AxisFilters FModelingToolsAxisFilter
local UMoveBrushOpProps = {}



---@class UOffsetMeshSelectionTool : USingleTargetWithSelectionTool
---@field OffsetProperties UOffsetMeshSelectionToolProperties
---@field SourcePreview UPreviewMesh
---@field EditCompute UMeshOpPreviewWithBackgroundCompute
local UOffsetMeshSelectionTool = {}



---@class UOffsetMeshSelectionToolBuilder : USingleTargetWithSelectionToolBuilder
local UOffsetMeshSelectionToolBuilder = {}


---@class UOffsetMeshSelectionToolProperties : UInteractiveToolPropertySet
---@field OffsetDistance double
---@field Direction EOffsetMeshSelectionDirectionMode
---@field NumSubdivisions int32
---@field CreaseAngle double
---@field bShellsToSolids boolean
---@field bInferGroupsFromNbrs boolean
---@field bGroupPerSubdivision boolean
---@field bReplaceSelectionGroups boolean
---@field UVScale double
---@field bUVIslandPerGroup boolean
---@field bInferMaterialID boolean
---@field SetMaterialID int32
---@field bShowInputMaterials boolean
local UOffsetMeshSelectionToolProperties = {}



---@class UOffsetMeshTool : UBaseMeshProcessingTool
---@field OffsetProperties UOffsetMeshToolProperties
---@field IterativeProperties UIterativeOffsetProperties
---@field ImplicitProperties UImplicitOffsetProperties
---@field WeightMapProperties UOffsetWeightMapSetProperties
local UOffsetMeshTool = {}



---@class UOffsetMeshToolBuilder : UBaseMeshProcessingToolBuilder
local UOffsetMeshToolBuilder = {}


---@class UOffsetMeshToolProperties : UInteractiveToolPropertySet
---@field OffsetType EOffsetMeshToolOffsetType
---@field Distance float
---@field bCreateShell boolean
local UOffsetMeshToolProperties = {}



---@class UOffsetWeightMapSetProperties : UWeightMapSetProperties
---@field MinDistance float
local UOffsetWeightMapSetProperties = {}



---@class UPatternTool : UMultiSelectionMeshEditingTool
---@field Settings UPatternToolSettings
---@field BoundingBoxSettings UPatternTool_BoundingBoxSettings
---@field LinearSettings UPatternTool_LinearSettings
---@field GridSettings UPatternTool_GridSettings
---@field RadialSettings UPatternTool_RadialSettings
---@field RotationSettings UPatternTool_RotationSettings
---@field TranslationSettings UPatternTool_TranslationSettings
---@field ScaleSettings UPatternTool_ScaleSettings
---@field OutputSettings UPatternTool_OutputSettings
---@field PatternGizmoProxy UComponentBoundTransformProxy
---@field PatternGizmo UInteractiveGizmo
---@field PatternGizmoComponent UPrimitiveComponent
---@field DragAlignmentMechanic UDragAlignmentMechanic
---@field PlaneMechanic UConstructionPlaneMechanic
---@field AllComponents TSet<UPrimitiveComponent>
---@field PreviewGeometry UPreviewGeometry
local UPatternTool = {}



---@class UPatternToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UPatternToolBuilder = {}


---@class UPatternToolSettings : UInteractiveToolPropertySet
---@field Seed int32
---@field bProjectElementsDown boolean
---@field ProjectionOffset float
---@field bHideSources boolean
---@field bUseRelativeTransforms boolean
---@field bRandomlyPickElements boolean
---@field Shape EPatternToolShape
---@field SingleAxis EPatternToolSingleAxis
---@field SinglePlane EPatternToolSinglePlane
local UPatternToolSettings = {}



---@class UPatternTool_BoundingBoxSettings : UInteractiveToolPropertySet
---@field bIgnoreTransforms boolean
---@field Adjustment float
---@field bVisualize boolean
local UPatternTool_BoundingBoxSettings = {}



---@class UPatternTool_GridSettings : UInteractiveToolPropertySet
---@field SpacingX EPatternToolAxisSpacingMode
---@field CountX int32
---@field StepSizeX double
---@field ExtentX double
---@field bCenteredX boolean
---@field SpacingY EPatternToolAxisSpacingMode
---@field CountY int32
---@field StepSizeY double
---@field ExtentY double
---@field bCenteredY boolean
local UPatternTool_GridSettings = {}



---@class UPatternTool_LinearSettings : UInteractiveToolPropertySet
---@field SpacingMode EPatternToolAxisSpacingMode
---@field Count int32
---@field StepSize double
---@field Extent double
---@field bCentered boolean
local UPatternTool_LinearSettings = {}



---@class UPatternTool_OutputSettings : UInteractiveToolPropertySet
---@field bSeparateActors boolean
---@field bConvertToDynamic boolean
---@field bCreateISMCs boolean
---@field bHaveStaticMeshes boolean
---@field bEnableCreateISMCs boolean
local UPatternTool_OutputSettings = {}



---@class UPatternTool_RadialSettings : UInteractiveToolPropertySet
---@field SpacingMode EPatternToolAxisSpacingMode
---@field Count int32
---@field StepSize double
---@field Radius double
---@field StartAngle double
---@field EndAngle double
---@field AngleShift double
---@field bOriented boolean
local UPatternTool_RadialSettings = {}



---@class UPatternTool_RotationSettings : UInteractiveToolPropertySet
---@field bInterpolate boolean
---@field bJitter boolean
---@field StartRotation FRotator
---@field EndRotation FRotator
---@field Jitter FRotator
local UPatternTool_RotationSettings = {}



---@class UPatternTool_ScaleSettings : UInteractiveToolPropertySet
---@field bProportional boolean
---@field bInterpolate boolean
---@field bJitter boolean
---@field StartScale FVector
---@field EndScale FVector
---@field Jitter FVector
local UPatternTool_ScaleSettings = {}



---@class UPatternTool_TranslationSettings : UInteractiveToolPropertySet
---@field bInterpolate boolean
---@field bJitter boolean
---@field StartTranslation FVector
---@field EndTranslation FVector
---@field Jitter FVector
local UPatternTool_TranslationSettings = {}



---@class UPhysicsInspectorTool : UMultiSelectionMeshEditingTool
---@field VizSettings UCollisionGeometryVisualizationProperties
---@field objectData TArray<UPhysicsObjectToolPropertySet>
---@field PreviewElements TArray<UPreviewGeometry>
local UPhysicsInspectorTool = {}



---@class UPhysicsInspectorToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UPhysicsInspectorToolBuilder = {}


---@class UPhysicsObjectToolPropertySet : UInteractiveToolPropertySet
---@field ObjectName FString
---@field CollisionType ECollisionGeometryMode
---@field Spheres TArray<FPhysicsSphereData>
---@field Boxes TArray<FPhysicsBoxData>
---@field Capsules TArray<FPhysicsCapsuleData>
---@field Convexes TArray<FPhysicsConvexData>
---@field LevelSets TArray<FPhysicsLevelSetData>
local UPhysicsObjectToolPropertySet = {}



---@class UPinchBrushOpProps : UMeshSculptBrushOpProps
---@field Strength float
---@field Falloff float
---@field Depth float
---@field bPerpDamping boolean
local UPinchBrushOpProps = {}



---@class UPlaneBrushOpProps : UBasePlaneBrushOpProps
---@field Strength float
---@field Falloff float
---@field Depth float
---@field WhichSide EPlaneBrushSideMode
local UPlaneBrushOpProps = {}



---@class UPlaneCutOperatorFactory : UObject
---@field CutTool UPlaneCutTool
local UPlaneCutOperatorFactory = {}



---@class UPlaneCutTool : UMultiSelectionMeshEditingTool
---@field BasicProperties UPlaneCutToolProperties
---@field Previews TArray<UMeshOpPreviewWithBackgroundCompute>
---@field MeshesToCut TArray<UDynamicMeshReplacementChangeTarget>
---@field PlaneMechanic UConstructionPlaneMechanic
local UPlaneCutTool = {}

function UPlaneCutTool:FlipPlane() end
function UPlaneCutTool:Cut() end


---@class UPlaneCutToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UPlaneCutToolBuilder = {}


---@class UPlaneCutToolProperties : UInteractiveToolPropertySet
---@field bKeepBothHalves boolean
---@field SpacingBetweenHalves float
---@field bExportSeparatedPiecesAsNewMeshAssets boolean
---@field bShowPreview boolean
---@field bFillCutHole boolean
---@field bFillSpans boolean
---@field bSimplifyAlongCut boolean
local UPlaneCutToolProperties = {}



---@class UProjectToTargetTool : URemeshMeshTool
local UProjectToTargetTool = {}


---@class UProjectToTargetToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UProjectToTargetToolBuilder = {}


---@class UProjectToTargetToolProperties : URemeshMeshToolProperties
---@field bWorldSpace boolean
---@field bParallel boolean
---@field FaceProjectionPassesPerRemeshIteration int32
---@field SurfaceProjectionSpeed float
---@field NormalAlignmentSpeed float
---@field bSmoothInFillAreas boolean
---@field FillAreaDistanceMultiplier float
---@field FillAreaSmoothMultiplier float
local UProjectToTargetToolProperties = {}



---@class UPullKelvinletBrushOpProps : UBaseKelvinletBrushOpProps
---@field Falloff float
---@field Depth float
local UPullKelvinletBrushOpProps = {}



---@class URemeshMeshTool : UMultiSelectionMeshEditingTool
---@field BasicProperties URemeshMeshToolProperties
---@field MeshStatisticsProperties UMeshStatisticsProperties
---@field Preview UMeshOpPreviewWithBackgroundCompute
---@field MeshElementsDisplay UMeshElementsVisualizer
local URemeshMeshTool = {}



---@class URemeshMeshToolBuilder : UMultiSelectionMeshEditingToolBuilder
local URemeshMeshToolBuilder = {}


---@class URemeshMeshToolProperties : URemeshProperties
---@field TargetTriangleCount int32
---@field SmoothingType ERemeshSmoothingType
---@field bDiscardAttributes boolean
---@field bShowGroupColors boolean
---@field RemeshType ERemeshType
---@field RemeshIterations int32
---@field MaxRemeshIterations int32
---@field ExtraProjectionIterations int32
---@field bUseTargetEdgeLength boolean
---@field TargetEdgeLength float
---@field bReproject boolean
---@field bReprojectConstraints boolean
---@field BoundaryCornerAngleThreshold float
local URemeshMeshToolProperties = {}



---@class URemeshProperties : UMeshConstraintProperties
---@field SmoothingStrength float
---@field bFlips boolean
---@field bSplits boolean
---@field bCollapses boolean
local URemeshProperties = {}



---@class URemoveOccludedTrianglesAdvancedProperties : UInteractiveToolPropertySet
local URemoveOccludedTrianglesAdvancedProperties = {}


---@class URemoveOccludedTrianglesOperatorFactory : UObject
---@field Tool URemoveOccludedTrianglesTool
local URemoveOccludedTrianglesOperatorFactory = {}



---@class URemoveOccludedTrianglesTool : UMultiSelectionMeshEditingTool
---@field BasicProperties URemoveOccludedTrianglesToolProperties
---@field PolygroupLayersProperties UPolygroupLayersProperties
---@field AdvancedProperties URemoveOccludedTrianglesAdvancedProperties
---@field Previews TArray<UMeshOpPreviewWithBackgroundCompute>
---@field PreviewCopies TArray<UPreviewMesh>
local URemoveOccludedTrianglesTool = {}



---@class URemoveOccludedTrianglesToolBuilder : UMultiSelectionMeshEditingToolBuilder
local URemoveOccludedTrianglesToolBuilder = {}


---@class URemoveOccludedTrianglesToolProperties : UInteractiveToolPropertySet
---@field OcclusionTestMethod EOcclusionCalculationUIMode
---@field TriangleSampling EOcclusionTriangleSamplingUIMode
---@field WindingIsoValue double
---@field AddRandomRays int32
---@field AddTriangleSamples int32
---@field bOnlySelfOcclude boolean
---@field ShrinkRemoval int32
---@field MinAreaIsland double
---@field MinTriCountIsland int32
---@field Action EOccludedAction
local URemoveOccludedTrianglesToolProperties = {}



---@class URevolveBoundaryOperatorFactory : UObject
---@field RevolveBoundaryTool URevolveBoundaryTool
local URevolveBoundaryOperatorFactory = {}



---@class URevolveBoundaryTool : UMeshBoundaryToolBase
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field Settings URevolveBoundaryToolProperties
---@field MaterialProperties UNewMeshMaterialProperties
---@field PlaneMechanic UConstructionPlaneMechanic
---@field Preview UMeshOpPreviewWithBackgroundCompute
local URevolveBoundaryTool = {}



---@class URevolveBoundaryToolBuilder : USingleSelectionMeshEditingToolBuilder
local URevolveBoundaryToolBuilder = {}


---@class URevolveBoundaryToolProperties : URevolveProperties
---@field CapFillMode ERevolvePropertiesCapFillMode
---@field bDisplayInputMesh boolean
---@field AxisOrigin FVector
---@field AxisOrientation FVector2D
local URevolveBoundaryToolProperties = {}



---@class URevolveSplineTool : UBaseMeshFromSplinesTool
---@field Settings URevolveSplineToolProperties
---@field ToolActions URevolveSplineToolActionPropertySet
---@field PlaneMechanic UConstructionPlaneMechanic
local URevolveSplineTool = {}



---@class URevolveSplineToolActionPropertySet : UInteractiveToolPropertySet
local URevolveSplineToolActionPropertySet = {}

function URevolveSplineToolActionPropertySet:ResetAxis() end


---@class URevolveSplineToolBuilder : UBaseMeshFromSplinesToolBuilder
local URevolveSplineToolBuilder = {}


---@class URevolveSplineToolProperties : URevolveProperties
---@field SampleMode ERevolveSplineSampleMode
---@field ErrorTolerance double
---@field MaxSampleDistance double
---@field CapFillMode ERevolvePropertiesCapFillMode
---@field bClosePathToAxis boolean
---@field AxisOrigin FVector
---@field AxisOrientation FVector2D
---@field bResetAxisOnStart boolean
local URevolveSplineToolProperties = {}



---@class UScaleKelvinletBrushOpProps : UBaseKelvinletBrushOpProps
---@field Strength float
---@field Falloff float
local UScaleKelvinletBrushOpProps = {}



---@class USculptBrushProperties : UInteractiveToolPropertySet
---@field BrushSize FBrushToolRadius
---@field BrushFalloffAmount float
---@field bShowFalloff boolean
---@field Depth float
---@field bHitBackFaces boolean
---@field FlowRate float
---@field Spacing float
---@field Lazyness float
---@field bShowPerBrushProps boolean
---@field bShowLazyness boolean
---@field bShowFlowRate boolean
---@field bShowSpacing boolean
local USculptBrushProperties = {}



---@class USculptMaxBrushOpProps : UMeshSculptBrushOpProps
---@field Strength float
---@field Falloff float
---@field MaxHeight float
---@field bUseFixedHeight boolean
---@field FixedHeight float
local USculptMaxBrushOpProps = {}



---@class USculptMaxBrushProperties : UInteractiveToolPropertySet
---@field MaxHeight float
---@field bFreezeCurrentHeight boolean
local USculptMaxBrushProperties = {}



---@class USeamSculptTool : UDynamicMeshBrushTool
---@field Settings USeamSculptToolProperties
---@field PreviewGeom UPreviewGeometry
local USeamSculptTool = {}



---@class USeamSculptToolBuilder : UMeshSurfacePointMeshEditingToolBuilder
local USeamSculptToolBuilder = {}


---@class USeamSculptToolProperties : UInteractiveToolPropertySet
---@field bShowWireframe boolean
---@field bHitBackFaces boolean
---@field PathSimilarityWeight double
local USeamSculptToolProperties = {}



---@class USecondarySmoothBrushOpProps : UBaseSmoothBrushOpProps
---@field Strength float
---@field Falloff float
---@field bPreserveUVFlow boolean
local USecondarySmoothBrushOpProps = {}



---@class USelectiveTessellationProperties : UInteractiveToolPropertySet
---@field SelectionType EDisplaceMeshToolTriangleSelectionType
---@field ActiveMaterial FName
---@field MaterialIDList TArray<FString>
local USelectiveTessellationProperties = {}

---@return TArray<FString>
function USelectiveTessellationProperties:GetMaterialIDsFunc() end


---@class USelfUnionMeshesTool : UBaseCreateFromSelectedTool
---@field Properties USelfUnionMeshesToolProperties
---@field DrawnLineSet ULineSetComponent
local USelfUnionMeshesTool = {}



---@class USelfUnionMeshesToolBuilder : UBaseCreateFromSelectedToolBuilder
local USelfUnionMeshesToolBuilder = {}


---@class USelfUnionMeshesToolProperties : UInteractiveToolPropertySet
---@field bTrimFlaps boolean
---@field bTryFixHoles boolean
---@field bTryCollapseEdges boolean
---@field WindingThreshold float
---@field bShowNewBoundaryEdges boolean
---@field bOnlyUseFirstMeshMaterials boolean
local USelfUnionMeshesToolProperties = {}



---@class USetCollisionGeometryTool : UMultiSelectionMeshEditingTool
---@field Settings USetCollisionGeometryToolProperties
---@field PolygroupLayerProperties UPolygroupLayersProperties
---@field VizSettings UCollisionGeometryVisualizationProperties
---@field CollisionProps UPhysicsObjectToolPropertySet
---@field PreviewGeom UPreviewGeometry
---@field GeometrySelectionVizProperties UGeometrySelectionVisualizationProperties
---@field GeometrySelectionViz UPreviewGeometry
local USetCollisionGeometryTool = {}



---@class USetCollisionGeometryToolBuilder : UMultiSelectionMeshEditingToolBuilder
local USetCollisionGeometryToolBuilder = {}


---@class USetCollisionGeometryToolProperties : UInteractiveToolPropertySet
---@field GeometryType ECollisionGeometryType
---@field bAppendToExisting boolean
---@field bUseWorldSpace boolean
---@field InputMode ESetCollisionGeometryInputMode
---@field bRemoveContained boolean
---@field bEnableMaxCount boolean
---@field MaxCount int32
---@field MinThickness float
---@field bDetectBoxes boolean
---@field bDetectSpheres boolean
---@field bDetectCapsules boolean
---@field bMergeCollisionShapes boolean
---@field MergeAboveCount int32
---@field bUseNegativeSpaceInMerge boolean
---@field bSimplifyHulls boolean
---@field HullTargetFaceCount int32
---@field bPreSimplifyToEdgeLength boolean
---@field DecompositionTargetEdgeLength double
---@field DecompositionMethod EConvexDecompositionMethod
---@field bLimitHullsPerShape boolean
---@field MaxHullsPerShape int32
---@field ConvexDecompositionSearchFactor float
---@field AddHullsErrorTolerance float
---@field MinPartThickness float
---@field NegativeSpaceTolerance double
---@field NegativeSpaceMinRadius double
---@field bIgnoreInternalNegativeSpace boolean
---@field HullTolerance float
---@field SweepAxis EProjectedHullAxis
---@field LevelSetResolution int32
---@field SetCollisionType ECollisionGeometryMode
---@field bShowTargetMesh boolean
---@field bUsingMultipleInputs boolean
local USetCollisionGeometryToolProperties = {}



---@class USharpPullKelvinletBrushOpProps : UBaseKelvinletBrushOpProps
---@field Falloff float
---@field Depth float
local USharpPullKelvinletBrushOpProps = {}



---@class USimpleCollisionEditorTool : USingleSelectionMeshEditingTool
---@field ActionProperties USimpleCollisionEditorToolActionProperties
local USimpleCollisionEditorTool = {}



---@class USimpleCollisionEditorToolActionProperties : UInteractiveToolPropertySet
local USimpleCollisionEditorToolActionProperties = {}

function USimpleCollisionEditorToolActionProperties:Duplicate() end
function USimpleCollisionEditorToolActionProperties:DeleteAll() end
function USimpleCollisionEditorToolActionProperties:Delete() end
function USimpleCollisionEditorToolActionProperties:AddSphere() end
function USimpleCollisionEditorToolActionProperties:AddCapsule() end
function USimpleCollisionEditorToolActionProperties:AddBox() end


---@class USimpleCollisionEditorToolBuilder : USingleSelectionMeshEditingToolBuilder
local USimpleCollisionEditorToolBuilder = {}


---@class USmoothBrushOpProps : UBaseSmoothBrushOpProps
---@field Strength float
---@field Falloff float
---@field bPreserveUVFlow boolean
local USmoothBrushOpProps = {}



---@class USmoothFillBrushOpProps : UBaseSmoothBrushOpProps
---@field Strength float
---@field Falloff float
---@field bPreserveUVFlow boolean
local USmoothFillBrushOpProps = {}



---@class USmoothHoleFillProperties : UInteractiveToolPropertySet
---@field bConstrainToHoleInterior boolean
---@field RemeshingExteriorRegionWidth int32
---@field SmoothingExteriorRegionWidth int32
---@field SmoothingInteriorRegionWidth int32
---@field InteriorSmoothness float
---@field FillDensityScalar double
---@field bProjectDuringRemesh boolean
local USmoothHoleFillProperties = {}



---@class USmoothMeshTool : UBaseMeshProcessingTool
---@field SmoothProperties USmoothMeshToolProperties
---@field IterativeProperties UIterativeSmoothProperties
---@field DiffusionProperties UDiffusionSmoothProperties
---@field ImplicitProperties UImplicitSmoothProperties
---@field WeightMapProperties USmoothWeightMapSetProperties
local USmoothMeshTool = {}



---@class USmoothMeshToolBuilder : UBaseMeshProcessingToolBuilder
local USmoothMeshToolBuilder = {}


---@class USmoothMeshToolProperties : UInteractiveToolPropertySet
---@field SmoothingType ESmoothMeshToolSmoothType
local USmoothMeshToolProperties = {}



---@class USmoothWeightMapSetProperties : UWeightMapSetProperties
---@field MinSmoothMultiplier float
local USmoothWeightMapSetProperties = {}



---@class USpaceDeformerOperatorFactory : UObject
---@field SpaceDeformerTool UMeshSpaceDeformerTool
local USpaceDeformerOperatorFactory = {}



---@class USplitMeshesTool : UMultiTargetWithSelectionTool
---@field BasicProperties USplitMeshesToolProperties
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field PerTargetPreviews TArray<UPreviewGeometry>
---@field PreviewMaterial UMaterialInterface
local USplitMeshesTool = {}



---@class USplitMeshesToolBuilder : UMultiTargetWithSelectionToolBuilder
local USplitMeshesToolBuilder = {}


---@class USplitMeshesToolProperties : UInteractiveToolPropertySet
---@field SplitMethod ESplitMeshesMethod
---@field ConnectVerticesThreshold double
---@field bTransferMaterials boolean
---@field bShowPreview boolean
---@field bIsInSelectionMode boolean
local USplitMeshesToolProperties = {}



---@class UStandardSculptBrushOpProps : UMeshSculptBrushOpProps
---@field Strength float
---@field Falloff float
local UStandardSculptBrushOpProps = {}



---@class UTransferMeshTool : UMultiSelectionMeshEditingTool
---@field BasicProperties UTransferMeshToolProperties
local UTransferMeshTool = {}



---@class UTransferMeshToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UTransferMeshToolBuilder = {}


---@class UTransferMeshToolProperties : UInteractiveToolPropertySet
---@field bTransferMaterials boolean
---@field bTransferCollision boolean
---@field SourceLOD FString
---@field TargetLod FString
---@field bIsStaticMeshSource boolean
---@field SourceLODNamesList TArray<FString>
---@field TargetLODNamesList TArray<FString>
---@field bIsStaticMeshTarget boolean
local UTransferMeshToolProperties = {}

---@return TArray<FString>
function UTransferMeshToolProperties:GetTargetLODNamesFunc() end
---@return TArray<FString>
function UTransferMeshToolProperties:GetSourceLODNamesFunc() end


---@class UTransformMeshesTool : UMultiSelectionMeshEditingTool
---@field TransformProps UTransformMeshesToolProperties
---@field ActiveGizmos TArray<FTransformMeshesTarget>
---@field DragAlignmentMechanic UDragAlignmentMechanic
local UTransformMeshesTool = {}



---@class UTransformMeshesToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UTransformMeshesToolBuilder = {}


---@class UTransformMeshesToolProperties : UInteractiveToolPropertySet
---@field TransformMode ETransformMeshesTransformMode
---@field bApplyToInstances boolean
---@field bSetPivotMode boolean
---@field bEnableSnapDragging boolean
---@field SnapDragSource ETransformMeshesSnapDragSource
---@field RotationMode ETransformMeshesSnapDragRotationMode
---@field bHaveInstances boolean
local UTransformMeshesToolProperties = {}



---@class UTriangulateSplinesTool : UBaseMeshFromSplinesTool
---@field TriangulateProperties UTriangulateSplinesToolProperties
local UTriangulateSplinesTool = {}



---@class UTriangulateSplinesToolBuilder : UBaseMeshFromSplinesToolBuilder
local UTriangulateSplinesToolBuilder = {}


---@class UTriangulateSplinesToolProperties : UInteractiveToolPropertySet
---@field ErrorTolerance double
---@field FlattenMethod EFlattenCurveMethod
---@field CombineMethod ECombineCurvesMethod
---@field Thickness double
---@field bFlipResult boolean
---@field OpenCurves EOffsetOpenCurvesMethod
---@field CurveOffset double
---@field OffsetClosedCurves EOffsetClosedCurvesMethod
---@field EndShapes EOpenCurveEndShapes
---@field JoinMethod EOffsetJoinMethod
---@field MiterLimit double
local UTriangulateSplinesToolProperties = {}



---@class UTwistKelvinletBrushOpProps : UBaseKelvinletBrushOpProps
---@field Strength float
---@field Falloff float
local UTwistKelvinletBrushOpProps = {}



---@class UUVTransferTool : UMultiTargetWithSelectionTool
---@field Settings UUVTransferToolProperties
---@field UVChannelProperties UMeshUVChannelProperties
---@field DestinationMaterialSettings UExistingMeshMaterialProperties
---@field DestinationPreview UMeshOpPreviewWithBackgroundCompute
---@field SourcePreview UPreviewMesh
---@field SourceSeamVisualizer UMeshElementsVisualizer
---@field DestinationSeamVisualizer UMeshElementsVisualizer
local UUVTransferTool = {}



---@class UUVTransferToolBuilder : UMultiTargetWithSelectionToolBuilder
local UUVTransferToolBuilder = {}


---@class UUVTransferToolProperties : UInteractiveToolPropertySet
---@field bReverseDirection boolean
---@field bTransferSeamsOnly boolean
---@field bClearExistingSeams boolean
---@field PathSimilarityWeight double
---@field bShowWireframes boolean
---@field bShowSeams boolean
---@field VertexSearchDistance double
local UUVTransferToolProperties = {}



---@class UVertexBrushAlphaProperties : UInteractiveToolPropertySet
---@field Alpha UTexture2D
---@field RotationAngle float
---@field bRandomize boolean
---@field RandomRange float
---@field Tool TWeakObjectPtr<UMeshVertexSculptTool>
local UVertexBrushAlphaProperties = {}



---@class UVertexBrushSculptProperties : UInteractiveToolPropertySet
---@field PrimaryBrushType EMeshVertexSculptBrushType
---@field PrimaryFalloffType EMeshSculptFalloffType
---@field BrushFilter EMeshVertexSculptBrushFilterType
---@field bFreezeTarget boolean
---@field Tool TWeakObjectPtr<UMeshVertexSculptTool>
local UVertexBrushSculptProperties = {}



---@class UVertexColorBaseBrushOpProps : UMeshSculptBrushOpProps
---@field Strength float
---@field Falloff float
---@field BlendMode EVertexColorPaintBrushOpBlendMode
---@field bApplyFalloff boolean
local UVertexColorBaseBrushOpProps = {}



---@class UVertexColorPaintBrushOpProps : UVertexColorBaseBrushOpProps
---@field Color FLinearColor
local UVertexColorPaintBrushOpProps = {}



---@class UVertexColorSmoothBrushOpProps : UVertexColorBaseBrushOpProps
local UVertexColorSmoothBrushOpProps = {}


---@class UVertexColorSoftenBrushOpProps : UVertexColorBaseBrushOpProps
local UVertexColorSoftenBrushOpProps = {}


---@class UVertexPaintBasicProperties : UInteractiveToolPropertySet
---@field PrimaryBrushType EMeshVertexPaintBrushType
---@field SubToolType EMeshVertexPaintInteractionType
---@field PaintColor FLinearColor
---@field BlendMode EMeshVertexPaintColorBlendMode
---@field SecondaryActionType EMeshVertexPaintSecondaryActionType
---@field EraseColor FLinearColor
---@field SmoothStrength float
---@field ChannelFilter FModelingToolsColorChannelFilter
---@field bHardEdges boolean
local UVertexPaintBasicProperties = {}



---@class UVertexPaintBrushFilterProperties : UInteractiveToolPropertySet
---@field BrushAreaMode EMeshVertexPaintBrushAreaType
---@field AngleThreshold float
---@field bUVSeams boolean
---@field bNormalSeams boolean
---@field VisibilityFilter EMeshVertexPaintVisibilityType
---@field MinTriVertCount int32
---@field MaterialMode EMeshVertexPaintMaterialMode
---@field bShowHitColor boolean
---@field CurrentSubToolType EMeshVertexPaintInteractionType
local UVertexPaintBrushFilterProperties = {}



---@class UViewAlignedPlaneBrushOpProps : UBasePlaneBrushOpProps
---@field Strength float
---@field Falloff float
---@field Depth float
---@field WhichSide EPlaneBrushSideMode
local UViewAlignedPlaneBrushOpProps = {}



---@class UViewAlignedSculptBrushOpProps : UMeshSculptBrushOpProps
---@field Strength float
---@field Falloff float
local UViewAlignedSculptBrushOpProps = {}



---@class UVolumeToMeshTool : UInteractiveTool
---@field Settings UVolumeToMeshToolProperties
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field PreviewMesh UPreviewMesh
---@field TargetVolume TLazyObjectPtr<AVolume>
---@field VolumeEdgesSet ULineSetComponent
local UVolumeToMeshTool = {}



---@class UVolumeToMeshToolBuilder : UInteractiveToolBuilder
local UVolumeToMeshToolBuilder = {}


---@class UVolumeToMeshToolProperties : UInteractiveToolPropertySet
---@field bWeldEdges boolean
---@field bAutoRepair boolean
---@field bOptimizeMesh boolean
---@field bShowWireframe boolean
local UVolumeToMeshToolProperties = {}



---@class UVoxelBlendMeshesTool : UBaseVoxelTool
---@field BlendProperties UVoxelBlendMeshesToolProperties
local UVoxelBlendMeshesTool = {}



---@class UVoxelBlendMeshesToolBuilder : UBaseCreateFromSelectedToolBuilder
local UVoxelBlendMeshesToolBuilder = {}


---@class UVoxelBlendMeshesToolProperties : UInteractiveToolPropertySet
---@field BlendPower double
---@field BlendFalloff double
---@field Operation EVoxelBlendOperation
---@field bVoxWrap boolean
---@field bRemoveInternalsAfterVoxWrap boolean
---@field ThickenShells double
local UVoxelBlendMeshesToolProperties = {}



---@class UVoxelMorphologyMeshesTool : UBaseVoxelTool
---@field MorphologyProperties UVoxelMorphologyMeshesToolProperties
local UVoxelMorphologyMeshesTool = {}



---@class UVoxelMorphologyMeshesToolBuilder : UBaseCreateFromSelectedToolBuilder
local UVoxelMorphologyMeshesToolBuilder = {}


---@class UVoxelMorphologyMeshesToolProperties : UInteractiveToolPropertySet
---@field Operation EMorphologyOperation
---@field Distance double
---@field bVoxWrap boolean
---@field bRemoveInternalsAfterVoxWrap boolean
---@field ThickenShells double
local UVoxelMorphologyMeshesToolProperties = {}



---@class UVoxelSolidifyMeshesTool : UBaseVoxelTool
---@field SolidifyProperties UVoxelSolidifyMeshesToolProperties
local UVoxelSolidifyMeshesTool = {}



---@class UVoxelSolidifyMeshesToolBuilder : UBaseCreateFromSelectedToolBuilder
local UVoxelSolidifyMeshesToolBuilder = {}


---@class UVoxelSolidifyMeshesToolProperties : UInteractiveToolPropertySet
---@field WindingThreshold double
---@field ExtendBounds double
---@field SurfaceSearchSteps int32
---@field bSolidAtBoundaries boolean
---@field bApplyThickenShells boolean
---@field ThickenShells double
local UVoxelSolidifyMeshesToolProperties = {}



---@class UWeldMeshEdgesOperatorFactory : UObject
---@field WeldMeshEdgesTool UWeldMeshEdgesTool
local UWeldMeshEdgesOperatorFactory = {}



---@class UWeldMeshEdgesTool : USingleTargetWithSelectionTool
---@field Settings UWeldMeshEdgesToolProperties
---@field PreviewCompute UMeshOpPreviewWithBackgroundCompute
---@field MeshElementsDisplay UMeshElementsVisualizer
---@field OperatorFactory UWeldMeshEdgesOperatorFactory
local UWeldMeshEdgesTool = {}



---@class UWeldMeshEdgesToolBuilder : USingleTargetWithSelectionToolBuilder
local UWeldMeshEdgesToolBuilder = {}


---@class UWeldMeshEdgesToolProperties : UInteractiveToolPropertySet
---@field Tolerance float
---@field bOnlyUnique boolean
---@field bResolveTJunctions boolean
---@field bSplitBowties boolean
---@field InitialEdges int32
---@field RemainingEdges int32
---@field AttrWeldingMode EWeldMeshEdgesAttributeUIMode
---@field SplitNormalThreshold float
---@field SplitTangentsThreshold float
---@field SplitUVThreshold float
---@field SplitColorThreshold float
local UWeldMeshEdgesToolProperties = {}



---@class UWorkPlaneProperties : UInteractiveToolPropertySet
---@field bPropertySetEnabled boolean
---@field bShowGizmo boolean
---@field Position FVector
---@field Rotation FQuat
local UWorkPlaneProperties = {}



