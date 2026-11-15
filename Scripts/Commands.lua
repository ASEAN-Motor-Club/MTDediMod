local vehicleManager = require("VehicleManager")
local repairManager = require("RepairManager")
local teleportLocations = require("TeleportLocations")
local teleportAllow = require("TeleportAllow")

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
  local mode = args[1] and string.lower(args[1]) or nil
  local count = 0

  if mode == "company" then
    count = vehicleManager.DespawnSpawnedVehicles(PC, { companyFilter = "company" })
  elseif mode == "personal" then
    count = vehicleManager.DespawnSpawnedVehicles(PC, { companyFilter = "personal" })
  elseif mode == "ai" then
    count = vehicleManager.DespawnSpawnedVehicles(PC, { aiFilter = true })
  elseif mode == "all" then
    count = vehicleManager.DespawnSpawnedVehicles(PC)
  else
    count = vehicleManager.DespawnPlayerVehicle(PC)
  end

  if count > 0 then
    LogOutput("INFO", "Despawned %d vehicle(s) for player %s", count, PC.PlayerState:GetPlayerName():ToString())
  else
    LogOutput("INFO", "No vehicle to despawn for player %s", PC.PlayerState:GetPlayerName():ToString())
  end
end

Commands["/d"] = Commands["/despawn"]

local function Reply(PC, message)
  pcall(function()
    PC:ClientShowSystemMessage(FText(message))
  end)
end

-- Listings go to a POPUP: a six-place list is unreadable as a chat system
-- message. One-line confirmations stay on the system message.
local function ReplyPopup(PC, message)
  local ok, err = pcall(function()
    PC:ClientShowPopupMessage(FText(message))
  end)
  if not ok then
    LogOutput("ERROR", "ClientShowPopupMessage failed: %s", tostring(err))
  end
end

--- Teleport the caller to a named destination from the locations file.
--- /tp <name> teleports; /tp with no argument lists the destinations.
Commands["/tp"] = function(PC, args)
  local name = args[1]
  local names = teleportLocations.Names()
  if #names == 0 then
    Reply(PC, "No teleport places are configured on this server.")
    return
  end
  if name == nil then
    ReplyPopup(PC, "Teleport places (use /tp <name>):\n" .. table.concat(names, "\n"))
    return
  end

  local target = teleportLocations.Get(name)
  if target == nil then
    ReplyPopup(PC, "Unknown place '" .. name .. "'. Available:\n" .. table.concat(names, "\n"))
    return
  end

  local pawn = PC:K2_GetPawn()
  if not pawn:IsValid() then
    Reply(PC, "Cannot teleport right now (no pawn).")
    return
  end

  local location = { X = target.x, Y = target.y, Z = target.z }
  local rotation = pawn:K2_GetActorRotation()

  local charClass = StaticFindObject("/Script/MotorTown.MTCharacter")
  local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")

  -- Mark this as a mod-initiated teleport so the anti-teleport-with-cargo
  -- hook does not undo it (take before, release after; the hook is synchronous).
  teleportAllow.Take()
  local ok, err = pcall(function()
    if pawn:IsA(vehicleClass) then
      -- Client-side reset keeps the vehicle + trailer chain together.
      PC:ClientResetVehicleAt(pawn, location, rotation, true, true)
    elseif pawn:IsA(charClass) then
      PC:ServerTeleportCharacter(location, false, false)
    else
      error("unsupported pawn class")
    end
  end)
  teleportAllow.Release()

  if ok then
    LogOutput("INFO", "/tp %s -> %s (%s %s %s)",
      PC.PlayerState:GetPlayerName():ToString(), name,
      tostring(target.x), tostring(target.y), tostring(target.z))
    Reply(PC, "Teleported to " .. name .. ".")
  else
    LogOutput("ERROR", "/tp %s failed: %s", name, tostring(err))
    Reply(PC, "Teleport failed: " .. tostring(err))
  end
end

Commands["/tps"] = function(PC, args)
  local names = teleportLocations.Names()
  if #names == 0 then
    ReplyPopup(PC, "No teleport places are configured on this server.")
    return
  end
  ReplyPopup(PC, "Teleport places (use /tp <name>):\n" .. table.concat(names, "\n"))
end

--- Repair the caller's own vehicle: zero every damaged part, fill the tank.
--- Uses LastVehicle (or the vehicle they are sitting in), so it works on foot
--- with a parked car as well as while driving.
Commands["/repair"] = function(PC, args)
  local playerName = "unknown"
  pcall(function() playerName = PC.PlayerState:GetPlayerName():ToString() end)
  LogOutput("INFO", "/repair requested by %s", playerName)

  local result = repairManager.RepairPlayerVehicle(PC)

  if not result.ok and result.error == "no_vehicle" then
    Reply(PC, "No vehicle found. Sit in a car or spawn one first.")
    return
  end

  local parts = result.parts or {}
  local fuel = result.fuel or {}
  local message = string.format("Repaired %d of %d damaged parts.",
    parts.repaired or 0, parts.damaged or 0)

  if fuel.method == "skipped" or fuel.method == "no_capacity" then
    message = message .. " Tank not changed."
  elseif fuel.method == "rpc_failed" then
    message = message .. " Tank fill failed."
  else
    message = message .. " Tank filled."
  end

  if (parts.failed or 0) > 0 then
    message = message .. string.format(" (%d parts failed)", parts.failed)
  end

  LogOutput("INFO", "/repair %s: vehicleId=%s damaged=%d repaired=%d fuel=%s",
    playerName, tostring(result.vehicleId),
    parts.damaged or 0, parts.repaired or 0, tostring(fuel.method))
  Reply(PC, message)
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

-- Chat commands are OPT-IN per instance. Production gets its commands from
-- amc-backend's registry, and this hook was previously disabled repo-wide for
-- crash stability, so it arms only where the operator asked for it
-- (MOD_CHAT_COMMANDS=1) or where a teleport locations file exists — i.e. an
-- instance with no backend of its own, such as the Shuto test server.
local chatCommandsEnabled = os.getenv("MOD_CHAT_COMMANDS") == "1" or teleportLocations.Available()

if chatCommandsEnabled then
  -- Resolve the UFunction BEFORE registering: RegisterHook on a function the
  -- class does not override aborts the entire Lua chunk, even inside pcall.
  local sendChat = StaticFindObject("/Script/MotorTown.MotorTownPlayerController:ServerSendChat")
  if sendChat == nil then
    LogOutput("ERROR", "chat commands: ServerSendChat not found on this build; /tp disabled")
  else
    local ok, err = pcall(RegisterHook,
      "/Script/MotorTown.MotorTownPlayerController:ServerSendChat",
      function(PC, Message, Category)
        local playerController = PC:get()
        local message = Message:get():ToString()

        if not playerController:IsValid() or not playerController.PlayerState:IsValid() then
          return
        end

        HandleCommand(playerController, message)
      end,
      function() end)
    LogOutput(ok and "INFO" or "ERROR", "chat commands hook: %s", ok and "registered" or tostring(err))
  end
end
