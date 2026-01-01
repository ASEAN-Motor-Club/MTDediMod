---@meta

---@class FDataRegistryCachePolicy
---@field bCacheIsAlwaysVolatile boolean
---@field bUseCurveTableCacheVersion boolean
---@field MinNumberKept int32
---@field MaxNumberKept int32
---@field ForceKeepSeconds float
---@field ForceReleaseSeconds float
local FDataRegistryCachePolicy = {}



---@class FDataRegistryId
---@field RegistryType FDataRegistryType
---@field ItemName FName
local FDataRegistryId = {}



---@class FDataRegistryIdFormat
---@field BaseGameplayTag FGameplayTag
local FDataRegistryIdFormat = {}



---@class FDataRegistryLookup
local FDataRegistryLookup = {}


---@class FDataRegistryOrTableRow
---@field bUseDataRegistryId boolean
---@field DataTableRow FDataTableRowHandle
---@field DataRegistryId FDataRegistryId
local FDataRegistryOrTableRow = {}



---@class FDataRegistrySourceItemId
local FDataRegistrySourceItemId = {}


---@class FDataRegistrySource_DataTableRules
---@field bPrecacheTable boolean
---@field CachedTableKeepSeconds float
local FDataRegistrySource_DataTableRules = {}



---@class FDataRegistryType
---@field Name FName
local FDataRegistryType = {}



---@class FSoftDataRegistryOrTable
---@field bUseDataRegistry boolean
---@field Table TSoftObjectPtr<UDataTable>
---@field RegistryType FDataRegistryType
local FSoftDataRegistryOrTable = {}



---@class UDataRegistry : UObject
---@field RegistryType FName
---@field IdFormat FDataRegistryIdFormat
---@field ItemStruct UScriptStruct
---@field DataSources TArray<UDataRegistrySource>
---@field RuntimeSources TArray<UDataRegistrySource>
---@field TimerUpdateFrequency float
---@field DefaultCachePolicy FDataRegistryCachePolicy
local UDataRegistry = {}



---@class UDataRegistrySettings : UDeveloperSettings
---@field DirectoriesToScan TArray<FDirectoryPath>
---@field bInitializeAllLoadedRegistries boolean
---@field bIgnoreMissingCookedAssetRegistryData boolean
local UDataRegistrySettings = {}



---@class UDataRegistrySource : UObject
---@field ParentSource UDataRegistrySource
local UDataRegistrySource = {}



---@class UDataRegistrySource_CurveTable : UDataRegistrySource
---@field SourceTable TSoftObjectPtr<UCurveTable>
---@field TableRules FDataRegistrySource_DataTableRules
---@field CachedTable UCurveTable
---@field PreloadTable UCurveTable
local UDataRegistrySource_CurveTable = {}



---@class UDataRegistrySource_DataTable : UDataRegistrySource
---@field SourceTable TSoftObjectPtr<UDataTable>
---@field TableRules FDataRegistrySource_DataTableRules
---@field CachedTable UDataTable
---@field PreloadTable UDataTable
local UDataRegistrySource_DataTable = {}



---@class UDataRegistrySubsystem : UEngineSubsystem
local UDataRegistrySubsystem = {}

---@param A FDataRegistryType
---@param B FDataRegistryType
---@return boolean
function UDataRegistrySubsystem:NotEqual_DataRegistryType(A, B) end
---@param A FDataRegistryId
---@param B FDataRegistryId
---@return boolean
function UDataRegistrySubsystem:NotEqual_DataRegistryId(A, B) end
---@param DataRegistryType FDataRegistryType
---@return boolean
function UDataRegistrySubsystem:IsValidDataRegistryType(DataRegistryType) end
---@param DataRegistryId FDataRegistryId
---@return boolean
function UDataRegistrySubsystem:IsValidDataRegistryId(DataRegistryId) end
---@param RegistryType FDataRegistryType
---@param OutIdList TArray<FDataRegistryId>
function UDataRegistrySubsystem:GetPossibleDataRegistryIdList(RegistryType, OutIdList) end
---@param ItemId FDataRegistryId
---@param ResolvedLookup FDataRegistryLookup
---@param OutItem FTableRowBase
---@return boolean
function UDataRegistrySubsystem:GetCachedItemFromLookupBP(ItemId, ResolvedLookup, OutItem) end
---@param ItemId FDataRegistryId
---@param OutItem FTableRowBase
---@return boolean
function UDataRegistrySubsystem:GetCachedItemBP(ItemId, OutItem) end
---@param ItemId FDataRegistryId
---@param ResolvedLookup FDataRegistryLookup
---@param OutResult EDataRegistrySubsystemGetItemResult
---@param OutItem FTableRowBase
function UDataRegistrySubsystem:FindCachedItemFromLookupBP(ItemId, ResolvedLookup, OutResult, OutItem) end
---@param ItemId FDataRegistryId
---@param OutResult EDataRegistrySubsystemGetItemResult
---@param OutItem FTableRowBase
function UDataRegistrySubsystem:FindCachedItemBP(ItemId, OutResult, OutItem) end
---@param ItemId FDataRegistryId
---@param InputValue float
---@param DefaultValue float
---@param OutResult EDataRegistrySubsystemGetItemResult
---@param OutValue float
function UDataRegistrySubsystem:EvaluateDataRegistryCurve(ItemId, InputValue, DefaultValue, OutResult, OutValue) end
---@param A FDataRegistryType
---@param B FDataRegistryType
---@return boolean
function UDataRegistrySubsystem:EqualEqual_DataRegistryType(A, B) end
---@param A FDataRegistryId
---@param B FDataRegistryId
---@return boolean
function UDataRegistrySubsystem:EqualEqual_DataRegistryId(A, B) end
---@param DataRegistryType FDataRegistryType
---@return FString
function UDataRegistrySubsystem:Conv_DataRegistryTypeToString(DataRegistryType) end
---@param DataRegistryId FDataRegistryId
---@return FString
function UDataRegistrySubsystem:Conv_DataRegistryIdToString(DataRegistryId) end
---@param ItemId FDataRegistryId
---@param AcquireCallback FAcquireItemBPAcquireCallback
---@return boolean
function UDataRegistrySubsystem:AcquireItemBP(ItemId, AcquireCallback) end


---@class UMetaDataRegistrySource : UDataRegistrySource
---@field AssetUsage EMetaDataRegistrySourceAssetUsage
---@field SearchRules FAssetManagerSearchRules
---@field RuntimeChildren TMap<FName, UDataRegistrySource>
local UMetaDataRegistrySource = {}



---@class UMetaDataRegistrySource_CurveTable : UMetaDataRegistrySource
---@field CreatedSource TSubclassOf<UDataRegistrySource_CurveTable>
---@field TableRules FDataRegistrySource_DataTableRules
local UMetaDataRegistrySource_CurveTable = {}



---@class UMetaDataRegistrySource_DataTable : UMetaDataRegistrySource
---@field CreatedSource TSubclassOf<UDataRegistrySource_DataTable>
---@field TableRules FDataRegistrySource_DataTableRules
local UMetaDataRegistrySource_DataTable = {}



