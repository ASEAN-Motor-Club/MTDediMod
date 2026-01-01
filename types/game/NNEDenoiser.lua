---@meta

---@class FNNEDenoiserBaseMappingData : FTableRowBase
---@field TensorIndex int32
---@field TensorChannel int32
---@field ResourceChannel int32
local FNNEDenoiserBaseMappingData = {}



---@class FNNEDenoiserInputMappingData : FNNEDenoiserBaseMappingData
---@field Resource EInputResourceName
local FNNEDenoiserInputMappingData = {}



---@class FNNEDenoiserOutputMappingData : FNNEDenoiserBaseMappingData
---@field Resource EOutputResourceName
local FNNEDenoiserOutputMappingData = {}



---@class FNNEDenoiserTemporalInputMappingData : FNNEDenoiserBaseMappingData
---@field Resource ETemporalInputResourceName
---@field FrameIndex int32
local FNNEDenoiserTemporalInputMappingData = {}



---@class FNNEDenoiserTemporalOutputMappingData : FNNEDenoiserBaseMappingData
---@field Resource ETemporalOutputResourceName
local FNNEDenoiserTemporalOutputMappingData = {}



---@class FTilingConfig
---@field Alignment int32
---@field Overlap int32
---@field MaxSize int32
---@field MinSize int32
local FTilingConfig = {}



---@class UNNEDenoiserAsset : UDataAsset
---@field ModelData TSoftObjectPtr<UNNEModelData>
---@field InputMapping TSoftObjectPtr<UDataTable>
---@field OutputMapping TSoftObjectPtr<UDataTable>
---@field TilingConfig FTilingConfig
local UNNEDenoiserAsset = {}



---@class UNNEDenoiserSettings : UDeveloperSettingsBackedByCVars
---@field DenoiserAsset TSoftObjectPtr<UNNEDenoiserAsset>
---@field RuntimeType EDenoiserRuntimeType
---@field RuntimeName FString
local UNNEDenoiserSettings = {}



---@class UNNEDenoiserTemporalAsset : UDataAsset
---@field ModelData TSoftObjectPtr<UNNEModelData>
---@field InputMapping TSoftObjectPtr<UDataTable>
---@field OutputMapping TSoftObjectPtr<UDataTable>
---@field TilingConfig FTilingConfig
local UNNEDenoiserTemporalAsset = {}



