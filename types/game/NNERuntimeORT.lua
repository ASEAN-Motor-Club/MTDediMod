---@meta

---@class FThreadingOptions
---@field bUseGlobalThreadPool boolean
---@field IntraOpNumThreads int32
---@field InterOpNumThreads int32
---@field ExecutionMode EExecutionMode
local FThreadingOptions = {}



---@class UNNERuntimeORTCpu : UObject
local UNNERuntimeORTCpu = {}


---@class UNNERuntimeORTDml : UObject
local UNNERuntimeORTDml = {}


---@class UNNERuntimeORTSettings : UDeveloperSettings
---@field EditorThreadingOptions FThreadingOptions
---@field GameThreadingOptions FThreadingOptions
local UNNERuntimeORTSettings = {}



