local statics = require("Statics")

local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")

---Check if a player's display name contains an RP tag [R...] or wanted tag [*].
local function IsRPPlayer(playerController)
  if not playerController or not playerController:IsValid() then return false end
  local PS = playerController.PlayerState
  if not PS or not PS:IsValid() then return false end

  local ok, name = pcall(function()
    local n = PS:GetPlayerName()
    if type(n) == "userdata" then return n:ToString() end
    return tostring(n)
  end)
  if not ok or not name then return false end

  -- Match [R...] or [*...] tag prefix (same regex as C++ should_block_teleport)
  return string.find(name, "^%[R") ~= nil or string.find(name, "%[%*") ~= nil
end

---Get the player's current pawn location.
local function GetPawnLocation(playerController)
  if not playerController or not playerController:IsValid() then return nil end
  local pawn = playerController:K2_GetPawn()
  if not pawn or not pawn:IsValid() then return nil end
  return pawn:K2_GetActorLocation()
end

-- ServerTeleportCharacter: replace AbsoluteLocation with current pawn pos
RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerTeleportCharacter", function(PC, AbsoluteLocation, bCharge, bIsRespawn)
  local playerController = PC:get()
  if not IsRPPlayer(playerController) then return end

  local loc = GetPawnLocation(playerController)
  if loc then
    local al = AbsoluteLocation:get()
    al.X = loc.X
    al.Y = loc.Y
    al.Z = loc.Z
    LogOutput("INFO", "[RPManager] Blocked ServerTeleportCharacter — replaced with current pos")
  end
end)

-- ServerTeleportVehicle: replace AbsoluteLocation with current vehicle pos
RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerTeleportVehicle", function(PC, Vehicle, AbsoluteLocation)
  local playerController = PC:get()
  if not IsRPPlayer(playerController) then return end

  local veh = Vehicle:get()
  if veh and veh:IsValid() then
    local loc = veh:K2_GetActorLocation()
    local al = AbsoluteLocation:get()
    al.X = loc.X
    al.Y = loc.Y
    al.Z = loc.Z
    LogOutput("INFO", "[RPManager] Blocked ServerTeleportVehicle — replaced with current pos")
  end
end)

-- ServerRespawnCharacter: replace AbsoluteLocation with current pawn pos
RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerRespawnCharacter", function(PC, AbsoluteLocation)
  local playerController = PC:get()
  if not IsRPPlayer(playerController) then return end

  local loc = GetPawnLocation(playerController)
  if loc then
    local al = AbsoluteLocation:get()
    al.X = loc.X
    al.Y = loc.Y
    al.Z = loc.Z
    LogOutput("INFO", "[RPManager] Blocked ServerRespawnCharacter — replaced with current pos")
  end
end)

-- ServerResetVehicleAt: replace WorldLocation/Rotation with current vehicle transform
RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerResetVehicleAt", function(PC, Vehicle, WorldLocation, Rotation, bRemoveCargo, bResetCarriedVehicles)
  local playerController = PC:get()
  if not IsRPPlayer(playerController) then return end

  local veh = Vehicle:get()
  if veh and veh:IsValid() then
    local loc = veh:K2_GetActorLocation()
    local rot = veh:K2_GetActorRotation()
    local wl = WorldLocation:get()
    wl.X = loc.X
    wl.Y = loc.Y
    wl.Z = loc.Z
    local r = Rotation:get()
    r.Pitch = rot.Pitch
    r.Yaw = rot.Yaw
    r.Roll = rot.Roll
    LogOutput("INFO", "[RPManager] Blocked ServerResetVehicleAt — replaced with current transform")
  end
end)

RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerVehicleExControl", function(PC, Vehicle, Control)
  local playerController = PC:get()
  if not IsRPPlayer(playerController) then return end
  if Control:get() == 2 then
    Control:set(0)
    LogOutput("INFO", "[RPManager] Neutralized RoadsideService for RP player")
  end
end)

---Find the PlayerController whose pawn is this vehicle (i.e. the driver).
local function GetOwningPlayerController(vehicle)
  local gameState = GetMotorTownGameState()
  if not gameState or not gameState:IsValid() then return nil end
  for i = 1, #gameState.PlayerArray, 1 do
    local PS = gameState.PlayerArray[i]
    if PS and PS:IsValid() then
      local ok, pc = pcall(function() return PS:GetPlayerController() end)
      if ok and pc and pc:IsValid() and pc:K2_GetPawn() == vehicle then
        return pc
      end
    end
  end
  return nil
end

---Block autopilot (AI driving) for RP players. The client OWNS the vehicle
---cold state, so clearing bIsAIDriving here is bookkeeping only — enforcement
---is fuel starvation with restore (freeman): save current fuel, MulticastSetFuel(0)
---(the client's own simulation starves — AI can't drive an empty tank), and
---restore on the player's next sync with bIsAIDriving=false. Client-mod users
---never trigger this — their RPRestrictions hook strips the flag pre-send.
---Per-player debounce; per-vehicle starve state.
local LAST_AUTOPILOT_ACTION = {}
local STARVED_FUEL = {}

RegisterHook("/Script/MotorTown.MTVehicle:ServerSyncColdState", function(Vehicle, ColdState, bMulticast)
  local veh = Vehicle:get()
  if not veh or not veh:IsValid() or veh:IsActorBeingDestroyed() then return end
  local pc = GetOwningPlayerController(veh)
  if not pc or not IsRPPlayer(pc) then return end

  local ok, cs = pcall(function() return ColdState:get() end)
  if not ok or not cs then return end
  local okAI, bAI = pcall(function() return cs.bIsAIDriving end)
  if not okAI then return end

  -- Restore path: autopilot toggled off -> give the fuel back (never less
  -- than what's in the tank now, so a mid-starve refuel is not rolled back).
  if not bAI then
    local saved = STARVED_FUEL[veh]
    if saved then
      STARVED_FUEL[veh] = nil
      pcall(function()
        local current = 0
        if veh.NetLC_VehicleState and veh.NetLC_VehicleState:IsValid() then
          current = veh.NetLC_VehicleState.Fuel or 0
        end
        veh:MulticastSetFuel(math.max(saved, current))
      end)
      LogOutput("INFO", "[RPManager] Restored fuel (autopilot off) for RP player")
    end
    return
  end

  pcall(function() cs.bIsAIDriving = false end)

  local now = os.time()
  if now - (LAST_AUTOPILOT_ACTION[pc] or 0) < 5 then return end
  LAST_AUTOPILOT_ACTION[pc] = now

  pcall(function()
    if veh.NetLC_ColdState and veh.NetLC_ColdState:IsValid() then
      veh.NetLC_ColdState.bIsAIDriving = false
    end
    if not STARVED_FUEL[veh] then
      local saved = 0
      if veh.NetLC_VehicleState and veh.NetLC_VehicleState:IsValid() then
        saved = veh.NetLC_VehicleState.Fuel or 0
      end
      STARVED_FUEL[veh] = saved
      veh:MulticastSetFuel(0)
    end
  end)
  pcall(function()
    pc:ClientShowSystemMessage(FText("You may not use autopilot in RP mode. Toggle autopilot off to restore fuel."))
  end)
  LogOutput("INFO", "[RPManager] Starved fuel (autopilot attempt) for RP player")
end)

LogOutput("INFO", "[RPManager] Loaded (v%s)", statics.ModVersion)

return {}
