---@meta

---@class AChaosSolverActor : AActor
---@field Properties FChaosSolverConfiguration
---@field TimeStepMultiplier float
---@field CollisionIterations int32
---@field PushOutIterations int32
---@field PushOutPairIterations int32
---@field ClusterConnectionFactor float
---@field ClusterUnionConnectionType EClusterConnectionTypeEnum
---@field DoGenerateCollisionData boolean
---@field CollisionFilterSettings FSolverCollisionFilterSettings
---@field DoGenerateBreakingData boolean
---@field BreakingFilterSettings FSolverBreakingFilterSettings
---@field DoGenerateTrailingData boolean
---@field TrailingFilterSettings FSolverTrailingFilterSettings
---@field MassScale float
---@field bHasFloor boolean
---@field FloorHeight float
---@field ChaosDebugSubstepControl FChaosDebugSubstepControl
---@field SpriteComponent UBillboardComponent
---@field SimulationAsset FDataflowSimulationAsset
---@field GameplayEventDispatcherComponent UChaosGameplayEventDispatcher
local AChaosSolverActor = {}

---@param bActive boolean
function AChaosSolverActor:SetSolverActive(bActive) end
function AChaosSolverActor:SetAsCurrentWorldSolver() end


---@class FBreakEventCallbackWrapper
local FBreakEventCallbackWrapper = {}


---@class FChaosDebugSubstepControl
---@field bPause boolean
---@field bSubstep boolean
---@field bStep boolean
local FChaosDebugSubstepControl = {}



---@class FChaosHandlerSet
---@field ChaosHandlers TSet<UObject>
local FChaosHandlerSet = {}



---@class FChaosPhysicsCollisionInfo
---@field Component UPrimitiveComponent
---@field OtherComponent UPrimitiveComponent
---@field Location FVector
---@field Normal FVector
---@field AccumulatedImpulse FVector
---@field Velocity FVector
---@field OtherVelocity FVector
---@field AngularVelocity FVector
---@field OtherAngularVelocity FVector
---@field Mass float
---@field OtherMass float
local FChaosPhysicsCollisionInfo = {}



---@class FCrumblingEventCallbackWrapper
local FCrumblingEventCallbackWrapper = {}


---@class FDataflowRigidSolverProxy : FDataflowPhysicsSolverProxy
local FDataflowRigidSolverProxy = {}


---@class FRemovalEventCallbackWrapper
local FRemovalEventCallbackWrapper = {}


---@class IChaosNotifyHandlerInterface : IInterface
local IChaosNotifyHandlerInterface = {}


---@class UChaosDebugDrawComponent : UActorComponent
local UChaosDebugDrawComponent = {}


---@class UChaosDebugDrawSubsystem : UWorldSubsystem
local UChaosDebugDrawSubsystem = {}


---@class UChaosEventListenerComponent : UActorComponent
local UChaosEventListenerComponent = {}


---@class UChaosGameplayEventDispatcher : UChaosEventListenerComponent
---@field CollisionEventRegistrations TMap<UPrimitiveComponent, FChaosHandlerSet>
---@field BreakEventRegistrations TMap<UPrimitiveComponent, FBreakEventCallbackWrapper>
---@field RemovalEventRegistrations TMap<UPrimitiveComponent, FRemovalEventCallbackWrapper>
---@field CrumblingEventRegistrations TMap<UPrimitiveComponent, FCrumblingEventCallbackWrapper>
local UChaosGameplayEventDispatcher = {}



---@class UChaosSolver : UObject
local UChaosSolver = {}


---@class UChaosSolverEngineBlueprintLibrary : UBlueprintFunctionLibrary
local UChaosSolverEngineBlueprintLibrary = {}

---@param PhysicsCollision FChaosPhysicsCollisionInfo
---@return FHitResult
function UChaosSolverEngineBlueprintLibrary:ConvertPhysicsCollisionToHitResult(PhysicsCollision) end


---@class UChaosSolverSettings : UDeveloperSettings
---@field DefaultChaosSolverActorClass FSoftClassPath
local UChaosSolverSettings = {}



