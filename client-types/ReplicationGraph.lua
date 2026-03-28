---@meta

---@class AReplicationGraphDebugActor : AActor
---@field ReplicationGraph UReplicationGraph
---@field ConnectionManager UNetReplicationGraphConnection
local AReplicationGraphDebugActor = {}

function AReplicationGraphDebugActor:ServerStopDebugging() end
function AReplicationGraphDebugActor:ServerStartDebugging() end
---@param Class UClass
---@param PeriodFrame int32
function AReplicationGraphDebugActor:ServerSetPeriodFrameForClass(Class, PeriodFrame) end
---@param Class UClass
---@param CullDistance float
function AReplicationGraphDebugActor:ServerSetCullDistanceForClass(Class, CullDistance) end
---@param Actor AActor
function AReplicationGraphDebugActor:ServerSetConditionalActorBreakpoint(Actor) end
function AReplicationGraphDebugActor:ServerPrintCullDistances() end
---@param Str FString
function AReplicationGraphDebugActor:ServerPrintAllActorInfo(Str) end
function AReplicationGraphDebugActor:ServerCellInfo() end
---@param CellLocation FVector
---@param CellExtent FVector
---@param Actors TArray<AActor>
function AReplicationGraphDebugActor:ClientCellInfo(CellLocation, CellExtent, Actors) end


---@class FAlwaysRelevantActorInfo
---@field Connection UNetConnection
---@field LastViewer AActor
---@field LastViewTarget AActor
local FAlwaysRelevantActorInfo = {}



---@class FClassReplicationInfo
---@field DistancePriorityScale float
---@field StarvationPriorityScale float
---@field AccumulatedNetPriorityBias float
---@field ReplicationPeriodFrame uint16
---@field FastPath_ReplicationPeriodFrame uint16
---@field ActorChannelFrameTimeout uint16
---@field CullDistance float
---@field CullDistanceSquared float
local FClassReplicationInfo = {}



---@class FConnectionAlwaysRelevantNodePair
---@field NetConnection UNetConnection
---@field Node UReplicationGraphNode_AlwaysRelevant_ForConnection
local FConnectionAlwaysRelevantNodePair = {}



---@class FLastLocationGatherInfo
---@field Connection UNetConnection
---@field LastLocation FVector
---@field LastOutOfRangeLocationCheck FVector
local FLastLocationGatherInfo = {}



---@class FTearOffActorInfo
---@field Actor AActor
local FTearOffActorInfo = {}



---@class UBasicReplicationGraph : UReplicationGraph
---@field GridNode UReplicationGraphNode_GridSpatialization2D
---@field AlwaysRelevantNode UReplicationGraphNode_ActorList
---@field AlwaysRelevantForConnectionList TArray<FConnectionAlwaysRelevantNodePair>
---@field ActorsWithoutNetConnection TArray<AActor>
local UBasicReplicationGraph = {}



---@class UNetReplicationGraphConnection : UReplicationConnectionDriver
---@field NetConnection UNetConnection
---@field DebugActor TWeakObjectPtr<AReplicationGraphDebugActor>
---@field LastGatherLocations TArray<FLastLocationGatherInfo>
---@field ConnectionGraphNodes TArray<UReplicationGraphNode>
---@field TearOffNode UReplicationGraphNode_TearOff_ForConnection
local UNetReplicationGraphConnection = {}



---@class UReplicationGraph : UReplicationDriver
---@field ReplicationConnectionManagerClass TSubclassOf<UNetReplicationGraphConnection>
---@field NetDriver UNetDriver
---@field Connections TArray<UNetReplicationGraphConnection>
---@field PendingConnections TArray<UNetReplicationGraphConnection>
---@field GlobalGraphNodes TArray<UReplicationGraphNode>
---@field PrepareForReplicationNodes TArray<UReplicationGraphNode>
---@field ActiveNetworkActors TSet<AActor>
local UReplicationGraph = {}



---@class UReplicationGraphNode : UObject
---@field AllChildNodes TArray<UReplicationGraphNode>
local UReplicationGraphNode = {}



---@class UReplicationGraphNode_ActorList : UReplicationGraphNode
local UReplicationGraphNode_ActorList = {}


---@class UReplicationGraphNode_ActorListFrequencyBuckets : UReplicationGraphNode
local UReplicationGraphNode_ActorListFrequencyBuckets = {}


---@class UReplicationGraphNode_AlwaysRelevant : UReplicationGraphNode
---@field ChildNode UReplicationGraphNode
local UReplicationGraphNode_AlwaysRelevant = {}



---@class UReplicationGraphNode_AlwaysRelevant_ForConnection : UReplicationGraphNode_ActorList
---@field PastRelevantActors TArray<FAlwaysRelevantActorInfo>
local UReplicationGraphNode_AlwaysRelevant_ForConnection = {}



---@class UReplicationGraphNode_ConnectionDormancyNode : UReplicationGraphNode_ActorList
local UReplicationGraphNode_ConnectionDormancyNode = {}


---@class UReplicationGraphNode_DormancyNode : UReplicationGraphNode_ActorList
local UReplicationGraphNode_DormancyNode = {}


---@class UReplicationGraphNode_DynamicSpatialFrequency : UReplicationGraphNode_ActorList
local UReplicationGraphNode_DynamicSpatialFrequency = {}


---@class UReplicationGraphNode_GridCell : UReplicationGraphNode_ActorList
---@field DynamicNode UReplicationGraphNode
---@field DormancyNode UReplicationGraphNode_DormancyNode
local UReplicationGraphNode_GridCell = {}



---@class UReplicationGraphNode_GridSpatialization2D : UReplicationGraphNode
local UReplicationGraphNode_GridSpatialization2D = {}


---@class UReplicationGraphNode_TearOff_ForConnection : UReplicationGraphNode
---@field TearOffActors TArray<FTearOffActorInfo>
local UReplicationGraphNode_TearOff_ForConnection = {}



