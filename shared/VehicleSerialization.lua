---Shared bidirectional serialization for vehicle customization, decals, and parts
---Used by both server (Scripts/VehicleManager.lua) and client (ClientScripts/VehicleSaveSpawn.lua)

local types = require("MTHelpers.Types")

local VehicleSerialization = {}

---Convert FMTVehicleCustomization to JSON serializable table
---@param custom FMTVehicleCustomization
---@return table
function VehicleSerialization.VehicleCustomizationToTable(custom)
  local data = {}

  data.BodyMaterialIndex = custom.BodyMaterialIndex

  data.BodyColors = {}
  if custom.BodyColors:IsValid() then
    custom.BodyColors:ForEach(function(index, element)
      local bodyColor = element:get()
      if bodyColor:IsValid() then
        table.insert(data.BodyColors, {
          MaterialSlotName = element:get().MaterialSlotName:ToString(),
          Color = types.ColorToTable(element:get().Color),
        })
      end
    end)
  end

  return data
end

function VehicleSerialization.TableToVehicleCustomization(t, custom)
  custom.BodyColors:Empty()
  for index, value in ipairs(t.BodyColors) do
    custom.BodyColors[index] = {
      MaterialSlotName = FName(value.MaterialSlotName),
      Color = value.Color,
      Metallic = value.Metallic,
      Roughness = value.Roughness,
    }
  end
  return {
    BodyMaterialIndex = t.BodyMaterialIndex,
    BodyColors = custom.BodyColors,
  }
end

---Convert FMTVehicleDecalLayer to JSON serializable table
---@param decal FMTVehicleDecalLayer
---@return table
function VehicleSerialization.VehicleDecalLayerToTable(decal)
  return {
    DecalKey = decal.DecalKey:ToString(),
    Color = types.ColorToTable(decal.Color),
    Position = types.Vector2DToTable(decal.Position),
    Rotation = types.RotatorToTable(decal.Rotation),
    DecalScale = decal.DecalScale,
    Stretch = decal.Stretch,
    Coverage = decal.Coverage,
    Flags = decal.Flags,
  }
end

function VehicleSerialization.TableToVehicleDecalLayer(decal)
  return {
    DecalKey = FName(decal.DecalKey),
    Color = decal.Color,
    Position = decal.Position,
    Rotation = decal.Rotation,
    DecalScale = decal.DecalScale,
    Stretch = decal.Stretch,
    Coverage = decal.Coverage,
    Flags = decal.Flags,
  }
end

---Convert FMTVehicleDecal to JSON serializable table
---@param decal FMTVehicleDecal
---@return table
function VehicleSerialization.VehicleDecalToTable(decal)
  local data = {}

  if decal.DecalLayers:IsValid() then
    decal.DecalLayers:ForEach(function(index, element)
      local layer = element:get()
      if layer:IsValid() then
        table.insert(data, VehicleSerialization.VehicleDecalLayerToTable(layer))
      end
    end)
  end

  return {
    DecalLayers = data,
  }
end

function VehicleSerialization.TableToVehicleDecal(decal)
  local decalLayers = {}

  for index, value in ipairs(decal.DecalLayers) do
    table.insert(decalLayers, VehicleSerialization.TableToVehicleDecalLayer(value))
  end

  return {
    DecalLayers = decalLayers,
  }
end

---Convert FMTVehiclePart to JSON serializable table
---@param part FMTVehiclePart
---@return table
function VehicleSerialization.VehiclePartToTable(part)
  if not part:IsValid() or (IsUObjectSafe and not IsUObjectSafe(part)) then
    return {}
  end
  local data = {}

  data.ID = part.ID
  data.Key = part.Key:ToString()
  data.Slot = part.Slot
  data.Damage = part.Damage

  data.FloatValues = {} ---@type number[]
  if part.FloatValues:IsValid() then
    part.FloatValues:ForEach(function(index, element)
      table.insert(data.FloatValues, element:get())
    end)
  end

  data.Int64Values = {} ---@type number[]
  if part.Int64Values:IsValid() then
    part.Int64Values:ForEach(function(index, element)
      table.insert(data.Int64Values, element:get())
    end)
  end

  data.StringValues = {} ---@type string[]
  if part.StringValues:IsValid() then
    part.StringValues:ForEach(function(index, element)
      table.insert(data.StringValues, element:get():ToString())
    end)
  end

  data.VectorValues = {} ---@type table[]
  if part.VectorValues:IsValid() then
    part.VectorValues:ForEach(function(index, element)
      table.insert(data.VectorValues, types.VectorToTable(element:get()))
    end)
  end

  ---@diagnostic disable-next-line: undefined-field
  if part.ItemInventory:IsValid() then
    data.ItemInventory = types.ItemInventoryToTable(part.ItemInventory)
  end

  return data
end

function VehicleSerialization.TableToVehiclePart(part)
  local data = part

  if part.partKey ~= nil then
    data.Key = FName(part.partKey)
  else
    data.Key = FName(part.Key)
  end
  data.ItemInventory = types.TableToItemInventory(part.ItemInventory)

  return data
end

return VehicleSerialization
