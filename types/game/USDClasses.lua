---@meta

---@class FUsdCombinedPrimMetadata
---@field PrimPathToMetadata TMap<FString, FUsdPrimMetadata>
local FUsdCombinedPrimMetadata = {}



---@class FUsdMetadataImportOptions
---@field bCollectMetadata boolean
---@field bCollectFromEntireSubtrees boolean
---@field bCollectOnComponents boolean
---@field BlockedPrefixFilters TArray<FString>
---@field bInvertFilters boolean
local FUsdMetadataImportOptions = {}



---@class FUsdMetadataValue
---@field TypeName FString
---@field StringifiedValue FString
local FUsdMetadataValue = {}



---@class FUsdPrimMetadata
---@field MetaData TMap<FString, FUsdMetadataValue>
local FUsdPrimMetadata = {}



---@class FUsdPrimPathList
---@field PrimPaths TArray<FString>
local FUsdPrimPathList = {}



---@class FUsdStageOptions
---@field MetersPerUnit float
---@field UpAxis EUsdUpAxis
local FUsdStageOptions = {}



---@class FUsdUnrealAssetInfo
---@field Name FString
---@field Identifier FString
---@field Version FString
---@field UnrealContentPath FString
---@field UnrealAssetType FString
---@field UnrealExportTime FString
---@field UnrealEngineVersion FString
local FUsdUnrealAssetInfo = {}



---@class UUsdAnimSequenceAssetImportData : UUsdAssetImportData
---@field LayerStartOffsetSeconds float
local UUsdAnimSequenceAssetImportData = {}



---@class UUsdAnimSequenceAssetUserData : UUsdAssetUserData
---@field LayerStartOffsetSeconds float
local UUsdAnimSequenceAssetUserData = {}



---@class UUsdAssetCache : UObject
---@field TransientStorage TMap<FString, UObject>
---@field PersistentStorage TMap<FString, UObject>
---@field bAllowPersistentStorage boolean
---@field OwnedAssets TSet<TWeakObjectPtr<UObject>>
---@field PrimPathToAssets TMap<FString, TWeakObjectPtr<UObject>>
local UUsdAssetCache = {}



---@class UUsdAssetCache2 : UObject
---@field UnreferencedAssetStorageSizeMB double
---@field PersistentAssetStorageSizeMB double
---@field AssetStorage TMap<FString, UObject>
local UUsdAssetCache2 = {}

---@param Asset UObject
---@param Referencer UObject
---@return boolean
function UUsdAssetCache2:TouchAsset(Asset, Referencer) end
function UUsdAssetCache2:Reset() end
---@param Asset UObject
---@param Referencer UObject
---@return boolean
function UUsdAssetCache2:RemoveAssetReference(Asset, Referencer) end
---@param Hash FString
---@return UObject
function UUsdAssetCache2:RemoveAsset(Hash) end
---@param Referencer UObject
---@return boolean
function UUsdAssetCache2:RemoveAllAssetReferences(Referencer) end
function UUsdAssetCache2:RefreshStorage() end
---@param AssetPath FString
---@return boolean
function UUsdAssetCache2:IsAssetOwnedByCache(AssetPath) end
---@return int32
function UUsdAssetCache2:GetNumAssets() end
---@param Asset UObject
---@return FString
function UUsdAssetCache2:GetHashForAsset(Asset) end
---@param Hash FString
---@return UObject
function UUsdAssetCache2:GetCachedAsset(Hash) end
---@return TArray<UObject>
function UUsdAssetCache2:GetAllLoadedAssets() end
---@return TArray<FString>
function UUsdAssetCache2:GetAllCachedAssetPaths() end
---@return TArray<FString>
function UUsdAssetCache2:GetAllAssetHashes() end
---@param Hash FString
---@return boolean
function UUsdAssetCache2:CanRemoveAsset(Hash) end
---@param Hash FString
---@param Asset UObject
---@param Referencer UObject
function UUsdAssetCache2:CacheAsset(Hash, Asset, Referencer) end
---@param Asset UObject
---@param Referencer UObject
---@return boolean
function UUsdAssetCache2:AddAssetReference(Asset, Referencer) end


---@class UUsdAssetCache3 : UObject
---@field AssetDirectory FDirectoryPath
---@field bOnlyHandleAssetsWithinAssetDirectory boolean
---@field HashToAssetPaths TMap<FString, FSoftObjectPath>
---@field bCleanUpUnreferencedAssets boolean
---@field AssetPathToHashes TMap<FSoftObjectPath, FString>
---@field TransientObjectStorage TMap<FString, UObject>
local UUsdAssetCache3 = {}

---@param Hash FString
---@return FSoftObjectPath
function UUsdAssetCache3:StopTrackingAsset(Hash) end
---@param Asset UObject
---@param bIsDeletable boolean
function UUsdAssetCache3:SetAssetDeletable(Asset, bIsDeletable) end
function UUsdAssetCache3:RescanAssetDirectory() end
---@param Asset UObject
---@param Referencer UObject
---@return boolean
function UUsdAssetCache3:RemoveAssetReferencer(Asset, Referencer) end
---@param Asset UObject
---@return boolean
function UUsdAssetCache3:RemoveAllReferencersForAsset(Asset) end
---@param Referencer UObject
---@return boolean
function UUsdAssetCache3:RemoveAllReferencerAssets(Referencer) end
---@return boolean
function UUsdAssetCache3:RemoveAllAssetReferencers() end
---@return TMap<FString, UObject>
function UUsdAssetCache3:LoadAndGetAllTrackedAssets() end
---@param AssetPath FSoftObjectPath
---@return boolean
function UUsdAssetCache3:IsAssetTrackedByCache(AssetPath) end
---@param Asset UObject
---@return boolean
function UUsdAssetCache3:IsAssetDeletable(Asset) end
---@param Hash FString
---@param Class UClass
---@param DesiredName FString
---@param DesiredFlags int32
---@param bOutCreatedAsset boolean
---@param Referencer UObject
---@return UObject
function UUsdAssetCache3:GetOrCreateCachedAsset(Hash, Class, DesiredName, DesiredFlags, bOutCreatedAsset, Referencer) end
---@return int32
function UUsdAssetCache3:GetNumAssets() end
---@param AssetPath FSoftObjectPath
---@return FString
function UUsdAssetCache3:GetHashForAsset(AssetPath) end
---@param Hash FString
---@return FSoftObjectPath
function UUsdAssetCache3:GetCachedAssetPath(Hash) end
---@param Hash FString
---@return UObject
function UUsdAssetCache3:GetCachedAsset(Hash) end
---@return TMap<FString, FSoftObjectPath>
function UUsdAssetCache3:GetAllTrackedAssets() end
function UUsdAssetCache3:DeleteUnreferencedAssetsWithConfirmation() end
---@param bShowConfirmation boolean
function UUsdAssetCache3:DeleteUnreferencedAssets(bShowConfirmation) end
---@param Hash FString
---@param AssetPath FSoftObjectPath
---@param Referencer UObject
function UUsdAssetCache3:CacheAsset(Hash, AssetPath, Referencer) end
---@param Asset UObject
---@param Referencer UObject
---@return boolean
function UUsdAssetCache3:AddAssetReferencer(Asset, Referencer) end


---@class UUsdAssetImportData : UAssetImportData
---@field PrimPath FString
---@field ImportOptions UObject
local UUsdAssetImportData = {}



---@class UUsdAssetUserData : UAssetUserData
---@field PrimPaths TArray<FString>
---@field StageIdentifierToMetadata TMap<FString, FUsdCombinedPrimMetadata>
---@field OriginalHash FString
local UUsdAssetUserData = {}



---@class UUsdDrawModeComponent : UPrimitiveComponent
---@field BoundsMin FVector
---@field BoundsMax FVector
---@field DrawMode EUsdDrawMode
---@field BoundsColor FLinearColor
---@field CardGeometry EUsdModelCardGeometry
---@field CardTextureXPos UTexture2D
---@field CardTextureYPos UTexture2D
---@field CardTextureZPos UTexture2D
---@field CardTextureXNeg UTexture2D
---@field CardTextureYNeg UTexture2D
---@field CardTextureZNeg UTexture2D
---@field MaterialInstances TArray<UMaterialInstance>
---@field AuthoredFaces int32
local UUsdDrawModeComponent = {}

---@param Face EUsdModelCardFace
---@param Texture UTexture2D
function UUsdDrawModeComponent:SetTextureForFace(Face, Texture) end
---@param NewDrawMode EUsdDrawMode
function UUsdDrawModeComponent:SetDrawMode(NewDrawMode) end
---@param NewTexture UTexture2D
function UUsdDrawModeComponent:SetCardTextureZPos(NewTexture) end
---@param NewTexture UTexture2D
function UUsdDrawModeComponent:SetCardTextureZNeg(NewTexture) end
---@param NewTexture UTexture2D
function UUsdDrawModeComponent:SetCardTextureYPos(NewTexture) end
---@param NewTexture UTexture2D
function UUsdDrawModeComponent:SetCardTextureYNeg(NewTexture) end
---@param NewTexture UTexture2D
function UUsdDrawModeComponent:SetCardTextureXPos(NewTexture) end
---@param NewTexture UTexture2D
function UUsdDrawModeComponent:SetCardTextureXNeg(NewTexture) end
---@param NewGeometry EUsdModelCardGeometry
function UUsdDrawModeComponent:SetCardGeometry(NewGeometry) end
---@param NewMin FVector
function UUsdDrawModeComponent:SetBoundsMin(NewMin) end
---@param NewMax FVector
function UUsdDrawModeComponent:SetBoundsMax(NewMax) end
---@param NewColor FLinearColor
function UUsdDrawModeComponent:SetBoundsColor(NewColor) end
---@param Face EUsdModelCardFace
---@return UTexture2D
function UUsdDrawModeComponent:GetTextureForFace(Face) end


---@class UUsdGeometryCacheAssetUserData : UUsdMeshAssetUserData
---@field LayerStartOffsetSeconds float
local UUsdGeometryCacheAssetUserData = {}



---@class UUsdLevelSequenceAssetUserData : UAssetUserData
---@field LastCheckedSignature FGuid
---@field HandledBindingGuids TSet<FGuid>
local UUsdLevelSequenceAssetUserData = {}



---@class UUsdMaterialAssetUserData : UUsdAssetUserData
---@field ParameterToPrimvar TMap<FString, FString>
---@field PrimvarToUVIndex TMap<FString, int32>
local UUsdMaterialAssetUserData = {}



---@class UUsdMeshAssetImportData : UUsdAssetImportData
---@field MaterialSlotToPrimPaths TMap<int32, FUsdPrimPathList>
local UUsdMeshAssetImportData = {}



---@class UUsdMeshAssetUserData : UUsdAssetUserData
---@field MaterialSlotToPrimPaths TMap<int32, FUsdPrimPathList>
---@field PrimvarToUVIndex TMap<FString, int32>
local UUsdMeshAssetUserData = {}



---@class UUsdProjectSettings : UDeveloperSettings
---@field AdditionalPluginDirectories TArray<FDirectoryPath>
---@field DefaultResolverSearchPath TArray<FDirectoryPath>
---@field AdditionalMaterialPurposes TArray<FName>
---@field bLogUsdSdkErrors boolean
---@field DefaultAssetCache FSoftObjectPath
---@field bShowCreateDefaultAssetCacheDialog boolean
---@field bShowConfirmationWhenClearingLayers boolean
---@field bShowConfirmationWhenMutingDirtyLayers boolean
---@field bShowConfirmationWhenReloadingDirtyLayers boolean
---@field bShowOverriddenOpinionsWarning boolean
---@field EditInInstanceableBehavior EUsdEditInInstanceBehavior
---@field bShowWarningOnIncompleteDuplication boolean
---@field bShowTransformOnCameraComponentWarning boolean
---@field bShowTransformTrackOnCameraComponentWarning boolean
---@field bShowInheritedVisibilityWarning boolean
---@field ShowSaveLayersDialogWhenSaving EUsdSaveDialogBehavior
---@field ShowSaveLayersDialogWhenClosing EUsdSaveDialogBehavior
---@field DefaultSoundAttenuation FSoftObjectPath
---@field ReferenceDefaultSVTMaterial FSoftObjectPath
---@field ReferenceModelCardTextureMaterial FSoftObjectPath
---@field ReferencePreviewSurfaceMaterial FSoftObjectPath
---@field ReferencePreviewSurfaceTranslucentMaterial FSoftObjectPath
---@field ReferencePreviewSurfaceTwoSidedMaterial FSoftObjectPath
---@field ReferencePreviewSurfaceTranslucentTwoSidedMaterial FSoftObjectPath
---@field ReferencePreviewSurfaceVTMaterial FSoftObjectPath
---@field ReferencePreviewSurfaceTranslucentVTMaterial FSoftObjectPath
---@field ReferencePreviewSurfaceTwoSidedVTMaterial FSoftObjectPath
---@field ReferencePreviewSurfaceTranslucentTwoSidedVTMaterial FSoftObjectPath
---@field ReferenceDisplayColorMaterial FSoftObjectPath
---@field ReferenceDisplayColorAndOpacityMaterial FSoftObjectPath
---@field ReferenceDisplayColorTwoSidedMaterial FSoftObjectPath
---@field ReferenceDisplayColorAndOpacityTwoSidedMaterial FSoftObjectPath
local UUsdProjectSettings = {}



---@class UUsdReferenceOptions : UObject
---@field bInternalReference boolean
---@field TargetFile FFilePath
---@field bUseDefaultPrim boolean
---@field TargetPrimPath FString
---@field TimeCodeOffset float
---@field TimeCodeScale float
local UUsdReferenceOptions = {}



---@class UUsdSparseVolumeTextureAssetUserData : UUsdAssetUserData
---@field SourceOpenVDBAssetPrimPaths TArray<FString>
---@field TimeSamplePathTimeCodes TArray<double>
---@field TimeSamplePathIndices TArray<int32>
---@field TimeSamplePaths TArray<FString>
local UUsdSparseVolumeTextureAssetUserData = {}



