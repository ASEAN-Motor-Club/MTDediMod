---RepairManager.lua
---Vehicle repair: zero every damaged part slot and fill the tank.
---
---Two entry points, one implementation:
---  * chat `/repair` (Commands.lua) — the only input channel on instances with
---    no amc-backend (Shuto test server).
---  * mod API (`GET /repair`, `POST /repair`, `POST /repair/fuel_probe`) — the
---    ops/verification surface, so a repair can be proven from the host without
---    a client round-trip.
---
---Damage is written through `AMTVehicle:ServerSetPartDamage(Slot, 0.0)` per
---part, never by assigning `part.Damage` (a raw Lua write does not mark the
---replicated property dirty, so it would not reach clients) and never via
---`ServerSetParts` with a rebuilt array (that replaces part identity wholesale).
---
---Fuel units are NOT assumed: `ServerSetFuel(Vehicle, Fuel)` may take the 0..1
---ratio the HUD reads or an absolute litre count. The first repair probes it by
---writing 1.0 and reading `NetLC_VehicleState.Fuel` back, then corrects to the
---real fill value if the build turned out to want litres.

local json = require("JsonParser")

local PART_EPSILON = 0.0001

-- "ratio" | "liter" | nil (unprobed). Module-local: a mod reload resets it and
-- the next repair re-probes.
local fuelVerdict = nil
local fuelProbeValue = nil

local stats = {
  repairs = 0,
  partsRepaired = 0,
  partsFailed = 0,
  fuelFills = 0,
  lastError = nil,
}

local function Log(level, fmt, ...)
  LogOutput(level, "[RepairManager] " .. fmt, ...)
end

---Resolve the vehicle a player is driving now, else the last one they used.
---@param PC AMotorTownPlayerController
---@return AMTVehicle?
local function GetPlayerVehicle(PC)
  local ok, veh = pcall(function()
    local v = PC.LastVehicle
    if v ~= nil and v:IsValid() then
      return v
    end
    local pawn = PC:K2_GetPawn()
    if pawn ~= nil and pawn:IsValid() then
      local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
      if vehicleClass ~= nil and pawn:IsA(vehicleClass) then
        return pawn
      end
    end
    return nil
  end)
  if ok then return veh end
  return nil
end

local function IsVehicleUsable(veh)
  if veh == nil or not veh:IsValid() then return false end
  if IsUObjectSafe and not IsUObjectSafe(veh) then return false end
  if veh:IsActorBeingDestroyed() then return false end
  return true
end

---Server copy of the fuel state plus the tank size in litres.
---@return number? fuel, number? capacity
local function GetFuelState(veh)
  local fuel, capacity
  pcall(function() fuel = tonumber(veh.NetLC_VehicleState.Fuel) end)
  pcall(function() capacity = tonumber(veh.FuelTankCapacityInLiter) end)
  return fuel, capacity
end

local function SetFuel(PC, veh, value)
  local ok, err = pcall(function() PC:ServerSetFuel(veh, value) end)
  if not ok then
    Log("ERROR", "ServerSetFuel(%s) failed: %s", tostring(value), tostring(err))
  end
  return ok
end

---Settle the units of `ServerSetFuel`'s parameter, once per mod load.
---
---`NetLC_VehicleState.Fuel` is the HUD's fuel value and is NOT normalised:
---measured on Shuto, fuel=31.85 with FuelTankCapacityInLiter=50, i.e. litres.
---The RPC parameter may still be the 0..1 ratio, so probe with the CAPACITY:
---that write is safe under both interpretations (litres -> a full tank, ratio ->
---clamped to full) and the read-back discriminates (~capacity = litres,
---~1.0 = ratio). No second write, no near-empty transient.
---@return string? verdict, number? before, number? capacity
local function ProbeFuelUnit(PC, veh, value)
  local before, capacity = GetFuelState(veh)
  if not SetFuel(PC, veh, value) then
    return nil, before, capacity
  end
  local after = GetFuelState(veh)
  if after == nil then
    return nil, before, capacity
  end

  local verdict = nil
  if capacity ~= nil and capacity > 2.0 and math.abs(after - capacity) <= 0.05 * capacity then
    verdict = "liter"
  elseif math.abs(after - 1.0) <= 0.02 then
    verdict = "ratio"
  end

  fuelProbeValue = value
  fuelVerdict = verdict
  Log("INFO", "fuel unit probe: wrote %s, read back %s (capacity %s) -> %s",
    tostring(value), tostring(after), tostring(capacity), tostring(verdict))
  return verdict, before, capacity
end

---Zero every damaged part slot. Returns counters rather than throwing, so one
---bad part cannot abort the rest of the repair.
---@return integer scanned, integer damaged, integer repaired, integer failed
local function RepairParts(veh)
  local scanned, damaged, repaired, failed = 0, 0, 0, 0

  if not veh.Net_Parts:IsValid() then
    return scanned, damaged, repaired, failed
  end

  veh.Net_Parts:ForEach(function(index, element)
    local part = element:get()
    if part == nil then return end
    scanned = scanned + 1

    local damage = nil
    pcall(function() damage = tonumber(part.Damage) end)
    if damage == nil or damage <= PART_EPSILON then
      return
    end

    damaged = damaged + 1
    local ok, err = pcall(function() veh:ServerSetPartDamage(part.Slot, 0.0) end)
    if ok then
      repaired = repaired + 1
    else
      failed = failed + 1
      Log("ERROR", "ServerSetPartDamage failed for slot %s: %s",
        tostring(part.Slot), tostring(err))
    end
  end)

  return scanned, damaged, repaired, failed
end

---Fill the tank, settling the units on first use.
---@return table fuel
local function FillTank(PC, veh, skip)
  local before, capacity = GetFuelState(veh)
  local info = {
    before = before,
    capacity = capacity,
    verdict = fuelVerdict,
    method = "skipped",
  }
  if skip then return info end

  local target = nil
  local needWrite = true

  if fuelVerdict == "ratio" then
    target = 1.0
    info.method = "known_ratio"
  elseif fuelVerdict == "liter" then
    target = capacity
    info.method = "known_liter"
  else
    -- Unknown units: write the tank capacity, which is a full tank under both
    -- interpretations, and let the read-back settle the semantics.
    local probeWrite = capacity or 1.0
    info.verdict = ProbeFuelUnit(PC, veh, probeWrite)
    target = probeWrite
    needWrite = false
    info.method = info.verdict and "probed" or "probe_inconclusive"
  end

  if target == nil then
    info.method = "no_capacity"
    return info
  end

  if needWrite then
    if not SetFuel(PC, veh, target) then
      info.method = "rpc_failed"
      return info
    end
  end

  stats.fuelFills = stats.fuelFills + 1
  info.wrote = target
  info.after = GetFuelState(veh)
  return info
end

---Repair a player's vehicle. Returns a plain table (also JSON-encodable).
---@param PC AMotorTownPlayerController
---@param opts table? { skipFuel = boolean }
---@return table
function RepairPlayerVehicle(PC, opts)
  opts = opts or {}

  local veh = GetPlayerVehicle(PC)
  if not IsVehicleUsable(veh) then
    return { ok = false, error = "no_vehicle" }
  end

  local vehicleId = nil
  pcall(function() vehicleId = veh.Net_VehicleId end)

  local scanned, damaged, repaired, failed = RepairParts(veh)
  local fuel = FillTank(PC, veh, opts.skipFuel == true)

  stats.repairs = stats.repairs + 1
  stats.partsRepaired = stats.partsRepaired + repaired
  stats.partsFailed = stats.partsFailed + failed
  if failed > 0 then
    stats.lastError = "part_write_failed"
  end

  Log("INFO", "repair: vehicleId=%s scanned=%d damaged=%d repaired=%d failed=%d fuel=%s",
    tostring(vehicleId), scanned, damaged, repaired, failed, tostring(fuel.method))

  return {
    ok = failed == 0,
    vehicleId = vehicleId,
    parts = {
      scanned = scanned,
      damaged = damaged,
      repaired = repaired,
      failed = failed,
    },
    fuel = fuel,
  }
end

-- ---------------------------------------------------------------------------
-- HTTP surface
-- ---------------------------------------------------------------------------

local function ResolvePlayerController(data)
  if data.CharacterGuid then
    local pc = GetPlayerControllerFromGuid(data.CharacterGuid)
    if pc ~= nil and pc:IsValid() then return pc end
  end
  if data.UniqueID then
    local pc = GetPlayerControllerFromUniqueId(tostring(data.UniqueID))
    if pc ~= nil and pc:IsValid() then return pc end
  end
  return nil
end

---GET /repair — fuel-unit verdict, counters, and one row per online player.
local function HandleGetRepairStatus(session)
  local players = {}
  local gameState = GetMotorTownGameState()
  if gameState:IsValid() then
    local arr = gameState.PlayerArray
    for i = 1, #arr do
      local ps = arr[i]
      if ps:IsValid() then
        local ok, row = pcall(function()
          local uid = GetUniqueNetIdAsString(ps)
          local pc = GetPlayerControllerFromUniqueId(uid)
          local name = ps:GetPlayerName():ToString()
          if pc == nil or not pc:IsValid() then
            return { UniqueID = uid, name = name, error = "no_player_controller" }
          end
          local veh = GetPlayerVehicle(pc)
          if not IsVehicleUsable(veh) then
            return { UniqueID = uid, name = name, error = "no_vehicle" }
          end
          local damaged, scanned = 0, 0
          if veh.Net_Parts:IsValid() then
            veh.Net_Parts:ForEach(function(_, element)
              local part = element:get()
              if part ~= nil then
                scanned = scanned + 1
                local d = nil
                pcall(function() d = tonumber(part.Damage) end)
                if d ~= nil and d > PART_EPSILON then damaged = damaged + 1 end
              end
            end)
          end
          local fuel, capacity = GetFuelState(veh)
          local vehicleId = nil
          pcall(function() vehicleId = veh.Net_VehicleId end)
          return {
            UniqueID = uid,
            name = name,
            vehicleId = vehicleId,
            partsScanned = scanned,
            partsDamaged = damaged,
            fuel = fuel,
            fuelCapacity = capacity,
          }
        end)
        if ok then table.insert(players, row) end
      end
    end
  end

  return {
    fuelVerdict = fuelVerdict,
    fuelProbeValue = fuelProbeValue,
    stats = stats,
    players = players,
  }, nil, 200
end

---POST /repair {"CharacterGuid"|"UniqueID": "..."} — repair one online player.
local function HandleRepairPlayer(session)
  local data = nil
  if session.content and session.content ~= "" then
    local ok, parsed = pcall(json.parse, session.content)
    if not ok or type(parsed) ~= "table" then
      return { error = "Invalid JSON body" }, nil, 400
    end
    data = parsed
  end
  if data == nil then
    return { error = 'Body must be {"CharacterGuid": "..."} or {"UniqueID": "..."}' }, nil, 400
  end

  local pc = ResolvePlayerController(data)
  if pc == nil then
    return { error = "Player not found" }, nil, 404
  end

  local result = RepairPlayerVehicle(pc, { skipFuel = data.skipFuel == true })
  if result.error then
    return result, nil, 409
  end
  return result, nil, 200
end

---POST /repair/fuel_probe {"CharacterGuid": "...", "Value": 0.5}
---Deliberately writes a small value and reads it back, so this must only be
---used on a PARKED vehicle owned by a tester.
local function HandleFuelProbe(session)
  local data = nil
  if session.content and session.content ~= "" then
    local ok, parsed = pcall(json.parse, session.content)
    if ok and type(parsed) == "table" then data = parsed end
  end
  if data == nil then
    return { error = "Invalid JSON body" }, nil, 400
  end

  local pc = ResolvePlayerController(data)
  if pc == nil then
    return { error = "Player not found" }, nil, 404
  end

  local veh = GetPlayerVehicle(pc)
  if not IsVehicleUsable(veh) then
    return { error = "Player has no usable vehicle" }, nil, 409
  end

  local before, capacity = GetFuelState(veh)
  local value = tonumber(data.Value)
  if value == nil then value = capacity or 1.0 end

  local verdict = ProbeFuelUnit(pc, veh, value)
  local after = GetFuelState(veh)

  return {
    verdict = verdict,
    wrote = value,
    before = before,
    after = after,
    capacity = capacity,
  }, nil, 200
end

Log("INFO", "loaded: /repair (parts + fuel) and /repair API routes ready")

return {
  RepairPlayerVehicle = RepairPlayerVehicle,
  HandleGetRepairStatus = HandleGetRepairStatus,
  HandleRepairPlayer = HandleRepairPlayer,
  HandleFuelProbe = HandleFuelProbe,
  GetFuelVerdict = function() return fuelVerdict end,
}
