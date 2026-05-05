local statics = require("Statics")

---Check if a player's display name contains a wanted tag [*].
local function IsWantedPlayer(playerController)
  if not playerController or not playerController:IsValid() then return false end
  local PS = playerController.PlayerState
  if not PS or not PS:IsValid() then return false end

  local ok, name = pcall(function()
    local n = PS:GetPlayerName()
    if type(n) == "userdata" then return n:ToString() end
    return tostring(n)
  end)
  if not ok or not name then return false end

  return string.find(name, "%[%*") ~= nil
end

RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerSetSprint", function(PC, bSprint)
  local playerController = PC:get()
  if not IsWantedPlayer(playerController) then return end
  if bSprint:get() then
    bSprint:set(false)
    LogOutput("INFO", "[CriminalManager] Blocked sprint for wanted player")
  end
end)

LogOutput("INFO", "[CriminalManager] Loaded (v%s)", statics.ModVersion)

return {}
