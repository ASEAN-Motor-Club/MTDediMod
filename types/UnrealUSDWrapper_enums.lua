---@enum EGeometryCacheImport
local EGeometryCacheImport = {
    Never = 0,
    OnLoad = 1,
    OnSave = 2,
    EGeometryCacheImport_MAX = 3,
}

---@enum EUsdDefaultKind
local EUsdDefaultKind = {
    None = 0,
    Model = 1,
    Component = 2,
    Group = 4,
    Assembly = 8,
    Subcomponent = 16,
    EUsdDefaultKind_MAX = 17,
}

---@enum EUsdInitialLoadSet
local EUsdInitialLoadSet = {
    LoadAll = 0,
    LoadNone = 1,
    EUsdInitialLoadSet_MAX = 2,
}

---@enum EUsdInterpolationType
local EUsdInterpolationType = {
    Held = 0,
    Linear = 1,
    EUsdInterpolationType_MAX = 2,
}

---@enum EUsdListPosition
local EUsdListPosition = {
    FrontOfPrependList = 0,
    BackOfPrependList = 1,
    FrontOfAppendList = 2,
    BackOfAppendList = 3,
    EUsdListPosition_MAX = 4,
}

---@enum EUsdLoadPolicy
local EUsdLoadPolicy = {
    UsdLoadWithDescendants = 0,
    UsdLoadWithoutDescendants = 1,
    EUsdLoadPolicy_MAX = 2,
}

---@enum EUsdPurpose
local EUsdPurpose = {
    Default = 0,
    Proxy = 1,
    Render = 2,
    Guide = 4,
    EUsdPurpose_MAX = 5,
}

---@enum EUsdRootMotionHandling
local EUsdRootMotionHandling = {
    NoAdditionalRootMotion = 0,
    UseMotionFromSkelRoot = 1,
    UseMotionFromSkeleton = 2,
    EUsdRootMotionHandling_MAX = 3,
}

