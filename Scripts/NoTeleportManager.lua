---NoTeleportManager.lua
---Backend-pushed per-GUID no-teleport flag (freeman 2026-09-23).
---
---The mod is dumb: it keeps an IN-MEMORY map of character GUIDs -> lock MODE,
---written only by the backend via the webserver endpoints below. No
---display-name involvement — the flag is invisible to other players (unlike
---the [R] tag, which reveals wanted status).
---
---Modes (freeman 2026-09-27: "allow different types of teleport blocking"):
---  "all"             — block every movement RPC (wanted / admin hold).
---  "reset_cargo_keep" — block ONLY ServerResetVehicleAt with bRemoveCargo=false
---                      (the roadside flow that teleports the vehicle with its
---                      cargo); bRemoveCargo=true passes. Used for on-duty police.
---Absent body / unknown-shape push defaults to "all" (back-compat with the
---pre-mode backend), so an old backend always yields the full lock.
---
---State is memory-only by design: the backend is the source of truth and
---re-asserts the flag on every player login, so a game restart simply clears
---it until the backend pushes again.
---
---RPManager.lua consults GetNoTeleportMode() in the four server-side movement
---hooks (ServerTeleportCharacter / ServerTeleportVehicle / ServerRespawnCharacter /
---ServerResetVehicleAt). The "all" flag blocks UNCONDITIONALLY — the racetrack
---event-member allowance that applies to RP-mode players does NOT apply here:
---the flag is a deliberate enforcement (wanted grace window / admin hold),
---not an RP immersion rule.

local json = require("JsonParser")

local MODE_ALL = "all"
local MODE_RESET_CARGO_KEEP = "reset_cargo_keep"

local noTeleportModes = {}

---@param guid string character GUID
---@param enabled boolean
---@param string mode one of MODE_ALL / MODE_RESET_CARGO_KEEP
local function SetNoTeleport(guid, enabled, mode)
  if not guid or guid == "" then
    return false
  end
  if enabled then
    noTeleportModes[guid] = mode or MODE_ALL
    LogOutput("INFO", string.format("[NoTeleport] ENABLED (%s) for %s", noTeleportModes[guid], guid))
  else
    if noTeleportModes[guid] then
      LogOutput("INFO", string.format("[NoTeleport] cleared for %s", guid))
    end
    noTeleportModes[guid] = nil
  end
  return true
end

---@param guid string character GUID
---@return boolean
local function IsNoTeleportGuid(guid)
  return guid ~= nil and noTeleportModes[guid] ~= nil
end

---@param guid string character GUID
---@return string mode or nil when not flagged
local function GetNoTeleportMode(guid)
  if guid == nil then return nil end
  return noTeleportModes[guid]
end

---@return table list of {Guid, Mode} currently flagged
local function GetNoTeleportGuids()
  local result = {}
  for guid, mode in pairs(noTeleportModes) do
    table.insert(result, { Guid = guid, Mode = mode })
  end
  table.sort(result, function(a, b) return a.Guid < b.Guid end)
  return result
end

---POST /players/{guid}/no_teleport
---Body (optional): {"Enabled": false} clears;
---absent/true enables with Mode (default "all", one of MODE_ALL /
---MODE_RESET_CARGO_KEEP; unknown modes are rejected so the mod never
---silently applies a weaker lock than intended).
---@type RequestPathHandler
local function HandleSetPlayerNoTeleport(session)
  local guid = session.pathComponents[2]
  if not guid or guid == "" then
    return { error = "Invalid player GUID" }, nil, 400
  end
  local enabled = true
  local mode = nil
  if session.content and session.content ~= "" then
    local ok, data = pcall(json.parse, session.content)
    if ok and type(data) == "table" then
      if data.Enabled == false then
        enabled = false
      end
      if data.Mode ~= nil then
        if type(data.Mode) ~= "string"
            or (data.Mode ~= MODE_ALL and data.Mode ~= MODE_RESET_CARGO_KEEP) then
          return { error = "Invalid Mode" }, nil, 400
        end
        mode = data.Mode
      end
    end
  end
  if not SetNoTeleport(guid, enabled, mode) then
    return { error = "Invalid GUID" }, nil, 400
  end
  return { status = enabled and "no_teleport_enabled" or "no_teleport_cleared", Guid = guid, Mode = enabled and (mode or MODE_ALL) or nil }, nil, 200
end

---DELETE /players/{guid}/no_teleport
---@type RequestPathHandler
local function HandleClearPlayerNoTeleport(session)
  local guid = session.pathComponents[2]
  if not guid or guid == "" then
    return { error = "Invalid player GUID" }, nil, 400
  end
  SetNoTeleport(guid, false)
  return { status = "no_teleport_cleared", Guid = guid }, nil, 200
end

---GET /players/no_teleport
---@type RequestPathHandler
local function HandleGetNoTeleportPlayers(session)
  return { data = GetNoTeleportGuids() }, nil, 200
end

return {
  MODE_ALL = MODE_ALL,
  MODE_RESET_CARGO_KEEP = MODE_RESET_CARGO_KEEP,
  SetNoTeleport = SetNoTeleport,
  IsNoTeleportGuid = IsNoTeleportGuid,
  GetNoTeleportGuids = GetNoTeleportGuids,
  HandleSetPlayerNoTeleport = HandleSetPlayerNoTeleport,
  HandleClearPlayerNoTeleport = HandleClearPlayerNoTeleport,
  HandleGetNoTeleportPlayers = HandleGetNoTeleportPlayers,
}
