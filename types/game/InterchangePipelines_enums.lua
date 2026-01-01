---@enum EInterchangeAnimationRange
local EInterchangeAnimationRange = {
    Timeline = 0,
    Animated = 1,
    SetRange = 2,
    MAX = 3,
}

---@enum EInterchangeForceMeshType
local EInterchangeForceMeshType = {
    IFMT_None = 0,
    IFMT_StaticMesh = 1,
    IFMT_SkeletalMesh = 2,
    IFMT_MAX = 3,
}

---@enum EInterchangeMaterialImportOption
local EInterchangeMaterialImportOption = {
    ImportAsMaterials = 0,
    ImportAsMaterialInstances = 1,
    EInterchangeMaterialImportOption_MAX = 2,
}

---@enum EInterchangeMaterialSearchLocation
local EInterchangeMaterialSearchLocation = {
    Local = 0,
    UnderParent = 1,
    UnderRoot = 2,
    AllAssets = 3,
    DoNotSearch = 4,
    EInterchangeMaterialSearchLocation_MAX = 5,
}

---@enum EInterchangeSceneHierarchyType
local EInterchangeSceneHierarchyType = {
    CreateLevelActors = 0,
    CreateLevelInstanceActor = 1,
    EInterchangeSceneHierarchyType_MAX = 2,
}

---@enum EInterchangeVertexColorImportOption
local EInterchangeVertexColorImportOption = {
    IVCIO_Replace = 0,
    IVCIO_Ignore = 1,
    IVCIO_Override = 2,
    IVCIO_MAX = 3,
}

