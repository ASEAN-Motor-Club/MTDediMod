-- RaceCam/director.lua -- pure-Lua Auto Director state machine.
--
-- This module intentionally contains ZERO UE4SS / LuaSocket / filesystem calls.
-- Every input arrives in the `snap` table handed to `d:step(snap)`, so all
-- interest scoring, hysteresis and shot pacing are deterministic and can be
-- exercised under plain Lua 5.4 (see tests/test_racecam_lua.py).
--
-- Public surface (kept in sync with init.lua wiring):
--   D.MODES                     -- { off=true, shots=true, full=true }
--   D.normalize_mode(m)         -- "off"|"shots"|"full"|nil
--   D.new(opts)                 -- instance d
--   d:reset()
--   d:note_manual_shot(now)     -- pause auto shot switching for 15 s
--   d:note_manual_target(now)   -- pause auto target switching for 15 s
--   d:override_remaining(now)   -- max remaining override, >= 0
--   d:step(snap)                -- { target, shot, reason, next_cut_in, override_s }

local D = {}
D.__index = D

D.MODES = { off = true, shots = true, full = true }

local DEFAULTS = {
  override_cooldown_s = 15.0,
  min_target_hold_s   = 7.0,
  min_shot_hold_s     = 4.5,
  max_shot_hold_s     = 12.0,
  trackside_hold_s    = 16.0,
  phase_hold_s        = 7.0,   -- 6-8 s LOBBY / COUNTDOWN cycle
}

local CLOSE_CM            = 3500.0   -- 35 m = "close battle"
local CLOSE_GAP_S         = 1.5
local FINISH_CM           = 25000.0  -- 250 m final-lap sprint zone
local FINAL_LAP_FINISH_CM = 15000.0  -- 150 m -> lock finish_line
local AIR_GRACE_S         = 12.0
local AIR_DECAY_PER_S     = 2.5
local AIR_DECAY_CAP       = 45.0
local DEAD_SPEED_CM_S     = 150.0
local DEAD_GRACE_S        = 4.0
local INCIDENT_SPEED_CM_S = 1200.0
local INCIDENT_WINDOW_S   = 1.5
local OVERTAKE_BURST_S    = 6.0
local INCIDENT_BURST_S    = 4.5

local BATTLE_POOL = {
  "pack_battle", "front_chase", "rear_battle", "heli_follow", "auto_trackside",
}
-- auto_trackside appears on 5 of 11 entries (~45%) and is never adjacent to
-- itself, so a solo run gets trackside airtime without back-to-back repeats.
local SOLO_POOL = {
  "auto_trackside", "onboard_tcam",
  "auto_trackside", "side_tracking",
  "auto_trackside", "chase_close",
  "auto_trackside", "heli_follow",
  "auto_trackside", "chase_close",
  "onboard_tcam",
}
local REMOTE_POOL = {
  "auto_trackside", "heli_follow", "chase_wide", "follow_focus",
}
local PHASE_CYCLE = { "start_line", "orbit_hero", "start_crane" }

-- ---------------------------------------------------------------------------
-- small helpers
-- ---------------------------------------------------------------------------

function D.normalize_mode(m)
  if type(m) ~= "string" then return nil end
  local s = m:match("^%s*(.-)%s*$"):lower()
  if D.MODES[s] then return s end
  return nil
end

local function num(v, default)
  if type(v) == "number" then return v end
  return default
end

local function axis(p, key, idx)
  if type(p) ~= "table" then return 0.0 end
  local v = p[key]
  if type(v) ~= "number" then v = p[idx] end
  if type(v) ~= "number" then return 0.0 end
  return v
end

local function dist3(a, b)
  if type(a) ~= "table" or type(b) ~= "table" then return nil end
  local dx = axis(a, "x", 1) - axis(b, "x", 1)
  local dy = axis(a, "y", 2) - axis(b, "y", 2)
  local dz = axis(a, "z", 3) - axis(b, "z", 3)
  return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function sorted_keys(t)
  local keys = {}
  for k in pairs(t or {}) do keys[#keys + 1] = k end
  table.sort(keys)
  return keys
end

local function avail_ok(avail, id)
  if not avail then return true end              -- no plan loaded: allow all
  if avail[id] then return true end              -- set form
  for _, v in ipairs(avail) do                   -- tolerate array form
    if v == id then return true end
  end
  return false
end

-- ---------------------------------------------------------------------------
-- instance lifecycle
-- ---------------------------------------------------------------------------

function D.new(opts)
  opts = type(opts) == "table" and opts or {}
  local d = setmetatable({}, D)
  for k, v in pairs(DEFAULTS) do d[k] = num(opts[k], v) end
  d:reset()
  return d
end

function D:reset()
  self.target = nil
  self.shot = nil
  self.target_since = nil
  self.shot_since = nil
  self.shot_override_until = 0.0
  self.target_override_until = 0.0
  self.last_state = nil
  self.prev_ranks = {}
  self.prev_speed = {}
  self.prev_gaps = {}
  self.boost_until = {}
  self.boost_kind = {}
  self.solo_since = {}
  self.slow_since = {}
  self.pool_idx = 0
  self.phase_state = nil
  self.phase_idx = 1
  self.phase_since = 0.0
end

function D:note_manual_shot(now)
  self.shot_override_until = (num(now, 0.0) or 0.0) + self.override_cooldown_s
end

function D:note_manual_target(now)
  self.target_override_until = (num(now, 0.0) or 0.0) + self.override_cooldown_s
end

function D:override_remaining(now)
  now = num(now, 0.0) or 0.0
  local s = math.max(0.0, (self.shot_override_until or 0.0) - now)
  local t = math.max(0.0, (self.target_override_until or 0.0) - now)
  return math.max(s, t, 0.0)
end

-- Keep our internal "what is on air" in sync with reality. A non-nil,
-- different value coming from the snapshot means the operator changed it by
-- hand, so the hold timer restarts from now.
function D:_sync_current(snap, now)
  local ct = snap.current_target
  if type(ct) == "string" and ct ~= self.target then
    self.target = ct
    self.target_since = now
  end
  local cs = snap.current_shot
  if type(cs) == "string" and cs ~= self.shot then
    self.shot = cs
    self.shot_since = now
  end
end

-- ---------------------------------------------------------------------------
-- WHO: interest scorer (mode == "full")
-- Returns name, reason, priority, meta.  Priority 2 == immediate cut.
-- ---------------------------------------------------------------------------

function D:_choose_target(snap, now)
  local state = snap.event_state
  local standings = type(snap.standings) == "table" and snap.standings or nil
  local cars = type(snap.cars) == "table" and snap.cars or nil
  local num_laps = num(snap.num_laps, nil)
  local finish_pos = snap.finish_pos

  -- Build the candidate rows. Fall back to car keys (fastest first) when the
  -- leaderboard is empty so the director still has something to point at.
  local rows = {}
  if standings then
    for _, r in ipairs(standings) do
      if type(r) == "table" and type(r.name) == "string" then
        rows[#rows + 1] = r
      end
    end
  end
  if #rows == 0 and cars then
    local names = sorted_keys(cars)
    table.sort(names, function(a, b)
      local sa = num(cars[a] and cars[a].spd_cm_s, 0.0)
      local sb = num(cars[b] and cars[b].spd_cm_s, 0.0)
      if sa == sb then return a < b end
      return sa > sb
    end)
    for _, name in ipairs(names) do
      rows[#rows + 1] = {
        name = name, rank = #rows + 1, laps = 0, section = 0,
        split_s = nil, finished = false, dq = false,
      }
    end
  end

  -- Eligibility: never a DQ; no finished cars while still RACING.
  local elig = {}
  for _, r in ipairs(rows) do
    if not r.dq and not (state == "RACING" and r.finished) then
      elig[#elig + 1] = r
    end
  end
  if #elig == 0 then return nil, "no targets", 0, {} end

  -- score record -------------------------------------------------------------
  local scores = {}
  local function rec(name)
    if not scores[name] then
      scores[name] = { value = 0.0, priority = 0, bits = {}, meta = {} }
    end
    return scores[name]
  end
  local function add(name, amount, prio, bit)
    if not name then return end
    local s = rec(name)
    s.value = s.value + amount
    if (prio or 0) > s.priority then s.priority = prio or 0 end
    if bit then s.bits[#s.bits + 1] = bit end
  end

  -- Base rank bias + podium preference once the race is over -----------------
  for i, r in ipairs(elig) do
    local rk = num(r.rank, i)
    add(r.name, 100.0 - math.min(rk, 20) * 4.0, 0, nil)
    if state == "FINISHED" and rk <= 3 then
      add(r.name, (4 - rk) * 120.0, 0, "P" .. rk .. " result")
    end
  end

  -- Overtake / rank swap: +50 for 6 s, priority 2 (immediate cut) ------------
  local new_ranks = {}
  for _, r in ipairs(elig) do
    local rk = num(r.rank, 99)
    local prev = self.prev_ranks[r.name]
    if prev and rk < prev then
      self.boost_until[r.name] = math.max(self.boost_until[r.name] or 0.0,
                                          now + OVERTAKE_BURST_S)
      self.boost_kind[r.name] = "overtake"
      rec(r.name).meta.overtake = true
    end
    new_ranks[r.name] = rk
  end
  self.prev_ranks = new_ranks

  -- Incident / spin: top-10 car loses >60% speed in <1.5 s from >1200 cm/s ---
  local new_speed = {}
  for _, r in ipairs(elig) do
    local info = cars and cars[r.name]
    local spd = info and num(info.spd_cm_s, nil)
    local pv = self.prev_speed[r.name]
    if spd and pv and pv.spd > INCIDENT_SPEED_CM_S
       and spd < pv.spd * 0.4
       and (now - pv.t) >= 0.0 and (now - pv.t) < INCIDENT_WINDOW_S
       and num(r.rank, 99) <= 10 then
      self.boost_until[r.name] = math.max(self.boost_until[r.name] or 0.0,
                                          now + INCIDENT_BURST_S)
      self.boost_kind[r.name] = "incident"
      rec(r.name).meta.incident = true
    end
    if spd then new_speed[r.name] = { spd = spd, t = now } end
  end
  self.prev_speed = new_speed

  -- Apply any still-live bursts (detection above only sets the timer) --------
  for _, name in ipairs(sorted_keys(self.boost_until)) do
    local until_t = self.boost_until[name]
    if until_t > now then
      local kind = self.boost_kind[name]
      if kind == "overtake" then
        add(name, 50.0, 2, "overtake")
      elseif kind == "incident" then
        add(name, 45.0, 2, "spin / incident")
      end
    else
      self.boost_until[name] = nil
      self.boost_kind[name] = nil
    end
  end

  -- Close battle: adjacent ranked pairs within 35 m OR < 1.5 s gap -----------
  local in_battle = {}
  local new_gaps = {}
  for i = 1, #elig - 1 do
    local a, b = elig[i], elig[i + 1]
    local ra = num(a.rank, i)
    local rb = num(b.rank, i + 1)
    if rb == ra + 1 then
      local ca = cars and cars[a.name]
      local cb = cars and cars[b.name]
      local d = dist3(ca and ca.pos, cb and cb.pos)
      local gap = num(b.split_s, nil)
      local close = (d and d < CLOSE_CM) or (gap and gap < CLOSE_GAP_S)
      if close then
        in_battle[a.name] = true
        in_battle[b.name] = true
        local key = a.name .. "|" .. b.name
        local value = 60.0
        if gap and self.prev_gaps[key] and gap < self.prev_gaps[key] - 1e-9 then
          value = value + 25.0                    -- closing rate positive
        end
        if ra <= 3 then value = value + 15.0 end  -- top-3 battle
        local label = "P" .. ra .. "-P" .. rb .. " battle"
        if d then
          label = label .. " (" .. tostring(math.floor(d / 100.0 + 0.5)) .. "m)"
        end
        add(a.name, value, 1, label)
        add(b.name, value, 1, label)
        if gap then new_gaps[key] = gap end
        rec(a.name).meta.in_battle = true
        rec(b.name).meta.in_battle = true
      end
    end
  end
  self.prev_gaps = new_gaps

  -- Final-lap finish sprint: +80, priority 2 --------------------------------
  for _, r in ipairs(elig) do
    local info = cars and cars[r.name]
    local sprint = false
    if num_laps and num_laps >= 1 and num(r.laps, 0) >= num_laps - 1 then
      if finish_pos and info and info.pos then
        local d = dist3(info.pos, finish_pos)
        if d and d < FINISH_CM then sprint = true end
      end
      local sec = num(r.section, nil)
      if not sprint and sec and snap.num_sections
         and sec >= math.ceil(num(snap.num_sections, 0) * 0.75) then
        sprint = true
      end
      if not sprint and sec and snap.final_section
         and sec >= num(snap.final_section, 0) - 1 then
        sprint = true
      end
    end
    if sprint then
      add(r.name, 80.0, 2, "final lap finish")
      rec(r.name).meta.finish_sprint = true
    end
  end

  -- Solo airtime decay (only the car currently on air can get stale) and the
  -- dead-car filter -----------------------------------------------------------
  local cur_target = self.target
  for _, r in ipairs(elig) do
    local name = r.name
    local info = cars and cars[name]
    local spd = info and num(info.spd_cm_s, nil)
    if in_battle[name] or name ~= cur_target then
      self.solo_since[name] = nil
    else
      if self.solo_since[name] == nil then self.solo_since[name] = now end
      local air = now - self.solo_since[name]
      if air > AIR_GRACE_S then
        add(name, -math.min(AIR_DECAY_CAP, (air - AIR_GRACE_S) * AIR_DECAY_PER_S), 0, nil)
      end
    end
    if state == "RACING" and spd and spd < DEAD_SPEED_CM_S then
      if self.slow_since[name] == nil then self.slow_since[name] = now end
      if now - self.slow_since[name] > DEAD_GRACE_S then
        add(name, -80.0, 0, "stopped")
      end
    else
      self.slow_since[name] = nil
    end
  end

  -- Drop stale per-name history ----------------------------------------------
  for _, name in ipairs(sorted_keys(self.solo_since)) do
    if not scores[name] then self.solo_since[name] = nil end
  end
  for _, name in ipairs(sorted_keys(self.slow_since)) do
    if not scores[name] then self.slow_since[name] = nil end
  end

  -- Pick the best, with +25% stickiness and min-hold on the current target ---
  local best_name, best_value, best_prio = nil, -math.huge, 0
  local cur = self.target
  for _, name in ipairs(sorted_keys(scores)) do
    local s = scores[name]
    local v = s.value
    if name == cur and v > 0 then v = v + v * 0.25 end
    if v > best_value or (v == best_value and name == cur) then
      best_name, best_value, best_prio = name, v, s.priority
    end
  end

  local within_hold = cur ~= nil and self.target_since ~= nil
                      and (now - self.target_since) < self.min_target_hold_s
  if within_hold and best_name ~= cur and best_prio < 2 then
    best_name = cur
    best_value = scores[cur] and scores[cur].value or 0.0
    best_prio = scores[cur] and scores[cur].priority or 0
  end

  if not best_name then return nil, "no targets", 0, {} end

  if best_name ~= cur then
    self.target = best_name
    self.target_since = now
  end

  local s = scores[best_name]
  local reason = nil
  for _, preferred in ipairs({ "final lap finish", "spin / incident", "overtake" }) do
    for _, bit in ipairs(s.bits) do
      if bit == preferred then reason = bit; break end
    end
    if reason then break end
  end
  if not reason then
    for _, bit in ipairs(s.bits) do
      if bit:find("battle", 1, true) then reason = bit; break end
    end
  end
  reason = reason or s.bits[1] or ("target " .. best_name)
  return best_name, reason, best_prio, s.meta
end

-- ---------------------------------------------------------------------------
-- WHICH ANGLE: contextual shot picker (mode == "shots" or "full")
-- ---------------------------------------------------------------------------

local function phase_pick(self, state, now, avail_ok_fn)
  if self.phase_state ~= state then
    self.phase_state = state
    self.phase_idx = 1
    self.phase_since = now
  end
  local function first_available(start)
    for i = 0, #PHASE_CYCLE - 1 do
      local idx = ((start - 1 + i) % #PHASE_CYCLE) + 1
      local id = PHASE_CYCLE[idx]
      if avail_ok_fn(id) then return id, idx end
    end
    return nil, start
  end
  local id, idx = first_available(self.phase_idx)
  if id then self.phase_idx = idx end
  if now - self.phase_since >= self.phase_hold_s then
    self.phase_since = now
    local next_idx = (self.phase_idx % #PHASE_CYCLE) + 1
    local next_id, picked_idx = first_available(next_idx)
    if next_id then
      id, idx = next_id, picked_idx
      self.phase_idx = idx
    end
  end
  return id, id
end

function D:_choose_shot(snap, now, target, meta)
  local state = snap.event_state
  local avail = snap.available_shots
  local function ok(id) return avail_ok(avail, id) end

  if state == "LOBBY" or state == "COUNTDOWN" then
    return phase_pick(self, state or "LOBBY", now, ok)
  end
  if state == "FINISHED" then
    local id = ok("orbit_hero") and "orbit_hero"
              or (ok("finish_line") and "finish_line" or nil)
    return id, id
  end

  if state == "RACING" and meta and meta.finish_sprint then
    local id = ok("finish_line") and "finish_line"
              or (ok("start_crane") and "start_crane" or nil)
    return id, id
  end

  local info = snap.cars and target and snap.cars[target]
  local remote = info and info.streamed_in == false
  local pool = remote and REMOTE_POOL
            or ((meta and meta.in_battle) and BATTLE_POOL or SOLO_POOL)

  local cur = snap.current_shot or self.shot
  local pick = nil
  for i = 0, #pool - 1 do
    local idx = ((self.pool_idx + i) % #pool) + 1
    local id = pool[idx]
    if ok(id) and id ~= cur then
      pick = id
      -- pool_idx is the 0-based cursor for the NEXT cut; idx is 1-based here.
      self.pool_idx = idx % #pool
      break
    end
  end
  if not pick then
    for _, id in ipairs(pool) do
      if ok(id) then pick = id; break end
    end
  end

  return pick, pick
end

-- ---------------------------------------------------------------------------
-- step(): the one public entry point
-- ---------------------------------------------------------------------------

function D:step(snap)
  snap = type(snap) == "table" and snap or {}
  local now = num(snap.now, 0.0) or 0.0
  local mode = D.normalize_mode(snap.mode) or "off"

  if mode == "off" then
    return { target = nil, shot = nil, reason = "off",
             next_cut_in = 0.0, override_s = 0.0 }
  end

  self:_sync_current(snap, now)

  local shot_rem = math.max(0.0, (self.shot_override_until or 0.0) - now)
  local target_rem = math.max(0.0, (self.target_override_until or 0.0) - now)
  local override_s = math.max(shot_rem, target_rem, 0.0)

  local state = snap.event_state
  local phase_changed = state ~= self.last_state
  self.last_state = state

  -- WHO ----------------------------------------------------------------------
  local target_out, target_reason, target_meta = nil, nil, nil
  if mode == "full" and target_rem <= 0.0 then
    local wanted, reason, _, meta = self:_choose_target(snap, now)
    target_reason, target_meta = reason, meta
    if wanted and wanted ~= snap.current_target then target_out = wanted end
  end

  -- WHICH ANGLE --------------------------------------------------------------
  local shot_out, shot_reason = nil, nil
  if (mode == "shots" or mode == "full") and shot_rem <= 0.0 then
    local force = phase_changed
                  or (target_meta and (target_meta.finish_sprint or target_meta.incident))
    local held = self.shot_since and (now - self.shot_since) or self.min_shot_hold_s
    if force or held >= self.min_shot_hold_s then
      local wanted, reason = self:_choose_shot(snap, now, snap.current_target or self.target,
                                               target_meta)
      shot_reason = reason
      if wanted and wanted ~= (snap.current_shot or self.shot) then
        self.shot = wanted
        self.shot_since = now
        shot_out = wanted
      end
    end
  end

  -- Human-readable reason ----------------------------------------------------
  local parts = {}
  if override_s > 0.0 then
    parts[#parts + 1] = string.format("override (%ds)", math.ceil(override_s))
  end
  if target_reason then parts[#parts + 1] = target_reason end
  if shot_reason then parts[#parts + 1] = shot_reason end
  local reason = table.concat(parts, " \194\183 ")
  if reason == "" then reason = "holding" end

  local target_wait = math.max(0.0, (self.target_since or now) + self.min_target_hold_s - now)
  local shot_wait = math.max(0.0, (self.shot_since or now) + self.min_shot_hold_s - now)
  local next_cut_in = math.max(target_wait, shot_wait, override_s)

  return {
    target = target_out,
    shot = shot_out,
    reason = reason,
    next_cut_in = next_cut_in,
    override_s = override_s,
  }
end

return D
