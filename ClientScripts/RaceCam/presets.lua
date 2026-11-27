-- presets.lua — named camera presets for AMC RaceCam.
-- All distances are UE centimetres; fov is degrees; duration is seconds.
local P = {}

P.types = { fixed = true, look_at = true, follow = true, orbit = true, flyover = true }
P.easings = { linear = true, ease_in_out_cubic = true, arc_length_spline = true }

P.presets = {
  chase_close = {
    id = "chase_close",
    label = "Chase close (verified)",
    type = "follow",
    offset = { back = 900.0, up = 350.0 },
    look_offset = { ahead = 600.0, up = 150.0 },
    fov = 70.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.12, heading_alpha = 0.10, use_route_tangent = false },
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
    flags = { pin_view_target = true, smoothing_alpha = 1.0, step_cm = 50.0, use_route_tangent = true },
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
    flags = { pin_view_target = true, smoothing_alpha = 0.20, use_route_tangent = true },
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
    flags = { pin_view_target = true, smoothing_alpha = 0.15, use_route_tangent = false },
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
    flags = { pin_view_target = true, smoothing_alpha = 0.18, use_route_tangent = true },
  },
  chase_wide = {
    id = "chase_wide",
    label = "Wide chase",
    type = "follow",
    offset = { fwd = -1400.0, right = 0.0, up = 550.0 },
    look_offset = { look_ahead = 600.0, up = 150.0 },
    fov = 75.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.10, use_route_tangent = false },
  },
  heli_follow = {
    id = "heli_follow",
    label = "Heli / drone follow",
    type = "follow",
    offset = { fwd = -1800.0, right = 1400.0, up = 3200.0 },
    look_offset = { look_ahead = 600.0, up = 150.0 },
    fov = 55.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.05, use_route_tangent = false },
  },
  front_chase = {
    id = "front_chase",
    label = "Front / reverse battle cam",
    type = "follow",
    offset = { fwd = 850.0, right = 180.0, up = 220.0 },
    look_offset = { look_ahead = -300.0, up = 150.0 },
    fov = 65.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.14, use_route_tangent = false },
  },
  side_tracking = {
    id = "side_tracking",
    label = "Low side tracking",
    type = "follow",
    offset = { fwd = -150.0, right = 650.0, up = 160.0 },
    look_offset = { look_ahead = 250.0, up = 150.0 },
    fov = 68.0,
    duration = 0.0,
    easing = "linear",
    flags = { pin_view_target = true, smoothing_alpha = 0.14, use_route_tangent = false },
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
    flags = { pin_view_target = true, smoothing_alpha = 1.0, use_route_tangent = false },
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
  end
  return errors
end

return P
