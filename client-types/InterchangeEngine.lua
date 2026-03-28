---@meta

---@class FImportAssetParameters
---@field ReimportAsset UObject
---@field ReimportSourceIndex int32
---@field bIsAutomated boolean
---@field bFollowRedirectors boolean
---@field OverridePipelines TArray<FSoftObjectPath>
---@field ImportLevel ULevel
---@field DestinationName FString
---@field bReplaceExisting boolean
---@field bForceShowDialog boolean
---@field OnAssetDone FImportAssetParametersOnAssetDone
---@field OnAssetsImportDone FImportAssetParametersOnAssetsImportDone
---@field OnSceneObjectDone FImportAssetParametersOnSceneObjectDone
---@field OnSceneImportDone FImportAssetParametersOnSceneImportDone
local FImportAssetParameters = {}



---@class FInterchangeContentImportSettings : FInterchangeImportSettings
---@field DefaultPipelineStackOverride TMap<EInterchangeTranslatorAssetType, FName>
---@field ShowImportDialogOverride TMap<EInterchangeTranslatorAssetType, FInterchangeDialogOverride>
local FInterchangeContentImportSettings = {}



---@class FInterchangeDialogOverride
---@field bShowImportDialog boolean
---@field PerTranslatorImportDialogOverride TArray<FInterchangePerTranslatorDialogOverride>
local FInterchangeDialogOverride = {}



---@class FInterchangeFilePickerParameters
---@field bAllowMultipleFiles boolean
---@field Title FText
---@field DefaultPath FString
---@field bShowAllFactoriesExtension boolean
---@field ExtraFormats TArray<FString>
local FInterchangeFilePickerParameters = {}



---@class FInterchangeGroup
---@field DisplayName FName
---@field UniqueID FGuid
---@field DefaultPipelineStack FName
---@field DefaultPipelineStackOverride TMap<EInterchangeTranslatorAssetType, FName>
---@field bShowImportDialog boolean
---@field ShowImportDialogOverride TMap<EInterchangeTranslatorAssetType, FInterchangeDialogOverride>
local FInterchangeGroup = {}



---@class FInterchangeImportSettings
---@field PipelineStacks TMap<FName, FInterchangePipelineStack>
---@field DefaultPipelineStack FName
---@field ImportDialogClass TSoftClassPtr<UInterchangePipelineConfigurationBase>
---@field bShowImportDialog boolean
local FInterchangeImportSettings = {}



---@class FInterchangePerTranslatorDialogOverride
---@field Translator TSoftClassPtr<UInterchangeTranslatorBase>
---@field bShowImportDialog boolean
local FInterchangePerTranslatorDialogOverride = {}



---@class FInterchangePipelineStack
---@field Pipelines TArray<FSoftObjectPath>
---@field PerTranslatorPipelines TArray<FInterchangeTranslatorPipelines>
local FInterchangePipelineStack = {}



---@class FInterchangeStackInfo
---@field StackName FName
---@field Pipelines TArray<UInterchangePipelineBase>
local FInterchangeStackInfo = {}



---@class FInterchangeTranslatorPipelines
---@field Translator TSoftClassPtr<UInterchangeTranslatorBase>
---@field Pipelines TArray<FSoftObjectPath>
local FInterchangeTranslatorPipelines = {}



---@class FPropertyData
local FPropertyData = {}


---@class UInterchangeAssetImportData : UAssetImportData
---@field SceneImportAsset FSoftObjectPath
---@field NodeUniqueID FString
---@field NodeContainer UInterchangeBaseNodeContainer
---@field Pipelines TArray<UObject>
---@field TransientNodeContainer UInterchangeBaseNodeContainer
---@field TransientPipelines TArray<UObject>
---@field TransientTranslatorSettings UInterchangeTranslatorSettings
local UInterchangeAssetImportData = {}

---@param TranslatorSettings UInterchangeTranslatorSettings
function UInterchangeAssetImportData:SetTranslatorSettings(TranslatorSettings) end
---@param InPipelines TArray<UObject>
function UInterchangeAssetImportData:SetPipelines(InPipelines) end
---@param InNodeContainer UInterchangeBaseNodeContainer
function UInterchangeAssetImportData:SetNodeContainer(InNodeContainer) end
---@return FString
function UInterchangeAssetImportData:ScriptGetFirstFilename() end
---@return TArray<FString>
function UInterchangeAssetImportData:ScriptExtractFilenames() end
---@return TArray<FString>
function UInterchangeAssetImportData:ScriptExtractDisplayLabels() end
---@return UInterchangeTranslatorSettings
function UInterchangeAssetImportData:GetTranslatorSettings() end
---@param InNodeUniqueId FString
---@return UInterchangeBaseNode
function UInterchangeAssetImportData:GetStoredNode(InNodeUniqueId) end
---@param InNodeUniqueId FString
---@return UInterchangeFactoryBaseNode
function UInterchangeAssetImportData:GetStoredFactoryNode(InNodeUniqueId) end
---@return TArray<UObject>
function UInterchangeAssetImportData:GetPipelines() end
---@return int32
function UInterchangeAssetImportData:GetNumberOfPipelines() end
---@return UInterchangeBaseNodeContainer
function UInterchangeAssetImportData:GetNodeContainer() end


---@class UInterchangeAssetImportDataConverterBase : UObject
local UInterchangeAssetImportDataConverterBase = {}


---@class UInterchangeBlueprintPipelineBase : UBlueprint
local UInterchangeBlueprintPipelineBase = {}


---@class UInterchangeEditorSettings : UDeveloperSettings
---@field bShowImportDialogAtReimport boolean
---@field UsedGroupName FName
---@field UsedGroupUID FGuid
local UInterchangeEditorSettings = {}

---@param InUsedGroupName FName
function UInterchangeEditorSettings:SetUsedGroupName(InUsedGroupName) end
---@return FName
function UInterchangeEditorSettings:GetUsedGroupName() end
---@return TArray<FName>
function UInterchangeEditorSettings:GetSelectableItems() end


---@class UInterchangeEditorUtilitiesBase : UObject
local UInterchangeEditorUtilitiesBase = {}


---@class UInterchangeFilePickerBase : UObject
local UInterchangeFilePickerBase = {}

---@param TranslatorType EInterchangeTranslatorType
---@param Parameters FInterchangeFilePickerParameters
---@param OutFilenames TArray<FString>
---@return boolean
function UInterchangeFilePickerBase:ScriptedFilePickerForTranslatorType(TranslatorType, Parameters, OutFilenames) end
---@param TranslatorAssetType EInterchangeTranslatorAssetType
---@param Parameters FInterchangeFilePickerParameters
---@param OutFilenames TArray<FString>
---@return boolean
function UInterchangeFilePickerBase:ScriptedFilePickerForTranslatorAssetType(TranslatorAssetType, Parameters, OutFilenames) end


---@class UInterchangeManager : UObject
---@field RegisteredTranslatorsClass TSet<UClass>
---@field RegisteredFactoryClasses TMap<UClass, UClass>
---@field RegisteredWriters TMap<UClass, UInterchangeWriterBase>
---@field RegisteredConverters TMap<UClass, UInterchangeAssetImportDataConverterBase>
local UInterchangeManager = {}

---@param ContentPath FString
---@param SourceData UInterchangeSourceData
---@param ImportAssetParameters FImportAssetParameters
---@return boolean
function UInterchangeManager:ScriptedImportSceneAsync(ContentPath, SourceData, ImportAssetParameters) end
---@param ContentPath FString
---@param SourceData UInterchangeSourceData
---@param ImportAssetParameters FImportAssetParameters
---@return boolean
function UInterchangeManager:ScriptedImportAssetAsync(ContentPath, SourceData, ImportAssetParameters) end
---@param ContentPath FString
---@param SourceData UInterchangeSourceData
---@param ImportAssetParameters FImportAssetParameters
---@return boolean
function UInterchangeManager:ImportScene(ContentPath, SourceData, ImportAssetParameters) end
---@param ContentPath FString
---@param SourceData UInterchangeSourceData
---@param ImportAssetParameters FImportAssetParameters
---@param OutImportedObjects TArray<UObject>
---@return boolean
function UInterchangeManager:ImportAsset(ContentPath, SourceData, ImportAssetParameters, OutImportedObjects) end
---@param ClassToMake UClass
---@return UClass
function UInterchangeManager:GetRegisteredFactoryClass(ClassToMake) end
---@return UInterchangeManager
function UInterchangeManager:GetInterchangeManagerScripted() end
---@param World UObject
---@param bIsAutomated boolean
---@return boolean
function UInterchangeManager:ExportScene(World, bIsAutomated) end
---@param Asset UObject
---@param bIsAutomated boolean
---@return boolean
function UInterchangeManager:ExportAsset(Asset, bIsAutomated) end
---@param InFilename FString
---@return UInterchangeSourceData
function UInterchangeManager:CreateSourceData(InFilename) end


---@class UInterchangeMeshUtilities : UObject
local UInterchangeMeshUtilities = {}

---@param SkeletalMesh USkeletalMesh
---@param LODIndex int32
---@param SourceData UInterchangeSourceData
---@param MorphTargetName FString
---@return boolean
function UInterchangeMeshUtilities:ScriptedImportMorphTarget(SkeletalMesh, LODIndex, SourceData, MorphTargetName) end


---@class UInterchangePipelineConfigurationBase : UObject
local UInterchangePipelineConfigurationBase = {}

---@param PipelineStacks TArray<FInterchangeStackInfo>
---@param OutPipelines TArray<UInterchangePipelineBase>
---@param SourceData UInterchangeSourceData
---@param Translator UInterchangeTranslatorBase
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@return EInterchangePipelineConfigurationDialogResult
function UInterchangePipelineConfigurationBase:ScriptedShowScenePipelineConfigurationDialog(PipelineStacks, OutPipelines, SourceData, Translator, BaseNodeContainer) end
---@param PipelineStacks TArray<FInterchangeStackInfo>
---@param OutPipelines TArray<UInterchangePipelineBase>
---@param SourceData UInterchangeSourceData
---@param Translator UInterchangeTranslatorBase
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param ReimportAsset UObject
---@return EInterchangePipelineConfigurationDialogResult
function UInterchangePipelineConfigurationBase:ScriptedShowReimportPipelineConfigurationDialog(PipelineStacks, OutPipelines, SourceData, Translator, BaseNodeContainer, ReimportAsset) end
---@param PipelineStacks TArray<FInterchangeStackInfo>
---@param OutPipelines TArray<UInterchangePipelineBase>
---@param SourceData UInterchangeSourceData
---@param Translator UInterchangeTranslatorBase
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@return EInterchangePipelineConfigurationDialogResult
function UInterchangePipelineConfigurationBase:ScriptedShowPipelineConfigurationDialog(PipelineStacks, OutPipelines, SourceData, Translator, BaseNodeContainer) end


---@class UInterchangePipelineStackOverride : UObject
---@field OverridePipelines TArray<FSoftObjectPath>
local UInterchangePipelineStackOverride = {}

---@param PipelineBase UInterchangePythonPipelineBase
function UInterchangePipelineStackOverride:AddPythonPipeline(PipelineBase) end
---@param PipelineBase UInterchangePipelineBase
function UInterchangePipelineStackOverride:AddPipeline(PipelineBase) end
---@param PipelineBase UInterchangeBlueprintPipelineBase
function UInterchangePipelineStackOverride:AddBlueprintPipeline(PipelineBase) end


---@class UInterchangeProjectSettings : UDeveloperSettings
---@field ContentImportSettings FInterchangeContentImportSettings
---@field SceneImportSettings FInterchangeImportSettings
---@field FilePickerClass TSoftClassPtr<UInterchangeFilePickerBase>
---@field bStaticMeshUseSmoothEdgesIfSmoothingInformationIsMissing boolean
---@field GenericPipelineClass TSoftClassPtr<UInterchangePipelineBase>
---@field ConverterDefaultPipeline FSoftObjectPath
---@field InterchangeGroups TArray<FInterchangeGroup>
local UInterchangeProjectSettings = {}



---@class UInterchangePythonPipelineAsset : UObject
---@field PythonClass TSoftClassPtr<UInterchangePythonPipelineBase>
---@field GeneratedPipeline UInterchangePythonPipelineBase
---@field JsonDefaultProperties FString
local UInterchangePythonPipelineAsset = {}



---@class UInterchangePythonPipelineBase : UInterchangePipelineBase
local UInterchangePythonPipelineBase = {}


---@class UInterchangeSceneImportAsset : UObject
local UInterchangeSceneImportAsset = {}


