---@meta

---@class UInterchangeActorFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeActorFactoryNode = {}

---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeActorFactoryNode:SetCustomMobility(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FTransform
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeActorFactoryNode:SetCustomLocalTransform(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FTransform
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeActorFactoryNode:SetCustomGlobalTransform(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FString
---@return boolean
function UInterchangeActorFactoryNode:SetCustomActorClassName(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeActorFactoryNode:GetCustomMobility(AttributeValue) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeActorFactoryNode:GetCustomLocalTransform(AttributeValue) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeActorFactoryNode:GetCustomGlobalTransform(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeActorFactoryNode:GetCustomActorClassName(AttributeValue) end


---@class UInterchangeAnimSequenceFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeAnimSequenceFactoryNode = {}

---@param AttributeValue FSoftObjectPath
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomSkeletonSoftObjectPath(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomSkeletonFactoryNodeUid(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomRemoveCurveRedundantKeys(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomMaterialDriveParameterOnCustomAttribute(AttributeValue) end
---@param AttributeValue double
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomImportBoneTracksSampleRate(AttributeValue) end
---@param AttributeValue double
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomImportBoneTracksRangeStop(AttributeValue) end
---@param AttributeValue double
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomImportBoneTracksRangeStart(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomImportBoneTracks(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomImportAttributeCurves(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomDoNotImportCurveWithZero(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomDeleteExistingNonCurveCustomAttributes(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomDeleteExistingMorphTargetCurves(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomDeleteExistingCustomAttributeCurves(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetCustomAddCurveMetadataToSkeleton(AttributeValue) end
---@param SceneNodeAnimationPayloadKeyUids TMap<FString, FString>
---@param SceneNodeAnimationPayloadKeyTypes TMap<FString, uint8>
function UInterchangeAnimSequenceFactoryNode:SetAnimationPayloadKeysForSceneNodeUids(SceneNodeAnimationPayloadKeyUids, SceneNodeAnimationPayloadKeyTypes) end
---@param MorphTargetAnimationPayloadKeyUids TMap<FString, FString>
---@param MorphTargetAnimationPayloadKeyTypes TMap<FString, uint8>
function UInterchangeAnimSequenceFactoryNode:SetAnimationPayloadKeysForMorphTargetNodeUids(MorphTargetAnimationPayloadKeyUids, MorphTargetAnimationPayloadKeyTypes) end
---@param MaterialCurveSuffixe FString
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetAnimatedMaterialCurveSuffixe(MaterialCurveSuffixe) end
---@param AttributeStepCurveName FString
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetAnimatedAttributeStepCurveName(AttributeStepCurveName) end
---@param AttributeCurveName FString
---@return boolean
function UInterchangeAnimSequenceFactoryNode:SetAnimatedAttributeCurveName(AttributeCurveName) end
---@param MaterialCurveSuffixe FString
---@return boolean
function UInterchangeAnimSequenceFactoryNode:RemoveAnimatedMaterialCurveSuffixe(MaterialCurveSuffixe) end
---@param AttributeStepCurveName FString
---@return boolean
function UInterchangeAnimSequenceFactoryNode:RemoveAnimatedAttributeStepCurveName(AttributeStepCurveName) end
---@param AttributeCurveName FString
---@return boolean
function UInterchangeAnimSequenceFactoryNode:RemoveAnimatedAttributeCurveName(AttributeCurveName) end
---@param UniqueID FString
---@param DisplayLabel FString
function UInterchangeAnimSequenceFactoryNode:InitializeAnimSequenceNode(UniqueID, DisplayLabel) end
---@param OutSceneNodeAnimationPayloadKeys TMap<FString, FInterchangeAnimationPayLoadKey>
function UInterchangeAnimSequenceFactoryNode:GetSceneNodeAnimationPayloadKeys(OutSceneNodeAnimationPayloadKeys) end
---@return UClass
function UInterchangeAnimSequenceFactoryNode:GetObjectClass() end
---@param OutMorphTargetNodeAnimationPayloads TMap<FString, FInterchangeAnimationPayLoadKey>
function UInterchangeAnimSequenceFactoryNode:GetMorphTargetNodeAnimationPayloadKeys(OutMorphTargetNodeAnimationPayloads) end
---@param AttributeValue FSoftObjectPath
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomSkeletonSoftObjectPath(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomSkeletonFactoryNodeUid(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomRemoveCurveRedundantKeys(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomMaterialDriveParameterOnCustomAttribute(AttributeValue) end
---@param AttributeValue double
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomImportBoneTracksSampleRate(AttributeValue) end
---@param AttributeValue double
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomImportBoneTracksRangeStop(AttributeValue) end
---@param AttributeValue double
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomImportBoneTracksRangeStart(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomImportBoneTracks(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomImportAttributeCurves(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomDoNotImportCurveWithZero(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomDeleteExistingNonCurveCustomAttributes(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomDeleteExistingMorphTargetCurves(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomDeleteExistingCustomAttributeCurves(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeAnimSequenceFactoryNode:GetCustomAddCurveMetadataToSkeleton(AttributeValue) end
---@return int32
function UInterchangeAnimSequenceFactoryNode:GetAnimatedMaterialCurveSuffixesCount() end
---@param OutMaterialCurveSuffixes TArray<FString>
function UInterchangeAnimSequenceFactoryNode:GetAnimatedMaterialCurveSuffixes(OutMaterialCurveSuffixes) end
---@param Index int32
---@param OutMaterialCurveSuffixe FString
function UInterchangeAnimSequenceFactoryNode:GetAnimatedMaterialCurveSuffixe(Index, OutMaterialCurveSuffixe) end
---@return int32
function UInterchangeAnimSequenceFactoryNode:GetAnimatedAttributeStepCurveNamesCount() end
---@param OutAttributeStepCurveNames TArray<FString>
function UInterchangeAnimSequenceFactoryNode:GetAnimatedAttributeStepCurveNames(OutAttributeStepCurveNames) end
---@param Index int32
---@param OutAttributeStepCurveName FString
function UInterchangeAnimSequenceFactoryNode:GetAnimatedAttributeStepCurveName(Index, OutAttributeStepCurveName) end
---@return int32
function UInterchangeAnimSequenceFactoryNode:GetAnimatedAttributeCurveNamesCount() end
---@param OutAttributeCurveNames TArray<FString>
function UInterchangeAnimSequenceFactoryNode:GetAnimatedAttributeCurveNames(OutAttributeCurveNames) end
---@param Index int32
---@param OutAttributeCurveName FString
function UInterchangeAnimSequenceFactoryNode:GetAnimatedAttributeCurveName(Index, OutAttributeCurveName) end


---@class UInterchangeBaseLightFactoryNode : UInterchangeActorFactoryNode
local UInterchangeBaseLightFactoryNode = {}

---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeBaseLightFactoryNode:SetCustomUseTemperature(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeBaseLightFactoryNode:SetCustomTemperature(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FColor
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeBaseLightFactoryNode:SetCustomLightColor(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeBaseLightFactoryNode:SetCustomIntensity(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeBaseLightFactoryNode:GetCustomUseTemperature(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeBaseLightFactoryNode:GetCustomTemperature(AttributeValue) end
---@param AttributeValue FColor
---@return boolean
function UInterchangeBaseLightFactoryNode:GetCustomLightColor(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeBaseLightFactoryNode:GetCustomIntensity(AttributeValue) end


---@class UInterchangeBaseMaterialFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeBaseMaterialFactoryNode = {}

---@param AttributeValue boolean
---@return boolean
function UInterchangeBaseMaterialFactoryNode:SetCustomIsMaterialImportEnabled(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeBaseMaterialFactoryNode:GetCustomIsMaterialImportEnabled(AttributeValue) end


---@class UInterchangeCommonPipelineDataFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeCommonPipelineDataFactoryNode = {}

---@param NodeContainer UInterchangeBaseNodeContainer
---@param AttributeValue FTransform
---@return boolean
function UInterchangeCommonPipelineDataFactoryNode:SetCustomGlobalOffsetTransform(NodeContainer, AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeCommonPipelineDataFactoryNode:SetBakePivotMeshes(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeCommonPipelineDataFactoryNode:SetBakeMeshes(AttributeValue) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeCommonPipelineDataFactoryNode:GetCustomGlobalOffsetTransform(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeCommonPipelineDataFactoryNode:GetBakePivotMeshes(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeCommonPipelineDataFactoryNode:GetBakeMeshes(AttributeValue) end


---@class UInterchangeDecalActorFactoryNode : UInterchangeActorFactoryNode
local UInterchangeDecalActorFactoryNode = {}

---@param AttributeValue int32
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeDecalActorFactoryNode:SetCustomSortOrder(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FVector
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeDecalActorFactoryNode:SetCustomDecalSize(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FString
---@return boolean
function UInterchangeDecalActorFactoryNode:SetCustomDecalMaterialPathName(AttributeValue) end
---@return UClass
function UInterchangeDecalActorFactoryNode:GetObjectClass() end
---@param AttributeValue int32
---@return boolean
function UInterchangeDecalActorFactoryNode:GetCustomSortOrder(AttributeValue) end
---@param AttributeValue FVector
---@return boolean
function UInterchangeDecalActorFactoryNode:GetCustomDecalSize(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeDecalActorFactoryNode:GetCustomDecalMaterialPathName(AttributeValue) end


---@class UInterchangeDecalMaterialFactoryNode : UInterchangeBaseMaterialFactoryNode
local UInterchangeDecalMaterialFactoryNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeDecalMaterialFactoryNode:SetCustomNormalTexturePath(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeDecalMaterialFactoryNode:SetCustomDiffuseTexturePath(AttributeValue) end
---@return UClass
function UInterchangeDecalMaterialFactoryNode:GetObjectClass() end
---@param AttributeValue FString
---@return boolean
function UInterchangeDecalMaterialFactoryNode:GetCustomNormalTexturePath(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeDecalMaterialFactoryNode:GetCustomDiffuseTexturePath(AttributeValue) end


---@class UInterchangeDirectionalLightFactoryNode : UInterchangeBaseLightFactoryNode
local UInterchangeDirectionalLightFactoryNode = {}


---@class UInterchangeLevelFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeLevelFactoryNode = {}

---@param AttributeValue boolean
---@return boolean
function UInterchangeLevelFactoryNode:SetCustomShouldCreateLevel(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeLevelFactoryNode:SetCustomSceneImportAssetFactoryNodeUid(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeLevelFactoryNode:SetCustomCreateWorldPartitionLevel(AttributeValue) end
---@param ActorFactoryNodeUid FString
---@return boolean
function UInterchangeLevelFactoryNode:RemoveCustomActorFactoryNodeUid(ActorFactoryNodeUid) end
---@return UClass
function UInterchangeLevelFactoryNode:GetObjectClass() end
---@param AttributeValue boolean
---@return boolean
function UInterchangeLevelFactoryNode:GetCustomShouldCreateLevel(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeLevelFactoryNode:GetCustomSceneImportAssetFactoryNodeUid(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeLevelFactoryNode:GetCustomCreateWorldPartitionLevel(AttributeValue) end
---@param OutActorFactoryNodeUids TArray<FString>
function UInterchangeLevelFactoryNode:GetCustomActorFactoryNodeUids(OutActorFactoryNodeUids) end
---@return int32
function UInterchangeLevelFactoryNode:GetCustomActorFactoryNodeUidCount() end
---@param Index int32
---@param OutActorFactoryNodeUid FString
function UInterchangeLevelFactoryNode:GetCustomActorFactoryNodeUid(Index, OutActorFactoryNodeUid) end
---@param ActorFactoryNodeUid FString
---@return boolean
function UInterchangeLevelFactoryNode:AddCustomActorFactoryNodeUid(ActorFactoryNodeUid) end


---@class UInterchangeLevelInstanceActorFactoryNode : UInterchangeActorFactoryNode
local UInterchangeLevelInstanceActorFactoryNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeLevelInstanceActorFactoryNode:SetCustomLevelReference(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeLevelInstanceActorFactoryNode:GetCustomLevelReference(AttributeValue) end


---@class UInterchangeLevelSequenceFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeLevelSequenceFactoryNode = {}

---@param AttributeValue float
---@return boolean
function UInterchangeLevelSequenceFactoryNode:SetCustomFrameRate(AttributeValue) end
---@param AnimationTrackUid FString
---@return boolean
function UInterchangeLevelSequenceFactoryNode:RemoveCustomAnimationTrackUid(AnimationTrackUid) end
---@return UClass
function UInterchangeLevelSequenceFactoryNode:GetObjectClass() end
---@param AttributeValue float
---@return boolean
function UInterchangeLevelSequenceFactoryNode:GetCustomFrameRate(AttributeValue) end
---@param OutAnimationTrackUids TArray<FString>
function UInterchangeLevelSequenceFactoryNode:GetCustomAnimationTrackUids(OutAnimationTrackUids) end
---@return int32
function UInterchangeLevelSequenceFactoryNode:GetCustomAnimationTrackUidCount() end
---@param Index int32
---@param OutAnimationTrackUid FString
function UInterchangeLevelSequenceFactoryNode:GetCustomAnimationTrackUid(Index, OutAnimationTrackUid) end
---@param AnimationTrackUid FString
---@return boolean
function UInterchangeLevelSequenceFactoryNode:AddCustomAnimationTrackUid(AnimationTrackUid) end


---@class UInterchangeLightFactoryNode : UInterchangeBaseLightFactoryNode
local UInterchangeLightFactoryNode = {}

---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeLightFactoryNode:SetCustomUseIESBrightness(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FRotator
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeLightFactoryNode:SetCustomRotation(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue ELightUnits
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeLightFactoryNode:SetCustomIntensityUnits(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FString
---@return boolean
function UInterchangeLightFactoryNode:SetCustomIESTexture(AttributeValue) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeLightFactoryNode:SetCustomIESBrightnessScale(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeLightFactoryNode:SetCustomAttenuationRadius(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeLightFactoryNode:GetCustomUseIESBrightness(AttributeValue) end
---@param AttributeValue FRotator
---@return boolean
function UInterchangeLightFactoryNode:GetCustomRotation(AttributeValue) end
---@param AttributeValue ELightUnits
---@return boolean
function UInterchangeLightFactoryNode:GetCustomIntensityUnits(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeLightFactoryNode:GetCustomIESTexture(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeLightFactoryNode:GetCustomIESBrightnessScale(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeLightFactoryNode:GetCustomAttenuationRadius(AttributeValue) end


---@class UInterchangeMaterialExpressionFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeMaterialExpressionFactoryNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialExpressionFactoryNode:SetCustomExpressionClassName(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialExpressionFactoryNode:GetCustomExpressionClassName(AttributeValue) end


---@class UInterchangeMaterialFactoryNode : UInterchangeBaseMaterialFactoryNode
local UInterchangeMaterialFactoryNode = {}

---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMaterialFactoryNode:SetCustomTwoSided(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue ETranslucencyLightingMode
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMaterialFactoryNode:SetCustomTranslucencyLightingMode(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue EMaterialShadingModel
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMaterialFactoryNode:SetCustomShadingModel(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMaterialFactoryNode:SetCustomScreenSpaceReflections(AttributeValue) end
---@param AttributeValue ERefractionMode
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMaterialFactoryNode:SetCustomRefractionMethod(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMaterialFactoryNode:SetCustomOpacityMaskClipValue(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue EBlendMode
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMaterialFactoryNode:SetCustomBlendMode(AttributeValue, bAddApplyDelegate) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetTransmissionColorConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetTangentConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetSurfaceCoverageConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetSubsurfaceConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetSpecularConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetRoughnessConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetRefractionConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetOpacityConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetOcclusionConnection(ExpressionNodeUid, OutputName) end
---@return UClass
function UInterchangeMaterialFactoryNode:GetObjectClass() end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetNormalConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetMetallicConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetFuzzColorConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetEmissiveColorConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetDisplacementConnection(ExpressionNodeUid, OutputName) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMaterialFactoryNode:GetCustomTwoSided(AttributeValue) end
---@param AttributeValue ETranslucencyLightingMode
---@return boolean
function UInterchangeMaterialFactoryNode:GetCustomTranslucencyLightingMode(AttributeValue) end
---@param AttributeValue EMaterialShadingModel
---@return boolean
function UInterchangeMaterialFactoryNode:GetCustomShadingModel(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMaterialFactoryNode:GetCustomScreenSpaceReflections(AttributeValue) end
---@param AttributeValue ERefractionMode
---@return boolean
function UInterchangeMaterialFactoryNode:GetCustomRefractionMethod(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeMaterialFactoryNode:GetCustomOpacityMaskClipValue(AttributeValue) end
---@param AttributeValue EBlendMode
---@return boolean
function UInterchangeMaterialFactoryNode:GetCustomBlendMode(AttributeValue) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetClothConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetClearCoatRoughnessConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetClearCoatNormalConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetClearCoatConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetBaseColorConnection(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:GetAnisotropyConnection(ExpressionNodeUid, OutputName) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToTransmissionColor(AttributeValue) end
---@param ExpressionNodeUid FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToTangent(ExpressionNodeUid) end
---@param ExpressionUid FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToSurfaceCoverage(ExpressionUid) end
---@param ExpressionNodeUid FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToSubsurface(ExpressionNodeUid) end
---@param ExpressionNodeUid FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToSpecular(ExpressionNodeUid) end
---@param ExpressionNodeUid FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToRoughness(ExpressionNodeUid) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToRefraction(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToOpacity(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToOcclusion(AttributeValue) end
---@param ExpressionNodeUid FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToNormal(ExpressionNodeUid) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToMetallic(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToFuzzColor(AttributeValue) end
---@param ExpressionNodeUid FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToEmissiveColor(ExpressionNodeUid) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToDisplacement(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToCloth(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToClearCoatRoughness(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToClearCoatNormal(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToClearCoat(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToBaseColor(AttributeValue) end
---@param ExpressionNodeUid FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectToAnisotropy(ExpressionNodeUid) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToTransmissionColor(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToTangent(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToSurfaceCoverage(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToSubsurface(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToSpecular(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToRoughness(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToRefraction(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToOpacity(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToOcclusion(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToNormal(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToMetallic(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToFuzzColor(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToEmissiveColor(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToDisplacement(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToCloth(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToClearCoatRoughness(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToClearCoatNormal(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToClearCoat(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToBaseColor(ExpressionNodeUid, OutputName) end
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFactoryNode:ConnectOutputToAnisotropy(ExpressionNodeUid, OutputName) end


---@class UInterchangeMaterialFunctionCallExpressionFactoryNode : UInterchangeMaterialExpressionFactoryNode
local UInterchangeMaterialFunctionCallExpressionFactoryNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFunctionCallExpressionFactoryNode:SetCustomMaterialFunctionDependency(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialFunctionCallExpressionFactoryNode:GetCustomMaterialFunctionDependency(AttributeValue) end


---@class UInterchangeMaterialFunctionFactoryNode : UInterchangeBaseMaterialFactoryNode
local UInterchangeMaterialFunctionFactoryNode = {}

---@return UClass
function UInterchangeMaterialFunctionFactoryNode:GetObjectClass() end
---@param InputName FString
---@param ExpressionNodeUid FString
---@param OutputName FString
---@return boolean
function UInterchangeMaterialFunctionFactoryNode:GetInputConnection(InputName, ExpressionNodeUid, OutputName) end


---@class UInterchangeMaterialInstanceFactoryNode : UInterchangeBaseMaterialFactoryNode
local UInterchangeMaterialInstanceFactoryNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialInstanceFactoryNode:SetCustomParent(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialInstanceFactoryNode:SetCustomInstanceClassName(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialInstanceFactoryNode:GetCustomParent(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialInstanceFactoryNode:GetCustomInstanceClassName(AttributeValue) end


---@class UInterchangeMeshActorFactoryNode : UInterchangeActorFactoryNode
local UInterchangeMeshActorFactoryNode = {}

---@param SlotName FString
---@param MaterialDependencyUid FString
---@return boolean
function UInterchangeMeshActorFactoryNode:SetSlotMaterialDependencyUid(SlotName, MaterialDependencyUid) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeMeshActorFactoryNode:SetCustomGeometricTransform(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMeshActorFactoryNode:SetCustomAnimationAssetUidToPlay(AttributeValue) end
---@param SlotName FString
---@return boolean
function UInterchangeMeshActorFactoryNode:RemoveSlotMaterialDependencyUid(SlotName) end
---@param SlotName FString
---@param OutMaterialDependency FString
---@return boolean
function UInterchangeMeshActorFactoryNode:GetSlotMaterialDependencyUid(SlotName, OutMaterialDependency) end
---@param OutMaterialDependencies TMap<FString, FString>
function UInterchangeMeshActorFactoryNode:GetSlotMaterialDependencies(OutMaterialDependencies) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeMeshActorFactoryNode:GetCustomGeometricTransform(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMeshActorFactoryNode:GetCustomAnimationAssetUidToPlay(AttributeValue) end


---@class UInterchangeMeshFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeMeshFactoryNode = {}

---@param SlotName FString
---@param MaterialDependencyUid FString
---@return boolean
function UInterchangeMeshFactoryNode:SetSlotMaterialDependencyUid(SlotName, MaterialDependencyUid) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomVertexColorReplace(AttributeValue) end
---@param AttributeValue FColor
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomVertexColorOverride(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomVertexColorIgnore(AttributeValue) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomUseMikkTSpace(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomUseHighPrecisionTangentBasis(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomUseFullPrecisionUVs(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomUseBackwardsCompatibleF16TruncUVs(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomRemoveDegenerates(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomRecomputeTangents(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomRecomputeNormals(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FName
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomLODGroup(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomKeepSectionsSeparate(AttributeValue) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeMeshFactoryNode:SetCustomComputeWeightedNormals(AttributeValue, bAddApplyDelegate) end
---@return boolean
function UInterchangeMeshFactoryNode:ResetSlotMaterialDependencies() end
---@param SlotName FString
---@return boolean
function UInterchangeMeshFactoryNode:RemoveSlotMaterialDependencyUid(SlotName) end
---@param LodDataUniqueId FString
---@return boolean
function UInterchangeMeshFactoryNode:RemoveLodDataUniqueId(LodDataUniqueId) end
---@param SlotName FString
---@param OutMaterialDependency FString
---@return boolean
function UInterchangeMeshFactoryNode:GetSlotMaterialDependencyUid(SlotName, OutMaterialDependency) end
---@param OutMaterialDependencies TMap<FString, FString>
function UInterchangeMeshFactoryNode:GetSlotMaterialDependencies(OutMaterialDependencies) end
---@param OutLodDataUniqueIds TArray<FString>
function UInterchangeMeshFactoryNode:GetLodDataUniqueIds(OutLodDataUniqueIds) end
---@return int32
function UInterchangeMeshFactoryNode:GetLodDataCount() end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomVertexColorReplace(AttributeValue) end
---@param AttributeValue FColor
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomVertexColorOverride(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomVertexColorIgnore(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomUseMikkTSpace(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomUseHighPrecisionTangentBasis(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomUseFullPrecisionUVs(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomUseBackwardsCompatibleF16TruncUVs(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomRemoveDegenerates(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomRecomputeTangents(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomRecomputeNormals(AttributeValue) end
---@param AttributeValue FName
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomLODGroup(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomKeepSectionsSeparate(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshFactoryNode:GetCustomComputeWeightedNormals(AttributeValue) end
---@param LodDataUniqueId FString
---@return boolean
function UInterchangeMeshFactoryNode:AddLodDataUniqueId(LodDataUniqueId) end


---@class UInterchangePhysicalCameraFactoryNode : UInterchangeActorFactoryNode
local UInterchangePhysicalCameraFactoryNode = {}

---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangePhysicalCameraFactoryNode:SetCustomSensorWidth(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangePhysicalCameraFactoryNode:SetCustomSensorHeight(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue ECameraFocusMethod
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangePhysicalCameraFactoryNode:SetCustomFocusMethod(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangePhysicalCameraFactoryNode:SetCustomFocalLength(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@return boolean
function UInterchangePhysicalCameraFactoryNode:GetCustomSensorWidth(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangePhysicalCameraFactoryNode:GetCustomSensorHeight(AttributeValue) end
---@param AttributeValue ECameraFocusMethod
---@return boolean
function UInterchangePhysicalCameraFactoryNode:GetCustomFocusMethod(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangePhysicalCameraFactoryNode:GetCustomFocalLength(AttributeValue) end


---@class UInterchangePhysicsAssetFactoryNode : UInterchangeFactoryBaseNode
local UInterchangePhysicsAssetFactoryNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangePhysicsAssetFactoryNode:SetCustomSkeletalMeshUid(AttributeValue) end
---@param UniqueID FString
---@param DisplayLabel FString
---@param InAssetClass FString
function UInterchangePhysicsAssetFactoryNode:InitializePhysicsAssetNode(UniqueID, DisplayLabel, InAssetClass) end
---@return UClass
function UInterchangePhysicsAssetFactoryNode:GetObjectClass() end
---@param AttributeValue FString
---@return boolean
function UInterchangePhysicsAssetFactoryNode:GetCustomSkeletalMeshUid(AttributeValue) end


---@class UInterchangePointLightFactoryNode : UInterchangeLightFactoryNode
local UInterchangePointLightFactoryNode = {}

---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangePointLightFactoryNode:SetCustomUseInverseSquaredFalloff(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangePointLightFactoryNode:SetCustomLightFalloffExponent(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@return boolean
function UInterchangePointLightFactoryNode:GetCustomUseInverseSquaredFalloff(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangePointLightFactoryNode:GetCustomLightFalloffExponent(AttributeValue) end


---@class UInterchangeRectLightFactoryNode : UInterchangeLightFactoryNode
local UInterchangeRectLightFactoryNode = {}

---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeRectLightFactoryNode:SetCustomSourceWidth(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeRectLightFactoryNode:SetCustomSourceHeight(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@return boolean
function UInterchangeRectLightFactoryNode:GetCustomSourceWidth(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeRectLightFactoryNode:GetCustomSourceHeight(AttributeValue) end


---@class UInterchangeSceneImportAssetFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeSceneImportAssetFactoryNode = {}


---@class UInterchangeSceneVariantSetsFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeSceneVariantSetsFactoryNode = {}

---@param VariantUid FString
---@return boolean
function UInterchangeSceneVariantSetsFactoryNode:RemoveCustomVariantSetUid(VariantUid) end
---@return UClass
function UInterchangeSceneVariantSetsFactoryNode:GetObjectClass() end
---@param OutVariantUids TArray<FString>
function UInterchangeSceneVariantSetsFactoryNode:GetCustomVariantSetUids(OutVariantUids) end
---@return int32
function UInterchangeSceneVariantSetsFactoryNode:GetCustomVariantSetUidCount() end
---@param Index int32
---@param OutVariantUid FString
function UInterchangeSceneVariantSetsFactoryNode:GetCustomVariantSetUid(Index, OutVariantUid) end
---@param VariantUid FString
---@return boolean
function UInterchangeSceneVariantSetsFactoryNode:AddCustomVariantSetUid(VariantUid) end


---@class UInterchangeSkeletalMeshFactoryNode : UInterchangeMeshFactoryNode
local UInterchangeSkeletalMeshFactoryNode = {}

---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomUseHighPrecisionSkinWeights(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomThresholdUV(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomThresholdTangentNormal(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomThresholdPosition(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FSoftObjectPath
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomSkeletonSoftObjectPath(AttributeValue) end
---@param AttributeValue FSoftObjectPath
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomPhysicAssetSoftObjectPath(AttributeValue) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomMorphThresholdPosition(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomMergeMorphTargetShapeWithSameName(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomImportVertexAttributes(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomImportMorphTarget(AttributeValue) end
---@param AttributeValue EInterchangeSkeletalMeshContentType
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomImportContentType(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomCreatePhysicsAsset(AttributeValue) end
---@param AttributeValue int32
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:SetCustomBoneInfluenceLimit(AttributeValue, bAddApplyDelegate) end
---@param UniqueID FString
---@param DisplayLabel FString
---@param InAssetClass FString
function UInterchangeSkeletalMeshFactoryNode:InitializeSkeletalMeshNode(UniqueID, DisplayLabel, InAssetClass) end
---@return UClass
function UInterchangeSkeletalMeshFactoryNode:GetObjectClass() end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomUseHighPrecisionSkinWeights(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomThresholdUV(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomThresholdTangentNormal(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomThresholdPosition(AttributeValue) end
---@param AttributeValue FSoftObjectPath
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomSkeletonSoftObjectPath(AttributeValue) end
---@param AttributeValue FSoftObjectPath
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomPhysicAssetSoftObjectPath(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomMorphThresholdPosition(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomMergeMorphTargetShapeWithSameName(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomImportVertexAttributes(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomImportMorphTarget(AttributeValue) end
---@param AttributeValue EInterchangeSkeletalMeshContentType
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomImportContentType(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomCreatePhysicsAsset(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeSkeletalMeshFactoryNode:GetCustomBoneInfluenceLimit(AttributeValue) end


---@class UInterchangeSkeletalMeshLodDataNode : UInterchangeFactoryBaseNode
local UInterchangeSkeletalMeshLodDataNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeSkeletalMeshLodDataNode:SetCustomSkeletonUid(AttributeValue) end
---@param MeshName FString
---@return boolean
function UInterchangeSkeletalMeshLodDataNode:RemoveMeshUid(MeshName) end
---@return boolean
function UInterchangeSkeletalMeshLodDataNode:RemoveAllMeshes() end
---@return int32
function UInterchangeSkeletalMeshLodDataNode:GetMeshUidsCount() end
---@param OutMeshNames TArray<FString>
function UInterchangeSkeletalMeshLodDataNode:GetMeshUids(OutMeshNames) end
---@param AttributeValue FString
---@return boolean
function UInterchangeSkeletalMeshLodDataNode:GetCustomSkeletonUid(AttributeValue) end
---@param MeshName FString
---@return boolean
function UInterchangeSkeletalMeshLodDataNode:AddMeshUid(MeshName) end


---@class UInterchangeSkeletonFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeSkeletonFactoryNode = {}

---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletonFactoryNode:SetCustomUseTimeZeroForBindPose(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeSkeletonFactoryNode:SetCustomSkeletalMeshFactoryNodeUid(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeSkeletonFactoryNode:SetCustomRootJointUid(AttributeValue) end
---@param UniqueID FString
---@param DisplayLabel FString
---@param InAssetClass FString
function UInterchangeSkeletonFactoryNode:InitializeSkeletonNode(UniqueID, DisplayLabel, InAssetClass) end
---@return UClass
function UInterchangeSkeletonFactoryNode:GetObjectClass() end
---@param AttributeValue boolean
---@return boolean
function UInterchangeSkeletonFactoryNode:GetCustomUseTimeZeroForBindPose(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeSkeletonFactoryNode:GetCustomSkeletalMeshFactoryNodeUid(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeSkeletonFactoryNode:GetCustomRootJointUid(AttributeValue) end


---@class UInterchangeSpotLightFactoryNode : UInterchangePointLightFactoryNode
local UInterchangeSpotLightFactoryNode = {}

---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeSpotLightFactoryNode:SetCustomOuterConeAngle(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeSpotLightFactoryNode:SetCustomInnerConeAngle(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@return boolean
function UInterchangeSpotLightFactoryNode:GetCustomOuterConeAngle(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeSpotLightFactoryNode:GetCustomInnerConeAngle(AttributeValue) end


---@class UInterchangeStandardCameraFactoryNode : UInterchangeActorFactoryNode
local UInterchangeStandardCameraFactoryNode = {}

---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStandardCameraFactoryNode:SetCustomWidth(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue ECameraProjectionMode::Type
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStandardCameraFactoryNode:SetCustomProjectionMode(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStandardCameraFactoryNode:SetCustomNearClipPlane(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStandardCameraFactoryNode:SetCustomFieldOfView(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStandardCameraFactoryNode:SetCustomFarClipPlane(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStandardCameraFactoryNode:SetCustomAspectRatio(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraFactoryNode:GetCustomWidth(AttributeValue) end
---@param AttributeValue ECameraProjectionMode::Type
---@return boolean
function UInterchangeStandardCameraFactoryNode:GetCustomProjectionMode(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraFactoryNode:GetCustomNearClipPlane(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraFactoryNode:GetCustomFieldOfView(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraFactoryNode:GetCustomFarClipPlane(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraFactoryNode:GetCustomAspectRatio(AttributeValue) end


---@class UInterchangeStaticMeshFactoryNode : UInterchangeMeshFactoryNode
local UInterchangeStaticMeshFactoryNode = {}

---@param InLODScreenSizes TArray<float>
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetLODScreenSizes(InLODScreenSizes) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomSupportFaceRemap(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue int32
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomSrcLightmapIndex(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue int32
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomMinLightmapResolution(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue int32
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomMaxLumenMeshCards(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomGenerateLightmapUVs(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomGenerateDistanceFieldAsIfTwoSided(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue int32
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomDstLightmapIndex(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomDistanceFieldResolutionScale(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FSoftObjectPath
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomDistanceFieldReplacementMesh(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FVector
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomBuildScale3D(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomBuildReversedIndexBuffer(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomBuildNanite(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:SetCustomAutoComputeLODScreenSizes(AttributeValue) end
---@param SocketUid FString
---@return boolean
function UInterchangeStaticMeshFactoryNode:RemoveSocketUd(SocketUid) end
---@param UniqueID FString
---@param DisplayLabel FString
---@param InAssetClass FString
function UInterchangeStaticMeshFactoryNode:InitializeStaticMeshNode(UniqueID, DisplayLabel, InAssetClass) end
---@param OutSocketUids TArray<FString>
function UInterchangeStaticMeshFactoryNode:GetSocketUids(OutSocketUids) end
---@return int32
function UInterchangeStaticMeshFactoryNode:GetSocketUidCount() end
---@return UClass
function UInterchangeStaticMeshFactoryNode:GetObjectClass() end
---@param OutLODScreenSizes TArray<float>
function UInterchangeStaticMeshFactoryNode:GetLODScreenSizes(OutLODScreenSizes) end
---@return int32
function UInterchangeStaticMeshFactoryNode:GetLODScreenSizeCount() end
---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomSupportFaceRemap(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomSrcLightmapIndex(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomMinLightmapResolution(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomMaxLumenMeshCards(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomGenerateLightmapUVs(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomGenerateDistanceFieldAsIfTwoSided(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomDstLightmapIndex(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomDistanceFieldResolutionScale(AttributeValue) end
---@param AttributeValue FSoftObjectPath
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomDistanceFieldReplacementMesh(AttributeValue) end
---@param AttributeValue FVector
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomBuildScale3D(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomBuildReversedIndexBuffer(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomBuildNanite(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshFactoryNode:GetCustomAutoComputeLODScreenSizes(AttributeValue) end
---@param InSocketUids TArray<FString>
---@return boolean
function UInterchangeStaticMeshFactoryNode:AddSocketUids(InSocketUids) end
---@param SocketUid FString
---@return boolean
function UInterchangeStaticMeshFactoryNode:AddSocketUid(SocketUid) end


---@class UInterchangeStaticMeshLodDataNode : UInterchangeFactoryBaseNode
local UInterchangeStaticMeshLodDataNode = {}

---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshLodDataNode:SetOneConvexHullPerUCX(AttributeValue) end
---@param AttributeValue EInterchangeMeshCollision
---@return boolean
function UInterchangeStaticMeshLodDataNode:SetImportCollisionType(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshLodDataNode:SetImportCollision(AttributeValue) end
---@param MeshName FString
---@return boolean
function UInterchangeStaticMeshLodDataNode:RemoveSphereCollisionMeshUid(MeshName) end
---@param MeshName FString
---@return boolean
function UInterchangeStaticMeshLodDataNode:RemoveMeshUid(MeshName) end
---@param MeshName FString
---@return boolean
function UInterchangeStaticMeshLodDataNode:RemoveConvexCollisionMeshUid(MeshName) end
---@param MeshName FString
---@return boolean
function UInterchangeStaticMeshLodDataNode:RemoveCapsuleCollisionMeshUid(MeshName) end
---@param MeshName FString
---@return boolean
function UInterchangeStaticMeshLodDataNode:RemoveBoxCollisionMeshUid(MeshName) end
---@return boolean
function UInterchangeStaticMeshLodDataNode:RemoveAllSphereCollisionMeshes() end
---@return boolean
function UInterchangeStaticMeshLodDataNode:RemoveAllMeshes() end
---@return boolean
function UInterchangeStaticMeshLodDataNode:RemoveAllConvexCollisionMeshes() end
---@return boolean
function UInterchangeStaticMeshLodDataNode:RemoveAllCapsuleCollisionMeshes() end
---@return boolean
function UInterchangeStaticMeshLodDataNode:RemoveAllBoxCollisionMeshes() end
---@return int32
function UInterchangeStaticMeshLodDataNode:GetSphereCollisionMeshUidsCount() end
---@param OutMeshNames TArray<FString>
function UInterchangeStaticMeshLodDataNode:GetSphereCollisionMeshUids(OutMeshNames) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshLodDataNode:GetOneConvexHullPerUCX(AttributeValue) end
---@return int32
function UInterchangeStaticMeshLodDataNode:GetMeshUidsCount() end
---@param OutMeshNames TArray<FString>
function UInterchangeStaticMeshLodDataNode:GetMeshUids(OutMeshNames) end
---@param AttributeValue EInterchangeMeshCollision
---@return boolean
function UInterchangeStaticMeshLodDataNode:GetImportCollisionType(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeStaticMeshLodDataNode:GetImportCollision(AttributeValue) end
---@return int32
function UInterchangeStaticMeshLodDataNode:GetConvexCollisionMeshUidsCount() end
---@param OutMeshNames TArray<FString>
function UInterchangeStaticMeshLodDataNode:GetConvexCollisionMeshUids(OutMeshNames) end
---@return int32
function UInterchangeStaticMeshLodDataNode:GetCapsuleCollisionMeshUidsCount() end
---@param OutMeshNames TArray<FString>
function UInterchangeStaticMeshLodDataNode:GetCapsuleCollisionMeshUids(OutMeshNames) end
---@return int32
function UInterchangeStaticMeshLodDataNode:GetBoxCollisionMeshUidsCount() end
---@param OutMeshNames TArray<FString>
function UInterchangeStaticMeshLodDataNode:GetBoxCollisionMeshUids(OutMeshNames) end
---@param MeshName FString
---@return boolean
function UInterchangeStaticMeshLodDataNode:AddSphereCollisionMeshUid(MeshName) end
---@param MeshName FString
---@return boolean
function UInterchangeStaticMeshLodDataNode:AddMeshUid(MeshName) end
---@param MeshName FString
---@return boolean
function UInterchangeStaticMeshLodDataNode:AddConvexCollisionMeshUid(MeshName) end
---@param MeshName FString
---@return boolean
function UInterchangeStaticMeshLodDataNode:AddCapsuleCollisionMeshUid(MeshName) end
---@param MeshName FString
---@return boolean
function UInterchangeStaticMeshLodDataNode:AddBoxCollisionMeshUid(MeshName) end


---@class UInterchangeTexture2DArrayFactoryNode : UInterchangeTextureFactoryNode
local UInterchangeTexture2DArrayFactoryNode = {}

---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTexture2DArrayFactoryNode:SetCustomAddressZ(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTexture2DArrayFactoryNode:GetCustomAddressZ(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTexture2DArrayFactoryNode:GetCustomAddressY(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTexture2DArrayFactoryNode:GetCustomAddressX(AttributeValue) end


---@class UInterchangeTexture2DFactoryNode : UInterchangeTextureFactoryNode
local UInterchangeTexture2DFactoryNode = {}

---@param InSourceBlocks TMap<int32, FString>
function UInterchangeTexture2DFactoryNode:SetSourceBlocks(InSourceBlocks) end
---@param X int32
---@param Y int32
---@param InSourceFile FString
function UInterchangeTexture2DFactoryNode:SetSourceBlockByCoordinates(X, Y, InSourceFile) end
---@param BlockIndex int32
---@param InSourceFile FString
function UInterchangeTexture2DFactoryNode:SetSourceBlock(BlockIndex, InSourceFile) end
---@param AttributeValue TextureAddress
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTexture2DFactoryNode:SetCustomAddressY(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue TextureAddress
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTexture2DFactoryNode:SetCustomAddressX(AttributeValue, bAddApplyDelegate) end
---@return TMap<int32, FString>
function UInterchangeTexture2DFactoryNode:GetSourceBlocks() end
---@param X int32
---@param Y int32
---@param OutSourceFile FString
---@return boolean
function UInterchangeTexture2DFactoryNode:GetSourceBlockByCoordinates(X, Y, OutSourceFile) end
---@param BlockIndex int32
---@param OutSourceFile FString
---@return boolean
function UInterchangeTexture2DFactoryNode:GetSourceBlock(BlockIndex, OutSourceFile) end
---@param AttributeValue TextureAddress
---@return boolean
function UInterchangeTexture2DFactoryNode:GetCustomAddressY(AttributeValue) end
---@param AttributeValue TextureAddress
---@return boolean
function UInterchangeTexture2DFactoryNode:GetCustomAddressX(AttributeValue) end


---@class UInterchangeTextureCubeArrayFactoryNode : UInterchangeTextureFactoryNode
local UInterchangeTextureCubeArrayFactoryNode = {}


---@class UInterchangeTextureCubeFactoryNode : UInterchangeTextureFactoryNode
local UInterchangeTextureCubeFactoryNode = {}


---@class UInterchangeTextureFactoryNode : UInterchangeFactoryBaseNode
local UInterchangeTextureFactoryNode = {}

---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomVirtualTextureStreaming(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FString
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomTranslatedTextureNodeUid(AttributeValue) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomSRGB(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomPreferCompressedSourceData(AttributeValue) end
---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomPowerOfTwoMode(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FColor
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomPaddingColor(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomMipLoadOptions(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomMipGenSettings(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue int32
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomMaxTextureSize(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomLossyCompressionAmount(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomLODGroup(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue int32
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomLODBias(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomFilter(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomDownscaleOptions(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomDownscale(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomDeferCompression(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomCompressionSettings(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomCompressionQuality(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomCompressionNoAlpha(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue uint8
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomCompositeTextureMode(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomCompositePower(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue ETextureColorSpace
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomColorSpace(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomChromaKeyThreshold(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FColor
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomChromaKeyColor(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustombUseLegacyGamma(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustombPreserveBorder(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustombFlipGreenChannel(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustombDoScaleMipsForAlphaCoverage(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustombChromaKeyTexture(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FVector4
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomAlphaCoverageThresholds(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomAllowNonPowerOfTwo(AttributeValue) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomAdjustVibrance(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomAdjustSaturation(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomAdjustRGBCurve(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomAdjustMinAlpha(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomAdjustMaxAlpha(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomAdjustHue(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomAdjustBrightnessCurve(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureFactoryNode:SetCustomAdjustBrightness(AttributeValue, bAddApplyDelegate) end
---@param UniqueID FString
---@param DisplayLabel FString
---@param InAssetName FString
function UInterchangeTextureFactoryNode:InitializeTextureNode(UniqueID, DisplayLabel, InAssetName) end
---@return UClass
function UInterchangeTextureFactoryNode:GetObjectClass() end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomVirtualTextureStreaming(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomTranslatedTextureNodeUid(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomSRGB(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomPreferCompressedSourceData(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomPowerOfTwoMode(AttributeValue) end
---@param AttributeValue FColor
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomPaddingColor(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomMipLoadOptions(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomMipGenSettings(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomMaxTextureSize(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomLossyCompressionAmount(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomLODGroup(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomLODBias(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomFilter(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomDownscaleOptions(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomDownscale(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomDeferCompression(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomCompressionSettings(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomCompressionQuality(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomCompressionNoAlpha(AttributeValue) end
---@param AttributeValue uint8
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomCompositeTextureMode(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomCompositePower(AttributeValue) end
---@param AttributeValue ETextureColorSpace
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomColorSpace(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomChromaKeyThreshold(AttributeValue) end
---@param AttributeValue FColor
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomChromaKeyColor(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustombUseLegacyGamma(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustombPreserveBorder(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustombFlipGreenChannel(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustombDoScaleMipsForAlphaCoverage(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustombChromaKeyTexture(AttributeValue) end
---@param AttributeValue FVector4
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomAlphaCoverageThresholds(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomAllowNonPowerOfTwo(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomAdjustVibrance(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomAdjustSaturation(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomAdjustRGBCurve(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomAdjustMinAlpha(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomAdjustMaxAlpha(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomAdjustHue(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomAdjustBrightnessCurve(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureFactoryNode:GetCustomAdjustBrightness(AttributeValue) end


---@class UInterchangeTextureLightProfileFactoryNode : UInterchangeTexture2DFactoryNode
local UInterchangeTextureLightProfileFactoryNode = {}

---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureLightProfileFactoryNode:SetCustomTextureMultiplier(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeTextureLightProfileFactoryNode:SetCustomBrightness(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureLightProfileFactoryNode:GetCustomTextureMultiplier(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeTextureLightProfileFactoryNode:GetCustomBrightness(AttributeValue) end


---@class UInterchangeVolumeTextureFactoryNode : UInterchangeTextureFactoryNode
local UInterchangeVolumeTextureFactoryNode = {}


