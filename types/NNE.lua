---@meta

---@class FNNEAttributeValue
---@field Type ENNEAttributeDataType
---@field Value TArray<uint8>
local FNNEAttributeValue = {}



---@class FNNEFormatAttributeDesc
---@field Name FString
---@field Value FNNEAttributeValue
local FNNEFormatAttributeDesc = {}



---@class FNNEFormatOperatorDesc
---@field TypeName FString
---@field DomainName FString
---@field Version TOptional<uint32>
---@field InTensors TArray<uint32>
---@field OutTensors TArray<uint32>
---@field Attributes TArray<FNNEFormatAttributeDesc>
local FNNEFormatOperatorDesc = {}



---@class FNNEFormatTensorDesc
---@field Name FString
---@field Shape TArray<int32>
---@field Type ENNEFormatTensorType
---@field DataType ENNETensorDataType
---@field DataSize uint64
---@field DataOffset uint64
local FNNEFormatTensorDesc = {}



---@class FNNERuntimeFormat
---@field Tensors TArray<FNNEFormatTensorDesc>
---@field Operators TArray<FNNEFormatOperatorDesc>
local FNNERuntimeFormat = {}



---@class INNERuntime : IInterface
local INNERuntime = {}


---@class INNERuntimeCPU : IInterface
local INNERuntimeCPU = {}


---@class INNERuntimeGPU : IInterface
local INNERuntimeGPU = {}


---@class INNERuntimeNPU : IInterface
local INNERuntimeNPU = {}


---@class INNERuntimeRDG : IInterface
local INNERuntimeRDG = {}


---@class UNNEModelData : UObject
local UNNEModelData = {}


