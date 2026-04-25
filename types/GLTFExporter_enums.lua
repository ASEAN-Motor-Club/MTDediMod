---@enum EGLTFMaterialBakeMode
local EGLTFMaterialBakeMode = {
    Disabled = 0,
    Simple = 1,
    UseMeshData = 2,
    EGLTFMaterialBakeMode_MAX = 3,
}

---@enum EGLTFMaterialPropertyGroup
local EGLTFMaterialPropertyGroup = {
    None = 0,
    BaseColorOpacity = 1,
    MetallicRoughness = 2,
    EmissiveColor = 3,
    Normal = 4,
    AmbientOcclusion = 5,
    ClearCoatRoughness = 6,
    ClearCoatBottomNormal = 7,
    EGLTFMaterialPropertyGroup_MAX = 8,
}

---@enum EGLTFMaterialVariantMode
local EGLTFMaterialVariantMode = {
    None = 0,
    Simple = 1,
    UseMeshData = 2,
    EGLTFMaterialVariantMode_MAX = 3,
}

---@enum EGLTFTextureImageFormat
local EGLTFTextureImageFormat = {
    None = 0,
    PNG = 1,
    JPEG = 2,
    EGLTFTextureImageFormat_MAX = 3,
}

