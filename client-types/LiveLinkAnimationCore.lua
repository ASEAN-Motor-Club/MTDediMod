---@meta

---@class FAnimNode_LiveLinkPose : FAnimNode_Base
---@field InputPose FPoseLink
---@field LiveLinkSubjectName FLiveLinkSubjectName
---@field bDoLiveLinkEvaluation boolean
---@field RetargetAsset TSubclassOf<ULiveLinkRetargetAsset>
---@field CurrentRetargetAsset ULiveLinkRetargetAsset
local FAnimNode_LiveLinkPose = {}



---@class FLiveLinkInstanceProxy : FAnimInstanceProxy
---@field PoseNode FAnimNode_LiveLinkPose
local FLiveLinkInstanceProxy = {}



---@class ULiveLinkInstance : UAnimInstance
---@field CurrentRetargetAsset ULiveLinkRetargetAsset
local ULiveLinkInstance = {}

---@param SubjectName FLiveLinkSubjectName
function ULiveLinkInstance:SetSubject(SubjectName) end
---@param RetargetAsset TSubclassOf<ULiveLinkRetargetAsset>
function ULiveLinkInstance:SetRetargetAsset(RetargetAsset) end
---@param bDoEnable boolean
function ULiveLinkInstance:EnableLiveLinkEvaluation(bDoEnable) end


---@class ULiveLinkRemapAsset : ULiveLinkRetargetAsset
local ULiveLinkRemapAsset = {}

---@param CurveItems TMap<FName, float>
function ULiveLinkRemapAsset:RemapCurveElements(CurveItems) end
---@param CurveName FName
---@return FName
function ULiveLinkRemapAsset:GetRemappedCurveName(CurveName) end
---@param BoneName FName
---@return FName
function ULiveLinkRemapAsset:GetRemappedBoneName(BoneName) end


---@class ULiveLinkRetargetAsset : UObject
local ULiveLinkRetargetAsset = {}


