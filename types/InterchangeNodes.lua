---@meta

---@class FInterchangeAnimationPayLoadKey
---@field UniqueID FString
---@field Type EInterchangeAnimationPayLoadType
local FInterchangeAnimationPayLoadKey = {}



---@class FInterchangeMeshPayLoadKey
---@field UniqueID FString
---@field Type EInterchangeMeshPayLoadType
local FInterchangeMeshPayLoadKey = {}



---@class UInterchangeAnimationTrackBaseNode : UInterchangeBaseNode
local UInterchangeAnimationTrackBaseNode = {}

---@param AttributeValue int32
---@return boolean
function UInterchangeAnimationTrackBaseNode:SetCustomCompletionMode(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeAnimationTrackBaseNode:GetCustomCompletionMode(AttributeValue) end


---@class UInterchangeAnimationTrackNode : UInterchangeAnimationTrackBaseNode
local UInterchangeAnimationTrackNode = {}

---@param PropertyTrack EInterchangePropertyTracks
---@return boolean
function UInterchangeAnimationTrackNode:SetCustomPropertyTrack(PropertyTrack) end
---@param AttributeValue int32
---@return boolean
function UInterchangeAnimationTrackNode:SetCustomFrameCount(AttributeValue) end
---@param InUniqueId FString
---@param InType EInterchangeAnimationPayLoadType
---@return boolean
function UInterchangeAnimationTrackNode:SetCustomAnimationPayloadKey(InUniqueId, InType) end
---@param DependencyUid FString
---@return boolean
function UInterchangeAnimationTrackNode:SetCustomActorDependencyUid(DependencyUid) end
---@param PropertyTrack EInterchangePropertyTracks
---@return boolean
function UInterchangeAnimationTrackNode:GetCustomPropertyTrack(PropertyTrack) end
---@param AttributeValue int32
---@return boolean
function UInterchangeAnimationTrackNode:GetCustomFrameCount(AttributeValue) end
---@param AnimationPayLoadKey FInterchangeAnimationPayLoadKey
---@return boolean
function UInterchangeAnimationTrackNode:GetCustomAnimationPayloadKey(AnimationPayLoadKey) end
---@param DependencyUid FString
---@return boolean
function UInterchangeAnimationTrackNode:GetCustomActorDependencyUid(DependencyUid) end


---@class UInterchangeAnimationTrackSetInstanceNode : UInterchangeAnimationTrackBaseNode
local UInterchangeAnimationTrackSetInstanceNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeAnimationTrackSetInstanceNode:SetCustomTrackSetDependencyUid(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeAnimationTrackSetInstanceNode:SetCustomTimeScale(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeAnimationTrackSetInstanceNode:SetCustomStartFrame(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeAnimationTrackSetInstanceNode:SetCustomDuration(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeAnimationTrackSetInstanceNode:GetCustomTrackSetDependencyUid(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeAnimationTrackSetInstanceNode:GetCustomTimeScale(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeAnimationTrackSetInstanceNode:GetCustomStartFrame(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeAnimationTrackSetInstanceNode:GetCustomDuration(AttributeValue) end


---@class UInterchangeAnimationTrackSetNode : UInterchangeBaseNode
local UInterchangeAnimationTrackSetNode = {}

---@param AttributeValue float
---@return boolean
function UInterchangeAnimationTrackSetNode:SetCustomFrameRate(AttributeValue) end
---@param AnimationTrackUid FString
---@return boolean
function UInterchangeAnimationTrackSetNode:RemoveCustomAnimationTrackUid(AnimationTrackUid) end
---@param AttributeValue float
---@return boolean
function UInterchangeAnimationTrackSetNode:GetCustomFrameRate(AttributeValue) end
---@param OutAnimationTrackUids TArray<FString>
function UInterchangeAnimationTrackSetNode:GetCustomAnimationTrackUids(OutAnimationTrackUids) end
---@return int32
function UInterchangeAnimationTrackSetNode:GetCustomAnimationTrackUidCount() end
---@param Index int32
---@param OutAnimationTrackUid FString
function UInterchangeAnimationTrackSetNode:GetCustomAnimationTrackUid(Index, OutAnimationTrackUid) end
---@param AnimationTrackUid FString
---@return boolean
function UInterchangeAnimationTrackSetNode:AddCustomAnimationTrackUid(AnimationTrackUid) end


---@class UInterchangeBaseLightNode : UInterchangeBaseNode
local UInterchangeBaseLightNode = {}

---@param AttributeValue boolean
---@return boolean
function UInterchangeBaseLightNode:SetCustomUseTemperature(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeBaseLightNode:SetCustomTemperature(AttributeValue) end
---@param AttributeValue FLinearColor
---@return boolean
function UInterchangeBaseLightNode:SetCustomLightColor(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeBaseLightNode:SetCustomIntensity(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeBaseLightNode:GetCustomUseTemperature(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeBaseLightNode:GetCustomTemperature(AttributeValue) end
---@param AttributeValue FLinearColor
---@return boolean
function UInterchangeBaseLightNode:GetCustomLightColor(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeBaseLightNode:GetCustomIntensity(AttributeValue) end


---@class UInterchangeDecalMaterialNode : UInterchangeShaderNode
local UInterchangeDecalMaterialNode = {}


---@class UInterchangeDecalNode : UInterchangeBaseNode
local UInterchangeDecalNode = {}

---@param AttributeValue int32
---@return boolean
function UInterchangeDecalNode:SetCustomSortOrder(AttributeValue) end
---@param AttributeValue FVector
---@return boolean
function UInterchangeDecalNode:SetCustomDecalSize(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeDecalNode:SetCustomDecalMaterialPathName(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeDecalNode:GetCustomSortOrder(AttributeValue) end
---@param AttributeValue FVector
---@return boolean
function UInterchangeDecalNode:GetCustomDecalSize(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeDecalNode:GetCustomDecalMaterialPathName(AttributeValue) end


---@class UInterchangeDirectionalLightNode : UInterchangeBaseLightNode
local UInterchangeDirectionalLightNode = {}


---@class UInterchangeFunctionCallShaderNode : UInterchangeShaderNode
local UInterchangeFunctionCallShaderNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeFunctionCallShaderNode:SetCustomMaterialFunction(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeFunctionCallShaderNode:GetCustomMaterialFunction(AttributeValue) end


---@class UInterchangeLightNode : UInterchangeBaseLightNode
local UInterchangeLightNode = {}

---@param AttributeValue boolean
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeLightNode:SetCustomUseIESBrightness(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue FRotator
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeLightNode:SetCustomRotation(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue EInterchangeLightUnits
---@return boolean
function UInterchangeLightNode:SetCustomIntensityUnits(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeLightNode:SetCustomIESTexture(AttributeValue) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeLightNode:SetCustomIESBrightnessScale(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue float
---@return boolean
function UInterchangeLightNode:SetCustomAttenuationRadius(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeLightNode:GetCustomUseIESBrightness(AttributeValue) end
---@param AttributeValue FRotator
---@return boolean
function UInterchangeLightNode:GetCustomRotation(AttributeValue) end
---@param AttributeValue EInterchangeLightUnits
---@return boolean
function UInterchangeLightNode:GetCustomIntensityUnits(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeLightNode:GetCustomIESTexture(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeLightNode:GetCustomIESBrightnessScale(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeLightNode:GetCustomAttenuationRadius(AttributeValue) end


---@class UInterchangeMaterialInstanceNode : UInterchangeBaseNode
local UInterchangeMaterialInstanceNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialInstanceNode:SetCustomParent(AttributeValue) end
---@param ParameterName FString
---@param AttributeValue FLinearColor
---@return boolean
function UInterchangeMaterialInstanceNode:GetVectorParameterValue(ParameterName, AttributeValue) end
---@param ParameterName FString
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialInstanceNode:GetTextureParameterValue(ParameterName, AttributeValue) end
---@param ParameterName FString
---@param AttributeValue boolean
---@return boolean
function UInterchangeMaterialInstanceNode:GetStaticSwitchParameterValue(ParameterName, AttributeValue) end
---@param ParameterName FString
---@param AttributeValue float
---@return boolean
function UInterchangeMaterialInstanceNode:GetScalarParameterValue(ParameterName, AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialInstanceNode:GetCustomParent(AttributeValue) end
---@param ParameterName FString
---@param AttributeValue FLinearColor
---@return boolean
function UInterchangeMaterialInstanceNode:AddVectorParameterValue(ParameterName, AttributeValue) end
---@param ParameterName FString
---@param AttributeValue FString
---@return boolean
function UInterchangeMaterialInstanceNode:AddTextureParameterValue(ParameterName, AttributeValue) end
---@param ParameterName FString
---@param AttributeValue boolean
---@return boolean
function UInterchangeMaterialInstanceNode:AddStaticSwitchParameterValue(ParameterName, AttributeValue) end
---@param ParameterName FString
---@param AttributeValue float
---@return boolean
function UInterchangeMaterialInstanceNode:AddScalarParameterValue(ParameterName, AttributeValue) end


---@class UInterchangeMeshNode : UInterchangeBaseNode
local UInterchangeMeshNode = {}

---@param SlotName FString
---@param MaterialDependencyUid FString
---@return boolean
function UInterchangeMeshNode:SetSlotMaterialDependencyUid(SlotName, MaterialDependencyUid) end
---@param bIsSkinnedMesh boolean
---@return boolean
function UInterchangeMeshNode:SetSkinnedMesh(bIsSkinnedMesh) end
---@param DependencyUid FString
---@return boolean
function UInterchangeMeshNode:SetSkeletonDependencyUid(DependencyUid) end
---@param DependencyUid FString
---@return boolean
function UInterchangeMeshNode:SetSceneInstanceUid(DependencyUid) end
---@param PayloadKey FString
---@param PayloadType EInterchangeMeshPayLoadType
function UInterchangeMeshNode:SetPayLoadKey(PayloadKey, PayloadType) end
---@param MorphTargetName FString
---@return boolean
function UInterchangeMeshNode:SetMorphTargetName(MorphTargetName) end
---@param DependencyUid FString
---@return boolean
function UInterchangeMeshNode:SetMorphTargetDependencyUid(DependencyUid) end
---@param bIsMorphTarget boolean
---@return boolean
function UInterchangeMeshNode:SetMorphTarget(bIsMorphTarget) end
---@param AttributeValue int32
---@return boolean
function UInterchangeMeshNode:SetCustomVertexCount(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeMeshNode:SetCustomUVCount(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeMeshNode:SetCustomPolygonCount(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshNode:SetCustomHasVertexTangent(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshNode:SetCustomHasVertexNormal(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshNode:SetCustomHasVertexColor(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshNode:SetCustomHasVertexBinormal(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshNode:SetCustomHasSmoothGroup(AttributeValue) end
---@param AttributeValue FBox
---@return boolean
function UInterchangeMeshNode:SetCustomBoundingBox(AttributeValue) end
---@param SlotName FString
---@return boolean
function UInterchangeMeshNode:RemoveSlotMaterialDependencyUid(SlotName) end
---@param DependencyUid FString
---@return boolean
function UInterchangeMeshNode:RemoveSkeletonDependencyUid(DependencyUid) end
---@param DependencyUid FString
---@return boolean
function UInterchangeMeshNode:RemoveSceneInstanceUid(DependencyUid) end
---@param DependencyUid FString
---@return boolean
function UInterchangeMeshNode:RemoveMorphTargetDependencyUid(DependencyUid) end
---@return boolean
function UInterchangeMeshNode:IsSkinnedMesh() end
---@return boolean
function UInterchangeMeshNode:IsMorphTarget() end
---@param SlotName FString
---@param OutMaterialDependency FString
---@return boolean
function UInterchangeMeshNode:GetSlotMaterialDependencyUid(SlotName, OutMaterialDependency) end
---@param OutMaterialDependencies TMap<FString, FString>
function UInterchangeMeshNode:GetSlotMaterialDependencies(OutMaterialDependencies) end
---@param Index int32
---@param OutDependency FString
function UInterchangeMeshNode:GetSkeletonDependency(Index, OutDependency) end
---@param OutDependencies TArray<FString>
function UInterchangeMeshNode:GetSkeletonDependencies(OutDependencies) end
---@return int32
function UInterchangeMeshNode:GetSkeletonDependeciesCount() end
---@return int32
function UInterchangeMeshNode:GetSceneInstanceUidsCount() end
---@param OutDependencies TArray<FString>
function UInterchangeMeshNode:GetSceneInstanceUids(OutDependencies) end
---@param Index int32
---@param OutDependency FString
function UInterchangeMeshNode:GetSceneInstanceUid(Index, OutDependency) end
---@param OutMorphTargetName FString
---@return boolean
function UInterchangeMeshNode:GetMorphTargetName(OutMorphTargetName) end
---@param Index int32
---@param OutDependency FString
function UInterchangeMeshNode:GetMorphTargetDependency(Index, OutDependency) end
---@param OutDependencies TArray<FString>
function UInterchangeMeshNode:GetMorphTargetDependencies(OutDependencies) end
---@return int32
function UInterchangeMeshNode:GetMorphTargetDependeciesCount() end
---@param AttributeValue int32
---@return boolean
function UInterchangeMeshNode:GetCustomVertexCount(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeMeshNode:GetCustomUVCount(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeMeshNode:GetCustomPolygonCount(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshNode:GetCustomHasVertexTangent(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshNode:GetCustomHasVertexNormal(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshNode:GetCustomHasVertexColor(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshNode:GetCustomHasVertexBinormal(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeMeshNode:GetCustomHasSmoothGroup(AttributeValue) end
---@param AttributeValue FBox
---@return boolean
function UInterchangeMeshNode:GetCustomBoundingBox(AttributeValue) end


---@class UInterchangePhysicalCameraNode : UInterchangeBaseNode
local UInterchangePhysicalCameraNode = {}

---@param AttributeValue float
---@return boolean
function UInterchangePhysicalCameraNode:SetCustomSensorWidth(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangePhysicalCameraNode:SetCustomSensorHeight(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangePhysicalCameraNode:SetCustomFocalLength(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangePhysicalCameraNode:SetCustomEnableDepthOfField(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangePhysicalCameraNode:GetCustomSensorWidth(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangePhysicalCameraNode:GetCustomSensorHeight(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangePhysicalCameraNode:GetCustomFocalLength(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangePhysicalCameraNode:GetCustomEnableDepthOfField(AttributeValue) end


---@class UInterchangePointLightNode : UInterchangeLightNode
local UInterchangePointLightNode = {}

---@param AttributeValue boolean
---@return boolean
function UInterchangePointLightNode:SetCustomUseInverseSquaredFalloff(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangePointLightNode:SetCustomLightFalloffExponent(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangePointLightNode:GetCustomUseInverseSquaredFalloff(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangePointLightNode:GetCustomLightFalloffExponent(AttributeValue) end


---@class UInterchangeRectLightNode : UInterchangeLightNode
local UInterchangeRectLightNode = {}

---@param AttributeValue float
---@return boolean
function UInterchangeRectLightNode:SetCustomSourceWidth(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeRectLightNode:SetCustomSourceHeight(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeRectLightNode:GetCustomSourceWidth(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeRectLightNode:GetCustomSourceHeight(AttributeValue) end


---@class UInterchangeSceneNode : UInterchangeBaseNode
local UInterchangeSceneNode = {}

---@param SlotName FString
---@param MaterialDependencyUid FString
---@return boolean
function UInterchangeSceneNode:SetSlotMaterialDependencyUid(SlotName, MaterialDependencyUid) end
---@param MorphTargetName FString
---@param Weight float
---@return boolean
function UInterchangeSceneNode:SetMorphTargetCurveWeight(MorphTargetName, Weight) end
---@param GlobalBindPoseReferenceForMeshUIDs TMap<FString, FMatrix>
function UInterchangeSceneNode:SetGlobalBindPoseReferenceForMeshUIDs(GlobalBindPoseReferenceForMeshUIDs) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param AttributeValue FTransform
---@param bResetCache boolean
---@return boolean
function UInterchangeSceneNode:SetCustomTimeZeroLocalTransform(BaseNodeContainer, AttributeValue, bResetCache) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeSceneNode:SetCustomPivotNodeTransform(AttributeValue) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param AttributeValue FTransform
---@param bResetCache boolean
---@return boolean
function UInterchangeSceneNode:SetCustomLocalTransform(BaseNodeContainer, AttributeValue, bResetCache) end
---@param bHasBindPose boolean
---@return boolean
function UInterchangeSceneNode:SetCustomHasBindPose(bHasBindPose) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeSceneNode:SetCustomGeometricTransform(AttributeValue) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param AttributeValue FTransform
---@param bResetCache boolean
---@return boolean
function UInterchangeSceneNode:SetCustomBindPoseLocalTransform(BaseNodeContainer, AttributeValue, bResetCache) end
---@param AttributeValue FString
---@return boolean
function UInterchangeSceneNode:SetCustomAssetInstanceUid(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeSceneNode:SetCustomAnimationAssetUidToPlay(AttributeValue) end
---@param SpecializedType FString
---@return boolean
function UInterchangeSceneNode:RemoveSpecializedType(SpecializedType) end
---@param SlotName FString
---@return boolean
function UInterchangeSceneNode:RemoveSlotMaterialDependencyUid(SlotName) end
---@param SpecializedType FString
---@return boolean
function UInterchangeSceneNode:IsSpecializedTypeContains(SpecializedType) end
---@param OutSpecializedTypes TArray<FString>
function UInterchangeSceneNode:GetSpecializedTypes(OutSpecializedTypes) end
---@return int32
function UInterchangeSceneNode:GetSpecializedTypeCount() end
---@param Index int32
---@param OutSpecializedType FString
function UInterchangeSceneNode:GetSpecializedType(Index, OutSpecializedType) end
---@param SlotName FString
---@param OutMaterialDependency FString
---@return boolean
function UInterchangeSceneNode:GetSlotMaterialDependencyUid(SlotName, OutMaterialDependency) end
---@param OutMaterialDependencies TMap<FString, FString>
function UInterchangeSceneNode:GetSlotMaterialDependencies(OutMaterialDependencies) end
---@param OutMorphTargetCurveWeights TMap<FString, float>
function UInterchangeSceneNode:GetMorphTargetCurveWeights(OutMorphTargetCurveWeights) end
---@param MeshUid FString
---@param GlobalBindPoseReference FMatrix
---@return boolean
function UInterchangeSceneNode:GetGlobalBindPoseReferenceForMeshUID(MeshUid, GlobalBindPoseReference) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeSceneNode:GetCustomTimeZeroLocalTransform(AttributeValue) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param GlobalOffsetTransform FTransform
---@param AttributeValue FTransform
---@param bForceRecache boolean
---@return boolean
function UInterchangeSceneNode:GetCustomTimeZeroGlobalTransform(BaseNodeContainer, GlobalOffsetTransform, AttributeValue, bForceRecache) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeSceneNode:GetCustomPivotNodeTransform(AttributeValue) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeSceneNode:GetCustomLocalTransform(AttributeValue) end
---@param bHasBindPose boolean
---@return boolean
function UInterchangeSceneNode:GetCustomHasBindPose(bHasBindPose) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param GlobalOffsetTransform FTransform
---@param AttributeValue FTransform
---@param bForceRecache boolean
---@return boolean
function UInterchangeSceneNode:GetCustomGlobalTransform(BaseNodeContainer, GlobalOffsetTransform, AttributeValue, bForceRecache) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeSceneNode:GetCustomGeometricTransform(AttributeValue) end
---@param AttributeValue FTransform
---@return boolean
function UInterchangeSceneNode:GetCustomBindPoseLocalTransform(AttributeValue) end
---@param BaseNodeContainer UInterchangeBaseNodeContainer
---@param GlobalOffsetTransform FTransform
---@param AttributeValue FTransform
---@param bForceRecache boolean
---@return boolean
function UInterchangeSceneNode:GetCustomBindPoseGlobalTransform(BaseNodeContainer, GlobalOffsetTransform, AttributeValue, bForceRecache) end
---@param AttributeValue FString
---@return boolean
function UInterchangeSceneNode:GetCustomAssetInstanceUid(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeSceneNode:GetCustomAnimationAssetUidToPlay(AttributeValue) end
---@param SpecializedType FString
---@return boolean
function UInterchangeSceneNode:AddSpecializedType(SpecializedType) end


---@class UInterchangeSceneVariantSetsNode : UInterchangeBaseNode
local UInterchangeSceneVariantSetsNode = {}

---@param VariantUid FString
---@return boolean
function UInterchangeSceneVariantSetsNode:RemoveCustomVariantSetUid(VariantUid) end
---@param OutVariantUids TArray<FString>
function UInterchangeSceneVariantSetsNode:GetCustomVariantSetUids(OutVariantUids) end
---@return int32
function UInterchangeSceneVariantSetsNode:GetCustomVariantSetUidCount() end
---@param Index int32
---@param OutVariantUid FString
function UInterchangeSceneVariantSetsNode:GetCustomVariantSetUid(Index, OutVariantUid) end
---@param VariantUid FString
---@return boolean
function UInterchangeSceneVariantSetsNode:AddCustomVariantSetUid(VariantUid) end


---@class UInterchangeShaderGraphNode : UInterchangeShaderNode
local UInterchangeShaderGraphNode = {}

---@param AttributeValue boolean
---@return boolean
function UInterchangeShaderGraphNode:SetCustomTwoSidedTransmission(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeShaderGraphNode:SetCustomTwoSided(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeShaderGraphNode:SetCustomScreenSpaceReflections(AttributeValue) end
---@param AttributeValue float
---@param bAddApplyDelegate boolean
---@return boolean
function UInterchangeShaderGraphNode:SetCustomOpacityMaskClipValue(AttributeValue, bAddApplyDelegate) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeShaderGraphNode:SetCustomIsAShaderFunction(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeShaderGraphNode:SetCustomBlendMode(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeShaderGraphNode:GetCustomTwoSidedTransmission(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeShaderGraphNode:GetCustomTwoSided(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeShaderGraphNode:GetCustomScreenSpaceReflections(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeShaderGraphNode:GetCustomOpacityMaskClipValue(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeShaderGraphNode:GetCustomIsAShaderFunction(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeShaderGraphNode:GetCustomBlendMode(AttributeValue) end


---@class UInterchangeShaderNode : UInterchangeBaseNode
local UInterchangeShaderNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeShaderNode:SetCustomShaderType(AttributeValue) end
---@param AttributeValue FString
---@return boolean
function UInterchangeShaderNode:GetCustomShaderType(AttributeValue) end
---@param InputName FString
---@param AttributeValue FString
---@param bIsAParameter boolean
---@return boolean
function UInterchangeShaderNode:AddStringInput(InputName, AttributeValue, bIsAParameter) end
---@param InputName FString
---@param AttributeValue FLinearColor
---@param bIsAParameter boolean
---@return boolean
function UInterchangeShaderNode:AddLinearColorInput(InputName, AttributeValue, bIsAParameter) end
---@param InputName FString
---@param AttributeValue float
---@param bIsAParameter boolean
---@return boolean
function UInterchangeShaderNode:AddFloatInput(InputName, AttributeValue, bIsAParameter) end


---@class UInterchangeShaderPortsAPI : UObject
local UInterchangeShaderPortsAPI = {}

---@param InputName FString
---@return FString
function UInterchangeShaderPortsAPI:MakeInputValueKey(InputName) end
---@param InputName FString
---@return FString
function UInterchangeShaderPortsAPI:MakeInputParameterKey(InputName) end
---@param InputKey FString
---@return FString
function UInterchangeShaderPortsAPI:MakeInputName(InputKey) end
---@param InputName FString
---@return FString
function UInterchangeShaderPortsAPI:MakeInputConnectionKey(InputName) end
---@param AttributeKey FString
---@return boolean
function UInterchangeShaderPortsAPI:IsAParameter(AttributeKey) end
---@param AttributeKey FString
---@return boolean
function UInterchangeShaderPortsAPI:IsAnInput(AttributeKey) end
---@param InterchangeNode UInterchangeBaseNode
---@param InInputName FName
---@return boolean
function UInterchangeShaderPortsAPI:HasParameter(InterchangeNode, InInputName) end
---@param InterchangeNode UInterchangeBaseNode
---@param InInputName FName
---@return boolean
function UInterchangeShaderPortsAPI:HasInput(InterchangeNode, InInputName) end
---@param InterchangeNode UInterchangeBaseNode
---@param InputName FString
---@param OutExpressionUid FString
---@param OutputName FString
---@return boolean
function UInterchangeShaderPortsAPI:GetInputConnection(InterchangeNode, InputName, OutExpressionUid, OutputName) end
---@param InterchangeNode UInterchangeBaseNode
---@param OutInputNames TArray<FString>
function UInterchangeShaderPortsAPI:GatherInputs(InterchangeNode, OutInputNames) end
---@param InterchangeNode UInterchangeBaseNode
---@param InputName FString
---@param ExpressionUid FString
---@param OutputName FString
---@return boolean
function UInterchangeShaderPortsAPI:ConnectOuputToInputByName(InterchangeNode, InputName, ExpressionUid, OutputName) end
---@param InterchangeNode UInterchangeBaseNode
---@param InputName FString
---@param ExpressionUid FString
---@param OutputIndex int32
---@return boolean
function UInterchangeShaderPortsAPI:ConnectOuputToInputByIndex(InterchangeNode, InputName, ExpressionUid, OutputIndex) end
---@param InterchangeNode UInterchangeBaseNode
---@param InputName FString
---@param ExpressionUid FString
---@return boolean
function UInterchangeShaderPortsAPI:ConnectDefaultOuputToInput(InterchangeNode, InputName, ExpressionUid) end


---@class UInterchangeSkeletalAnimationTrackNode : UInterchangeAnimationTrackBaseNode
local UInterchangeSkeletalAnimationTrackNode = {}

---@param AttributeValue FString
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:SetCustomSkeletonNodeUid(AttributeValue) end
---@param StopTime double
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:SetCustomAnimationStopTime(StopTime) end
---@param StartTime double
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:SetCustomAnimationStartTime(StartTime) end
---@param SampleRate double
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:SetCustomAnimationSampleRate(SampleRate) end
---@param SceneNodeUid FString
---@param InUniqueId FString
---@param InType EInterchangeAnimationPayLoadType
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:SetAnimationPayloadKeyForSceneNodeUid(SceneNodeUid, InUniqueId, InType) end
---@param MorphTargetNodeUid FString
---@param InUniqueId FString
---@param InType EInterchangeAnimationPayLoadType
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:SetAnimationPayloadKeyForMorphTargetNodeUid(MorphTargetNodeUid, InUniqueId, InType) end
---@param SceneNodeUid FString
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:IsNodeAnimatedWithBakedCurve(SceneNodeUid) end
---@param OutSceneNodeAnimationPayloadKeyUids TMap<FString, FString>
---@param OutSceneNodeAnimationPayloadKeyTypes TMap<FString, uint8>
function UInterchangeSkeletalAnimationTrackNode:GetSceneNodeAnimationPayloadKeys(OutSceneNodeAnimationPayloadKeyUids, OutSceneNodeAnimationPayloadKeyTypes) end
---@param OutMorphTargetNodeAnimationPayloadKeyUids TMap<FString, FString>
---@param OutMorphTargetNodeAnimationPayloadKeyTypes TMap<FString, uint8>
function UInterchangeSkeletalAnimationTrackNode:GetMorphTargetNodeAnimationPayloadKeys(OutMorphTargetNodeAnimationPayloadKeyUids, OutMorphTargetNodeAnimationPayloadKeyTypes) end
---@param AttributeValue FString
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:GetCustomSkeletonNodeUid(AttributeValue) end
---@param StopTime double
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:GetCustomAnimationStopTime(StopTime) end
---@param StartTime double
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:GetCustomAnimationStartTime(StartTime) end
---@param SampleRate double
---@return boolean
function UInterchangeSkeletalAnimationTrackNode:GetCustomAnimationSampleRate(SampleRate) end


---@class UInterchangeSpotLightNode : UInterchangePointLightNode
local UInterchangeSpotLightNode = {}

---@param AttributeValue float
---@return boolean
function UInterchangeSpotLightNode:SetCustomOuterConeAngle(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeSpotLightNode:SetCustomInnerConeAngle(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeSpotLightNode:GetCustomOuterConeAngle(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeSpotLightNode:GetCustomInnerConeAngle(AttributeValue) end


---@class UInterchangeStandardCameraNode : UInterchangeBaseNode
local UInterchangeStandardCameraNode = {}

---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraNode:SetCustomWidth(AttributeValue) end
---@param AttributeValue EInterchangeCameraProjectionType
---@return boolean
function UInterchangeStandardCameraNode:SetCustomProjectionMode(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraNode:SetCustomNearClipPlane(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraNode:SetCustomFieldOfView(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraNode:SetCustomFarClipPlane(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraNode:SetCustomAspectRatio(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraNode:GetCustomWidth(AttributeValue) end
---@param AttributeValue EInterchangeCameraProjectionType
---@return boolean
function UInterchangeStandardCameraNode:GetCustomProjectionMode(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraNode:GetCustomNearClipPlane(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraNode:GetCustomFieldOfView(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraNode:GetCustomFarClipPlane(AttributeValue) end
---@param AttributeValue float
---@return boolean
function UInterchangeStandardCameraNode:GetCustomAspectRatio(AttributeValue) end


---@class UInterchangeTexture2DArrayNode : UInterchangeTextureNode
local UInterchangeTexture2DArrayNode = {}


---@class UInterchangeTexture2DNode : UInterchangeTextureNode
local UInterchangeTexture2DNode = {}

---@param AttributeValue EInterchangeTextureWrapMode
---@return boolean
function UInterchangeTexture2DNode:SetCustomWrapV(AttributeValue) end
---@param AttributeValue EInterchangeTextureWrapMode
---@return boolean
function UInterchangeTexture2DNode:SetCustomWrapU(AttributeValue) end
---@return TMap<int32, FString>
function UInterchangeTexture2DNode:GetSourceBlocks() end
---@param AttributeValue EInterchangeTextureWrapMode
---@return boolean
function UInterchangeTexture2DNode:GetCustomWrapV(AttributeValue) end
---@param AttributeValue EInterchangeTextureWrapMode
---@return boolean
function UInterchangeTexture2DNode:GetCustomWrapU(AttributeValue) end


---@class UInterchangeTextureBlurNode : UInterchangeTexture2DNode
local UInterchangeTextureBlurNode = {}


---@class UInterchangeTextureCubeArrayNode : UInterchangeTextureNode
local UInterchangeTextureCubeArrayNode = {}


---@class UInterchangeTextureCubeNode : UInterchangeTextureNode
local UInterchangeTextureCubeNode = {}


---@class UInterchangeTextureLightProfileNode : UInterchangeTextureNode
local UInterchangeTextureLightProfileNode = {}


---@class UInterchangeTextureNode : UInterchangeBaseNode
local UInterchangeTextureNode = {}

---@param PayloadKey FString
function UInterchangeTextureNode:SetPayLoadKey(PayloadKey) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureNode:SetCustomSRGB(AttributeValue) end
---@param AttributeValue EInterchangeTextureFilterMode
---@return boolean
function UInterchangeTextureNode:SetCustomFilter(AttributeValue) end
---@param AttributeValue EInterchangeTextureColorSpace
---@return boolean
function UInterchangeTextureNode:SetCustomColorSpace(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureNode:SetCustombFlipGreenChannel(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureNode:GetCustomSRGB(AttributeValue) end
---@param AttributeValue EInterchangeTextureFilterMode
---@return boolean
function UInterchangeTextureNode:GetCustomFilter(AttributeValue) end
---@param AttributeValue EInterchangeTextureColorSpace
---@return boolean
function UInterchangeTextureNode:GetCustomColorSpace(AttributeValue) end
---@param AttributeValue boolean
---@return boolean
function UInterchangeTextureNode:GetCustombFlipGreenChannel(AttributeValue) end


---@class UInterchangeTransformAnimationTrackNode : UInterchangeAnimationTrackNode
local UInterchangeTransformAnimationTrackNode = {}

---@param AttributeValue int32
---@return boolean
function UInterchangeTransformAnimationTrackNode:SetCustomUsedChannels(AttributeValue) end
---@param AttributeValue int32
---@return boolean
function UInterchangeTransformAnimationTrackNode:GetCustomUsedChannels(AttributeValue) end


---@class UInterchangeVariantSetNode : UInterchangeBaseNode
local UInterchangeVariantSetNode = {}

---@param PayloadKey FString
---@return boolean
function UInterchangeVariantSetNode:SetCustomVariantsPayloadKey(PayloadKey) end
---@param AttributeValue FString
---@return boolean
function UInterchangeVariantSetNode:SetCustomDisplayText(AttributeValue) end
---@param DependencyUid FString
---@return boolean
function UInterchangeVariantSetNode:RemoveCustomDependencyUid(DependencyUid) end
---@param PayloadKey FString
---@return boolean
function UInterchangeVariantSetNode:GetCustomVariantsPayloadKey(PayloadKey) end
---@param AttributeValue FString
---@return boolean
function UInterchangeVariantSetNode:GetCustomDisplayText(AttributeValue) end
---@param OutDependencyUids TArray<FString>
function UInterchangeVariantSetNode:GetCustomDependencyUids(OutDependencyUids) end
---@return int32
function UInterchangeVariantSetNode:GetCustomDependencyUidCount() end
---@param Index int32
---@param OutDependencyUid FString
function UInterchangeVariantSetNode:GetCustomDependencyUid(Index, OutDependencyUid) end
---@param DependencyUid FString
---@return boolean
function UInterchangeVariantSetNode:AddCustomDependencyUid(DependencyUid) end


---@class UInterchangeVolumeTextureNode : UInterchangeTextureNode
local UInterchangeVolumeTextureNode = {}


