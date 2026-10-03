---NoTeleportManager.lua
---Backend-pushed per-GUID no-teleport BLOCK SET (freeman 2026-09-23; block-set
---schema freeman 2026-09-28: "no teleport should be agnostic — accept flags
---for each type of teleport, whether they should be allowed or not").
---
---The mod is dumb: it keeps an IN-MEMORY map of character GUIDs -> block-set
---table, written only by the backend via the webserver endpoints below. No
---display-name involvement — the flag is invisible to other players (unlike
---the [R] tag, which reveals wanted status). No domain vocabulary (wanted /
---police / modes) lives here; the backend composes the block set.
---
---Block flags (absent guid = unrestricted; absent key = allowed):
---  block_teleport_character          — ServerTeleportCharacter
---  block_teleport_vehicle            — ServerTeleportVehicle
---  block_respawn_character           — ServerRespawnCharacter
---  block_reset_vehicle_keep_cargo    — ServerResetVehicleAt with
---                                      bRemoveCargo=false (roadside flow that
---                                      moves the vehicle WITH its cargo)
---  block_reset_vehicle_strip_cargo   — ServerResetVehicleAt with
---                                      bRemoveCargo=true (cargo-strip reset)
---
---State is memory-only by design: the backend is the source of truth and
---re-asserts the flags on every player login, so a game restart simply clears
---them until the backend pushes again.
---
---RPManager.lua consults GetNoTeleportBlocks() / IsBlocked() in the four
---server-side movement hooks (ServerTeleportCharacter / ServerTeleportVehicle /
---ServerRespawnCharacter / ServerResetVehicleAt) plus the roadside-service
---hook (ServerVehicleExControl, block_roadside_service — wanted players'
---names are blanked so the [R*] name-match can no longer carry that block).
---A full block set blocks
---UNCONDITIONALLY — the racetrack event-member allowance that applies to
---RP-mode players does NOT apply here: the set is deliberate enforcement
---(chased-close wanted / admin hold), not an RP immersion rule.

local json = require("JsonParser")

local BLOCK_KEYS = {
  "block_teleport_character",
  "block_teleport_vehicle",
  "block_respawn_character",
  "block_reset_vehicle_keep_cargo",
  "block_reset_vehicle_strip_cargo",
  "block_roadside_service",
}

local BLOCK_KEY_SET = {}
for _, k in ipairs(BLOCK_KEYS) do
  BLOCK_KEY_SET[k] = true
end

local noTeleportBlocks = {}

---@param guid string character GUID
---@param blocks table|nil block-flag table (keys from BLOCK_KEYS); nil/empty clears
local function SetNoTeleport(guid, blocks)
  if not guid or guid == "" then
    return false
  end
  if blocks and next(blocks) ~= nil then
    noTeleportBlocks[guid] = blocks
    local n = 0
    for _ in pairs(blocks) do n = n + 1 end
    LogOutput("INFO", string.format("[NoTeleport] ENABLED (%d flags) for %s", n, guid))
  else
    if noTeleportBlocks[guid] then
      LogOutput("INFO", string.format("[NoTeleport] cleared for %s", guid))
    end
    noTeleportBlocks[guid] = nil
  end
  return true
end

---@param guid string character GUID
---@return boolean
local function IsNoTeleportGuid(guid)
  return guid ~= nil and noTeleportBlocks[guid] ~= nil
end

---@param guid string character GUID
---@return table block set or nil when not flagged
local function GetNoTeleportBlocks(guid)
  if guid == nil then return nil end
  return noTeleportBlocks[guid]
end

---@param guid string character GUID
---@param key string one of BLOCK_KEYS
---@return boolean
local function IsBlocked(guid, key)
  local blocks = GetNoTeleportBlocks(guid)
  return blocks ~= nil and blocks[key] == true
end

---@return table list of {Guid, Blocks} currently flagged
local function GetNoTeleportGuids()
  local result = {}
  for guid, blocks in pairs(noTeleportBlocks) do
    table.insert(result, { Guid = guid, Blocks = blocks })
  end
  table.sort(result, function(a, b) return a.Guid < b.Guid end)
  return result
end

---Legacy body mapping (deprecated; accepted for one release so the current
---prod backend keeps working until its counterpart PR ships):
---{"Enabled": bool, "Mode": "all"|"reset_cargo_keep"|"wanted_roadside"}.
local function LegacyModeBlocks(mode)
  if mode == "all" then
    return {
      block_teleport_character = true,
      block_teleport_vehicle = true,
      block_respawn_character = true,
      block_reset_vehicle_keep_cargo = true,
      block_reset_vehicle_strip_cargo = true,
    }
  elseif mode == "reset_cargo_keep" then
    return { block_reset_vehicle_keep_cargo = true }
  elseif mode == "wanted_roadside" then
    return {
      block_teleport_character = true,
      block_teleport_vehicle = true,
      block_respawn_character = true,
      block_reset_vehicle_strip_cargo = true,
    }
  end
  return nil
end

---POST /players/{guid}/no_teleport
---Body: {"Blocks": {...}} — absent/empty Blocks clears the record; unknown
---keys are rejected so a typo can never silently weaken a lock.
---Legacy {"Enabled": bool, "Mode": ...} bodies are still accepted (mapped)
---for one release.
---@type RequestPathHandler
local function HandleSetPlayerNoTeleport(session)
  local guid = session.pathComponents[2]
  if not guid or guid == "" then
    return { error = "Invalid player GUID" }, nil, 400
  end

  local blocks = nil
  if session.content and session.content ~= "" then
    local ok, data = pcall(json.parse, session.content)
    if not ok or type(data) ~= "table" then
      return { error = "Invalid body" }, nil, 400
    end
    if data.Blocks ~= nil then
      if type(data.Blocks) ~= "table" then
        return { error = "Invalid Blocks" }, nil, 400
      end
      blocks = {}
      for k, v in pairs(data.Blocks) do
        if not BLOCK_KEY_SET[k] then
          return { error = "Unknown block key: " .. tostring(k) }, nil, 400
        end
        if v == true then
          blocks[k] = true
        end
      end
    elseif data.Mode ~= nil then
      blocks = LegacyModeBlocks(data.Mode)
      if blocks == nil then
        return { error = "Invalid Mode" }, nil, 400
      end
      if data.Enabled == false then
        blocks = nil
      end
    elseif data.Enabled == false then
      blocks = nil
    end
  end

  if not SetNoTeleport(guid, blocks) then
    return { error = "Invalid GUID" }, nil, 400
  end
  return { status = blocks and "no_teleport_enabled" or "no_teleport_cleared", Guid = guid, Blocks = blocks }, nil, 200
end

---DELETE /players/{guid}/no_teleport
---@type RequestPathHandler
local function HandleClearPlayerNoTeleport(session)
  local guid = session.pathComponents[2]
  if not guid or guid == "" then
    return { error = "Invalid player GUID" }, nil, 400
  end
  SetNoTeleport(guid, nil)
  return { status = "no_teleport_cleared", Guid = guid }, nil, 200
end

---GET /players/no_teleport
---@type RequestPathHandler
local function HandleGetNoTeleportPlayers(session)
  return { data = GetNoTeleportGuids() }, nil, 200
end

return {
  BLOCK_KEYS = BLOCK_KEYS,
  SetNoTeleport = SetNoTeleport,
  IsNoTeleportGuid = IsNoTeleportGuid,
  GetNoTeleportBlocks = GetNoTeleportBlocks,
  IsBlocked = IsBlocked,
  GetNoTeleportGuids = GetNoTeleportGuids,
  HandleSetPlayerNoTeleport = HandleSetPlayerNoTeleport,
  HandleClearPlayerNoTeleport = HandleClearPlayerNoTeleport,
  HandleGetNoTeleportPlayers = HandleGetNoTeleportPlayers,
}
