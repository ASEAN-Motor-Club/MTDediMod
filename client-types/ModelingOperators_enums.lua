---@enum ECSGOperation
local ECSGOperation = {
    DifferenceAB = 0,
    DifferenceBA = 1,
    Intersect = 2,
    Union = 3,
    ECSGOperation_MAX = 4,
}

---@enum ECombineCurvesMethod
local ECombineCurvesMethod = {
    LeaveSeparate = 0,
    Union = 1,
    Intersect = 2,
    Difference = 3,
    ExclusiveOr = 4,
    ECombineCurvesMethod_MAX = 5,
}

---@enum EFlattenCurveMethod
local EFlattenCurveMethod = {
    DoNotFlatten = 0,
    ToBestFitPlane = 1,
    AlongX = 2,
    AlongY = 3,
    AlongZ = 4,
    EFlattenCurveMethod_MAX = 5,
}

---@enum EHoleFillOpFillType
local EHoleFillOpFillType = {
    TriangleFan = 0,
    PolygonEarClipping = 1,
    Planar = 2,
    Minimal = 3,
    Smooth = 4,
    EHoleFillOpFillType_MAX = 5,
}

---@enum EMorphologyOperation
local EMorphologyOperation = {
    Dilate = 0,
    Contract = 1,
    Close = 2,
    Open = 3,
    EMorphologyOperation_MAX = 4,
}

---@enum ENormalCalculationMethod
local ENormalCalculationMethod = {
    AreaWeighted = 0,
    AngleWeighted = 1,
    AreaAngleWeighting = 2,
    ENormalCalculationMethod_MAX = 3,
}

---@enum EOffsetClosedCurvesMethod
local EOffsetClosedCurvesMethod = {
    DoNotOffset = 0,
    OffsetOuterSide = 1,
    OffsetBothSides = 2,
    EOffsetClosedCurvesMethod_MAX = 3,
}

---@enum EOffsetJoinMethod
local EOffsetJoinMethod = {
    Square = 0,
    Miter = 1,
    Round = 2,
    EOffsetJoinMethod_MAX = 3,
}

---@enum EOffsetOpenCurvesMethod
local EOffsetOpenCurvesMethod = {
    TreatAsClosed = 0,
    Offset = 1,
    EOffsetOpenCurvesMethod_MAX = 2,
}

---@enum EOpenCurveEndShapes
local EOpenCurveEndShapes = {
    Square = 0,
    Round = 1,
    Butt = 2,
    EOpenCurveEndShapes_MAX = 3,
}

---@enum ERecomputeUVsPropertiesIslandMode
local ERecomputeUVsPropertiesIslandMode = {
    PolyGroups = 0,
    ExistingUVs = 1,
    ERecomputeUVsPropertiesIslandMode_MAX = 2,
}

---@enum ERecomputeUVsPropertiesLayoutType
local ERecomputeUVsPropertiesLayoutType = {
    None = 0,
    Repack = 1,
    NormalizeToExistingBounds = 2,
    NormalizeToBounds = 3,
    NormalizeToWorld = 4,
    ERecomputeUVsPropertiesLayoutType_MAX = 5,
}

---@enum ERecomputeUVsPropertiesUnwrapType
local ERecomputeUVsPropertiesUnwrapType = {
    ExpMap = 0,
    Conformal = 1,
    SpectralConformal = 2,
    IslandMerging = 3,
    ERecomputeUVsPropertiesUnwrapType_MAX = 4,
}

---@enum ERecomputeUVsToolOrientationMode
local ERecomputeUVsToolOrientationMode = {
    None = 0,
    MinBounds = 1,
    ERecomputeUVsToolOrientationMode_MAX = 2,
}

---@enum ERemeshSmoothingType
local ERemeshSmoothingType = {
    Uniform = 0,
    Cotangent = 1,
    MeanValue = 2,
    ERemeshSmoothingType_MAX = 3,
}

---@enum ERemeshType
local ERemeshType = {
    Standard = 0,
    FullPass = 1,
    NormalFlow = 2,
    ERemeshType_MAX = 3,
}

---@enum ESplitNormalMethod
local ESplitNormalMethod = {
    UseExistingTopology = 0,
    FaceNormalThreshold = 1,
    FaceGroupID = 2,
    PerTriangle = 3,
    PerVertex = 4,
    ESplitNormalMethod_MAX = 5,
}

---@enum ETexelDensityToolMode
local ETexelDensityToolMode = {
    ApplyToIslands = 0,
    ApplyToWhole = 1,
    Normalize = 2,
    ETexelDensityToolMode_MAX = 3,
}

---@enum ETrimOperation
local ETrimOperation = {
    TrimA = 0,
    TrimB = 1,
    ETrimOperation_MAX = 2,
}

---@enum ETrimSide
local ETrimSide = {
    RemoveInside = 0,
    RemoveOutside = 1,
    ETrimSide_MAX = 2,
}

---@enum EUVLayoutType
local EUVLayoutType = {
    Transform = 0,
    Stack = 1,
    Repack = 2,
    Normalize = 3,
    EUVLayoutType_MAX = 4,
}

---@enum EUVProjectionMethod
local EUVProjectionMethod = {
    Box = 0,
    Cylinder = 1,
    Plane = 2,
    ExpMap = 3,
    EUVProjectionMethod_MAX = 4,
}

