---@enum EUsdDrawMode
local EUsdDrawMode = {
    Origin = 0,
    Bounds = 1,
    Cards = 2,
    Default = 3,
    Inherited = 4,
    EUsdDrawMode_MAX = 5,
}

---@enum EUsdDuplicateType
local EUsdDuplicateType = {
    FlattenComposedPrim = 0,
    SingleLayerSpecs = 1,
    AllLocalLayerSpecs = 2,
    EUsdDuplicateType_MAX = 3,
}

---@enum EUsdEditInInstanceBehavior
local EUsdEditInInstanceBehavior = {
    Ignore = 0,
    RemoveInstanceable = 1,
    ShowPrompt = 2,
    EUsdEditInInstanceBehavior_MAX = 3,
}

---@enum EUsdModelCardFace
local EUsdModelCardFace = {
    None = 0,
    XPos = 1,
    YPos = 2,
    ZPos = 4,
    XNeg = 8,
    YNeg = 16,
    ZNeg = 32,
    EUsdModelCardFace_MAX = 33,
}

---@enum EUsdModelCardGeometry
local EUsdModelCardGeometry = {
    Cross = 0,
    Box = 1,
    FromTexture = 2,
    EUsdModelCardGeometry_MAX = 3,
}

---@enum EUsdSaveDialogBehavior
local EUsdSaveDialogBehavior = {
    NeverSave = 0,
    AlwaysSave = 1,
    ShowPrompt = 2,
    EUsdSaveDialogBehavior_MAX = 3,
}

---@enum EUsdUpAxis
local EUsdUpAxis = {
    YAxis = 0,
    ZAxis = 1,
    EUsdUpAxis_MAX = 2,
}

