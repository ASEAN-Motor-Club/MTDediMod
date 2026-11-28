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

--- Exposed for event_control.lua's response hook: convert a fresh FGuid
--- userdata into a plain string immediately (never cache the userdata).
M.guid_string = guid_of

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

--- Fresh local CharacterGuid (AMotorTownPlayerState.CharacterGuid) as a plain
--- string. Used to decide event ownership; no UObject is retained.
---@return string
local function local_character_guid()
    if type(GetMyPlayerController) ~= "function" then return "" end
    local ok, pc = pcall(GetMyPlayerController)
    if not ok or not valid(pc) then return "" end
    local ok2, ps = pcall(function() return pc.PlayerState end)
    if not ok2 or not valid(ps) then return "" end
    return guid_of(field(ps, "CharacterGuid"))
end
M.local_character_guid = local_character_guid

--- Standings sort: ranked (rank > 0) first by rank asc, then the pre-start
--- grid (rank == 0) alphabetically, then disqualified alphabetically. Rank
--- ties break on laps desc, section desc, then name asc.
local function standing_cmp(a, b)
    if a.disqualified ~= b.disqualified then return not a.disqualified end
    if not a.disqualified then
        local a_ranked, b_ranked = a.rank > 0, b.rank > 0
        if a_ranked ~= b_ranked then return a_ranked end
        if a_ranked then
            if a.rank ~= b.rank then return a.rank < b.rank end
            if a.laps ~= b.laps then return a.laps > b.laps end
            if a.section ~= b.section then return a.section > b.section end
        end
    end
    return a.name < b.name
end

local function build_event(ev, wanted_name, local_guid)
    local ok, data = pcall(function()
        local players = {}
        local player_rows = {}
        foreach(field(ev, "Players"), function(_, p)
            if not p then return end
            local nm = name_of(field(p, "PlayerName"))
            if nm then
                local cid = field(p, "CharacterId")
                local pguid = guid_of(field(cid, "CharacterGuid"))
                if pguid == "" then pguid = guid_of(field(cid, "UniqueNetId")) end
                player_rows[#player_rows + 1] = { name = nm, guid = pguid }
                players[#players + 1] = {
                    rank = tonumber(field(p, "Rank")) or 0,
                    name = nm,
                    laps = tonumber(field(p, "Laps")) or 0,
                    section = tonumber(field(p, "SectionIndex")) or 0,
                    best_lap_s = tonumber(field(p, "BestLapTime")) or 0,
                    last_sec_s = tonumber(field(p, "LastSectionTotalTimeSeconds")) or 0,
                    finished = field(p, "bFinished") and true or false,
                    disqualified = field(p, "bDisqualified") and true or false,
                }
            end
        end)

        -- Owner is an FMTCharacterId on the event. Convert to a plain string
        -- immediately; the raw struct userdata must never be retained.
        local owner_id = field(ev, "OwnerCharacterId")
        local owner_guid = ""
        for _, key in ipairs({ "CharacterGuid", "UniqueNetId" }) do
            local s = guid_of(field(owner_id, key))
            if s ~= "" then owner_guid = s break end
        end
        local owner_name = ""
        local is_owner = owner_guid ~= "" and local_guid ~= "" and owner_guid == local_guid
        if owner_guid ~= "" then
            for _, row in ipairs(player_rows) do
                if row.guid == owner_guid then owner_name = row.name break end
            end
            if owner_name == "" then
                local gs = get_game_state()
                if gs then
                    foreach(field(gs, "PlayerArray"), function(_, ps)
                        if owner_name == "" and ps
                           and guid_of(field(ps, "CharacterGuid")) == owner_guid then
                            local n = name_of(field(ps, "PlayerName"))
                            if not n and type(ps.GetPlayerName) == "function" then
                                local okn, v = pcall(ps.GetPlayerName, ps)
                                if okn then n = name_of(v) end
                            end
                            if n then owner_name = n end
                        end
                    end)
                end
            end
            if owner_name == "" and is_owner and wanted_name then owner_name = wanted_name end
        end

        -- Compact, sorted leaderboard. Shares the already-built player tables
        -- (no deep copy) so this stays cheap for the 700 ms /api/state poll.
        local standings = {}
        for _, p in ipairs(players) do standings[#standings + 1] = p end
        table.sort(standings, standing_cmp)
        local num_laps = tonumber(field(field(ev, "RaceSetup"), "NumLaps")) or 0

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
            is_joined = is_member,
            owner_guid = owner_guid,
            owner_name = owner_name,
            is_owner = is_owner,
            player_count = #players,
            waypoint_count = #waypoints,
            leader_name = leader,
            num_laps = num_laps,
            standings = standings,
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
    local my_guid = local_character_guid()
    local events = {}
    foreach(field(es, "Net_Events"), function(_, ev)
        if ev then events[#events + 1] = ev end
    end)
    local out = {}
    for _, ev in ipairs(events) do
        local item = build_event(ev, wanted, my_guid)
        if item then out[#out + 1] = item end
    end
    return out
end

--- Freshly resolve one replicated event by its 32-hex EventGuid string.
--- Returns ONLY plain Lua numbers plus state/counts - no UObject escapes.
--- Used by event_control.lua immediately before every RPC, so a stale
--- UE4SS pointer can never survive across ticks.
---@param guid_str string
---@return table? { A, B, C, D, state, player_count, waypoint_count }
function M.find_event_guid_parts(guid_str)
    if type(guid_str) ~= "string" or guid_str == "" then return nil end
    local es = get_event_system()
    if not es then return nil end

    local found = nil
    foreach(field(es, "Net_Events"), function(_, ev)
        -- Never return early from a UE4SS ForEach callback (bounded-exit
        -- semantics can wedge iteration); skip already-resolved entries.
        if not found and ev then
            local g = field(ev, "EventGuid")
            local eg = g and guid_of(g) or ""
            if eg ~= "" and eg:lower() == guid_str:lower() then
                local ok, parts = pcall(function()
                    local a = tonumber(field(g, "A"))
                    local b = tonumber(field(g, "B"))
                    local c = tonumber(field(g, "C"))
                    local d = tonumber(field(g, "D"))
                    if not (a and b and c and d) then return nil end
                    local players, waypoints = 0, 0
                    foreach(field(ev, "Players"), function() players = players + 1 end)
                    local route = field(field(ev, "RaceSetup"), "Route")
                    foreach(field(route, "Waypoints"), function() waypoints = waypoints + 1 end)
                    return {
                        A = a, B = b, C = c, D = d,
                        state = tonumber(field(ev, "State")) or 0,
                        player_count = players,
                        waypoint_count = waypoints,
                    }
                end)
                if ok then found = parts end
            end
        end
    end)
    return found
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

--- Compact snapshot of the leaderboard for the /api/state poll. Cached for
--- 0.5 s so the panel's 700 ms poll does not re-scan the event list on every
--- request. Deliberately omits waypoints[] — only the leaderboard is needed.
local standings_cache = { key = nil, t = -math.huge, value = nil }

--- Drop the cache (test seam; also harmless in production).
function M.clear_cache()
    standings_cache.key, standings_cache.t, standings_cache.value = nil, -math.huge, nil
end

---@param local_player_name string?
---@return table? { event_name, event_guid, state, in_countdown, num_laps,
---                 waypoint_count, standings } or nil when no event has players.
function M.active_standings(local_player_name)
    local wanted = name_of(local_player_name) or M.local_name()
    local key = wanted or ""
    local now = os.clock()
    if standings_cache.key == key and now - standings_cache.t < 0.5 then
        return standings_cache.value
    end
    standings_cache.key, standings_cache.t = key, now

    local events = M.list(wanted)
    local chosen = nil
    for _, ev in ipairs(events) do
        if ev.is_member and #ev.standings > 0 then chosen = ev break end
    end
    -- Spectating outside an event (or an empty member event): fall back to
    -- the first live race with a populated leaderboard.
    if not chosen then
        for _, ev in ipairs(events) do
            if #ev.standings > 0 then chosen = ev break end
        end
    end

    local value = nil
    if chosen and #chosen.standings > 0 then
        value = {
            event_name = chosen.name,
            event_guid = chosen.guid,
            state = chosen.state,
            in_countdown = chosen.in_countdown,
            num_laps = chosen.num_laps,
            waypoint_count = chosen.waypoint_count,
            standings = chosen.standings,
        }
    end
    standings_cache.value = value
    return value
end

return M
