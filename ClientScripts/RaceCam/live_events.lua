--- AMC RaceCam live event reader for MotorTownClientMod (admin build).
---
--- Reads the replicated Motor Town event list from
---   gameState.Net_EventSystem.Net_Events  (FMTEvent[])
--- and returns plain Lua tables safe for JSON serialization by the operator
--- panel. See Scripts/EventManager.lua:55-83 for the verified UE5 data path.
---
--- EVERY UE property access is pcall-guarded, so an absent GameState, an
--- absent EventSystem, or a half-replicated event can never crash the game
--- thread. Callers get `{}` / nil instead.

local M = {}

---@param obj any
---@return boolean
local function valid(obj)
    if not obj then return false end
    local ok, v = pcall(function() return obj:IsValid() end)
    return ok and v and true or false
end

--- pcall-guarded property read (works for userdata proxies and Lua tables).
local function field(obj, key)
    if not obj then return nil end
    local ok, v = pcall(function() return obj[key] end)
    if ok then return v end
    return nil
end

--- FName / FString -> plain string.
local function name_of(v)
    if v == nil then return nil end
    if type(v) == "string" then return v end
    local ok, s = pcall(function()
        if type(v.ToString) == "function" then return v:ToString() end
        return tostring(v)
    end)
    if ok and s and s ~= "" then return s end
    return nil
end

--- FGuid -> stable string (GuidToString from Helpers when present).
local function guid_of(v)
    if v == nil then return "" end
    if type(v) == "string" then return v end
    if type(v) == "table" and v.A ~= nil then
        local ok, s = pcall(string.format, "%08X%08X%08X%08X", v.A, v.B, v.C, v.D)
        if ok and s then return s end
    end
    if type(GuidToString) == "function" then
        local ok, s = pcall(GuidToString, v)
        if ok and s and s ~= "0000" then return tostring(s) end
    end
    local ok, s = pcall(function() return v:ToString() end)
    if ok and s then return tostring(s) end
    return ""
end

--- Iterate a UE4SS TArray (`:ForEach`) or a plain Lua array. Never return
--- early from the ForEach callback: UE4SS bounded-exit semantics are not
--- continue/stop and an early return can wedge the iteration.
local function foreach(arr, cb)
    if not arr then return end
    if type(arr) == "table" and #arr > 0 then
        for i = 1, #arr do pcall(cb, i - 1, arr[i]) end
        return
    end
    local ok, fn = pcall(function() return arr.ForEach end)
    if not ok or type(fn) ~= "function" then return end
    pcall(function()
        arr:ForEach(function(i, element)
            local item = element
            -- UE4SS passes a wrapper with :get(); plain Lua arrays pass the
            -- value itself. Unwrap either representation.
            local okfn, get_fn = pcall(function() return element.get end)
            if okfn and type(get_fn) == "function" then
                local okget, value = pcall(get_fn, element)
                if okget then item = value end
            end
            pcall(cb, i, item)
        end)
    end)
end

--- Resolve the GameState without assuming server-only globals exist on the
--- client. Prefers GetMotorTownGameState() when available, falls back to the
--- cached UWorld, and validates the class with IsA when possible.
local function get_game_state()
    if type(GetMotorTownGameState) == "function" then
        local ok, gs = pcall(GetMotorTownGameState)
        if ok and valid(gs) then return gs end
    end
    if type(GetCachedWorld) ~= "function" then return nil end
    local ok, world = pcall(GetCachedWorld)
    if not ok or not valid(world) then return nil end
    local ok2, gs = pcall(function() return world.GameState end)
    if not ok2 or not valid(gs) then return nil end
    if type(StaticFindObject) == "function" then
        local ok3, cls = pcall(StaticFindObject, "/Script/MotorTown.MotorTownGameState")
        if ok3 and cls then
            local ok4, isa = pcall(function() return gs:IsA(cls) end)
            if ok4 and not isa then return nil end
        end
    end
    return gs
end

local function get_event_system()
    local gs = get_game_state()
    if not gs then return nil end
    local ok, es = pcall(function() return gs.Net_EventSystem end)
    if not ok or not valid(es) then return nil end
    if type(StaticFindObject) == "function" then
        local okc, cls = pcall(StaticFindObject, "/Script/MotorTown.MTEventSystem")
        if okc and cls then
            local oka, isa = pcall(function() return es:IsA(cls) end)
            if oka and not isa then return nil end
        end
    end
    return es
end

--- Best effort local player name (used when callers omit the argument).
---@return string?
function M.local_name()
    if type(GetMyPlayerController) ~= "function" then return nil end
    local ok, pc = pcall(GetMyPlayerController)
    if not ok or not valid(pc) then return nil end
    local ok2, ps = pcall(function() return pc.PlayerState end)
    if ok2 and valid(ps) then
        local n = name_of(field(ps, "PlayerName"))
        if n then return n end
        local ok3, nn = pcall(function() return ps:GetPlayerName() end)
        if ok3 and nn then return tostring(nn) end
    end
    return nil
end

local function build_event(ev, wanted_name)
    local ok, data = pcall(function()
        local players = {}
        foreach(field(ev, "Players"), function(_, p)
            if not p then return end
            local nm = name_of(field(p, "PlayerName"))
            if nm then
                players[#players + 1] = {
                    name = nm,
                    rank = tonumber(field(p, "Rank")) or 0,
                    disqualified = field(p, "bDisqualified") and true or false,
                }
            end
        end)

        local is_member = false
        if wanted_name then
            for _, p in ipairs(players) do
                if p.name == wanted_name then is_member = true end
            end
        end

        local leader, best = nil, math.huge
        for _, p in ipairs(players) do
            if not p.disqualified and p.rank == 1 then leader = p.name break end
        end
        if not leader then
            for _, p in ipairs(players) do
                if not p.disqualified and p.rank > 0 and p.rank < best then
                    best, leader = p.rank, p.name
                end
            end
        end

        local route = field(field(ev, "RaceSetup"), "Route")
        local waypoints = {}
        foreach(field(route, "Waypoints"), function(_, wp)
            if not wp then return end
            local tr = field(wp, "Translation")
            local sc = field(wp, "Scale3D")
            local sy = tonumber(field(sc, "Y")) or 0
            -- FMTEvent checkpoint gates use Scale3D.Y * 10 metres; a missing or
            -- non-positive scale falls back to a sensible 12 m gate.
            local gate_m = sy > 0 and math.max(8, sy * 10.0) or 12.0
            waypoints[#waypoints + 1] = {
                x = tonumber(field(tr, "X")) or 0,
                y = tonumber(field(tr, "Y")) or 0,
                z = tonumber(field(tr, "Z")) or 0,
                gate_m = gate_m,
            }
        end)

        return {
            guid = guid_of(field(ev, "EventGuid")),
            name = name_of(field(ev, "EventName")) or "",
            route_name = name_of(field(route, "RouteName")) or "",
            state = tonumber(field(ev, "State")) or 0,
            in_countdown = field(ev, "bInCountdown") and true or false,
            is_member = is_member,
            player_count = #players,
            waypoint_count = #waypoints,
            leader_name = leader,
            waypoints = waypoints,
        }
    end)
    if not ok then return nil end
    return data
end

--- List all active events as clean Lua tables.
---@param local_player_name string?
---@return table[]
function M.list(local_player_name)
    local es = get_event_system()
    if not es then return {} end
    local wanted = name_of(local_player_name) or M.local_name()
    local events = {}
    foreach(field(es, "Net_Events"), function(_, ev)
        if ev then events[#events + 1] = ev end
    end)
    local out = {}
    for _, ev in ipairs(events) do
        local item = build_event(ev, wanted)
        if item then out[#out + 1] = item end
    end
    return out
end

--- First event the local player is a member of, or nil.
---@param local_player_name string?
---@return table?
function M.current_event(local_player_name)
    for _, ev in ipairs(M.list(local_player_name)) do
        if ev.is_member then return ev end
    end
    return nil
end

return M
