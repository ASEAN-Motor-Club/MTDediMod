---@meta

---@class FInterchangePipelineContextParams
local FInterchangePipelineContextParams = {}


---@class FInterchangePipelinePropertyStatePerContext
---@field bVisible boolean
local FInterchangePipelinePropertyStatePerContext = {}



---@class FInterchangePipelinePropertyStates
---@field bLocked boolean
---@field bPreDialogReset boolean
---@field BasicLayoutStates FInterchangePipelinePropertyStatePerContext
---@field ImportStates FInterchangePipelinePropertyStatePerContext
---@field ReimportStates FInterchangePipelinePropertyStatePerContext
local FInterchangePipelinePropertyStates = {}



---@class FInterchangeUserDefinedAttributeInfo
---@field Name FString
local FInterchangeUserDefinedAttributeInfo = {}



---@class UInterchangeBaseNode : UObject
local UInterchangeBaseNode = {}

---@param ParentUid FString
---@return boolean
function UInterchangeBaseNode:SetParentUid(ParentUid) end
---@param bIsEnabled boolean
---@return boolean
function UInterchangeBaseNode:SetEnabled(bIsEnabled) end
---@param DisplayName FString
---@return boolean
function UInterchangeBaseNode:SetDisplayLabel(DisplayName) end
---@param AssetName FString
---@return boolean
function UInterchangeBaseNode:SetAssetName(AssetName) end
---@param AssetUid FString
---@return boolean
function UInterchangeBaseNode:RemoveTargetNodeUid(AssetUid) end
---@param NodeAttributeKey FString
---@return boolean
function UInterchangeBaseNode:RemoveAttribute(NodeAttributeKey) end
---@return boolean
function UInterchangeBaseNode:IsEnabled() end
---@param UniqueID FString
---@param DisplayLabel FString
---@param NodeContainerType EInterchangeNodeContainerType
function UInterchangeBaseNode:InitializeNode(UniqueID, DisplayLabel, NodeContainerType) end
---@param NodeAttributeKey FString
---@param OutValue FVector2f
---@return boolean
function UInterchangeBaseNode:GetVector2Attribute(NodeAttributeKey, OutValue) end
---@return FString
function UInterchangeBaseNode:GetUniqueID() end
---@param OutTargetAssets TArray<FString>
function UInterchangeBaseNode:GetTargetNodeUids(OutTargetAssets) end
---@return int32
function UInterchangeBaseNode:GetTargetNodeCount() end
---@param NodeAttributeKey FString
---@param OutValue FString
---@return boolean
function UInterchangeBaseNode:GetStringAttribute(NodeAttributeKey, OutValue) end
---@return FString
function UInterchangeBaseNode:GetParentUid() end
---@return EInterchangeNodeContainerType
function UInterchangeBaseNode:GetNodeContainerType() end
---@param NodeAttributeKey FString
---@param OutValue FLinearColor
---@return boolean
function UInterchangeBaseNode:GetLinearColorAttribute(NodeAttributeKey, OutValue) end
---@param NodeAttributeKey FString
---@param OutValue int32
---@return boolean
function UInterchangeBaseNode:GetInt32Attribute(NodeAttributeKey, OutValue) end
---@param NodeAttributeKey FString
---@param OutValue FGuid
---@return boolean
function UInterchangeBaseNode:GetGuidAttribute(NodeAttributeKey, OutValue) end
---@param NodeAttributeKey FString
---@param OutValue float
---@return boolean
function UInterchangeBaseNode:GetFloatAttribute(NodeAttributeKey, OutValue) end
---@param NodeAttributeKey FString
---@param OutValue double
---@return boolean
function UInterchangeBaseNode:GetDoubleAttribute(NodeAttributeKey, OutValue) end
---@return FString
function UInterchangeBaseNode:GetDisplayLabel() end
---@param NodeAttributeKey FString
---@param OutValue boolean
---@return boolean
function UInterchangeBaseNode:GetBooleanAttribute(NodeAttributeKey, OutValue) end
---@return FString
function UInterchangeBaseNode:GetAssetName() end
---@param NodeAttributeKey FString
---@param Value FVector2f
---@return boolean
function UInterchangeBaseNode:AddVector2Attribute(NodeAttributeKey, Value) end
---@param AssetUid FString
---@return boolean
function UInterchangeBaseNode:AddTargetNodeUid(AssetUid) end
---@param NodeAttributeKey FString
---@param Value FString
---@return boolean
function UInterchangeBaseNode:AddStringAttribute(NodeAttributeKey, Value) end
---@param NodeAttributeKey FString
---@param Value FLinearColor
---@return boolean
function UInterchangeBaseNode:AddLinearColorAttribute(NodeAttributeKey, Value) end
---@param NodeAttributeKey FString
---@param Value int32
---@return boolean
function UInterchangeBaseNode:AddInt32Attribute(NodeAttributeKey, Value) end
---@param NodeAttributeKey FString
---@param Value FGuid
---@return boolean
function UInterchangeBaseNode:AddGuidAttribute(NodeAttributeKey, Value) end
---@param NodeAttributeKey FString
---@param Value float
---@return boolean
function UInterchangeBaseNode:AddFloatAttribute(NodeAttributeKey, Value) end
---@param NodeAttributeKey FString
---@param Value double
---@return boolean
function UInterchangeBaseNode:AddDoubleAttribute(NodeAttributeKey, Value) end
---@param NodeAttributeKey FString
---@param Value boolean
---@return boolean
function UInterchangeBaseNode:AddBooleanAttribute(NodeAttributeKey, Value) end


---@class UInterchangeBaseNodeContainer : UObject
---@field Nodes TMap<FString, UInterchangeBaseNode>
local UInterchangeBaseNodeContainer = {}

---@param NodeUniqueID FString
---@param NewParentNodeUid FString
---@return boolean
function UInterchangeBaseNodeContainer:SetNodeParentUid(NodeUniqueID, NewParentNodeUid) end
---@param Filename FString
function UInterchangeBaseNodeContainer:SaveToFile(Filename) end
function UInterchangeBaseNodeContainer:ResetChildrenCache() end
function UInterchangeBaseNodeContainer:Reset() end
---@param NodeUniqueID FString
---@param NewNode UInterchangeFactoryBaseNode
function UInterchangeBaseNodeContainer:ReplaceNode(NodeUniqueID, NewNode) end
---@param Filename FString
function UInterchangeBaseNodeContainer:LoadFromFile(Filename) end
---@param NodeUniqueID FString
---@return boolean
function UInterchangeBaseNodeContainer:IsNodeUidValid(NodeUniqueID) end
---@param RootNodes TArray<FString>
function UInterchangeBaseNodeContainer:GetRoots(RootNodes) end
---@param ClassNode UClass
---@param OutNodes TArray<FString>
function UInterchangeBaseNodeContainer:GetNodes(ClassNode, OutNodes) end
---@param NodeUniqueID FString
---@return TArray<FString>
function UInterchangeBaseNodeContainer:GetNodeChildrenUids(NodeUniqueID) end
---@param NodeUniqueID FString
---@return int32
function UInterchangeBaseNodeContainer:GetNodeChildrenCount(NodeUniqueID) end
---@param NodeUniqueID FString
---@param ChildIndex int32
---@return UInterchangeBaseNode
function UInterchangeBaseNodeContainer:GetNodeChildren(NodeUniqueID, ChildIndex) end
---@param NodeUniqueID FString
---@return UInterchangeBaseNode
function UInterchangeBaseNodeContainer:GetNode(NodeUniqueID) end
---@param NodeUniqueID FString
---@param AncestorUID FString
---@return boolean
function UInterchangeBaseNodeContainer:GetIsAncestor(NodeUniqueID, AncestorUID) end
---@param NodeUniqueID FString
---@return UInterchangeFactoryBaseNode
function UInterchangeBaseNodeContainer:GetFactoryNode(NodeUniqueID) end
function UInterchangeBaseNodeContainer:ComputeChildrenCache() end
---@param Node UInterchangeBaseNode
---@return FString
function UInterchangeBaseNodeContainer:AddNode(Node) end


---@class UInterchangeFactoryBase : UObject
---@field Results UInterchangeResultsContainer
local UInterchangeFactoryBase = {}

---@return UClass
function UInterchangeFactoryBase:GetFactoryClass() end


---@class UInterchangeFactoryBaseNode : UInterchangeBaseNode
local UInterchangeFactoryBaseNode = {}

---@return boolean
function UInterchangeFactoryBaseNode:UnsetSkipNodeImport() end
---@return boolean
function UInterchangeFactoryBaseNode:UnsetForceNodeReimport() end
---@return boolean
function UInterchangeFactoryBaseNode:ShouldSkipNodeImport() end
---@return boolean
function UInterchangeFactoryBaseNode:ShouldForceNodeReimport() end
---@return boolean
function UInterchangeFactoryBaseNode:SetSkipNodeImport() end
---@param ReimportStrategyFlags EReimportStrategyFlags
---@return boolean
function UInterchangeFactoryBaseNode:SetReimportStrategyFlags(ReimportStrategyFlags) end
---@return boolean
function UInterchangeFactoryBaseNode:SetForceNodeReimport() end
---@param AttributeValue FString
---@return boolean
function UInterchangeFactoryBaseNode:SetCustomSubPath(AttributeValue) end
---@param AttributeValue FSoftObjectPath
---@return boolean
function UInterchangeFactoryBaseNode:SetCustomReferenceObject(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeFactoryBaseNode:SetCustomLevelUid(AttributeValue) end
---@param DependencyUid FString
---@return boolean
function UInterchangeFactoryBaseNode:RemoveFactoryDependencyUid(DependencyUid) end
---@return boolean
function UInterchangeFactoryBaseNode:IsRuntimeImportAllowed() end
---@return EReimportStrategyFlags
function UInterchangeFactoryBaseNode:GetReimportStrategyFlags() end
---@param Index int32
---@param OutDependency FString
function UInterchangeFactoryBaseNode:GetFactoryDependency(Index, OutDependency) end
---@return int32
function UInterchangeFactoryBaseNode:GetFactoryDependenciesCount() end
---@param OutDependencies TArray<FString>
function UInterchangeFactoryBaseNode:GetFactoryDependencies(OutDependencies) end
---@param AttributeValue FString
---@return boolean
function UInterchangeFactoryBaseNode:GetCustomSubPath(AttributeValue) end
---@param AttributeValue FSoftObjectPath
---@return boolean
function UInterchangeFactoryBaseNode:GetCustomReferenceObject(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeFactoryBaseNode:GetCustomLevelUid(AttributeValue) end
---@param DependencyUid FString
---@return boolean
function UInterchangeFactoryBaseNode:AddFactoryDependencyUid(DependencyUid) end


---@class UInterchangePipelineBase : UObject
---@field DestinationName FString
---@field ContentImportPath FString
---@field ReimportLevel FSoftObjectPath
---@field bFromReimportOrOverride boolean
---@field Results UInterchangeResultsContainer
---@field PropertiesStates TMap<FName, FInterchangePipelinePropertyStates>
local UInterchangePipelineBase = {}

---@param ReimportObjectClass UClass
---@param SourceFileIndex int32
function UInterchangePipelineBase:ScriptedSetReimportSourceIndex(ReimportObjectClass, SourceFileIndex) end
---@return FString
function UInterchangePipelineBase:ScriptedGetPipelineDisplayName() end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param FactoryNodeKey FString
---@param CreatedAsset UObject
---@param bIsAReimport boolean
function UInterchangePipelineBase:ScriptedExecutePostImportPipeline(BaseNodeContainer, FactoryNodeKey, CreatedAsset, bIsAReimport) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param FactoryNodeKey FString
---@param CreatedAsset UObject
---@param bIsAReimport boolean
function UInterchangePipelineBase:ScriptedExecutePostFactoryPipeline(BaseNodeContainer, FactoryNodeKey, CreatedAsset, bIsAReimport) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param FactoryNodeKey FString
---@param CreatedAsset UObject
---@param bIsAReimport boolean
function UInterchangePipelineBase:ScriptedExecutePostBroadcastPipeline(BaseNodeContainer, FactoryNodeKey, CreatedAsset, bIsAReimport) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param SourceDatas TArray<UInterchangeSourceData>
---@param ContentBasePath FString
function UInterchangePipelineBase:ScriptedExecutePipeline(BaseNodeContainer, SourceDatas, ContentBasePath) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
function UInterchangePipelineBase:ScriptedExecuteExportPipeline(BaseNodeContainer) end
---@param PropertyPath FName
---@return FInterchangePipelinePropertyStates
function UInterchangePipelineBase:FindOrAddPropertyStates(PropertyPath) end
---@param PropertyPath FName
---@return boolean
function UInterchangePipelineBase:DoesPropertyStatesExist(PropertyPath) end


---@class UInterchangeResult : UObject
---@field SourceAssetName FString
---@field DestinationAssetName FString
---@field AssetFriendlyName FString
---@field AssetType UClass
---@field InterchangeKey FString
local UInterchangeResult = {}



---@class UInterchangeResultDisplay_Generic : UInterchangeResultSuccess
---@field Text FText
local UInterchangeResultDisplay_Generic = {}



---@class UInterchangeResultError : UInterchangeResult
local UInterchangeResultError = {}


---@class UInterchangeResultError_Generic : UInterchangeResultError
---@field Text FText
local UInterchangeResultError_Generic = {}



---@class UInterchangeResultError_ReimportFail : UInterchangeResultError
local UInterchangeResultError_ReimportFail = {}


---@class UInterchangeResultSuccess : UInterchangeResult
local UInterchangeResultSuccess = {}


---@class UInterchangeResultWarning : UInterchangeResult
local UInterchangeResultWarning = {}


---@class UInterchangeResultWarning_Generic : UInterchangeResultWarning
---@field Text FText
local UInterchangeResultWarning_Generic = {}



---@class UInterchangeResultsContainer : UObject
---@field Results TArray<UInterchangeResult>
local UInterchangeResultsContainer = {}



---@class UInterchangeSourceData : UObject
---@field Filename FString
local UInterchangeSourceData = {}

---@param InFilename FString
---@return boolean
function UInterchangeSourceData:SetFilename(InFilename) end
---@return FString
function UInterchangeSourceData:GetFilename() end


---@class UInterchangeSourceNode : UInterchangeBaseNode
local UInterchangeSourceNode = {}

---@param Name FString
---@param Value FString
---@return boolean
function UInterchangeSourceNode:SetExtraInformation(Name, Value) end
---@param AttributeValue double
---@return boolean
function UInterchangeSourceNode:SetCustomSourceTimelineStart(AttributeValue) end
---@param AttributeValue double
---@return boolean
function UInterchangeSourceNode:SetCustomSourceTimelineEnd(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeSourceNode:SetCustomSourceFrameRateNumerator(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeSourceNode:SetCustomSourceFrameRateDenominator(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSourceNode:SetCustomImportUnusedMaterial(AttributeValue) end
---@param AxisConversionInverseTransform FTransform
---@return boolean
function UInterchangeSourceNode:SetCustomAxisConversionInverseTransform(AxisConversionInverseTransform) end
---@param AttributeValue double
---@return boolean
function UInterchangeSourceNode:SetCustomAnimatedTimeStart(AttributeValue) end
---@param AttributeValue double
---@return boolean
function UInterchangeSourceNode:SetCustomAnimatedTimeEnd(AttributeValue) end
---@param Name FString
---@return boolean
function UInterchangeSourceNode:RemoveExtraInformation(Name) end
---@param UniqueID FString
---@param DisplayLabel FString
function UInterchangeSourceNode:InitializeSourceNode(UniqueID, DisplayLabel) end
---@param OutExtraInformation TMap<FString, FString>
function UInterchangeSourceNode:GetExtraInformation(OutExtraInformation) end
---@param AttributeValue double
---@return boolean
function UInterchangeSourceNode:GetCustomSourceTimelineStart(AttributeValue) end
---@param AttributeValue double
---@return boolean
function UInterchangeSourceNode:GetCustomSourceTimelineEnd(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeSourceNode:GetCustomSourceFrameRateNumerator(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeSourceNode:GetCustomSourceFrameRateDenominator(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSourceNode:GetCustomImportUnusedMaterial(AttributeValue) end
---@param AxisConversionInverseTransform FTransform
---@return boolean
function UInterchangeSourceNode:GetCustomAxisConversionInverseTransform(AxisConversionInverseTransform) end
---@param AttributeValue double
---@return boolean
function UInterchangeSourceNode:GetCustomAnimatedTimeStart(AttributeValue) end
---@param AttributeValue double
---@return boolean
function UInterchangeSourceNode:GetCustomAnimatedTimeEnd(AttributeValue) end


---@class UInterchangeTranslatorBase : UObject
---@field Results UInterchangeResultsContainer
---@field SourceData UInterchangeSourceData
local UInterchangeTranslatorBase = {}



---@class UInterchangeTranslatorSettings : UObject
local UInterchangeTranslatorSettings = {}

function UInterchangeTranslatorSettings:SaveSettings() end
function UInterchangeTranslatorSettings:LoadSettings() end


---@class UInterchangeUserDefinedAttributesAPI : UObject
local UInterchangeUserDefinedAttributesAPI = {}

---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@return boolean
function UInterchangeUserDefinedAttributesAPI:RemoveUserDefinedAttribute(InterchangeNode, UserDefinedAttributeName) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeInfos TArray<FInterchangeUserDefinedAttributeInfo>
function UInterchangeUserDefinedAttributesAPI:GetUserDefinedAttributeInfos(InterchangeNode, UserDefinedAttributeInfos) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@param OutValue int32
---@param OutPayloadKey FString
---@return boolean
function UInterchangeUserDefinedAttributesAPI:GetUserDefinedAttribute_Int32(InterchangeNode, UserDefinedAttributeName, OutValue, OutPayloadKey) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@param OutValue FString
---@param OutPayloadKey FString
---@return boolean
function UInterchangeUserDefinedAttributesAPI:GetUserDefinedAttribute_FString(InterchangeNode, UserDefinedAttributeName, OutValue, OutPayloadKey) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@param OutValue float
---@param OutPayloadKey FString
---@return boolean
function UInterchangeUserDefinedAttributesAPI:GetUserDefinedAttribute_Float(InterchangeNode, UserDefinedAttributeName, OutValue, OutPayloadKey) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@param OutValue double
---@param OutPayloadKey FString
---@return boolean
function UInterchangeUserDefinedAttributesAPI:GetUserDefinedAttribute_Double(InterchangeNode, UserDefinedAttributeName, OutValue, OutPayloadKey) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@param OutValue boolean
---@param OutPayloadKey FString
---@return boolean
function UInterchangeUserDefinedAttributesAPI:GetUserDefinedAttribute_Boolean(InterchangeNode, UserDefinedAttributeName, OutValue, OutPayloadKey) end
---@param InterchangeSourceNode UInterchangeBaseNode
---@param InterchangeDestinationNode UInterchangeBaseNode
---@param bAddSourceNodeName boolean
function UInterchangeUserDefinedAttributesAPI:DuplicateAllUserDefinedAttribute(InterchangeSourceNode, InterchangeDestinationNode, bAddSourceNodeName) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@param Value int32
---@param PayloadKey FString
---@param RequiresDelegate boolean
---@return boolean
function UInterchangeUserDefinedAttributesAPI:CreateUserDefinedAttribute_Int32(InterchangeNode, UserDefinedAttributeName, Value, PayloadKey, RequiresDelegate) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@param Value FString
---@param PayloadKey FString
---@param RequiresDelegate boolean
---@return boolean
function UInterchangeUserDefinedAttributesAPI:CreateUserDefinedAttribute_FString(InterchangeNode, UserDefinedAttributeName, Value, PayloadKey, RequiresDelegate) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@param Value float
---@param PayloadKey FString
---@param RequiresDelegate boolean
---@return boolean
function UInterchangeUserDefinedAttributesAPI:CreateUserDefinedAttribute_Float(InterchangeNode, UserDefinedAttributeName, Value, PayloadKey, RequiresDelegate) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@param Value double
---@param PayloadKey FString
---@param RequiresDelegate boolean
---@return boolean
function UInterchangeUserDefinedAttributesAPI:CreateUserDefinedAttribute_Double(InterchangeNode, UserDefinedAttributeName, Value, PayloadKey, RequiresDelegate) end
---@param InterchangeNode UInterchangeBaseNode
---@param UserDefinedAttributeName FString
---@param Value boolean
---@param PayloadKey FString
---@param RequiresDelegate boolean
---@return boolean
function UInterchangeUserDefinedAttributesAPI:CreateUserDefinedAttribute_Boolean(InterchangeNode, UserDefinedAttributeName, Value, PayloadKey, RequiresDelegate) end


---@class UInterchangeWriterBase : UObject
local UInterchangeWriterBase = {}


