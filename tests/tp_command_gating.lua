-- Direct test of the /tp chat-hook gate in Commands.lua.
-- Stubs the engine surface, loads the real Commands.lua + TeleportLocations.lua,
-- and reports whether OUR ServerSendChat hook armed in each scenario.
local scriptDir = arg[1] or "Scripts"

local registered = {}
local envValue = nil

function LogOutput(...) end
function RequireSafe(name) return nil end
function FText(s) return s end
function SplitString(s, sep)
  local out = {}
  for part in string.gmatch(s, "([^" .. sep .. "]+)") do table.insert(out, part) end
  return out
end
function StaticFindObject(path) return { fake = true } end
function RegisterHook(path, pre, post)
  table.insert(registered, path)
  return 1
end

local realGetenv = os.getenv
os.getenv = function(k)
  if k == "MOD_CHAT_COMMANDS" then return envValue end
  if k == "MOD_TP_LOCATIONS_FILE" then return nil end
  return nil
end

local realRequire = require
require = function(name)
  if name == "VehicleManager" then return {} end
  if name == "RepairManager" then
    return { RepairPlayerVehicle = function() return { ok = false, error = "no_vehicle" } end }
  end
  if name == "TeleportAllow" then return { Take = function() end, Release = function() end } end
  if name == "JsonParser" or name == "TeleportLocations" then
    local chunk = assert(loadfile(scriptDir .. "/" .. name .. ".lua"))
    return chunk()
  end
  return realRequire(name)
end

local function run(label)
  registered = {}
  local ok, err = pcall(dofile, scriptDir .. "/Commands.lua")
  local armed = false
  for _, p in ipairs(registered) do
    if p:find("ServerSendChat") then armed = true end
  end
  print(string.format("%-46s loaded=%s chat_hook_armed=%s", label, tostring(ok), tostring(armed)))
  if not ok then print("  ERROR: " .. tostring(err)) end
end

-- 1. Production / staging Jeju: no env, no locations file anywhere.
envValue = nil
os.remove("tp_locations.json")
run("no env, no file (prod/staging Jeju)")

-- 2. Explicit operator opt-in.
envValue = "1"
run("MOD_CHAT_COMMANDS=1, no file")

-- 3. Locations file present, no env (fallback path).
envValue = nil
local f = assert(io.open("tp_locations.json", "w"))
f:write('{"locations":[{"name":"a","x":1,"y":2,"z":3}]}')
f:close()
run("no env, tp_locations.json present")

-- 4. Malformed file must fail closed, never arm.
local g = assert(io.open("tp_locations.json", "w"))
g:write("this is not json")
g:close()
run("no env, malformed locations file")
os.remove("tp_locations.json")
