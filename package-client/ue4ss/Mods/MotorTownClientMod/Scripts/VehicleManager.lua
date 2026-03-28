local json = require("JsonParser")

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

return {
  DespawnPlayerVehicle = DespawnPlayerVehicle,
}
