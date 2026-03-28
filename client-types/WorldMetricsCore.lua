---@meta

---@class FWorldMetricCollection
---@field Metrics TArray<UWorldMetricInterface>
---@field Subsystem TWeakObjectPtr<UWorldMetricsSubsystem>
---@field bIsEnabled boolean
local FWorldMetricCollection = {}



---@class IWorldMetricsActorTrackerSubscriber : IInterface
local IWorldMetricsActorTrackerSubscriber = {}


---@class UWorldMetricInterface : UObject
local UWorldMetricInterface = {}


---@class UWorldMetricsActorTracker : UWorldMetricsExtension
local UWorldMetricsActorTracker = {}


---@class UWorldMetricsExtension : UObject
local UWorldMetricsExtension = {}


---@class UWorldMetricsSubsystem : UWorldSubsystem
---@field Metrics TArray<UWorldMetricInterface>
---@field UpdateRateInSeconds float
---@field WarmUpFrames int32
local UWorldMetricsSubsystem = {}



