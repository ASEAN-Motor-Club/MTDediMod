---@meta

---@class UAddArrowPrimitiveTool : UAddPrimitiveTool
local UAddArrowPrimitiveTool = {}


---@class UAddBoxPrimitiveTool : UAddPrimitiveTool
local UAddBoxPrimitiveTool = {}


---@class UAddCapsulePrimitiveTool : UAddPrimitiveTool
local UAddCapsulePrimitiveTool = {}


---@class UAddConePrimitiveTool : UAddPrimitiveTool
local UAddConePrimitiveTool = {}


---@class UAddCylinderPrimitiveTool : UAddPrimitiveTool
local UAddCylinderPrimitiveTool = {}


---@class UAddDiscPrimitiveTool : UAddPrimitiveTool
local UAddDiscPrimitiveTool = {}


---@class UAddPrimitiveTool : USingleClickTool
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field ShapeSettings UProceduralShapeToolProperties
---@field MaterialProperties UNewMeshMaterialProperties
---@field PreviewMesh UPreviewMesh
---@field Gizmo UCombinedTransformGizmo
---@field DragAlignmentMechanic UDragAlignmentMechanic
---@field AssetName FString
local UAddPrimitiveTool = {}



---@class UAddPrimitiveToolBuilder : UInteractiveToolBuilder
local UAddPrimitiveToolBuilder = {}


---@class UAddRectanglePrimitiveTool : UAddPrimitiveTool
local UAddRectanglePrimitiveTool = {}


---@class UAddSpherePrimitiveTool : UAddPrimitiveTool
local UAddSpherePrimitiveTool = {}


---@class UAddStairsPrimitiveTool : UAddPrimitiveTool
local UAddStairsPrimitiveTool = {}


---@class UAddTorusPrimitiveTool : UAddPrimitiveTool
local UAddTorusPrimitiveTool = {}


---@class UCSGMeshesTool : UBaseCreateFromSelectedTool
---@field CSGProperties UCSGMeshesToolProperties
---@field TrimProperties UTrimMeshesToolProperties
---@field OriginalMeshPreviews TArray<UPreviewMesh>
---@field PreviewsGhostMaterial UMaterialInstanceDynamic
---@field DrawnLineSet ULineSetComponent
local UCSGMeshesTool = {}



---@class UCSGMeshesToolBuilder : UBaseCreateFromSelectedToolBuilder
local UCSGMeshesToolBuilder = {}


---@class UCSGMeshesToolProperties : UInteractiveToolPropertySet
---@field Operation ECSGOperation
---@field bTryFixHoles boolean
---@field bTryCollapseEdges boolean
---@field WindingThreshold float
---@field bShowNewBoundaries boolean
---@field bShowSubtractedMesh boolean
---@field SubtractedMeshOpacity float
---@field SubtractedMeshColor FLinearColor
---@field bUseFirstMeshMaterials boolean
local UCSGMeshesToolProperties = {}



---@class UCombineMeshesTool : UMultiSelectionMeshEditingTool
---@field BasicProperties UCombineMeshesToolProperties
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field HandleSourceProperties UOnAcceptHandleSourcesPropertiesBase
local UCombineMeshesTool = {}



---@class UCombineMeshesToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UCombineMeshesToolBuilder = {}


---@class UCombineMeshesToolProperties : UInteractiveToolPropertySet
---@field bIsDuplicateMode boolean
---@field OutputWriteTo EBaseCreateFromSelectedTargetType
---@field OutputNewName FString
---@field OutputExistingName FString
local UCombineMeshesToolProperties = {}



---@class UCutMeshWithMeshTool : UBaseCreateFromSelectedTool
---@field CutProperties UCutMeshWithMeshToolProperties
---@field IntersectPreviewMesh UPreviewMesh
---@field DrawnLineSet ULineSetComponent
local UCutMeshWithMeshTool = {}



---@class UCutMeshWithMeshToolBuilder : UBaseCreateFromSelectedToolBuilder
local UCutMeshWithMeshToolBuilder = {}


---@class UCutMeshWithMeshToolProperties : UInteractiveToolPropertySet
---@field bTryFixHoles boolean
---@field bTryCollapseEdges boolean
---@field WindingThreshold float
---@field bShowNewBoundaries boolean
---@field bUseFirstMeshMaterials boolean
local UCutMeshWithMeshToolProperties = {}



---@class UDeleteGeometrySelectionCommand : UGeometrySelectionEditCommand
local UDeleteGeometrySelectionCommand = {}


---@class UDisconnectGeometrySelectionCommand : UGeometrySelectionEditCommand
local UDisconnectGeometrySelectionCommand = {}


---@class UDrawAndRevolveTool : UInteractiveTool
---@field ControlPointsMechanic UCurveControlPointsMechanic
---@field PlaneMechanic UConstructionPlaneMechanic
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field Settings URevolveToolProperties
---@field MaterialProperties UNewMeshMaterialProperties
---@field Preview UMeshOpPreviewWithBackgroundCompute
local UDrawAndRevolveTool = {}



---@class UDrawAndRevolveToolBuilder : UInteractiveToolBuilder
local UDrawAndRevolveToolBuilder = {}


---@class UDrawPolygonTool : UInteractiveTool
---@field OutputTypeProperties UCreateMeshObjectTypeProperties
---@field PolygonProperties UDrawPolygonToolStandardProperties
---@field SnapProperties UDrawPolygonToolSnapProperties
---@field MaterialProperties UNewMeshMaterialProperties
---@field PreviewMesh UPreviewMesh
---@field HeightMechanic UPlaneDistanceFromHitMechanic
---@field DragAlignmentMechanic UDragAlignmentMechanic
---@field PlaneMechanic UConstructionPlaneMechanic
local UDrawPolygonTool = {}



---@class UDrawPolygonToolBuilder : UInteractiveToolBuilder
local UDrawPolygonToolBuilder = {}


---@class UDrawPolygonToolSnapProperties : UInteractiveToolPropertySet
---@field bEnableSnapping boolean
---@field bSnapToWorldGrid boolean
---@field bSnapToVertices boolean
---@field bSnapToEdges boolean
---@field bSnapToAxes boolean
---@field bSnapToLengths boolean
---@field bSnapToSurfaces boolean
---@field SnapToSurfacesOffset float
local UDrawPolygonToolSnapProperties = {}



---@class UDrawPolygonToolStandardProperties : UInteractiveToolPropertySet
---@field PolygonDrawMode EDrawPolygonDrawMode
---@field bAllowSelfIntersections boolean
---@field FeatureSizeRatio float
---@field RadialSlices int32
---@field Distance float
---@field bShowGridGizmo boolean
---@field ExtrudeMode EDrawPolygonExtrudeMode
---@field ExtrudeHeight float
local UDrawPolygonToolStandardProperties = {}



---@class UEdgeLoopInsertionProperties : UInteractiveToolPropertySet
---@field PositionMode EEdgeLoopPositioningMode
---@field InsertionMode EEdgeLoopInsertionMode
---@field NumLoops int32
---@field ProportionOffset double
---@field DistanceOffset double
---@field bInteractive boolean
---@field bFlipOffsetDirection boolean
---@field bHighlightProblemGroups boolean
---@field VertexTolerance double
local UEdgeLoopInsertionProperties = {}



---@class UEditMeshPolygonsActionModeToolBuilder : UEditMeshPolygonsToolBuilder
local UEditMeshPolygonsActionModeToolBuilder = {}


---@class UEditMeshPolygonsSelectionModeToolBuilder : UEditMeshPolygonsToolBuilder
local UEditMeshPolygonsSelectionModeToolBuilder = {}


---@class UEditMeshPolygonsTool : USingleTargetWithSelectionTool
---@field Preview UMeshOpPreviewWithBackgroundCompute
---@field CommonProps UPolyEditCommonProperties
---@field EditActions UEditMeshPolygonsToolActions
---@field EditActions_Triangles UEditMeshPolygonsToolActions_Triangles
---@field EditEdgeActions UEditMeshPolygonsToolEdgeActions
---@field EditEdgeActions_Triangles UEditMeshPolygonsToolEdgeActions_Triangles
---@field EditUVActions UEditMeshPolygonsToolUVActions
---@field TopologyProperties UPolyEditTopologyProperties
---@field ExtrudeActivity UPolyEditExtrudeActivity
---@field InsetOutsetActivity UPolyEditInsetOutsetActivity
---@field CutFacesActivity UPolyEditCutFacesActivity
---@field PlanarProjectionUVActivity UPolyEditPlanarProjectionUVActivity
---@field InsertEdgeActivity UPolyEditInsertEdgeActivity
---@field InsertEdgeLoopActivity UPolyEditInsertEdgeLoopActivity
---@field BevelEdgeActivity UPolyEditBevelEdgeActivity
---@field ExtrudeEdgeActivity UPolyEditExtrudeEdgeActivity
---@field ActivityContext UPolyEditActivityContext
---@field SelectionMechanic UPolygonSelectionMechanic
---@field DragAlignmentMechanic UDragAlignmentMechanic
---@field TransformGizmo UCombinedTransformGizmo
---@field TransformProxy UTransformProxy
local UEditMeshPolygonsTool = {}



---@class UEditMeshPolygonsToolActionPropertySet : UInteractiveToolPropertySet
local UEditMeshPolygonsToolActionPropertySet = {}


---@class UEditMeshPolygonsToolActions : UEditMeshPolygonsToolActionPropertySet
local UEditMeshPolygonsToolActions = {}

function UEditMeshPolygonsToolActions:SimplifyByGroups() end
function UEditMeshPolygonsToolActions:Retriangulate() end
function UEditMeshPolygonsToolActions:RecalcNormals() end
function UEditMeshPolygonsToolActions:PushPull() end
function UEditMeshPolygonsToolActions:Outset() end
function UEditMeshPolygonsToolActions:Offset() end
function UEditMeshPolygonsToolActions:Merge() end
function UEditMeshPolygonsToolActions:Inset() end
function UEditMeshPolygonsToolActions:InsertEdgeLoop() end
function UEditMeshPolygonsToolActions:InsertEdge() end
function UEditMeshPolygonsToolActions:Flip() end
function UEditMeshPolygonsToolActions:Extrude() end
function UEditMeshPolygonsToolActions:Duplicate() end
function UEditMeshPolygonsToolActions:Disconnect() end
function UEditMeshPolygonsToolActions:Delete() end
function UEditMeshPolygonsToolActions:Decompose() end
function UEditMeshPolygonsToolActions:CutFaces() end
function UEditMeshPolygonsToolActions:Bevel() end


---@class UEditMeshPolygonsToolActions_Triangles : UEditMeshPolygonsToolActionPropertySet
local UEditMeshPolygonsToolActions_Triangles = {}

function UEditMeshPolygonsToolActions_Triangles:RecalcNormals() end
function UEditMeshPolygonsToolActions_Triangles:PushPull() end
function UEditMeshPolygonsToolActions_Triangles:Poke() end
function UEditMeshPolygonsToolActions_Triangles:Outset() end
function UEditMeshPolygonsToolActions_Triangles:Offset() end
function UEditMeshPolygonsToolActions_Triangles:Inset() end
function UEditMeshPolygonsToolActions_Triangles:Flip() end
function UEditMeshPolygonsToolActions_Triangles:Extrude() end
function UEditMeshPolygonsToolActions_Triangles:Duplicate() end
function UEditMeshPolygonsToolActions_Triangles:Disconnect() end
function UEditMeshPolygonsToolActions_Triangles:Delete() end
function UEditMeshPolygonsToolActions_Triangles:CutFaces() end


---@class UEditMeshPolygonsToolBuilder : USingleTargetWithSelectionToolBuilder
local UEditMeshPolygonsToolBuilder = {}


---@class UEditMeshPolygonsToolEdgeActions : UEditMeshPolygonsToolActionPropertySet
local UEditMeshPolygonsToolEdgeActions = {}

function UEditMeshPolygonsToolEdgeActions:WeldCentered() end
function UEditMeshPolygonsToolEdgeActions:Weld() end
function UEditMeshPolygonsToolEdgeActions:Straighten() end
function UEditMeshPolygonsToolEdgeActions:Simplify() end
function UEditMeshPolygonsToolEdgeActions:FillHole() end
function UEditMeshPolygonsToolEdgeActions:Extrude() end
function UEditMeshPolygonsToolEdgeActions:DeleteEdge() end
function UEditMeshPolygonsToolEdgeActions:Collapse() end
function UEditMeshPolygonsToolEdgeActions:Bridge() end
function UEditMeshPolygonsToolEdgeActions:Bevel() end


---@class UEditMeshPolygonsToolEdgeActions_Triangles : UEditMeshPolygonsToolActionPropertySet
local UEditMeshPolygonsToolEdgeActions_Triangles = {}

function UEditMeshPolygonsToolEdgeActions_Triangles:WeldCentered() end
function UEditMeshPolygonsToolEdgeActions_Triangles:Weld() end
function UEditMeshPolygonsToolEdgeActions_Triangles:Split() end
function UEditMeshPolygonsToolEdgeActions_Triangles:Flip() end
function UEditMeshPolygonsToolEdgeActions_Triangles:FillHole() end
function UEditMeshPolygonsToolEdgeActions_Triangles:Extrude() end
function UEditMeshPolygonsToolEdgeActions_Triangles:Collapse() end
function UEditMeshPolygonsToolEdgeActions_Triangles:Bridge() end


---@class UEditMeshPolygonsToolUVActions : UEditMeshPolygonsToolActionPropertySet
local UEditMeshPolygonsToolUVActions = {}

function UEditMeshPolygonsToolUVActions:PlanarProjection() end


---@class UExistingMeshMaterialProperties : UInteractiveToolPropertySet
---@field MaterialMode ESetMeshMaterialMode
---@field CheckerDensity float
---@field OverrideMaterial UMaterialInterface
---@field UVChannel FString
---@field UVChannelNamesList TArray<FString>
---@field CheckerMaterial UMaterialInstanceDynamic
local UExistingMeshMaterialProperties = {}

---@return TArray<FString>
function UExistingMeshMaterialProperties:GetUVChannelNamesFunc() end


---@class UGroupEdgeInsertionProperties : UInteractiveToolPropertySet
---@field InsertionMode EGroupEdgeInsertionMode
---@field bContinuousInsertion boolean
---@field VertexTolerance double
local UGroupEdgeInsertionProperties = {}



---@class UMeshEditingViewProperties : UInteractiveToolPropertySet
---@field bShowWireframe boolean
---@field MaterialMode EMeshEditingMaterialModes
---@field bFlatShading boolean
---@field Color FLinearColor
---@field Image UTexture2D
---@field Opacity double
---@field TransparentMaterialColor FLinearColor
---@field bTwoSided boolean
---@field CustomMaterial TWeakObjectPtr<UMaterialInterface>
local UMeshEditingViewProperties = {}



---@class UMeshUVChannelProperties : UInteractiveToolPropertySet
---@field UVChannel FString
---@field UVChannelNamesList TArray<FString>
local UMeshUVChannelProperties = {}

---@return TArray<FString>
function UMeshUVChannelProperties:GetUVChannelNamesFunc() end


---@class UModifyGeometrySelectionCommand : UGeometrySelectionEditCommand
local UModifyGeometrySelectionCommand = {}


---@class UModifyGeometrySelectionCommand_Contract : UModifyGeometrySelectionCommand
local UModifyGeometrySelectionCommand_Contract = {}


---@class UModifyGeometrySelectionCommand_Expand : UModifyGeometrySelectionCommand
local UModifyGeometrySelectionCommand_Expand = {}


---@class UModifyGeometrySelectionCommand_ExpandToConnected : UModifyGeometrySelectionCommand
local UModifyGeometrySelectionCommand_ExpandToConnected = {}


---@class UModifyGeometrySelectionCommand_Invert : UModifyGeometrySelectionCommand
local UModifyGeometrySelectionCommand_Invert = {}


---@class UModifyGeometrySelectionCommand_InvertConnected : UModifyGeometrySelectionCommand
local UModifyGeometrySelectionCommand_InvertConnected = {}


---@class UNewMeshMaterialProperties : UInteractiveToolPropertySet
---@field Material TWeakObjectPtr<UMaterialInterface>
---@field UVScale float
---@field bWorldSpaceUVScale boolean
---@field bShowWireframe boolean
---@field bShowExtendedOptions boolean
local UNewMeshMaterialProperties = {}



---@class UPolyEditActivityContext : UObject
---@field CommonProperties UPolyEditCommonProperties
---@field Preview UMeshOpPreviewWithBackgroundCompute
---@field SelectionMechanic UPolygonSelectionMechanic
local UPolyEditActivityContext = {}



---@class UPolyEditBevelEdgeActivity : UInteractiveToolActivity
---@field BevelProperties UPolyEditBevelEdgeProperties
---@field ActivityContext UPolyEditActivityContext
local UPolyEditBevelEdgeActivity = {}



---@class UPolyEditBevelEdgeProperties : UInteractiveToolPropertySet
---@field BevelDistance double
---@field Subdivisions int32
---@field RoundWeight float
---@field bInferMaterialID boolean
---@field SetMaterialID int32
local UPolyEditBevelEdgeProperties = {}



---@class UPolyEditCommonProperties : UInteractiveToolPropertySet
---@field bShowWireframe boolean
---@field bShowSelectableCorners boolean
---@field bGizmoVisible boolean
---@field LocalFrameMode ELocalFrameMode
---@field bLockRotation boolean
---@field bLocalCoordSystem boolean
local UPolyEditCommonProperties = {}



---@class UPolyEditCutFacesActivity : UInteractiveToolActivity
---@field CutProperties UPolyEditCutProperties
---@field EditPreview UPolyEditPreviewMesh
---@field SurfacePathMechanic UCollectSurfacePathMechanic
---@field ActivityContext UPolyEditActivityContext
local UPolyEditCutFacesActivity = {}



---@class UPolyEditCutProperties : UInteractiveToolPropertySet
---@field Orientation EPolyEditCutPlaneOrientation
---@field bSnapToVertices boolean
local UPolyEditCutProperties = {}



---@class UPolyEditExtrudeActivity : UInteractiveToolActivity
---@field ExtrudeProperties UPolyEditExtrudeProperties
---@field OffsetProperties UPolyEditOffsetProperties
---@field PushPullProperties UPolyEditPushPullProperties
---@field ExtrudeHeightMechanic UPlaneDistanceFromHitMechanic
---@field ActivityContext UPolyEditActivityContext
local UPolyEditExtrudeActivity = {}



---@class UPolyEditExtrudeEdgeActivity : UInteractiveToolActivity
---@field Settings UPolyEditExtrudeEdgeActivityProperties
---@field ActivityContext UPolyEditActivityContext
---@field ExtrudeFrameProxy UTransformProxy
---@field ExtrudeFrameGizmo UCombinedTransformGizmo
---@field SingleDirectionProxy UTransformProxy
---@field SingleDirectionGizmo UCombinedTransformGizmo
---@field PreviewGeometry UPreviewGeometry
local UPolyEditExtrudeEdgeActivity = {}



---@class UPolyEditExtrudeEdgeActivityProperties : UInteractiveToolPropertySet
---@field DirectionMode EPolyEditExtrudeEdgeDirectionMode
---@field DistanceMode EPolyEditExtrudeEdgeDistanceMode
---@field Distance double
---@field bUseUnselectedForFrames boolean
---@field bAdjustToExtrudeEvenly boolean
local UPolyEditExtrudeEdgeActivityProperties = {}



---@class UPolyEditExtrudeProperties : UInteractiveToolPropertySet
---@field DistanceMode EPolyEditExtrudeDistanceMode
---@field Distance double
---@field DirectionMode EPolyEditExtrudeModeOptions
---@field Direction EPolyEditExtrudeDirection
---@field MaxDistanceScaleFactor double
---@field bShellsToSolids boolean
---@field MeasureDirection EPolyEditExtrudeDirection
---@field bUseColinearityForSettingBorderGroups boolean
local UPolyEditExtrudeProperties = {}



---@class UPolyEditInsertEdgeActivity : UInteractiveToolActivity
---@field Settings UGroupEdgeInsertionProperties
---@field ActivityContext UPolyEditActivityContext
local UPolyEditInsertEdgeActivity = {}



---@class UPolyEditInsertEdgeLoopActivity : UInteractiveToolActivity
---@field Settings UEdgeLoopInsertionProperties
---@field ActivityContext UPolyEditActivityContext
local UPolyEditInsertEdgeLoopActivity = {}



---@class UPolyEditInsetOutsetActivity : UInteractiveToolActivity
---@field Settings UPolyEditInsetOutsetProperties
---@field EditPreview UPolyEditPreviewMesh
---@field CurveDistMechanic USpatialCurveDistanceMechanic
---@field ActivityContext UPolyEditActivityContext
local UPolyEditInsetOutsetActivity = {}



---@class UPolyEditInsetOutsetProperties : UInteractiveToolPropertySet
---@field Softness float
---@field bBoundaryOnly boolean
---@field AreaScale float
---@field bReproject boolean
---@field bOutset boolean
local UPolyEditInsetOutsetProperties = {}



---@class UPolyEditOffsetProperties : UInteractiveToolPropertySet
---@field DistanceMode EPolyEditExtrudeDistanceMode
---@field Distance double
---@field DirectionMode EPolyEditOffsetModeOptions
---@field MaxDistanceScaleFactor double
---@field bShellsToSolids boolean
---@field MeasureDirection EPolyEditExtrudeDirection
---@field bUseColinearityForSettingBorderGroups boolean
local UPolyEditOffsetProperties = {}



---@class UPolyEditPlanarProjectionUVActivity : UInteractiveToolActivity
---@field SetUVProperties UPolyEditSetUVProperties
---@field EditPreview UPolyEditPreviewMesh
---@field SurfacePathMechanic UCollectSurfacePathMechanic
---@field ActivityContext UPolyEditActivityContext
local UPolyEditPlanarProjectionUVActivity = {}



---@class UPolyEditPushPullProperties : UInteractiveToolPropertySet
---@field DistanceMode EPolyEditExtrudeDistanceMode
---@field Distance double
---@field DirectionMode EPolyEditPushPullModeOptions
---@field SingleDirection EPolyEditExtrudeDirection
---@field MaxDistanceScaleFactor double
---@field bShellsToSolids boolean
---@field MeasureDirection EPolyEditExtrudeDirection
---@field bUseColinearityForSettingBorderGroups boolean
local UPolyEditPushPullProperties = {}



---@class UPolyEditSetUVProperties : UInteractiveToolPropertySet
---@field bShowMaterial boolean
local UPolyEditSetUVProperties = {}



---@class UPolyEditTopologyProperties : UEditMeshPolygonsToolActionPropertySet
---@field bAddExtraCorners boolean
---@field ExtraCornerAngleThresholdDegrees double
local UPolyEditTopologyProperties = {}

function UPolyEditTopologyProperties:RegenerateExtraCorners() end


---@class UProceduralArrowToolProperties : UProceduralShapeToolProperties
---@field ShaftRadius float
---@field ShaftHeight float
---@field HeadRadius float
---@field HeadHeight float
---@field RadialSlices int32
---@field HeightSubdivisions int32
local UProceduralArrowToolProperties = {}



---@class UProceduralBoxToolProperties : UProceduralShapeToolProperties
---@field Width float
---@field Depth float
---@field Height float
---@field WidthSubdivisions int32
---@field DepthSubdivisions int32
---@field HeightSubdivisions int32
local UProceduralBoxToolProperties = {}



---@class UProceduralCapsuleToolProperties : UProceduralShapeToolProperties
---@field Radius float
---@field CylinderLength float
---@field HemisphereSlices int32
---@field CylinderSlices int32
---@field CylinderSubdivisions int32
local UProceduralCapsuleToolProperties = {}



---@class UProceduralConeToolProperties : UProceduralShapeToolProperties
---@field Radius float
---@field Height float
---@field RadialSlices int32
---@field HeightSubdivisions int32
local UProceduralConeToolProperties = {}



---@class UProceduralCylinderToolProperties : UProceduralShapeToolProperties
---@field Radius float
---@field Height float
---@field RadialSlices int32
---@field HeightSubdivisions int32
local UProceduralCylinderToolProperties = {}



---@class UProceduralDiscToolProperties : UProceduralShapeToolProperties
---@field DiscType EProceduralDiscType
---@field Radius float
---@field RadialSlices int32
---@field RadialSubdivisions int32
---@field HoleRadius float
local UProceduralDiscToolProperties = {}



---@class UProceduralRectangleToolProperties : UProceduralShapeToolProperties
---@field RectangleType EProceduralRectType
---@field Width float
---@field Depth float
---@field WidthSubdivisions int32
---@field DepthSubdivisions int32
---@field bMaintainDimension boolean
---@field CornerRadius float
---@field CornerSlices int32
local UProceduralRectangleToolProperties = {}



---@class UProceduralShapeToolProperties : UInteractiveToolPropertySet
---@field PolygroupMode EMakeMeshPolygroupMode
---@field TargetSurface EMakeMeshPlacementType
---@field PivotLocation EMakeMeshPivotLocation
---@field Rotation float
---@field bAlignToNormal boolean
---@field bShowGizmo boolean
---@field bShowGizmoOptions boolean
local UProceduralShapeToolProperties = {}



---@class UProceduralSphereToolProperties : UProceduralShapeToolProperties
---@field Radius float
---@field SubdivisionType EProceduralSphereType
---@field Subdivisions int32
---@field HorizontalSlices int32
---@field VerticalSlices int32
local UProceduralSphereToolProperties = {}



---@class UProceduralStairsToolProperties : UProceduralShapeToolProperties
---@field StairsType EProceduralStairsType
---@field NumSteps int32
---@field StepWidth float
---@field StepHeight float
---@field StepDepth float
---@field CurveAngle float
---@field SpiralAngle float
---@field InnerRadius float
local UProceduralStairsToolProperties = {}



---@class UProceduralTorusToolProperties : UProceduralShapeToolProperties
---@field MajorRadius float
---@field MinorRadius float
---@field MajorSlices int32
---@field MinorSlices int32
local UProceduralTorusToolProperties = {}



---@class URecomputeUVsTool : USingleSelectionMeshEditingTool
---@field UVChannelProperties UMeshUVChannelProperties
---@field Settings URecomputeUVsToolProperties
---@field PolygroupLayerProperties UPolygroupLayersProperties
---@field MaterialSettings UExistingMeshMaterialProperties
---@field bCreateUVLayoutViewOnSetup boolean
---@field UVLayoutView UUVLayoutPreview
---@field RecomputeUVsOpFactory URecomputeUVsOpFactory
---@field Preview UMeshOpPreviewWithBackgroundCompute
local URecomputeUVsTool = {}



---@class URecomputeUVsToolBuilder : USingleSelectionMeshEditingToolBuilder
local URecomputeUVsToolBuilder = {}


---@class URetriangulateGeometrySelectionCommand : UGeometrySelectionEditCommand
local URetriangulateGeometrySelectionCommand = {}


---@class URevolveOperatorFactory : UObject
---@field RevolveTool UDrawAndRevolveTool
local URevolveOperatorFactory = {}



---@class URevolveProperties : UInteractiveToolPropertySet
---@field RevolveDegreesClamped double
---@field RevolveDegrees double
---@field RevolveDegreesOffset double
---@field StepsMaxDegrees double
---@field bExplicitSteps boolean
---@field NumExplicitSteps int32
---@field HeightOffsetPerDegree double
---@field bReverseRevolutionDirection boolean
---@field bFlipMesh boolean
---@field bSharpNormals boolean
---@field SharpNormalsDegreeThreshold double
---@field bPathAtMidpointOfStep boolean
---@field PolygroupMode ERevolvePropertiesPolygroupMode
---@field QuadSplitMode ERevolvePropertiesQuadSplit
local URevolveProperties = {}



---@class URevolveToolProperties : URevolveProperties
---@field CapFillMode ERevolvePropertiesCapFillMode
---@field bClosePathToAxis boolean
---@field DrawPlaneOrigin FVector
---@field DrawPlaneOrientation FRotator
---@field bEnableSnapping boolean
---@field bAllowedToEditDrawPlane boolean
local URevolveToolProperties = {}



---@class UTrimMeshesToolProperties : UInteractiveToolPropertySet
---@field WhichMesh ETrimOperation
---@field TrimSide ETrimSide
---@field WindingThreshold float
---@field bShowTrimmingMesh boolean
---@field OpacityOfTrimmingMesh float
---@field ColorOfTrimmingMesh FLinearColor
local UTrimMeshesToolProperties = {}



---@class UUVLayoutTool : UMultiSelectionMeshEditingTool
---@field UVChannelProperties UMeshUVChannelProperties
---@field BasicProperties UUVLayoutProperties
---@field MaterialSettings UExistingMeshMaterialProperties
---@field Previews TArray<UMeshOpPreviewWithBackgroundCompute>
---@field Factories TArray<UUVLayoutOperatorFactory>
---@field UVLayoutView UUVLayoutPreview
local UUVLayoutTool = {}



---@class UUVLayoutToolBuilder : UMultiSelectionMeshEditingToolBuilder
local UUVLayoutToolBuilder = {}


---@class UUVProjectionOperatorFactory : UObject
---@field Tool UUVProjectionTool
local UUVProjectionOperatorFactory = {}



---@class UUVProjectionTool : USingleTargetWithSelectionTool
---@field UVChannelProperties UMeshUVChannelProperties
---@field BasicProperties UUVProjectionToolProperties
---@field EditActions UUVProjectionToolEditActions
---@field MaterialSettings UExistingMeshMaterialProperties
---@field Preview UMeshOpPreviewWithBackgroundCompute
---@field CheckerMaterial UMaterialInstanceDynamic
---@field TransformGizmo UCombinedTransformGizmo
---@field TransformProxy UTransformProxy
---@field OperatorFactory UUVProjectionOperatorFactory
---@field EdgeRenderer UPreviewGeometry
---@field ClickToSetPlaneBehavior USingleClickInputBehavior
local UUVProjectionTool = {}



---@class UUVProjectionToolBuilder : USingleTargetWithSelectionToolBuilder
local UUVProjectionToolBuilder = {}


---@class UUVProjectionToolEditActions : UInteractiveToolPropertySet
local UUVProjectionToolEditActions = {}

function UUVProjectionToolEditActions:Reset() end
function UUVProjectionToolEditActions:AutoFitAlign() end
function UUVProjectionToolEditActions:AutoFit() end


---@class UUVProjectionToolProperties : UInteractiveToolPropertySet
---@field ProjectionType EUVProjectionMethod
---@field Dimensions FVector
---@field bProportionalDimensions boolean
---@field Initialization EUVProjectionToolInitializationMode
---@field CylinderSplitAngle float
---@field ExpMapNormalBlending float
---@field ExpMapSmoothingSteps int32
---@field ExpMapSmoothingAlpha float
---@field Rotation float
---@field Scale FVector2D
---@field Translation FVector2D
---@field SavedDimensions FVector
---@field bSavedProportionalDimensions boolean
---@field SavedTransform FTransform
local UUVProjectionToolProperties = {}



