---@meta

---@class FArrayShaderValue
---@field ArrayOfValues TArray<uint8>
local FArrayShaderValue = {}



---@class FComputeGraphEdge
---@field KernelIndex int32
---@field KernelBindingIndex int32
---@field DataInterfaceIndex int32
---@field DataInterfaceBindingIndex int32
---@field bKernelInput boolean
---@field BindingFunctionNameOverride FString
---@field BindingFunctionNamespace FString
local FComputeGraphEdge = {}



---@class FComputeGraphInstance
---@field DataProviders TArray<UComputeDataProvider>
local FComputeGraphInstance = {}



---@class FComputeKernelDefinition
---@field Symbol FString
---@field Define FString
local FComputeKernelDefinition = {}



---@class FComputeKernelDefinitionSet
---@field Defines TArray<FComputeKernelDefinition>
local FComputeKernelDefinitionSet = {}



---@class FComputeKernelPermutationBool
---@field Name FString
---@field Value boolean
local FComputeKernelPermutationBool = {}



---@class FComputeKernelPermutationSet
---@field BooleanOptions TArray<FComputeKernelPermutationBool>
local FComputeKernelPermutationSet = {}



---@class FComputeKernelPermutationVector
---@field Permutations TMap<FString, uint32>
---@field BitCount uint32
local FComputeKernelPermutationVector = {}



---@class FShaderFunctionDefinition
---@field Name FString
---@field ParamTypes TArray<FShaderParamTypeDefinition>
---@field bHasReturnType boolean
local FShaderFunctionDefinition = {}



---@class FShaderParamTypeDefinition
---@field TypeDeclaration FString
---@field Name FString
---@field ValueType FShaderValueTypeHandle
---@field ArrayElementCount uint16
---@field BindingType EShaderParamBindingType
---@field ResourceType EShaderResourceType
---@field Modifier EShaderParamModifier
local FShaderParamTypeDefinition = {}



---@class FShaderValueContainer
---@field ShaderValue TArray<uint8>
---@field ArrayList TArray<FArrayShaderValue>
local FShaderValueContainer = {}



---@class FShaderValueType
---@field Type EShaderFundamentalType
---@field DimensionType EShaderFundamentalDimensionType
---@field Name FName
---@field bIsDynamicArray boolean
local FShaderValueType = {}



---@class FShaderValueTypeHandle
local FShaderValueTypeHandle = {}


---@class UComputeDataInterface : UObject
local UComputeDataInterface = {}


---@class UComputeDataProvider : UObject
local UComputeDataProvider = {}


---@class UComputeGraph : UObject
---@field KernelInvocations TArray<UComputeKernel>
---@field DataInterfaces TArray<UComputeDataInterface>
---@field GraphEdges TArray<FComputeGraphEdge>
---@field Bindings TArray<UClass>
---@field DataInterfaceToBinding TArray<int32>
local UComputeGraph = {}



---@class UComputeGraphComponent : UActorComponent
---@field ComputeGraph UComputeGraph
---@field ComputeGraphInstance FComputeGraphInstance
local UComputeGraphComponent = {}

function UComputeGraphComponent:QueueExecute() end
function UComputeGraphComponent:DestroyDataProviders() end
---@param InBindingIndex int32
---@param InBindingObject UObject
function UComputeGraphComponent:CreateDataProviders(InBindingIndex, InBindingObject) end


---@class UComputeKernel : UObject
---@field KernelSource UComputeKernelSource
---@field KernelFlags int32
local UComputeKernel = {}



---@class UComputeKernelFromText : UComputeKernelSource
---@field SourceFile FFilePath
local UComputeKernelFromText = {}



---@class UComputeKernelSource : UObject
---@field EntryPoint FString
---@field GroupSize FIntVector
---@field PermutationSet FComputeKernelPermutationSet
---@field DefinitionsSet FComputeKernelDefinitionSet
---@field AdditionalSources TArray<UComputeSource>
---@field ExternalInputs TArray<FShaderFunctionDefinition>
---@field ExternalOutputs TArray<FShaderFunctionDefinition>
local UComputeKernelSource = {}



---@class UComputeSource : UObject
---@field AdditionalSources TArray<UComputeSource>
local UComputeSource = {}



---@class UComputeSourceFromText : UComputeSource
---@field SourceFile FFilePath
local UComputeSourceFromText = {}



