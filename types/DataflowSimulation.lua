---@meta

---@class FAdvancePhysicsSolversDataflowNode : FDataflowSimulationNode
---@field SimulationTime FDataflowSimulationTime
---@field PhysicsSolvers TArray<FDataflowSimulationProperty>
local FAdvancePhysicsSolversDataflowNode = {}



---@class FDataflowCollisionObjectProxy : FDataflowSimulationProxy
local FDataflowCollisionObjectProxy = {}


---@class FDataflowConstraintObjectProxy : FDataflowSimulationProxy
local FDataflowConstraintObjectProxy = {}


---@class FDataflowExecutionNode : FDataflowSimulationNode
local FDataflowExecutionNode = {}


---@class FDataflowInvalidNode : FDataflowSimulationNode
local FDataflowInvalidNode = {}


---@class FDataflowPhysicsObjectProxy : FDataflowSimulationProxy
local FDataflowPhysicsObjectProxy = {}


---@class FDataflowPhysicsSolverProxy : FDataflowSimulationProxy
local FDataflowPhysicsSolverProxy = {}


---@class FDataflowSimulationAsset
---@field DataflowAsset UDataflow
---@field SimulationGroups TSet<FString>
local FDataflowSimulationAsset = {}



---@class FDataflowSimulationNode : FDataflowNode
local FDataflowSimulationNode = {}


---@class FDataflowSimulationProperty
local FDataflowSimulationProperty = {}


---@class FDataflowSimulationProxy
local FDataflowSimulationProxy = {}


---@class FDataflowSimulationTime
---@field DeltaTime float
---@field CurrentTime float
---@field TimeOffset float
local FDataflowSimulationTime = {}



---@class FFilterSimulationProxiesDataflowNode : FDataflowSimulationNode
---@field SimulationProxies TArray<FDataflowSimulationProperty>
---@field FilteredProxies TArray<FDataflowSimulationProperty>
---@field SimulationGroups TArray<FString>
local FFilterSimulationProxiesDataflowNode = {}



---@class FGetPhysicsSolversDataflowNode : FDataflowInvalidNode
---@field PhysicsSolvers TArray<FDataflowSimulationProperty>
---@field SimulationGroups TArray<FString>
local FGetPhysicsSolversDataflowNode = {}



---@class FGetSimulationTimeDataflowNode : FDataflowInvalidNode
---@field SimulationTime FDataflowSimulationTime
local FGetSimulationTimeDataflowNode = {}



---@class FSimulationProxiesTerminalDataflowNode : FDataflowExecutionNode
---@field SimulationProxies TArray<FDataflowSimulationProperty>
local FSimulationProxiesTerminalDataflowNode = {}



---@class IDataflowCollisionObjectInterface : IDataflowSimulationInterface
local IDataflowCollisionObjectInterface = {}


---@class IDataflowConstraintObjectInterface : IDataflowSimulationInterface
local IDataflowConstraintObjectInterface = {}


---@class IDataflowGeometryCachable : IInterface
local IDataflowGeometryCachable = {}


---@class IDataflowPhysicsObjectInterface : IDataflowSimulationInterface
local IDataflowPhysicsObjectInterface = {}


---@class IDataflowPhysicsSolverInterface : IDataflowSimulationInterface
local IDataflowPhysicsSolverInterface = {}


---@class IDataflowSimulationActor : IInterface
local IDataflowSimulationActor = {}

---@param SimulationTime float
---@param DeltaTime float
function IDataflowSimulationActor:PreDataflowSimulationTick(SimulationTime, DeltaTime) end
---@param SimulationTime float
---@param DeltaTime float
function IDataflowSimulationActor:PostDataflowSimulationTick(SimulationTime, DeltaTime) end


---@class IDataflowSimulationInterface : IInterface
local IDataflowSimulationInterface = {}


---@class UDataflowSimulationManager : UTickableWorldSubsystem
local UDataflowSimulationManager = {}


