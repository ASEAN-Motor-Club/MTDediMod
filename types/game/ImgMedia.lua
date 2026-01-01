---@meta

---@class FImgMediaSourceCustomizationSequenceProxy
local FImgMediaSourceCustomizationSequenceProxy = {}


---@class UImgMediaSource : UBaseMediaSource
---@field IsPathRelativeToProjectRoot boolean
---@field FrameRateOverride FFrameRate
---@field ProxyOverride FString
---@field bFillGapsInSequence boolean
---@field StartTimecode FTimecode
---@field SequencePath FDirectoryPath
local UImgMediaSource = {}

---@param Path FString
function UImgMediaSource:SetTokenizedSequencePath(Path) end
---@param Path FString
function UImgMediaSource:SetSequencePath(Path) end
---@param InActor AActor
function UImgMediaSource:RemoveTargetObject(InActor) end
---@return FString
function UImgMediaSource:GetSequencePath() end
---@param OutProxies TArray<FString>
function UImgMediaSource:GetProxies(OutProxies) end
---@param InActor AActor
function UImgMediaSource:AddTargetObject(InActor) end


