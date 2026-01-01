---@meta

---@class FBlueprintEnhancedInputActionBinding
---@field InputAction UInputAction
---@field TriggerEvent ETriggerEvent
---@field FunctionNameToBind FName
local FBlueprintEnhancedInputActionBinding = {}



---@class FBlueprintInputDebugKeyDelegateBinding
---@field InputChord FInputChord
---@field InputKeyEvent EInputEvent
---@field FunctionNameToBind FName
---@field bExecuteWhenPaused boolean
local FBlueprintInputDebugKeyDelegateBinding = {}



---@class FDefaultContextSetting
---@field InputMappingContext TSoftObjectPtr<UInputMappingContext>
---@field Priority int32
---@field bAddImmediately boolean
---@field bRegisterWithUserSettings boolean
local FDefaultContextSetting = {}



---@class FEnhancedActionKeyMapping
---@field Triggers TArray<UInputTrigger>
---@field Modifiers TArray<UInputModifier>
---@field Action UInputAction
---@field Key FKey
---@field bShouldBeIgnored boolean
---@field bHasAlwaysTickTrigger boolean
---@field SettingBehavior EPlayerMappableKeySettingBehaviors
---@field PlayerMappableKeySettings UPlayerMappableKeySettings
local FEnhancedActionKeyMapping = {}



---@class FInjectedInput
---@field Triggers TArray<UInputTrigger>
---@field Modifiers TArray<UInputModifier>
local FInjectedInput = {}



---@class FInjectedInputArray
---@field Injected TArray<FInjectedInput>
local FInjectedInputArray = {}



---@class FInputActionInstance
---@field SourceAction UInputAction
---@field TriggerEvent ETriggerEvent
---@field LastTriggeredWorldTime float
---@field Triggers TArray<UInputTrigger>
---@field Modifiers TArray<UInputModifier>
---@field ElapsedProcessedTime float
---@field ElapsedTriggeredTime float
local FInputActionInstance = {}



---@class FInputActionValue
local FInputActionValue = {}


---@class FInputCancelAction
---@field CancelAction UInputAction
---@field CancellationStates uint8
local FInputCancelAction = {}



---@class FInputComboStepData
---@field ComboStepAction UInputAction
---@field ComboStepCompletionStates uint8
---@field TimeToPressKey float
local FInputComboStepData = {}



---@class FKeyConsumptionOptions
local FKeyConsumptionOptions = {}


---@class FKeyMappingRow
---@field Mappings TSet<FPlayerKeyMapping>
local FKeyMappingRow = {}



---@class FMapPlayerKeyArgs
---@field MappingName FName
---@field Slot EPlayerMappableKeySlot
---@field NewKey FKey
---@field HardwareDeviceId FName
---@field ProfileId FGameplayTag
---@field bCreateMatchingSlotIfNeeded boolean
---@field bDeferOnSettingsChangedBroadcast boolean
local FMapPlayerKeyArgs = {}



---@class FMappingQueryIssue
---@field Issue EMappingQueryIssue
---@field BlockingContext UInputMappingContext
---@field BlockingAction UInputAction
local FMappingQueryIssue = {}



---@class FModifyContextOptions
---@field bIgnoreAllPressedKeysUntilRelease boolean
---@field bForceImmediately boolean
---@field bNotifyUserSettings boolean
local FModifyContextOptions = {}



---@class FPlayerKeyMapping
---@field MappingName FName
---@field DisplayName FText
---@field DisplayCategory FText
---@field Slot EPlayerMappableKeySlot
---@field bIsDirty boolean
---@field DefaultKey FKey
---@field CurrentKey FKey
---@field HardwareDeviceId FHardwareDeviceIdentifier
---@field AssociatedInputAction UInputAction
local FPlayerKeyMapping = {}



---@class FPlayerMappableKeyOptions
---@field MetaData UObject
---@field Name FName
---@field DisplayName FText
---@field DisplayCategory FText
local FPlayerMappableKeyOptions = {}



---@class FPlayerMappableKeyProfileCreationArgs
---@field ProfileType TSubclassOf<UEnhancedPlayerMappableKeyProfile>
---@field ProfileIdentifier FGameplayTag
---@field UserId FPlatformUserId
---@field DisplayName FText
---@field bSetAsCurrentProfile boolean
local FPlayerMappableKeyProfileCreationArgs = {}



---@class FPlayerMappableKeyQueryOptions
---@field MappingName FName
---@field KeyToMatch FKey
---@field SlotToMatch EPlayerMappableKeySlot
---@field bMatchBasicKeyTypes boolean
---@field bMatchKeyAxisType boolean
---@field RequiredDeviceType EHardwareDevicePrimaryType
---@field RequiredDeviceFlags int32
local FPlayerMappableKeyQueryOptions = {}



---@class FPlayerMappableKeySlot
---@field SlotNumber int32
local FPlayerMappableKeySlot = {}



---@class IEnhancedInputSubsystemInterface : IInterface
local IEnhancedInputSubsystemInterface = {}

---@param MappingName FName
---@param RawValue FInputActionValue
function IEnhancedInputSubsystemInterface:UpdateValueOfContinuousInputInjectionForPlayerMapping(MappingName, RawValue) end
---@param Action UInputAction
---@param RawValue FInputActionValue
function IEnhancedInputSubsystemInterface:UpdateValueOfContinuousInputInjectionForAction(Action, RawValue) end
---@param MappingName FName
function IEnhancedInputSubsystemInterface:StopContinuousInputInjectionForPlayerMapping(MappingName) end
---@param Action UInputAction
function IEnhancedInputSubsystemInterface:StopContinuousInputInjectionForAction(Action) end
---@param MappingName FName
---@param RawValue FInputActionValue
---@param Modifiers TArray<UInputModifier>
---@param Triggers TArray<UInputTrigger>
function IEnhancedInputSubsystemInterface:StartContinuousInputInjectionForPlayerMapping(MappingName, RawValue, Modifiers, Triggers) end
---@param Action UInputAction
---@param RawValue FInputActionValue
---@param Modifiers TArray<UInputModifier>
---@param Triggers TArray<UInputTrigger>
function IEnhancedInputSubsystemInterface:StartContinuousInputInjectionForAction(Action, RawValue, Modifiers, Triggers) end
---@param Options FModifyContextOptions
---@param RebuildType EInputMappingRebuildType
function IEnhancedInputSubsystemInterface:RequestRebuildControlMappings(Options, RebuildType) end
---@param MappingContext UInputMappingContext
---@param Options FModifyContextOptions
function IEnhancedInputSubsystemInterface:RemoveMappingContext(MappingContext, Options) end
---@param PrioritizedActiveContexts TArray<UInputMappingContext>
---@param InputContext UInputMappingContext
---@param Action UInputAction
---@param Key FKey
---@param OutIssues TArray<FMappingQueryIssue>
---@param BlockingIssues EMappingQueryIssue
---@return EMappingQueryResult
function IEnhancedInputSubsystemInterface:QueryMapKeyInContextSet(PrioritizedActiveContexts, InputContext, Action, Key, OutIssues, BlockingIssues) end
---@param InputContext UInputMappingContext
---@param Action UInputAction
---@param Key FKey
---@param OutIssues TArray<FMappingQueryIssue>
---@param BlockingIssues EMappingQueryIssue
---@return EMappingQueryResult
function IEnhancedInputSubsystemInterface:QueryMapKeyInActiveContextSet(InputContext, Action, Key, OutIssues, BlockingIssues) end
---@param Action UInputAction
---@return TArray<FKey>
function IEnhancedInputSubsystemInterface:QueryKeysMappedToAction(Action) end
---@param Settings UEnhancedInputUserSettings
function IEnhancedInputSubsystemInterface:OnUserSettingsChanged(Settings) end
---@param InNewProfile UEnhancedPlayerMappableKeyProfile
function IEnhancedInputSubsystemInterface:OnUserKeyProfileChanged(InNewProfile) end
---@param MappingName FName
---@param Value FVector
---@param Modifiers TArray<UInputModifier>
---@param Triggers TArray<UInputTrigger>
function IEnhancedInputSubsystemInterface:InjectInputVectorForPlayerMapping(MappingName, Value, Modifiers, Triggers) end
---@param Action UInputAction
---@param Value FVector
---@param Modifiers TArray<UInputModifier>
---@param Triggers TArray<UInputTrigger>
function IEnhancedInputSubsystemInterface:InjectInputVectorForAction(Action, Value, Modifiers, Triggers) end
---@param MappingName FName
---@param RawValue FInputActionValue
---@param Modifiers TArray<UInputModifier>
---@param Triggers TArray<UInputTrigger>
function IEnhancedInputSubsystemInterface:InjectInputForPlayerMapping(MappingName, RawValue, Modifiers, Triggers) end
---@param Action UInputAction
---@param RawValue FInputActionValue
---@param Modifiers TArray<UInputModifier>
---@param Triggers TArray<UInputTrigger>
function IEnhancedInputSubsystemInterface:InjectInputForAction(Action, RawValue, Modifiers, Triggers) end
---@param MappingContext UInputMappingContext
---@param OutFoundPriority int32
---@return boolean
function IEnhancedInputSubsystemInterface:HasMappingContext(MappingContext, OutFoundPriority) end
---@return UEnhancedInputUserSettings
function IEnhancedInputSubsystemInterface:GetUserSettings() end
---@return TArray<FEnhancedActionKeyMapping>
function IEnhancedInputSubsystemInterface:GetAllPlayerMappableActionKeyMappings() end
function IEnhancedInputSubsystemInterface:ClearAllMappings() end
---@param MappingContext UInputMappingContext
---@param Priority int32
---@param Options FModifyContextOptions
function IEnhancedInputSubsystemInterface:AddMappingContext(MappingContext, Priority, Options) end


---@class UEnhancedInputActionDelegateBinding : UInputDelegateBinding
---@field InputActionDelegateBindings TArray<FBlueprintEnhancedInputActionBinding>
local UEnhancedInputActionDelegateBinding = {}



---@class UEnhancedInputActionValueBinding : UInputDelegateBinding
---@field InputActionValueBindings TArray<FBlueprintEnhancedInputActionBinding>
local UEnhancedInputActionValueBinding = {}



---@class UEnhancedInputComponent : UInputComponent
local UEnhancedInputComponent = {}

---@param Action UInputAction
---@return FInputActionValue
function UEnhancedInputComponent:GetBoundActionValue(Action) end


---@class UEnhancedInputDeveloperSettings : UDeveloperSettingsBackedByCVars
---@field DefaultMappingContexts TArray<FDefaultContextSetting>
---@field DefaultWorldSubsystemMappingContexts TArray<FDefaultContextSetting>
---@field PlatformSettings FPerPlatformSettings
---@field UserSettingsClass TSoftClassPtr<UEnhancedInputUserSettings>
---@field DefaultPlayerMappableKeyProfileClass TSoftClassPtr<UEnhancedPlayerMappableKeyProfile>
---@field DefaultWorldInputClass TSoftClassPtr<UEnhancedPlayerInput>
---@field bSendTriggeredEventsWhenInputIsFlushed boolean
---@field bEnableUserSettings boolean
---@field bEnableDefaultMappingContexts boolean
---@field bShouldOnlyTriggerLastActionInChord boolean
---@field bLogOnDeprecatedConfigUsed boolean
---@field bEnableWorldSubsystem boolean
---@field bShouldLogAllWorldSubsystemInputs boolean
local UEnhancedInputDeveloperSettings = {}



---@class UEnhancedInputLibrary : UBlueprintFunctionLibrary
local UEnhancedInputLibrary = {}

---@param Context UInputMappingContext
---@param bForceImmediately boolean
function UEnhancedInputLibrary:RequestRebuildControlMappingsUsingContext(Context, bForceImmediately) end
---@param X double
---@param Y double
---@param Z double
---@param ValueType EInputActionValueType
---@return FInputActionValue
function UEnhancedInputLibrary:MakeInputActionValueOfType(X, Y, Z, ValueType) end
---@param X double
---@param Y double
---@param Z double
---@param MatchValueType FInputActionValue
---@return FInputActionValue
function UEnhancedInputLibrary:MakeInputActionValue(X, Y, Z, MatchValueType) end
---@param ActionKeyMapping FEnhancedActionKeyMapping
---@return boolean
function UEnhancedInputLibrary:IsActionKeyMappingPlayerMappable(ActionKeyMapping) end
---@return FPlayerMappableKeySlot
function UEnhancedInputLibrary:GetThirdPlayerMappableKeySlot() end
---@return FPlayerMappableKeySlot
function UEnhancedInputLibrary:GetSecondPlayerMappableKeySlot() end
---@param ActionKeyMapping FEnhancedActionKeyMapping
---@return UPlayerMappableKeySettings
function UEnhancedInputLibrary:GetPlayerMappableKeySettings(ActionKeyMapping) end
---@param ActionKeyMapping FEnhancedActionKeyMapping
---@return FName
function UEnhancedInputLibrary:GetMappingName(ActionKeyMapping) end
---@return FPlayerMappableKeySlot
function UEnhancedInputLibrary:GetFourthPlayerMappableKeySlot() end
---@return FPlayerMappableKeySlot
function UEnhancedInputLibrary:GetFirstPlayerMappableKeySlot() end
---@param Actor AActor
---@param Action UInputAction
---@return FInputActionValue
function UEnhancedInputLibrary:GetBoundActionValue(Actor, Action) end
---@param PlayerController APlayerController
function UEnhancedInputLibrary:FlushPlayerInput(PlayerController) end
---@param TriggerEvent ETriggerEvent
---@return FString
function UEnhancedInputLibrary:Conv_TriggerEventValueToString(TriggerEvent) end
---@param ActionValue FInputActionValue
---@return FString
function UEnhancedInputLibrary:Conv_InputActionValueToString(ActionValue) end
---@param InValue FInputActionValue
---@return boolean
function UEnhancedInputLibrary:Conv_InputActionValueToBool(InValue) end
---@param ActionValue FInputActionValue
---@return FVector
function UEnhancedInputLibrary:Conv_InputActionValueToAxis3D(ActionValue) end
---@param InValue FInputActionValue
---@return FVector2D
function UEnhancedInputLibrary:Conv_InputActionValueToAxis2D(InValue) end
---@param InValue FInputActionValue
---@return double
function UEnhancedInputLibrary:Conv_InputActionValueToAxis1D(InValue) end
---@param InActionValue FInputActionValue
---@param X double
---@param Y double
---@param Z double
---@param Type EInputActionValueType
function UEnhancedInputLibrary:BreakInputActionValue(InActionValue, X, Y, Z, Type) end


---@class UEnhancedInputLocalPlayerSubsystem : ULocalPlayerSubsystem
---@field ControlMappingsRebuiltDelegate FEnhancedInputLocalPlayerSubsystemControlMappingsRebuiltDelegate
---@field UserSettings UEnhancedInputUserSettings
---@field ContinuouslyInjectedInputs TMap<UInputAction, FInjectedInput>
local UEnhancedInputLocalPlayerSubsystem = {}

function UEnhancedInputLocalPlayerSubsystem:OnControlMappingsRebuilt__DelegateSignature() end


---@class UEnhancedInputPlatformData : UObject
---@field MappingContextRedirects TMap<UInputMappingContext, UInputMappingContext>
local UEnhancedInputPlatformData = {}

---@param InContext UInputMappingContext
---@return UInputMappingContext
function UEnhancedInputPlatformData:GetContextRedirect(InContext) end


---@class UEnhancedInputPlatformSettings : UPlatformSettings
---@field InputData TArray<TSoftClassPtr<UEnhancedInputPlatformData>>
---@field InputDataClasses TArray<TSubclassOf<UEnhancedInputPlatformData>>
---@field bShouldLogMappingContextRedirects boolean
local UEnhancedInputPlatformSettings = {}



---@class UEnhancedInputUserSettings : USaveGame
---@field OnSettingsChanged FEnhancedInputUserSettingsOnSettingsChanged
---@field OnSettingsApplied FEnhancedInputUserSettingsOnSettingsApplied
---@field CurrentProfileIdentifier FGameplayTag
---@field SavedKeyProfiles TMap<FGameplayTag, UEnhancedPlayerMappableKeyProfile>
---@field OwningLocalPlayer TWeakObjectPtr<ULocalPlayer>
---@field RegisteredMappingContexts TSet<UInputMappingContext>
local UEnhancedInputUserSettings = {}

---@param MappingContexts TSet<UInputMappingContext>
---@return boolean
function UEnhancedInputUserSettings:UnregisterInputMappingContexts(MappingContexts) end
---@param IMC UInputMappingContext
---@return boolean
function UEnhancedInputUserSettings:UnregisterInputMappingContext(IMC) end
---@param InArgs FMapPlayerKeyArgs
---@param FailureReason FGameplayTagContainer
function UEnhancedInputUserSettings:UnMapPlayerKey(InArgs, FailureReason) end
---@param InProfileId FGameplayTag
---@return boolean
function UEnhancedInputUserSettings:SetKeyProfile(InProfileId) end
function UEnhancedInputUserSettings:SaveSettings() end
---@param ProfileId FGameplayTag
---@param FailureReason FGameplayTagContainer
function UEnhancedInputUserSettings:ResetKeyProfileToDefault(ProfileId, FailureReason) end
---@param InArgs FMapPlayerKeyArgs
---@param FailureReason FGameplayTagContainer
function UEnhancedInputUserSettings:ResetAllPlayerKeysInRow(InArgs, FailureReason) end
---@param MappingContexts TSet<UInputMappingContext>
---@return boolean
function UEnhancedInputUserSettings:RegisterInputMappingContexts(MappingContexts) end
---@param IMC UInputMappingContext
---@return boolean
function UEnhancedInputUserSettings:RegisterInputMappingContext(IMC) end
---@param InArgs FMapPlayerKeyArgs
---@param FailureReason FGameplayTagContainer
function UEnhancedInputUserSettings:MapPlayerKey(InArgs, FailureReason) end
---@param IMC UInputMappingContext
function UEnhancedInputUserSettings:MappingContextRegisteredWithSettings__DelegateSignature(IMC) end
---@param NewProfile UEnhancedPlayerMappableKeyProfile
function UEnhancedInputUserSettings:MappableKeyProfileChanged__DelegateSignature(NewProfile) end
---@param IMC UInputMappingContext
---@return boolean
function UEnhancedInputUserSettings:IsMappingContextRegistered(IMC) end
---@param ProfileId FGameplayTag
---@return UEnhancedPlayerMappableKeyProfile
function UEnhancedInputUserSettings:GetKeyProfileWithIdentifier(ProfileId) end
---@return FGameplayTag
function UEnhancedInputUserSettings:GetCurrentKeyProfileIdentifier() end
---@return UEnhancedPlayerMappableKeyProfile
function UEnhancedInputUserSettings:GetCurrentKeyProfile() end
---@param MappingName FName
---@return TSet<FPlayerKeyMapping>
function UEnhancedInputUserSettings:FindMappingsInRow(MappingName) end
---@param Settings UEnhancedInputUserSettings
function UEnhancedInputUserSettings:EnhancedInputUserSettingsChanged__DelegateSignature(Settings) end
function UEnhancedInputUserSettings:EnhancedInputUserSettingsApplied__DelegateSignature() end
---@param InArgs FPlayerMappableKeyProfileCreationArgs
---@return UEnhancedPlayerMappableKeyProfile
function UEnhancedInputUserSettings:CreateNewKeyProfile(InArgs) end
function UEnhancedInputUserSettings:AsyncSaveSettings() end
function UEnhancedInputUserSettings:ApplySettings() end


---@class UEnhancedInputWorldSubsystem : UWorldSubsystem
---@field PlayerInput UEnhancedPlayerInput
---@field CurrentInputStack TArray<TWeakObjectPtr<UInputComponent>>
---@field ContinuouslyInjectedInputs TMap<UInputAction, FInjectedInput>
local UEnhancedInputWorldSubsystem = {}

---@param Actor AActor
---@return boolean
function UEnhancedInputWorldSubsystem:RemoveActorInputComponent(Actor) end
---@param Actor AActor
function UEnhancedInputWorldSubsystem:AddActorInputComponent(Actor) end


---@class UEnhancedPlayerInput : UPlayerInput
---@field KeyConsumptionData TMap<UInputAction, FKeyConsumptionOptions>
---@field AppliedInputContexts TMap<UInputMappingContext, int32>
---@field EnhancedActionMappings TArray<FEnhancedActionKeyMapping>
---@field ActionInstanceData TMap<UInputAction, FInputActionInstance>
---@field KeysPressedThisTick TMap<FKey, FVector>
---@field InputsInjectedThisTick TMap<UInputAction, FInjectedInputArray>
---@field LastInjectedActions TSet<UInputAction>
local UEnhancedPlayerInput = {}



---@class UEnhancedPlayerMappableKeyProfile : UObject
---@field ProfileIdentifier FGameplayTag
---@field OwningUserId FPlatformUserId
---@field DisplayName FText
---@field PlayerMappedKeys TMap<FName, FKeyMappingRow>
local UEnhancedPlayerMappableKeyProfile = {}

---@return FString
function UEnhancedPlayerMappableKeyProfile:ToString() end
---@param NewDisplayName FText
function UEnhancedPlayerMappableKeyProfile:SetDisplayName(NewDisplayName) end
function UEnhancedPlayerMappableKeyProfile:ResetToDefault() end
---@param InMappingName FName
function UEnhancedPlayerMappableKeyProfile:ResetMappingToDefault(InMappingName) end
---@param Options FPlayerMappableKeyQueryOptions
---@param OutKeys TArray<FKey>
---@return int32
function UEnhancedPlayerMappableKeyProfile:QueryPlayerMappedKeys(Options, OutKeys) end
---@param OutKeyMapping FPlayerKeyMapping
---@param InArgs FMapPlayerKeyArgs
function UEnhancedPlayerMappableKeyProfile:K2_FindKeyMapping(OutKeyMapping, InArgs) end
---@return FGameplayTag
function UEnhancedPlayerMappableKeyProfile:GetProfileIdentifer() end
---@return FText
function UEnhancedPlayerMappableKeyProfile:GetProfileDisplayName() end
---@return TMap<FName, FKeyMappingRow>
function UEnhancedPlayerMappableKeyProfile:GetPlayerMappingRows() end
---@param InKey FKey
---@param OutMappingNames TArray<FName>
---@return int32
function UEnhancedPlayerMappableKeyProfile:GetMappingNamesForKey(InKey, OutMappingNames) end
---@param MappingName FName
---@param OutKeys TArray<FKey>
---@return int32
function UEnhancedPlayerMappableKeyProfile:GetMappedKeysInRow(MappingName, OutKeys) end
function UEnhancedPlayerMappableKeyProfile:DumpProfileToLog() end
---@param PlayerMapping FPlayerKeyMapping
---@param Options FPlayerMappableKeyQueryOptions
---@return boolean
function UEnhancedPlayerMappableKeyProfile:DoesMappingPassQueryOptions(PlayerMapping, Options) end


---@class UInputAction : UDataAsset
---@field ActionDescription FText
---@field bTriggerWhenPaused boolean
---@field bConsumeInput boolean
---@field bConsumesActionAndAxisMappings boolean
---@field bReserveAllMappings boolean
---@field TriggerEventsThatConsumeLegacyKeys int32
---@field ValueType EInputActionValueType
---@field AccumulationBehavior EInputActionAccumulationBehavior
---@field Triggers TArray<UInputTrigger>
---@field Modifiers TArray<UInputModifier>
---@field PlayerMappableKeySettings UPlayerMappableKeySettings
local UInputAction = {}



---@class UInputDebugKeyDelegateBinding : UInputDelegateBinding
---@field InputDebugKeyDelegateBindings TArray<FBlueprintInputDebugKeyDelegateBinding>
local UInputDebugKeyDelegateBinding = {}



---@class UInputMappingContext : UDataAsset
---@field Mappings TArray<FEnhancedActionKeyMapping>
---@field ContextDescription FText
local UInputMappingContext = {}

---@param Action UInputAction
---@param Key FKey
function UInputMappingContext:UnmapKey(Action, Key) end
---@param Action UInputAction
function UInputMappingContext:UnmapAllKeysFromAction(Action) end
function UInputMappingContext:UnmapAll() end
---@param Action UInputAction
function UInputMappingContext:UnmapAction(Action) end
---@param Action UInputAction
---@param ToKey FKey
---@return FEnhancedActionKeyMapping
function UInputMappingContext:MapKey(Action, ToKey) end


---@class UInputModifier : UObject
local UInputModifier = {}

---@param PlayerInput UEnhancedPlayerInput
---@param CurrentValue FInputActionValue
---@param DeltaTime float
---@return FInputActionValue
function UInputModifier:ModifyRaw(PlayerInput, CurrentValue, DeltaTime) end
---@param SampleValue FInputActionValue
---@param FinalValue FInputActionValue
---@return FLinearColor
function UInputModifier:GetVisualizationColor(SampleValue, FinalValue) end


---@class UInputModifierDeadZone : UInputModifier
---@field LowerThreshold float
---@field UpperThreshold float
---@field Type EDeadZoneType
local UInputModifierDeadZone = {}



---@class UInputModifierFOVScaling : UInputModifier
---@field FOVScale float
---@field FOVScalingType EFOVScalingType
local UInputModifierFOVScaling = {}



---@class UInputModifierNegate : UInputModifier
---@field bX boolean
---@field bY boolean
---@field bZ boolean
local UInputModifierNegate = {}



---@class UInputModifierResponseCurveExponential : UInputModifier
---@field CurveExponent FVector
local UInputModifierResponseCurveExponential = {}



---@class UInputModifierResponseCurveUser : UInputModifier
---@field ResponseX UCurveFloat
---@field ResponseY UCurveFloat
---@field ResponseZ UCurveFloat
local UInputModifierResponseCurveUser = {}



---@class UInputModifierScalar : UInputModifier
---@field Scalar FVector
local UInputModifierScalar = {}



---@class UInputModifierScaleByDeltaTime : UInputModifier
local UInputModifierScaleByDeltaTime = {}


---@class UInputModifierSmooth : UInputModifier
local UInputModifierSmooth = {}


---@class UInputModifierSmoothDelta : UInputModifier
---@field SmoothingMethod ENormalizeInputSmoothingType
---@field Speed float
---@field EasingExponent float
local UInputModifierSmoothDelta = {}



---@class UInputModifierSwizzleAxis : UInputModifier
---@field Order EInputAxisSwizzle
local UInputModifierSwizzleAxis = {}



---@class UInputModifierToWorldSpace : UInputModifier
local UInputModifierToWorldSpace = {}


---@class UInputTrigger : UObject
---@field ActuationThreshold float
---@field bShouldAlwaysTick boolean
---@field LastValue FInputActionValue
local UInputTrigger = {}

---@param PlayerInput UEnhancedPlayerInput
---@param ModifiedValue FInputActionValue
---@param DeltaTime float
---@return ETriggerState
function UInputTrigger:UpdateState(PlayerInput, ModifiedValue, DeltaTime) end
---@param ForValue FInputActionValue
---@return boolean
function UInputTrigger:IsActuated(ForValue) end
---@return ETriggerType
function UInputTrigger:GetTriggerType() end


---@class UInputTriggerChordAction : UInputTrigger
---@field ChordAction UInputAction
local UInputTriggerChordAction = {}



---@class UInputTriggerChordBlocker : UInputTriggerChordAction
local UInputTriggerChordBlocker = {}


---@class UInputTriggerCombo : UInputTrigger
---@field CurrentComboStepIndex int32
---@field CurrentTimeBetweenComboSteps float
---@field ComboActions TArray<FInputComboStepData>
---@field InputCancelActions TArray<FInputCancelAction>
local UInputTriggerCombo = {}



---@class UInputTriggerDown : UInputTrigger
local UInputTriggerDown = {}


---@class UInputTriggerHold : UInputTriggerTimedBase
---@field HoldTimeThreshold float
---@field bIsOneShot boolean
local UInputTriggerHold = {}



---@class UInputTriggerHoldAndRelease : UInputTriggerTimedBase
---@field HoldTimeThreshold float
local UInputTriggerHoldAndRelease = {}



---@class UInputTriggerPressed : UInputTrigger
local UInputTriggerPressed = {}


---@class UInputTriggerPulse : UInputTriggerTimedBase
---@field bTriggerOnStart boolean
---@field Interval float
---@field TriggerLimit int32
local UInputTriggerPulse = {}



---@class UInputTriggerReleased : UInputTrigger
local UInputTriggerReleased = {}


---@class UInputTriggerTap : UInputTriggerTimedBase
---@field TapReleaseTimeThreshold float
local UInputTriggerTap = {}



---@class UInputTriggerTimedBase : UInputTrigger
---@field HeldDuration float
---@field bAffectedByTimeDilation boolean
local UInputTriggerTimedBase = {}



---@class UPlayerMappableInputConfig : UPrimaryDataAsset
---@field ConfigName FName
---@field ConfigDisplayName FText
---@field bIsDeprecated boolean
---@field MetaData UObject
---@field Contexts TMap<UInputMappingContext, int32>
local UPlayerMappableInputConfig = {}

function UPlayerMappableInputConfig:ResetToDefault() end
---@return boolean
function UPlayerMappableInputConfig:IsDeprecated() end
---@return TArray<FEnhancedActionKeyMapping>
function UPlayerMappableInputConfig:GetPlayerMappableKeys() end
---@return UObject
function UPlayerMappableInputConfig:GetMetadata() end
---@return TMap<UInputMappingContext, int32>
function UPlayerMappableInputConfig:GetMappingContexts() end
---@param MappingName FName
---@return FEnhancedActionKeyMapping
function UPlayerMappableInputConfig:GetMappingByName(MappingName) end
---@param InAction UInputAction
---@return TArray<FEnhancedActionKeyMapping>
function UPlayerMappableInputConfig:GetKeysBoundToAction(InAction) end
---@return FText
function UPlayerMappableInputConfig:GetDisplayName() end
---@return FName
function UPlayerMappableInputConfig:GetConfigName() end


---@class UPlayerMappableKeySettings : UObject
---@field MetaData UObject
---@field Name FName
---@field DisplayName FText
---@field DisplayCategory FText
---@field SupportedKeyProfiles FGameplayTagContainer
local UPlayerMappableKeySettings = {}



