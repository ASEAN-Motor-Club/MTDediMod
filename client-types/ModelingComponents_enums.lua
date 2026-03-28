---@enum EBakeTextureBitDepth
local EBakeTextureBitDepth = {
    ChannelBits8 = 0,
    ChannelBits16 = 1,
    EBakeTextureBitDepth_MAX = 2,
}

---@enum EBakeTextureResolution
local EBakeTextureResolution = {
    Resolution16 = 16,
    Resolution32 = 32,
    Resolution64 = 64,
    Resolution128 = 128,
    Resolution256 = 256,
    Resolution512 = 512,
    Resolution1024 = 1024,
    Resolution2048 = 2048,
    Resolution4096 = 4096,
    Resolution8192 = 8192,
    EBakeTextureResolution_MAX = 8193,
}

---@enum EBakeTextureSamplesPerPixel
local EBakeTextureSamplesPerPixel = {
    Sample1 = 1,
    Sample4 = 4,
    Sample16 = 16,
    Sample64 = 64,
    Sample256 = 256,
    EBakeTextureSamplesPerPixel_MAX = 257,
}

---@enum EBaseCreateFromSelectedTargetType
local EBaseCreateFromSelectedTargetType = {
    NewObject = 0,
    FirstInputObject = 1,
    LastInputObject = 2,
    EBaseCreateFromSelectedTargetType_MAX = 3,
}

---@enum ECreateMeshObjectSourceMeshType
local ECreateMeshObjectSourceMeshType = {
    MeshDescription = 0,
    DynamicMesh = 1,
    ECreateMeshObjectSourceMeshType_MAX = 2,
}

---@enum ECreateModelingObjectResult
local ECreateModelingObjectResult = {
    Ok = 0,
    Cancelled = 1,
    Failed_Unknown = 2,
    Failed_NoAPIFound = 3,
    Failed_InvalidWorld = 4,
    Failed_InvalidMesh = 5,
    Failed_InvalidTexture = 6,
    Failed_AssetCreationFailed = 7,
    Failed_ActorCreationFailed = 8,
    Failed_InvalidMaterial = 9,
    ECreateModelingObjectResult_MAX = 10,
}

---@enum ECreateObjectTypeHint
local ECreateObjectTypeHint = {
    Undefined = 0,
    StaticMesh = 1,
    Volume = 2,
    DynamicMeshActor = 3,
    ECreateObjectTypeHint_MAX = 4,
}

---@enum EGeometrySelectionElementType
local EGeometrySelectionElementType = {
    Vertex = 1,
    Edge = 2,
    Face = 4,
    EGeometrySelectionElementType_MAX = 5,
}

---@enum EGeometrySelectionTopologyType
local EGeometrySelectionTopologyType = {
    Triangle = 1,
    Polygroup = 2,
    EGeometrySelectionTopologyType_MAX = 3,
}

---@enum EHandleSourcesMethod
local EHandleSourcesMethod = {
    DeleteSources = 0,
    HideSources = 1,
    KeepSources = 2,
    KeepFirstSource = 3,
    KeepLastSource = 4,
    EHandleSourcesMethod_MAX = 5,
}

---@enum EMarqueeSelectionUpdateType
local EMarqueeSelectionUpdateType = {
    OnDrag = 0,
    OnTickAndRelease = 1,
    OnRelease = 2,
    EMarqueeSelectionUpdateType_MAX = 3,
}

---@enum EModelingComponentsPlaneVisualizationMode
local EModelingComponentsPlaneVisualizationMode = {
    SimpleGrid = 0,
    HierarchicalGrid = 1,
    FixedScreenAreaGrid = 2,
    EModelingComponentsPlaneVisualizationMode_MAX = 3,
}

---@enum EMultiTransformerMode
local EMultiTransformerMode = {
    DefaultGizmo = 1,
    QuickAxisTranslation = 2,
    EMultiTransformerMode_MAX = 3,
}

---@enum ESpaceCurveControlPointFalloffType
local ESpaceCurveControlPointFalloffType = {
    Linear = 0,
    Smooth = 1,
    ESpaceCurveControlPointFalloffType_MAX = 2,
}

---@enum ESpaceCurveControlPointOriginMode
local ESpaceCurveControlPointOriginMode = {
    Shared = 0,
    First = 1,
    Last = 2,
    ESpaceCurveControlPointOriginMode_MAX = 3,
}

---@enum ESpaceCurveControlPointTransformMode
local ESpaceCurveControlPointTransformMode = {
    Shared = 0,
    PerVertex = 1,
    ESpaceCurveControlPointTransformMode_MAX = 2,
}

---@enum EUVLayoutPreviewSide
local EUVLayoutPreviewSide = {
    Left = 0,
    Right = 1,
    EUVLayoutPreviewSide_MAX = 2,
}

