local webhook = require("Webclient")
local UEHelpers = require("UEHelpers")
local json = require("JsonParser")
local cargo = require("CargoManager")
local assetManager = require("AssetManager")
local timer = require("Debugging/Timer")

local vehicleDealerSoftPath = "/Script/MotorTown.MTDealerVehicleSpawnPoint"
local garageSoftPath = "/Game/Objects/GarageActorBP.GarageActorBP_C"

local function GetPlayerVehicle(PC)
  if PC.LastVehicle ~= nil and PC.LastVehicle:IsValid() then
    return PC.LastVehicle
  end
  local pawn = PC:K2_GetPawn()
  if pawn:IsValid() then
    local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")

    if pawn:IsA(vehicleClass) and pawn:IsValid() then
      return pawn
    end
  end
end

---Convert FMTVehicleColorSlot to JSON serializable table
---@param slot FMTVehicleColorSlot
local function ColorSlotToTable(slot)
  return {
    DefaultColor = ColorToTable(slot.DefaultColor),
    DisplayName = slot.DisplayName:ToString(),
    bUseColorAlpha = slot.bUseColorAlpha
  }
end

---Convert FMTVehicleColor to JSON serializable table
---@param color FMTVehicleColor
local function VehicleColorToTable(color)
  local data = {}

  data.Colors = {}
  color.Colors:ForEach(function(key, value)
    data.Colors[key:get():ToString()] = ColorToTable(value:get())
  end)

  return data
end

---Convert FMTVehicleColorSlot to JSON serializable table
---@param slot FMTVehicleColorSlot
local function VehicleColorSlotToTable(slot)
  return {
    DefaultColor = ColorToTable(slot.DefaultColor),
    DisplayName = slot.DisplayName:ToString(),
    bUseColorAlpha = slot.bUseColorAlpha
  }
end

---Convert FMTVehiclePartIntake to JSON serializable table
---@param intake FMTVehiclePartIntake
local function VehicleIntakeToTable(intake)
  return {
    BaseRPMRatio = intake.BaseRPMRatio,
    IntakeSpeedEfficencyMultiplier = intake.IntakeSpeedEfficencyMultiplier,
    Slope = intake.Slope
  }
end

---Converts FMTVehiclePartTurbocharger to JSON serializable table
---@param turbo FMTVehiclePartTurbocharger
local function VehicleTurboToTable(turbo)
  local data = {}

  data.bIsValid = turbo.bIsValid
  data.BaseTorqueMultiplier = turbo.BaseTorqueMultiplier
  data.TorqueMultiplier = turbo.TorqueMultiplier
  data.TurbineAspectRatio = turbo.TurbineAspectRatio
  data.IntakePressureMultiplier = turbo.IntakePressureMultiplier
  data.HeatingMultiplier = turbo.HeatingMultiplier
  data.FuelConsumptionMultiplier = turbo.FuelConsumptionMultiplier
  data.TurbineWeight = turbo.TurbineWeight

  return data
end

---Converts FMTTirePhysicsParams to JSON serializable table
---@param tire FMTTirePhysicsParams
local function TirePhysicsToTable(tire)
  return {
    PatchLengthCoefficient = tire.PatchLengthCoefficient,
    StaticMu = tire.StaticMu,
    SlidingMu = tire.SlidingMu,
    SpringX = tire.SpringX,
    SpringY = tire.SpringY,
    DampingX = tire.DampingX,
    DampingY = tire.DampingY,
    CoolDownSpeed = tire.CoolDownSpeed,
    WarmUpSpeed = tire.WarmUpSpeed,
    WearRate = tire.WearRate,
    SmokeRate = tire.SmokeRate,
    MaxWeightKg = tire.MaxWeightKg,
    BrushCount = tire.BrushCount,
    OffroadFriction = tire.OffroadFriction,
    RollingResistanceCoeff = tire.RollingResistanceCoeff,
    RollingResistanceCoeffV1 = tire.RollingResistanceCoeffV1,
  }
end

---Converts FMTVehiclePartTire to JSON serializable table
---@param tire FMTVehiclePartTire
local function VehicleTireToTable(tire)
  return {
    TirePhysicsDataAsset = tire.TirePhysicsDataAsset:IsValid() and {
      TirePhysicsParams = TirePhysicsToTable(tire.TirePhysicsDataAsset.TirePhysicsParams)
    } or json.null,
    TirePhysicsDataAsset_BikeRear = tire.TirePhysicsDataAsset_BikeRear:IsValid() and {
      TirePhysicsParams = TirePhysicsToTable(tire.TirePhysicsDataAsset_BikeRear.TirePhysicsParams)
    } or json.null,
    bIsDualRearWheel = tire.bIsDualRearWheel
  }
end

---Converts FMTVehiclePartAero to JSON serializable table
---@param aero FMTVehiclePartAero
local function VehicleAeroToTable(aero)
  local data = {}

  -- data.Mesh = aero.Mesh
  -- data.SkelealMesh = aero.SkelealMesh
  data.bUseCustomSocket = aero.bUseCustomSocket
  data.CustomSocketName = aero.CustomSocketName:ToString()
  data.ComponentTags = {}
  aero.ComponentTags:ForEach(function(index, element)
    table.insert(data.ComponentTags, element:get():ToString())
  end)

  return data
end

---Converts FMTVehiclePartCargoBed to JSON serializable table
---@param cargo FMTVehiclePartCargoBed
local function VehicleCargoBedToTable(cargo)
  return {
    CargoSpaceLocation = VectorToTable(cargo.CargoSpaceLocation),
    CargoSpaceSize = VectorToTable(cargo.CargoSpaceSize),
    CargoSpaceType = cargo.CargoSpaceType,
    bFixCargo = cargo.bFixCargo,
    bUnlimitedHeight = cargo.bUnlimitedHeight,
    DumpVolume = cargo.DumpVolume,
  }
end

---Converts FMTVehiclePartBrakePad to JSON serializable table
---@param brake FMTVehiclePartBrakePad
local function VehicleBrakePadToTable(brake)
  return {
    HeatingMultiplier = brake.HeatingMultiplier,
    CoolingMultiplier = brake.CoolingMultiplier,
    FadeTemperature = brake.FadeTemperature,
    WearMultiplier = brake.WearMultiplier,
  }
end

---Convert FVehiclePartRow to JSON serializable table
---@param row FVehiclePartRow
local function VehiclePartRowToTable(row)
  local data = {}

  data.Name = row.Name:ToString()

  data.Name2 = {}
  data.Name2.Texts = {}
  row.Name2.Texts:ForEach(function(index, element)
    table.insert(data.Name2.Texts, element:get():ToString())
  end)

  data.Desciption = row.Desciption:ToString()
  data.Cost = row.Cost
  data.bIsHidden = row.bIsHidden
  data.MassKg = row.MassKg
  data.AirDragMultiplier = row.AirDragMultiplier
  data.TrailerAirDragMultiplier = row.TrailerAirDragMultiplier
  data.AeroLift = row.AeroLift
  data.FrontAeroLift = row.FrontAeroLift
  data.RearAeroLift = row.RearAeroLift
  data.FrontDamageMultiplier = row.FrontDamageMultiplier
  data.PartType = row.PartType
  data.GameplayTags = GameplayTagContainerToString(row.GameplayTags)

  data.VehicleTypes = {} ---@type number[]
  row.VehicleTypes:ForEach(function(index, element)
    table.insert(data.VehicleTypes, element:get())
  end)

  data.TruckClasses = {} ---@type number[]
  row.TruckClasses:ForEach(function(index, element)
    table.insert(data.TruckClasses, element:get())
  end)

  data.VehicleRowGameplayTagQuery = GameplayTagQueryToTable(row.VehicleRowGameplayTagQuery)

  data.LevelRequirementToBuy = {}
  row.LevelRequirementToBuy:ForEach(function(key, value)
    data.LevelRequirementToBuy[key:get()] = value:get()
  end)

  data.VehicleKeys = {} ---@type string[]
  row.VehicleKeys:ForEach(function(index, element)
    table.insert(data.VehicleKeys, element:get():ToString())
  end)

  data.OverrideAllowedVehicleKeys = {} ---@type string[]
  row.OverrideAllowedVehicleKeys:ForEach(function(index, element)
    table.insert(data.OverrideAllowedVehicleKeys, element:get():ToString())
  end)

  data.Slots = {} ---@type number[]
  row.Slots:ForEach(function(index, element)
    table.insert(data.Slots, element:get())
  end)

  data.BodyMaterialNames = {}
  row.BodyMaterialNames:ForEach(function(key, value)
    data.BodyMaterialNames[key:get():ToString()] = value:get():ToString()
  end)

  data.ColorSlots = {}
  row.ColorSlots:ForEach(function(key, value)
    data.ColorSlots[key:get()] = VehicleColorSlotToTable(value:get())
  end)

  data.DecalableMaterialSlotNames = {} ---@type string[]
  row.DecalableMaterialSlotNames:ForEach(function(index, element)
    table.insert(data.DecalableMaterialSlotNames, element:get():ToString())
  end)

  -- data.EngineAsset = row.EngineAsset
  -- data.TransmissionAsset = row.TransmissionAsset
  -- data.LSDAsset = row.LSDAsset
  data.FinalDriveRatio = row.FinalDriveRatio
  data.Intake = VehicleIntakeToTable(row.Intake)
  data.CoolantRadiator = {
    CoolantWaterInLiter = row.CoolantRadiator.CoolantWaterInLiter,
    CoolingPower = row.CoolantRadiator.CoolingPower
  }
  data.Turbocharger = VehicleTurboToTable(row.Turbocharger)
  data.Tire = VehicleTireToTable(row.Tire)
  data.SuspensionSpring = {
    SpringRateMultiplier = row.SuspensionSpring.SpringRateMultiplier
  }
  data.SuspensionDamper = {
    BoundDampingRateMultiplier = row.SuspensionDamper.BoundDampingRateMultiplier,
    ReboundDampingRateMultiplier = row.SuspensionDamper.ReboundDampingRateMultiplier
  }
  data.SuspensionRideHeight = {
    RideHeightChange = row.SuspensionRideHeight.RideHeightChange
  }
  data.AntiRollBar = {
    AntiRollBarRateMultiplier = row.AntiRollBar.AntiRollBarRateMultiplier
  }
  data.Aero = VehicleAeroToTable(row.Aero)
  -- data.Headlight = row.Headlight
  data.TrailerHitch = {
    ConnectionType = row.TrailerHitch.ConnectionType
  }
  data.CargoBed = VehicleCargoBedToTable(row.CargoBed)
  data.RoofRack = {
    CargoSpaceLocation = VectorToTable(row.RoofRack.CargoSpaceLocation),
    CargoSpaceSize = VectorToTable(row.RoofRack.CargoSpaceSize)
  }
  -- data.Wheel = row.Wheel
  data.WheelSpacer = {
    Space = row.WheelSpacer.Space
  }
  data.BrakePad = VehicleBrakePadToTable(row.BrakePad)
  data.AngleKit = {
    AngleIncreaseInDegree = row.AngleKit.AngleIncreaseInDegree
  }
  data.BrakePower = {
    BrakePowerMultiplier = row.BrakePower.BrakePowerMultiplier
  }
  data.Winch = {
    MaxForceKg = row.Winch.MaxForceKg,
    MaxLength = row.Winch.MaxLength
  }
  data.Taxi = {
    TaxiType = row.Taxi.TaxiType
  }
  data.ItemInventory = {
    NumSlots = row.ItemInventory.NumSlots
  }
  data.FuelTank = {
    row.FuelTank.FuelLiter
  }

  return data
end

---Convert AMTWinch to JSON serializable table
---@param winch UMTWinchComponent
local function WinchToTable(winch)
  if not winch:IsValid() then return {} end

  local data = {}

  -- data.InteractableComponent = winch.InteractableComponent
  -- data.CableComponent = winch.CableComponent
  -- data.MotorSoundComponent = winch.MotorSoundComponent
  -- data.AxleMeshComponent = winch.AxleMeshComponent
  -- data.HookMeshComponent = winch.HookMeshComponent
  -- data.RopeCrackingSoundComponent = winch.RopeCrackingSoundComponent
  data.Net_WinchPartKey = winch.Net_WinchPartKey:ToString()
  data.Net_WinchPartSlot = winch.Net_WinchPartSlot
  data.PartRow = VehiclePartRowToTable(winch.PartRow)
  -- data.Net_HookActor = winch.Net_HookActor
  -- data.Net_ControllerActor = winch.Net_ControllerActor
  data.Net_bAttached = winch.Net_bAttached
  -- data.Net_AttachedActor = winch.Net_AttachedActor
  -- data.Net_AttachedComponent = winch.Net_AttachedComponent
  data.Net_AttachedLocation = VectorToTable(winch.Net_AttachedLocation)
  data.Net_AttachTransformSpace = winch.Net_AttachTransformSpace
  data.Net_Length = winch.Net_Length
  data.Net_WinchControl = winch.Net_WinchControl
  data.Net_bNotEnoughForce = winch.Net_bNotEnoughForce

  return data
end

---Converts UMTTowRequestComponent to JSON serializable table
---@param tow UMTTowRequestComponent
local function TowRequestCompToTable(tow)
  local data = {}

  if not tow:IsValid() then return {} end

  -- data.DestinationActor = tow.DestinationActor
  -- data.Marker = tow.Marker
  data.Net_StartLocation = VectorToTable(tow.Net_StartLocation)
  data.Net_DestinationAbsoluteLocation = VectorToTable(tow.Net_DestinationAbsoluteLocation)
  data.Net_Payment = tow.Net_Payment
  data.Net_bArrived = tow.Net_bArrived
  data.Net_TowRequestFlags = tow.Net_TowRequestFlags
  data.Net_LastWreckerPC = GetPlayerUniqueId(tow.Net_LastWreckerPC)
  data.Net_PoliceTowingVehicleDriverCharacterGuid = GuidToString(tow.Net_PoliceTowingVehicleDriverCharacterGuid)
  data.LastWrecker = tow.LastWrecker:IsValid() and tow.LastWrecker.Net_VehicleId or json.null

  return data
end

---Converts FMHTransmissionGear to JSON serializable table
---@param gear FMHTransmissionGear
local function TransGearToTable(gear)
  return {
    GearRatio = gear.GearRatio,
    Inertia = gear.Inertia,
    Name = gear.Name:ToString(),
  }
end

---Converts FMHTransmissionProperty to JSON serializable table
---@param trans FMHTransmissionProperty
local function TransPropertyToTable(trans)
  local data = {}

  data.Type = trans.Type
  data.ClutchType = trans.ClutchType

  data.Gears = {}
  trans.Gears:ForEach(function(index, element)
    table.insert(data.Gears, TransGearToTable(element:get()))
  end)

  data.DefaultGearIndex = trans.DefaultGearIndex
  data.ShiftTimeSeconds = trans.ShiftTimeSeconds
  data.AutoShiftComportRPM = trans.AutoShiftComportRPM
  data.TorqueConvertorStallRPM = trans.TorqueConvertorStallRPM
  data.TorqueConvertorStallRatioPower = trans.TorqueConvertorStallRatioPower
  data.TorqueConvertorTorqueRate = trans.TorqueConvertorTorqueRate
  data.CVT_InputRPMRange = Vector2DToTable(trans.CVT_InputRPMRange)
  data.CVT_ClutchRPMRange = Vector2DToTable(trans.CVT_ClutchRPMRange)
  data.CVT_ClutchCurvePow = trans.CVT_ClutchCurvePow
  data.CVT_GearRatios = Vector2DToTable(trans.CVT_GearRatios)
  -- data.GearGrindingSound = trans.GearGrindingSound

  return data
end

---Converts UMTDriveShaftComponent to JSON serializable table
---@param drive UMTDriveShaftComponent
local function DriveShaftToTable(drive)
  if not drive:IsValid() then return {} end

  return {
    TransmissionComponentName = drive.TransmissionComponentName:ToString(),
    Inertia = drive.Inertia,
    TransmissionComponent = drive.TransmissionComponent:IsValid() and {
      CurrentGear = drive.TransmissionComponent.CurrentGear,
      TransmissionProperty = TransPropertyToTable(drive.TransmissionComponent.TransmissionProperty)
    } or json.null
  }
end

---Converts FMTConstraintCollisionLock to JSON serializable table
---@param constraint FMTConstraintCollisionLock
local function ConstraintCollisionToTable(constraint)
  local data = {}

  data.CollisionComponentNames = {} ---@type string[]
  constraint.CollisionComponentNames:ForEach(function(index, element)
    table.insert(data, element:get():ToString())
  end)

  data.UnlockDirection = constraint.UnlockDirection

  return data
end

---Converts FMTConstraintRangeConfig to JSON serializable table
---@param constraint FMTConstraintRangeConfig
local function ConstraintRangeToTable(constraint)
  return {
    LinearLimitRange = Vector2DToTable(constraint.LinearLimitRange),
    TwistLimitDegrees = Vector2DToTable(constraint.TwistLimitDegrees),
    bAngularRotationOffset = constraint.bAngularRotationOffset,
    AngularRotationOffsetStart = RotatorToTable(constraint.AngularRotationOffsetStart),
    AngularRotationOffsetEnd = RotatorToTable(constraint.AngularRotationOffsetEnd),
  }
end

---Converts UMTConstraintComponent to JSON serializable table
---@param constraint UMTConstraintComponent
local function ConstraintToTable(constraint)
  if not constraint:IsValid() then return {} end

  local data = {}

  data.bDisableSimulationOnTerm1 = constraint.bDisableSimulationOnTerm1
  data.bDisableSimulationOnTerm2 = constraint.bDisableSimulationOnTerm2
  data.bOverridePos1 = constraint.bOverridePos1
  data.OverridePos1 = VectorToTable(constraint.OverridePos1)
  data.bOverridePos2 = constraint.bOverridePos2
  data.OverridePos2 = VectorToTable(constraint.OverridePos2)
  data.bHydraulic = constraint.bHydraulic
  data.bPTOHydraulic = constraint.bPTOHydraulic
  data.bLinearHydraulic = constraint.bLinearHydraulic
  data.bAngularHydraulic = constraint.bAngularHydraulic
  data.LinearSpeed = constraint.LinearSpeed
  data.LinearPositionStrength = constraint.LinearPositionStrength
  data.LinearVelocityStrength = constraint.LinearVelocityStrength
  data.LinearMaxForce = constraint.LinearMaxForce
  data.bLimitLinearRange = constraint.bLimitLinearRange
  data.LimitLinearRange = Vector2DToTable(constraint.LimitLinearRange)
  data.AngularSpeed = constraint.AngularSpeed
  data.AngularPositionStrength = constraint.AngularPositionStrength
  data.AngularVelocityStrength = constraint.AngularVelocityStrength
  data.AngularMaxForce = constraint.AngularMaxForce

  data.CollisionLocks = {}
  constraint.CollisionLocks:ForEach(function(index, element)
    table.insert(data.CollisionLocks, ConstraintCollisionToTable(element:get()))
  end)

  data.RangeConfigs = {}
  constraint.RangeConfigs:ForEach(function(index, element)
    table.insert(data.RangeConfigs, ConstraintRangeToTable(element:get()))
  end)

  -- data.HydraulicSound = constraint.HydraulicSound
  data.DisableCollisionComponentNames = {}
  constraint.DisableCollisionComponentNames:ForEach(function(index, element)
    table.insert(data.DisableCollisionComponentNames, element:get():ToString())
  end)

  -- data.DisableCollisionComponents = constraint.DisableCollisionComponents
  -- data.Net_BodyLocalMovements = constraint.Net_BodyLocalMovements
  -- data.HydraulicAudioComponent = constraint.HydraulicAudioComponent
  data.Net_HydraulicControl = constraint.Net_HydraulicControl
  data.Net_TargetPosition = constraint.Net_TargetPosition

  return data
end

---Converts UMTStrapComponent to JSON serializable table
---@param strap UMTStrapComponent
local function StrapCompToTable(strap)
  if not strap:IsValid() then return {} end

  local data = {}

  data.Net_Cargo = strap.Net_Cargo.Net_CargoKey:ToString()
  -- data.Net_Wheel = strap.Net_Wheel -- cyclic dependency
  -- data.Net_TargetComponent = strap.Net_TargetComponent
  -- data.Net_TowingComponent = strap.Net_TowingComponent
  data.Net_TowedVehicle = strap.Net_TowedVehicle.Net_VehicleId
  data.Net_Transform = TransformToTable(strap.Net_Transform)
  data.Constraint = ConstraintToTable(strap.Constraint)
  -- data.RopeMeshComponents = strap.RopeMeshComponents
  -- data.BuckleComponents = strap.BuckleComponents

  return data
end

---Converts UMTDifferentialComponent to JSON serializable table
---@param diff UMTDifferentialComponent
local function DiffToTable(diff)
  if not diff:IsValid() then return {} end

  return {
    LSDSlotName = diff.LSDSlotName:ToString(),
    LSDSlotIndex = diff.LSDSlotIndex,
    TransmissionComponentName = diff.TransmissionComponentName:ToString(),
    DifferentialComponentName = diff.DifferentialComponentName:ToString(),
    LinkGearRatio = diff.LinkGearRatio,
    Inertia = diff.Inertia,
    bAllowLockableLSD = diff.bAllowLockableLSD,
    -- TransmissionComponent = diff.TransmissionComponent,
    -- DifferentialComponent = diff.DifferentialComponent,
    DataAsset = diff.DataAsset:IsValid() and {
      LSDType = diff.DataAsset.LSDType,
      ClutchPackAccel = diff.DataAsset.ClutchPackAccel,
      ClutchPackBrake = diff.DataAsset.ClutchPackBrake,
    } or json.null
  }
end

---Converts UMHWheelComponent to JSON serializable table
---@param wheel UMHWheelComponent
local function WheelCompToTable(wheel)
  if not wheel:IsValid() then return {} end

  local data = {}

  data.WheelSlotIndex = wheel.WheelSlotIndex

  data.WheelFlags = {} ---@type number[]
  wheel.WheelFlags:ForEach(function(index, element)
    table.insert(data.WheelFlags, element:get())
  end)

  data.DriveShaftComponentName = wheel.DriveShaftComponentName:ToString()
  data.DifferentialComponentName = wheel.DifferentialComponentName:ToString()
  data.LinkGearRatio = wheel.LinkGearRatio
  data.TirePhysicsData = wheel.TirePhysicsData:IsValid() and {
    TirePhysicsParams = TirePhysicsToTable(wheel.TirePhysicsData.TirePhysicsParams)
  } or json.null
  data.BrushTirePhysics = {
    ContactPatchLength = wheel.BrushTirePhysics.ContactPatchLength,
    ContactPatchStaticLength = wheel.BrushTirePhysics.ContactPatchStaticLength
  }
  data.Inertia = wheel.Inertia
  data.SpringStroke = wheel.SpringStroke
  data.SpringLength = wheel.SpringLength
  data.SpringK = wheel.SpringK
  data.SpringBoundDamping = wheel.SpringBoundDamping
  data.SpringReboundDamping = wheel.SpringReboundDamping
  data.bSteer = wheel.bSteer
  data.bReverseSteer = wheel.bReverseSteer
  data.bSteerBy5thWheel = wheel.bSteerBy5thWheel
  data.bTagAxleSteer = wheel.bTagAxleSteer
  data.SteerBy5thWheelPivotX = wheel.SteerBy5thWheelPivotX
  data.TagAxleSteerPivotX = wheel.TagAxleSteerPivotX
  data.MaxSteeringAngleDegree = wheel.MaxSteeringAngleDegree
  data.MaxSteeringAngleDegreePerSeconds = wheel.MaxSteeringAngleDegreePerSeconds
  data.DisableSteeringSpeedKPH = wheel.DisableSteeringSpeedKPH
  data.CasterDegree = wheel.CasterDegree
  data.KingpinOffset = wheel.KingpinOffset
  data.KingpinAngle = wheel.KingpinAngle
  data.HandleBarOffset = wheel.HandleBarOffset
  data.BrakeRatio = wheel.BrakeRatio
  data.bHandBrake = wheel.bHandBrake
  data.TreadWidthOverride = wheel.TreadWidthOverride
  data.UnsprungMassMassFromBodyMultiplier = wheel.UnsprungMassMassFromBodyMultiplier
  data.DriveShaftComponent = DriveShaftToTable(wheel.DriveShaftComponent)
  data.DifferentialComponent = DiffToTable(wheel.DifferentialComponent)
  -- data.SkidSoundComponent = wheel.SkidSoundComponent
  -- data.RoadNoiseSoundComponent = wheel.RoadNoiseSoundComponent
  -- data.SurfaceSoundComponent = wheel.SurfaceSoundComponent
  -- data.SurfaceEnvSoundComponent = wheel.SurfaceEnvSoundComponent
  -- data.BrakeSoundComponent = wheel.BrakeSoundComponent
  -- data.SurfaceLoopNC = wheel.SurfaceLoopNC
  -- data.SurfaceLoopNS = wheel.SurfaceLoopNS
  -- data.BrakeSmokeEffect = wheel.BrakeSmokeEffect
  -- data.InteractableComponent = wheel.InteractableComponent
  data.Strap = StrapCompToTable(wheel.Strap)
  -- data.ContactSurfaceSound = wheel.ContactSurfaceSound
  -- data.SurfaceEnvSound = wheel.SurfaceEnvSound

  return data
end

---Converts UMTTowingComponent to JSON serializable table
---@param tow UMTTowingComponent
local function TowCompToTable(tow)
  if not tow:IsValid() then return {} end

  local data = {}

  data.HookType = tow.HookType
  -- data.HookSound = tow.HookSound
  -- data.UnhookSound = tow.UnhookSound
  -- data.InteractableComponent = tow.InteractableComponent
  data.Strap = StrapCompToTable(tow.Strap)
  -- data.DisableCollisionComponents = tow.DisableCollisionComponents

  return data
end

---Converts UMTVehicleAttachmentPartComponent to JSON serializable table
---@param comp UMTVehicleAttachmentPartComponent
local function VehicleAttachmentPartCompToTable(comp)
  if not comp:IsValid() then return {} end

  return {
    Net_PartKey = comp.Net_PartKey:ToString(),
    Net_PartSlot = comp.Net_PartSlot
  }
end

---Convert UMTVehicleCargoSpaceComponent to JSON serializable table
---@param cargoSpace UMTVehicleCargoSpaceComponent
local function VehicleCargoSpaceCompToTable(cargoSpace)
  if not cargoSpace:IsValid() then return {} end

  local data = {}

  data.CargoSpaceType = cargoSpace.CargoSpaceType
  data.bFixCargo = cargoSpace.bFixCargo
  data.bUnlimitedHeight = cargoSpace.bUnlimitedHeight
  data.DumpVolume = cargoSpace.DumpVolume
  data.DumpCargoSurfaceSlopeYAngleDegree = cargoSpace.DumpCargoSurfaceSlopeYAngleDegree
  data.bAllowPutdownCargoByInteraction = cargoSpace.bAllowPutdownCargoByInteraction
  -- data.InteractableComponent = cargo.InteractableComponent
  -- data.DumpMeshComponent = cargo.DumpMeshComponent
  -- data.DummyCargoInteractable = cargo.DummyCargoInteractable

  data.Net_Cargos = {}
  cargoSpace.Net_Cargos:ForEach(function(index, element)
    table.insert(data.Net_Cargos, cargo.CargoToTable(element:get()))
  end)

  data.Net_DroppedCargos = {}
  cargoSpace.Net_DroppedCargos:ForEach(function(index, element)
    table.insert(data.Net_DroppedCargos, cargo.CargoToTable(element:get()))
  end)

  data.Net_BoxExtent = VectorToTable(cargoSpace.Net_BoxExtent)
  data.Net_LoadedItemType = cargoSpace.Net_LoadedItemType
  data.Net_LoadedItemVolume = cargoSpace.Net_LoadedItemVolume
  data.Net_CargoSpaceRuntimeFlags = cargoSpace.Net_CargoSpaceRuntimeFlags

  data.DroppedCargoCandidates = {}
  cargoSpace.DroppedCargoCandidates:ForEach(function(key, value)
    data.DroppedCargoCandidates[key:get().Net_CargoKey:ToString()] = value:get()
  end)

  data.Net_CarryingVehicles = {}
  cargoSpace.Net_CarryingVehicles:ForEach(function(index, element)
    table.insert(data.Net_CarryingVehicles, element:get().Net_VehicleId)
  end)

  data.OverlappedVehicles = {}
  cargoSpace.OverlappedVehicles:ForEach(function(index, element)
    table.insert(data.OverlappedVehicles, element:get().Net_VehicleId)
  end)

  return data
end

---Converts FMTVehicleCargoPartAndSlot to JSON serializable table
---@param cargo FMTVehicleCargoPartAndSlot
local function VehicleCargoPartToTable(cargo)
  return {
    CargoSpace = VehicleCargoSpaceCompToTable(cargo.CargoSpace),
    Slot = cargo.Slot
  }
end

---Converts UMTPoliceVehicleComponent to JSON serializable table
---@param police UMTPoliceVehicleComponent
local function PoliceVehicleCompToTable(police)
  if not police:IsValid() then return {} end

  local data = {}

  data.Server_PendingTicketSuspects = {}
  police.Server_PendingTicketSuspects:ForEach(function(index, element)
    table.insert(
      data.Server_PendingTicketSuspects,
      GuidToString(element:get().Net_MTPlayerState.CharacterGuid)
    )
  end)

  return data
end

---Converts FMotorTownAIDriverSetting to JSON serializable table
---@param ai FMotorTownAIDriverSetting
local function AIDriverSettingToTable(ai)
  return {
    BrakingG = ai.BrakingG,
    LateralG = ai.LateralG,
    RaceBrakingG = ai.RaceBrakingG,
    RaceLateralG = ai.RaceLateralG
  }
end

---Converts FMTAntiRollBarParams to JSON serializable table
---@param rollbar FMTAntiRollBarParams
local function AntiRollbarToTable(rollbar)
  return {
    Wheel0Name = rollbar.Wheel0Name:ToString(),
    Wheel1Name = rollbar.Wheel1Name:ToString(),
    SpringK = rollbar.SpringK,
    SpringD = rollbar.SpringD,
  }
end

---Converts FMTVehicleSuspensionParams to JSON serializable table
---@param sus FMTVehicleSuspensionParams
local function VehicleSuspensionParamToTable(sus)
  return {
    WheelSlotIndex = sus.WheelSlotIndex,
    ComponentName = sus.ComponentName:ToString(),
    SuspensionType = sus.SuspensionType,
    WheelHubBoneName = sus.WheelHubBoneName:ToString(),
    TrailArmBoneName = sus.TrailArmBoneName:ToString(),
    TrailArmAxleSocketName = sus.TrailArmAxleSocketName:ToString(),
  }
end

---Converts FMTVehiclePistonParams to JSON serializable table
---@param piston FMTVehiclePistonParams
local function VehiclePistonParamToTable(piston)
  return {
    ComponentName = piston.ComponentName:ToString(),
    BaseComponentName = piston.BaseComponentName:ToString(),
    TargetComponentName = piston.TargetComponentName:ToString(),
    BaseSocketName = piston.BaseSocketName:ToString(),
    TargetSocketName = piston.TargetSocketName:ToString(),
  }
end

---Convert FMTVehicleDiffLockingState to JSON serializable table
---@param diff FMTVehicleDiffLockingState
local function VehicleDiffLockingStateToTable(diff)
  local data = {}

  data.Name = diff.Name:ToString()

  data.Differentials = {}
  diff.Differentials:ForEach(function(key, value)
    data.Differentials[key:get():ToString()] = value:get()
  end)

  data.GearRatio = diff.GearRatio
  data.bDisableBrakeTCS = diff.bDisableBrakeTCS

  return data
end

---Convert FMTVehicleLiftAxle to JSON serializable table
---@param axle FMTVehicleLiftAxle
local function VehicleLiftAxleToTable(axle)
  local data = {}

  data.Name = axle.Name:ToString()
  data.WheelIndexToHeight = {}
  axle.WheelIndexToHeight:ForEach(function(key, value)
    data.WheelIndexToHeight[key:get()] = value:get()
  end)

  return data
end

---Convert FMTVehicleWheelAxle to JSON serializable table
---@param axle FMTVehicleWheelAxle
local function VehicleWheelAxleToTable(axle)
  local data = {}

  data.AxleIndex = axle.AxleIndex
  data.WheelIndices = {} ---@type number[]
  axle.WheelIndices:ForEach(function(index, element)
    table.insert(data.WheelIndices, element:get())
  end)
  data.LocationX = axle.LocationX

  return data
end

---Convert FMTNetWheelHotState to JSON serializable table
---@param state FMTNetWheelHotState
local function NetWheelHotStateToTable(state)
  return {
    BrakeTemperature = state.BrakeTemperature,
    BrakeCoreTemperature = state.BrakeCoreTemperature,
    TireCoreTemperature = state.TireCoreTemperature,
    TireBrushTemperature = state.TireBrushTemperature,
  }
end

---Convert FMTVehicleColdState to JSON serializable table
---@param state FMTVehicleColdState
local function VehicleColdStateToTable(state)
  local data = {}

  data.DriveMode = state.DriveMode

  data.ToggleFunctions = {} ---@type boolean[]
  state.ToggleFunctions:ForEach(function(index, element)
    table.insert(data.ToggleFunctions, element:get())
  end)

  data.TurnSignal = state.TurnSignal
  data.HeadLightMode = state.HeadLightMode
  data.SirenIndex = state.SirenIndex
  data.bIsAIDriving = state.bIsAIDriving
  data.bStoppedInParkingSpace = state.bStoppedInParkingSpace
  data.bHorn = state.bHorn
  data.bAcceptTaxiPassenger = state.bAcceptTaxiPassenger

  data.RemovedWheels = {} ---@type number[]
  state.RemovedWheels:ForEach(function(index, element)
    table.insert(data.RemovedWheels, element:get())
  end)

  data.DiffLockIndex = state.DiffLockIndex

  data.LiftedAxleIndices = {} ---@type number[]
  state.LiftedAxleIndices:ForEach(function(index, element)
    table.insert(data.LiftedAxleIndices, element:get())
  end)

  data.LastLocationsInRoad = {}
  state.LastLocationsInRoad:ForEach(function(index, element)
    table.insert(data.LastLocationsInRoad, {
      Location = VectorToTable(element:get().Location),
      Rotation = RotatorToTable(element:get().Rotation),
    })
  end)

  return data
end

---Convert FMTVehicleState to JSON serializable table
---@param state FMTVehicleState
local function VehicleStateToTable(state)
  local data = {}

  data.Fuel = state.Fuel
  data.Condition = state.Condition
  data.OdoMeterKm = state.OdoMeterKm
  data.Wheels = {} ---@type table[]
  state.Wheels:ForEach(function(index, element)
    table.insert(data.Wheels, NetWheelHotStateToTable(element:get()))
  end)
  data.LiftAxleProgresses = {} ---@type number[]
  state.LiftAxleProgresses:ForEach(function(index, element)
    table.insert(data.LiftAxleProgresses, element:get())
  end)

  return data
end

---Convert FMTVehicleOwnerSetting to JSON serializable table
---@param setting FMTVehicleOwnerSetting
local function VehicleOwnerSettingToTable(setting)
  local data = {}

  data.bLocked = setting.bLocked
  data.DriveAllowedPlayers = setting.DriveAllowedPlayers

  if setting.LevelRequirementsToDrive:IsValid() then
    data.LevelRequirementsToDrive = {} ---@type number[]
    setting.LevelRequirementsToDrive:ForEach(function(index, element)
      table.insert(data.LevelRequirementsToDrive, element:get())
    end)
  end

  data.VehicleOwnerProfitShare = setting.VehicleOwnerProfitShare

  return data
end

---Convert FMTNetEngineHotState to JSON serializable table
---@param engine FMTNetEngineHotState
local function NetEngineHotStateToTable(engine)
  return {
    bStarterOn = engine.bStarterOn,
    bIgnitionOn = engine.bIgnitionOn,
    CurrentRPM = engine.CurrentRPM,
    CoolantTemp = engine.CoolantTemp,
    RegenBrake = engine.RegenBrake,
    JakeBrake = engine.JakeBrake,
  }
end

---Convert FMTVehicleCustomization to JSON serializable table
---@param custom FMTVehicleCustomization
local function VehicleCustomizationToTable(custom)
  local data = {}

  data.BodyMaterialIndex = custom.BodyMaterialIndex

  data.BodyColors = {}
  if custom.BodyColors:IsValid() then
    custom.BodyColors:ForEach(function(index, element)
      local bodyColor = element:get()
      if bodyColor:IsValid() then
        table.insert(data.BodyColors, {
          MaterialSlotName = element:get().MaterialSlotName:ToString(),
          Color = ColorToTable(element:get().Color),
        })
      end
    end)
  end

  return data
end

local function TableToVehicleCustomization(t, custom)
  custom.BodyColors:Empty()
  for index, value in ipairs(t.BodyColors) do
    custom.BodyColors[index] = {
      MaterialSlotName = FName(value.MaterialSlotName),
      Color = value.Color,
      Metallic = value.Metallic,
      Roughness = value.Roughness,
    }
  end
  return {
    BodyMaterialIndex = t.BodyMaterialIndex,
    BodyColors = custom.BodyColors,
  }
end

---Convert FMTVehicleDecalLayer to JSON serializable table
---@param decal FMTVehicleDecalLayer
local function VehicleDecalLayerToTable(decal)
  return {
    DecalKey = decal.DecalKey:ToString(),
    Color = ColorToTable(decal.Color),
    Position = Vector2DToTable(decal.Position),
    Rotation = RotatorToTable(decal.Rotation),
    DecalScale = decal.DecalScale,
    Stretch = decal.Stretch,
    Coverage = decal.Coverage,
    Flags = decal.Flags,
  }
end

local function TableToVehicleDecalLayer(decal)
  return {
    DecalKey = FName(decal.DecalKey),
    Color = decal.Color,
    Position = decal.Position,
    Rotation = decal.Rotation,
    DecalScale = decal.DecalScale,
    Stretch = decal.Stretch,
    Coverage = decal.Coverage,
    Flags = decal.Flags,
  }
end

---Convert FMTVehicleDecal to JSON serializable table
---@param decal FMTVehicleDecal
local function VehicleDecalToTable(decal)
  local data = {}

  if decal.DecalLayers:IsValid() then
    decal.DecalLayers:ForEach(function(index, element)
      local layer = element:get()
      if layer:IsValid() then
        table.insert(data, VehicleDecalLayerToTable(layer))
      end
    end)
  end

  return {
    DecalLayers = data,
  }
end

local function TableToVehicleDecal(decal)
  local decalLayers = {}

  for index, value in ipairs(decal.DecalLayers) do
    table.insert(decalLayers, TableToVehicleDecalLayer(value))
  end

  return {
    DecalLayers = decalLayers,
  }
end

---Convert FMTVehiclePart to JSON serializable table
---@param part FMTVehiclePart
local function VehiclePartToTable(part)
  if not part:IsValid() or not IsUObjectSafe(part) then
    return {}
  end
  local data = {}

  data.ID = part.ID
  data.Key = part.Key:ToString()
  data.Slot = part.Slot
  data.Damage = part.Damage

  data.FloatValues = {} ---@type number[]
  if part.FloatValues:IsValid() then
    part.FloatValues:ForEach(function(index, element)
      table.insert(data.FloatValues, element:get())
    end)
  end

  data.Int64Values = {} ---@type number[]
  if part.Int64Values:IsValid() then
    part.Int64Values:ForEach(function(index, element)
      table.insert(data.Int64Values, element:get())
    end)
  end

  data.StringValues = {} ---@type string[]
  if part.StringValues:IsValid() then
    part.StringValues:ForEach(function(index, element)
      table.insert(data.StringValues, element:get():ToString())
    end)
  end

  data.VectorValues = {} ---@type table[]
  if part.VectorValues:IsValid() then
    part.VectorValues:ForEach(function(index, element)
      table.insert(data.VectorValues, VectorToTable(element:get()))
    end)
  end

  ---@diagnostic disable-next-line: undefined-field
  if part.ItemInventory:IsValid() then
    data.ItemInventory = ItemInventoryToTable(part.ItemInventory)
  end

  return data
end

local function TableToVehiclePart(part)
  local data = part

  if part.partKey ~= nil then
    data.Key = FName(part.partKey)
  else
    data.Key = FName(part.Key)
  end
  data.ItemInventory = TableToItemInventory(part.ItemInventory)

  return data
end

---Convert FMTVehicleAINetState to JSON serializable table
---@param state FMTVehicleAINetState
local function VehicleAINetStateToTable(state)
  local data = {}

  data.CrossroadId = state.CrossroadId
  data.LastCrossRoadId = state.LastCrossRoadId
  data.CrossroadEnterTimeSeconds = state.CrossroadEnterTimeSeconds

  data.CrossRoadNodeIndices = {} ---@type number[]
  state.CrossRoadNodeIndices:ForEach(function(index, element)
    table.insert(data.CrossRoadNodeIndices, element:get())
  end)

  return data
end

---Convert AMotorTownRoad to JSON serializable table
---@param road AMotorTownRoad
local function MotorTownRoadToTable(road)
  if not road:IsValid() then return {} end

  local data = {}

  data.RoadType = road.RoadType
  data.CourseKey = road.CourseKey:ToString()
  data.LaneWidth = road.LaneWidth
  data.NumForwardLanes = road.NumForwardLanes
  data.NumBackwardLanes = road.NumBackwardLanes
  data.bCopyFromLandscape = road.bCopyFromLandscape
  data.CopyFromLandscapeWidthMultiplier = road.CopyFromLandscapeWidthMultiplier
  data.RoadFlags = road.RoadFlags
  data.SpeedLimitKPH = road.SpeedLimitKPH

  data.ExcludeConnectionRoads = {} ---@type string[]
  road.ExcludeConnectionRoads:ForEach(function(index, element)
    table.insert(data.ExcludeConnectionRoads, element:get().CourseKey:ToString())
  end)

  data.MaxRoadSideTowDistance = road.MaxRoadSideTowDistance
  -- data.Spline = road.Spline
  -- data.SplineBounds = road.SplineBounds

  return data
end

---Convert FMTLaptimeModule to JSON serializable table
---@param time FMTLaptimeModule
local function LaptimeModuleToTable(time)
  local data = {}

  data.Courses = {}
  time.Courses:ForEach(function(key, value)
    data.Courses[key:get():ToString()] = {
      NumSections = value:get().NumSections
    }
  end)
  data.CourseRoad = MotorTownRoadToTable(time.CourseRoad)
  data.OverlappedRaceSection = time.OverlappedRaceSection:IsValid() and {
    CourseName = time.OverlappedRaceSection.CourseName:ToString(),
    RaceSectionIndex = time.OverlappedRaceSection.RaceSectionIndex,
    bIsStopBox = time.OverlappedRaceSection.bIsStopBox
  } or json.null

  return data
end

---Convert FMTVehicleHookParams to JSON serializable table
---@param param FMTVehicleHookParams
local function VehicleHookParamToTable(param)
  return {
    HookType = param.HookType,
    HookSocketName = param.HookSocketName:ToString(),
    -- HookComponent = param.HookComponent,
    HookLocation = VectorToTable(param.HookLocation),
  }
end

---Convert vehicle mirror position to JSON serializable table
---@param mirror FMTVehicleMirrorPosition
local function VehicleMirrorPositionToTable(mirror)
  return {
    CurvatureMultiplier = mirror.CurvatureMultiplier,
    Name = mirror.Name:ToString(),
    Rotation = RotatorToTable(mirror.Rotation)
  }
end

---Convert vehicle setting to JSON serializable table
---@param setting FMTVehicleSetting
local function VehicleSettingToTable(setting)
  return {
    SettingType = setting.SettingType,
    Value = SettingValueToTable(setting.Value)
  }
end

---Determines the drive type (2WD/4WD/AWD/6WD) of a vehicle
---by analyzing its drivetrain topology.
---
---Static detection: checks which wheels have valid DriveShaftComponent
---connections back to the transmission. Groups driven wheels by axle.
---
---Runtime detection: reads DiffLockings[DiffLockIndex] to determine
---which differentials are currently Disconnected vs Open/Locked.
---
---@param vehicle AMTVehicle
---@return table drive_info with fields:
---  drive_type: string ("2WD"|"4WD"|"6WD"|"RWD"|"FWD"|"AWD")
---  driven_wheel_count: number of wheels with valid drive shaft
---  total_wheel_count: total number of wheels
---  driven_axle_indices: list of axle indices that have driven wheels
---  total_axle_count: total number of axles
---  num_differentials: number of differential components
---  current_diff_lock_index: current DiffLockIndex from cold state
---  current_disconnected_diffs: list of differential names currently disconnected
local function GetDriveInfo(vehicle)
  local info = {}

  -- Count differentials
  local numDiffs = 0
  vehicle.Differentials:ForEach(function(index, element)
    numDiffs = numDiffs + 1
  end)
  info.num_differentials = numDiffs

  -- Find which wheels are driven (have valid drive shaft connection)
  local drivenWheelIndices = {} ---@type number[]
  local totalWheels = 0
  vehicle.Wheels:ForEach(function(index, element)
    totalWheels = totalWheels + 1
    local wheel = element:get()
    if wheel:IsValid() and wheel.DriveShaftComponent:IsValid() then
      table.insert(drivenWheelIndices, wheel.WheelSlotIndex)
    end
  end)
  info.driven_wheel_count = #drivenWheelIndices
  info.total_wheel_count = totalWheels

  -- Map driven wheels to axles
  local drivenAxleSet = {} ---@type table<number, boolean>
  local totalAxles = 0
  vehicle.WheelAxles:ForEach(function(axleIdx, axleElement)
    totalAxles = totalAxles + 1
    local axle = axleElement:get()
    axle.WheelIndices:ForEach(function(_, wheelIdxElement)
      local wheelIdx = wheelIdxElement:get()
      for _, drivenIdx in ipairs(drivenWheelIndices) do
        if wheelIdx == drivenIdx then
          drivenAxleSet[axle.AxleIndex] = true
          break
        end
      end
    end)
  end)

  local drivenAxleIndices = {}
  for axleIdx, _ in pairs(drivenAxleSet) do
    table.insert(drivenAxleIndices, axleIdx)
  end
  table.sort(drivenAxleIndices)
  info.driven_axle_indices = drivenAxleIndices
  info.total_axle_count = totalAxles

  -- Determine drive type string
  local drivenAxleCount = #drivenAxleIndices
  if drivenAxleCount == 0 then
    info.drive_type = "None"
  elseif totalAxles <= 2 then
    -- Standard car: 2 axles
    if drivenAxleCount >= 2 then
      info.drive_type = "AWD"
    elseif drivenAxleCount == 1 then
      -- Check if front or rear axle is driven
      -- Axle with higher LocationX is front, lower is rear
      -- But simpler: axle index 0 is typically front
      -- Use the driven axle index to guess F vs R
      local drivenAxle = drivenAxleIndices[1]
      -- If only 1 axle total, it's just "2WD"
      if totalAxles == 1 then
        info.drive_type = "2WD"
      elseif drivenAxle == 0 then
        info.drive_type = "FWD"
      else
        info.drive_type = "RWD"
      end
    end
  else
    -- Multi-axle (trucks): count driven axles
    if drivenAxleCount == totalAxles then
      info.drive_type = tostring(drivenAxleCount * 2) .. "WD"  -- "6WD", "8WD"
    elseif drivenAxleCount >= 2 then
      info.drive_type = tostring(totalAxles * 2) .. "x" .. tostring(drivenAxleCount * 2) -- "6x4"
    else
      info.drive_type = tostring(totalAxles * 2) .. "x" .. tostring(drivenAxleCount * 2) -- "4x2"
    end
  end

  -- Runtime diff lock state
  info.current_diff_lock_index = vehicle.NetLC_ColdState.DiffLockIndex
  info.current_disconnected_diffs = {}

  local diffLockCount = 0
  vehicle.DiffLockings:ForEach(function() diffLockCount = diffLockCount + 1 end)

  if diffLockCount > 0 and info.current_diff_lock_index >= 0 then
    local currentIdx = 0
    vehicle.DiffLockings:ForEach(function(index, element)
      if currentIdx == info.current_diff_lock_index then
        local diffState = element:get()
        diffState.Differentials:ForEach(function(key, value)
          local diffName = key:get():ToString()
          local lockState = value:get() -- 0=Disconnect, 1=Open, 2=Locked
          if lockState == 0 then
            table.insert(info.current_disconnected_diffs, diffName)
          end
        end)
      end
      currentIdx = currentIdx + 1
    end)
  end

  -- If AWD-capable but currently has disconnected diffs, note the effective mode
  if info.drive_type == "AWD" and #info.current_disconnected_diffs > 0 then
    info.effective_drive_type = "Part-time"
  else
    info.effective_drive_type = info.drive_type
  end

  return info
end

---Convert AMTVehicle to JSON serializable table
---@param vehicle AMTVehicle
local function VehicleToTable(vehicle)
  if not vehicle:IsValid() or not IsUObjectSafe(vehicle) then
    return {}
  end
  local data = {}

  -- data.DefaultVehicleFeatures = vehicle.DefaultVehicleFeatures
  data.ExControls = {}
  vehicle.ExControls:ForEach(function(index, element)
    table.insert(data.ExControls, element:get())
  end)

  -- data.BodyMaterials = vehicle.BodyMaterials
  -- data.BodyMaterialList = vehicle.BodyMaterialList
  data.BodyMaterialName = vehicle.BodyMaterialName:ToString()

  data.BodyMaterialNames = {} ---@type string[]
  vehicle.BodyMaterialNames:ForEach(function(index, element)
    table.insert(data.BodyMaterialNames, element:get():ToString())
  end)

  data.DecalableMaterialSlotNames = {} ---@type string[]
  vehicle.DecalableMaterialSlotNames:ForEach(function(index, element)
    table.insert(data.DecalableMaterialSlotNames, element:get():ToString())
  end)

  data.BodyColorMaterialSlotNames = {}
  vehicle.BodyColorMaterialSlotNames:ForEach(function(key, value)
    data.BodyColorMaterialSlotNames[key:get():ToString()] = value:get():ToString()
  end)

  data.ColorSlots = {}
  vehicle.ColorSlots:ForEach(function(key, value)
    data.ColorSlots[key:get():ToString()] = ColorSlotToTable(value:get())
  end)

  data.BodyColors = {}
  vehicle.BodyColors:ForEach(function(index, element)
    table.insert(data.BodyColors, VehicleColorToTable(element:get()))
  end)
  -- data.BusComponentClass = vehicle.BusComponentClass
  -- data.RootBody = vehicle.RootBody
  -- data.Mesh = vehicle.Mesh
  -- data.SteeringWheel = vehicle.SteeringWheel
  data.Wheels = {}
  vehicle.Wheels:ForEach(function(index, element)
    table.insert(data.Wheels, WheelCompToTable(element:get()))
  end)
  -- data.EngineComponent = vehicle.EngineComponent
  -- data.CargoSpaceInteractableComponent = vehicle.CargoSpaceInteractableComponent
  -- data.DrivingInput = vehicle.DrivingInput
  -- data.HornAudioComponent = vehicle.HornAudioComponent
  -- data.SirenAudioComponent = vehicle.SirenAudioComponent
  -- data.BackupBeepAudioComponent = vehicle.BackupBeepAudioComponent
  -- data.RefuelAudioComponent = vehicle.RefuelAudioComponent
  -- data.AirHydraulicAudioComponent = vehicle.AirHydraulicAudioComponent
  -- data.WindNoiseAudioComponent = vehicle.WindNoiseAudioComponent
  -- data.AirHydraulicSound = vehicle.AirHydraulicSound
  -- data.DriverSeatInteractionSphereComponent = vehicle.DriverSeatInteractionSphereComponent
  -- data.DriverSeatInteractableComponent = vehicle.DriverSeatInteractableComponent
  -- data.PassengerSeatInteractionSphereComponent = vehicle.PassengerSeatInteractionSphereComponent
  -- data.PassengerSeatInteractableComponent = vehicle.PassengerSeatInteractableComponent
  -- data.NavModifierComponent = vehicle.NavModifierComponent
  -- data.Dashboard = vehicle.Dashboard
  -- data.CameraSpringArm = vehicle.CameraSpringArm
  -- data.TrailCamera = vehicle.TrailCamera
  -- data.CockpitCamera = vehicle.CockpitCamera
  -- data.LOD1DisableTickComponents = vehicle.LOD1DisableTickComponents
  -- data.LOD2DisableTickComponents = vehicle.LOD2DisableTickComponents
  -- data.LOD2UnregisterComponents = vehicle.LOD2UnregisterComponents
  -- data.LOD3UnregisterComponents = vehicle.LOD3UnregisterComponents
  -- data.LOD4UnregisterComponents = vehicle.LOD4UnregisterComponents
  -- data.TransmissionComponent = vehicle.TransmissionComponent
  data.Differentials = {}
  vehicle.Differentials:ForEach(function(index, element)
    table.insert(data.Differentials, DiffToTable(element:get()))
  end)
  -- data.Seats = vehicle.Seats
  -- data.MirrorComponents = vehicle.MirrorComponents
  -- data.Doors = vehicle.Doors
  -- data.CargoSpaces = vehicle.CargoSpaces
  -- data.TaxiComponent = vehicle.TaxiComponent
  -- data.Net_BusComponent = vehicle.Net_BusComponent
  -- data.TruckComponent = vehicle.TruckComponent
  -- data.WreckerComponent = vehicle.WreckerComponent
  -- data.TrailerComponent = vehicle.TrailerComponent
  -- data.Headlights = vehicle.Headlights
  -- data.TailLights = vehicle.TailLights
  -- data.ReverseLights = vehicle.ReverseLights
  -- data.BlinkerLights = vehicle.BlinkerLights
  -- data.EmegencyLights = vehicle.EmegencyLights
  -- data.Constraints = vehicle.Constraints
  -- data.ForkliftTiltConstraint = vehicle.ForkliftTiltConstraint
  -- data.ForkliftLiftConstraints = vehicle.ForkliftLiftConstraints
  -- data.ForkliftForkLeftConstraint = vehicle.ForkliftForkLeftConstraint
  -- data.ForkliftForkRightConstraint = vehicle.ForkliftForkRightConstraint

  data.Winches = {}
  vehicle.Winches:ForEach(function(index, element)
    table.insert(data.Winches, WinchToTable(element:get()))
  end)

  data.TowRequestComponent = TowRequestCompToTable(vehicle.TowRequestComponent)
  data.TowingComponent = TowCompToTable(vehicle.TowingComponent)
  -- data.PartSlots = vehicle.PartSlots
  -- data.InteriorLights = vehicle.InteriorLights
  -- data.TaxiRoofSign = vehicle.TaxiRoofSign
  data.RearSpoiler = vehicle.RearSpoiler:IsValid() and {
    Net_PartKey = vehicle.RearSpoiler.Net_PartKey:ToString(),
    Net_PartSlot = vehicle.RearSpoiler.Net_PartSlot
  } or json.null
  data.RearWing = vehicle.RearWing:IsValid() and {
    Net_PartKey = vehicle.RearWing.Net_PartKey:ToString(),
    Net_PartSlot = vehicle.RearWing.Net_PartSlot
  } or json.null
  -- data.AeroParts = vehicle.AeroParts
  data.AttachmentParts = {}
  vehicle.AttachmentParts:ForEach(function(key, value)
    data.AttachmentParts[key:get()] = VehicleAttachmentPartCompToTable(value:get())
  end)

  data.AttachmentPartsComponents = {}
  vehicle.AttachmentPartsComponents:ForEach(function(index, element)
    data.AttachmentPartsComponents[index] = VehicleAttachmentPartCompToTable(element:get())
  end)

  data.Net_RoofRackParts = {}
  vehicle.Net_RoofRackParts:ForEach(function(index, element)
    data.Net_RoofRackParts[index] = VehicleCargoPartToTable(element:get())
  end)

  data.Net_CargoBedParts = {}
  vehicle.Net_CargoBedParts:ForEach(function(index, element)
    data.Net_CargoBedParts[index] = VehicleCargoPartToTable(element:get())
  end)

  data.Server_Winches = {}
  vehicle.Server_Winches:ForEach(function(key, value)
    data.Server_Winches[key:get()] = WinchToTable(value:get())
  end)

  data.TrailerHitch = vehicle.TrailerHitch:IsValid() and {
    ConnectionType = vehicle.TrailerHitch.ConnectionType
  } or json.null
  data.PoliceComponent = PoliceVehicleCompToTable(vehicle.PoliceComponent)
  data.SellerComponent = vehicle.SellerComponent:IsValid() and vehicle.SellerComponent.Marker:IsValid() and {
    Marker = VectorToTable(vehicle.SellerComponent.Marker:K2_GetActorLocation())
  } or json.null
  -- data.CraneComponent = vehicle.CraneComponent
  -- data.GetawayComponent = vehicle.GetawayComponent
  -- data.DecalComponent = vehicle.DecalComponent
  -- data.TankerFuelPumpComponent = vehicle.TankerFuelPumpComponent
  data.GameplayTagContainer = GameplayTagContainerToString(vehicle.GameplayTagContainer)
  -- data.StaticMeshDefaultTransforms = vehicle.StaticMeshDefaultTransforms
  data.bForSale = vehicle.bForSale
  data.bDrivable = vehicle.bDrivable
  data.bHasSteeringWheel = vehicle.bHasSteeringWheel
  data.bHasDriverSeat = vehicle.bHasDriverSeat
  data.bHasPassengerSeat = vehicle.bHasPassengerSeat
  data.AIDriverSetting = AIDriverSettingToTable(vehicle.AIDriverSetting)
  data.bIsOpenAir = vehicle.bIsOpenAir
  data.DefaultDrivingMode = vehicle.DefaultDrivingMode
  data.MaxSteeringAngleDegree = vehicle.MaxSteeringAngleDegree
  data.ParallelSteering = vehicle.ParallelSteering
  data.OptimalSlipAngleDegree = vehicle.OptimalSlipAngleDegree
  data.SteeringOffsetX = vehicle.SteeringOffsetX
  data.MaxSteeringWheelAngleDegree = vehicle.MaxSteeringWheelAngleDegree
  data.BrakeTorqueMultiplier = vehicle.BrakeTorqueMultiplier
  data.BrakeTemperatureMass = vehicle.BrakeTemperatureMass
  data.KeyboardSteerSpeed = vehicle.KeyboardSteerSpeed
  data.KeyboardSteerReturnSpeed = vehicle.KeyboardSteerReturnSpeed

  data.AntiRollBars = {}
  vehicle.AntiRollBars:ForEach(function(index, element)
    table.insert(data.AntiRollBars, AntiRollbarToTable(element:get()))
  end)

  data.Suspensions = {}
  vehicle.Suspensions:ForEach(function(index, element)
    table.insert(data.Suspensions, VehicleSuspensionParamToTable(element:get()))
  end)

  data.Pistons = {}
  vehicle.Pistons:ForEach(function(index, element)
    table.insert(data.Pistons, VehiclePistonParamToTable(element:get()))
  end)

  data.FuelTankCapacityInLiter = vehicle.FuelTankCapacityInLiter
  data.AirDragCoeff = vehicle.AirDragCoeff
  data.AeroLiftCoeff = Vector2DToTable(vehicle.AeroLiftCoeff)
  data.AeroLiftCoeff_Front = vehicle.AeroLiftCoeff_Front
  data.AeroLiftCoeff_Rear = vehicle.AeroLiftCoeff_Rear
  data.AirDragFrontalAreaMultiplier = vehicle.AirDragFrontalAreaMultiplier

  data.DiffLockings = {}
  vehicle.DiffLockings:ForEach(function(index, element)
    table.insert(data.DiffLockings, VehicleDiffLockingStateToTable(element:get()))
  end)

  data.LiftAxles = {}
  vehicle.LiftAxles:ForEach(function(index, element)
    table.insert(data.LiftAxles, VehicleLiftAxleToTable(element:get()))
  end)

  data.ControlSettings = {
    SteeringAssistMinSpeed = Vector2DToTable(vehicle.ControlSettings.SteeringAssistMinSpeed),
    SteeringSpeedInComfort = vehicle.ControlSettings.SteeringSpeedInComfort,
    bRearSteering = vehicle.ControlSettings.bRearSteering
  }
  data.PhysicsSettings = {
    TCSMinWheelSpeed = Vector2DToTable(vehicle.PhysicsSettings.TCSMinWheelSpeed)
  }
  data.bUseSteeringWheelSocketAsPivot = vehicle.bUseSteeringWheelSocketAsPivot
  data.bSteeringAttachedToSkeletalSocket = vehicle.bSteeringAttachedToSkeletalSocket
  data.LimitSteeringByLateralG = vehicle.LimitSteeringByLateralG
  data.bLeanDriver = vehicle.bLeanDriver
  data.BaseLeanForwardDegree = vehicle.BaseLeanForwardDegree
  -- data.HornSound = vehicle.HornSound
  data.HornFadeInSeconds = vehicle.HornFadeInSeconds
  data.HornFadeOutSeconds = vehicle.HornFadeOutSeconds
  -- data.SirenSounds = vehicle.SirenSounds
  -- data.AirBrakeSound = vehicle.AirBrakeSound
  -- data.ParkingBrakeSound = vehicle.ParkingBrakeSound
  -- data.ParkingBrakeReleaseSound = vehicle.ParkingBrakeReleaseSound
  -- data.BackupBeep = vehicle.BackupBeep
  -- data.RefuelingSound = vehicle.RefuelingSound
  data.RefuelSoundFadeInSeconds = vehicle.RefuelSoundFadeInSeconds
  data.RefuelSoundFadeOutSeconds = vehicle.RefuelSoundFadeOutSeconds
  -- data.RefuelingEndSound = vehicle.RefuelingEndSound
  -- data.RattleSound = vehicle.RattleSound
  data.RattleSoundG = vehicle.RattleSoundG
  -- data.WindNoiseSound = vehicle.WindNoiseSound
  data.WindNoiseVolume = vehicle.WindNoiseVolume
  data.Throttle = vehicle.Throttle
  data.Brake = vehicle.Brake
  data.Steer = vehicle.Steer
  data.HandBrake = vehicle.HandBrake
  data.Clutch = vehicle.Clutch
  data.BikeDriverLeaning = RotatorToTable(vehicle.BikeDriverLeaning)
  data.Net_VehicleFlags = vehicle.Net_VehicleFlags

  data.WheelAxles = {}
  vehicle.WheelAxles:ForEach(function(index, element)
    table.insert(data.WheelAxles, VehicleWheelAxleToTable(element:get()))
  end)

  -- data.LocalBoundsComponents = vehicle.LocalBoundsComponents
  -- data.LocalBoundsComponentDefaultTransforms = vehicle.LocalBoundsComponentDefaultTransforms
  -- data.VehicleReplicatedMovement = vehicle.VehicleReplicatedMovement
  -- data.VehicleReplicatedMovements = vehicle.VehicleReplicatedMovements
  data.NetLC_VehicleState = VehicleStateToTable(vehicle.NetLC_VehicleState)
  data.NetLC_ColdState = VehicleColdStateToTable(vehicle.NetLC_ColdState)
  data.NetLC_EngineHotState = NetEngineHotStateToTable(vehicle.NetLC_EngineHotState)
  data.NetLC_EngineColdState = {
    bDisabled = vehicle.NetLC_EngineColdState.bDisabled,
    bOverHeated = vehicle.NetLC_EngineColdState.bOverHeated
  }
  data.NetLC_TransmissionColdState = {
    CurrentGear = vehicle.NetLC_TransmissionColdState.CurrentGear
  }

  data.Net_Seats = {}
  if vehicle.Net_Seats:IsValid() and IsUObjectSafe(vehicle.Net_Seats) then
    vehicle.Net_Seats:ForEach(function(index, element)
      local seat = element:get()
      if IsUObjectSafe(seat) then
        local charGuid = json.null
        if seat.Character:IsValid() and IsUObjectSafe(seat.Character) and
           seat.Character.Net_MTPlayerState:IsValid() and IsUObjectSafe(seat.Character.Net_MTPlayerState) then
          charGuid = GuidToString(seat.Character.Net_MTPlayerState.CharacterGuid)
        end
        table.insert(data.Net_Seats, {
          SeatName = seat.SeatName:ToString(),
          Character = charGuid,
          bHasCharacter = seat.bHasCharacter
        })
      end
    end)
  end

  data.Net_Cargo = {
    CargoWeightKg = vehicle.Net_Cargo.CargoWeightKg,
    LoadedVolumes = vehicle.Net_Cargo.LoadedVolumes,
    MaxVolumes = vehicle.Net_Cargo.MaxVolumes,
    NumCargo = vehicle.Net_Cargo.NumCargo
  }
  data.Net_VehicleOwnerSetting = VehicleOwnerSettingToTable(vehicle.Net_VehicleOwnerSetting)

  data.Net_VehicleSettings = {}
  vehicle.Net_VehicleSettings:ForEach(function(index, element)
    table.insert(data.Net_VehicleSettings, {
      SettingType = element:get().SettingType,
      Value = SettingValueToTable(element:get().Value)
    })
  end)

  data.Customization = VehicleCustomizationToTable(vehicle.Customization)
  data.Net_Decal = VehicleDecalToTable(vehicle.Net_Decal)
  data.Net_OwnerPlayerState = vehicle.Net_OwnerPlayerState:IsValid() and
      GuidToString(vehicle.Net_OwnerPlayerState.CharacterGuid) or json.null
  data.Net_OwnerCharacterId = {
    CharacterGuid = GuidToString(vehicle.Net_OwnerCharacterId.CharacterGuid),
    UniqueNetId = vehicle.Net_OwnerCharacterId.UniqueNetId:ToString()
  }
  data.Net_OwnerCompanyGuid = GuidToString(vehicle.Net_OwnerCompanyGuid)
  data.Net_AccountNickname = vehicle.Net_AccountNickname:ToString()
  data.Net_VehicleId = vehicle.Net_VehicleId
  -- data.Server_OwnerPlayerController = vehicle.Server_OwnerPlayerController

  -- SAFETY: Net_Parts TArray is mutated by the replication system on the game thread.
  -- Reading it from the async webserver thread causes EXCEPTION_ACCESS_VIOLATION.
  -- Parts are delivered safely via the C++ ServerEnterVehicle hook instead.
  data.Net_Parts = {}

  -- data.UtilitySlots = vehicle.UtilitySlots
  data.Net_AINetData = VehicleAINetStateToTable(vehicle.Net_AINetData)
  -- data.InternalWindowMaterials = vehicle.InternalWindowMaterials
  -- data.LC_InteractionCandidates = vehicle.LC_InteractionCandidates
  data.Laptime = LaptimeModuleToTable(vehicle.Laptime)
  -- data.TrailerHitchSocketComponent = vehicle.TrailerHitchSocketComponent
  data.CurrentRoad = MotorTownRoadToTable(vehicle.CurrentRoad)

  data.Net_Hooks = {}
  if vehicle.Net_Hooks:IsValid() and IsUObjectSafe(vehicle.Net_Hooks) then
    vehicle.Net_Hooks:ForEach(function(index, element)
      local hook = element:get()
      if IsUObjectSafe(hook) then
        local tractor = hook.Tractor
        local trailer = hook.Trailer
        table.insert(data.Net_Hooks, {
          Tractor = tractor:IsValid() and IsUObjectSafe(tractor) and tractor.Net_VehicleId or json.null,
          Trailer = trailer:IsValid() and IsUObjectSafe(trailer) and trailer.Net_VehicleId or json.null,
          TractorParams = VehicleHookParamToTable(hook.TractorParams),
          TrailerParams = VehicleHookParamToTable(hook.TrailerParams),
        })
      end
    end)
  end

  data.Net_Tractor = vehicle.Net_Tractor:IsValid() and vehicle.Net_Tractor.Net_VehicleId or json.null
  data.Net_MovementOwnerPC = GetPlayerUniqueId(vehicle.Net_MovementOwnerPC) or json.null

  data.Server_TempMovementOwnerPCs = {}
  vehicle.Server_TempMovementOwnerPCs:ForEach(function(index, element)
    table.insert(data.Server_TempMovementOwnerPCs, GetPlayerUniqueId(element:get()))
  end)

  data.Server_LastMovementOwnerPC = GetPlayerUniqueId(vehicle.Server_LastMovementOwnerPC)
  data.Net_LastNoMovementOwnerPCServerTimeSeconds = vehicle.Net_LastNoMovementOwnerPCServerTimeSeconds
  data.Net_LastMovementOwnerPCName = vehicle.Net_LastMovementOwnerPCName:ToString()
  data.VehicleOwnerProfitShareMultiplier = vehicle.VehicleOwnerProfitShareMultiplier
  -- data.ExplosionDetector = vehicle.ExplosionDetector
  -- data.Server_GarbageCompress = vehicle.Server_GarbageCompress
  data.Server_LastPlayerController = GetPlayerUniqueId(vehicle.Server_LastPlayerController)
  -- data.IgnoreCollisionComponents = vehicle.IgnoreCollisionComponents
  data.Net_CarCarrierCargoSpace = VehicleCargoSpaceCompToTable(vehicle.Net_CarCarrierCargoSpace)
  data.Net_CompanyGuid = GuidToString(vehicle.Net_CompanyGuid)
  data.Net_CompanyName = vehicle.Net_CompanyName:ToString()
  -- data.OverlappingActors = vehicle.OverlappingActors
  -- data.AreaVolumes = vehicle.AreaVolumes
  -- data.WaterBodies = vehicle.WaterBodies
  data.Net_PTOThrottle = vehicle.Net_PTOThrottle
  data.Net_bPTOOn = vehicle.Net_bPTOOn

  data.DriveInfo = GetDriveInfo(vehicle)

  return data
end

---Convert AMTGarageActor to JSON serializable table
---@param garage AMTGarageActor
local function GarageToTable(garage)
  local data = {}

  data.GarageFlags = garage.GarageFlags
  data.GameplayTags = GameplayTagContainerToString(garage.GameplayTags)
  data.AvailableVehiclePartTagQuery = GameplayTagQueryToTable(garage.AvailableVehiclePartTagQuery)
  data.Location = VectorToTable(garage:K2_GetActorLocation())
  data.Rotation = RotatorToTable(garage:K2_GetActorRotation())

  return data
end

---Get all or selected vehicle state(s)
---@param id number? Get specific vehicle with ID
---@param fields string[]? Filter the result based on the table key(s)
---@param limit number?
---@param isControlled boolean?
local function GetVehicles(id, fields, limit, isControlled)
  local gameState = GetMotorTownGameState()
  local arr = {} ---@type table[]

  if not gameState:IsValid() then return arr end

  for i = 1, #gameState.Vehicles, 1 do
    local v = gameState.Vehicles[i]
    if not v:IsValid() or not IsUObjectSafe(v) then goto continue end

    -- Filter by id
    if id and id ~= v.Net_VehicleId then
      goto continue
    end

    if isControlled and not v.Net_MovementOwnerPC:IsValid() then
      goto continue
    end

    local vehicle = VehicleToTable(v)
    local filtered = {}

    if fields then
      for index, value in ipairs(fields) do
        if vehicle[value] == nil then
          error("Field " .. value .. " does not exist")
        end

        filtered[value] = vehicle[value]
      end
      -- Always returns the delivery point guid
      filtered.Net_VehicleId = vehicle.Net_VehicleId

      table.insert(arr, filtered)
    else
      table.insert(arr, vehicle)
    end

    -- Limit result if set
    if limit and #arr >= limit then
      return arr
    end

    ::continue::
  end
  return arr
end

local function GetVehiclesByTag(tags)
  local arr = {}

  for tagIndex, tag in ipairs(tags) do
    local actors = {}
    UEHelpers.GetGameplayStatics():GetAllActorsWithTag(
      UEHelpers.GetWorld(),
      FName(tag),
      actors
    )
    for i, actorContainer in ipairs(actors) do
      local vehicle = actorContainer:get()
      if vehicle:IsValid() and IsUObjectSafe(vehicle) then
        -- SAFETY: Net_Parts TArray concurrent access crash — skip on async thread.
        local parts = {}
        table.insert(arr, {
          fullName = vehicle:GetFullName(),
          classFullName = vehicle:GetClass():GetFullName(),
          position = vehicle:K2_GetActorLocation(),
          rotation = vehicle:K2_GetActorRotation(),
          decal = VehicleDecalToTable(vehicle.Net_Decal),
          customization = VehicleCustomizationToTable(vehicle.Customization),
          parts = parts,
        })
      end
    end
  end
  return arr
end

---Despawn selected vehicle
---@param id number Vehicle ID
---@param uniqueId string? Player unique net ID
local function DespawnVehicleById(id, uniqueId)
  local gameState = GetMotorTownGameState()

  if not gameState:IsValid() then return false end

  local vehicle = CreateInvalidObject()
  ---@cast vehicle AMTVehicle
  for i = 1, #gameState.Vehicles, 1 do
    local v = gameState.Vehicles[i]
    if v:IsValid() and IsUObjectSafe(v) and v.Net_VehicleId == id then
      vehicle = v
      break
    end
  end

  if not vehicle:IsValid() or not IsUObjectSafe(vehicle) then return false end

  for i = 1, #gameState.PlayerArray, 1 do
    local playerState = gameState.PlayerArray[i]
    ---@cast playerState AMotorTownPlayerState

    if uniqueId and uniqueId == GetUniqueNetIdAsString(playerState) then
      local PC = playerState:GetPlayerController()
      ---@cast PC AMotorTownPlayerController

      if PC:IsValid() and playerState.bIsAdmin then
        if playerState.bIsHost then
          PC:ServerDespawnVehicle(vehicle, 0)
          return true
        else
          return webhook.CreateServerRequest(
            "/vehicle/" .. id .. "/despawn",
            json.stringify {
              PlayerGuid = uniqueId
            }
          )
        end
      end
    end
  end
  return false
end

---Spawn vehicle dealer plot at given location
---@param location FVector Location to spawn
---@param rotation FRotator? Plot world rotation
---@param vehicleClass string? Vehicle blueprint class path
---@param vehicleParam table? Optional vehicle parameter
---@return boolean Success
---@return string? AssetTag Generated asset tag
local function SpawnVehicleDealer(location, rotation, vehicleClass, vehicleParam)
  local status, assetTag, actor = assetManager.SpawnActor(vehicleDealerSoftPath, location, rotation)

  if status and actor and actor:IsValid() then
    ---@cast actor AMTDealerVehicleSpawnPoint

    if vehicleParam then
      local Customizations = {}
      if vehicleParam.Customization then
        local Customization = vehicleParam.Customization
        for i, bc in ipairs(Customization.BodyColors) do
            ---@diagnostic disable-next-line: param-type-mismatch
            bc.MaterialSlotName = FName(bc.MaterialSlotName)
            Customization.BodyColors[i] = bc
        end
        Customizations = { Customization }
      end

      actor.VehicleParams[1] = {
        Customizations = Customizations,
        Parts = vehicleParam.Parts or {},
        VehicleKey = FName(vehicleParam.VehicleKey or "")
      }
    end
    return true, assetTag
  end
  return false
end

---Get all garages
---@return table[]
local function GetGarages()
  local data = {}
  local gameState = GetMotorTownGameState()

  if gameState:IsValid() then
    gameState.Garages:ForEach(function(index, element)
      table.insert(data, GarageToTable(element:get()))
    end)
  end

  return data
end

---Spawn garage at the given location and rotation
---@param location FVector
---@param rotation FRotator
local function SpawnGarage(location, rotation)
  local status, assetTag, actor = assetManager.SpawnActor(garageSoftPath, location, rotation)

  if status and actor and actor:IsValid() then
    return true, assetTag
  end
  return false
end

-- Console commands

RegisterConsoleCommandHandler("despawnvehicle", function()
  local actor = GetSelectedActor()

  if not actor:IsValid() then
    LogOutput("ERROR", "No actor selected")
    return false
  end

  local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
  ---@cast vehicleClass UClass

  if not vehicleClass:IsValid() then
    LogOutput("ERROR", "Vehicle class not found")
    return false
  end

  if not actor:IsA(vehicleClass) then
    LogOutput("ERROR", "Selected actor is not a vehicle")
    return false
  end

  if not actor:IsActorBeingDestroyed() then
    ---@cast actor AMTVehicle

    local vehicleName = actor:GetFullName()
    if DespawnVehicleById(actor.Net_VehicleId, GetPlayerUniqueId(GetMyPlayerController())) then
      LogOutput("INFO", "Despawned vehicle: %s", vehicleName)
    end
  end
  return true
end)

RegisterKeyBind(Key.X, { ModifierKey.CONTROL, ModifierKey.SHIFT }, function()
  local wasHit, hitResult = GetHitResultFromCenterLineTrace()
  if not wasHit then
    LogOutput("WARN", "Raycast hit nothing")
    return
  end

  local actor = GetActorFromHitResult(hitResult)
  if not actor:IsValid() then
    LogOutput("WARN", "Hit actor is not valid")
    return
  end

  local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
  ---@cast vehicleClass UClass

  if not vehicleClass:IsValid() then
    LogOutput("ERROR", "Vehicle class not found")
    return
  end

  if not actor:IsA(vehicleClass) then
    LogOutput("INFO", "Raycast hit non-vehicle: %s", actor:GetFullName())
    return
  end

  if not actor:IsActorBeingDestroyed() then
    ---@cast actor AMTVehicle
    local vehicleName = actor:GetFullName()
    if DespawnVehicleById(actor.Net_VehicleId, GetPlayerUniqueId(GetMyPlayerController())) then
      LogOutput("INFO", "Despawned vehicle via raycast: %s", vehicleName)
    end
  end
end)

RegisterConsoleCommandHandler("setvehicleparam", function(Cmd, CommandParts, Ar)
  if not pcall(function()
        local fields = SplitString(table.remove(CommandParts, 1), ".")
        local value = CommandParts[1]

        if not fields then
          LogOutput("ERROR", "No fields value given.")
          return true
        end

        if value == nil then
          LogOutput("ERROR", "No valid value given.")
          return true
        end

        local PC = GetMyPlayerController()
        if PC:IsValid() then
          local pawn = PC:K2_GetPawn()
          local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
          ---@cast vehicleClass UClass

          if pawn:IsValid() and pawn:IsA(vehicleClass) then
            RecursiveSetValue(pawn, fields, value)
          end
        end
      end) then
    LogOutput("WARN", "Failed to change %s field for pawn", CommandParts[2])
  end

  return true
end)

-- HTTP request handler

---Handle the get vehicles commands
---@type RequestPathHandler
local function HandleGetVehicles(session)
  local id = tonumber(session.pathComponents[2]) or nil
  local fields = SplitString(session.queryComponents.filters, ",")
  local limit = nil ---@type number?
  local isPlayerControlled = nil ---@type boolean?

  if session.queryComponents.limit then
    limit = tonumber(session.queryComponents.limit)
  end

  if session.queryComponents.isPlayerControlled then
    isPlayerControlled = true
  end

  local getTime, data = timer.benchmark(GetVehicles, id, fields, limit, isPlayerControlled)
  LogOutput("DEBUG", "GetVehicles time: %fs", getTime)

  if id and #data == 0 then
    return { message = string.format("Vehicle with ID %s not found", id) }, nil, 404
  end

  return { data = data }, nil, 200
end

local function HandleGetVehiclesByTag(session)
  local tags = SplitString(session.queryComponents.tags, ",")
  return { data = GetVehiclesByTag(tags) }, nil, 200
end

---Handle vehicle despawn request
---@type RequestPathHandler
local function HandleDespawnVehicle(session)
  local id = tonumber(session.pathComponents[2])
  local content = json.parse(session.content)
  local playerGuid = nil

  if content then
    playerGuid = content.PlayerGuid
  end

  if not id then
    return { message = "Invalid vehicle ID" }, nil, 400
  end

  if DespawnVehicleById(id, playerGuid) then
    return nil, nil, 204
  else
    return { message = "Failed to despawn vehicle" }, nil, 400
  end
end

---Handle vehicle dealer spawn point
---@type RequestPathHandler
local function HandleCreateVehicleDealerSpawnPoint(session)
  local data = json.parse(session.content)
  if data then
    local status, tag = SpawnVehicleDealer(
      {
        X = data.Location.X,
        Y = data.Location.Y,
        Z = data.Location.Z
      },
      {
        Pitch = data.Rotation and data.Rotation.Pitch or 0,
        Roll = data.Rotation and data.Rotation.Roll or 0,
        Yaw = data.Rotation and data.Rotation.Yaw or 0
      },
      data.VehicleClass,
      data.VehicleParam
    )
    if status then
      return { data = { tag = tag } }, nil, 201
    end
  end
  return nil, nil, 400
end

---Handle the get garages request
---@type RequestPathHandler
local function HandleGetGarages(session)
  return { data = GetGarages() }, nil, 200
end

---Handle garage spawn request
---@type RequestPathHandler
local function HandleSpawnGarage(session)
  local data = json.parse(session.content)
  if data and data.Location then
    local status, tag = SpawnGarage(
      {
        X = data.Location.X,
        Y = data.Location.Y,
        Z = data.Location.Z
      },
      {
        Pitch = data.Rotation and data.Rotation.Pitch or 0,
        Roll = data.Rotation and data.Rotation.Roll or 0,
        Yaw = data.Rotation and data.Rotation.Yaw or 0
      }
    )
    if status then
      return { data = { tag = tag } }, nil, 201
    end
  end
  return nil, nil, 400
end

---Handle request to change a vehicle parameter
---@type RequestPathHandler
local function HandleSetVehicleParameter(session)
  local id = tonumber(session.pathComponents[2])
  local data = json.parse(session.content)

  if data and data.Field and data.Value then
    local vehicle = CreateInvalidObject() ---@cast vehicle AMTVehicle
    if id and id > 0 then -- Prevent modifying the AI/loaner vehicles
      local gameState = GetMotorTownGameState()
      if gameState:IsValid() then
        for i = 1, #gameState.Vehicles do
          local _vehicle = gameState.Vehicles[i]
          if _vehicle:IsValid() and _vehicle.Net_VehicleId == id then
            vehicle = _vehicle
            break;
          end
        end
      end
    elseif data.PlayerId then
      local PC = GetPlayerControllerFromUniqueId(data.PlayerId)
      if PC:IsValid() then
        local pawn = PC:K2_GetPawn()
        local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
        ---@cast vehicleClass UClass

        if pawn:IsValid() and pawn:IsA(vehicleClass) then
          vehicle = pawn
        end
      end
    end

    if vehicle:IsValid() and IsUObjectSafe(vehicle) then
      local fields = SplitString(data.Field, ".") or {}
      RecursiveSetValue(vehicle, fields, data.Value)
      return { Status = "ok" }, nil, 200
    end
    return { error = "Unable to find specified vehicle" }, nil, 404
  end
  return { error = "Invalid payload provided" }, nil, 400
end

local function HandleDetachPlayerVehicle(session)
  local playerId = session.pathComponents[2]
  local content = json.parse(session.content)
  if not content then
    return { error = "Invalid JSON body" }, nil, 400
  end

  local PC = GetPlayerControllerFromGuid(playerId)
  if not PC:IsValid() then
    return { error = "Invalid player controller" }, nil, 400
  end

  -- SAFETY: Net_SpawnedVehicles and Net_Hooks are replicated TArrays.
  -- All traversal + ServerDetachTrailer must run on the game thread.
  local ok = true
  if not PC:IsValid() then return end
  PC.Net_SpawnedVehicles:ForEach(function(index, element)
    local vehicle = element:get()
    if vehicle:IsValid() and IsUObjectSafe(vehicle) then
      if vehicle.Net_Hooks:IsValid() and IsUObjectSafe(vehicle.Net_Hooks) then
        vehicle.Net_Hooks:ForEach(function(i, val)
          local hook = val:get()
          if hook:IsValid() and IsUObjectSafe(hook) and hook.Trailer:IsValid() and IsUObjectSafe(hook.Trailer) and hook.Trailer.Net_VehicleId == content.vehicleId then
            if hook.Tractor:IsValid() and IsUObjectSafe(hook.Tractor) then
              PC:ServerDetachTrailer(hook.Tractor, hook.Trailer)
              if content.message ~= nil then
                PC:ClientShowSystemMessage(FText(content.message))
              end
            end
          end
        end)
      end
    end
  end)
  if not ok then return { error = "Game thread timeout" }, nil, 503 end
end

local function HandleGetPlayerVehicleDecal(session)
  local playerId = session.pathComponents[2]

  local result = nil
  local errMsg = nil
  local errCode = 400
  local ok = true
  local PC = GetPlayerControllerFromUniqueId(playerId)
  if not PC:IsValid() then
    errMsg = "Invalid player controller"
  else
    local vehicle = GetPlayerVehicle(PC)
    if vehicle == nil then
      errMsg = "Player is not in a vehicle"
    elseif not vehicle:IsValid() then
      errMsg = "Invalid vehicle"
    else
      result = {
        decal = VehicleDecalToTable(vehicle.Net_Decal),
        garageMode = vehicle:IsGarageMode(),
        customization = VehicleCustomizationToTable(vehicle.Customization),
      }
    end
  end

  if not ok then return { error = "Game thread timeout" }, nil, 503 end
  if errMsg then return { error = errMsg }, nil, errCode end
  return (result), nil, 200
end


local function HandleSetWorldVehicleDecal(session)
  local className = session.pathComponents[2]
  local content = json.parse(session.content)
  if not content then
    return { error = "Invalid JSON body" }, nil, 400
  end
  
  local vs = FindAllOf(className)

  for i, vehicle in ipairs(vs) do
    ---@cast vehicle AMTVehicle
    LogOutput('INFO', vehicle:GetFullName())
    if vehicle:IsValid() then
      if vehicle.bForSale then
        goto continue_loop
      end
      ---@diagnostic disable-next-line: need-check-nil
      local decal = TableToVehicleDecal(content.decal)
      vehicle.Net_Decal.DecalLayers:Empty()
      for index, value in ipairs(decal.DecalLayers) do
        vehicle.Net_Decal.DecalLayers[index] = value
      end
      vehicle:ServerSetDecal({ DecalLayers = vehicle.Net_Decal.DecalLayers })

      if content.customization then
        LogOutput("INFO", "Setting customization")
        vehicle.Customization.BodyMaterialIndex = content.customization.BodyMaterialIndex
        if vehicle.Customization.BodyColors:IsValid() then
          vehicle.Customization.BodyColors:Empty()
          for i, bc in ipairs(content.customization.BodyColors) do
            vehicle.Customization.BodyColors[i].MaterialSlotName = FName(bc.MaterialSlotName)
            vehicle.Customization.BodyColors[i].Color = bc.Color
          end
        end
      end

      if content.parts ~= nil then
        LogOutput("INFO", "Setting parts")
        if vehicle:IsValid() and vehicle.Net_Parts:IsValid() then
          vehicle.Net_Parts:Empty()
          for i, part in ipairs(content.parts) do
            vehicle.Net_Parts[i] = TableToVehiclePart(part)
            if part.StringValues ~= nil then
              vehicle.Net_Parts[i].StringValues = part.StringValues
            end
            if part.FloatValues ~= nil then
              vehicle.Net_Parts[i].FloatValues = part.FloatValues
            end
            if part.Int64Values ~= nil then
              vehicle.Net_Parts[i].Int64Values = part.Int64Values
            end
            if part.VectorValues ~= nil then
              vehicle.Net_Parts[i].VectorValues = part.VectorValues
            end
          end
          vehicle:ServerSetParts(vehicle.Net_Parts)
        end
      end
    end

    ::continue_loop::
  end
end

local function HandleSetPlayerVehicleDecal(session)
  local playerId = session.pathComponents[2]
  local content = json.parse(session.content)
  if not content then
    return { error = "Invalid JSON body" }, nil, 400
  end

  local PC = GetPlayerControllerFromUniqueId(playerId)
  if PC:IsValid() then
    local vehicle = GetPlayerVehicle(PC)
    if vehicle == nil then
      return { error = "Player is not in a vehicle" }, nil, 400
    end
    if vehicle:IsValid() then
      ---@diagnostic disable-next-line: need-check-nil
      local decal = TableToVehicleDecal(content.decal)
      vehicle.Net_Decal.DecalLayers:Empty()
      for index, value in ipairs(decal.DecalLayers) do
        vehicle.Net_Decal.DecalLayers[index] = value
      end
      vehicle:ServerSetDecal({ DecalLayers = vehicle.Net_Decal.DecalLayers })
      PC:ServerSetVehicleCustomization(vehicle, TableToVehicleCustomization(content.customization, vehicle.Customization))

      return { Status = "ok" }, nil, 200
    end
    return { error = "Invalid vehicle" }, nil, 400
  end

  return { error = "Invalid player controller" }, nil, 400
end

local function PlayerVehicleToTable(vehicle, complete)
  if not vehicle:IsValid() or not IsUObjectSafe(vehicle) then
    return {}
  end
  local vehicleInfo = {}
  vehicleInfo["vehicleId"] = vehicle.Net_VehicleId
  if vehicle.NetLC_ColdState:IsValid() then
    vehicleInfo["bIsAIDriving"] = vehicle.NetLC_ColdState.bIsAIDriving
  end
  LogOutput("INFO", "Getting company guid and name")
  if vehicle.Net_CompanyGuid:IsValid() then
    vehicleInfo["companyGuid"] = GuidToString(vehicle.Net_CompanyGuid)
  end
  vehicleInfo["companyName"] = vehicle.Net_CompanyName:ToString()
  vehicleInfo["position"] = vehicle:K2_GetActorLocation()
  vehicleInfo["rotation"] = vehicle:K2_GetActorRotation()
  vehicleInfo["fullName"] = vehicle:GetFullName()
  LogOutput("INFO", "Getting class name")
  local vehicleClass = vehicle:GetClass()
  if vehicleClass:IsValid() then
    vehicleInfo["classFullName"] = vehicleClass:GetFullName()
  end
  if complete then
    if vehicle.Net_VehicleOwnerSetting:IsValid() then
      vehicleInfo["Net_VehicleOwnerSetting"] = VehicleOwnerSettingToTable(vehicle.Net_VehicleOwnerSetting)
    end
    LogOutput("INFO", "Getting decal")
    if vehicle.Net_Decal:IsValid() then
      vehicleInfo["decal"] = VehicleDecalToTable(vehicle.Net_Decal)
    end
    LogOutput("INFO", "Getting customization")
    if vehicle.Customization:IsValid() then
      vehicleInfo["customization"] = VehicleCustomizationToTable(vehicle.Customization)
    end
    if vehicle.Net_Parts:IsValid() and IsUObjectSafe(vehicle.Net_Parts) then
      vehicleInfo["parts"] = {}
      vehicle.Net_Parts:ForEach(function(index, element)
        local part = element:get()
        if IsUObjectSafe(part) then
          table.insert(vehicleInfo["parts"], VehiclePartToTable(part))
        end
      end)
    end
  end
  return vehicleInfo
end

local function HandleGetPlayerVehicles(session)
  local playerId = session.pathComponents[2]
  local complete = session.queryComponents.complete ~= nil

  local PC = GetPlayerControllerFromUniqueId(playerId)
  if not PC:IsValid() then
    return { error = "Invalid player controller" }, nil, 400
  end

  if not PC.Net_SpawnedVehicles:IsValid() then
    return { error = "Invalid player vehicles" }, nil, 400
  end

  local lastPlayerVehicleId = nil
  local activeVehicles = {}

  LogOutput("INFO", "Recursively getting trailers")
  if PC.LastVehicle ~= nil and PC.LastVehicle:IsValid() and IsUObjectSafe(PC.LastVehicle) and not PC.LastVehicle:IsActorBeingDestroyed() then
    lastPlayerVehicleId = PC.LastVehicle.Net_VehicleId

    local curr = PC.LastVehicle ---@type AMTVehicle?

    while curr ~= nil and curr:IsValid() and IsUObjectSafe(curr) and not curr:IsActorBeingDestroyed() and curr.Net_Hooks:IsValid() and IsUObjectSafe(curr.Net_Hooks) do
      local v = curr
      table.insert(activeVehicles, v)
      curr = nil
      v.Net_Hooks:ForEach(function(i, val)
        local hook = val:get()
        if hook:IsValid() and IsUObjectSafe(hook) and hook.Trailer:IsValid() and IsUObjectSafe(hook.Trailer) and not hook.Trailer:IsActorBeingDestroyed() and hook.Trailer.Net_VehicleId ~= v.Net_VehicleId then
          curr = hook.Trailer
        end
      end)
    end
  end

  LogOutput("INFO", "Adding active vehicles")
  local vehicles = {}
  for index, vehicle in ipairs(activeVehicles) do
    if vehicle:IsValid() and IsUObjectSafe(vehicle) and not vehicle:IsActorBeingDestroyed() then
      local vehicleInfo = PlayerVehicleToTable(vehicle, complete)
      if vehicleInfo.vehicleId then
        vehicleInfo["isLastVehicle"] = true
        vehicleInfo["index"] = index - 1
        vehicles[tostring(vehicle.Net_VehicleId)] = vehicleInfo
      end
    end
  end

  if session.queryComponents.active == nil then
    LogOutput("INFO", "Adding spawned vehicles")
    PC.Net_SpawnedVehicles:ForEach(function(index, element)
      local vehicle = element:get()
      if vehicle:IsValid() and IsUObjectSafe(vehicle) and vehicles[tostring(vehicle.Net_VehicleId)] == nil then
        local vehicleInfo = PlayerVehicleToTable(vehicle, complete)
        if vehicleInfo.vehicleId then
          vehicleInfo["isLastVehicle"] = false
          vehicleInfo["index"] = 0
          vehicles[tostring(vehicle.Net_VehicleId)] = vehicleInfo
        end
      end
    end)
  end
  return { vehicles = vehicles }, nil, 200
end



local function HandlePlayerExitVehicle(session)
  local characterGuid = session.pathComponents[2]
  local PC = GetPlayerControllerFromGuid(characterGuid)
  if not PC:IsValid() then
    return { error = "Invalid player controller" }, nil, 400
  end
  PC:ServerExitVehicle()
  return nil, nil, 200
end

---Handle request to teleport player into their last used vehicle
---@type RequestPathHandler
local function HandlePlayerEnterLastVehicle(session)
  local characterGuid = session.pathComponents[2]
  local PC = GetPlayerControllerFromGuid(characterGuid)
  if PC == nil or not PC:IsValid() then
    return { error = "Invalid player controller" }, nil, 400
  end

  if PC.LastVehicle == nil or not PC.LastVehicle:IsValid() then
    return { error = "no_last_vehicle" }, nil, 400
  end

  local vehicle = PC.LastVehicle
  local loc = vehicle:K2_GetActorLocation()

  local pawn = PC:K2_GetPawn()
  if pawn:IsValid() then
    local charClass = StaticFindObject("/Script/MotorTown.MTCharacter")
    ---@cast charClass UClass
    if pawn:IsA(charClass) then
      PC:ServerTeleportCharacter(loc, false, false)
    end
  end
  -- 1 is Driver seat, -1 means default index
  PC:ServerEnterVehicle(vehicle, 1, -1, false)

  return { status = "success" }, nil, 200
end

local function HandleSpawnVehicle(session)
  local content = json.parse(session.content)

  if content ~= nil and type(content) == "table" and content.AssetPath and content.Location then
    if content.driverGuid ~= nil then
      local PC = GetPlayerControllerFromGuid(content.driverGuid)
      if PC:IsValid() then
        local pawn = PC:K2_GetPawn()
        if pawn:IsValid() then
          content.Rotation = RotatorToTable(pawn:K2_GetActorRotation())
          content.Location = VectorToTable(pawn:K2_GetActorLocation())
          content.Location.Z = content.Location.Z - 95
        end
      end
    end
    local spawned, tag, vehicle = assetManager.SpawnActor(content.AssetPath, content.Location, content.Rotation, content.tag)
    ---@cast vehicle AMTVehicle
    LogOutput("INFO", "Spawned vehicle")

    if spawned then
      local function setOwnerSetting(PC)
        LogOutput("INFO", "Setting profit share")
        if not vehicle:IsValid() then
          return
        end
        ---@diagnostic disable-next-line: undefined-field
        if not vehicle.Net_VehicleOwnerSetting:IsValid() then
          return
        end
        local ownerSettings = {
          bLocked = false,
          DriveAllowedPlayers = 0,
          VehicleOwnerProfitShare = content.profitShare or 0.0,
          LevelRequirementsToDrive = vehicle.Net_VehicleOwnerSetting.LevelRequirementsToDrive,
        }
        vehicle.Net_VehicleOwnerSetting = ownerSettings
        -- Temporarily set the driver as the owner to set the owner setting
        -- There's a problem with setting profitShare with other methods
        vehicle.Net_OwnerPlayerState = PC.PlayerState
        PC:ServerSetOwnerVehicleSetting(vehicle, ownerSettings)
        ---@diagnostic disable-next-line: assign-type-mismatch
        vehicle.Net_OwnerPlayerState = CreateInvalidObject()

        if vehicle.Net_VehicleOwnerSetting.LevelRequirementsToDrive:IsValid() then
          vehicle.Net_VehicleOwnerSetting.LevelRequirementsToDrive:ForEach(function(index, el)
            el:set(1)
          end)
        end
        LogOutput("INFO", "Profit share set 2")
      end

      if content.tags ~= nil  and vehicle.Tags:IsValid() then
        LogOutput("INFO", "Setting tags")
        for i, tag in ipairs(content.tags) do
          vehicle.Tags[#vehicle.Tags+1] = FName(tag)
        end
      end

      if content.drivable ~= nil then
        vehicle.bDrivable = content.drivable
      end

      if content.customization then
        LogOutput("INFO", "Setting customization")
        vehicle.Customization.BodyMaterialIndex = content.customization.BodyMaterialIndex
        if vehicle.Customization.BodyColors:IsValid() then
          vehicle.Customization.BodyColors:Empty()
          for i, bc in ipairs(content.customization.BodyColors) do
            vehicle.Customization.BodyColors[i].MaterialSlotName = FName(bc.MaterialSlotName)
            vehicle.Customization.BodyColors[i].Color = bc.Color
          end
        end
      end

      if content.companyGuid and content.companyName then
        LogOutput("INFO", "Setting company")
        vehicle.Net_CompanyGuid = StringToGuid(content.companyGuid)
        vehicle.Net_OwnerCompanyGuid = StringToGuid(content.companyGuid)
        vehicle.Net_CompanyName = content.companyName
      elseif content.accountNickname then
        vehicle.Net_AccountNickname = content.accountNickname
      end

      if content.forSale ~= nil then
        vehicle.bForSale = content.forSale
      end

      if vehicle:IsValid() then
        if content.decal ~= nil then
          LogOutput("INFO", "Setting decals")
          ---@diagnostic disable-next-line: undefined-field
          if vehicle.Net_Decal:IsValid() and vehicle.Net_Decal.DecalLayers:IsValid() then
            local decal = TableToVehicleDecal(content.decal)
            vehicle.Net_Decal.DecalLayers:Empty()
            for index, value in ipairs(decal.DecalLayers) do
              vehicle.Net_Decal.DecalLayers[index] = value
            end
            vehicle:ServerSetDecal({ DecalLayers = vehicle.Net_Decal.DecalLayers })
          end
        end

        if content.driverGuid ~= nil then
          LogOutput("INFO", "Setting driver")
          local PC = GetPlayerControllerFromGuid(content.driverGuid)
          if PC:IsValid() then
            if PC.PlayerState:IsValid() then
              setOwnerSetting(PC)
            end
            PC:ServerEnterVehicle(vehicle, 1, -1, false)
          end
        end
      end

      -- DISABLED: ExecuteInGameThreadWithDelay block for setting vehicle parts
      -- is not working reliably. Parts setting is skipped for now.
      -- if content.parts ~= nil then
      --   ExecuteInGameThreadWithDelay(2000, function()
      --     ...
      --   end)
      -- end

      return { data = { tag }, actor = vehicle:GetFullName() }
    else
      error("Failed to spawn asset " .. content.AssetPath)
    end
  end
  return nil, nil, 400
end

---Despawn player's last vehicle and attached trailers
---@param PC AMotorTownPlayerController
---@return number count The number of vehicles despawned
local function DespawnPlayerVehicle(PC)
  local count = 0
  if not PC:IsValid() or not IsUObjectSafe(PC) then
    return count
  end
  if PC.LastVehicle ~= nil and PC.LastVehicle:IsValid() and IsUObjectSafe(PC.LastVehicle) then
    local vehiclesToDespawn = {}
    local curr = PC.LastVehicle ---@type AMTVehicle?
    while curr ~= nil and curr:IsValid() and IsUObjectSafe(curr) and curr.Net_Hooks:IsValid() and IsUObjectSafe(curr.Net_Hooks) do
      local v = curr
      table.insert(vehiclesToDespawn, v)
      curr = nil
      v.Net_Hooks:ForEach(function(i, val)
        local hook = val:get()
        if hook:IsValid() and IsUObjectSafe(hook) and hook.Trailer:IsValid() and IsUObjectSafe(hook.Trailer) and hook.Trailer.Net_VehicleId ~= v.Net_VehicleId then
          curr = hook.Trailer
        end
      end)
    end

    for _, vehicle in ipairs(vehiclesToDespawn) do
      if vehicle:IsValid() and IsUObjectSafe(vehicle) then
        PC:ServerDespawnVehicle(vehicle, 0)
        count = count + 1
      end
    end
  end
  return count
end

---Handle despawning a player's current vehicle (and trailers)
---@type RequestPathHandler
local function HandleDespawnPlayerVehicle(session)
  local characterGuid = session.pathComponents[2]
  local PC = GetPlayerControllerFromGuid(characterGuid)
  if not PC:IsValid() then
    return { error = "Invalid player controller" }, nil, 400
  end
  local count = 0
  count = DespawnPlayerVehicle(PC)
  if count > 0 then
    return { despawned = count }, nil, 200
  else
    return { error = "No vehicle to despawn" }, nil, 404
  end
end

return {
  DespawnPlayerVehicle = DespawnPlayerVehicle,
  HandleGetVehicles = HandleGetVehicles,
  HandleGetVehiclesByTag = HandleGetVehiclesByTag,
  HandleGetPlayerVehicles = HandleGetPlayerVehicles,
  HandleGetPlayerVehicleDecal = HandleGetPlayerVehicleDecal,
  HandleSetPlayerVehicleDecal = HandleSetPlayerVehicleDecal,
  HandleSetWorldVehicleDecal = HandleSetWorldVehicleDecal,
  HandleDespawnVehicle = HandleDespawnVehicle,
  HandleDespawnPlayerVehicle = HandleDespawnPlayerVehicle,
  HandleDetachPlayerVehicle = HandleDetachPlayerVehicle,
  HandleCreateVehicleDealerSpawnPoint = HandleCreateVehicleDealerSpawnPoint,
  HandleGetGarages = HandleGetGarages,
  HandleSpawnGarage = HandleSpawnGarage,
  HandleSpawnVehicle = HandleSpawnVehicle,
  VehicleToTable = VehicleToTable,
  VehicleCustomizationToTable = VehicleCustomizationToTable,
  VehicleDecalToTable = VehicleDecalToTable,
  VehicleMirrorPositionToTable = VehicleMirrorPositionToTable,
  VehicleSettingToTable = VehicleSettingToTable,
  HandleSetVehicleParameter = HandleSetVehicleParameter,
  HandlePlayerExitVehicle = HandlePlayerExitVehicle,
  HandlePlayerEnterLastVehicle = HandlePlayerEnterLastVehicle,
}
