--- Named teleport destinations loaded from a JSON file.
---
--- Resolution order:
---   1. MOD_TP_LOCATIONS_FILE (absolute path; Nix sets this to a store JSON so
---      the list is declarative and survives rebuilds), otherwise
---   2. "tp_locations.json" relative to the server working directory, which is
---      the instance state dir (/var/lib/motortown-server[-<name>]) and so
---      survives restarts and game updates.
---
--- File shape:
---   { "locations": [ { "name": "shibaura", "x": 110237, "y": -470902, "z": 87511 }, ... ] }
--- Coordinates are UE centimetres. Z should be ~100 above the destination
--- ground so the character capsule does not spawn intersecting the floor.
---
--- The file is re-read on every command, so editing it takes effect without a
--- mod reload and without a server restart.
local json = require("JsonParser")

local M = {}

local function FilePath()
  local fromEnv = os.getenv("MOD_TP_LOCATIONS_FILE")
  if fromEnv ~= nil and fromEnv ~= "" then
    return fromEnv
  end
  return "tp_locations.json"
end

--- @return table<string, {x:number, y:number, z:number}> locations by lowercase name
--- @return string|nil error when the file is missing or unparsable
local function ReadAll()
  local path = FilePath()
  local f = io.open(path, "r")
  if f == nil then
    return {}, "no locations file at " .. path
  end
  local content = f:read("*a")
  f:close()

  local ok, parsed = pcall(json.parse, content)
  if not ok or type(parsed) ~= "table" or type(parsed.locations) ~= "table" then
    return {}, "could not parse " .. path
  end

  local out = {}
  for _, entry in ipairs(parsed.locations) do
    if type(entry) == "table" and type(entry.name) == "string"
      and tonumber(entry.x) and tonumber(entry.y) and tonumber(entry.z) then
      out[string.lower(entry.name)] = {
        x = tonumber(entry.x),
        y = tonumber(entry.y),
        z = tonumber(entry.z),
      }
    end
  end
  return out, nil
end

--- True when a usable locations file exists. Used to decide whether the chat
--- command hook should arm at all on an instance.
function M.Available()
  local locations = ReadAll()
  return next(locations) ~= nil
end

--- @return table|nil location {x, y, z} for the name, nil when unknown
function M.Get(name)
  local locations = ReadAll()
  return locations[string.lower(name)]
end

--- @return string[] sorted destination names
function M.Names()
  local locations = ReadAll()
  local names = {}
  for name in pairs(locations) do
    table.insert(names, name)
  end
  table.sort(names)
  return names
end

return M
