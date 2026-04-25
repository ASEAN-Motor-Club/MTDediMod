---@meta

---@class FLiveLinkClearSubject
---@field SubjectName FName
local FLiveLinkClearSubject = {}



---@class FLiveLinkConnectMessage
---@field LiveLinkVersion int32
local FLiveLinkConnectMessage = {}



---@class FLiveLinkHeartbeatMessage
local FLiveLinkHeartbeatMessage = {}


---@class FLiveLinkPingMessage
---@field PollRequest FGuid
---@field LiveLinkVersion int32
local FLiveLinkPingMessage = {}



---@class FLiveLinkPongMessage
---@field ProviderName FString
---@field MachineName FString
---@field PollRequest FGuid
---@field LiveLinkVersion int32
---@field CreationPlatformTime double
local FLiveLinkPongMessage = {}



---@class FLiveLinkSubjectDataMessage
---@field RefSkeleton FLiveLinkRefSkeleton
---@field SubjectName FName
local FLiveLinkSubjectDataMessage = {}



---@class FLiveLinkSubjectFrameMessage
---@field SubjectName FName
---@field Transforms TArray<FTransform>
---@field Curves TArray<FLiveLinkCurveElement>
---@field MetaData FLiveLinkMetaData
---@field Time double
local FLiveLinkSubjectFrameMessage = {}



