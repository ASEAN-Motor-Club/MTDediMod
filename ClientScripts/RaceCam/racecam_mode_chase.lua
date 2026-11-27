-- chase mode: verified numbers from follow_driver.lua
-- Resolve the RaceCam data directory without hardcoding a drive letter:
-- the RACECAM_DIR environment variable wins; otherwise candidate relative
-- paths are probed by attempting to create a marker file (io.open append).
local function racecam_dir() return require("RaceCam/path").data_dir() end

local M = { name = "chase_close", log_every = 30 }
local G = {}
_G.RACECAM_FOLLOW = G
G.idx = 1

local function norm2(x, y)
  local m = math.sqrt(x * x + y * y)
  if m < 0.001 then return nil end
  return x / m, y / m
end
local function aim(pos, look)
  local dx = look[1] - pos[1]; local dy = look[2] - pos[2]; local dz = look[3] - pos[3]
  return {
    Pitch = math.deg(math.atan(dz, math.sqrt(dx * dx + dy * dy))),
    Yaw = math.deg(math.atan(dy, dx)), Roll = 0.0,
  }
end
local function lerp(a, b, t) return a + (b - a) * t end

function G.retarget(i)
  local a = FindAllOf("MTPlayerCharacter_C") or {}
  if not a[i] then return "NO_Pawn_" .. tostring(i) end
  G.idx = i; G.target = a[i]; G.pos = nil; G.last = nil; G.fwd = nil
  local ok, l = pcall(function() return a[i]:K2_GetActorLocation() end)
  return "idx=" .. i .. " at=" .. (ok and string.format("%.0f,%.0f,%.0f", l.X, l.Y, l.Z) or "ERR")
end

M.init = function(Core)
  G.pawns = FindAllOf("MTPlayerCharacter_C") or {}
  if #G.pawns < 1 then error("no contestant pawns") end
  G.target = G.pawns[1]
  G.last = nil; G.pos = nil; G.fwd = nil
  Core.retarget = G.retarget
end

M.apply = function(Core)
  local p = G.target or G.pawns[1]
  local ok, loc = pcall(function() return p:K2_GetActorLocation() end)
  if not ok then error("target location") end
  local tx, ty, tz = loc.X, loc.Y, loc.Z
  if not G.last then G.last = { tx, ty, tz } end
  local dx, dy = tx - G.last[1], ty - G.last[2]
  local fx, fy = norm2(dx, dy)
  if fx then
    if not G.fwd then G.fwd = { fx, fy }
    else G.fwd = { lerp(G.fwd[1], fx, 0.10), lerp(G.fwd[2], fy, 0.10) } end
    local nx, ny = norm2(G.fwd[1], G.fwd[2]); if nx then G.fwd = { nx, ny } end
  end
  if not G.fwd then
    local okr, rot = pcall(function() return p:K2_GetActorRotation() end)
    local yaw = okr and math.rad(rot.Yaw) or 0.0
    G.fwd = { math.cos(yaw), math.sin(yaw) }
  end
  G.last = { tx, ty, tz }
  fx, fy = G.fwd[1], G.fwd[2]
  local want = { tx - fx * 900.0, ty - fy * 900.0, tz + 350.0 }
  if not G.pos then G.pos = want
  else G.pos = { lerp(G.pos[1], want[1], 0.12), lerp(G.pos[2], want[2], 0.12), lerp(G.pos[3], want[3], 0.12) } end
  local look = { tx + fx * 600.0, ty + fy * 600.0, tz + 150.0 }
  Core.apply_pose(G.pos, aim(G.pos, look), 70.0)
end

M.log = function(Core)
  if _G.RACECAM_LOG ~= 1 then return end
  local f = io.open(racecam_dir() .. "follow_core.txt", "a")
  if f then
    local p = G.pos or { 0, 0, 0 }
    f:write(string.format("F f=%d idx=%d t=%.0f,%.0f,%.0f cam=%.0f,%.0f,%.0f fwd=%.2f,%.2f\n",
      Core.n, G.idx, G.last[1], G.last[2], G.last[3], p[1], p[2], p[3], G.fwd[1], G.fwd[2]))
    f:close()
  end
end

return Core.start(M)
