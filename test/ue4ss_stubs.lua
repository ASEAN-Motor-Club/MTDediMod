--- UE4SS global stubs for running Lua tests outside the game runtime.
--- Load this before any production modules: require("test.ue4ss_stubs")
---
--- This file must be loaded via busted's --helper flag so that all UE4SS
--- globals are defined before any production module is require()'d.

-- ============================================================
-- Invalid object stub (mimics UE4SS CreateInvalidObject)
-- ============================================================
local InvalidObject = {}
InvalidObject.__index = InvalidObject
function InvalidObject:IsValid() return false end
function InvalidObject:IsA() return false end
function InvalidObject:GetFullName() return "InvalidObject" end

function CreateInvalidObject()
  return setmetatable({}, InvalidObject)
end

-- ============================================================
-- ValidObject stub (for things that should pass IsValid checks)
-- ============================================================
local function createValidObject(overrides)
  local obj = setmetatable(overrides or {}, {
    __index = function(_, k)
      -- Return a callable that returns a valid object for chained calls
      return function() return createValidObject() end
    end
  })
  obj.IsValid = function() return true end
  obj.IsA = function() return true end
  return obj
end

-- ============================================================
-- UEHelpers stub
-- ============================================================
local UEHelpers = {}
function UEHelpers.GetGameInstance() return CreateInvalidObject() end
function UEHelpers.GetPlayerController() return CreateInvalidObject() end
function UEHelpers:GetGameStateBase() return CreateInvalidObject() end
function UEHelpers.GetKismetSystemLibrary() return createValidObject() end
function UEHelpers.GetKismetMathLibrary() return createValidObject() end

-- Pre-register UEHelpers in package.loaded so require("UEHelpers") works
package.loaded["UEHelpers"] = UEHelpers

-- ============================================================
-- StaticFindObject stub
-- ============================================================
function StaticFindObject(path)
  return CreateInvalidObject()
end

-- ============================================================
-- Key binding / console command stubs (no-ops)
-- ============================================================
Key = setmetatable({}, { __index = function(_, k) return k end })
ModifierKey = setmetatable({}, { __index = function(_, k) return k end })

function RegisterKeyBind(...) end
function RegisterConsoleCommandHandler(...) end

-- ============================================================
-- Game thread execution (immediate in test env)
-- ============================================================
function ExecuteInGameThread(fn)
  fn()
end

function ExecuteInGameThreadSync(exec, label, maxMs)
  exec()
  return true
end

function ExecuteInGameThreadSync2(exec, label, maxMs)
  exec()
  return true
end

-- ============================================================
-- FName stub
-- ============================================================
function FName(s) return s end

-- ============================================================
-- UnrealVersion stub
-- ============================================================
UnrealVersion = {
  IsBelow = function(self, major, minor)
    return false
  end
}

-- ============================================================
-- Logging stubs
-- ============================================================
function LogMsg(...) end
function LogOutput(level, fmt, ...)
  -- Uncomment for debug visibility:
  -- print(string.format("[%s] " .. fmt, level, ...))
end

-- ============================================================
-- ============================================================
-- LuaSocket stub (Helpers.lua requires socket for Sleep/ExecuteInGameThreadSync)
-- ============================================================
package.loaded["socket"] = {
  sleep = function(secs) end,
  gettime = function() return os.clock() end,
}

-- RequireSafe (copied from Helpers.lua to be available before Helpers loads)
-- ============================================================
function RequireSafe(moduleName)
  local hasModule, mod = pcall(require, moduleName)
  if hasModule then
    return mod
  end
  return nil
end

-- ============================================================
-- Other stubs
-- ============================================================
function GenerateLuaTypes() end
function RestartCurrentMod() end

-- ExportStructAsText stub
function ExportStructAsText(...) return "" end
