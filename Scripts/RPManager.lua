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
---cold state and only syncs it to the server, so clearing bIsAIDriving here
---is bookkeeping — enforcement is the proven seat eject (freeman's original
---approach, removed with the LoopAsync system in 9534c24; the eject itself
---was never the crash vector, the background polling loop was). Client-mod
---users never trigger this — their RPRestrictions hook strips the flag
---pre-send. Action debounced per-player.
local LAST_AUTOPILOT_ACTION = {}

RegisterHook("/Script/MotorTown.MTVehicle:ServerSyncColdState", function(Vehicle, ColdState, bMulticast)
  local veh = Vehicle:get()
  if not veh or not veh:IsValid() or veh:IsActorBeingDestroyed() then return end
  local pc = GetOwningPlayerController(veh)
  if not pc or not IsRPPlayer(pc) then return end

  local ok, cs = pcall(function() return ColdState:get() end)
  if not ok or not cs then return end
  local okAI, bAI = pcall(function() return cs.bIsAIDriving end)
  if not okAI or not bAI then return end

  pcall(function() cs.bIsAIDriving = false end)

  local now = os.time()
  if now - (LAST_AUTOPILOT_ACTION[pc] or 0) < 5 then return end
  LAST_AUTOPILOT_ACTION[pc] = now

  pcall(function()
    if veh.NetLC_ColdState and veh.NetLC_ColdState:IsValid() then
      veh.NetLC_ColdState.bIsAIDriving = false
    end
    pc:ServerExitVehicle()
  end)
  pcall(function()
    pc:ClientShowSystemMessage(FText("You may not use autopilot in RP mode. Toggle autopilot again to turn it off."))
  end)
  LogOutput("INFO", "[RPManager] Ejected RP player from vehicle (autopilot attempt)")
end)

LogOutput("INFO", "[RPManager] Loaded (v%s)", statics.ModVersion)

return {}
