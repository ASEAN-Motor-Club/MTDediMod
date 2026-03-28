---@meta

---@class FArrayPropertyNetSerializerConfig : FNetSerializerConfig
---@field MaxElementCount uint16
---@field ElementCountBitCount uint16
---@field Property TFieldPath<FArrayProperty>
local FArrayPropertyNetSerializerConfig = {}



---@class FBitfieldNetSerializerConfig : FNetSerializerConfig
---@field BitMask uint8
local FBitfieldNetSerializerConfig = {}



---@class FBoolNetSerializerConfig : FNetSerializerConfig
local FBoolNetSerializerConfig = {}


---@class FDataStreamDefinition
---@field DataStreamName FName
---@field ClassName FName
---@field Class UClass
---@field DefaultSendStatus EDataStreamSendStatus
---@field bAutoCreate boolean
local FDataStreamDefinition = {}



---@class FDateTimeNetSerializerConfig : FNetSerializerConfig
local FDateTimeNetSerializerConfig = {}


---@class FDoubleNetSerializerConfig : FNetSerializerConfig
local FDoubleNetSerializerConfig = {}


---@class FEnumInt16NetSerializerConfig : FNetSerializerConfig
---@field LowerBound int16
---@field UpperBound int16
---@field BitCount uint8
local FEnumInt16NetSerializerConfig = {}



---@class FEnumInt32NetSerializerConfig : FNetSerializerConfig
---@field LowerBound int32
---@field UpperBound int32
---@field BitCount uint8
local FEnumInt32NetSerializerConfig = {}



---@class FEnumInt64NetSerializerConfig : FNetSerializerConfig
---@field LowerBound int64
---@field UpperBound int64
---@field BitCount uint8
local FEnumInt64NetSerializerConfig = {}



---@class FEnumInt8NetSerializerConfig : FNetSerializerConfig
---@field LowerBound int8
---@field UpperBound int8
---@field BitCount uint8
local FEnumInt8NetSerializerConfig = {}



---@class FEnumUint16NetSerializerConfig : FNetSerializerConfig
---@field LowerBound uint16
---@field UpperBound uint16
---@field BitCount uint8
local FEnumUint16NetSerializerConfig = {}



---@class FEnumUint32NetSerializerConfig : FNetSerializerConfig
---@field LowerBound uint32
---@field UpperBound uint32
---@field BitCount uint8
local FEnumUint32NetSerializerConfig = {}



---@class FEnumUint64NetSerializerConfig : FNetSerializerConfig
---@field LowerBound uint64
---@field UpperBound uint64
---@field BitCount uint8
local FEnumUint64NetSerializerConfig = {}



---@class FEnumUint8NetSerializerConfig : FNetSerializerConfig
---@field LowerBound uint8
---@field UpperBound uint8
---@field BitCount uint8
local FEnumUint8NetSerializerConfig = {}



---@class FFieldPathNetSerializerConfig : FNetSerializerConfig
---@field Property TFieldPath<FProperty>
local FFieldPathNetSerializerConfig = {}



---@class FFieldPathNetSerializerSerializationHelper
---@field Owner TWeakObjectPtr<UStruct>
---@field PropertyPath TArray<FName>
local FFieldPathNetSerializerSerializationHelper = {}



---@class FFloatNetSerializerConfig : FNetSerializerConfig
local FFloatNetSerializerConfig = {}


---@class FGuidNetSerializerConfig : FNetSerializerConfig
local FGuidNetSerializerConfig = {}


---@class FInstancedStructNetSerializerConfig : FNetSerializerConfig
---@field SupportedTypes TArray<TSoftObjectPtr<UScriptStruct>>
local FInstancedStructNetSerializerConfig = {}



---@class FInt16RangeNetSerializerConfig : FNetSerializerConfig
---@field LowerBound int16
---@field UpperBound int16
---@field BitCount uint8
local FInt16RangeNetSerializerConfig = {}



---@class FInt32RangeNetSerializerConfig : FNetSerializerConfig
---@field LowerBound int32
---@field UpperBound int32
---@field BitCount uint8
local FInt32RangeNetSerializerConfig = {}



---@class FInt64RangeNetSerializerConfig : FNetSerializerConfig
---@field LowerBound int64
---@field UpperBound int64
---@field BitCount uint8
local FInt64RangeNetSerializerConfig = {}



---@class FInt8RangeNetSerializerConfig : FNetSerializerConfig
---@field LowerBound int8
---@field UpperBound int8
---@field BitCount uint8
local FInt8RangeNetSerializerConfig = {}



---@class FIntNetSerializerConfig : FNetSerializerConfig
---@field BitCount uint8
local FIntNetSerializerConfig = {}



---@class FIrisFastArraySerializer : FFastArraySerializer
---@field ChangeMaskStorage uint32
local FIrisFastArraySerializer = {}



---@class FLastResortPropertyNetSerializerConfig : FNetSerializerConfig
---@field Property TFieldPath<FProperty>
local FLastResortPropertyNetSerializerConfig = {}



---@class FNameAsNetTokenNetSerializerConfig : FNetSerializerConfig
local FNameAsNetTokenNetSerializerConfig = {}


---@class FNameNetSerializerConfig : FNetSerializerConfig
local FNameNetSerializerConfig = {}


---@class FNetBlobHandlerDefinition
---@field ClassName FName
local FNetBlobHandlerDefinition = {}



---@class FNetObjectFilterDefinition
---@field FilterName FName
---@field ClassName FName
---@field ConfigClassName FName
local FNetObjectFilterDefinition = {}



---@class FNetObjectGridFilterProfile
---@field FilterProfileName FName
---@field FrameCountBeforeCulling uint16
local FNetObjectGridFilterProfile = {}



---@class FNetObjectPrioritizerDefinition
---@field PrioritizerName FName
---@field ClassName FName
---@field Class UClass
---@field ConfigClassName FName
---@field ConfigClass UClass
local FNetObjectPrioritizerDefinition = {}



---@class FNetRoleNetSerializerConfig : FNetSerializerConfig
---@field RelativeInternalOffsetToOtherRole int32
---@field RelativeExternalOffsetToOtherRole int32
---@field LowerBound uint8
---@field UpperBound uint8
---@field BitCount uint8
---@field AutonomousProxyValue uint8
---@field SimulatedProxyValue uint8
local FNetRoleNetSerializerConfig = {}



---@class FNetSerializerConfig
local FNetSerializerConfig = {}


---@class FNopNetSerializerConfig : FNetSerializerConfig
local FNopNetSerializerConfig = {}


---@class FObjectNetSerializerConfig : FNetSerializerConfig
local FObjectNetSerializerConfig = {}


---@class FObjectReplicatedBridgeCriticalClassConfig
---@field ClassName FName
---@field bDisconnectOnProtocolMismatch boolean
local FObjectReplicatedBridgeCriticalClassConfig = {}



---@class FObjectReplicationBridgeDeltaCompressionConfig
---@field ClassName FName
---@field bEnableDeltaCompression boolean
local FObjectReplicationBridgeDeltaCompressionConfig = {}



---@class FObjectReplicationBridgeFilterConfig
---@field ClassName FName
---@field DynamicFilterName FName
---@field FilterProfile FName
---@field bForceEnableOnAllInstances boolean
local FObjectReplicationBridgeFilterConfig = {}



---@class FObjectReplicationBridgePollConfig
---@field ClassName FName
---@field PollFrequency float
---@field bIncludeSubclasses boolean
local FObjectReplicationBridgePollConfig = {}



---@class FObjectReplicationBridgePrioritizerConfig
---@field ClassName FName
---@field PrioritizerName FName
---@field bForceEnableOnAllInstances boolean
local FObjectReplicationBridgePrioritizerConfig = {}



---@class FObjectReplicationBridgeTypeStatsConfig
---@field ClassName FName
---@field TypeStatsName FName
---@field bIncludeInMinimalCSVStats boolean
local FObjectReplicationBridgeTypeStatsConfig = {}



---@class FObjectScopeHysteresisProfile
---@field FilterProfileName FName
---@field HysteresisFrameCount uint8
local FObjectScopeHysteresisProfile = {}



---@class FPackedInt32NetSerializerConfig : FNetSerializerConfig
local FPackedInt32NetSerializerConfig = {}


---@class FPackedInt64NetSerializerConfig : FNetSerializerConfig
local FPackedInt64NetSerializerConfig = {}


---@class FPackedUint32NetSerializerConfig : FNetSerializerConfig
local FPackedUint32NetSerializerConfig = {}


---@class FPackedUint64NetSerializerConfig : FNetSerializerConfig
local FPackedUint64NetSerializerConfig = {}


---@class FPolymorphicArrayStructNetSerializerConfig : FPolymorphicStructNetSerializerConfig
local FPolymorphicArrayStructNetSerializerConfig = {}


---@class FPolymorphicStructNetSerializerConfig : FNetSerializerConfig
local FPolymorphicStructNetSerializerConfig = {}


---@class FRotator3dNetSerializerConfig : FNetSerializerConfig
local FRotator3dNetSerializerConfig = {}


---@class FRotator3fNetSerializerConfig : FNetSerializerConfig
local FRotator3fNetSerializerConfig = {}


---@class FRotatorAsByteNetSerializerConfig : FNetSerializerConfig
local FRotatorAsByteNetSerializerConfig = {}


---@class FRotatorAsShortNetSerializerConfig : FNetSerializerConfig
local FRotatorAsShortNetSerializerConfig = {}


---@class FRotatorNetSerializerConfig : FNetSerializerConfig
local FRotatorNetSerializerConfig = {}


---@class FScriptInterfaceNetSerializerConfig : FNetSerializerConfig
---@field InterfaceClass UClass
local FScriptInterfaceNetSerializerConfig = {}



---@class FSoftClassPathNetSerializerConfig : FNetSerializerConfig
local FSoftClassPathNetSerializerConfig = {}


---@class FSoftObjectNetSerializerConfig : FNetSerializerConfig
local FSoftObjectNetSerializerConfig = {}


---@class FSoftObjectPathNetSerializerConfig : FNetSerializerConfig
local FSoftObjectPathNetSerializerConfig = {}


---@class FStringNetSerializerConfig : FNetSerializerConfig
local FStringNetSerializerConfig = {}


---@class FStructNetSerializerConfig : FNetSerializerConfig
local FStructNetSerializerConfig = {}


---@class FSupportsStructNetSerializerConfig
---@field StructName FName
---@field bCanUseStructNetSerializer boolean
local FSupportsStructNetSerializerConfig = {}



---@class FUint16RangeNetSerializerConfig : FNetSerializerConfig
---@field LowerBound uint16
---@field UpperBound uint16
---@field BitCount uint8
local FUint16RangeNetSerializerConfig = {}



---@class FUint32RangeNetSerializerConfig : FNetSerializerConfig
---@field LowerBound uint32
---@field UpperBound uint32
---@field BitCount uint8
local FUint32RangeNetSerializerConfig = {}



---@class FUint64RangeNetSerializerConfig : FNetSerializerConfig
---@field LowerBound uint64
---@field UpperBound uint64
---@field BitCount uint8
local FUint64RangeNetSerializerConfig = {}



---@class FUint8RangeNetSerializerConfig : FNetSerializerConfig
---@field LowerBound uint8
---@field UpperBound uint8
---@field BitCount uint8
local FUint8RangeNetSerializerConfig = {}



---@class FUintNetSerializerConfig : FNetSerializerConfig
---@field BitCount uint8
local FUintNetSerializerConfig = {}



---@class FUnitQuat4dNetSerializerConfig : FNetSerializerConfig
local FUnitQuat4dNetSerializerConfig = {}


---@class FUnitQuat4fNetSerializerConfig : FNetSerializerConfig
local FUnitQuat4fNetSerializerConfig = {}


---@class FUnitQuatNetSerializerConfig : FNetSerializerConfig
local FUnitQuatNetSerializerConfig = {}


---@class FVector3dNetSerializerConfig : FNetSerializerConfig
local FVector3dNetSerializerConfig = {}


---@class FVector3fNetSerializerConfig : FNetSerializerConfig
local FVector3fNetSerializerConfig = {}


---@class FVectorNetQuantize100NetSerializerConfig : FNetSerializerConfig
local FVectorNetQuantize100NetSerializerConfig = {}


---@class FVectorNetQuantize10NetSerializerConfig : FNetSerializerConfig
local FVectorNetQuantize10NetSerializerConfig = {}


---@class FVectorNetQuantizeNetSerializerConfig : FNetSerializerConfig
local FVectorNetQuantizeNetSerializerConfig = {}


---@class FVectorNetQuantizeNormalNetSerializerConfig : FNetSerializerConfig
local FVectorNetQuantizeNormalNetSerializerConfig = {}


---@class FVectorNetSerializerConfig : FNetSerializerConfig
local FVectorNetSerializerConfig = {}


---@class FWeakObjectNetSerializerConfig : FNetSerializerConfig
local FWeakObjectNetSerializerConfig = {}


---@class UDataStream : UObject
local UDataStream = {}


---@class UDataStreamDefinitions : UObject
---@field DataStreamDefinitions TArray<FDataStreamDefinition>
local UDataStreamDefinitions = {}



---@class UDataStreamManager : UDataStream
local UDataStreamManager = {}


---@class UFieldOfViewNetObjectPrioritizer : ULocationBasedNetObjectPrioritizer
local UFieldOfViewNetObjectPrioritizer = {}


---@class UFieldOfViewNetObjectPrioritizerConfig : UNetObjectPrioritizerConfig
---@field InnerSphereRadius float
---@field InnerSpherePriority float
---@field OuterSphereRadius float
---@field OuterSpherePriority float
---@field ConeFieldOfViewDegrees float
---@field InnerConeLength float
---@field ConeLength float
---@field MinConePriority float
---@field MaxConePriority float
---@field LineOfSightWidth float
---@field LineOfSightPriority float
---@field OutsidePriority float
local UFieldOfViewNetObjectPrioritizerConfig = {}



---@class UFilterOutNetObjectFilter : UNetObjectFilter
local UFilterOutNetObjectFilter = {}


---@class UFilterOutNetObjectFilterConfig : UNetObjectFilterConfig
local UFilterOutNetObjectFilterConfig = {}


---@class UIrisObjectReferencePackageMap : UPackageMap
local UIrisObjectReferencePackageMap = {}


---@class ULocationBasedNetObjectPrioritizer : UNetObjectPrioritizer
local ULocationBasedNetObjectPrioritizer = {}


---@class UNetBlobHandler : UObject
local UNetBlobHandler = {}


---@class UNetBlobHandlerDefinitions : UObject
---@field NetBlobHandlerDefinitions TArray<FNetBlobHandlerDefinition>
local UNetBlobHandlerDefinitions = {}



---@class UNetObjectBlobHandler : UNetBlobHandler
local UNetObjectBlobHandler = {}


---@class UNetObjectConnectionFilter : UNetObjectFilter
local UNetObjectConnectionFilter = {}


---@class UNetObjectConnectionFilterConfig : UNetObjectFilterConfig
---@field MaxObjectCount uint16
local UNetObjectConnectionFilterConfig = {}



---@class UNetObjectCountLimiter : UNetObjectPrioritizer
local UNetObjectCountLimiter = {}


---@class UNetObjectCountLimiterConfig : UNetObjectPrioritizerConfig
---@field Mode ENetObjectCountLimiterMode
---@field MaxObjectCount uint32
---@field Priority float
---@field OwningConnectionPriority float
---@field bEnableOwnedObjectsFastLane boolean
local UNetObjectCountLimiterConfig = {}



---@class UNetObjectFactory : UObject
local UNetObjectFactory = {}


---@class UNetObjectFilter : UObject
local UNetObjectFilter = {}


---@class UNetObjectFilterConfig : UObject
local UNetObjectFilterConfig = {}


---@class UNetObjectFilterDefinitions : UObject
---@field NetObjectFilterDefinitions TArray<FNetObjectFilterDefinition>
local UNetObjectFilterDefinitions = {}



---@class UNetObjectGridFilter : UNetObjectFilter
local UNetObjectGridFilter = {}


---@class UNetObjectGridFilterConfig : UNetObjectFilterConfig
---@field ViewPosRelevancyFrameCount uint32
---@field DefaultFrameCountBeforeCulling uint16
---@field CellSizeX float
---@field CellSizeY float
---@field MaxCullDistance float
---@field DefaultCullDistance float
---@field bUseExactCullDistance boolean
---@field FilterProfiles TArray<FNetObjectGridFilterProfile>
local UNetObjectGridFilterConfig = {}



---@class UNetObjectGridWorldLocFilter : UNetObjectGridFilter
local UNetObjectGridWorldLocFilter = {}


---@class UNetObjectPrioritizer : UObject
local UNetObjectPrioritizer = {}


---@class UNetObjectPrioritizerConfig : UObject
local UNetObjectPrioritizerConfig = {}


---@class UNetObjectPrioritizerDefinitions : UObject
---@field NetObjectPrioritizerDefinitions TArray<FNetObjectPrioritizerDefinition>
local UNetObjectPrioritizerDefinitions = {}



---@class UNetRPCHandler : UNetBlobHandler
local UNetRPCHandler = {}


---@class UNetTokenDataStream : UDataStream
local UNetTokenDataStream = {}


---@class UNopNetObjectFilter : UNetObjectFilter
local UNopNetObjectFilter = {}


---@class UNopNetObjectFilterConfig : UNetObjectFilterConfig
local UNopNetObjectFilterConfig = {}


---@class UObjectReplicationBridge : UReplicationBridge
---@field NetObjectFactories TArray<UNetObjectFactory>
local UObjectReplicationBridge = {}



---@class UObjectReplicationBridgeConfig : UObject
---@field PollConfigs TArray<FObjectReplicationBridgePollConfig>
---@field FilterConfigs TArray<FObjectReplicationBridgeFilterConfig>
---@field PrioritizerConfigs TArray<FObjectReplicationBridgePrioritizerConfig>
---@field DeltaCompressionConfigs TArray<FObjectReplicationBridgeDeltaCompressionConfig>
---@field CriticalClassConfigs TArray<FObjectReplicatedBridgeCriticalClassConfig>
---@field bAllClassesCritical boolean
---@field TypeStatsConfigs TArray<FObjectReplicationBridgeTypeStatsConfig>
---@field DefaultSpatialFilterName FName
---@field RequiredNetDriverChannelClassName FName
---@field CriticalActorClasses TArray<FName>
local UObjectReplicationBridgeConfig = {}



---@class UPartialNetObjectAttachmentHandler : USequentialPartialNetBlobHandler
local UPartialNetObjectAttachmentHandler = {}


---@class UPartialNetObjectAttachmentHandlerConfig : USequentialPartialNetBlobHandlerConfig
---@field BitCountSplitThreshold uint32
---@field ClientUnreliableBitCountSplitThreshold uint32
---@field ServerUnreliableBitCountSplitThreshold uint32
local UPartialNetObjectAttachmentHandlerConfig = {}



---@class UReplicationBridge : UObject
local UReplicationBridge = {}


---@class UReplicationDataStream : UDataStream
local UReplicationDataStream = {}


---@class UReplicationFilteringConfig : UObject
---@field bEnableObjectScopeHysteresis boolean
---@field DefaultHysteresisFrameCount uint8
---@field HysteresisUpdateConnectionThrottling uint8
---@field HysteresisProfiles TArray<FObjectScopeHysteresisProfile>
local UReplicationFilteringConfig = {}



---@class UReplicationStateDescriptorConfig : UObject
---@field SupportsStructNetSerializerList TArray<FSupportsStructNetSerializerConfig>
local UReplicationStateDescriptorConfig = {}



---@class UReplicationSystem : UObject
---@field ReplicationBridge UReplicationBridge
local UReplicationSystem = {}



---@class USequentialPartialNetBlobHandler : UNetBlobHandler
local USequentialPartialNetBlobHandler = {}


---@class USequentialPartialNetBlobHandlerConfig : UObject
---@field MaxPartBitCount uint32
---@field MaxPartCount uint32
local USequentialPartialNetBlobHandlerConfig = {}



---@class USphereNetObjectPrioritizer : ULocationBasedNetObjectPrioritizer
local USphereNetObjectPrioritizer = {}


---@class USphereNetObjectPrioritizerConfig : UNetObjectPrioritizerConfig
---@field InnerRadius float
---@field OuterRadius float
---@field InnerPriority float
---@field OuterPriority float
---@field OutsidePriority float
local USphereNetObjectPrioritizerConfig = {}



---@class USphereWithOwnerBoostNetObjectPrioritizer : USphereNetObjectPrioritizer
local USphereWithOwnerBoostNetObjectPrioritizer = {}


---@class USphereWithOwnerBoostNetObjectPrioritizerConfig : USphereNetObjectPrioritizerConfig
---@field OwnerPriorityBoost float
local USphereWithOwnerBoostNetObjectPrioritizerConfig = {}



---@class UWorldLocationsConfig : UObject
---@field MinPos FVector
---@field MaxPos FVector
local UWorldLocationsConfig = {}



