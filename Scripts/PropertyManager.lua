local UEHelper = require("UEHelpers")
local json = require("JsonParser")
local socket = require("socket")
local assetManager = require("AssetManager")

---@param houseGuid string
---@return AMTHouse?
local function FindHouseByGuid(houseGuid)
  local gameState = GetMotorTownGameState()
  if not gameState:IsValid() then return nil end

  for i = 1, #gameState.Houses do
    local house = gameState.Houses[i]
    if house:IsValid() and GuidToString(house.HouseGuid) == houseGuid:upper() then
      return house
    end
  end
  return nil
end

---@param characterGuid string
---@return AMotorTownPlayerController?
local function FindOnlinePCByCharacterGuid(characterGuid)
  local gameState = GetMotorTownGameState()
  if not gameState:IsValid() then return nil end

  for i = 1, #gameState.PlayerArray do
    local ps = gameState.PlayerArray[i]
    ---@cast ps AMotorTownPlayerState
    if ps:IsValid() and GuidToString(ps.CharacterGuid) == characterGuid then
      local pc = ps:GetPlayerController()
      if pc:IsValid() then return pc end
    end
  end
  return nil
end

---Convert house to JSON serializable table
---@param house AMTHouse
local function HouseToTable(house)
  local data = {}

  data.AreaSize = VectorToTable(house.AreaSize)
  data.FenceStep = house.FenceStep
  data.HousegKey = house.HousegKey:ToString()
  data.HouseGuid = GuidToString(house.HouseGuid)
  data.Net_OwnerUniqueNetId = house.Net_OwnerUniqueNetId:ToString()
  data.Net_OwnerCharacterGuid = GuidToString(house.Net_OwnerCharacterGuid)
  data.Net_OwnerName = house.Net_OwnerName:ToString()
  data.Net_RentLeftTimeSeconds = house.Net_RentLeftTimeSeconds
  data.ForSale = house.ForSale:IsValid()
  data.Teleport = nil
  data.Location = VectorToTable(house:K2_GetActorLocation())
  data.Rotation = RotatorToTable(house:K2_GetActorRotation())

  if house.Teleport:IsValid() then
    data.Teleport = VectorToTable(house.Teleport:K2_GetActorLocation())
  end

  return data
end

---Get all houses
---@param guid string? Filter by house GUID
---@return table[]
local function GetHouses(guid)
  local gameState = GetMotorTownGameState()
  local arr = {}

  if gameState:IsValid() then
    for i = 1, #gameState.Houses do
      local house = gameState.Houses[i]

      if guid and guid:upper() ~= GuidToString(house.HouseGuid) then
        goto continue
      end

      table.insert(arr, HouseToTable(house))

      :: continue ::
    end
  end

  return arr
end

---Create a house at specified location
---@param location FVector
---@param rotation FRotator
---@param houseParam { AreaSize: FVector, HouseKey: string, HouseGuid: string }
---@return boolean Status
---@return string? HouseGuid
local function SpawnHouse(location, rotation, houseParam)
  local housePath = "/Game/Objects/Housing/House.House_C"
  local gameState = GetMotorTownGameState()
  local status, assetTag, actor = assetManager.SpawnActor(housePath, location, rotation)

  if status and actor and actor:IsValid() and gameState:IsValid() then
    ---@cast actor AMTHouse

    actor.AreaSize = houseParam.AreaSize
    actor.HousegKey = FName(houseParam.HouseKey)
    actor.HouseGuid = StringToGuid(houseParam.HouseGuid)

    local guid = GuidToString(actor.HouseGuid)
    actor.Tags[#actor.Tags + 1] = FName(guid)

    LogOutput("INFO", "Spawned a new house: %s", actor:GetFullName())
    gameState.Houses[#gameState.Houses + 1] = actor

    return true, guid
  end
  return false
end

-- HTTP request handlers

---Handle request for all houses
---@type RequestPathHandler
local function HandleGetHouses(session)
  local guid = session.pathComponents[2]

  local houses = GetHouses(guid)
  return json.stringify { data = houses }
end

---Handle request for spawning a new house for sale
---@type RequestPathHandler
local function HandleSpawnHouse(session)
  local data = json.parse(session.content)

  if data ~= nil and data.Location and data.Rotation and data.HouseParam then
    local status, guid = SpawnHouse(data.Location, data.Rotation, data.HouseParam)
    if status and guid then
      return json.stringify { data = { HouseGuid = guid } }, nil, 201
    end
  end

  return nil, nil, 400
end

local function HandleTransferHouseDirect(session)
  local houseGuid = session.pathComponents[2]
  if not houseGuid then
    return json.stringify { error = "Missing house GUID" }, nil, 400
  end

  local data = json.parse(session.content)
  if not data or not data.NewOwnerCharacterGuid then
    return json.stringify { error = "Missing NewOwnerCharacterGuid in payload" }, nil, 400
  end

  local resultMsg = "not_executed"
  ExecuteInGameThreadSync(function()
    local ok, err = pcall(function()
      local house = FindHouseByGuid(houseGuid)
      if not house then resultMsg = "house_not_found"; return end

      local newOwnerPC = FindOnlinePCByCharacterGuid(data.NewOwnerCharacterGuid)
      if not newOwnerPC or not newOwnerPC:IsValid() then
        resultMsg = "new_owner_offline"; return
      end

      local newOwnerPS = newOwnerPC.PlayerState
      ---@cast newOwnerPS AMotorTownPlayerState
      if not newOwnerPS:IsValid() then
        resultMsg = "new_owner_ps_invalid"; return
      end

      local newUniqueId = GetUniqueNetIdAsString(newOwnerPS) or ""
      local newName = newOwnerPS:GetPlayerName():ToString()
      local newCharGuid = newOwnerPS.CharacterGuid

      house.Net_OwnerUniqueNetId = newUniqueId
      house.Net_OwnerCharacterGuid = newCharGuid
      house.Net_OwnerName = newName

      resultMsg = "success"
    end)
    if not ok then resultMsg = "error: " .. tostring(err) end
  end, "HandleTransferHouseDirect")

  return json.stringify { status = resultMsg }, nil, 200
end

local function HandleTransferHouseDirectExtend(session)
  local houseGuid = session.pathComponents[2]
  if not houseGuid then
    return json.stringify { error = "Missing house GUID" }, nil, 400
  end

  local data = json.parse(session.content)
  if not data or not data.NewOwnerCharacterGuid then
    return json.stringify { error = "Missing NewOwnerCharacterGuid in payload" }, nil, 400
  end

  local resultMsg = "not_executed"
  ExecuteInGameThreadSync(function()
    local ok, err = pcall(function()
      local house = FindHouseByGuid(houseGuid)
      if not house then resultMsg = "house_not_found"; return end

      local rentLeft = house.Net_RentLeftTimeSeconds

      local newOwnerPC = FindOnlinePCByCharacterGuid(data.NewOwnerCharacterGuid)
      if not newOwnerPC or not newOwnerPC:IsValid() then
        resultMsg = "new_owner_offline"; return
      end

      local newOwnerPS = newOwnerPC.PlayerState
      ---@cast newOwnerPS AMotorTownPlayerState
      if not newOwnerPS:IsValid() then
        resultMsg = "new_owner_ps_invalid"; return
      end

      local newUniqueId = GetUniqueNetIdAsString(newOwnerPS) or ""
      local newName = newOwnerPS:GetPlayerName():ToString()
      local newCharGuid = newOwnerPS.CharacterGuid

      house.Net_OwnerUniqueNetId = newUniqueId
      house.Net_OwnerCharacterGuid = newCharGuid
      house.Net_OwnerName = newName

      if rentLeft > 0 then
        newOwnerPC:ServerRentExtendHouse(house, 0, rentLeft)
      end

      resultMsg = "success"
    end)
    if not ok then resultMsg = "error: " .. tostring(err) end
  end, "HandleTransferHouseDirectExtend")

  return json.stringify { status = resultMsg }, nil, 200
end

local function HandleExtendHouseRent(session)
  local houseGuid = session.pathComponents[2]
  if not houseGuid then
    return json.stringify { error = "Missing house GUID" }, nil, 400
  end

  local data = json.parse(session.content)
  if not data or not data.Seconds then
    return json.stringify { error = "Missing Seconds in payload" }, nil, 400
  end

  local resultMsg = "not_executed"
  ExecuteInGameThreadSync(function()
    local ok, err = pcall(function()
      local house = FindHouseByGuid(houseGuid)
      if not house then resultMsg = "house_not_found"; return end

      house.Net_RentLeftTimeSeconds = house.Net_RentLeftTimeSeconds + data.Seconds
      resultMsg = "success"
    end)
    if not ok then resultMsg = "error: " .. tostring(err) end
  end, "HandleExtendHouseRent")

  return json.stringify { status = resultMsg }, nil, 200
end

return {
  HandleGetHouses = HandleGetHouses,
  HandleSpawnHouse = HandleSpawnHouse,
  HandleTransferHouseDirect = HandleTransferHouseDirect,
  HandleTransferHouseDirectExtend = HandleTransferHouseDirectExtend,
  HandleExtendHouseRent = HandleExtendHouseRent
}
