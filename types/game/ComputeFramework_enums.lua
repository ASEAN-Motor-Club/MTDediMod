---@enum EComputeKernelFlags
local EComputeKernelFlags = {
    IsDefaultKernel = 1,
    IsolatedMemoryWrites = 2,
    EComputeKernelFlags_MAX = 3,
}

---@enum EShaderFundamentalDimensionType
local EShaderFundamentalDimensionType = {
    Scalar = 0,
    Vector = 1,
    Matrix = 2,
    EShaderFundamentalDimensionType_MAX = 3,
}

---@enum EShaderFundamentalType
local EShaderFundamentalType = {
    Bool = 0,
    Int = 1,
    Uint = 2,
    Float = 3,
    Struct = 4,
    None = 255,
    EShaderFundamentalType_MAX = 256,
}

---@enum EShaderParamBindingType
local EShaderParamBindingType = {
    None = 0,
    ConstantParameter = 1,
    ReadOnlyResource = 2,
    ReadWriteResource = 3,
    EShaderParamBindingType_MAX = 4,
}

---@enum EShaderParamModifier
local EShaderParamModifier = {
    None = 0,
    In = 1,
    Out = 2,
    InOut = 3,
    EShaderParamModifier_MAX = 4,
}

---@enum EShaderResourceType
local EShaderResourceType = {
    None = 0,
    Texture1D = 1,
    Texture2D = 2,
    Texture3D = 3,
    TextureCube = 4,
    Buffer = 5,
    StructuredBuffer = 6,
    ByteAddressBuffer = 7,
    EShaderResourceType_MAX = 8,
}

