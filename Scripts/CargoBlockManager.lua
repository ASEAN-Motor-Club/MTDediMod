---CargoBlockManager.lua
---Backend-pushed illicit-cargo KEY BLOCK SET (freeman 2026-09-29).
---
---The mod is dumb: it keeps an IN-MEMORY set of cargo keys that must never
---stay strapped. Written only via the webserver endpoints below; the backend
---(or the operator) pushes the list directly. The reference list is
---ILLICIT_CARGO_KEYS in amc-backend's special_cargo.py.
---
---State is memory-only by design: the pusher is the source of truth, so a
---game restart (or hot reload) clears the set until the list is pushed again.
---
---Enforcement lives in IllicitCargoManager.lua (ServerStrapCargo hook):
---new strap attempts on a blocked key are unstrapped immediately. Already
---strapped cargo is NOT swept — only new strap attempts are enforced.

local json = require("JsonParser")

local blockedKeys = {}      -- lowercase key -> true
local blockedKeyCount = 0
local stats = {
  listUpdates = 0,
  strapAttemptsSeen = 0,
  strapsBlocked = 0,
  unstrapCallsFailed = 0,
}

local lastUpdate = nil      -- { At = iso-ish string, KeyCount = n }

---Normalize a cargo key for comparison (FName ToString casing varies).
---@param key string
---@return string
local function NormalizeKey(key)
  return string.lower(key or "")
end

---@param keys table list of cargo key strings
---@return boolean ok, number|nil count
local function SetBlockedKeys(keys)
  if type(keys) ~= "table" then
    return false
  end

  local newSet = {}
  local n = 0
  for _, key in ipairs(keys) do
    if type(key) ~= "string" then
      return false
    end
    local normalized = NormalizeKey(key)
    if normalized ~= "" and newSet[normalized] == nil then
      newSet[normalized] = true
      n = n + 1
    end
  end

  blockedKeys = newSet
  blockedKeyCount = n
  stats.listUpdates = stats.listUpdates + 1

  local shown = {}
  for key in pairs(newSet) do
    table.insert(shown, key)
  end
  table.sort(shown)
  lastUpdate = { KeyCount = n }
  LogOutput("INFO", "[CargoBlock] Blocked key list updated (%d keys): %s", n,
    table.concat(shown, ", "))
  return true, n
end

---@param key string raw cargo key (any casing)
---@return boolean
local function IsBlockedKey(key)
  if not key or key == "" then return false end
  return blockedKeys[NormalizeKey(key)] == true
end

---@return table state snapshot
local function GetState()
  local keys = {}
  for key in pairs(blockedKeys) do
    table.insert(keys, key)
  end
  table.sort(keys)
  return {
    Keys = keys,
    KeyCount = blockedKeyCount,
    Stats = stats,
    LastUpdate = lastUpdate,
  }
end

---POST /cargo/blocked_keys
---Body: {"Keys": ["Money", "Ganja", ...]} — full replace; absent/empty Keys
---clears enforcement. Non-string / non-array bodies are rejected so a typo
---can never silently weaken (or wrongly strengthen) enforcement.
---@type RequestPathHandler
local function HandleSetBlockedCargoKeys(session)
  local keys = nil
  if session.content and session.content ~= "" then
    local ok, data = pcall(json.parse, session.content)
    if not ok or type(data) ~= "table" then
      return { error = "Invalid body" }, nil, 400
    end
    if type(data.Keys) ~= "table" then
      return { error = "Invalid Keys (expected array of strings)" }, nil, 400
    end
    keys = data.Keys
  else
    keys = {}
  end

  local ok, count = SetBlockedKeys(keys)
  if not ok then
    return { error = "Invalid Keys (expected array of strings)" }, nil, 400
  end

  return {
    status = count > 0 and "blocked_keys_enabled" or "blocked_keys_cleared",
    KeyCount = count,
    Stats = stats,
  }, nil, 200
end

local function RecordStrapAttempt()
  stats.strapAttemptsSeen = stats.strapAttemptsSeen + 1
end

local function RecordStrapBlocked()
  stats.strapsBlocked = stats.strapsBlocked + 1
end

local function RecordUnstrapFailure()
  stats.unstrapCallsFailed = stats.unstrapCallsFailed + 1
end

---GET /cargo/blocked_keys — read-only; never mutates state.
---@type RequestPathHandler
local function HandleGetBlockedCargoKeys(session)
  return { data = GetState() }, nil, 200
end

return {
  SetBlockedKeys = SetBlockedKeys,
  IsBlockedKey = IsBlockedKey,
  GetState = GetState,
  RecordStrapAttempt = RecordStrapAttempt,
  RecordStrapBlocked = RecordStrapBlocked,
  RecordUnstrapFailure = RecordUnstrapFailure,
  HandleSetBlockedCargoKeys = HandleSetBlockedCargoKeys,
  HandleGetBlockedCargoKeys = HandleGetBlockedCargoKeys,
}
