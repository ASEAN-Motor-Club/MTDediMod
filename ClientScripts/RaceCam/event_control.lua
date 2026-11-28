--- AMC RaceCam event lifecycle control (admin build).
---
--- Thin wrapper around the client -> server event RPCs on
--- AMotorTownPlayerController. Every call resolves the controller and the
--- replicated FMTEvent FRESH: no UE4SS UObject (or StructProperty FGuid)
--- is ever cached across ticks. The FGuid is handed to the RPC as a plain
--- Lua table { A, B, C, D } of numbers -- UE4SS cannot marshal a raw
--- StructProperty userdata (see Scripts/EventManager.lua:411-422).
---
--- All public functions return ok, message, meta (meta is plain Lua data).

local LiveEvents = require("RaceCam/live_events")

local M = {}

--- EMTEventState (uint8, verified from SDK):
--- 0 None/Lobby, 1 Ready, 2 InProgress, 3 Finished.
local STATE_BY_NAME = {
  none = 0, lobby = 0,
  ready = 1,
  start = 2, in_progress = 2, racing = 2,
  finish = 3, finished = 3,
}
local NAME_BY_STATE = {
  [0] = "lobby", [1] = "ready", [2] = "start", [3] = "finish",
}
M.STATE_BY_NAME = STATE_BY_NAME
M.NAME_BY_STATE = NAME_BY_STATE

-- Best-effort acknowledgement of ServerRemoveEvent. Plain values only.
local last_remove_response = nil

local function valid(obj)
  if not obj then return false end
  local ok, v = pcall(function() return obj:IsValid() end)
  return ok and v and true or false
end

--- Fresh controller lookup on every RPC. Never store the result.
local function get_pc()
  if type(FindFirstOf) == "function" then
    local ok, pc = pcall(FindFirstOf, "MotorTownPlayerController")
    if ok and valid(pc) then return pc end
  end
  if type(GetMyPlayerController) == "function" then
    local ok, pc = pcall(GetMyPlayerController)
    if ok and valid(pc) then return pc end
  end
  return nil
end

--- Every caller is http.lua's H.tick, which LoopInGameThreadWithDelay already
--- runs ON the game thread. Call the RPC directly: queueing it through
--- ExecuteInGameThread would retain the freshly-resolved PC UObject in a
--- closure until the next tick, breaking the zero-cross-tick-caching rule.
local function on_game_thread(fn)
  local ok, err = pcall(fn)
  if ok then return true, nil end
  return false, err
end

if type(RegisterHook) == "function" then
  pcall(RegisterHook,
    "/Script/MotorTown.MotorTownPlayerController:ClientRemoveEventResponse",
    function(_, guid_value, succeeded)
      local ok, guid_str = pcall(function()
        return LiveEvents.guid_string(guid_value)
      end)
      -- Convert immediately; the hook argument is a UObject-backed FGuid.
      last_remove_response = {
        guid = ok and type(guid_str) == "string" and guid_str or "",
        succeeded = succeeded and true or false,
        ts = os.time(),
      }
    end)
end

---@return table? { guid, succeeded, ts } -- plain Lua values or nil
function M.last_remove_response()
  return last_remove_response
end

--- Resolve a 32-hex guid string into a freshly-read plain parts table.
local function resolve(guid_str)
  if type(guid_str) ~= "string" or #guid_str ~= 32 or not guid_str:match("^%x+$") then
    return nil, "invalid event guid", nil
  end
  local parts = LiveEvents.find_event_guid_parts(guid_str)
  if not parts then return nil, "unknown event guid", nil end
  local pc = get_pc()
  if not pc then return nil, "player controller unavailable", nil end
  return parts, nil, pc
end

--- Change event state. State 2 (start) mirrors EventManager.lua:407: the
--- server will not start an event with no players or no waypoints.
---@param guid_str string 32-hex EventGuid
---@param state_name string none|lobby|ready|start|in_progress|racing|finish|finished
---@return boolean ok, string message, table? meta
function M.set_state(guid_str, state_name)
  local key = tostring(state_name or ""):lower()
  local state = STATE_BY_NAME[key]
  if state == nil then return false, "invalid state: " .. key, nil end

  local parts, err, pc = resolve(guid_str)
  if not parts then return false, err, nil end

  if state == 2 and (parts.player_count == 0 or parts.waypoint_count == 0) then
    return false, "event needs at least one player and one waypoint", {
      state = state, reason = "empty_event",
      player_count = parts.player_count, waypoint_count = parts.waypoint_count,
    }
  end

  local guid_table = {
    A = parts.A, B = parts.B, C = parts.C, D = parts.D,
  }
  local ok, rpc_err = on_game_thread(function()
    local called, result = pcall(function()
      return pc:ServerChangeEventState(guid_table, state)
    end)
    if not called then error(tostring(result)) end
    return result
  end)
  if not ok then return false, "rpc failed: " .. tostring(rpc_err), nil end

  return true, "state requested", {
    state = state, state_name = NAME_BY_STATE[state] or key,
    event_guid = guid_str,
  }
end

--- Close / remove the event (server removes it from Net_Events).
function M.close_event(guid_str)
  local parts, err, pc = resolve(guid_str)
  if not parts then return false, err, nil end
  local guid_table = {
    A = parts.A, B = parts.B, C = parts.C, D = parts.D,
  }
  local ok, rpc_err = on_game_thread(function()
    local called, result = pcall(function() return pc:ServerRemoveEvent(guid_table) end)
    if not called then error(tostring(result)) end
    return result
  end)
  if not ok then return false, "rpc failed: " .. tostring(rpc_err), nil end
  return true, "remove requested", { event_guid = guid_str }
end

--- Join (claim an ownerless event as host).
function M.join_event(guid_str)
  local parts, err, pc = resolve(guid_str)
  if not parts then return false, err, nil end
  local guid_table = {
    A = parts.A, B = parts.B, C = parts.C, D = parts.D,
  }
  local ok, rpc_err = on_game_thread(function()
    local called, result = pcall(function() return pc:ServerJoinEvent(guid_table) end)
    if not called then error(tostring(result)) end
    return result
  end)
  if not ok then return false, "rpc failed: " .. tostring(rpc_err), nil end
  return true, "join requested", { event_guid = guid_str }
end

--- Leave the event / step off the grid.
function M.leave_event(guid_str)
  local parts, err, pc = resolve(guid_str)
  if not parts then return false, err, nil end
  local guid_table = {
    A = parts.A, B = parts.B, C = parts.C, D = parts.D,
  }
  local ok, rpc_err = on_game_thread(function()
    local called, result = pcall(function() return pc:ServerLeaveEvent(guid_table) end)
    if not called then error(tostring(result)) end
    return result
  end)
  if not ok then return false, "rpc failed: " .. tostring(rpc_err), nil end
  return true, "leave requested", { event_guid = guid_str }
end

return M
