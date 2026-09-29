---StrapBlockManager.lua
---Backend-pushed cargo strap blocking (freeman 2026-09-29).
---
---The mod is dumb and domain-agnostic: it keeps an IN-MEMORY set of cargo
---keys that must not stay strapped, written only by the pusher via the
---webserver endpoints below. The mod does not know or care WHY a key is
---blocked (illicit cargo, admin hold, anything else) — the pusher composes
---the list and owns the meaning of the keys.
---
---State is memory-only by design: the pusher is the source of truth, so a
---game restart (or hot reload) clears the set until the list is pushed again.
---
---Enforcement (ServerStrapCargo two-callback hook): UE4SS hooks cannot
---cancel a server RPC, so the strap is allowed to land and the POST-callback
---immediately calls ServerUnstrapCargo on the same PC. Registration uses a
---SafeRegisterHook wrapper (a bad top-level hook aborts the whole Lua chunk
---and bricks the mod API). Net_Strap is NOT consulted: enforcement is purely
---hook-driven on new strap attempts — already-strapped cargo is NOT swept.

local json = require("JsonParser")

-- ---------------------------------------------------------------------------
-- Blocked key set (backend-pushed, memory-only)
-- ---------------------------------------------------------------------------

local blockedKeys = {}      -- lowercase key -> true
local blockedKeyCount = 0
local stats = {
  listUpdates = 0,
  strapAttemptsSeen = 0,
  strapsBlocked = 0,
  unstrapCallsFailed = 0,
}

local lastUpdate = nil      -- { KeyCount = n }

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
  LogOutput("INFO", "[StrapBlock] Blocked key list updated (%d keys): %s", n,
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

local function RecordStrapAttempt()
  stats.strapAttemptsSeen = stats.strapAttemptsSeen + 1
end

local function RecordStrapBlocked()
  stats.strapsBlocked = stats.strapsBlocked + 1
end

local function RecordUnstrapFailure()
  stats.unstrapCallsFailed = stats.unstrapCallsFailed + 1
end

---POST /cargo/blocked_keys
---Body: {"Keys": ["Money", "Ganja", ...]} — full replace; empty Keys clears
---enforcement. Non-string / non-array bodies are rejected so a typo can
---never silently weaken (or wrongly strengthen) enforcement.
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

---GET /cargo/blocked_keys — read-only; never mutates state.
---@type RequestPathHandler
local function HandleGetBlockedCargoKeys(session)
  return { data = GetState() }, nil, 200
end

-- ---------------------------------------------------------------------------
-- ServerStrapCargo enforcement hook
-- ---------------------------------------------------------------------------

---RegisterHook THROWS on an unregistrable UFunction — fail soft instead of
---killing the module chunk (same wrapper as RPManager.lua).
local function SafeRegisterHook(path, preFn, postFn)
  local ok, err = pcall(RegisterHook, path, preFn, postFn)
  if not ok then
    LogOutput("WARNING", "[StrapBlock] RegisterHook FAILED for %s: %s", tostring(path), tostring(err))
  end
  return ok
end

---Best-effort display name for log attribution (same shape as RPManager).
local function GetPlayerName(playerController)
  if not playerController or not playerController:IsValid() then return "?" end
  local PS = playerController.PlayerState
  if not PS or not PS:IsValid() then return "?" end
  local ok, name = pcall(function()
    local n = PS:GetPlayerName()
    if type(n) == "userdata" then return n:ToString() end
    return tostring(n)
  end)
  if not ok or not name or name == "" then return "?" end
  return name
end

---Resolve a cargo actor's Net_CargoKey safely.
---@param cargo AMTCargo
---@return string|nil
local function GetCargoKey(cargo)
  if not cargo or not cargo:IsValid() then return nil end
  local ok, key = pcall(function()
    local k = cargo.Net_CargoKey
    if k == nil then return nil end
    return k:ToString()
  end)
  if not ok then return nil end
  if type(key) == "userdata" then
    local ok2, s = pcall(function() return key:ToString() end)
    if ok2 then key = s else key = nil end
  end
  return key
end

---Pre-hook marks blocked straps in this per-call pending table (keyed on the
---cargo's full instance name) so the post-hook knows which call to act on.
local pendingStraps = {}

local hookStatus = "not_registered"

hookStatus = SafeRegisterHook(
  "/Script/MotorTown.MotorTownPlayerController:ServerStrapCargo",
  function(PC, Cargo)
    local ok, err = pcall(function()
      local playerController = PC:get()
      local cargo = Cargo:get()
      if not playerController or not playerController:IsValid() then return end
      if not cargo or not cargo:IsValid() then return end

      local key = GetCargoKey(cargo)
      if not key then return end

      RecordStrapAttempt()

      if not IsBlockedKey(key) then return end

      local cargoName = cargo:GetFullName()
      pendingStraps[cargoName] = key
      LogOutput("INFO", "[StrapBlock] Strap attempt on blocked cargo %s by %s — unstrapping",
        key, GetPlayerName(playerController))
    end)
    if not ok then
      LogOutput("ERROR", "[StrapBlock] Pre-hook error: %s", tostring(err))
    end
  end,
  function(PC, Cargo)
    local ok, err = pcall(function()
      local playerController = PC:get()
      local cargo = Cargo:get()
      if not cargo or not cargo:IsValid() then
        pendingStraps = {}
        return
      end
      local cargoName = cargo:GetFullName()
      local key = pendingStraps[cargoName]
      pendingStraps[cargoName] = nil
      if not key then return end

      if not playerController or not playerController:IsValid() then return end

      local unstrapOk, unstrapErr = pcall(function()
        playerController:ServerUnstrapCargo(cargo)
      end)
      if unstrapOk then
        RecordStrapBlocked()
        LogOutput("INFO", "[StrapBlock] Unstrapped blocked cargo %s for %s",
          key, GetPlayerName(playerController))
      else
        RecordUnstrapFailure()
        LogOutput("ERROR", "[StrapBlock] ServerUnstrapCargo FAILED for %s: %s",
          key, tostring(unstrapErr))
      end

      local playerId = nil
      local playerGuid = nil
      pcall(function() playerId = GetPlayerUniqueId(playerController) end)
      pcall(function() playerGuid = GetPlayerGuid(playerController) end)
      EnqueueWebhookEvent("StrapBlocked", {
        PlayerId = playerId,
        CharacterGuid = playerGuid,
        CargoKey = key,
      })
    end)
    if not ok then
      LogOutput("ERROR", "[StrapBlock] Post-hook error: %s", tostring(err))
    end
  end
)

LogOutput("INFO", "[StrapBlock] Loaded (hookStatus=%s)", hookStatus and "registered" or "failed")

return {
  SetBlockedKeys = SetBlockedKeys,
  IsBlockedKey = IsBlockedKey,
  GetState = GetState,
  HandleSetBlockedCargoKeys = HandleSetBlockedCargoKeys,
  HandleGetBlockedCargoKeys = HandleGetBlockedCargoKeys,
  GetHookStatus = function() return hookStatus end,
}
