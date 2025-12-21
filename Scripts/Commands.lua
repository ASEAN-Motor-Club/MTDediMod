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
      end
    end
    return true
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
    Category:set(2) -- 2 = Company (Hidden from public chat)
  end
end)
