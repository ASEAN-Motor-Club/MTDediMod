local statics = require("Statics")

local WIDGET_FULL_PATH = "/Game/UI/InGame/Vehicle/W_RoadSideService.W_RoadSideService_C"

NotifyOnNewObject(WIDGET_FULL_PATH, function(widget)
    ExecuteInGameThread(function()
        if widget:IsValid() then
            widget:RemoveFromParent()
            LogOutput("INFO", "[RoadsideServiceFilter] Blocked roadside service menu")
        end
    end)
end)

local existing = FindFirstOf("W_RoadSideService_C")
if existing and existing:IsValid() then
    existing:RemoveFromParent()
end

LogOutput("INFO", "[RoadsideServiceFilter] Loaded (v%s)", statics.ModVersion)

return {}
