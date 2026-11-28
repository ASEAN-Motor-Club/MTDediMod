-- presets.lua — named camera presets for AMC RaceCam.
-- All distances are UE centimetres; fov is degrees; duration is seconds.
-- flag tau_* values are smoothing time constants in seconds (dt-invariant).
-- `smoothing_alpha` is retained for backwards compatibility with older plans.
local P = {}

P.types = { fixed = true, look_at = true, follow = true, orbit = true, flyover = true, pack_battle = true }
P.easings = { linear = true, ease_in_out_cubic = true, arc_length_spline = true }

P.presets = {
  chase_close = {
    id = "chase_close",
    label = "Chase close (verified)",
    type = "follow",
    offset = { back = 1100.0, up = 340.0 },
    look_offset = { ahead = 250.0, up = 130.0 },
    fov = 72.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.12, heading_alpha = 0.10, use_route_tangent = false,
              tau_pos = 0.12, tau_look = 0.10, tau_hdg = 0.18, tau_fov = 0.25 },
  },
  route_flyover = {
    id = "route_flyover",
    label = "Route flyover (verified)",
    type = "flyover",
    offset = { up = 350.0 },
    look_offset = { ahead = 2500.0 },
    fov = 76.0,
    duration = 0.0,
    easing = "arc_length_spline",
    flags = { pin_view_target = true, smoothing_alpha = 1.0, step_cm = 50.0, use_route_tangent = true,
              tau_pos = 0.16, tau_look = 0.20, tau_hdg = 0.20, tau_fov = 0.25 },
  },
  trackside_low = {
    id = "trackside_low",
    label = "Trackside low",
    type = "look_at",
    offset = { normal = 800.0, up = 150.0 },
    look_offset = { along = 400.0, up = 100.0 },
    fov = 55.0,
    duration = 4.0,
    easing = "ease_in_out_cubic",
    flags = { pin_view_target = true, smoothing_alpha = 0.20, use_route_tangent = true,
              tau_pos = 0.14, tau_look = 0.10, tau_hdg = 0.18, tau_fov = 0.25 },
  },
  overview_high = {
    id = "overview_high",
    label = "High overview",
    type = "fixed",
    offset = { up = 3000.0 },
    look_offset = { pitch = -70.0 },
    fov = 90.0,
    duration = 5.0,
    easing = "ease_in_out_cubic",
    flags = { pin_view_target = true, smoothing_alpha = 0.15, use_route_tangent = false,
              tau_pos = 0.18, tau_look = 0.20, tau_hdg = 0.20, tau_fov = 0.25 },
  },
  finish_line = {
    id = "finish_line",
    label = "Finish line",
    type = "look_at",
    offset = { back = 400.0, normal = 500.0 },
    look_offset = { at = "waypoint_0" },
    fov = 65.0,
    duration = 6.0,
    easing = "ease_in_out_cubic",
    flags = { pin_view_target = true, smoothing_alpha = 0.18, use_route_tangent = true,
              tau_pos = 0.14, tau_look = 0.12, tau_hdg = 0.20, tau_fov = 0.25 },
  },
  chase_wide = {
    id = "chase_wide",
    label = "Wide chase",
    type = "follow",
    offset = { fwd = -1650.0, right = 0.0, up = 520.0 },
    look_offset = { look_ahead = 320.0, up = 130.0 },
    fov = 74.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.10, use_route_tangent = false,
              tau_pos = 0.18, tau_look = 0.14, tau_hdg = 0.20, tau_fov = 0.25 },
  },
  heli_follow = {
    id = "heli_follow",
    label = "Heli / drone follow",
    type = "follow",
    offset = { fwd = -1800.0, right = 1200.0, up = 2600.0 },
    look_offset = { look_ahead = 300.0, up = 120.0 },
    fov = 56.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.05, use_route_tangent = false,
              tau_pos = 0.35, tau_look = 0.22, tau_hdg = 1.10, tau_fov = 0.25 },
  },
  front_chase = {
    id = "front_chase",
    label = "Front / reverse battle cam",
    type = "follow",
    offset = { fwd = 1150.0, right = 160.0, up = 230.0 },
    look_offset = { look_ahead = -100.0, up = 120.0 },
    fov = 66.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.14, use_route_tangent = false,
              tau_pos = 0.14, tau_look = 0.12, tau_hdg = 0.20, tau_fov = 0.25 },
  },
  side_tracking = {
    id = "side_tracking",
    label = "Low side tracking",
    type = "follow",
    offset = { fwd = 50.0, right = 950.0, up = 180.0 },
    look_offset = { look_ahead = 120.0, up = 110.0 },
    fov = 68.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.14, use_route_tangent = false,
              tau_pos = 0.14, tau_look = 0.12, tau_hdg = 0.18, tau_fov = 0.25 },
  },
  onboard_tcam = {
    id = "onboard_tcam",
    label = "Onboard T-cam",
    type = "follow",
    offset = { fwd = -35.0, right = 0.0, up = 185.0 },
    look_offset = { look_ahead = 1200.0, up = 120.0 },
    fov = 78.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.55, use_route_tangent = false,
              tau_pos = 0.04, tau_look = 0.04, tau_hdg = 0.06, tau_fov = 0.20 },
  },
  rear_battle = {
    id = "rear_battle",
    label = "Rear battle cam",
    type = "follow",
    offset = { fwd = -260.0, right = 0.0, up = 125.0 },
    look_offset = { look_ahead = -1200.0, up = 105.0 },
    fov = 68.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.35, use_route_tangent = false,
              tau_pos = 0.08, tau_look = 0.08, tau_hdg = 0.12, tau_fov = 0.20 },
  },
  pack_battle = {
    id = "pack_battle",
    label = "Pack battle (two-car)",
    type = "pack_battle",
    offset = { fwd = -1200.0, right = 180.0, up = 420.0 },
    look_offset = { look_ahead = 260.0, up = 110.0 },
    fov = 68.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.20, use_route_tangent = false,
              tau_pos = 0.18, tau_look = 0.14, tau_hdg = 0.24, tau_fov = 0.25 },
  },
  orbit_hero = {
    id = "orbit_hero",
    label = "Hero orbit",
    type = "orbit",
    offset = { radius_cm = 1200.0, height_cm = 450.0, deg_per_s = 18.0 },
    look_offset = { look_ahead = 0.0, up = 100.0 },
    fov = 60.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 1.0, use_route_tangent = false,
              tau_pos = 0.20, tau_look = 0.12, tau_hdg = 0.20, tau_fov = 0.25 },
  },
}

function P.get(id)
  return P.presets[id]
end

function P.validate()
  local errors = {}
  for id, p in pairs(P.presets) do
    if p.id ~= id then errors[#errors + 1] = id .. ": id mismatch" end
    if not p.label or p.label == "" then errors[#errors + 1] = id .. ": missing label" end
    if not P.types[p.type] then errors[#errors + 1] = id .. ": bad type " .. tostring(p.type) end
    if not p.offset or type(p.offset) ~= "table" then errors[#errors + 1] = id .. ": missing offset" end
    if not p.look_offset or type(p.look_offset) ~= "table" then errors[#errors + 1] = id .. ": missing look_offset" end
    if type(p.fov) ~= "number" or p.fov < 10.0 or p.fov > 150.0 then errors[#errors + 1] = id .. ": bad fov" end
    if type(p.duration) ~= "number" or p.duration < 0.0 then errors[#errors + 1] = id .. ": bad duration" end
    if not P.easings[p.easing] then errors[#errors + 1] = id .. ": bad easing" end
    local f = p.flags or {}
    if type(f.pin_view_target) ~= "boolean" then errors[#errors + 1] = id .. ": bad pin_view_target" end
    if type(f.smoothing_alpha) ~= "number" or f.smoothing_alpha < 0.0 or f.smoothing_alpha > 1.0 then
      errors[#errors + 1] = id .. ": bad smoothing_alpha"
    end
    if type(f.use_route_tangent) ~= "boolean" then errors[#errors + 1] = id .. ": bad use_route_tangent" end
    for _, key in ipairs({ "tau_pos", "tau_look", "tau_hdg", "tau_fov" }) do
      local v = f[key]
      if type(v) ~= "number" or v < 0.0 or v ~= v then
        errors[#errors + 1] = id .. ": bad " .. key
      end
    end
  end
  return errors
end

return P
