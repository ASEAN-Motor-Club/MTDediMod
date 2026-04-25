---@meta

---@class APreviewGeometryActor : AInternalToolFrameworkActor
local APreviewGeometryActor = {}


---@class APreviewMeshActor : AInternalToolFrameworkActor
local APreviewMeshActor = {}


---@class FCreateActorParams
---@field TargetWorld UWorld
---@field BaseName FString
---@field Transform FTransform
---@field TemplateActor AActor
---@field TemplateAsset UObject
local FCreateActorParams = {}



---@class FCreateActorResult
---@field ResultCode ECreateModelingObjectResult
---@field NewActor AActor
local FCreateActorResult = {}



---@class FCreateMaterialObjectParams
---@field TargetWorld UWorld
---@field StoreRelativeToObject UObject
---@field BaseName FString
---@field MaterialToDuplicate UMaterialInterface
local FCreateMaterialObjectParams = {}



---@class FCreateMaterialObjectResult
---@field ResultCode ECreateModelingObjectResult
---@field NewAsset UObject
local FCreateMaterialObjectResult = {}



---@class FCreateMeshObjectParams
---@field SourceComponent UPrimitiveComponent
---@field TypeHint ECreateObjectTypeHint
---@field TypeHintClass UClass
---@field TypeHintExtended int32
---@field TargetWorld UWorld
---@field Transform FTransform
---@field BaseName FString
---@field Materials TArray<UMaterialInterface>
---@field AssetMaterials TArray<UMaterialInterface>
---@field bEnableCollision boolean
---@field CollisionMode ECollisionTraceFlag
---@field bEnableRaytracingSupport boolean
---@field bGenerateLightmapUVs boolean
---@field bEnableRecomputeNormals boolean
---@field bEnableRecomputeTangents boolean
---@field bEnableNanite boolean
---@field NaniteProxyTrianglePercent float
---@field NaniteSettings FMeshNaniteSettings
local FCreateMeshObjectParams = {}



---@class FCreateMeshObjectResult
---@field ResultCode ECreateModelingObjectResult
---@field NewActor AActor
---@field NewComponent UPrimitiveComponent
---@field NewAsset UObject
local FCreateMeshObjectResult = {}



---@class FCreateTextureObjectParams
---@field TypeHintExtended int32
---@field TargetWorld UWorld
---@field StoreRelativeToObject UObject
---@field BaseName FString
---@field GeneratedTransientTexture UTexture2D
---@field FullAssetPath FString
local FCreateTextureObjectParams = {}



---@class FCreateTextureObjectResult
---@field ResultCode ECreateModelingObjectResult
---@field NewAsset UObject
local FCreateTextureObjectResult = {}



---@class FMeshElementSelectionParams
---@field SelectionFillColor UMaterialInstanceDynamic
local FMeshElementSelectionParams = {}



---@class FModelingToolsAxisFilter
---@field bAxisX boolean
---@field bAxisY boolean
---@field bAxisZ boolean
local FModelingToolsAxisFilter = {}



---@class FModelingToolsColorChannelFilter
---@field bRed boolean
---@field bGreen boolean
---@field bBlue boolean
---@field bAlpha boolean
local FModelingToolsColorChannelFilter = {}



---@class FRenderableTriangle
---@field Material UMaterialInterface
---@field Vertex0 FRenderableTriangleVertex
---@field Vertex1 FRenderableTriangleVertex
---@field Vertex2 FRenderableTriangleVertex
local FRenderableTriangle = {}



---@class FRenderableTriangleVertex
---@field Position FVector
---@field UV FVector2D
---@field Normal FVector
---@field Color FColor
local FRenderableTriangleVertex = {}



---@class IDynamicMeshCommitter : IInterface
local IDynamicMeshCommitter = {}


---@class IDynamicMeshProvider : IInterface
local IDynamicMeshProvider = {}


---@class IPersistentDynamicMeshSource : IInterface
local IPersistentDynamicMeshSource = {}


---@class IToolActivityHost : IInterface
local IToolActivityHost = {}


---@class IToolHostCustomizationAPI : IInterface
local IToolHostCustomizationAPI = {}


---@class UBaseCreateFromSelectedCollisionProperties : UInteractiveToolPropertySet
---@field bTransferCollision boolean
local UBaseCreateFromSelectedCollisionProperties = {}



---@class UBaseCreateFromSelectedHandleSourceProperties : UOnAcceptHandleSourcesProperties
---@field OutputWriteTo EBaseCreateFromSelectedTargetType
---@field OutputNewName FString
---@field OutputExistingName FString
local UBaseCreateFromSelectedHandleSourceProperties = {}



---@class UBaseCreateFromSelectedTool : UMultiSelectionMeshEditingTool
---@field TransformProperties UTransformInputsToolProperties
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field HandleSourcesProperties UBaseCreateFromSelectedHandleSourceProperties
---@field CollisionProperties UBaseCreateFromSelectedCollisionProperties
---@field Preview UMeshOpPreviewWithBackgroundCompute
---@field TransformProxies TArray<UTransformProxy>
---@field TransformGizmos TArray<UCombinedTransformGizmo>
local UBaseCreateFromSelectedTool = {}



---@class UBaseCreateFromSelectedToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UBaseCreateFromSelectedToolBuilder = {}


---@class UBaseMeshProcessingTool : USingleTargetWithSelectionTool
---@field Preview UMeshOpPreviewWithBackgroundCompute
local UBaseMeshProcessingTool = {}



---@class UBaseMeshProcessingToolBuilder : USingleTargetWithSelectionToolBuilder
local UBaseMeshProcessingToolBuilder = {}


---@class UBaseVoxelTool : UBaseCreateFromSelectedTool
---@field VoxProperties UVoxelProperties
local UBaseVoxelTool = {}



---@class UBoundarySelectionMechanic : UMeshTopologySelectionMechanic
local UBoundarySelectionMechanic = {}


---@class UCollectSurfacePathMechanic : UInteractionMechanic
local UCollectSurfacePathMechanic = {}


---@class UCollisionPrimitivesMechanic : UInteractionMechanic
---@field PreviewGeometry UPreviewGeometry
---@field DrawnPrimitiveEdges ULineSetComponent
---@field TranslateTransformProxy UTransformProxy
---@field SphereTransformProxy UTransformProxy
---@field BoxTransformProxy UTransformProxy
---@field CapsuleTransformProxy UTransformProxy
---@field FullTransformProxy UTransformProxy
---@field CurrentActiveProxy UTransformProxy
---@field TranslateTransformGizmo UCombinedTransformGizmo
---@field SphereTransformGizmo UCombinedTransformGizmo
---@field BoxTransformGizmo UCombinedTransformGizmo
---@field CapsuleTransformGizmo UCombinedTransformGizmo
---@field FullTransformGizmo UCombinedTransformGizmo
---@field MarqueeMechanic URectangleMarqueeMechanic
local UCollisionPrimitivesMechanic = {}



---@class UConstructionPlaneMechanic : UInteractionMechanic
---@field PlaneTransformGizmo UCombinedTransformGizmo
---@field PlaneTransformProxy UTransformProxy
---@field ClickToSetPlaneBehavior USingleClickInputBehavior
---@field MiddleClickToSetGizmoBehavior ULocalSingleClickInputBehavior
local UConstructionPlaneMechanic = {}



---@class UCreateMeshObjectTypeProperties : UInteractiveToolPropertySet
---@field OutputType FString
---@field VolumeType TSubclassOf<AVolume>
---@field OutputTypeNamesList TArray<FString>
---@field bShowVolumeList boolean
local UCreateMeshObjectTypeProperties = {}

---@return boolean
function UCreateMeshObjectTypeProperties:ShouldShowPropertySet() end
---@return TArray<FString>
function UCreateMeshObjectTypeProperties:GetOutputTypeNamesFunc() end
---@return ECreateObjectTypeHint
function UCreateMeshObjectTypeProperties:GetCurrentCreateMeshType() end


---@class UCurveControlPointsMechanic : UInteractionMechanic
---@field ClickBehavior USingleClickInputBehavior
---@field HoverBehavior UMouseHoverBehavior
---@field PreviewGeometryActor APreviewGeometryActor
---@field DrawnControlPoints UPointSetComponent
---@field DrawnControlSegments ULineSetComponent
---@field PreviewPoint UPointSetComponent
---@field PreviewSegment ULineSetComponent
---@field PointTransformProxy UTransformProxy
---@field PointTransformGizmo UCombinedTransformGizmo
local UCurveControlPointsMechanic = {}



---@class UDEPRECATED_PolygonSelectionMechanicProperties : UMeshTopologySelectionMechanicProperties
local UDEPRECATED_PolygonSelectionMechanicProperties = {}


---@class UDragAlignmentInteraction : UObject
local UDragAlignmentInteraction = {}


---@class UDragAlignmentMechanic : UInteractionMechanic
local UDragAlignmentMechanic = {}


---@class UDynamicMeshReplacementChangeTarget : UObject
local UDynamicMeshReplacementChangeTarget = {}


---@class UGeometrySelectionEditCommand : UInteractiveCommand
local UGeometrySelectionEditCommand = {}


---@class UGeometrySelectionEditCommandArguments : UInteractiveCommandArguments
local UGeometrySelectionEditCommandArguments = {}


---@class UGeometrySelectionEditCommandResult : UInteractiveCommandResult
local UGeometrySelectionEditCommandResult = {}


---@class UGeometrySelectionManager : UObject
---@field SelectionArguments UGeometrySelectionEditCommandArguments
---@field ToolsContext UInteractiveToolsContext
---@field PreviewGeometry UPreviewGeometry
---@field UnselectedParams FMeshElementSelectionParams
---@field HoverOverSelectedParams FMeshElementSelectionParams
---@field HoverOverUnselectedParams FMeshElementSelectionParams
---@field SelectedParams FMeshElementSelectionParams
local UGeometrySelectionManager = {}



---@class UGeometrySelectionVisualizationProperties : UInteractiveToolPropertySet
---@field bEnableShowTriangleROIBorder boolean
---@field bEnableShowEdgeSelectionVertices boolean
---@field SelectionElementType EGeometrySelectionElementType
---@field SelectionTopologyType EGeometrySelectionTopologyType
---@field bShowSelection boolean
---@field bShowTriangleROIBorder boolean
---@field bShowHidden boolean
---@field bShowEdgeSelectionVertices boolean
---@field LineThickness float
---@field PointSize float
---@field DepthBias float
---@field FaceColor FColor
---@field LineColor FColor
---@field PointColor FColor
---@field TriangleROIBorderColor FColor
---@field TriangleMaterial UMaterialInterface
---@field LineMaterial UMaterialInterface
---@field PointMaterial UMaterialInterface
---@field TriangleMaterialShowingHidden UMaterialInterface
---@field LineMaterialShowingHidden UMaterialInterface
---@field PointMaterialShowingHidden UMaterialInterface
local UGeometrySelectionVisualizationProperties = {}



---@class UInteractiveToolActivity : UInteractionMechanic
local UInteractiveToolActivity = {}


---@class ULatticeControlPointsMechanic : UInteractionMechanic
---@field PreviewGeometryActor APreviewGeometryActor
---@field DrawnControlPoints UPointSetComponent
---@field DrawnLatticeEdges ULineSetComponent
---@field PointTransformProxy UTransformProxy
---@field PointTransformGizmo UCombinedTransformGizmo
---@field MarqueeMechanic URectangleMarqueeMechanic
local ULatticeControlPointsMechanic = {}



---@class ULineSetComponent : UMeshComponent
---@field LineMaterial UMaterialInterface
---@field Bounds FBoxSphereBounds
---@field bBoundsDirty boolean
local ULineSetComponent = {}

---@param InLineMaterial UMaterialInterface
function ULineSetComponent:SetLineMaterial(InLineMaterial) end
function ULineSetComponent:Clear() end
---@param InStart TArray<FVector>
---@param InEnd TArray<FVector>
---@param InColor FColor
---@param InThickness float
---@param InDepthBias float
---@return int32
function ULineSetComponent:AddLines(InStart, InEnd, InColor, InThickness, InDepthBias) end


---@class UMeshElementsVisualizer : UPreviewGeometry
---@field Settings UMeshElementsVisualizerProperties
---@field WireframeComponent UMeshWireframeComponent
local UMeshElementsVisualizer = {}



---@class UMeshElementsVisualizerProperties : UInteractiveToolPropertySet
---@field bVisible boolean
---@field bShowWireframe boolean
---@field bShowBorders boolean
---@field bShowUVSeams boolean
---@field bShowNormalSeams boolean
---@field bShowTangentSeams boolean
---@field bShowColorSeams boolean
---@field ThicknessScale float
---@field WireframeColor FColor
---@field BoundaryEdgeColor FColor
---@field UVSeamColor FColor
---@field NormalSeamColor FColor
---@field TangentSeamColor FColor
---@field ColorSeamColor FColor
---@field DepthBias float
---@field bAdjustDepthBiasUsingMeshSize boolean
local UMeshElementsVisualizerProperties = {}



---@class UMeshOpPreviewWithBackgroundCompute : UObject
---@field PreviewMesh UPreviewMesh
---@field StandardMaterials TArray<UMaterialInterface>
---@field OverrideMaterial UMaterialInterface
---@field WorkingMaterial UMaterialInterface
---@field SecondaryMaterial UMaterialInterface
---@field PreviewWorld TWeakObjectPtr<UWorld>
local UMeshOpPreviewWithBackgroundCompute = {}



---@class UMeshSurfacePointMeshEditingToolBuilder : UMeshSurfacePointToolBuilder
local UMeshSurfacePointMeshEditingToolBuilder = {}


---@class UMeshTopologySelectionMechanic : UInteractionMechanic
---@field Properties UMeshTopologySelectionMechanicProperties
---@field HoverBehavior UMouseHoverBehavior
---@field ClickOrDragBehavior USingleClickOrDragInputBehavior
---@field MarqueeMechanic URectangleMarqueeMechanic
---@field MarqueeSelectionUpdateType EMarqueeSelectionUpdateType
---@field PreviewGeometryActor APreviewGeometryActor
---@field DrawnTriangleSetComponent UTriangleSetComponent
---@field HighlightedFaceMaterial UMaterialInterface
local UMeshTopologySelectionMechanic = {}



---@class UMeshTopologySelectionMechanicProperties : UInteractiveToolPropertySet
---@field bSelectVertices boolean
---@field bSelectEdges boolean
---@field bSelectFaces boolean
---@field bSelectEdgeLoops boolean
---@field bSelectEdgeRings boolean
---@field bHitBackFaces boolean
---@field bEnableMarquee boolean
---@field bMarqueeIgnoreOcclusion boolean
---@field bPreferProjectedElement boolean
---@field bSelectDownRay boolean
---@field bIgnoreOcclusion boolean
local UMeshTopologySelectionMechanicProperties = {}

function UMeshTopologySelectionMechanicProperties:SelectAll() end
function UMeshTopologySelectionMechanicProperties:InvertSelection() end


---@class UMeshWireframeComponent : UMeshComponent
---@field LineDepthBias float
---@field LineDepthBiasSizeScale float
---@field ThicknessScale float
---@field bEnableWireframe boolean
---@field WireframeColor FColor
---@field WireframeThickness float
---@field bEnableBoundaryEdges boolean
---@field BoundaryEdgeColor FColor
---@field BoundaryEdgeThickness float
---@field bEnableUVSeams boolean
---@field UVSeamColor FColor
---@field UVSeamThickness float
---@field bEnableNormalSeams boolean
---@field NormalSeamColor FColor
---@field NormalSeamThickness float
---@field bEnableTangentSeams boolean
---@field TangentSeamColor FColor
---@field TangentSeamThickness float
---@field bEnableColorSeams boolean
---@field ColorSeamColor FColor
---@field ColorSeamThickness float
---@field LineMaterial UMaterialInterface
---@field LocalBounds FBoxSphereBounds
local UMeshWireframeComponent = {}



---@class UModelingComponentsEditorSettings : UDeveloperSettings
---@field GridMode EModelingComponentsPlaneVisualizationMode
---@field NumGridLines int32
---@field GridSpacing float
---@field GridScale float
---@field GridSize float
local UModelingComponentsEditorSettings = {}



---@class UModelingComponentsSettings : UDeveloperSettings
---@field bEnableRayTracingWhileEditing boolean
---@field bEnableRayTracing boolean
---@field bGenerateLightmapUVs boolean
---@field bEnableCollision boolean
---@field CollisionMode ECollisionTraceFlag
local UModelingComponentsSettings = {}



---@class UModelingObjectsCreationAPI : UObject
local UModelingObjectsCreationAPI = {}

---@param CreateTexParams FCreateTextureObjectParams
---@return FCreateTextureObjectResult
function UModelingObjectsCreationAPI:CreateTextureObject(CreateTexParams) end
---@param CreateActorParams FCreateActorParams
---@return FCreateActorResult
function UModelingObjectsCreationAPI:CreateNewActor(CreateActorParams) end
---@param CreateMeshParams FCreateMeshObjectParams
---@return FCreateMeshObjectResult
function UModelingObjectsCreationAPI:CreateMeshObject(CreateMeshParams) end
---@param CreateMaterialParams FCreateMaterialObjectParams
---@return FCreateMaterialObjectResult
function UModelingObjectsCreationAPI:CreateMaterialObject(CreateMaterialParams) end


---@class UModelingSceneSnappingManager : USceneSnappingManager
---@field ParentContext UInteractiveToolsContext
local UModelingSceneSnappingManager = {}



---@class UMultiSelectionMeshEditingTool : UMultiSelectionTool
---@field TargetWorld TWeakObjectPtr<UWorld>
local UMultiSelectionMeshEditingTool = {}



---@class UMultiSelectionMeshEditingToolBuilder : UInteractiveToolWithToolTargetsBuilder
local UMultiSelectionMeshEditingToolBuilder = {}


---@class UMultiTargetWithSelectionTool : UMultiSelectionTool
---@field TargetWorld TWeakObjectPtr<UWorld>
---@field GeometrySelectionVizProperties UGeometrySelectionVisualizationProperties
---@field GeometrySelectionViz UPreviewGeometry
local UMultiTargetWithSelectionTool = {}



---@class UMultiTargetWithSelectionToolBuilder : UInteractiveToolWithToolTargetsBuilder
local UMultiTargetWithSelectionToolBuilder = {}


---@class UMultiTransformer : UObject
---@field GizmoManager UInteractiveGizmoManager
---@field TransformGizmo UCombinedTransformGizmo
---@field TransformProxy UTransformProxy
---@field DragAlignmentMechanic UDragAlignmentMechanic
local UMultiTransformer = {}



---@class UOctreeDynamicMeshComponent : UBaseDynamicMeshComponent
---@field MeshObject UDynamicMesh
local UOctreeDynamicMeshComponent = {}

---@param NewMesh UDynamicMesh
function UOctreeDynamicMeshComponent:SetDynamicMesh(NewMesh) end


---@class UOnAcceptHandleSourcesProperties : UOnAcceptHandleSourcesPropertiesBase
---@field HandleInputs EHandleSourcesMethod
local UOnAcceptHandleSourcesProperties = {}



---@class UOnAcceptHandleSourcesPropertiesBase : UInteractiveToolPropertySet
local UOnAcceptHandleSourcesPropertiesBase = {}


---@class UOnAcceptHandleSourcesPropertiesSingle : UOnAcceptHandleSourcesPropertiesBase
---@field HandleInputs EHandleSourcesMethod
local UOnAcceptHandleSourcesPropertiesSingle = {}



---@class UPlaneDistanceFromHitMechanic : UInteractionMechanic
local UPlaneDistanceFromHitMechanic = {}


---@class UPointSetComponent : UMeshComponent
---@field PointMaterial UMaterialInterface
---@field Bounds FBoxSphereBounds
---@field bBoundsDirty boolean
local UPointSetComponent = {}



---@class UPolyEditPreviewMesh : UPreviewMesh
local UPolyEditPreviewMesh = {}


---@class UPolyLassoMarqueeMechanic : UInteractionMechanic
---@field SpacingTolerance float
---@field LineThickness float
---@field LineColor FLinearColor
---@field ClosedColor FLinearColor
---@field bEnableFreehandPolygons boolean
---@field bEnableMultiClickPolygons boolean
---@field ClickDragBehavior UClickDragInputBehavior
---@field HoverBehavior UMouseHoverBehavior
local UPolyLassoMarqueeMechanic = {}



---@class UPolygonSelectionMechanic : UMeshTopologySelectionMechanic
local UPolygonSelectionMechanic = {}


---@class UPolygroupLayersProperties : UInteractiveToolPropertySet
---@field ActiveGroupLayer FName
---@field GroupLayersList TArray<FString>
local UPolygroupLayersProperties = {}

---@return TArray<FString>
function UPolygroupLayersProperties:GetGroupLayersFunc() end


---@class UPreviewGeometry : UObject
---@field ParentActor APreviewGeometryActor
---@field TriangleSets TMap<FString, UTriangleSetComponent>
---@field LineSets TMap<FString, ULineSetComponent>
---@field PointSets TMap<FString, UPointSetComponent>
local UPreviewGeometry = {}

---@param PointSetIdentifier FString
---@param bVisible boolean
---@return boolean
function UPreviewGeometry:SetPointSetVisibility(PointSetIdentifier, bVisible) end
---@param PointSetIdentifier FString
---@param NewMaterial UMaterialInterface
---@return boolean
function UPreviewGeometry:SetPointSetMaterial(PointSetIdentifier, NewMaterial) end
---@param LineSetIdentifier FString
---@param bVisible boolean
---@return boolean
function UPreviewGeometry:SetLineSetVisibility(LineSetIdentifier, bVisible) end
---@param LineSetIdentifier FString
---@param NewMaterial UMaterialInterface
---@return boolean
function UPreviewGeometry:SetLineSetMaterial(LineSetIdentifier, NewMaterial) end
---@param Material UMaterialInterface
function UPreviewGeometry:SetAllPointSetsMaterial(Material) end
---@param Material UMaterialInterface
function UPreviewGeometry:SetAllLineSetsMaterial(Material) end
---@param TriangleSetIdentifier FString
---@param bDestroy boolean
---@return boolean
function UPreviewGeometry:RemoveTriangleSet(TriangleSetIdentifier, bDestroy) end
---@param PointSetIdentifier FString
---@param bDestroy boolean
---@return boolean
function UPreviewGeometry:RemovePointSet(PointSetIdentifier, bDestroy) end
---@param LineSetIdentifier FString
---@param bDestroy boolean
---@return boolean
function UPreviewGeometry:RemoveLineSet(LineSetIdentifier, bDestroy) end
---@param bDestroy boolean
function UPreviewGeometry:RemoveAllTriangleSets(bDestroy) end
---@param bDestroy boolean
function UPreviewGeometry:RemoveAllPointSets(bDestroy) end
---@param bDestroy boolean
function UPreviewGeometry:RemoveAllLineSets(bDestroy) end
---@return APreviewGeometryActor
function UPreviewGeometry:GetActor() end
---@param TriangleSetIdentifier FString
---@return UTriangleSetComponent
function UPreviewGeometry:FindTriangleSet(TriangleSetIdentifier) end
---@param PointSetIdentifier FString
---@return UPointSetComponent
function UPreviewGeometry:FindPointSet(PointSetIdentifier) end
---@param LineSetIdentifier FString
---@return ULineSetComponent
function UPreviewGeometry:FindLineSet(LineSetIdentifier) end
function UPreviewGeometry:Disconnect() end
---@param World UWorld
---@param WithTransform FTransform
function UPreviewGeometry:CreateInWorld(World, WithTransform) end
---@param TriangleSetIdentifier FString
---@return UTriangleSetComponent
function UPreviewGeometry:AddTriangleSet(TriangleSetIdentifier) end
---@param PointSetIdentifier FString
---@return UPointSetComponent
function UPreviewGeometry:AddPointSet(PointSetIdentifier) end
---@param LineSetIdentifier FString
---@return ULineSetComponent
function UPreviewGeometry:AddLineSet(LineSetIdentifier) end


---@class UPreviewMesh : UObject
---@field bBuildSpatialDataStructure boolean
---@field DynamicMeshComponent UDynamicMeshComponent
local UPreviewMesh = {}



---@class URectangleMarqueeInteraction : UObject
local URectangleMarqueeInteraction = {}


---@class URectangleMarqueeMechanic : UInteractionMechanic
---@field bUseExternalClickDragBehavior boolean
---@field bUseExternalUpdateCameraState boolean
---@field OnDragRectangleChangedDeferredThreshold double
---@field ClickDragBehavior UClickDragInputBehavior
local URectangleMarqueeMechanic = {}



---@class USingleSelectionMeshEditingTool : USingleSelectionTool
---@field TargetWorld TWeakObjectPtr<UWorld>
local USingleSelectionMeshEditingTool = {}



---@class USingleSelectionMeshEditingToolBuilder : UInteractiveToolWithToolTargetsBuilder
local USingleSelectionMeshEditingToolBuilder = {}


---@class USingleTargetWithSelectionTool : USingleSelectionTool
---@field TargetWorld TWeakObjectPtr<UWorld>
---@field GeometrySelectionVizProperties UGeometrySelectionVisualizationProperties
---@field GeometrySelectionViz UPreviewGeometry
local USingleTargetWithSelectionTool = {}



---@class USingleTargetWithSelectionToolBuilder : UInteractiveToolWithToolTargetsBuilder
local USingleTargetWithSelectionToolBuilder = {}


---@class USpaceCurveDeformationMechanic : UInteractionMechanic
---@field ClickBehavior USingleClickInputBehavior
---@field HoverBehavior UMouseHoverBehavior
---@field TransformProperties USpaceCurveDeformationMechanicPropertySet
---@field PreviewGeometryActor APreviewGeometryActor
---@field RenderPoints UPointSetComponent
---@field RenderSegments ULineSetComponent
---@field PointTransformProxy UTransformProxy
---@field PointTransformGizmo UCombinedTransformGizmo
local USpaceCurveDeformationMechanic = {}



---@class USpaceCurveDeformationMechanicPropertySet : UInteractiveToolPropertySet
---@field TransformMode ESpaceCurveControlPointTransformMode
---@field TransformOrigin ESpaceCurveControlPointOriginMode
---@field Softness float
---@field SoftFalloff ESpaceCurveControlPointFalloffType
local USpaceCurveDeformationMechanicPropertySet = {}



---@class USpatialCurveDistanceMechanic : UInteractionMechanic
local USpatialCurveDistanceMechanic = {}


---@class UTransformInputsToolProperties : UInteractiveToolPropertySet
---@field bShowTransformGizmo boolean
local UTransformInputsToolProperties = {}



---@class UTriangleSetComponent : UMeshComponent
---@field Bounds FBoxSphereBounds
---@field bBoundsDirty boolean
local UTriangleSetComponent = {}



---@class UUVLayoutPreview : UObject
---@field Settings UUVLayoutPreviewProperties
---@field PreviewMesh UPreviewMesh
---@field MeshElementsVisualizer UMeshElementsVisualizer
---@field TriangleComponent UTriangleSetComponent
---@field bShowBackingRectangle boolean
---@field BackingRectangleMaterial UMaterialInterface
local UUVLayoutPreview = {}



---@class UUVLayoutPreviewProperties : UInteractiveToolPropertySet
---@field bEnabled boolean
---@field Side EUVLayoutPreviewSide
---@field Scale float
---@field Offset FVector2D
---@field bShowWireframe boolean
local UUVLayoutPreviewProperties = {}



---@class UVoxelProperties : UInteractiveToolPropertySet
---@field VoxelCount int32
---@field bAutoSimplify boolean
---@field bRemoveInternalSurfaces boolean
---@field SimplifyMaxErrorFactor double
---@field CubeRootMinComponentVolume double
local UVoxelProperties = {}



---@class UWeightMapSetProperties : UInteractiveToolPropertySet
---@field WeightMap FName
---@field WeightMapsList TArray<FString>
---@field bInvertWeightMap boolean
local UWeightMapSetProperties = {}

---@return TArray<FString>
function UWeightMapSetProperties:GetWeightMapsFunc() end


