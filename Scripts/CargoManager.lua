local json = require("JsonParser")
local webhook = require("Webclient")

local _deliverySystem = CreateInvalidObject()
---Get Motor Town delivery system
local function GetDeliverySystem()
  local gameState = GetMotorTownGameState()
  if gameState:IsValid() and gameState.Net_DeliverySystem:IsValid() then
    local gameStateClass = StaticFindObject("/Script/MotorTown.MTDeliverySystem")
    ---@cast gameStateClass UClass
    if gameState.Net_DeliverySystem:IsA(gameStateClass) then
      _deliverySystem = gameState.Net_DeliverySystem
    end
  end
  return _deliverySystem ---@type AMTDeliverySystem
end

---Convert FMTNameAndNumber to JSON serializable table
---@param nan FMTNameAndNumber
local function NameAndNumberToTable(nan)
  return {
    Name = nan.Name:ToString(),
    Number = nan.Number
  }
end

---Convert FMTDeliveryPointLimit to JSON serializable table
---@param limit FMTDeliveryPointLimit
local function DeliveryPointLimitToTable(limit)
  local data = {}

  data.CargoTagQuery = GameplayTagQueryToTable(limit.CargoTagQuery)
  data.DeliveryPointTagQuery = GameplayTagQueryToTable(limit.DeliveryPointTagQuery)
  data.LimitCount = limit.LimitCount

  return data
end

---Convert FMTProductionConfig to JSON serializable table
---@param config FMTProductionConfig
local function ProductionConfigToTable(config)
  local data = {}

  data.InputCargos = {}
  config.InputCargos:ForEach(function(key, value)
    data.InputCargos[key:get():ToString()] = value:get()
  end)

  data.InputCargoTypes = {}
  config.InputCargoTypes:ForEach(function(key, value)
    data.InputCargoTypes[key:get()] = value:get()
  end)

  data.InputCargoGameplayTagQuery = GameplayTagQueryToTable(config.InputCargoGameplayTagQuery)
  data.OutputCargos = {}
  config.OutputCargos:ForEach(function(key, value)
    data.OutputCargos[key:get():ToString()] = value:get()
  end)

  data.OutputCargoTypes = {}
  config.OutputCargoTypes:ForEach(function(key, value)
    data.OutputCargoTypes[key:get()] = value:get()
  end)

  data.OutputCargoRowGameplayTagQuery = GameplayTagQueryToTable(config.OutputCargoRowGameplayTagQuery)
  data.bStoreInputCargo = config.bStoreInputCargo
  data.ProductionTimeSeconds = config.ProductionTimeSeconds
  data.ProductionSpeedMultiplier = config.ProductionSpeedMultiplier
  data.LocalFoodSupply = config.LocalFoodSupply
  data.bHidden = config.bHidden
  data.TimeSinceLastProduction = config.TimeSinceLastProduction
  data.ProductionFlags = config.ProductionFlags

  return data
end

---Convert FMTDeliveryPassiveSupply to JSON serializable table
---@param supply FMTDeliveryPassiveSupply
local function DeliveryPassiveSuplyToTable(supply)
  local data = {}

  data.CargoType = supply.CargoType
  data.CargoKey = supply.CargoKey:ToString()
  data.MinNumCargoPerDelivery = supply.MinNumCargoPerDelivery
  data.MaxNumCargoPerDelivery = supply.MaxNumCargoPerDelivery
  data.MaxDeliveries = supply.MaxDeliveries
  data.Priority = supply.Priority

  return data
end

---Convert FMTDeliveryDemand to JSON serializable table
---@param demand FMTDeliveryDemandConfig
local function DeliveryDemandToTable(demand)
  local data = {}

  data.CargoType = demand.CargoType
  data.CargoKey = demand.CargoKey:ToString()
  data.CargoGameplayTagQuery = GameplayTagQueryToTable(demand.CargoGameplayTagQuery)
  data.PaymentMultiplier = demand.PaymentMultiplier
  data.MaxStorage = demand.MaxStorage

  return data
end

---Convert FMTStorageConfig to JSON serializable table
---@param storage FMTDeliveryStorageConfig
local function StorageConfigToTable(storage)
  local data = {}

  data.CargoType = storage.CargoType
  data.CargoKey = storage.CargoKey:ToString()
  data.MaxStorage = storage.MaxStorage

  return data
end

---Convert FMTDelivery to JSON serializable table
---@param delivery FMTDelivery
local function DeliveryToTable(delivery)
  local data = {}

  data.ID = delivery.ID
  data.CargoType = delivery.CargoType
  data.CargoKey = delivery.CargoKey:ToString()
  data.NumCargos = delivery.NumCargos
  data.ColorIndex = delivery.ColorIndex
  data.Weight = delivery.Weight
  data.SenderPoint = GuidToString(delivery.SenderPoint.DeliveryPointGuid)
  data.ReceiverPoint = GuidToString(delivery.ReceiverPoint.DeliveryPointGuid)
  data.RegisteredTimeSeconds = delivery.RegisteredTimeSeconds
  data.PaymentMultiplierByDemand = delivery.PaymentMultiplierByDemand
  data.PaymentMultiplierBySupply = delivery.PaymentMultiplierBySupply
  data.PaymentMultiplierByBalanceConfig = delivery.PaymentMultiplierByBalanceConfig
  -- data.Server_Cargos = delivery.Server_Cargos
  data.DeliveryFlags = delivery.DeliveryFlags
  data.TimerSeconds = delivery.TimerSeconds
  data.PathDistance = delivery.PathDistance
  data.PathClimbHeight = delivery.PathClimbHeight
  data.PathSpeedKPH = delivery.PathSpeedKPH

  return data
end

---Convert UMTPassengerComponent to table
---@param delivery UMTPassengerComponent
local function PassengerToTable(passenger)
  local data = {}

  data.Net_PassengerType = passenger.Net_PassengerType --EMTPassengerType
  --data.Net_BusPassengerParams = passenger.Net_BusPassengerParams --FMTBusPassengerParams
  data.Net_StartLocation = VectorToTable(passenger.Net_StartLocation) --FVector
  data.Net_DestinationLocation = VectorToTable(passenger.Net_DestinationLocation) --FVector
  data.Net_Distance = passenger.Net_Distance --float
  data.Net_Payment = passenger.Net_Payment --int64
  data.Net_PaymentPer100m = passenger.Net_PaymentPer100m --int64
  data.Net_PassengerFlags = passenger.Net_PassengerFlags --int32
  data.Net_bArrived = passenger.Net_bArrived --boolean
  --data.Net_GroupCharacters = passenger.Net_GroupCharacters --TArray<AMTCharacter>
  --data.InteractionMeshComponent = passenger.InteractionMeshComponent --UMTInteractionMeshComponent
  --data.InteractionComponent = passenger.InteractionComponent --UMTInteractableComponent
  --data.DestinationActor = passenger.DestinationActor --AMTInteractionMeshActor
  --data.PassengerMarker = passenger.PassengerMarker --AMTARMarker
  --data.DialogueComponent = passenger.DialogueComponent --UMTDialogueComponent
  --data.DialogueInteractionComponent = passenger.DialogueInteractionComponent --UMTInteractableComponent
  --data.Net_ReservedPlayerState = passenger.Net_ReservedPlayerState --AMotorTownPlayerState
  data.Net_TimeLimitToDestinationFromStart = passenger.Net_TimeLimitToDestinationFromStart --float
  data.Net_TimeLimitToDestination = passenger.Net_TimeLimitToDestination --float
  data.Net_TimeLimitPoint = passenger.Net_TimeLimitPoint --int32
  data.Net_LCComfortSatisfaction = passenger.Net_LCComfortSatisfaction --int32

  return data
end

local function TowRequestToTable(towRequest)
  local data = {}

  --data.DestinationActor = towRequest.DestinationActor --AMTInteractionMeshActor
  --data.Marker = towRequest.Marker --AMTARMarker
  data.Net_StartLocation = VectorToTable(towRequest.Net_StartLocation) --FVector
  data.Net_DestinationAbsoluteLocation = VectorToTable(towRequest.Net_DestinationAbsoluteLocation) --FVector
  data.Net_Payment = towRequest.Net_Payment --int64
  data.Net_bArrived = towRequest.Net_bArrived --boolean
  data.Net_TowRequestFlags = towRequest.Net_TowRequestFlags --int32
  --data.Net_LastWreckerPC = towRequest.Net_LastWreckerPC --AMotorTownPlayerController
  --data.Net_PoliceTowingVehicleDriverCharacterGuid = towRequest.Net_PoliceTowingVehicleDriverCharacterGuid --FGuid
  -- data.LastWrecker = towRequest.LastWrecker --AMTVehicle

  return data
end

---Convert FMTInventoryEntry to JSON serializable table
---@param entry FMTInventoryEntry
local function InventoryEntryToTable(entry)
  return {
    Amount = entry.Amount,
    CargoKey = entry.CargoKey:ToString(),
  }
end

---Convert DeliveryPoint to JSON serializable table
---@param point AMTDeliveryPoint
local function DeliveryPointToTable(point)
  if not point:IsValid() then
    return json.null
  end

  local data = {}

  data.DeliveryPointGuid = GuidToString(point.DeliveryPointGuid)
  data.MissionPointName = point.MissionPointName:ToString()
  data.DeliveryPointName = NameAndNumberToTable(point.DeliveryPointName)

  data.PointName = {}
  data.PointName.Texts = {} ---@type string[]
  point.PointName.Texts:ForEach(function(index, element)
    table.insert(data.PointName.Texts, element:get():ToString())
  end)

  data.PaymentMultiplier = point.PaymentMultiplier
  data.BasePayment = point.BasePayment
  data.MaxDeliveries = point.MaxDeliveries
  data.MaxPassiveDeliveries = point.MaxPassiveDeliveries
  data.MaxDeliveryDistance = point.MaxDeliveryDistance
  data.MaxDeliveryReceiveDistance = point.MaxDeliveryReceiveDistance
  data.MissionPointType = point.MissionPointType
  data.GameplayTags = GameplayTagContainerToString(point.GameplayTags)

  data.DestinationTypes = {} ---@type number[]
  -- for i = 1, #point.DestinationTypes, 1 do
  --   table.insert(data.DestinationTypes, point.DestinationTypes[i])
  -- end

  data.DestinationExcludeTypes = {} ---@type number[]
  -- for i = 1, #point.DestinationExcludeTypes, 1 do
  --   table.insert(data.DestinationExcludeTypes, point.DestinationExcludeTypes[i])
  -- end

  data.DestinationCargoLimits = {}
  point.DestinationCargoLimits:ForEach(function(index, element)
    table.insert(data.DestinationCargoLimits, DeliveryPointLimitToTable(element:get()))
  end)

  data.bUseAsDestinationInteraction = point.bUseAsDestinationInteraction

  data.ProductionConfigs = {}
  point.ProductionConfigs:ForEach(function(index, element)
    table.insert(data.ProductionConfigs, ProductionConfigToTable(element:get()))
  end)

  data.PassiveSupplies = {}
  point.PassiveSupplies:ForEach(function(index, element)
    table.insert(data.PassiveSupplies, DeliveryPassiveSuplyToTable(element:get()))
  end)

  data.DemandConfigs = {}
  point.DemandConfigs:ForEach(function(index, element)
    table.insert(data.DemandConfigs, DeliveryDemandToTable(element:get()))
  end)

  data.Supplies = {}
  point.Supplies:ForEach(function(key, value)
    data.Supplies[key:get()] = value:get()
  end)

  data.Demands = {}
  point.Demands:ForEach(function(key, value)
    data.Demands[key:get()] = value:get()
  end)

  data.DemandPriority = point.DemandPriority

  data.StorageConfigs = {}
  point.StorageConfigs:ForEach(function(index, element)
    table.insert(data.StorageConfigs, StorageConfigToTable(element:get()))
  end)

  data.MaxStorage = point.MaxStorage
  data.bConsumeContainer = point.bConsumeContainer

  data.InputInventoryShare = {}
  point.InputInventoryShare:ForEach(function(index, element)
    table.insert(data.InputInventoryShare, GuidToString(element:get().DeliveryPointGuid))
  end)

  data.InputInventoryShareTarget = {}
  point.InputInventoryShareTarget:ForEach(function(index, element)
    table.insert(data.InputInventoryShareTarget, GuidToString(element:get().DeliveryPointGuid))
  end)

  data.bIsSender = point.bIsSender
  data.bIsReceiver = point.bIsReceiver
  data.bRemoveUnusedInputCargo = point.bRemoveUnusedInputCargo
  data.bShowStorage = point.bShowStorage
  data.bLoadCargoBySpawnAtPoint = point.bLoadCargoBySpawnAtPoint
  -- data.ZoneVolume = point.ZoneVolume

  data.Net_Deliveries = {}
  point.Net_Deliveries:ForEach(function(index, element)
    table.insert(data.Net_Deliveries, DeliveryToTable(element:get()))
  end)

  -- data.Server_DeliveryGoods = point.Server_DeliveryGoods
  -- data.SenderMarker = point.SenderMarker
  data.Net_InputInventory = {}
  data.Net_InputInventory.Entries = {}
  point.Net_InputInventory.Entries:ForEach(function(index, element)
    table.insert(data.Net_InputInventory.Entries, InventoryEntryToTable(element:get()))
  end)

  data.Net_OutputInventory = {}
  data.Net_OutputInventory.Entries = {}
  point.Net_OutputInventory.Entries:ForEach(function(index, element)
    table.insert(data.Net_OutputInventory.Entries, InventoryEntryToTable(element:get()))
  end)

  data.Net_RuntimeFlags = point.Net_RuntimeFlags
  data.Net_ProductionBonusByProduction = point.Net_ProductionBonusByProduction
  data.Net_ProductionBonusByPopulation = point.Net_ProductionBonusByPopulation
  data.Net_ProductionLocalFoodSupply = point.Net_ProductionLocalFoodSupply

  return data
end

---Convert FMTCargoRepLocalMovement to JSON serializable table
---@param movement FMTCargoRepLocalMovement
local function CargoMovementToTable(movement)
  return {
    Location = VectorToTable(movement.Location),
    Quat = QuatToTable(movement.Quat),
    bIsValid = movement.bIsValid
  }
end

local function ContractToTable(contract)
  local data = {}
  data.Item = contract.Item:ToString()
  data.Amount = contract.Amount
  data.Cost = RewardToTable(contract.Cost)
  data.CompletionPayment = RewardToTable(contract.CompletionPayment)
  return data
end


---Convert AMTCargo to JSON serializable table
---@param cargo AMTCargo
local function CargoToTable(cargo)
  local data = {}

  data.bCanPickup = cargo.bCanPickup
  data.bCanAutoload = cargo.bCanAutoload
  data.Net_bIsAttachedDummy = cargo.Net_bIsAttachedDummy
  -- data.Mesh = cargo.Mesh
  -- data.CollisionResponse_NoSimulate = cargo.CollisionResponse_NoSimulate
  -- data.CollisionResponse_NoSimulateAttached = cargo.CollisionResponse_NoSimulateAttached
  -- data.DumpParticle = cargo.DumpParticle
  -- data.DumpSound = cargo.DumpSound
  data.EmptyContainerMass = cargo.EmptyContainerMass
  -- data.PickupSound = cargo.PickupSound
  -- data.HitSound = cargo.HitSound
  -- data.InteractableComponent = cargo.InteractableComponent
  -- data.Net_DroppedCargoSpace = cargo.Net_DroppedCargoSpace
  --data.Net_MovementOwnerPC = GetPlayerUniqueId(cargo.Net_MovementOwnerPC)
  --data.Server_ManualLoadingPaidPC = GetPlayerUniqueId(cargo.Server_ManualLoadingPaidPC)
  --data.Server_LastMovementOwnerPC = GetPlayerUniqueId(cargo.Server_LastMovementOwnerPC)

  data.Server_TempMovementOwnerPCs = {}
  --cargo.Server_TempMovementOwnerPCs:ForEach(function(key, value)
  --  data.Server_TempMovementOwnerPCs[GetPlayerUniqueId(key:get())] = value:get()
  --end)

  -- data.DestinationInteractionActor = cargo.DestinationInteractionActor
  data.Net_CargoKey = cargo.Net_CargoKey:ToString()
  data.Net_ColorIndex = cargo.Net_ColorIndex
  data.Net_Weight = cargo.Net_Weight
  data.Net_Damage = cargo.Net_Damage
  data.Net_CargoActorFlags = cargo.Net_CargoActorFlags
  -- data.Net_SenderActor = cargo.Net_SenderActor
  -- data.Net_DestinationActor = cargo.Net_DestinationActor
  data.Net_DeliveryId = cargo.Net_DeliveryId
  data.Net_bEnableSimulation = cargo.Net_bEnableSimulation
  data.Net_EnableCollision = cargo.Net_EnableCollision
  data.Net_DestinationLocation = VectorToTable(cargo.Net_DestinationLocation)
  data.Net_SenderAbsoluteLocation = VectorToTable(cargo.Net_SenderAbsoluteLocation)
  data.Net_SingleCargoPayment = RewardToTable(cargo.Net_SingleCargoPayment)
  data.Net_Payment = RewardToTable(cargo.Net_Payment)
  data.Net_SavedLifeTimeSeconds = cargo.Net_SavedLifeTimeSeconds
  data.Net_TimeLeftSeconds = cargo.Net_TimeLeftSeconds
  -- data.Net_CarrierComponent = cargo.Net_CarrierComponent
  -- data.Server_LastValidCarrierComponent = cargo.Server_LastValidCarrierComponent
  data.Net_LocalRepMovement = CargoMovementToTable(cargo.Net_LocalRepMovement)
  data.Net_bIsEmptyContainer = cargo.Net_bIsEmptyContainer
  data.Net_OwnerName = cargo.Net_OwnerName:ToString()
  -- data.Net_LastValidCarrierVehicle = cargo.Net_LastValidCarrierVehicle
  --data.DroppedMarker = VectorToTable(cargo.DroppedMarker:K2_GetActorLocation())
  --data.Marker = VectorToTable(cargo.Marker:K2_GetActorLocation())
  -- data.Net_Strap = cargo.Net_Strap
  data.Net_PickupTimeSeconds = cargo.Net_PickupTimeSeconds

  return data
end

---@param cargo AMTCargo
local function CargoToTableSummary(cargo)
  local data = {}

  data.EmptyContainerMass = cargo.EmptyContainerMass
  data.Net_CargoKey = cargo.Net_CargoKey:ToString()
  data.Net_Weight = cargo.Net_Weight
  data.Net_Damage = cargo.Net_Damage
  data.Net_CargoActorFlags = cargo.Net_CargoActorFlags
  data.Net_DeliveryId = cargo.Net_DeliveryId
  data.Net_DestinationLocation = VectorToTable(cargo.Net_DestinationLocation)
  data.Net_SenderAbsoluteLocation = VectorToTable(cargo.Net_SenderAbsoluteLocation)
  data.Net_Payment = RewardToTable(cargo.Net_Payment)
  data.Net_SavedLifeTimeSeconds = cargo.Net_SavedLifeTimeSeconds
  data.Net_TimeLeftSeconds = cargo.Net_TimeLeftSeconds
  data.Net_bIsEmptyContainer = cargo.Net_bIsEmptyContainer
  data.Net_PickupTimeSeconds = cargo.Net_PickupTimeSeconds

  return data
end

---Get delivery points
---@param guid string? Filter by delivery guid
---@param fields string[]? Filter by fields
---@param limit number? Limit the number of results
local function GetDeliveryPoints(guid, fields, limit)
  local deliverySystem = GetDeliverySystem()
  local arr = {} ---@type table[]

  if deliverySystem:IsValid() then
    for i = 1, #deliverySystem.DeliveryPoints, 1 do
      local deliveryPoint = deliverySystem.DeliveryPoints[i]
      if deliveryPoint:IsValid() then
        -- Filter by guid
        if guid and guid:upper() ~= GuidToString(deliveryPoint.DeliveryPointGuid) then
          goto continue
        end

        local point = DeliveryPointToTable(deliverySystem.DeliveryPoints[i])
        local filtered = {}

        if fields then
          for j = 1, #fields, 1 do
            if not point[fields[j]] then
              error("Field " .. fields[j] .. " does not exist")
            end

            filtered[fields[j]] = point[fields[j]]
          end
          -- Always returns the delivery point guid
          filtered.DeliveryPointGuid = point.DeliveryPointGuid

          table.insert(arr, filtered)
        else
          table.insert(arr, point)
        end

        -- Limit result if set
        if limit and #arr >= limit then
          return arr
        end

        ::continue::
      end
    end
  end
  return arr
end

-- Register event hooks

webhook.RegisterEventHook(
  "ServerAcceptDelivery",
  function(PC, DeliveryId)
    return {
      PlayerId = GetPlayerUniqueId(PC),
      DeliveryId = DeliveryId,
    }
  end
)

webhook.RegisterEventHook(
  "ServerCargoArrived",
  function (PC, cargos)
    local characterGuid = GetPlayerGuid(PC)
    local data = {}
    cargos:ForEach(function(key, value)
      local cargo = value:get()
      if cargo ~= nil and cargo:IsValid() then
        table.insert(data, CargoToTableSummary(cargo))
      end
    end)

    return {
      CharacterGuid = characterGuid,
      Cargos = data
    }
  end
)

webhook.RegisterEventHook(
  "ServerCargoDumped",
  function (PC, cargo)
    local playerId = GetPlayerUniqueId(PC)
    return {
      PlayerId = playerId,
      Cargo = CargoToTableSummary(cargo)
    }
  end
)

webhook.RegisterEventHook(
  "ServerSignContract",
  function (PC, contract, companyGuid)
    local playerId = GetPlayerUniqueId(PC)
    local company = nil
    PC.Companies:ForEach(function(key, value)
      local _company = value:get()
      if company ~= nil and _company:IsValid() and GuidToString(_company.Guid) == GuidToString(companyGuid) then
        company = _company
      end
    end)

    local contractGuid = nil
    if company ~= nil then
      company.ContractsInProgress:ForEach(function(key, value)
        local cip = value:get()
        if cip ~= nil and cip:IsValid() and cip.Contract == contract then
          contractGuid = GuidToString(cip.Guid)
        end
      end)
    end

    return {
      PlayerId = playerId,
      Contract = ContractToTable(contract),
      contractGuid = contractGuid,
    }
  end
)

webhook.RegisterEventHook(
  "ServerContractCargoDelivered",
  function (PC, contractGuid)
    local characterGuid = GetPlayerGuid(PC)
    local contract = nil
    local finishedAmount = 0
    PC.Companies:ForEach(function(key, value)
      local company = value:get()
      if company ~= nil and company:IsValid() and company.ContractsInProgress:IsValid() then
        company.ContractsInProgress:ForEach(function(key, value)
          local cip = value:get()
          if cip ~= nil and cip:IsValid() and GuidToString(cip.Guid) == GuidToString(contractGuid) and cip.Contract:IsValid() then
            contract = ContractToTable(cip.Contract)
            finishedAmount = cip.FinishedAmount
          end
        end)
      end
    end)
    if contract == nil then
      return {}
    end

    return {
      CharacterGuid = characterGuid,
      ContractGuid = GuidToString(contractGuid),
      Contract = contract,
      FinishedAmount = finishedAmount,
    }
  end
)

webhook.RegisterEventHook(
  "ServerPassengerArrived",
  function (PC, passenger)
    local characterGuid = GetPlayerGuid(PC)
    local data = PassengerToTable(passenger)
    return {
      CharacterGuid = characterGuid,
      Passenger = data
    }
  end
)

webhook.RegisterEventHook(
  "ServerTowRequestArrived",
  function (PC, towRequest)
    local characterGuid = GetPlayerGuid(PC)
    local data = TowRequestToTable(towRequest)
    return {
      CharacterGuid = characterGuid,
      TowRequest = data
    }
  end
)

-- HTTP request handlers

---Handle GetDeliveryPoints request
---@type RequestPathHandler
local function HandleGetDeliveryPoints(session)
  local guid = session.pathComponents[3]
  local limit = nil ---@type number?

  if session.queryComponents.limit then
    limit = tonumber(session.queryComponents.limit)
  end

  local rawFilters = session.queryComponents.filters
  local filters = SplitString(rawFilters, ",")

  local data = GetDeliveryPoints(guid, filters, limit)
  if guid and #data == 0 then
    return json.stringify { message = string.format("Delivery point %s not found", guid) }, nil, 404
  end
  return json.stringify {
    data = data
  }
end

return {
  HandleGetDeliveryPoints = HandleGetDeliveryPoints,
  CargoToTable = CargoToTable
}
