---@meta

---@class FLiveLinkTransformControllerData
---@field bWorldTransform boolean
---@field bUseLocation boolean
---@field bUseRotation boolean
---@field bUseScale boolean
---@field bSweep boolean
---@field bTeleport boolean
local FLiveLinkTransformControllerData = {}



---@class ULiveLinkComponentController : UActorComponent
---@field SubjectRepresentation FLiveLinkSubjectRepresentation
---@field ControllerMap TMap<TSubclassOf<ULiveLinkRole>, ULiveLinkControllerBase>
---@field bUpdateInEditor boolean
---@field OnLiveLinkUpdated FLiveLinkComponentControllerOnLiveLinkUpdated
---@field OnControllerMapUpdatedDelegate FLiveLinkComponentControllerOnControllerMapUpdatedDelegate
---@field bDisableEvaluateLiveLinkWhenSpawnable boolean
---@field bEvaluateLiveLink boolean
---@field bUpdateInPreviewEditor boolean
local ULiveLinkComponentController = {}

---@param InSubjectRepresentation FLiveLinkSubjectRepresentation
function ULiveLinkComponentController:SetSubjectRepresentation(InSubjectRepresentation) end
---@param InRoleClass TSubclassOf<ULiveLinkRole>
---@param InComponent UActorComponent
function ULiveLinkComponentController:SetControlledComponent(InRoleClass, InComponent) end
---@return FLiveLinkSubjectRepresentation
function ULiveLinkComponentController:GetSubjectRepresentation() end
---@param InRoleClass TSubclassOf<ULiveLinkRole>
---@return UActorComponent
function ULiveLinkComponentController:GetControlledComponent(InRoleClass) end


---@class ULiveLinkComponentSettings : UObject
---@field DefaultControllerForRole TMap<TSubclassOf<ULiveLinkRole>, TSubclassOf<ULiveLinkControllerBase>>
---@field bUpdateSubjectsImmediatelyInPIE boolean
local ULiveLinkComponentSettings = {}



---@class ULiveLinkControllerBase : UObject
---@field ComponentPicker FComponentReference
local ULiveLinkControllerBase = {}



---@class ULiveLinkLightController : ULiveLinkControllerBase
local ULiveLinkLightController = {}


---@class ULiveLinkTransformController : ULiveLinkControllerBase
---@field TransformData FLiveLinkTransformControllerData
---@field OffsetTransform FTransform
local ULiveLinkTransformController = {}



