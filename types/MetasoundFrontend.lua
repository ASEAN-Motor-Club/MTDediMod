---@meta

---@class FMetaSoundFrontendDocumentBuilder
---@field DocumentInterface TScriptInterface<IMetaSoundDocumentInterface>
---@field BuildPageID FGuid
local FMetaSoundFrontendDocumentBuilder = {}



---@class FMetaSoundFrontendGraphComment
local FMetaSoundFrontendGraphComment = {}


---@class FMetasoundFrontendClass
---@field ID FGuid
---@field MetaData FMetasoundFrontendClassMetadata
---@field Interface FMetasoundFrontendClassInterface
local FMetasoundFrontendClass = {}



---@class FMetasoundFrontendClassEnvironmentVariable
---@field Name FName
---@field TypeName FName
---@field bIsRequired boolean
local FMetasoundFrontendClassEnvironmentVariable = {}



---@class FMetasoundFrontendClassInput : FMetasoundFrontendClassVertex
---@field Defaults TArray<FMetasoundFrontendClassInputDefault>
local FMetasoundFrontendClassInput = {}



---@class FMetasoundFrontendClassInputDefault
---@field Literal FMetasoundFrontendLiteral
---@field PageID FGuid
local FMetasoundFrontendClassInputDefault = {}



---@class FMetasoundFrontendClassInterface
---@field Inputs TArray<FMetasoundFrontendClassInput>
---@field Outputs TArray<FMetasoundFrontendClassOutput>
---@field Environment TArray<FMetasoundFrontendClassEnvironmentVariable>
---@field ChangeID FGuid
local FMetasoundFrontendClassInterface = {}



---@class FMetasoundFrontendClassMetadata
---@field ClassName FMetasoundFrontendClassName
---@field Version FMetasoundFrontendVersionNumber
---@field Type EMetasoundFrontendClassType
---@field bIsDeprecated boolean
---@field bAutoUpdateManagesInterface boolean
---@field ChangeID FGuid
local FMetasoundFrontendClassMetadata = {}



---@class FMetasoundFrontendClassName
---@field NameSpace FName
---@field Name FName
---@field Variant FName
local FMetasoundFrontendClassName = {}



---@class FMetasoundFrontendClassOutput : FMetasoundFrontendClassVertex
local FMetasoundFrontendClassOutput = {}


---@class FMetasoundFrontendClassStyle
local FMetasoundFrontendClassStyle = {}


---@class FMetasoundFrontendClassStyleDisplay
local FMetasoundFrontendClassStyleDisplay = {}


---@class FMetasoundFrontendClassVariable : FMetasoundFrontendClassVertex
---@field DefaultLiteral FMetasoundFrontendLiteral
local FMetasoundFrontendClassVariable = {}



---@class FMetasoundFrontendClassVertex : FMetasoundFrontendVertex
---@field NodeID FGuid
---@field AccessType EMetasoundFrontendVertexAccessType
local FMetasoundFrontendClassVertex = {}



---@class FMetasoundFrontendDocument
---@field MetaData FMetasoundFrontendDocumentMetadata
---@field Interfaces TSet<FMetasoundFrontendVersion>
---@field RootGraph FMetasoundFrontendGraphClass
---@field Subgraphs TArray<FMetasoundFrontendGraphClass>
---@field Dependencies TArray<FMetasoundFrontendClass>
---@field IdCounter uint32
local FMetasoundFrontendDocument = {}



---@class FMetasoundFrontendDocumentMetadata
---@field Version FMetasoundFrontendVersion
local FMetasoundFrontendDocumentMetadata = {}



---@class FMetasoundFrontendEdge
---@field FromNodeID FGuid
---@field FromVertexID FGuid
---@field ToNodeID FGuid
---@field ToVertexID FGuid
local FMetasoundFrontendEdge = {}



---@class FMetasoundFrontendEdgeStyle
---@field NodeID FGuid
---@field OutputName FName
---@field LiteralColorPairs TArray<FMetasoundFrontendEdgeStyleLiteralColorPair>
local FMetasoundFrontendEdgeStyle = {}



---@class FMetasoundFrontendEdgeStyleLiteralColorPair
---@field Value FMetasoundFrontendLiteral
---@field Color FLinearColor
local FMetasoundFrontendEdgeStyleLiteralColorPair = {}



---@class FMetasoundFrontendGraph
---@field Nodes TArray<FMetasoundFrontendNode>
---@field Edges TArray<FMetasoundFrontendEdge>
---@field Variables TArray<FMetasoundFrontendVariable>
---@field PageID FGuid
local FMetasoundFrontendGraph = {}



---@class FMetasoundFrontendGraphClass : FMetasoundFrontendClass
---@field PagedGraphs TArray<FMetasoundFrontendGraph>
---@field PresetOptions FMetasoundFrontendGraphClassPresetOptions
local FMetasoundFrontendGraphClass = {}



---@class FMetasoundFrontendGraphClassPresetOptions
---@field bIsPreset boolean
---@field InputsInheritingDefault TSet<FName>
local FMetasoundFrontendGraphClassPresetOptions = {}



---@class FMetasoundFrontendGraphStyle
local FMetasoundFrontendGraphStyle = {}


---@class FMetasoundFrontendInterface : FMetasoundFrontendClassInterface
---@field Version FMetasoundFrontendVersion
---@field UClassOptions TArray<FMetasoundFrontendInterfaceUClassOptions>
local FMetasoundFrontendInterface = {}



---@class FMetasoundFrontendInterfaceBinding
---@field OutputInterfaceVersion FMetasoundFrontendVersion
---@field InputInterfaceVersion FMetasoundFrontendVersion
---@field BindingPriority int32
---@field VertexBindings TArray<FMetasoundFrontendInterfaceVertexBinding>
local FMetasoundFrontendInterfaceBinding = {}



---@class FMetasoundFrontendInterfaceStyle
local FMetasoundFrontendInterfaceStyle = {}


---@class FMetasoundFrontendInterfaceUClassOptions
---@field ClassPath FTopLevelAssetPath
---@field bIsModifiable boolean
---@field bIsDefault boolean
local FMetasoundFrontendInterfaceUClassOptions = {}



---@class FMetasoundFrontendInterfaceVertexBinding
---@field OutputName FName
---@field InputName FName
local FMetasoundFrontendInterfaceVertexBinding = {}



---@class FMetasoundFrontendLiteral
---@field Type EMetasoundFrontendLiteralType
---@field AsNumDefault int32
---@field AsBoolean TArray<boolean>
---@field AsInteger TArray<int32>
---@field AsFloat TArray<float>
---@field AsString TArray<FString>
---@field AsUObject TArray<UObject>
local FMetasoundFrontendLiteral = {}



---@class FMetasoundFrontendNode
---@field ID FGuid
---@field ClassID FGuid
---@field Name FName
---@field Interface FMetasoundFrontendNodeInterface
---@field InputLiterals TArray<FMetasoundFrontendVertexLiteral>
local FMetasoundFrontendNode = {}



---@class FMetasoundFrontendNodeInterface
---@field Inputs TArray<FMetasoundFrontendVertex>
---@field Outputs TArray<FMetasoundFrontendVertex>
---@field Environment TArray<FMetasoundFrontendVertex>
local FMetasoundFrontendNodeInterface = {}



---@class FMetasoundFrontendNodeStyle
local FMetasoundFrontendNodeStyle = {}


---@class FMetasoundFrontendNodeStyleDisplay
local FMetasoundFrontendNodeStyleDisplay = {}


---@class FMetasoundFrontendVariable
---@field Name FName
---@field TypeName FName
---@field Literal FMetasoundFrontendLiteral
---@field ID FGuid
---@field VariableNodeID FGuid
---@field MutatorNodeID FGuid
---@field AccessorNodeIDs TArray<FGuid>
---@field DeferredAccessorNodeIDs TArray<FGuid>
local FMetasoundFrontendVariable = {}



---@class FMetasoundFrontendVersion
---@field Name FName
---@field Number FMetasoundFrontendVersionNumber
local FMetasoundFrontendVersion = {}



---@class FMetasoundFrontendVersionNumber
---@field Major int32
---@field Minor int32
local FMetasoundFrontendVersionNumber = {}



---@class FMetasoundFrontendVertex
---@field Name FName
---@field TypeName FName
---@field VertexID FGuid
local FMetasoundFrontendVertex = {}



---@class FMetasoundFrontendVertexHandle
---@field NodeID FGuid
---@field VertexID FGuid
local FMetasoundFrontendVertexHandle = {}



---@class FMetasoundFrontendVertexLiteral
---@field VertexID FGuid
---@field Value FMetasoundFrontendLiteral
local FMetasoundFrontendVertexLiteral = {}



---@class FMetasoundFrontendVertexMetadata
local FMetasoundFrontendVertexMetadata = {}


---@class FNodeTemplateGenerateInterfaceParams
---@field InputsToConnect TArray<FName>
---@field OutputsToConnect TArray<FName>
local FNodeTemplateGenerateInterfaceParams = {}



---@class IMetaSoundDocumentInterface : IInterface
local IMetaSoundDocumentInterface = {}


---@class UMetaSoundBuilderDocument : UObject
---@field Document FMetasoundFrontendDocument
---@field MetaSoundUClass UClass
---@field BuilderUClass UClass
local UMetaSoundBuilderDocument = {}



---@class UMetaSoundFrontendMemberMetadata : UObject
local UMetaSoundFrontendMemberMetadata = {}


---@class UMetasoundParameterPack : UObject
local UMetasoundParameterPack = {}

---@param ParameterName FName
---@param OnlyIfExists boolean
---@return ESetParamResult
function UMetasoundParameterPack:SetTrigger(ParameterName, OnlyIfExists) end
---@param ParameterName FName
---@param InValue FString
---@param OnlyIfExists boolean
---@return ESetParamResult
function UMetasoundParameterPack:SetString(ParameterName, InValue, OnlyIfExists) end
---@param ParameterName FName
---@param InValue int32
---@param OnlyIfExists boolean
---@return ESetParamResult
function UMetasoundParameterPack:SetInt(ParameterName, InValue, OnlyIfExists) end
---@param ParameterName FName
---@param InValue float
---@param OnlyIfExists boolean
---@return ESetParamResult
function UMetasoundParameterPack:SetFloat(ParameterName, InValue, OnlyIfExists) end
---@param ParameterName FName
---@param InValue boolean
---@param OnlyIfExists boolean
---@return ESetParamResult
function UMetasoundParameterPack:SetBool(ParameterName, InValue, OnlyIfExists) end
---@return UMetasoundParameterPack
function UMetasoundParameterPack:MakeMetasoundParameterPack() end
---@param ParameterName FName
---@return boolean
function UMetasoundParameterPack:HasTrigger(ParameterName) end
---@param ParameterName FName
---@return boolean
function UMetasoundParameterPack:HasString(ParameterName) end
---@param ParameterName FName
---@return boolean
function UMetasoundParameterPack:HasInt(ParameterName) end
---@param ParameterName FName
---@return boolean
function UMetasoundParameterPack:HasFloat(ParameterName) end
---@param ParameterName FName
---@return boolean
function UMetasoundParameterPack:HasBool(ParameterName) end
---@param ParameterName FName
---@param Result ESetParamResult
---@return boolean
function UMetasoundParameterPack:GetTrigger(ParameterName, Result) end
---@param ParameterName FName
---@param Result ESetParamResult
---@return FString
function UMetasoundParameterPack:GetString(ParameterName, Result) end
---@param ParameterName FName
---@param Result ESetParamResult
---@return int32
function UMetasoundParameterPack:GetInt(ParameterName, Result) end
---@param ParameterName FName
---@param Result ESetParamResult
---@return float
function UMetasoundParameterPack:GetFloat(ParameterName, Result) end
---@param ParameterName FName
---@param Result ESetParamResult
---@return boolean
function UMetasoundParameterPack:GetBool(ParameterName, Result) end


