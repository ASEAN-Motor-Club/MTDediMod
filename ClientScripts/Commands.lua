local vehicleManager = require("VehicleManager")
local teleportManager = require("TeleportManager")
local satNav = require("SatNav")
local integrityChecker = require("IntegrityChecker")
local vehicleSaveSpawn = require("VehicleSaveSpawn")
local UEHelpers = require("UEHelpers")
local types = require("MTHelpers.Types")

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

Commands["/spawn_vehicle"] = function(PC, args)
  local name = args[1]
  if not name then
    LogOutput("WARN", "/spawn_vehicle: missing name")
    return
  end
  local config = vehicleSaveSpawn.LoadVehicle(name)
  if not config then
    LogOutput("WARN", "/spawn_vehicle: '%s' not found", name)
    return
  end

  local world = UEHelpers.GetWorld()
  if not world or not world:IsValid() then
    LogOutput("WARN", "/spawn_vehicle: invalid world")
    return
  end

  local assetPath = config.AssetPath:gsub("^BlueprintGeneratedClass ", ""):gsub("^Class ", "")
  local assetClass = StaticFindObject(assetPath)
  if not assetClass or not assetClass:IsValid() then
    LogOutput("WARN", "/spawn_vehicle: asset not found: %s", assetPath)
    return
  end

  local pawn = PC:K2_GetPawn()
  local location = pawn:IsValid() and types.VectorToTable(pawn:K2_GetActorLocation()) or {X=0, Y=0, Z=0}
  local rotation = pawn:IsValid() and types.RotatorToTable(pawn:K2_GetActorRotation()) or {Pitch=0, Yaw=0, Roll=0}
  -- Offset down slightly so vehicle spawns on ground
  location.Z = location.Z - 95

  local vehicle = world:SpawnActor(
    assetClass,
    location,
    rotation
  )

  if not vehicle or not vehicle:IsValid() then
    LogOutput("WARN", "/spawn_vehicle: spawn failed")
    return
  end

  -- Apply config (customization, decals, parts)
  vehicleSaveSpawn.ApplyVehicleConfig(vehicle, config, PC)

  -- Auto-enter driver seat
  PC:ServerEnterVehicle(vehicle, 1, -1, false)
  LogOutput("INFO", "/spawn_vehicle: spawned '%s'", name)
end

Commands["/sv"] = Commands["/save_vehicle"]
Commands["/spv"] = Commands["/spawn_vehicle"]

---Spawn a saved vehicle using the native ServerSpawnVehicle RPC.
---Requires the saved config to have a VehicleKey (re-save old configs to populate it).
Commands["/spawn_vehicle2"] = function(PC, args)
  local name = args[1]
  if not name then
    LogOutput("WARN", "/spawn_vehicle2: missing name")
    return
  end

  local config = vehicleSaveSpawn.LoadVehicle(name)
  if not config then
    LogOutput("WARN", "/spawn_vehicle2: '%s' not found", name)
    return
  end

  if not config.VehicleKey then
    LogOutput("WARN", "/spawn_vehicle2: '%s' has no VehicleKey (re-save with /save_vehicle first)", name)
    return
  end

  local pawn = PC:K2_GetPawn()
  local location = pawn:IsValid() and types.VectorToTable(pawn:K2_GetActorLocation()) or {X=0, Y=0, Z=0}
  local rotation = pawn:IsValid() and types.RotatorToTable(pawn:K2_GetActorRotation()) or {Pitch=0, Yaw=0, Roll=0}
  location.Z = location.Z - 95

  local params = vehicleSaveSpawn.BuildSpawnParams(config, location, rotation)
  PC:ServerSpawnVehicle(params)
  LogOutput("INFO", "/spawn_vehicle2: spawned '%s' via ServerSpawnVehicle", name)
end

Commands["/spv2"] = Commands["/spawn_vehicle2"]

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
