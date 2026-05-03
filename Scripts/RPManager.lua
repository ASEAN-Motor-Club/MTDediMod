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

LogOutput("INFO", "[RPManager] Loaded (v%s)", statics.ModVersion)

return {}
