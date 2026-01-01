---@enum EDrawPolygonDrawMode
local EDrawPolygonDrawMode = {
    Freehand = 0,
    Circle = 1,
    Square = 2,
    Rectangle = 3,
    RoundedRectangle = 4,
    Ring = 5,
    EDrawPolygonDrawMode_MAX = 6,
}

---@enum EDrawPolygonExtrudeMode
local EDrawPolygonExtrudeMode = {
    Flat = 0,
    Fixed = 1,
    Interactive = 2,
    EDrawPolygonExtrudeMode_MAX = 3,
}

---@enum EEdgeLoopInsertionMode
local EEdgeLoopInsertionMode = {
    Retriangulate = 0,
    PlaneCut = 1,
    EEdgeLoopInsertionMode_MAX = 2,
}

---@enum EEdgeLoopPositioningMode
local EEdgeLoopPositioningMode = {
    Even = 0,
    ProportionOffset = 1,
    DistanceOffset = 2,
    EEdgeLoopPositioningMode_MAX = 3,
}

---@enum EEditMeshPolygonsToolActions
local EEditMeshPolygonsToolActions = {
    NoAction = 0,
    AcceptCurrent = 1,
    CancelCurrent = 2,
    Extrude = 3,
    PushPull = 4,
    Offset = 5,
    Inset = 6,
    Outset = 7,
    BevelFaces = 8,
    InsertEdge = 9,
    InsertEdgeLoop = 10,
    Complete = 11,
    PlaneCut = 12,
    Merge = 13,
    Delete = 14,
    CutFaces = 15,
    RecalculateNormals = 16,
    FlipNormals = 17,
    Retriangulate = 18,
    Decompose = 19,
    Disconnect = 20,
    Duplicate = 21,
    CollapseEdge = 22,
    WeldEdges = 23,
    WeldEdgesCentered = 24,
    StraightenEdge = 25,
    FillHole = 26,
    BridgeEdges = 27,
    ExtrudeEdges = 28,
    BevelEdges = 29,
    SimplifyAlongEdges = 30,
    PlanarProjectionUV = 31,
    SimplifyByGroups = 32,
    RegenerateExtraCorners = 33,
    PokeSingleFace = 34,
    SplitSingleEdge = 35,
    FlipSingleEdge = 36,
    CollapseSingleEdge = 37,
    BevelAuto = 38,
    EEditMeshPolygonsToolActions_MAX = 39,
}

---@enum EEditMeshPolygonsToolSelectionMode
local EEditMeshPolygonsToolSelectionMode = {
    Faces = 0,
    Edges = 1,
    Vertices = 2,
    Loops = 3,
    Rings = 4,
    FacesEdgesVertices = 5,
    EEditMeshPolygonsToolSelectionMode_MAX = 6,
}

---@enum EGroupEdgeInsertionMode
local EGroupEdgeInsertionMode = {
    Retriangulate = 0,
    PlaneCut = 1,
    EGroupEdgeInsertionMode_MAX = 2,
}

---@enum ELocalFrameMode
local ELocalFrameMode = {
    FromObject = 0,
    FromGeometry = 1,
    ELocalFrameMode_MAX = 2,
}

---@enum EMakeMeshPivotLocation
local EMakeMeshPivotLocation = {
    Base = 0,
    Centered = 1,
    Top = 2,
    EMakeMeshPivotLocation_MAX = 3,
}

---@enum EMakeMeshPlacementType
local EMakeMeshPlacementType = {
    GroundPlane = 0,
    OnScene = 1,
    AtOrigin = 2,
    EMakeMeshPlacementType_MAX = 3,
}

---@enum EMakeMeshPolygroupMode
local EMakeMeshPolygroupMode = {
    PerShape = 0,
    PerFace = 1,
    PerQuad = 2,
    EMakeMeshPolygroupMode_MAX = 3,
}

---@enum EMeshEditingMaterialModes
local EMeshEditingMaterialModes = {
    ExistingMaterial = 0,
    Diffuse = 1,
    Grey = 2,
    Soft = 3,
    Transparent = 4,
    TangentNormal = 5,
    VertexColor = 6,
    CustomImage = 7,
    Custom = 8,
    EMeshEditingMaterialModes_MAX = 9,
}

---@enum EPolyEditCutPlaneOrientation
local EPolyEditCutPlaneOrientation = {
    FaceNormals = 0,
    ViewDirection = 1,
    EPolyEditCutPlaneOrientation_MAX = 2,
}

---@enum EPolyEditExtrudeDirection
local EPolyEditExtrudeDirection = {
    SelectionNormal = 0,
    WorldX = 1,
    WorldY = 2,
    WorldZ = 3,
    LocalX = 4,
    LocalY = 5,
    LocalZ = 6,
    EPolyEditExtrudeDirection_MAX = 7,
}

---@enum EPolyEditExtrudeDistanceMode
local EPolyEditExtrudeDistanceMode = {
    ClickInViewport = 0,
    Fixed = 1,
    EPolyEditExtrudeDistanceMode_MAX = 2,
}

---@enum EPolyEditExtrudeEdgeDirectionMode
local EPolyEditExtrudeEdgeDirectionMode = {
    LocalExtrudeFrames = 0,
    SingleDirection = 1,
    EPolyEditExtrudeEdgeDirectionMode_MAX = 2,
}

---@enum EPolyEditExtrudeEdgeDistanceMode
local EPolyEditExtrudeEdgeDistanceMode = {
    Fixed = 0,
    Gizmo = 1,
    EPolyEditExtrudeEdgeDistanceMode_MAX = 2,
}

---@enum EPolyEditExtrudeModeOptions
local EPolyEditExtrudeModeOptions = {
    SingleDirection = 3,
    SelectedTriangleNormals = 0,
    SelectedTriangleNormalsEven = 1,
    EPolyEditExtrudeModeOptions_MAX = 4,
}

---@enum EPolyEditOffsetModeOptions
local EPolyEditOffsetModeOptions = {
    VertexNormals = 2,
    SelectedTriangleNormals = 0,
    SelectedTriangleNormalsEven = 1,
    EPolyEditOffsetModeOptions_MAX = 3,
}

---@enum EPolyEditPushPullModeOptions
local EPolyEditPushPullModeOptions = {
    SelectedTriangleNormals = 0,
    SelectedTriangleNormalsEven = 1,
    SingleDirection = 3,
    VertexNormals = 2,
    EPolyEditPushPullModeOptions_MAX = 4,
}

---@enum EProceduralDiscType
local EProceduralDiscType = {
    Disc = 0,
    PuncturedDisc = 1,
    EProceduralDiscType_MAX = 2,
}

---@enum EProceduralRectType
local EProceduralRectType = {
    Rectangle = 0,
    RoundedRectangle = 1,
    EProceduralRectType_MAX = 2,
}

---@enum EProceduralSphereType
local EProceduralSphereType = {
    LatLong = 0,
    Box = 1,
    EProceduralSphereType_MAX = 2,
}

---@enum EProceduralStairsType
local EProceduralStairsType = {
    Linear = 0,
    Floating = 1,
    Curved = 2,
    Spiral = 3,
    EProceduralStairsType_MAX = 4,
}

---@enum ERevolvePropertiesCapFillMode
local ERevolvePropertiesCapFillMode = {
    None = 0,
    CenterFan = 1,
    Delaunay = 2,
    EarClipping = 3,
    ERevolvePropertiesCapFillMode_MAX = 4,
}

---@enum ERevolvePropertiesPolygroupMode
local ERevolvePropertiesPolygroupMode = {
    PerShape = 0,
    PerFace = 1,
    PerRevolveStep = 2,
    PerPathSegment = 3,
    ERevolvePropertiesPolygroupMode_MAX = 4,
}

---@enum ERevolvePropertiesQuadSplit
local ERevolvePropertiesQuadSplit = {
    Uniform = 0,
    Compact = 1,
    ERevolvePropertiesQuadSplit_MAX = 2,
}

---@enum ESetMeshMaterialMode
local ESetMeshMaterialMode = {
    Original = 0,
    Checkerboard = 1,
    Override = 2,
    ESetMeshMaterialMode_MAX = 3,
}

---@enum EUVProjectionToolActions
local EUVProjectionToolActions = {
    NoAction = 0,
    AutoFit = 1,
    AutoFitAlign = 2,
    Reset = 3,
    EUVProjectionToolActions_MAX = 4,
}

---@enum EUVProjectionToolInitializationMode
local EUVProjectionToolInitializationMode = {
    Default = 0,
    UsePrevious = 1,
    AutoFit = 2,
    AutoFitAlign = 3,
    EUVProjectionToolInitializationMode_MAX = 4,
}

