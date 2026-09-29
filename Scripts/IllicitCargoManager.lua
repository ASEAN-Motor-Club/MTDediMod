---IllicitCargoManager.lua
---Force-unstrap illicit cargo on ServerStrapCargo (freeman 2026-09-29).
---
---Mechanism: UE4SS hooks cannot cancel a server RPC, so the strap is allowed
---to land and the POST-callback immediately calls ServerUnstrapCargo on the
---same PC. Two-callback RegisterHook form (same pattern as Webclient.lua).
---Registration uses a SafeRegisterHook wrapper (a bad top-level hook aborts
---the whole Lua chunk and bricks the mod API).
---
---The blocked key set lives in CargoBlockManager.lua (backend-pushed, list
---POST). Net_Strap is NOT consulted: enforcement is purely hook-driven on
---new strap attempts.

local cargoBlockManager = require("CargoBlockManager")

---RegisterHook THROWS on an unregistrable UFunction — fail soft instead of
---killing the module chunk (same wrapper as RPManager.lua).
local function SafeRegisterHook(path, preFn, postFn)
  local ok, err = pcall(RegisterHook, path, preFn, postFn)
  if not ok then
    LogOutput("WARNING", "[IllicitCargo] RegisterHook FAILED for %s: %s", tostring(path), tostring(err))
  end
  return ok
end

---Best-effort display name for log attribution (same shape as RPManager).
local function GetPlayerName(playerController)
  if not playerController or not playerController:IsValid() then return "?" end
  local PS = playerController.PlayerState
  if not PS or not PS:IsValid() then return "?" end
  local ok, name = pcall(function()
    local n = PS:GetPlayerName()
    if type(n) == "userdata" then return n:ToString() end
    return tostring(n)
  end)
  if not ok or not name or name == "" then return "?" end
  return name
end

---Resolve a cargo actor's Net_CargoKey safely.
---@param cargo AMTCargo
---@return string|nil
local function GetCargoKey(cargo)
  if not cargo or not cargo:IsValid() then return nil end
  local ok, key = pcall(function()
    local k = cargo.Net_CargoKey
    if k == nil then return nil end
    return k:ToString()
  end)
  if not ok then return nil end
  if type(key) == "userdata" then
    local ok2, s = pcall(function() return key:ToString() end)
    if ok2 then key = s else key = nil end
  end
  return key
end

---Pre-hook marks illicit straps in this per-call pending table (keyed on the
---cargo's full instance name) so the post-hook knows which call to act on.
local pendingStraps = {}

local hookStatus = "not_registered"

hookStatus = SafeRegisterHook(
  "/Script/MotorTown.MotorTownPlayerController:ServerStrapCargo",
  function(PC, Cargo)
    local ok, err = pcall(function()
      local playerController = PC:get()
      local cargo = Cargo:get()
      if not playerController or not playerController:IsValid() then return end
      if not cargo or not cargo:IsValid() then return end

      local key = GetCargoKey(cargo)
      if not key then return end

      cargoBlockManager.RecordStrapAttempt()

      if not cargoBlockManager.IsBlockedKey(key) then return end

      local cargoName = cargo:GetFullName()
      pendingStraps[cargoName] = key
      LogOutput("INFO", "[IllicitCargo] Strap attempt on blocked cargo %s by %s — unstrapping",
        key, GetPlayerName(playerController))
    end)
    if not ok then
      LogOutput("ERROR", "[IllicitCargo] Pre-hook error: %s", tostring(err))
    end
  end,
  function(PC, Cargo)
    local ok, err = pcall(function()
      local playerController = PC:get()
      local cargo = Cargo:get()
      if not cargo or not cargo:IsValid() then
        pendingStraps = {}
        return
      end
      local cargoName = cargo:GetFullName()
      local key = pendingStraps[cargoName]
      pendingStraps[cargoName] = nil
      if not key then return end

      if not playerController or not playerController:IsValid() then return end

      local unstrapOk, unstrapErr = pcall(function()
        playerController:ServerUnstrapCargo(cargo)
      end)
      if unstrapOk then
        cargoBlockManager.RecordStrapBlocked()
        LogOutput("INFO", "[IllicitCargo] Unstrapped blocked cargo %s for %s",
          key, GetPlayerName(playerController))
      else
        cargoBlockManager.RecordUnstrapFailure()
        LogOutput("ERROR", "[IllicitCargo] ServerUnstrapCargo FAILED for %s: %s",
          key, tostring(unstrapErr))
      end

      local playerId = nil
      local playerGuid = nil
      pcall(function() playerId = GetPlayerUniqueId(playerController) end)
      pcall(function() playerGuid = GetPlayerGuid(playerController) end)
      EnqueueWebhookEvent("IllicitStrapBlocked", {
        PlayerId = playerId,
        CharacterGuid = playerGuid,
        CargoKey = key,
      })
    end)
    if not ok then
      LogOutput("ERROR", "[IllicitCargo] Post-hook error: %s", tostring(err))
    end
  end
)

LogOutput("INFO", "[IllicitCargo] Loaded (hookStatus=%s)", hookStatus and "registered" or "failed")

return {
  GetHookStatus = function() return hookStatus end,
}
