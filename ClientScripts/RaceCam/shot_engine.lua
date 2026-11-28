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

-- dt-invariant smoothing ------------------------------------------------------
local function clamp_num(v, lo, hi)
  if v < lo then return lo end
  if v > hi then return hi end
  return v
end

-- Exponential smoothing coefficient for a wall-clock step dt and time constant
-- tau (seconds). tau <= 0 means "snap". Unlike a fixed per-frame alpha this is
-- identical at 30 / 60 / 120 FPS and survives frame-time spikes.
local function exp_alpha(dt, tau)
  if not tau or tau <= 0.0 then return 1.0 end
  return 1.0 - math.exp(-dt / tau)
end
E.exp_alpha = exp_alpha

local function norm_xy(x, y, fb_x, fb_y)
  local n = math.sqrt(x * x + y * y)
  if n > 1.0e-6 then return x / n, y / n end
  return fb_x or 1.0, fb_y or 0.0
end

local DEFAULT_TAU = {
  tau_pos = 0.14, tau_look = 0.12, tau_hdg = 0.20, tau_fov = 0.22,
}

-- Trackside broadcast tripods aim a little above the car's root so the car
-- sits in the vertical centre of the frame rather than hanging off the bottom.
local TRACKSIDE_LOOK_UP = 110.0

-- Legacy 60 Hz alpha -> time constant, so old plans using `damping` /
-- `smoothing_alpha` keep their previous feel without any explicit tau.
local function legacy_alpha_tau(a, default)
  if type(a) ~= "number" then return default end
  if a >= 1.0 then return 0.0 end
  if a <= 0.0 then return default end
  return -1.0 / (60.0 * math.log(1.0 - a))
end

-- Explicit tau_* on the shot wins, then the preset flags, then the legacy
-- alpha conversion, then a sensible default. Operator smoothing multiplier is
-- applied to every effective tau.
local function shot_tau(self, s, preset, name)
  local flags = preset and preset.flags or nil
  local v = s and s[name]
  if type(v) ~= "number" or v <= 0.0 then v = flags and flags[name] end
  if type(v) ~= "number" or v <= 0.0 then
    local a = s and s.damping
    if type(a) ~= "number" then a = s and s.smoothing_alpha end
    if type(a) ~= "number" then a = flags and flags.smoothing_alpha end
    v = legacy_alpha_tau(a, DEFAULT_TAU[name] or 0.14)
  end
  return v * (self.smoothing_scale or 1.0)
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
    follow_pos = nil, follow_look = nil, follow_fwd = nil,
    smooth_fov = nil, tgt_filter = nil,
    auto_cam_id = nil, auto_cam_since = nil,
    smoothing_mode = "normal", smoothing_scale = 1.0,
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

-- Operator-facing smoothing multiplier (Stage 2). Affects every effective
-- tau_*; "tight" halves the time constants, "cinematic" makes them 1.8x longer.
local SMOOTHING_SCALES = { tight = 0.5, normal = 1.0, cinematic = 1.8 }

function E.set_smoothing_mode(self, mode)
  if type(mode) ~= "string" then return nil, "invalid mode" end
  local key = mode:lower()
  if not SMOOTHING_SCALES[key] then return nil, "invalid mode" end
  self.smoothing_mode = key
  self.smoothing_scale = SMOOTHING_SCALES[key]
  return key
end

local function reset_rig(self)
  self.follow_pos = nil
  self.follow_look = nil
  self.follow_fwd = nil
  self.smooth_fov = nil
  -- A shot cut (activate -> reset_smoothing) restarts the director's hold
  -- timer, so the first trackside frame picks the camera freshly.
  self.auto_cam_since = nil
end

-- Wipe every smoothed state so a shot cut / target switch is a crisp cut, never
-- a smear from the previous driver or camera position.
function E.reset_smoothing(self)
  reset_rig(self)
  self.tgt_filter = nil
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
-- Prefers a streamed-in MTPlayerCharacter_C pawn; falls back to the map-wide
-- replicated AMotorTownPlayerState.Location when the driver is outside UE5's
-- network relevancy bubble, upgrading back to the live pawn automatically once
-- they stream in.
local function ps_location(ps)
  if not ps then return nil end
  local ok, loc = pcall(function()
    if ps.IsValid and not ps:IsValid() then return nil end
    local l = ps.Location
    if not l then return nil end
    if l.X == nil and l[1] == nil then return nil end
    return l
  end)
  if ok and loc then return loc end
  return nil
end

-- Vehicle-root sampling ------------------------------------------------------
-- A MTPlayerCharacter_C is seated when GetVehicle() / LastVehicle /
-- AttachParent resolves to a live actor exposing the UE actor pose API. Every
-- probe is pcall-guarded: missing methods or pending-kill UE objects must
-- never abort a camera tick.
local function is_live(o)
  if not o then return false end
  local ok, live = pcall(function()
    if type(o.IsValid) == "function" then return o:IsValid() ~= false end
    if o.IsValid ~= nil then return o.IsValid ~= false end
    return true
  end)
  return ok and live ~= false
end

local function has_actor_pose(o)
  if not is_live(o) then return false end
  local ok, get_loc, get_rot = pcall(function() return o.K2_GetActorLocation, o.K2_GetActorRotation end)
  return ok and type(get_loc) == "function" and type(get_rot) == "function"
end

local function seated_vehicle(p)
  if not p then return nil end
  local ok, candidates = pcall(function()
    local out = {}
    if p.GetVehicle then out[#out + 1] = p:GetVehicle() end
    local parent = nil
    if p.GetAttachParentActor then parent = p:GetAttachParentActor() end
    if not is_live(parent) and p.AttachParent then parent = p.AttachParent end
    if parent then out[#out + 1] = parent end
    return out
  end)
  if not ok or type(candidates) ~= "table" then return nil end
  for _, v in ipairs(candidates) do
    if has_actor_pose(v) then return v end
  end
  return nil
end
E.seated_vehicle = seated_vehicle

-- The actor whose world transform represents the contestant: the vehicle root
-- when seated, otherwise the MTPlayerCharacter_C pawn itself.
local function pose_actor(p)
  return (p and seated_vehicle(p)) or p
end

local function target_loc(self)
  if not self.target then
    -- Periodically check whether the live pawn has streamed in (or re-resolve
    -- a lost target).
    resolve_target(self)
  end
  local p = self.target
  if p then
    local actor = pose_actor(p)
    local ok, loc = pcall(function() return actor:K2_GetActorLocation() end)
    if ok and loc then
      self.target_lost = false
      self.target_lost_since = nil
      return loc
    end
    -- Pawn despawned or streamed out of relevancy; try re-resolving (which may
    -- fall back to PlayerState.Location).
    self.target = nil
    self.target_retry_at = 0.0
    resolve_target(self)
    if self.target then
      local a2 = pose_actor(self.target)
      local ok2, loc2 = pcall(function() return a2:K2_GetActorLocation() end)
      if ok2 and loc2 then
        self.target_lost = false
        self.target_lost_since = nil
        return loc2
      end
      self.target = nil
    end
  end
  if self.target_ps then
    local loc = ps_location(self.target_ps)
    if loc then
      self.target_lost = false
      self.target_lost_since = nil
      return loc
    end
    self.target_ps = nil
  end
  mark_target_lost(self)
  return nil
end

-- Stage 1 — shared velocity-compensated target state estimator.
-- Updated at most once per clock tick; every live shot kind consumes the same
-- filtered position / velocity / heading so cuts between them never disagree.
local function target_state(self, s, preset)
  local loc = target_loc(self)
  if not loc then return nil end
  local p = self.target
  local actor_ref = p or self.target_ps
  local raw = { loc.X or loc[1] or 0.0, loc.Y or loc[2] or 0.0, loc.Z or loc[3] or 0.0 }
  local fx, fy = 1.0, 0.0
  if p then
    -- When seated, sample the vehicle root's yaw, not the driver pawn's: long
    -- / tall vehicles otherwise put the camera off by metres on hairpins.
    local pose_a = pose_actor(p)
    local okr, rot = pcall(function() return pose_a:K2_GetActorRotation() end)
    if okr and rot then
      local yaw = math.rad(rot.Yaw or 0.0)
      fx, fy = math.cos(yaw), math.sin(yaw)
    end
  elseif self.tgt_filter and self.tgt_filter.fwd then
    fx, fy = self.tgt_filter.fwd[1], self.tgt_filter.fwd[2]
  end
  local now = self:clock()
  local f = self.tgt_filter
  local name = self.target_name

  -- Fresh target / target switch / first tick: snap, never interpolate across
  -- the map from a previous driver. Same driver upgrading between remote
  -- PlayerState and streamed-in pawn keeps the filter continuous unless >25m.
  local same_driver = f and name and name ~= "" and f.name == name
  if not f or (not same_driver and f.actor ~= actor_ref) then
    reset_rig(self)
    self.tgt_filter = {
      pos = { raw[1], raw[2], raw[3] }, vel = { 0.0, 0.0, 0.0 },
      fwd = { fx, fy }, t = now, dt = 1.0 / 60.0, actor = actor_ref, name = name,
    }
    return self.tgt_filter
  end
  f.actor = actor_ref
  -- pose_of can be called more than once in a tick (activate + update, or the
  -- auto_trackside recursion). The estimator must be idempotent within a tick.
  if now <= f.t then return f end

  local dt = clamp_num(now - f.t, 1.0 / 240.0, 0.10)
  f.dt = dt
  local dx, dy, dz = raw[1] - f.pos[1], raw[2] - f.pos[2], raw[3] - f.pos[3]
  local jump = math.sqrt(dx * dx + dy * dy + dz * dz)
  if jump > 2500.0 then
    -- Respawn / teleport / rubber-band across >25 m: hard snap in one tick.
    reset_rig(self)
    f.pos[1], f.pos[2], f.pos[3] = raw[1], raw[2], raw[3]
    f.vel[1], f.vel[2], f.vel[3] = 0.0, 0.0, 0.0
    f.fwd[1], f.fwd[2] = fx, fy
    f.t = now
    return f
  end

  -- Critically/slightly-overdamped alpha-beta predictor (zeta >= 1.15):
  -- dead-reckons smoothly between network packets without ringing.
  -- Critical damping for a discrete alpha-beta filter is
  -- beta_crit = 2 - alpha - 2*sqrt(1 - alpha) (~alpha^2 / 4).
  -- Using 0.75 * beta_crit guarantees zero spring overshoot on bursty network
  -- packet arrival or hard braking/acceleration.
  local px = f.pos[1] + f.vel[1] * dt
  local py = f.pos[2] + f.vel[2] * dt
  local pz = f.pos[3] + f.vel[3] * dt
  local ex, ey, ez = raw[1] - px, raw[2] - py, raw[3] - pz
  local err = math.sqrt(ex * ex + ey * ey + ez * ez)
  local scale = 1.0
  if err > 300.0 then
    -- Brief packet-loss rubber-banding: bound the step correction so the
    -- camera glides instead of snapping. >25 m is handled above as a cut.
    scale = err > 2500.0 and 0.12 or (300.0 / err)
  end
  ex, ey, ez = ex * scale, ey * scale, ez * scale
  -- Critically damped alpha-beta predictor (zeta = 1.0, ZERO spring bounce):
  -- For a 2nd-order critically damped tracker with time constant tau_pos,
  -- alpha = 1 - exp(-2*dt/tau_pos) and beta_crit = 2 - alpha - 2*sqrt(1-alpha).
  -- This converges in ~4*tau_pos on hard braking/acceleration with zero
  -- overshoot while crushing 10-15 Hz network packet jitter.
  local tau_pos = shot_tau(self, s, preset, "tau_pos")
  local alpha_pos = exp_alpha(dt, tau_pos * 0.5)
  local beta_vel = 2.0 - alpha_pos - 2.0 * math.sqrt(math.max(0.0, 1.0 - alpha_pos))
  f.pos[1], f.pos[2], f.pos[3] = px + ex * alpha_pos, py + ey * alpha_pos, pz + ez * alpha_pos
  local inv_dt = 1.0 / math.max(dt, 0.008)
  f.vel[1] = clamp_num(f.vel[1] + ex * inv_dt * beta_vel, -12000.0, 12000.0)
  f.vel[2] = clamp_num(f.vel[2] + ey * inv_dt * beta_vel, -12000.0, 12000.0)
  f.vel[3] = clamp_num(f.vel[3] + ez * inv_dt * beta_vel, -12000.0, 12000.0)

  -- Heading: prefer the velocity vector once the car is moving, blended with
  -- the (noisier) replicated actor yaw; fall back to pure smoothed actor yaw
  -- when stationary or reversing.
  local spd = math.sqrt(f.vel[1] * f.vel[1] + f.vel[2] * f.vel[2])
  local tx, ty = fx, fy
  if spd > 300.0 then
    local w = clamp_num((spd - 300.0) / 700.0, 0.0, 0.8)
    tx, ty = (f.vel[1] / spd) * w + fx * (1.0 - w),
             (f.vel[2] / spd) * w + fy * (1.0 - w)
  end
  local nx, ny = norm_xy(tx, ty, fx, fy)
  local kh = exp_alpha(dt, shot_tau(self, s, preset, "tau_hdg"))
  local hx = f.fwd[1] + (nx - f.fwd[1]) * kh
  local hy = f.fwd[2] + (ny - f.fwd[2]) * kh
  f.fwd[1], f.fwd[2] = norm_xy(hx, hy, f.fwd[1], f.fwd[2])
  f.t = now
  return f
end

-- Pack-battle rival search ---------------------------------------------------
-- Nearby streamed-in pawns first, then the map-wide PlayerArray so a rival
-- outside UE5's relevancy bubble still frames correctly. Identity and name
-- checks prevent the focus car itself from being picked as its own rival.
local function contestant_pos(entry)
  if not entry then return nil end
  local ok, loc = pcall(function()
    if entry.K2_GetActorLocation then
      local l = entry:K2_GetActorLocation()
      if l and (l.X ~= nil or l[1] ~= nil) then return l end
    end
    if entry.Location then
      local l = entry.Location
      if l and (l.X ~= nil or l[1] ~= nil) then return l end
    end
    return nil
  end)
  if not ok or not loc then return nil end
  return { loc.X or loc[1] or 0.0, loc.Y or loc[2] or 0.0, loc.Z or loc[3] or 0.0 }
end

local function is_focus(self, entry, is_ps)
  if entry == self.target or entry == self.target_ps then return true end
  local name = is_ps and self:ps_name(entry) or self:pawn_name(entry)
  return name ~= nil and self.target_name ~= nil and name == self.target_name
end

local function nearest_rival(self, focus, max_rival_cm)
  local limit = max_rival_cm or 3500.0
  local best, best_d, seen = nil, math.huge, {}
  local function consider(entry, is_ps)
    if not entry or is_focus(self, entry, is_ps) then return end
    local pos = contestant_pos(entry)
    if not pos then return end
    local d = math.sqrt((pos[1] - focus[1])^2 + (pos[2] - focus[2])^2)
    if d <= limit and d < best_d then
      local key = string.format("%s:%.0f_%.0f", is_ps and "ps" or "p", pos[1], pos[2])
      if not seen[key] then
        seen[key] = true
        best, best_d = { pos = pos, entry = entry }, d
      end
    end
  end
  for _, p in ipairs(self:pawns()) do consider(p, false) end
  for _, ps in ipairs(self:player_states()) do consider(ps, true) end
  return best, best_d
end
E._nearest_rival = nearest_rival

function E.pose_of(self, s)
  if not s then return nil end
  local kind = s.kind or "look_at"
  local preset = s.preset and self.presets.get(s.preset) or nil
  if kind == "follow" then
    local st = target_state(self, s, preset)
    if not st then return nil end
    local loc = st.pos
    local fx, fy = st.fwd[1], st.fwd[2]
    local o = preset and preset.offset or {}
    local lo = preset and preset.look_offset or {}
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
    local dt = st.dt or (1.0 / 60.0)
    local want_pos = { loc[1] + fx * f_off + rx * r_off,
                       loc[2] + fy * f_off + ry * r_off,
                       loc[3] + u_off }
    -- Stage 1 already filtered st.pos and st.fwd cleanly; keeping XY rigidly
    -- attached to the filtered rig eliminates longitudinal rubber-banding
    -- during hard braking/acceleration while still damping vertical Z bumps.
    local pos = want_pos
    if self.follow_pos then
      local kz = exp_alpha(dt, shot_tau(self, s, preset, "tau_pos") * 1.5)
      pos = {
        want_pos[1],
        want_pos[2],
        lerp(self.follow_pos[3], want_pos[3], kz),
      }
    end
    self.follow_pos = pos
    self.follow_fwd = { fx, fy }
    -- Look point: look_ahead along the body forward axis (negative looks back
    -- at the car, as front_chase does to frame it and the pack behind).
    local look_ahead = (s.look_ahead_m and s.look_ahead_m * 100.0)
      or lo.look_ahead or lo.ahead or 250.0
    local want_look = { loc[1] + fx * look_ahead, loc[2] + fy * look_ahead,
                        loc[3] + (lo.up or 130.0) }
    local look = want_look
    if self.follow_look then
      look = vlerp(self.follow_look, want_look, exp_alpha(dt, shot_tau(self, s, preset, "tau_look") * 0.5))
    end
    self.follow_look = look
    return { pos = pos, look = look, fov = s.fov or (preset and preset.fov) or 70.0 }
  end
  if kind == "pack_battle" then
    local st = target_state(self, s, preset)
    if not st then return nil end
    local rival = nearest_rival(self, st.pos, s.max_rival_cm)
    if not rival then
      -- Solo: clean fallback to an ordinary follow rig (preset offset / fov).
      local fallback = {}
      for k, v in pairs(s) do fallback[k] = v end
      fallback.kind = "follow"
      return self:pose_of(fallback)
    end
    local fx, fy = st.fwd[1], st.fwd[2]
    local rx, ry = -fy, fx
    local mid_z = 0.6 * st.pos[3] + 0.4 * rival.pos[3]
    local mid = { 0.6 * st.pos[1] + 0.4 * rival.pos[1],
                  0.6 * st.pos[2] + 0.4 * rival.pos[2],
                  mid_z + TRACKSIDE_LOOK_UP }
    local o = preset and preset.offset or {}
    local f_off = o.fwd or -(o.back or 1200.0)
    local r_off = o.right or 0.0
    local u_off = o.up or 420.0
    local dt = st.dt or (1.0 / 60.0)
    local want_pos = { mid[1] + fx * f_off + rx * r_off,
                       mid[2] + fy * f_off + ry * r_off,
                       mid_z + u_off }
    local pos = want_pos
    if self.follow_pos then
      local kxy = exp_alpha(dt, shot_tau(self, s, preset, "tau_pos"))
      local kz = exp_alpha(dt, shot_tau(self, s, preset, "tau_pos") * 1.5)
      pos = {
        lerp(self.follow_pos[1], want_pos[1], kxy),
        lerp(self.follow_pos[2], want_pos[2], kxy),
        lerp(self.follow_pos[3], want_pos[3], kz),
      }
    end
    self.follow_pos = pos
    self.follow_fwd = { fx, fy }
    local want_look = mid
    local look = want_look
    if self.follow_look then
      look = vlerp(self.follow_look, want_look, exp_alpha(dt, shot_tau(self, s, preset, "tau_look")))
    end
    self.follow_look = look
    -- True 3D angular separation between focus and rival as seen from the
    -- camera, plus framing margin, so nose-to-tail battles stay crisp while
    -- side-by-side battles widen smoothly to keep both cars in view.
    local v1x, v1y, v1z = st.pos[1] - pos[1], st.pos[2] - pos[2], (st.pos[3] + TRACKSIDE_LOOK_UP) - pos[3]
    local v2x, v2y, v2z = rival.pos[1] - pos[1], rival.pos[2] - pos[2], (rival.pos[3] + TRACKSIDE_LOOK_UP) - pos[3]
    local m1 = math.max(math.sqrt(v1x*v1x + v1y*v1y + v1z*v1z), 1.0)
    local m2 = math.max(math.sqrt(v2x*v2x + v2y*v2y + v2z*v2z), 1.0)
    local cos_a = clamp_num((v1x*v2x + v1y*v2y + v1z*v2z) / (m1 * m2), -1.0, 1.0)
    local span_deg = math.deg(math.acos(cos_a))
    local want_fov = clamp_num(span_deg * 1.35 + 28.0, 56.0, 84.0)
    local fov = want_fov
    if self.smooth_fov then
      fov = lerp(self.smooth_fov, want_fov, exp_alpha(dt, shot_tau(self, s, preset, "tau_fov")))
    end
    self.smooth_fov = fov
    return { pos = pos, look = look, fov = fov }
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
    local st = target_state(self, s, preset)
    if st then
      -- Broadcast tripod head: aim at the filtered target with a subtle
      -- velocity lead, and glide the physically-derived optical zoom.
      local dx, dy = st.pos[1] - pos[1], st.pos[2] - pos[2]
      local dz = st.pos[3] + TRACKSIDE_LOOK_UP - pos[3]
      local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
      local spd = math.sqrt(st.vel[1] * st.vel[1] + st.vel[2] * st.vel[2])
      local lead = math.min(350.0, spd * 0.15)
        * clamp_num((dist - 1500.0) / 2500.0, 0.0, 1.0)
      local lx, ly = norm_xy(st.vel[1], st.vel[2], st.fwd[1], st.fwd[2])
      local want_look = { st.pos[1] + lx * lead, st.pos[2] + ly * lead,
                          st.pos[3] + TRACKSIDE_LOOK_UP }
      local look = want_look
      if self.follow_look then
        look = vlerp(self.follow_look, want_look,
          exp_alpha(st.dt or (1.0 / 60.0), shot_tau(self, s, preset, "tau_look")))
      end
      self.follow_look = look
      local fov = s.fov or 65.0
      if s.auto_zoom ~= false then
        -- Physical-size auto-zoom: a car of `car_span_cm` should fill
        -- `target_fill` of the horizontal frame at this camera distance.
        local car_span_cm = s.car_span_cm or 550.0
        local target_fill = s.target_fill or 0.28
        local fov_min = s.fov_min or 13.0
        local fov_max = s.fov_max or 58.0
        local want_fov = clamp_num(
          math.deg(2.0 * math.atan((car_span_cm / target_fill) / (2.0 * math.max(dist, 600.0)))),
          fov_min, fov_max)
        fov = want_fov
        if self.smooth_fov then
          fov = lerp(self.smooth_fov, want_fov,
            exp_alpha(st.dt or (1.0 / 60.0), shot_tau(self, s, preset, "tau_fov")))
        end
      end
      self.smooth_fov = fov
      return { pos = pos, look = look, fov = fov }
    end
    -- No live target: fall back to the static frame.
    local look = s.look_at and { s.look_at[1], s.look_at[2], s.look_at[3] } or pos
    return { pos = pos, look = look, fov = s.fov or 65.0 }
  end
  if kind == "auto_trackside" then
    -- TV director: choose a trackside camera with approach-first scoring,
    -- hold the pick for a minimum time, then hand off cleanly after pass-by.
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
    local st = target_state(self, s, preset)
    local tx, ty = 0.0, 0.0
    local fwd_x, fwd_y = nil, nil
    if st then
      tx, ty = st.pos[1], st.pos[2]
      fwd_x, fwd_y = st.fwd[1], st.fwd[2]
    end
    local now = self:clock()
    local min_hold_s = s.min_hold_s or 2.8
    local held = now - (self.auto_cam_since or now)
    local current = nil
    if self.auto_cam_id and held >= 0.0 and held < min_hold_s then
      for _, c in ipairs(cands) do
        if c.id == self.auto_cam_id then current = c break end
      end
      if current and st then
        local cx, cy = current.location[1] - tx, current.location[2] - ty
        local along = fwd_x and (cx * fwd_x + cy * fwd_y) or 0.0
        local dist = math.sqrt(cx * cx + cy * cy)
        -- Early release only when the car is already well past this lens or
        -- the camera is simply too far away to be useful.
        if along < -3500.0 or dist > 18000.0 then current = nil end
      end
      if current then
        local chosen = {}
        for k, v in pairs(current) do chosen[k] = v end
        return self:pose_of(chosen)
      end
    end
    local best, best_score = nil, math.huge
    for _, c in ipairs(cands) do
      local dx, dy = c.location[1] - tx, c.location[2] - ty
      local score = math.sqrt(dx * dx + dy * dy)
      local along = fwd_x and (dx * fwd_x + dy * fwd_y) or 0.0
      if fwd_x and along > 0.0 and along < 14000.0 then
        -- Strong approach bias: open on the car charging toward the lens.
        score = score - 3000.0
      end
      if fwd_x and along < -2000.0 then
        -- Car has passed this camera; hand off to the next approaching one.
        score = score + 4000.0
      end
      if c.id == self.auto_cam_id then score = score - 800.0 end
      if score < best_score then best, best_score = c, score end
    end
    if not best then return nil end
    if best.id ~= self.auto_cam_id then
      -- Cut: snap the new camera straight onto the car at its own telephoto
      -- FOV instead of panning across the sky from the old look vector.
      self.follow_look = nil
      self.smooth_fov = nil
      self.auto_cam_since = now
    end
    self.auto_cam_id = best.id
    local chosen = {}
    for k, v in pairs(best) do chosen[k] = v end
    return self:pose_of(chosen)
  end
  if kind == "orbit" then
    local st = target_state(self, s, preset)
    local c
    if st then
      c = { st.pos[1], st.pos[2], st.pos[3] }
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
    local want_look = { c[1], c[2], c[3] + 100.0 }
    local look = want_look
    if self.follow_look then
      look = vlerp(self.follow_look, want_look,
        exp_alpha(st and st.dt or (1.0 / 60.0), shot_tau(self, s, preset, "tau_look")))
    end
    self.follow_look = look
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
  -- Every shot cut restarts all smoothing from the fresh pose (clear before
  -- pose_of so the activation frame never blends with the previous shot).
  self:reset_smoothing()
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
  if self.target ~= pawn then self:reset_smoothing() end
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

function E.ps_name(self, ps)
  if not ps then return nil end
  local ok, name = pcall(function()
    if ps.IsValid and not ps:IsValid() then return nil end
    if not ps.GetPlayerName then return nil end
    local n = ps:GetPlayerName()
    if type(n) == "string" then return n end
    if n and n.ToString then return n:ToString() end
    return nil
  end)
  if ok and type(name) == "string" and name ~= "" then return name end
  return nil
end

function E.player_states(self)
  local out = {}
  local ok_gs, gs = pcall(function()
    if FindFirstOf then
      local g = FindFirstOf("MotorTownGameState")
      if g and (not g.IsValid or g:IsValid()) then return g end
      g = FindFirstOf("GameStateBase")
      if g and (not g.IsValid or g:IsValid()) then return g end
    end
    return nil
  end)
  if ok_gs and gs then
    local ok_arr, arr = pcall(function() return gs.PlayerArray end)
    if ok_arr and arr then
      if type(arr) == "table" then
        for i = 1, #arr do
          if arr[i] then out[#out + 1] = arr[i] end
        end
      else
        local ok_fe = pcall(function()
          arr:ForEach(function(_, elem)
            local ps = elem and elem.get and elem:get() or elem
            if ps then out[#out + 1] = ps end
          end)
        end)
        if not ok_fe then
          pcall(function()
            local n = #arr
            for i = 1, n do
              if arr[i] then out[#out + 1] = arr[i] end
            end
          end)
        end
      end
    end
  end
  if #out == 0 then
    local ok_all, all = pcall(function() return FindAllOf("MotorTownPlayerState") end)
    if ok_all and type(all) == "table" then
      for i = 1, #all do
        if all[i] then out[#out + 1] = all[i] end
      end
    end
  end
  return out
end

function E.list_targets(self)
  local names, seen = {}, {}
  -- Streamed-in nearby pawns first so they stay at the top of the roster.
  for _, p in ipairs(self:pawns()) do
    local n = self:pawn_name(p)
    if n and not seen[n] then
      seen[n] = true
      names[#names + 1] = n
    end
  end
  -- Full-server roster from GameState.PlayerArray (map-wide, outside UE5's
  -- relevancy bubble).
  local remote = {}
  for _, ps in ipairs(self:player_states()) do
    local n = self:ps_name(ps)
    if n and not seen[n] then
      seen[n] = true
      remote[#remote + 1] = n
    end
  end
  table.sort(remote)
  for _, n in ipairs(remote) do names[#names + 1] = n end
  return names
end

-- Returns (ok, message): true,"target <name>" on success.
function E.set_target_by_name(self, name)
  if not name or name == "" then return false, "no name given" end
  local found = self:pawns()
  for i, p in ipairs(found) do
    if self:pawn_name(p) == name then
      if self.target_name ~= name then self:reset_smoothing() end
      self.target = p
      self.target_ps = nil
      self.target_name = name
      self.target_index = i
      self.target_lost = false
      self.target_lost_since = nil
      self:log("TARGET name=" .. name .. " idx=" .. tostring(i))
      return true, "target " .. name
    end
  end
  -- Fallback: driver is on the server (GameState.PlayerArray) but currently
  -- outside UE5's network relevancy bubble. Track PlayerState.Location until
  -- their MTPlayerCharacter_C streams in.
  for _, ps in ipairs(self:player_states()) do
    if self:ps_name(ps) == name then
      if self.target_name ~= name then self:reset_smoothing() end
      self.target = nil
      self.target_ps = ps
      self.target_name = name
      self.target_index = nil
      self.target_lost = false
      self.target_lost_since = nil
      self:log("TARGET name=" .. name .. " (remote PlayerState)")
      return true, "target " .. name
    end
  end
  if #found == 0 then return false, "no pawns" end
  return false, "no pawn named " .. tostring(name)
end

function E.set_target_by_index(self, i)
  local ok, pawns = pcall(function() return FindAllOf("MTPlayerCharacter_C") end)
  if not ok or not pawns or not pawns[i] then return "no pawn " .. tostring(i) end
  if self.target ~= pawns[i] then self:reset_smoothing() end
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
