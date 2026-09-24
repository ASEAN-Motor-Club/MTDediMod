---NoTeleportManager.lua
---Backend-pushed per-GUID no-teleport flag (freeman 2026-09-23).
---
---The mod is dumb: it keeps an IN-MEMORY set of character GUIDs that must be
---teleport-locked, written only by the backend via the webserver endpoints
---below. No display-name involvement — the flag is invisible to other players
---(unlike the [R] tag, which reveals wanted status).
---
---State is memory-only by design: the backend is the source of truth and
---re-asserts the flag on every player login, so a game restart simply clears
---it until the backend pushes again.
---
---RPManager.lua consults IsNoTeleportGuid() in the four server-side movement
---hooks (ServerTeleportCharacter / ServerTeleportVehicle / ServerRespawnCharacter /
---ServerResetVehicleAt). The flag blocks UNCONDITIONALLY — the racetrack
---event-member allowance that applies to RP-mode players does NOT apply here:
---the flag is a deliberate enforcement (wanted grace window / admin hold),
---not an RP immersion rule.

local json = require("JsonParser")

local noTeleportGuids = {}

---@param guid string character GUID
---@param enabled boolean
local function SetNoTeleport(guid, enabled)
  if not guid or guid == "" then
    return false
  end
  if enabled then
    noTeleportGuids[guid] = true
    LogOutput("INFO", string.format("[NoTeleport] ENABLED for %s", guid))
  else
    if noTeleportGuids[guid] then
      LogOutput("INFO", string.format("[NoTeleport] cleared for %s", guid))
    end
    noTeleportGuids[guid] = nil
  end
  return true
end

---@param guid string character GUID
---@return boolean
local function IsNoTeleportGuid(guid)
  return guid ~= nil and noTeleportGuids[guid] == true
end

---@return table list of GUIDs currently flagged
local function GetNoTeleportGuids()
  local result = {}
  for guid in pairs(noTeleportGuids) do
    table.insert(result, guid)
  end
  table.sort(result)
  return result
end

---POST /players/{guid}/no_teleport
---Body (optional): {"Enabled": false} clears; absent/true enables.
---@type RequestPathHandler
local function HandleSetPlayerNoTeleport(session)
  local guid = session.pathComponents[2]
  if not guid or guid == "" then
    return { error = "Invalid player GUID" }, nil, 400
  end
  local enabled = true
  if session.content and session.content ~= "" then
    local ok, data = pcall(json.parse, session.content)
    if ok and type(data) == "table" and data.Enabled == false then
      enabled = false
    end
  end
  if not SetNoTeleport(guid, enabled) then
    return { error = "Invalid GUID" }, nil, 400
  end
  return { status = enabled and "no_teleport_enabled" or "no_teleport_cleared", Guid = guid }, nil, 200
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
  SetNoTeleport = SetNoTeleport,
  IsNoTeleportGuid = IsNoTeleportGuid,
  GetNoTeleportGuids = GetNoTeleportGuids,
  HandleSetPlayerNoTeleport = HandleSetPlayerNoTeleport,
  HandleClearPlayerNoTeleport = HandleClearPlayerNoTeleport,
  HandleGetNoTeleportPlayers = HandleGetNoTeleportPlayers,
}
