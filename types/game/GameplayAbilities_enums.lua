---@enum EAbilityGenericReplicatedEvent
local EAbilityGenericReplicatedEvent = {
    GenericConfirm = 0,
    GenericCancel = 1,
    InputPressed = 2,
    InputReleased = 3,
    GenericSignalFromClient = 4,
    GenericSignalFromServer = 5,
    GameCustom1 = 6,
    GameCustom2 = 7,
    GameCustom3 = 8,
    GameCustom4 = 9,
    GameCustom5 = 10,
    GameCustom6 = 11,
    MAX = 12,
}

---@enum EAbilityTaskNetSyncType
local EAbilityTaskNetSyncType = {
    BothWait = 0,
    OnlyServerWait = 1,
    OnlyClientWait = 2,
    EAbilityTaskNetSyncType_MAX = 3,
}

---@enum EAbilityTaskWaitState
local EAbilityTaskWaitState = {
    WaitingOnGame = 1,
    WaitingOnUser = 2,
    WaitingOnAvatar = 4,
    EAbilityTaskWaitState_MAX = 5,
}

---@enum EAttributeBasedFloatCalculationType
local EAttributeBasedFloatCalculationType = {
    AttributeMagnitude = 0,
    AttributeBaseValue = 1,
    AttributeBonusMagnitude = 2,
    AttributeMagnitudeEvaluatedUpToChannel = 3,
    EAttributeBasedFloatCalculationType_MAX = 4,
}

---@enum EGameplayAbilityActivationMode
local EGameplayAbilityActivationMode = {
    Authority = 0,
    NonAuthority = 1,
    Predicting = 2,
    Confirmed = 3,
    Rejected = 4,
    EGameplayAbilityActivationMode_MAX = 5,
}

---@enum EGameplayAbilityInputBinds
local EGameplayAbilityInputBinds = {
    Ability1 = 0,
    Ability2 = 1,
    Ability3 = 2,
    Ability4 = 3,
    Ability5 = 4,
    Ability6 = 5,
    Ability7 = 6,
    Ability8 = 7,
    Ability9 = 8,
    EGameplayAbilityInputBinds_MAX = 9,
}

---@enum EGameplayAbilityInstancingPolicy
local EGameplayAbilityInstancingPolicy = {
    NonInstanced = 0,
    InstancedPerActor = 1,
    InstancedPerExecution = 2,
    EGameplayAbilityInstancingPolicy_MAX = 3,
}

---@enum EGameplayAbilityNetExecutionPolicy
local EGameplayAbilityNetExecutionPolicy = {
    LocalPredicted = 0,
    LocalOnly = 1,
    ServerInitiated = 2,
    ServerOnly = 3,
    EGameplayAbilityNetExecutionPolicy_MAX = 4,
}

---@enum EGameplayAbilityNetSecurityPolicy
local EGameplayAbilityNetSecurityPolicy = {
    ClientOrServer = 0,
    ServerOnlyExecution = 1,
    ServerOnlyTermination = 2,
    ServerOnly = 3,
    EGameplayAbilityNetSecurityPolicy_MAX = 4,
}

---@enum EGameplayAbilityReplicationPolicy
local EGameplayAbilityReplicationPolicy = {
    ReplicateNo = 0,
    ReplicateYes = 1,
    EGameplayAbilityReplicationPolicy_MAX = 2,
}

---@enum EGameplayAbilityTargetingLocationType
local EGameplayAbilityTargetingLocationType = {
    LiteralTransform = 0,
    ActorTransform = 1,
    SocketTransform = 2,
    EGameplayAbilityTargetingLocationType_MAX = 3,
}

---@enum EGameplayAbilityTriggerSource
local EGameplayAbilityTriggerSource = {
    GameplayEvent = 0,
    OwnedTagAdded = 1,
    OwnedTagPresent = 2,
    EGameplayAbilityTriggerSource_MAX = 3,
}

---@enum EGameplayCueEvent
local EGameplayCueEvent = {
    OnActive = 0,
    WhileActive = 1,
    Executed = 2,
    Removed = 3,
    EGameplayCueEvent_MAX = 4,
}

---@enum EGameplayCueNotify_AttachPolicy
local EGameplayCueNotify_AttachPolicy = {
    DoNotAttach = 0,
    AttachToTarget = 1,
    EGameplayCueNotify_MAX = 2,
}

---@enum EGameplayCueNotify_EffectPlaySpace
local EGameplayCueNotify_EffectPlaySpace = {
    WorldSpace = 0,
    CameraSpace = 1,
    EGameplayCueNotify_MAX = 2,
}

---@enum EGameplayCueNotify_LocallyControlledPolicy
local EGameplayCueNotify_LocallyControlledPolicy = {
    Always = 0,
    LocalOnly = 1,
    NotLocal = 2,
    EGameplayCueNotify_MAX = 3,
}

---@enum EGameplayCueNotify_LocallyControlledSource
local EGameplayCueNotify_LocallyControlledSource = {
    InstigatorActor = 0,
    TargetActor = 1,
    EGameplayCueNotify_MAX = 2,
}

---@enum EGameplayCuePayloadType
local EGameplayCuePayloadType = {
    CueParameters = 0,
    FromSpec = 1,
    EGameplayCuePayloadType_MAX = 2,
}

---@enum EGameplayEffectAttributeCaptureSource
local EGameplayEffectAttributeCaptureSource = {
    Source = 0,
    Target = 1,
    EGameplayEffectAttributeCaptureSource_MAX = 2,
}

---@enum EGameplayEffectDurationType
local EGameplayEffectDurationType = {
    Instant = 0,
    Infinite = 1,
    HasDuration = 2,
    EGameplayEffectDurationType_MAX = 3,
}

---@enum EGameplayEffectGrantedAbilityRemovePolicy
local EGameplayEffectGrantedAbilityRemovePolicy = {
    CancelAbilityImmediately = 0,
    RemoveAbilityOnEnd = 1,
    DoNothing = 2,
    EGameplayEffectGrantedAbilityRemovePolicy_MAX = 3,
}

---@enum EGameplayEffectMagnitudeCalculation
local EGameplayEffectMagnitudeCalculation = {
    ScalableFloat = 0,
    AttributeBased = 1,
    CustomCalculationClass = 2,
    SetByCaller = 3,
    EGameplayEffectMagnitudeCalculation_MAX = 4,
}

---@enum EGameplayEffectPeriodInhibitionRemovedPolicy
local EGameplayEffectPeriodInhibitionRemovedPolicy = {
    NeverReset = 0,
    ResetPeriod = 1,
    ExecuteAndResetPeriod = 2,
    EGameplayEffectPeriodInhibitionRemovedPolicy_MAX = 3,
}

---@enum EGameplayEffectReplicationMode
local EGameplayEffectReplicationMode = {
    Minimal = 0,
    Mixed = 1,
    Full = 2,
    EGameplayEffectReplicationMode_MAX = 3,
}

---@enum EGameplayEffectScopedModifierAggregatorType
local EGameplayEffectScopedModifierAggregatorType = {
    CapturedAttributeBacked = 0,
    Transient = 1,
    EGameplayEffectScopedModifierAggregatorType_MAX = 2,
}

---@enum EGameplayEffectStackingDurationPolicy
local EGameplayEffectStackingDurationPolicy = {
    RefreshOnSuccessfulApplication = 0,
    NeverRefresh = 1,
    EGameplayEffectStackingDurationPolicy_MAX = 2,
}

---@enum EGameplayEffectStackingExpirationPolicy
local EGameplayEffectStackingExpirationPolicy = {
    ClearEntireStack = 0,
    RemoveSingleStackAndRefreshDuration = 1,
    RefreshDuration = 2,
    EGameplayEffectStackingExpirationPolicy_MAX = 3,
}

---@enum EGameplayEffectStackingPeriodPolicy
local EGameplayEffectStackingPeriodPolicy = {
    ResetOnSuccessfulApplication = 0,
    NeverReset = 1,
    EGameplayEffectStackingPeriodPolicy_MAX = 2,
}

---@enum EGameplayEffectStackingType
local EGameplayEffectStackingType = {
    None = 0,
    AggregateBySource = 1,
    AggregateByTarget = 2,
    EGameplayEffectStackingType_MAX = 3,
}

---@enum EGameplayEffectVersion
local EGameplayEffectVersion = {
    Monolithic = 0,
    Modular53 = 1,
    AbilitiesComponent53 = 2,
    Current = 2,
    EGameplayEffectVersion_MAX = 3,
}

---@enum EGameplayModEvaluationChannel
local EGameplayModEvaluationChannel = {
    Channel0 = 0,
    Channel1 = 1,
    Channel2 = 2,
    Channel3 = 3,
    Channel4 = 4,
    Channel5 = 5,
    Channel6 = 6,
    Channel7 = 7,
    Channel8 = 8,
    Channel9 = 9,
    Channel_MAX = 10,
    EGameplayModEvaluationChannel_MAX = 11,
}

---@enum EGameplayModOp
local EGameplayModOp = {
    AddBase = 0,
    MultiplyAdditive = 1,
    DivideAdditive = 2,
    MultiplyCompound = 4,
    AddFinal = 5,
    Max = 6,
    Additive = 0,
    Multiplicitive = 1,
    Division = 2,
    Override = 3,
}

---@enum EGameplayTagEventType
local EGameplayTagEventType = {
    NewOrRemoved = 0,
    AnyCountChange = 1,
    EGameplayTagEventType_MAX = 2,
}

---@enum EGameplayTargetingConfirmation
local EGameplayTargetingConfirmation = {
    Instant = 0,
    UserConfirmed = 1,
    Custom = 2,
    CustomMulti = 3,
    EGameplayTargetingConfirmation_MAX = 4,
}

---@enum ERepAnimPositionMethod
local ERepAnimPositionMethod = {
    Position = 0,
    CurrentSectionId = 1,
    ERepAnimPositionMethod_MAX = 2,
}

---@enum ERootMotionMoveToActorTargetOffsetType
local ERootMotionMoveToActorTargetOffsetType = {
    AlignFromTargetToSource = 0,
    AlignToTargetForward = 1,
    AlignToWorldSpace = 2,
    ERootMotionMoveToActorTargetOffsetType_MAX = 3,
}

---@enum ETargetDataFilterSelf
local ETargetDataFilterSelf = {
    TDFS_Any = 0,
    TDFS_NoSelf = 1,
    TDFS_NoOthers = 2,
    TDFS_MAX = 3,
}

---@enum EWaitAttributeChangeComparison
local EWaitAttributeChangeComparison = {
    None = 0,
    GreaterThan = 1,
    LessThan = 2,
    GreaterThanOrEqualTo = 3,
    LessThanOrEqualTo = 4,
    NotEqualTo = 5,
    ExactlyEqualTo = 6,
    MAX = 7,
}

---@enum EWaitGameplayTagQueryTriggerCondition
local EWaitGameplayTagQueryTriggerCondition = {
    WhenTrue = 0,
    WhenFalse = 1,
    EWaitGameplayTagQueryTriggerCondition_MAX = 2,
}

