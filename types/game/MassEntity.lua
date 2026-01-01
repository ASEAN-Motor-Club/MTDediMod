---@meta

---@class FMassChunkFragment
local FMassChunkFragment = {}


---@class FMassConstSharedFragment
local FMassConstSharedFragment = {}


---@class FMassEntityHandle
---@field Index int32
---@field SerialNumber int32
local FMassEntityHandle = {}



---@class FMassEntityObserverClassesMap
---@field Container TMap<UScriptStruct, FMassProcessorClassCollection>
local FMassEntityObserverClassesMap = {}



---@class FMassEntityQuery : FMassFragmentRequirements
local FMassEntityQuery = {}


---@class FMassEntityView
local FMassEntityView = {}


---@class FMassFragment
local FMassFragment = {}


---@class FMassFragmentRequirements
local FMassFragmentRequirements = {}


---@class FMassGenericDebugEvent
local FMassGenericDebugEvent = {}


---@class FMassObserverManager
---@field FragmentObservers FMassObserversMap
---@field TagObservers FMassObserversMap
local FMassObserverManager = {}



---@class FMassObserversMap
---@field Container TMap<UScriptStruct, FMassRuntimePipeline>
local FMassObserversMap = {}



---@class FMassProcessingContext
---@field DeltaSeconds float
---@field AuxData FInstancedStruct
---@field bFlushCommandBuffer boolean
local FMassProcessingContext = {}



---@class FMassProcessingPhaseConfig
---@field PhaseName FName
---@field PhaseGroupClass TSubclassOf<UMassCompositeProcessor>
---@field ProcessorCDOs TArray<UMassProcessor>
local FMassProcessingPhaseConfig = {}



---@class FMassProcessorClassCollection
---@field ClassCollection TArray<TSubclassOf<UMassProcessor>>
local FMassProcessorClassCollection = {}



---@class FMassProcessorExecutionOrder
---@field ExecuteInGroup FName
---@field ExecuteBefore TArray<FName>
---@field ExecuteAfter TArray<FName>
local FMassProcessorExecutionOrder = {}



---@class FMassRuntimePipeline
---@field Processors TArray<UMassProcessor>
local FMassRuntimePipeline = {}



---@class FMassSharedFragment
local FMassSharedFragment = {}


---@class FMassSubsystemRequirements
local FMassSubsystemRequirements = {}


---@class FMassTag
local FMassTag = {}


---@class FProcessorAuxDataBase
local FProcessorAuxDataBase = {}


---@class UMassCompositeProcessor : UMassProcessor
---@field ChildPipeline FMassRuntimePipeline
---@field GroupName FName
local UMassCompositeProcessor = {}



---@class UMassEntitySettings : UMassModuleSettings
---@field ChunkMemorySize int32
---@field DumpDependencyGraphFileName FString
---@field ProcessingPhasesConfig FMassProcessingPhaseConfig
---@field ProcessorCDOs TArray<UMassProcessor>
local UMassEntitySettings = {}



---@class UMassEntitySubsystem : UMassSubsystemBase
local UMassEntitySubsystem = {}


---@class UMassModuleSettings : UObject
local UMassModuleSettings = {}


---@class UMassObserverProcessor : UMassProcessor
---@field bAutoRegisterWithObserverRegistry boolean
---@field ObservedType UScriptStruct
local UMassObserverProcessor = {}



---@class UMassObserverRegistry : UObject
---@field FragmentObservers FMassEntityObserverClassesMap
---@field TagObservers FMassEntityObserverClassesMap
local UMassObserverRegistry = {}



---@class UMassProcessor : UObject
---@field ExecutionOrder FMassProcessorExecutionOrder
---@field ProcessingPhase EMassProcessingPhase
---@field ExecutionFlags uint8
---@field bAutoRegisterWithProcessingPhases boolean
---@field bRequiresGameThreadExecution boolean
local UMassProcessor = {}



---@class UMassSettings : UDeveloperSettings
---@field ModuleSettings TMap<FName, UMassModuleSettings>
local UMassSettings = {}



---@class UMassSubsystemBase : UWorldSubsystem
local UMassSubsystemBase = {}


---@class UMassTickableSubsystemBase : UTickableWorldSubsystem
local UMassTickableSubsystemBase = {}


