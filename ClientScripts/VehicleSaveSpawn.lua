---Client-side vehicle save/spawn module for single-player use
---Stores vehicle configs as local JSON and spawns them via direct world:SpawnActor + server RPCs

local json = require("JsonParser")
local statics = require("Statics")
local vehicleSerialization = require("VehicleSerialization")
local types = require("MTHelpers.Types")
local UEHelpers = require("UEHelpers")

local dir = os.getenv("PWD") or io.popen("cd"):read()
local saveDir = dir .. "/ue4ss/Mods/" .. statics.ModName .. "/saved_vehicles"

-- Ensure directory exists
local function ensureDir()
  local ok = os.execute('mkdir "' .. saveDir .. '" 2>nul')
  if not ok then
    -- Fallback for non-Windows shells
    os.execute('mkdir -p "' .. saveDir .. '"')
  end
end

-- Extract asset path from a vehicle's class
local function GetVehicleAssetPath(vehicle)
  local class = vehicle:GetClass()
  if not class:IsValid() then return nil end
  local fullName = class:GetFullName()          -- "BlueprintGeneratedClass /Game/.../BP.MyBP_C"
  return fullName:gsub("^BlueprintGeneratedClass ", ""):gsub("^Class ", "")
end

---Derive a VehicleKey FName from an asset path.
---Example: /Game/Vehicles/Pickup/BP_Pickup.BP_Pickup_C -> "Pickup"
---@param assetPath string
---@return string|nil
local function GetVehicleKeyFromAssetPath(assetPath)
  if not assetPath then return nil end
  -- Try parent folder before the BP file: /.../VehicleKey/BP_...
  local key = assetPath:match("/([^/]+)/BP_[^/]+%.[^/]+$")
  if key then
    return key
  end
  -- Fallback: strip BP_ prefix and _C suffix from the class name
  key = assetPath:match("/BP_(%w+)%.%w+_C$")
  if key then
    return key
  end
  return nil
end

-- Serialize vehicle to a saveable table
local function SerializeVehicle(vehicle)
  local data = {}
  data.AssetPath = GetVehicleAssetPath(vehicle)
  data.VehicleKey = GetVehicleKeyFromAssetPath(data.AssetPath)

  if vehicle.Customization:IsValid() then
    data.customization = vehicleSerialization.VehicleCustomizationToTable(vehicle.Customization)
  end

  if vehicle.Net_Decal:IsValid() then
    data.decal = vehicleSerialization.VehicleDecalToTable(vehicle.Net_Decal)
  end

  if vehicle.Net_Parts:IsValid() then
    data.parts = {}
    vehicle.Net_Parts:ForEach(function(index, element)
      local part = element:get()
      if part:IsValid() then
        table.insert(data.parts, vehicleSerialization.VehiclePartToTable(part))
      end
    end)
  end

  return data
end

-- Apply saved config to a spawned vehicle
local function ApplyVehicleConfig(vehicle, config, PC)
  -- Customization
  if config.customization then
    vehicle.Customization.BodyMaterialIndex = config.customization.BodyMaterialIndex
    if vehicle.Customization.BodyColors:IsValid() then
      vehicle.Customization.BodyColors:Empty()
      for i, bc in ipairs(config.customization.BodyColors) do
        vehicle.Customization.BodyColors[i] = {
          MaterialSlotName = FName(bc.MaterialSlotName),
          Color = bc.Color,
        }
      end
    end
    PC:ServerSetVehicleCustomization(vehicle, {
      BodyMaterialIndex = config.customization.BodyMaterialIndex,
      BodyColors = vehicle.Customization.BodyColors,
    })
  end

  -- Decals
  if config.decal and vehicle.Net_Decal:IsValid() and vehicle.Net_Decal.DecalLayers:IsValid() then
    local decal = vehicleSerialization.TableToVehicleDecal(config.decal)
    vehicle.Net_Decal.DecalLayers:Empty()
    for i, layer in ipairs(decal.DecalLayers) do
      vehicle.Net_Decal.DecalLayers[i] = layer
    end
    vehicle:ServerSetDecal({ DecalLayers = vehicle.Net_Decal.DecalLayers })
  end

  -- Parts
  if config.parts and vehicle.Net_Parts:IsValid() then
    vehicle.Net_Parts:Empty()
    for i, part in ipairs(config.parts) do
      vehicle.Net_Parts[i] = vehicleSerialization.TableToVehiclePart(part)
    end
    vehicle:ServerSetParts(vehicle.Net_Parts)
  end
end

---Build FMTVehicleSpawnParams from a saved vehicle config.
---@param config table
---@param location table? FVector-like table {X, Y, Z}
---@param rotation table? FRotator-like table {Pitch, Yaw, Roll}
---@return table
local function BuildSpawnParams(config, location, rotation)
  local params = {
    VehicleKey = FName(config.VehicleKey or "Pickup"),
    AbsoluteLocation = location or { X = 0, Y = 0, Z = 0 },
    Rotation = rotation or { Pitch = 0, Yaw = 0, Roll = 0 },
    VehicleId = 0,
    bResetOnSpawn = true,
    bUseRandomCustomization = false,
    bForSale = false,
  }

  if config.customization then
    params.Customization = {
      BodyMaterialIndex = config.customization.BodyMaterialIndex or 0,
      BodyColors = {},
    }
    if config.customization.BodyColors then
      for i, bc in ipairs(config.customization.BodyColors) do
        params.Customization.BodyColors[i] = {
          MaterialSlotName = FName(bc.MaterialSlotName),
          Color = bc.Color,
          Metallic = bc.Metallic or 0.5,
          Roughness = bc.Roughness or 0.5,
        }
      end
    end
  end

  if config.decal then
    params.Decal = vehicleSerialization.TableToVehicleDecal(config.decal)
  end

  if config.parts then
    params.Parts = {}
    for i, part in ipairs(config.parts) do
      params.Parts[i] = vehicleSerialization.TableToVehiclePart(part)
    end
  end

  return params
end

local function SaveVehicle(name, config)
  ensureDir()
  local path = saveDir .. "/" .. name .. ".json"
  local f, err = io.open(path, "wb")
  if f then
    f:write(json.stringify(config))
    f:close()
    LogOutput("INFO", "Vehicle saved: %s", name)
  else
    LogOutput("WARN", "Failed to save vehicle '%s': %s", name, err or "unknown error")
  end
end

local function LoadVehicle(name)
  local path = saveDir .. "/" .. name .. ".json"
  local f, err = io.open(path, "rb")
  if not f then
    return nil
  end
  local raw = f:read("*a")
  f:close()
  local ok, data = pcall(json.parse, raw)
  if ok and type(data) == "table" then
    return data
  end
  LogOutput("WARN", "Failed to parse vehicle save '%s'", name)
  return nil
end

return {
  SerializeVehicle = SerializeVehicle,
  ApplyVehicleConfig = ApplyVehicleConfig,
  BuildSpawnParams = BuildSpawnParams,
  GetVehicleKeyFromAssetPath = GetVehicleKeyFromAssetPath,
  SaveVehicle = SaveVehicle,
  LoadVehicle = LoadVehicle,
}
