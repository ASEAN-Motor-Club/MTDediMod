---@enum EAddCargoResult
local EAddCargoResult = {
    Success = 0,
    Failed = 1,
    NoCargo = 2,
    CharacterIsAlreadyHoldingCargo = 3,
    CharacterCanOnlyHoldOneCargo = 4,
    NotPickupable = 5,
    NotEnoughCargoSpace = 6,
    EAddCargoResult_MAX = 7,
}

---@enum EDeliverMissionAcceptResponseCode
local EDeliverMissionAcceptResponseCode = {
    Success = 0,
    ServerError = 1,
    NotExists = 2,
    LoadingFailed = 3,
    NotEnoughSpace = 4,
    EDeliverMissionAcceptResponseCode_MAX = 5,
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
    EMTAccountStatType_MAX = 14,
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
    EMTCargoActorFlags_MAX = 9,
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
    EMTCargoFlags_MAX = 33,
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
    NoBlockVehicle = 1,
    Ghost = 4,
    MeshPicking = 8,
    HideCostume = 16,
    EMTCharacterFlags_MAX = 17,
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
    NotifyCargoDeliveries = 4,
    EMTCompanyVehicleFlags_MAX = 5,
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
    EMTItemType_MAX = 7,
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
    Count = 9,
    EMTMapIconType_MAX = 10,
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
    EMTMirroType_MAX = 6,
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
    EMTPOIFlags_MAX = 1025,
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
    Max = 17,
}

---@enum EMTPlayerDataWorldCharacterType
local EMTPlayerDataWorldCharacterType = {
    None = 0,
    Resident = 1,
    Hitchhiker = 2,
    TaxiPassenger = 3,
    BusPassenger = 4,
    SearchAndRescuePatient = 5,
    EMTPlayerDataWorldCharacterType_MAX = 6,
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
    EMTTowRequestFlags_MAX = 9,
}

---@enum EMTTowingHookType
local EMTTowingHookType = {
    Sling = 0,
    Lift = 1,
    EMTTowingHookType_MAX = 2,
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
    CockpitCameraShake = 7,
    AutoRecenterCockpitCameraAfterSeconds = 8,
    AutoRecenterChaseCameraAfterSeconds = 9,
    DisableAutoRencterCameraDuringReverse = 10,
    CameraLookLeftRightAngle = 11,
    CameraLookLeftRightByRate = 12,
    BikeCockpitCameraHorizontalLock = 13,
    ShowVirtualMirror = 14,
    RenderMirrorPerFrame = 15,
    RenderMirrorInChaseView = 16,
    RenderMirrorInCharacterMode = 17,
    Graphic_Brightness = 18,
    MoonLightBrigtness = 19,
    AntiAliasingMethod = 20,
    VehicleLODQualityLevel = 21,
    HideSteeringWheel = 22,
    Sound_MasterVolume = 23,
    Sound_BGMVolume = 24,
    Sound_EffectVolume = 25,
    Sound_EngineVolume = 26,
    Sound_TireVolume = 27,
    Sound_WindNoiseVolume = 28,
    Sound_MuffleInCabin = 29,
    Net_UseUPNP = 30,
    Net_ReceiveBroadcastMessages = 31,
    Multiplayer_JoinVehicleId = 32,
    Multiplayer_MaxNumPlayers = 33,
    Multiplayer_Password = 34,
    Multiplayer_MaxVehiclePerPlayer = 35,
    Multiplayer_AllowPlayerToJoinWithCompanyVehicles = 36,
    Multiplayer_AllowCompanyAIDriver = 37,
    Multiplayer_AllowCorporationAIDriver = 38,
    Multiplayer_SearchDistance = 39,
    Party_IgnoreInvitation = 40,
    Company_IgnoreInvitation = 41,
    Language = 42,
    UseHShifter = 43,
    ShiftSelectorAsSwitch = 44,
    Input_UseMouseWheelAsThrottle = 45,
    HideUnavailableMarker = 46,
    ShowMarker_JobVehicle = 47,
    MarkerScale = 48,
    NameTagViewDistanceKm = 49,
    AutoTurnOffSignalLight = 50,
    Mouse_CameraRotationSpeed = 51,
    Controller_CameraRotationSpeed = 52,
    Controller_CockpitCameraRotationSpeed = 53,
    Controller_DisableWhileBackground = 54,
    Controller_StickDeadZone = 55,
    Controller_WorldMapStickDeadZone = 56,
    Mouse_InvertVerticalCameraRotation = 57,
    Mouse_InvertVerticalFPSCameraRotation = 58,
    HeadTracking_RotationDegree = 59,
    HeadTracking_Distance = 60,
    LengthUnits = 61,
    FuelConsumptionDisplay = 62,
    DriftModeChaseCameraRotationSpeed = 63,
    HUD_ShowSteeringAndPedals = 64,
    HUD_ShowFPS = 65,
    HUD_ShowBandwidth = 66,
    HUD_ShowServerFPS = 67,
    HUD_ShowVersion = 68,
    HUD_ShowRealTime = 69,
    HUD_ShowDynamicKeyHelper = 70,
    HUD_ShowNewTopSpeed = 71,
    HUD_ShowHelpMessage = 72,
    UI_Scale = 73,
    AutoShift = 74,
    AutoThrottleBlip = 75,
    AutoReverse = 76,
    AutoStartEngine = 77,
    AutoAntiStallClutch = 78,
    ShiftingFailure = 79,
    KeyboardSteeringSpeed = 80,
    SteeringAssistStrength = 81,
    TractionControlStrength = 82,
    StabilityControlStrength = 83,
    ABSStrength = 84,
    ARPStrength = 85,
    UseAssistedBikeSteeringForSteeringWheelDevice = 86,
    AssistedBikeSteeringForSteeringWheelDeviceRange = 87,
    CharacterThirdPersonCameraFOV = 88,
    CharacterFirstPersonCameraFOV = 89,
    Taxi_AcceptPassenger = 90,
    Taxi_AutoAcceptPassenger = 91,
    Taxi_AutoAcceptPassengerOffroad = 92,
    Taxi_FindComfort = 93,
    Taxi_FindUrgent = 94,
    Police_AutoAcceptSuspect = 95,
    Police_AutoAcceptPatrol = 96,
    Police_AllowPatrolOffroad = 97,
    Ambulance_AutoAcceptPassenger = 98,
    Ambulance_AutoAcceptPassengerOffroad = 99,
    DeliveryListSortingOrder = 100,
    ShowAutoPopup_Bus = 101,
    ShowAutoPopup_Taxi = 102,
    ShowAutoPopup_Ambulance = 103,
    ShowAutoPopup_TowRequest = 104,
    ShowAutoPopup_FireJob = 105,
    ChatBackgroundTransparency = 106,
    MinimapOrientation = 107,
    DisableFlashingLightEffect = 108,
    DisableFlashingLight = 109,
    Count = 110,
    EMTUserSettingType_MAX = 111,
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

---@enum EMTVehicleAIType
local EMTVehicleAIType = {
    None = 0,
    BusDriver = 1,
    TruckDriver = 2,
    EMTVehicleAIType_MAX = 3,
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
    EMTVehicleDoorType_MAX = 15,
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
    WheelSpacerMax = 69,
    BrakePad0 = 70,
    BrakePad1 = 71,
    BrakePad2 = 72,
    BrakePad3 = 73,
    BrakePad4 = 74,
    BrakePad5 = 75,
    BrakePad6 = 76,
    BrakePad7 = 77,
    BrakePadMax = 78,
    AngleKit = 79,
    Suspension_Spring0 = 80,
    Suspension_Spring1 = 81,
    Suspension_Spring2 = 82,
    Suspension_Spring3 = 83,
    Suspension_Spring4 = 84,
    Suspension_Spring5 = 85,
    Suspension_Spring6 = 86,
    Suspension_Spring7 = 87,
    Suspension_SpringMax = 88,
    Suspension_Damper0 = 89,
    Suspension_Damper1 = 90,
    Suspension_Damper2 = 91,
    Suspension_Damper3 = 92,
    Suspension_Damper4 = 93,
    Suspension_Damper5 = 94,
    Suspension_Damper6 = 95,
    Suspension_Damper7 = 96,
    Suspension_DamperMax = 97,
    Suspension_RideHeight0 = 98,
    Suspension_RideHeight1 = 99,
    Suspension_RideHeight2 = 100,
    Suspension_RideHeight3 = 101,
    Suspension_RideHeight4 = 102,
    Suspension_RideHeight5 = 103,
    Suspension_RideHeight6 = 104,
    Suspension_RideHeight7 = 105,
    Suspension_RideHeightMax = 106,
    AntiRollBar0 = 107,
    AntiRollBar1 = 108,
    AntiRollBar2 = 109,
    AntiRollBarMax = 110,
    TaxiLicense = 111,
    BusLicense = 112,
    FrontSpoiler = 113,
    RearSpoiler = 114,
    RearWing = 115,
    Fender = 116,
    SideSkirt = 117,
    FrontWindowSticker = 118,
    FrontWindowSunVisor = 119,
    RearWindowLouvers = 120,
    TrailerHitch = 121,
    CargoBed0 = 122,
    CargoBedAttachment0 = 123,
    RoofRack0 = 124,
    Roof = 125,
    FrontBumper = 126,
    RearBumper = 127,
    Bonnet = 128,
    Trunk = 129,
    Winch0 = 130,
    Crane0 = 131,
    Crane1 = 132,
    Crane2 = 133,
    BrakePower = 134,
    BrakeBalance = 135,
    Headlight = 136,
    Utility0 = 137,
    Utility1 = 138,
    Utility2 = 139,
    Utility3 = 140,
    Utility4 = 141,
    Utility5 = 142,
    Utility6 = 143,
    Utility7 = 144,
    Utility8 = 145,
    Utility9 = 146,
    UtilityMax = 147,
    Bullbar = 148,
    Attachment0 = 149,
    Attachment1 = 150,
    Attachment2 = 151,
    Attachment3 = 152,
    Attachment4 = 153,
    Attachment5 = 154,
    Attachment6 = 155,
    Attachment7 = 156,
    Attachment8 = 157,
    Attachment9 = 158,
    Attachment10 = 159,
    Attachment11 = 160,
    Attachment12 = 161,
    Attachment13 = 162,
    Attachment14 = 163,
    Attachment15 = 164,
    Attachment16 = 165,
    Attachment17 = 166,
    Attachment18 = 167,
    Attachment19 = 168,
    AttachmentMax = 169,
    EMTVehiclePartSlot_MAX = 170,
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
    FrontSpoiler = 16,
    RearSpoiler = 17,
    RearWing = 18,
    TrailerHitch = 19,
    CargoBed = 20,
    CargoBedAttachment = 21,
    RoofRack = 22,
    Roof = 23,
    FrontBumper = 24,
    RearBumper = 25,
    Bonnet = 26,
    Trunk = 27,
    Fender = 28,
    SideSkirt = 29,
    FrontWindowSticker = 30,
    FrontWindowSunVisor = 31,
    RearWindowLouvers = 32,
    Wheel = 33,
    WheelSpacer = 34,
    AngleKit = 35,
    Winch = 36,
    BrakePad = 37,
    BrakePower = 38,
    BrakeBalance = 39,
    Headlight = 40,
    Utility = 41,
    Bullbar = 42,
    Attachment = 43,
    Max = 44,
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
    Max = 40,
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
    EMTWheelFlags_MAX = 2,
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
    Outrigger_Horizontal = 69,
    Outrigger_Vertical = 70,
    Garbage_CompressLoader = 71,
    Police_RequestTow = 72,
    PlaceCarryingPatientIntoVehicle = 73,
    Build = 74,
    Construct = 75,
    ManageBuilding = 76,
    AttachToVehicle = 77,
    CreateCompany = 78,
    Uninstall = 79,
    ToggleLight = 80,
    ChangeLightMode = 81,
    ChangeLightColor = 82,
    Placement = 83,
    Loan = 84,
    OpenInventory = 85,
    OpenCharacterEditor = 86,
    EMotorTownInteractableType_MAX = 87,
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

