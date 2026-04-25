---@enum EDynamicMeshAttributeChangeFlags
local EDynamicMeshAttributeChangeFlags = {
    Unknown = 0,
    MeshTopology = 1,
    VertexPositions = 2,
    NormalsTangents = 4,
    VertexColors = 8,
    UVs = 16,
    TriangleGroups = 32,
    EDynamicMeshAttributeChangeFlags_MAX = 33,
}

---@enum EDynamicMeshChangeType
local EDynamicMeshChangeType = {
    GeneralEdit = 0,
    MeshChange = 1,
    MeshReplacementChange = 2,
    MeshVertexChange = 3,
    DeformationEdit = 4,
    AttributeEdit = 5,
    EDynamicMeshChangeType_MAX = 6,
}

---@enum EDynamicMeshComponentColorOverrideMode
local EDynamicMeshComponentColorOverrideMode = {
    None = 0,
    VertexColors = 1,
    Polygroups = 2,
    Constant = 3,
    EDynamicMeshComponentColorOverrideMode_MAX = 4,
}

---@enum EDynamicMeshComponentDistanceFieldMode
local EDynamicMeshComponentDistanceFieldMode = {
    NoDistanceField = 0,
    AsyncCPUDistanceField = 1,
    EDynamicMeshComponentDistanceFieldMode_MAX = 2,
}

---@enum EDynamicMeshComponentRenderUpdateMode
local EDynamicMeshComponentRenderUpdateMode = {
    NoUpdate = 0,
    FullUpdate = 1,
    FastUpdate = 2,
    EDynamicMeshComponentRenderUpdateMode_MAX = 3,
}

---@enum EDynamicMeshComponentTangentsMode
local EDynamicMeshComponentTangentsMode = {
    NoTangents = 0,
    AutoCalculated = 1,
    ExternallyProvided = 2,
    Default = 255,
    EDynamicMeshComponentTangentsMode_MAX = 256,
}

---@enum EDynamicMeshDrawPath
local EDynamicMeshDrawPath = {
    DynamicDraw = 0,
    StaticDraw = 1,
    EDynamicMeshDrawPath_MAX = 2,
}

---@enum EDynamicMeshVertexColorTransformMode
local EDynamicMeshVertexColorTransformMode = {
    NoTransform = 0,
    LinearToSRGB = 1,
    SRGBToLinear = 2,
    EDynamicMeshVertexColorTransformMode_MAX = 3,
}

