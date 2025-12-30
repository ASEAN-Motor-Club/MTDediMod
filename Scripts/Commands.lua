local vehicleManager = require("VehicleManager")

local Commands = {}

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
  if args[1] == "confirm" then
    local rpMode = vehicleManager.ToggleRPMode(PC)
    if rpMode then
      LogOutput("INFO", "Set RP Mode = ON player %s", count, PC.PlayerState:GetPlayerName():ToString())
    else
      LogOutput("INFO", "Set RP Mode = OFF player %s", count, PC.PlayerState:GetPlayerName():ToString())
    end
  end
end

Commands["/rp"] = Commands["/rp_mode"]

local function HandleCommand(PC, message)
  if string.sub(message, 1, 1) == "/" then
    local parts = SplitString(message, " ")
    if #parts > 0 then
      local commandName = parts[1]
      local handler = Commands[commandName]
      if handler then
        local args = {}
        for i = 2, #parts do
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
  LogOutput("INFO", "Incoming ServerSendChat")
  local playerController = PC:get()
  local message = Message:get():ToString()

  LogOutput("INFO", "Message: %s", message)

  if not playerController:IsValid() or not playerController.PlayerState:IsValid() then
    return
  end

  if HandleCommand(playerController, message) then
    LogOutput("INFO", "Hiding slash command %s", message)
    --Category:set(2) -- 2 = Company (Hidden from public chat)
  end
end)
