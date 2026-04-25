---@enum EAddCargoResult
local EAddCargoResult = {
    Success = 0,
    Failed = 1,
    NoCargo = 2,
    CharacterIsAlreadyHoldingCargo = 3,
    CharacterCanOnlyHoldOneCargo = 4,
    NotPickupable = 5,
    NotEnoughCargoSpace = 6,
    WrongCargoSpaceType = 7,
    EAddCargoResult_MAX = 8,
}

---@enum EDeliverMissionAcceptResponseCode
local EDeliverMissionAcceptResponseCode = {
    Success = 0,
    ServerError = 1,
    NotExists = 2,
    LoadingFailed = 3,
    NotEnoughSpace = 4,
    NotEnoughSpaceSpawnAtPoint = 5,
    EDeliverMissionAcceptResponseCode_MAX = 6,
}

---@enum EDeliveryCargoType
local EDeliveryCargoType = {
    None = 0,
    CourierPackage = 1,
    SmallPackage = 2,
    LargePackage = 3,
    FinalProduct = 4,
    Sand = 5,
    Stone = 6,
    Coal = 7,
    Concrete = 8,
    Container = 9,
    Log = 10,
    Wood = 11,
    Garbage = 12,
    Furniture = 13,
    Food = 14,
    MilitarySupply = 15,
    Max = 16,
}

---@enum EDeliveryMissionPointType
local EDeliveryMissionPointType = {
    None = 0,
    Errand = 1,
    Warehouse = 2,
    Courier = 3,
    Store = 4,
    Supermarket = 5,
    Factory = 6,
    Farm = 7,
    Logging = 8,
    Container = 9,
    Construction = 10,
    Mine = 11,
    OilPump = 12,
    GasStation = 13,
    DropOff = 14,
    EDeliveryMissionPointType_MAX = 15,
}

---@enum EGhostCarVisibility
local EGhostCarVisibility = {
    Hidden = 0,
    CurrentSession = 1,
    AllTime = 2,
    EGhostCarVisibility_MAX = 3,
}

---@enum EMTAICharacterSpawnLocation
local EMTAICharacterSpawnLocation = {
    Road = 0,
    EMTAICharacterSpawnLocation_MAX = 1,
}

---@enum EMTAIResidentFeature
local EMTAIResidentFeature = {
    Student = 0,
    Police = 1,
    Paramedic = 2,
    Gang = 3,
    VIPTaxiCustomer = 4,
    EMTAIResidentFeature_MAX = 5,
}

---@enum EMTAIVehicleSpawnType
local EMTAIVehicleSpawnType = {
    None = 0,
    TowRequest = 1,
    TowRequest_Rescue = 2,
    TowRequest_Delivery = 3,
    Getaway = 4,
    EMTAIVehicleSpawnType_MAX = 5,
}

---@enum EMTAccountStatType
local EMTAccountStatType = {
    NumOwnVehicles = 0,
    OdometerKm = 1,
    Towing = 2,
    Rescue = 3,
    VehicleDelivery = 4,
    CargoDelivered = 5,
    GarbageDelivered = 6,
    GhostHunt = 7,
    LapAnsanWithFormulaSCM = 8,
    AmbulancePassengerDelivered = 9,
    SearchAndRescueAmbulancePassengerDelivered = 10,
    ReactionTime0 = 11,
    DragstripRuns = 12,
    FireExtinguished = 13,
    FoundHiddenCostume = 14,
    FoundHiddenVehicle = 15,
    FoundStrangeThing = 16,
    EMTAccountStatType_MAX = 17,
}

---@enum EMTAllowJoinType
local EMTAllowJoinType = {
    DenyAll = 0,
    AllowAll = 1,
    AllowFriendOnly = 2,
    EMTAllowJoinType_MAX = 3,
}

---@enum EMTAreaVolumeFlags
local EMTAreaVolumeFlags = {
    RaceTrack = 0,
    SmallArea = 1,
    LargeArea = 2,
    Zone = 3,
    EMTAreaVolumeFlags_MAX = 4,
}

---@enum EMTAttachmentEditMode
local EMTAttachmentEditMode = {
    Placement = 0,
    ChangeColor = 1,
    EMTAttachmentEditMode_MAX = 2,
}

---@enum EMTAutoReverseType
local EMTAutoReverseType = {
    Disabled = 0,
    AutoReverseMode1 = 1,
    AutoReverseMode2 = 2,
    EMTAutoReverseType_MAX = 3,
}

---@enum EMTBlinkerLightType
local EMTBlinkerLightType = {
    LeftBlinker = 0,
    RightBlinker = 1,
    EMTBlinkerLightType_MAX = 2,
}

---@enum EMTBoolFilter
local EMTBoolFilter = {
    Any = 0,
    MustTrue = 1,
    MustFalse = 2,
    EMTBoolFilter_MAX = 3,
}

---@enum EMTBreakableRuntimeFlags
local EMTBreakableRuntimeFlags = {
    DisableBreakable = 1,
    EMTBreakableRuntimeFlags_MAX = 2,
}

---@enum EMTBudgetType
local EMTBudgetType = {
    None = 0,
    MirrorRenderPerFrame = 1,
    ActiveBreakable = 2,
    BrokenBreakable = 3,
    MarkerWidgetRedraw = 4,
    UpdateMarker = 5,
    ActorTickRate = 6,
    MirrorRenderTarget = 7,
    CargoOverlap = 8,
    RollingTick = 9,
    OverlapComponent = 10,
    ActiveLight = 11,
    VehicleDecal = 12,
    Count = 13,
    EMTBudgetType_MAX = 14,
}

---@enum EMTBuffEffectType
local EMTBuffEffectType = {
    None = 0,
    Sleeping = 1,
    ImmuneToBeSuspect = 2,
    ImmuneToBeCaught = 3,
    NoPaymentToPlayerPolice = 4,
    KnockDown = 5,
    EMTBuffEffectType_MAX = 6,
}

---@enum EMTBuildingAccess
local EMTBuildingAccess = {
    OwnerOnly = 0,
    PartyOnly = 1,
    CompanyOnly = 2,
    Everyone = 3,
    EMTBuildingAccess_MAX = 4,
}

---@enum EMTBuildingRowType
local EMTBuildingRowType = {
    House = 0,
    Furniture = 1,
    EMTBuildingRowType_MAX = 2,
}

---@enum EMTBuildingType
local EMTBuildingType = {
    None = 0,
    Building = 1,
    ParkingSpace = 2,
    Furniture = 3,
    EMTBuildingType_MAX = 4,
}

---@enum EMTBusPassengerType
local EMTBusPassengerType = {
    None = 0,
    Student_GoingSchool = 1,
    Student_GoingHome = 2,
    EMTBusPassengerType_MAX = 3,
}

---@enum EMTBusRouteFlags
local EMTBusRouteFlags = {
    SchoolBus = 0,
    EMTBusRouteFlags_MAX = 1,
}

---@enum EMTBusStopFlags
local EMTBusStopFlags = {
    School = 0,
    SchoolBusStop = 1,
    Terminal = 2,
    EMTBusStopFlags_MAX = 3,
}

---@enum EMTCargoActorFlags
local EMTCargoActorFlags = {
    ShowGarbageMarker = 1,
    CompressedGarbage = 2,
    CompanyAILoaded = 4,
    HasMovementOwnerPC = 8,
    IsImported = 16,
    Offroad = 32,
    EMTCargoActorFlags_MAX = 33,
}

---@enum EMTCargoFlags
local EMTCargoFlags = {
    None = 0,
    CustomSupply = 1,
    SharedByMultipleDelivery = 2,
    PartyProfitShare = 4,
    PaymentChangeByDemand = 8,
    IgnoreMaxDelivery = 16,
    IgnoreMaxDeliveryReceiveDistance = 32,
    Oversize = 64,
    EMTCargoFlags_MAX = 65,
}

---@enum EMTCargoSize
local EMTCargoSize = {
    Small = 0,
    Medium = 1,
    Large = 2,
    EMTCargoSize_MAX = 3,
}

---@enum EMTCargoSpaceLoadedItemType
local EMTCargoSpaceLoadedItemType = {
    None = 0,
    Gasoline = 1,
    Diesel = 2,
    Water = 3,
    EMTCargoSpaceLoadedItemType_MAX = 4,
}

---@enum EMTCargoSpaceRuntimeFlags
local EMTCargoSpaceRuntimeFlags = {
    Refueling = 1,
    NotFit = 2,
    EMTCargoSpaceRuntimeFlags_MAX = 3,
}

---@enum EMTCargoSpaceType
local EMTCargoSpaceType = {
    Invalid = 0,
    Flatbed = 1,
    Box = 2,
    Dump = 3,
    ConcreteMixer = 4,
    Container = 5,
    Tanker = 6,
    DryBulk = 7,
    LiveFishTanker = 8,
    Log = 9,
    Garbage = 10,
    CarCarrier = 11,
    Grain = 12,
    Max = 13,
}

---@enum EMTCharacterCustomizationSlot
local EMTCharacterCustomizationSlot = {
    None = 0,
    Hair = 1,
    Body = 2,
    MAX = 3,
}

---@enum EMTCharacterEventType
local EMTCharacterEventType = {
    GhostHunted = 0,
    EMTCharacterEventType_MAX = 1,
}

---@enum EMTCharacterFlags
local EMTCharacterFlags = {
    None = 0,
    NeedCapsuleOverlapEvent = 1,
    NoMovementController = 2,
    Ghost = 4,
    MeshPicking = 8,
    HideCostume = 16,
    NoBlockVehicle = 32,
    EMTCharacterFlags_MAX = 33,
}

---@enum EMTCharacterJob
local EMTCharacterJob = {
    None = 0,
    Paramedic = 1,
    Police = 2,
    Garbage = 3,
    FireFighter = 4,
    EMTCharacterJob_MAX = 5,
}

---@enum EMTCharacterLOD
local EMTCharacterLOD = {
    LOD0 = 0,
    LOD1 = 1,
    EMTCharacterLOD_MAX = 2,
}

---@enum EMTCharacterLevelType
local EMTCharacterLevelType = {
    CL_Driver = 0,
    CL_Taxi = 1,
    CL_Bus = 2,
    CL_Truck = 3,
    CL_Racer = 4,
    CL_Wrecker = 5,
    CL_Police = 6,
    CL_Count = 7,
    CL_MAX = 8,
}

---@enum EMTCharacterLocalFlags
local EMTCharacterLocalFlags = {
    None = 0,
    NoBlockVehicle = 1,
    NoBlockCargo = 2,
    EMTCharacterLocalFlags_MAX = 3,
}

---@enum EMTCharacterPartSlot
local EMTCharacterPartSlot = {
    None = 0,
    Body = 1,
    Hair = 2,
    Beard = 3,
    Hat = 4,
    Glasses = 5,
    Costume = 6,
    EMTCharacterPartSlot_MAX = 7,
}

---@enum EMTCharacterPartVisibilityInVehiclePolicy
local EMTCharacterPartVisibilityInVehiclePolicy = {
    Show = 0,
    Hide = 1,
    Auto = 2,
    EMTCharacterPartVisibilityInVehiclePolicy_MAX = 3,
}

---@enum EMTCharacterPose
local EMTCharacterPose = {
    None = 0,
    Talking = 1,
    EMTCharacterPose_MAX = 2,
}

---@enum EMTCharacterPoseFlags
local EMTCharacterPoseFlags = {
    None = 0,
    Talking = 1,
    Pushing = 2,
    LieDown = 4,
    Downed = 8,
    EMTCharacterPoseFlags_MAX = 9,
}

---@enum EMTChaseCameraVerticalMode
local EMTChaseCameraVerticalMode = {
    Fixed = 0,
    Follow = 1,
    EMTChaseCameraVerticalMode_MAX = 2,
}

---@enum EMTChatCategory
local EMTChatCategory = {
    Normal = 0,
    Announce = 1,
    Company = 2,
    Party = 3,
    Event = 4,
    WhisperIn = 5,
    WhisperOut = 6,
    SmallArea = 7,
    EMTChatCategory_MAX = 8,
}

---@enum EMTColorPickerChannels
local EMTColorPickerChannels = {
    Hue = 0,
    Saturation = 1,
    Value = 2,
    Alpha = 3,
    EMTColorPickerChannels_MAX = 4,
}

---@enum EMTCompanyVehicleFlags
local EMTCompanyVehicleFlags = {
    AssignedBusRoute = 1,
    AssignedTruckRoute = 2,
    AssignedTaxiDepot = 4,
    NotifyTransportations = 8,
    EMTCompanyVehicleFlags_MAX = 9,
}

---@enum EMTCompanyVehicleState
local EMTCompanyVehicleState = {
    Spawnable = 0,
    Idle = 1,
    OnRoute = 2,
    Stuck = 3,
    Problem = 4,
    InUse = 5,
    EMTCompanyVehicleState_MAX = 6,
}

---@enum EMTContractType
local EMTContractType = {
    None = 0,
    DeliveryPointOnlineInfo = 1,
    DeliveryPointSupplyCargo = 2,
    DeliveryPointFastTravel = 3,
    EMTContractType_MAX = 4,
}

---@enum EMTControlPanelControlType
local EMTControlPanelControlType = {
    Interaction = 0,
    InteractionByActor = 1,
    Constraint = 2,
    Door = 3,
    WaterSpray = 4,
    EMTControlPanelControlType_MAX = 5,
}

---@enum EMTCouponType
local EMTCouponType = {
    None = 0,
    Discount_RoadSideTowToRoad = 1,
    EMTCouponType_MAX = 2,
}

---@enum EMTDashboardGaugeType
local EMTDashboardGaugeType = {
    None = 0,
    RPM = 1,
    Speed = 2,
    Fuel = 3,
    Temp = 4,
    EMTDashboardGaugeType_MAX = 5,
}

---@enum EMTDashboardMFDType
local EMTDashboardMFDType = {
    None = 0,
    Upper = 1,
    MDF_01 = 2,
    EMTDashboardMFDType_MAX = 3,
}

---@enum EMTDataSyncOp
local EMTDataSyncOp = {
    Upsert = 0,
    Remove = 1,
    EMTDataSyncOp_MAX = 2,
}

---@enum EMTDecalLayerFlags
local EMTDecalLayerFlags = {
    None = 0,
    Flip = 1,
    Mirror = 2,
    OppositeCull = 4,
    BackFaceCull = 8,
    Highlighted = 128,
    DrawOnWheel = 256,
    EMTDecalLayerFlags_MAX = 257,
}

---@enum EMTDecalRowFlags
local EMTDecalRowFlags = {
    None = 0,
    AlphaOnlyTexture = 1,
    Hidden = 2,
    EMTDecalRowFlags_MAX = 3,
}

---@enum EMTDeliveryCargoSpawnFlags
local EMTDeliveryCargoSpawnFlags = {
    Garbage = 1,
    EMTDeliveryCargoSpawnFlags_MAX = 2,
}

---@enum EMTDeliveryPointFlag
local EMTDeliveryPointFlag = {
    None = 0,
    IsExport = 1,
    IsImport = 2,
    IgnoreMinDistance = 4,
    EMTDeliveryPointFlag_MAX = 5,
}

---@enum EMTDialogActionType
local EMTDialogActionType = {
    None = 0,
    WaypointToNearestDriveableVehicle = 1,
    WaypointToActor = 2,
    UseActor = 3,
    Interact = 4,
    OpenUI_CompanyList = 5,
    EMTDialogActionType_MAX = 6,
}

---@enum EMTDialogResult
local EMTDialogResult = {
    OK = 0,
    Cancel = 1,
    EMTDialogResult_MAX = 2,
}

---@enum EMTDialogueMessageArgumentType
local EMTDialogueMessageArgumentType = {
    Destination = 0,
    EMTDialogueMessageArgumentType_MAX = 1,
}

---@enum EMTDiffLockStateType
local EMTDiffLockStateType = {
    Disconnect = 0,
    Open = 1,
    Locked = 2,
    EMTDiffLockStateType_MAX = 3,
}

---@enum EMTDoorMoveType
local EMTDoorMoveType = {
    None = 0,
    Slide = 1,
    Rotate = 2,
    EMTDoorMoveType_MAX = 3,
}

---@enum EMTDragRaceSensorState
local EMTDragRaceSensorState = {
    Idle = 0,
    Prestage = 1,
    Stage = 2,
    CountdownAmber1 = 3,
    CountdownAmber2 = 4,
    CountdownAmber3 = 5,
    Green = 6,
    FalseStart = 7,
    Finished = 8,
    EMTDragRaceSensorState_MAX = 9,
}

---@enum EMTDriftModeChaseCameraMode
local EMTDriftModeChaseCameraMode = {
    VehicleDirection = 0,
    VelocityDirection = 1,
    EMTDriftModeChaseCameraMode_MAX = 2,
}

---@enum EMTDriveMode
local EMTDriveMode = {
    Comfort = 0,
    Sport = 1,
    Drift = 2,
    Max = 3,
}

---@enum EMTDrivingController
local EMTDrivingController = {
    Keyboard = 0,
    KeyboardAndMouse = 1,
    Gamepad = 2,
    SteeringWheel = 3,
    EMTDrivingController_MAX = 4,
}

---@enum EMTDroneCameraMode
local EMTDroneCameraMode = {
    FPV = 0,
    VisualFlight = 1,
    EMTDroneCameraMode_MAX = 2,
}

---@enum EMTDroneControlMode
local EMTDroneControlMode = {
    CursorMode = 0,
    EMTDroneControlMode_MAX = 1,
}

---@enum EMTDroneFlightMode
local EMTDroneFlightMode = {
    Normal = 0,
    Sport = 1,
    EMTDroneFlightMode_MAX = 2,
}

---@enum EMTDroneType
local EMTDroneType = {
    MultiRotor = 0,
    EMTDroneType_MAX = 1,
}

---@enum EMTEngineType
local EMTEngineType = {
    Small = 0,
    Medium = 1,
    Large = 2,
    EMTEngineType_MAX = 3,
}

---@enum EMTEquipmentSlot
local EMTEquipmentSlot = {
    None = 0,
    Hat = 1,
    Glasses = 2,
    Beard = 3,
    Costume = 4,
    MAX = 5,
}

---@enum EMTEscortInvalidReason
local EMTEscortInvalidReason = {
    None = 0,
    NoSeatedVehicle = 1,
    EscortLicenseRequired = 2,
    SameEscortTractor = 3,
    EMTEscortInvalidReason_MAX = 4,
}

---@enum EMTEscortType
local EMTEscortType = {
    Heavy = 0,
    Oversize = 1,
    Offroad = 2,
    EMTEscortType_MAX = 3,
}

---@enum EMTEventChangedType
local EMTEventChangedType = {
    None = 0,
    CountdownFinished = 1,
    EMTEventChangedType_MAX = 2,
}

---@enum EMTEventState
local EMTEventState = {
    None = 0,
    Ready = 1,
    InProgress = 2,
    Finished = 3,
    EMTEventState_MAX = 4,
}

---@enum EMTEventType
local EMTEventType = {
    None = 0,
    Race = 1,
    CaptureTheFlag = 2,
    EMTEventType_MAX = 3,
}

---@enum EMTFindPathSource
local EMTFindPathSource = {
    MTGraphOnly = 0,
    MTGraphAndMesh = 1,
    MeshOnly = 2,
    EMTFindPathSource_MAX = 3,
}

---@enum EMTFireFlags
local EMTFireFlags = {
    Spotted = 1,
    ExtinguishStarted = 2,
    FirstArrivedRewarded = 4,
    EMTFireFlags_MAX = 5,
}

---@enum EMTFuelConsumptionDisplay
local EMTFuelConsumptionDisplay = {
    DistanceFirstFormat = 0,
    ConsumptionFirstFormat = 1,
    EMTFuelConsumptionDisplay_MAX = 2,
}

---@enum EMTFuelType
local EMTFuelType = {
    Invalid = 0,
    Gasoline = 1,
    Diesel = 2,
    Electric = 3,
    Water = 4,
    EMTFuelType_MAX = 5,
}

---@enum EMTGameSettingFire
local EMTGameSettingFire = {
    Off = 0,
    Low = 1,
    Normal = 2,
    High = 3,
    VeryHigh = 4,
    EMTGameSettingFire_MAX = 5,
}

---@enum EMTGameSettingWeather
local EMTGameSettingWeather = {
    Off = 0,
    Low = 1,
    Normal = 2,
    High = 3,
    Always = 4,
    EMTGameSettingWeather_MAX = 5,
}

---@enum EMTGarageFlags
local EMTGarageFlags = {
    LargeVehicleGarage = 1,
    EMTGarageFlags_MAX = 2,
}

---@enum EMTGraphNodeEdgeFlags
local EMTGraphNodeEdgeFlags = {
    None = 0,
    EF_CrossRoad = 1,
    EF_CrossRoad_LowPriority = 2,
    EF_CrossRoad_Turn = 4,
    EF_CrossRoad_Turn_Left = 8,
    EF_CrossRoad_Turn_Right = 16,
    EF_CrossRoad_Turn_Tight = 32,
    EF_UTurn = 64,
    EMTGraphNodeEdgeFlags_MAX = 65,
}

---@enum EMTGridType
local EMTGridType = {
    None = 0,
    Race = 1,
    TimeAttackJumpStart = 2,
    PitOutside = 3,
    PitInside = 4,
    EMTGridType_MAX = 5,
}

---@enum EMTHUDAspectRatio
local EMTHUDAspectRatio = {
    Full = 0,
    Fixed21x9 = 1,
    Fixed16x9 = 2,
    Fixed4x3 = 3,
    EMTHUDAspectRatio_MAX = 4,
}

---@enum EMTHeadLightMode
local EMTHeadLightMode = {
    Off = 0,
    Low = 1,
    High = 2,
    Count = 3,
    EMTHeadLightMode_MAX = 4,
}

---@enum EMTHelpMessageType
local EMTHelpMessageType = {
    None = 0,
    Teleport = 1,
    WorldVehicleProfitShare = 2,
    HeadLight = 3,
    Dump = 4,
    LandingGear = 5,
    OverHeat = 6,
    Repair = 7,
    OutOfBattery = 8,
    OutOfFuel = 9,
    RoadsideService = 10,
    CargoStrap = 11,
    OpenBusDoorAtBusStop = 12,
    OpenCompanyUI = 13,
    PoliceSuspect = 14,
    PutPatientIntoAmbulance = 15,
    InSearchAndRescueCircle = 16,
    EMTHelpMessageType_MAX = 17,
}

---@enum EMTIconType
local EMTIconType = {
    None = 0,
    Job = 1,
    Trade = 2,
    Delivery = 3,
    Warning = 4,
    TaxiPassenger = 5,
    AmbulancePassenger = 6,
    Hitchhiker = 7,
    OtherPlayer = 8,
    Company = 9,
    Police = 10,
    Wrecker = 11,
    Destination = 12,
    EMTIconType_MAX = 13,
}

---@enum EMTInventoryType
local EMTInventoryType = {
    Item = 0,
    Coupon = 1,
    Equipment = 2,
    VehiclePart = 3,
    Building = 4,
    EMTInventoryType_MAX = 5,
}

---@enum EMTItemFeature
local EMTItemFeature = {
    InfraredThermometer = 0,
    EMTItemFeature_MAX = 1,
}

---@enum EMTItemHandRIKType
local EMTItemHandRIKType = {
    Flash = 0,
    GunTool = 1,
    EMTItemHandRIKType_MAX = 2,
}

---@enum EMTItemType
local EMTItemType = {
    None = 0,
    BuildingBlueprint = 1,
    Furniture = 2,
    Costume = 3,
    VehicleAttachment = 4,
    Drone = 5,
    Coupon = 6,
    CharacterPart = 7,
    EMTItemType_MAX = 8,
}

---@enum EMTLSDType
local EMTLSDType = {
    Open = 0,
    Locked = 1,
    ClutchPackLSD = 2,
    Lockable = 3,
    EMTLSDType_MAX = 4,
}

---@enum EMTLengthUnit
local EMTLengthUnit = {
    Meter = 0,
    Miles = 1,
    EMTLengthUnit_MAX = 2,
}

---@enum EMTListViewHighlightType
local EMTListViewHighlightType = {
    ByFocus = 0,
    BySelection = 1,
    EMTListViewHighlightType_MAX = 2,
}

---@enum EMTMapFilterType
local EMTMapFilterType = {
    None = 0,
    First = 1,
    Hitchhiker = 1,
    TaxiJob = 2,
    BusJob = 3,
    TruckJob = 4,
    RaceTrack = 5,
    PoliceJob = 6,
    AmbulanceJob = 7,
    WreckerJob = 8,
    Garbage = 9,
    Delivery = 10,
    TaxiPassenger = 11,
    AmbulancePassenger = 12,
    Trailer = 13,
    GasStation = 14,
    Vendor = 15,
    TuningShop = 16,
    CarDealer = 17,
    HouseForSale = 18,
    MyVehicle = 19,
    Home = 20,
    Motorhome = 21,
    Construction = 22,
    Fire = 23,
    Destination = 24,
    Zone = 25,
    Max = 26,
}

---@enum EMTMapIconFlags
local EMTMapIconFlags = {
    ShowTaxiPassengerGroupCount = 1,
    SpikeBarrier = 2,
    UseTownCondition = 4,
    EMTMapIconFlags_MAX = 5,
}

---@enum EMTMapIconType
local EMTMapIconType = {
    None = 0,
    Delivery = 1,
    Hitchhiker = 2,
    CarSeller = 3,
    OtherPlayer = 4,
    Destination = 5,
    CustomIcon = 6,
    TowRequest = 7,
    TeleportPoint = 8,
    HouseForTeleport = 9,
    HouseForSale = 10,
    Count = 11,
    EMTMapIconType_MAX = 12,
}

---@enum EMTMinimapOrientation
local EMTMinimapOrientation = {
    HeadingUp = 0,
    NorthUp = 1,
    EMTMinimapOrientation_MAX = 2,
}

---@enum EMTMirroType
local EMTMirroType = {
    None = 0,
    SideLeft = 1,
    SideRight = 2,
    SideFrontRight = 3,
    SideLookDownRight = 4,
    Room = 5,
    RearViewCamera = 6,
    EMTMirroType_MAX = 7,
}

---@enum EMTNetGSVehicleFlags
local EMTNetGSVehicleFlags = {
    NVF_TowRequestArrived = 1,
    NVF_TowRequestHasDriver = 2,
    NVF_TowRequestRescue = 4,
    NVF_TowRequestDelivery = 8,
    NVF_HasWrecker = 16,
    NVF_OnFire = 32,
    NVF_MAX = 33,
}

---@enum EMTPOIFlags
local EMTPOIFlags = {
    None = 0,
    Offroad = 1,
    Uphill = 2,
    AmbulanceDropOff = 4,
    Residential = 8,
    Commercial = 16,
    Industrial = 32,
    Office = 64,
    Agriculture = 128,
    School = 256,
    PoliceStation = 512,
    FireStation = 1024,
    Discover = 2048,
    EMTPOIFlags_MAX = 2049,
}

---@enum EMTParkingSpaceType
local EMTParkingSpaceType = {
    None = 0,
    TowingDestination = 1,
    DeliveryDestination = 2,
    PoliceTowingDestination = 3,
    EMTParkingSpaceType_MAX = 4,
}

---@enum EMTPassengerType
local EMTPassengerType = {
    None = 0,
    Hitchhiker = 1,
    Taxi = 2,
    Ambulance = 3,
    Bus = 4,
    EMTPassengerType_MAX = 5,
}

---@enum EMTPlayerCounterType
local EMTPlayerCounterType = {
    None = 0,
    CalledTowService = 1,
    AmbulancePassengerDelivered = 2,
    SearchAndRescueAmbulancePassengerDelivered = 3,
    BusPassengerDelivered = 4,
    HitchhikerPassengerDelivered = 5,
    TaxiPassengerDelivered = 6,
    TowRequestDelivered = 7,
    RescueRequestDelivered = 8,
    VehicleDelivered = 9,
    CargoDelivered = 10,
    GarbageDelivered = 11,
    GhostHunted = 12,
    LapAnsanWithFormulaSCM = 13,
    ReactionTime0 = 14,
    DragstripRuns = 15,
    FireExtinguished = 16,
    FoundHiddenCostume = 17,
    FoundHiddenVehicle = 18,
    FoundStrangeThing = 19,
    Max = 20,
}

---@enum EMTPlayerDataWorldCharacterType
local EMTPlayerDataWorldCharacterType = {
    None = 0,
    Resident = 1,
    Hitchhiker = 2,
    TaxiPassenger = 3,
    BusPassenger = 4,
    SearchAndRescuePatient = 5,
    AmbulancePassenger = 6,
    EMTPlayerDataWorldCharacterType_MAX = 7,
}

---@enum EMTPlayerRole
local EMTPlayerRole = {
    None = 0,
    Police = 1,
    EMTPlayerRole_MAX = 2,
}

---@enum EMTPlayerStartType
local EMTPlayerStartType = {
    None = 0,
    TimeAttack_JumpStart = 1,
    EMTPlayerStartType_MAX = 2,
}

---@enum EMTQuestConditionType
local EMTQuestConditionType = {
    None = 0,
    Timer = 1,
    CharacterLevel = 2,
    PickupHitchhiker = 3,
    DeliverHitchhiker = 4,
    PickupTaxiPassenger = 5,
    DeliverTaxiPassenger = 6,
    PickupCargo = 7,
    DeliverCargo = 8,
    StrapCargo = 9,
    DriveVehicle = 10,
    FindVehicle = 11,
    FindParkingSpace = 12,
    FindPointOfInterest = 13,
    VehicleDriveMode = 14,
    PlayerCounterEqualOrMore = 15,
    NearActorClass = 16,
    NearActorAndComponentClass = 17,
    HookVehicle = 18,
    FinishTowRequest = 19,
    SummonVehicle = 20,
    BuyVehicle = 21,
    CreateCompany = 22,
    EMTQuestConditionType_MAX = 23,
}

---@enum EMTQuestInputEventType
local EMTQuestInputEventType = {
    None = 0,
    CharacterLevelChanged = 1,
    CharacterCargoChanged = 2,
    DrivingVehicleChanged = 3,
    VehicleSeatedCharacterChanged = 4,
    VehicleCargoChanged = 5,
    VehicleDriveModeChanged = 6,
    VehicleSummoned = 7,
    VehicleBought = 8,
    PassengerArrived = 9,
    CargoArrived = 10,
    CargoStrapped = 11,
    PlayerCounterChanged = 12,
    TowingHooked = 13,
    TowRequestArrived = 14,
    CompanyCreated = 15,
    EMTQuestInputEventType_MAX = 16,
}

---@enum EMTRaceStep
local EMTRaceStep = {
    None = 0,
    Countdown = 1,
    Race = 2,
    EMTRaceStep_MAX = 3,
}

---@enum EMTRoadFlags
local EMTRoadFlags = {
    None = 0,
    Offroad = 1,
    Dirt = 2,
    Gravel = 4,
    NoAI = 8,
    NoCompanyAI = 128,
    IgnoreWrongWay = 16,
    AllowPararellConnection = 32,
    DisallowLeftTurn = 64,
    Mud = 256,
    EMTRoadFlags_MAX = 257,
}

---@enum EMTRoadSignDirection
local EMTRoadSignDirection = {
    Forward = 0,
    Left = 1,
    Right = 2,
    EMTRoadSignDirection_MAX = 3,
}

---@enum EMTRoadSignType
local EMTRoadSignType = {
    None = 0,
    Stop = 1,
    RubberCone = 2,
    EMTRoadSignType_MAX = 3,
}

---@enum EMTRoadType
local EMTRoadType = {
    Road = 0,
    Track_RaceLine = 1,
    Track_Course = 2,
    EMTRoadType_MAX = 3,
}

---@enum EMTSeatExitType
local EMTSeatExitType = {
    OwnDoor = 0,
    NearestDoor = 1,
    PassengerDoor = 2,
    StandUp = 3,
    LastLocation = 4,
    EMTSeatExitType_MAX = 5,
}

---@enum EMTSeatPositionType
local EMTSeatPositionType = {
    None = 0,
    Sedan = 1,
    ScooterDriver = 2,
    ScooterPassenger = 3,
    BikeDriverUpright = 4,
    BikeDriverSport = 5,
    Bed = 6,
    Chair = 7,
    Standing_FrontGrip = 8,
    EMTSeatPositionType_MAX = 9,
}

---@enum EMTSeatType
local EMTSeatType = {
    None = 0,
    Driver = 1,
    Passenger = 2,
    Bed = 3,
    CraneOperator = 4,
    ControlPanel = 5,
    EMTSeatType_MAX = 6,
}

---@enum EMTSettingValueType
local EMTSettingValueType = {
    Float = 0,
    Int64 = 1,
    Bool = 2,
    String = 3,
    Enum = 4,
    EMTSettingValueType_MAX = 5,
}

---@enum EMTShowMirror
local EMTShowMirror = {
    Hide = 0,
    ShowMyCarOnly = 1,
    ShowAll = 2,
    EMTShowMirror_MAX = 3,
}

---@enum EMTSpinBoxStringValueType
local EMTSpinBoxStringValueType = {
    String = 0,
    Bool = 1,
    Float = 2,
    EMTSpinBoxStringValueType_MAX = 3,
}

---@enum EMTTailLightType
local EMTTailLightType = {
    None = 0,
    LeftBlinker = 1,
    RightBlinker = 2,
    EMTTailLightType_MAX = 3,
}

---@enum EMTTaxiType
local EMTTaxiType = {
    Normal = 0,
    Limo = 1,
    EMTTaxiType_MAX = 2,
}

---@enum EMTTimeOfDayScheduleType
local EMTTimeOfDayScheduleType = {
    None = 0,
    BusPassengerSpawnMultiplayer = 1,
    SchoolBusPassengerSpawnMultiplayer = 2,
    Count = 3,
    EMTTimeOfDayScheduleType_MAX = 4,
}

---@enum EMTTowRequestFlags
local EMTTowRequestFlags = {
    None = 0,
    Rescue = 1,
    Delivery = 2,
    PoliceTowing = 4,
    LoadedFromVehicle = 8,
    HasBeenTowed = 16,
    EMTTowRequestFlags_MAX = 17,
}

---@enum EMTTowingHookType
local EMTTowingHookType = {
    Sling = 0,
    Lift = 1,
    EMTTowingHookType_MAX = 2,
}

---@enum EMTTownPolicyEffectType
local EMTTownPolicyEffectType = {
    None = 0,
    FuelSubsidy = 1,
    MaxVehicleLengthAdd = 2,
    MaxCargoHeightAdd = 3,
    CompanyTruckProfitShareMultiplier = 4,
    CompanyBusProfitShareMultiplier = 5,
    CompanyTaxiProfitShareMultiplier = 6,
    CompanyTruckConditionDecreaseSpeedMultiplier = 7,
    CompanyBusConditionDecreaseSpeedMultiplier = 8,
    CompanyTaxiConditionDecreaseSpeedMultiplier = 9,
    MaxGVWKgAdd = 10,
    EMTTownPolicyEffectType_MAX = 11,
}

---@enum EMTTrafficLightState
local EMTTrafficLightState = {
    Green = 0,
    Red = 1,
    RedBlinking = 2,
    Yellow = 3,
    YellowBlinking = 4,
    EMTTrafficLightState_MAX = 5,
}

---@enum EMTTrailerConnectionType
local EMTTrailerConnectionType = {
    None = 0,
    FifthWheel = 1,
    Hitch = 2,
    Ring = 3,
    EMTTrailerConnectionType_MAX = 4,
}

---@enum EMTTransformStepMode
local EMTTransformStepMode = {
    Location = 0,
    Rotation = 1,
    EMTTransformStepMode_MAX = 2,
}

---@enum EMTTransmissionClutchType
local EMTTransmissionClutchType = {
    TorqueConvertor = 0,
    MultiPlateClutch = 1,
    TorqueConvertorV2 = 2,
    EMTTransmissionClutchType_MAX = 3,
}

---@enum EMTTransmissionType
local EMTTransmissionType = {
    Normal = 0,
    EatonFuller18 = 1,
    EatonFuller13 = 2,
    CVT = 3,
    EMTTransmissionType_MAX = 4,
}

---@enum EMTTruckClass
local EMTTruckClass = {
    None = 0,
    LightDuty = 1,
    MediumDuty = 2,
    HeavyDuty = 3,
    Max = 4,
}

---@enum EMTUserSettingType
local EMTUserSettingType = {
    None = 0,
    GameMode_DriveTimeOfDayMinutes = 1,
    GameMode_Rain = 2,
    GameMode_Fire = 3,
    GameMode_NPCVehicleDensity = 4,
    GameMode_NPCPoliceDensity = 5,
    ChaseViewDistance = 6,
    ChaseViewVerticalMode = 7,
    CockpitCameraShake = 8,
    AutoRecenterCockpitCameraAfterSeconds = 9,
    AutoRecenterChaseCameraAfterSeconds = 10,
    DisableAutoRencterCameraDuringReverse = 11,
    CameraLookLeftRightAngle = 12,
    CameraLookLeftRightByRate = 13,
    BikeCockpitCameraHorizontalLock = 14,
    ShowVirtualMirror = 15,
    RenderMirrorPerFrame = 16,
    RenderMirrorInChaseView = 17,
    RenderMirrorInCharacterMode = 18,
    Graphic_Brightness = 19,
    MoonLightBrigtness = 20,
    AntiAliasingMethod = 21,
    VehicleLODQualityLevel = 22,
    HideSteeringWheel = 23,
    Sound_MasterVolume = 24,
    Sound_BGMVolume = 25,
    Sound_EffectVolume = 26,
    Sound_EngineVolume = 27,
    Sound_TireVolume = 28,
    Sound_WindNoiseVolume = 29,
    Sound_RainVolume = 30,
    Sound_MuffleInCabin = 31,
    Net_UseUPNP = 32,
    Net_ReceiveBroadcastMessages = 33,
    Multiplayer_JoinVehicleId = 34,
    Multiplayer_MaxNumPlayers = 35,
    Multiplayer_Password = 36,
    Multiplayer_MaxVehiclePerPlayer = 37,
    Multiplayer_AllowPlayerToJoinWithCompanyVehicles = 38,
    Multiplayer_AllowCompanyAIDriver = 39,
    Multiplayer_AllowCorporationAIDriver = 40,
    Multiplayer_SearchDistance = 41,
    Party_IgnoreInvitation = 42,
    Company_IgnoreInvitation = 43,
    Language = 44,
    UseHShifter = 45,
    ShiftSelectorAsSwitch = 46,
    Input_UseMouseWheelAsThrottle = 47,
    HideUnavailableMarker = 48,
    ShowMarker_JobVehicle = 49,
    MarkerScale = 50,
    NameTagViewDistanceKm = 51,
    AutoTurnOffSignalLight = 52,
    Mouse_CameraRotationSpeed = 53,
    Controller_CameraRotationSpeed = 54,
    Controller_CockpitCameraRotationSpeed = 55,
    Controller_DisableWhileBackground = 56,
    Controller_StickDeadZone = 57,
    Controller_WorldMapStickDeadZone = 58,
    Mouse_InvertVerticalCameraRotation = 59,
    Mouse_InvertVerticalFPSCameraRotation = 60,
    HeadTracking_RotationDegree = 61,
    HeadTracking_Distance = 62,
    LengthUnits = 63,
    FuelConsumptionDisplay = 64,
    DriftModeChaseCameraMode = 65,
    DriftModeChaseCameraRotationSpeed = 66,
    HUDAspectRatio = 67,
    HUD_ShowSteeringAndPedals = 68,
    HUD_ShowFPS = 69,
    HUD_ShowBandwidth = 70,
    HUD_ShowServerFPS = 71,
    HUD_ShowVersion = 72,
    HUD_ShowRealTime = 73,
    HUD_ShowDynamicKeyHelper = 74,
    HUD_ShowNewTopSpeed = 75,
    HUD_ShowHelpMessage = 76,
    UI_Scale = 77,
    AutoShift = 78,
    AutoThrottleBlip = 79,
    AutoReverse = 80,
    AutoStartEngine = 81,
    AutoReleaseParkingBrakeByThrottle = 82,
    AutoAntiStallClutch = 83,
    ShiftingFailure = 84,
    KeyboardSteeringSpeed = 85,
    SteeringAssistStrength = 86,
    TractionControlStrength = 87,
    StabilityControlStrength = 88,
    ABSStrength = 89,
    ARPStrength = 90,
    UseAssistedBikeSteeringForSteeringWheelDevice = 91,
    AssistedBikeSteeringForSteeringWheelDeviceRange = 92,
    CharacterThirdPersonCameraFOV = 93,
    CharacterFirstPersonCameraFOV = 94,
    DroneCameraFOV = 95,
    Taxi_AcceptPassenger = 96,
    Taxi_AutoAcceptPassenger = 97,
    Taxi_AutoAcceptPassengerOffroad = 98,
    Taxi_FindComfort = 99,
    Taxi_FindUrgent = 100,
    Police_AutoAcceptSuspect = 101,
    Police_AutoAcceptPatrol = 102,
    Police_AllowPatrolOffroad = 103,
    Ambulance_AutoAcceptPassenger = 104,
    Ambulance_AutoAcceptPassengerOffroad = 105,
    DeliveryListSortingOrder = 106,
    ShowAutoPopup_Bus = 107,
    ShowAutoPopup_Taxi = 108,
    ShowAutoPopup_Ambulance = 109,
    ShowAutoPopup_TowRequest = 110,
    ShowAutoPopup_FireJob = 111,
    ChatBackgroundTransparency = 112,
    MinimapOrientation = 113,
    HUD_ShowMinimapWhenHidden = 114,
    HUD_ShowSpeedometerWhenHidden = 115,
    HUD_ShowChatWhenHidden = 116,
    DisableFlashingLightEffect = 117,
    DisableFlashingLight = 118,
    Count = 119,
    EMTUserSettingType_MAX = 120,
}

---@enum EMTUserSettingValueType
local EMTUserSettingValueType = {
    Float = 0,
    Int64 = 1,
    Bool = 2,
    String = 3,
    Enum = 4,
    EMTUserSettingValueType_MAX = 5,
}

---@enum EMTVehicleAIControllerState
local EMTVehicleAIControllerState = {
    Idle = 0,
    Roaming = 1,
    Chase = 2,
    Search = 3,
    EMTVehicleAIControllerState_MAX = 4,
}

---@enum EMTVehicleAITaxiDriverState
local EMTVehicleAITaxiDriverState = {
    None = 0,
    RoamingNearDepot = 1,
    GoingToPassenger = 2,
    GoingToDestination = 3,
    GoingToDepotForRefresh = 4,
    EMTVehicleAITaxiDriverState_MAX = 5,
}

---@enum EMTVehicleAIType
local EMTVehicleAIType = {
    None = 0,
    BusDriver = 1,
    TruckDriver = 2,
    TaxiDriver = 3,
    EMTVehicleAIType_MAX = 4,
}

---@enum EMTVehicleDoorFlags
local EMTVehicleDoorFlags = {
    None = 0,
    Openable = 1,
    StopAtCollision = 2,
    BusDoor = 4,
    DisablePhysicsCollisionInOpened = 8,
    DisablePhysicsCollisionInClosed = 16,
    EMTVehicleDoorFlags_MAX = 17,
}

---@enum EMTVehicleDoorState
local EMTVehicleDoorState = {
    Closed = 0,
    Opening = 1,
    Opened = 2,
    Closing = 3,
    Stopped = 4,
    EMTVehicleDoorState_MAX = 5,
}

---@enum EMTVehicleDoorType
local EMTVehicleDoorType = {
    None = 0,
    DriverDoor = 1,
    PassengerDoor = 2,
    Bus_DriverAndPassenger = 3,
    SchoolBus_StopSign = 4,
    Van_RearSwingDoor = 5,
    Van_OutSliding = 6,
    Trailer_LandingGear = 7,
    TowBar = 8,
    Dump = 9,
    DumpDoor = 10,
    Outrigger_Horizontal = 11,
    Outrigger_Vertical = 12,
    GarbageCompressLid = 13,
    FifthWheel = 14,
    CustomControl = 15,
    EMTVehicleDoorType_MAX = 16,
}

---@enum EMTVehicleDriveAllowedPlayers
local EMTVehicleDriveAllowedPlayers = {
    Everyone = 0,
    PartyOnly = 1,
    OwnerOnly = 2,
    EMTVehicleDriveAllowedPlayers_MAX = 3,
}

---@enum EMTVehicleExControl
local EMTVehicleExControl = {
    None = 0,
    Info = 1,
    RoadsideService = 2,
    Dump_Raise = 3,
    Dump_Lower = 4,
    Light_ToggleInternal = 5,
    Sleep = 6,
    Passengers = 7,
    Cargos = 8,
    SeatPosition = 9,
    MirrorPosition = 10,
    Lock = 11,
    ParkingBrake = 12,
    Taxi = 13,
    Ambulance = 14,
    TowRequest = 15,
    Bus = 16,
    Company = 17,
    Police = 18,
    Fire = 19,
    DriveModeSetting = 20,
    LiftUpBike = 21,
    Count = 22,
    EMTVehicleExControl_MAX = 23,
}

---@enum EMTVehicleFeature
local EMTVehicleFeature = {
    VF_SchoolBus = 0,
    VF_Siren = 1,
    VF_EmergencyVehicle = 2,
    VF_Count = 3,
    VF_MAX = 4,
}

---@enum EMTVehicleHookType
local EMTVehicleHookType = {
    None = 0,
    Socket = 1,
    TowingComponent = 2,
    TrailerHitch = 3,
    EMTVehicleHookType_MAX = 4,
}

---@enum EMTVehicleLOD
local EMTVehicleLOD = {
    LOD0 = 0,
    LOD1 = 1,
    LOD2 = 2,
    LOD3 = 3,
    LOD4 = 4,
    Count = 5,
    EMTVehicleLOD_MAX = 6,
}

---@enum EMTVehicleLightType
local EMTVehicleLightType = {
    None = 0,
    Head = 1,
    HighBeam = 2,
    Tail = 3,
    Brake = 4,
    SideMarker = 5,
    LeftSideMarker = 6,
    RightSideMarker = 7,
    RightTail = 8,
    LeftTail = 9,
    RightSignal = 10,
    LeftSignal = 11,
    Reverse = 12,
    Emergency = 13,
    Taxi = 14,
    Count = 15,
    EMTVehicleLightType_MAX = 16,
}

---@enum EMTVehiclePartSlot
local EMTVehiclePartSlot = {
    Invalid = 0,
    Body = 1,
    Engine = 2,
    Transmission = 3,
    FinalDriveRatio = 4,
    Intake = 5,
    CoolantRadiator = 6,
    Turbocharger = 7,
    LSD0 = 8,
    LSD1 = 9,
    LSD2 = 10,
    LSD3 = 11,
    LSD4 = 12,
    LSD5 = 13,
    LSD6 = 14,
    LSD7 = 15,
    LSD8 = 16,
    LSD9 = 17,
    LSDMax = 18,
    Tire0 = 19,
    Tire1 = 20,
    Tire2 = 21,
    Tire3 = 22,
    Tire4 = 23,
    Tire5 = 24,
    Tire6 = 25,
    Tire7 = 26,
    Tire8 = 27,
    Tire9 = 28,
    Tire10 = 29,
    Tire11 = 30,
    Tire12 = 31,
    Tire13 = 32,
    Tire14 = 33,
    Tire15 = 34,
    Tire16 = 35,
    Tire17 = 36,
    Tire18 = 37,
    Tire19 = 38,
    TireMax = 39,
    Wheel0 = 40,
    Wheel1 = 41,
    Wheel2 = 42,
    Wheel3 = 43,
    Wheel4 = 44,
    Wheel5 = 45,
    Wheel6 = 46,
    Wheel7 = 47,
    Wheel8 = 48,
    Wheel9 = 49,
    Wheel10 = 50,
    Wheel11 = 51,
    Wheel12 = 52,
    Wheel13 = 53,
    Wheel14 = 54,
    Wheel15 = 55,
    Wheel16 = 56,
    Wheel17 = 57,
    Wheel18 = 58,
    Wheel19 = 59,
    WheelMax = 60,
    WheelSpacer0 = 61,
    WheelSpacer1 = 62,
    WheelSpacer2 = 63,
    WheelSpacer3 = 64,
    WheelSpacer4 = 65,
    WheelSpacer5 = 66,
    WheelSpacer6 = 67,
    WheelSpacer7 = 68,
    WheelSpacer8 = 69,
    WheelSpacer9 = 70,
    WheelSpacer10 = 71,
    WheelSpacer11 = 72,
    WheelSpacer12 = 73,
    WheelSpacer13 = 74,
    WheelSpacer14 = 75,
    WheelSpacer15 = 76,
    WheelSpacer16 = 77,
    WheelSpacer17 = 78,
    WheelSpacer18 = 79,
    WheelSpacer19 = 80,
    WheelSpacerMax = 81,
    BrakePad0 = 82,
    BrakePad1 = 83,
    BrakePad2 = 84,
    BrakePad3 = 85,
    BrakePad4 = 86,
    BrakePad5 = 87,
    BrakePad6 = 88,
    BrakePad7 = 89,
    BrakePad8 = 90,
    BrakePad9 = 91,
    BrakePad10 = 92,
    BrakePad11 = 93,
    BrakePad12 = 94,
    BrakePad13 = 95,
    BrakePad14 = 96,
    BrakePad15 = 97,
    BrakePad16 = 98,
    BrakePad17 = 99,
    BrakePad18 = 100,
    BrakePad19 = 101,
    BrakePadMax = 102,
    AngleKit = 103,
    Suspension_Spring0 = 104,
    Suspension_Spring1 = 105,
    Suspension_Spring2 = 106,
    Suspension_Spring3 = 107,
    Suspension_Spring4 = 108,
    Suspension_Spring5 = 109,
    Suspension_Spring6 = 110,
    Suspension_Spring7 = 111,
    Suspension_Spring8 = 112,
    Suspension_Spring9 = 113,
    Suspension_Spring10 = 114,
    Suspension_Spring11 = 115,
    Suspension_Spring12 = 116,
    Suspension_Spring13 = 117,
    Suspension_Spring14 = 118,
    Suspension_Spring15 = 119,
    Suspension_Spring16 = 120,
    Suspension_Spring17 = 121,
    Suspension_Spring18 = 122,
    Suspension_Spring19 = 123,
    Suspension_SpringMax = 124,
    Suspension_Damper0 = 125,
    Suspension_Damper1 = 126,
    Suspension_Damper2 = 127,
    Suspension_Damper3 = 128,
    Suspension_Damper4 = 129,
    Suspension_Damper5 = 130,
    Suspension_Damper6 = 131,
    Suspension_Damper7 = 132,
    Suspension_Damper8 = 133,
    Suspension_Damper9 = 134,
    Suspension_Damper10 = 135,
    Suspension_Damper11 = 136,
    Suspension_Damper12 = 137,
    Suspension_Damper13 = 138,
    Suspension_Damper14 = 139,
    Suspension_Damper15 = 140,
    Suspension_Damper16 = 141,
    Suspension_Damper17 = 142,
    Suspension_Damper18 = 143,
    Suspension_Damper19 = 144,
    Suspension_DamperMax = 145,
    Suspension_RideHeight0 = 146,
    Suspension_RideHeight1 = 147,
    Suspension_RideHeight2 = 148,
    Suspension_RideHeight3 = 149,
    Suspension_RideHeight4 = 150,
    Suspension_RideHeight5 = 151,
    Suspension_RideHeight6 = 152,
    Suspension_RideHeight7 = 153,
    Suspension_RideHeight8 = 154,
    Suspension_RideHeight9 = 155,
    Suspension_RideHeight10 = 156,
    Suspension_RideHeight11 = 157,
    Suspension_RideHeight12 = 158,
    Suspension_RideHeight13 = 159,
    Suspension_RideHeight14 = 160,
    Suspension_RideHeight15 = 161,
    Suspension_RideHeight16 = 162,
    Suspension_RideHeight17 = 163,
    Suspension_RideHeight18 = 164,
    Suspension_RideHeight19 = 165,
    Suspension_RideHeightMax = 166,
    AntiRollBar0 = 167,
    AntiRollBar1 = 168,
    AntiRollBar2 = 169,
    AntiRollBar3 = 170,
    AntiRollBar4 = 171,
    AntiRollBar5 = 172,
    AntiRollBar6 = 173,
    AntiRollBar7 = 174,
    AntiRollBar8 = 175,
    AntiRollBar9 = 176,
    AntiRollBarMax = 177,
    TaxiLicense = 178,
    BusLicense = 179,
    EscortLicense = 180,
    FrontSpoiler = 181,
    RearSpoiler = 182,
    RearWing = 183,
    Fender = 184,
    SideSkirt = 185,
    FrontWindowSticker = 186,
    FrontWindowSunVisor = 187,
    RearWindowLouvers = 188,
    TrailerHitch = 189,
    CargoBed0 = 190,
    CargoBedAttachment0 = 191,
    RoofRack0 = 192,
    Roof = 193,
    FrontBumper = 194,
    RearBumper = 195,
    Bonnet = 196,
    Trunk = 197,
    Winch0 = 198,
    Crane0 = 199,
    Crane1 = 200,
    Crane2 = 201,
    BrakePower = 202,
    BrakeBalance = 203,
    Headlight = 204,
    Utility0 = 205,
    Utility1 = 206,
    Utility2 = 207,
    Utility3 = 208,
    Utility4 = 209,
    Utility5 = 210,
    Utility6 = 211,
    Utility7 = 212,
    Utility8 = 213,
    Utility9 = 214,
    UtilityMax = 215,
    Bullbar = 216,
    Attachment0 = 217,
    Attachment1 = 218,
    Attachment2 = 219,
    Attachment3 = 220,
    Attachment4 = 221,
    Attachment5 = 222,
    Attachment6 = 223,
    Attachment7 = 224,
    Attachment8 = 225,
    Attachment9 = 226,
    Attachment10 = 227,
    Attachment11 = 228,
    Attachment12 = 229,
    Attachment13 = 230,
    Attachment14 = 231,
    Attachment15 = 232,
    Attachment16 = 233,
    Attachment17 = 234,
    Attachment18 = 235,
    Attachment19 = 236,
    AttachmentMax = 237,
    EMTVehiclePartSlot_MAX = 238,
}

---@enum EMTVehiclePartType
local EMTVehiclePartType = {
    Invalid = 0,
    Body = 1,
    Engine = 2,
    Transmission = 3,
    LSD = 4,
    FinalDriveRatio = 5,
    Intake = 6,
    CoolantRadiator = 7,
    Turbocharger = 8,
    Tire = 9,
    Suspension_Spring = 10,
    Suspension_Damper = 11,
    Suspension_RideHeight = 12,
    AntiRollBar = 13,
    TaxiLicense = 14,
    BusLicense = 15,
    EscortLicense = 16,
    FrontSpoiler = 17,
    RearSpoiler = 18,
    RearWing = 19,
    TrailerHitch = 20,
    CargoBed = 21,
    CargoBedAttachment = 22,
    RoofRack = 23,
    Roof = 24,
    FrontBumper = 25,
    RearBumper = 26,
    Bonnet = 27,
    Trunk = 28,
    Fender = 29,
    SideSkirt = 30,
    FrontWindowSticker = 31,
    FrontWindowSunVisor = 32,
    RearWindowLouvers = 33,
    Wheel = 34,
    WheelSpacer = 35,
    AngleKit = 36,
    Winch = 37,
    BrakePad = 38,
    BrakePower = 39,
    BrakeBalance = 40,
    Headlight = 41,
    Utility = 42,
    Bullbar = 43,
    Attachment = 44,
    Max = 45,
}

---@enum EMTVehicleSettingType
local EMTVehicleSettingType = {
    None = 0,
    Comfort_Throttle_RangeMax = 1,
    Comfort_Throttle_Linearity = 2,
    Comfort_Throttle_ButtonPressSensitivity = 3,
    Comfort_Throttle_ButtonReleaseSensitivity = 4,
    Comfort_Brake_RangeMax = 5,
    Comfort_Brake_Linearity = 6,
    Comfort_Brake_ButtonPressSensitivity = 7,
    Comfort_Brake_ButtonReleaseSensitivity = 8,
    Comfort_HandBrake_ButtonPressSensitivity = 9,
    Comfort_HandBrake_ButtonReleaseSensitivity = 10,
    Comfort_ShiftUpRPM = 11,
    Sport_Throttle_RangeMax = 12,
    Sport_Throttle_Linearity = 13,
    Sport_Throttle_ButtonPressSensitivity = 14,
    Sport_Throttle_ButtonReleaseSensitivity = 15,
    Sport_Brake_RangeMax = 16,
    Sport_Brake_Linearity = 17,
    Sport_Brake_ButtonPressSensitivity = 18,
    Sport_Brake_ButtonReleaseSensitivity = 19,
    Sport_HandBrake_ButtonPressSensitivity = 20,
    Sport_HandBrake_ButtonReleaseSensitivity = 21,
    Sport_ShiftUpRPM = 22,
    Drift_Throttle_RangeMax = 23,
    Drift_Throttle_Linearity = 24,
    Drift_Throttle_ButtonPressSensitivity = 25,
    Drift_Throttle_ButtonReleaseSensitivity = 26,
    Drift_Brake_RangeMax = 27,
    Drift_Brake_Linearity = 28,
    Drift_Brake_ButtonPressSensitivity = 29,
    Drift_Brake_ButtonReleaseSensitivity = 30,
    Drift_HandBrake_ButtonPressSensitivity = 31,
    Drift_HandBrake_ButtonReleaseSensitivity = 32,
    Drift_ShiftUpRPM = 33,
    Owner_ShowAsLookingForDriver = 34,
    DriveMode = 35,
    EnableSoftRevLimiter = 36,
    ARPStrength = 37,
    FuelPumpAccessRight = 38,
    FuelPumpPriceRate = 39,
    CockpitCameraDefaultPitch = 40,
    ChaseCameraDefaultPitch = 41,
    Max = 42,
}

---@enum EMTVehicleSuspensionType
local EMTVehicleSuspensionType = {
    None = 0,
    AnimBPTarget = 1,
    TrailArm = 2,
    EMTVehicleSuspensionType_MAX = 3,
}

---@enum EMTVehicleToggleFunction
local EMTVehicleToggleFunction = {
    None = 0,
    Siren = 1,
    SchoolBusStopSign = 2,
    InteriorLight = 3,
    Count = 4,
    EMTVehicleToggleFunction_MAX = 5,
}

---@enum EMTVehicleTurnSingal
local EMTVehicleTurnSingal = {
    Off = 0,
    Left = 1,
    Right = 2,
    Hazard = 3,
    EMTVehicleTurnSingal_MAX = 4,
}

---@enum EMTVehicleType
local EMTVehicleType = {
    None = 0,
    Kart = 1,
    Small = 2,
    Pickup = 3,
    Bus = 4,
    Truck = 5,
    SemiTractor = 6,
    SemiTrailer = 7,
    SmallTrailer = 8,
    Motorhome = 9,
    Caravan = 10,
    HeavyMachinery = 11,
    Bike = 12,
    Racecar = 13,
    Max = 14,
}

---@enum EMTVehicleTypeFlags
local EMTVehicleTypeFlags = {
    None = 0,
    Garbage = 1,
    TowTruck = 2,
    NeedLargeVehicleGarage = 4,
    Police = 8,
    NotForSale = 16,
    EMTVehicleTypeFlags_MAX = 17,
}

---@enum EMTVoiceLineType
local EMTVoiceLineType = {
    None = 0,
    Oh_Surprised = 1,
    BeCareful = 2,
    WhatsWrong = 3,
    AreYouAlright = 4,
    Hey_Suprised = 5,
    Hello = 6,
    ThankYou = 7,
    Police_InPursuit = 8,
    Police_SuspectInCustody = 9,
    EMTVoiceLineType_MAX = 10,
}

---@enum EMTWeather
local EMTWeather = {
    Sunny = 0,
    Rain = 1,
    Max = 2,
}

---@enum EMTWeightInMotionType
local EMTWeightInMotionType = {
    None = 0,
    Police = 1,
    Gate = 2,
    EMTWeightInMotionType_MAX = 3,
}

---@enum EMTWheelFlags
local EMTWheelFlags = {
    DualRearWheel = 0,
    RearWheel = 1,
    QuadWheel = 2,
    EMTWheelFlags_MAX = 3,
}

---@enum EMTWidgetInputAction
local EMTWidgetInputAction = {
    OK = 0,
    Cancel = 1,
    EMTWidgetInputAction_MAX = 2,
}

---@enum EMTWinchControl
local EMTWinchControl = {
    Idle = 0,
    In = 1,
    Out = 2,
    EMTWinchControl_MAX = 3,
}

---@enum EMTWingControlSurfaceType
local EMTWingControlSurfaceType = {
    None = 0,
    Aileron = 1,
    Elevator = 2,
    Max = 3,
}

---@enum EMTZoneCoeffType
local EMTZoneCoeffType = {
    None = 0,
    FoodConsumptionSpeedMultiplier = 1,
    GarbageCollectionRateDecreaseSpeedMultiplier = 2,
    EMTZoneCoeffType_MAX = 3,
}

---@enum EMoneyTransactionType
local EMoneyTransactionType = {
    None = 0,
    CargoDelivery = 1,
    TaxiPassenger = 2,
    AmbulancePassenger = 3,
    BusPassenger = 4,
    Wrecker = 5,
    VehicleRunningCost = 6,
    VehicleRepair = 7,
    VehicleRefuel = 8,
    ContractAcquire = 9,
    VehicleSlot = 10,
    EMoneyTransactionType_MAX = 11,
}

---@enum EMotorTownGameType
local EMotorTownGameType = {
    Menu = 0,
    Driving = 1,
    TimeAttack = 2,
    Autocross = 3,
    Race = 4,
    EMotorTownGameType_MAX = 5,
}

---@enum EMotorTownInteractableType
local EMotorTownInteractableType = {
    None = 0,
    EnterVehicle = 1,
    EnterVehiclePassenger = 2,
    EnterVehicleParentSeat = 3,
    EnterVehicleChildSeat = 4,
    GasStation_FuelPump = 5,
    EVCharger = 6,
    Delivery_Sender = 7,
    Car_Seller = 8,
    SellVehicle = 9,
    Garage = 10,
    Cargo = 11,
    Despawn = 12,
    CargoSpace = 13,
    LoadCargoFromSpawner = 14,
    CargoReceiver = 15,
    UseActor = 16,
    Hitchhiking = 17,
    TaxiPassenger = 18,
    AmbulancePassenger = 19,
    ToggleVehicleDoor = 20,
    ToggleLandingGear = 21,
    SaveLandingGearLength = 22,
    ResetLandingGearLength = 23,
    Adjust = 24,
    TrailerControlPanel = 25,
    TrailerCargoList = 26,
    ToggleTowBar = 27,
    TrailerHook = 28,
    TrailerUnhook = 29,
    TowingHook = 30,
    TowingUnhook = 31,
    PTOThrottleUp = 32,
    PTOThrottleDown = 33,
    Sleep = 34,
    Seat = 35,
    HouseForSale = 36,
    HouseManagement = 37,
    Park = 38,
    SummonVehicle = 39,
    Vendor = 40,
    Talk = 41,
    Item = 42,
    GetItem = 43,
    TrashItem = 44,
    SpawnTaxi = 45,
    SpawnPoliceVehicle = 46,
    SpawnAmbulance = 47,
    SpawnVehicle = 48,
    Tanker_FuelPump = 49,
    Crane0_In = 50,
    Crane0_Out = 51,
    Crane1_In = 52,
    Crane1_Out = 53,
    Crane2_In = 54,
    Crane2_Out = 55,
    ToggleWaterSpray = 56,
    BuyThisItem = 57,
    StrapCargo = 58,
    RefuelWithJerrycan = 59,
    RefillCoolant = 60,
    RepairFlatTire = 61,
    Throw = 62,
    OpenBusDoor = 63,
    CloseBusDoor = 64,
    PickupWinchHook = 65,
    AttachWinch = 66,
    CutWinchCable = 67,
    PickupWinchController = 68,
    PickupWaterHoseNozzle = 69,
    Outrigger_Horizontal = 70,
    Outrigger_Vertical = 71,
    Garbage_CompressLoader = 72,
    Police_RequestTow = 73,
    PlaceCarryingPatientIntoVehicle = 74,
    Build = 75,
    Construct = 76,
    ManageBuilding = 77,
    BuildingPlacement = 78,
    AttachToVehicle = 79,
    CreateCompany = 80,
    Uninstall = 81,
    ToggleLight = 82,
    ChangeLightMode = 83,
    ChangeLightColor = 84,
    Placement = 85,
    Loan = 86,
    OpenInventory = 87,
    OpenCharacterEditor = 88,
    EMotorTownInteractableType_MAX = 89,
}

---@enum EMotorTownMissionType
local EMotorTownMissionType = {
    None = 0,
    TimeAttack = 1,
    Autocross = 2,
    Delivery = 3,
    Race = 4,
    Police = 5,
    EMotorTownMissionType_MAX = 6,
}

---@enum EMotorTownSurface
local EMotorTownSurface = {
    Default = 0,
    Grass = 1,
    Dirt = 2,
    Vehicle = 3,
    Metal = 4,
    Asphalt = 5,
    Wood = 6,
    Snow = 7,
    Rubber = 8,
    Plastic = 9,
    Sand = 10,
    Mud = 11,
    Water = 12,
    Max = 13,
}

---@enum EMotorTownSurfaceEnv
local EMotorTownSurfaceEnv = {
    None = 0,
    Water = 1,
    EMotorTownSurfaceEnv_MAX = 2,
}

---@enum EStaticMeshSpawnerMeshType
local EStaticMeshSpawnerMeshType = {
    Default = 0,
    Start = 1,
    End = 2,
    Single = 3,
    EStaticMeshSpawnerMeshType_MAX = 4,
}

---@enum EVehicleCameraMode
local EVehicleCameraMode = {
    Trail = 0,
    TrailLong = 1,
    Cockpit = 2,
    CockpitNoSteel = 3,
    Stationary = 4,
    Count = 5,
    EVehicleCameraMode_MAX = 6,
}

