local vehicleManager = require("VehicleManager")
local teleportManager = require("TeleportManager")
local satNav = require("SatNav")
local integrityChecker = require("IntegrityChecker")

local Commands = {}

Commands["/despawn"] = function(PC, args)
  local mode = args[1] and string.lower(args[1]) or nil
  local count = 0

  if mode == "all" then
    count = vehicleManager.DespawnAllPlayerVehicles(PC)
    if count > 0 then
      LogOutput("INFO", "Despawned all %d vehicle(s)", count)
    else
      LogOutput("INFO", "No vehicles to despawn")
    end
  elseif mode == "others" then
    count = vehicleManager.DespawnOtherPlayerVehicles(PC)
    if count > 0 then
      LogOutput("INFO", "Despawned %d other vehicle(s)", count)
    else
      LogOutput("INFO", "No other vehicles to despawn")
    end
  else
    count = vehicleManager.DespawnPlayerVehicle(PC)
    if count > 0 then
      LogOutput("INFO", "Despawned %d vehicle(s)", count)
    else
      LogOutput("INFO", "No vehicle to despawn")
    end
  end
end

Commands["/d"] = Commands["/despawn"]

Commands["/teleport"] = function(PC, args)
  teleportManager.HandleTeleport(PC, args)
end

Commands["/tp"] = Commands["/teleport"]

Commands["/satnav"] = function(PC, args)
  satNav.Toggle()
end

Commands["/nav"] = Commands["/satnav"]

Commands["/check"] = function(PC, args)
  integrityChecker.RunCheck()
end

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

-- Hook the client-side chat widget text commit instead of the Server RPC
-- ServerSendChat is a Server RPC stub on the client and may not be hookable by UE4SS
RegisterHook("/Script/MotorTown.ChatWidget:OnTextCommitted", function(Context, Text, CommitMethod)
  local message = Text:get():ToString()
  if message == "" then return end

  local PC = GetMyPlayerController()
  if not PC:IsValid() then return end

  HandleCommand(PC, message)
end)

return Commands
