---Cached game state accessor functions for MotorTown
---Provides efficient cached access to MotorTown subsystems
---@class GameState

local UEHelpers = require("UEHelpers")

local GameState = {}

-- Cached references
local MotorTownGameState = CreateInvalidObject()
local DeliverySystem = CreateInvalidObject()
local EventSystem = CreateInvalidObject()
local myPlayerControllerCache = CreateInvalidObject()

---Get Motor Town GameState object (cached)
---@return AMotorTownGameState
function GameState.GetMotorTownGameState()
  if not MotorTownGameState:IsValid() then
    local gameState = UEHelpers.GetGameStateBase()
    local gameStateClass = StaticFindObject("/Script/MotorTown.MotorTownGameState")
    ---@cast gameStateClass UClass
    if gameState:IsValid() and gameState:IsA(gameStateClass) then
      MotorTownGameState = gameState
    end
  end
  return MotorTownGameState ---@type AMotorTownGameState
end

---Get Motor Town delivery system (cached)
---@return AMTDeliverySystem
function GameState.GetDeliverySystem()
  local gameState = GameState.GetMotorTownGameState()
  if gameState:IsValid() and gameState.Net_DeliverySystem:IsValid() then
    local gameStateClass = StaticFindObject("/Script/MotorTown.MTDeliverySystem")
    ---@cast gameStateClass UClass
    if gameState.Net_DeliverySystem:IsA(gameStateClass) then
      DeliverySystem = gameState.Net_DeliverySystem
    end
  end
  return DeliverySystem ---@type AMTDeliverySystem
end

---Get Motor Town event system (cached)
---@return AMTEventSystem
function GameState.GetEventSystem()
  local gameState = GameState.GetMotorTownGameState()
  if gameState:IsValid() and gameState.Net_EventSystem:IsValid() then
    local gameStateClass = StaticFindObject("/Script/MotorTown.MTEventSystem")
    ---@cast gameStateClass UClass
    if gameState.Net_EventSystem:IsA(gameStateClass) then
      EventSystem = gameState.Net_EventSystem
    end
  end
  return EventSystem ---@type AMTEventSystem
end

---Get my own PlayerController (client-only, cached)
---@return AMotorTownPlayerController
function GameState.GetMyPlayerController()
  if myPlayerControllerCache:IsValid() then
    return myPlayerControllerCache
  end

  local gameInstance = UEHelpers.GetGameInstance()
  if gameInstance:IsValid() and gameInstance.LocalPlayers and #gameInstance.LocalPlayers > 0 then
    local localPlayer = gameInstance.LocalPlayers[1]
    if localPlayer:IsValid() then
      myPlayerControllerCache = localPlayer.PlayerController
    end
  else
    local playerController = UEHelpers.GetPlayerController()
    if playerController:IsValid() then
      myPlayerControllerCache = playerController
    end
  end
  return myPlayerControllerCache ---@type AMotorTownPlayerController
end

return GameState
