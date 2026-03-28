---@meta

---@class APrefabActor : AActor
---@field PrefabComponent UPrefabComponent
---@field LastUpdateID FGuid
---@field Seed int32
local APrefabActor = {}

function APrefabActor:SavePrefab() end
---@param InRandom FRandomStream
---@param bRecursive boolean
function APrefabActor:RandomizeSeed(InRandom, bRecursive) end
function APrefabActor:LoadPrefab() end
---@return boolean
function APrefabActor:IsPrefabOutdated() end
---@return UPrefabricatorAsset
function APrefabActor:GetPrefabAsset() end


---@class APrefabDebugActor : AActor
---@field Actor AActor
---@field ActorData TArray<uint8>
local APrefabDebugActor = {}



---@class APrefabRandomizer : AActor
---@field bRandomizeOnBeginPlay boolean
---@field SeedOffset int32
---@field MaxBuildTimePerFrame float
---@field OnRandomizationComplete FPrefabRandomizerOnRandomizationComplete
---@field bFastSyncBuild boolean
---@field ActorsToRandomize TArray<APrefabActor>
local APrefabRandomizer = {}

---@param InSeed int32
function APrefabRandomizer:Randomize(InSeed) end


---@class APrefabSeedLinker : AActor
---@field LinkedActors TArray<TWeakObjectPtr<APrefabActor>>
---@field SeedLinkerComponent UPrefabSeedLinkerComponent
local APrefabSeedLinker = {}



---@class AReplicablePrefabActor : APrefabActor
local AReplicablePrefabActor = {}


---@class FPrefabricatorActorData
---@field PrefabItemID FGuid
---@field RelativeTransform FTransform
---@field ClassPath FString
---@field ClassPathRef FSoftClassPath
---@field Properties TArray<UPrefabricatorProperty>
---@field Components TArray<FPrefabricatorComponentData>
local FPrefabricatorActorData = {}



---@class FPrefabricatorAssetCollectionItem
---@field PrefabAsset TSoftObjectPtr<UPrefabricatorAsset>
---@field Weight float
local FPrefabricatorAssetCollectionItem = {}



---@class FPrefabricatorComponentData
---@field RelativeTransform FTransform
---@field ComponentName FString
---@field Properties TArray<UPrefabricatorProperty>
local FPrefabricatorComponentData = {}



---@class FPrefabricatorPropertyAssetMapping
---@field AssetReference FSoftObjectPath
---@field AssetClassName FString
---@field AssetObjectPath FName
---@field bUseQuotes boolean
local FPrefabricatorPropertyAssetMapping = {}



---@class UPrefabComponent : USceneComponent
---@field PrefabAssetInterface TSoftObjectPtr<UPrefabricatorAssetInterface>
local UPrefabComponent = {}



---@class UPrefabSeedLinkerComponent : USceneComponent
local UPrefabSeedLinkerComponent = {}


---@class UPrefabricatorAsset : UPrefabricatorAssetInterface
---@field ActorData TArray<FPrefabricatorActorData>
---@field PrefabMobility EComponentMobility::Type
---@field LastUpdateID FGuid
---@field ThumbnailInfo UThumbnailInfo
---@field Version uint32
local UPrefabricatorAsset = {}



---@class UPrefabricatorAssetCollection : UPrefabricatorAssetInterface
---@field Prefabs TArray<FPrefabricatorAssetCollectionItem>
---@field Version uint32
local UPrefabricatorAssetCollection = {}



---@class UPrefabricatorAssetInterface : UObject
---@field EventListener TSubclassOf<UPrefabricatorEventListener>
---@field bReplicates boolean
local UPrefabricatorAssetInterface = {}



---@class UPrefabricatorAssetUserData : UAssetUserData
---@field PrefabActor TWeakObjectPtr<APrefabActor>
---@field ItemId FGuid
local UPrefabricatorAssetUserData = {}



---@class UPrefabricatorBlueprintLibrary : UBlueprintFunctionLibrary
local UPrefabricatorBlueprintLibrary = {}

---@param PrefabActor APrefabActor
function UPrefabricatorBlueprintLibrary:UnlinkPrefab(PrefabActor) end
---@param WorldContextObject UObject
---@param Prefab UPrefabricatorAssetInterface
---@param Transform FTransform
---@param Seed int32
---@return APrefabActor
function UPrefabricatorBlueprintLibrary:SpawnPrefab(WorldContextObject, Prefab, Transform, Seed) end
---@param PrefabActor APrefabActor
---@param Prefab UPrefabricatorAssetInterface
---@param bReloadPrefab boolean
function UPrefabricatorBlueprintLibrary:SetPrefabAsset(PrefabActor, Prefab, bReloadPrefab) end
---@param PrefabActor APrefabActor
---@param InRandom FRandomStream
function UPrefabricatorBlueprintLibrary:RandomizePrefab(PrefabActor, InRandom) end
---@param Prefab AActor
---@param AttachedActors TArray<AActor>
function UPrefabricatorBlueprintLibrary:GetAllAttachedActors(Prefab, AttachedActors) end
---@param InActor AActor
---@return APrefabActor
function UPrefabricatorBlueprintLibrary:FindTopMostPrefabActor(InActor) end


---@class UPrefabricatorEventListener : UObject
local UPrefabricatorEventListener = {}

---@param Prefab APrefabActor
function UPrefabricatorEventListener:PostSpawn(Prefab) end


---@class UPrefabricatorProperty : UObject
---@field PropertyName FString
---@field ExportedValue FString
---@field AssetSoftReferenceMappings TArray<FPrefabricatorPropertyAssetMapping>
---@field bIsCrossReferencedActor boolean
---@field CrossReferencePrefabActorId FGuid
local UPrefabricatorProperty = {}



---@class UPrefabricatorSettings : UDeveloperSettings
---@field PivotPosition EPrefabricatorPivotPosition
---@field bAllowDynamicUpdate boolean
---@field IgnoreBoundingBoxForObjects TSet<UClass>
---@field DefaultThumbnailPitch float
---@field DefaultThumbnailYaw float
---@field DefaultThumbnailZoom float
local UPrefabricatorSettings = {}



