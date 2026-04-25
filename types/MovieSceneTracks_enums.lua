---@enum EComponentMaterialType
local EComponentMaterialType = {
    Empty = 0,
    IndexedMaterial = 1,
    OverlayMaterial = 2,
    DecalMaterial = 3,
    VolumetricCloudMaterial = 4,
    EComponentMaterialType_MAX = 5,
}

---@enum EFireEventsAtPosition
local EFireEventsAtPosition = {
    AtStartOfEvaluation = 0,
    AtEndOfEvaluation = 1,
    AfterSpawn = 2,
    EFireEventsAtPosition_MAX = 3,
}

---@enum ELevelVisibility
local ELevelVisibility = {
    Visible = 0,
    Hidden = 1,
    ELevelVisibility_MAX = 2,
}

---@enum EMovieSceneScalabilityConditionGroup
local EMovieSceneScalabilityConditionGroup = {
    ViewDistance = 0,
    AntiAliasing = 1,
    Shadow = 2,
    GlobalIllumination = 3,
    Reflection = 4,
    PostProcess = 5,
    Texture = 6,
    Effects = 7,
    Foliage = 8,
    Shading = 9,
    Landscape = 10,
    EMovieSceneScalabilityConditionGroup_MAX = 11,
}

---@enum EMovieSceneScalabilityConditionLevel
local EMovieSceneScalabilityConditionLevel = {
    Low = 0,
    Medium = 1,
    High = 2,
    Epic = 3,
    Cinematic = 4,
    EMovieSceneScalabilityConditionLevel_MAX = 5,
}

---@enum EMovieSceneScalabilityConditionOperator
local EMovieSceneScalabilityConditionOperator = {
    LessThan = 0,
    LessThanOrEqualTo = 1,
    EqualTo = 2,
    GreaterThanOrEqualTo = 3,
    GreaterThan = 4,
    EMovieSceneScalabilityConditionOperator_MAX = 5,
}

---@enum EParticleKey
local EParticleKey = {
    Activate = 0,
    Deactivate = 1,
    Trigger = 2,
    EParticleKey_MAX = 3,
}

---@enum MovieScene3DPathSection_Axis
local MovieScene3DPathSection_Axis = {
    X = 0,
    Y = 1,
    Z = 2,
    NEG_X = 3,
    NEG_Y = 4,
    NEG_Z = 5,
    MovieScene3DPathSection_MAX = 6,
}

