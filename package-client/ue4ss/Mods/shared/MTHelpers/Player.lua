---Player lookup and identification functions for MotorTown
---@class Player

local GameState = require("MTHelpers.GameState")
local Guid = require("MTHelpers.Guid")

local Player = {}

---Get net player state unique net ID as string
---@param playerState APlayerState
---@return string?
function Player.GetUniqueNetIdAsString(playerState)
  if playerState:IsValid() then
    local status, output = pcall(function()
      -- Attempt to call the function registerd in C++
      ---@diagnostic disable-next-line: undefined-global
      return ExportStructAsText(playerState, "UniqueID")
    end)
    if status then
      return output
    end
  end
  return nil
end

---Get the player controller given the unique net ID
---@param uniqueId string Player state unique net ID
---@return AMotorTownPlayerController
function Player.GetPlayerControllerFromUniqueId(uniqueId)
  local gameState = GameState.GetMotorTownGameState()
  if gameState:IsValid() then
    for i = 1, #gameState.PlayerArray, 1 do
      local PS = gameState.PlayerArray[i]
      ---@cast PS AMotorTownPlayerState

      if PS:IsValid() then
        local id = Player.GetUniqueNetIdAsString(PS)
        if id == uniqueId then
          return PS:GetPlayerController() ---@type AMotorTownPlayerController
        end
      end
    end
  end
  return CreateInvalidObject() ---@type AMotorTownPlayerController
end

---Get the player controller given the GUID
---@param guid string
---@return AMotorTownPlayerController
function Player.GetPlayerControllerFromGuid(guid)
  local gameState = GameState.GetMotorTownGameState()
  if gameState:IsValid() then
    for i = 1, #gameState.PlayerArray, 1 do
      local PS = gameState.PlayerArray[i]
      ---@cast PS AMotorTownPlayerState
      if PS:IsValid() and Guid.ToString(PS.CharacterGuid) == guid then
        return PS:GetPlayerController() ---@type AMotorTownPlayerController
      end
    end
  end
  return CreateInvalidObject() ---@type AMotorTownPlayerController
end

---Get a player controller guid
---@param playerController APlayerController
---@return string?
function Player.GetPlayerGuid(playerController)
  if not playerController:IsValid() then return nil end

  local playerState = playerController.PlayerState
  ---@cast playerState AMotorTownPlayerState

  if not playerState:IsValid() then return nil end

  return Guid.ToString(playerState.CharacterGuid)
end

---Get player unique net ID
---@param playerController APlayerController
---@return string?
function Player.GetPlayerUniqueId(playerController)
  if playerController:IsValid() then
    local PS = playerController.PlayerState
    if PS:IsValid() then
      local id = Player.GetUniqueNetIdAsString(PS)
      return id
    end
  end
  return nil
end

return Player
