---@enum EAlignObjectsAlignToOptions
local EAlignObjectsAlignToOptions = {
    FirstSelected = 0,
    LastSelected = 1,
    Combined = 2,
    EAlignObjectsAlignToOptions_MAX = 3,
}

---@enum EAlignObjectsAlignTypes
local EAlignObjectsAlignTypes = {
    Pivots = 0,
    BoundingBoxes = 1,
    EAlignObjectsAlignTypes_MAX = 2,
}

---@enum EAlignObjectsBoxPoint
local EAlignObjectsBoxPoint = {
    Center = 0,
    Bottom = 1,
    Top = 2,
    Left = 3,
    Right = 4,
    Front = 5,
    Back = 6,
    Min = 7,
    Max = 8,
}

---@enum EBakeCurvatureClampMode
local EBakeCurvatureClampMode = {
    None = 0,
    OnlyPositive = 1,
    OnlyNegative = 2,
    EBakeCurvatureClampMode_MAX = 3,
}

---@enum EBakeCurvatureColorMode
local EBakeCurvatureColorMode = {
    Grayscale = 0,
    RedBlue = 1,
    RedGreenBlue = 2,
    EBakeCurvatureColorMode_MAX = 3,
}

---@enum EBakeCurvatureTypeMode
local EBakeCurvatureTypeMode = {
    MeanAverage = 0,
    Max = 1,
    Min = 2,
    Gaussian = 3,
}

---@enum EBakeMapType
local EBakeMapType = {
    None = 0,
    TangentSpaceNormal = 1,
    ObjectSpaceNormal = 2,
    FaceNormal = 4,
    BentNormal = 8,
    Position = 16,
    Curvature = 32,
    AmbientOcclusion = 64,
    Texture = 128,
    MultiTexture = 256,
    VertexColor = 512,
    MaterialID = 1024,
    PolyGroupID = 2048,
    One = 4096,
    Zero = 8192,
    UVShell = 16384,
    All = 16383,
    EBakeMapType_MAX = 16385,
}

---@enum EBakeNormalSpace
local EBakeNormalSpace = {
    Tangent = 0,
    Object = 1,
    EBakeNormalSpace_MAX = 2,
}

---@enum EBakeScaleMethod
local EBakeScaleMethod = {
    BakeFullScale = 0,
    BakeNonuniformScale = 1,
    DoNotBakeScale = 2,
    EBakeScaleMethod_MAX = 3,
}

---@enum EBakeVertexChannel
local EBakeVertexChannel = {
    R = 0,
    G = 1,
    B = 2,
    A = 3,
    RGBA = 4,
    EBakeVertexChannel_MAX = 5,
}

---@enum EBakeVertexOutput
local EBakeVertexOutput = {
    RGBA = 0,
    PerChannel = 1,
    EBakeVertexOutput_MAX = 2,
}

---@enum EBrushActionMode
local EBrushActionMode = {
    Paint = 0,
    FloodFill = 1,
    EBrushActionMode_MAX = 2,
}

---@enum EBrushToolSizeType
local EBrushToolSizeType = {
    Adaptive = 0,
    World = 1,
    EBrushToolSizeType_MAX = 2,
}

---@enum ECollisionGeometryMode
local ECollisionGeometryMode = {
    Default = 0,
    SimpleAndComplex = 1,
    UseSimpleAsComplex = 2,
    UseComplexAsSimple = 3,
    ECollisionGeometryMode_MAX = 4,
}

---@enum ECollisionGeometryType
local ECollisionGeometryType = {
    CopyFromInputs = 0,
    AlignedBoxes = 1,
    OrientedBoxes = 2,
    MinimalSpheres = 3,
    Capsules = 4,
    ConvexHulls = 5,
    ConvexDecompositions = 8,
    SweptHulls = 6,
    LevelSets = 7,
    MinVolume = 10,
    Empty = 11,
    ECollisionGeometryType_MAX = 12,
}

---@enum EConvertToPolygonsMode
local EConvertToPolygonsMode = {
    FaceNormalDeviation = 0,
    FindPolygons = 1,
    FromUVIslands = 2,
    FromNormalSeams = 3,
    FromConnectedTris = 4,
    FromFurthestPointSampling = 5,
    CopyFromLayer = 6,
    EConvertToPolygonsMode_MAX = 7,
}

---@enum EConvexDecompositionMethod
local EConvexDecompositionMethod = {
    NavigationDriven = 0,
    VolumetricError = 1,
    EConvexDecompositionMethod_MAX = 2,
}

---@enum ECubeGridToolAction
local ECubeGridToolAction = {
    NoAction = 0,
    Push = 1,
    Pull = 2,
    Flip = 3,
    SlideForward = 4,
    SlideBack = 5,
    DecreaseGridPower = 6,
    IncreaseGridPower = 7,
    CornerMode = 8,
    ResetFromActor = 9,
    AcceptAndStartNew = 10,
    ECubeGridToolAction_MAX = 11,
}

---@enum ECubeGridToolFaceSelectionMode
local ECubeGridToolFaceSelectionMode = {
    OutsideBasedOnNormal = 0,
    InsideBasedOnNormal = 1,
    OutsideBasedOnViewRay = 2,
    InsideBasedOnViewRay = 3,
    ECubeGridToolFaceSelectionMode_MAX = 4,
}

---@enum EDisplaceMeshToolChannelType
local EDisplaceMeshToolChannelType = {
    Red = 0,
    Green = 1,
    Blue = 2,
    Alpha = 3,
    EDisplaceMeshToolChannelType_MAX = 4,
}

---@enum EDisplaceMeshToolDisplaceType
local EDisplaceMeshToolDisplaceType = {
    Constant = 0,
    DisplacementMap = 1,
    RandomNoise = 2,
    PerlinNoise = 3,
    SineWave = 4,
    EDisplaceMeshToolDisplaceType_MAX = 5,
}

---@enum EDisplaceMeshToolSubdivisionType
local EDisplaceMeshToolSubdivisionType = {
    Flat = 0,
    PNTriangles = 1,
    EDisplaceMeshToolSubdivisionType_MAX = 2,
}

---@enum EDisplaceMeshToolTriangleSelectionType
local EDisplaceMeshToolTriangleSelectionType = {
    None = 0,
    Material = 1,
    EDisplaceMeshToolTriangleSelectionType_MAX = 2,
}

---@enum EDrawPolyPathExtrudeDirection
local EDrawPolyPathExtrudeDirection = {
    SelectionNormal = 0,
    WorldX = 1,
    WorldY = 2,
    WorldZ = 3,
    LocalX = 4,
    LocalY = 5,
    LocalZ = 6,
    EDrawPolyPathExtrudeDirection_MAX = 7,
}

---@enum EDrawPolyPathExtrudeMode
local EDrawPolyPathExtrudeMode = {
    Flat = 0,
    Fixed = 1,
    Interactive = 2,
    RampFixed = 3,
    RampInteractive = 4,
    EDrawPolyPathExtrudeMode_MAX = 5,
}

---@enum EDrawPolyPathRadiusMode
local EDrawPolyPathRadiusMode = {
    Fixed = 0,
    Interactive = 1,
    EDrawPolyPathRadiusMode_MAX = 2,
}

---@enum EDrawPolyPathWidthMode
local EDrawPolyPathWidthMode = {
    Fixed = 0,
    Interactive = 1,
    EDrawPolyPathWidthMode_MAX = 2,
}

---@enum EDynamicMeshSculptBrushType
local EDynamicMeshSculptBrushType = {
    Move = 0,
    PullKelvin = 1,
    PullSharpKelvin = 2,
    Smooth = 3,
    Offset = 4,
    SculptView = 5,
    SculptMax = 6,
    Inflate = 7,
    ScaleKelvin = 8,
    Pinch = 9,
    TwistKelvin = 10,
    Flatten = 11,
    Plane = 12,
    PlaneViewAligned = 13,
    FixedPlane = 14,
    Resample = 15,
    LastValue = 16,
    EDynamicMeshSculptBrushType_MAX = 17,
}

---@enum EEditPivotSnapDragRotationMode
local EEditPivotSnapDragRotationMode = {
    Align = 1,
    AlignFlipped = 2,
    LastValue = 3,
    EEditPivotSnapDragRotationMode_MAX = 4,
}

---@enum EEditPivotToolActions
local EEditPivotToolActions = {
    NoAction = 0,
    Center = 1,
    Bottom = 2,
    Top = 3,
    Left = 4,
    Right = 5,
    Front = 6,
    Back = 7,
    WorldOrigin = 8,
    EEditPivotToolActions_MAX = 9,
}

---@enum EExtractCollisionOutputType
local EExtractCollisionOutputType = {
    Simple = 0,
    Complex = 1,
    EExtractCollisionOutputType_MAX = 2,
}

---@enum EExtrudeMeshSelectionInteractionMode
local EExtrudeMeshSelectionInteractionMode = {
    Interactive = 0,
    Fixed = 1,
    EExtrudeMeshSelectionInteractionMode_MAX = 2,
}

---@enum EExtrudeMeshSelectionRegionModifierMode
local EExtrudeMeshSelectionRegionModifierMode = {
    OriginalShape = 0,
    FlattenToPlane = 1,
    RaycastToPlane = 2,
    EExtrudeMeshSelectionRegionModifierMode_MAX = 3,
}

---@enum EFlareProfileType
local EFlareProfileType = {
    SinMode = 0,
    SinSquaredMode = 1,
    TriangleMode = 2,
    EFlareProfileType_MAX = 3,
}

---@enum EGroupBoundaryConstraint
local EGroupBoundaryConstraint = {
    Fixed = 7,
    Refine = 5,
    Free = 1,
    Ignore = 0,
    EGroupBoundaryConstraint_MAX = 8,
}

---@enum EGroupTopologyDeformationStrategy
local EGroupTopologyDeformationStrategy = {
    Linear = 0,
    Laplacian = 1,
    EGroupTopologyDeformationStrategy_MAX = 2,
}

---@enum EHoleFillToolActions
local EHoleFillToolActions = {
    NoAction = 0,
    SelectAll = 1,
    ClearSelection = 2,
    EHoleFillToolActions_MAX = 3,
}

---@enum ELatticeDeformerToolAction
local ELatticeDeformerToolAction = {
    NoAction = 0,
    Constrain = 1,
    ClearConstraints = 2,
    ELatticeDeformerToolAction_MAX = 3,
}

---@enum ELatticeInterpolationType
local ELatticeInterpolationType = {
    Linear = 0,
    Cubic = 1,
    ELatticeInterpolationType_MAX = 2,
}

---@enum EMaterialBoundaryConstraint
local EMaterialBoundaryConstraint = {
    Fixed = 7,
    Refine = 5,
    Free = 1,
    Ignore = 0,
    EMaterialBoundaryConstraint_MAX = 8,
}

---@enum EMeshAttributePaintToolActions
local EMeshAttributePaintToolActions = {
    NoAction = 0,
    EMeshAttributePaintToolActions_MAX = 1,
}

---@enum EMeshBoundaryConstraint
local EMeshBoundaryConstraint = {
    Fixed = 7,
    Refine = 5,
    Free = 1,
    EMeshBoundaryConstraint_MAX = 8,
}

---@enum EMeshFacesColorMode
local EMeshFacesColorMode = {
    None = 0,
    ByGroup = 1,
    ByMaterialID = 2,
    ByUVIsland = 3,
    EMeshFacesColorMode_MAX = 4,
}

---@enum EMeshGroupPaintBrushAreaType
local EMeshGroupPaintBrushAreaType = {
    Connected = 0,
    Volumetric = 1,
    EMeshGroupPaintBrushAreaType_MAX = 2,
}

---@enum EMeshGroupPaintBrushType
local EMeshGroupPaintBrushType = {
    Paint = 0,
    Erase = 1,
    LastValue = 2,
    EMeshGroupPaintBrushType_MAX = 3,
}

---@enum EMeshGroupPaintInteractionType
local EMeshGroupPaintInteractionType = {
    Brush = 0,
    Fill = 1,
    GroupFill = 2,
    PolyLasso = 3,
    LastValue = 4,
    EMeshGroupPaintInteractionType_MAX = 5,
}

---@enum EMeshGroupPaintToolActions
local EMeshGroupPaintToolActions = {
    NoAction = 0,
    ClearFrozen = 1,
    FreezeCurrent = 2,
    FreezeOthers = 3,
    GrowCurrent = 4,
    ShrinkCurrent = 5,
    ClearCurrent = 6,
    FloodFillCurrent = 7,
    ClearAll = 8,
    EMeshGroupPaintToolActions_MAX = 9,
}

---@enum EMeshGroupPaintVisibilityType
local EMeshGroupPaintVisibilityType = {
    None = 0,
    FrontFacing = 1,
    Unoccluded = 2,
    EMeshGroupPaintVisibilityType_MAX = 3,
}

---@enum EMeshInspectorMaterialMode
local EMeshInspectorMaterialMode = {
    Original = 0,
    FlatShaded = 1,
    Grey = 2,
    Transparent = 3,
    TangentNormal = 4,
    VertexColor = 5,
    GroupColor = 6,
    Checkerboard = 7,
    Override = 8,
    EMeshInspectorMaterialMode_MAX = 9,
}

---@enum EMeshInspectorToolDrawIndexMode
local EMeshInspectorToolDrawIndexMode = {
    None = 0,
    VertexID = 1,
    TriangleID = 2,
    GroupID = 3,
    EdgeID = 4,
    EMeshInspectorToolDrawIndexMode_MAX = 5,
}

---@enum EMeshSculptFalloffType
local EMeshSculptFalloffType = {
    Smooth = 0,
    Linear = 1,
    Inverse = 2,
    Round = 3,
    BoxSmooth = 4,
    BoxLinear = 5,
    BoxInverse = 6,
    BoxRound = 7,
    LastValue = 8,
    EMeshSculptFalloffType_MAX = 9,
}

---@enum EMeshSelectionToolActions
local EMeshSelectionToolActions = {
    NoAction = 0,
    SelectAll = 1,
    SelectAllByMaterial = 2,
    ClearSelection = 3,
    InvertSelection = 4,
    GrowSelection = 5,
    ShrinkSelection = 6,
    ExpandToConnected = 7,
    SelectLargestComponentByTriCount = 8,
    SelectLargestComponentByArea = 9,
    OptimizeSelection = 10,
    DeleteSelected = 11,
    DisconnectSelected = 12,
    SeparateSelected = 13,
    DuplicateSelected = 14,
    FlipSelected = 15,
    CreateGroup = 16,
    SmoothBoundary = 17,
    CycleSelectionMode = 18,
    CycleViewMode = 19,
    EMeshSelectionToolActions_MAX = 20,
}

---@enum EMeshSelectionToolPrimaryMode
local EMeshSelectionToolPrimaryMode = {
    Brush = 0,
    VolumetricBrush = 1,
    AngleFiltered = 2,
    Visible = 3,
    AllConnected = 4,
    AllInGroup = 5,
    ByMaterial = 6,
    ByMaterialAll = 7,
    ByUVIsland = 8,
    AllWithinAngle = 9,
    EMeshSelectionToolPrimaryMode_MAX = 10,
}

---@enum EMeshSpaceDeformerToolAction
local EMeshSpaceDeformerToolAction = {
    NoAction = 0,
    ShiftToCenter = 1,
    EMeshSpaceDeformerToolAction_MAX = 2,
}

---@enum EMeshVertexPaintBrushAreaType
local EMeshVertexPaintBrushAreaType = {
    Connected = 0,
    Volumetric = 1,
    EMeshVertexPaintBrushAreaType_MAX = 2,
}

---@enum EMeshVertexPaintBrushType
local EMeshVertexPaintBrushType = {
    Paint = 0,
    Erase = 1,
    Soften = 2,
    Smooth = 3,
    LastValue = 4,
    EMeshVertexPaintBrushType_MAX = 5,
}

---@enum EMeshVertexPaintColorBlendMode
local EMeshVertexPaintColorBlendMode = {
    Lerp = 0,
    Mix = 1,
    Multiply = 2,
    EMeshVertexPaintColorBlendMode_MAX = 3,
}

---@enum EMeshVertexPaintColorChannel
local EMeshVertexPaintColorChannel = {
    Red = 0,
    Green = 1,
    Blue = 2,
    Alpha = 3,
    EMeshVertexPaintColorChannel_MAX = 4,
}

---@enum EMeshVertexPaintInteractionType
local EMeshVertexPaintInteractionType = {
    Brush = 0,
    TriFill = 1,
    Fill = 2,
    GroupFill = 3,
    PolyLasso = 4,
    LastValue = 5,
    EMeshVertexPaintInteractionType_MAX = 6,
}

---@enum EMeshVertexPaintMaterialMode
local EMeshVertexPaintMaterialMode = {
    LitVertexColor = 0,
    UnlitVertexColor = 1,
    OriginalMaterial = 2,
    EMeshVertexPaintMaterialMode_MAX = 3,
}

---@enum EMeshVertexPaintSecondaryActionType
local EMeshVertexPaintSecondaryActionType = {
    Erase = 0,
    Soften = 1,
    Smooth = 2,
    EMeshVertexPaintSecondaryActionType_MAX = 3,
}

---@enum EMeshVertexPaintToolActions
local EMeshVertexPaintToolActions = {
    NoAction = 0,
    PaintAll = 1,
    EraseAll = 2,
    FillBlack = 3,
    FillWhite = 4,
    ApplyCurrentUtility = 5,
    EMeshVertexPaintToolActions_MAX = 6,
}

---@enum EMeshVertexPaintToolUtilityOperations
local EMeshVertexPaintToolUtilityOperations = {
    BlendAllSeams = 0,
    FillChannels = 1,
    InvertChannels = 2,
    CopyChannelToChannel = 3,
    SwapChannels = 4,
    CopyFromWeightMap = 5,
    CopyToOtherLODs = 6,
    CopyToSingleLOD = 7,
    EMeshVertexPaintToolUtilityOperations_MAX = 8,
}

---@enum EMeshVertexPaintVisibilityType
local EMeshVertexPaintVisibilityType = {
    None = 0,
    FrontFacing = 1,
    Unoccluded = 2,
    EMeshVertexPaintVisibilityType_MAX = 3,
}

---@enum EMeshVertexSculptBrushFilterType
local EMeshVertexSculptBrushFilterType = {
    None = 0,
    Component = 1,
    PolyGroup = 2,
    EMeshVertexSculptBrushFilterType_MAX = 3,
}

---@enum EMeshVertexSculptBrushType
local EMeshVertexSculptBrushType = {
    Move = 0,
    PullKelvin = 1,
    PullSharpKelvin = 2,
    Smooth = 3,
    SmoothFill = 4,
    Offset = 5,
    SculptView = 6,
    SculptMax = 7,
    Inflate = 8,
    ScaleKelvin = 9,
    Pinch = 10,
    TwistKelvin = 11,
    Flatten = 12,
    Plane = 13,
    PlaneViewAligned = 14,
    FixedPlane = 15,
    LastValue = 16,
    EMeshVertexSculptBrushType_MAX = 17,
}

---@enum EMirrorOperationMode
local EMirrorOperationMode = {
    MirrorAndAppend = 0,
    MirrorExisting = 1,
    EMirrorOperationMode_MAX = 2,
}

---@enum EMirrorSaveMode
local EMirrorSaveMode = {
    InputObjects = 0,
    NewObjects = 1,
    EMirrorSaveMode_MAX = 2,
}

---@enum EMirrorToolAction
local EMirrorToolAction = {
    NoAction = 0,
    ShiftToCenter = 1,
    Left = 2,
    Right = 3,
    Up = 4,
    Down = 5,
    Forward = 6,
    Backward = 7,
    EMirrorToolAction_MAX = 8,
}

---@enum ENonlinearOperationType
local ENonlinearOperationType = {
    Bend = 0,
    Flare = 1,
    Twist = 2,
    ENonlinearOperationType_MAX = 3,
}

---@enum EOccludedAction
local EOccludedAction = {
    Remove = 0,
    SetNewGroup = 1,
    EOccludedAction_MAX = 2,
}

---@enum EOcclusionCalculationUIMode
local EOcclusionCalculationUIMode = {
    GeneralizedWindingNumber = 0,
    RaycastOcclusionSamples = 1,
    EOcclusionCalculationUIMode_MAX = 2,
}

---@enum EOcclusionTriangleSamplingUIMode
local EOcclusionTriangleSamplingUIMode = {
    Vertices = 0,
    VerticesAndCentroids = 1,
    EOcclusionTriangleSamplingUIMode_MAX = 2,
}

---@enum EOffsetMeshSelectionDirectionMode
local EOffsetMeshSelectionDirectionMode = {
    VertexNormals = 0,
    FaceNormals = 1,
    ConstantWidth = 2,
    EOffsetMeshSelectionDirectionMode_MAX = 3,
}

---@enum EOffsetMeshSelectionInteractionMode
local EOffsetMeshSelectionInteractionMode = {
    Fixed = 0,
    EOffsetMeshSelectionInteractionMode_MAX = 1,
}

---@enum EOffsetMeshToolOffsetType
local EOffsetMeshToolOffsetType = {
    Iterative = 0,
    Implicit = 1,
    EOffsetMeshToolOffsetType_MAX = 2,
}

---@enum EPatternToolAxisSpacingMode
local EPatternToolAxisSpacingMode = {
    ByCount = 0,
    StepSize = 1,
    Packed = 2,
    EPatternToolAxisSpacingMode_MAX = 3,
}

---@enum EPatternToolShape
local EPatternToolShape = {
    Line = 0,
    Grid = 1,
    Circle = 2,
    EPatternToolShape_MAX = 3,
}

---@enum EPatternToolSingleAxis
local EPatternToolSingleAxis = {
    XAxis = 0,
    YAxis = 1,
    ZAxis = 2,
    EPatternToolSingleAxis_MAX = 3,
}

---@enum EPatternToolSinglePlane
local EPatternToolSinglePlane = {
    XYPlane = 0,
    XZPlane = 1,
    YZPlane = 2,
    EPatternToolSinglePlane_MAX = 3,
}

---@enum EPlaneBrushSideMode
local EPlaneBrushSideMode = {
    BothSides = 0,
    PushDown = 1,
    PullTowards = 2,
    EPlaneBrushSideMode_MAX = 3,
}

---@enum EPlaneCutToolActions
local EPlaneCutToolActions = {
    NoAction = 0,
    Cut = 1,
    FlipPlane = 2,
    EPlaneCutToolActions_MAX = 3,
}

---@enum EProjectedHullAxis
local EProjectedHullAxis = {
    X = 0,
    Y = 1,
    Z = 2,
    SmallestBoxDimension = 3,
    SmallestVolume = 4,
    EProjectedHullAxis_MAX = 5,
}

---@enum EQuickTransformerMode
local EQuickTransformerMode = {
    AxisTranslation = 0,
    AxisRotation = 1,
    EQuickTransformerMode_MAX = 2,
}

---@enum ERevolveSplineSampleMode
local ERevolveSplineSampleMode = {
    ControlPointsOnly = 0,
    PolyLineMaxError = 1,
    UniformSpacingAlongCurve = 2,
    ERevolveSplineSampleMode_MAX = 3,
}

---@enum ESetCollisionGeometryInputMode
local ESetCollisionGeometryInputMode = {
    CombineAll = 0,
    PerInputObject = 1,
    PerMeshComponent = 2,
    PerMeshGroup = 3,
    ESetCollisionGeometryInputMode_MAX = 4,
}

---@enum ESimpleCollisionEditorToolAction
local ESimpleCollisionEditorToolAction = {
    NoAction = 0,
    AddSphere = 1,
    AddBox = 2,
    AddCapsule = 3,
    Duplicate = 4,
    DeleteSelected = 5,
    DeleteAll = 6,
    ESimpleCollisionEditorToolAction_MAX = 7,
}

---@enum ESmoothMeshToolSmoothType
local ESmoothMeshToolSmoothType = {
    Iterative = 0,
    Implicit = 1,
    Diffusion = 2,
    ESmoothMeshToolSmoothType_MAX = 3,
}

---@enum ESplitMeshesMethod
local ESplitMeshesMethod = {
    ByMeshTopology = 0,
    ByVertexOverlap = 1,
    ByMaterialID = 2,
    ByPolyGroup = 3,
    ESplitMeshesMethod_MAX = 4,
}

---@enum ETransformMeshesSnapDragRotationMode
local ETransformMeshesSnapDragRotationMode = {
    Ignore = 0,
    Align = 1,
    AlignFlipped = 2,
    LastValue = 3,
    ETransformMeshesSnapDragRotationMode_MAX = 4,
}

---@enum ETransformMeshesSnapDragSource
local ETransformMeshesSnapDragSource = {
    ClickPoint = 0,
    Pivot = 1,
    LastValue = 2,
    ETransformMeshesSnapDragSource_MAX = 3,
}

---@enum ETransformMeshesTransformMode
local ETransformMeshesTransformMode = {
    SharedGizmo = 0,
    SharedGizmoLocal = 1,
    PerObjectGizmo = 2,
    LastValue = 3,
    ETransformMeshesTransformMode_MAX = 4,
}

---@enum EVertexColorPaintBrushOpBlendMode
local EVertexColorPaintBrushOpBlendMode = {
    Lerp = 0,
    Mix = 1,
    Multiply = 2,
    EVertexColorPaintBrushOpBlendMode_MAX = 3,
}

---@enum EVoxelBlendOperation
local EVoxelBlendOperation = {
    Union = 0,
    Subtract = 1,
    EVoxelBlendOperation_MAX = 2,
}

---@enum EWeightScheme
local EWeightScheme = {
    Uniform = 0,
    Umbrella = 1,
    Valence = 2,
    MeanValue = 3,
    Cotangent = 4,
    ClampedCotangent = 5,
    IDTCotangent = 6,
    EWeightScheme_MAX = 7,
}

---@enum EWeldMeshEdgesAttributeUIMode
local EWeldMeshEdgesAttributeUIMode = {
    None = 0,
    OnWeldedMeshEdgesOnly = 1,
    OnFullMesh = 2,
    EWeldMeshEdgesAttributeUIMode_MAX = 3,
}

