local json = require("JsonParser")

---Announce a message to the whole server
---@param message string
---@param playerId string?
---@param pinned boolean?
local function AnnounceServerMessage(message, playerId, pinned)
  local PC = CreateInvalidObject()
  if playerId then
    PC = GetPlayerControllerFromUniqueId(playerId)
  else
    local gameState = GetMotorTownGameState()
    if gameState:IsValid() then
      for i = 1, #gameState.PlayerArray do
        local PS = gameState.PlayerArray[i]

        if PS:IsValid() then
          ---@cast PS AMotorTownPlayerState

          if PS.bIsAdmin then
            PC = PS:GetPlayerController()
          end
        end
      end
    end
  end

  if PC:IsValid() then
    ---@cast PC AMotorTownPlayerController

    ExecuteInGameThread(function()
      if pinned then
        PC:ServerAnnouncePinned(message)
      else
        PC:ServerAnnounce(message)
      end
    end)
    local id = GetPlayerUniqueId(PC)
    return true, id
  elseif pinned then
    local gameState = GetMotorTownGameState()
    if gameState:IsValid() then
      gameState.Net_ServerConfig.PinnedAnnounce = message
      return true
    end
  end
  return false
end

-- Handle HTTP requests

---Handle a direct pinned-announcement write from the backend (`POST /pin`).
---The mod is intentionally dumb here: Django computes the current scheduled
---message and pushes it. We just write whatever value we receive to the `/ap`
---board (Net_ServerConfig.PinnedAnnounce). Empty string clears the board.
---@type RequestPathHandler
local function HandlePinAnnouncement(session)
  local data = json.parse(session.content)
  if not data or type(data) ~= "table" or type(data.message) ~= "string" then
    return { message = "Invalid request content" }, nil, 400
  end

  local message = data.message
  ExecuteInGameThread(function()
    local gameState = GetMotorTownGameState()
    if gameState and gameState:IsValid() and gameState.Net_ServerConfig then
      gameState.Net_ServerConfig.PinnedAnnounce = message
    end
  end)
  return { status = "ok" }
end

---Handle announce request
---@type RequestPathHandler
local function HandleAnnounceMessage(session)
  local data = json.parse(session.content)

  if data and type(data) == "table" then
    if data.message then
      if type(data.message) == "string" then
        local status, id = AnnounceServerMessage(data.message, data.playerId, data.isPinned)
        if status then
          return { status = "ok", playerId = id }
        end
        return { message = "Failed to send message" }, nil, 400
      else
        return { message = "Invalid message field specified" }, nil, 400
      end
    else
      return { message = "No message field specified" }, nil, 400
    end
  end
  return { message = "Invalid request content" }, nil, 400
end

return {
  HandleAnnounceMessage = HandleAnnounceMessage,
  HandlePinAnnouncement = HandlePinAnnouncement
}
