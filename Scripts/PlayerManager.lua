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
    local pawn = playerState:GetPawn()
    if pawn:IsValid() then
      data.Rotation = RotatorToTable(pawn:K2_GetActorRotation())
    end
    data.VehicleKey = playerState.VehicleKey:ToString()
    data.bAFK = playerState.Net_bAFK
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
---@param uniqueId string Filter by player state unique net ID
---@param amount integer The amount to transfer (potentially negative)
---@param message string The message that comes with the transfer
---@return boolean
local function TransferMoneyToPlayer(uniqueId, amount, message)
  local PC = GetPlayerControllerFromUniqueId(uniqueId)
  if PC == nil or not PC:IsValid() then return false end
  LogOutput("INFO", "TransferMoneyToPlayer")
  ExecuteInGameThreadSync(function()
    if PC:IsValid() then
      ---@diagnostic disable-next-line: param-type-mismatch
      PC:ClientAddMoney(amount, 'Context', FText(message), true, 'Context', 'Context')
    end
  end, "TransferMoneyToPlayer")
  return true
end

local function TransferMoneyToCharacter(characterGuid, amount, message)
  local PC = GetPlayerControllerFromGuid(characterGuid)
  if PC == nil or not PC:IsValid() then return false end
  LogOutput("INFO", "TransferMoneyToPlayer")
  ExecuteInGameThreadSync(function()
    if PC:IsValid() then
      ---@diagnostic disable-next-line: param-type-mismatch
      PC:ClientAddMoney(amount, '', FText(message), true, '', '')
    end
  end, "TransferMoneyToCharacter")
  return true
end


local function PlayerSendChat(uniqueId, message)
  local PC = GetPlayerControllerFromUniqueId(uniqueId)
  ExecuteInGameThreadSync(function()
    LogOutput("INFO", "PlayerSendChat")
    if PC:IsValid() then
      PC:ServerSendChat(message, 0)
    end
  end, "PlayerSendChat")
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
    ExecuteInGameThreadSync(function()
      if PC:IsValid() and PC.PlayerState:IsValid() then
        PC.PlayerState.PlayerNamePrivate = data.name
        PC:SetName(data.name)
      end
    end, "HandleSetPlayerName")

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
              if data.Force then
                -- Bypass Motor Town's native suspect check which blocks
                -- ServerTeleportCharacter for suspects with a popup.
                -- K2_SetActorLocation moves the pawn server-side, then
                -- ClientTeleportedCharacter notifies the owning client
                -- (camera reset, loading screen, etc.) — mimicking what
                -- ServerTeleportCharacter does internally sans suspect gate.
                pawn:K2_SetActorLocation(location, false, {}, true)
                PC:ClientTeleportedCharacter(location)
              else
                PC:ServerTeleportCharacter(location, false, false)
              end
            elseif pawn:IsA(vehicleClass) and data.NoVehicles then
              return json.stringify { error = string.format("Failed to teleport player %s: Player is inside a vehicle", playerId) }, nil, 400
            elseif pawn:IsA(vehicleClass) then
              ---@cast pawn AMTVehicle
              local bResetTrailers = true
              if data.bResetTrailers ~= nil then
                bResetTrailers = data.bResetTrailers
              end
              local bResetCarriedVehicles = true
              if data.bResetCarriedVehicles ~= nil then
                bResetCarriedVehicles = data.bResetCarriedVehicles
              end
              PC:ClientResetVehicleAt(pawn, location, rotation, bResetTrailers, bResetCarriedVehicles)
            else
              error("Failed to teleport player")
            end
          end, "HandleTeleportPlayer")

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

---Get all current parties
---@return table[]
local function GetParties()
  local gameState = GetMotorTownGameState()
  local arr = {}
  if not gameState:IsValid() then return arr end

  for i = 1, #gameState.Net_Parties do
    local party = gameState.Net_Parties[i]
    local players = {}
    for j = 1, #party.Players do
      local ps = party.Players[j]
      ---@cast ps AMotorTownPlayerState
      if ps:IsValid() then
        table.insert(players, GuidToString(ps.CharacterGuid))
      end
    end
    if #players > 0 then
      table.insert(arr, {
        PartyId = party.PartyId,
        Players = players,
      })
    end
  end
  return arr
end

---Handle request for parties
---@type RequestPathHandler
local function HandleGetParties(session)
  return json.stringify { data = GetParties() }, nil, 200
end

---Handle request to make a player a suspect
---@type RequestPathHandler
local function HandleMakePlayerSuspect(session)
  local characterGuid = session.pathComponents[2]
  if not characterGuid then
    return json.stringify { error = "Missing character GUID" }, nil, 400
  end

  local data = json.parse(session.content)
  local durationSeconds = (data and data.DurationSeconds) or 300

  local PC = GetPlayerControllerFromGuid(characterGuid)
  if not PC:IsValid() then
    return json.stringify { error = string.format("Player %s not found", characterGuid) }, nil, 404
  end

  local charClass = StaticFindObject("/Script/MotorTown.MTCharacter")
  ---@cast charClass UClass

  local resultMsg = "not_executed"
  ExecuteInGameThreadSync(function()
    local ok, err = pcall(function()
      if not PC:IsValid() then resultMsg = "pc_invalid"; return end

      -- Get the AMTCharacter
      local character = PC.Net_MyDrivingCharacter
      if not character or not character:IsValid() then
        character = PC:K2_GetPawn()
      end
      if not character or not character:IsValid() then resultMsg = "char_not_found"; return end

      -- Only test C++ AddPoliceSuspect (buff logic removed for debugging)
      local gameState = GetMotorTownGameState()
      if gameState:IsValid() and gameState.Net_Police:IsValid() then
        local success = AddPoliceSuspect(gameState.Net_Police, character)
        resultMsg = "suspects=" .. tostring(success)
      else
        resultMsg = "police_not_found"
      end
    end)
    if not ok then
      resultMsg = "error: " .. tostring(err)
    end
  end)

  return json.stringify { status = resultMsg }, nil, 200
end

---Diagnostic: peek into Net_Suspects and police state
---@type RequestHandler
local function HandleGetPoliceState()
  local result = { suspects = {}, police_valid = false }

  ExecuteInGameThreadSync(function()
    local ok, err = pcall(function()
      local gameState = GetMotorTownGameState()
      if not gameState:IsValid() then return end

      result.police_valid = gameState.Net_Police:IsValid()
      if not result.police_valid then return end

      local police = gameState.Net_Police
      police.Net_Suspects:ForEach(function(index, suspect)
        local entry = {
          index = index,
          bOutOfSight = suspect.bOutOfSight,
        }
        if suspect.Character:IsValid() then
          entry.character_class = suspect.Character:GetClass():GetFName():ToString()
          local loc = suspect.LastSeenLocation
          entry.location = { x = loc.X, y = loc.Y, z = loc.Z }
        else
          entry.character = "invalid"
        end
        -- Read ViolationTags
        entry.tags = {}
        suspect.ViolationTags.GameplayTags:ForEach(function(i, tag)
          entry.tags[i] = tag.TagName:ToString()
        end)
        result.suspects[#result.suspects + 1] = entry
      end)
    end)
    if not ok then
      result.error = tostring(err)
    end
  end)

  return json.stringify(result), nil, 200
end

---Experimental endpoint to hide actor and disable collision
---@type RequestPathHandler
local function HandleExperimentalHideActor(session)
  local characterGuid = session.pathComponents[2]
  if not characterGuid then
    return json.stringify { error = "Missing character GUID" }, nil, 400
  end

  local data = json.parse(session.content)
  local hide = true
  if data and data.hidden ~= nil then
    hide = data.hidden
  end

  local resultMsg = "not_executed"
  ExecuteInGameThreadSync(function()
    local PC = GetPlayerControllerFromGuid(characterGuid)
    if PC:IsValid() then
      local pawn = PC:K2_GetPawn()
      if pawn:IsValid() then
        pawn:SetActorHiddenInGame(hide)
        pawn:SetActorEnableCollision(not hide)
        resultMsg = "success: hidden=" .. tostring(hide)
      else
        resultMsg = "pawn_invalid"
      end
    else
      resultMsg = "pc_invalid"
    end
  end, "HandleExperimentalHideActor")

  return json.stringify { status = resultMsg }, nil, 200
end

---Experimental endpoint to hide costume using MotorTown API
---@type RequestPathHandler
local function HandleExperimentalHideCostume(session)
  local characterGuid = session.pathComponents[2]
  if not characterGuid then
    return json.stringify { error = "Missing character GUID" }, nil, 400
  end

  local data = json.parse(session.content)
  local hide = true
  if data and data.hide_costume ~= nil then
    hide = data.hide_costume
  end

  local resultMsg = "not_executed"
  ExecuteInGameThreadSync(function()
    local PC = GetPlayerControllerFromGuid(characterGuid)
    if PC:IsValid() then
      local character = PC:K2_GetPawn()
      if character:IsValid() and character:IsA(StaticFindObject("/Script/MotorTown.MTCharacter")) then
        ---@cast character AMTCharacter
        character:ServerHideCostume(hide)
        resultMsg = "success: hide_costume=" .. tostring(hide)
      else
        resultMsg = "char_invalid"
      end
    else
      resultMsg = "pc_invalid"
    end
  end, "HandleExperimentalHideCostume")

  return json.stringify { status = resultMsg }, nil, 200
end

---Experimental endpoint to manipulate Ghost flag
---@type RequestPathHandler
local function HandleExperimentalGhostFlag(session)
  local characterGuid = session.pathComponents[2]
  if not characterGuid then
    return json.stringify { error = "Missing character GUID" }, nil, 400
  end

  local data = json.parse(session.content)
  local ghost = true
  if data and data.ghost ~= nil then
    ghost = data.ghost
  end

  local resultMsg = "not_executed"
  ExecuteInGameThreadSync(function()
    local PC = GetPlayerControllerFromGuid(characterGuid)
    if PC:IsValid() then
      local character = PC:K2_GetPawn()
      if character:IsValid() and character:IsA(StaticFindObject("/Script/MotorTown.MTCharacter")) then
        ---@cast character AMTCharacter
        local flags = character.Net_CharacterFlags
        -- 4 is EMTCharacterFlags.Ghost
        if ghost then
          flags = flags | 4
        else
          flags = flags & ~4
        end
        character.Net_CharacterFlags = flags
        resultMsg = "success: ghost=" .. tostring(ghost)
      else
        resultMsg = "char_invalid"
      end
    else
      resultMsg = "pc_invalid"
    end
  end, "HandleExperimentalGhostFlag")

  return json.stringify { status = resultMsg }, nil, 200
end

---Experimental endpoint to spectate target player
---@type RequestPathHandler
local function HandleExperimentalSpectate(session)
  local callerGuid = session.pathComponents[2]
  if not callerGuid then
    return json.stringify { error = "Missing caller character GUID" }, nil, 400
  end

  local data = json.parse(session.content)
  if not data or not data.target_guid then
     return json.stringify { error = "Missing target_guid in payload" }, nil, 400
  end
  local targetGuid = data.target_guid

  local resultMsg = "not_executed"
  ExecuteInGameThreadSync(function()
    local PC = GetPlayerControllerFromGuid(callerGuid)
    local targetPC = GetPlayerControllerFromGuid(targetGuid)
    
    if PC:IsValid() and targetPC:IsValid() then
      local targetPS = targetPC.PlayerState
      if targetPS:IsValid() and targetPS:IsA(StaticFindObject("/Script/MotorTown.MotorTownPlayerState")) then
        ---@cast PC AMotorTownPlayerController
        ---@cast targetPS AMotorTownPlayerState
        PC:ServerStartSpectatingPlayer(targetPS)
        resultMsg = "success: spectating " .. tostring(targetGuid)
      else
        resultMsg = "target_ps_invalid"
      end
    else
      resultMsg = "pc_invalid"
    end
  end, "HandleExperimentalSpectate")

  return json.stringify { status = resultMsg }, nil, 200
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
  HandleGetParties = HandleGetParties,
  HandleMakePlayerSuspect = HandleMakePlayerSuspect,
  HandleGetPoliceState = HandleGetPoliceState,
  HandleExperimentalHideActor = HandleExperimentalHideActor,
  HandleExperimentalHideCostume = HandleExperimentalHideCostume,
  HandleExperimentalGhostFlag = HandleExperimentalGhostFlag,
  HandleExperimentalSpectate = HandleExperimentalSpectate,
}
