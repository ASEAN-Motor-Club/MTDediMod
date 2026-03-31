local json = require("JsonParser")

---Collect the LastVehicle + trailer chain vehicle IDs
---@param PC AMotorTownPlayerController
---@return table<integer, boolean> set of Net_VehicleId values in the chain
local function GetLastVehicleChainIds(PC)
  local keepIds = {}
  if PC.LastVehicle ~= nil and PC.LastVehicle:IsValid() then
    local curr = PC.LastVehicle ---@type AMTVehicle?
    while curr ~= nil and curr:IsValid() and curr.Net_Hooks:IsValid() do
      local v = curr
      keepIds[v.Net_VehicleId] = true
      curr = nil
      v.Net_Hooks:ForEach(function(i, val)
        local hook = val:get()
        if hook:IsValid() and hook.Trailer:IsValid() and hook.Trailer.Net_VehicleId ~= v.Net_VehicleId then
          curr = hook.Trailer
        end
      end)
    end
  end
  return keepIds
end

---Despawn the player's current vehicle and any attached trailers
---@param PC AMotorTownPlayerController
---@return integer count Number of vehicles despawned
local function DespawnPlayerVehicle(PC)
  local count = 0
  if PC.LastVehicle ~= nil and PC.LastVehicle:IsValid() then
    local vehiclesToDespawn = {}
    local curr = PC.LastVehicle ---@type AMTVehicle?
    while curr ~= nil and curr:IsValid() and curr.Net_Hooks:IsValid() do
      local v = curr
      table.insert(vehiclesToDespawn, v)
      curr = nil
      v.Net_Hooks:ForEach(function(i, val)
        local hook = val:get()
        if hook:IsValid() and hook.Trailer:IsValid() and hook.Trailer.Net_VehicleId ~= v.Net_VehicleId then
          curr = hook.Trailer
        end
      end)
    end

    for _, vehicle in ipairs(vehiclesToDespawn) do
      if vehicle:IsValid() then
        PC:ServerDespawnVehicle(vehicle, 0)
        count = count + 1
      end
    end
  end
  return count
end

---Despawn ALL player vehicles from Net_SpawnedVehicles
---@param PC AMotorTownPlayerController
---@return integer count Number of vehicles despawned
local function DespawnAllPlayerVehicles(PC)
  local count = 0
  if not PC.Net_SpawnedVehicles:IsValid() then return count end

  local vehiclesToDespawn = {}
  PC.Net_SpawnedVehicles:ForEach(function(index, element)
    local vehicle = element:get()
    if vehicle:IsValid() and not vehicle:IsActorBeingDestroyed() then
      table.insert(vehiclesToDespawn, vehicle)
    end
  end)

  for _, vehicle in ipairs(vehiclesToDespawn) do
    if vehicle:IsValid() then
      PC:ServerDespawnVehicle(vehicle, 0)
      count = count + 1
    end
  end
  return count
end

---Despawn all player vehicles EXCEPT the LastVehicle chain
---@param PC AMotorTownPlayerController
---@return integer count Number of vehicles despawned
local function DespawnOtherPlayerVehicles(PC)
  local count = 0
  if not PC.Net_SpawnedVehicles:IsValid() then return count end

  local keepIds = GetLastVehicleChainIds(PC)
  local vehiclesToDespawn = {}
  PC.Net_SpawnedVehicles:ForEach(function(index, element)
    local vehicle = element:get()
    if vehicle:IsValid() and not vehicle:IsActorBeingDestroyed() and not keepIds[vehicle.Net_VehicleId] then
      table.insert(vehiclesToDespawn, vehicle)
    end
  end)

  for _, vehicle in ipairs(vehiclesToDespawn) do
    if vehicle:IsValid() then
      PC:ServerDespawnVehicle(vehicle, 0)
      count = count + 1
    end
  end
  return count
end

return {
  DespawnPlayerVehicle = DespawnPlayerVehicle,
  DespawnAllPlayerVehicles = DespawnAllPlayerVehicles,
  DespawnOtherPlayerVehicles = DespawnOtherPlayerVehicles,
}
