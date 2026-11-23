--- Player-build chat commands: teleport and vehicle save only. The admin
--- build's Commands.lua (/despawn, /check, vehicle spawn) is not shipped here.

local teleportManager = require("TeleportManager")
local vehicleSaveSpawn = require("VehicleSaveSpawn")

local Commands = {}

Commands["/teleport"] = function(PC, args)
  teleportManager.HandleTeleport(PC, args)
end

Commands["/tp"] = Commands["/teleport"]

Commands["/save_vehicle"] = function(PC, args)
  local name = args[1]
  if not name then
    LogOutput("WARN", "/save_vehicle: missing name")
    return
  end
  local vehicle = PC.LastVehicle
  if not vehicle or not vehicle:IsValid() then
    LogOutput("WARN", "/save_vehicle: no active vehicle")
    return
  end
  local data = vehicleSaveSpawn.SerializeVehicle(vehicle)
  vehicleSaveSpawn.SaveVehicle(name, data)
end


Commands["/sv"] = Commands["/save_vehicle"]

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
