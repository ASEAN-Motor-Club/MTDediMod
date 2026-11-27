-- racecam_core.lua — canonical verified CameraActor seam.
-- Mode modules provide init(core), apply(core), optional log(core).
local Core = { rehearsal = false }
Core.VERSION = "0.7.20-mod-v14"
_G.RACECAM_CORE = Core

-- Resolve the RaceCam data directory without hardcoding a drive letter:
-- the RACECAM_DIR environment variable wins; otherwise candidate relative
-- paths are probed by attempting to create a marker file (io.open append).
local function racecam_dir() return require("RaceCam/path").data_dir() end

local function log(s)
  if _G.RACECAM_LOG == 1 then
    local f = io.open(racecam_dir() .. "core.txt", "a")
    if f then f:write(tostring(s) .. "\n") f:close() end
  end
end

local function safe(fn, tag)
  local ok, err = pcall(fn)
  if not ok then log("ERR " .. tostring(tag) .. " " .. tostring(err)) end
  return ok
end

function Core.acquire()
  local pcs = FindAllOf("PlayerController") or {}
  if #pcs < 1 then return "NOPC" end
  local cams = FindAllOf("CameraActor") or {}
  if #cams < 1 then return "NOCAM" end
  Core.pc = pcs[1]
  Core.cam = cams[1]
  Core.pawn = Core.pc:K2_GetPawn()
  if not Core.pawn then return "NOPAWN" end
  return nil
end

function Core.apply_pose(pos, rot, fov)
  if Core.rehearsal then return end
  local cam, pc = Core.cam, Core.pc
  safe(function() cam:K2_SetActorLocation({ X = pos[1], Y = pos[2], Z = pos[3] }, false, {}, false) end, "loc")
  safe(function() cam:K2_SetActorRotation(rot, false) end, "rot")
  safe(function() pc:SetViewTargetWithBlend(cam, 0, 0, 0, false) end, "view")
  local cc = cam.CameraComponent
  if cc and fov then safe(function() cc:SetFieldOfView(fov) end, "fov") end
end

function Core.stop()
  Core.running = false
  Core.gen = (Core.gen or 0) + 1
  if Core.pc and Core.pawn then
    safe(function() Core.pc:SetViewTargetWithBlend(Core.pawn, 0, 0, 0, false) end, "restore")
  end
  Core.mode = nil
  log("stopped frame=" .. tostring(Core.n or 0))
end

function Core.stop_all()
  for _, c in ipairs(_G.RACECAM_CORES or {}) do
    if c.running and type(c.stop) == "function" then c.stop() end
  end
  _G.RACECAM_CORES = {}
end

function Core.start(mode, resume)
  _G.RACECAM_CORES = _G.RACECAM_CORES or {}
  _G.RACECAM_CORES[#_G.RACECAM_CORES + 1] = Core
  local err = Core.acquire()
  if err then log("acquire " .. err) return err end
  Core.gen = (Core.gen or 0) + 1
  local gen = Core.gen
  Core.mode, Core.last_mode = mode, mode
  Core.n = 0
  Core.running = true
  if not Core.rehearsal then
    safe(function() Core.pc:SetViewTargetWithBlend(Core.cam, 0, 0, 0, false) end, "pin")
  end
  if not resume then
    if mode.init then safe(function() mode.init(Core) end, "init") end
    local ok = safe(function() mode.apply(Core) end, "apply")
    if not ok then Core.stop() return "APPLYERR" end
  end
  log("start " .. tostring(os.date()) .. " resume=" .. tostring(resume and true or false) .. " mode=" .. tostring(mode.name))
  LoopInGameThreadAfterFrames(1, function()
    if not Core.running or Core.gen ~= gen then return true end
    Core.n = Core.n + 1
    local aok, aerr = pcall(function() mode.apply(Core) end)
    if not aok then
      log("ERR tick " .. tostring(aerr))
      Core.stop()
      return true
    end
    if mode.log and (Core.n % (mode.log_every or 5)) == 0 then
      safe(function() mode.log(Core) end, "log")
    end
    return true
  end)
  return mode.name or "ok"
end

function Core.register(mode)
  Core.mode, Core.last_mode = mode, mode
  return mode.name or "registered"
end

function Core.restart()
  if Core.running then return "already running" end
  if not Core.last_mode then return "NOMODE" end
  return Core.start(Core.last_mode, true)
end

return Core
