---@meta

---@class AMHWheelTester : AActor
---@field VerticalLoadInKg float
---@field GroundSpeedMeterPerSec float
---@field GroundLateralSpeedMeterPerSec float
---@field WheelSpeedMeterPerSec float
---@field RootBodyComponent USphereComponent
---@field WheelComponent UMHWheelComponent
local AMHWheelTester = {}

---@return UMHWheelComponent
function AMHWheelTester:GetWheelComponent() end


---@class AMTAICharacterController : AAIController
local AMTAICharacterController = {}


---@class AMTAICharacterSpawnConfig : AInfo
---@field NumResidents int32
---@field NumPedestrian int32
---@field NumHitchhikers int32
---@field NumTaxiPassengers int32
---@field NumAmbulancePassengers int32
---@field NumSearchAndRescuePassengers int32
---@field MinHitchhikingDistance float
---@field BusStopExtraMultiplier float
---@field Entries TArray<FMTAICharacterSpawnConfigEntry>
local AMTAICharacterSpawnConfig = {}



---@class AMTAIVehicleSpawnSystem : AInfo
---@field SpawnSettings TArray<FMTAIVehicleSpawnSetting>
---@field DeliveryVehicleSpawnPoints TArray<AMTDeliveryVehicleSpawnPoint>
local AMTAIVehicleSpawnSystem = {}

---@param HUD AMTHUD
function AMTAIVehicleSpawnSystem:OnHUDDraw(HUD) end


---@class AMTARMarker : AActor
---@field WidgetComponent UWidgetComponent
---@field VerticalScreenSize float
---@field ViewDistance float
---@field CameraZOffset float
---@field bAdjustOffsetToZ boolean
---@field Widget UARMarkerWidget
---@field IconWidgetClass TSubclassOf<UIconWidget>
---@field MarkerOwnerActor AActor
local AMTARMarker = {}



---@class AMTActorPreview : AActor
---@field RootSceneComponent USceneComponent
---@field SceneCaptureComponent USceneCaptureComponent2D
---@field RenderTarget UTextureRenderTarget2D
---@field PreviewActor AActor
---@field SpawnedPreviewActorClass UClass
local AMTActorPreview = {}



---@class AMTActorSpawnerBase : AActor
---@field EditorPreviewActorClass TSubclassOf<AActor>
---@field EditorPreviewMesh UStaticMesh
---@field SpawnDelayAfterMissing float
---@field EditorPreviewActor AActor
---@field SpawnedActor AActor
---@field SceneComponent USceneComponent
local AMTActorSpawnerBase = {}



---@class AMTAlwaysLoadedChildActorSystem : AInfo
---@field Actors TArray<FMTAlwaysLoadedChildActor>
local AMTAlwaysLoadedChildActorSystem = {}

function AMTAlwaysLoadedChildActorSystem:ClearActors() end
function AMTAlwaysLoadedChildActorSystem:BuildActors() end


---@class AMTAreaVolume : AVolume
---@field AreaName FText
---@field AreaNameTexts FMTTextByTexts
---@field ZoneKey FName
---@field ZoneColor FLinearColor
---@field AreaVolumeFlags TArray<EMTAreaVolumeFlags>
---@field POIs TArray<AMTPointOfInterest>
---@field TopViewLines TArray<FVector>
local AMTAreaVolume = {}



---@class AMTAutocrossCone : AStaticMeshActor
local AMTAutocrossCone = {}


---@class AMTBank : AInfo
local AMTBank = {}


---@class AMTBreakable : AStaticMeshActor
---@field OnBroken FMTBreakableOnBroken
---@field LinearBreakThreshold float
---@field TriggerRadius float
---@field DespawnAfterBreakSeconds float
---@field BrokenMaterialParameterName FName
---@field bDetachFromParentOnBeginPlay boolean
---@field bDetachChildActorsOnActivateConstraint boolean
---@field bDisableVehicleCollisionAfterBreak boolean
---@field TriggerSphere USphereComponent
---@field Constraint UMTConstraintComponent
---@field OriginalParentComponent USceneComponent
---@field OriginalRelativeTransform FTransform
---@field Net_BreakableRuntimeFlags uint32
---@field OverlappedVehicles TArray<AMTVehicle>
---@field Debug_CollisionIgnoredComponents TArray<UPrimitiveComponent>
local AMTBreakable = {}

function AMTBreakable:ReceiveBroken() end
function AMTBreakable:OnRep_BreakableRuntimeFlags() end
---@return boolean
function AMTBreakable:IsBroken() end
---@param ConstraintIndex int32
function AMTBreakable:HandleConstraintBroken(ConstraintIndex) end


---@class AMTBuilding : AActor
---@field SceneComponent USceneComponent
---@field AreaBoudingBox UBoxComponent
---@field CollisionBox UBoxComponent
---@field InteractionLocator USceneComponent
---@field DeliveryLocator USceneComponent
---@field BuildingType EMTBuildingType
---@field Construction AMTBuildingConstruction
---@field Server_ConstructionDeliveryPoint AMTDeliveryPoint
---@field Net_DepotDeliveryPoint AMTDeliveryPoint
---@field Net_BuildingKey FName
---@field Net_BuildingGuid FGuid
---@field Net_OwnerUniqueNetId FString
---@field Net_OwnerCharacterGuid FGuid
---@field Net_BuildingStep int32
---@field Net_ItemInventory FMTItemInventory
---@field Net_DeliveredMaterials TArray<FMTBuildingMaterialNet>
---@field Net_House AMTHouse
---@field Net_ParkedVehicles TArray<FMTParkedVehicleNet>
---@field ParkingSpaces TArray<AMTParkingSpace>
local AMTBuilding = {}

function AMTBuilding:UpdateAreaBoudingBox() end
function AMTBuilding:OnRep_ParkedVehicleIds() end
function AMTBuilding:OnRep_ItemInventory() end
function AMTBuilding:OnRep_DeliveredMaterials() end
function AMTBuilding:OnRep_BuildingStep() end
function AMTBuilding:OnRep_BuildingKey() end
function AMTBuilding:OnRep_BuildingGuid() end
function AMTBuilding:MulticastSpawnConstructionSmokes() end


---@class AMTBuildingConstruction : AActor
---@field SceneComponent USceneComponent
---@field Interactable UMTInteractableComponent
---@field Building AMTBuilding
---@field Marker AMTARMarker
local AMTBuildingConstruction = {}



---@class AMTBusStop : AActor
---@field BusStopGuid FGuid
---@field BusStopDisplayName FText
---@field BusStopName FMTTextByTexts
---@field PassengerSpawnPeriodMinMax FVector2D
---@field ResidentFeatures TSet<EMTAIResidentFeature>
---@field PassengerSpawnBox FBox2D
---@field BusStopFlags TSet<EMTBusStopFlags>
---@field ParkingMeshComponent UStaticMeshComponent
---@field PassengerSpawnBoxComponent UBoxComponent
---@field AIDestinationComponent USceneComponent
---@field bUseAIDestination boolean
---@field AdditionalDestinations TArray<AMTBusStop>
---@field InteractionBuses TArray<UMTVehicleBusComponent>
---@field InteractionVisibleBuses TArray<UMTVehicleBusComponent>
---@field Terminal AMTBusStop
---@field ZoneVolume AMTAreaVolume
---@field InteractableComponent UMTInteractableComponent
---@field Net_Passengers TArray<AMTCharacter>
---@field Net_BasePaymentToTerminal int32
local AMTBusStop = {}

---@param Actor AActor
function AMTBusStop:Server_HandlePassengerActorDestroyed(Actor) end
function AMTBusStop:GenerateBusStopGuid() end


---@class AMTBusSystem : AActor
---@field Routes TArray<FMTBusRoute>
---@field AllRoutes TArray<FMTBusRoute>
---@field OwnCompanyRoutes TArray<FMTCompanyBusRoute>
---@field JoinedCompanyRoutes TArray<FMTCompanyBusRoute>
---@field BusStops TArray<AMTBusStop>
---@field BusComponents TArray<UMTVehicleBusComponent>
---@field RoutePathFinders TArray<UMTBusRoutePathFinder>
local AMTBusSystem = {}

function AMTBusSystem:LoadRouteFromClipboard() end
function AMTBusSystem:CalculateRoute() end


---@class AMTCargo : AActor
---@field bCanPickup boolean
---@field bCanAutoload boolean
---@field Net_bIsAttachedDummy boolean
---@field Mesh UStaticMeshComponent
---@field CollisionResponse_NoSimulate FCollisionResponseContainer
---@field CollisionResponse_NoSimulateAttached FCollisionResponseContainer
---@field DumpParticle UParticleSystem
---@field DumpSound USoundBase
---@field EmptyContainerMass float
---@field PickupSound USoundBase
---@field HitSound USoundBase
---@field InteractableComponent UMTInteractableComponent
---@field Net_DroppedCargoSpace UMTVehicleCargoSpaceComponent
---@field Net_MovementOwnerPC AMotorTownPlayerController
---@field Server_ManualLoadingPaidPC AMotorTownPlayerController
---@field Server_LastMovementOwnerPC AMotorTownPlayerController
---@field Server_TempMovementOwnerPCs TMap<AMotorTownPlayerController, double>
---@field DestinationInteractionActor AMTInteractionMeshActor
---@field Net_CargoKey FName
---@field Net_ColorIndex int32
---@field Net_Weight float
---@field Net_Damage float
---@field Net_CargoActorFlags uint32
---@field Net_SenderActor AActor
---@field Net_DestinationActor AActor
---@field Net_DeliveryId int32
---@field Net_bEnableSimulation boolean
---@field Net_EnableCollision ECollisionEnabled::Type
---@field Net_DestinationLocation FVector
---@field Net_SenderAbsoluteLocation FVector
---@field Net_SingleCargoPayment FMTShadowedInt64
---@field Net_Payment FMTShadowedInt64
---@field Net_SavedLifeTimeSeconds double
---@field Net_TimeLeftSeconds float
---@field Net_CarrierComponent USceneComponent
---@field Server_LastValidCarrierComponent USceneComponent
---@field Net_LocalRepMovement FMTCargoRepLocalMovement
---@field Net_bIsEmptyContainer boolean
---@field Net_OwnerName FString
---@field Net_LastValidCarrierVehicle AMTVehicle
---@field DroppedMarker AMTARMarker
---@field Marker AMTARMarker
---@field Net_Strap UMTStrapComponent
---@field Net_PickupTimeSeconds double
---@field NoCollisionPrimComponents TArray<UPrimitiveComponent>
local AMTCargo = {}

function AMTCargo:OnRep_Weight() end
function AMTCargo:OnRep_MovementOwnerPC() end
function AMTCargo:OnRep_LocalRepMovement() end
function AMTCargo:OnRep_IsEmptyContainer() end
function AMTCargo:OnRep_IsAttachedDummy() end
function AMTCargo:OnRep_EnableSimulation() end
function AMTCargo:OnRep_DroppedCargoSpace() end
function AMTCargo:OnRep_DestinationAbsoluteLocation() end
function AMTCargo:OnRep_ColorIndex() end
function AMTCargo:OnRep_CarrierComponent() end
function AMTCargo:OnRep_CargoKey() end
function AMTCargo:OnRep_CargoActorFlags() end
---@param NewLocation FVector
---@param NewQuat FQuat
---@param Teleport ETeleportType
function AMTCargo:MulticastSetActorLocationAndRotation(NewLocation, NewQuat, Teleport) end
---@param PaidPC AMotorTownPlayerController
---@param bPlaySound boolean
function AMTCargo:MulticastDump(PaidPC, bPlaySound) end


---@class AMTCargoSpawner : AActor
---@field bIsTransient boolean
---@field SpawnerGuid FGuid
---@field Configs TArray<FMTCargoSpawnerCargoConfig>
---@field bSpawnInteractionBox boolean
---@field bSimulateCargo boolean
---@field EnableCargoCollision ECollisionEnabled::Type
---@field bSetTargetDeliveryPoint boolean
---@field SceneComponent USceneComponent
---@field InteractionMeshComponent UStaticMeshComponent
---@field InteractionComponent UMTInteractableComponent
---@field Net_Cargo AMTCargo
local AMTCargoSpawner = {}

function AMTCargoSpawner:OnRep_Cargo() end
function AMTCargoSpawner:GenerateCargoSpawnerGuid() end


---@class AMTCharacter : ACharacter
---@field AbilityComponent UAbilitySystemComponent
---@field CameraBoom USpringArmComponent
---@field FollowCamera UCameraComponent
---@field VoiceLineData UMTVoiceLineDataAsset
---@field InteractionMontages TMap<EMotorTownInteractableType, UAnimMontage>
---@field InteractionFailMontage UAnimMontage
---@field FirstPersonCamera UCameraComponent
---@field Passenger UMTPassengerComponent
---@field Net_GroupPassenger UMTPassengerComponent
---@field BaseTurnRate float
---@field BaseLookUpRate float
---@field Net_Parts FMTCharacterParts
---@field Net_ResidentKey FName
---@field PartStaticMeshes TMap<EMTCharacterPartSlot, UStaticMeshComponent>
---@field PartSkeletalMeshes TMap<EMTCharacterPartSlot, USkeletalMeshComponent>
---@field MapIconName FText
---@field LC_InteractionTarget FMTCharacterInteractionTarget
---@field Net_Cargo AMTCargo
---@field Net_HoldingItem FMTHoldingItem
---@field Net_CarryingCharacter AMTCharacter
---@field Net_CarrierCharacter AMTCharacter
---@field Net_SeatPositionType EMTSeatPositionType
---@field Net_Seat UMTSeatComponent
---@field Net_PoseFlags uint32
---@field Net_CharacterFlags uint32
---@field Net_Buff2 FMTBuffContainer
---@field GameplayTagContainer FGameplayTagContainer
---@field Net_MTPlayerState AMotorTownPlayerState
---@field Net_LookRotation FRotator
---@field Net_bSprint boolean
local AMTCharacter = {}

---@param Flags uint32
function AMTCharacter:ServerRemovePoseFlags(Flags) end
---@param bHideCostume boolean
function AMTCharacter:ServerHideCostume(bHideCostume) end
---@param Flags uint32
function AMTCharacter:ServerAddPoseFlags(Flags) end
function AMTCharacter:Server_Knockdown() end
function AMTCharacter:OnRep_SeatPositionType() end
function AMTCharacter:OnRep_Seat() end
function AMTCharacter:OnRep_ResidentKey() end
function AMTCharacter:OnRep_HoldingItem() end
function AMTCharacter:OnRep_GameplayTagContainer() end
function AMTCharacter:OnRep_CharacterParts() end
---@param OldCharacterFlags uint32
function AMTCharacter:OnRep_CharacterFlags(OldCharacterFlags) end
---@param OldCargo AMTCargo
function AMTCharacter:OnRep_Cargo(OldCargo) end
function AMTCharacter:OnRep_Buff() end
---@param VoiceLineType EMTVoiceLineType
function AMTCharacter:MulticastPlayVoiceLine(VoiceLineType) end
---@param InteractableType EMotorTownInteractableType
function AMTCharacter:MulticastPlayInteractionMontage(InteractableType) end
---@param AnimMontage UAnimMontage
function AMTCharacter:MulticastPlayAnimMontage(AnimMontage) end
---@param EventType EMTCharacterEventType
function AMTCharacter:MulticastEvent(EventType) end
---@param Flags int32
---@return boolean
function AMTCharacter:HasPoseFlagsAny(Flags) end
---@return boolean
function AMTCharacter:HasAnyPoseFlags() end
---@return EMTSeatPositionType
function AMTCharacter:GetSeatPositionType() end


---@class AMTCloud : AActor
---@field Meshes TArray<UInstancedStaticMeshComponent>
---@field Material UMaterialInstanceDynamic
local AMTCloud = {}



---@class AMTCloudConfig : AInfo
---@field CloudConfig FMTCloudConfigParams
local AMTCloudConfig = {}



---@class AMTCompanySystem : AInfo
---@field Server_Companies TArray<FMTCompany>
---@field Net_CompanyInfos TArray<FMTCompanyInfo>
---@field Net_Depots TArray<FMTCompanyDepot>
local AMTCompanySystem = {}

function AMTCompanySystem:OnRep_CompanyInfo() end
---@param PlayerState AMotorTownPlayerState
function AMTCompanySystem:OnPlayerStateRemoved(PlayerState) end
---@param PlayerState AMotorTownPlayerState
function AMTCompanySystem:OnPlayerStateAdded(PlayerState) end


---@class AMTDealerVehicleSpawnPoint : AActor
---@field VehicleClass TSubclassOf<AMTVehicle>
---@field VehicleClasses TArray<TSubclassOf<AMTVehicle>>
---@field VehicleParams TArray<FMTVehicleSpawnPointVehicleParams>
---@field EditorVisualVehicleClass TSubclassOf<AMTVehicle>
---@field EditorVisualVehicle AMTVehicle
---@field InventoryRatioComponent UMTDeliveryPointInventoryRatio
---@field Controller FMTVehicleSpawnPointControler
---@field SceneComponent USceneComponent
local AMTDealerVehicleSpawnPoint = {}

function AMTDealerVehicleSpawnPoint:SpawnVehicle() end
---@param InVehicleClass TSubclassOf<AMTVehicle>
function AMTDealerVehicleSpawnPoint:SetVehicleClass(InVehicleClass) end


---@class AMTDeliveryPoint : AActor
---@field SceneComponent USceneComponent
---@field NavDestinationComponent USceneComponent
---@field DeliveryPointGuid FGuid
---@field MissionPointName FText
---@field DeliveryPointName FMTNameAndNumber
---@field PointName FMTTextByTexts
---@field PaymentMultiplier float
---@field BasePayment int64
---@field MaxDeliveries int32
---@field MaxPassiveDeliveries int32
---@field MaxDeliveryDistance float
---@field MaxDeliveryReceiveDistance float
---@field MaxDeliveryReceiveCount int32
---@field MissionPointType EDeliveryMissionPointType
---@field GameplayTags FGameplayTagContainer
---@field DestinationTypes TSet<EDeliveryMissionPointType>
---@field DestinationExcludeTypes TSet<EDeliveryMissionPointType>
---@field DestinationCargoLimits TArray<FMTDeliveryPointLimit>
---@field bUseAsDestinationInteraction boolean
---@field ProductionConfigs TArray<FMTProductionConfig>
---@field PassiveSupplies TArray<FMTDeliveryPassiveSupply>
---@field DemandConfigs TArray<FMTDeliveryDemandConfig>
---@field Supplies TMap<EDeliveryCargoType, int32>
---@field Demands TMap<EDeliveryCargoType, int32>
---@field DemandPriority int32
---@field StorageConfigs TArray<FMTDeliveryStorageConfig>
---@field MaxStorage int32
---@field bConsumeContainer boolean
---@field InputInventoryShare TArray<AMTDeliveryPoint>
---@field InputInventoryShareTarget TArray<AMTDeliveryPoint>
---@field bIsSender boolean
---@field bIsReceiver boolean
---@field bRemoveUnusedInputCargo boolean
---@field bShowStorage boolean
---@field bLoadCargoBySpawnAtPoint boolean
---@field ZoneVolume AMTAreaVolume
---@field Net_Deliveries TArray<FMTDelivery>
---@field Server_DeliveryGoods AMTCargo
---@field SenderMarker AMTARMarker
---@field Net_InputInventory FMTDeliveryPointInventory
---@field Net_OutputInventory FMTDeliveryPointInventory
---@field Net_RuntimeFlags uint32
---@field Net_ProductionBonusByProduction float
---@field Net_ProductionBonusByPopulation float
---@field Net_ProductionLocalFoodSupply float
local AMTDeliveryPoint = {}

---@param bShow boolean
function AMTDeliveryPoint:ReceiveShowInteractionArea(bShow) end
---@param bShow boolean
function AMTDeliveryPoint:ReceiveShowAsReceiver(bShow) end
---@param Goods AActor
function AMTDeliveryPoint:ReceiveSetGoods(Goods) end
function AMTDeliveryPoint:OnRep_Flags() end
function AMTDeliveryPoint:OnRep_Deliveries() end
function AMTDeliveryPoint:GenerateDeliveryPointGuid() end


---@class AMTDeliverySystem : AInfo
---@field ErrandSystem UErrandDeliveryMissionSystem
---@field TrailerSpawnPoints TArray<AMTTrailerSpawnPoint>
---@field Config FMTDeliverySystemConfig
---@field DeliveryPoints TArray<AMTDeliveryPoint>
---@field CargoSpawners TArray<AMTCargoSpawner>
---@field GarbageSpawners TArray<AMTCargoSpawner>
---@field CourierServices TArray<AMTDeliveryPoint>
---@field SupplyAndDemands TArray<AMTDeliveryPoint>
---@field Deliveries TArray<FMTDelivery>
---@field DeliveryPointsToSyncDeliveries TArray<AMTDeliveryPoint>
---@field Trailers TArray<FMTSpawnedTrailer>
---@field TrailersToDespawn TArray<AMTVehicle>
local AMTDeliverySystem = {}

---@param HUD AMTHUD
function AMTDeliverySystem:OnHUDDraw(HUD) end


---@class AMTDeliverySystemConfigActor : AInfo
---@field Config FMTDeliverySystemConfig
local AMTDeliverySystemConfigActor = {}



---@class AMTDeliveryVehicleSpawnPoint : AActor
---@field SceneComponent USceneComponent
---@field GameplayTagContainer FGameplayTagContainer
---@field InventoryRatioComponent UMTDeliveryPointInventoryRatio
local AMTDeliveryVehicleSpawnPoint = {}



---@class AMTDragRaceLane : AActor
---@field CourseKey FName
---@field LaneIndex int32
---@field SceneComponent USceneComponent
---@field LaneBox UBoxComponent
---@field PrestageSection AMotorTownRaceSection
---@field StageSection AMotorTownRaceSection
---@field StartSection AMotorTownRaceSection
---@field FinishSection AMotorTownRaceSection
---@field PrestageLight UMTLightControlComponent
---@field StageLight UMTLightControlComponent
---@field AmberLight1 UMTLightControlComponent
---@field AmberLight2 UMTLightControlComponent
---@field AmberLight3 UMTLightControlComponent
---@field GreenLight UMTLightControlComponent
---@field RedLight UMTLightControlComponent
---@field ChildLanes TArray<AMTDragRaceLane>
---@field ParentLane AMTDragRaceLane
---@field Net_OwnerPC AMotorTownPlayerController
---@field Net_Vehicle AMTVehicle
---@field Net_CurrentState EMTDragRaceSensorState
---@field Net_LCFlags uint32
---@field Net_Record FMTDragRaceRecord
---@field LC_Vehicle AMTVehicle
---@field LC_StartSyncedOtherLanes TArray<AMTDragRaceLane>
local AMTDragRaceLane = {}

---@param Section AMotorTownRaceSection
function AMTDragRaceLane:SetStartSection(Section) end
---@param Section AMotorTownRaceSection
function AMTDragRaceLane:SetStageSection(Section) end
---@param LightActor AActor
function AMTDragRaceLane:SetStageLight(LightActor) end
---@param LightActor AActor
function AMTDragRaceLane:SetRedLight(LightActor) end
---@param Section AMotorTownRaceSection
function AMTDragRaceLane:SetPrestageSection(Section) end
---@param LightActor AActor
function AMTDragRaceLane:SetPrestageLight(LightActor) end
---@param LightActor AActor
function AMTDragRaceLane:SetGreenLight(LightActor) end
---@param Section AMotorTownRaceSection
function AMTDragRaceLane:SetFinishSection(Section) end
---@param LightActor AActor
function AMTDragRaceLane:SetAmberLight3(LightActor) end
---@param LightActor AActor
function AMTDragRaceLane:SetAmberLight2(LightActor) end
---@param LightActor AActor
function AMTDragRaceLane:SetAmberLight1(LightActor) end


---@class AMTDrone : AActor
---@field DroneType EMTDroneType
---@field DroneSetting FMTDroneSetting
---@field PropMesh UStaticMesh
---@field PropSound USoundBase
---@field Camera UCameraComponent
---@field RootBody USphereComponent
---@field Props TArray<UStaticMeshComponent>
---@field PropSounds TArray<UAudioComponent>
---@field Net_PC AMotorTownPlayerController
---@field Net_DroneKey FName
---@field Net_DroneItemKey FName
---@field Net_DroneName FString
---@field Net_HotData FMTDroneNetHotData
local AMTDrone = {}

function AMTDrone:OnRep_PC() end
function AMTDrone:OnRep_HotData() end


---@class AMTDumpPileActor : AStaticMeshActor
local AMTDumpPileActor = {}


---@class AMTEventSystem : AInfo
---@field Net_Events TArray<FMTEvent>
---@field LC_RaceSections TArray<AMotorTownRaceSection>
local AMTEventSystem = {}

---@param PlayerState AMotorTownPlayerState
function AMTEventSystem:HandlePlayerStateAdded(PlayerState) end


---@class AMTFire : AActor
---@field InitialThermalMass float
---@field InitialFuel float
---@field InitialTemperature float
---@field bEnableSpreading boolean
---@field FireSound USoundBase
---@field Net_CellRadius double
---@field Net_NumCellsOnFire int32
---@field Net_FireFlags uint32
---@field Net_Payment FMTShadowedInt64
---@field FireCells TMap<FIntVector, FMTFireCell>
---@field Net_FireCellArray FMTNetFireCellArray
---@field FireSoundComponents TMap<FIntVector, UAudioComponent>
---@field SpottingSmokeNC UNiagaraComponent
---@field Server_ExtinguishingPlayers TArray<AMotorTownPlayerController>
local AMTFire = {}

function AMTFire:OnRep_FireFlags() end
---@param Actor AActor
---@param EndPlayReason EEndPlayReason::Type
function AMTFire:HandleParentEndPlay(Actor, EndPlayReason) end


---@class AMTFireSystem : AInfo
---@field Fires TArray<AMTFire>
local AMTFireSystem = {}



---@class AMTFireSystemConfigActor : AInfo
---@field FireSystemConfig FTMFireSystemConfig
local AMTFireSystemConfigActor = {}



---@class AMTGameSession : AGameSession
local AMTGameSession = {}


---@class AMTGarageActor : AActor
---@field SceneComponent USceneComponent
---@field SizeBoxComponent UBoxComponent
---@field Camera UCameraComponent
---@field GarageFlags int32
---@field GameplayTags FGameplayTagContainer
---@field AvailableVehiclePartTagQuery FGameplayTagQuery
local AMTGarageActor = {}



---@class AMTGrid : AActor
---@field GridType EMTGridType
---@field GridIndex int32
local AMTGrid = {}

function AMTGrid:SetGridIndexFromName() end


---@class AMTHUD : AHUD
---@field BaseHUDWidget UWidget
---@field ErrorMessagePopUpWidgetClass TSubclassOf<UErrorMessagePopUpWidget>
---@field DialogPopUpWidgetClass TSubclassOf<UDialogPopupWidget>
---@field GameModalessDialogPopUpWidgetClass TSubclassOf<UDialogPopupWidget>
---@field ButtonsDialogueWidgetClass TSubclassOf<UButtonsDialogWidget>
---@field EditableTextDialogPopupWidgetClass TSubclassOf<UEditableTextDialogPopupWidget>
---@field SpinBoxDialogWidgetClass TSubclassOf<USpinBoxDialogPopupWidget>
---@field InProgressScreenBlockerWidgetClass TSubclassOf<UInProgressScreenBlockerWidget>
---@field FullScreenMenuWidgetStack TArray<FMTFullScreenWidget>
---@field OKButtons TArray<UOKButtonWidget>
---@field CancelButtons TArray<UCancelButtonWidget>
---@field HelpTexts TArray<FText>
---@field CursorWidgetContext UMTCursorWidgetContext
---@field WidgetPool FUserWidgetPool
---@field InputKeyMappedButtons TArray<UMTButtonWidget>
local AMTHUD = {}

---@param Message FText
function AMTHUD:ShowMessagePopup(Message) end
---@param WidgetClass TSubclassOf<UUserWidget>
---@param Params FMTHUDWidgetParams
---@return UUserWidget
function AMTHUD:PushFullScreenMenuWidget2(WidgetClass, Params) end
---@param WidgetClass TSubclassOf<UUserWidget>
---@param bCollapseBelow boolean
---@return UUserWidget
function AMTHUD:PushFullScreenMenuWidget(WidgetClass, bCollapseBelow) end
---@param Widget UUserWidget
function AMTHUD:PopFullScreenMenuWidget(Widget) end


---@class AMTHitchhikingSystem : AInfo
local AMTHitchhikingSystem = {}


---@class AMTHouse : AActor
---@field PostBoxLocatorComponent USceneComponent
---@field AreaSize FVector
---@field FenceStep float
---@field FenceClass TSubclassOf<AActor>
---@field HouseForSaleClass TSubclassOf<AMTHouseForSale>
---@field ConstructionClass TSubclassOf<AMTHouseForSale>
---@field HousegKey FName
---@field HouseGuid FGuid
---@field TeleportLocation AActor
---@field Net_OwnerUniqueNetId FString
---@field Net_OwnerCharacterGuid FGuid
---@field Net_OwnerName FString
---@field Net_Buildings TArray<AMTBuilding>
---@field Net_RentLeftTimeSeconds double
---@field ForSale AMTHouseForSale
---@field Teleport AMTHouseTeleport
---@field FenceMeshComponent UInstancedStaticMeshComponent
local AMTHouse = {}

function AMTHouse:SpawnFences() end
---@param NewAreaSize FIntPoint
function AMTHouse:ReceiveSpawnFences(NewAreaSize) end
function AMTHouse:OnRep_HousingOwner() end
function AMTHouse:OnRep_Buildings() end
function AMTHouse:DespawnFences() end
function AMTHouse:Debug_SpawnFences() end


---@class AMTHouseForSale : AActor
---@field SceneComponent USceneComponent
---@field Interactable UMTInteractableComponent
---@field House AMTHouse
---@field Marker AMTARMarker
local AMTHouseForSale = {}



---@class AMTHouseTeleport : AActor
---@field SceneComponent USceneComponent
local AMTHouseTeleport = {}



---@class AMTInteractionMeshActor : AActor
---@field Mesh UMTInteractionMeshComponent
local AMTInteractionMeshActor = {}



---@class AMTItemSellSpawner : AMTActorSpawnerBase
---@field ItemKey FName
---@field bShowPriceMarker boolean
---@field PriceMarkerOffset FVector
local AMTItemSellSpawner = {}



---@class AMTLevelScriptActor : ALevelScriptActor
local AMTLevelScriptActor = {}

function AMTLevelScriptActor:RelaodAutocrossLevel() end


---@class AMTNavPointContainer : AActor
local AMTNavPointContainer = {}

---@param Transform FTransform
function AMTNavPointContainer:ReceiveOnConstruction(Transform) end


---@class AMTOceanConfig : AInfo
---@field OceanConfig FMTOceanConfigParams
local AMTOceanConfig = {}



---@class AMTOverlapInteractor : AActor
---@field OverlapInteractorComponent UMTOverlapInteractorComponent
---@field InteractableComponent UMTInteractableComponent
local AMTOverlapInteractor = {}

---@return UMTInteractableComponent
function AMTOverlapInteractor:GetInteractableComponent() end


---@class AMTParkingSpace : AActor
---@field BoxComponent UBoxComponent
---@field ParkingSpaceKey FName
---@field ParkingSpaceType EMTParkingSpaceType
---@field VehicleDeliveryVehicleType EMTVehicleType
---@field VehicleDeliveryVehicleTypes TArray<EMTVehicleType>
---@field VehicleDeliveryTruckClasses TArray<EMTTruckClass>
---@field VehicleDeliveryVehicleTypeFlags int32
---@field VehicleDeliveryVehicleQuery FGameplayTagQuery
---@field House AMTHouse
---@field Building AMTBuilding
---@field Interactable UMTInteractableComponent
---@field bParkingSpaceOwned boolean
---@field ParkedVehicleId int64
local AMTParkingSpace = {}



---@class AMTPhysics : AInfo
---@field DeferredImpacts0 TArray<FMTPhysicsImpact>
---@field DeferredImpacts1 TArray<FMTPhysicsImpact>
---@field DeferredImpacts2 TArray<FMTPhysicsImpact>
---@field Net_CharacterPushes TArray<FMTCharacterPush>
---@field Ropes TMap<uint32, FMTPhysicsRope>
---@field PT_Ropes TMap<uint32, FMTPhysicsRope>
---@field Constraints TArray<FMTPhysicsConstraint>
---@field PT_Constraints TArray<FMTPhysicsConstraint>
local AMTPhysics = {}

---@param Impact FMTPhysicsImpact
function AMTPhysics:MulticastApplyImpact(Impact) end


---@class AMTPlayerCameraManager : APlayerCameraManager
local AMTPlayerCameraManager = {}


---@class AMTPlayerStart : APlayerStart
---@field PlayerStartType EMTPlayerStartType
local AMTPlayerStart = {}



---@class AMTPointOfInterest : AActor
---@field SceneComponent USceneComponent
---@field POIGuid FGuid
---@field TaxiPaymentMultiplier float
---@field AreaFlags int32
---@field Priority float
---@field GameplayTagContainer FGameplayTagContainer
---@field ZoneVolume AMTAreaVolume
local AMTPointOfInterest = {}

function AMTPointOfInterest:GeneratePOIGuid() end


---@class AMTPolice : AInfo
---@field Net_Suspects TArray<FMTPoliceSuspect>
---@field Net_ColdState FMTPoliceColdState
---@field SuspectMarkers TMap<AMTCharacter, AMTARMarker>
---@field PatrolLocationActors TMap<int32, FMTPatrolLocationActor>
---@field PoliceComponents TArray<UMTPoliceVehicleComponent>
---@field Server_SpikeBarriers TArray<AMTSpikePadBarrier>
---@field Server_ParkingTicketTimers TArray<FMTParkingTicketTimer>
local AMTPolice = {}

---@param VoiceLineType EMTVoiceLineType
function AMTPolice:MulticastPlayDispatchVoice(VoiceLineType) end


---@class AMTPoliceVehicleAIController : AMTVehicleAIController
---@field PoliceVehiclePerception UAIPerceptionComponent
---@field SuspectGameplayTags FGameplayTagContainer
---@field SuspectGameplayTagsForNPC FGameplayTagContainer
---@field PullOverStopSpeed float
---@field PullOverStopDistance float
---@field ChaseTargetActor AActor
---@field LastSuspect APawn
local AMTPoliceVehicleAIController = {}

---@param UpdatedActors TArray<AActor>
function AMTPoliceVehicleAIController:HandlePerceptionUpdated(UpdatedActors) end


---@class AMTRoadSide : AActor
---@field ObjectActorClass TSubclassOf<AActor>
---@field bForward boolean
---@field SegmentCount int32
---@field StepDistance float
---@field SideDistance float
---@field StartOffset float
---@field EndOffset float
---@field ObjectRotation FRotator
---@field SceneComponent USceneComponent
---@field Objects TArray<AActor>
---@field SplineComponent ULandscapeSplinesComponent
---@field ControlPoint ULandscapeSplineControlPoint
local AMTRoadSide = {}



---@class AMTRoadSideList : AActor
---@field Objects TMap<FName, FMTRoadSideObject>
---@field Segments TMap<FGuid, FMTRoadSideSegmentObjects>
local AMTRoadSideList = {}



---@class AMTSpectatorPawn : ASpectatorPawn
local AMTSpectatorPawn = {}


---@class AMTSpikePad : AActor
---@field RootScene USceneComponent
---@field TriggerBox UBoxComponent
local AMTSpikePad = {}



---@class AMTSpikePadBarrier : AActor
---@field RootScene USceneComponent
---@field Server_SpikePads TArray<AMTSpikePad>
---@field Server_SpawnerPC AMotorTownPlayerController
---@field Net_DeployAt float
---@field Net_ExpireAt float
---@field Net_SpawnerPlayerState AMotorTownPlayerState
local AMTSpikePadBarrier = {}



---@class AMTSunSky : AActor
---@field SolarTime float
---@field Latitude float
---@field Longitude float
---@field NorthOffset float
---@field TimeZone float
---@field Year int32
---@field Month int32
---@field Day int32
---@field SunLightIntensityNoon float
---@field SunLightIntensitySunset float
---@field SunLightIntensityNoon_Rain float
---@field SunLightIntensitySunset_Rain float
---@field MoonLightIntensity float
---@field SkyIntensity float
---@field SkyIntensity_Night float
---@field SkyIntensityMultiplier_Rain float
---@field RootSceneComponent USceneComponent
---@field DirectionalLight_Sun2 UDirectionalLightComponent
---@field DirectionalLight_Moon2 UDirectionalLightComponent
---@field SkyLight2 USkyLightComponent
---@field PostProcess UPostProcessComponent
---@field OutlineMaterial UMaterialInterface
---@field UIBlurMaterial UMaterialInterface
---@field MaterialParamCollection_UI UMaterialParameterCollectionInstance
local AMTSunSky = {}

---@param DeltaSeconds float
function AMTSunSky:UpdateLighting(DeltaSeconds) end
---@param TimeOfDay float
function AMTSunSky:ReceiveTimeOfDayChanged(TimeOfDay) end


---@class AMTTaxi : AActor
---@field Net_Passengers TArray<UMTPassengerComponent>
local AMTTaxi = {}



---@class AMTTaxiRoofSign : AActor
local AMTTaxiRoofSign = {}


---@class AMTTimeOfDayConfig : AInfo
---@field TimeOfDayConfig FMTTimeOfDayConfigParams
local AMTTimeOfDayConfig = {}



---@class AMTTrailerSpawnPoint : AActor
---@field Trailer AMTVehicle
---@field DestinatedTrailer AMTVehicle
---@field DeliveryPointName FText
---@field BoxComponent UBoxComponent
---@field DeliveryPointGuid FGuid
local AMTTrailerSpawnPoint = {}



---@class AMTVehicle : APawn
---@field DefaultVehicleFeatures TSet<EMTVehicleFeature>
---@field ExControls TArray<EMTVehicleExControl>
---@field BodyMaterials TArray<UMaterialInterface>
---@field BodyMaterialList TArray<FMTVehicleBodyMaterial>
---@field BodyMaterialName FName
---@field BodyMaterialNames TArray<FName>
---@field DecalableMaterialSlotNames TArray<FName>
---@field BodyColorMaterialSlotNames TMap<FName, FText>
---@field ColorSlots TMap<FName, FMTVehicleColorSlot>
---@field BodyColors TArray<FMTVehicleColor>
---@field BusComponentClass TSubclassOf<UMTVehicleBusComponent>
---@field RootBody UMTVehicleRootComponent
---@field Mesh UStaticMeshComponent
---@field SteeringWheel UStaticMeshComponent
---@field Wheels TArray<UMHWheelComponent>
---@field Wings TArray<UMTWingComponent>
---@field EngineComponent UMTEngineComponent
---@field CargoSpaceInteractableComponent UMTInteractableComponent
---@field DrivingInput UMTDrivingInput
---@field HornAudioComponent UAudioComponent
---@field SirenAudioComponent UAudioComponent
---@field BackupBeepAudioComponent UAudioComponent
---@field RefuelAudioComponent UAudioComponent
---@field AirHydraulicAudioComponent UAudioComponent
---@field WindNoiseAudioComponent UAudioComponent
---@field AirHydraulicSound USoundBase
---@field DriverSeatInteractionSphereComponent USphereComponent
---@field DriverSeatInteractableComponent UMTInteractableComponent
---@field PassengerSeatInteractionSphereComponent USphereComponent
---@field PassengerSeatInteractableComponent UMTInteractableComponent
---@field NavModifierComponent UMTVehicleNavModifierComponent
---@field Dashboard UMTDashboard
---@field CameraSpringArm USpringArmComponent
---@field TrailCamera UCameraComponent
---@field CockpitCamera UCameraComponent
---@field LOD1DisableTickComponents TArray<UActorComponent>
---@field LOD2DisableTickComponents TArray<UActorComponent>
---@field LOD2UnregisterComponents TArray<UActorComponent>
---@field LOD3UnregisterComponents TArray<UActorComponent>
---@field LOD4UnregisterComponents TArray<UActorComponent>
---@field LOD3NoCollisionComponents TArray<UPrimitiveComponent>
---@field TransmissionComponent UMHTransmissionComponent
---@field Differentials TArray<UMTDifferentialComponent>
---@field Seats TArray<UMTSeatComponent>
---@field MirrorComponents TArray<UMTMirrorComponent>
---@field Doors TArray<UMTVehicleDoorComponent>
---@field CargoSpaces TArray<UMTVehicleCargoSpaceComponent>
---@field TaxiComponent UMTVehicleTaxiComponent
---@field AmbulanceComponent UMTVehicleAmbulanceComponent
---@field FireFightingComponent UMTVehicleFireFightingComponent
---@field Net_BusComponent UMTVehicleBusComponent
---@field TruckComponent UMTVehicleTruckComponent
---@field WreckerComponent UMTVehicleWreckerComponent
---@field TrailerComponent UMTVehicleTrailerComponent
---@field Headlights TArray<UMTVehicleHeadLight>
---@field TailLights TArray<UMTVehicleTailLight>
---@field ReverseLights TArray<UMTVehicleReverseLight>
---@field BlinkerLights TArray<UMTVehicleBlinkerLight>
---@field EmegencyLights TArray<UMTVehicleEmergencyLight>
---@field Constraints TArray<UMTConstraintComponent>
---@field ForkliftTiltConstraint UMTConstraintComponent
---@field ForkliftLiftConstraints TArray<UMTConstraintComponent>
---@field ForkliftForkLeftConstraint UMTConstraintComponent
---@field ForkliftForkRightConstraint UMTConstraintComponent
---@field Winches TArray<UMTWinchComponent>
---@field TowRequestComponent UMTTowRequestComponent
---@field TowingComponent UMTTowingComponent
---@field PartSlots TArray<UMTVehiclePartSlotComponent>
---@field InteriorLights TArray<AMTVehicleInteriorLight>
---@field TaxiRoofSign AMTTaxiRoofSign
---@field RearSpoiler UMTStaticMeshAeroPartComponent
---@field RearWing UMTStaticMeshAeroPartComponent
---@field AeroParts TMap<EMTVehiclePartSlot, UMeshComponent>
---@field AttachmentParts TMap<EMTVehiclePartSlot, UMTVehicleAttachmentPartComponent>
---@field AttachmentPartsComponents TArray<UMTVehicleAttachmentPartComponent>
---@field Net_RoofRackParts TArray<FMTVehicleCargoPartAndSlot>
---@field Net_CargoBedParts TArray<FMTVehicleCargoPartAndSlot>
---@field Server_Winches TMap<EMTVehiclePartSlot, UMTWinchComponent>
---@field TrailerHitch UMTTrailerHitchComponent
---@field PoliceComponent UMTPoliceVehicleComponent
---@field SellerComponent UMTCarSellerInteractableComponent
---@field CraneComponent UMTCraneComponent
---@field GetawayComponent UMTGetawayComponent
---@field DecalComponent UMTDecalComponent
---@field TankerFuelPumpComponent UMTTankerFuelPumpComponent
---@field WaterSprayComponents TArray<UMTWaterSprayComponent>
---@field GameplayTagContainer FGameplayTagContainer
---@field StaticMeshDefaultTransforms TMap<UStaticMeshComponent, FTransform>
---@field bForSale boolean
---@field bDrivable boolean
---@field bHasSteeringWheel boolean
---@field bHasDriverSeat boolean
---@field bHasPassengerSeat boolean
---@field AIDriverSetting FMotorTownAIDriverSetting
---@field bIsOpenAir boolean
---@field DefaultDrivingMode EMTDriveMode
---@field MaxSteeringAngleDegree float
---@field ParallelSteering float
---@field OptimalSlipAngleDegree float
---@field SteeringOffsetX float
---@field MaxSteeringWheelAngleDegree float
---@field BrakeTorqueMultiplier float
---@field BrakeTemperatureMass float
---@field KeyboardSteerSpeed float
---@field KeyboardSteerReturnSpeed float
---@field AntiRollBars TArray<FMTAntiRollBarParams>
---@field Suspensions TArray<FMTVehicleSuspensionParams>
---@field Pistons TArray<FMTVehiclePistonParams>
---@field FuelTankCapacityInLiter float
---@field AirDragCoeff float
---@field AeroLiftCoeff FVector2D
---@field AeroLiftCoeff_Front float
---@field AeroLiftCoeff_Rear float
---@field AirDragFrontalAreaMultiplier float
---@field DiffLockings TArray<FMTVehicleDiffLockingState>
---@field LiftAxles TArray<FMTVehicleLiftAxle>
---@field ControlSettings FMTVehicleControlSettings
---@field PhysicsSettings FMTVehiclePhysicsSettings
---@field bUseSteeringWheelSocketAsPivot boolean
---@field bSteeringAttachedToSkeletalSocket boolean
---@field LimitSteeringByLateralG float
---@field bLeanDriver boolean
---@field BaseLeanForwardDegree float
---@field HornSound USoundBase
---@field HornFadeInSeconds float
---@field HornFadeOutSeconds float
---@field SirenSounds TArray<USoundBase>
---@field AirBrakeSound USoundBase
---@field ParkingBrakeSound USoundBase
---@field ParkingBrakeReleaseSound USoundBase
---@field BackupBeep USoundBase
---@field RefuelingSound USoundBase
---@field RefuelSoundFadeInSeconds float
---@field RefuelSoundFadeOutSeconds float
---@field RefuelingEndSound USoundBase
---@field RattleSound USoundBase
---@field RattleSoundG float
---@field WindNoiseSound USoundBase
---@field WindNoiseVolume float
---@field Throttle float
---@field Brake float
---@field Steer float
---@field HandBrake float
---@field Clutch float
---@field BikeDriverLeaning FRotator
---@field Net_VehicleFlags uint32
---@field WheelAxles TArray<FMTVehicleWheelAxle>
---@field LocalBoundsComponents TArray<UStaticMeshComponent>
---@field LocalBoundsComponentDefaultTransforms TMap<UStaticMeshComponent, FTransform>
---@field VehicleReplicatedMovement FMTVehicleRepMovement
---@field VehicleReplicatedMovements TArray<FMTVehicleRepMovementNet>
---@field NetLC_VehicleState FMTVehicleState
---@field NetLC_ColdState FMTVehicleColdState
---@field NetLC_EngineHotState FMTNetEngineHotState
---@field NetLC_EngineColdState FMTEngineColdState
---@field NetLC_TransmissionColdState FMTNetTransmissionColdState
---@field Net_Seats TArray<FMTNetVehicleSeat>
---@field Net_Cargo FMTNetVehicleCargo
---@field Net_VehicleOwnerSetting FMTVehicleOwnerSetting
---@field Net_VehicleSettings TArray<FMTVehicleSetting>
---@field Customization FMTVehicleCustomization
---@field Net_Decal FMTVehicleDecal
---@field Net_OwnerPlayerState AMotorTownPlayerState
---@field Net_OwnerCharacterId FMTCharacterId
---@field Net_OwnerCompanyGuid FGuid
---@field Net_AccountNickname FString
---@field Net_VehicleId int64
---@field Server_OwnerPlayerController AMotorTownPlayerController
---@field Net_Parts TArray<FMTVehiclePart>
---@field UtilitySlots TMap<EMTVehiclePartSlot, FMTVehicleUtilitySlot>
---@field Net_AINetData FMTVehicleAINetState
---@field InternalWindowMaterials TArray<UMaterialInstanceDynamic>
---@field LC_InteractionCandidates TArray<UMTInteractableComponent>
---@field Laptime FMTLaptimeModule
---@field TrailerHitchSocketComponent UPrimitiveComponent
---@field CurrentRoad AMotorTownRoad
---@field Net_Hooks TArray<FMTVehicleHook>
---@field Net_Tractor AMTVehicle
---@field Net_MovementOwnerPC AMotorTownPlayerController
---@field Server_TempMovementOwnerPCs TMap<AMotorTownPlayerController, double>
---@field Server_LastMovementOwnerPC AMotorTownPlayerController
---@field Net_LastNoMovementOwnerPCServerTimeSeconds double
---@field Net_LastMovementOwnerPCName FString
---@field VehicleOwnerProfitShareMultiplier float
---@field ExplosionDetector FMTPhysicsExplosionDetector
---@field Server_GarbageCompress FMTVehicleGarbageCompress
---@field Server_LastPlayerController AMotorTownPlayerController
---@field IgnoreCollisionComponents TArray<UPrimitiveComponent>
---@field Net_CarCarrierCargoSpace UMTVehicleCargoSpaceComponent
---@field Net_CompanyGuid FGuid
---@field Net_CompanyName FString
---@field OverlappingActors TArray<AActor>
---@field AreaVolumes TArray<AMTAreaVolume>
---@field WaterBodies TArray<AWaterBody>
---@field Net_PTOThrottle float
---@field Net_bPTOOn boolean
---@field CaptureTheFlagFlagActor AActor
local AMTVehicle = {}

---@param PartSlot EMTVehiclePartSlot
---@param Part FMTVehiclePart
function AMTVehicle:ServerUpdatePart(PartSlot, Part) end
---@param ColdState FMTVehicleColdState
---@param bMulticast boolean
function AMTVehicle:ServerSyncColdState(ColdState, bMulticast) end
---@param State FMTNetTransmissionColdState
function AMTVehicle:ServerSetTransmissionColdState(State) end
---@param VehicleRaceState FMTVehicleRaceState
function AMTVehicle:ServerSetRace(VehicleRaceState) end
---@param NewParts TArray<FMTVehiclePart>
function AMTVehicle:ServerSetParts(NewParts) end
---@param PartSlot EMTVehiclePartSlot
---@param ValueIndex int32
---@param Value float
function AMTVehicle:ServerSetPartFloatValue(PartSlot, ValueIndex, Value) end
---@param PartSlot EMTVehiclePartSlot
---@param NewDamage float
function AMTVehicle:ServerSetPartDamage(PartSlot, NewDamage) end
---@param State FMTEngineColdState
function AMTVehicle:ServerSetEngineColdState(State) end
---@param InDecal FMTVehicleDecal
function AMTVehicle:ServerSetDecal(InDecal) end
---@param State FMTVehicleAINetState
function AMTVehicle:ServerSetAIState(State) end
---@param Goods AActor
function AMTVehicle:ReceiveSetGoods(Goods) end
function AMTVehicle:OnRep_VehicleSettings() end
function AMTVehicle:OnRep_VehicleOwnerSetting() end
function AMTVehicle:OnRep_VehicleId() end
function AMTVehicle:OnRep_VehicleFlags() end
function AMTVehicle:OnRep_TransmissionColdState() end
function AMTVehicle:OnRep_Parts() end
function AMTVehicle:OnRep_OwnerPlayerState() end
function AMTVehicle:OnRep_OwnerCompanyGuid() end
function AMTVehicle:OnRep_OwnerCharacterGuid() end
function AMTVehicle:OnRep_NetSeats() end
function AMTVehicle:OnRep_MovementOwnerPC() end
function AMTVehicle:OnRep_Hooks() end
function AMTVehicle:OnRep_GameplayTagContainer() end
function AMTVehicle:OnRep_ForSale() end
function AMTVehicle:OnRep_EngineHotState() end
function AMTVehicle:OnRep_EngineColdState() end
function AMTVehicle:OnRep_Drivable() end
function AMTVehicle:OnRep_Decal() end
function AMTVehicle:OnRep_Customization() end
function AMTVehicle:OnRep_ColdState() end
function AMTVehicle:OnRep_CargoSpaceParts() end
---@param Movements TArray<FMTVehicleRepMovementNet>
function AMTVehicle:MulticastSyncMovement(Movements) end
---@param PartSlot EMTVehiclePartSlot
---@param NewDamage float
function AMTVehicle:MulticastSetPartDamage(PartSlot, NewDamage) end
---@param InFuel float
function AMTVehicle:MulticastSetFuel(InFuel) end
---@param Condition float
function AMTVehicle:MulticastSetCondition(Condition) end
---@param SeatName FName
function AMTVehicle:MulticastSeatExit(SeatName) end
---@param SeatName FName
---@param Character AMTCharacter
function AMTVehicle:MulticastSeatCharacter(SeatName, Character) end
---@param Location FVector
---@param Rotation FRotator
---@param bResetTrailers boolean
---@param bResetCarriedVehicles boolean
function AMTVehicle:MulticastResetVehicle(Location, Rotation, bResetTrailers, bResetCarriedVehicles) end
function AMTVehicle:MulticastRefuelFinished() end
---@param bHook boolean
---@param TrailerParams FMTVehicleHookParams
function AMTVehicle:MulticastPlayTrailerHookSound(bHook, TrailerParams) end
---@param bHook boolean
---@param TractorParams FMTVehicleHookParams
function AMTVehicle:MulticastPlayTractorHookSound(bHook, TractorParams) end
---@param RelativeLocation FVector
---@param Volume float
---@param ExceptionPC AMotorTownPlayerController
function AMTVehicle:MulticastPlayHitSound(RelativeLocation, Volume, ExceptionPC) end
function AMTVehicle:MigrateBodyMaterials() end
---@return boolean
function AMTVehicle:IsTractionControlActivated() end
---@return boolean
function AMTVehicle:IsPhysicsUnstable() end
---@return boolean
function AMTVehicle:IsGarageMode() end
---@return FMTVehicleState
function AMTVehicle:GetVehicleState() end
---@return EMTVehicleLOD
function AMTVehicle:GetVehicleLOD() end
---@return UMTVehicleRootComponent
function AMTVehicle:GetRootBody() end
---@return float
function AMTVehicle:GetFuelRatio() end
---@return float
function AMTVehicle:GetEVPowerPercentage() end
---@param InState FMTVehicleState
---@param ColdStata FMTVehicleColdState
function AMTVehicle:ClientSetVehicleState(InState, ColdStata) end
---@param bIncludeTrailers boolean
---@return TArray<AMTCargo>
function AMTVehicle:BP_GetAllCargos(bIncludeTrailers) end


---@class AMTVehicleAIController : AAIController
---@field Dev_TargetTagName FName
---@field bRoaming boolean
---@field bRacing boolean
---@field bIsSpeeding boolean
---@field bUseMeshPath boolean
---@field SpawnedDriverCharacter AMTCharacter
---@field DrivingAI UMotorTownDrivingAI
---@field TargetActor AActor
---@field BusDriver FMTVehicleAIBusDriver
---@field BusDriverState FMTVehicleAIBusDriverState
---@field TruckDriver FMTVehicleAITruckDriver
---@field TruckDriverState FMTVehicleAITruckDriverState
local AMTVehicleAIController = {}



---@class AMTVehicleInteriorLight : AActor
---@field Lights TArray<ULightComponent>
---@field Meshes TArray<UStaticMeshComponent>
---@field bLightOn boolean
local AMTVehicleInteriorLight = {}

---@param bOn boolean
function AMTVehicleInteriorLight:ReceiveSetLightOn(bOn) end


---@class AMTVehicleSpawnPoint : AActor
---@field BoxComponent UBoxComponent
local AMTVehicleSpawnPoint = {}



---@class AMTWeatherConfig : AInfo
---@field WeatherConfig FMTWeatherConfigParams
local AMTWeatherConfig = {}



---@class AMTWeighInMotion : AActor
---@field RootScene USceneComponent
---@field TriggerBox UBoxComponent
---@field WeightInMotionType EMTWeightInMotionType
local AMTWeighInMotion = {}



---@class AMTWorldMapCapture : ASceneCapture2D
---@field TargetTexture UTexture2D
local AMTWorldMapCapture = {}

function AMTWorldMapCapture:CaptureWorldMap() end


---@class AMWorldVehicleSpawnPoint : AActor
---@field VehicleClasses TArray<TSubclassOf<AMTVehicle>>
---@field VehicleParams TArray<FMTVehicleSpawnPointVehicleParams>
---@field EditorVisualVehicleClass TSubclassOf<AMTVehicle>
---@field EditorVisualVehicle AMTVehicle
---@field SceneComponent USceneComponent
---@field Controller FMTVehicleSpawnPointControler
local AMWorldVehicleSpawnPoint = {}

function AMWorldVehicleSpawnPoint:SpawnVehicle() end
---@param VehicleClass TSubclassOf<AMTVehicle>
function AMWorldVehicleSpawnPoint:SetVehicleClass(VehicleClass) end


---@class AMotorTownGameMode : AGameModeBase
---@field DeliveryMissionSystem AMTDeliverySystem
---@field DediWebServer UMTHostWebServer
local AMotorTownGameMode = {}



---@class AMotorTownGameState : AGameStateBase
---@field GameType EMotorTownGameType
---@field Net_bIsDedicatedServer boolean
---@field Net_DeliverySystem AMTDeliverySystem
---@field Net_BusSystem AMTBusSystem
---@field Net_Taxi AMTTaxi
---@field Net_Physics AMTPhysics
---@field Net_Police AMTPolice
---@field Net_CompanySystem AMTCompanySystem
---@field Net_Bank AMTBank
---@field Net_EventSystem AMTEventSystem
---@field Net_FireSystem AMTFireSystem
---@field ActorCache UMTActorCache
---@field AIVehicleSpawnSystem AMTAIVehicleSpawnSystem
---@field Navigation AMotorTownNavigation
---@field Vehicles TArray<AMTVehicle>
---@field Characters TArray<AMTCharacter>
---@field Drones TArray<AMTDrone>
---@field Passengers TArray<UMTPassengerComponent>
---@field Roads TArray<AMotorTownRoad>
---@field POIs TArray<AMTPointOfInterest>
---@field ParkingSpaces TArray<AMTParkingSpace>
---@field RoadSigns TArray<UMTRoadSignComponent>
---@field CargoReceivers TArray<UMTCargoReceiver>
---@field Houses TArray<AMTHouse>
---@field Buildings TArray<AMTBuilding>
---@field ARMarkers TArray<AMTARMarker>
---@field Garages TArray<AMTGarageActor>
---@field Breakables TSet<AMTBreakable>
---@field CheckingBreakables TArray<AMTBreakable>
---@field AreaVolumes TArray<AMTAreaVolume>
---@field ZoneVolumes TArray<AMTAreaVolume>
---@field RaceSections TArray<AMotorTownRaceSection>
---@field DealerVehicleSpawnPoints TArray<FMTDealerVehicleSpawnPointData>
---@field Server_TowRequests TArray<UMTTowRequestComponent>
---@field Space UMTSpace
---@field RaceSetting FMTRaceSetting
---@field RaceState FMTRaceState
---@field Net_Parties TArray<FMTParty>
---@field Net_Admins TArray<FMTAdmin>
---@field Net_BannedPlayers TArray<FMTBannedPlayer>
---@field Net_PoliceRolePlayers TArray<FMTRolePlayer>
---@field Server_PersistenceItems TArray<UMTItemComponent>
---@field Net_WorldGuid FGuid
---@field Net_ServerConfig FMTServerRuntimeConfig
---@field Net_HotState FMTGameHotState
---@field Net_TowRequests TArray<FMTNetTowRequest>
---@field Net_TeleportPoints TArray<FMTNetTeleportPoint>
---@field Markers TArray<FMTGSMarker>
local AMotorTownGameState = {}

---@param OldServerConfig FMTServerRuntimeConfig
function AMotorTownGameState:OnRep_ServerConfig(OldServerConfig) end
function AMotorTownGameState:OnRep_Physics() end
---@param State FMTRaceState
function AMotorTownGameState:MulticastSetRaceState(State) end
---@return EMotorTownGameType
function AMotorTownGameState:GetGameType() end


---@class AMotorTownInGameHUD : AMTHUD
---@field FuelPumpWidgetClass TSubclassOf<UFuelPumpWidget>
---@field DeliveryMissionInteractionWidgetClass TSubclassOf<UDeliveryMissionInteractionWidget>
---@field VehicleSellerWidgetClass TSubclassOf<UVehicleSellerWidget>
---@field GarageWidgetClass TSubclassOf<UGarageWidget>
---@field HUDWidgetClass TSubclassOf<UInGameHUDWidget>
---@field MenuWidgetClass TSubclassOf<UUserWidget>
---@field WorldMapWidgetClass TSubclassOf<UUserWidget>
---@field CompanyWidgetClass TSubclassOf<UUserWidget>
---@field NameTagWidgetClass TSubclassOf<UNameTagWidget>
---@field HUDWidget UInGameHUDWidget
---@field NameTagWidgets TArray<UNameTagWidget>
---@field WorldMapWidget UUserWidget
---@field CompanyWidget UUserWidget
---@field EventWidget UEventWidget
---@field MenuWidget UInGameMenuWidget
---@field NameTagStates TMap<AActor, FMTNameTagState>
local AMotorTownInGameHUD = {}



---@class AMotorTownInteractableActor : AActor
---@field InteractableComponent UMTInteractableComponent
local AMotorTownInteractableActor = {}

---@return UMTInteractableComponent
function AMotorTownInteractableActor:GetInteractableComponent() end


---@class AMotorTownMainMenuGameMode : AGameModeBase
local AMotorTownMainMenuGameMode = {}


---@class AMotorTownNavPoint : AActor
---@field NextPoints TArray<FMTNavPointEdge>
---@field bIsCrossRoad boolean
---@field AutoConnectToRoadDistance float
local AMotorTownNavPoint = {}

---@param NextPoint AMotorTownNavPoint
---@param EdgeFlags int32
function AMotorTownNavPoint:AddNextPoint(NextPoint, EdgeFlags) end


---@class AMotorTownNavigation : AActor
---@field DebugDrawHeightmapDistance float
---@field GraphData FMTRoadGraphData
---@field HeightmapData FMTHeightmapData
local AMotorTownNavigation = {}

---@param HUD AMTHUD
function AMotorTownNavigation:OnHUDDraw(HUD) end
function AMotorTownNavigation:BuildNavigation() end


---@class AMotorTownNavigationTester : AActor
---@field Start USceneComponent
---@field End USceneComponent
---@field InvokerComponent UNavigationInvokerComponent
---@field StartRadius float
---@field EndRadius float
---@field bAllowUTurn boolean
---@field PathSource EMTFindPathSource
---@field CoolDownSeconds float
local AMotorTownNavigationTester = {}



---@class AMotorTownPlayerController : AMotorTownPlayerControllerBase
---@field CharacterClass TSubclassOf<AMTCharacter>
---@field Net_MyDrivingCharacter AMTCharacter
---@field DrivingAI UMotorTownDrivingAI
---@field GhostCar AMTVehicle
---@field StationaryCamera ACameraActor
---@field Server_CharacterParts FMTCharacterParts
---@field Net_SpawnedVehicles TArray<AMTVehicle>
---@field Navigation UMTPlayerNavigation
---@field Net_Flags uint32
---@field LastVehicle AMTVehicle
---@field Net_ServerViewTarget AActor
---@field Net_ServerViewAbsoluteLocation FVector
---@field SleepWidget USleepWidget
---@field RefuelingWidget URefuelingWidget
---@field QuestController UMTQuestController
---@field QuestTargetVehicleKey FName
---@field LC_AreaVolumes TArray<AMTAreaVolume>
---@field LC_CurrentLargeAreaVolume AMTAreaVolume
---@field LC_CurrentSmallAreaVolume AMTAreaVolume
---@field Server_CurrentLargeAreaVolume AMTAreaVolume
---@field Server_CurrentSmallAreaVolume AMTAreaVolume
---@field LC_CurrentZoneVolume AMTAreaVolume
---@field LC_CrosshairTargetActor AActor
---@field LC_CrosshairFenceShownHouses TArray<AMTHouse>
---@field SpectatingTargetActor AActor
---@field LC_SpectatingOldViewTarget AActor
---@field Server_SpectatingPC AMotorTownPlayerController
---@field LC_ArrivedCargos TArray<AMTCargo>
---@field Net_ReservedPassenger UMTPassengerComponent
---@field LC_OverrideReservedPassenger UMTPassengerComponent
---@field Net_AssignedFire AMTFire
---@field Companies TArray<FMTCompany>
---@field Net_CompaniesBase TArray<FMTCompany>
---@field Server_SentCompanyPartials TArray<FMTCompany>
---@field Net_JoinRequestedCompany FGuid
---@field RGWatchActors TSet<AActor>
---@field TargetJobActors TSet<AActor>
---@field LC_PassengerNavTarget UMTPassengerComponent
---@field LC_DumpingArrivedHighlightedActor AActor
---@field Net_PoliceTowingNoPayments TArray<FMTPoliceTowingNoPayment>
---@field Drone AMTDrone
local AMotorTownPlayerController = {}

---@param Winch UMTWinchComponent
---@param Control EMTWinchControl
function AMotorTownPlayerController:ServerWinchControl2(Winch, Control) end
---@param WinchControlItemActor AActor
---@param Control EMTWinchControl
function AMotorTownPlayerController:ServerWinchControl(WinchControlItemActor, Control) end
---@param TargetPlayerState AMotorTownPlayerState
---@param Message FString
function AMotorTownPlayerController:ServerWhisper(TargetPlayerState, Message) end
function AMotorTownPlayerController:ServerWakeUp() end
---@param Vehicle1 AMTVehicle
---@param Vehicle2 AMTVehicle
---@param DurationSeconds float
function AMotorTownPlayerController:ServerVehicleLinkMovementOwner(Vehicle1, Vehicle2, DurationSeconds) end
---@param Vehicle AMTVehicle
---@param Control EMTVehicleExControl
function AMotorTownPlayerController:ServerVehicleExControl(Vehicle, Control) end
---@param Wheel UMHWheelComponent
---@param bBroken boolean
function AMotorTownPlayerController:ServerUnStrapWheel(Wheel, bBroken) end
---@param Cargo AMTCargo
function AMotorTownPlayerController:ServerUnstrapCargo(Cargo) end
---@param ItemActor AActor
function AMotorTownPlayerController:ServerTrashItem(ItemActor) end
---@param TowRequestComponent UMTTowRequestComponent
function AMotorTownPlayerController:ServerTowRequestArrived(TowRequestComponent) end
---@param WaterSpray UMTWaterSprayComponent
function AMotorTownPlayerController:ServerToggleWaterSpray(WaterSpray) end
---@param Door UMTVehicleDoorComponent
function AMotorTownPlayerController:ServerToggleDoor(Door) end
---@param bOpen boolean
function AMotorTownPlayerController:ServerToggleBusDoor(bOpen) end
---@param Velocity FVector
---@param Location FVector
---@param Rotation FRotator
function AMotorTownPlayerController:ServerThrowItem(Velocity, Location, Rotation) end
---@param Cargo AMTCargo
---@param Velocity FVector
function AMotorTownPlayerController:ServerThrowCargo(Cargo, Velocity) end
---@param House AMTHouse
function AMotorTownPlayerController:ServerTerminateHouseOwnership(House) end
---@param Vehicle AMTVehicle
---@param AbsoluteLocation FVector
function AMotorTownPlayerController:ServerTeleportVehicle(Vehicle, AbsoluteLocation) end
---@param AbsoluteLocation FVector
---@param bCharge boolean
---@param bIsRespawn boolean
function AMotorTownPlayerController:ServerTeleportCharacter(AbsoluteLocation, bCharge, bIsRespawn) end
---@param Vehicle AMTVehicle
---@param Movements TArray<FMTVehicleRepMovementNet>
function AMotorTownPlayerController:ServerSyncVehicleMovement(Vehicle, Movements) end
---@param Vehicle AMTVehicle
---@param SyncData FMTVehicleSyncData
function AMotorTownPlayerController:ServerSyncVehicleData(Vehicle, SyncData) end
---@param Cargo AMTCargo
---@param Movement FRepMovement
function AMotorTownPlayerController:ServerSyncCargoMovement(Cargo, Movement) end
---@param Cargo AMTCargo
---@param Movement FMTCargoRepLocalMovement
function AMotorTownPlayerController:ServerSyncCargoLocalMovement(Cargo, Movement) end
function AMotorTownPlayerController:ServerSurrender() end
---@param Location FVector
function AMotorTownPlayerController:ServerSummonSpikePad(Location) end
---@param Wheel UMHWheelComponent
---@param TargetComp UPrimitiveComponent
---@param WheelOffset float
function AMotorTownPlayerController:ServerStrapWheel(Wheel, TargetComp, WheelOffset) end
---@param Cargo AMTCargo
function AMotorTownPlayerController:ServerStrapCargo(Cargo) end
function AMotorTownPlayerController:ServerStopSpectatingPlayer() end
---@param Vehicle AMTVehicle
function AMotorTownPlayerController:ServerStopRefuelingVehicle(Vehicle) end
---@param PusherCharacter AMTCharacter
function AMotorTownPlayerController:ServerStopCharacterPushing(PusherCharacter) end
---@param TargetPlayerState AMotorTownPlayerState
function AMotorTownPlayerController:ServerStartSpectatingPlayer(TargetPlayerState) end
---@param Actor AActor
function AMotorTownPlayerController:ServerStartSpectatingActor(Actor) end
---@param InCharacter AMTCharacter
function AMotorTownPlayerController:ServerStartDialogue(InCharacter) end
---@param PusherCharacter AMTCharacter
---@param TaretActor AActor
---@param Direction FVector
function AMotorTownPlayerController:ServerStartCharacterPushing(PusherCharacter, TaretActor, Direction) end
---@param Fire AMTFire
function AMotorTownPlayerController:ServerSpotFire(Fire) end
function AMotorTownPlayerController:ServerSpectatePreviousPlayer() end
function AMotorTownPlayerController:ServerSpectateNextPlayer() end
---@param SpawnParams FMTVehicleSpawnParams
function AMotorTownPlayerController:ServerSpawnVehicle(SpawnParams) end
---@param SpawnParams FMTVehicleSpawnParams
function AMotorTownPlayerController:ServerSpawnInitialVehicle(SpawnParams) end
---@param InDroneKey FName
---@param InDroneItemKey FName
function AMotorTownPlayerController:ServerSpawnDrone(InDroneKey, InDroneItemKey) end
---@param SpawnParams TArray<FMTVehicleSpawnParams>
---@param bBegin boolean
---@param bEnd boolean
function AMotorTownPlayerController:ServerSpawnDrivingModeVehicles(SpawnParams, bBegin, bEnd) end
---@param Contract FMTContract
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ServerSignContract(Contract, CompanyGuid) end
---@param Winch UMTWinchComponent
---@param bNotEnoughForce boolean
function AMotorTownPlayerController:ServerSetWinchNotEnoughForce(Winch, bNotEnoughForce) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param RouteGuid FGuid
function AMotorTownPlayerController:ServerSetVehicleTruckRoute(CompanyGuid, VehicleId, RouteGuid) end
---@param Vehicle AMTVehicle
---@param SettingType EMTVehicleSettingType
---@param Value FMTSettingValue
function AMotorTownPlayerController:ServerSetVehicleSetting(Vehicle, SettingType, Value) end
---@param Vehicle AMTVehicle
---@param NewParts TArray<FMTVehiclePart>
---@param Tag FString
function AMotorTownPlayerController:ServerSetVehicleParts(Vehicle, NewParts, Tag) end
---@param Vehicle AMTVehicle
---@param PartSlot EMTVehiclePartSlot
---@param ValueIndex int32
---@param Value float
function AMotorTownPlayerController:ServerSetVehiclePartFloatValue(Vehicle, PartSlot, ValueIndex, Value) end
---@param Vehicle AMTVehicle
---@param PartSlot EMTVehiclePartSlot
---@param NewDamage float
function AMotorTownPlayerController:ServerSetVehiclePartDamage(Vehicle, PartSlot, NewDamage) end
---@param Vehicle AMTVehicle
---@param ParkingBrake float
function AMotorTownPlayerController:ServerSetVehicleParkingBrake(Vehicle, ParkingBrake) end
---@param Vehicle AMTVehicle
---@param Decal FMTVehicleDecal
function AMotorTownPlayerController:ServerSetVehicleDecal(Vehicle, Decal) end
---@param Vehicle AMTVehicle
---@param Customization FMTVehicleCustomization
function AMotorTownPlayerController:ServerSetVehicleCustomization(Vehicle, Customization) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param RouteGuid FGuid
function AMotorTownPlayerController:ServerSetVehicleBusRoute(CompanyGuid, VehicleId, RouteGuid) end
---@param bSprint boolean
function AMotorTownPlayerController:ServerSetSprint(bSprint) end
---@param AreaVolume AMTAreaVolume
function AMotorTownPlayerController:ServerSetSmallAreaVolume(AreaVolume) end
---@param Winch UMTWinchComponent
---@param Length float
function AMotorTownPlayerController:ServerSetRopeLength(Winch, Length) end
---@param RaceSetting FMTRaceSetting
function AMotorTownPlayerController:ServerSetRaceSetting(RaceSetting) end
---@param VehicleKey FName
function AMotorTownPlayerController:ServerSetQuestTargetVehicleKey(VehicleKey) end
---@param Vehicle AMTVehicle
---@param Throttle float
function AMotorTownPlayerController:ServerSetPTOThrottle(Vehicle, Throttle) end
---@param Guid FGuid
function AMotorTownPlayerController:ServerSetPlayerCharacterGuid(Guid) end
---@param PassengerComponent UMTPassengerComponent
---@param Satisfaction int32
function AMotorTownPlayerController:ServerSetPassngerComfortSatisfaction(PassengerComponent, Satisfaction) end
---@param Vehicle AMTVehicle
---@param Slot EMTVehiclePartSlot
---@param Inventory FMTItemInventory
function AMotorTownPlayerController:ServerSetPartInventory(Vehicle, Slot, Inventory) end
---@param Vehicle AMTVehicle
---@param Setting FMTVehicleOwnerSetting
function AMotorTownPlayerController:ServerSetOwnerVehicleSetting(Vehicle, Setting) end
---@param Money int64
function AMotorTownPlayerController:ServerSetMoney(Money) end
---@param LevelType EMTCharacterLevelType
---@param Level int32
function AMotorTownPlayerController:ServerSetLevel(LevelType, Level) end
---@param AreaVolume AMTAreaVolume
function AMotorTownPlayerController:ServerSetLargeAreaVolume(AreaVolume) end
---@param InbInNotLoadedLevel boolean
function AMotorTownPlayerController:ServerSetInNotLoadedLevel(InbInNotLoadedLevel) end
---@param Vehicle AMTVehicle
---@param Fuel float
function AMotorTownPlayerController:ServerSetFuel(Vehicle, Fuel) end
---@param EventGuid FGuid
---@param RaceSetup FMTRaceEventSetup
function AMotorTownPlayerController:ServerSetEventRaceSetup(EventGuid, RaceSetup) end
---@param EventGuid FGuid
---@param CaptureFlagSetup FMTCaptureTheFlagEventSetup
function AMotorTownPlayerController:ServerSetEventCaptureFlagSetup(EventGuid, CaptureFlagSetup) end
---@param InDrone AMTDrone
---@param Movement FMTDroneNetMovement
function AMotorTownPlayerController:ServerSetDroneMovement(InDrone, Movement) end
---@param Lane AMTDragRaceLane
---@param Record FMTDragRaceRecord
function AMotorTownPlayerController:ServerSetDragRaceRecord(Lane, Record) end
---@param Lane AMTDragRaceLane
---@param State EMTDragRaceSensorState
function AMotorTownPlayerController:ServerSetDragRaceLaneState(Lane, State) end
---@param Lane AMTDragRaceLane
---@param Flags uint32
function AMotorTownPlayerController:ServerSetDragRaceLaneLCFlags(Lane, Flags) end
---@param Door UMTVehicleDoorComponent
---@param Control float
function AMotorTownPlayerController:ServerSetDoorControl(Door, Control) end
---@param AbsoluteLocation FVector
function AMotorTownPlayerController:ServerSetCustomDestination(AbsoluteLocation) end
---@param Input uint32
function AMotorTownPlayerController:ServerSetCraneControlInput(Input) end
---@param Constraint UMTConstraintComponent
---@param Body0Movement FMTConstraintRepBodyLocalMovement
---@param Body1Movement FMTConstraintRepBodyLocalMovement
function AMotorTownPlayerController:ServerSetConstraintMovement(Constraint, Body0Movement, Body1Movement) end
---@param Constraint UMTConstraintComponent
---@param Control float
function AMotorTownPlayerController:ServerSetConstraintHydraulicControl(Constraint, Control) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param Setting FMTCompanyVehicleSetting
function AMotorTownPlayerController:ServerSetCompanyVehicleSetting(CompanyGuid, VehicleId, Setting) end
---@param CompanyGuid FGuid
---@param CharacterId FMTCharacterId
---@param RoleGuid FGuid
function AMotorTownPlayerController:ServerSetCompanyPlayerRole(CompanyGuid, CharacterId, RoleGuid) end
---@param Parts FMTCharacterParts
function AMotorTownPlayerController:ServerSetCharacterParts(Parts) end
---@param Vehicle AMTVehicle
---@param CargoSpace UMTVehicleCargoSpaceComponent
function AMotorTownPlayerController:ServerSetCarrier(Vehicle, CargoSpace) end
---@param Vehicle AMTVehicle
---@param RouteKey FName
function AMotorTownPlayerController:ServerSetBusRoute(Vehicle, RouteKey) end
---@param Building AMTBuilding
---@param Inventory FMTItemInventory
function AMotorTownPlayerController:ServerSetBuildingInventory(Building, Inventory) end
---@param bAFK boolean
function AMotorTownPlayerController:ServerSetAFK(bAFK) end
---@param Actor AActor
---@param MinLifeSpan float
function AMotorTownPlayerController:ServerSetActorMinLifeSpan(Actor, MinLifeSpan) end
---@param Message FString
---@param Category EMTChatCategory
function AMotorTownPlayerController:ServerSendChat(Message, Category) end
---@param Vehicle AMTVehicle
---@param Cost int64
function AMotorTownPlayerController:ServerSellVehicle(Vehicle, Cost) end
---@param SuspectCharacter AMTCharacter
---@param bWarningOnly boolean
function AMotorTownPlayerController:ServerSelectPolicePullOverPenaltyResponse(SuspectCharacter, bWarningOnly) end
---@param Door UMTVehicleDoorComponent
---@param bClosed boolean
function AMotorTownPlayerController:ServerSaveDoorExtendedRange(Door, bClosed) end
---@param DepotGuid FGuid
---@param Amount float
---@param Cost int64
function AMotorTownPlayerController:ServerRestockDepot(DepotGuid, Amount, Cost) end
function AMotorTownPlayerController:ServerRestartRace() end
---@param AbsoluteLocation FVector
function AMotorTownPlayerController:ServerRespawnCharacter(AbsoluteLocation) end
---@param Vehicle AMTVehicle
---@param WorldLocation FVector
---@param Rotation FRotator
---@param bRemoveCargo boolean
function AMotorTownPlayerController:ServerResetVehicleAtResponse(Vehicle, WorldLocation, Rotation, bRemoveCargo) end
---@param Vehicle AMTVehicle
---@param WorldLocation FVector
---@param Rotation FRotator
---@param bRemoveCargo boolean
---@param bResetCarriedVehicles boolean
function AMotorTownPlayerController:ServerResetVehicleAt(Vehicle, WorldLocation, Rotation, bRemoveCargo, bResetCarriedVehicles) end
function AMotorTownPlayerController:ServerResetVehicle() end
---@param Door UMTVehicleDoorComponent
function AMotorTownPlayerController:ServerResetDoorExtendedRange(Door) end
function AMotorTownPlayerController:ServerResetAFKTimer() end
---@param Passenger UMTPassengerComponent
---@param bWarnIfFailed boolean
function AMotorTownPlayerController:ServerReservePassenger(Passenger, bWarnIfFailed) end
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ServerRequestJoinCompany(CompanyGuid) end
---@param Lane AMTDragRaceLane
---@param Vehicle AMTVehicle
---@param State EMTDragRaceSensorState
---@param LCFlags uint32
function AMotorTownPlayerController:ServerRequestDragRaceLaneOwner(Lane, Vehicle, State, LCFlags) end
---@param Wheel UMHWheelComponent
---@param ItemKey FName
---@param QuickSlotIndex int32
function AMotorTownPlayerController:ServerRepairFlatTireWithItem(Wheel, ItemKey, QuickSlotIndex) end
---@param House AMTHouse
function AMotorTownPlayerController:ServerRentHouse(House) end
---@param House AMTHouse
---@param Money int64
---@param Seconds double
function AMotorTownPlayerController:ServerRentExtendHouse(House, Money, Seconds) end
---@param Vehicle AMTVehicle
---@param RentCost int64
function AMotorTownPlayerController:ServerRent(Vehicle, RentCost) end
---@param Actor AActor
function AMotorTownPlayerController:ServerRemoveTargetJobActor(Actor) end
---@param Vehicle AMTVehicle
---@param FuelType EMTFuelType
function AMotorTownPlayerController:ServerRemoveTankerFuel(Vehicle, FuelType) end
---@param Actor AActor
function AMotorTownPlayerController:ServerRemoveRGWatchActor(Actor) end
---@param UniqueNetId FString
function AMotorTownPlayerController:ServerRemovePolicePlayer(UniqueNetId) end
---@param Flags uint32
function AMotorTownPlayerController:ServerRemoveFlags(Flags) end
---@param EventGuid FGuid
function AMotorTownPlayerController:ServerRemoveEvent(EventGuid) end
---@param CargoSpace UMTVehicleCargoSpaceComponent
---@param Cargo AMTCargo
function AMotorTownPlayerController:ServerRemoveDroppedCargo(CargoSpace, Cargo) end
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ServerRemoveCompanyVehicleSlot(CompanyGuid) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param Flags uint32
function AMotorTownPlayerController:ServerRemoveCompanyVehicleFlags(CompanyGuid, VehicleId, Flags) end
---@param CompanyGuid FGuid
---@param VehicleId int64
function AMotorTownPlayerController:ServerRemoveCompanyVehicle(CompanyGuid, VehicleId) end
---@param CompanyGuid FGuid
---@param TruckRouteGuid FGuid
function AMotorTownPlayerController:ServerRemoveCompanyTruckRoute(CompanyGuid, TruckRouteGuid) end
---@param CompanyGuid FGuid
---@param BusRouteGuid FGuid
function AMotorTownPlayerController:ServerRemoveCompanyBusRoute(CompanyGuid, BusRouteGuid) end
---@param Building AMTBuilding
function AMotorTownPlayerController:ServerRemoveBuilding(Building) end
---@param UniqueNetId FString
function AMotorTownPlayerController:ServerRemoveBannedPlayer(UniqueNetId) end
---@param CargoSpace UMTVehicleCargoSpaceComponent
function AMotorTownPlayerController:ServerRemoveAllCargo(CargoSpace) end
---@param UniqueNetId FString
function AMotorTownPlayerController:ServerRemoveAdmin(UniqueNetId) end
---@param Lane AMTDragRaceLane
function AMotorTownPlayerController:ServerReleaseDragRaceLaneOwner(Lane) end
---@param Cargo AMTCargo
function AMotorTownPlayerController:ServerReleaseCargoMovementOwner(Cargo) end
---@param Vehicle AMTVehicle
---@param ItemKey FName
---@param QuickSlotIndex int32
function AMotorTownPlayerController:ServerRefuelWithJerrycan(Vehicle, ItemKey, QuickSlotIndex) end
---@param Vehicle AMTVehicle
---@param CargoSpace UMTVehicleCargoSpaceComponent
---@param FuelType EMTFuelType
---@param CurrentFuel float
---@param TargetFuel float
---@param Cost int64
---@param bChargeToOwner boolean
---@param TankerVehicle AMTVehicle
function AMotorTownPlayerController:ServerRefuelVehicle(Vehicle, CargoSpace, FuelType, CurrentFuel, TargetFuel, Cost, bChargeToOwner, TankerVehicle) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param Requester FMTCharacterId
---@param VehicleData FMTPlayerDataVehicle
---@param Parts TArray<FMTPlayerDataVehiclePart>
function AMotorTownPlayerController:ServerQueryCompanyVehicleDataResponse(CompanyGuid, VehicleId, Requester, VehicleData, Parts) end
---@param CompanyGuid FGuid
---@param VehicleId int64
function AMotorTownPlayerController:ServerQueryCompanyVehicleData(CompanyGuid, VehicleId) end
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ServerQueryCompany(CompanyGuid) end
---@param Cargo AMTCargo
---@param Location FVector
---@param Rotation FRotator
function AMotorTownPlayerController:ServerPutdownHoldingCargo(Cargo, Location, Rotation) end
function AMotorTownPlayerController:ServerPutdownCarryingCharacter() end
---@param Vehicle AMTVehicle
---@param RelativeLocation FVector
---@param Volume float
function AMotorTownPlayerController:ServerPlayVehicleHitSound(Vehicle, RelativeLocation, Volume) end
---@param InteractionType EMotorTownInteractableType
function AMotorTownPlayerController:ServerPlayInteractionMontage(InteractionType) end
---@param Winch UMTWinchComponent
function AMotorTownPlayerController:ServerPickupWinchHook(Winch) end
---@param Winch UMTWinchComponent
function AMotorTownPlayerController:ServerPickupWinchController(Winch) end
---@param ItemActor AActor
function AMotorTownPlayerController:ServerPickupItem(ItemActor) end
---@param ItemActor AActor
---@param InItemKey FName
---@param bSuccess boolean
---@param bDestroyActor boolean
---@param bCharge boolean
function AMotorTownPlayerController:ServerPickupedItem(ItemActor, InItemKey, bSuccess, bDestroyActor, bCharge) end
---@param Cargo AMTCargo
function AMotorTownPlayerController:ServerPickupCargo(Cargo) end
---@param PassengerComponent UMTPassengerComponent
function AMotorTownPlayerController:ServerPassengerArrived(PassengerComponent) end
---@param EventGuid FGuid
---@param SectionIndex int32
---@param TotalTimeSeconds float
---@param LaptimeSeconds float
function AMotorTownPlayerController:ServerPassedRaceSection(EventGuid, SectionIndex, TotalTimeSeconds, LaptimeSeconds) end
---@param Building AMTBuilding
---@param ParkingSpaceKey FName
---@param VehicleId int64
function AMotorTownPlayerController:ServerParkVehicle(Building, ParkingSpaceKey, VehicleId) end
---@param InteractableComponent UMTInteractableComponent
function AMotorTownPlayerController:ServerOnPreInteraction(InteractableComponent) end
---@param CompanyGuid FGuid
---@param TruckRoute FMTCompanyTruckRoute
function AMotorTownPlayerController:ServerModifyCompanyTruckRoute(CompanyGuid, TruckRoute) end
---@param CompanyGuid FGuid
---@param BusRoute FMTCompanyBusRoute
function AMotorTownPlayerController:ServerModifyCompanyBusRoute(CompanyGuid, BusRoute) end
---@param CompanyGuid FGuid
---@param VehicleIds TArray<int64>
function AMotorTownPlayerController:ServerMaintenanceCompanyVehicles(CompanyGuid, VehicleIds) end
---@param CompanyGuid FGuid
---@param VehicleId int64
function AMotorTownPlayerController:ServerMaintenanceCompanyVehicle(CompanyGuid, VehicleId) end
---@param Cargo AMTCargo
---@param CargoSpace UMTVehicleCargoSpaceComponent
---@param bReposition boolean
function AMotorTownPlayerController:ServerLoadCargo(Cargo, CargoSpace, bReposition) end
---@param Vehicle AMTVehicle
---@param Cargo AMTCargo
---@param DurationSeconds float
function AMotorTownPlayerController:ServerLinkCargoMovementOwner(Vehicle, Cargo, DurationSeconds) end
function AMotorTownPlayerController:ServerLeaveParty() end
---@param EventGuid FGuid
function AMotorTownPlayerController:ServerLeaveEvent(EventGuid) end
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ServerLeaveCompany(CompanyGuid) end
---@param TargetPlayerState AMotorTownPlayerState
function AMotorTownPlayerController:ServerKickPlayer(TargetPlayerState) end
---@param CompanyGuid FGuid
---@param CharacterId FMTCharacterId
function AMotorTownPlayerController:ServerKickCompanyPlayer(CompanyGuid, CharacterId) end
---@param EventGuid FGuid
function AMotorTownPlayerController:ServerJoinEvent(EventGuid) end
---@param InviteePlayerState AMotorTownPlayerState
function AMotorTownPlayerController:ServerInviteToParty(InviteePlayerState) end
---@param CompanyGuid FGuid
---@param InviteePlayerState AMotorTownPlayerState
function AMotorTownPlayerController:ServerInviteToCompany(CompanyGuid, InviteePlayerState) end
---@param Vehicle AMTVehicle
function AMotorTownPlayerController:ServerInteract_RequestTowing(Vehicle) end
---@param Vehicle AMTVehicle
function AMotorTownPlayerController:ServerInteract_Garbage_CompressLoader(Vehicle) end
---@param CargoSpawner AMTCargoSpawner
function AMotorTownPlayerController:ServerInteract_CargoSpawner(CargoSpawner) end
---@param QuickSlotIndex int32
---@param ItemKey FName
---@param ItemActor AActor
function AMotorTownPlayerController:ServerHoldItemActor(QuickSlotIndex, ItemKey, ItemActor) end
---@param QuickSlotIndex int32
---@param ItemKey FName
function AMotorTownPlayerController:ServerHoldItem(QuickSlotIndex, ItemKey) end
---@param CompanyGuid FGuid
---@param Vehicle FMTCompanyVehicle
---@param VehicleData FMTPlayerDataVehicle
---@param Parts TArray<FMTPlayerDataVehiclePart>
function AMotorTownPlayerController:ServerHandOverVehicleToCompany(CompanyGuid, Vehicle, VehicleData, Parts) end
---@param CompanyGuid FGuid
---@param VehicleId int64
function AMotorTownPlayerController:ServerHandOverVehicleFromCompanyResponse(CompanyGuid, VehicleId) end
---@param CompanyGuid FGuid
---@param VehicleId int64
function AMotorTownPlayerController:ServerHandOverVehicleFromCompany(CompanyGuid, VehicleId) end
---@param Vehicle AMTVehicle
function AMotorTownPlayerController:ServerHandoverToCompanyAI(Vehicle) end
---@param UsableActor AActor
---@param Interactor AActor
---@param Param1 float
function AMotorTownPlayerController:ServerHandleUse(UsableActor, Interactor, Param1) end
---@param BedActor AActor
function AMotorTownPlayerController:ServerHandleSleep(BedActor) end
---@param ChairActor AActor
function AMotorTownPlayerController:ServerHandleSeat(ChairActor) end
---@param Vehicle AMTVehicle
---@param Money int64
---@param TransactionType EMoneyTransactionType
function AMotorTownPlayerController:ServerGiveOwnerProfitShare(Vehicle, Money, TransactionType) end
function AMotorTownPlayerController:ServerGetawayArrived() end
---@param Vehicle AMTVehicle
function AMotorTownPlayerController:ServerGetawayAcceptJob(Vehicle) end
---@param Vehicle AMTVehicle
function AMotorTownPlayerController:ServerForceLeaveAllPassengers(Vehicle) end
---@param Vehicle AMTVehicle
---@param BusStop AMTBusStop
function AMotorTownPlayerController:ServerForceLeaveAllBusPassengerToBusStop(Vehicle, BusStop) end
---@param SeatedCharacter AMTCharacter
---@param bSay boolean
function AMotorTownPlayerController:ServerForceExitVehicle(SeatedCharacter, bSay) end
---@param Response FString
function AMotorTownPlayerController:ServerFirstTickResponse(Response) end
function AMotorTownPlayerController:ServerFirstTick() end
---@param PatrolPointId int32
---@param Seconds float
function AMotorTownPlayerController:ServerExtendPolicePatrolPoint(PatrolPointId, Seconds) end
function AMotorTownPlayerController:ServerExitVehicle() end
---@param Vehicle AMTVehicle
---@param SeatName FString
function AMotorTownPlayerController:ServerEnterVehicleBySeatName(Vehicle, SeatName) end
---@param VehicleId int64
---@param SeatName FString
---@param bCheckDistance boolean
function AMotorTownPlayerController:ServerEnterVehicleByIdAndSeatName(VehicleId, SeatName, bCheckDistance) end
---@param Vehicle AMTVehicle
---@param SeatType EMTSeatType
---@param SeatIndex int32
---@param bSteal boolean
function AMotorTownPlayerController:ServerEnterVehicle(Vehicle, SeatType, SeatIndex, bSteal) end
function AMotorTownPlayerController:ServerEnteredVehicleByInitGame() end
---@param InCharacter AMTCharacter
function AMotorTownPlayerController:ServerEndDialogue(InCharacter) end
---@param ItemKey FName
---@param InventorySlotIndex int32
---@param bOwnItem boolean
---@param Location FVector
---@param Rotation FRotator
function AMotorTownPlayerController:ServerDropItem(ItemKey, InventorySlotIndex, bOwnItem, Location, Rotation) end
---@param Tractor AMTVehicle
---@param Trailer AMTVehicle
function AMotorTownPlayerController:ServerDetachTrailer(Tractor, Trailer) end
---@param Towing UMTTowingComponent
function AMotorTownPlayerController:ServerDetachTowing(Towing) end
---@param InDrone AMTDrone
function AMotorTownPlayerController:ServerDestroyDrone(InDrone) end
---@param ActorTag FName
---@param ReplacingVehicleKey FName
---@param ReplacingLocation FVector
function AMotorTownPlayerController:ServerDespawnVehiclesByTag(ActorTag, ReplacingVehicleKey, ReplacingLocation) end
---@param Vehicle AMTVehicle
---@param Cost int64
function AMotorTownPlayerController:ServerDespawnVehicle(Vehicle, Cost) end
---@param Cargo AMTCargo
function AMotorTownPlayerController:ServerDespawnCargo(Cargo) end
---@param CompanyGuid FGuid
---@param JoinRequest FMTCompanyJoinRequest
function AMotorTownPlayerController:ServerDenyCompanyJoinRequest(CompanyGuid, JoinRequest) end
---@param Winch UMTWinchComponent
function AMotorTownPlayerController:ServerCutWinchCable(Winch) end
---@param CompanyName FString
---@param bIsCorporation boolean
---@param Money int64
function AMotorTownPlayerController:ServerCreateCompany(CompanyName, bIsCorporation, Money) end
function AMotorTownPlayerController:ServerCrash() end
---@param ContractGuid FGuid
function AMotorTownPlayerController:ServerContractCargoDelivered(ContractGuid) end
---@param WaterSpray UMTWaterSprayComponent
---@param Amount float
function AMotorTownPlayerController:ServerConsumeWaterFromSpray(WaterSpray, Amount) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param RoutePointIndex int32
function AMotorTownPlayerController:ServerCompanyVehicleSetRoutePointIndex(CompanyGuid, VehicleId, RoutePointIndex) end
---@param Command FString
function AMotorTownPlayerController:ServerCommand(Command) end
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ServerCloseDownCompany(CompanyGuid) end
function AMotorTownPlayerController:ServerClearLaptime() end
function AMotorTownPlayerController:ServerCheatUnposes() end
---@param EventCharacter AMTCharacter
---@param EventType EMTCharacterEventType
function AMotorTownPlayerController:ServerCharacterEvent(EventCharacter, EventType) end
---@param SpawnParams FMTVehicleSpawnParams
---@param Cost int64
---@param RequesterCharacterId FMTCharacterId
function AMotorTownPlayerController:ServerChangeVehicle(SpawnParams, Cost, RequesterCharacterId) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param Location FVector
---@param Rotation FRotator
---@param Cost int64
function AMotorTownPlayerController:ServerChangeToCompanyVehicle(CompanyGuid, VehicleId, Location, Rotation, Cost) end
---@param EventGuid FGuid
---@param EventState EMTEventState
function AMotorTownPlayerController:ServerChangeEventState(EventGuid, EventState) end
---@param DepotGuid FGuid
---@param ChangeRequest FMTCompanyDepotChangeRequest
function AMotorTownPlayerController:ServerChangeDepotSettings(DepotGuid, ChangeRequest) end
---@param CompanyGuid FGuid
---@param Settings FMTCompanySettings
function AMotorTownPlayerController:ServerChangeCompanySettings(CompanyGuid, Settings) end
---@param Cargo AMTCargo
function AMotorTownPlayerController:ServerCargoDumped(Cargo) end
---@param CargoSpace UMTVehicleCargoSpaceComponent
---@param NewDroppedCargos TArray<AMTCargo>
function AMotorTownPlayerController:ServerCargoDropped(CargoSpace, NewDroppedCargos) end
---@param Cargos TArray<AMTCargo>
function AMotorTownPlayerController:ServerCargoArrived(Cargos) end
---@param EventGuid FGuid
---@param CharacterIdA FMTCharacterId
---@param CharacterIdB FMTCharacterId
function AMotorTownPlayerController:ServerCaptureTheFlagEventCollision(EventGuid, CharacterIdA, CharacterIdB) end
---@param Passenger UMTPassengerComponent
function AMotorTownPlayerController:ServerCancelReservePassenger(Passenger) end
---@param Vehicle AMTVehicle
---@param Cargos TArray<AMTCargo>
function AMotorTownPlayerController:ServerCancelLoadCargos(Vehicle, Cargos) end
---@param Vehicle AMTVehicle
---@param DeliveryId int32
---@param NumCargo int32
function AMotorTownPlayerController:ServerCancelLoadCargo(Vehicle, DeliveryId, NumCargo) end
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ServerCancelJoinCompanyRequest(CompanyGuid) end
---@param House AMTHouse
function AMotorTownPlayerController:ServerBuyHouse(House) end
---@param ItemKey FName
---@param BuildingKey FName
---@param QuickSlotIndex int32
---@param Location FVector
---@param Rotation FRotator
---@param Housing AMTHouse
function AMotorTownPlayerController:ServerBuild(ItemKey, BuildingKey, QuickSlotIndex, Location, Rotation, Housing) end
---@param Winch UMTWinchComponent
function AMotorTownPlayerController:ServerBreakWinch(Winch) end
---@param Vehicle AMTVehicle
function AMotorTownPlayerController:ServerBoughtVehicle(Vehicle) end
---@param TargetPlayerState AMotorTownPlayerState
---@param Hours double
---@param Reason FString
function AMotorTownPlayerController:ServerBanPlayer(TargetPlayerState, Hours, Reason) end
---@param HookItemActor AActor
---@param TargetActor AActor
---@param TargetComponent UPrimitiveComponent
---@param Location FVector
---@param Normal FVector
---@param TransformSpace ERelativeTransformSpace
function AMotorTownPlayerController:ServerAttachWinch(HookItemActor, TargetActor, TargetComponent, Location, Normal, TransformSpace) end
---@param Tractor AMTVehicle
---@param Trailer AMTVehicle
function AMotorTownPlayerController:ServerAttachTrailer(Tractor, Trailer) end
---@param Towing UMTTowingComponent
function AMotorTownPlayerController:ServerAttachTowing(Towing) end
---@param Fire AMTFire
function AMotorTownPlayerController:ServerAssignToFireJob(Fire) end
---@param PatrolPointId int32
---@param ArrivedPlayer AMotorTownPlayerController
function AMotorTownPlayerController:ServerArrivedAtPolicePatrolPoint(PatrolPointId, ArrivedPlayer) end
---@param Impact FMTPhysicsImpact
function AMotorTownPlayerController:ServerApplyImpact(Impact) end
---@param Message FString
function AMotorTownPlayerController:ServerAnnouncePinned(Message) end
---@param Message FString
function AMotorTownPlayerController:ServerAnnounce(Message) end
---@param Actor AActor
function AMotorTownPlayerController:ServerAddTargetJobActor(Actor) end
---@param Actor AActor
function AMotorTownPlayerController:ServerAddRGWatchActor(Actor) end
---@param TargetPlayerState AMotorTownPlayerState
function AMotorTownPlayerController:ServerAddPolicePlayer(TargetPlayerState) end
---@param Context FString
---@param Money int64
---@param LevelType EMTCharacterLevelType
---@param ChatMessage FText
---@param Context2 FString
---@param Context3 FString
function AMotorTownPlayerController:ServerAddMoneyAndExpToParty2(Context, Money, LevelType, ChatMessage, Context2, Context3) end
---@param Context FString
---@param Money int64
---@param OwnerFee int64
---@param LevelType EMTCharacterLevelType
---@param ChatMessage FText
---@param Context2 FString
---@param Context3 FString
function AMotorTownPlayerController:ServerAddMoneyAndExpToParty(Context, Money, OwnerFee, LevelType, ChatMessage, Context2, Context3) end
---@param Laptime float
function AMotorTownPlayerController:ServerAddLaptime(Laptime) end
---@param Flags uint32
function AMotorTownPlayerController:ServerAddFlags(Flags) end
---@param FireExtinguishes TArray<FMTNetFireExtinguish>
function AMotorTownPlayerController:ServerAddFireExtinguishes(FireExtinguishes) end
---@param Event FMTEvent
function AMotorTownPlayerController:ServerAddEvent(Event) end
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ServerAddCompanyVehicleSlot(CompanyGuid) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param Flags uint32
function AMotorTownPlayerController:ServerAddCompanyVehicleFlags(CompanyGuid, VehicleId, Flags) end
---@param CompanyGuid FGuid
---@param Vehicle FMTCompanyVehicle
function AMotorTownPlayerController:ServerAddCompanyVehicle(CompanyGuid, Vehicle) end
---@param CompanyGuid FGuid
---@param TruckRoute FMTCompanyTruckRoute
function AMotorTownPlayerController:ServerAddCompanyTruckRoute(CompanyGuid, TruckRoute) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param Money int64
---@param TransactionType EMoneyTransactionType
---@param Context2 FString
---@param Context3 FString
function AMotorTownPlayerController:ServerAddCompanyMoney(CompanyGuid, VehicleId, Money, TransactionType, Context2, Context3) end
---@param CompanyGuid FGuid
---@param BusRoute FMTCompanyBusRoute
function AMotorTownPlayerController:ServerAddCompanyBusRoute(CompanyGuid, BusRoute) end
---@param Company FMTCompany
---@param bLoaded boolean
function AMotorTownPlayerController:ServerAddCompany(Company, bLoaded) end
---@param Cargo AMTCargo
---@param Damage float
function AMotorTownPlayerController:ServerAddCargoDamage(Cargo, Damage) end
---@param TargetPlayerState AMotorTownPlayerState
---@param bForce boolean
function AMotorTownPlayerController:ServerAddAdmin(TargetPlayerState, bForce) end
---@param Vehicle AMTVehicle
---@param PassengerCharacter AMTCharacter
function AMotorTownPlayerController:ServerAcceptPassenger(Vehicle, PassengerCharacter) end
---@param InviterPlayerState AMotorTownPlayerState
---@param bAccept boolean
---@param bIgnored boolean
function AMotorTownPlayerController:ServerAcceptInviteToParty(InviterPlayerState, bAccept, bIgnored) end
---@param CompanyGuid FGuid
---@param InviterCharacterId FMTCharacterId
---@param bAccept boolean
---@param bIgnored boolean
function AMotorTownPlayerController:ServerAcceptInviteToCompany(CompanyGuid, InviterCharacterId, bAccept, bIgnored) end
---@param DeliveryId int32
---@param bShowErrorMessage boolean
function AMotorTownPlayerController:ServerAcceptDelivery(DeliveryId, bShowErrorMessage) end
---@param CompanyGuid FGuid
---@param JoinRequest FMTCompanyJoinRequest
function AMotorTownPlayerController:ServerAcceptCompanyJoinRequest(CompanyGuid, JoinRequest) end
---@param Vehicle AMTVehicle
function AMotorTownPlayerController:ServerAbandonTowRequest(Vehicle) end
---@param TowRequestUniqueId uint32
function AMotorTownPlayerController:ServerAbandonRescueJob(TowRequestUniqueId) end
---@param InDrone AMTDrone
function AMotorTownPlayerController:ServerAbandonDrone(InDrone) end
---@param LightControl UMTLightControlComponent
function AMotorTownPlayerController:Server_ToggleLight(LightControl) end
---@param PreExposure float
function AMotorTownPlayerController:ReceiveSetPreExposure(PreExposure) end
---@param PossessedPawn APawn
function AMotorTownPlayerController:ReceiveSetPawn(PossessedPawn) end
---@param bHide boolean
function AMotorTownPlayerController:ReceiveHideInteractionBox(bHide) end
function AMotorTownPlayerController:OnRep_CompaniesSubData() end
function AMotorTownPlayerController:OnRep_Companies() end
---@param OutCenter FVector
---@param OutLocalExtent FVector
function AMotorTownPlayerController:GetPawnBounds(OutCenter, OutLocalExtent) end
---@param VehicleId int64
function AMotorTownPlayerController:ClientVehicleSpawned(VehicleId) end
---@param VehicleId int64
function AMotorTownPlayerController:ClientVehicleRemovedFromWorld(VehicleId) end
---@param TowRequestComponent UMTTowRequestComponent
function AMotorTownPlayerController:ClientTowRequestArrived(TowRequestComponent) end
---@param AbsoluteLocation FVector
function AMotorTownPlayerController:ClientTeleportedCharacter(AbsoluteLocation) end
---@param CompanyGuid FGuid
---@param NumOwnVehicles int32
---@param OwnVehiclesOffset int32
---@param OwnVehicles TArray<FMTPlayerDataVehicle>
---@param NumOwnVehicleParts int32
---@param OwnVehiclePartsOffset int32
---@param OwnVehicleParts TArray<FMTPlayerDataVehiclePart>
function AMotorTownPlayerController:ClientSyncCompanyPartial(CompanyGuid, NumOwnVehicles, OwnVehiclesOffset, OwnVehicles, NumOwnVehicleParts, OwnVehiclePartsOffset, OwnVehicleParts) end
---@param Cargo AMTCargo
function AMotorTownPlayerController:ClientStrapCargoSucceed(Cargo) end
function AMotorTownPlayerController:ClientStopSpectatingPlayer() end
---@param Vehicle AMTVehicle
---@param WIMType EMTWeightInMotionType
function AMotorTownPlayerController:ClientStartWeightInMotion(Vehicle, WIMType) end
---@param TargetActor AActor
function AMotorTownPlayerController:ClientStartSpectatingActor(TargetActor) end
function AMotorTownPlayerController:ClientStartDeliveryMission() end
---@param VehicleId int64
---@param Location FVector
---@param Rotation FRotator
---@param Cost int64
---@param RequesterCharacterId FMTCharacterId
function AMotorTownPlayerController:ClientSpawnVehicle(VehicleId, Location, Rotation, Cost, RequesterCharacterId) end
---@param InDrone AMTDrone
---@param InDroneItemKey FName
function AMotorTownPlayerController:ClientSpawnDroneResponse(InDrone, InDroneItemKey) end
---@param NumSpawned int32
function AMotorTownPlayerController:ClientSpawnDrivingModeVehiclesFinished(NumSpawned) end
---@param TextNamespace FString
---@param TextKey FString
function AMotorTownPlayerController:ClientShowSystemMessageLocalizedInternal(TextNamespace, TextKey) end
---@param Message FText
function AMotorTownPlayerController:ClientShowSystemMessage(Message) end
---@param TextNamespace FString
---@param TextKey FString
function AMotorTownPlayerController:ClientShowPopupMessageLocalizedInternal(TextNamespace, TextKey) end
---@param Message FText
function AMotorTownPlayerController:ClientShowPopupMessage(Message) end
---@param Message FText
function AMotorTownPlayerController:ClientShowErrorMessage(Message) end
---@param Index int32
function AMotorTownPlayerController:ClientSetWeatherIndex(Index) end
---@param TimeOfDay float
---@param Speed float
function AMotorTownPlayerController:ClientSetTimeOfDay(TimeOfDay, Speed) end
---@param VehicleId int64
---@param Cost int64
function AMotorTownPlayerController:ClientSellVehicleFinished(VehicleId, Cost) end
---@param SuspectCharacter AMTCharacter
function AMotorTownPlayerController:ClientSelectPolicePullOverPenalty(SuspectCharacter) end
function AMotorTownPlayerController:ClientSaveVehicles() end
---@param AbsoluteLocation FVector
function AMotorTownPlayerController:ClientRespawnCharacter(AbsoluteLocation) end
---@param Vehicle AMTVehicle
---@param WorldLocation FVector
---@param Rotation FRotator
---@param bResetTrailers boolean
---@param bResetCarriedVehicles boolean
function AMotorTownPlayerController:ClientResetVehicleAt(Vehicle, WorldLocation, Rotation, bResetTrailers, bResetCarriedVehicles) end
---@param Passenger UMTPassengerComponent
---@param bSucceeded boolean
function AMotorTownPlayerController:ClientReservePassengerResponse(Passenger, bSucceeded) end
---@param bSucceeded boolean
---@param Lane AMTDragRaceLane
---@param Vehicle AMTVehicle
function AMotorTownPlayerController:ClientRequestDragRaceLaneOwnerResponse(bSucceeded, Lane, Vehicle) end
---@param bSucceeded boolean
---@param Wheel UMHWheelComponent
---@param ItemKey FName
---@param QuickSlotIndex int32
function AMotorTownPlayerController:ClientRepairFlatTireWithItemResponse(bSucceeded, Wheel, ItemKey, QuickSlotIndex) end
---@param ItemKey FName
---@param QuickSlotIndex int32
function AMotorTownPlayerController:ClientRemoveItemBySlot(ItemKey, QuickSlotIndex) end
---@param ItemKey FName
function AMotorTownPlayerController:ClientRemoveItem(ItemKey) end
---@param EventGuid FGuid
---@param bSucceeded boolean
function AMotorTownPlayerController:ClientRemoveEventResponse(EventGuid, bSucceeded) end
---@param EventGuid FGuid
function AMotorTownPlayerController:ClientRemovedFromJoinedEvent(EventGuid) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param VehicleData FMTPlayerDataVehicle
---@param Parts TArray<FMTPlayerDataVehiclePart>
function AMotorTownPlayerController:ClientQueryCompanyVehicleDataResponse(CompanyGuid, VehicleId, VehicleData, Parts) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param Requester FMTCharacterId
function AMotorTownPlayerController:ClientQueryCompanyVehicleData(CompanyGuid, VehicleId, Requester) end
---@param Company FMTCompany
function AMotorTownPlayerController:ClientQueryCompanyResponse(Company) end
---@param PlayerName FString
function AMotorTownPlayerController:ClientPlayerLoggedout(PlayerName) end
---@param PlayerName FString
function AMotorTownPlayerController:ClientPlayerLoggedIn(PlayerName) end
---@param LeftPlayerState AMotorTownPlayerState
function AMotorTownPlayerController:ClientPlayerLeftParty(LeftPlayerState) end
---@param NewPlayerState AMotorTownPlayerState
function AMotorTownPlayerController:ClientPlayerJoinedParty(NewPlayerState) end
---@param ItemActor AActor
---@param InItemKey FName
---@param bCharge boolean
function AMotorTownPlayerController:ClientPickupItem(ItemActor, InItemKey, bCharge) end
---@param Cargo AMTCargo
function AMotorTownPlayerController:ClientPickupCargoSucceeded(Cargo) end
---@param Money int64
---@param ViolationTextNamespace FString
---@param ViolationTextKey FString
function AMotorTownPlayerController:ClientPayFineInternal(Money, ViolationTextNamespace, ViolationTextKey) end
---@param NumBuildings int32
---@param NumMaxBuildings int32
function AMotorTownPlayerController:ClientMessageNumBuildings(NumBuildings, NumMaxBuildings) end
function AMotorTownPlayerController:ClientLeftParty() end
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ClientLeftCompany(CompanyGuid) end
---@param PartyId int32
function AMotorTownPlayerController:ClientJoinedParty(PartyId) end
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ClientJoinedCompany(CompanyGuid) end
---@param CounterType EMTPlayerCounterType
---@param Count int32
function AMotorTownPlayerController:ClientIncreasePlayerCounter(CounterType, Count) end
---@param VehicleId int64
---@param bSucceeded boolean
function AMotorTownPlayerController:ClientHandOverVehicleToCompanyResponse(VehicleId, bSucceeded) end
---@param CompanyGuid FGuid
---@param VehicleId int64
---@param VehicleData FMTPlayerDataVehicle
---@param Parts TArray<FMTPlayerDataVehiclePart>
---@param bSucceeded boolean
function AMotorTownPlayerController:ClientHandOverVehicleFromCompanyResponse(CompanyGuid, VehicleId, VehicleData, Parts, bSucceeded) end
---@param Reward FMTReward
function AMotorTownPlayerController:ClientGiveReward(Reward) end
function AMotorTownPlayerController:ClientForceExitFromSeat() end
function AMotorTownPlayerController:ClientFirstTickResponse() end
---@param Fire AMTFire
function AMotorTownPlayerController:ClientExtinguishFireSucceed(Fire) end
---@param Event FMTEvent
function AMotorTownPlayerController:ClientEventStateChanged(Event) end
---@param Event FMTEvent
function AMotorTownPlayerController:ClientEventFinished(Event) end
---@param Event FMTEvent
---@param ChangedType EMTEventChangedType
function AMotorTownPlayerController:ClientEventChanged(Event, ChangedType) end
---@param ItemKey FName
---@param InventorySlotIndex int32
---@param bSuccess boolean
---@param bOwnItem boolean
---@param ItemActor AActor
function AMotorTownPlayerController:ClientDropItemResult(ItemKey, InventorySlotIndex, bSuccess, bOwnItem, ItemActor) end
function AMotorTownPlayerController:ClientDestroyDroneResponse() end
---@param Company FMTCompany
---@param Money int64
---@param bSucceeded boolean
function AMotorTownPlayerController:ClientCreateCompanyResponse(Company, Money, bSucceeded) end
---@param Vehicle AMTVehicle
function AMotorTownPlayerController:ClientConfirmHandoverToCompanyAI(Vehicle) end
---@param Report FMTCompanyReport
function AMotorTownPlayerController:ClientCompanyReport(Report) end
---@param CompanyGuid FGuid
function AMotorTownPlayerController:ClientCloseDownCompanySucceeded(CompanyGuid) end
---@param MotorTownPlayerState AMotorTownPlayerState
---@param TextNamespace FString
---@param TextKey FString
function AMotorTownPlayerController:ClientChatLocalizedInternal(MotorTownPlayerState, TextNamespace, TextKey) end
---@param MotorTownPlayerState AMotorTownPlayerState
---@param Message FString
---@param Category EMTChatCategory
---@param Color FColor
function AMotorTownPlayerController:ClientChat(MotorTownPlayerState, Message, Category, Color) end
---@param Company FMTCompany
function AMotorTownPlayerController:ClientChangeCompanySettingsResponse(Company) end
---@param bSucceeded boolean
---@param ItemKey FName
---@param QuickSlotIndex int32
function AMotorTownPlayerController:ClientBuildResult(bSucceeded, ItemKey, QuickSlotIndex) end
---@param Towing UMTTowingComponent
---@param bSucceeded boolean
function AMotorTownPlayerController:ClientAttachTowingResult(Towing, bSucceeded) end
---@param DriverName FString
---@param Money int64
---@param VehicleKey FString
function AMotorTownPlayerController:ClientAddMoneyByProfitShare(DriverName, Money, VehicleKey) end
---@param Context FString
---@param Money int64
---@param LevelType EMTCharacterLevelType
---@param exp int64
---@param ChatMessage FText
---@param Context2 FString
---@param Context3 FString
function AMotorTownPlayerController:ClientAddMoneyAndExp(Context, Money, LevelType, exp, ChatMessage, Context2, Context3) end
---@param Money int64
---@param Context FString
---@param ChatMessage FText
---@param bAllowNegative boolean
---@param Context2 FString
---@param Context3 FString
function AMotorTownPlayerController:ClientAddMoney(Money, Context, ChatMessage, bAllowNegative, Context2, Context3) end
---@param ItemKey FName
---@param NumItems int32
function AMotorTownPlayerController:ClientAddItem(ItemKey, NumItems) end
---@param Context FString
---@param LevelType EMTCharacterLevelType
---@param exp int64
---@param ChatMessage FText
function AMotorTownPlayerController:ClientAddExp(Context, LevelType, exp, ChatMessage) end
---@param Event FMTEvent
---@param bSucceeded boolean
function AMotorTownPlayerController:ClientAddEventResponse(Event, bSucceeded) end
---@param ItemKey FName
---@param ChatMessage FText
function AMotorTownPlayerController:ClientAddCoupon(ItemKey, ChatMessage) end
---@param InviterPlayerState AMotorTownPlayerState
function AMotorTownPlayerController:ClientAcceptInviteToParty(InviterPlayerState) end
---@param CompanyGuid FGuid
---@param InviterCharacterId FMTCharacterId
---@param InviterPlayerName FString
function AMotorTownPlayerController:ClientAcceptInviteToCompany(CompanyGuid, InviterCharacterId, InviterPlayerName) end
function AMotorTownPlayerController:ClientAbandonDroneResponse() end
function AMotorTownPlayerController:Cheat_ZeroToHundreds() end
function AMotorTownPlayerController:Cheat_VehicleValidate() end
function AMotorTownPlayerController:Cheat_VehicleSaveDefaultAttachments() end
function AMotorTownPlayerController:Cheat_VehicleCTFFlag() end
function AMotorTownPlayerController:Cheat_UpdateIgnoreCollisionActors() end
---@param ZoneKey FString
---@param Rate float
function AMotorTownPlayerController:Cheat_TownPolicePatrolRate(ZoneKey, Rate) end
---@param TopSpeedKPH float
function AMotorTownPlayerController:Cheat_TopSpeed(TopSpeedKPH) end
---@param Speed float
function AMotorTownPlayerController:Cheat_TimeOfDaySpeed(Speed) end
---@param TimeOfDay float
function AMotorTownPlayerController:Cheat_TimeOfDay(TimeOfDay) end
function AMotorTownPlayerController:Cheat_Test2() end
function AMotorTownPlayerController:Cheat_Test() end
function AMotorTownPlayerController:Cheat_Sunny() end
---@param StatsName FName
---@param IntValue int32
function AMotorTownPlayerController:Cheat_StatsSetInt(StatsName, IntValue) end
function AMotorTownPlayerController:Cheat_Spectate() end
function AMotorTownPlayerController:Cheat_SpawnDumpWithSand() end
---@param Temp float
function AMotorTownPlayerController:Cheat_SetEngineCoolantTemp(Temp) end
---@param Temp float
function AMotorTownPlayerController:Cheat_SetBrakeTemp(Temp) end
function AMotorTownPlayerController:Cheat_ServerCrash() end
---@param Command FString
function AMotorTownPlayerController:Cheat_ServerCommand(Command) end
---@param VehicleId int32
function AMotorTownPlayerController:Cheat_SellVehicleById(VehicleId) end
function AMotorTownPlayerController:Cheat_SellVehicle() end
function AMotorTownPlayerController:Cheat_SellInvalidVehicles() end
function AMotorTownPlayerController:Cheat_SaveWorld() end
function AMotorTownPlayerController:Cheat_SaveGame() end
---@param SpeedMultiplier float
function AMotorTownPlayerController:Cheat_RunningSpeed(SpeedMultiplier) end
---@param DegreePerSecond float
function AMotorTownPlayerController:Cheat_Roll(DegreePerSecond) end
function AMotorTownPlayerController:Cheat_RewardDialog() end
function AMotorTownPlayerController:Cheat_RemoveBuildingAll() end
function AMotorTownPlayerController:Cheat_Rain() end
function AMotorTownPlayerController:Cheat_Ragdoll() end
---@param QuestKey FString
function AMotorTownPlayerController:Cheat_QuestRemove(QuestKey) end
function AMotorTownPlayerController:Cheat_QuestList() end
function AMotorTownPlayerController:Cheat_QuestClearInProgressList() end
function AMotorTownPlayerController:Cheat_QuestClearFinishedList() end
---@param QuestKey FString
function AMotorTownPlayerController:Cheat_QuestAdd(QuestKey) end
---@param SpeedKPH float
function AMotorTownPlayerController:Cheat_PushSide(SpeedKPH) end
---@param SpeedKPH float
function AMotorTownPlayerController:Cheat_Push(SpeedKPH) end
---@param Kilometer float
function AMotorTownPlayerController:Cheat_Odometer(Kilometer) end
function AMotorTownPlayerController:Cheat_ModalessDialog() end
function AMotorTownPlayerController:Cheat_LoanRemoveAll() end
function AMotorTownPlayerController:Cheat_Loan() end
function AMotorTownPlayerController:Cheat_LevelStreamingStopProfile() end
function AMotorTownPlayerController:Cheat_LevelStreamingStartProfile() end
---@param CourseKey FName
---@param Laptime float
---@param SpeedKPH float
function AMotorTownPlayerController:Cheat_Laptime(CourseKey, Laptime, SpeedKPH) end
function AMotorTownPlayerController:Cheat_HouseRemoveAll() end
function AMotorTownPlayerController:Cheat_FireVehicle() end
function AMotorTownPlayerController:Cheat_FireSpotAll() end
function AMotorTownPlayerController:Cheat_FireHere() end
function AMotorTownPlayerController:Cheat_FireClear() end
function AMotorTownPlayerController:Cheat_Event() end
---@param DroneKey FString
function AMotorTownPlayerController:Cheat_DroneSpawn(DroneKey) end
---@param Amount int32
---@param CargoKeySubString FString
function AMotorTownPlayerController:Cheat_DeliveryFillOutputStorageCargoKey(Amount, CargoKeySubString) end
---@param Amount int32
function AMotorTownPlayerController:Cheat_DeliveryFillOutputStorage(Amount) end
---@param Amount int32
---@param CargoKeySubString FString
function AMotorTownPlayerController:Cheat_DeliveryFillInputStorageCargoKey(Amount, CargoKeySubString) end
---@param Amount int32
function AMotorTownPlayerController:Cheat_DeliveryFillInputStorage(Amount) end
function AMotorTownPlayerController:Cheat_DeliveryClearStorage() end
function AMotorTownPlayerController:Cheat_DeliveryClear() end
---@param Day int32
function AMotorTownPlayerController:Cheat_Day(Day) end
---@param PartSlot int32
---@param Damage float
function AMotorTownPlayerController:Cheat_Damage(PartSlot, Damage) end
function AMotorTownPlayerController:Cheat_Crash() end
---@param CounterType int32
---@param Add int32
function AMotorTownPlayerController:Cheat_CounterAdd(CounterType, Add) end
function AMotorTownPlayerController:Cheat_CompanyRemoveAll() end
---@param Money int64
function AMotorTownPlayerController:Cheat_CompanyMoney(Money) end
function AMotorTownPlayerController:Cheat_CompanyDump() end
---@param NumBusStops int32
function AMotorTownPlayerController:Cheat_CompanyCreateDummyBusRoute(NumBusStops) end
function AMotorTownPlayerController:Cheat_CompanyCreateDummy() end
---@param Name FString
function AMotorTownPlayerController:Cheat_CompanyCreateCorporation(Name) end
---@param Name FString
function AMotorTownPlayerController:Cheat_CompanyCreate(Name) end
---@param Amount float
function AMotorTownPlayerController:Cheat_CompanyAddDepotStorage(Amount) end
function AMotorTownPlayerController:Cheat_ClearTopSpeed() end
function AMotorTownPlayerController:Cheat_ClearAICharacters() end
---@param Lines int32
---@param Characters int32
function AMotorTownPlayerController:Cheat_ChatRandom(Lines, Characters) end
function AMotorTownPlayerController:Cheat_BuildNavigation() end
function AMotorTownPlayerController:Cheat_BuildAll() end
function AMotorTownPlayerController:Cheat_AIVehiclesClear() end
function AMotorTownPlayerController:Cheat_Admin() end
---@param Amount float
function AMotorTownPlayerController:Cheat_AddWater(Amount) end
---@param VehicleKey FName
function AMotorTownPlayerController:Cheat_AddVehicle(VehicleKey) end
---@param Money int64
function AMotorTownPlayerController:Cheat_AddMoney(Money) end
---@param ItemKey FName
---@param NumItems int32
function AMotorTownPlayerController:Cheat_AddItem(ItemKey, NumItems) end
---@param Liter int32
function AMotorTownPlayerController:Cheat_AddFuel(Liter) end
---@param Type int32
---@param exp int64
function AMotorTownPlayerController:Cheat_AddExp(Type, exp) end
---@param Money int64
function AMotorTownPlayerController:Cheat_ActiveCompanyMoney(Money) end
function AMotorTownPlayerController:Cheat_AchievementsReset() end
---@param ArchievementName FName
---@param IntValue int32
function AMotorTownPlayerController:Cheat_AchievementSetInt(ArchievementName, IntValue) end
function AMotorTownPlayerController:Cheat_AchievementDump() end
function AMotorTownPlayerController:ApplyKeyMappings() end


---@class AMotorTownPlayerControllerBase : APlayerController
local AMotorTownPlayerControllerBase = {}

function AMotorTownPlayerControllerBase:StopLoadingScreen() end


---@class AMotorTownPlayerState : APlayerState
---@field GridIndex int32
---@field bIsHost boolean
---@field bIsAdmin boolean
---@field CharacterGuid FGuid
---@field BestLapTime float
---@field Levels TArray<int32>
---@field Character AMTCharacter
---@field OwnCompanyGuid FGuid
---@field JoinedCompanyGuid FGuid
---@field CustomDestinationAbsoluteLocation FVector
---@field OwnEventGuids TArray<FGuid>
---@field JoinedEventGuids TArray<FGuid>
---@field Location FVector
---@field VehicleKey FName
---@field Net_bAFK boolean
local AMotorTownPlayerState = {}



---@class AMotorTownRaceSection : AActor
---@field CourseName FName
---@field RaceSectionIndex int32
---@field bIsStopBox boolean
local AMotorTownRaceSection = {}

---@param Alpha float
function AMotorTownRaceSection:SetGateAlpha(Alpha) end
---@param bCheckered boolean
function AMotorTownRaceSection:SetCheckeredFlag(bCheckered) end
---@param bActive boolean
function AMotorTownRaceSection:SetActiveGate(bActive) end


---@class AMotorTownRoad : AActor
---@field RoadType EMTRoadType
---@field CourseKey FName
---@field LaneWidth float
---@field NumForwardLanes int32
---@field NumBackwardLanes int32
---@field bCopyFromLandscape boolean
---@field CopyFromLandscapeWidthMultiplier float
---@field RoadFlags int32
---@field SpeedLimitKPH float
---@field ExcludeConnectionRoads TArray<AMotorTownRoad>
---@field MaxRoadSideTowDistance float
---@field Spline USplineComponent
---@field SplineBounds FBox
local AMotorTownRoad = {}



---@class FAMTDriveSetting
local FAMTDriveSetting = {}


---@class FBrushState
---@field PrevDistortion FVector2D
---@field Distortion FVector2D
---@field DistortionVelocity FVector2D
---@field Temperature float
local FBrushState = {}



---@class FCargoRow : FTableRowBase
---@field bDepcreated boolean
---@field Name FText
---@field Name2 FMTTextByTexts
---@field CargoType EDeliveryCargoType
---@field CargoSpaceTypes TArray<EMTCargoSpaceType>
---@field VolumeSize float
---@field WeightRange FVector2D
---@field bAllowStacking boolean
---@field bUseDamage boolean
---@field Fragile float
---@field SpawnProbability int32
---@field NumCargoMin int32
---@field NumCargoMax int32
---@field PaymentPer1Km float
---@field PaymentPer1KmMultiplierByMaxWeight float
---@field PaymentSqrtRatio float
---@field PaymentSqrtRatioMinCapcity int32
---@field BasePayment int64
---@field MaxDamagePaymentMultiplier float
---@field DamageBonusMultiplier float
---@field ManualLoadingPayment int64
---@field ActorClass TSubclassOf<AMTCargo>
---@field DumpCargoSurfaceMesh UStaticMesh
---@field DumpCargoSurfaceMaterial UMaterialInterface
---@field DumpPileActorClass TSubclassOf<AMTDumpPileActor>
---@field CargoFlags int32
---@field GameplayTags FGameplayTagContainer
---@field MinDeliveryDistance float
---@field MaxDeliveryDistance float
---@field bTimer boolean
---@field BaseTimeSeconds float
---@field TimerBySpeedKPH float
---@field TimerByRoadSpeedLimitRatio float
---@field InTimeTipRange FVector2D
---@field bHoldingOffsetUsingItemBounds boolean
---@field Colors TArray<FMTVehicleColor>
local FCargoRow = {}



---@class FDeliverMissionAcceptResonse
---@field Code EDeliverMissionAcceptResponseCode
---@field AddCargoResult EAddCargoResult
local FDeliverMissionAcceptResonse = {}



---@class FGhostCarData
---@field VehicleActorClass TSubclassOf<AMTVehicle>
---@field Records TArray<FGhostCarRecord>
---@field LaptimeSeconds float
local FGhostCarData = {}



---@class FGhostCarRecord
---@field TimeSeconds float
---@field WorldLocation FVector
---@field Rotation FRotator
local FGhostCarRecord = {}



---@class FMHBrushTirePhysics
---@field Brushes TArray<FBrushState>
---@field ContactPatchLength float
---@field ContactPatchStaticLength float
local FMHBrushTirePhysics = {}



---@class FMHTirePhysics
---@field FrictionMu float
local FMHTirePhysics = {}



---@class FMHTransmissionGear
---@field GearRatio float
---@field Inertia float
---@field Name FString
local FMHTransmissionGear = {}



---@class FMHTransmissionProperty
---@field Type EMTTransmissionType
---@field ClutchType EMTTransmissionClutchType
---@field Gears TArray<FMHTransmissionGear>
---@field DefaultGearIndex int32
---@field ShiftTimeSeconds float
---@field AutoShiftComportRPM float
---@field TorqueConvertorStallRPM float
---@field TorqueConvertorStallRatioPower float
---@field TorqueConvertorTorqueRatio float
---@field TorqueConvertorTorqueRate float
---@field CVT_InputRPMRange FVector2D
---@field CVT_ClutchRPMRange FVector2D
---@field CVT_ClutchCurvePow float
---@field CVT_GearRatios FVector2D
---@field GearGrindingSound USoundBase
local FMHTransmissionProperty = {}



---@class FMTAICharacterSpawnConfigEntry
---@field ActorName FName
---@field ActorClass TSubclassOf<AMTCharacter>
---@field SpawnLocation EMTAICharacterSpawnLocation
---@field NumActors int32
---@field bScaleNumActorsByPlayerCount boolean
---@field NumMaxActors int32
---@field MaxPlayerDistance float
---@field bUseController boolean
---@field bUseMovementController boolean
---@field SpawnedActors TArray<AActor>
local FMTAICharacterSpawnConfigEntry = {}



---@class FMTAICharacterSpawnParams
---@field ActorClass TSubclassOf<AMTCharacter>
---@field BusPassengerParams FMTBusPassengerParams
local FMTAICharacterSpawnParams = {}



---@class FMTAIResidentPersonality
---@field Aggressive int32
local FMTAIResidentPersonality = {}



---@class FMTAIResidentRow : FTableRowBase
---@field Name FText
---@field CharacterClass TSubclassOf<AMTCharacter>
---@field SkeletalMesh USkeletalMesh
---@field Job FText
---@field Features TSet<EMTAIResidentFeature>
---@field HomePOIFlags int32
---@field WorkPOIFlags int32
---@field Personality FMTAIResidentPersonality
---@field VoiceLineData UMTVoiceLineDataAsset
local FMTAIResidentRow = {}



---@class FMTAIVehicleSpawnSetting
---@field SettingKey FName
---@field SpawnType EMTAIVehicleSpawnType
---@field VehicleClass TSubclassOf<AMTVehicle>
---@field VehicleKey FName
---@field VehicleTypes TArray<EMTVehicleType>
---@field GameplayTagQuery FGameplayTagQuery
---@field GameplayTagQuery2 FGameplayTagQuery
---@field bSpawnAIController boolean
---@field bIsTrafficVehicle boolean
---@field bSpawnRoadSide boolean
---@field bDespawnIfPlayersAreFar boolean
---@field bAllowCloseToPlayer boolean
---@field bAllowCloseToOtherVehicle boolean
---@field bDespawnIfNotMoveForLong boolean
---@field MaxLifetimeSeconds float
---@field MaxCount int32
---@field MinCount int32
---@field bUseNPCVehicleDensity boolean
---@field bUseNPCPoliceDensity boolean
---@field SpawnOverMinCountCoolDownTimeSeconds float
---@field CountMultiplierScheduleType EMTTimeOfDayScheduleType
---@field MinDistanceFromRoad float
---@field MaxDistanceFromRoad float
---@field MinDistanceFromLastSpawnLocation float
---@field bIncludeTrailer boolean
local FMTAIVehicleSpawnSetting = {}



---@class FMTActorCacheItem
---@field Actor AActor
local FMTActorCacheItem = {}



---@class FMTAdmin
---@field UniqueNetId FString
---@field Nickname FString
---@field bTransient boolean
local FMTAdmin = {}



---@class FMTAlwaysLoadedChildActor
---@field ChildActorClass TSubclassOf<AActor>
---@field Transform FTransform
---@field OwnerComponentName FString
---@field Actor AActor
local FMTAlwaysLoadedChildActor = {}



---@class FMTAntiRollBarParams
---@field Wheel0Name FName
---@field Wheel1Name FName
---@field SpringK float
---@field SpringD float
---@field Wheel0 UMHWheelComponent
---@field Wheel1 UMHWheelComponent
local FMTAntiRollBarParams = {}



---@class FMTAutoCrossModule
---@field Sections TArray<AMotorTownRaceSection>
---@field OverlappedRaceSection AMotorTownRaceSection
---@field OverlappedStopBox AMotorTownRaceSection
local FMTAutoCrossModule = {}



---@class FMTBalanceConfig
---@field Cargo FMTCargoBalanceConfig
---@field BusStop FMTBusStopBalanceConfig
local FMTBalanceConfig = {}



---@class FMTBalanceTable
---@field VehicleOwnerProfitShare TMap<EMTVehicleType, float>
---@field VehicleOwnerProfitSharePerCost float
---@field RentalCostMultiplier TMap<EMTVehicleType, float>
---@field TaxiPaymentPer100Meter float
---@field AmbulancePaymentPer100Meter float
---@field BusPayment float
---@field BusPaymentPer100Meter float
---@field MaxNonFixCargo int32
---@field JobIncomeToJobExpMultiplier float
---@field FuelCostPerLiter float
---@field FuelCostPerLiters TMap<EMTFuelType, float>
---@field SmallEngineFuelConsumption float
---@field MediumEngineFuelConsumption float
---@field LargeEngineFuelConsumption float
---@field RoadsideServiceRefuelingBaseCost int64
---@field RoadsideServiceRefuelingPercent float
---@field RoadsideServiceRefuelingCostMultiplier float
---@field RoadsideServiceTowToRoadCostPer1Km float
---@field BoxTrailerPaymentPer1Km float
---@field NavigatedTowRequestBasePayment float
---@field NavigatedTowRequestPaymentPer1Km float
---@field VehicleDeliveryBasePayment float
---@field VehicleDeliveryPaymentPer1Km float
---@field RescueRequestBasePayment float
---@field RescueRequestPaymentPer1Km float
---@field TowBasePaymentBonusSize FVector2D
---@field TowBasePaymentBonusMultiplier FVector2D
---@field TowDistPaymentBonusSize FVector2D
---@field TowDistPaymentBonusMultiplier FVector2D
---@field RescueBasePaymentBonusSize FVector2D
---@field RescueBasePaymentBonusMultiplier FVector2D
local FMTBalanceTable = {}



---@class FMTBannedPlayer
---@field UniqueNetId FString
---@field Nickname FString
---@field Reason FString
---@field UntilServerPlatformTimeSeconds double
---@field Server_UntilDateTime FString
local FMTBannedPlayer = {}



---@class FMTBuff
---@field BuffId int64
---@field BuffKey FName
---@field Effects TArray<EMTBuffEffectType>
---@field ExpiresAtTimeSeconds float
local FMTBuff = {}



---@class FMTBuffContainer
---@field Net_Buffs TArray<FMTBuff>
---@field BuffDataList TArray<FMTBuffData>
---@field Owner UObject
local FMTBuffContainer = {}



---@class FMTBuffData
---@field SoundComponent UAudioComponent
local FMTBuffData = {}



---@class FMTBuffRow : FTableRowBase
---@field Effects TArray<EMTBuffEffectType>
---@field DurationSeconds float
---@field Sound USoundBase
---@field bLoopSound boolean
---@field GameplayTags FGameplayTagContainer
---@field AddConditionQuery FGameplayTagQuery
local FMTBuffRow = {}



---@class FMTBuildingDepot
---@field RunningCostMultiplier float
---@field StorageMultiplier float
local FMTBuildingDepot = {}



---@class FMTBuildingItemInventory
---@field NumSlots int32
local FMTBuildingItemInventory = {}



---@class FMTBuildingMaterialNet
---@field MaterialKey FName
---@field Count int32
local FMTBuildingMaterialNet = {}



---@class FMTBuildingRow : FTableRowBase
---@field BuildingRowType EMTBuildingRowType
---@field Steps TArray<FMTBuildingStep>
---@field bIsCompanyVehicleDepot boolean
---@field Depot FMTBuildingDepot
---@field bValidateLocationByCollisionMesh boolean
---@field bUseXOffsetPlacing boolean
---@field bUseYOffsetPlacing boolean
---@field bUseZOffsetPlacing boolean
---@field PlacingOffset FVector
---@field ItemInventory FMTBuildingItemInventory
local FMTBuildingRow = {}



---@class FMTBuildingStep : FTableRowBase
---@field ActorClass TSubclassOf<AActor>
---@field Materials TMap<FName, int32>
---@field StaticMeshes TMap<FName, UStaticMesh>
---@field MeshScale FVector
---@field Material UMaterialInterface
---@field MaterialOverrides TArray<UMaterialInterface>
---@field ChildActorClass TSubclassOf<AActor>
local FMTBuildingStep = {}



---@class FMTBusPassengerParams
---@field Type EMTBusPassengerType
---@field ResidentId int32
---@field ExitAfterStops int32
---@field BusStop AMTBusStop
---@field DestinationPOI AMTPointOfInterest
---@field DestinationBusStop AMTBusStop
local FMTBusPassengerParams = {}



---@class FMTBusRoute
---@field Key FName
---@field DisplayName FText
---@field BusRouteFlags TSet<EMTBusRouteFlags>
---@field PaymentMultiplier float
---@field BusStops TArray<AMTBusStop>
local FMTBusRoute = {}



---@class FMTBusStopBalanceConfig
---@field PaymentMultipliers TMap<FGuid, float>
local FMTBusStopBalanceConfig = {}



---@class FMTCaptureTheFlagEventSetup
---@field ScoreToWin int32
---@field Route FMTCircleRoute
---@field Slowness float
local FMTCaptureTheFlagEventSetup = {}



---@class FMTCargoBalanceConfig
---@field PaymentMultipliers TMap<FName, float>
local FMTCargoBalanceConfig = {}



---@class FMTCargoDeliveryReward
---@field Vehicle AMTVehicle
local FMTCargoDeliveryReward = {}



---@class FMTCargoRepLocalMovement
---@field Location FVector
---@field Quat FQuat
---@field bIsValid boolean
local FMTCargoRepLocalMovement = {}



---@class FMTCargoSpawnerCargoConfig
---@field CargoKey FName
---@field SpawnCooltimeSecondsMin float
---@field SpawnCooltimeSecondsMax float
local FMTCargoSpawnerCargoConfig = {}



---@class FMTCharacterBodyPartRow : FTableRowBase
---@field BodyPartNameTexts FMTTextByTexts
---@field SkeletalMesh USkeletalMesh
---@field StaticMesh UStaticMesh
---@field AttachSocketName FName
---@field AttachSocketTransform FTransform
---@field bShowInCharacterCreationUI boolean
---@field Job EMTCharacterJob
---@field Slot EMTCharacterPartSlot
---@field bOverlapAllSlots boolean
---@field HeatDamageMultiplier float
---@field OverlapSlots TArray<EMTCharacterPartSlot>
local FMTCharacterBodyPartRow = {}



---@class FMTCharacterCustomization
---@field BodyKey FName
---@field BodyParts TArray<FMTCharacterPart>
---@field CostumeBodyKey FName
---@field CostumeItemKey FName
local FMTCharacterCustomization = {}



---@class FMTCharacterId
---@field UniqueNetId FString
---@field CharacterGuid FGuid
local FMTCharacterId = {}



---@class FMTCharacterInteractionTarget
---@field Interactables TArray<UMTInteractableComponent>
---@field ItemTargetActors TArray<AActor>
---@field ItemTargetComponents TArray<UPrimitiveComponent>
---@field VehiclePart UPrimitiveComponent
---@field VehiclePartInterface TScriptInterface<IMTVehiclePartComponent>
local FMTCharacterInteractionTarget = {}



---@class FMTCharacterLevel
---@field Levels TArray<int32>
---@field Experiences TArray<int32>
local FMTCharacterLevel = {}



---@class FMTCharacterLevelRuntime
---@field Levels TArray<int32>
---@field Experiences TArray<FMTShadowedInt64>
local FMTCharacterLevelRuntime = {}



---@class FMTCharacterPart
---@field Slot EMTCharacterPartSlot
---@field PartKey FName
local FMTCharacterPart = {}



---@class FMTCharacterParts
---@field Parts TArray<FMTCharacterPart>
---@field CostumeItemKey FName
local FMTCharacterParts = {}



---@class FMTCharacterPush
---@field Character AMTCharacter
---@field TargetActor AActor
---@field Direction FVector
local FMTCharacterPush = {}



---@class FMTCircleRoute
---@field RouteName FString
---@field Center FVector
---@field Radius float
local FMTCircleRoute = {}



---@class FMTCloudConfigParams
---@field SpawnRadius2D float
---@field SpawnHeightMin float
---@field SpawnHeightMax float
---@field SpeedMin float
---@field SpeedMax float
---@field CloudScaleMin float
---@field CloudScaleMax float
---@field CloudScaleUpRain float
---@field WindDirectionYaw float
---@field CloudCount int32
local FMTCloudConfigParams = {}



---@class FMTColorPaletteItem
---@field Color FColor
---@field Metallic float
---@field Roughness float
local FMTColorPaletteItem = {}



---@class FMTCompany
---@field Guid FGuid
---@field bDeactivated boolean
---@field bIsCorporation boolean
---@field Money FMTShadowedInt64
---@field Settings FMTCompanySettings
---@field OwnerCharacterId FMTCharacterId
---@field OwnerCharacterName FString
---@field AddedVehicleSlots int32
---@field Roles TArray<FMTCompanyPlayerRole>
---@field Players TArray<FMTCompanyPlayer>
---@field JoinRequests TArray<FMTCompanyJoinRequest>
---@field Vehicles TArray<FMTCompanyVehicle>
---@field OwnVehicles TArray<FMTPlayerDataVehicle>
---@field OwnVehicleWorldData TArray<FMTCompanyOwnVehicleWorldData>
---@field OwnVehicleParts TArray<FMTPlayerDataVehiclePart>
---@field BusRoutes TArray<FMTCompanyBusRoute>
---@field TruckRoutes TArray<FMTCompanyTruckRoute>
---@field MoneyTransactions TArray<FMTCompanyMoneyTransaction>
---@field ContractsInProgress TArray<FMTContractInProgress>
---@field OwnerPC AMotorTownPlayerController
---@field PendingRunningCost double
---@field BusProfitShareToApply int64
---@field TruckProfitShareToApply int64
---@field IdleDurationSeconds double
local FMTCompany = {}



---@class FMTCompanyBusRoute
---@field Guid FGuid
---@field RouteName FString
---@field Points TArray<FMTCompanyBusRoutePoint>
local FMTCompanyBusRoute = {}



---@class FMTCompanyBusRoutePoint
---@field PointGuid FGuid
---@field RouteFlags uint32
local FMTCompanyBusRoutePoint = {}



---@class FMTCompanyBusRouteV1
---@field Guid FGuid
---@field RouteName FString
---@field BusStops TArray<FGuid>
local FMTCompanyBusRouteV1 = {}



---@class FMTCompanyDepot
---@field BuildingGuid FGuid
---@field Name FString
---@field CompanyGuid FGuid
---@field bIsUnderConstruction boolean
---@field Storage float
---@field NumActiveVehicles int32
---@field RunningCostPer10Mins int32
---@field StorageMultiplier float
---@field Server_Building AMTBuilding
local FMTCompanyDepot = {}



---@class FMTCompanyDepotChangeRequest
---@field DepotName FString
local FMTCompanyDepotChangeRequest = {}



---@class FMTCompanyInfo
---@field Guid FGuid
---@field bDeactivated boolean
---@field bIsCorperation boolean
---@field OwnerCharacterId FMTCharacterId
---@field Settings FMTCompanySettings
---@field OwnerCharacterName FString
---@field NumPlayers int32
---@field NumVehicles int32
---@field NumBusRoutes int32
---@field IdleDurationSeconds double
local FMTCompanyInfo = {}



---@class FMTCompanyJoinRequest
---@field CharacterId FMTCharacterId
---@field CharacterName FString
local FMTCompanyJoinRequest = {}



---@class FMTCompanyMoneyTransaction
---@field Money int64
---@field TransactionType EMoneyTransactionType
---@field CharacterId FMTCharacterId
---@field PlayerName FString
---@field VehicleId int64
local FMTCompanyMoneyTransaction = {}



---@class FMTCompanyOwnVehicleWorldData
---@field VehicleId int64
---@field CargoSpaces TArray<FMTPlayerDataCargoSpace>
local FMTCompanyOwnVehicleWorldData = {}



---@class FMTCompanyPlayer
---@field CharacterId FMTCharacterId
---@field CharacterName FString
---@field RoleGuid FGuid
local FMTCompanyPlayer = {}



---@class FMTCompanyPlayerNet
---@field CharacterId FMTCharacterId
---@field CharacterName FString
---@field RoleGuid FGuid
local FMTCompanyPlayerNet = {}



---@class FMTCompanyPlayerRole
---@field RoleGuid FGuid
---@field Name FString
---@field bIsOwner boolean
---@field bIsDefaultRole boolean
---@field bIsManager boolean
local FMTCompanyPlayerRole = {}



---@class FMTCompanyReport
---@field CompanyGuid FGuid
---@field TotalVehicleStat FMTCompanyVehicleStatNet
---@field VehicleStats TArray<FMTCompanyVehicleStatNet>
local FMTCompanyReport = {}



---@class FMTCompanySettings
---@field Name FString
---@field ShortDesc FString
local FMTCompanySettings = {}



---@class FMTCompanyTruckRoute
---@field Guid FGuid
---@field RouteName FString
---@field DeliveryPoints TArray<FMTCompanyTruckRoutePoint>
local FMTCompanyTruckRoute = {}



---@class FMTCompanyTruckRoutePoint
---@field PointGuid FGuid
---@field RouteFlags uint32
local FMTCompanyTruckRoutePoint = {}



---@class FMTCompanyVehicle
---@field VehicleId int64
---@field DonatorVehicleId int64
---@field VehicleKey FName
---@field Setting FMTCompanyVehicleSetting
---@field RoutePointIndex int32
---@field TotalRunningCost int64
---@field TotalProfitShare int64
---@field DailyStats TArray<FMTCompanyVehicleStat>
---@field VehicleState EMTCompanyVehicleState
---@field ProblemText FText
---@field VehicleFlags uint32
---@field UserCharacterId FMTCharacterId
---@field LastUserCharacterId FMTCharacterId
---@field VehicleActor AMTVehicle
local FMTCompanyVehicle = {}



---@class FMTCompanyVehicleCargoStat
---@field CargoKey FName
---@field Payments float
---@field NumCargo int32
---@field Weights float
local FMTCompanyVehicleCargoStat = {}



---@class FMTCompanyVehicleSetting
---@field VehicleName FString
---@field RouteGuid FGuid
local FMTCompanyVehicleSetting = {}



---@class FMTCompanyVehicleStat
---@field TotalCost int64
---@field TotalIncome int64
---@field CargoStats TArray<FMTCompanyVehicleCargoStat>
local FMTCompanyVehicleStat = {}



---@class FMTCompanyVehicleStatNet
---@field VehicleId int64
---@field Stat FMTCompanyVehicleStat
local FMTCompanyVehicleStatNet = {}



---@class FMTConstraintCollisionLock
---@field CollisionComponentNames TArray<FName>
---@field bAnyCollision boolean
---@field UnlockDirection float
---@field CollisionComponents TArray<UPrimitiveComponent>
local FMTConstraintCollisionLock = {}



---@class FMTConstraintRangeConfig
---@field LinearLimitRange FVector2D
---@field TwistLimitDegrees FVector2D
---@field bAngularRotationOffset boolean
---@field AngularRotationOffsetStart FRotator
---@field AngularRotationOffsetEnd FRotator
local FMTConstraintRangeConfig = {}



---@class FMTConstraintRepBodyLocalMovement
---@field Location FVector
---@field Quat FQuat
---@field LocalVelocity FVector
---@field LocalAngleVel FVector
---@field bIsValid boolean
local FMTConstraintRepBodyLocalMovement = {}



---@class FMTContract
---@field ContractType EMTContractType
---@field Contractor FString
---@field Item FString
---@field Amount float
---@field DurationSeconds double
---@field Cost FMTShadowedInt64
---@field BonusPaymentRate float
---@field CompletionPayment FMTShadowedInt64
local FMTContract = {}



---@class FMTContractInProgress
---@field Guid FGuid
---@field Contract FMTContract
---@field TimeLeftSeconds double
---@field FinishedAmount float
local FMTContractInProgress = {}



---@class FMTControlPanelControl
---@field ControlName FText
---@field ControlType EMTControlPanelControlType
---@field InteractionType EMotorTownInteractableType
---@field ComponentName FName
---@field ComponentNames TArray<FName>
---@field ConstraintControl float
---@field DoorControl float
---@field KeyMapping int32
---@field Interactable UMTInteractableComponent
---@field Constraint UMTConstraintComponent
---@field Constraints TArray<UMTConstraintComponent>
---@field Door UMTVehicleDoorComponent
---@field WaterSpray UMTWaterSprayComponent
local FMTControlPanelControl = {}



---@class FMTControlSettingsPreset
---@field Guid FGuid
---@field Name FString
---@field DrivingController EMTDrivingController
---@field InputKeyMappings TArray<FMTInputKeyMapping>
---@field MouseSteering FMTMouseSteeringSettings
---@field ForceFeedback FMTForceFeedbackSettings
---@field Rumble FMTRumbleSettings
local FMTControlSettingsPreset = {}



---@class FMTCouponRow : FTableRowBase
---@field CouponType EMTCouponType
---@field ChargeMultiplier float
local FMTCouponRow = {}



---@class FMTCourseRow : FTableRowBase
---@field Name FText
---@field Name2 FMTTextByTexts
---@field bUseOffTrack boolean
---@field RacerXPPerLap int32
local FMTCourseRow = {}



---@class FMTCraneBoomParams
---@field ComponentName FName
---@field Length float
---@field PitchRangeInDegree FVector2D
local FMTCraneBoomParams = {}



---@class FMTDashboardGaugeConfig
---@field WidgetClass TSubclassOf<UGaugeWidget>
---@field WidgetDrawSize FVector2D
---@field NiddleMesh UStaticMesh
---@field NiddleMeshScale FVector
---@field MinValue float
---@field MaxValue float
---@field ValueScale float
---@field TextStep float
---@field LineStep float
---@field NiddleStartDegree float
---@field NiddleEndDegree float
---@field Text1ValueType EMTDashboardGaugeType
---@field Text1UpdatePeriodSeconds float
local FMTDashboardGaugeConfig = {}



---@class FMTDashboardMFDParams
---@field MFDType EMTDashboardMFDType
---@field MFDWidgetClass TSubclassOf<UDashboardMFDWidget>
---@field MFDTextureSize FVector2D
---@field MFDWidget UDashboardMFDWidget
---@field RenderTarget UTextureRenderTarget2D
local FMTDashboardMFDParams = {}



---@class FMTDealerVehicleSpawnPointData
---@field Location FVector
---@field VehicleParams TArray<FMTVehicleSpawnPointVehicleParams>
local FMTDealerVehicleSpawnPointData = {}



---@class FMTDecalRow : FTableRowBase
---@field Texture TSoftObjectPtr<UTexture2D>
---@field BrushMaterial UMaterialInterface
---@field Flags int32
---@field Cost int32
local FMTDecalRow = {}



---@class FMTDecalTargetMesh
---@field MeshComponent UMeshComponent
---@field Materials TArray<UMaterialInstanceDynamic>
---@field DecalRT UTextureRenderTarget2D
---@field StaticMesh UStaticMesh
local FMTDecalTargetMesh = {}



---@class FMTDediConfig
---@field ServerName FString
---@field Password FString
---@field ServerMessage FString
---@field MaxPlayers int32
---@field MaxVehiclePerPlayer int32
---@field bAllowPlayerToJoinWithCompanyVehicles boolean
---@field bAllowCompanyAIDriver boolean
---@field Admins TArray<FMTDediConfigAdmin>
---@field PoliceRolePlayers TArray<FMTDediConfigRolePlayer>
---@field bAllowPoliceVehicleByPlayerRole boolean
---@field bAllowCorporation boolean
---@field bAllowCorporationAIDriver boolean
---@field MaxHousingPlotRentalDays int32
---@field HousingPlotRentalPriceRatio float
---@field MaxHousingPlotRentalPerPlayer int32
---@field bAllowModdedVehicle boolean
---@field bEnableHostWebAPIServer boolean
---@field HostWebAPIServerPassword FString
---@field HostWebAPIServerPort int32
---@field Rain int32
---@field Fire int32
---@field NPCVehicleDensity float
---@field NPCPoliceDensity float
---@field bAllowAdminToRemoveAdmin boolean
---@field HostWebAPIDisabledCommands TArray<FString>
local FMTDediConfig = {}



---@class FMTDediConfigAdmin
---@field UniqueNetId FString
---@field Nickname FString
local FMTDediConfigAdmin = {}



---@class FMTDediConfigRolePlayer
---@field UniqueNetId FString
---@field Nickname FString
local FMTDediConfigRolePlayer = {}



---@class FMTDelivery
---@field ID int32
---@field CargoType EDeliveryCargoType
---@field CargoKey FName
---@field NumCargos int32
---@field ColorIndex int8
---@field Weight float
---@field SenderPoint AMTDeliveryPoint
---@field ReceiverPoint AMTDeliveryPoint
---@field RegisteredTimeSeconds float
---@field ExpiresAtServerTimeSeconds double
---@field PaymentMultiplierByDemand float
---@field PaymentMultiplierBySupply float
---@field PaymentMultiplierByBalanceConfig float
---@field Server_Cargos TArray<AMTCargo>
---@field DeliveryFlags uint32
---@field TimerSeconds float
---@field PathDistance float
---@field PathClimbHeight float
---@field PathSpeedKPH float
local FMTDelivery = {}



---@class FMTDeliveryCargoSpawnConfig
---@field Flags int32
---@field CargoKey FName
---@field MaxNum int32
---@field bUseSpawner boolean
---@field SpawnCooltimeSecondsMin float
---@field SpawnCooltimeSecondsMax float
local FMTDeliveryCargoSpawnConfig = {}



---@class FMTDeliveryDemandConfig
---@field CargoType EDeliveryCargoType
---@field CargoKey FName
---@field CargoGameplayTagQuery FGameplayTagQuery
---@field PaymentMultiplier float
---@field MaxStorage int32
local FMTDeliveryDemandConfig = {}



---@class FMTDeliveryOld
---@field CargoKey FName
---@field NumCargos int32
---@field SenderPoint AMTDeliveryPoint
---@field ReceiverPoint AMTDeliveryPoint
local FMTDeliveryOld = {}



---@class FMTDeliveryPassiveSupply
---@field CargoType EDeliveryCargoType
---@field CargoKey FName
---@field MinNumCargoPerDelivery int32
---@field MaxNumCargoPerDelivery int32
---@field MaxDeliveries int32
---@field Priority int32
local FMTDeliveryPassiveSupply = {}



---@class FMTDeliveryPointCargo
---@field CargoKey FName
---@field Destination AMTDeliveryPoint
---@field Amount int32
local FMTDeliveryPointCargo = {}



---@class FMTDeliveryPointInventory
---@field Entries TArray<FMTInventoryEntry>
local FMTDeliveryPointInventory = {}



---@class FMTDeliveryPointLimit
---@field DeliveryPointTagQuery FGameplayTagQuery
---@field CargoTagQuery FGameplayTagQuery
---@field bMustSameZone boolean
---@field bMustNotSameZone boolean
---@field LimitCount int32
local FMTDeliveryPointLimit = {}



---@class FMTDeliveryStorageConfig
---@field CargoType EDeliveryCargoType
---@field CargoKey FName
---@field MaxStorage int32
---@field MaxStorageRandomRange FVector2D
local FMTDeliveryStorageConfig = {}



---@class FMTDeliverySystemConfig
---@field CargoSpawns TArray<FMTDeliveryCargoSpawnConfig>
local FMTDeliverySystemConfig = {}



---@class FMTDialogueAction
---@field ActionText FText
---@field ActionType EMTDialogActionType
---@field StringParams1 TArray<FString>
---@field IntParams1 TArray<int32>
---@field FloatParams1 TArray<int32>
---@field ActorClassParams1 TArray<TSubclassOf<AActor>>
---@field InteractionType EMotorTownInteractableType
---@field NextDialogueKey FName
local FMTDialogueAction = {}



---@class FMTDialogueRow : FTableRowBase
---@field Message FText
---@field Actions TArray<FMTDialogueAction>
---@field MessageArguments TArray<EMTDialogueMessageArgumentType>
local FMTDialogueRow = {}



---@class FMTDragRaceRecord
---@field ReactionTimeSeconds double
---@field ElapsedTimeSeconds double
---@field SpeedAtFinish float
local FMTDragRaceRecord = {}



---@class FMTDroneNetHotData
---@field ThrustRatio float
---@field RateAccel100 FVector_NetQuantize100
local FMTDroneNetHotData = {}



---@class FMTDroneNetMovement
---@field Location FVector_NetQuantize100
---@field Rotation FQuat
---@field Velocity FVector_NetQuantize100
---@field AngVel FVector_NetQuantize100
---@field HotData FMTDroneNetHotData
local FMTDroneNetMovement = {}



---@class FMTDroneRow : FTableRowBase
---@field DroneName FMTTextByTexts
---@field ActorClass TSubclassOf<AMTDrone>
local FMTDroneRow = {}



---@class FMTDroneSetting
---@field MaxDistance double
---@field FlightTimeSeconds double
---@field MaxThrustG double
---@field MaxSpeedXY double
---@field MaxSpeedZ double
---@field MaxYawSpeed double
---@field MaxTiltDegree double
---@field MaxPropRPM double
---@field MaxHeight double
---@field ReturnDistance double
local FMTDroneSetting = {}



---@class FMTEngineColdState
---@field bOverHeated boolean
---@field bDisabled boolean
local FMTEngineColdState = {}



---@class FMTEngineHotState
---@field bStarterOn boolean
---@field bIgnitionOn boolean
---@field Throttle float
---@field CurrentRPM float
---@field CoolantTemp float
---@field RegenBrake int8
---@field JakeBrake int8
local FMTEngineHotState = {}



---@class FMTEngineProperty
---@field TorqueCurve UCurveFloat
---@field Inertia float
---@field StarterTorque float
---@field StarterRPM float
---@field MaxTorque float
---@field MaxRPM float
---@field FrictionCoulombCoeff float
---@field FrictionViscosityCoeff float
---@field IdleThrottle float
---@field FuelType EMTFuelType
---@field FuelConsumption float
---@field EngineType EMTEngineType
---@field HeatingPower float
---@field CoolingEfficiency float
---@field BlipThrottle float
---@field IntakeSpeedEfficency float
---@field BlipDurationSeconds float
---@field AfterFireProbability float
---@field MaxJakeBrakeStep int32
---@field MaxRegenStep int32
---@field MaxRegenTorqueRatio float
---@field MotorMaxPower float
---@field MotorMaxVoltage float
local FMTEngineProperty = {}



---@class FMTEvent
---@field EventName FString
---@field EventGuid FGuid
---@field EventType EMTEventType
---@field State EMTEventState
---@field bInCountdown boolean
---@field OwnerCharacterId FMTCharacterId
---@field Players TArray<FMTEventPlayer>
---@field RaceSetup FMTRaceEventSetup
---@field CaptureTheFlagSetup FMTCaptureTheFlagEventSetup
---@field CaptureTheFlag_FlagVehicle AMTVehicle
---@field CaptureTheFlag_ExcludedPlayersFromRandomFlag TArray<FMTCharacterId>
local FMTEvent = {}



---@class FMTEventPlayer
---@field CharacterId FMTCharacterId
---@field PlayerName FString
---@field PC AMotorTownPlayerController
---@field Rank int32
---@field SectionIndex int32
---@field Laps int32
---@field bDisqualified boolean
---@field bFinished boolean
---@field bWrongVehicle boolean
---@field bWrongEngine boolean
---@field LastSectionTotalTimeSeconds float
---@field LapTimes TArray<float>
---@field BestLapTime float
---@field bIsHoldingFlag boolean
---@field CaptureFlagScore int32
---@field Reward_RacingExp int32
---@field Reward_Money FMTShadowedInt64
local FMTEventPlayer = {}



---@class FMTExportPart
---@field Key FString
---@field Name FString
---@field PartType FString
local FMTExportPart = {}



---@class FMTExportParts
---@field Parts TArray<FMTExportPart>
local FMTExportParts = {}



---@class FMTExportVehicle
---@field Name FString
---@field VehicleName FString
---@field VehicleType FString
local FMTExportVehicle = {}



---@class FMTExportVehicles
---@field Vehicles TArray<FMTExportVehicle>
local FMTExportVehicles = {}



---@class FMTFireCell
---@field CellComponent UMTFireCellComponent
local FMTFireCell = {}



---@class FMTForceFeedbackSettings
---@field Strength float
---@field MinStrength float
---@field LowSpeedDamping float
local FMTForceFeedbackSettings = {}



---@class FMTFuelPumpSlot
---@field FuelType EMTFuelType
local FMTFuelPumpSlot = {}



---@class FMTFullScreenWidget
---@field Widget UUserWidget
---@field OKButtons TArray<UOKButtonWidget>
---@field CancelButtons TArray<UCancelButtonWidget>
---@field InputKeyMappedButtons TArray<UMTButtonWidget>
local FMTFullScreenWidget = {}



---@class FMTGSMarker
---@field MarkerActor AMTARMarker
local FMTGSMarker = {}



---@class FMTGameDB_BusStop
---@field Guid FString
---@field Name FString
local FMTGameDB_BusStop = {}



---@class FMTGameDB_BusStops
---@field BusStops TArray<FMTGameDB_BusStop>
local FMTGameDB_BusStops = {}



---@class FMTGameHotState
---@field ServerPlatformTimeSeconds double
---@field FPS uint8
---@field NumResidents int32
---@field BusTransportRate float
---@field TaxiTransportRate float
---@field FoodSupplyRate float
---@field PolicePatrolRate double
---@field GarbageCollectRate float
---@field ZoneStates TArray<FMTZoneState>
local FMTGameHotState = {}



---@class FMTGarageVehicleDecalExport
---@field Decal FMTVehicleDecal
local FMTGarageVehicleDecalExport = {}



---@class FMTGarageVehicleExport
---@field bHasPaint boolean
---@field Paint FMTGarageVehiclePaintExport
---@field bHasDecal boolean
---@field Decal FMTGarageVehicleDecalExport
---@field bHasParts boolean
---@field Parts FMTGarageVehiclePartsExport
local FMTGarageVehicleExport = {}



---@class FMTGarageVehiclePaintExport
---@field BodyMaterialIndex int32
---@field BodyColors TArray<FMTVehicleCustomizationColor>
local FMTGarageVehiclePaintExport = {}



---@class FMTGarageVehiclePartExport
---@field Key FName
---@field Slot EMTVehiclePartSlot
---@field FloatValues TMap<int32, float>
---@field Int64Values TMap<int32, int64>
---@field StringValues TMap<int32, FString>
---@field VectorValues TMap<int32, FVector>
local FMTGarageVehiclePartExport = {}



---@class FMTGarageVehiclePartsExport
---@field Parts TArray<FMTGarageVehiclePartExport>
local FMTGarageVehiclePartsExport = {}



---@class FMTGauge
---@field Niddle UStaticMeshComponent
---@field BackgroundRT UTextureRenderTarget2D
---@field Widget UGaugeWidget
local FMTGauge = {}



---@class FMTGaugeZone
---@field Name FName
---@field Start float
---@field StartPercent float
---@field End float
---@field EndPercent float
---@field Step float
---@field LineHeight float
---@field RadiusOffset float
---@field Color FColor
local FMTGaugeZone = {}



---@class FMTGetawayColdState
---@field GangCharacter AMTCharacter
---@field DestinationLocation FVector
---@field Payment int64
---@field bArrived boolean
---@field bIsJobActivated boolean
local FMTGetawayColdState = {}



---@class FMTGetawayHotState
local FMTGetawayHotState = {}


---@class FMTHUDWidgetParams
---@field bCollapseBelow boolean
---@field bGameModaless boolean
---@field bUseInteractionKeyForOKButton boolean
local FMTHUDWidgetParams = {}



---@class FMTHeightmapData
---@field GridSize double
---@field Origin FVector
---@field SizeX int32
---@field SizeY int32
---@field ScaleZ double
---@field ScaledHeightData TArray<uint16>
local FMTHeightmapData = {}



---@class FMTHelpRow : FTableRowBase
---@field Title FText
---@field Description FText
local FMTHelpRow = {}



---@class FMTHoldingItem
---@field QuickSlotIndex int32
---@field ItemKey FName
---@field Actor AActor
local FMTHoldingItem = {}



---@class FMTHouseRow : FTableRowBase
---@field Name FText
---@field Cost int64
---@field bAllowBuilding boolean
local FMTHouseRow = {}



---@class FMTInputKeyMapping
---@field InputName FName
---@field bIsAxis boolean
---@field Key FMTKey
---@field Options FMTInputMappingOptions
local FMTInputKeyMapping = {}



---@class FMTInputMappingOptions
---@field AxisScale float
---@field bBidirectional boolean
---@field bInvert boolean
---@field AxisMin float
---@field AxisMax float
---@field Linearity float
---@field CenterDeadZone float
local FMTInputMappingOptions = {}



---@class FMTInteractionParams
---@field InteractionType EMotorTownInteractableType
---@field CustomName FText
---@field bHideOnList boolean
local FMTInteractionParams = {}



---@class FMTInternetRadioStation
---@field Name FString
---@field URL FString
local FMTInternetRadioStation = {}



---@class FMTInternetRadioStations
---@field Stations TArray<FMTInternetRadioStation>
local FMTInternetRadioStations = {}



---@class FMTInventoryEntry
---@field CargoKey FName
---@field Amount int32
local FMTInventoryEntry = {}



---@class FMTItemInventory
---@field Slots TArray<FMTItemInventorySlot>
local FMTItemInventory = {}



---@class FMTItemInventorySlot
---@field Key FName
---@field NumStack int32
local FMTItemInventorySlot = {}



---@class FMTItemRow : FTableRowBase
---@field ItemName FText
---@field ItemNameAndNumber FMTNameAndNumber
---@field ItemNameTexts FMTTextByTexts
---@field IconTexture UTexture2D
---@field Cost int64
---@field bNotForSale boolean
---@field MaxStack int64
---@field ItemType EMTItemType
---@field GameplayTags FGameplayTagContainer
---@field HoldableActorClass TSubclassOf<AActor>
---@field DropActorClass TSubclassOf<AActor>
---@field AttachmentPartActorClass TSubclassOf<AActor>
---@field HoldableSocketName FName
---@field HoldableItemSocketName FName
---@field bHoldingOffsetUsingItemBounds boolean
---@field bUseHandIK boolean
---@field HandIKType EMTItemHandRIKType
---@field bUseCargoHoldingPose boolean
---@field InteractionType EMotorTownInteractableType
---@field InteractionTargetActorClasses TArray<TSubclassOf<AActor>>
---@field InteractionTargetComponentClasses TArray<TSubclassOf<UActorComponent>>
---@field InteractionTargetActorMax int32
---@field bTrashByInteraction boolean
---@field ItemFeatures TSet<EMTItemFeature>
---@field bIsPersistence boolean
---@field bDropable boolean
---@field bThrowable boolean
---@field bSpawnActorOnDrop boolean
---@field bHoldOnlyItem boolean
---@field bCrosshairMode boolean
---@field bCrosshairModeForInteraction boolean
---@field bCrosshairModeGroundTargeting boolean
---@field bCrosshairModeForDropping boolean
---@field bHideHoldingItemOnValidCrosshairTarget boolean
---@field bIsHeavy boolean
---@field BuildingKey FName
---@field DefaultHoldingRotation FRotator
---@field AttachmentRotationStep FRotator
---@field PickupSound USoundBase
---@field StaticMesh UStaticMesh
---@field StaticMeshScale FVector
---@field MassKg float
---@field Material UMaterialInterface
---@field Materials TArray<UMaterialInterface>
---@field CostumeBodyKey FName
---@field DroneKey FName
---@field LevelRequirementToBuy TMap<EMTCharacterLevelType, int32>
---@field CouponKey FName
---@field bUsingCouponInventory boolean
local FMTItemRow = {}



---@class FMTItemTagObject
---@field Tag FName
---@field Object UObject
local FMTItemTagObject = {}



---@class FMTJoystickKey
---@field DeviceID FName
---@field axisID int32
---@field buttonID int32
---@field DPadIndex int32
---@field DPadValue int32
local FMTJoystickKey = {}



---@class FMTKey
---@field Chord FInputChord
---@field JoystickKey FMTJoystickKey
local FMTKey = {}



---@class FMTLaptimeCourse
---@field Sections TArray<AMotorTownRaceSection>
---@field NumSections int32
local FMTLaptimeCourse = {}



---@class FMTLaptimeModule
---@field Courses TMap<FName, FMTLaptimeCourse>
---@field CourseRoad AMotorTownRoad
---@field OverlappedRaceSection AMotorTownRaceSection
local FMTLaptimeModule = {}



---@class FMTLightControlBlink
---@field Period float
---@field OnDuration float
---@field Offset float
local FMTLightControlBlink = {}



---@class FMTMap
---@field Key FName
---@field Name FText
---@field Level TSoftObjectPtr<UWorld>
---@field bDevWorld boolean
---@field bAvailableInDemo boolean
---@field WorldMap FMTWorldMap
local FMTMap = {}



---@class FMTMapIconParams
---@field ZOrder int32
---@field Alignment FVector2D
---@field IconType EMTMapIconType
---@field FilterTypes TArray<EMTMapFilterType>
---@field IconFlags int32
---@field IconWidgetClass TSubclassOf<UMapIconWidget>
---@field SubWidgetClass TSubclassOf<UUserWidget>
---@field ToolTipText FText
---@field bShowVehicleNameInTooltip boolean
---@field bAllowTeleport boolean
---@field MergeDistance float
---@field ActorClass TSubclassOf<AActor>
---@field GameplayTagQueryStatic FGameplayTagQuery
---@field GameplayTagQuery FGameplayTagQuery
---@field ActorTagsAny TSet<FName>
---@field MaxDistance float
---@field Actors TArray<AActor>
local FMTMapIconParams = {}



---@class FMTMapIconRow : FTableRowBase
---@field ZOrder int32
---@field Alignment FVector2D
---@field IconType EMTMapIconType
---@field FilterTypes TArray<EMTMapFilterType>
---@field IconFlags int32
---@field IconWidgetClass TSubclassOf<UMapIconWidget>
---@field SubWidgetClass TSubclassOf<UUserWidget>
---@field ToolTipText FText
---@field TooltipText_Disabled FText
---@field bShowVehicleNameInTooltip boolean
---@field bAllowTeleport boolean
---@field MergeDistance float
---@field ActorClass TSubclassOf<AActor>
---@field GameplayTagQueryStatic FGameplayTagQuery
---@field GameplayTagQuery FGameplayTagQuery
---@field ActorTagsAnyStatic TSet<FName>
---@field ActorTagsAny TSet<FName>
---@field MaxDistance float
---@field Actors TArray<AActor>
local FMTMapIconRow = {}



---@class FMTMouseSteeringSettings
---@field MouseSteeringSensitivity float
---@field MouseSteeringLinearity float
local FMTMouseSteeringSettings = {}



---@class FMTNameAndNumber
---@field Name FText
---@field Number int32
local FMTNameAndNumber = {}



---@class FMTNameTagState
local FMTNameTagState = {}


---@class FMTNavPointEdge
---@field NavPoint AMotorTownNavPoint
---@field EdgeFlags EMTGraphNodeEdgeFlags
local FMTNavPointEdge = {}



---@class FMTNetEngineHotState
---@field bStarterOn boolean
---@field bIgnitionOn boolean
---@field CurrentRPM float
---@field CoolantTemp uint8
---@field RegenBrake uint8
---@field JakeBrake uint8
local FMTNetEngineHotState = {}



---@class FMTNetFireCell : FFastArraySerializerItem
---@field CellCoord FIntVector
---@field RelativeLocation FVector_NetQuantize
---@field ThermalMass float
---@field Temperature uint16
---@field Fuel float
local FMTNetFireCell = {}



---@class FMTNetFireCellArray : FFastArraySerializer
---@field Cells TArray<FMTNetFireCell>
---@field OwningFire AMTFire
local FMTNetFireCellArray = {}



---@class FMTNetFireExtinguish
---@field FireActor AMTFire
---@field PlayerStates TArray<AMotorTownPlayerState>
---@field CellCoord FIntVector
---@field UsedWaterAmount float
---@field WaterTemperature float
local FMTNetFireExtinguish = {}



---@class FMTNetSeatKey
---@field Vehicle AMTVehicle
---@field SeatName FName
local FMTNetSeatKey = {}



---@class FMTNetTeleportPoint
---@field VehicleUniqueId uint32
---@field VehicleKey FName
---@field Location FVector
local FMTNetTeleportPoint = {}



---@class FMTNetTowRequest
---@field TowRequestUniqueId uint32
---@field Location FVector
---@field VehicleKey FName
---@field TrailerKeys TArray<FName>
---@field TowRequestWeight float
---@field VehicleFlags uint32
---@field PoliceTowingVehicleLastDriverCharacterGuid FGuid
---@field Server_TowRequestComp UMTTowRequestComponent
---@field Server_Vehicle AMTVehicle
local FMTNetTowRequest = {}



---@class FMTNetTransmissionColdState
---@field CurrentGear int8
local FMTNetTransmissionColdState = {}



---@class FMTNetVehicleCargo
---@field NumCargo int32
---@field CargoWeightKg float
---@field LoadedVolumes int32
---@field MaxVolumes int32
local FMTNetVehicleCargo = {}



---@class FMTNetVehicleSeat
---@field SeatName FName
---@field Character AMTCharacter
---@field bHasCharacter boolean
local FMTNetVehicleSeat = {}



---@class FMTNetWheelHotState
---@field BrakeTemperature int16
---@field BrakeCoreTemperature int16
---@field TireCoreTemperature int16
---@field TireBrushTemperature int16
local FMTNetWheelHotState = {}



---@class FMTOceanConfigParams
---@field OceanLevel float
local FMTOceanConfigParams = {}



---@class FMTParkedVehicleNet
---@field ParkingSpaceKey FName
---@field ParkedVehicleId int64
local FMTParkedVehicleNet = {}



---@class FMTParkingTicketTimer
---@field Vehicle AMTVehicle
---@field StartTimeSeconds double
---@field ParkingTicketComponent UMTParkingTicketComponent
local FMTParkingTicketTimer = {}



---@class FMTParty
---@field PartyId int32
---@field Players TArray<APlayerState>
local FMTParty = {}



---@class FMTPatrolArea
---@field PatrolAreaId int32
---@field ZoneKey FName
---@field Center FVector
---@field Radius float
---@field NumTotalPoints int32
---@field PointsToPatrol TArray<FMTPatrolPoint>
local FMTPatrolArea = {}



---@class FMTPatrolLocationActor
---@field InteractionActor AMTInteractionMeshActor
---@field Marker AMTARMarker
local FMTPatrolLocationActor = {}



---@class FMTPatrolPoint
---@field PatrolPointId int32
---@field Location FVector
---@field DisplayIndex int32
---@field BasePayment int32
---@field AreaBonusPayment int32
---@field RoadWidth float
local FMTPatrolPoint = {}



---@class FMTPendingFireExtinguish
---@field FireExtinguish FMTNetFireExtinguish
local FMTPendingFireExtinguish = {}



---@class FMTPhysicsConstraint : FMTPhysicsConstraintParams
---@field OriginalComp1 UPrimitiveComponent
---@field OriginalComp2 UPrimitiveComponent
local FMTPhysicsConstraint = {}



---@class FMTPhysicsConstraintParams
---@field OwnerObject UObject
---@field Comp1 UPrimitiveComponent
---@field Comp2 UPrimitiveComponent
local FMTPhysicsConstraintParams = {}



---@class FMTPhysicsExplosionDetector
local FMTPhysicsExplosionDetector = {}


---@class FMTPhysicsImpact
---@field Component UPrimitiveComponent
---@field RelativeLocation FVector
---@field Impulse FVector
local FMTPhysicsImpact = {}



---@class FMTPhysicsRope
---@field OwnerObject UObject
---@field Comp1 UPrimitiveComponent
---@field Comp2 UPrimitiveComponent
local FMTPhysicsRope = {}



---@class FMTPlayerDataBus
---@field RouteKey FString
---@field NextBusStopIndex int32
---@field LastBusStopGuid FGuid
---@field TimeLeftSecondsToNextStop float
local FMTPlayerDataBus = {}



---@class FMTPlayerDataBusPassenger
---@field Type EMTBusPassengerType
---@field ResidentIndex int32
---@field ExitAfterStops int32
---@field BusStopGuid FGuid
---@field DestinationPOIGuid FGuid
---@field DestinationBusStopGuid FGuid
local FMTPlayerDataBusPassenger = {}



---@class FMTPlayerDataCargo
---@field CargoSpaceIndex int32
---@field CargoKey FName
---@field SenderGuid FString
---@field DestinationGuid FString
---@field DestinationAbsoluteLocation FVector
---@field SenderAbsoluteLocation FVector
---@field Payment int64
---@field ScaledPayment int64
---@field LifeTimeSeconds float
---@field TimeLeftSeconds float
---@field bIsAttachedDummy boolean
---@field bIsEmptyContainer boolean
---@field bStrapped boolean
---@field OwnerName FString
---@field ColorIndex int32
---@field Weight float
---@field Damage float
---@field Flags uint32
---@field bLocationSaved boolean
---@field Location FVector
---@field Rotation FRotator
local FMTPlayerDataCargo = {}



---@class FMTPlayerDataCargoSpace
---@field CargoSpaceIndex int32
---@field LoadedItemType uint32
---@field LoadedItemVolume float
local FMTPlayerDataCargoSpace = {}



---@class FMTPlayerDataConstraint
---@field ConstraintName FString
---@field Position float
---@field ComponentTransform FTransform
local FMTPlayerDataConstraint = {}



---@class FMTPlayerDataGetaway
---@field bIsValid boolean
---@field CharacterResidentKey FName
---@field DestinationLocation FVector
---@field Payment int64
---@field bArrived boolean
---@field bIsJobActivated boolean
local FMTPlayerDataGetaway = {}



---@class FMTPlayerDataMapTopSpeed
---@field TopSpeedsKPH TMap<FName, float>
local FMTPlayerDataMapTopSpeed = {}



---@class FMTPlayerDataPassenger
---@field Characters TArray<FMTPlayerDataPassengerCharacter>
---@field PassengerType int32
---@field StartLocation FVector
---@field DestinationAbsoluteLocation FVector
---@field Payment int64
---@field PassengerRequirementFlags int32
---@field ComfortSatisfaction int32
---@field TimeLimitToDestinationFromStart float
---@field TimeLimitToDestination float
---@field TimeLimitPoint int32
---@field TimeLimitPointMax int32
---@field Bus FMTPlayerDataBusPassenger
---@field SearchAndRescueRadiusRatio float
local FMTPlayerDataPassenger = {}



---@class FMTPlayerDataPassengerCharacter
---@field ResidentKey FName
---@field SeatName FString
local FMTPlayerDataPassengerCharacter = {}



---@class FMTPlayerDataQuest
---@field QuestKey FName
---@field bSetAsDestination boolean
local FMTPlayerDataQuest = {}



---@class FMTPlayerDataTowRequest
---@field bIsValid boolean
---@field StartLocation FVector
---@field DestinationLocation FVector
---@field Payment int64
---@field TowRequestFlags int32
---@field bArrived boolean
---@field PunctureWheelSlotIndex int32
---@field MissingWheelSlotIndex int32
local FMTPlayerDataTowRequest = {}



---@class FMTPlayerDataVehicle
---@field ID int64
---@field Key FName
---@field VehicleName FString
---@field Condition float
---@field Fuel float
---@field Customization FMTVehicleCustomization
---@field Decal FMTVehicleDecal
---@field TraveledDistanceKm float
---@field SeatPosition FMTVehicleSeatPosition
---@field MirrorPositions FMTVehicleMirrorPositions
---@field OwnerSetting FMTVehicleOwnerSetting
---@field VehicleSettings TArray<FMTVehicleSetting>
---@field Doors TArray<FMTPlayerDataVehicleDoor>
---@field bIsModded boolean
---@field VehicleTags TArray<FName>
local FMTPlayerDataVehicle = {}



---@class FMTPlayerDataVehicleDoor
---@field DoorId int32
---@field ExtendedRange FVector2D
local FMTPlayerDataVehicleDoor = {}



---@class FMTPlayerDataVehiclePart
---@field ID int64
---@field Key FName
---@field Slot EMTVehiclePartSlot
---@field InstalledVehicleId int64
---@field Damage float
---@field FloatValues TArray<float>
---@field Int64Values TArray<int64>
---@field StringValues TArray<FString>
---@field VectorValues TArray<FVector>
---@field ItemInventory FMTItemInventory
local FMTPlayerDataVehiclePart = {}



---@class FMTPlayerDataWheelStrap
---@field WheelSlotIndex int32
---@field TargetComponentName FString
---@field TargetVehicleId int64
local FMTPlayerDataWheelStrap = {}



---@class FMTPlayerDataWorldAICharacter
---@field CharacterType EMTPlayerDataWorldCharacterType
---@field ActorName FName
---@field ResidentKey FName
---@field ResidentId int32
---@field AbsoluteLocation FVector
---@field Rotation FRotator
---@field DestinationLocation FVector
---@field BusPassenger FMTPlayerDataWorldAICharacterBusPassenger
local FMTPlayerDataWorldAICharacter = {}



---@class FMTPlayerDataWorldAICharacterBusPassenger
---@field Type EMTBusPassengerType
---@field ExitAfterStops int32
---@field BusStopName FName
---@field DestinationPOIGuid FGuid
---@field DestinationBusStopGuid FGuid
local FMTPlayerDataWorldAICharacterBusPassenger = {}



---@class FMTPlayerDataWorldAICharacters
---@field Residents TArray<FMTPlayerDataWorldResident>
---@field Characters TArray<FMTPlayerDataWorldAICharacter>
---@field SearchAndRescueLastLocations TArray<FVector>
local FMTPlayerDataWorldAICharacters = {}



---@class FMTPlayerDataWorldBuilding
---@field Guid FGuid
---@field BuildingKey FName
---@field HousingKey FName
---@field OwnerUniqueNetId FString
---@field OwnerCharacterGuid FGuid
---@field Location FVector
---@field Rotation FRotator
---@field BuildingStep int32
---@field Materials TMap<FName, int32>
---@field ItemInventory FMTItemInventory
local FMTPlayerDataWorldBuilding = {}



---@class FMTPlayerDataWorldDepot
---@field BuildingGuid FGuid
---@field Name FString
---@field Storage float
local FMTPlayerDataWorldDepot = {}



---@class FMTPlayerDataWorldFireSystem
---@field Fires TArray<FMTPlayerWorldDataFire>
---@field UntilNextRandomFireStartTimeSeconds double
local FMTPlayerDataWorldFireSystem = {}



---@class FMTPlayerDataWorldHousing
---@field HousingKey FName
---@field OwnerUniqueNetId FString
---@field OwnerCharacterGuid FGuid
---@field OwnerName FString
---@field RentLeftTimeSeconds double
local FMTPlayerDataWorldHousing = {}



---@class FMTPlayerDataWorldItem
---@field ItemGuid FGuid
---@field ItemKey FName
---@field OwnerCharacterGuid FGuid
---@field OwnerName FString
---@field Location FVector
---@field Rotation FRotator
---@field bHoldingByServerCharacter boolean
---@field bStrapped boolean
local FMTPlayerDataWorldItem = {}



---@class FMTPlayerDataWorldResident
---@field ResidentId int32
---@field ResidentKey FName
---@field ZoneKey FName
---@field HomePOIGuid FGuid
---@field WorkPOIGuid FGuid
---@field State int32
---@field CurrentPOIGuid FGuid
---@field CurrentBusStopGuid FGuid
---@field DestinationPOIGuid FGuid
---@field DestinationBusStopGuid FGuid
---@field StayUntilSeconds float
---@field bTransportNotAvailable boolean
local FMTPlayerDataWorldResident = {}



---@class FMTPlayerDataWorldVehicleCargoSpace
---@field CargoSpaceIndex int32
---@field LoadedItemType uint32
---@field LoadedItemVolume float
local FMTPlayerDataWorldVehicleCargoSpace = {}



---@class FMTPlayerDataWorldVehicleHook
---@field HookType EMTVehicleHookType
---@field HookSocketName FName
---@field HookLocation FVector
local FMTPlayerDataWorldVehicleHook = {}



---@class FMTPlayerNavigationDestination
---@field DestinationActor AActor
local FMTPlayerNavigationDestination = {}



---@class FMTPlayerWorldDataDoor
---@field DoorName FString
---@field DoorState int32
---@field Sliding float
---@field Angle float
---@field ExtendedRange FVector2D
local FMTPlayerWorldDataDoor = {}



---@class FMTPlayerWorldDataFire
---@field Location FVector
---@field InitialThermalMass float
---@field InitialFuel float
---@field InitialTemperature float
---@field bEnableSpreading boolean
---@field CellRadius float
---@field FireFlags uint32
---@field Payment uint64
---@field FireCells TArray<FMTPlayerWorldDataFireCell>
local FMTPlayerWorldDataFire = {}



---@class FMTPlayerWorldDataFireCell
---@field CellCoord FIntVector
---@field RelativeLocation FVector
---@field ThermalMass float
---@field Temperature float
---@field Fuel float
local FMTPlayerWorldDataFireCell = {}



---@class FMTPoliceColdState
---@field PatrolAreas TArray<FMTPatrolArea>
local FMTPoliceColdState = {}



---@class FMTPoliceSuspect
---@field Character AMTCharacter
---@field Marker AMTARMarker
---@field ViolationTags FGameplayTagContainer
---@field LastSeenLocation FVector
---@field bOutOfSight boolean
---@field SightedPCs TArray<AMotorTownPlayerController>
local FMTPoliceSuspect = {}



---@class FMTPoliceTowingNoPayment
---@field TowedVehicleDriverCharacterGuid FGuid
---@field NoPaymentUntilServerTimeSeconds double
local FMTPoliceTowingNoPayment = {}



---@class FMTProductionConfig
---@field InputCargos TMap<FName, int32>
---@field InputCargoTypes TMap<EDeliveryCargoType, int32>
---@field InputCargoGameplayTagQuery FGameplayTagQuery
---@field OutputCargos TMap<FName, int32>
---@field OutputCargoTypes TMap<EDeliveryCargoType, int32>
---@field OutputCargoRowGameplayTagQuery FGameplayTagQuery
---@field bStoreInputCargo boolean
---@field ProductionTimeSeconds float
---@field ProductionSpeedMultiplier float
---@field LocalFoodSupply float
---@field bHidden boolean
---@field TimeSinceLastProduction float
---@field ProductionFlags uint32
local FMTProductionConfig = {}



---@class FMTProgressBarGaugeColor
---@field PercentRange FVector2D
---@field BarColor FLinearColor
local FMTProgressBarGaugeColor = {}



---@class FMTQuest
---@field QuestName FText
---@field SuccessCondition FMTQuestConditionContainer
---@field NextQuestsOnSuccess TArray<FName>
local FMTQuest = {}



---@class FMTQuestCondition : FMTQuestConditionBase
---@field ConditionType EMTQuestConditionType
---@field VehicleKey FName
---@field VehicleKeys TArray<FName>
---@field CharacterLevelType EMTCharacterLevelType
---@field CharacterLevel int32
---@field DriveMode EMTDriveMode
---@field PlayerCounterType EMTPlayerCounterType
---@field SubClass1 UClass
---@field SubClass2 UClass
---@field GameplayTagQuery FGameplayTagQuery
---@field Int64Value0 int64
---@field Int64Value1 int64
local FMTQuestCondition = {}



---@class FMTQuestConditionBase
local FMTQuestConditionBase = {}


---@class FMTQuestConditionContainer : FMTQuestConditionBase
---@field AllConditions TArray<FMTQuestCondition>
---@field AnyConditions TArray<FMTQuestCondition>
local FMTQuestConditionContainer = {}



---@class FMTQuestRow : FTableRowBase
---@field Quest FMTQuest
---@field QuestDescription FText
---@field bShowDescPopupOnStart boolean
local FMTQuestRow = {}



---@class FMTRGConnection
---@field RGConnection UNetReplicationGraphConnection
---@field NetConnection UNetConnection
---@field Node UReplicationGraphNode_AlwaysRelevant_ForConnection
---@field WatchingActors TSet<AActor>
local FMTRGConnection = {}



---@class FMTRaceDriverState
---@field Name FString
---@field PlayerState APlayerState
---@field AIVehicle AMTVehicle
---@field Grid int32
---@field Position int32
---@field Laps int32
---@field LastSectionIndex int32
---@field LastSectionRaceTime float
local FMTRaceDriverState = {}



---@class FMTRaceEventSetup
---@field Route FMTRoute
---@field NumLaps int32
---@field VehicleKeys TArray<FName>
---@field EngineKeys TArray<FName>
---@field bEnableRoadSideTowingToGarage boolean
local FMTRaceEventSetup = {}



---@class FMTRaceGameMode
local FMTRaceGameMode = {}


---@class FMTRaceSetting
---@field NumLaps int32
---@field NumAIDrivers int32
---@field AIVehicleKeys TArray<FName>
local FMTRaceSetting = {}



---@class FMTRaceState
---@field Step EMTRaceStep
---@field Drivers TArray<FMTRaceDriverState>
local FMTRaceState = {}



---@class FMTReplicationGraphActorData
---@field Actor AActor
---@field RelevantConnections TArray<UNetConnection>
local FMTReplicationGraphActorData = {}



---@class FMTResident
---@field HomePOI AMTPointOfInterest
---@field WorkPOI AMTPointOfInterest
---@field Character AMTCharacter
---@field CurrentPOI AMTPointOfInterest
---@field CurrentBusStop AMTBusStop
---@field DestinationPOI AMTPointOfInterest
---@field DestinationBusStop AMTBusStop
local FMTResident = {}



---@class FMTResidentTownState
---@field ZoneStates TMap<FName, FMTResidentZoneState>
local FMTResidentTownState = {}



---@class FMTResidentZoneState
---@field POIs TArray<AMTPointOfInterest>
local FMTResidentZoneState = {}



---@class FMTReward
---@field bShowPopup boolean
---@field Context FString
---@field TransactionType EMoneyTransactionType
---@field Title FText
---@field RewardEntries TArray<FMTRewardEntry>
local FMTReward = {}



---@class FMTRewardEntry
---@field Name FText
---@field LogName FString
---@field Detail FText
---@field Money int64
---@field bShowMoney boolean
---@field ExpLevelType EMTCharacterLevelType
---@field exp int64
local FMTRewardEntry = {}



---@class FMTRoadGraphData
---@field Nodes TArray<FMTRoadGraphNode>
---@field Bounds FBox
local FMTRoadGraphData = {}



---@class FMTRoadGraphNode
---@field Road AMotorTownRoad
---@field Debug_NavPoints TArray<TWeakObjectPtr<AMotorTownNavPoint>>
---@field SplineDistance float
---@field AbsoluteLocation FVector
---@field Direction FVector
---@field RightVector FVector
---@field NodeIndex int32
---@field LateralDistance float
---@field LateralOffset float
---@field Lane int32
---@field SplinePointIndex int32
---@field Flags uint32
---@field AutoConnectDistance float
---@field Edges TArray<FMTRoadGraphNodeEdge>
---@field SpeedLimit float
---@field IslandId int32
---@field CrossroadId int32
local FMTRoadGraphNode = {}



---@class FMTRoadGraphNodeEdge
---@field NodeIndex int32
---@field Cost float
---@field Distance float
---@field Flags uint32
local FMTRoadGraphNodeEdge = {}



---@class FMTRoadSideObject
---@field ObjectActorClasses TArray<TSubclassOf<AActor>>
---@field StepDistance float
---@field SideDistance float
---@field StartOffset float
---@field EndOffset float
---@field HeightOffset float
---@field bRaycast boolean
---@field RaycastStartOffset float
---@field RaycastDistance float
---@field bStacking boolean
---@field LocalOffset FVector
---@field RandomScaleMin FVector
---@field RandomScaleMax FVector
---@field Rotation FRotator
---@field RandomRotation FRotator
---@field bMirrorRotateRightSide boolean
local FMTRoadSideObject = {}



---@class FMTRoadSideSegmentObjectActorParams
---@field ClassIndex int32
---@field Transform FTransform
local FMTRoadSideSegmentObjectActorParams = {}



---@class FMTRoadSideSegmentObjectActors
---@field Actors TArray<AActor>
---@field ActorParams TArray<FMTRoadSideSegmentObjectActorParams>
local FMTRoadSideSegmentObjectActors = {}



---@class FMTRoadSideSegmentObjects
---@field SegmentBounds FBox
---@field Objects TMap<FName, FMTRoadSideSegmentObjectActors>
local FMTRoadSideSegmentObjects = {}



---@class FMTRoadSignDirectionData
---@field NameKorean FString
---@field NameEnglish FString
---@field Direction EMTRoadSignDirection
local FMTRoadSignDirectionData = {}



---@class FMTRolePlayer
---@field UniqueNetId FString
---@field Nickname FString
local FMTRolePlayer = {}



---@class FMTRoute
---@field RouteName FString
---@field Waypoints TArray<FTransform>
local FMTRoute = {}



---@class FMTRumbleSettings
---@field EngineStrength float
---@field TireStrength float
local FMTRumbleSettings = {}



---@class FMTSaveGameCompany
---@field Guid FGuid
---@field bIsCorporation boolean
---@field Name FString
---@field ShortDesc FString
---@field Money int64
---@field OwnerCharacterId FMTCharacterId
---@field OwnerCharacterName FString
---@field AddedVehicleSlots int32
---@field Roles TArray<FMTSaveGameCompanyPlayerRole>
---@field Players TArray<FMTSaveGameCompanyPlayer>
---@field JoinRequests TArray<FMTSaveGameCompanyJoinRequest>
---@field Vehicles TArray<FMTSaveGameCompanyVehicle>
---@field OwnVehicles TArray<FMTSaveGameVehicle>
---@field OwnVehicleWorldData TArray<FMTSaveGameCompanyOwnVehicleWorldData>
---@field OwnVehicleParts TArray<FMTSaveGameVehiclePart>
---@field BusRoutes TArray<FMTSaveGameCompanyBusRoute>
---@field TruckRoutes TArray<FMTSaveGameCompanyTruckRoute>
---@field ContractsInProgress TArray<FMTSaveGameContractInProgress>
local FMTSaveGameCompany = {}



---@class FMTSaveGameCompanyBusRoute
---@field Guid FGuid
---@field RouteName FString
---@field BusStops TArray<FGuid>
---@field Points TArray<FMTSaveGameCompanyBusRoutePoint>
local FMTSaveGameCompanyBusRoute = {}



---@class FMTSaveGameCompanyBusRoutePoint
---@field PointGuid FGuid
---@field Flags uint32
local FMTSaveGameCompanyBusRoutePoint = {}



---@class FMTSaveGameCompanyJoinRequest
---@field CharacterId FMTCharacterId
---@field CharacterName FString
local FMTSaveGameCompanyJoinRequest = {}



---@class FMTSaveGameCompanyOwnVehicleWorldData
---@field VehicleId int64
---@field CargoSpaces TArray<FMTPlayerDataWorldVehicleCargoSpace>
local FMTSaveGameCompanyOwnVehicleWorldData = {}



---@class FMTSaveGameCompanyPlayer
---@field CharacterId FMTCharacterId
---@field CharacterName FString
---@field RoleGuid FGuid
local FMTSaveGameCompanyPlayer = {}



---@class FMTSaveGameCompanyPlayerRole
---@field RoleGuid FGuid
---@field Name FString
---@field bIsOwner boolean
---@field bIsDefaultRole boolean
---@field bIsManager boolean
local FMTSaveGameCompanyPlayerRole = {}



---@class FMTSaveGameCompanyTruckRoute
---@field Guid FGuid
---@field RouteName FString
---@field DeliveryPoints TArray<FMTSaveGameCompanyTruckRoutePoint>
local FMTSaveGameCompanyTruckRoute = {}



---@class FMTSaveGameCompanyTruckRoutePoint
---@field DeliveryPointGuid FGuid
---@field Flags uint32
local FMTSaveGameCompanyTruckRoutePoint = {}



---@class FMTSaveGameCompanyVehicle
---@field VehicleId int64
---@field DonatorVehicleId int64
---@field VehicleKey FName
---@field VehicleName FString
---@field BusRouteGuid FGuid
---@field RoutePointIndex int32
---@field VehicleFlags uint32
local FMTSaveGameCompanyVehicle = {}



---@class FMTSaveGameContract
---@field ContractType EMTContractType
---@field Contractor FString
---@field Item FString
---@field Amount float
---@field DurationSeconds double
---@field Cost int64
---@field BonusPaymentRate float
---@field CompletionPayment int64
local FMTSaveGameContract = {}



---@class FMTSaveGameContractInProgress
---@field Guid FGuid
---@field Contract FMTSaveGameContract
---@field TimeLeftSeconds double
---@field FinishedAmount float
local FMTSaveGameContractInProgress = {}



---@class FMTSaveGameHouse
---@field Key FName
local FMTSaveGameHouse = {}



---@class FMTSaveGameItem
---@field Key FName
---@field NumStack int32
local FMTSaveGameItem = {}



---@class FMTSaveGameItemInventory
---@field Items TArray<FMTSaveGameItem>
local FMTSaveGameItemInventory = {}



---@class FMTSaveGameParkingSpace
---@field ParkedVehicleId int64
---@field BuildingGuid FString
local FMTSaveGameParkingSpace = {}



---@class FMTSaveGamePlayer
---@field Slot int32
---@field Guid FString
---@field Nickname FString
---@field PlaytimeSeconds double
---@field bIsCheater boolean
---@field Locations TMap<FName, FVector>
---@field Level FMTCharacterLevel
---@field Customization FMTCharacterCustomization
---@field Counter FMTSaveGamePlayerCounter
---@field HelpMessageCounter FMTSaveGamePlayerHelpMessageCounter
---@field Money int64
---@field LastVehicleId int64
---@field Vehicles TArray<FMTSaveGameVehicle>
---@field VehicleParts TArray<FMTSaveGameVehiclePart>
---@field Houses TArray<FMTSaveGameHouse>
---@field Items TArray<FMTSaveGameItem>
---@field ItemInventory FMTSaveGameItemInventory
---@field CouponInventory FMTSaveGameItemInventory
---@field QuickbarSlots TArray<FMTSaveGameQuickbarSlot>
---@field VehicleTopSpeedsKPH TMap<FName, FMTPlayerDataMapTopSpeed>
---@field Quests TArray<FMTPlayerDataQuest>
---@field FinishedQuestKeys TArray<FName>
---@field Companies TArray<FMTSaveGameCompany>
---@field Loans TArray<FMTSavedGamePlayerLoan>
local FMTSaveGamePlayer = {}



---@class FMTSaveGamePlayerCounter
---@field Counters TMap<FString, int32>
local FMTSaveGamePlayerCounter = {}



---@class FMTSaveGamePlayerHelpMessageCounter
---@field Counters TMap<FString, int32>
local FMTSaveGamePlayerHelpMessageCounter = {}



---@class FMTSaveGameQuickbarSlot
---@field ItemKey FName
local FMTSaveGameQuickbarSlot = {}



---@class FMTSaveGameVehicle
---@field ID int64
---@field Key FName
---@field VehicleName FString
---@field Fuel float
---@field Condition float
---@field Settings FMTSaveGameVehicleSetting
---@field SeatPosition FMTVehicleSeatPosition
---@field MirrorPositions FMTSaveGameVehicleMirrors
---@field Customization FMTSaveGameVehicleCustomization
---@field Decal FMTSaveGameVehicleDecal
---@field Doors TArray<FMTSaveGameVehicleDoor>
---@field TraveledDistanceKm float
---@field LastUsedPlayTimeSeconds double
---@field bIsModded boolean
---@field VehicleTags TArray<FName>
local FMTSaveGameVehicle = {}



---@class FMTSaveGameVehicleCustomization
---@field BodyMaterialIndex int32
---@field BodyColors TArray<FMTSaveGameVehicleCustomizationColor>
local FMTSaveGameVehicleCustomization = {}



---@class FMTSaveGameVehicleCustomizationColor
---@field MaterialSlotName FName
---@field Color FColor
---@field Metallic float
---@field Roughness float
local FMTSaveGameVehicleCustomizationColor = {}



---@class FMTSaveGameVehicleDecal
---@field DecalLayers TArray<FMTSaveGameVehicleDecalLayer>
local FMTSaveGameVehicleDecal = {}



---@class FMTSaveGameVehicleDecalLayer
---@field DecalKey FName
---@field Color FColor
---@field Position FVector2D
---@field Rotation FRotator
---@field DecalScale float
---@field Stretch float
---@field Coverage float
---@field Flags uint32
local FMTSaveGameVehicleDecalLayer = {}



---@class FMTSaveGameVehicleDoor
---@field DoorId int32
---@field ExtendedRange FVector2D
local FMTSaveGameVehicleDoor = {}



---@class FMTSaveGameVehicleMirror
---@field Name FName
---@field Rotation FRotator
---@field CurvatureMultiplier float
local FMTSaveGameVehicleMirror = {}



---@class FMTSaveGameVehicleMirrors
---@field MirrorPositions TArray<FMTSaveGameVehicleMirror>
local FMTSaveGameVehicleMirrors = {}



---@class FMTSaveGameVehiclePart
---@field ID int64
---@field Key FName
---@field InstalledVehicleId int64
---@field Damage float
---@field FloatValues TArray<float>
---@field Int64Values TArray<int64>
---@field StringValues TArray<FString>
---@field VectorValues TArray<FVector>
---@field Slot FString
---@field ItemInventory FMTSaveGameItemInventory
local FMTSaveGameVehiclePart = {}



---@class FMTSaveGameVehicleSetting
---@field bLocked boolean
---@field DriveAllowedPlayers EMTVehicleDriveAllowedPlayers
---@field LevelRequirementsToDrive TArray<int32>
---@field VehicleOwnerProfitShare float
---@field VehicleSettings TArray<FMTSaveGameVehicleSettingItem>
local FMTSaveGameVehicleSetting = {}



---@class FMTSaveGameVehicleSettingItem
---@field SettingType FString
---@field SettingValue FString
local FMTSaveGameVehicleSettingItem = {}



---@class FMTSaveGameWorld
---@field WorldGuid FString
---@field WorldKey FName
---@field Day int32
---@field TimeOfDay float
---@field TownState FMTSaveGameWorldTownState
---@field Character FMTSaveGameWorldCharacter
---@field AICharacters2 FMTSaveGameWorldAICharacters
---@field AIVehicles FMTSaveGameWorldAIVehicles
---@field CargoSpawners TArray<FMTSaveGameWorldCargoSpawner>
---@field DeliveryPoints TArray<FMTSaveGameWorldDeliveryPoint>
---@field Deliveries TArray<FMTSaveGameWorldDelivery>
---@field ParkingSpaces TMap<FName, FMTSaveGameParkingSpace>
---@field Vehicles TMap<int64, FMTSaveGameWorldVehicle>
---@field NotInWorldVehicleIds TArray<int64>
---@field Housings TMap<FName, FMTSaveGameWorldHousing>
---@field Buildings TArray<FMTSaveGameWorldBuilding>
---@field Depots TArray<FMTSaveWorldCompanyDepot>
---@field Items TArray<FMTSaveGameWorldItem>
---@field Police FMTSaveGameWorldPolice
---@field Fire FMTSaveGameWorldFireSystem
---@field Navigation FMTSaveGameWorldNavigation
local FMTSaveGameWorld = {}



---@class FMTSaveGameWorldAICharacter
---@field CharacterType FString
---@field ActorName FName
---@field ResidentKey FName
---@field ResidentId int32
---@field AbsoluteLocation FVector
---@field Rotation FRotator
---@field DestinationLocation FVector
---@field BusPassenger FMTSaveGameWorldAICharacterBusPassenger
local FMTSaveGameWorldAICharacter = {}



---@class FMTSaveGameWorldAICharacterBusPassenger
---@field Type FString
---@field ExitAfterStops int32
---@field BusStopName FName
---@field DestinationPOIGuid FString
---@field DestinationBusStopGuid FString
local FMTSaveGameWorldAICharacterBusPassenger = {}



---@class FMTSaveGameWorldAICharacters
---@field Residents TArray<FMTSaveGameWorldResident>
---@field Characters TArray<FMTSaveGameWorldAICharacter>
---@field SearchAndRescueLastLocations TArray<FVector>
local FMTSaveGameWorldAICharacters = {}



---@class FMTSaveGameWorldAIVehicle
---@field Index int32
---@field TractorIndex int32
---@field SettingKey FName
---@field AbsoluteLocation FVector
---@field Rotation FRotator
---@field Customization FMTVehicleCustomization
---@field TowRequest FMTPlayerDataTowRequest
---@field VehicleKey FName
---@field AgeSeconds float
---@field FireData FMTSaveGameWorldFire
local FMTSaveGameWorldAIVehicle = {}



---@class FMTSaveGameWorldAIVehicles
---@field Vehicles TArray<FMTSaveGameWorldAIVehicle>
local FMTSaveGameWorldAIVehicles = {}



---@class FMTSaveGameWorldBuilding
---@field Guid FString
---@field BuildingKey FName
---@field HousingKey FName
---@field OwnerUniqueNetId FString
---@field OwnerCharacterGuid FString
---@field BuildingStep int32
---@field Location FVector
---@field Rotation FRotator
---@field Materials TMap<FName, int32>
---@field ItemInventory FMTSaveGameItemInventory
local FMTSaveGameWorldBuilding = {}



---@class FMTSaveGameWorldBusPassenger
---@field Type FString
---@field ResidentIndex int32
---@field ExitAfterStops int32
---@field BusStopGuid FString
---@field DestinationPOIGuid FString
---@field DestinationBusStopGuid FString
local FMTSaveGameWorldBusPassenger = {}



---@class FMTSaveGameWorldCargoSpawner
---@field SpawnerGuid FString
---@field bHasCargo boolean
---@field TimeToSpawnSeconds float
local FMTSaveGameWorldCargoSpawner = {}



---@class FMTSaveGameWorldCharacter
---@field AbsoluteLocation FVector
---@field Rotation FRotator
---@field SeatedVehicleId int64
---@field SeatIndex int32
---@field LastSeatedVehicleId int64
---@field SeatName FString
---@field HoldingItemKey FName
local FMTSaveGameWorldCharacter = {}



---@class FMTSaveGameWorldDelivery
---@field ID int32
---@field CargoType EDeliveryCargoType
---@field CargoKey FName
---@field NumCargos int32
---@field ColorIndex int32
---@field Weight float
---@field SenderPointGuid FString
---@field ReceiverPointGuid FString
---@field TimeUntilExpiresSeconds float
---@field Payment int64
---@field DeliveryFlags uint32
local FMTSaveGameWorldDelivery = {}



---@class FMTSaveGameWorldDeliveryPoint
---@field DeliveryPointGuid FString
---@field InputInventory FMTSaveGameWorldDeliveryPointInventory
---@field OutputInventory FMTSaveGameWorldDeliveryPointInventory
---@field ProductionProgresses TArray<float>
local FMTSaveGameWorldDeliveryPoint = {}



---@class FMTSaveGameWorldDeliveryPointInventory
---@field Entries TArray<FMTSaveGameWorldDeliveryPointInventoryEntry>
local FMTSaveGameWorldDeliveryPointInventory = {}



---@class FMTSaveGameWorldDeliveryPointInventoryEntry
---@field CargoKey FName
---@field Amount int32
local FMTSaveGameWorldDeliveryPointInventoryEntry = {}



---@class FMTSaveGameWorldFire
---@field Location FVector
---@field InitialThermalMass float
---@field InitialFuel float
---@field InitialTemperature float
---@field bEnableSpreading boolean
---@field CellRadius float
---@field FireFlags uint32
---@field Payment uint64
---@field FireCells TArray<FMTSaveGameWorldFireCell>
local FMTSaveGameWorldFire = {}



---@class FMTSaveGameWorldFireCell
---@field CellCoord FIntVector
---@field RelativeLocation FVector
---@field ThermalMass float
---@field Temperature float
---@field Fuel float
local FMTSaveGameWorldFireCell = {}



---@class FMTSaveGameWorldFireSystem
---@field Fires TArray<FMTSaveGameWorldFire>
---@field UntilNextRandomFireStartTimeSeconds double
local FMTSaveGameWorldFireSystem = {}



---@class FMTSaveGameWorldHousing
---@field HousingKey FName
---@field OwnerUniqueNetId FString
---@field OwnerCharacterGuid FString
---@field OwnerName FString
---@field RentLeftTimeSeconds double
local FMTSaveGameWorldHousing = {}



---@class FMTSaveGameWorldItem
---@field ItemGuid FString
---@field ItemKey FName
---@field OwnerCharacterGuid FString
---@field OwnerName FString
---@field Location FVector
---@field Rotation FRotator
---@field bHoldingByServerCharacter boolean
---@field bStrapped boolean
local FMTSaveGameWorldItem = {}



---@class FMTSaveGameWorldNavigation
---@field CustomDestinations TArray<FMTSaveGameWorldNavigationDestination>
local FMTSaveGameWorldNavigation = {}



---@class FMTSaveGameWorldNavigationDestination
---@field Location FVector
---@field bAutoAdjustLandscapeHeight boolean
local FMTSaveGameWorldNavigationDestination = {}



---@class FMTSaveGameWorldPassenger
---@field Characters TArray<FMTSaveGameWorldPassengerCharacter>
---@field PassengerType int32
---@field DestinationAbsoluteLocation FVector
---@field Payment int64
---@field PassengerRequirementFlags int32
---@field ComfortSatisfaction int32
---@field TimeLimitToDestinationFromStart float
---@field TimeLimitToDestination float
---@field TimeLimitPoint int32
---@field TimeLimitPointMax int32
---@field Bus FMTSaveGameWorldBusPassenger
local FMTSaveGameWorldPassenger = {}



---@class FMTSaveGameWorldPassengerCharacter
---@field ResidentKey FName
---@field SeatName FString
local FMTSaveGameWorldPassengerCharacter = {}



---@class FMTSaveGameWorldPolice
---@field PatrolAreas TArray<FMTSaveGameWorldPolicePatrolArea>
local FMTSaveGameWorldPolice = {}



---@class FMTSaveGameWorldPolicePatrolArea
---@field AreaCenter FVector
---@field AreaRadius float
---@field NumTotalPoints int32
---@field PointsToPatrol TArray<FVector>
---@field ContributionCountMap TMap<FMTCharacterId, int32>
local FMTSaveGameWorldPolicePatrolArea = {}



---@class FMTSaveGameWorldResident
---@field ResidentId int32
---@field ResidentKey FName
---@field ZoneKey FName
---@field HomePOIGuid FString
---@field WorkPOIGuid FString
---@field State int32
---@field CurrentPOIGuid FString
---@field CurrentBusStopGuid FString
---@field DestinationPOIGuid FString
---@field DestinationBusStopGuid FString
---@field StayUntilSeconds float
---@field bTransportNotAvailable boolean
local FMTSaveGameWorldResident = {}



---@class FMTSaveGameWorldTownState
---@field ZoneStates TMap<FName, FMTSaveGameWorldZoneState>
local FMTSaveGameWorldTownState = {}



---@class FMTSaveGameWorldVehicle
---@field Version int32
---@field AbsoluteLocation FVector
---@field Rotation FRotator
---@field Parts TArray<FMTSaveGameWorldVehiclePart>
---@field Customization FMTVehicleCustomization
---@field Doors TArray<FMTPlayerWorldDataDoor>
---@field Constraints TArray<FMTSaveGameWorldVehicleConstraint>
---@field Passengers TArray<FMTSaveGameWorldPassenger>
---@field CargoSpaces TArray<FMTPlayerDataWorldVehicleCargoSpace>
---@field Cargos TArray<FMTPlayerDataCargo>
---@field Bus FMTPlayerDataBus
---@field TowRequest FMTPlayerDataTowRequest
---@field Getaway FMTSaveGameWorldVehicleGetaway
---@field Rent FMTSaveGameWorldVehicleRent
---@field WheelStraps TArray<FMTSaveGameWorldVehicleWheelStrap>
---@field VehicleKey FName
---@field bForSale boolean
---@field Fuel float
---@field Condition float
---@field OdoMeterKm float
---@field ToggleFunctions TArray<FString>
---@field TurnSignal FString
---@field HeadLightMode FString
---@field SirenIndex int32
---@field LastLocationsInRoad TArray<FMTVecRot>
---@field bHaveTractor boolean
---@field TractorVehicleId uint64
---@field TractorHookParams FMTPlayerDataWorldVehicleHook
---@field TrailerHookParams FMTPlayerDataWorldVehicleHook
---@field bHaveCarrier boolean
---@field CarrierVehicleId int64
---@field Flags uint32
local FMTSaveGameWorldVehicle = {}



---@class FMTSaveGameWorldVehicleConstraint
---@field ConstraintName FString
---@field Position float
---@field ComponentTransform FTransform
local FMTSaveGameWorldVehicleConstraint = {}



---@class FMTSaveGameWorldVehicleGetaway
---@field bIsValid boolean
---@field CharacterResidentKey FName
---@field DestinationLocation FVector
---@field Payment int64
---@field bArrived boolean
---@field bIsJobActivated boolean
local FMTSaveGameWorldVehicleGetaway = {}



---@class FMTSaveGameWorldVehiclePart
---@field ID int64
---@field Key FName
---@field Slot FString
---@field Damage float
---@field FloatValues TArray<float>
---@field Int64Values TArray<int64>
---@field StringValues TArray<FString>
---@field VectorValues TArray<FVector>
---@field ItemInventory FMTSaveGameItemInventory
local FMTSaveGameWorldVehiclePart = {}



---@class FMTSaveGameWorldVehicleRent
---@field bIsValid boolean
---@field RenterPlayerGuid FString
---@field PaymentPeriodSeconds float
---@field Cost int64
---@field RentalTimeLeftSeconds float
local FMTSaveGameWorldVehicleRent = {}



---@class FMTSaveGameWorldVehicleWheelStrap
---@field WheelSlotIndex int32
---@field TargetComponentName FString
---@field TargetVehicleId int64
local FMTSaveGameWorldVehicleWheelStrap = {}



---@class FMTSaveGameWorldZoneState
---@field TaxiTransportRate float
---@field PolicePatrolRate float
---@field GarbageCollectRate float
local FMTSaveGameWorldZoneState = {}



---@class FMTSaveWorldCompanyDepot
---@field BuildingGuid FGuid
---@field Name FString
---@field Storage float
local FMTSaveWorldCompanyDepot = {}



---@class FMTSavedGame
---@field DateTimeTicks int64
---@field Player FMTSaveGamePlayer
---@field Version int32
local FMTSavedGame = {}



---@class FMTSavedGamePlayerLoan
---@field Guid FString
---@field OriginalLoanMoney int64
---@field LoanMoney int64
---@field LeftToRepay int64
---@field InterestPerHour float
---@field DurationHours float
---@field SecondsLeft int64
local FMTSavedGamePlayerLoan = {}



---@class FMTSavedWorld
---@field World FMTSaveGameWorld
---@field DateTimeTicks int64
---@field Version int32
local FMTSavedWorld = {}



---@class FMTServerRuntimeConfig
---@field ServerMessage FString
---@field PinnedAnnounce FString
---@field MaxVehiclePerPlayer int32
---@field bAllowPlayerToJoinWithCompanyVehicles boolean
---@field bAllowCompanyAIDriver boolean
---@field MaxHousingPlotRentalDays int32
---@field HousingPlotRentalPriceRatio float
---@field MaxHousingPlotRentalPerPlayer int32
---@field bAllowModdedVehicle boolean
---@field bAllowPoliceVehicleByPlayerRole boolean
---@field bAllowCorporation boolean
---@field bAllowCorporationAIDriver boolean
---@field bAllowAdminToRemoveAdmin boolean
local FMTServerRuntimeConfig = {}



---@class FMTSettingDesc
---@field ValueType EMTSettingValueType
---@field FloatValue float
---@field Int64Value int64
---@field BoolValue boolean
---@field StringValue FString
---@field EnumValue int32
---@field Flags int32
local FMTSettingDesc = {}



---@class FMTSettingValue
---@field ValueType EMTSettingValueType
---@field FloatValue float
---@field Int64Value int64
---@field BoolValue boolean
---@field StringValue FString
---@field EnumValue int32
local FMTSettingValue = {}



---@class FMTShadowedInt64
---@field BaseValue int64
---@field ShadowedValue int64
local FMTShadowedInt64 = {}



---@class FMTSlidingSoundFX
---@field Actor AActor
---@field Comp USceneComponent
---@field OtherActor AActor
---@field OtherComp USceneComponent
---@field Audio UAudioComponent
local FMTSlidingSoundFX = {}



---@class FMTSpawnedTrailer
---@field Trailer AMTVehicle
---@field SpawnPoint AMTTrailerSpawnPoint
---@field Destination AMTTrailerSpawnPoint
local FMTSpawnedTrailer = {}



---@class FMTSurfaceHitSoundTable
---@field Sounds TMap<EMotorTownSurface, USoundBase>
local FMTSurfaceHitSoundTable = {}



---@class FMTSurfaceParticleTable
---@field Particles TMap<EMotorTownSurface, UParticleSystem>
local FMTSurfaceParticleTable = {}



---@class FMTTextByTexts
---@field Texts TArray<FText>
local FMTTextByTexts = {}



---@class FMTTextSlidingAnimation
---@field Speed float
---@field MoveStep float
---@field StartStopDuration float
---@field EndStopDuration float
---@field HideDuration float
local FMTTextSlidingAnimation = {}



---@class FMTTickFunction : FTickFunction
local FMTTickFunction = {}


---@class FMTTimeOfDayConfigParams
---@field Speed float
---@field Start float
local FMTTimeOfDayConfigParams = {}



---@class FMTTimeOfDaySchedule
---@field StartTimeOfDay float
---@field EndTimeOfDay float
---@field ScheduleType EMTTimeOfDayScheduleType
---@field FloatValue float
local FMTTimeOfDaySchedule = {}



---@class FMTTimeOfDayScheduleRow : FTableRowBase
---@field Schedule FMTTimeOfDaySchedule
local FMTTimeOfDayScheduleRow = {}



---@class FMTTirePhysicsParams
---@field PatchLengthCoefficient float
---@field StaticMu float
---@field SlidingMu float
---@field SpringX float
---@field SpringY float
---@field DampingX float
---@field DampingY float
---@field CoolDownSpeed float
---@field WarmUpSpeed float
---@field WearRate float
---@field SmokeRate float
---@field MaxWeightKg float
---@field BrushCount int32
---@field OffroadFriction float
---@field RollingResistanceCoeff float
---@field RollingResistanceCoeffV1 float
local FMTTirePhysicsParams = {}



---@class FMTTrafficVehicleSpawnParams
---@field VehicleKey FName
local FMTTrafficVehicleSpawnParams = {}



---@class FMTUserSettingValue
---@field ValueType EMTUserSettingValueType
---@field FloatValue float
---@field Int64Value int64
---@field BoolValue boolean
---@field StringValue FString
---@field EnumValue int32
local FMTUserSettingValue = {}



---@class FMTUserSettingVariable
---@field ValueType EMTUserSettingValueType
---@field FloatValue float
---@field Int64Value int64
---@field BoolValue boolean
---@field StringValue FString
---@field EnumValue int32
local FMTUserSettingVariable = {}



---@class FMTVecRot
---@field Location FVector
---@field Rotation FRotator
local FMTVecRot = {}



---@class FMTVehicleAIBusDriver
---@field CompanyBusRoute FMTCompanyBusRoute
---@field BusRoute FMTBusRoute
---@field CompanyOwnerPC AMotorTownPlayerController
local FMTVehicleAIBusDriver = {}



---@class FMTVehicleAIBusDriverState
---@field CurrentRouteIndex int32
local FMTVehicleAIBusDriverState = {}



---@class FMTVehicleAINetState
---@field CrossroadId int32
---@field LastCrossRoadId int32
---@field CrossroadEnterTimeSeconds float
---@field CrossRoadNodeIndices TArray<int32>
local FMTVehicleAINetState = {}



---@class FMTVehicleAITruckDriver
---@field TruckRoute FMTCompanyTruckRoute
---@field CompanyOwnerPC AMotorTownPlayerController
local FMTVehicleAITruckDriver = {}



---@class FMTVehicleAITruckDriverState
---@field CurrentRouteIndex int32
local FMTVehicleAITruckDriverState = {}



---@class FMTVehicleBodyMaterial
---@field Material UMaterialInterface
---@field SlotMaterials TMap<FName, UMaterialInterface>
---@field bUseForAIVehicle boolean
local FMTVehicleBodyMaterial = {}



---@class FMTVehicleCargoPartAndSlot
---@field Slot EMTVehiclePartSlot
---@field CargoSpace UMTVehicleCargoSpaceComponent
local FMTVehicleCargoPartAndSlot = {}



---@class FMTVehicleColdState
---@field DriveMode EMTDriveMode
---@field ToggleFunctions TArray<boolean>
---@field TurnSignal EMTVehicleTurnSingal
---@field HeadLightMode EMTHeadLightMode
---@field SirenIndex int32
---@field bIsAIDriving boolean
---@field bStoppedInParkingSpace boolean
---@field bHorn boolean
---@field bAcceptTaxiPassenger boolean
---@field RemovedWheels TArray<int32>
---@field DiffLockIndex int8
---@field LiftedAxleIndices TArray<int32>
---@field LastLocationsInRoad TArray<FMTVecRot>
local FMTVehicleColdState = {}



---@class FMTVehicleColor
---@field Colors TMap<FName, FColor>
local FMTVehicleColor = {}



---@class FMTVehicleColorSlot
---@field DisplayName FText
---@field bUseColorAlpha boolean
---@field DefaultColor FColor
---@field DefaultMetallic float
---@field DefaultRoughness float
local FMTVehicleColorSlot = {}



---@class FMTVehicleControlSettings
---@field bRearSteering boolean
---@field SteeringSpeedInComfort float
---@field SteeringAssistMinSpeed FVector2D
local FMTVehicleControlSettings = {}



---@class FMTVehicleCustomization
---@field BodyMaterialIndex int32
---@field BodyColors TArray<FMTVehicleCustomizationColor>
local FMTVehicleCustomization = {}



---@class FMTVehicleCustomizationColor
---@field MaterialSlotName FName
---@field Color FColor
---@field Metallic float
---@field Roughness float
local FMTVehicleCustomizationColor = {}



---@class FMTVehicleDecal
---@field DecalLayers TArray<FMTVehicleDecalLayer>
local FMTVehicleDecal = {}



---@class FMTVehicleDecalLayer
---@field DecalKey FName
---@field Color FColor
---@field Position FVector2D
---@field Rotation FRotator
---@field DecalScale float
---@field Stretch float
---@field Coverage float
---@field Flags uint32
local FMTVehicleDecalLayer = {}



---@class FMTVehicleDiffLockingState
---@field Name FText
---@field Differentials TMap<FName, EMTDiffLockStateType>
---@field GearRatio float
---@field bDisableBrakeTCS boolean
---@field DifferentialsCache TMap<UMTDifferentialComponent, EMTDiffLockStateType>
local FMTVehicleDiffLockingState = {}



---@class FMTVehicleDriverProfile
---@field SeatPosition FMTVehicleSeatPosition
---@field ForceFeedbackStrengthMultiplier float
local FMTVehicleDriverProfile = {}



---@class FMTVehicleGarbageCompress
---@field LidDoor UMTVehicleDoorComponent
local FMTVehicleGarbageCompress = {}



---@class FMTVehicleHook
---@field Tractor AMTVehicle
---@field Trailer AMTVehicle
---@field TractorParams FMTVehicleHookParams
---@field TrailerParams FMTVehicleHookParams
---@field Constraint UPhysicsConstraintComponent
local FMTVehicleHook = {}



---@class FMTVehicleHookParams
---@field HookType EMTVehicleHookType
---@field HookSocketName FName
---@field HookComponent USceneComponent
---@field HookLocation FVector
local FMTVehicleHookParams = {}



---@class FMTVehicleLODContext
---@field DesiredVehicleLOD EMTVehicleLOD
---@field DesiredVehicleLODMust EMTVehicleLOD
---@field DesiredVehicleLODPriority EMTVehicleLOD
---@field VehicleLOD EMTVehicleLOD
---@field LastVehicleLOD EMTVehicleLOD
---@field bForced boolean
---@field bMildlyForced boolean
---@field bStop boolean
---@field SquaredDistanceToClosestPlayer float
---@field bInNotLoadedLevel boolean
---@field ForceSimulateUntilSeconds float
---@field ForceCollideUntilSeconds float
---@field UpdatedFrameCounter uint64
local FMTVehicleLODContext = {}



---@class FMTVehicleLiftAxle
---@field Name FText
---@field WheelIndexToHeight TMap<int32, float>
local FMTVehicleLiftAxle = {}



---@class FMTVehicleMirrorPosition
---@field Name FName
---@field Rotation FRotator
---@field CurvatureMultiplier float
local FMTVehicleMirrorPosition = {}



---@class FMTVehicleMirrorPositions
---@field MirrorPositions TArray<FMTVehicleMirrorPosition>
local FMTVehicleMirrorPositions = {}



---@class FMTVehicleOwnerSetting
---@field bLocked boolean
---@field DriveAllowedPlayers EMTVehicleDriveAllowedPlayers
---@field LevelRequirementsToDrive TArray<int32>
---@field VehicleOwnerProfitShare float
local FMTVehicleOwnerSetting = {}



---@class FMTVehiclePart
---@field ID int64
---@field Key FName
---@field Slot EMTVehiclePartSlot
---@field Damage float
---@field FloatValues TArray<float>
---@field Int64Values TArray<int64>
---@field StringValues TArray<FString>
---@field VectorValues TArray<FVector>
---@field ItemInventory FMTItemInventory
local FMTVehiclePart = {}



---@class FMTVehiclePartAero
---@field Mesh UStaticMesh
---@field SkelealMesh USkeletalMesh
---@field bUseCustomSocket boolean
---@field CustomSocketName FName
---@field ComponentTags TArray<FName>
---@field AttachParentComponentName FName
local FMTVehiclePartAero = {}



---@class FMTVehiclePartAngleKit
---@field AngleIncreaseInDegree float
local FMTVehiclePartAngleKit = {}



---@class FMTVehiclePartAntiRollBar
---@field AntiRollBarRateMultiplier float
local FMTVehiclePartAntiRollBar = {}



---@class FMTVehiclePartBrakeBalance
---@field FrontMultiplier float
---@field RearMultiplier float
local FMTVehiclePartBrakeBalance = {}



---@class FMTVehiclePartBrakePad
---@field HeatingMultiplier float
---@field CoolingMultiplier float
---@field FadeTemperature float
---@field WearMultiplier float
local FMTVehiclePartBrakePad = {}



---@class FMTVehiclePartBrakePower
---@field BrakePowerMultiplier float
local FMTVehiclePartBrakePower = {}



---@class FMTVehiclePartCargoBed
---@field CargoSpaceLocation FVector
---@field CargoSpaceSize FVector
---@field CargoSpaceType EMTCargoSpaceType
---@field bFixCargo boolean
---@field bUnlimitedHeight boolean
---@field DumpVolume float
local FMTVehiclePartCargoBed = {}



---@class FMTVehiclePartCoolantRadiator
---@field CoolingPower float
---@field CoolantWaterInLiter float
local FMTVehiclePartCoolantRadiator = {}



---@class FMTVehiclePartFuelTank
---@field FuelLiter float
local FMTVehiclePartFuelTank = {}



---@class FMTVehiclePartHeadlight
---@field LightOnAnim UAnimationAsset
local FMTVehiclePartHeadlight = {}



---@class FMTVehiclePartIntake
---@field Slope float
---@field BaseRPMRatio float
---@field IntakeSpeedEfficencyMultiplier float
local FMTVehiclePartIntake = {}



---@class FMTVehiclePartItemInventory
---@field NumSlots int32
local FMTVehiclePartItemInventory = {}



---@class FMTVehiclePartRoofRack
---@field CargoSpaceLocation FVector
---@field CargoSpaceSize FVector
local FMTVehiclePartRoofRack = {}



---@class FMTVehiclePartSuspensionDamper
---@field BoundDampingRateMultiplier float
---@field ReboundDampingRateMultiplier float
local FMTVehiclePartSuspensionDamper = {}



---@class FMTVehiclePartSuspensionRideHeight
---@field RideHeightChange float
local FMTVehiclePartSuspensionRideHeight = {}



---@class FMTVehiclePartSuspensionSpring
---@field SpringRateMultiplier float
local FMTVehiclePartSuspensionSpring = {}



---@class FMTVehiclePartTaxi
---@field TaxiType EMTTaxiType
---@field TaxiRoofSignClass TSubclassOf<AMTTaxiRoofSign>
local FMTVehiclePartTaxi = {}



---@class FMTVehiclePartTire
---@field TirePhysicsDataAsset UMTTirePhysicsDataAsset
---@field TirePhysicsDataAsset_BikeRear UMTTirePhysicsDataAsset
---@field bIsDualRearWheel boolean
local FMTVehiclePartTire = {}



---@class FMTVehiclePartTrailerHitch
---@field Mesh UStaticMesh
---@field ConnectionType EMTTrailerConnectionType
local FMTVehiclePartTrailerHitch = {}



---@class FMTVehiclePartTurbocharger
---@field bIsValid boolean
---@field BaseTorqueMultiplier float
---@field TorqueMultiplier float
---@field TurbineAspectRatio float
---@field IntakePressureMultiplier float
---@field HeatingMultiplier float
---@field FuelConsumptionMultiplier float
---@field TurbineWeight float
local FMTVehiclePartTurbocharger = {}



---@class FMTVehiclePartWheel
---@field LeftWheelMesh UStaticMesh
---@field RightWheelMesh UStaticMesh
---@field DRWLeftWheelMesh UStaticMesh
---@field DRWRightWheelMesh UStaticMesh
---@field RearLeftWheelMesh UStaticMesh
---@field RearRightWheelMesh UStaticMesh
local FMTVehiclePartWheel = {}



---@class FMTVehiclePartWheelSpacer
---@field Space float
local FMTVehiclePartWheelSpacer = {}



---@class FMTVehiclePartWinch
---@field MaxForceKg float
---@field MaxLength float
---@field BodyMesh UStaticMesh
---@field AxleMesh UStaticMesh
---@field HookMesh UStaticMesh
---@field StartSound USoundBase
---@field ReleaseSound USoundBase
---@field MotorInSound USoundBase
---@field MotorOutSound USoundBase
---@field RopeCrackingSound USoundBase
---@field RopeSnapSound USoundBase
local FMTVehiclePartWinch = {}



---@class FMTVehiclePhysicsSettings
---@field TCSMinWheelSpeed FVector2D
local FMTVehiclePhysicsSettings = {}



---@class FMTVehiclePistonParams
---@field ComponentName FName
---@field BaseComponentName FName
---@field TargetComponentName FName
---@field BaseSocketName FName
---@field TargetSocketName FName
---@field LinearMovementRatio float
---@field Component UPrimitiveComponent
---@field BaseComponent UPrimitiveComponent
---@field TargetComponent UPrimitiveComponent
local FMTVehiclePistonParams = {}



---@class FMTVehicleRaceState
---@field Laps int32
---@field LastSectionIndex int32
---@field LastSectionRaceTime float
---@field bFinished boolean
local FMTVehicleRaceState = {}



---@class FMTVehicleRepMovement
---@field bForceSync boolean
---@field Steer int8
---@field Throttle uint8
---@field Brake uint8
---@field HandBrake uint8
---@field bHasBaseVehicle boolean
---@field bIsBaseRelative boolean
---@field bIsBaseOffset boolean
---@field bIsBaseRelativeRotation boolean
---@field BaseVehicle AMTVehicle
---@field Location FVector
---@field Velocity FVector
---@field Quat FQuat
---@field AngularVelocityInRadian FVector
---@field LOD uint8
---@field bLODForced boolean
---@field bLODMildlyForced boolean
---@field bInNotLoadedLevel boolean
---@field VehicleState FMTVehicleState
---@field EngineHotState FMTNetEngineHotState
---@field DriverRelativeLookRotation FRotator
---@field BikeDriverLeaningDegree float
local FMTVehicleRepMovement = {}



---@class FMTVehicleRepMovementNet
---@field Vehicle AMTVehicle
---@field VehicleId int64
---@field Movement FMTVehicleRepMovement
local FMTVehicleRepMovementNet = {}



---@class FMTVehicleRowPartValues
---@field FloatValues TArray<float>
---@field Int64Values TArray<int64>
---@field StringValues TArray<FString>
---@field VectorValues TArray<FVector>
local FMTVehicleRowPartValues = {}



---@class FMTVehicleSeatPosition
---@field ForwardPosition float
---@field Height float
---@field SteeringWheelDistance float
---@field SteeringWheelHeight float
local FMTVehicleSeatPosition = {}



---@class FMTVehicleSetting
---@field SettingType EMTVehicleSettingType
---@field Value FMTSettingValue
local FMTVehicleSetting = {}



---@class FMTVehicleSpawnParams
---@field OwnerCompanyGuid FGuid
---@field VehicleId int64
---@field VehicleKey FName
---@field Parts TArray<FMTVehiclePart>
---@field OwnerSetting FMTVehicleOwnerSetting
---@field VehicleSettings TArray<FMTVehicleSetting>
---@field VehicleState FMTVehicleState
---@field VehicleColdState FMTVehicleColdState
---@field Customization FMTVehicleCustomization
---@field bUseRandomCustomization boolean
---@field Decal FMTVehicleDecal
---@field bForSale boolean
---@field AbsoluteLocation FVector
---@field Rotation FRotator
---@field WorldDoors TArray<FMTPlayerWorldDataDoor>
---@field Doors TArray<FMTPlayerDataVehicleDoor>
---@field Passengers TArray<FMTPlayerDataPassenger>
---@field Constraints TArray<FMTPlayerDataConstraint>
---@field CargoSpaces TArray<FMTPlayerDataCargoSpace>
---@field Cargos TArray<FMTPlayerDataCargo>
---@field Bus FMTPlayerDataBus
---@field TowRequest FMTPlayerDataTowRequest
---@field Getaway FMTPlayerDataGetaway
---@field Rent FMTSaveGameWorldVehicleRent
---@field WheelStraps TArray<FMTPlayerDataWheelStrap>
---@field CarrierVehicleId int64
---@field bHaveTractor boolean
---@field TractorVehicleId int64
---@field TractorHookParams FMTVehicleHookParams
---@field TrailerHookParams FMTVehicleHookParams
---@field bResetOnSpawn boolean
---@field bResetIfCollide boolean
---@field bForceSimulate boolean
---@field bSpawnedFromSpawner boolean
---@field WorldVehicleFlags uint32
---@field ActorTags TArray<FName>
local FMTVehicleSpawnParams = {}



---@class FMTVehicleSpawnPointControler
---@field Vehicle AMTVehicle
local FMTVehicleSpawnPointControler = {}



---@class FMTVehicleSpawnPointPartParams
---@field Slot EMTVehiclePartSlot
---@field PartKey FName
local FMTVehicleSpawnPointPartParams = {}



---@class FMTVehicleSpawnPointVehicleParams
---@field VehicleKey FName
---@field Customizations TArray<FMTVehicleCustomization>
---@field Parts TArray<FMTVehicleSpawnPointPartParams>
local FMTVehicleSpawnPointVehicleParams = {}



---@class FMTVehicleState
---@field Fuel float
---@field Condition float
---@field OdoMeterKm double
---@field Wheels TArray<FMTNetWheelHotState>
---@field LiftAxleProgresses TArray<float>
local FMTVehicleState = {}



---@class FMTVehicleSuspensionBone
---@field BoneName FName
---@field WheelHubSocketName FName
---@field bSteering boolean
---@field bRotate boolean
---@field bSlide boolean
---@field bApplyToWheel boolean
---@field LocalRotationAxis FVector
---@field LocalSlidingAxis FVector
local FMTVehicleSuspensionBone = {}



---@class FMTVehicleSuspensionParams
---@field WheelSlotIndex int32
---@field ComponentName FName
---@field SuspensionType EMTVehicleSuspensionType
---@field WheelHubBoneName FName
---@field TrailArmBoneName FName
---@field TrailArmAxleSocketName FName
---@field Bones TArray<FMTVehicleSuspensionBone>
---@field AnimInstance UMTSuspensionAnimInstance
---@field SkeletalMeshComponent USkeletalMeshComponent
---@field PoseableMeshComponent UPoseableMeshComponent
local FMTVehicleSuspensionParams = {}



---@class FMTVehicleSyncData
---@field SyncFlags uint8
---@field Int32Param1 int32
---@field SyncData int32
local FMTVehicleSyncData = {}



---@class FMTVehicleUtilitySlot
---@field ParentComponent USceneComponent
local FMTVehicleUtilitySlot = {}



---@class FMTVehicleWheelAxle
---@field AxleIndex int32
---@field WheelIndices TArray<int32>
---@field LocationX float
local FMTVehicleWheelAxle = {}



---@class FMTVoiceLineRow : FTableRowBase
---@field VoiceLineType EMTVoiceLineType
---@field Sound USoundBase
local FMTVoiceLineRow = {}



---@class FMTWaterSprayPoint
---@field SphereComponent USphereComponent
---@field WaterNS UNiagaraComponent
local FMTWaterSprayPoint = {}



---@class FMTWeatherConfigParams
---@field DefaultWeather EMTWeather
---@field FogParameters TMap<EMTWeather, FMTWeatherFogConfigParams>
---@field WeatherSchedules TMap<EMTWeather, FMTWeatherScheduleConfigParams>
---@field WeatherSchedules2 TArray<FMTWeatherScheduleConfigParams>
local FMTWeatherConfigParams = {}



---@class FMTWeatherFogConfigParams
---@field FogDensity float
local FMTWeatherFogConfigParams = {}



---@class FMTWeatherScheduleConfigParams
---@field Probability int32
---@field Weather EMTWeather
---@field WeatherStartSecondsRange FVector2D
---@field WeatherDurationSecondsRange FVector2D
---@field Fog FMTWeatherFogConfigParams
---@field Temperature float
local FMTWeatherScheduleConfigParams = {}



---@class FMTWorldMap
---@field WorldMapTexture UTexture2D
---@field WorldMapLocation FVector
---@field WorldMapSize float
---@field DefaultViewLocation FVector2D
---@field DefaultViewWidth float
---@field DefaultViewHeight float
local FMTWorldMap = {}



---@class FMTWorldMapArea
---@field Volume AMTAreaVolume
---@field ScaleByVolumeType float
---@field Widget UMapAreaNameWidget
---@field Slot UCanvasPanelSlot
local FMTWorldMapArea = {}



---@class FMTZoneState
---@field ZoneKey FName
---@field Server_Volume AMTAreaVolume
---@field Server_Supermarkets TArray<AMTDeliveryPoint>
---@field Server_Residents TArray<AMTDeliveryPoint>
---@field FoodSupplyRate float
---@field BusTransportRate float
---@field TaxiTransportRate float
---@field PolicePatrolRate float
---@field GarbageCollectRate float
---@field NumResidents int32
local FMTZoneState = {}



---@class FMotorTownAIDriverSetting
---@field LateralG float
---@field BrakingG float
---@field RaceLateralG float
---@field RaceBrakingG float
local FMotorTownAIDriverSetting = {}



---@class FStaticMeshSpawnerMeshParams
---@field bUseInstancing boolean
---@field Mesh UStaticMesh
---@field MeshType EStaticMeshSpawnerMeshType
---@field Collision ECollisionEnabled::Type
---@field EndCullDistance float
---@field RandomLocationRate FVector
---@field Rotation FRotator
---@field RandomRotation FRotator
---@field RandomScaleMin FVector
---@field RandomScaleMax FVector
local FStaticMeshSpawnerMeshParams = {}



---@class FTMFireSystemConfig
---@field MaxFires int32
---@field RandomFireStartIntervalMinSeconds float
---@field RandomFireStartIntervalMaxSeconds float
local FTMFireSystemConfig = {}



---@class FVehiclePartRow : FTableRowBase
---@field Name FText
---@field Name2 FMTTextByTexts
---@field Desciption FText
---@field Cost int32
---@field bIsHidden boolean
---@field MassKg float
---@field AirDragMultiplier float
---@field TrailerAirDragMultiplier float
---@field AeroLift float
---@field FrontAeroLift float
---@field RearAeroLift float
---@field FrontDamageMultiplier float
---@field PartType EMTVehiclePartType
---@field GameplayTags FGameplayTagContainer
---@field VehicleTypes TArray<EMTVehicleType>
---@field TruckClasses TArray<EMTTruckClass>
---@field bTruckClassIncludeNone boolean
---@field VehicleRowGameplayTagQuery FGameplayTagQuery
---@field LevelRequirementToBuy TMap<EMTCharacterLevelType, int32>
---@field VehicleKeys TArray<FName>
---@field OverrideAllowedVehicleKeys TArray<FName>
---@field Slots TArray<EMTVehiclePartSlot>
---@field BodyMaterialNames TMap<FName, FText>
---@field ColorSlots TMap<FName, FMTVehicleColorSlot>
---@field DecalableMaterialSlotNames TArray<FName>
---@field EngineAsset UMHEngineDataAsset
---@field TransmissionAsset UMTTransmissionDataAsset
---@field LSDAsset UMTLSDDataAsset
---@field FinalDriveRatio float
---@field Intake FMTVehiclePartIntake
---@field CoolantRadiator FMTVehiclePartCoolantRadiator
---@field Turbocharger FMTVehiclePartTurbocharger
---@field Tire FMTVehiclePartTire
---@field SuspensionSpring FMTVehiclePartSuspensionSpring
---@field SuspensionDamper FMTVehiclePartSuspensionDamper
---@field SuspensionRideHeight FMTVehiclePartSuspensionRideHeight
---@field AntiRollBar FMTVehiclePartAntiRollBar
---@field Aero FMTVehiclePartAero
---@field Headlight FMTVehiclePartHeadlight
---@field TrailerHitch FMTVehiclePartTrailerHitch
---@field CargoBed FMTVehiclePartCargoBed
---@field RoofRack FMTVehiclePartRoofRack
---@field Wheel FMTVehiclePartWheel
---@field WheelSpacer FMTVehiclePartWheelSpacer
---@field BrakePad FMTVehiclePartBrakePad
---@field AngleKit FMTVehiclePartAngleKit
---@field BrakePower FMTVehiclePartBrakePower
---@field BrakeBalance FMTVehiclePartBrakeBalance
---@field Winch FMTVehiclePartWinch
---@field Taxi FMTVehiclePartTaxi
---@field ItemInventory FMTVehiclePartItemInventory
---@field FuelTank FMTVehiclePartFuelTank
local FVehiclePartRow = {}



---@class FVehicleRow : FTableRowBase
---@field VehicleName FText
---@field VehicleName2 FMTTextByTexts
---@field VehicleType EMTVehicleType
---@field VehicleClass TSubclassOf<AMTVehicle>
---@field TruckClass EMTTruckClass
---@field VehicleTypeFlags int32
---@field GameplayTags FGameplayTagContainer
---@field GarageGameplayTagQuery FGameplayTagQuery
---@field bHidden boolean
---@field DeliveryBasePayment int64
---@field bShowCargoSpaceAtTheGarage boolean
---@field ExhaustBlackSmokeDensity float
---@field Cost int32
---@field bIsTaxiable boolean
---@field bIsLimoable boolean
---@field bIsBusable boolean
---@field bIsRaceCar boolean
---@field bTrailerHauling boolean
---@field bHasFuelPump boolean
---@field LevelRequirementToDrive TMap<EMTCharacterLevelType, int32>
---@field Parts TMap<EMTVehiclePartSlot, FName>
---@field PartValues TMap<EMTVehiclePartSlot, FMTVehicleRowPartValues>
---@field Comport float
---@field NotOptionalPartTypes TSet<EMTVehiclePartType>
---@field OptionalPartTypes TSet<EMTVehiclePartType>
---@field NotOptionalPartSlots TSet<EMTVehiclePartSlot>
---@field NotSupportedPartTypes TSet<EMTVehiclePartType>
---@field SlotSupportedPartsQueries TMap<EMTVehiclePartSlot, FGameplayTagQuery>
---@field BodyDamageThreshold float
---@field NPCSpawnPrabability float
---@field DeliveryPaymentMultiplier float
---@field CompanyAIRunningCostMultiplier float
---@field CompanyAIConditionUsageMultiplier float
---@field CompanyAIConditionUsageMultiplierOffroad float
---@field bDisabled boolean
---@field bShowRequirementsNotMet boolean
---@field CurbWeight float
local FVehicleRow = {}



---@class FWarehouse
---@field DeliveryPoint AMTDeliveryPoint
local FWarehouse = {}



---@class IMTConstraintOwner : IInterface
local IMTConstraintOwner = {}


---@class IMTGameplayTagsOwner : IInterface
local IMTGameplayTagsOwner = {}


---@class IMTRopeOwner : IInterface
local IMTRopeOwner = {}


---@class IMTUseableActor : IInterface
local IMTUseableActor = {}

---@param Interactor AActor
---@param Param1 float
function IMTUseableActor:HandleUse(Interactor, Param1) end


---@class IMTVehicleComponent : IInterface
local IMTVehicleComponent = {}


---@class IMTVehicleOverlapEventHandler : IInterface
local IMTVehicleOverlapEventHandler = {}


---@class IMTVehiclePartComponent : IInterface
local IMTVehiclePartComponent = {}


---@class IMTWidgetInputHandler : IInterface
local IMTWidgetInputHandler = {}


---@class UARMarkerWidget : UUserWidget
---@field DistanceTextBlock UTextBlock
---@field IconOverlay UOverlay
---@field IconWidgetClass TSubclassOf<UIconWidget>
---@field bShowDistance boolean
---@field Marker AMTARMarker
---@field IconWidget UIconWidget
local UARMarkerWidget = {}

---@param IconType EMTIconType
---@param bInDisabled boolean
function UARMarkerWidget:ReceiveSetIconType(IconType, bInDisabled) end


---@class UARVehicleSellerMarkerWidget : UARMarkerWidget
---@field MoneyWidget UMTMoneyWidget
local UARVehicleSellerMarkerWidget = {}



---@class UActionKeyMappingWidget : UUserWidget
---@field ActionNameTextBlock UTextBlock
---@field KeySelector0 UKeySelectorWidget
---@field KeySelector1 UKeySelectorWidget
---@field KeySelector2 UKeySelectorWidget
---@field NumKeys int32
---@field KeySelectors TArray<UKeySelectorWidget>
local UActionKeyMappingWidget = {}



---@class UActionKeyWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field KeyIconWidget UKeyIconWidget
local UActionKeyWidget = {}



---@class UActionPopupWidget : UUserWidget
---@field ActionKeyWidgetClass TSubclassOf<UActionKeyWidget>
---@field VerticalBox UVerticalBox
---@field InteractionKey UActionKeyWidget
---@field ActionWidgets TMap<FName, UActionKeyWidget>
local UActionPopupWidget = {}



---@class UActiveLoanEntryWidget : UUserWidget
---@field LoanTextBlock UTextBlock
---@field PaymentLeftTextBlock UTextBlock
---@field InterestRateTextBlock UTextBlock
---@field InstallmentTextBlock UTextBlock
---@field TimeLeftTextBlock UTextBlock
---@field RepayButton UMTButtonWidget
local UActiveLoanEntryWidget = {}



---@class UAdminListEntryWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field DeleteButton UMTButtonWidget
local UAdminListEntryWidget = {}



---@class UAdminVehicleListEntryWidget : UMTListViewEntryWidget
---@field NameWidget UTextBlock
local UAdminVehicleListEntryWidget = {}



---@class UAdminVehicleListWidget : UUserWidget
---@field FilterBox UVerticalBox
---@field VehiclesListView UMTListView
---@field AbandonedCheckBox UCheckBoxWidget
---@field CompanyAICheckBox UCheckBoxWidget
---@field DetailWidget UWidget
---@field DespawnButton UMTButtonWidget
---@field DetailTextBlock URichTextBlock
---@field PlayerOwnVehicleCheckBox UCheckBoxWidget
---@field CompanyOwnVehicleCheckBox UCheckBoxWidget
---@field DealerVehicleCheckBox UCheckBoxWidget
---@field WorldRentalVehicleCheckBox UCheckBoxWidget
---@field TowRequestVehicleCheckBox UCheckBoxWidget
---@field AITrafficVehicleCheckBox UCheckBoxWidget
---@field CachedVehicles TArray<AMTVehicle>
---@field SelectedVehicle AMTVehicle
local UAdminVehicleListWidget = {}



---@class UAdminWidget : UUserWidget
---@field ServerMessageButton UMTButtonWidget
---@field ServerMessageTextBox UMultiLineEditableTextBox
---@field AdminListView UListView
---@field BanListView UListView
---@field PoliceListView UListView
---@field PoliceDisabledTextBlock UTextBlock
---@field VehiclesButton UMTButtonWidget
local UAdminWidget = {}



---@class UAmbulanceControlPanelWidget : UUserWidget
---@field AutoAcceptPassengerSetting UUserSettingItemWidget
---@field AutoAcceptPassengerOffroadSetting UUserSettingItemWidget
---@field DistanceToPassengerSortButton UMTButtonWidget
---@field MoneySortButton UMTButtonWidget
---@field PassengersListView UMTListView
---@field PassengersMapWidget UWorldMapWidget
---@field SelectedDetailTextBlock URichTextBlock
---@field ShowWhenEnterVehicleCheckBox UCheckBoxWidget
---@field CachedPassengers TArray<UMTPassengerComponent>
---@field SelectedPassengerObject UMTAmbulancePassengerListObject
local UAmbulanceControlPanelWidget = {}



---@class UAmbulancePassengerEntryWidget : UMTListViewEntryWidget
---@field ReservedFrame UWidget
---@field NameWidget UTextBlock
---@field DistanceToPassengerWidet UTextBlock
---@field DistanceWidet URichTextBlock
---@field DetailsWidet URichTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field AcceptButton UMTButtonWidget
---@field PickUpWidget UWidget
---@field DropOffWidget UWidget
local UAmbulancePassengerEntryWidget = {}



---@class UAssistSettingsWidget : UUserWidget
---@field SettingWidgetClass TSubclassOf<USettingWidget>
---@field SettingsVerticalBox UVerticalBox
---@field ResetToDefaultButton UMTButtonWidget
---@field AutoShiftSpinBox USettingWidget
---@field AutoReverseSpinBox USettingWidget
---@field AutoStartEngineSpinBox USettingWidget
---@field KeyboardSteeringSpeedSpinBox USettingWidget
---@field SteeringAssistStrengthSpinBox USettingWidget
---@field TractionControlStrengthSpinBox USettingWidget
---@field StabilityControlStrengthSpinBox USettingWidget
---@field ABSStrengthSpinBox USettingWidget
local UAssistSettingsWidget = {}



---@class UAttachmentPlacementWidget : UUserWidget
---@field AttachmentPopupWindow UUserWidget
---@field AttachmentSelection USettingWidget
---@field LocationXSetting USettingWidget
---@field LocationYSetting USettingWidget
---@field LocationZSetting USettingWidget
---@field RotationXSetting USettingWidget
---@field RotationYSetting USettingWidget
---@field RotationZSetting USettingWidget
---@field InteractionsVerticalBox UVerticalBox
---@field SaveButton UMTButtonWidget
---@field UninstallButton UMTButtonWidget
---@field ControlsPanel UPanelWidget
---@field ColorPickerOverlay UOverlay
---@field ColorPicker UColorPicker2Widget
---@field ColorPickerCloseButton UMTButtonWidget
---@field Attachment UMTVehicleAttachmentPartComponent
---@field Vehicle AMTVehicle
---@field Camera ACameraActor
local UAttachmentPlacementWidget = {}



---@class UBanConfirmWidget : UUserWidget
---@field PlayerState AMotorTownPlayerState
---@field BanReasonEditableTextBox UEditableTextBox
---@field DurationReasonEditableTextBox UEditableTextBox
---@field OkButton UMTButtonWidget
local UBanConfirmWidget = {}



---@class UBanListEntryWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field DeleteButton UMTButtonWidget
local UBanListEntryWidget = {}



---@class UBankLoanWidget : UUserWidget
---@field NewLoanSettingItem USettingWidget
---@field NewLoanDurationSettingItem USettingWidget
---@field NewLoanInterestTextBlock UTextBlock
---@field NewLoanInstallmentTextBlock UTextBlock
---@field NewLoanTotalTextBlock UTextBlock
---@field TakeLoanButton UMTButtonWidget
---@field ActiveLoanListView UListView
local UBankLoanWidget = {}



---@class UBuffWidget : UUserWidget
---@field IconImage UImage
---@field ProgressBar UProgressBar
local UBuffWidget = {}



---@class UBuildingInventoryInteractionWidget : UUserWidget
---@field CharacterInventory UInventoryWidget
---@field BuildingInventory UInventoryWidget
local UBuildingInventoryInteractionWidget = {}

---@param BuildingName FText
function UBuildingInventoryInteractionWidget:SetBuildingName(BuildingName) end


---@class UBuildingManagementWidget : UUserWidget
---@field DestructionButton UMTButtonWidget
---@field Building AMTBuilding
local UBuildingManagementWidget = {}



---@class UBusExternalScreenWidget : UUserWidget
---@field RouteTextBlock UTextBlock
---@field NextStopSizeBox UWidget
---@field NextStopScaleBox UScaleBox
---@field NextStopTextBlock UTextBlock
---@field NextStopTextAnimation FMTTextSlidingAnimation
local UBusExternalScreenWidget = {}



---@class UBusRouteEntryWidget : UMTListViewEntryWidget
---@field IconTextBlock URichTextBlock
---@field RouteNameTextBlock UTextBlock
---@field LengthTextBlock UTextBlock
---@field NumStopsTextBlock UTextBlock
---@field NumPassengersTextBlock UTextBlock
---@field SelectButton UMTButtonWidget
local UBusRouteEntryWidget = {}



---@class UBusRouteSelectionWidget : UUserWidget
---@field RouteListView UListView
---@field MapWidget UWorldMapWidget
---@field StopButton UMTButtonWidget
---@field ShowWhenEnterVehicleCheckBox UCheckBoxWidget
---@field Vehicle AMTVehicle
---@field SelectedObject UMTBusRouteListObject
local UBusRouteSelectionWidget = {}



---@class UButtonsDialogWidget : UUserWidget
---@field ButtonClass TSubclassOf<UMTButtonWidget>
---@field CheckBoxClass TSubclassOf<UCheckBoxWidget>
---@field MessageTextBlock URichTextBlock
---@field ButtonsVerticalBox UVerticalBox
---@field CheckBoxes TArray<UCheckBoxWidget>
local UButtonsDialogWidget = {}



---@class UCancelButtonWidget : UMTButtonWidget
local UCancelButtonWidget = {}


---@class UCargoEncyclopediaCargoEntryObject : UObject
---@field CargoKey FName
---@field CargoRow FCargoRow
---@field SupplyDeliveryPoints TArray<AMTDeliveryPoint>
---@field DemandDeliveryPoints TArray<AMTDeliveryPoint>
local UCargoEncyclopediaCargoEntryObject = {}



---@class UCargoEncyclopediaCargoEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock URichTextBlock
---@field CargoTypeTextBlock URichTextBlock
local UCargoEncyclopediaCargoEntryWidget = {}



---@class UCargoEncyclopediaDeliveryPointEntryObject : UObject
---@field DeliveryPoint AMTDeliveryPoint
local UCargoEncyclopediaDeliveryPointEntryObject = {}



---@class UCargoEncyclopediaDeliveryPointEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock URichTextBlock
---@field SupplyTextBlock URichTextBlock
---@field DemandTextBlock URichTextBlock
local UCargoEncyclopediaDeliveryPointEntryWidget = {}



---@class UCargoEncyclopediaWidget : UUserWidget
---@field CargoTypeFilterSpinBox USpinBoxString
---@field CargoSpaceTypeFilterSpinBox USpinBoxString
---@field StringSearchBox UStringSearchBoxWidget
---@field CargoListView UMTListView
---@field NameStatWidget UStatWidget
---@field CargoTypeStatWidget UStatWidget
---@field CargoSpaceTypeStatWidget UStatWidget
---@field SupplyStatWidget UStatWidget
---@field DemandStatWidget UStatWidget
---@field DeliveryPointListView UMTListView
---@field MapWidget UWorldMapWidget
local UCargoEncyclopediaWidget = {}



---@class UCargoInfoTooltipWidget : UUserWidget
---@field InfoTextBlock URichTextBlock
---@field MapWidget UWorldMapWidget
---@field Cargo AMTCargo
local UCargoInfoTooltipWidget = {}



---@class UCargoTimerHUDWidget : UUserWidget
---@field TimeTextBlock UTextBlock
local UCargoTimerHUDWidget = {}



---@class UChangeVehicleNameWidget : UGarageChildWidget
---@field VehicleNameTextBox UEditableTextBox
---@field OkButton UMTButtonWidget
local UChangeVehicleNameWidget = {}

---@param Text FText
function UChangeVehicleNameWidget:HandleNameTextBoxChanged(Text) end


---@class UCharacterCounterListWidget : UUserWidget
---@field CountersVerticalBox UVerticalBox
---@field CounterWidgetClass TSubclassOf<UCharacterCounterWidget>
local UCharacterCounterListWidget = {}



---@class UCharacterCounterWidget : UUserWidget
---@field NameTextBlock URichTextBlock
---@field CountTextBlock URichTextBlock
local UCharacterCounterWidget = {}



---@class UCharacterCreationWidget : UUserWidget
---@field CharacterPartsSettingWidget UCharacterPartsSettingWidget
---@field NicknameTextBox UEditableTextBox
---@field ConfirmButton UMTButtonWidget
---@field OldViewTarget AActor
---@field Character AMTCharacter
local UCharacterCreationWidget = {}

---@param bMode boolean
---@param InModifySlot int32
function UCharacterCreationWidget:SetModifyMode(bMode, InModifySlot) end
function UCharacterCreationWidget:ReceiveDisableBackButton() end
---@param Text FText
function UCharacterCreationWidget:HandleNicknameTextBoxChanged(Text) end
function UCharacterCreationWidget:HandleConfirm() end


---@class UCharacterEditorWidget : UUserWidget
---@field PreviewImageWidget UImage
---@field CharacterPartsSettingWidget UCharacterPartsSettingWidget
---@field ConfirmButton UMTButtonWidget
---@field ActorPreview AMTActorPreview
---@field PreviewCharacter AMTCharacter
---@field WorldCharacter AMTCharacter
local UCharacterEditorWidget = {}



---@class UCharacterFrameWidget : UUserWidget
---@field NameTextBlock URichTextBlock
---@field LevelProgress ULevelProgressWidget
local UCharacterFrameWidget = {}



---@class UCharacterInfoWidget : UUserWidget
---@field NicknameTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field LevelsPanel UPanelWidget
---@field LevelWidgetPadding FMargin
---@field bHideProgressbar boolean
---@field LevelWidgets TMap<EMTCharacterLevelType, ULevelProgressWidget>
local UCharacterInfoWidget = {}

function UCharacterInfoWidget:HandleProfileChanged() end


---@class UCharacterListWidget : UUserWidget
---@field CharacterButtonWidgetClass TSubclassOf<UMTButtonWidget>
---@field CharacterCreationWidgetClass TSubclassOf<UCharacterCreationWidget>
---@field CharactersVerticalBox UVerticalBox
---@field CharacterInfoWidget UCharacterInfoWidget
---@field CounterListWidget UCharacterCounterListWidget
---@field CreateButton UMTButtonWidget
---@field SelectButton UMTButtonWidget
---@field EditButton UMTButtonWidget
---@field DeleteButton UMTButtonWidget
---@field OldViewTarget AActor
---@field Character AMTCharacter
---@field CharacterButtons TMap<FString, UMTButtonWidget>
local UCharacterListWidget = {}

function UCharacterListWidget:HandleProfileModified() end


---@class UCharacterPartsSettingWidget : UUserWidget
---@field SlotSettingWidgetClass TSubclassOf<USettingWidget>
---@field SlotSettingWidgetPadding FMargin
---@field SlotsBox UVerticalBox
---@field SlotSettingWidgetMap TMap<EMTCharacterPartSlot, USettingWidget>
local UCharacterPartsSettingWidget = {}



---@class UChaseCameraArmComponent : USpringArmComponent
local UChaseCameraArmComponent = {}


---@class UChatEntry : UObject
local UChatEntry = {}


---@class UChatListEntryWidget : UUserWidget
---@field ChatTextBlock URichTextBlock
---@field ChatEntry UChatEntry
local UChatListEntryWidget = {}



---@class UChatWidget : UUserWidget
---@field PinnedMessageTextBlock URichTextBlock
---@field ChatListView UListView
---@field ChatInputBox UWidget
---@field ChatTextBox UEditableTextBox
---@field ChatCommandsOverlay UOverlay
---@field ChatCommandsTextBlock URichTextBlock
---@field WhisperTargetOverlay UOverlay
---@field WhisperTargetListView UListView
---@field MoreButton UMTButtonWidget
---@field ChatListBG UUserWidget
---@field LastWhisperInPlayerState AMotorTownPlayerState
---@field CurrentWhisperPlayerState AMotorTownPlayerState
local UChatWidget = {}

function UChatWidget:StartEnterChat() end
---@param Text FText
---@param CommitMethod ETextCommit::Type
function UChatWidget:OnTextCommitted(Text, CommitMethod) end
---@param Text FText
function UChatWidget:OnTextChanged(Text) end


---@class UCheckBoxWidget : UUserWidget
---@field NameTextBlock URichTextBlock
---@field CheckBox UCheckBox
local UCheckBoxWidget = {}

---@param bIsChecked boolean
function UCheckBoxWidget:HandleCheckChanged(bIsChecked) end


---@class UColorPaletteItemWidget : UUserWidget
---@field Button UMTButtonWidget
---@field ColorBorder UBorder
local UColorPaletteItemWidget = {}



---@class UColorPicker2Widget : UUserWidget
---@field PaletteItemWidgetClass TSubclassOf<UColorPaletteItemWidget>
---@field HueSlider UColorSliderWidget
---@field SaturationSlider UColorSliderWidget
---@field ValueSlider UColorSliderWidget
---@field AlphaSlider UColorSliderWidget
---@field MetallicSlider UColorSliderWidget
---@field RoughnessSlider UColorSliderWidget
---@field ColorCodeTextBox UEditableTextBox
---@field DefaultPaletteWrapBox UWrapBox
---@field AddToPaletteButton UMTButtonWidget
---@field PaletteWrapBox UWrapBox
local UColorPicker2Widget = {}

---@param Text FText
function UColorPicker2Widget:HandleColorCodeTextBoxChanged(Text) end


---@class UColorPickerWidget : UUserWidget
---@field ColorWheel UColorWidget
---@field ValueSlider USlider
local UColorPickerWidget = {}

---@param NewColor FLinearColor
function UColorPickerWidget:HandleColorWheelChanged(NewColor) end


---@class UColorSliderWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field Gradient UMTComplexGradientWidget
---@field SpinBox USpinBoxString
---@field Channel EMTColorPickerChannels
local UColorSliderWidget = {}



---@class UComfortHUDWidget : UUserWidget
---@field ComfortTextBlock URichTextBlock
---@field Vehicle AMTVehicle
local UComfortHUDWidget = {}



---@class UCompanyAdminWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field ShortDescTextBox UEditableTextBox
---@field EditNameButton UMTButtonWidget
---@field EditShortDescButton UMTButtonWidget
---@field LeaveButton UMTButtonWidget
---@field CloseDownButton UMTButtonWidget
---@field CompanyWidget UCompanyWidget
local UCompanyAdminWidget = {}

---@param Text FText
function UCompanyAdminWidget:HandleShortDescTextBoxChanged(Text) end


---@class UCompanyBusRoutesEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock UTextBlock
---@field StateTextBlock URichTextBlock
---@field EditButton UMTButtonWidget
---@field RemoveButton UMTButtonWidget
local UCompanyBusRoutesEntryWidget = {}



---@class UCompanyBusRoutesWidget : UUserWidget
---@field StatusTextBlock URichTextBlock
---@field BusRoutesListView UMTListView
---@field AddButton UMTButtonWidget
---@field ImportSystemButton UMTButtonWidget
---@field CompanyMapWidget UWorldMapWidget
---@field SelectedObject UMTCompanyRouteObject
local UCompanyBusRoutesWidget = {}



---@class UCompanyDailyReportListEntryWidget : UMTListViewEntryWidget
---@field ReportTextBlock URichTextBlock
local UCompanyDailyReportListEntryWidget = {}



---@class UCompanyDepotWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field StatusTextBlock URichTextBlock
---@field StorageTextBlock URichTextBlock
---@field EditNameButton UMTButtonWidget
---@field RestockButton UMTButtonWidget
local UCompanyDepotWidget = {}

---@param VehicleName FText
function UCompanyDepotWidget:ReceiveSetDepotName(VehicleName) end


---@class UCompanyDepotsEntryWidget : UMTListViewEntryWidget
---@field DepotNameTextBlock UTextBlock
---@field StatusTextBlock URichTextBlock
---@field StorageGauge UProgressBarGaugeWidget
---@field RestockButton UMTButtonWidget
---@field EditButton UMTButtonWidget
local UCompanyDepotsEntryWidget = {}



---@class UCompanyDepotsWidget : UUserWidget
---@field DepotsListView UMTListView
local UCompanyDepotsWidget = {}



---@class UCompanyInfoPlayerListEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock UTextBlock
---@field LevelsHorizontalBox UHorizontalBox
---@field PlayerState AMotorTownPlayerState
local UCompanyInfoPlayerListEntryWidget = {}



---@class UCompanyInfoWidget : UUserWidget
---@field NameTextBlock URichTextBlock
---@field DescRichTextBlock URichTextBlock
---@field JoinButton UMTButtonWidget
---@field CancelJoinRequestButton UMTButtonWidget
---@field CloseDownButton UMTButtonWidget
---@field PlayerListView UMTListView
local UCompanyInfoWidget = {}



---@class UCompanyJoinRequestEntryWidget : UMTListViewEntryWidget
---@field PlayerLevelAndNameWidget UPlayerLevelAndNameWidget
---@field MoreButton UMTButtonWidget
local UCompanyJoinRequestEntryWidget = {}



---@class UCompanyListEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock URichTextBlock
---@field InfoRichTextBlock URichTextBlock
---@field SelectButton UMTButtonWidget
local UCompanyListEntryWidget = {}



---@class UCompanyListWidget : UUserWidget
---@field StringSearchBox UStringSearchBoxWidget
---@field CompanyListView UMTListView
local UCompanyListWidget = {}



---@class UCompanyMoneyTransactionListEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock UTextBlock
---@field PlayerNameTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
local UCompanyMoneyTransactionListEntryWidget = {}



---@class UCompanyMoneyWidget : UUserWidget
---@field DailyReportListView UMTListView
---@field MoneyTransactionList UMTListView
local UCompanyMoneyWidget = {}

---@param Minutes int32
function UCompanyMoneyWidget:ReceiveSetDayMinutes(Minutes) end


---@class UCompanyPlayersEntryWidget : UMTListViewEntryWidget
---@field PlayerLevelAndNameWidget UPlayerLevelAndNameWidget
---@field RoleTextBlock URichTextBlock
---@field MoreButton UMTButtonWidget
local UCompanyPlayersEntryWidget = {}



---@class UCompanyPlayersWidget : UUserWidget
---@field PlayerListView UMTListView
---@field JoinRequestListView UMTListView
---@field CachedPlayers TArray<FMTCompanyPlayer>
---@field CachedRequests TArray<FMTCompanyJoinRequest>
local UCompanyPlayersWidget = {}



---@class UCompanyTruckRoutesEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock UTextBlock
---@field StateTextBlock URichTextBlock
---@field EditButton UMTButtonWidget
---@field RemoveButton UMTButtonWidget
local UCompanyTruckRoutesEntryWidget = {}



---@class UCompanyTruckRoutesWidget : UUserWidget
---@field StatusTextBlock URichTextBlock
---@field RoutesListView UMTListView
---@field AddButton UMTButtonWidget
---@field CompanyMapWidget UWorldMapWidget
---@field SelectedObject UMTCompanyRouteObject
local UCompanyTruckRoutesWidget = {}



---@class UCompanyVehicleControlPanelWidget : UUserWidget
---@field LevelsVerticalBox UVerticalBox
---@field OwnerProfitShare USettingWidget
---@field DrivablePlayers USettingWidget
---@field ResetToDefaultButton UMTButtonWidget
---@field LevelWidgets TMap<EMTCharacterLevelType, USettingWidget>
---@field Vehicle AMTVehicle
local UCompanyVehicleControlPanelWidget = {}



---@class UCompanyVehicleWidget : UUserWidget
---@field StatusTextBlock URichTextBlock
---@field ConditionTextBlock URichTextBlock
---@field MaintenanceButton UMTButtonWidget
---@field RemoveButton UMTButtonWidget
---@field CurrentRouteWidget UWidget
---@field CurrentRouteTextBlock URichTextBlock
---@field RoutePrevButton UMTButtonWidget
---@field RouteNextButton UMTButtonWidget
---@field AssignBusRouteButton UMTButtonWidget
---@field RemoveBusRouteButton UMTButtonWidget
---@field AssignTruckRouteButton UMTButtonWidget
---@field RemoveTruckRouteButton UMTButtonWidget
---@field NotifyCargoDeliveryCheckBox UCheckBoxWidget
---@field TowToRoadButton UMTButtonWidget
---@field DespawnButton UMTButtonWidget
---@field RightSideRichTextBlock URichTextBlock
---@field CargoListWidget ULoadedCargoListWidget
local UCompanyVehicleWidget = {}

---@param VehicleName FText
function UCompanyVehicleWidget:ReceiveSetVehicleName(VehicleName) end


---@class UCompanyVehiclesEntryWidget : UMTListViewEntryWidget
---@field VehicleBox UWidget
---@field BuySlotButton UMTButtonWidget
---@field VehicleNameTextBlock UTextBlock
---@field StatusTextBlock URichTextBlock
---@field ConditionGauge UProgressBarGaugeWidget
---@field MaintenanceButton UMTButtonWidget
---@field ActivateNPCButton UMTButtonWidget
---@field EditButton UMTButtonWidget
local UCompanyVehiclesEntryWidget = {}



---@class UCompanyVehiclesWidget : UUserWidget
---@field StatusTextBlock URichTextBlock
---@field RefreshAllButton UMTButtonWidget
---@field SortButton_Number UMTButtonWidget
---@field SortButton_Name UMTButtonWidget
---@field SortButton_Condition UMTButtonWidget
---@field VehiclesListView UMTListView
---@field AddButton UMTButtonWidget
---@field AddSlotButton UMTButtonWidget
local UCompanyVehiclesWidget = {}



---@class UCompanyWidget : UUserWidget
---@field MoneyWidgetClass TSubclassOf<UCompanyMoneyWidget>
---@field CompanyNameTextBlock URichTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field TabMenu UTabMenuTemplateWidget
---@field VehiclesWidget UCompanyVehiclesWidget
---@field DepotsWidget UCompanyDepotsWidget
---@field VehiclesMapMessageBox UWidget
---@field VehiclesMapMessageTextBlock URichTextBlock
---@field BusRoutesWidget UCompanyBusRoutesWidget
---@field TruckRoutesWidget UCompanyTruckRoutesWidget
---@field VehiclesMapWidget UWorldMapWidget
---@field DepotsMapWidget UWorldMapWidget
---@field BusRoutesMapWidget UWorldMapWidget
---@field TruckRoutesMapWidget UWorldMapWidget
---@field MapBusStopCheckBox UCheckBoxWidget
---@field PlayersWidget UCompanyPlayersWidget
---@field AdminWidget UCompanyAdminWidget
---@field ContractInProgressListView UMTListView
---@field MoneyButton UMTButtonWidget
local UCompanyWidget = {}



---@class UConstructionMaterialEntryWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field NumberTextBlock UTextBlock
local UConstructionMaterialEntryWidget = {}



---@class UConstructionWidget : UUserWidget
---@field DestructionButton UMTButtonWidget
---@field MaterialsListView UMTListView
---@field Building AMTBuilding
local UConstructionWidget = {}



---@class UContractEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock UTextBlock
---@field DescTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field SelectButton UMTButtonWidget
local UContractEntryWidget = {}



---@class UContractInProgressEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock URichTextBlock
---@field DescTextBlock UTextBlock
---@field SetAsDestinationButton UMTButtonWidget
---@field OnlineAccessButton UMTButtonWidget
local UContractInProgressEntryWidget = {}



---@class UControlPanelCargoListWidget : UUserWidget
---@field CargoList ULoadedCargoListWidget
---@field TowingList UTowingVehicleListWidget
---@field Vehicle AMTVehicle
---@field MapWidget UWorldMapWidget
local UControlPanelCargoListWidget = {}



---@class UControlPanelWidget : UUserWidget
---@field InfoRichTextBlock URichTextBlock
---@field ButtonsVerticalBox UVerticalBox
---@field ButtonsScrollBox UMTScrollBox
---@field ControlPanel UMTControlPanel
---@field buttons TArray<UMTButtonWidget>
local UControlPanelWidget = {}



---@class UControlSettingsWidget : UUserWidget
---@field ActionKeyMappingWidgetClass TSubclassOf<UActionKeyMappingWidget>
---@field DrivingKeyboardButton UMTButtonWidget
---@field DrivingKeyboardAndMouseButton UMTButtonWidget
---@field DrivingGamepadButton UMTButtonWidget
---@field DrivingSteeringWheelButton UMTButtonWidget
---@field DrivingKeyboardWidget UKeyboardDrivingSettingWidget
---@field DrivingKeyboardAndMouseWidget UKeyboardAndMouseDrivingSettingWidget
---@field DrivingGamepadWidget UGamepadDrivingSettingWidget
---@field DrivingSteeringWheelWidget USteeringWheelSettingWidget
---@field DrivingSwitcher UWidgetSwitcher
---@field DrivingCommonEtcVerticalBox UVerticalBox
---@field GamepadVerticalBox UVerticalBox
---@field ShifterVerticalBox UVerticalBox
---@field CharacterMovementVerticalBox UVerticalBox
---@field CharacterQuickbarVerticalBox UVerticalBox
---@field VehicleKeysVerticalBox UVerticalBox
---@field ViewKeysVerticalBox UVerticalBox
---@field UIKeysVerticalBox UVerticalBox
---@field ResetButton UMTButtonWidget
---@field SelectedPresetNameTextBlock URichTextBlock
---@field PresetLoadButton UMTButtonWidget
---@field PresetSaveButton UMTButtonWidget
---@field PresetSaveAsButton UMTButtonWidget
---@field PresetDeleteButton UMTButtonWidget
---@field ActionKeyMappingWidgets TArray<UActionKeyMappingWidget>
---@field CommonActionKeyMappingWidgets TArray<UActionKeyMappingWidget>
local UControlSettingsWidget = {}



---@class UControlWidget : UUserWidget
---@field IconsBox UPanelWidget
---@field NameTextBlock UTextBlock
---@field KeyIconWidgetClass TSubclassOf<UKeyIconWidget>
---@field bIsActivated boolean
local UControlWidget = {}



---@class UCouponListEntryWidget : UMTListViewEntryWidget
---@field CouponTextBlock UTextBlock
---@field DeleteButton UMTButtonWidget
local UCouponListEntryWidget = {}



---@class UCouponListObject : UObject
local UCouponListObject = {}


---@class UCouponListWidget : UUserWidget
---@field CouponListView UMTListView
local UCouponListWidget = {}



---@class UCreateCompanyWidget : UUserWidget
---@field CompanyNameTextBlock UEditableTextBox
---@field CorpCheckBox UCheckBoxWidget
---@field CorpHelpTextBlock URichTextBlock
---@field CorpNotAllowedTextBlock URichTextBlock
---@field OkButton UMoneyButtonWidget
local UCreateCompanyWidget = {}

---@param Text FText
function UCreateCompanyWidget:HandleNameTextBoxChanged(Text) end


---@class UCreditWidget : UUserWidget
local UCreditWidget = {}


---@class UDashboardMFDWidget : UUserWidget
---@field GasolineIconBrush FSlateBrush
---@field ElectricIconBrush FSlateBrush
---@field Vehicle AMTVehicle
local UDashboardMFDWidget = {}

---@param bOn boolean
function UDashboardMFDWidget:ReceiveTCSOff(bOn) end
---@param bOn boolean
function UDashboardMFDWidget:ReceiveTCS(bOn) end
---@param InVehicle AMTVehicle
function UDashboardMFDWidget:ReceiveSetVehicle(InVehicle) end
---@param bOn boolean
function UDashboardMFDWidget:ReceiveRightTurnSignalLight(bOn) end
---@param bOn boolean
function UDashboardMFDWidget:ReceiveOverHeat(bOn) end
---@param bOn boolean
function UDashboardMFDWidget:ReceiveLowFuel(bOn) end
---@param bOn boolean
function UDashboardMFDWidget:ReceiveLeftTurnSignalLight(bOn) end
---@param bOn boolean
---@param bHighBeam boolean
function UDashboardMFDWidget:ReceiveHeadLight(bOn, bHighBeam) end
---@param bOn boolean
function UDashboardMFDWidget:ReceiveHandbrake(bOn) end
---@param Brush FSlateBrush
function UDashboardMFDWidget:ReceiveFuelTypeIconBrush(Brush) end
---@param bOn boolean
function UDashboardMFDWidget:ReceiveESC(bOn) end


---@class UDeliveryEncyclopediaCargoEntryObject : UObject
---@field CargoKey FName
---@field CargoRow FCargoRow
local UDeliveryEncyclopediaCargoEntryObject = {}



---@class UDeliveryEncyclopediaCargoEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock URichTextBlock
local UDeliveryEncyclopediaCargoEntryWidget = {}



---@class UDeliveryEncyclopediaDeliveryPointEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock URichTextBlock
local UDeliveryEncyclopediaDeliveryPointEntryWidget = {}



---@class UDeliveryEncyclopediaProductionEntryObject : UObject
---@field DeliveryPoint AMTDeliveryPoint
local UDeliveryEncyclopediaProductionEntryObject = {}



---@class UDeliveryEncyclopediaProductionEntryWidget : UMTListViewEntryWidget
---@field InputTextBlock URichTextBlock
---@field OutputTextBlock URichTextBlock
---@field TimeLeftTextBlock URichTextBlock
---@field DeliveryPoint AMTDeliveryPoint
local UDeliveryEncyclopediaProductionEntryWidget = {}



---@class UDeliveryEncyclopediaWidget : UUserWidget
---@field StringSearchBox UStringSearchBoxWidget
---@field DeliveryPointListView UMTListView
---@field DemandListView UMTListView
---@field SupplyListView UMTListView
---@field ProductionListView UMTListView
---@field MapWidget UWorldMapWidget
---@field SelectedDeliveryPoint AMTDeliveryPoint
local UDeliveryEncyclopediaWidget = {}



---@class UDeliveryMissionInteractionWidget : UUserWidget
---@field BG_OnlineAccess UWidget
---@field RightSideTabMenu UTabMenuTemplateWidget
---@field ProductionWidget UWidget
---@field CargoInfoTextBlock URichTextBlock
---@field ProductionTextBlock URichTextBlock
---@field StorageBox UWidget
---@field StorageTextBlock URichTextBlock
---@field DropOffOverlay UOverlay
---@field DropOffTextBlock UTextBlock
---@field DropOffOpenTargetButton UMTButtonWidget
---@field DeliveryListOverlay UOverlay
---@field DeliveryMissionListView UMTListView
---@field MapWidget UWorldMapWidget
---@field VehicleCargoInfo UWidget
---@field VehicleNameTextBlock UTextBlock
---@field StrapButton UMoneyButtonWidget
---@field VehicleCargoTextBlocks URichTextBlock
---@field VehicleCargoWeightTextBlock UTextBlock
---@field ViewportPanel UPanelWidget
---@field HeaderCargoButton UMTButtonWidget
---@field HeaderDestinationButton UMTButtonWidget
---@field HeaderDistanceButton UMTButtonWidget
---@field HeaderPayButton UMTButtonWidget
---@field HeaderAmountButton UMTButtonWidget
---@field HeaderLoadedButton UMTButtonWidget
---@field ProductionListView UListView
---@field LoadedCargoList ULoadedCargoListWidget
---@field ContractInProgressListView UMTListView
---@field ContractList UMTListView
---@field ContractInfoTextBlock URichTextBlock
---@field VehicleWeightRichTextBlock URichTextBlock
---@field OverloadHelpButton UMTButtonWidget
---@field ProductionBuffWidget UWidget
---@field ProductionBuffRichTextBlock URichTextBlock
---@field ProductionSpeedButton UMTButtonWidget
---@field DeliveryPoint AMTDeliveryPoint
---@field Vehicle AMTVehicle
---@field Camera ACameraActor
---@field ShowingCargo AMTCargo
---@field MapSelectedObject UMTDeliveryListObject
local UDeliveryMissionInteractionWidget = {}

---@param Title FText
function UDeliveryMissionInteractionWidget:SetTitle(Title) end
---@param Item UObject
function UDeliveryMissionInteractionWidget:OnItemDoubleClicked(Item) end


---@class UDeliveryMissionListEntryWidget : UMTListViewEntryWidget
---@field CargoNameTextBlock URichTextBlock
---@field NumCargosTextBlock UTextBlock
---@field SenderNameTextBlock UTextBlock
---@field ReceiverNameTextBlock UTextBlock
---@field DistanceTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field MoneyBonusTextBlock UTextBlock
---@field NumLoadedTextBlock UTextBlock
---@field LoadButton UMTButtonWidget
---@field UnloadButton UMTButtonWidget
---@field SetAsDestinationButton UMTButtonWidget
---@field ExpireOverlay UOverlay
---@field ExpireTextBlock URichTextBlock
local UDeliveryMissionListEntryWidget = {}

function UDeliveryMissionListEntryWidget:UnloadCargo() end
function UDeliveryMissionListEntryWidget:LoadCargo() end
function UDeliveryMissionListEntryWidget:HandleButtonFocused() end


---@class UDeliveryMissionSideBarWidget : UUserWidget
---@field DeliveryWidgetClass TSubclassOf<UInProgressDeliveryWidget>
---@field DeliveryListVerticalBox UVerticalBox
local UDeliveryMissionSideBarWidget = {}



---@class UDeliveryMissionWidget : UUserWidget
---@field DeliveryWidgetClass TSubclassOf<UDeliveryWidget>
---@field SenderTextBlock UTextBlock
---@field DeliveryListVerticalBox UVerticalBox
---@field MoneyWidget UMTMoneyWidget
local UDeliveryMissionWidget = {}



---@class UDeliveryWidget : UUserWidget
---@field CargoNameTextBlock UTextBlock
---@field NumCargosTextBlock UTextBlock
---@field ReceiverNameTextBlock UTextBlock
---@field DistanceTextBlock UTextBlock
local UDeliveryWidget = {}



---@class UDeviceListWidget : UUserWidget
---@field DeviceListVerticalBox UVerticalBox
---@field RefreshButton UMTButtonWidget
local UDeviceListWidget = {}

function UDeviceListWidget:RefreshList() end


---@class UDialogPopupWidget : UUserWidget
---@field TextScrollBox UScrollBox
---@field MessageTextBlock URichTextBlock
---@field OkButton UMTButtonWidget
---@field CancelButton UMTButtonWidget
local UDialogPopupWidget = {}

function UDialogPopupWidget:HandleOK() end
function UDialogPopupWidget:HandleCancel() end


---@class UDialogueActionEntryWidget : UUserWidget
---@field Button UMTButtonWidget
local UDialogueActionEntryWidget = {}



---@class UDialogueWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field MessageTextBlock URichTextBlock
---@field ActionsListView UListView
---@field DialogueComponent UMTDialogueComponent
local UDialogueWidget = {}



---@class UDigitalSpeedometerWidget : UUserWidget
---@field Vehicle AMTVehicle
---@field SpeedTextBlock UTextBlock
---@field UnitTextBlock UTextBlock
local UDigitalSpeedometerWidget = {}

---@param InVehicle AMTVehicle
function UDigitalSpeedometerWidget:SetVehicle(InVehicle) end


---@class UDriveModeGeneralSettingTabWidget : UUserWidget
---@field GeneralVertialBox UVerticalBox
---@field ResetToDefaultButton UMTButtonWidget
---@field Vehicle AMTVehicle
local UDriveModeGeneralSettingTabWidget = {}



---@class UDriveModeSettingTabWidget : UUserWidget
---@field TransmissionBox UVerticalBox
---@field ThrottleBox UVerticalBox
---@field BrakeBox UVerticalBox
---@field HandBrakeBox UVerticalBox
---@field ResetToDefaultButton UMTButtonWidget
---@field Vehicle AMTVehicle
local UDriveModeSettingTabWidget = {}



---@class UDriveModeSettingWidget : UUserWidget
---@field DriveModeTab UTabMenuTemplateWidget
---@field TabWidgetClass TSubclassOf<UDriveModeSettingTabWidget>
local UDriveModeSettingWidget = {}



---@class UDrivingControlSettingWidget : UUserWidget
---@field MappingWidgetClass TSubclassOf<UActionKeyMappingWidget>
---@field MappingVerticalBox UVerticalBox
---@field MappingWidgets TArray<UActionKeyMappingWidget>
local UDrivingControlSettingWidget = {}



---@class UDrivingHUDWidget : UUserWidget
---@field FuelGaugeWidgetClass TSubclassOf<UProgressBarGaugeWidget>
---@field FuelGaugeIconBrush FSlateBrush
---@field ElectricGaugeIconBrush FSlateBrush
---@field GearWidget UGearWidget
---@field BlinkerRightControlWidget UControlWidget
---@field BlinkerLeftControlWidget UControlWidget
---@field LightWidget UControlWidget
---@field HazardWidget UControlWidget
---@field AutoPilotWidget UControlWidget
---@field SirenWidget UControlWidget
---@field DrivingModeWidget UControlWidget
---@field DiffLockModeWidget UControlWidget
---@field VirtualMirrorControlWidget UControlWidget
---@field SteeringPoint UImage
---@field SteeringFFB UImage
---@field SeatLayoutWidget USeatLayoutWidget
---@field SeatsTextBlock UTextBlock
---@field CargoTextBlock UTextBlock
---@field Cargo_CountImage UImage
---@field Cargo_VolumeImage UImage
---@field RentalWidget URentalStatusWidget
---@field SpeedLimitSignWidget USpeedLimitSignWidget
---@field ComfortWidget UComfortHUDWidget
---@field TimerWidget UTimerWidget
---@field GMeterWidget UGMeterWidget
---@field DashboardMFDWidget UDashboardMFDWidget
---@field FuelGaugesHorizontalBox UHorizontalBox
---@field FuelGauge UProgressBarGaugeWidget
---@field CoolantTempGauge UProgressBarGaugeWidget
---@field BoostGauge UProgressBarGaugeWidget
---@field PassengerAndCargo UWidget
---@field TachoMeter UGaugeWidget
---@field TripMeterWidget UTripMeterWidget
---@field VirtualMirrorLeft UWidget
---@field VirtualMirrorRight UWidget
---@field VirtualMirrorLeftImage UImage
---@field VirtualMirrorRightImage UImage
---@field BodyDamageImage UImage
---@field RadiatorDamageImage UImage
---@field EngineDamageImage UImage
---@field TireDamageImage UImage
---@field BrakePadDamageImage UImage
---@field ExControlWidget UVehicleControlPanelWidget
---@field CruiseControlVerticalBox UVerticalBox
---@field CruiseControlSpeedTextBlock UTextBlock
---@field AutoPilotImage UImage
---@field AverageKPLTextBlock UTextBlock
---@field AverageKPLLabelTextBlock UTextBlock
---@field AvrFuelConsumptionSlider USlider
---@field FuelConsumptionProgressBar UProgressBar
---@field RegenBrakeHorizontalBox UHorizontalBox
---@field RegenBrakeTextBlock UTextBlock
---@field ShifterOverlay UOverlay
---@field DigitalSpeedometer UDigitalSpeedometerWidget
---@field SteeringOverlay UOverlay
---@field PedalsBorder UBorder
---@field ThrottleBar UImage
---@field BrakeBar UImage
---@field ClutchBar UImage
---@field HandbrakeBar UImage
---@field BlinkCruiseControlSpeed UWidgetAnimation
---@field BusStopWidgetClass TSubclassOf<UUserWidget>
---@field BusStopWidget UUserWidget
---@field Vehicle AMTVehicle
---@field ShifterWidget UShifterWidget
local UDrivingHUDWidget = {}

---@param InVehicle AMTVehicle
function UDrivingHUDWidget:SetVehicle(InVehicle) end
---@param InVehicle AMTVehicle
function UDrivingHUDWidget:ReceiveSetVehicle(InVehicle) end


---@class UDrivingSettingWidget : UUserWidget
local UDrivingSettingWidget = {}


---@class UDroneHUDWidget : UUserWidget
---@field FlightCursorImage UImage
---@field TimeLeftTextBlock UTextBlock
---@field HeightTextBlock UTextBlock
---@field DistanceTextBlock UTextBlock
---@field AltSpeedTextBlock UTextBlock
---@field SpeedTextBlock UTextBlock
---@field HeightAGLTextBlock UTextBlock
---@field HeightAGLBox UBorder
---@field ControlUpWidget UControlWidget
---@field ControlDownWidget UControlWidget
---@field ControlSpeedWidget UControlWidget
---@field ControlFlightModeWidget UControlWidget
---@field ControlCameraModeWidget UControlWidget
---@field ControlExitWidget UControlWidget
local UDroneHUDWidget = {}



---@class UDuplicatedKeyMappingItemWidget : UUserWidget
---@field ActionNameTextBlock UTextBlock
---@field DeleteButton UMTButtonWidget
local UDuplicatedKeyMappingItemWidget = {}



---@class UDuplicatedKeyMappingPopupWidget : UUserWidget
---@field MappingItemWidgetClass TSubclassOf<UDuplicatedKeyMappingItemWidget>
---@field KeyNameTextBlock UTextBlock
---@field BindingsVerticalBox UVerticalBox
local UDuplicatedKeyMappingPopupWidget = {}



---@class UDynoWidget : UUserWidget
---@field Plot UCartesianPlot
---@field MaxPowerText UTextBlock
---@field MaxTorqueText UTextBlock
---@field EngineComponent UMTEngineComponent
local UDynoWidget = {}

---@param InEngineComponent UMTEngineComponent
function UDynoWidget:SetEngine(InEngineComponent) end


---@class UEditableTextDialogPopupWidget : UUserWidget
---@field EditableTextBlock UEditableTextBox
---@field OkButton UMTButtonWidget
local UEditableTextDialogPopupWidget = {}

---@param Title FText
function UEditableTextDialogPopupWidget:ReceiveSetTitle(Title) end
---@param Text FText
---@param CommitMethod ETextCommit::Type
function UEditableTextDialogPopupWidget:HandleTextBoxCommitted(Text, CommitMethod) end
---@param Text FText
function UEditableTextDialogPopupWidget:HandleTextBoxChanged(Text) end


---@class UEngineTorqueGraphWidget : UUserWidget
---@field EngineComponent UMTEngineComponent
local UEngineTorqueGraphWidget = {}

---@param InEngineComponent UMTEngineComponent
function UEngineTorqueGraphWidget:SetEngine(InEngineComponent) end


---@class UErrandDeliveryMissionSystem : UObject
---@field MissionSystem AMTDeliverySystem
---@field SenderPoints TArray<AMTDeliveryPoint>
---@field ReceiverPoints TArray<AMTDeliveryPoint>
local UErrandDeliveryMissionSystem = {}



---@class UErrorMessagePopUpWidget : UUserWidget
---@field MessageTextBlock URichTextBlock
local UErrorMessagePopUpWidget = {}



---@class UEventListEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock URichTextBlock
---@field InfoRichTextBlock URichTextBlock
---@field SelectButton UMTButtonWidget
local UEventListEntryWidget = {}



---@class UEventListWidget : UUserWidget
---@field CreateButton UMTButtonWidget
---@field EventListView UMTListView
local UEventListWidget = {}



---@class UEventPlayersEntryWidget : UMTListViewEntryWidget
---@field RankTextBlock URichTextBlock
---@field PlayerLevelAndNameWidget UPlayerLevelAndNameWidget
---@field DetailTextBlock URichTextBlock
---@field MoreButton UMTButtonWidget
local UEventPlayersEntryWidget = {}



---@class UEventResultPlayerEntry : UMTListViewEntryWidget
---@field NameTextBlock UTextBlock
---@field DetailTextBlock URichTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field ExpWidget UExpWidget
local UEventResultPlayerEntry = {}



---@class UEventResultWidget : UUserWidget
---@field TitleTextBlock UTextBlock
---@field PlayerListView UListView
---@field JobLevelProgressWidget ULevelProgressWidget
---@field LevelProgressWidget ULevelProgressWidget
local UEventResultWidget = {}



---@class UEventVehicleRestrictionWidget : UUserWidget
---@field VehicleseVerticalBox UVerticalBox
---@field EnginesVerticalBox UVerticalBox
---@field VehicleCheckBoxes TArray<UCheckBoxWidget>
---@field EngineCheckBoxes TArray<UCheckBoxWidget>
local UEventVehicleRestrictionWidget = {}



---@class UEventWidget : UUserWidget
---@field InfoTextBlock URichTextBlock
---@field SettingsBox UVerticalBox
---@field ReadyButton UMTButtonWidget
---@field StartButton UMTButtonWidget
---@field FinishButton UMTButtonWidget
---@field CloseEventButton UMTButtonWidget
---@field MapWidget UWorldMapWidget
---@field EditMapButton UMTButtonWidget
---@field JoinButton UMTButtonWidget
---@field LeaveButton UMTButtonWidget
---@field PlayersListView UMTListView
---@field VehicleRestrictionWidget UEventVehicleRestrictionWidget
---@field SettingWidgets TArray<USettingWidget>
local UEventWidget = {}



---@class UExpWidget : UUserWidget
---@field LevelTypeImage UImage
---@field ExpTextBlock UTextBlock
local UExpWidget = {}



---@class UFireControlPanelWidget : UUserWidget
---@field FireListView UMTListView
---@field FireMapWidget UWorldMapWidget
---@field SelectedDetailTextBlock URichTextBlock
---@field ShowWhenEnterVehicleCheckBox UCheckBoxWidget
---@field MoveToControlSeatButton UMTButtonWidget
---@field CachedFires TArray<AMTFire>
---@field SelectedObject UMTFireListObject
local UFireControlPanelWidget = {}



---@class UFireEntryWidget : UMTListViewEntryWidget
---@field ReservedFrame UWidget
---@field NameWidget UTextBlock
---@field DistanceToFireWidget UTextBlock
---@field DetailsWidget URichTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field AcceptButton UMTButtonWidget
---@field AssignedWidget UWidget
local UFireEntryWidget = {}



---@class UFriendListEntryWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field StatusTextBlock UTextBlock
---@field JoinButton UMTButtonWidget
local UFriendListEntryWidget = {}



---@class UFriendListWidget : UUserWidget
---@field FriendListView UListView
local UFriendListWidget = {}

function UFriendListWidget:RefreshList() end


---@class UFuelPumpWidget : UUserWidget
---@field SlotHorizontalBox UHorizontalBox
---@field VehicleTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field LiterTextBlock UTextBlock
---@field FuelCostTextBlock UTextBlock
---@field OwnerPayTextBlock UTextBlock
---@field CostLabel UTextBlock
---@field AmountLabel UTextBlock
---@field AvailableBox UWidget
---@field AvailableTextBlock UTextBlock
---@field FillUpButton UMTButtonWidget
---@field ActorName FText
---@field FuelPump UMTFuelPumpComponent
---@field TankerFuelPump UMTTankerFuelPumpComponent
---@field FuelPumpActor AActor
---@field Vehicle AMTVehicle
---@field CargoSpace UMTVehicleCargoSpaceComponent
---@field FuelTypeButtons TMap<EMTFuelType, UMTButtonWidget>
local UFuelPumpWidget = {}

function UFuelPumpWidget:ReceiveStartInteraction() end
function UFuelPumpWidget:FillUp() end


---@class UGMeterWidget : UUserWidget
---@field FrameCanvasPanel UPanelWidget
---@field BallImage UImage
---@field Vehicle AMTVehicle
local UGMeterWidget = {}



---@class UGameUserSettingsWidget : UUserWidget
---@field ApplyStuntDriverButton UMTButtonWidget
local UGameUserSettingsWidget = {}



---@class UGamepadDrivingSettingWidget : UDrivingControlSettingWidget
---@field RumbleEngineStrengthSpinBox USpinBoxString
---@field RumbleTireStrengthSpinBox USpinBoxString
---@field InvertCameraVerticalSpinBox USpinBoxString
local UGamepadDrivingSettingWidget = {}

---@param SpinBoxString USpinBoxString
function UGamepadDrivingSettingWidget:HandleOptionSpinBoxChanged(SpinBoxString) end


---@class UGameplaySettingWidget : UUserWidget
---@field ResetToDefaultButton UMTButtonWidget
---@field SettingWidgetClass TSubclassOf<UUserSettingItemWidget>
---@field SettingsVerticalBox UVerticalBox
---@field GeneralVerticalBox UVerticalBox
---@field ViewVerticalBox UVerticalBox
---@field HUDVerticalBox UVerticalBox
---@field HeadTrackingVerticalBox UVerticalBox
---@field ResetHelpHistoryButton UMTButtonWidget
---@field SettingWidgets TMap<EMTUserSettingType, UUserSettingItemWidget>
local UGameplaySettingWidget = {}



---@class UGarageChangeCarWidget : UGarageChildWidget
---@field MyCarsSpinBox USpinBoxString
---@field ChangeCarButton UMTButtonWidget
local UGarageChangeCarWidget = {}



---@class UGarageChildWidget : UUserWidget
---@field GarageActor AMTGarageActor
---@field Vehicle AMTVehicle
local UGarageChildWidget = {}



---@class UGarageDecalEditModeWidget : UUserWidget
---@field DecalTextureImage UImage
---@field SelectDecalButton UMTButtonWidget
---@field SelectColorButton UMTButtonWidget
---@field OptionButton UMTButtonWidget
---@field ControlsVerticalBox UVerticalBox
---@field SelectDecalWidgetClass TSubclassOf<UGarageSelectDecalWidget>
---@field SelectColorWidgetClass TSubclassOf<UGaragePaintColorPickerWidget>
---@field OptionWidgetClass TSubclassOf<UGarageDecalOptionWidget>
---@field ControlWidgetClass TSubclassOf<UControlWidget>
---@field Vehicle AMTVehicle
---@field DecalComp UMTDecalComponent
local UGarageDecalEditModeWidget = {}



---@class UGarageDecalLayerEntryWidget : UMTListViewEntryWidget
---@field TextureImage UImage
---@field EditButton UMTButtonWidget
---@field UpButton UMTButtonWidget
---@field DownButton UMTButtonWidget
---@field TopButton UMTButtonWidget
---@field BottomButton UMTButtonWidget
---@field DeleteButton UMTButtonWidget
local UGarageDecalLayerEntryWidget = {}



---@class UGarageDecalOptionWidget : UGarageChildWidget
---@field SelectColorWidgetClass TSubclassOf<UGaragePaintColorPickerWidget>
---@field SelectColorButton UMTButtonWidget
---@field NoBackFaceCheckBox UCheckBoxWidget
---@field NoOppositeSideCheckBox UCheckBoxWidget
---@field DrawOnWheelCheckBox UCheckBoxWidget
---@field DecalComp UMTDecalComponent
local UGarageDecalOptionWidget = {}



---@class UGarageDecalWidget : UGarageChildWidget
---@field LayersListView UMTListView
---@field AddButton UMTButtonWidget
---@field ConfirmButton UMoneyButtonWidget
---@field NumLayersTextBlock UTextBlock
---@field NumMaxLayersTextBlock UTextBlock
---@field SelectDecalWidgetClass TSubclassOf<UGarageSelectDecalWidget>
---@field EditModelWidgetClass TSubclassOf<UGarageDecalEditModeWidget>
---@field DecalComp UMTDecalComponent
---@field CameraActor ACameraActor
local UGarageDecalWidget = {}

function UGarageDecalWidget:HandleBack() end


---@class UGarageImportEntryWidget : UGarageChildWidget
---@field CheckBox UCheckBoxWidget
---@field MoneyWidget UMTMoneyWidget
---@field ParentWidget UGarageWorkshopImportConfirmWidget
local UGarageImportEntryWidget = {}



---@class UGarageImportExportWidget : UGarageChildWidget
---@field MenuSwitcher UWidgetSwitcher
---@field ImportExportMenu UWidget
---@field ConfirmMenu UWidget
---@field BrowseMenu UWidget
---@field BrowseButton UMTButtonWidget
---@field ExportButton UMTButtonWidget
---@field ImportButton UMTButtonWidget
---@field ImportSelectionVerticalBox UVerticalBox
---@field BrowseLeftButton UMTButtonWidget
---@field BrowseRightButton UMTButtonWidget
---@field WorkshopEntriesBox UHorizontalBox
---@field WorkshopListView UMTListView
---@field BrowseDetailBox UWidget
---@field DeleteButton UMTButtonWidget
---@field LikeButton UMTButtonWidget
---@field ReportButton UMTButtonWidget
---@field ApplyButton UMTButtonWidget
---@field BrowseDetailTextBlock URichTextBlock
---@field MyCheckBox UCheckBoxWidget
---@field LikedCheckBox UCheckBoxWidget
---@field SearchEditableTextBox UEditableTextBox
---@field ClearSearchButton UMTButtonWidget
---@field WorkshopEntryWidgetClass TSubclassOf<UGarageWorkShopEntryWidget>
---@field ImportEntryClass TSubclassOf<UGarageImportEntryWidget>
---@field ImportConfirmWidgetClass TSubclassOf<UGarageWorkshopImportConfirmWidget>
---@field WorkshopEntryWidgets TArray<UGarageWorkShopEntryWidget>
local UGarageImportExportWidget = {}

---@param Text FText
---@param CommitMethod ETextCommit::Type
function UGarageImportExportWidget:HandleTextCommitted(Text, CommitMethod) end
---@param Text FText
function UGarageImportExportWidget:HandleSearchTextChanged(Text) end


---@class UGaragePaintColorPickerWidget : UGarageChildWidget
---@field ColorPicker UColorPicker2Widget
---@field PaintWidget UGaragePaintWidget
local UGaragePaintColorPickerWidget = {}



---@class UGaragePaintWidget : UGarageChildWidget
---@field ColorButtonWidgetClass TSubclassOf<UMTButtonWidget>
---@field ColorPickerWidgetClass TSubclassOf<UGaragePaintColorPickerWidget>
---@field BodyMaterialIndexSpinBox USpinBoxString
---@field ColorsVerticalBox UVerticalBox
---@field ConfirmButton UMTButtonWidget
---@field ColorButtons TMap<FName, UMTButtonWidget>
---@field ColorPickerWidget UGaragePaintColorPickerWidget
local UGaragePaintWidget = {}

---@param SpinBoxString USpinBoxString
function UGaragePaintWidget:HandleBodyMaterialChange(SpinBoxString) end


---@class UGaragePartEntryWidget : UMTListViewEntryWidget
---@field PopupWidgetClass TSubclassOf<UGaragePartPopupWidget>
---@field InstallWidgetClass TSubclassOf<UGaragePartInstallWidget>
---@field NameTextBlock UTextBlock
---@field InstalledWidget UWidget
---@field OwnedWidget UWidget
---@field OwnCountTextBlock UTextBlock
local UGaragePartEntryWidget = {}



---@class UGaragePartInfoWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field InfoTextBlock URichTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field Vehicle AMTVehicle
local UGaragePartInfoWidget = {}



---@class UGaragePartInstallMoreWidget : UUserWidget
---@field SlotNameTextBlock UTextBlock
---@field InstallButton UMTButtonWidget
---@field UninstallButton UMTButtonWidget
---@field Vehicle AMTVehicle
local UGaragePartInstallMoreWidget = {}



---@class UGaragePartInstallWidget : UGarageChildWidget
---@field InstallMoreWidgetClass TSubclassOf<UGaragePartInstallMoreWidget>
---@field PartNameRichTextBlock URichTextBlock
---@field OwnCountRichTextBlock URichTextBlock
---@field BuyButton UMoneyButtonWidget
---@field SellButton UMoneyButtonWidget
---@field InstallSpinBoxString USpinBoxString
---@field InstallButton UMTButtonWidget
---@field UninstallSpinBoxString USpinBoxString
---@field UninstallButton UMTButtonWidget
---@field InstallMoreVerticalBox UVerticalBox
---@field InstallMoreSlotsVerticalBox UVerticalBox
local UGaragePartInstallWidget = {}



---@class UGaragePartListWidget : UUserWidget
---@field bShowInventry boolean
---@field bShowShop boolean
---@field PartsListView UMTListView
---@field GarageActor AMTGarageActor
---@field Vehicle AMTVehicle
local UGaragePartListWidget = {}



---@class UGaragePartPopupWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field UninstallButton UMTButtonWidget
---@field InstallButton UMTButtonWidget
---@field BuyButton UMTButtonWidget
---@field BuyAndInstallButton UMTButtonWidget
---@field SellButton UMTButtonWidget
---@field CloseButton UMTButtonWidget
local UGaragePartPopupWidget = {}

function UGaragePartPopupWidget:OnUninstall() end
function UGaragePartPopupWidget:OnSell() end
function UGaragePartPopupWidget:OnInstall() end
function UGaragePartPopupWidget:OnClose() end


---@class UGaragePartWidget : UGarageChildWidget
---@field PartListWidget UGaragePartListWidget
---@field PartInfoWidget UGaragePartInfoWidget
---@field DynoWidget UDynoWidget
local UGaragePartWidget = {}

function UGaragePartWidget:HandlePlayerVehiclePartsChanged() end


---@class UGaragePartsWidget : UGarageChildWidget
---@field PartWidgetClass TSubclassOf<UGaragePartWidget>
---@field PartButtonWidgetClass TSubclassOf<UMTButtonWidget>
---@field PartsVerticalBox UVerticalBox
---@field DynoWidget UDynoWidget
---@field buttons UMTButtonWidget
local UGaragePartsWidget = {}



---@class UGarageRepairEntryWidget : UMTListViewEntryWidget
---@field PartTypeNameTextBlock UTextBlock
---@field PartNameTextBlock UTextBlock
---@field DamageTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field RepairButton UMTButtonWidget
---@field ReplaceButton UMTButtonWidget
local UGarageRepairEntryWidget = {}



---@class UGarageRepairWidget : UGarageChildWidget
---@field RepairListView UMTListView
---@field OwnerPayTextBlock UTextBlock
---@field RepairAllButton UMTButtonWidget
---@field ReplaceAllTiresButton UMTButtonWidget
local UGarageRepairWidget = {}



---@class UGarageSelectDecalSlotWidget : UUserWidget
---@field TextureImage UImage
---@field HighlightWidget UBorder
local UGarageSelectDecalSlotWidget = {}



---@class UGarageSelectDecalWidget : UUserWidget
---@field SlotWidgetClass TSubclassOf<UGarageSelectDecalSlotWidget>
---@field DecalsWrapBox UWrapBox
---@field SelectButton UMTButtonWidget
---@field SelectedDecalInfoVerticalBox UWidget
---@field SelectedDecalImage UImage
---@field SelectedOwnCountTextBlock URichTextBlock
---@field SelectedDecalPrice UMTMoneyWidget
---@field SelectedSlotWidget UGarageSelectDecalSlotWidget
local UGarageSelectDecalWidget = {}



---@class UGarageWidget : UUserWidget
---@field RepairWidgetClass TSubclassOf<UGarageChildWidget>
---@field PaintWidgetClass TSubclassOf<UGarageChildWidget>
---@field DecalWidgetClass TSubclassOf<UGarageDecalWidget>
---@field PartsWidgetClass TSubclassOf<UGarageChildWidget>
---@field ChangeNameWidgetClass TSubclassOf<UGarageChildWidget>
---@field WorkshopWidgetClass TSubclassOf<UGarageImportExportWidget>
---@field DynoWidget UDynoWidget
---@field ChangeCarButton UMTButtonWidget
---@field RepairButton UMTButtonWidget
---@field PaintButton UMTButtonWidget
---@field DecalButton UMTButtonWidget
---@field PartsButton UMTButtonWidget
---@field NameButton UMTButtonWidget
---@field WorkshopButton UMTButtonWidget
---@field WorkshopUploadButton UMTButtonWidget
---@field GarageActor AMTGarageActor
---@field Vehicle AMTVehicle
local UGarageWidget = {}

---@param Actor AActor
---@param EndPlayReason EEndPlayReason::Type
function UGarageWidget:HandleVehicleRemoved(Actor, EndPlayReason) end


---@class UGarageWorkShopEntryWidget : UMTListViewEntryWidget
---@field IdTextBlock UTextBlock
---@field AuthorTextBlock UTextBlock
---@field DetailTextBlock URichTextBlock
---@field RightSideDetailTextBlock URichTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field PreviewImageWidget UImage
---@field ActorPreview AMTActorPreview
local UGarageWorkShopEntryWidget = {}

---@return int32
function UGarageWorkShopEntryWidget:GetNumLiked() end


---@class UGarageWorkshopImportConfirmWidget : UGarageChildWidget
---@field ConfirmMenu UWidget
---@field ConfirmButton UMoneyButtonWidget
---@field ImportSelectionVerticalBox UVerticalBox
---@field EntryDetailWidget UWidget
---@field EntryDetailTextBlock URichTextBlock
---@field ImportEntryClass TSubclassOf<UGarageImportEntryWidget>
---@field EntryWidgets TArray<UGarageImportEntryWidget>
local UGarageWorkshopImportConfirmWidget = {}



---@class UGaugeBackgroundWidget : UUserWidget
---@field GaugeWidget UGaugeWidget
local UGaugeBackgroundWidget = {}



---@class UGaugeTextWidget : UUserWidget
local UGaugeTextWidget = {}

---@param InText FText
function UGaugeTextWidget:SetText(InText) end
---@param Scale float
function UGaugeTextWidget:SetScale(Scale) end


---@class UGaugeWidget : UUserWidget
---@field GaugeCanvas UCanvasPanel
---@field BackgroundRetainer URetainerBox
---@field BackgroundCanvas UCanvasPanel
---@field Text1TextBlock UTextBlock
---@field TextWidgetClass TSubclassOf<UGaugeTextWidget>
---@field NiddleWidgetClass TSubclassOf<UUserWidget>
---@field LineWidgetClass TSubclassOf<UUserWidget>
---@field MinValue float
---@field MaxValue float
---@field ValueScale float
---@field TextStep float
---@field LineStep float
---@field TextScale float
---@field LineSize FVector2D
---@field Radius float
---@field LineRadius float
---@field NiddleRadius float
---@field StartDegree float
---@field EndDegree float
---@field MinValueText FText
---@field MaxValueText FText
---@field Zones TArray<FMTGaugeZone>
---@field TextWidgets TArray<UGaugeTextWidget>
---@field LineWidgets TArray<UUserWidget>
---@field NiddleWidget UUserWidget
---@field NiddleSizeBox USizeBox
---@field NiddleSlot UCanvasPanelSlot
---@field BackgroundWidget UGaugeBackgroundWidget
local UGaugeWidget = {}

---@param Value float
function UGaugeWidget:SetValue(Value) end


---@class UGearWidget : UUserWidget
---@field GearTextBlock UTextBlock
---@field AutoGearTextBlock UTextBlock
---@field transmission UMHTransmissionComponent
local UGearWidget = {}



---@class UGraphicSettingsWidget : UUserWidget
---@field ResolutionSetting USettingWidget
---@field WindowedModeSetting USettingWidget
---@field AntiAliasingMethodSetting USettingWidget
---@field QualityLevelSpinBox USpinBoxString
---@field ResolutionScaleSpinBox USpinBoxString
---@field ViewDistanceSetting USettingWidget
---@field AntiAliasingSetting USettingWidget
---@field ShadowSetting USettingWidget
---@field GlobalIlluminationSetting USettingWidget
---@field ReflectionSetting USettingWidget
---@field PostProcessSetting USettingWidget
---@field TextureSetting USettingWidget
---@field EffectsSetting USettingWidget
---@field FoliageSetting USettingWidget
---@field ShadingSetting USettingWidget
---@field QualitySubSettings TArray<USettingWidget>
---@field ShowMirrorSpinBox USpinBoxString
---@field VehicleLODSetting UUserSettingItemWidget
---@field FPSLimitSpinBox USpinBoxString
---@field VSyncSpinBox USpinBoxString
---@field ChaseCameraFOVSpinBox USpinBoxString
---@field CockpitCameraFOVSpinBox USpinBoxString
---@field SettingsVerticalBox UVerticalBox
---@field ApplyButton UMTButtonWidget
---@field ResolutionConfirmDialog UDialogPopupWidget
local UGraphicSettingsWidget = {}

function UGraphicSettingsWidget:Apply() end


---@class UHUDDestinationWidget : UUserWidget
local UHUDDestinationWidget = {}


---@class UHUDPlayerListWidget : UUserWidget
---@field PlayerListView UListView
---@field PlayerStates TArray<AMotorTownPlayerState>
local UHUDPlayerListWidget = {}

---@param PlayerState AMotorTownPlayerState
function UHUDPlayerListWidget:HandlePlayerStateRemoved(PlayerState) end
---@param PlayerState AMotorTownPlayerState
function UHUDPlayerListWidget:HandlePlayerStateAdded(PlayerState) end


---@class UHelpEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock URichTextBlock
local UHelpEntryWidget = {}



---@class UHelpWidget : UUserWidget
---@field CargoEncyclopediaTabIndex int32
---@field DeliveryEncyclopediaTabIndex int32
---@field HelpListView UMTListView
---@field HelpDescRichTextBlock URichTextBlock
---@field CargoEncyclopediaWidget UCargoEncyclopediaWidget
---@field DeliveryEncyclopediaWidget UDeliveryEncyclopediaWidget
local UHelpWidget = {}

---@param Index int32
function UHelpWidget:ReceiveSetTabIndex(Index) end


---@class UHitchhikerInteractionWidget : UUserWidget
---@field MessageTextBlock URichTextBlock
---@field MapWidget UWorldMapWidget
---@field OkButton UMTButtonWidget
---@field Hitchhiker AMTCharacter
local UHitchhikerInteractionWidget = {}



---@class UHostOptionWidget : UUserWidget
---@field AllowJoinSpinBox USpinBoxString
---@field UseUPNP USpinBoxString
---@field IPSpinBox USpinBoxString
---@field MaxPlayersSpinBox USpinBoxString
local UHostOptionWidget = {}



---@class UHousingManagementWidget : UUserWidget
---@field OwnerNameTextBlock UTextBlock
---@field RentDueTextBlock UTextBlock
---@field RentDueHorizontalBox UHorizontalBox
---@field PayRentButton UMTButtonWidget
---@field TerminateButton UMTButtonWidget
---@field House AMTHouse
local UHousingManagementWidget = {}



---@class UIconImageWidget : UUserWidget
local UIconImageWidget = {}

---@param IconType EMTIconType
---@param bDisabled boolean
function UIconImageWidget:ReceiveSetIconType(IconType, bDisabled) end
---@param Color FLinearColor
function UIconImageWidget:ReceiveOverrideColor(Color) end


---@class UIconWidget : UUserWidget
---@field IconImage UIconImageWidget
---@field LowTextOverlay UOverlay
---@field LowTextBlock URichTextBlock
---@field IconType EMTIconType
local UIconWidget = {}



---@class UInGameAutocrossSettingWidget : UUserWidget
---@field GhostCarVisibilitySpinBox USpinBoxString
---@field DeleteGhostButton UMTButtonWidget
local UInGameAutocrossSettingWidget = {}

---@param SpinBoxString USpinBoxString
function UInGameAutocrossSettingWidget:OnGhostCarVisibilitySpinBoxChanged(SpinBoxString) end
function UInGameAutocrossSettingWidget:OnDeleteGhostButtonClicked() end


---@class UInGameHUDWidget : UUserWidget
---@field DestinationWidgetClass TSubclassOf<UHUDDestinationWidget>
---@field CompanyAlarmWidgetClass TSubclassOf<UJobStatusEntryWidget>
---@field BusStopWidgetClass TSubclassOf<UUserWidget>
---@field RootCanvasPanel UCanvasPanel
---@field DrivingHUD UDrivingHUDWidget
---@field DroneHUD UDroneHUDWidget
---@field SystemMessageTextBlock UTextBlock
---@field Chat UChatWidget
---@field Money UWidget
---@field MissionWidgetSwitcher UWidgetSwitcher
---@field TimeAttack ULaptimeFrameWidget
---@field Delivery UDeliveryMissionSideBarWidget
---@field RaceLapsAndPos UWidget
---@field MinimapWidget UMinimapWidget
---@field MinimapTimeTextBlock UTextBlock
---@field MinimapDistanceTextBlock UTextBlock
---@field MinimapAreaNameTextBlock UTextBlock
---@field ActionPopup UActionPopupWidget
---@field FPSTextBlock UTextBlock
---@field SuspectBuffWidget UBuffWidget
---@field QuestFrame UQuestFrameWidget
---@field TimeAttackEventOverlay UOverlay
---@field TimeAttackEventConditionRichTextBlock URichTextBlock
---@field TimeAttackEventTimerTextBlock UTextBlock
---@field RaceEventOverlay UOverlay
---@field RaceEventNameTextBlock UTextBlock
---@field RaceEventInfoTextBlock URichTextBlock
---@field PlayerList UHUDPlayerListWidget
---@field RacePositionList URacePositionListWidget
---@field ComfortWidget UComfortHUDWidget
---@field TimerWidget UTimerWidget
---@field CargoTimer UCargoTimerHUDWidget
---@field CargoDamage UJobStatusEntryWidget
---@field CompanyAlarm UJobStatusEntryWidget
---@field PoliceStatus_Patrol UJobStatusEntryWidget
---@field PoliceStatus_Suspect UJobStatusEntryWidget
---@field HelpWidget UWidget
---@field HelpTextImageBlock URichTextBlock
---@field HelpTextBlock URichTextBlock
---@field HelpCloseTextBlock URichTextBlock
---@field QuickbarWidget UQuickbarWidget
---@field ExpSplashTextBlock URichTextBlock
---@field CrosshairImage UImage
---@field CrosshairText URichTextBlock
---@field CrosshairTooltipNamedSlot UNamedSlot
---@field LeftVirtualMirrorSpacer USpacer
---@field ProgressBarBorder UBorder
---@field ProgressBar UProgressBar
---@field DamageBarBorder UBorder
---@field DamageProgressBar UProgressBar
---@field ControlPanelWidget UControlPanelWidget
---@field JobStatus UVerticalBox
---@field PulseExpSplash UWidgetAnimation
---@field WidgetPool FUserWidgetPool
---@field CrosshairTooltipWidget UWidget
local UInGameHUDWidget = {}

---@param Message FText
---@param exp int32
function UInGameHUDWidget:ShowExperienceSplash(Message, exp) end
---@param Pawn APawn
function UInGameHUDWidget:SetPawn(Pawn) end
function UInGameHUDWidget:ReceiveShowSystemMessage() end


---@class UInGameMenuDeliveriesWidget : UUserWidget
---@field DeliveryListView UListView
local UInGameMenuDeliveriesWidget = {}



---@class UInGameMenuWidget : UUserWidget
---@field RespawnButton UMTButtonWidget
---@field RaceSettingButton UMTButtonWidget
---@field TimeAttackSettingButton UMTButtonWidget
---@field AutocrossSettingButton UMTButtonWidget
---@field VehicleSettingButton UMTButtonWidget
---@field ContentSwitcher UWidgetSwitcher
---@field TabMenu UTabMenuTemplateWidget
---@field DrivingContent UUserWidget
---@field CompanyList UWidget
---@field ExitToMenuButton UMTButtonWidget
---@field Help_CorporationTextBlock URichTextBlock
local UInGameMenuWidget = {}



---@class UInGameRaceSettingWidget : UUserWidget
---@field RaceSettingWidget URaceSettingWidget
---@field RestartButton UMTButtonWidget
local UInGameRaceSettingWidget = {}

function UInGameRaceSettingWidget:OnRestartClicked() end


---@class UInGameTimeAttackSettingWidget : UUserWidget
---@field GhostCarVisibilitySpinBox USpinBoxString
---@field DeleteGhostButton UMTButtonWidget
local UInGameTimeAttackSettingWidget = {}

---@param SpinBoxString USpinBoxString
function UInGameTimeAttackSettingWidget:OnGhostCarVisibilitySpinBoxChanged(SpinBoxString) end
function UInGameTimeAttackSettingWidget:OnDeleteGhostButtonClicked() end


---@class UInGameVehicleSettingWidget : UUserWidget
---@field VehiclesSpinBox USpinBoxString
---@field ChangeVehicleButton UMTButtonWidget
local UInGameVehicleSettingWidget = {}

function UInGameVehicleSettingWidget:OnChangeVehicleButtonClicked() end


---@class UInProgressDeliveryMissionWidget : UUserWidget
---@field DeliveryWidgetClass TSubclassOf<UInProgressDeliveryWidget>
---@field DeliveryListVerticalBox UVerticalBox
---@field CancelButton UMTButtonWidget
local UInProgressDeliveryMissionWidget = {}

function UInProgressDeliveryMissionWidget:OnCancelDelivery() end


---@class UInProgressDeliveryWidget : UUserWidget
---@field CargoNameTextBlock UTextBlock
---@field NumCargosTextBlock UTextBlock
---@field ReceiverNameTextBlock UTextBlock
---@field DistanceTextBlock UTextBlock
---@field StatusTextBlock UTextBlock
---@field Direction UWidget
---@field Receiver AMTDeliveryPoint
local UInProgressDeliveryWidget = {}



---@class UInProgressScreenBlockerWidget : UUserWidget
---@field MessageTextBlock UTextBlock
local UInProgressScreenBlockerWidget = {}



---@class UInputKeyWidget : UUserWidget
---@field KeyNameTextBlock UTextBlock
---@field KeyboardBackground UBorder
---@field Pad_Back UUserWidget
---@field DefaultActionName FName
local UInputKeyWidget = {}



---@class UInteractionListEntryWidget : UUserWidget
local UInteractionListEntryWidget = {}


---@class UInteractionListWidget : UUserWidget
---@field InteractionButtonClass TSubclassOf<UMTButtonWidget>
---@field InteractionsVerticalBox UVerticalBox
---@field CargoInfoTooltip UCargoInfoTooltipWidget
---@field InteractableComponents TArray<UMTInteractableComponent>
---@field HighlightedInteractable UMTInteractableComponent
local UInteractionListWidget = {}



---@class UInternetRadioEntryWidget : UUserWidget
---@field NameTextBlock UTextBlock
local UInternetRadioEntryWidget = {}



---@class UInventorySlotWidget : UUserWidget
---@field DragWidgetClass TSubclassOf<UItemWidget>
---@field Overlay UOverlay
---@field ItemWidget UItemWidget
---@field HoldingHighlight UBorder
---@field InventoryWidget UInventoryWidget
local UInventorySlotWidget = {}



---@class UInventoryWidget : UUserWidget
---@field SlotWidgetClass TSubclassOf<UInventorySlotWidget>
---@field SlotsWrapBox UWrapBox
---@field SlotWidgets TArray<UInventorySlotWidget>
---@field InventoryAccesor UMTItemInventoryAccessor
local UInventoryWidget = {}



---@class UItemWidget : UUserWidget
---@field NumStackTextBlock UTextBlock
---@field IconImage UImage
local UItemWidget = {}

function UItemWidget:SetMiniSize() end


---@class UJobListObject : UObject
local UJobListObject = {}


---@class UJobStatusEntryWidget : UUserWidget
---@field NameTextBlock URichTextBlock
---@field ValueTextBlock URichTextBlock
local UJobStatusEntryWidget = {}



---@class UJobWidget : UUserWidget
---@field Delivery UDeliveryMissionWidget
local UJobWidget = {}

---@param Result EMTDialogResult
function UJobWidget:HandleDialogResult(Result) end


---@class UJobsWidget : UUserWidget
---@field JobsListView UListView
local UJobsWidget = {}

---@param Item UObject
function UJobsWidget:OnItemDoubleClicked(Item) end


---@class UJoinOptionWidget : UUserWidget
---@field VehicleSetting USettingWidget
---@field JoinButton UMTButtonWidget
local UJoinOptionWidget = {}



---@class UJoinWidget : UUserWidget
---@field ServerListWidget UServerListWidget
---@field ServerInfoWidget UServerInfoWidget
---@field FindSessionsThrobber UCircularThrobber
---@field RefreshButton UMTButtonWidget
---@field ConnectButton UMTButtonWidget
---@field RefreshFriendListButton UMTButtonWidget
---@field FriendListWidget UFriendListWidget
---@field DistanceFilter USettingWidget
---@field FavoriteButton UMTButtonWidget
local UJoinWidget = {}



---@class UKeyIconWidget : UUserWidget
---@field BGImage UImage
---@field KeyNameTextBlock URichTextBlock
---@field DefaultActionName FName
---@field bIsNavigationBack boolean
local UKeyIconWidget = {}

function UKeyIconWidget:HandleInputMappingChanged() end


---@class UKeySelectorWidget : UUserWidget
---@field Button UButton
---@field NameTextBlock UTextBlock
---@field ClearButton UMTButtonWidget
---@field DetailButton UMTButtonWidget
---@field AxisProgressBar UProgressBar
---@field DetailHorizontalBox UHorizontalBox
---@field InvertSpinBox USpinBoxString
---@field AxisMinSpinBox USpinBoxString
---@field AxisMaxSpinBox USpinBoxString
---@field CenterDeadZoneWidget UWidget
---@field CenterDeadZoneSpinBox USpinBoxString
---@field AxisLinearitySpinBox USpinBoxString
---@field JoystickInputDetector UMTJoystickInputDetector
---@field KeyBindingActor AActor
local UKeySelectorWidget = {}

---@param SpinBoxString USpinBoxString
function UKeySelectorWidget:HandleOptionsChanged(SpinBoxString) end
function UKeySelectorWidget:HandleButtonClicked() end


---@class UKeyboardAndMouseDrivingSettingWidget : UDrivingControlSettingWidget
---@field MouseSteeringSensitivitySpinBox USpinBoxString
---@field MouseSteeringLinearitySpinBox USpinBoxString
local UKeyboardAndMouseDrivingSettingWidget = {}

---@param SpinBoxString USpinBoxString
function UKeyboardAndMouseDrivingSettingWidget:HandleMouseSteeringSpinBoxChanged(SpinBoxString) end


---@class UKeyboardDrivingSettingWidget : UDrivingControlSettingWidget
local UKeyboardDrivingSettingWidget = {}


---@class ULaptimeAndBestWidget : UUserWidget
---@field TitleTextBlock UTextBlock
---@field TimeTextBlock UTextBlock
---@field BestTimeTextBlock UTextBlock
local ULaptimeAndBestWidget = {}



---@class ULaptimeFrameWidget : UUserWidget
---@field LaptimeWidget ULaptimeWidget
---@field BestLaptimeWidget ULaptimeWidget
---@field LastLaptimeWidget ULaptimeWidget
---@field Vehicle AMTVehicle
local ULaptimeFrameWidget = {}

---@param InVehicle AMTVehicle
function ULaptimeFrameWidget:SetVehicle(InVehicle) end


---@class ULaptimeLeaderboardEntry : UObject
local ULaptimeLeaderboardEntry = {}


---@class ULaptimeLeaderboardEntryWidget : UUserWidget
---@field RankTextBlock UTextBlock
---@field LaptimeTextBlock UTextBlock
---@field NameTextBlock UTextBlock
---@field VersionTextBlock UTextBlock
---@field DateTextBlock UTextBlock
---@field Object ULaptimeLeaderboardEntry
local ULaptimeLeaderboardEntryWidget = {}



---@class ULaptimeLeaderboardWidget : UUserWidget
---@field LaptimeListView UListView
---@field Entries TArray<ULaptimeLeaderboardEntry>
local ULaptimeLeaderboardWidget = {}

---@param bSuccess boolean
---@param Json UJsonFieldData
---@param status EJSONResult
function ULaptimeLeaderboardWidget:OnGetListResult(bSuccess, Json, status) end


---@class ULaptimeTextWidget : UUserWidget
---@field LaptimeTextBlock UTextBlock
local ULaptimeTextWidget = {}



---@class ULaptimeWidget : UUserWidget
---@field TimeTextBlock UTextBlock
local ULaptimeWidget = {}



---@class ULeaderboardWidget : UUserWidget
---@field MotorTownWeb UWebBrowser
local ULeaderboardWidget = {}

function ULeaderboardWidget:ReloadWebpage() end
---@param URL FText
function ULeaderboardWidget:HandleWebUrlChanged(URL) end
---@param URL FString
---@param Frame FString
function ULeaderboardWidget:HandleWebBeforePopup(URL, Frame) end


---@class ULevelProgressWidget : UUserWidget
---@field LevelTypeImage UImage
---@field LevelTextBlock UTextBlock
---@field ProgressBarOverlay UWidget
---@field ExpProgressBar UProgressBar
---@field ExpTextBlock UTextBlock
local ULevelProgressWidget = {}



---@class ULevelWidget : UUserWidget
---@field LevelTypeImage UImage
---@field LevelTextBlock UTextBlock
local ULevelWidget = {}



---@class ULoadedCargoEntryWidget : UMTListViewEntryWidget
---@field CargoNameTextBlock URichTextBlock
---@field ReceiverNameTextBlock UTextBlock
---@field DistanceTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field NumLoadedTextBlock UTextBlock
---@field UnloadButton UMTButtonWidget
---@field UpButton UMTButtonWidget
---@field DownButton UMTButtonWidget
local ULoadedCargoEntryWidget = {}

function ULoadedCargoEntryWidget:UnloadCargo() end


---@class ULoadedCargoListWidget : UUserWidget
---@field CargoListView UMTListView
---@field Vehicle AMTVehicle
local ULoadedCargoListWidget = {}



---@class ULoanAdWidget : UUserWidget
---@field LoanTextBlock URichTextBlock
---@field SetDestinationButton UMTButtonWidget
local ULoanAdWidget = {}

function ULoanAdWidget:HandleSetDestination() end


---@class UMHEngineDataAsset : UDataAsset
---@field EngineProperty FMTEngineProperty
---@field EnginesSound USoundCue
---@field BackfireSound USoundCue
---@field IntakeSound USoundCue
---@field JakeBrakeSound USoundCue
local UMHEngineDataAsset = {}



---@class UMHTransmissionComponent : UActorComponent
---@field TransmissionProperty FMHTransmissionProperty
---@field CurrentGear int32
local UMHTransmissionComponent = {}

---@param InCurrentGear int32
function UMHTransmissionComponent:ServerReplicates(InCurrentGear) end


---@class UMHWheelComponent : UStaticMeshComponent
---@field WheelSlotIndex int32
---@field WheelFlags TArray<EMTWheelFlags>
---@field DriveShaftComponentName FName
---@field DifferentialComponentName FName
---@field LinkGearRatio float
---@field TirePhysicsData UMTTirePhysicsDataAsset
---@field BrushTirePhysics FMHBrushTirePhysics
---@field Inertia float
---@field SpringStroke float
---@field SpringLength float
---@field DefaultRideHeightAdjust float
---@field SpringK float
---@field SpringBoundDamping float
---@field SpringReboundDamping float
---@field bSteer boolean
---@field bReverseSteer boolean
---@field bSteerBy5thWheel boolean
---@field bTagAxleSteer boolean
---@field SteerBy5thWheelPivotX float
---@field TagAxleSteerPivotX float
---@field MaxSteeringAngleDegree float
---@field MaxSteeringAngleDegreePerSeconds float
---@field DisableSteeringSpeedKPH float
---@field CasterDegree float
---@field KingpinOffset float
---@field KingpinAngle float
---@field HandleBarOffset float
---@field BrakeRatio float
---@field bHandBrake boolean
---@field TreadWidthOverride float
---@field UnsprungMassMassFromBodyMultiplier float
---@field DriveShaftComponent UMTDriveShaftComponent
---@field DifferentialComponent UMTDifferentialComponent
---@field SkidSoundComponent UAudioComponent
---@field RoadNoiseSoundComponent UAudioComponent
---@field SurfaceSoundComponent UAudioComponent
---@field SurfaceEnvSoundComponent UAudioComponent
---@field BrakeSoundComponent UAudioComponent
---@field SurfaceLoopNC UNiagaraComponent
---@field SurfaceLoopNS UNiagaraSystem
---@field BrakeSmokeEffect UParticleSystemComponent
---@field InteractableComponent UMTInteractableComponent
---@field Strap UMTStrapComponent
---@field ContactSurfaceSound USoundCue
---@field SurfaceEnvSound USoundCue
local UMHWheelComponent = {}

---@return double
function UMHWheelComponent:GetAngularVelocity() end


---@class UMTAICharacterSystem : UWorldSubsystem
---@field SpawnConfig AMTAICharacterSpawnConfig
---@field Entries TArray<FMTAICharacterSpawnConfigEntry>
---@field Hitchhikers TArray<AMTCharacter>
---@field TaxiPassengers TArray<AMTCharacter>
---@field AmbulancePassengers TArray<AMTCharacter>
---@field SearchAndRescuePassengers TArray<AMTCharacter>
---@field BusStopPassengers TArray<AMTCharacter>
---@field Passengers TArray<AMTCharacter>
---@field Pedestrians TArray<AMTCharacter>
---@field Residents TArray<FMTResident>
---@field SpawnQueue TArray<FMTAICharacterSpawnParams>
---@field TownState FMTResidentTownState
local UMTAICharacterSystem = {}

---@param HUD AMTHUD
function UMTAICharacterSystem:OnHUDDraw(HUD) end


---@class UMTActiveLoanListObject : UObject
local UMTActiveLoanListObject = {}


---@class UMTActorCache : UObject
---@field ActorCaches TMap<UClass, FMTActorCacheItem>
local UMTActorCache = {}



---@class UMTAdminListObject : UObject
local UMTAdminListObject = {}


---@class UMTAdminVehicleListObject : UObject
---@field Vehicle AMTVehicle
local UMTAdminVehicleListObject = {}



---@class UMTAlwaysLoadedChildActorComponent : USceneComponent
---@field ChildActorClass TSubclassOf<AActor>
local UMTAlwaysLoadedChildActorComponent = {}



---@class UMTAmbulancePassengerListObject : UObject
---@field Passenger UMTPassengerComponent
local UMTAmbulancePassengerListObject = {}



---@class UMTAnimInstance : UAnimInstance
---@field Speed float
---@field Speed2D float
---@field IsStopped float
---@field bIsDowned boolean
---@field bIsFalling boolean
---@field bPose_Seat boolean
---@field bPose_SeatedSedan boolean
---@field bPose_SeatedScooterDriver boolean
---@field bPose_SeatedScooterPassenger boolean
---@field bPose_SeatedBikeUpRightDriver boolean
---@field bPose_SeatedBikeSportDriver boolean
---@field bPose_SeatedChair boolean
---@field bPose_StandingFrontGrip boolean
---@field bPose_Hitchhiking boolean
---@field bPose_Sleeping boolean
---@field bPose_Talking boolean
---@field bPose_Pushing boolean
---@field bPose_Patient_LieDown boolean
---@field bHoldingObject boolean
---@field bUseIK_HandR boolean
---@field bUseIK_HandRVertical boolean
---@field IKEffector_HandR FVector
---@field IKJointTarget_HandR FVector
---@field bUseIK_Look boolean
---@field IKLook_Target FVector
---@field LowerUpperBlendedWeight float
---@field UpperBodyWeight float
---@field bUseIK_Leaning boolean
---@field BikeLeaningRotation FRotator
---@field bUseIK_Hands boolean
---@field HandIK_Target_R FVector
---@field HandIK_Target_L FVector
---@field bUseIK_ThrowSpineBending boolean
---@field ThrowSpineBendingRotation FRotator
local UMTAnimInstance = {}



---@class UMTAnimNotify_FootStep : UAnimNotify
local UMTAnimNotify_FootStep = {}


---@class UMTAnimNotify_Throw : UAnimNotify
local UMTAnimNotify_Throw = {}


---@class UMTAudio : UGameInstanceSubsystem
local UMTAudio = {}


---@class UMTBTTask_AddGameplayTags : UBTTask_BlackboardBase
---@field GameplayTags FGameplayTagContainer
local UMTBTTask_AddGameplayTags = {}



---@class UMTBTTask_RemoveGameplayTags : UBTTask_BlackboardBase
---@field GameplayTags FGameplayTagContainer
local UMTBTTask_RemoveGameplayTags = {}



---@class UMTBTTask_SetVehicleControllerState : UBTTaskNode
---@field State EMTVehicleAIControllerState
local UMTBTTask_SetVehicleControllerState = {}



---@class UMTBTTask_SetVehicleControllerTargetActor : UBTTask_BlackboardBase
---@field bClearTarget boolean
local UMTBTTask_SetVehicleControllerTargetActor = {}



---@class UMTBTTask_SetVehicleToggleFunction : UBTTask_BlackboardBase
---@field ToggleFunction EMTVehicleToggleFunction
---@field bToggleOn boolean
local UMTBTTask_SetVehicleToggleFunction = {}



---@class UMTBanListObject : UObject
local UMTBanListObject = {}


---@class UMTBlueprintLibrary : UBlueprintFunctionLibrary
local UMTBlueprintLibrary = {}

---@param Actor AActor
---@param bEnableLight boolean
function UMTBlueprintLibrary:ToggleLightComponents(Actor, bEnableLight) end
---@param WorldContextObject UObject
---@param Index int32
---@param Location FVector
---@param Rotation FRotator
---@return AMTVehicle
function UMTBlueprintLibrary:SpawnVehicleByRowIndex(WorldContextObject, Index, Location, Rotation) end
---@param Vehicle AMTVehicle
---@param Index int32
---@return AMTVehicle
function UMTBlueprintLibrary:SpawnAttachableVehicleByRowIndex(Vehicle, Index) end
---@param PC APlayerController
function UMTBlueprintLibrary:ShowTerminatePopup(PC) end
---@param Vehicle AMTVehicle
---@param bStiff boolean
function UMTBlueprintLibrary:SetVehicleStiffSpring(Vehicle, bStiff) end
---@param Vehicle AMTVehicle
---@param bStiff boolean
function UMTBlueprintLibrary:SetVehicleStiffDamper(Vehicle, bStiff) end
---@param PC APlayerController
---@param Text FText
function UMTBlueprintLibrary:PushHelpText(PC, Text) end
---@param PC APlayerController
---@param Text FText
function UMTBlueprintLibrary:PopHelpText(PC, Text) end
---@param WorldContextObject UObject
---@param HelpKey FName
function UMTBlueprintLibrary:OpenHelp(WorldContextObject, HelpKey) end
---@param WorldContextObject UObject
---@return boolean
function UMTBlueprintLibrary:IsTurnOnStreetLamp(WorldContextObject) end
---@return boolean
function UMTBlueprintLibrary:IsDemo() end
---@param WorldContextObject UObject
---@param TimeOfDay float
---@param OutHour int32
---@param OutMinute int32
---@param OutSeconds int32
function UMTBlueprintLibrary:GetTimeOfDayHourMinuteSeconds(WorldContextObject, TimeOfDay, OutHour, OutMinute, OutSeconds) end
---@param WorldContextObject UObject
---@return float
function UMTBlueprintLibrary:GetTimeOfDay(WorldContextObject) end
---@param UnitDistance float
---@return FString
function UMTBlueprintLibrary:GetRoughDistanceString(UnitDistance) end
---@param WorldContextObject UObject
---@return int32
function UMTBlueprintLibrary:GetNumVehicleRows(WorldContextObject) end
---@param PC APlayerController
---@return FText
function UMTBlueprintLibrary:GetHelpText(PC) end
---@param UnitDistance float
---@return FString
function UMTBlueprintLibrary:GetDistanceString(UnitDistance) end
---@param UnitDistance float
---@param NumFrac int32
---@return FString
function UMTBlueprintLibrary:GetDistanceMeterOrFeetString(UnitDistance, NumFrac) end
---@param Vehicle AMTVehicle
---@return TArray<FName>
function UMTBlueprintLibrary:GetAttachableVehicleKeys(Vehicle) end
---@param Widget UWidget
---@return UWidget
function UMTBlueprintLibrary:FindMostTopFocusableDescendantWidget(Widget) end
---@param Widget UWidget
---@return UWidget
function UMTBlueprintLibrary:FindFocusableDescendantWidget(Widget) end


---@class UMTBudgetSystem : UWorldSubsystem
local UMTBudgetSystem = {}

---@param KeyObject UObject
function UMTBudgetSystem:UnregisterRollingTick(KeyObject) end
---@param WorldContextObject UObject
---@param Actor AActor
function UMTBudgetSystem:UnregisterPlayerDistanceBasedActorTickable(WorldContextObject, Actor) end
---@param KeyObject UObject
---@param Delegate FRegisterRollingTickDelegate
function UMTBudgetSystem:RegisterRollingTick(KeyObject, Delegate) end
---@param WorldContextObject UObject
---@param Actor AActor
---@param DistanceToPlayer float
---@param bAutoDistanceByActorBounds boolean
function UMTBudgetSystem:RegisterPlayerDistanceBasedActorTickable(WorldContextObject, Actor, DistanceToPlayer, bAutoDistanceByActorBounds) end


---@class UMTBuildingItemInventoryAccessor : UMTItemInventoryAccessor
---@field Building AMTBuilding
local UMTBuildingItemInventoryAccessor = {}



---@class UMTBusRouteListObject : UObject
---@field Route FMTBusRoute
---@field Vehicle AMTVehicle
local UMTBusRouteListObject = {}



---@class UMTBusRoutePathFinder : UObject
local UMTBusRoutePathFinder = {}


---@class UMTBusSystemDrawComponent : UPrimitiveComponent
local UMTBusSystemDrawComponent = {}


---@class UMTButtonWidget : UUserWidget
---@field OnClicked FMTButtonWidgetOnClicked
---@field OnFocused FMTButtonWidgetOnFocused
---@field ButtonName FText
---@field ButtonNameTexts FMTTextByTexts
---@field bAutoSize boolean
---@field TextImageBrush FSlateBrush
---@field TextPrefixImageBrush FSlateBrush
---@field bShowBackground boolean
---@field TextHorizontalAlignment EHorizontalAlignment
---@field SizeBox USizeBox
---@field MenuButton UButton
---@field NameTextBlock UTextBlock
---@field NameRichTextBlock URichTextBlock
---@field TextImage UImage
---@field InputKeyBox UWidget
---@field InputKeyWidget UKeyIconWidget
---@field bChecked boolean
---@field PooledTooltipWidget UMTTooltipWidget
local UMTButtonWidget = {}

---@param bNewChecked boolean
function UMTButtonWidget:ReceiveCheckChanged(bNewChecked) end
function UMTButtonWidget:OnButtonClicked() end
function UMTButtonWidget:MTButtonEvent__DelegateSignature() end
function UMTButtonWidget:HandleUnhovered() end
function UMTButtonWidget:HandleReleased() end
function UMTButtonWidget:HandlePressed() end
function UMTButtonWidget:HandleHovered() end


---@class UMTCarSellerInteractableComponent : UMTInteractableComponent
---@field Marker AMTARMarker
local UMTCarSellerInteractableComponent = {}



---@class UMTCargoReceiver : USceneComponent
---@field CargoTypes TArray<EDeliveryCargoType>
local UMTCargoReceiver = {}



---@class UMTCharacterMovementComponent : UCharacterMovementComponent
---@field MaxImpartedSpeed float
---@field MaxWalkSpeedWithHeavyObject float
---@field SprintSpeedMultiplier float
---@field PushingTarget AActor
local UMTCharacterMovementComponent = {}



---@class UMTChatCommand : UGameInstanceSubsystem
local UMTChatCommand = {}


---@class UMTCircleRouteDataView : UMTRouteDataViewBase
local UMTCircleRouteDataView = {}


---@class UMTCompanyBusRouteDataView : UMTRouteDataViewBase
---@field Route FMTCompanyBusRoute
local UMTCompanyBusRouteDataView = {}



---@class UMTCompanyDailyReportListObject : UObject
local UMTCompanyDailyReportListObject = {}


---@class UMTCompanyDepotListObject : UObject
local UMTCompanyDepotListObject = {}


---@class UMTCompanyInfoPlayerListObject : UObject
---@field Player FMTCompanyPlayer
local UMTCompanyInfoPlayerListObject = {}



---@class UMTCompanyJoinRequestListObject : UObject
---@field JoinRequest FMTCompanyJoinRequest
local UMTCompanyJoinRequestListObject = {}



---@class UMTCompanyListObject : UObject
---@field CompanyInfo FMTCompanyInfo
local UMTCompanyListObject = {}



---@class UMTCompanyMoneyTransactionListObject : UObject
---@field Transaction FMTCompanyMoneyTransaction
local UMTCompanyMoneyTransactionListObject = {}



---@class UMTCompanyPlayerListObject : UObject
---@field Player FMTCompanyPlayer
local UMTCompanyPlayerListObject = {}



---@class UMTCompanyRouteObject : UObject
---@field Name FText
---@field CompanyGuid FGuid
---@field RouteGuid FGuid
local UMTCompanyRouteObject = {}



---@class UMTCompanyTruckRouteDataView : UMTRouteDataViewBase
---@field Route FMTCompanyTruckRoute
local UMTCompanyTruckRouteDataView = {}



---@class UMTCompanyVehicleListObject : UObject
local UMTCompanyVehicleListObject = {}


---@class UMTComplexGradientWidget : UWidget
---@field Channel EMTColorPickerChannels
local UMTComplexGradientWidget = {}



---@class UMTComponentLODComponent : UActorComponent
---@field OnUpdate FMTComponentLODComponentOnUpdate
---@field TargetClasses TArray<TSubclassOf<UActorComponent>>
---@field ViewDistance float
---@field TickDistance float
---@field RegisterDistance float
---@field BudgetType EMTBudgetType
---@field TargetComponents TArray<UActorComponent>
local UMTComponentLODComponent = {}



---@class UMTConstraintComponent : UPhysicsConstraintComponent
---@field bDisableSimulationOnTerm1 boolean
---@field bDisableSimulationOnTerm2 boolean
---@field bOverridePos1 boolean
---@field OverridePos1 FVector
---@field bOverridePos2 boolean
---@field OverridePos2 FVector
---@field bHydraulic boolean
---@field bPTOHydraulic boolean
---@field bLinearHydraulic boolean
---@field bAngularHydraulic boolean
---@field LinearSpeed float
---@field LinearPositionStrength float
---@field LinearVelocityStrength float
---@field LinearMaxForce float
---@field bLimitLinearRange boolean
---@field LimitLinearRange FVector2D
---@field AngularSpeed float
---@field AngularPositionStrength float
---@field AngularVelocityStrength float
---@field AngularMaxForce float
---@field CollisionLocks TArray<FMTConstraintCollisionLock>
---@field RangeConfigs TArray<FMTConstraintRangeConfig>
---@field HydraulicSound USoundBase
---@field DisableCollisionComponentNames TArray<FName>
---@field DisableCollisionComponents TArray<UPrimitiveComponent>
---@field Net_BodyLocalMovements TArray<FMTConstraintRepBodyLocalMovement>
---@field HydraulicAudioComponent UAudioComponent
---@field Net_HydraulicControl float
---@field Net_TargetPosition float
---@field NetInitial_bConstraintLoaded boolean
---@field NetInitial_LoadedTransform FTransform
local UMTConstraintComponent = {}

function UMTConstraintComponent:OnRep_TargetPosition() end
function UMTConstraintComponent:OnRep_HydraulicControl() end
---@param HitComp UPrimitiveComponent
---@param OtherActor AActor
---@param OtherComp UPrimitiveComponent
---@param NormalImpulse FVector
---@param Hit FHitResult
function UMTConstraintComponent:HandleHit(HitComp, OtherActor, OtherComp, NormalImpulse, Hit) end


---@class UMTConstructionMaterialObject : UObject
local UMTConstructionMaterialObject = {}


---@class UMTContractInProgressListObject : UObject
---@field Contract FMTContractInProgress
local UMTContractInProgressListObject = {}



---@class UMTContractListObject : UObject
---@field Contract FMTContract
local UMTContractListObject = {}



---@class UMTControlPanel : UObject
---@field Controls TArray<FMTControlPanelControl>
---@field Actor AActor
local UMTControlPanel = {}



---@class UMTConveyorBeltComponent : USceneComponent
---@field MoveDirection FVector
---@field Speed float
local UMTConveyorBeltComponent = {}



---@class UMTCraneComponent : UActorComponent
---@field RotatingTopComponentName FName
---@field TopRotatingDegreePerSecond FVector
---@field BoomTelescopingSpeedPerSeconds float
---@field BoomRaiseSpeedPerSeconds float
---@field BoomParams TArray<FMTCraneBoomParams>
---@field RotatingTop USceneComponent
---@field Winch UMTWinchComponent
---@field Booms TArray<USceneComponent>
local UMTCraneComponent = {}



---@class UMTCursorWidgetContext : UObject
---@field SourceWidget UUserWidget
---@field CursorWidget UUserWidget
local UMTCursorWidgetContext = {}



---@class UMTDashboard : UActorComponent
---@field DashboardAttachSocketName FName
---@field DashboardMesh UStaticMesh
---@field DashboardMeshComponentName FName
---@field DashboardMeshLocation FVector
---@field DashboardMeshRotation FRotator
---@field DashboardMeshScale FVector
---@field GaugeConfigs TMap<EMTDashboardGaugeType, FMTDashboardGaugeConfig>
---@field TurnSignalSound USoundBase
---@field UpperMFDWidgetClass TSubclassOf<UDashboardMFDWidget>
---@field UpperMFDSize FVector2D
---@field DashboardMeshComponent UStaticMeshComponent
---@field MFDWidget UDashboardMFDWidget
---@field UpperMFDRT UTextureRenderTarget2D
---@field MFDParams TArray<FMTDashboardMFDParams>
---@field TurnSignalAudioComponent UAudioComponent
---@field Gauges TArray<FMTGauge>
---@field MeshMaterials TArray<UMaterialInstanceDynamic>
local UMTDashboard = {}



---@class UMTDecalBaker : UObject
---@field BoundDilateMaterial UMaterialInstanceDynamic
---@field BoundsActor AStaticMeshActor
---@field DilatedBoundsRT UTextureRenderTarget2D
---@field DilatedNormalRT UTextureRenderTarget2D
local UMTDecalBaker = {}



---@class UMTDecalComponent : UActorComponent
---@field DemoTargetMeshComponentName FName
---@field DemoTargetMaterialIndex int32
---@field DemoDecalKeys TArray<FName>
---@field EditModeDecalBaker UMTDecalBaker
---@field DecalContainer UMTDecalContainer
---@field TargetMeshComponents TMap<UMeshComponent, FMTDecalTargetMesh>
---@field EditModeTargetMeshComponentsToUpdate TArray<UMeshComponent>
local UMTDecalComponent = {}



---@class UMTDecalContainer : UObject
---@field Layers TArray<UMTDecalLayer>
local UMTDecalContainer = {}



---@class UMTDecalLayer : UObject
---@field Texture TSoftObjectPtr<UTexture2D>
---@field LoadedTexture UTexture2D
---@field BrushMaterial UMaterialInterface
---@field DynamicBrushMaterial UMaterialInstanceDynamic
local UMTDecalLayer = {}



---@class UMTDecalSystem : UWorldSubsystem
---@field FreeBakers TArray<UMTDecalBaker>
---@field UsedBakers TArray<UMTDecalBaker>
---@field UpdateQueuedDecalComps TArray<UMTDecalComponent>
local UMTDecalSystem = {}



---@class UMTDeliveryListObject : UObject
---@field ListView UListView
local UMTDeliveryListObject = {}



---@class UMTDeliveryPointInventoryRatio : UActorComponent
---@field bAutoFindNearestDeliveryPoint boolean
---@field AutoFindNearestDeliveryPointMaxDistance float
---@field DeliveryPoint AMTDeliveryPoint
---@field CargoKey FName
---@field bInputInventory boolean
local UMTDeliveryPointInventoryRatio = {}



---@class UMTDeliveryProductionListObject : UObject
---@field DeliveryPoint AMTDeliveryPoint
local UMTDeliveryProductionListObject = {}



---@class UMTDialogueActionEntry : UObject
---@field DialogueWidget UDialogueWidget
---@field NPC AActor
local UMTDialogueActionEntry = {}



---@class UMTDialogueComponent : UActorComponent
---@field DialogueKey FName
---@field CurrentDialogueKey FName
local UMTDialogueComponent = {}



---@class UMTDifferentialComponent : UActorComponent
---@field LSDSlotName FText
---@field LSDSlotIndex int32
---@field TransmissionComponentName FString
---@field DifferentialComponentName FString
---@field LinkGearRatio float
---@field Inertia float
---@field bAllowLockableLSD boolean
---@field TransmissionComponent UMHTransmissionComponent
---@field DifferentialComponent UMTDifferentialComponent
---@field DataAsset UMTLSDDataAsset
local UMTDifferentialComponent = {}



---@class UMTDriveShaftComponent : UActorComponent
---@field TransmissionComponentName FString
---@field Inertia float
---@field TransmissionComponent UMHTransmissionComponent
local UMTDriveShaftComponent = {}



---@class UMTDrivingInput : UObject
---@field Vehicle AMTVehicle
local UMTDrivingInput = {}

function UMTDrivingInput:HandleInputMappingChanged() end
function UMTDrivingInput:HandleDeviceDetached() end
function UMTDrivingInput:HandleDeviceAttached() end


---@class UMTEditorBlueprintLibrary : UBlueprintFunctionLibrary
local UMTEditorBlueprintLibrary = {}

---@param PartsTable UDataTable
---@param GameResourceObject UObject
---@param LightDutyMultiplier float
---@param MidDutyMultiplier float
---@param HeavyDutyMultiplier float
function UMTEditorBlueprintLibrary:UpdatePartsTableTruckClassVariations(PartsTable, GameResourceObject, LightDutyMultiplier, MidDutyMultiplier, HeavyDutyMultiplier) end
---@param Vehicle AMTVehicle
function UMTEditorBlueprintLibrary:TeleportToCargoDestination(Vehicle) end
---@param Mesh UStaticMesh
---@param Resolution int32
function UMTEditorBlueprintLibrary:SetStaticMeshMinLightmapResolution(Mesh, Resolution) end
---@param PC AMotorTownPlayerController
---@param Vehicle AMTVehicle
function UMTEditorBlueprintLibrary:RaiseDumpBed(PC, Vehicle) end
---@param Vehicle AMTVehicle
function UMTEditorBlueprintLibrary:PickupDelivery(Vehicle) end
---@param VehiclesTable UDataTable
---@param GameResourceObject UObject
function UMTEditorBlueprintLibrary:MigrateVehiclesTable(VehiclesTable, GameResourceObject) end
---@param ItemsTable UDataTable
---@param GameResourceObject UObject
function UMTEditorBlueprintLibrary:MigrateItemsTable(ItemsTable, GameResourceObject) end
---@param PCG UPCGComponent
---@return boolean
function UMTEditorBlueprintLibrary:IsPCGGenerating(PCG) end
---@param WorldContextObject UObject
---@return AMotorTownPlayerController
function UMTEditorBlueprintLibrary:GetPlayerController(WorldContextObject) end
---@param WorldContextObject UObject
function UMTEditorBlueprintLibrary:GeneratePCGAll(WorldContextObject) end
---@param PCG UPCGComponent
function UMTEditorBlueprintLibrary:DetachPCGBreakables(PCG) end
---@param PC APlayerController
---@param VehicleKey FName
function UMTEditorBlueprintLibrary:ChangeVehicle(PC, VehicleKey) end
---@param Objects TArray<UObject>
---@param Color FColor
---@param Mask FColor
function UMTEditorBlueprintLibrary:ChangeTextureColor(Objects, Color, Mask) end
---@param Objects TArray<UObject>
---@param Mask FColor
function UMTEditorBlueprintLibrary:ChangeTextureAlhaFromColor(Objects, Mask) end
---@param WorldContextObject UObject
function UMTEditorBlueprintLibrary:BuildVehicles(WorldContextObject) end
---@param PartsTable UDataTable
---@param VehicleTypes TArray<EMTVehicleType>
---@param MeshesObjects TArray<UObject>
function UMTEditorBlueprintLibrary:AddToWheelPartsTable(PartsTable, VehicleTypes, MeshesObjects) end
---@param BuildingTable UDataTable
---@param ItemsTable UDataTable
---@param Objects TArray<UObject>
---@param IconTexture UTexture2D
---@param HoldableActorClass TSubclassOf<AActor>
function UMTEditorBlueprintLibrary:AddToHousingBuildingTable(BuildingTable, ItemsTable, Objects, IconTexture, HoldableActorClass) end
---@param DecalsTable UDataTable
---@param Objects TArray<UObject>
---@param BrushMaterial UMaterialInterface
---@param bIsAlphaOnlyTexture boolean
function UMTEditorBlueprintLibrary:AddToDecalsTable(DecalsTable, Objects, BrushMaterial, bIsAlphaOnlyTexture) end
---@param PartsTable UDataTable
---@param GameResourceObject UObject
---@param VehicleAndMeshes TArray<UObject>
function UMTEditorBlueprintLibrary:AddToAeroPartsTable(PartsTable, GameResourceObject, VehicleAndMeshes) end


---@class UMTEngineComponent : USceneComponent
---@field EngineData UMHEngineDataAsset
---@field AudioComponent UAudioComponent
---@field IntakeAudioComponent UAudioComponent
---@field OverheatSmokeEffect UParticleSystemComponent
---@field AfterfireAudioComponents TArray<UAudioComponent>
---@field JakeBrakeAudioComponent UAudioComponent
---@field NetLC_EngineHotState FMTEngineHotState
---@field Intake FMTVehiclePartIntake
---@field CoolantRadiator FMTVehiclePartCoolantRadiator
---@field Turbocharger FMTVehiclePartTurbocharger
---@field ExhaustBlackSmokes TArray<UNiagaraComponent>
---@field ExhaustWhiteSmokes TArray<UNiagaraComponent>
local UMTEngineComponent = {}

---@param InThrottle float
function UMTEngineComponent:SetThrottle(InThrottle) end
---@param bOn boolean
function UMTEngineComponent:SetStarterOn(bOn) end
---@param OldState FMTEngineHotState
function UMTEngineComponent:OnRep_EngineHotState(OldState) end
---@return boolean
function UMTEngineComponent:IsStarterOn() end
---@return boolean
function UMTEngineComponent:IsIgnitionOn() end
---@return float
function UMTEngineComponent:GetThrottle() end
---@return float
function UMTEngineComponent:GetRPM() end
---@return FMTEngineProperty
function UMTEngineComponent:GetEngineProperty() end


---@class UMTEnv : UWorldSubsystem
---@field Cloud AMTCloud
---@field PC APlayerController
---@field SunSky AMTSunSky
---@field HeightFog AExponentialHeightFog
---@field Landscapes TArray<ALandscapeProxy>
---@field OceanMeshes TArray<AActor>
---@field HighlightedComponents TArray<USceneComponent>
---@field WeatherNCs TArray<UNiagaraComponent>
---@field WeatherAudioComponents TArray<UAudioComponent>
---@field MaterialParamCollection_Env UMaterialParameterCollectionInstance
local UMTEnv = {}



---@class UMTEventListObject : UObject
---@field Event FMTEvent
local UMTEventListObject = {}



---@class UMTEventPlayersListObject : UObject
---@field Player FMTEventPlayer
local UMTEventPlayersListObject = {}



---@class UMTEventResultPlayerEntryObject : UObject
---@field Event FMTEvent
---@field Player FMTEventPlayer
local UMTEventResultPlayerEntryObject = {}



---@class UMTExportDataTableCommandlet : UCommandlet
local UMTExportDataTableCommandlet = {}


---@class UMTFX : UWorldSubsystem
---@field SlidingSounds TArray<FMTSlidingSoundFX>
---@field TireSmokeParticles TArray<UParticleSystemComponent>
local UMTFX = {}



---@class UMTFireCellComponent : USceneComponent
---@field FireNC UNiagaraComponent
local UMTFireCellComponent = {}



---@class UMTFireListObject : UObject
---@field Fire AMTFire
local UMTFireListObject = {}



---@class UMTFriendListObject : UObject
local UMTFriendListObject = {}


---@class UMTFuelPumpComponent : UActorComponent
---@field Slots TArray<FMTFuelPumpSlot>
local UMTFuelPumpComponent = {}



---@class UMTGameResource : UDataAsset
---@field BalanceTable FMTBalanceTable
---@field DriveMaps TArray<FMTMap>
---@field TimeAttackMaps TArray<FMTMap>
---@field RaceMaps TArray<FMTMap>
---@field BaseSoundMix USoundMix
---@field CabinMasterSoundMix USoundMix
---@field MasterSoundClass USoundClass
---@field BGMSoundClass USoundClass
---@field EngineSoundClass USoundClass
---@field TireSoundClass USoundClass
---@field WindNoiseSoundClass USoundClass
---@field BGMSound USoundBase
---@field TurnSignalSound USoundBase
---@field InvalidLocationMaterial UMaterialInterface
---@field BusCoinDropSound USoundBase
---@field BusStopSound USoundBase
---@field BusStopOnTimeSound USoundBase
---@field BusPassengerWantToStopSound USoundBase
---@field CruiseControlActivatedSound USoundBase
---@field SwitchOnSound USoundBase
---@field SwitchOffSound USoundBase
---@field WinchAttachSound USoundBase
---@field StrapSound USoundBase
---@field UnstrapSound USoundBase
---@field StrapSnapSound USoundBase
---@field ABSSound USoundBase
---@field BrakeSqueakSound USoundBase
---@field ImpactGunSound USoundBase
---@field MoneyChangedSound USoundBase
---@field PoliceRadioCopySound USoundBase
---@field WaterSplashSound USoundBase
---@field AirHydraulicSound USoundBase
---@field WaterSpraySound USoundBase
---@field FireSound USoundBase
---@field FireExtinguishSteamSound USoundBase
---@field GhostCarMaterial UMaterialInterface
---@field InteractionMesh UStaticMesh
---@field DisabledMirrorMaterial UMaterialInterface
---@field DisabledMirrorTexture UTexture
---@field EmptyDecalTexture UTexture2D
---@field SplineEditorMesh UStaticMesh
---@field MarkerWidgetMaterial UMaterialInterface
---@field DestinationMarkerActorClass TSubclassOf<AMTARMarker>
---@field DeliveryMarkerActorClass TSubclassOf<AMTARMarker>
---@field HitchhikerMarkerActorClass TSubclassOf<AMTARMarker>
---@field TaxiPassengerMarkerActorClass TSubclassOf<AMTARMarker>
---@field LimoPassengerMarkerActorClass TSubclassOf<AMTARMarker>
---@field AmbulancePassengerMarkerActorClass TSubclassOf<AMTARMarker>
---@field CarSellerMarkerActorClass TSubclassOf<AMTARMarker>
---@field PriceMarkerActorClass TSubclassOf<AMTARMarker>
---@field TaxiJobMarkerActorClass TSubclassOf<AMTARMarker>
---@field AmbulanceJobMarkerActorClass TSubclassOf<AMTARMarker>
---@field BusJobMarkerActorClass TSubclassOf<AMTARMarker>
---@field TruckJobMarkerActorClass TSubclassOf<AMTARMarker>
---@field WreckerJobMarkerActorClass TSubclassOf<AMTARMarker>
---@field UnHookedTrailerMarkerActorClass TSubclassOf<AMTARMarker>
---@field DroppedCargoMarkerActorClass TSubclassOf<AMTARMarker>
---@field TowRequestMarkerActorClass TSubclassOf<AMTARMarker>
---@field TowRequestRescueMarkerActorClass TSubclassOf<AMTARMarker>
---@field VehicleDeliveryMarkerActorClass TSubclassOf<AMTARMarker>
---@field HouseForSaleMarkerActorClass TSubclassOf<AMTARMarker>
---@field BuildingConstructionMarkerActorClass TSubclassOf<AMTARMarker>
---@field PoliceSuspectMarkerActorClass TSubclassOf<AMTARMarker>
---@field GarbageMarkerActorClass TSubclassOf<AMTARMarker>
---@field PatrolMarkerActorClass TSubclassOf<AMTARMarker>
---@field GetawayJobMarkerActorClass TSubclassOf<AMTARMarker>
---@field ParkingTicketMarkerActorClass TSubclassOf<AMTARMarker>
---@field FuelPumpMarkerActorClass TSubclassOf<AMTARMarker>
---@field WaterPumpMarkerActorClass TSubclassOf<AMTARMarker>
---@field WaterSprayPhysicalMaterial UPhysicalMaterial
---@field MapIcons TArray<FMTMapIconParams>
---@field ButtonWidgetClass TSubclassOf<UMTButtonWidget>
---@field CheckBoxWidgetClass TSubclassOf<UCheckBoxWidget>
---@field TooltipWidgetClass TSubclassOf<UMTTooltipWidget>
---@field LevelTypeIcons TMap<EMTCharacterLevelType, UMaterialInterface>
---@field RewardWidgetClass TSubclassOf<URewardWidget>
---@field InteractionListWidgetClass TSubclassOf<UInteractionListWidget>
---@field SettingWidgetClass TSubclassOf<USettingWidget>
---@field UserSettingWidgetClass TSubclassOf<UUserSettingItemWidget>
---@field VehicleSettingWidgetClass TSubclassOf<UVehicleSettingItemWidget>
---@field VendorWidgetClass TSubclassOf<UVendorWidget>
---@field DialogueWidgetClass TSubclassOf<UDialogueWidget>
---@field ParkingSpaceSummonWidgetClass TSubclassOf<UParkingSpaceSummonWidget>
---@field SleepWidgetClass TSubclassOf<USleepWidget>
---@field VehicleInfoWidgetClass TSubclassOf<UVehicleInfoWidget>
---@field VehicleLockWidgetClass TSubclassOf<UVehicleLockWidget>
---@field SeatPositionWidgetClass TSubclassOf<USeatPositionWidget>
---@field MirrorPositionWidgetClass TSubclassOf<UMirrorControlWidget>
---@field RoadsideServiceWidgetClass TSubclassOf<URoadsideServiceWidget>
---@field CompanyVehicleControlPanelWidget TSubclassOf<UCompanyVehicleControlPanelWidget>
---@field DriveModeVehicleControlPanelWidget TSubclassOf<UDriveModeSettingWidget>
---@field Shifter13SpeedWidgetClass TSubclassOf<UShifterWidget>
---@field Shifter18SpeedWidgetClass TSubclassOf<UShifterWidget>
---@field PassengersWidgetClass TSubclassOf<UPassengersWidget>
---@field CargosWidgetClass TSubclassOf<UUserWidget>
---@field TaxiControlPanelWidgetClass TSubclassOf<UUserWidget>
---@field AmbulanceControlPanelWidgetClass TSubclassOf<UUserWidget>
---@field FireJobControlPanelWidgetClass TSubclassOf<UUserWidget>
---@field TowRequestControlPanelWidgetClass TSubclassOf<UTowRequestControlPanelWidget>
---@field SelectVehicleWidgetClass TSubclassOf<USelectVehicleWidget>
---@field HitchhikerInteractionWidgetClass TSubclassOf<UHitchhikerInteractionWidget>
---@field TaxiPassengerInteractionWidgetClass TSubclassOf<UTaxiPassengerInteractionWidget>
---@field BusRouteSelectionWidgetClass TSubclassOf<UBusRouteSelectionWidget>
---@field VehicleControlPanelWidgetClass TSubclassOf<UVehicleControlPanelWidget>
---@field DuplicatedKeyMappingPopupWidgetClass TSubclassOf<UDuplicatedKeyMappingPopupWidget>
---@field JoinOptionWidgetClass TSubclassOf<UJoinOptionWidget>
---@field RescueRequestMapPopupWidgetClass TSubclassOf<URescueRequestMapPopupWidget>
---@field ConstructionWidgetClass TSubclassOf<UConstructionWidget>
---@field BuildingManagementWidgetClass TSubclassOf<UBuildingManagementWidget>
---@field ControlPanelWidgetClass TSubclassOf<UControlPanelWidget>
---@field LevelProgressWidget TSubclassOf<ULevelProgressWidget>
---@field LevelWidget TSubclassOf<ULevelWidget>
---@field VehiclePartInvenotryInteractionWidgetClass TSubclassOf<UVehiclePartInvenotryInteractionWidget>
---@field BuildingInventoryInteractionWidgetClass TSubclassOf<UBuildingInventoryInteractionWidget>
---@field CreateCompanyWidgetClass TSubclassOf<UCreateCompanyWidget>
---@field CreateCompanyVehicleWidgetClass TSubclassOf<UCompanyVehicleWidget>
---@field CreateCompanyDepotWidgetClass TSubclassOf<UCompanyDepotWidget>
---@field CompanyInfoWidgetClass TSubclassOf<UCompanyInfoWidget>
---@field JobStatusEntryWidgetClass TSubclassOf<UJobStatusEntryWidget>
---@field RefuelingWidgetClass TSubclassOf<URefuelingWidget>
---@field OtherPlayerIconWidgetClass TSubclassOf<UUserWidget>
---@field PassengerIconWidgetClass TSubclassOf<UUserWidget>
---@field TaxiPassengerIconWidgetClass TSubclassOf<UUserWidget>
---@field AmbulancePassengerIconWidgetClass TSubclassOf<UUserWidget>
---@field FireIconWidgetClass TSubclassOf<UUserWidget>
---@field BusStopIconWidgetClass TSubclassOf<UUserWidget>
---@field BusTerminalIconWidgetClass TSubclassOf<UUserWidget>
---@field CompanyVehicleIconWidgetClass TSubclassOf<UUserWidget>
---@field CompanyBusIconWidgetClass TSubclassOf<UUserWidget>
---@field CompanyTruckIconWidgetClass TSubclassOf<UUserWidget>
---@field CompanyDepotIconWidgetClass TSubclassOf<UUserWidget>
---@field PolicePatrolPointIconWidgetClass TSubclassOf<UIconWidget>
---@field CrosshairTargetActorClass TSubclassOf<AActor>
---@field BankLoanWidgetClass TSubclassOf<UBankLoanWidget>
---@field TankerFuelPumpWidgetClass TSubclassOf<UTankerFuelPumpWidget>
---@field HousingManagementWidgetClass TSubclassOf<UHousingManagementWidget>
---@field AdminVehicleListWidgetClass TSubclassOf<UAdminVehicleListWidget>
---@field ActorPreviewActorClass TSubclassOf<AMTActorPreview>
---@field PreviewCharacterClass TSubclassOf<AMTCharacter>
---@field EventWidgetClass TSubclassOf<UEventWidget>
---@field EventResultWidgetClass TSubclassOf<UEventResultWidget>
---@field RouteEditorWidgetClass TSubclassOf<URouteEditorWidget>
---@field MapDeliveryDefaultIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliverySupermarketIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryStoreIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryWarehouseIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryFarmIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryFactoryIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryLoggingIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryContainerIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryCourierIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryConstructionIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryMineIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryOilPumpIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryGasStationIconWidgetClass TSubclassOf<UIconWidget>
---@field MapDeliveryDropOffIconWidgetClass TSubclassOf<UIconWidget>
---@field MapFilterWidgetClass TSubclassOf<UMapFilterWidget>
---@field HelpWidgetClass TSubclassOf<UHelpWidget>
---@field AttachmentPlacementWidgetClass TSubclassOf<UAttachmentPlacementWidget>
---@field ControlWidgetClass TSubclassOf<UControlWidget>
---@field BanConfirmWidgetClass TSubclassOf<UBanConfirmWidget>
---@field TagEditorWidgetClass TSubclassOf<UTagEditorWidget>
---@field PoliceControlPanelWidgetClass TSubclassOf<UPoliceControlPanelWidget>
---@field MapDeliveryVehicleIconWidgetClass TSubclassOf<UIconWidget>
---@field MapVehicleSpawnPointIconWidgetClass TSubclassOf<UIconWidget>
---@field CharacterEditorWidgetClass TSubclassOf<UCharacterEditorWidget>
---@field CargoInfoTooltipWidgetClass TSubclassOf<UCargoInfoTooltipWidget>
---@field RoamingCharacterAIControllerClass TSubclassOf<AAIController>
---@field RaceVehicleAIControllerClass TSubclassOf<AMTVehicleAIController>
---@field CompanyVehicleAIControllerClass TSubclassOf<AMTVehicleAIController>
---@field PoliceSuspectGE TSubclassOf<UGameplayEffect>
---@field PolicePullOverCoolDownGE TSubclassOf<UGameplayEffect>
---@field VehicleCollidingGE TSubclassOf<UGameplayEffect>
---@field TaxiRoofSignClass TSubclassOf<AMTTaxiRoofSign>
---@field SpikePadClass TSubclassOf<AMTSpikePad>
---@field CaptureTheFlagFlagActorClass TSubclassOf<AActor>
---@field SignalFlareAcctor TSubclassOf<AActor>
---@field CloudMeshes TArray<UStaticMesh>
---@field StrapMaterial UMaterialInterface
---@field WheelStrapMaterial UMaterialInterface
---@field StrapBuckleMesh UStaticMesh
---@field WinchRopeMaterial UMaterialInterface
---@field ConstructionClass TSubclassOf<AMTBuildingConstruction>
---@field ConstructionDeliveryPointClass TSubclassOf<AMTDeliveryPoint>
---@field DepotDeliveryPointClass TSubclassOf<AMTDeliveryPoint>
---@field ConstructionSmoke UParticleSystem
---@field HousingFenceMesh UStaticMesh
---@field TireCollisionCylinderMesh UStaticMesh
---@field TireCollisionCylinderOffsetedMesh UStaticMesh
---@field SuspectGameplayTags FGameplayTagContainer
---@field SuspectGameplayTagsForNPC FGameplayTagContainer
---@field PoliceDispatchVoice UMTVoiceLineDataAsset
---@field MaterialParamCollection_UI UMaterialParameterCollection
---@field MaterialParamCollection_Env UMaterialParameterCollection
---@field DecalBakerBoundsMaterial UMaterialInterface
---@field DecalBakerNormalMaterial UMaterialInterface
---@field DecalBoundsDilateMaterial UMaterialInterface
---@field DecalDilateMaterial UMaterialInterface
---@field CopyTextureMaterial UMaterialInterface
---@field DecalBakerHiddenMaterial UMaterialInterface
---@field RaceEventSectionActorClass TSubclassOf<AMotorTownRaceSection>
---@field FXAsset UMotorTownFXAsset
---@field Courses UDataTable
---@field Houses UDataTable
---@field Buildings UDataTable
---@field Vehicles UDataTable
---@field VehicleParts UDataTable
---@field Drones UDataTable
---@field Residents UDataTable
---@field Cargos UDataTable
---@field CharacterBodyParts UDataTable
---@field TimeOfDaySchedule UDataTable
---@field Items UDataTable
---@field Buffs UDataTable
---@field Dialogues UDataTable
---@field KeyRichImages UDataTable
---@field Quests UDataTable
---@field MapIconsTable UDataTable
---@field Decals UDataTable
---@field Helps UDataTable
---@field Coupons UDataTable
local UMTGameResource = {}

function UMTGameResource:UpdateVehicleBuildData() end


---@class UMTGameViewportClient : UGameViewportClient
local UMTGameViewportClient = {}


---@class UMTGarageDecalLayerObject : UObject
---@field DecalContainer UMTDecalContainer
local UMTGarageDecalLayerObject = {}



---@class UMTGaragePartListObject : UObject
local UMTGaragePartListObject = {}


---@class UMTGarageRepairListObject : UObject
---@field Vehicle AMTVehicle
local UMTGarageRepairListObject = {}



---@class UMTGarageWorkshopListObject : UObject
local UMTGarageWorkshopListObject = {}


---@class UMTGetawayComponent : UActorComponent
---@field Net_ColdState FMTGetawayColdState
---@field Net_HotState FMTGetawayHotState
---@field DestinationActor AMTInteractionMeshActor
---@field Marker AMTARMarker
local UMTGetawayComponent = {}



---@class UMTGhostComponent : UActorComponent
local UMTGhostComponent = {}

---@param OverlappedComponent UPrimitiveComponent
---@param OtherActor AActor
---@param OtherComp UPrimitiveComponent
---@param OtherBodyIndex int32
---@param bFromSweep boolean
---@param SweepResult FHitResult
function UMTGhostComponent:HandleOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult) end


---@class UMTHelpEntryObject : UObject
local UMTHelpEntryObject = {}


---@class UMTHostWebServer : UMTWebServer
local UMTHostWebServer = {}


---@class UMTHouseDrawComponent : UPrimitiveComponent
local UMTHouseDrawComponent = {}


---@class UMTInput : UGameInstanceSubsystem
local UMTInput = {}

function UMTInput:HandleInputMappingChanged() end
---@param DeviceID FString
---@param directionalPadValue int32
---@param directionalPadIndex int32
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function UMTInput:HandleDPadEvent(DeviceID, directionalPadValue, directionalPadIndex, deviceIndex, device) end
---@param device FSimpleControllerDevice
function UMTInput:HandleDeviceDetached(device) end
---@param device FSimpleControllerDevice
function UMTInput:HandleDeviceAttached(device) end
---@param DeviceID FString
---@param buttonID int32
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function UMTInput:HandleButtonUp(DeviceID, buttonID, deviceIndex, device) end
---@param DeviceID FString
---@param buttonID int32
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function UMTInput:HandleButtonDown(DeviceID, buttonID, deviceIndex, device) end
---@param DeviceID FString
---@param axisID int32
---@param AxisValue float
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function UMTInput:HandleAxisMoved(DeviceID, axisID, AxisValue, deviceIndex, device) end


---@class UMTInteractableComponent : USceneComponent
---@field OnCandidated FMTInteractableComponentOnCandidated
---@field OnPreInteraction FMTInteractableComponentOnPreInteraction
---@field bUseServerOnPreInteraction boolean
---@field InteractableType EMotorTownInteractableType
---@field Interactions TArray<EMotorTownInteractableType>
---@field InteractionParams TArray<FMTInteractionParams>
---@field bInteractbyActor boolean
---@field bInteractByChildOfParent boolean
---@field InteractableName FText
---@field LC_Interactor AActor
local UMTInteractableComponent = {}

function UMTInteractableComponent:MulticastPreInteraction() end
---@param InteractableComponent UMTInteractableComponent
function UMTInteractableComponent:MTEvent__DelegateSignature(InteractableComponent) end


---@class UMTInteractionMeshAssetUserData : UAssetUserData
local UMTInteractionMeshAssetUserData = {}


---@class UMTInteractionMeshComponent : UStaticMeshComponent
local UMTInteractionMeshComponent = {}


---@class UMTInteractionObject : UObject
local UMTInteractionObject = {}


---@class UMTInternetRadioEntry : UObject
local UMTInternetRadioEntry = {}


---@class UMTInventoryItemCursorWidgetContext : UMTCursorWidgetContext
local UMTInventoryItemCursorWidgetContext = {}


---@class UMTInventorySlotDragAndDrop : UDragDropOperation
---@field DragSourceWidget UInventorySlotWidget
local UMTInventorySlotDragAndDrop = {}



---@class UMTItemComponent : UActorComponent
---@field Interactable UMTInteractableComponent
---@field Server_ItemGuid FGuid
---@field Server_PickupLockedPlayerController APlayerController
---@field Server_OwnerCharacterGuid FGuid
---@field Net_OwnerName FString
---@field Net_ItemKey FName
---@field Net_bIsInteratable boolean
---@field Net_bEnableSimulation boolean
---@field Net_EnableCollision ECollisionEnabled::Type
---@field Net_TaggedObjects TArray<FMTItemTagObject>
---@field ItemRow FMTItemRow
local UMTItemComponent = {}

function UMTItemComponent:OnRep_ItemKey() end
function UMTItemComponent:OnRep_Interatable() end
function UMTItemComponent:OnRep_EnableSimulation() end


---@class UMTItemInventoryAccessor : UObject
local UMTItemInventoryAccessor = {}


---@class UMTItemSellComponent : UActorComponent
---@field Net_ItemKey FName
---@field Net_PriceMarkerOffset FVector
---@field Net_bShowPriceMarker boolean
---@field PriceMarkerScale FVector
---@field Interaction UMTInteractableComponent
---@field Marker AMTARMarker
---@field PriceMarkerTexture UTexture2D
local UMTItemSellComponent = {}

---@param Key FName
function UMTItemSellComponent:SetItemKeyBP(Key) end


---@class UMTJoystickInputDetector : UObject
local UMTJoystickInputDetector = {}


---@class UMTLSDDataAsset : UDataAsset
---@field LSDType EMTLSDType
---@field ClutchPackAccel float
---@field ClutchPackBrake float
local UMTLSDDataAsset = {}



---@class UMTLightControlComponent : UActorComponent
---@field Net_LightColor FLinearColor
---@field LightIntensity float
---@field FadingSpeed float
---@field TargetComponentTags TArray<FName>
---@field TargetMaterialSlotNames TArray<FName>
---@field Blinks TArray<FMTLightControlBlink>
---@field Net_bLightOn boolean
---@field LightDefaultIntensityMap TMap<ULightComponent, float>
---@field LightIntensityMaterials TArray<UMaterialInstanceDynamic>
---@field LightMaterials TArray<UMaterialInstanceDynamic>
---@field LightColorMaterials TArray<UMaterialInstanceDynamic>
local UMTLightControlComponent = {}

function UMTLightControlComponent:OnRep_LightOn() end
function UMTLightControlComponent:OnRep_LightColor() end
---@return boolean
function UMTLightControlComponent:IsLightOn() end


---@class UMTListView : UListView
---@field LastSelectedEntryWidget UMTListViewEntryWidget
local UMTListView = {}



---@class UMTListViewEntryBG : UUserWidget
local UMTListViewEntryBG = {}

---@param bSelected boolean
function UMTListViewEntryBG:ReceiveSetSelected(bSelected) end
---@param bHovered boolean
function UMTListViewEntryBG:ReceiveSetHovered(bHovered) end
---@param bFocused boolean
function UMTListViewEntryBG:ReceiveSetFocused(bFocused) end


---@class UMTListViewEntryWidget : UUserWidget
---@field BG UMTListViewEntryBG
---@field HighlightType EMTListViewHighlightType
---@field FocusDelegatedWidget UWidget
---@field FocusDelegatedWidgets TArray<UWidget>
local UMTListViewEntryWidget = {}



---@class UMTLoadedCargoListObject : UObject
---@field Vehicle AMTVehicle
---@field Cargo AMTCargo
---@field SenderActor AActor
---@field DestinationActor AActor
---@field Cargos TArray<AMTCargo>
local UMTLoadedCargoListObject = {}



---@class UMTLocalMessage : UEngineMessage
local UMTLocalMessage = {}


---@class UMTLocalPlayer : ULocalPlayer
local UMTLocalPlayer = {}


---@class UMTMapIconPlaceNameComponent : UActorComponent
---@field PlaceName FText
---@field PlaceNameTexts FMTTextByTexts
---@field AdditionalTooltipText FText
local UMTMapIconPlaceNameComponent = {}



---@class UMTMirrorComponent : UStaticMeshComponent
---@field SideMirrorSocketName FName
---@field SideMirrorSurfaceSocketName FName
---@field DigitalScreenSocketName FName
---@field MirrorType EMTMirroType
---@field bIsDigitalMirror boolean
---@field MirrorSize float
---@field MirrorCurvature float
---@field ViewDistance float
---@field Resolution float
---@field SideMirrorRotation FRotator
---@field SceneCaptureComponent USceneCaptureComponent2D
---@field Materials TArray<UMaterialInstanceDynamic>
---@field AssignedRenderTarget UTextureRenderTarget2D
local UMTMirrorComponent = {}



---@class UMTMoneyWidget : UUserWidget
---@field MoneyTextBlock UTextBlock
---@field PostfixTextBlock UTextBlock
---@field bShowAccountMoney boolean
local UMTMoneyWidget = {}

function UMTMoneyWidget:PlayChaChingEffect() end
---@param OldMoney int64
---@param NewMoney int64
function UMTMoneyWidget:OnMoneyChanged(OldMoney, NewMoney) end


---@class UMTNavPointDrawComponent : UPrimitiveComponent
local UMTNavPointDrawComponent = {}


---@class UMTNavigationDrawComponent : UPrimitiveComponent
local UMTNavigationDrawComponent = {}


---@class UMTNet : UGameInstanceSubsystem
---@field PortFowardings TArray<UMTPortFowarding>
local UMTNet = {}



---@class UMTNetInterpolatedComponent : USceneComponent
local UMTNetInterpolatedComponent = {}


---@class UMTOrientationCompasWidget : UUserWidget
---@field NorthImage UImage
local UMTOrientationCompasWidget = {}



---@class UMTOverlapComponent : UActorComponent
---@field OnOverlapTested FMTOverlapComponentOnOverlapTested
---@field ComponentName FName
---@field TargetObjectTypes TArray<EObjectTypeQuery>
---@field bControlledPawn boolean
---@field bServerOnly boolean
---@field PrimComp UPrimitiveComponent
local UMTOverlapComponent = {}

---@param bHasOverlap boolean
function UMTOverlapComponent:OverlapTestedEvent__DelegateSignature(bHasOverlap) end


---@class UMTOverlapInteractorComponent : UActorComponent
---@field OverlappedLocalPawns TArray<APawn>
local UMTOverlapInteractorComponent = {}

---@param OverlappedActor AActor
---@param OtherActor AActor
function UMTOverlapInteractorComponent:OnActorEndOverlap(OverlappedActor, OtherActor) end
---@param OverlappedActor AActor
---@param OtherActor AActor
function UMTOverlapInteractorComponent:OnActorBeginOverlap(OverlappedActor, OtherActor) end


---@class UMTParkingTicketComponent : UActorComponent
---@field Marker AMTARMarker
---@field Interactable UMTInteractableComponent
local UMTParkingTicketComponent = {}



---@class UMTPassengerComponent : UActorComponent
---@field Net_PassengerType EMTPassengerType
---@field Net_BusPassengerParams FMTBusPassengerParams
---@field Net_StartLocation FVector
---@field Net_DestinationLocation FVector
---@field Net_Distance float
---@field Net_Payment int64
---@field Net_PaymentPer100m int64
---@field Net_ResidentId int32
---@field Net_PassengerFlags int32
---@field Net_bArrived boolean
---@field Net_GroupCharacters TArray<AMTCharacter>
---@field InteractionMeshComponent UMTInteractionMeshComponent
---@field InteractionComponent UMTInteractableComponent
---@field DestinationActor AMTInteractionMeshActor
---@field PassengerMarker AMTARMarker
---@field DialogueComponent UMTDialogueComponent
---@field DialogueInteractionComponent UMTInteractableComponent
---@field Net_ReservedPlayerState AMotorTownPlayerState
---@field Net_TimeLimitToDestinationFromStart float
---@field Net_TimeLimitToDestination float
---@field Net_TimeLimitPoint int32
---@field Net_LCComfortSatisfaction int32
---@field Net_SearchAndRescueRadiusRatio float
---@field Server_SearchAndRescueFlareActor AActor
---@field Client_SearchAndRescueFlareActor AActor
---@field Net_FlareActorLocation FVector
local UMTPassengerComponent = {}

function UMTPassengerComponent:OnRep_Payment() end
function UMTPassengerComponent:OnRep_PassengerType() end
function UMTPassengerComponent:OnRep_FlareActorLocation() end
function UMTPassengerComponent:OnRep_Arrived() end


---@class UMTPlayerDataSubsystem : UGameInstanceSubsystem
local UMTPlayerDataSubsystem = {}


---@class UMTPlayerInput : UPlayerInput
local UMTPlayerInput = {}


---@class UMTPlayerItemInventoryAccessor : UMTItemInventoryAccessor
local UMTPlayerItemInventoryAccessor = {}


---@class UMTPlayerNavigation : UObject
---@field PC AMotorTownPlayerController
---@field Destinations TArray<FMTPlayerNavigationDestination>
local UMTPlayerNavigation = {}



---@class UMTPoliceVehicleComponent : UActorComponent
---@field Perception UAIPerceptionComponent
---@field SightConfig UAISenseConfig_Sight
---@field ChaseTargetActor AActor
---@field LastSuspect APawn
---@field Server_PendingTicketSuspects TArray<AMTCharacter>
local UMTPoliceVehicleComponent = {}



---@class UMTPortFowarding : UObject
---@field GetPortListProxy UGetPortListCallbackProxy
---@field PerformAllDevicesProxy UPerformAllDevicesCallbackProxy
local UMTPortFowarding = {}

---@param PortList TArray<FSimpleUPNPInfo>
---@param ErrorCode ESimpleUPNPErrorCode
function UMTPortFowarding:HandlePortListResultFailed(PortList, ErrorCode) end
---@param PortList TArray<FSimpleUPNPInfo>
---@param ErrorCode ESimpleUPNPErrorCode
function UMTPortFowarding:HandlePortListResult(PortList, ErrorCode) end
---@param ErrorCode ESimpleUPNPErrorCode
function UMTPortFowarding:HandlePerformAllDevicesResult(ErrorCode) end
---@param ErrorCode ESimpleUPNPErrorCode
function UMTPortFowarding:HandlePerformAllDevicesFailed(ErrorCode) end


---@class UMTPriceMarkerWidget : UARMarkerWidget
---@field MoneyWidget UMTMoneyWidget
local UMTPriceMarkerWidget = {}



---@class UMTQuestController : UObject
---@field PC AMotorTownPlayerController
---@field Character AMTCharacter
---@field DrivingVehicle AMTVehicle
local UMTQuestController = {}



---@class UMTQuestFrameEntryObject : UObject
local UMTQuestFrameEntryObject = {}


---@class UMTQuestListEntryObject : UObject
local UMTQuestListEntryObject = {}


---@class UMTQuickbar : UWorldSubsystem
local UMTQuickbar = {}


---@class UMTQuickbarSlotDragAndDrop : UDragDropOperation
---@field DragSourceWidget UQuickbarSlotWidget
local UMTQuickbarSlotDragAndDrop = {}



---@class UMTRadio : UGameInstanceSubsystem
---@field BGMAudio UAudioComponent
---@field MediaComponent UMediaSoundComponent
---@field MediaPlayer UMediaPlayer
local UMTRadio = {}



---@class UMTRentalComponent : UActorComponent
---@field Server_RenterPC AMotorTownPlayerController
---@field Net_RenterPlayerGuid FGuid
---@field Net_PaymentPeriodSeconds float
---@field Net_Cost int64
---@field Net_RentalTimeLeftSeconds float
local UMTRentalComponent = {}



---@class UMTReplicationGraph : UReplicationGraph
---@field GridNode UReplicationGraphNode_GridSpatialization2D
---@field AlwaysRelevantNode UReplicationGraphNode_ActorList
---@field MTConnections TArray<FMTRGConnection>
---@field ActorsWithoutNetConnection TArray<AActor>
---@field Actors TSet<FMTReplicationGraphActorData>
---@field ForceUpdateReplicationPeriodFrameActors TSet<AActor>
---@field AlwaysRelevantDistanceBasedFrequencyActors TArray<AActor>
---@field UpdateReplicationPeriodFrameImmediatelyActors TArray<AActor>
local UMTReplicationGraph = {}



---@class UMTRewardEntryObject : UObject
local UMTRewardEntryObject = {}


---@class UMTRewardInfoObject : UObject
local UMTRewardInfoObject = {}


---@class UMTRichTextBlockLinkDecorator : URichTextBlockDecorator
---@field ButtonStyle FButtonStyle
local UMTRichTextBlockLinkDecorator = {}



---@class UMTRoadSideDrawComponent : UPrimitiveComponent
local UMTRoadSideDrawComponent = {}


---@class UMTRoadSignComponent : UActorComponent
---@field SignType EMTRoadSignType
local UMTRoadSignComponent = {}



---@class UMTRolePlayerListObject : UObject
local UMTRolePlayerListObject = {}


---@class UMTRouteDataView : UMTRouteDataViewBase
---@field Route FMTRoute
local UMTRouteDataView = {}



---@class UMTRouteDataViewBase : UObject
local UMTRouteDataViewBase = {}


---@class UMTRouteEditorWaypointObject : UObject
---@field EditorWidget URouteEditorWidget
local UMTRouteEditorWaypointObject = {}



---@class UMTSaveGameSubsystem : UGameInstanceSubsystem
local UMTSaveGameSubsystem = {}


---@class UMTScrollBox : UScrollBox
local UMTScrollBox = {}


---@class UMTSeatComponent : USceneComponent
---@field SeatIndex int32
---@field SeatType EMTSeatType
---@field SeatPositionType EMTSeatPositionType
---@field SeatExitType EMTSeatExitType
---@field Controls TArray<FMTControlPanelControl>
---@field CenterOfMassOffset FVector
---@field CharacterCameraDistanceOverride float
---@field ControlPanel UMTControlPanel
---@field Net_Character AMTCharacter
local UMTSeatComponent = {}

function UMTSeatComponent:OnRep_Character() end
---@param InCharacter AMTCharacter
---@param Location FVector
function UMTSeatComponent:MulticastSeatCharacter(InCharacter, Location) end
function UMTSeatComponent:MulticastExitCharacter() end


---@class UMTSelectVehicleObject : UObject
---@field SelectWidget USelectVehicleWidget
local UMTSelectVehicleObject = {}



---@class UMTSkeletalAeroPartComponent : USkeletalMeshComponent
---@field Net_PartKey FName
---@field Net_PartSlot EMTVehiclePartSlot
---@field PartAnim UAnimationAsset
local UMTSkeletalAeroPartComponent = {}

function UMTSkeletalAeroPartComponent:OnRep_PartKey() end


---@class UMTSkidMark : UWorldSubsystem
---@field SkidMarkMeshComponent UProceduralMeshComponent
local UMTSkidMark = {}



---@class UMTSpace : UWorldSubsystem
local UMTSpace = {}


---@class UMTSpawnVehicleListComponent : USceneComponent
---@field VechileKeys TArray<FName>
---@field VehicleTypes TArray<EMTVehicleType>
---@field VehicleParams TArray<FMTVehicleSpawnPointVehicleParams>
---@field IncludeVehicleTypeFlags int32
---@field ExcludeVehicleTypeFlags int32
---@field GameplayTagQuery FGameplayTagQuery
---@field VehicleRowGameplayTagQuery FGameplayTagQuery
local UMTSpawnVehicleListComponent = {}



---@class UMTSpikePadComponent : USceneComponent
local UMTSpikePadComponent = {}


---@class UMTSpringArmComponent : USpringArmComponent
local UMTSpringArmComponent = {}


---@class UMTStaticMeshAeroPartComponent : UStaticMeshComponent
---@field Net_PartKey FName
---@field Net_PartSlot EMTVehiclePartSlot
local UMTStaticMeshAeroPartComponent = {}

function UMTStaticMeshAeroPartComponent:OnRep_PartKey() end


---@class UMTStaticMeshSpawnerComponent : USceneComponent
---@field MeshParams TArray<FStaticMeshSpawnerMeshParams>
---@field NumTileX int32
---@field NumTileY int32
---@field StepDistance FVector2D
---@field StaticMeshes TArray<UStaticMeshComponent>
---@field InstancedMeshes TArray<UInstancedStaticMeshComponent>
local UMTStaticMeshSpawnerComponent = {}

function UMTStaticMeshSpawnerComponent:RecreateStaticMeshes() end


---@class UMTStrapComponent : UActorComponent
---@field Net_Cargo AMTCargo
---@field Net_Wheel UMHWheelComponent
---@field Net_TargetComponent UPrimitiveComponent
---@field Net_TowingComponent UMTTowingComponent
---@field Net_TowedVehicle AMTVehicle
---@field Net_Transform FTransform
---@field Constraint UMTConstraintComponent
---@field RopeMeshComponents TArray<UProceduralMeshComponent>
---@field BuckleComponents TArray<UStaticMeshComponent>
local UMTStrapComponent = {}

function UMTStrapComponent:OnRep_Wheel() end
function UMTStrapComponent:OnRep_Transform() end
function UMTStrapComponent:OnRep_TowingComponent() end
function UMTStrapComponent:OnRep_TowedVehicle() end
function UMTStrapComponent:OnRep_TargetComponent() end
function UMTStrapComponent:OnRep_Cargo() end
---@param Location FVector
function UMTStrapComponent:MulticastPlayUnStrapSound(Location) end
---@param Location FVector
function UMTStrapComponent:MulticastPlayStrapSound(Location) end
---@param Location FVector
function UMTStrapComponent:MulticastPlayRopeSnapSound(Location) end
---@param ConstraintIndex int32
function UMTStrapComponent:HandleConstraintBroken(ConstraintIndex) end


---@class UMTSummonOwnVehicleObject : UObject
---@field ParkingSpace AMTParkingSpace
---@field Garage AMTGarageActor
---@field SummonWidget UParkingSpaceSummonWidget
---@field DespawnVehicle AMTVehicle
---@field SpawnedVehicle AMTVehicle
local UMTSummonOwnVehicleObject = {}



---@class UMTSuspensionAnimInstance : UAnimInstance
---@field WheelHubLocation FVector
local UMTSuspensionAnimInstance = {}



---@class UMTTankerFuelPumpComponent : UActorComponent
---@field InteractionMeshRelativeLocation FVector
---@field Vehicle AMTVehicle
---@field InteractionMeshComponent UStaticMeshComponent
---@field InteractionComponent UMTInteractableComponent
---@field Marker AMTARMarker
---@field Slots TArray<FMTFuelPumpSlot>
local UMTTankerFuelPumpComponent = {}



---@class UMTTaxiPassengerListObject : UObject
---@field Passenger UMTPassengerComponent
local UMTTaxiPassengerListObject = {}



---@class UMTTirePhysicsDataAsset : UDataAsset
---@field TirePhysicsParams FMTTirePhysicsParams
local UMTTirePhysicsDataAsset = {}



---@class UMTTooltipWidget : UUserWidget
---@field TooltipTextBlock URichTextBlock
local UMTTooltipWidget = {}



---@class UMTTowRequestComponent : UActorComponent
---@field DestinationActor AMTInteractionMeshActor
---@field Marker AMTARMarker
---@field Net_StartLocation FVector
---@field Net_DestinationAbsoluteLocation FVector
---@field Net_Payment int64
---@field Net_bArrived boolean
---@field Net_TowRequestFlags int32
---@field Net_LastWreckerPC AMotorTownPlayerController
---@field Net_PoliceTowingVehicleDriverCharacterGuid FGuid
---@field LastWrecker AMTVehicle
---@field Server_DeliveryVehicleSpawnPoint AMTDeliveryVehicleSpawnPoint
local UMTTowRequestComponent = {}

function UMTTowRequestComponent:OnRep_LastWreckerPC() end


---@class UMTTowingComponent : USphereComponent
---@field HookType EMTTowingHookType
---@field HookSound USoundBase
---@field UnhookSound USoundBase
---@field InteractableComponent UMTInteractableComponent
---@field Strap UMTStrapComponent
---@field DisableCollisionComponents TArray<UPrimitiveComponent>
local UMTTowingComponent = {}

---@param Interactable UMTInteractableComponent
function UMTTowingComponent:HandleInteractionCandidated(Interactable) end


---@class UMTTownConditionComponent : UActorComponent
---@field OnConditionChanged FMTTownConditionComponentOnConditionChanged
---@field MinPopulationBonus float
---@field bUseConditionChangeEvent boolean
local UMTTownConditionComponent = {}

---@param bIsConditionMet boolean
function UMTTownConditionComponent:ConditionChanged__DelegateSignature(bIsConditionMet) end


---@class UMTTownStateListObject : UObject
local UMTTownStateListObject = {}


---@class UMTTrafficLightComponent : UStaticMeshComponent
---@field LightMaterialIndex int32
---@field GreenLightMaterial UMaterialInterface
---@field RedLightMaterial UMaterialInterface
---@field RedBlinkingLightMaterial UMaterialInterface
---@field YellowLightMaterial UMaterialInterface
---@field YellowBlinkingLightMaterial UMaterialInterface
---@field LightState EMTTrafficLightState
local UMTTrafficLightComponent = {}



---@class UMTTrailerHitchComponent : UStaticMeshComponent
---@field UnHookIneractionSphere USphereComponent
---@field UnHookInteractableComponent UMTInteractableComponent
---@field ConnectionType EMTTrailerConnectionType
local UMTTrailerHitchComponent = {}



---@class UMTTransmissionDataAsset : UDataAsset
---@field TransmissionProperty FMHTransmissionProperty
---@field DevComment FString
local UMTTransmissionDataAsset = {}



---@class UMTVehicleAmbulanceComponent : UActorComponent
---@field JobMarker AMTARMarker
local UMTVehicleAmbulanceComponent = {}



---@class UMTVehicleAttachmentPartComponent : UChildActorComponent
---@field Net_PartKey FName
---@field Net_PartSlot EMTVehiclePartSlot
---@field LightControls TArray<UMTLightControlComponent>
local UMTVehicleAttachmentPartComponent = {}

function UMTVehicleAttachmentPartComponent:OnRep_PartKey() end
---@param HitComponent UPrimitiveComponent
---@param OtherActor AActor
---@param OtherComp UPrimitiveComponent
---@param NormalImpulse FVector
---@param Hit FHitResult
function UMTVehicleAttachmentPartComponent:OnAttachmentPartHit(HitComponent, OtherActor, OtherComp, NormalImpulse, Hit) end


---@class UMTVehicleAttachmentPartLinkComponent : UActorComponent
---@field AttachmentPart UMTVehicleAttachmentPartComponent
local UMTVehicleAttachmentPartLinkComponent = {}



---@class UMTVehicleBlinkerLight : USpotLightComponent
---@field BlinkerLightType EMTBlinkerLightType
local UMTVehicleBlinkerLight = {}



---@class UMTVehicleBusComponent : UActorComponent
---@field Net_RouteKey FName
---@field ExternalScreenWidgetClass TSubclassOf<UBusExternalScreenWidget>
---@field ExternalScreenWidgetDrawSize FVector2D
---@field Route FMTBusRoute
---@field WidgetRender UMTWidgetRender
---@field ExternalScreenWidget UBusExternalScreenWidget
---@field LocalControl_ActivatedBusStops TArray<AMTBusStop>
---@field BusJobMarker AMTARMarker
---@field NetLC_NextBusStopIndex int32
---@field LC_ExitPassengerSeats TArray<UMTSeatComponent>
---@field LC_EnterPassengers TArray<AMTCharacter>
---@field NetLC_bPassengerStopBell boolean
---@field RoutePathFinder UMTBusRoutePathFinder
local UMTVehicleBusComponent = {}

---@param bOpen boolean
function UMTVehicleBusComponent:ServerToggleDoor(bOpen) end
---@param bStopBell boolean
function UMTVehicleBusComponent:ServerSetPassengerStopBell(bStopBell) end
---@param StopIndex int32
function UMTVehicleBusComponent:ServerSetNextStop(StopIndex) end
---@param BusStop AMTBusStop
function UMTVehicleBusComponent:ServerOnArriveBusStop(BusStop) end
---@param BusStop AMTBusStop
---@param Seat UMTSeatComponent
function UMTVehicleBusComponent:ServerExitPassenger(BusStop, Seat) end
---@param BusStop AMTBusStop
---@param Character AMTCharacter
function UMTVehicleBusComponent:ServerEnterPassengerCharacter(BusStop, Character) end
---@param BusStop AMTBusStop
function UMTVehicleBusComponent:ServerEnterPassenger(BusStop) end
function UMTVehicleBusComponent:OnRep_RouteKey() end
function UMTVehicleBusComponent:OnRep_NextBusStopIndex() end
---@param TimeLeftSecondsToNextStop float
function UMTVehicleBusComponent:MulticastInitLoadedBus(TimeLeftSecondsToNextStop) end


---@class UMTVehicleCargoSpaceComponent : UBoxComponent
---@field CargoSpaceType EMTCargoSpaceType
---@field bFixCargo boolean
---@field bCanLoadCargo boolean
---@field bUnlimitedHeight boolean
---@field DumpVolume float
---@field bUseDumpPileActor boolean
---@field AllowedFuelTypes TArray<EMTFuelType>
---@field DumpCargoSurfaceMesh UStaticMesh
---@field DumpCargoSurfaceSlopeYAngleDegree float
---@field bAllowPutdownCargoByInteraction boolean
---@field InteractableComponent UMTInteractableComponent
---@field DumpMeshComponent UStaticMeshComponent
---@field DumpPileActor AMTDumpPileActor
---@field DummyCargoInteractable UMTInteractableComponent
---@field Net_Cargos TArray<AMTCargo>
---@field Net_DroppedCargos TArray<AMTCargo>
---@field Net_BoxExtent FVector
---@field Net_LoadedItemType EMTCargoSpaceLoadedItemType
---@field Net_LoadedItemVolume float
---@field Net_CargoSpaceRuntimeFlags uint32
---@field DroppedCargoCandidates TMap<AMTCargo, float>
---@field Net_CarryingVehicles TArray<AMTVehicle>
---@field OverlappedVehicles TArray<AMTVehicle>
local UMTVehicleCargoSpaceComponent = {}

function UMTVehicleCargoSpaceComponent:OnRep_LoadedItemVolumeChanged() end
function UMTVehicleCargoSpaceComponent:OnRep_Cargoes() end
function UMTVehicleCargoSpaceComponent:OnRep_BoxExtent() end
---@param Cargos TArray<AMTCargo>
---@param RelativeLocations TArray<FVector>
---@param RelativeRotations TArray<FRotator>
function UMTVehicleCargoSpaceComponent:MulticastSetCargoLocations(Cargos, RelativeLocations, RelativeRotations) end
---@param NewDroppedCargos TArray<AMTCargo>
function UMTVehicleCargoSpaceComponent:MulticastCargoDropped(NewDroppedCargos) end
---@param OverlappedComponent UPrimitiveComponent
---@param OtherActor AActor
---@param OtherComp UPrimitiveComponent
---@param OtherBodyIndex int32
function UMTVehicleCargoSpaceComponent:HandleEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex) end
---@param OverlappedComponent UPrimitiveComponent
---@param OtherActor AActor
---@param OtherComp UPrimitiveComponent
---@param OtherBodyIndex int32
---@param bFromSweep boolean
---@param SweepResult FHitResult
function UMTVehicleCargoSpaceComponent:HandleBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult) end


---@class UMTVehicleDoorComponent : UStaticMeshComponent
---@field DoorId int32
---@field DoorType EMTVehicleDoorType
---@field DoorFlags int32
---@field InteractionName FText
---@field HingeSocketName FName
---@field SkeletalMeshComponentName FName
---@field DoorOpenAnim UAnimationAsset
---@field SkeletalMeshComponent USkeletalMeshComponent
---@field DoorMoveType EMTDoorMoveType
---@field DoorMaxAngleDegree float
---@field DoorAngleSpeed float
---@field RotateAxis FVector
---@field SlidingVector FVector
---@field SlidingMaxDistance float
---@field SlidingSpeed float
---@field SlidingVector2 FVector
---@field SlidingMaxDistance2 float
---@field ExtendRange FVector2D
---@field bScaleWhileSliding boolean
---@field ScaleTarget FVector
---@field DoorSound USoundBase
---@field DoorOpenSound USoundBase
---@field DoorOpenedSound USoundBase
---@field DoorClosedSound USoundBase
---@field SyncedDoorNames TArray<FName>
---@field SyncedDoors TArray<UMTVehicleDoorComponent>
---@field InteractableComponent UMTInteractableComponent
---@field DoorAudioComponent UAudioComponent
---@field InteractionsWhileOpened TArray<EMotorTownInteractableType>
---@field OpenedInteractionSphereComponent USphereComponent
---@field OpenedInteractable UMTInteractableComponent
---@field ControlPanel UMTControlPanel
---@field Net_CurrentAngle float
---@field Net_CurrentSlide float
---@field Net_SavedExtendedRange FVector2D
---@field Net_bInManualMode boolean
---@field Net_DoorState EMTVehicleDoorState
local UMTVehicleDoorComponent = {}

function UMTVehicleDoorComponent:OnRep_SavedExtendedRange() end
function UMTVehicleDoorComponent:OnRep_DoorState() end
function UMTVehicleDoorComponent:MulticastOpened() end
function UMTVehicleDoorComponent:MulticastOpen() end
function UMTVehicleDoorComponent:MulticastClosed() end
function UMTVehicleDoorComponent:MulticastClose() end
---@param Interactable UMTInteractableComponent
function UMTVehicleDoorComponent:HandleInteractableCandidated(Interactable) end


---@class UMTVehicleEmergencyLight : USpotLightComponent
local UMTVehicleEmergencyLight = {}


---@class UMTVehicleFireFightingComponent : UActorComponent
---@field JobMarker AMTARMarker
local UMTVehicleFireFightingComponent = {}



---@class UMTVehicleHeadLight : USpotLightComponent
---@field bHighBeamOnly boolean
---@field FogLight USpotLightComponent
local UMTVehicleHeadLight = {}



---@class UMTVehicleLOD : UWorldSubsystem
local UMTVehicleLOD = {}

---@param HUD AMTHUD
function UMTVehicleLOD:OnHUDDraw(HUD) end


---@class UMTVehicleNavModifierComponent : UNavRelevantComponent
---@field AreaClass TSubclassOf<UNavArea>
local UMTVehicleNavModifierComponent = {}



---@class UMTVehiclePartItemInventoryAccessor : UMTItemInventoryAccessor
---@field Vehicle AMTVehicle
local UMTVehiclePartItemInventoryAccessor = {}



---@class UMTVehiclePartSlotComponent : UChildActorComponent
local UMTVehiclePartSlotComponent = {}


---@class UMTVehicleReverseLight : USpotLightComponent
local UMTVehicleReverseLight = {}


---@class UMTVehicleRootComponent : USphereComponent
---@field BottomLocations TArray<FVector>
---@field BottomSphereRadius float
---@field Vehicle AMTVehicle
local UMTVehicleRootComponent = {}

function UMTVehicleRootComponent:GenerateBottomSpheres() end
function UMTVehicleRootComponent:ApplyBottomSpheresToBlueprint() end


---@class UMTVehicleTailLight : USpotLightComponent
---@field TailLightType EMTTailLightType
---@field BrightIntensityMultiplier float
local UMTVehicleTailLight = {}



---@class UMTVehicleTaxiComponent : UActorComponent
---@field TaxiJobMarker AMTARMarker
---@field TaxiType EMTTaxiType
local UMTVehicleTaxiComponent = {}



---@class UMTVehicleTrailerComponent : USphereComponent
---@field ConnectionType EMTTrailerConnectionType
---@field HookSound USoundBase
---@field UnhookSound USoundBase
---@field TrailerMarker AMTARMarker
local UMTVehicleTrailerComponent = {}



---@class UMTVehicleTruckComponent : UActorComponent
---@field TruckJobMarker AMTARMarker
local UMTVehicleTruckComponent = {}



---@class UMTVehicleUtilitySlotComponent : UBoxComponent
---@field PartSlot EMTVehiclePartSlot
local UMTVehicleUtilitySlotComponent = {}



---@class UMTVehicleWreckerComponent : UActorComponent
---@field WreckerJobMarker AMTARMarker
local UMTVehicleWreckerComponent = {}



---@class UMTVenderSellItem : UObject
local UMTVenderSellItem = {}


---@class UMTVendorComponent : UActorComponent
---@field SellItems TArray<FName>
---@field SellItemTypes TArray<EMTItemType>
---@field GameplayTagQuery FGameplayTagQuery
local UMTVendorComponent = {}



---@class UMTVoiceLineDataAsset : UDataAsset
---@field VoiceLineTable UDataTable
---@field VoiceLines TMap<EMTVoiceLineType, FMTVoiceLineRow>
local UMTVoiceLineDataAsset = {}



---@class UMTWaterSprayComponent : USceneComponent
---@field InitialVelocity float
---@field InitialRadius float
---@field WaterSpraySound USoundBase
---@field WaterSprayAudioComponent UAudioComponent
---@field ExtinguishSteamAudioComponent UAudioComponent
---@field WaterSprayPhysicalMaterial UPhysicalMaterial
---@field Net_bSpraying boolean
---@field TankerCargoSpaces TArray<UMTVehicleCargoSpaceComponent>
local UMTWaterSprayComponent = {}

function UMTWaterSprayComponent:OnRep_Spraying() end


---@class UMTWebServer : UObject
local UMTWebServer = {}


---@class UMTWidgetRender : UObject
---@field RenderTarget UTextureRenderTarget2D
---@field Widget UUserWidget
local UMTWidgetRender = {}



---@class UMTWinchComponent : UStaticMeshComponent
---@field InteractableComponent UMTInteractableComponent
---@field CableComponent UCableComponent
---@field MotorSoundComponent UAudioComponent
---@field AxleMeshComponent UStaticMeshComponent
---@field HookMeshComponent UStaticMeshComponent
---@field RopeCrackingSoundComponent UAudioComponent
---@field Net_WinchPartKey FName
---@field Net_WinchPartSlot EMTVehiclePartSlot
---@field PartRow FVehiclePartRow
---@field Net_HookActor AActor
---@field Net_ControllerActor AActor
---@field Net_bAttached boolean
---@field Net_AttachedActor AActor
---@field Net_AttachedComponent UPrimitiveComponent
---@field Net_AttachedLocation FVector
---@field Net_AttachTransformSpace ERelativeTransformSpace
---@field Net_Length float
---@field Net_WinchControl EMTWinchControl
---@field Net_bNotEnoughForce boolean
local UMTWinchComponent = {}

function UMTWinchComponent:OnRep_WinchPartKey() end
function UMTWinchComponent:OnRep_NotEnoughForce() end
function UMTWinchComponent:OnRep_Length() end
function UMTWinchComponent:OnRep_HookAndControllerActor() end
function UMTWinchComponent:OnRep_Attached() end
---@param AbsoluteLocation FVector
function UMTWinchComponent:MulticastPlayRopeSnapSound(AbsoluteLocation) end
function UMTWinchComponent:HandleRopeLengthChanged() end
function UMTWinchComponent:HandleControlChanged() end


---@class UMTWingComponent : UStaticMeshComponent
---@field ControlSurfaceType EMTWingControlSurfaceType
---@field ControlSurfaceDeflectionDegreeRange FVector2D
---@field ControlMultiplier float
local UMTWingComponent = {}



---@class UMTWorldPartitionHiderComponent : UActorComponent
---@field WorldPartition UWorldPartition
local UMTWorldPartitionHiderComponent = {}



---@class UMTWorldVehicleDespawnComponent : UActorComponent
---@field Vehicle AMTVehicle
---@field SpawnPoint AActor
local UMTWorldVehicleDespawnComponent = {}



---@class UMTZoneStateListObject : UObject
local UMTZoneStateListObject = {}


---@class UMainMenuWidget : UUserWidget
---@field NewProfileWidgetClass TSubclassOf<UCharacterCreationWidget>
---@field CharacterListWidgetClass TSubclassOf<UCharacterListWidget>
---@field NewVersionWidgetClass TSubclassOf<UNewVersionWidget>
---@field MotorTownWeb UWebBrowser
---@field ConnectingTextBlock UTextBlock
---@field VersionTextBlock UTextBlock
---@field NoticeWidget UWidget
---@field NoticeWebBrowser UWebBrowser
local UMainMenuWidget = {}

function UMainMenuWidget:ReloadWebpage() end
---@param URL FText
function UMainMenuWidget:HandleWebUrlChanged(URL) end
---@param URL FString
---@param Frame FString
function UMainMenuWidget:HandleWebBeforePopup(URL, Frame) end
function UMainMenuWidget:HandleProfileModified() end


---@class UMapAreaNameWidget : UUserWidget
---@field TextScaleBox UScaleBox
---@field AreaNameTextBlock UTextBlock
local UMapAreaNameWidget = {}



---@class UMapBaseWidget : UUserWidget
---@field MapImage UImage
---@field MapCanvasPanel UCanvasPanel
---@field MapSearchWidget UMapSearchWidget
---@field bSyncFilterWithSettings boolean
---@field IconRows TArray<FMTMapIconRow>
---@field MyLocationIcon UImage
---@field NavigationMap UNavigationMapWidget
---@field WidgetPool FUserWidgetPool
---@field DeliverReceiverIconWidget UUserWidget
---@field GameplayTagsEventRegisteredActors TArray<AActor>
local UMapBaseWidget = {}



---@class UMapFilterWidget : UUserWidget
---@field FilterNameTextBlock UTextBlock
---@field FilterInCheckBox UCheckBox
---@field MapWidget UMapBaseWidget
local UMapFilterWidget = {}

---@param bIsChecked boolean
function UMapFilterWidget:HandleCheckChanged(bIsChecked) end


---@class UMapIconWidget : UUserWidget
---@field IconSizeBox USizeBox
---@field HighTextOverlay UOverlay
---@field LowTextOverlay UOverlay
---@field HighTextBlock URichTextBlock
---@field LowTextBlock URichTextBlock
---@field SubWidget UUserWidget
local UMapIconWidget = {}

---@param bSelected boolean
function UMapIconWidget:ReceiveSelected(bSelected) end
---@param bInHighlighted boolean
function UMapIconWidget:ReceiveHighlighted(bInHighlighted) end


---@class UMapSearchResultEntryObject : UObject
---@field IconRow FMTMapIconRow
local UMapSearchResultEntryObject = {}



---@class UMapSearchResultEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock URichTextBlock
local UMapSearchResultEntryWidget = {}



---@class UMapSearchWidget : UUserWidget
---@field StringSearchBox UStringSearchBoxWidget
---@field SearchResultListView UMTListView
---@field IconRows TArray<FMTMapIconRow>
local UMapSearchWidget = {}



---@class UMenuPlayerListEntryWidget : UUserWidget
---@field NameTextBlock URichTextBlock
---@field LevelsHorizontalBox UHorizontalBox
---@field MoreButton UMTButtonWidget
---@field LevelWidgetPadding FMargin
---@field PlayerState AMotorTownPlayerState
---@field LevelWidgets TMap<int32, ULevelWidget>
local UMenuPlayerListEntryWidget = {}



---@class UMiniInventorySlotWidget : UUserWidget
---@field ItemWidget UItemWidget
---@field HoldingHighlight UBorder
local UMiniInventorySlotWidget = {}



---@class UMiniInventoryWidget : UUserWidget
---@field SlotWidgetClass TSubclassOf<UMiniInventorySlotWidget>
---@field SlotsWrapBox UWrapBox
---@field SlotWidgets TArray<UMiniInventorySlotWidget>
local UMiniInventoryWidget = {}



---@class UMinimapWidget : UMapBaseWidget
---@field OrientationCompasWidget UMTOrientationCompasWidget
---@field SpeedLimitSignWidget USpeedLimitSignWidget
local UMinimapWidget = {}



---@class UMirrorControlWidget : UUserWidget
---@field SettingsVerticalBox UVerticalBox
---@field Vehicle AMTVehicle
---@field PitchSetting USettingWidget
---@field YawSetting USettingWidget
---@field CurvatureSetting USettingWidget
local UMirrorControlWidget = {}



---@class UModalessDialogPopupWidget : UDialogPopupWidget
local UModalessDialogPopupWidget = {}


---@class UMoneyButtonWidget : UMTButtonWidget
---@field MoneyWidget UMTMoneyWidget
local UMoneyButtonWidget = {}



---@class UMotorTownDrivingAI : UObject
---@field Vehicle AMTVehicle
---@field TrackCourse AMotorTownRoad
---@field SignComponents TArray<UMTRoadSignComponent>
local UMotorTownDrivingAI = {}



---@class UMotorTownFXAsset : UDataAsset
---@field WeatherEnvSounds TMap<EMTWeather, USoundCue>
---@field RainNS UNiagaraSystem
---@field EngineOverheatSmokeParticle UParticleSystem
---@field ExhaustNS UNiagaraSystem
---@field TireSmokeParticle UParticleSystem
---@field TireSkidSound USoundCue
---@field TireRoadNoiseSound USoundCue
---@field FlatTireRoadNoiseSound USoundCue
---@field SkidMarkMaterial UMaterialInterface
---@field WheelSurfaceSounds TMap<EMotorTownSurface, USoundCue>
---@field WheelSurfaceEnvSounds TMap<EMotorTownSurfaceEnv, USoundCue>
---@field WheelSurfaceLoopNSs TMap<EMotorTownSurfaceEnv, UNiagaraSystem>
---@field WheelSurfaceEnvNSs TMap<EMotorTownSurfaceEnv, UNiagaraSystem>
---@field WheelSurfaceParticles TMap<EMotorTownSurface, UParticleSystem>
---@field WheelSurfaceDebrisParticles TMap<EMotorTownSurface, UParticleSystem>
---@field TireBumpSounds TMap<EMotorTownSurface, USoundCue>
---@field VehicleToVehicleImpactSound USoundBase
---@field SurfaceHitSoundTable TMap<EMotorTownSurface, FMTSurfaceHitSoundTable>
---@field SurfaceSlidingSoundTable TMap<EMotorTownSurface, FMTSurfaceHitSoundTable>
---@field SurfaceSlidingParticleTable TMap<EMotorTownSurface, FMTSurfaceParticleTable>
---@field FootStepSounds TMap<EMotorTownSurface, USoundCue>
---@field FireCellNS UNiagaraSystem
---@field FireSpottingSmokeNS UNiagaraSystem
---@field WaterSprayPointNS UNiagaraSystem
---@field SteamNS UNiagaraSystem
local UMotorTownFXAsset = {}



---@class UMotorTownGameInstance : UGameInstance
---@field GameResource UMTGameResource
local UMotorTownGameInstance = {}



---@class UMotorTownPhysicalMaterial : UPhysicalMaterial
---@field StaticFrictionMultiplier float
---@field SlidingFrictionMultiplier float
---@field TireHeatMultiplier float
---@field RollingResistance float
---@field HeightNoise float
---@field bAllowDigging boolean
---@field DiggingDepth FVector2D
---@field DiggingSpeed float
---@field DiggingSpeedMultiplierByWeightKg float
---@field DiggingSpeedMultiplierByWeightKgRange FVector2D
---@field DiggingDepthByWeightKg float
---@field DiggingDepthByWeightKgRange FVector2D
---@field DiggingResistForceMultiplier float
---@field bIsOffroad boolean
local UMotorTownPhysicalMaterial = {}



---@class UMotorTownRoadSplineDrawComponent : UPrimitiveComponent
local UMotorTownRoadSplineDrawComponent = {}


---@class UMotorTownUserSettings : UGameUserSettings
---@field DriveModeSessionName FString
---@field RaceModeSessionName FString
---@field TimeAttackModeSessionName FString
---@field SessionPasswordMD5 FString
---@field GameInstance UMotorTownGameInstance
---@field bAutoShift boolean
---@field AutoReverse EMTAutoReverseType
---@field bAutoStartEngine boolean
---@field SteeringAssistStrength float
---@field KeyboardSteeringSpeed float
---@field TractionControllStrength float
---@field StabilityControllStrength float
---@field ABSStrength float
---@field BGMVolume float
---@field ShowMirror EMTShowMirror
---@field ChaseCameraFOV float
---@field CockpitCameraFOV float
---@field GhostCarVisibility EGhostCarVisibility
---@field AllowJoinType EMTAllowJoinType
---@field ControlSettingsPresetGuid FGuid
---@field DrivingController EMTDrivingController
---@field InputKeyMappings TArray<FMTInputKeyMapping>
---@field MouseSteering FMTMouseSteeringSettings
---@field ForceFeedback FMTForceFeedbackSettings
---@field Rumble FMTRumbleSettings
---@field bAskedForDriveByGamepad boolean
---@field VehicleCameraMode EVehicleCameraMode
---@field Values TMap<EMTUserSettingType, FMTUserSettingValue>
---@field LastPlayredCharcterSlot int32
---@field MigrationVersion int32
---@field InternetRadioStaionName FString
---@field WorldMapFilters TArray<EMTMapFilterType>
---@field Admins TArray<FMTAdmin>
---@field BannedPlayers TArray<FMTBannedPlayer>
---@field ServerMessage FString
---@field ColorPalette TArray<FColor>
---@field ColorPaletteV2 TArray<FMTColorPaletteItem>
---@field FavoriteServerNames TArray<FString>
---@field PatrolTargetZoneKeys TArray<FName>
---@field PoliceRolePlayers TArray<FMTRolePlayer>
local UMotorTownUserSettings = {}



---@class UMyVehiclesComboBoxWidget : UUserWidget
---@field OnSelectionChanged FMyVehiclesComboBoxWidgetOnSelectionChanged
---@field VehiclesComboBox UComboBoxString
local UMyVehiclesComboBoxWidget = {}

function UMyVehiclesComboBoxWidget:OnSelectionChanged__DelegateSignature() end
---@param SelectedItem FString
---@param SelectionType ESelectInfo::Type
function UMyVehiclesComboBoxWidget:OnComboSelectionChanged(SelectedItem, SelectionType) end
---@return int64
function UMyVehiclesComboBoxWidget:GetSelectedVehicleId() end


---@class UNameTagWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field PostfixTextBlock URichTextBlock
local UNameTagWidget = {}



---@class UNavigationMapWidget : UUserWidget
---@field ZoneVolumeBrush FSlateBrush
---@field ZoneVolumeLineColor FLinearColor
---@field ZoneVolumeFont FSlateFontInfo
---@field PoliceAreaBrush FSlateBrush
local UNavigationMapWidget = {}



---@class UNewVersionWidget : UUserWidget
---@field MyVersionTextBlock UTextBlock
---@field NewVersionTextBlock UTextBlock
local UNewVersionWidget = {}



---@class UOKButtonWidget : UMTButtonWidget
local UOKButtonWidget = {}


---@class UPaintShopWidget : UUserWidget
---@field ColorButtonWidgetClass TSubclassOf<UUserWidget>
---@field ColorSelectionVerticalBox UVerticalBox
local UPaintShopWidget = {}

---@param Vehicle AMTVehicle
function UPaintShopWidget:SetVehicle(Vehicle) end


---@class UParkingSpaceSummonWidget : UUserWidget
---@field ParkedVehicleVerticalBox UVerticalBox
---@field ParkedVehicleWidget USummonOwnVehicleEntryWidget
---@field OwnVehiclesButton UMTButtonWidget
---@field CompanyVehiclesButton UMTButtonWidget
---@field OwnVehicleListView UMTListView
---@field VehicleInfo UVehicleInfoWidget
---@field FilterSpinBox USpinBoxString
---@field SortSpinBox USpinBoxString
---@field DespawnButton UMTButtonWidget
---@field MapWidget UWorldMapWidget
---@field StringSearchBox UStringSearchBoxWidget
---@field FilterTagBox UTagBoxString
---@field ParkingSpace AMTParkingSpace
---@field Garage AMTGarageActor
---@field Vehicle AMTVehicle
---@field SelectedSpawnedVehicle AMTVehicle
local UParkingSpaceSummonWidget = {}



---@class UPassengerWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field DestinationTextBlock UTextBlock
---@field DistanceTextBlock UTextBlock
---@field LeaveButton UMTButtonWidget
---@field Character AMTCharacter
---@field Passenger UMTPassengerComponent
local UPassengerWidget = {}



---@class UPassengersWidget : UUserWidget
---@field PassengerWidgetClass TSubclassOf<UPassengerWidget>
---@field PassengersVerticalBox UVerticalBox
---@field Vehicle AMTVehicle
local UPassengersWidget = {}



---@class UPlayerLevelAndNameWidget : UUserWidget
---@field DriverLevelTextBlock UTextBlock
---@field NameTextBlock URichTextBlock
local UPlayerLevelAndNameWidget = {}



---@class UPlayerListEntryWidget : UUserWidget
---@field DriverLevelTextBlock UTextBlock
---@field NameTextBlock URichTextBlock
---@field PlayerState AMotorTownPlayerState
local UPlayerListEntryWidget = {}



---@class UPlayerListWidget : UUserWidget
---@field PlayerListView UListView
---@field LeavePartyButton UMTButtonWidget
---@field StringSearchBox UStringSearchBoxWidget
local UPlayerListWidget = {}

---@param PlayerState AMotorTownPlayerState
function UPlayerListWidget:OnPlayerStateRemoved(PlayerState) end
---@param PlayerState AMotorTownPlayerState
function UPlayerListWidget:OnPlayerStateAdded(PlayerState) end


---@class UPoliceControlPanelWidget : UUserWidget
---@field AutoAcceptSuspectSetting UUserSettingItemWidget
---@field AutoAcceptPatrolSetting UUserSettingItemWidget
---@field AllowPatrolOffroadSetting UUserSettingItemWidget
---@field ZoneListView UMTListView
---@field PatrolListView UMTListView
---@field PatrolMapWidget UWorldMapWidget
local UPoliceControlPanelWidget = {}



---@class UPoliceListEntryWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field DeleteButton UMTButtonWidget
local UPoliceListEntryWidget = {}



---@class UPoliceMissionWidget : UUserWidget
---@field SuspectsTextBlock UTextBlock
local UPoliceMissionWidget = {}



---@class UPolicePatrolPointEntryWidget : UMTListViewEntryWidget
---@field PatrolTextBlock UTextBlock
---@field DistanceTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field OffroadTextBlock URichTextBlock
---@field SetDestinationButton UMTButtonWidget
local UPolicePatrolPointEntryWidget = {}

function UPolicePatrolPointEntryWidget:HandleSetDestinationButtonClicked() end


---@class UPolicePatrolPointListObject : UObject
---@field ZoneVolume AMTAreaVolume
local UPolicePatrolPointListObject = {}



---@class UPolicePatrolZoneEntryWidget : UMTListViewEntryWidget
---@field SelectCheckBox UCheckBoxWidget
local UPolicePatrolZoneEntryWidget = {}



---@class UPolicePatrolZoneListObject : UObject
---@field ZoneVolume AMTAreaVolume
local UPolicePatrolZoneListObject = {}



---@class UProductionInputWidget : UUserWidget
---@field CargoNameTextBlock UTextBlock
---@field AmountTextBlock UTextBlock
---@field DeliveryPoint AMTDeliveryPoint
local UProductionInputWidget = {}



---@class UProductionItemWidget : UUserWidget
---@field InputWidgetClass TSubclassOf<UProductionInputWidget>
---@field OutputWidgetClass TSubclassOf<UProductionOutputWidget>
---@field InputVerticalBox UVerticalBox
---@field OutputVerticalBox UVerticalBox
---@field ProductionProgressBar UProgressBar
---@field TimeLeftRichTextBlock URichTextBlock
local UProductionItemWidget = {}



---@class UProductionOutputWidget : UUserWidget
---@field CargoNameTextBlock URichTextBlock
---@field AmountTextBlock UTextBlock
---@field DeliveryPoint AMTDeliveryPoint
local UProductionOutputWidget = {}



---@class UProfileWidget : UUserWidget
---@field NicknameTextBox UEditableTextBox
local UProfileWidget = {}

function UProfileWidget:Apply() end


---@class UProgressBarGaugeWidget : UUserWidget
---@field GaugeProgressBar UProgressBar
---@field Colors TArray<FMTProgressBarGaugeColor>
local UProgressBarGaugeWidget = {}

---@param Percent float
function UProgressBarGaugeWidget:SetPercent(Percent) end
---@param Brush FSlateBrush
function UProgressBarGaugeWidget:ReceiveSetIconBrush(Brush) end


---@class UProgressWiget : UUserWidget
---@field ProgressBar UProgressBar
---@field ProgressTextBlock UTextBlock
local UProgressWiget = {}



---@class UQuestFrameEntryWidget : UUserWidget
---@field QusetNameTextBlock URichTextBlock
local UQuestFrameEntryWidget = {}

---@param bIsDestination boolean
function UQuestFrameEntryWidget:ReceiveSetAsDestination(bIsDestination) end


---@class UQuestFrameWidget : UUserWidget
---@field QuestListView UListView
local UQuestFrameWidget = {}



---@class UQuestListEntryWidget : UMTListViewEntryWidget
---@field QusetNameTextBlock URichTextBlock
---@field SetAsDestinationButton UMTButtonWidget
---@field SkipButton UMTButtonWidget
---@field RestartButton UMTButtonWidget
local UQuestListEntryWidget = {}



---@class UQuestListWidget : UUserWidget
---@field InProgressQuestButton UMTButtonWidget
---@field CompletedQuestButton UMTButtonWidget
---@field QuestListView UListView
---@field QuestDescriptionTextBlock URichTextBlock
---@field SetDestinationButton UMTButtonWidget
local UQuestListWidget = {}



---@class UQuickbarSlotWidget : UUserWidget
---@field DragWidgetClass TSubclassOf<UItemWidget>
---@field Overlay UOverlay
---@field KeyIconWidget UKeyIconWidget
---@field IconImage UImage
---@field HoldingHighlight UBorder
---@field NumStackTextBlock UTextBlock
local UQuickbarSlotWidget = {}



---@class UQuickbarWidget : UUserWidget
---@field SlotWidgetClass TSubclassOf<UQuickbarSlotWidget>
---@field MouseModeHighlight UWidget
---@field SlotsHorizontalBox UHorizontalBox
---@field SlotWidgets TArray<UQuickbarSlotWidget>
local UQuickbarWidget = {}



---@class URaceDriverWidget : UUserWidget
---@field PositionTextBlock UTextBlock
---@field NameTextBlock UTextBlock
local URaceDriverWidget = {}



---@class URaceLapsWidget : UUserWidget
---@field CurrentLapTextBlock UTextBlock
---@field TotalLapsTextBlock UTextBlock
local URaceLapsWidget = {}



---@class URaceMissionSideBarWidget : UUserWidget
---@field DriverWidgetClass TSubclassOf<URaceDriverWidget>
---@field DriversVerticalBox UVerticalBox
local URaceMissionSideBarWidget = {}



---@class URacePositionEntryWidget : UUserWidget
---@field PositionTextBlock UTextBlock
---@field DriverNameTextBlock URichTextBlock
---@field MyBG UUserWidget
---@field LaptimeTextBlock URichTextBlock
local URacePositionEntryWidget = {}



---@class URacePositionListItem : UObject
local URacePositionListItem = {}


---@class URacePositionListWidget : UUserWidget
---@field ListView UMTListView
local URacePositionListWidget = {}



---@class URacePositionWidget : UUserWidget
---@field CurrentPosTextBlock UTextBlock
---@field TotalDriversTextBlock UTextBlock
local URacePositionWidget = {}



---@class URaceSettingWidget : UUserWidget
---@field bShowLevels boolean
---@field bShowVehicles boolean
---@field LevelsLabel UTextBlock
---@field VehiclesLabel UTextBlock
---@field LevelsSpinBox USpinBoxString
---@field VehiclesSpinBox USpinBoxString
---@field LapsSpinBox USpinBoxString
---@field AIDriversSpinBox USpinBoxString
---@field AIVehicle0 USpinBoxString
---@field AIVehicle1 USpinBoxString
local URaceSettingWidget = {}



---@class URaceTimeWidget : UUserWidget
---@field SectionLaptimeWidgetClass TSubclassOf<ULaptimeTextWidget>
---@field LaptimeHistoryWidgetClass TSubclassOf<ULaptimeTextWidget>
---@field LaptimeTextBlock UTextBlock
---@field LaptimeHistoryVerticalBox UVerticalBox
---@field SectionLaptimeVerticalBox UVerticalBox
---@field Vehicle AMTVehicle
---@field SectionLaptimeWidgets TArray<ULaptimeTextWidget>
local URaceTimeWidget = {}

---@param InVehicle AMTVehicle
function URaceTimeWidget:SetVehicle(InVehicle) end


---@class URadioWidget : UUserWidget
---@field TabMenu UTabMenuTemplateWidget
---@field VolumeSettingVerticalBox UVerticalBox
---@field StationListView UListView
---@field RadioStatusTextBlock URichTextBlock
local URadioWidget = {}



---@class URefuelingWidget : UUserWidget
---@field TitleTextBlock UTextBlock
---@field ProgressWidget UProgressWiget
---@field StopButton UMTButtonWidget
---@field Vehicle AMTVehicle
local URefuelingWidget = {}



---@class URentalStatusWidget : UUserWidget
---@field TimeLeftTextBlock UTextBlock
local URentalStatusWidget = {}



---@class URescueRequestMapPopupWidget : UUserWidget
---@field AbandonJobButton UMTButtonWidget
local URescueRequestMapPopupWidget = {}



---@class URewardEntry : UUserWidget
---@field ListItemBG UWidget
---@field NameTextBlock UTextBlock
---@field DetailTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field ExpWidget UExpWidget
local URewardEntry = {}



---@class URewardInfoEntry : UUserWidget
local URewardInfoEntry = {}


---@class URewardWidget : UUserWidget
---@field TitleTextBlock UTextBlock
---@field RewardListView UListView
---@field TotalPaymentWidget UMTMoneyWidget
---@field DriverLevelProgressWidget ULevelProgressWidget
---@field LevelProgressWidget ULevelProgressWidget
local URewardWidget = {}



---@class URoadsideServiceWidget : UUserWidget
---@field RefuelingButton UMTButtonWidget
---@field TowToRoadButton UMTButtonWidget
---@field TowToGarageButton UMTButtonWidget
---@field SuspectMessage UTextBlock
---@field ButtonsBox UWidget
---@field TowLocationsBoxWidget UWidget
---@field MapWidget UWorldMapWidget
---@field TowLocationButtonsBox UVerticalBox
---@field TowingLocationMapIconWidgetClass TSubclassOf<UUserWidget>
---@field MoneyButtonWidgetClass TSubclassOf<UMoneyButtonWidget>
---@field Vehicle AMTVehicle
---@field TowLocationButtons TArray<UMoneyButtonWidget>
local URoadsideServiceWidget = {}



---@class URouteEditorWaypointEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock UTextBlock
---@field UpButton UMTButtonWidget
---@field DownButton UMTButtonWidget
---@field RemoveButton UMTButtonWidget
local URouteEditorWaypointEntryWidget = {}



---@class URouteEditorWidget : UUserWidget
---@field RouteNameTextBox UEditableTextBox
---@field MapWidget UWorldMapWidget
---@field WaypointListView UMTListView
---@field OkButton UMTButtonWidget
---@field ExportButton UMTButtonWidget
---@field ImportButton UMTButtonWidget
---@field RouteCountTextBlock UTextBlock
---@field MapMessageBox UWidget
---@field MapMessageRichTextBlock URichTextBlock
---@field Route UMTRouteDataViewBase
local URouteEditorWidget = {}

---@param Text FText
function URouteEditorWidget:HandleNameTextBoxChanged(Text) end


---@class USeatLayoutWidget : UUserWidget
---@field SeatWidgetClass TSubclassOf<USeatWidget>
---@field CabinSizeBox USizeBox
---@field CabinCanvas UCanvasPanel
local USeatLayoutWidget = {}



---@class USeatPositionWidget : UUserWidget
---@field ForwardSpinBoxString USpinBoxString
---@field UpSpinBoxString USpinBoxString
---@field SteeringWheelDistanceSpinBoxString USpinBoxString
---@field SteeringWheelHeightSpinBoxString USpinBoxString
---@field Vehicle AMTVehicle
local USeatPositionWidget = {}



---@class USeatWidget : UUserWidget
local USeatWidget = {}


---@class USelectVehicleEntryWidget : UMTListViewEntryWidget
---@field VehicleNameTextBlock URichTextBlock
---@field VehicleData1TextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field SelectButton UMTButtonWidget
local USelectVehicleEntryWidget = {}



---@class USelectVehicleWidget : UUserWidget
---@field FilterSpinBox USpinBoxString
---@field SortSpinBox USpinBoxString
---@field VehicleListView UMTListView
---@field VehicleInfo UVehicleInfoWidget
---@field StringSearchBox UStringSearchBoxWidget
local USelectVehicleWidget = {}



---@class UServerInfoWidget : UUserWidget
---@field ServerInfoText UTextBlock
local UServerInfoWidget = {}



---@class UServerListObject : UObject
local UServerListObject = {}


---@class UServerListRowWidget : UMTListViewEntryWidget
---@field NumPlayersTextBlock UTextBlock
---@field PrefixTextBlock URichTextBlock
---@field ServerNameTextBlock URichTextBlock
---@field GameTypeTextBlock UTextBlock
---@field PingTextBlock URichTextBlock
---@field FPSTextBlock URichTextBlock
---@field Object UServerListObject
local UServerListRowWidget = {}



---@class UServerListWidget : UUserWidget
---@field ServerSearchTextBox UEditableTextBox
---@field DedicatedServerCheckBox UCheckBoxWidget
---@field PasswordCheckBox UCheckBoxWidget
---@field VersionCheckBox UCheckBoxWidget
---@field PlayersSortButton UMTButtonWidget
---@field PingSortButton UMTButtonWidget
---@field FPSSortButton UMTButtonWidget
---@field ServerNameSortButton UMTButtonWidget
---@field ServerListView UMTListView
---@field HostListJson UJsonFieldData
---@field ServerListObjects TArray<UServerListObject>
local UServerListWidget = {}

function UServerListWidget:RefreshServerList() end
---@param bSuccess boolean
---@param Json UJsonFieldData
---@param status EJSONResult
function UServerListWidget:OnHostListGetResult(bSuccess, Json, status) end
---@param Text FText
function UServerListWidget:HandleSearchTextChanged(Text) end


---@class USettingWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field SpinBoxString USpinBoxString
local USettingWidget = {}

---@param Name FText
function USettingWidget:SetSettingName(Name) end


---@class UShifterGearWidget : UUserWidget
local UShifterGearWidget = {}

---@param bLow boolean
function UShifterGearWidget:ReceiveSplitterSelected(bLow) end
---@param bSelected boolean
function UShifterGearWidget:ReceiveSelectedChanged(bSelected) end
---@param bLow boolean
function UShifterGearWidget:ReceiveRangeSelected(bLow) end


---@class UShifterWidget : UUserWidget
---@field Gear1 UShifterGearWidget
---@field Gear2 UShifterGearWidget
---@field Gear3 UShifterGearWidget
---@field Gear4 UShifterGearWidget
---@field Gear5 UShifterGearWidget
---@field Gear6 UShifterGearWidget
---@field Gears TArray<UShifterGearWidget>
local UShifterWidget = {}



---@class USleepWidget : UUserWidget
---@field TimeTextBlock UTextBlock
---@field WakeUpButton UMTButtonWidget
---@field AllPlayersMustSleepTextBlock UTextBlock
local USleepWidget = {}



---@class USoundSettingsWidget : UUserWidget
---@field SettingsVerticalBox UVerticalBox
---@field ResetToDefaultButton UMTButtonWidget
local USoundSettingsWidget = {}



---@class USpeedLimitSignWidget : UUserWidget
---@field SpeedLimitTextBlock UTextBlock
---@field SpeedLimitChanged UWidgetAnimation
local USpeedLimitSignWidget = {}



---@class USpeedometerWidget : UUserWidget
---@field Vehicle AMTVehicle
local USpeedometerWidget = {}

---@param InVehicle AMTVehicle
function USpeedometerWidget:SetVehicle(InVehicle) end


---@class USpinBoxDialogPopupWidget : UUserWidget
---@field MessageTextBlock URichTextBlock
---@field SpinBoxString USpinBoxString
---@field OkButton UMTButtonWidget
---@field CancelButton UMTButtonWidget
local USpinBoxDialogPopupWidget = {}

function USpinBoxDialogPopupWidget:HandleOK() end
function USpinBoxDialogPopupWidget:HandleCancel() end


---@class USpinBoxString : UUserWidget
---@field TextBorder UBorder
---@field TextBlock URichTextBlock
---@field DownButton UButton
---@field UpButton UButton
---@field Progress UProgressBar
---@field HelpText FText
local USpinBoxString = {}

function USpinBoxString:Up() end
---@param SpinBoxString USpinBoxString
function USpinBoxString:OnValueChangedEvent__DelegateSignature(SpinBoxString) end
function USpinBoxString:HandleUpReleased() end
function USpinBoxString:HandleUpPressed() end
function USpinBoxString:HandleDownReleased() end
function USpinBoxString:HandleDownPressed() end
function USpinBoxString:Down() end


---@class UStartDriveWidget : UUserWidget
---@field LevelsSpinBox USpinBoxString
---@field TimeOfDayStart USpinBoxString
---@field TimeOfDayMinutes USpinBoxString
---@field StartButtonWidget UMTButtonWidget
---@field AllowJoinSetting USettingWidget
---@field MaxPlayersSetting USettingWidget
---@field SessionNameSetting UTextSettingWidget
---@field SessionPasswordSetting UTextSettingWidget
---@field MultiplayerOptionsVerticalBox UVerticalBox
---@field OptionsVerticalBox UVerticalBox
local UStartDriveWidget = {}

function UStartDriveWidget:Start() end


---@class UStartOfflineTimeAttackWidget : UUserWidget
---@field LevelsSpinBox USpinBoxString
---@field VehiclesSpinBox USpinBoxString
---@field HostOptionWidget UHostOptionWidget
---@field SessionNameTextBox UEditableTextBox
local UStartOfflineTimeAttackWidget = {}

function UStartOfflineTimeAttackWidget:Start() end
---@param Text FText
function UStartOfflineTimeAttackWidget:HandleSessionNameTextBoxChanged(Text) end


---@class UStartRaceWidget : UUserWidget
---@field LevelsSpinBox USpinBoxString
---@field VehiclesSpinBox USpinBoxString
---@field LapsSpinBox USpinBoxString
---@field AIDriversSpinBox USpinBoxString
---@field AIVehicle0 USpinBoxString
---@field AIVehicle1 USpinBoxString
---@field HostOptionWidget UHostOptionWidget
---@field SessionNameTextBox UEditableTextBox
local UStartRaceWidget = {}

function UStartRaceWidget:Start() end
---@param Text FText
function UStartRaceWidget:HandleSessionNameTextBoxChanged(Text) end


---@class UStatWidget : UUserWidget
---@field NameTextBlock URichTextBlock
---@field StatTextBlock URichTextBlock
local UStatWidget = {}



---@class USteeringWheelSettingWidget : UDrivingControlSettingWidget
---@field FFBStrengthSpinBox USpinBoxString
---@field FFBMinStrengthSpinBox USpinBoxString
local USteeringWheelSettingWidget = {}

---@param SpinBoxString USpinBoxString
function USteeringWheelSettingWidget:HandleFFBSpinBoxChanged(SpinBoxString) end


---@class UStringSearchBoxWidget : UUserWidget
---@field SearchTextBox UEditableTextBox
local UStringSearchBoxWidget = {}

---@param Text FText
function UStringSearchBoxWidget:HandleTextChanged(Text) end
function UStringSearchBoxWidget:ClearSearchString() end


---@class USummonOwnVehicleEntryWidget : UMTListViewEntryWidget
---@field VehicleNameTextBlock UTextBlock
---@field VehicleData1TextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field SpwnerActor AActor
---@field SummonWidget UParkingSpaceSummonWidget
---@field DespawnVehicle AMTVehicle
---@field SpawnedVehicle AMTVehicle
local USummonOwnVehicleEntryWidget = {}



---@class UTabMenuTemplateWidget : UUserWidget
---@field TabSwitcher UWidgetSwitcher
---@field TabButton0 UMTButtonWidget
---@field TabButton1 UMTButtonWidget
---@field TabButton2 UMTButtonWidget
---@field TabButton3 UMTButtonWidget
---@field TabButton4 UMTButtonWidget
---@field TabButton5 UMTButtonWidget
---@field TabButton6 UMTButtonWidget
---@field TabSlot0 UNamedSlot
---@field TabSlot1 UNamedSlot
---@field TabSlot2 UNamedSlot
---@field TabSlot3 UNamedSlot
---@field TabSlot4 UNamedSlot
---@field TabSlot5 UNamedSlot
---@field TabSlot6 UNamedSlot
---@field ButtonNames TArray<FText>
---@field TabButtons TArray<UMTButtonWidget>
local UTabMenuTemplateWidget = {}

---@param TabIndex int32
function UTabMenuTemplateWidget:SetTabIndex(TabIndex) end


---@class UTagBoxString : UUserWidget
---@field bShowOpenEditorButton boolean
---@field bShowEditButtonInTagEditor boolean
---@field MaxSelectedTags int32
---@field TagTextBlock UTextBlock
---@field OpenTagEditorButton UMTButtonWidget
local UTagBoxString = {}



---@class UTagEditorEntryData : UObject
---@field TagEditorWidget UTagEditorWidget
local UTagEditorEntryData = {}



---@class UTagEditorEntryWidget : UMTListViewEntryWidget
---@field TagCheckBox UCheckBoxWidget
local UTagEditorEntryWidget = {}



---@class UTagEditorWidget : UUserWidget
---@field CountTextBox UTextBlock
---@field TagListView UMTListView
---@field AddOverlay UOverlay
---@field AddTextBox UEditableTextBox
---@field AddButton UMTButtonWidget
---@field ClearButton UMTButtonWidget
local UTagEditorWidget = {}

---@param Text FText
---@param CommitMethod ETextCommit::Type
function UTagEditorWidget:HandleAddTextCommitted(Text, CommitMethod) end
---@param Text FText
function UTagEditorWidget:HandleAddTextBoxChanged(Text) end


---@class UTankerFuelPumpWidget : UUserWidget
---@field InfoTextBlock URichTextBlock
---@field ProgressWidget UProgressWiget
---@field AccessRightSettingWidget UVehicleSettingItemWidget
---@field PriceSettingWidget UVehicleSettingItemWidget
---@field Vehicle AMTVehicle
local UTankerFuelPumpWidget = {}



---@class UTaxiControlPanelWidget : UUserWidget
---@field AcceptPassengerSetting UUserSettingItemWidget
---@field FindComfortPassenger UUserSettingItemWidget
---@field FindUrgentPassenger UUserSettingItemWidget
---@field AutoAcceptPassengerSetting UUserSettingItemWidget
---@field AutoAcceptPassengerOffroadSetting UUserSettingItemWidget
---@field DistanceToPassengerSortButton UMTButtonWidget
---@field MoneySortButton UMTButtonWidget
---@field PassengersListView UMTListView
---@field PassengersMapWidget UWorldMapWidget
---@field SelectedDetailTextBlock URichTextBlock
---@field ShowWhenEnterVehicleCheckBox UCheckBoxWidget
---@field CachedPassengers TArray<UMTPassengerComponent>
---@field SelectedPassengerObject UMTTaxiPassengerListObject
local UTaxiControlPanelWidget = {}



---@class UTaxiPassengerEntryWidget : UMTListViewEntryWidget
---@field ReservedFrame UWidget
---@field NameWidget UTextBlock
---@field DistanceToPassengerWidet UTextBlock
---@field DistanceWidet URichTextBlock
---@field DetailsWidet URichTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field AcceptButton UMTButtonWidget
---@field PickUpWidget UWidget
---@field DropOffWidget UWidget
local UTaxiPassengerEntryWidget = {}



---@class UTaxiPassengerInteractionWidget : UUserWidget
---@field MessageTextBlock URichTextBlock
---@field MapWidget UWorldMapWidget
---@field OkButton UMTButtonWidget
---@field Character AMTCharacter
local UTaxiPassengerInteractionWidget = {}



---@class UTextSettingWidget : UUserWidget
---@field NameTextBlock UTextBlock
---@field SettingTextBlock UEditableTextBox
local UTextSettingWidget = {}

---@param Name FText
function UTextSettingWidget:SetSettingName(Name) end
---@param Text FText
function UTextSettingWidget:HandleTextBoxChanged(Text) end


---@class UTimerWidget : UUserWidget
---@field TimeTextBlock UTextBlock
---@field PointTextBlock URichTextBlock
local UTimerWidget = {}



---@class UTireForceGraphWidget : UUserWidget
---@field WheelComponent UMHWheelComponent
---@field Plot UCartesianPlot
---@field PeakTextBlock UTextBlock
local UTireForceGraphWidget = {}

---@param InWheelComponent UMHWheelComponent
function UTireForceGraphWidget:SetWheelComponent(InWheelComponent) end
function UTireForceGraphWidget:ClearGraph() end


---@class UTowRequestControlPanelWidget : UUserWidget
---@field PaymentMoneyWidget UMTMoneyWidget
---@field DistanceTextBlock URichTextBlock
---@field AbandonButton UMTButtonWidget
---@field MapWidget UWorldMapWidget
---@field ShowWhenEnterVehicleCheckBox UCheckBoxWidget
---@field Vehicle AMTVehicle
local UTowRequestControlPanelWidget = {}



---@class UTowingVehicleListEntryWidget : UMTListViewEntryWidget
---@field VehicleNameTextBlock URichTextBlock
---@field DistanceTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field DamageTextBlock UTextBlock
local UTowingVehicleListEntryWidget = {}



---@class UTowingVehicleListObject : UObject
---@field Vehicle AMTVehicle
---@field TowComponent UMTTowRequestComponent
local UTowingVehicleListObject = {}



---@class UTowingVehicleListWidget : UUserWidget
---@field TowingListView UMTListView
---@field Vehicle AMTVehicle
local UTowingVehicleListWidget = {}



---@class UTownStateEntryWidget : UMTListViewEntryWidget
---@field NameTextBlock URichTextBlock
---@field WorkRateTextBlock URichTextBlock
---@field PopulationBonusTextBlock URichTextBlock
local UTownStateEntryWidget = {}



---@class UTownStateWidget : UUserWidget
---@field TownStateListView UMTListView
---@field TownStateTextBlock URichTextBlock
---@field ZoneStateListView UMTListView
---@field WebBrowser UWebBrowser
local UTownStateWidget = {}

function UTownStateWidget:ReloadWebpage() end
---@param URL FText
function UTownStateWidget:HandleWebUrlChanged(URL) end
---@param URL FString
---@param Frame FString
function UTownStateWidget:HandleWebBeforePopup(URL, Frame) end


---@class UTripMeterWidget : UUserWidget
---@field DecimalTextBlock UTextBlock
---@field FractionFrameWidget UWidget
---@field FractionSpinnerWidget UWidget
---@field FractionTextBlock UTextBlock
---@field FractionPrevTextBlock UTextBlock
---@field FractionNextTextBlock UTextBlock
local UTripMeterWidget = {}

---@param Distance float
function UTripMeterWidget:SetDistanceKm(Distance) end


---@class UUserSettingItemWidget : USettingWidget
local UUserSettingItemWidget = {}

---@param SpinBox USpinBoxString
function UUserSettingItemWidget:HandleValueChanged(SpinBox) end


---@class UVehicleControlPanelWidget : UUserWidget
---@field ButtonClass TSubclassOf<UMTButtonWidget>
---@field VehicleSelection USettingWidget
---@field ListWrapBox UWrapBox
---@field CloseButton UMTButtonWidget
---@field buttons TArray<UMTButtonWidget>
---@field DiffLockButton UMTButtonWidget
---@field Vehicle AMTVehicle
---@field Vehicles TArray<AMTVehicle>
---@field ActiveVehicle AMTVehicle
local UVehicleControlPanelWidget = {}



---@class UVehicleDetailInfoWidget : UUserWidget
---@field VehicleInfoWidget UVehicleInfoWidget
---@field NotForSaleTextBlock URichTextBlock
---@field SaleLocationVerticalBox UVerticalBox
---@field MapWidget UWorldMapWidget
---@field VehicleSpawnPointDatas TArray<FMTDealerVehicleSpawnPointData>
local UVehicleDetailInfoWidget = {}



---@class UVehicleEncyclopediaEntryObject : UObject
---@field VehicleRow FVehicleRow
local UVehicleEncyclopediaEntryObject = {}



---@class UVehicleEncyclopediaEntryWidget : UMTListViewEntryWidget
---@field VehicleImage UImage
---@field NameTextBlock URichTextBlock
---@field DetailTextBlock URichTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field ActorPreview AMTActorPreview
local UVehicleEncyclopediaEntryWidget = {}



---@class UVehicleEncyclopediaWidget : UUserWidget
---@field VehicleTypeFilterSpinBox USpinBoxString
---@field TruckClassFilterSpinBox USpinBoxString
---@field StringSearchBox UStringSearchBoxWidget
---@field NotOwnedOnlyCheckBox UCheckBoxWidget
---@field SortButton_Vehicle UMTButtonWidget
---@field SortButton_RequiredLevel UMTButtonWidget
---@field SortButton_Cost UMTButtonWidget
---@field VehiclesListView UMTListView
---@field VehicleDetailInfoWidget UVehicleDetailInfoWidget
local UVehicleEncyclopediaWidget = {}

function UVehicleEncyclopediaWidget:UpdateVehicleList() end


---@class UVehicleInfoWidget : UUserWidget
---@field VehicleNameTextBlock UTextBlock
---@field EngineTextBlock UTextBlock
---@field TransmissionTextBlock UTextBlock
---@field OwnerProfitShareWidget UWidget
---@field OwnerProfitShareTextBlock UTextBlock
---@field PowertrainWidget UVehiclePowertrainWidget
---@field ComfortWidget UWidget
---@field ComfortTextBlock UTextBlock
---@field CargoSpaceWidget UWidget
---@field CargoSpaceTextBlock UTextBlock
---@field CloseButton UMTButtonWidget
---@field StatWidgetClass TSubclassOf<UStatWidget>
---@field StatVerticalBox UVerticalBox
---@field PreviewImageWidget UImage
---@field TagsWidget UWidget
---@field TagsTextBlock UTextBlock
---@field EditTagsButton UMTButtonWidget
---@field DetailTextBlock URichTextBlock
---@field InventoryWidgetBox UHorizontalBox
---@field InventoryWidget UMiniInventoryWidget
---@field SpawnedVehicle AMTVehicle
---@field ActorPreview AMTActorPreview
local UVehicleInfoWidget = {}



---@class UVehicleLockWidget : UUserWidget
---@field LockedImage UImage
---@field UnlockedImage UImage
---@field LockButton UMTButtonWidget
---@field UnlockButton UMTButtonWidget
---@field Vehicle AMTVehicle
local UVehicleLockWidget = {}



---@class UVehiclePartInvenotryInteractionWidget : UUserWidget
---@field CharacterInventory UInventoryWidget
---@field VehiclePartInventory UInventoryWidget
local UVehiclePartInvenotryInteractionWidget = {}



---@class UVehiclePowertrainWidget : UUserWidget
---@field ScaleBox UScaleBox
---@field Canvas UCanvasPanel
---@field EngineWidgetClass TSubclassOf<UUserWidget>
---@field WheelWidgetClass TSubclassOf<UUserWidget>
---@field DriveWheelWidgetClass TSubclassOf<UUserWidget>
---@field Vehicle AMTVehicle
---@field EngineWidget UUserWidget
---@field WheelWidgets TArray<UUserWidget>
---@field CanvasSize FVector2D
local UVehiclePowertrainWidget = {}



---@class UVehicleSellerWidget : UUserWidget
---@field VehicleNameTextBlock UTextBlock
---@field PriceTextBlock UMTMoneyWidget
---@field RentPriceTextBlock UMTMoneyWidget
---@field RentPeriodTextBlock UTextBlock
---@field LoanAdWidget ULoanAdWidget
---@field InfoButton UMTButtonWidget
---@field Vehicle AMTVehicle
local UVehicleSellerWidget = {}

function UVehicleSellerWidget:Rent() end
function UVehicleSellerWidget:Info() end
function UVehicleSellerWidget:Accept() end


---@class UVehicleSettingItemWidget : USettingWidget
---@field Vehicle AMTVehicle
local UVehicleSettingItemWidget = {}



---@class UVendorSellItemEntryWidget : UMTListViewEntryWidget
---@field ItemIconImage UImage
---@field ItemNameTextBlock UTextBlock
---@field MoneyWidget UMTMoneyWidget
---@field BuyButton UMTButtonWidget
local UVendorSellItemEntryWidget = {}



---@class UVendorWidget : UUserWidget
---@field ItemsListView UMTListView
---@field PreviewImageOverlay UWidget
---@field InfoTextOverlay UWidget
---@field PreviewImageWidget UImage
---@field InfoRichTextBlock URichTextBlock
---@field ActorPreview AMTActorPreview
local UVendorWidget = {}



---@class UWheelStatusWidget : UUserWidget
---@field WheelComponent UMHWheelComponent
---@field WheelStatusText UTextBlock
local UWheelStatusWidget = {}

---@param InWheelComponent UMHWheelComponent
function UWheelStatusWidget:SetWheelComponent(InWheelComponent) end


---@class UWhisperTargetEntry : UObject
---@field Value FString
---@field PartialPlayerName FString
---@field PlayerState AMotorTownPlayerState
local UWhisperTargetEntry = {}



---@class UWhisperTargetEntryWidget : UUserWidget
---@field Entry UWhisperTargetEntry
local UWhisperTargetEntryWidget = {}



---@class UWorldMapWidget : UMapBaseWidget
---@field SceneCaptureActorClass TSubclassOf<AActor>
---@field FilterWidgetClass TSubclassOf<UMapFilterWidget>
---@field AreaNameWidgetClass TSubclassOf<UMapAreaNameWidget>
---@field MapMaterial UMaterialInterface
---@field AreaNameZOrder int32
---@field AreaNameSize float
---@field bUseSharedCenterAndZoom boolean
---@field RightSidePanel UVerticalBox
---@field CrosshairImage UImage
---@field CenterToPlayerButton UMTButtonWidget
---@field ClearWayPointsButton UMTButtonWidget
---@field GamepadControlOverlay UWidget
---@field Gamepad_LeftClick UControlWidget
---@field Gamepad_RightClick UControlWidget
---@field FocusOnPlayerKeyWidget UControlWidget
---@field ControlKeyBox UHorizontalBox
---@field ClearWaypointsKeyWidget UControlWidget
---@field SceneCaptureComponent USceneCaptureComponent2D
---@field SceneCaptureActor AActor
---@field AreaNameWidgets TArray<FMTWorldMapArea>
---@field WorldMapData FMTWorldMap
---@field MapDynamicMaterial UMaterialInstanceDynamic
local UWorldMapWidget = {}



---@class UZoneStateEntryWidget : UMTListViewEntryWidget
---@field ZoneNameTextBlock URichTextBlock
---@field PopulationTextBlock URichTextBlock
---@field PaymentBonusTextBlock URichTextBlock
---@field FoodTextBlock URichTextBlock
---@field BusTextBlock URichTextBlock
---@field TaxiTextBlock URichTextBlock
---@field PolicePatrolTextBlock URichTextBlock
---@field GarbageCollectTextBlock URichTextBlock
local UZoneStateEntryWidget = {}



