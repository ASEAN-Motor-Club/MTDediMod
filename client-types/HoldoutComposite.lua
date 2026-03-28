---@meta

---@class UHoldoutCompositeComponent : USceneComponent
---@field bIsEnabled boolean
local UHoldoutCompositeComponent = {}

---@param bInEnabled boolean
function UHoldoutCompositeComponent:SetEnabled(bInEnabled) end
---@return boolean
function UHoldoutCompositeComponent:IsEnabled() end


---@class UHoldoutCompositeSettings : UDeveloperSettings
---@field bCompositeFollowsSceneExposure boolean
---@field bCompositeSupportsSSR boolean
---@field SceneViewExtensionPriority int32
---@field DisabledPrimitiveClasses TArray<FSoftClassPath>
local UHoldoutCompositeSettings = {}



---@class UHoldoutCompositeSubsystem : UWorldSubsystem
local UHoldoutCompositeSubsystem = {}

---@param InPrimitiveComponent TSoftObjectPtr<UPrimitiveComponent>
---@param bInHoldoutState boolean
function UHoldoutCompositeSubsystem:UnregisterPrimitive(InPrimitiveComponent, bInHoldoutState) end
---@param InPrimitiveComponent TSoftObjectPtr<UPrimitiveComponent>
---@param bInHoldoutState boolean
function UHoldoutCompositeSubsystem:RegisterPrimitive(InPrimitiveComponent, bInHoldoutState) end


