---@meta

---@class AMediaPlate : AActor
---@field MediaPlateComponent UMediaPlateComponent
---@field StaticMeshComponent UStaticMeshComponent
local AMediaPlate = {}



---@class FMediaPlateResource
---@field Type EMediaPlateResourceType
---@field ExternalMediaPath FString
---@field ExternalMedia UMediaSource
---@field MediaAsset TSoftObjectPtr<UMediaSource>
---@field SourcePlaylist TSoftObjectPtr<UMediaPlaylist>
---@field ActivePlaylist UMediaPlaylist
local FMediaPlateResource = {}



---@class FMediaTextureResourceSettings
---@field bEnableGenMips boolean
---@field CurrentNumMips uint8
local FMediaTextureResourceSettings = {}



---@class UMediaPlateAssetUserData : UAssetUserData
local UMediaPlateAssetUserData = {}


---@class UMediaPlateComponent : UActorComponent
---@field bPlayOnOpen boolean
---@field bAutoPlay boolean
---@field bEnableAudio boolean
---@field StartTime float
---@field SoundComponent UMediaSoundComponent
---@field StaticMeshComponent UStaticMeshComponent
---@field Letterboxes TArray<UStaticMeshComponent>
---@field MediaPlateResource FMediaPlateResource
---@field PlaylistIndex int32
---@field CacheSettings FMediaSourceCacheSettings
---@field bIsMediaPlatePlaying boolean
---@field bPlayOnlyWhenVisible boolean
---@field bLoop boolean
---@field VisibleMipsTilesCalculations EMediaTextureVisibleMipsTiles
---@field MipMapBias float
---@field bIsAspectRatioAuto boolean
---@field bEnableMipMapUpscaling boolean
---@field MipLevelToUpscale int32
---@field bAdaptivePoleMipUpscaling boolean
---@field LetterboxAspectRatio float
---@field MeshRange FVector2D
---@field MediaTextures TArray<UMediaTexture>
---@field MediaTextureSettings FMediaTextureResourceSettings
---@field MediaPlayer UMediaPlayer
local UMediaPlateComponent = {}

---@param bInPlayOnlyWhenVisible boolean
function UMediaPlateComponent:SetPlayOnlyWhenVisible(bInPlayOnlyWhenVisible) end
---@param InMeshRange FVector2D
function UMediaPlateComponent:SetMeshRange(InMeshRange) end
---@param bInLoop boolean
function UMediaPlateComponent:SetLoop(bInLoop) end
---@param AspectRatio float
function UMediaPlateComponent:SetLetterboxAspectRatio(AspectRatio) end
---@param bInIsAspectRatioAuto boolean
function UMediaPlateComponent:SetIsAspectRatioAuto(bInIsAspectRatioAuto) end
---@param Time FTimespan
---@return boolean
function UMediaPlateComponent:Seek(Time) end
---@return boolean
function UMediaPlateComponent:Rewind() end
function UMediaPlateComponent:Play() end
function UMediaPlateComponent:Pause() end
function UMediaPlateComponent:Open() end
function UMediaPlateComponent:OnMediaSuspended() end
function UMediaPlateComponent:OnMediaResumed() end
---@param DeviceUrl FString
function UMediaPlateComponent:OnMediaOpened(DeviceUrl) end
function UMediaPlateComponent:OnMediaEnd() end
---@return boolean
function UMediaPlateComponent:IsMediaPlatePlaying() end
---@return FVector2D
function UMediaPlateComponent:GetMeshRange() end
---@param Index int32
---@return UMediaTexture
function UMediaPlateComponent:GetMediaTexture(Index) end
---@return UMediaPlayer
function UMediaPlateComponent:GetMediaPlayer() end
---@return boolean
function UMediaPlateComponent:GetLoop() end
---@return float
function UMediaPlateComponent:GetLetterboxAspectRatio() end
---@return boolean
function UMediaPlateComponent:GetIsAspectRatioAuto() end
function UMediaPlateComponent:Close() end


