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
  local count = 0
  if custom.BodyColors:IsValid() then
    custom.BodyColors:ForEach(function(index, element)
      local bodyColor = element:get()
      if bodyColor:IsValid() then
        count = count + 1
        data.BodyColors[count] = {
          MaterialSlotName = element:get().MaterialSlotName:ToString(),
          Color = types.ColorToTable(element:get().Color),
        }
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
  local count = 0

  if decal.DecalLayers:IsValid() then
    decal.DecalLayers:ForEach(function(index, element)
      local layer = element:get()
      if layer:IsValid() then
        count = count + 1
        data[count] = VehicleSerialization.VehicleDecalLayerToTable(layer)
      end
    end)
  end

  return {
    DecalLayers = data,
  }
end

function VehicleSerialization.TableToVehicleDecal(decal)
  local decalLayers = {}
  local count = 0

  for index, value in ipairs(decal.DecalLayers) do
    count = count + 1
    decalLayers[count] = VehicleSerialization.TableToVehicleDecalLayer(value)
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
  local floatCount = 0
  if part.FloatValues:IsValid() then
    part.FloatValues:ForEach(function(index, element)
      floatCount = floatCount + 1
      data.FloatValues[floatCount] = element:get()
    end)
  end

  data.Int64Values = {} ---@type number[]
  local int64Count = 0
  if part.Int64Values:IsValid() then
    part.Int64Values:ForEach(function(index, element)
      int64Count = int64Count + 1
      data.Int64Values[int64Count] = element:get()
    end)
  end

  data.StringValues = {} ---@type string[]
  local stringCount = 0
  if part.StringValues:IsValid() then
    part.StringValues:ForEach(function(index, element)
      stringCount = stringCount + 1
      data.StringValues[stringCount] = element:get():ToString()
    end)
  end

  data.VectorValues = {} ---@type table[]
  local vectorCount = 0
  if part.VectorValues:IsValid() then
    part.VectorValues:ForEach(function(index, element)
      vectorCount = vectorCount + 1
      data.VectorValues[vectorCount] = types.VectorToTable(element:get())
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
