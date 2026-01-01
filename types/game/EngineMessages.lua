---@meta

---@class FEngineServiceAuthDeny
---@field UserName FString
---@field UserToDeny FString
local FEngineServiceAuthDeny = {}



---@class FEngineServiceAuthGrant
---@field UserName FString
---@field UserToGrant FString
local FEngineServiceAuthGrant = {}



---@class FEngineServiceExecuteCommand
---@field Command FString
---@field UserName FString
local FEngineServiceExecuteCommand = {}



---@class FEngineServiceNotification
---@field Text FString
---@field TimeSeconds double
local FEngineServiceNotification = {}



---@class FEngineServicePing
local FEngineServicePing = {}


---@class FEngineServicePong
---@field CurrentLevel FString
---@field EngineVersion int32
---@field HasBegunPlay boolean
---@field InstanceId FGuid
---@field InstanceType FString
---@field SessionId FGuid
---@field WorldTimeSeconds float
local FEngineServicePong = {}



---@class FEngineServiceTerminate
---@field UserName FString
local FEngineServiceTerminate = {}



---@class FTraceChannelPreset
---@field Name FString
---@field ChannelList FString
---@field bIsReadOnly boolean
local FTraceChannelPreset = {}



---@class FTraceControlBookmark
---@field Label FString
local FTraceControlBookmark = {}



---@class FTraceControlChannelsDesc
---@field Channels TArray<FString>
---@field Ids TArray<uint32>
---@field Descriptions TArray<FString>
---@field ReadOnlyIds TArray<uint32>
local FTraceControlChannelsDesc = {}



---@class FTraceControlChannelsPing
---@field KnownChannelCount uint32
local FTraceControlChannelsPing = {}



---@class FTraceControlChannelsSet
---@field ChannelIdsToEnable TArray<uint32>
---@field ChannelIdsToDisable TArray<uint32>
local FTraceControlChannelsSet = {}



---@class FTraceControlChannelsStatus
---@field EnabledIds TArray<uint32>
local FTraceControlChannelsStatus = {}



---@class FTraceControlDiscovery : FTraceControlStatus
---@field SessionId FGuid
---@field InstanceId FGuid
local FTraceControlDiscovery = {}



---@class FTraceControlDiscoveryPing
---@field SessionId FGuid
---@field InstanceId FGuid
local FTraceControlDiscoveryPing = {}



---@class FTraceControlFile : FTraceControlStartCommon
---@field File FString
---@field bTruncateFile boolean
local FTraceControlFile = {}



---@class FTraceControlPause
local FTraceControlPause = {}


---@class FTraceControlResume
local FTraceControlResume = {}


---@class FTraceControlScreenshot
---@field Name FString
---@field bShowUI boolean
local FTraceControlScreenshot = {}



---@class FTraceControlSend : FTraceControlStartCommon
---@field Host FString
local FTraceControlSend = {}



---@class FTraceControlSetStatNamedEvents
---@field bEnabled boolean
local FTraceControlSetStatNamedEvents = {}



---@class FTraceControlSettings
---@field bUseWorkerThread boolean
---@field bUseImportantCache boolean
---@field TailSizeBytes uint32
---@field ChannelPresets TArray<FTraceChannelPreset>
local FTraceControlSettings = {}



---@class FTraceControlSettingsPing
local FTraceControlSettingsPing = {}


---@class FTraceControlSnapshotFile
---@field File FString
local FTraceControlSnapshotFile = {}



---@class FTraceControlSnapshotSend
---@field Host FString
local FTraceControlSnapshotSend = {}



---@class FTraceControlStartCommon
---@field Channels FString
---@field bExcludeTail boolean
local FTraceControlStartCommon = {}



---@class FTraceControlStatus
---@field Endpoint FString
---@field SessionGuid FGuid
---@field TraceGuid FGuid
---@field BytesSent uint64
---@field BytesTraced uint64
---@field MemoryUsed uint64
---@field CacheAllocated uint32
---@field CacheUsed uint32
---@field CacheWaste uint32
---@field bAreStatNamedEventsEnabled boolean
---@field bIsPaused boolean
---@field bIsTracing boolean
---@field StatusTimestamp FDateTime
---@field TraceSystemStatus uint8
local FTraceControlStatus = {}



---@class FTraceControlStatusPing
local FTraceControlStatusPing = {}


---@class FTraceControlStop
local FTraceControlStop = {}


