---GUID utility functions for MotorTown
---@class Guid

local Guid = {}

---Convert FGuid to string
---@param guid FGuid
---@return string # 32-character uppercase hex string (e.g., "00112233445566778899AABBCCDDEEFF")
function Guid.ToString(guid)
  if guid == nil then
    return "0000"
  end

  if type(guid) == "table" then return "0000" end

  if type(guid.IsValid) == "function" and not guid:IsValid() then
    return "0000"
  end
  
  local rawGuid = { guid.A, guid.B, guid.C, guid.D }
  local strGuid = ""
  for index, value in ipairs(rawGuid) do
    if value < 0 then
      rawGuid[index] = rawGuid[index] + 0x100000000
    end
    strGuid = string.format("%s%08x", strGuid, rawGuid[index])
  end
  return strGuid:upper()
end

---Convert string to FGuid. If no input is provided, a random Guid will be generated.
---@param input string? # 32-character hex string, or nil for random GUID
---@return FGuid
function Guid.FromString(input)
  local s = {}

  if input then
    if #input ~= 32 then
      error(input .. " is not a valid Guid")
    end

    for i = 1, #input, 8 do
      local a = input:sub(i, i + 8 - 1)
      table.insert(s, tonumber(a, 16))
    end
  else
    return {
      A = math.random(1000000000, 9999999999),
      B = math.random(1000000000, 9999999999),
      C = math.random(1000000000, 9999999999),
      D = math.random(1000000000, 9999999999)
    }
  end
  
  if #s == 4 then
    return {
      A = s[1],
      B = s[2],
      C = s[3],
      D = s[4]
    }
  end
  error(input .. " is not a valid Guid")
end

---Check if a string is a valid GUID format
---@param input string
---@return boolean
function Guid.IsValid(input)
  if type(input) ~= "string" then
    return false
  end
  if #input ~= 32 then
    return false
  end
  return input:match("^[0-9A-Fa-f]+$") ~= nil
end

return Guid
