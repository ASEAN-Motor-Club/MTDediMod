local config = require("ModConfig")

--- Default global teleport points (from backend TeleportPoint where character IS NULL)
local defaultPoints = {
  { name = "1100", location = { X = -110427.67, Y = 26833.32, Z = -4448.44 } },
  { name = "aewol", location = { X = -175507.72, Y = -10599.3, Z = -13761.33 } },
  { name = "ansan", location = { X = -262423.57, Y = 332222.2, Z = -20911.87 } },
  { name = "ara", location = { X = 315186.08, Y = 1334743.75, Z = -19911.86 } },
  { name = "coal", location = { X = 317176.08, Y = 748228.21, Z = 1415.26 } },
  { name = "crude", location = { X = -229321.68, Y = 1019541.01, Z = -17711.87 } },
  { name = "dasa", location = { X = -786096.83, Y = 1189916.81, Z = -21911.85 } },
  { name = "dongbok", location = { X = 107036.78, Y = -180634.54, Z = -21646.11 } },
  { name = "dragstrip", location = { X = 350697.0, Y = 1115258.0, Z = -19006.0 } },
  { name = "furniture", location = { X = -222307.46, Y = -75985.67, Z = -20208.82 } },
  { name = "gosan", location = { X = -389387.13, Y = 105647.35, Z = -21880.36 } },
  { name = "gwangjinstorage", location = { X = 242884.8, Y = 628624.69, Z = -11601.12 } },
  { name = "harbor", location = { X = -16013.29, Y = -187404.77, Z = -21911.86 } },
  { name = "iseungag", location = { X = 37196.0, Y = 49108.0, Z = -13165.0 } },
  { name = "jail", location = { X = 316050.67, Y = 1338753.48, Z = -19796.63 } },
  { name = "joil", location = { X = -167836.76, Y = 1313218.28, Z = -20483.63 } },
  { name = "migeum", location = { X = 215544.61, Y = 451901.3, Z = -12012.03 } },
  { name = "millgate", location = { X = 402969.68, Y = 1216374.42, Z = -19417.73 } },
  { name = "namdang", location = { X = 152963.0, Y = 886105.0, Z = -13570.0 } },
  { name = "nobong", location = { X = -180347.75, Y = 505540.7, Z = -12512.83 } },
  { name = "noksan", location = { X = 175099.6, Y = 12802.54, Z = -19185.14 } },
  { name = "oak3", location = { X = 234018.0, Y = 527260.0, Z = -3063.0 } },
  { name = "plastic", location = { X = -284977.0, Y = 82714.0, Z = -19741.0 } },
  { name = "quarry", location = { X = -441028.04, Y = 615972.49, Z = -19082.31 } },
  { name = "seoguipo", location = { X = -9279.0, Y = 144794.0, Z = -20996.0 } },
  { name = "skydive", location = { X = -54908.15, Y = 154353.7, Z = 30000.0 } },
  { name = "steel", location = { X = 431638.84, Y = 1213816.33, Z = -19411.86 } },
  { name = "sunflower", location = { X = -449380.37, Y = 1040824.8, Z = -20011.88 } },
  { name = "terra", location = { X = -320912.0, Y = 1582880.0, Z = -19011.0 } },
  { name = "tosan", location = { X = 175766.49, Y = 82000.06, Z = -21406.86 } },
}

--- Get active teleport points (config override or defaults)
local function GetTeleportPoints()
  local ok, configPoints = pcall(config.GetModConfig, "teleportPoints")
  if ok and type(configPoints) == "table" and #configPoints > 0 then
    return configPoints
  end
  return defaultPoints
end

--- Find a teleport point by name (case-insensitive)
---@param name string
---@return table? point { name: string, location: { X: number, Y: number, Z: number } }
local function FindTeleportPoint(name)
  local points = GetTeleportPoints()
  if type(points) ~= "table" then return nil end

  local nameLower = string.lower(name)
  for _, point in ipairs(points) do
    if string.lower(point.name) == nameLower then
      return point
    end
  end
  return nil
end

--- Get list of teleport point names
---@return string[]
local function GetPointNames()
  local points = GetTeleportPoints()
  if type(points) ~= "table" then return {} end

  local names = {}
  for _, point in ipairs(points) do
    table.insert(names, point.name)
  end
  return names
end

--- Teleport character or vehicle to a location
---@param PC AMotorTownPlayerController
---@param location FVector
---@param withVehicle boolean If true and in vehicle, teleport vehicle too
local function DoTeleport(PC, location, withVehicle)
  ExecuteInGameThread(function()
    if not PC:IsValid() then return end

    local pawn = PC:K2_GetPawn()
    if not pawn:IsValid() then return end

    local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
    ---@cast vehicleClass UClass

    if vehicleClass:IsValid() and pawn:IsA(vehicleClass) then
      if withVehicle then
        ---@cast pawn AMTVehicle
        local rotation = pawn:K2_GetActorRotation()
        PC:ServerResetVehicleAt(pawn, location, rotation, false, false)
      else
        LogOutput("INFO", "Exit your vehicle first")
        return
      end
    else
      PC:ServerTeleportCharacter(location, false, false)
    end
  end)
end

--- Handle the /tp command
---@param PC AMotorTownPlayerController
---@param args string[]
local function HandleTeleport(PC, args)
  local isAdmin = false
  if PC.PlayerState:IsValid() then
    isAdmin = PC.PlayerState.bIsAdmin
  end

  local inVehicle = false
  local pawn = PC:K2_GetPawn()
  if pawn:IsValid() then
    local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
    ---@cast vehicleClass UClass
    if vehicleClass:IsValid() and pawn:IsA(vehicleClass) then
      inVehicle = true
    end
  end

  -- No args: admin → custom destination marker, otherwise show list
  if #args == 0 then
    if isAdmin then
      local ok, loc = pcall(function()
        return PC.PlayerState.CustomDestinationAbsoluteLocation
      end)
      if ok and loc and (loc.X ~= 0 or loc.Y ~= 0 or loc.Z ~= 0) then
        local dest = { X = loc.X, Y = loc.Y, Z = loc.Z }
        dest.Z = dest.Z + (inVehicle and 5 or 100)
        DoTeleport(PC, dest, isAdmin)
        LogOutput("INFO", "Teleported to custom destination")
        return
      end
    end

    local names = GetPointNames()
    if #names > 0 then
      LogOutput("INFO", "Usage: /tp [location]  |  Available: %s", table.concat(names, ", "))
    else
      LogOutput("INFO", "No teleport points configured")
    end
    return
  end

  -- Admin coordinate teleport: /tp x y z
  if #args >= 3 and isAdmin then
    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    if x and y and z then
      DoTeleport(PC, { X = x, Y = y, Z = z }, isAdmin)
      LogOutput("INFO", "Teleported to %d %d %d", x, y, z)
      return
    end
  end

  -- Named teleport point
  local name = table.concat(args, " ")
  local point = FindTeleportPoint(name)
  if point then
    local location = { X = point.location.X, Y = point.location.Y, Z = point.location.Z }
    location.Z = location.Z + (inVehicle and 5 or 100)
    DoTeleport(PC, location, isAdmin)
    LogOutput("INFO", "Teleported to %s", point.name)
  else
    LogOutput("INFO", "Teleport point '%s' not found", name)
    local names = GetPointNames()
    if #names > 0 then
      LogOutput("INFO", "Available: %s", table.concat(names, ", "))
    end
  end
end

return {
  HandleTeleport = HandleTeleport,
}
