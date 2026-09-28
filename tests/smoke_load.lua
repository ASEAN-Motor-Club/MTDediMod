---Smoke-load test for MTDediMod server Scripts.
---Loads every Scripts/*.lua in real Lua 5.4 with a stubbed UE4SS env, then
---invokes every RegisterHook'ed callback with stub args inside pcall.
---FAILS on 'attempt to call a nil value' errors — the exact PR #31 bug class
---(RPManager called noTeleportManager.GetNoTeleportMode, which was never
---exported; luac -p passed both files, the error only fired in-game).
---
---Run: lua tests/smoke_load.lua [Scripts-dir]
---Exit 0 = all scripts loaded + all hook callbacks probed clean; 1 = failure.

local scripts_dir = arg[1] or "Scripts"

-- Collect Scripts/*.lua without a filesystem dependency
local files = {}
do
  local f = io.popen(("ls %q"):format(scripts_dir), "r")
  if not f then error("cannot list " .. scripts_dir) end
  for line in f:lines() do
    if line:sub(-4) == ".lua" then files[#files + 1] = line end
  end
  f:close()
  table.sort(files)
end
assert(#files > 0, "no .lua files found in " .. scripts_dir)

local known = {}
for _, fname in ipairs(files) do known[fname:sub(1, -5)] = true end

-- Stub UE4SS environment ------------------------------------------------------------

local log_buf = {}
local function fake_log(...)
  local parts = {}
  for i = 1, select("#", ...) do parts[i] = tostring((select(i, ...))) end
  log_buf[#log_buf + 1] = table.concat(parts, " ")
end

local registered_hooks = {}  -- { {path=..., fn=...} }
local register_calls = 0

local stub = {
  LogOutput = fake_log,
  LogOutputWithStack = fake_log,
  -- hook registration: RECORD the callbacks so we can invoke them later
  RegisterHook = function(path, fn)
    register_calls = register_calls + 1
    registered_hooks[#registered_hooks + 1] = { path = path, fn = fn }
    return true
  end,
  Unhook = function() return true end,
  -- world/actor lookups return nil (no game objects in the stub); call sites
  -- are expected to handle nil (they check IsValid at runtime)
  FindAllOf = function() return {} end,
  FindFirstOf = function() return nil end,
  StaticFindObject = function() return nil end,
  StaticFindObjectNoFallback = function() return nil end,
  StaticConstructObject = function() return nil end,
  GetStaticStruct = function() return nil end,
  GetStaticEnum = function() return nil end,
  IsValid = function() return true end,
  GuidToString = function() return "11111111222233334444555566667777" end,
  StringToGuid = function() return {} end,
  -- delayed-action APIs: run game-thread callbacks IMMEDIATELY in the stub
  -- (sync semantics) so patterns like ExecuteInGameThreadSync's
  -- "while isProcessing do Sleep(1) end" terminate; delayed variants are
  -- recorded but never run (they capture real game objects that don't exist)
  ExecuteInGameThread = function(fn) if fn then local ok, err = pcall(fn) if not ok then fake_log("ExecuteInGameThread stub error: " .. tostring(err)) end end end,
  ExecuteInGameThreadWithDelay = function(fn) if fn then pcall(fn) end end,
  Sleep = function() end,
  LoopInGameThreadWithDelay = function() end, -- recorded, never run
   -- background-thread APIs (scripts must not use them; harmless stubs here)
  ExecuteWithDelay = function() end,
  LoopAsync = function() end,
  -- scripting helpers
  FText = function(text) return text end,
}

local _G_mt = {
  -- Unknown globals become "anything" stubs: callable AND indexable, so
  -- patterns like Key.PAGE_UP (enum global) and GetKismetSystemLibrary()
  -- both work. Anything hit this way is recorded for stub coverage review.
  __index = function(t, k)
    if type(k) == "string" then
      local anything
      anything = setmetatable({}, {
        -- integer keys MUST return nil: ipairs() in Lua 5.4 walks __index
        -- until nil, and a never-ending __index hangs load-time loops like
        -- Webclient's `for _, v in ipairs(webhookEvents)` (found 2026-09-28)
        __index = function(_, k2) if type(k2) == "number" then return nil end return anything end,
        __len = function() return 0 end,
        __call = function() return anything end,
        __tostring = function() return "<anything-stub:" .. k .. ">" end,
      })
      stub[k] = anything
      return anything
    end
    return nil
  end,
}

local loaded, modules, loading = {}, {}, {}
local stubbed_requires = {}
local nil_returns = {}
local shared_dir = arg[2] or "shared"

-- NOTE: declare first, assign after — the require closure references
-- script_env, and a local's scope only begins after its initializer, so
-- combining them would capture a nil global instead (real bug class, fittingly).
local script_env
script_env = setmetatable({
  require = function(modname)
    if modules[modname] then return modules[modname] end
    assert(not loading[modname], "require(" .. modname .. "): circular require")
    -- search Scripts/ first, then shared/ (VehicleSerialization, ...)
    local file = scripts_dir .. "/" .. modname .. ".lua"
    local fh = io.open(file, "r")
    if not fh then
      file = shared_dir .. "/" .. modname .. ".lua"
      fh = io.open(file, "r")
    end
    if not fh then
      -- External package-time dependency (UEHelpers, socket, mime, cjson...):
      -- these ship as prebuilt Lua/C binaries copied into shared/ only at
      -- package time. Auto-stub with a permissive proxy and RECORD it; field
      -- accesses on the proxy are no-ops. Listed in the report for review.
      stubbed_requires[#stubbed_requires + 1] = modname
      local anything_ext
      anything_ext = setmetatable({}, {
        __index = function() return function() return anything_ext end end,
        __call = function() return anything_ext end,
      })
      modules[modname] = anything_ext
      return anything_ext
    end
    fh:close()
    loading[modname] = true
    local chunk, err = loadfile(file, "t", script_env)
    assert(chunk, "require(" .. modname .. "): cannot load: " .. tostring(err))
    -- watchdog: 50M VM instructions per module load; a top-level loop that
    -- never terminates (stub world never changes) fails fast instead of
    -- hanging CI forever
    local checks, max_checks, every = 0, 500, 100000  -- 500 * 100k = 50M
    debug.sethook(function()
      checks = checks + 1
      if checks > max_checks then
        error(("SMOKE-WATCHDOG: %s exceeded %.0fM VM instructions (runaway load-time loop?)")
          :format(modname, max_checks * every / 1e6))
      end
    end, "", every)
    local ok, result = pcall(chunk)
    debug.sethook()
    loading[modname] = nil
    assert(ok, "require(" .. modname .. "): " .. tostring(result))
    -- modules may return a table OR a callable (ModConfig returns a function).
    -- nil return is legal (standard require caches `true`) but suspicious when
    -- another module requires it — record as WARN, don't fail the load.
    if result == nil then
      nil_returns[#nil_returns + 1] = modname
      modules[modname] = true
      return true
    end
    assert(type(result) == "table" or type(result) == "function",
      "require(" .. modname .. "): module must return a table or function (got " .. type(result) .. ")")
    modules[modname] = result
    return result
  end,
  package = package,
  print = print, tostring = tostring, tonumber = tonumber, type = type,
  pairs = pairs, ipairs = ipairs, next = next, select = select,
  pcall = pcall, xpcall = xpcall, error = error, assert = assert,
  setmetatable = setmetatable, getmetatable = getmetatable, rawget = rawget,
  table = table, string = string, math = math, os = os, io = io,
}, _G_mt)

script_env._G = script_env
-- Merge the explicit stub entries into the env. Without this, RegisterHook /
-- LogOutput etc. resolve through _G_mt.__index to "anything" stubs: loads
-- succeed but hooks are never recorded and the probe section is empty.
for k, v in pairs(stub) do script_env[k] = v end

-- main -------------------------------------------------------------------------------

local failures, failures_load, failures_probe = 0, 0, 0
-- arg[3] = comma-separated module filter (bisect hangs); prints each load
local only = {}
if arg[3] then
  for name in arg[3]:gmatch("[^,]+") do only[name] = true end
end
print("== loading " .. #files .. " scripts from " .. scripts_dir)

for _, fname in ipairs(files) do
  local modname = fname:sub(1, -5)
  if next(only) and not only[modname] then
    print(("  skip %s"):format(modname))
  else
    io.write(("  load %-20s ... "):format(modname)); io.stdout:flush()
    local ok, err = pcall(function() return script_env.require(modname) end)
    if ok then
      print("OK")
    else
      failures = failures + 1
      failures_load = failures_load + 1
      print(("FAIL %s"):format(tostring(err)))
    end
  end
end

-- Probe every registered hook callback. Args are permissive stub objects
-- with :get() (hook params are wrapped references in UE4SS) that always
-- "return" a valid actor, so callbacks run as deep as possible with stub
-- game state. pcall swallows the call; we FAIL only on 'attempt to call a
-- nil value' — a missing module field — which is the bug class this test
-- exists for (PR #31). Other errors (nil indexing on stub-shaped data) are
-- expected and reported as INFO.
print("== probing " .. #registered_hooks .. " registered hooks")

-- hook-param stub: any field is another stub, :get() returns itself,
-- IsValid() returns true, and __len is 0 so ipairs over it terminates
local hook_param_stub
hook_param_stub = setmetatable({}, {
  __index = function(_, k2)
    if type(k2) == "number" then return nil end
    if k2 == "get" then return function() return hook_param_stub end end
    if k2 == "IsValid" then return function() return true end end
    return hook_param_stub
  end,
  __len = function() return 0 end,
  __call = function() return hook_param_stub end,
  __tostring = function() return "<hook-param-stub>" end,
})

for _, h in ipairs(registered_hooks) do
  local ok, err = pcall(h.fn, hook_param_stub, hook_param_stub, hook_param_stub,
    hook_param_stub, hook_param_stub, hook_param_stub, hook_param_stub)
  if not ok then
    local msg = tostring(err)
    if msg:match("attempt to call a nil value") then
      failures = failures + 1
      failures_probe = failures_probe + 1
      print(("  FAIL %s: %s"):format(h.path, msg))
    else
      print(("  info %s: (stub-arg error, ok) %s"):format(h.path, (msg:gsub("\n", " ")):sub(1, 110)))
    end
  else
    print(("  ok   %s"):format(h.path))
  end
end

print(("== stubbed external requires: %s")
  :format(#stubbed_requires > 0 and table.concat(stubbed_requires, ", ") or "(none)"))
if #nil_returns > 0 then
  print(("== WARN modules returning nil (no `return` statement): %s")
    :format(table.concat(nil_returns, ", ")))
end
print(("== summary: %d scripts, %d hooks probed, %d failures (%d load, %d missing-field) — RegisterHook called %d times")
  :format(#files, #registered_hooks, failures, failures_load, failures_probe, register_calls))

if failures > 0 then os.exit(1) end
