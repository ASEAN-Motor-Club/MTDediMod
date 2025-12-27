local json = require("JsonParser")
local webhook = require("Webclient")

---Convert player state to JSON serializable table
---@param playerState AMotorTownPlayerState
local function PlayerStateToTable(playerState)
  local data = {}

  if playerState:IsValid() then
    data.UniqueID = GetUniqueNetIdAsString(playerState)

    data.PlayerName = playerState:GetPlayerName():ToString()
    data.GridIndex = playerState.GridIndex
    data.bIsHost = playerState.bIsHost
    data.bIsAdmin = playerState.bIsAdmin
    data.CharacterGuid = GuidToString(playerState.CharacterGuid)
    data.BestLapTime = playerState.BestLapTime

    data.Levels = {}
    playerState.Layers:ForEach(function(index, element)
      table.insert(data.Levels, element:get())
    end)

    data.OwnCompanyGuid = GuidToString(playerState.OwnCompanyGuid)
    data.JoinedCompanyGuid = GuidToString(playerState.JoinedCompanyGuid)
    data.CustomDestinationAbsoluteLocation = VectorToTable(playerState.CustomDestinationAbsoluteLocation)

    data.OwnEventGuids = {}
    playerState.OwnEventGuids:ForEach(function(index, element)
      table.insert(data.OwnEventGuids, GuidToString(element:get()))
    end)

    data.JoinedEventGuids = {}
    playerState.JoinedEventGuids:ForEach(function(index, element)
      table.insert(data.JoinedEventGuids, GuidToString(element:get()))
    end)

    data.Location = VectorToTable(playerState.Location)
    data.VehicleKey = playerState.VehicleKey:ToString()
  end

  return data
end

---Get all or selected player state(s)
---@param uniqueId string? Filter by player state unique net ID
---@return table[]
local function GetPlayerStates(uniqueId)
  local gameState = GetMotorTownGameState()
  local arr = {}

  if not gameState:IsValid() then return arr end

  local playerStates = gameState.PlayerArray

  LogOutput("DEBUG", "%i player state(s) found", #playerStates)

  for i = 1, #gameState.PlayerArray, 1 do
    local playerState = gameState.PlayerArray[i]
    if playerState:IsValid() then
      ---@cast playerState AMotorTownPlayerState

      local data = PlayerStateToTable(playerState)

      -- Filter by uniqueId if provided
      if uniqueId and uniqueId ~= data.UniqueID then goto continue end

      table.insert(arr, data)

      ::continue::
    end
  end
  return arr
end


---TransferMoneyToPlayer
---@param uniqueId string? Filter by player state unique net ID
---@param amount int The amount to transfer (potentially negative)
---@param message str The message that comes with the transfer
---@return bool
local function TransferMoneyToPlayer(uniqueId, amount, message)
  local PC = GetPlayerControllerFromUniqueId(uniqueId)
  if PC == nil or not PC:IsValid() then return false end
  LogOutput("INFO", "TransferMoneyToPlayer")
  ExecuteInGameThreadSync(function()
    if PC:IsValid() then
      PC:ClientAddMoney(amount, 'Context', FText(message), true, 'Context', 'Context')
    end
  end)
  return true
end

local function TransferMoneyToCharacter(characterGuid, amount, message)
  local PC = GetPlayerControllerFromGuid(characterGuid)
  if PC == nil or not PC:IsValid() then return false end
  LogOutput("INFO", "TransferMoneyToPlayer")
  ExecuteInGameThreadSync(function()
    if PC:IsValid() then
      PC:ClientAddMoney(amount, '', FText(message), true, '', '')
    end
  end)
  return true
end


local function PlayerSendChat(uniqueId, message)
  local PC = GetPlayerControllerFromUniqueId(uniqueId)
  if not PC:IsValid() then return false end
  LogOutput("INFO", "PlayerSendChat")
  ExecuteInGameThread(function()
    PC:ServerSendChat(message, 0)
  end)
  return true
end


---Get my current pawn transform
---@return FVector? location
---@return FRotator? rotation
local function GetMyCurrentTransform()
  local PC = GetMyPlayerController()
  if PC:IsValid() then
    local pawn = PC:K2_GetPawn()
    if pawn:IsValid() then
      local location = pawn:K2_GetActorLocation()
      local rotation = pawn:K2_GetActorRotation()
      return location, rotation
    end
  end
  return nil, nil
end

-- Console commands

RegisterConsoleCommandHandler("getplayers", function(Cmd, CommandParts, Ar)
  local playerStates = json.stringify(GetPlayerStates(CommandParts[1]))
  LogOutput("INFO", playerStates)
  return true
end)

RegisterConsoleCommandHandler("getplayertransform", function(Cmd, CommandParts, Ar)
  local location, rotation = GetMyCurrentTransform()
  LogOutput("INFO", "Actor transform: %s", json.stringify({ Location = location, Rotation = rotation }))
  return true
end)

-- HTTP request handlers

---Handle request for player states
---@type RequestPathHandler
local function HandleGetPlayerStates(session)
  local playerId = session.pathComponents[2]
  local res = GetPlayerStates(playerId)
  if playerId and #res == 0 then
    return json.stringify { message = string.format("Player with unique ID %s not found", playerId) }, nil, 404
  end

  return json.stringify { data = res }, nil, 200
end

---Handle request to teleport player
---@type RequestPathHandler
local function HandleTransferMoneyToPlayer(session)
  local playerId = session.pathComponents[2]
  if not playerId then
    return json.stringify { error = string.format("Invalid player ID %s", playerId) }, nil, 400
  end

  local data = json.parse(session.content)
  if data and data.Amount and data.Message and data.CharacterGuid then
    TransferMoneyToPlayer(data.CharacterGuid, data.Amount, data.Message)
    return nil, nil, 200
  end
  if data and data.Amount and data.Message then
    TransferMoneyToPlayer(playerId, data.Amount, data.Message)
    return nil, nil, 200
  end
  return json.stringify { error = "Invalid payload" }, nil, 400
end

local function HandleSetPlayerName(session)
  local characterGuid = session.pathComponents[2]
  if not characterGuid then
    return json.stringify { error = string.format("Invalid character guid %s", characterGuid) }, nil, 400
  end

  local data = json.parse(session.content)
  if data and data.name then
    local PC = GetPlayerControllerFromGuid(characterGuid)
    if not PC:IsValid() or not PC.PlayerState:IsValid() then
      return json.stringify { error = string.format("Invalid player controller %s", characterGuid) }, nil, 400
    end
    PC.PlayerState.PlayerNamePrivate = data.name
    PC:SetName(data.name)

    return nil, nil, 200
  end
  return json.stringify { error = "Invalid payload" }, nil, 400
end

local function HandlePlayerSendChat(session)
  local playerId = session.pathComponents[2]
  if not playerId then
    return json.stringify { error = string.format("Invalid player ID %s", playerId) }, nil, 400
  end

  local data = json.parse(session.content)
  if data and data.Message then
    PlayerSendChat(playerId, data.Message)
    return nil, nil, 204
  end
  return json.stringify { error = "Invalid payload" }, nil, 400
end

local mutedPlayers = {}

local function HandleMutePlayer(session)
  local playerId = session.pathComponents[2]
  if not playerId then
    return json.stringify { error = string.format("Invalid player ID %s", playerId) }, nil, 400
  end

  local data = json.parse(session.content)
  if data and data.MuteUntil then
    mutedPlayers[playerId] = data.MuteUntil
    return nil, nil, 204
  end
  return json.stringify { error = "Invalid payload" }, nil, 400
end


---Handle request to teleport player
---@type RequestPathHandler
local function HandleTeleportPlayer(session)
  local playerId = session.pathComponents[2]
  local data = json.parse(session.content)

  if data and data.Location then
    ---@type FVector
    local location = { X = data.Location.X, Y = data.Location.Y, Z = data.Location.Z }
    ---@type FRotator
    local rotation = {
      Roll = data.Rotation and data.Rotation.Roll or 0.0,
      Pitch = data.Rotation and data.Rotation.Pitch or 0.0,
      Yaw = data.Rotation and data.Rotation.Yaw or 0.0
    }

    if playerId then
      local PC = GetPlayerControllerFromUniqueId(playerId)
      ---@cast PC AMotorTownPlayerController

      if PC:IsValid() then
        local pawn = PC:K2_GetPawn()
        if pawn:IsValid() then
          LogOutput("DEBUG", "pawn: %s", pawn:GetFullName())
          local charClass = StaticFindObject("/Script/MotorTown.MTCharacter")
          ---@cast charClass UClass
          local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
          ---@cast vehicleClass UClass

          ExecuteInGameThreadSync(function()
            if not pawn:IsValid() then
              return
            end
            if pawn:IsA(charClass) then
              PC:ServerTeleportCharacter(location, false, false)
            elseif pawn:IsA(vehicleClass) and data.NoVehicles then
              return json.stringify { error = string.format("Failed to teleport player %s: Player is inside a vehicle", playerId) }, nil, 400
            elseif pawn:IsA(vehicleClass) then
              ---@cast pawn AMTVehicle
              PC:ServerResetVehicleAt(pawn, location, rotation, true, true)
            else
              error("Failed to teleport player")
            end
          end)

          local msg = string.format("Teleported player %s to %s", playerId, json.stringify(location))
          return json.stringify { status = msg }
        end
      end
      return json.stringify { error = string.format("Failed to teleport player %s", playerId) }, nil, 400
    end
    return json.stringify { error = string.format("Invalid player ID %s", playerId) }, nil, 400
  end
  return json.stringify { error = "Invalid payload" }, nil, 400
end


return {
  HandleGetPlayerStates = HandleGetPlayerStates,
  GetMyCurrentTransform = GetMyCurrentTransform,
  PlayerStateToTable = PlayerStateToTable,
  HandleTeleportPlayer = HandleTeleportPlayer,
  HandleTransferMoneyToPlayer = HandleTransferMoneyToPlayer,
  HandleSetPlayerName = HandleSetPlayerName,
  HandlePlayerSendChat = HandlePlayerSendChat,
  HandleMutePlayer = HandleMutePlayer,
}
