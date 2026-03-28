---Type conversion utilities for MotorTown
---Converts Unreal Engine types to JSON-serializable Lua tables
---@class Types

local Types = {}

---Convert FVector to JSON serializable table
---@param vector FVector
---@return table|nil # {X, Y, Z} or nil if invalid
function Types.VectorToTable(vector)
  if vector ~= nil and type(vector.IsValid) == "function" and not vector:IsValid() then
    return nil
  end
  return {
    X = vector.X,
    Y = vector.Y,
    Z = vector.Z
  }
end

---Convert FQuat to JSON serializable table
---@param rotation FQuat
---@return table # {W, X, Y, Z}
function Types.QuatToTable(rotation)
  return {
    W = rotation.W,
    X = rotation.X,
    Y = rotation.Y,
    Z = rotation.Z
  }
end

---Convert FRotator to JSON serializable table
---@param rotation FRotator
---@return table # {Pitch, Yaw, Roll}
function Types.RotatorToTable(rotation)
  return {
    Pitch = rotation.Pitch,
    Yaw = rotation.Yaw,
    Roll = rotation.Roll
  }
end

---Convert FTransform to JSON serializable table
---@param transform FTransform
---@return table # {Location, Rotation, Scale3D}
function Types.TransformToTable(transform)
  local location = Types.VectorToTable(transform.Translation)
  local rotation = Types.QuatToTable(transform.Rotation)
  local scale = Types.VectorToTable(transform.Scale3D)
  return {
    Location = location,
    Rotation = rotation,
    Scale3D = scale
  }
end

---Convert FColor to JSON serializable table
---@param color FColor
---@return table # {R, G, B, A}
function Types.ColorToTable(color)
  return {
    R = color.R,
    G = color.G,
    B = color.B,
    A = color.A
  }
end

---Converts FVector2D to JSON serializable table
---@param vector FVector2D
---@return table # {X, Y}
function Types.Vector2DToTable(vector)
  return {
    X = vector.X,
    Y = vector.Y
  }
end

---Convert FMTCharacterId to JSON serializable table
---@param characterId FMTCharacterId
---@return table # {CharacterGuid, UniqueNetId}
function Types.CharacterIdToTable(characterId)
  local Guid = require("MTHelpers.Guid")
  return {
    CharacterGuid = Guid.ToString(characterId.CharacterGuid),
    UniqueNetId = characterId.UniqueNetId:ToString(),
  }
end

---Convert FMTShadowedInt64 to JSON serializable table
---@param reward FMTShadowedInt64
---@return table # {BaseValue, ShadowedValue}
function Types.RewardToTable(reward)
  if not reward:IsValid() then
    return {}
  end
  return {
    BaseValue = reward.BaseValue,
    ShadowedValue = reward.ShadowedValue
  }
end

---Convert FMTRoute to JSON serializable table
---@param route FMTRoute
---@return table # {RouteName, Waypoints}
function Types.RouteToTable(route)
  local data = {}

  data.RouteName = route.RouteName:ToString()
  data.Waypoints = {}
  route.Waypoints:ForEach(function(index, element)
    table.insert(data.Waypoints, Types.TransformToTable(element:get()))
  end)
  return data
end

---Convert FMTSettingValue to JSON serializable table
---@param setting FMTSettingValue
---@return table
function Types.SettingValueToTable(setting)
  return {
    ValueType = setting.ValueType,
    FloatValue = setting.FloatValue,
    Int64Value = setting.Int64Value,
    BoolValue = setting.BoolValue,
    StringValue = setting.StringValue:ToString(),
    EnumValue = setting.EnumValue,
  }
end

---Convert FMTItemInventory to JSON serializable table
---@param item FMTItemInventory
---@return table # {Slots}
function Types.ItemInventoryToTable(item)
  local data = {}

  data.Slots = {}
  item.Slots:ForEach(function(index, element)
    table.insert(data.Slots, {
      Key = element:get().Key:ToString(),
      NumStack = element:get().NumStack
    })
  end)

  return data
end

---Convert table to FMTItemInventory (reverse of ItemInventoryToTable)
---@param item table
---@return table
function Types.TableToItemInventory(item)
  local data = item
  local slots = {}

  for i, slot in ipairs(data.Slots) do
    table.insert(slots, {
      Key = FName(slot.Key),
      NumStack = slot.NumStack
    })
  end
  data.Slots = slots

  return data
end

return Types
