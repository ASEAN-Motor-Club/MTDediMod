local statics = require("Statics")

local WIDGET_FULL_PATH = "/Game/UI/InGame/Vehicle/W_RoadSideService.W_RoadSideService_C"

local function IsRPPlayer()
    local PC = GetMyPlayerController()
    if not PC or not PC:IsValid() then return false end
    local PS = PC.PlayerState
    if not PS or not PS:IsValid() then return false end

    local ok, name = pcall(function()
        local n = PS:GetPlayerName()
        if type(n) == "userdata" then return n:ToString() end
        return tostring(n)
    end)
    if not ok then return false end

    return name and string.find(name, "%[RP%]") ~= nil
end

NotifyOnNewObject(WIDGET_FULL_PATH, function(widget)
    if not IsRPPlayer() then return end
    ExecuteInGameThread(function()
        if widget:IsValid() then
            widget:RemoveFromParent()
            LogOutput("INFO", "[RoadsideServiceFilter] Blocked roadside service menu for RP player")
        end
    end)
end)

local existing = FindFirstOf("W_RoadSideService_C")
if existing and existing:IsValid() and IsRPPlayer() then
    existing:RemoveFromParent()
end

LogOutput("INFO", "[RoadsideServiceFilter] Loaded (v%s)", statics.ModVersion)

return {}
