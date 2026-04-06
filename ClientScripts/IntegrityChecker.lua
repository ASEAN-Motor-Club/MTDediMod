---Anti-cheat physics integrity checker.
---
---Reads tire and vehicle physics values from local UObjects on vehicle entry,
---then reports them to the Django backend for comparison against known-good values.
---
---PoC phase: observe-only. No enforcement. All HTTP failures are silently ignored.

local json = require("JsonParser")
local http = require("socket.http")
local ltn12 = require("ltn12")
local config = require("ModConfig")
local statics = require("Statics")

-- Backend report URL — override via config.json `acReportUrl` key in future
local REPORT_URL = "http://api.aseanmotorclub.com/api/ac/report"

local IntegrityChecker = {}

---Read tire physics from a single UMHWheelComponent
---@param wheel UMHWheelComponent
---@param index integer 0-based index
---@return table|nil
local function ReadWheelPhysics(wheel, index)
  if not wheel:IsValid() then return nil end

  local tireData = wheel.TirePhysicsData
  if not tireData or not tireData:IsValid() then return nil end

  local params = tireData.TirePhysicsParams

  return {
    Index = index,
    StaticMu = params.StaticMu,
    SlidingMu = params.SlidingMu,
    RollingResistanceCoeff = params.RollingResistanceCoeff,
    OffroadFriction = params.OffroadFriction,
    MaxWeightKg = params.MaxWeightKg,
    WearRate = params.WearRate,
    PatchLengthCoefficient = params.PatchLengthCoefficient,
    SpringX = params.SpringX,
    SpringY = params.SpringY,
    DampingX = params.DampingX,
    DampingY = params.DampingY,
  }
end

---Read all physics values from vehicle UObject
---@param vehicle AMTVehicle
---@return table
local function ReadVehiclePhysics(vehicle)
  local values = {
    -- Vehicle-level params
    AirDragCoeff = vehicle.AirDragCoeff,
    BrakeTorqueMultiplier = vehicle.BrakeTorqueMultiplier,
    FuelTankCapacityInLiter = vehicle.FuelTankCapacityInLiter,
    MaxSteeringAngleDegree = vehicle.MaxSteeringAngleDegree,
    -- Full class name so Django can identify the vehicle type
    VehicleClass = vehicle:GetFullName(),
    Wheels = {},
  }

  -- Per-wheel tire physics
  if vehicle.Wheels and vehicle.Wheels:IsValid() then
    vehicle.Wheels:ForEach(function(index, element)
      local wheel = element:get()
      local wheelData = ReadWheelPhysics(wheel, index)
      if wheelData then
        table.insert(values.Wheels, wheelData)
      end
    end)
  end

  return values
end

---POST physics report to Django backend (fire-and-forget)
---@param guid string Character GUID as hex string
---@param values table Physics values table
local function SendReport(guid, values)
  local ok, body = pcall(json.stringify, {
    guid = guid,
    timestamp = os.time(),
    mod_version = statics.ModVersion,
    values = values,
  })
  if not ok then
    LogOutput("WARN", "[AC] Failed to serialize report: %s", tostring(body))
    return
  end

  local response = {}
  local success, code = pcall(function()
    return http.request({
      url = REPORT_URL,
      method = "POST",
      headers = {
        ["Content-Type"] = "application/json",
        ["Content-Length"] = tostring(#body),
      },
      source = ltn12.source.string(body),
      sink = ltn12.sink.table(response),
    })
  end)

  if success and code == 200 then
    LogOutput("DEBUG", "[AC] Report sent OK (guid=%s)", guid:sub(1, 8))
  else
    -- Silently ignore — PoC is observe-only, don't spam failures
    LogOutput("DEBUG", "[AC] Report failed (code=%s)", tostring(code))
  end
end

---Run an on-demand integrity check on the current vehicle.
---Prints values to log and sends a report to the backend.
---@return boolean success
function IntegrityChecker.RunCheck()
  local PC = GetMyPlayerController()
  if not PC:IsValid() then
    LogOutput("WARN", "[AC] /check — no player controller")
    return false
  end
  if not PC.LastVehicle or not PC.LastVehicle:IsValid() then
    LogOutput("WARN", "[AC] /check — not in a vehicle")
    return false
  end

  local playerState = PC.PlayerState
  if not playerState or not playerState:IsValid() then
    LogOutput("WARN", "[AC] /check — no player state")
    return false
  end

  local ok, values = pcall(ReadVehiclePhysics, PC.LastVehicle)
  if not ok then
    LogOutput("WARN", "[AC] /check — failed to read physics: %s", tostring(values))
    return false
  end

  -- Print full breakdown to log
  LogOutput("INFO", "[AC] === Manual Check ===")
  LogOutput("INFO", "[AC] Vehicle:     %s", values.VehicleClass or "?")
  LogOutput("INFO", "[AC] AirDrag:     %.6f", values.AirDragCoeff or 0)
  LogOutput("INFO", "[AC] BrakeMult:   %.6f", values.BrakeTorqueMultiplier or 0)
  LogOutput("INFO", "[AC] FuelTank:    %.2f L", values.FuelTankCapacityInLiter or 0)
  LogOutput("INFO", "[AC] MaxSteer:    %.2f deg", values.MaxSteeringAngleDegree or 0)
  for _, w in ipairs(values.Wheels) do
    LogOutput("INFO",
      "[AC] Wheel[%d]:  StaticMu=%.4f SlidingMu=%.4f RollRes=%.6f Offroad=%.4f MaxKg=%.1f WearRate=%.6f",
      w.Index, w.StaticMu or 0, w.SlidingMu or 0,
      w.RollingResistanceCoeff or 0, w.OffroadFriction or 0,
      w.MaxWeightKg or 0, w.WearRate or 0
    )
  end
  LogOutput("INFO", "[AC] === Sending Report ===")

  local guid = GuidToString(playerState.CharacterGuid)
  if guid and guid ~= "0000" then
    SendReport(guid, values)
  end
  return true
end

--- Shared post-hook handler: called after vehicle entry functions execute.
--- The post-hook fires after the UFunction body runs, so LastVehicle is already set.
--- Uses a debounce so multiple hooks registering the same entry don't double-fire.
local lastCheckTime = 0
local CHECK_DEBOUNCE_MS = 3000

local function OnVehicleEntered()
  local now = os.clock() * 1000
  if (now - lastCheckTime) < CHECK_DEBOUNCE_MS then return end
  lastCheckTime = now

  local PC = GetMyPlayerController()
  if not PC:IsValid() then return end
  if not PC.LastVehicle or not PC.LastVehicle:IsValid() then return end

  local playerState = PC.PlayerState
  if not playerState or not playerState:IsValid() then return end

  local ok, values = pcall(ReadVehiclePhysics, PC.LastVehicle)
  if not ok then
    LogOutput("WARN", "[AC] Failed to read physics: %s", tostring(values))
    return
  end

  LogOutput("INFO", "[AC] vehicle=%s AirDrag=%.4f BrakeMult=%.4f Wheels=%d StaticMu[0]=%.4f",
    values.VehicleClass or "?",
    values.AirDragCoeff or 0,
    values.BrakeTorqueMultiplier or 0,
    #values.Wheels,
    (values.Wheels[1] and values.Wheels[1].StaticMu) or 0
  )

  local guid = GuidToString(playerState.CharacterGuid)
  if guid and guid ~= "0000" then
    SendReport(guid, values)
  end
end

-- Hook 1: AMTCharacter:OnRep_Seat
-- Fires on the CLIENT when the character's replicated Seat property changes.
-- This is the most direct client-side signal for "I entered/exited a seat".
-- Context is the AMTCharacter (our pawn). Filter: only act if LastVehicle is valid.
local _, _ = RegisterHook(
  "/Script/MotorTown.MTCharacter:OnRep_Seat",
  function() end,
  function(Context)
    local character = Context:get()
    if not character or not character:IsValid() then return end
    -- Only handle our own character
    local PC = GetMyPlayerController()
    if not PC:IsValid() then return end
    local myPawn = PC.Pawn
    if not myPawn or not myPawn:IsValid() then return end
    if character ~= myPawn then return end
    -- Only fire if we entered a vehicle (LastVehicle valid)
    if PC.LastVehicle and PC.LastVehicle:IsValid() then
      OnVehicleEntered()
    end
  end
)

-- Hook 2: UMTSeatComponent:MulticastSeatCharacter
-- Fires on ALL clients when any character is seated. Filter for local pawn.
local _, _ = RegisterHook(
  "/Script/MotorTown.MTSeatComponent:MulticastSeatCharacter",
  function() end,
  function(Context, InCharacter, Location)
    local seatedChar = InCharacter:get()
    if not seatedChar or not seatedChar:IsValid() then return end
    local PC = GetMyPlayerController()
    if not PC:IsValid() then return end
    local myPawn = PC.Pawn
    if not myPawn or not myPawn:IsValid() then return end
    if seatedChar == myPawn then
      OnVehicleEntered()
    end
  end
)

LogOutput("INFO", "[AC] IntegrityChecker loaded")

return IntegrityChecker
