---@meta

---@class AConstraintsActor : AActor
---@field ConstraintsManager UConstraintsManager
local AConstraintsActor = {}



---@class FConstraintAndActiveChannel
---@field ActiveChannel FMovieSceneConstraintChannel
---@field ConstraintCopyToSpawn UTickableConstraint
local FConstraintAndActiveChannel = {}



---@class FConstraintTickFunction : FTickFunction
local FConstraintTickFunction = {}


---@class FConstraintsInWorld
---@field World TWeakObjectPtr<UWorld>
---@field Constraints TArray<TWeakObjectPtr<UTickableConstraint>>
local FConstraintsInWorld = {}



---@class FMovieSceneConstraintChannel : FMovieSceneBoolChannel
local FMovieSceneConstraintChannel = {}


---@class UConstraintSubsystem : UEngineSubsystem
---@field OnConstraintAddedToSystem_BP FConstraintSubsystemOnConstraintAddedToSystem_BP
---@field OnConstraintRemovedFromSystem_BP FConstraintSubsystemOnConstraintRemovedFromSystem_BP
---@field ConstraintsInWorld TArray<FConstraintsInWorld>
local UConstraintSubsystem = {}

---@param Mananger UConstraintSubsystem
---@param Constraint UTickableConstraint
---@param bDoNotCompensate boolean
function UConstraintSubsystem:OnConstraintRemovedFromSystem__DelegateSignature(Mananger, Constraint, bDoNotCompensate) end
---@param Mananger UConstraintSubsystem
---@param Constraint UTickableConstraint
function UConstraintSubsystem:OnConstraintAddedToSystem__DelegateSignature(Mananger, Constraint) end


---@class UConstraintsManager : UObject
---@field OnConstraintAdded_BP FConstraintsManagerOnConstraintAdded_BP
---@field OnConstraintRemoved_BP FConstraintsManagerOnConstraintRemoved_BP
---@field Constraints TArray<UTickableConstraint>
local UConstraintsManager = {}

---@param Mananger UConstraintsManager
---@param Constraint UTickableConstraint
---@param bDoNotCompensate boolean
function UConstraintsManager:OnConstraintRemoved__DelegateSignature(Mananger, Constraint, bDoNotCompensate) end
---@param Mananger UConstraintsManager
---@param Constraint UTickableConstraint
function UConstraintsManager:OnConstraintAdded__DelegateSignature(Mananger, Constraint) end


---@class UConstraintsScriptingLibrary : UBlueprintFunctionLibrary
local UConstraintsScriptingLibrary = {}

---@param InWorld UWorld
---@param InTickableConstraint UTickableConstraint
---@return boolean
function UConstraintsScriptingLibrary:RemoveThisConstraint(InWorld, InTickableConstraint) end
---@param InWorld UWorld
---@param InIndex int32
---@return boolean
function UConstraintsScriptingLibrary:RemoveConstraint(InWorld, InIndex) end
---@param InWorld UWorld
---@return TArray<UTickableConstraint>
function UConstraintsScriptingLibrary:GetConstraintsArray(InWorld) end
---@param InWorld UWorld
---@param InObject UObject
---@param InAttachmentName FName
---@return UTransformableHandle
function UConstraintsScriptingLibrary:CreateTransformableHandle(InWorld, InObject, InAttachmentName) end
---@param InWorld UWorld
---@param InSceneComponent USceneComponent
---@param InSocketName FName
---@return UTransformableComponentHandle
function UConstraintsScriptingLibrary:CreateTransformableComponentHandle(InWorld, InSceneComponent, InSocketName) end
---@param InWorld UWorld
---@param InType ETransformConstraintType
---@return UTickableTransformConstraint
function UConstraintsScriptingLibrary:CreateFromType(InWorld, InType) end
---@param InWorld UWorld
---@param InParentHandle UTransformableHandle
---@param InChildHandle UTransformableHandle
---@param InConstraint UTickableTransformConstraint
---@param bMaintainOffset boolean
---@return boolean
function UConstraintsScriptingLibrary:AddConstraint(InWorld, InParentHandle, InChildHandle, InConstraint, bMaintainOffset) end


---@class UTickableConstraint : UObject
---@field Active boolean
---@field bValid boolean
local UTickableConstraint = {}



---@class UTickableLookAtConstraint : UTickableTransformConstraint
---@field Axis FVector
local UTickableLookAtConstraint = {}



---@class UTickableParentConstraint : UTickableTransformConstraint
---@field OffsetTransform FTransform
---@field bScaling boolean
---@field TransformFilter FTransformFilter
local UTickableParentConstraint = {}



---@class UTickableRotationConstraint : UTickableTransformConstraint
---@field OffsetRotation FQuat
---@field AxisFilter FFilterOptionPerAxis
local UTickableRotationConstraint = {}



---@class UTickableScaleConstraint : UTickableTransformConstraint
---@field OffsetScale FVector
---@field AxisFilter FFilterOptionPerAxis
local UTickableScaleConstraint = {}



---@class UTickableTransformConstraint : UTickableConstraint
---@field ParentTRSHandle UTransformableHandle
---@field ChildTRSHandle UTransformableHandle
---@field bMaintainOffset boolean
---@field Weight float
---@field bDynamicOffset boolean
---@field Type ETransformConstraintType
local UTickableTransformConstraint = {}



---@class UTickableTranslationConstraint : UTickableTransformConstraint
---@field OffsetTranslation FVector
---@field AxisFilter FFilterOptionPerAxis
local UTickableTranslationConstraint = {}



---@class UTransformableComponentHandle : UTransformableHandle
---@field Component TWeakObjectPtr<USceneComponent>
---@field SocketName FName
local UTransformableComponentHandle = {}



---@class UTransformableHandle : UObject
---@field ConstraintBindingID FMovieSceneObjectBindingID
local UTransformableHandle = {}



