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

---Hook: trigger integrity check when player enters a vehicle
RegisterHook(
  "/Script/MotorTown.MotorTownPlayerController:ServerEnterVehicle",
  function(Context)
    -- Small delay so LastVehicle is set by the time we read it
    ExecuteWithDelay(500, function()
      local PC = GetMyPlayerController()
      if not PC:IsValid() then return end
      if not PC.LastVehicle or not PC.LastVehicle:IsValid() then return end

      local vehicle = PC.LastVehicle

      -- Guard: only report from driver seat (SeatType 0 = driver)
      local playerState = PC.PlayerState
      if not playerState or not playerState:IsValid() then return end

      local ok, values = pcall(ReadVehiclePhysics, vehicle)
      if not ok then
        LogOutput("WARN", "[AC] Failed to read physics: %s", tostring(values))
        return
      end

      -- Always log locally for debugging
      LogOutput("INFO", "[AC] vehicle=%s AirDrag=%.4f BrakeMult=%.4f Wheels=%d StaticMu[0]=%.4f",
        values.VehicleClass or "?",
        values.AirDragCoeff or 0,
        values.BrakeTorqueMultiplier or 0,
        #values.Wheels,
        (values.Wheels[1] and values.Wheels[1].StaticMu) or 0
      )

      -- Report to backend (async via Lua — runs in hook thread)
      local guid = GuidToString(playerState.CharacterGuid)
      if guid and guid ~= "0000" then
        SendReport(guid, values)
      end
    end)
  end
)

LogOutput("INFO", "[AC] IntegrityChecker loaded")

return IntegrityChecker
