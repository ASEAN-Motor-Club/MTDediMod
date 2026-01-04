local vehicleManager = require("VehicleManager")

local Commands = {}

-- Alphanumeric characters for verification code (excluding ambiguous chars like 0/O, 1/I/l)
local CODE_CHARS = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ"

--- Generates a deterministic 4-character verification code based on player name and command name.
--- Uses djb2 hash algorithm for consistent, reproducible codes.
--- @param playerName string The player's name
--- @param commandName string The command name (e.g., "/rp_mode")
--- @return string A 4-character alphanumeric verification code
local function GenerateVerificationCode(playerName, commandName)
  local input = playerName .. ":" .. commandName
  
  -- djb2 hash algorithm
  local hash = 5381
  for i = 1, #input do
    local char = string.byte(input, i)
    hash = ((hash * 33) + char) % 2147483647  -- Keep within 32-bit range
  end
  
  -- Convert hash to 4-character code
  local code = ""
  local numChars = #CODE_CHARS
  for _ = 1, 4 do
    local index = (hash % numChars) + 1
    code = code .. string.sub(CODE_CHARS, index, index)
    hash = math.floor(hash / numChars)
  end
  
  return code
end

Commands["/despawn"] = function(PC, args)
  local count = vehicleManager.DespawnPlayerVehicle(PC)
  if count > 0 then
    LogOutput("INFO", "Despawned %d vehicle(s) for player %s", count, PC.PlayerState:GetPlayerName():ToString())
  else
    LogOutput("INFO", "No vehicle to despawn for player %s", PC.PlayerState:GetPlayerName():ToString())
  end
end

Commands["/d"] = Commands["/despawn"]

Commands["/rp_mode"] = function(PC, args)
  local playerName = PC.PlayerState:GetPlayerName():ToString()
  local expectedCode = GenerateVerificationCode(playerName, "/rp_mode")
  
  if args[1] == nil then
    -- No argument provided, show warning and verification code prompt
    local msg = "<Title>RP Mode</>\n\n" ..
      "<Warning>Warning:</> Enabling RP Mode will <Bold>despawn your current vehicle</>.\n\n" ..
      "To confirm, type:\n" ..
      "<Highlight>/rp_mode " .. expectedCode .. "</>"
    PC:ClientShowPopupMessage(FText(msg))
    LogOutput("INFO", "Player %s must confirm with: /rp_mode %s", playerName, expectedCode)
    return
  end
  
  if string.upper(args[1]) == expectedCode then
    local rpMode = vehicleManager.ToggleRPMode(PC)
    if rpMode then
      local msg = "<Title>RP Mode</>\n\n" ..
        "<EffectGood>RP Mode is now ON</>\n\n" ..
        "<Small>Your vehicle has been despawned.</>"
      PC:ClientShowPopupMessage(FText(msg))
      LogOutput("INFO", "Set RP Mode = ON player %s", playerName)
    else
      local msg = "<Title>RP Mode</>\n\n" ..
        "<EffectGood>RP Mode is now OFF</>"
      PC:ClientShowPopupMessage(FText(msg))
      LogOutput("INFO", "Set RP Mode = OFF player %s", playerName)
    end
  else
    local msg = "<Title>RP Mode</>\n\n" ..
      "<Warning>Invalid verification code.</>\n\n" ..
      "Your code is:\n" ..
      "<Highlight>/rp_mode " .. expectedCode .. "</>"
    PC:ClientShowPopupMessage(FText(msg))
    LogOutput("INFO", "Invalid verification code for player %s. Expected: %s", playerName, expectedCode)
  end
end

Commands["/rp"] = Commands["/rp_mode"]

local function HandleCommand(PC, message)
  if string.sub(message, 1, 1) == "/" then
    local parts = SplitString(message, " ")
    if #parts > 0 then
      ---@diagnostic disable-next-line: need-check-nil
      local commandName = parts[1]
      local handler = Commands[commandName]
      if handler then
        local args = {}
        for i = 2, #parts do
          ---@diagnostic disable-next-line: need-check-nil
          table.insert(args, parts[i])
        end
        handler(PC, args)
        return true
      end
    end
  end
  return false
end

RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerSendChat", function(PC, Message, Category)
  local playerController = PC:get()
  local message = Message:get():ToString()

  if not playerController:IsValid() or not playerController.PlayerState:IsValid() then
    return
  end

  if HandleCommand(playerController, message) then
    -- Category:set(2) -- 2 = Company (Hidden from public chat) - BUGGY
  end
end)
