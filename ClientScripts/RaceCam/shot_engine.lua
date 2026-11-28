-- RaceCam/shot_engine.lua — state machine for RaceCam shots and triggers.
local Paths = require("RaceCam/paths")
local E = {}
E.__index = E

local function lerp(a, b, t) return a + (b - a) * t end
local function vlerp(a, b, t)
  return { lerp(a[1], b[1], t), lerp(a[2], b[2], t), lerp(a[3], b[3], t) }
end
local function ease(t, name)
  if name == "ease_in_out_cubic" then
    local u = -2 * t + 2
    return t < 0.5 and 4 * t * t * t or 1 - (u * u * u) / 2
  end
  return t
end
local function aim(pos, look)
  local dx = look[1] - pos[1]; local dy = look[2] - pos[2]; local dz = look[3] - pos[3]
  return {
    Pitch = math.deg(math.atan(dz, math.sqrt(dx * dx + dy * dy))),
    Yaw = math.deg(math.atan(dy, dx)), Roll = 0.0,
  }
end

-- Sample a compiled route table at arc distance d (cm). Backwards-compatible:
-- routes exposing pos_at() delegate to it; plain sample tables (dist/x/y/z,
-- ordered by dist) are interpolated linearly, clamped or wrapped per
-- closed_loop/total_length_cm. Always returns a fresh { x, y, z } array.
local function route_pos_at(route, d)
  if route.pos_at then return route.pos_at(d) end
  local samples = route.samples or {}
  local n = #samples
  if n == 0 then return { 0.0, 0.0, 0.0 } end
  local total = route.total_length_cm or samples[n].dist or 0.0
  if total and total > 0 and route.closed_loop then
    d = d % total
  else
    d = math.max(0.0, math.min(d, total or 0.0))
  end
  for i = 1, n - 1 do
    local a, b = samples[i], samples[i + 1]
    if d <= (b.dist or 0.0) or i == n - 1 then
      local span = (b.dist or 0.0) - (a.dist or 0.0)
      local t = span > 0.0001 and (d - (a.dist or 0.0)) / span or 0.0
      t = math.max(0.0, math.min(1.0, t))
      return {
        (a.x or 0.0) + ((b.x or 0.0) - (a.x or 0.0)) * t,
        (a.y or 0.0) + ((b.y or 0.0) - (a.y or 0.0)) * t,
        (a.z or 0.0) + ((b.z or 0.0) - (a.z or 0.0)) * t,
      }
    end
  end
  return { samples[1].x or 0.0, samples[1].y or 0.0, samples[1].z or 0.0 }
end

-- Nearest route arc distance to an XY point (linear scan; route tables are
-- small and this runs only on transition activation).
local function route_arc_near(route, p)
  local samples = route.samples or {}
  local best, best_d = 0.0, math.huge
  for _, s in ipairs(samples) do
    local dxy = math.sqrt(((s.x or 0.0) - p[1])^2 + ((s.y or 0.0) - p[2])^2)
    if dxy < best_d then best, best_d = s.dist or 0.0, dxy end
  end
  return best
end

function E.new(core, presets, plan, route)
  local e = setmetatable({
    core = core, presets = presets, plan = plan, route = route,
    frames = 0, elapsed = 0.0, started = false,
    clock = os.clock, t0 = 0.0,
    signals = {}, gate_hits = {}, wp_index = 0,
    active = nil, transition = nil, target = nil, target_name = nil,
    target_lost = false, target_lost_since = nil, target_retry_at = 0.0,
    follow_pos = nil, follow_fwd = nil,
    queue_entries = {},
    last = { pos = { 0, 0, 0 }, look = { 0, 0, 0 }, fov = 70.0 },
    log_path = Paths.log_path("shots.txt"),
  }, E)
  return e
end

function E.log(self, s)
  if _G.RACECAM_LOG ~= 1 then return end
  local f = io.open(self.log_path, "a")
  if f then f:write(tostring(s) .. "\n") f:close() end
end

function E.signal(self, name)
  self.signals[name] = true
  if name == "start" then
    self.started = true
    self.t0 = self:clock()
    self.frames = 0
    self.elapsed = 0.0
    self:log("SIGNAL start")
  end
end

function E.set_lead(self, pos)
  if not self.route or not pos then return end
  local samples = self.route.samples or {}
  local best, best_i = math.huge, 1
  for i, s in ipairs(samples) do
    local d = math.sqrt((s.x - pos[1])^2 + (s.y - pos[2])^2)
    if d < best then best, best_i = d, i end
  end
  local dist = samples[best_i] and samples[best_i].dist or 0.0
  local wp = self.route.waypoint_projection_cm or {}
  local idx = 0
  for i, arc in ipairs(wp) do if arc <= dist then idx = i end end
  self.wp_index = idx
end

function E.find_shot(self, id)
  for _, s in ipairs(self.plan.shots or {}) do if s.id == id then return s end end
  return nil
end

function E.trigger_met(self, t)
  if not t then return false end
  local kind = t.type or t.trigger
  if kind == "boot" then return true end
  if kind == "event_start" then return self.started end
  if kind == "t_plus" or kind == "tN" then
    if not self.started then return false end
    local n = t.seconds or (t.ms and t.ms / 1000.0) or 0.0
    return self.elapsed >= n
  end
  if kind == "waypoint" then return self.wp_index >= (t.index or 0) end
  if kind == "gate" then return self.gate_hits[t.gate or ""] == true end
  return false
end

-- Shared live-target resolution (used by follow and trackside kinds).
-- Keeps the throttled re-resolve + target_lost surfacing semantics.
local function mark_target_lost(self)
  self.target = nil
  self.target_lost = true
  if not self.target_lost_since then self.target_lost_since = self:clock() end
end

local function resolve_target(self)
  if self.target then return true end
  if not self.target_name or not self.set_target_by_name then return false end
  local t = self:clock()
  if t < (self.target_retry_at or 0.0) then return false end
  self.target_retry_at = t + 0.5
  local ok = self:set_target_by_name(self.target_name)
  if ok then
    self.target_lost = false
    self.target_lost_since = nil
    return true
  end
  return false
end

-- Live target location (pcall-guarded), or nil after a throttled re-resolve.
local function target_loc(self)
  if not resolve_target(self) then return nil end
  local p = self.target
  local ok, loc = pcall(function() return p:K2_GetActorLocation() end)
  if not ok or not loc then
    mark_target_lost(self)
    if not resolve_target(self) then return nil end
    p = self.target
    ok, loc = pcall(function() return p:K2_GetActorLocation() end)
    if not ok or not loc then mark_target_lost(self) return nil end
  end
  self.target_lost = false
  self.target_lost_since = nil
  return loc
end

function E.pose_of(self, s)
  if not s then return nil end
  local kind = s.kind or "look_at"
  local preset = s.preset and self.presets.get(s.preset) or nil
  if kind == "follow" then
    local loc = target_loc(self)
    if not loc then return nil end
    local p = self.target
    self.target_lost = false
    self.target_lost_since = nil
    local o = preset and preset.offset or {}
    local lo = preset and preset.look_offset or {}
    local fx, fy = 1.0, 0.0
    local okr, rot = pcall(function() return p:K2_GetActorRotation() end)
    if okr then
      local yaw = math.rad(rot.Yaw)
      fx, fy = math.cos(yaw), math.sin(yaw)
    end
    -- Body-frame 3D offsets: { fwd, right, up } in cm along the car's heading
    -- and its right-hand normal (rx, ry) = (-fy, fx). Legacy two-slot plans
    -- write { 0, -back, up } (zero fwd, negative middle) meaning "behind the
    -- car"; keep that reading so existing plans do not jump sideways.
    local f_off, r_off, u_off
    if s.offset_body then
      local b = s.offset_body
      if (b[1] or 0.0) == 0.0 and (b[2] or 0.0) < 0.0 then
        f_off, r_off, u_off = b[2], 0.0, b[3] or 0.0
      else
        f_off, r_off, u_off = b[1] or 0.0, b[2] or 0.0, b[3] or 0.0
      end
    elseif o.fwd or o.right then
      f_off, r_off, u_off = o.fwd or 0.0, o.right or 0.0, o.up or 0.0
    else
      f_off, r_off, u_off = -(o.back or 900.0), 0.0, o.up or 350.0
    end
    local rx, ry = -fy, fx
    local alpha = s.damping or (preset and preset.flags and preset.flags.smoothing_alpha) or 0.12
    local want_pos = { loc.X + fx * f_off + rx * r_off,
                       loc.Y + fy * f_off + ry * r_off,
                       loc.Z + u_off }
    local pos = want_pos
    if self.follow_pos and alpha < 1.0 then
      pos = vlerp(self.follow_pos, want_pos, alpha)
    end
    self.follow_pos = pos
    -- Look point: look_ahead along the body forward axis (negative looks back
    -- at the car, as front_chase does to frame it and the pack behind).
    local look_ahead = (s.look_ahead_m and s.look_ahead_m * 100.0)
      or lo.look_ahead or lo.ahead or 600.0
    local look = { loc.X + fx * look_ahead, loc.Y + fy * look_ahead, loc.Z + (lo.up or 150.0) }
    return { pos = pos, look = look, fov = s.fov or (preset and preset.fov) or 70.0 }
  end
  if kind == "flyover" and self.route then
    local started = self.shot_started_at or self:clock()
    local d = (s.arc or 0.0) + (self:clock() - started) * (s.speed_cm_s or 3000.0)
    local up = (preset and preset.offset and preset.offset.up) or 350.0
    local ahead = (preset and preset.look_offset and preset.look_offset.ahead) or 2500.0
    local p = route_pos_at(self.route, d); p[3] = p[3] + up
    local lk = route_pos_at(self.route, d + ahead)
    return { pos = p, look = lk, fov = s.fov or (preset and preset.fov) or 76.0 }
  end
  if kind == "trackside_pan" then
    if not s.location then return nil end
    local pos = { s.location[1], s.location[2], s.location[3] }
    local loc = target_loc(self)
    if loc then
      -- Live pan: aim at the target and optionally zoom to keep it framed.
      local look = { loc.X, loc.Y, loc.Z + 120.0 }
      local fov = s.fov or 65.0
      if s.auto_zoom ~= false then
        local dx, dy, dz = loc.X - pos[1], loc.Y - pos[2], look[3] - pos[3]
        local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
        fov = math.max(s.fov_min or 28.0,
          math.min(s.fov_max or 65.0, 220000.0 / math.max(dist, 1500.0)))
      end
      return { pos = pos, look = look, fov = fov }
    end
    -- No live target: fall back to the static frame.
    local look = s.look_at and { s.look_at[1], s.look_at[2], s.look_at[3] } or pos
    return { pos = pos, look = look, fov = s.fov or 65.0 }
  end
  if kind == "auto_trackside" then
    -- Pick the trackside camera nearest the live target; stick with the
    -- current pick until a challenger is meaningfully closer (hysteresis).
    local cands = {}
    for _, c in ipairs(self.plan.shots or {}) do
      if c ~= s and c.location
          and ((c.role == "trackside") or (c.kind or "") == "trackside_pan") then
        cands[#cands + 1] = c
      end
    end
    if #cands == 0 then
      -- No trackside cameras in the plan: behave as a follow shot.
      local fallback = {}
      for k, v in pairs(s) do fallback[k] = v end
      fallback.kind = "follow"
      return self:pose_of(fallback)
    end
    local loc = target_loc(self)
    local tx, ty = 0.0, 0.0
    local fwd_x, fwd_y = nil, nil
    if loc then
      tx, ty = loc.X, loc.Y
      local okr, rot = pcall(function() return self.target:K2_GetActorRotation() end)
      if okr and rot then
        local yaw = math.rad(rot.Yaw)
        fwd_x, fwd_y = math.cos(yaw), math.sin(yaw)
      end
    end
    local best, best_score = nil, math.huge
    for _, c in ipairs(cands) do
      local dx, dy = c.location[1] - tx, c.location[2] - ty
      local score = math.sqrt(dx * dx + dy * dy)
      if fwd_x and (dx * fwd_x + dy * fwd_y > 0.0) then
        -- Small preference for cameras ahead of the target's heading.
        score = score - 500.0
      end
      if c.id == self.auto_cam_id then score = score - 800.0 end
      if score < best_score then best, best_score = c, score end
    end
    if not best then return nil end
    self.auto_cam_id = best.id
    local chosen = {}
    for k, v in pairs(best) do chosen[k] = v end
    return self:pose_of(chosen)
  end
  if kind == "orbit" then
    local loc = target_loc(self)
    local c
    if loc then
      c = { loc.X, loc.Y, loc.Z }
    elseif s.center then
      c = { s.center[1], s.center[2], s.center[3] }
    else
      c = { self.last.look[1], self.last.look[2], self.last.look[3] }
    end
    local po = preset and preset.offset or {}
    local r = s.radius_cm or po.radius_cm or 1200.0
    local h = s.height_cm or po.height_cm or 450.0
    local dps = s.deg_per_s or po.deg_per_s or 18.0
    local started = self.shot_started_at or self:clock()
    local ang = math.rad((self:clock() - started) * dps)
    local pos = { c[1] + math.cos(ang) * r, c[2] + math.sin(ang) * r, c[3] + h }
    local look = { c[1], c[2], c[3] + 100.0 }
    return { pos = pos, look = look, fov = s.fov or (preset and preset.fov) or 60.0 }
  end
  if s.to and (kind == "tween" or s.transition == "spline") then
    return { pos = { s.to.location[1], s.to.location[2], s.to.location[3] },
             look = { s.to.look_at[1], s.to.look_at[2], s.to.look_at[3] },
             fov = s.to.fov or 70.0 }
  end
  if s.location and s.look_at then
    return { pos = { s.location[1], s.location[2], s.location[3] },
             look = { s.look_at[1], s.look_at[2], s.look_at[3] }, fov = s.fov or 70.0 }
  end
  return nil
end

function E.activate(self, s, via)
  if not s then return false end
  self.shot_started_at = self:clock()
  -- A new follow shot restarts position/heading smoothing from the fresh pose
  -- (clear before pose_of so the activation frame does not blend with the old
  -- follow shot's position).
  if s.kind == "follow" then
    self.follow_pos = nil
    self.follow_fwd = nil
  end
  local to = self:pose_of(s)
  if not to then return false end
  -- A non-follow shot has no live target: the TARGET LOST banner must clear.
  if (s.kind or "look_at") ~= "follow" then
    self.target_lost = false
    self.target_lost_since = nil
  end
  local trans = "cut"
  if s.kind == "tween" then trans = "tween" end
  if s.transition == "spline" then trans = "spline" end
  self.active = s
  self.via = via or "trigger"
  self.active_via = self.via
  self.transition = {
    mode = trans, t = 0.0, started_at = self:clock(),
    duration = (s.duration_ms or 4000) / 1000.0,
    ease = s.ease or "linear",
    from = { pos = self.last.pos, look = self.last.look, fov = self.last.fov },
    to = to,
  }
  if s.from and trans == "tween" then
    self.transition.from = {
      pos = { s.from.location[1], s.from.location[2], s.from.location[3] },
      look = { s.from.look_at[1], s.from.look_at[2], s.from.look_at[3] },
      fov = s.from.fov or 70.0,
    }
  end
  self:log(string.format("SHOT %d %s via=%s trans=%s dur=%.2f", self.frames, s.id, self.via, trans, self.transition.duration))
  return true
end

function E.set_target(self, pawn)
  self.target = pawn
  return pawn and "target set" or "target cleared"
end

-- Stable contestant identity -------------------------------------------------
-- Live-proven via UEBridge: pawn.PlayerState:GetPlayerName():ToString() returns
-- the real player name; BP_GetUniqueId() is NOT exposed. Player name is the
-- stable key; the pawn-index API below stays as a fallback.

function E.pawn_name(self, pawn)
  if not pawn then return nil end
  local ok, name = pcall(function()
    local ps = pawn.PlayerState
    if not ps or not ps.GetPlayerName then return nil end
    return ps:GetPlayerName():ToString()
  end)
  if ok and type(name) == "string" and name ~= "" then return name end
  return nil
end

function E.pawns(self)
  local ok, found = pcall(function() return FindAllOf("MTPlayerCharacter_C") end)
  if not ok or type(found) ~= "table" then return {} end
  return found
end

function E.list_targets(self)
  local names = {}
  for _, p in ipairs(self:pawns()) do
    local n = self:pawn_name(p)
    if n then names[#names + 1] = n end
  end
  return names
end

-- Returns (ok, message): true,"target <name>" on success.
function E.set_target_by_name(self, name)
  if not name or name == "" then return false, "no name given" end
  local found = self:pawns()
  if #found == 0 then return false, "no pawns" end
  for i, p in ipairs(found) do
    if self:pawn_name(p) == name then
      if self.target ~= p then self.follow_pos = nil; self.follow_fwd = nil end
      self.target = p
      self.target_name = name
      self.target_index = i
      self.target_lost = false
      self.target_lost_since = nil
      self:log("TARGET name=" .. name .. " idx=" .. tostring(i))
      return true, "target " .. name
    end
  end
  return false, "no pawn named " .. tostring(name)
end

function E.set_target_by_index(self, i)
  local ok, pawns = pcall(function() return FindAllOf("MTPlayerCharacter_C") end)
  if not ok or not pawns or not pawns[i] then return "no pawn " .. tostring(i) end
  self.target = pawns[i]
  self.target_index = i
  self.target_name = self:pawn_name(pawns[i])
  self.target_lost = false
  self.target_lost_since = nil
  return "target " .. tostring(i)
end

-- Cue queue -------------------------------------------------------------------
-- Ordered shot cues with optional absolute timing: at_t is an absolute time on
-- the event clock (seconds since the start signal), not a delay. The head cue
-- fires automatically in update() when due; untimed cues wait for queue_next()
-- or for their shot to be triggered manually. A manual trigger interrupts: it
-- removes the fired shot and every earlier cue, so the stack rewinds to the
-- next cue, and a manual shot is never overridden by auto-fire. All queue work
-- is O(queue length) per call — nothing blocks the game thread.

local function norm_entry(entry)
  if type(entry) == "string" then return { id = entry, at_t = nil } end
  if type(entry) == "table" and entry.id then
    return { id = entry.id, at_t = entry.at_t }
  end
  return nil
end

-- spec: array of cues, each a shot-id string or a table { id=..., at_t=... }.
-- A single cue table is accepted too. nil clears the queue.
function E.queue(self, spec)
  local entries = {}
  if spec then
    local list = spec
    if type(spec) == "table" and spec.id and #spec == 0 then list = { spec } end
    if type(list) == "table" then
      for _, item in ipairs(list) do
        local e = norm_entry(item)
        if e then entries[#entries + 1] = e end
      end
    end
  end
  self.queue_entries = entries
  self:log("QUEUE set n=" .. tostring(#entries))
  return "queued " .. tostring(#entries)
end

function E.queue_add(self, shot_id, at_t)
  if not shot_id then return "queue_add: no id" end
  self.queue_entries = self.queue_entries or {}
  self.queue_entries[#self.queue_entries + 1] = { id = shot_id, at_t = at_t }
  self:log(string.format("QUEUE add %s at_t=%s", tostring(shot_id), tostring(at_t)))
  return "queued " .. tostring(shot_id)
end

-- Fire the head cue now (skipping cues whose shot no longer exists).
function E.queue_next(self)
  while true do
    local head = self.queue_entries and self.queue_entries[1]
    if not head then return "QUEUE_EMPTY" end
    table.remove(self.queue_entries, 1)
    local s = self:find_shot(head.id)
    if s then
      if self:activate(s, "cue") then
        self:log("CUE manual-fire " .. tostring(head.id))
        return "ok " .. tostring(head.id)
      end
      return "NO_POSE_" .. tostring(head.id)
    end
    self:log("QUEUE skip missing " .. tostring(head.id))
  end
end

function E.queue_clear(self)
  local n = self.queue_entries and #self.queue_entries or 0
  self.queue_entries = {}
  self:log("QUEUE clear n=" .. tostring(n))
  return "cleared " .. tostring(n)
end

-- Panel-facing snapshot: next_shot (id or nil), countdown (seconds until the
-- head cue fires; nil when the head is untimed or the event has not started),
-- and queue (array of { id=..., at_t=... }) for rendering the cue stack.
function E.status(self)
  local out = { queue = {} }
  if self.active then
    out.shot = self.active.id
    out.via = self.active_via
  end
  out.elapsed = self.elapsed
  out.started = self.started
  out.target_lost = self.target_lost and true or false
  if self.target_lost_since then out.target_lost_for = self:clock() - self.target_lost_since end
  for _, e in ipairs(self.queue_entries or {}) do
    out.queue[#out.queue + 1] = { id = e.id, at_t = e.at_t }
  end
  local head = self.queue_entries and self.queue_entries[1]
  if head then
    out.next_shot = head.id
    if head.at_t and self.started then
      local cd = head.at_t - self.elapsed
      out.countdown = cd > 0 and cd or 0.0
    end
  end
  return out
end

function E.apply_last(self)
  if not self.last then return end
  self.core.apply_pose(self.last.pos, aim(self.last.pos, self.last.look), self.last.fov)
end

function E.manual(self, id)
  local s = self:find_shot(id)
  if not s then return "NO_SHOT_" .. tostring(id) end
  -- Manual trigger interrupts the cue stack: drop the fired shot and every
  -- earlier cue so the queue rewinds to the next cue after it.
  if not self:activate(s, "manual") then return "NO_POSE_" .. tostring(id) end
  if self.queue_entries then
    local found = false
    for _, e in ipairs(self.queue_entries) do
      local eid = type(e) == "table" and e.id or e
      if eid == id then found = true break end
    end
    if found then
      local kept, past = {}, false
      for _, e in ipairs(self.queue_entries) do
        local eid = type(e) == "table" and e.id or e
        if past then kept[#kept + 1] = e
        elseif eid == id then past = true end
      end
      self.queue_entries = kept
      self:log(string.format("QUEUE interrupt via manual %s left=%d", tostring(id), #kept))
    else
      self:log("QUEUE kept on manual " .. tostring(id) .. " (not queued)")
    end
  end
  return "ok " .. id
end

function E.update(self)
  self.frames = self.frames + 1
  if self.started then self.elapsed = self:clock() - (self.t0 or self:clock()) end
  local candidate = nil
  for _, s in ipairs(self.plan.shots or {}) do
    if self:trigger_met(s.trigger) then candidate = s end
  end
  if candidate and (not self.active or
      (self.active_via == "trigger" and candidate.id ~= self.active.id)) then
    self:activate(candidate, "trigger")
  end
  -- Auto-fire the head cue when its absolute t+ time is due. Never overrides a
  -- manual shot, and only runs while the event clock is started.
  local q = self.queue_entries or {}
  local head = q[1]
  if head and head.at_t and self.started and self.elapsed >= head.at_t then
    table.remove(q, 1)
    local s = self:find_shot(head.id)
    if not s then
      self:log("CUE miss " .. tostring(head.id) .. " no_shot")
    elseif self.active and self.active_via == "manual" then
      -- A manual shot owns the camera: drop the overtaken cue instead of
      -- leaving it queued to fire at a stale moment later.
      self:log("CUE skipped_by_manual " .. tostring(head.id))
    elseif self:activate(s, "cue") then
      self:log("CUE fire " .. tostring(head.id))
    else
      self:log("CUE no pose " .. tostring(head.id))
    end
  end
  if not self.active or not self.transition then return end
  local tr = self.transition
  local pose
  if tr.mode == "tween" or tr.mode == "spline" then
    tr.t = math.min(1.0, (self:clock() - (tr.started_at or self:clock())) / tr.duration)
    local k = ease(tr.t, tr.ease)
    local pos
    if tr.mode == "spline" and self.route then
      -- Walk the route by arc length between the from/to poses.
      local fa = route_arc_near(self.route, tr.from.pos)
      local ta = route_arc_near(self.route, tr.to.pos)
      pos = route_pos_at(self.route, fa + (ta - fa) * k)
    else
      pos = vlerp(tr.from.pos, tr.to.pos, k)
    end
    pose = {
      pos = pos,
      look = vlerp(tr.from.look, tr.to.look, k),
      fov = lerp(tr.from.fov, tr.to.fov, k),
    }
  else
    pose = self:pose_of(self.active) or self.last or tr.to
  end
  if not pose then return end
  self.last = pose
  self.core.apply_pose(pose.pos, aim(pose.pos, pose.look), pose.fov)
  if (self.frames % 5) == 0 then
    self:log(string.format("D f=%d p=%.1f,%.1f,%.1f fov=%.1f shot=%s", self.frames,
      pose.pos[1], pose.pos[2], pose.pos[3], pose.fov, tostring(self.active.id)))
  end
end

return E
