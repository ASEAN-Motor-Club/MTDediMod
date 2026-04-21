local statics = require("Statics")

local WIDGET_FULL_PATH = "/Game/UI/InGame/Vehicle/W_RoadSideService.W_RoadSideService_C"
local VIS_COLLAPSED = 1
local HUD_CLASS_PATH = "/Script/MotorTown.MotorTownInGameHUD"

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

local function GetMyVehicle()
    local PC = GetMyPlayerController()
    if not PC or not PC:IsValid() then return nil end
    local pawn = PC:K2_GetPawn()
    if not pawn or not pawn:IsValid() then return nil end
    local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
    if not vehicleClass or not vehicleClass:IsValid() then return nil end
    if pawn:IsA(vehicleClass) then return pawn end
    return nil
end

local function GetHudWidget()
    local PC = GetMyPlayerController()
    if not PC or not PC:IsValid() then return nil end
    local HUD = PC:GetHUD()
    if not HUD or not HUD:IsValid() then return nil end
    local hudClass = StaticFindObject(HUD_CLASS_PATH)
    if not hudClass or not hudClass:IsValid() then return nil end
    if not HUD:IsA(hudClass) then return nil end
    local hudWidget = HUD.HUDWidget
    if not hudWidget or not hudWidget:IsValid() then return nil end
    return hudWidget
end

NotifyOnNewObject(WIDGET_FULL_PATH, function(widget)
    if not IsRPPlayer() then return end
    ExecuteInGameThread(function()
        if widget:IsValid() then
            widget:RemoveFromParent()
            LogOutput("INFO", "[RPRestrictions] Blocked roadside service menu")
        end
    end)
end)

local existing = FindFirstOf("W_RoadSideService_C")
if existing and existing:IsValid() and IsRPPlayer() then
    existing:RemoveFromParent()
end

local function DisableAutoPilotWidgets()
    if not IsRPPlayer() then return end
    local hudWidget = GetHudWidget()
    if not hudWidget then return end
    local drivingHUD = hudWidget.DrivingHUD
    if not drivingHUD or not drivingHUD:IsValid() then return end

    local ap = drivingHUD.AutoPilotWidget
    if ap and ap:IsValid() and ap.Visibility ~= VIS_COLLAPSED then
        ap:SetVisibility(VIS_COLLAPSED)
        LogOutput("INFO", "[RPRestrictions] Hidden AutoPilotWidget")
    end

    local ai = drivingHUD.ToggleAIWidget
    if ai and ai:IsValid() and ai.Visibility ~= VIS_COLLAPSED then
        ai:SetVisibility(VIS_COLLAPSED)
        LogOutput("INFO", "[RPRestrictions] Hidden ToggleAIWidget")
    end
end

RegisterHook("/Script/MotorTown.MTVehicle:ServerSyncColdState", function(Context, ColdState, bMulticast)
    if not IsRPPlayer() then return end
    local ok, cs = pcall(function() return ColdState:get() end)
    if not ok or not cs then return end
    local ok2, bAI = pcall(function() return cs.bIsAIDriving end)
    if ok2 and bAI then
        pcall(function() cs.bIsAIDriving = false end)
        LogOutput("INFO", "[RPRestrictions] Blocked bIsAIDriving=true in ServerSyncColdState")
    end
end)

local function ForceDisableAutoPilot()
    if not IsRPPlayer() then return end
    local vehicle = GetMyVehicle()
    if not vehicle then return end

    local ok, coldState = pcall(function() return vehicle.NetLC_ColdState end)
    if not ok or not coldState then return end

    local ok2, bAIDriving = pcall(function() return coldState.bIsAIDriving end)
    if not ok2 or not bAIDriving then return end

    LogOutput("INFO", "[RPRestrictions] AutoPilot active — forcing disable via ServerSyncColdState")

    pcall(function()
        coldState.bIsAIDriving = false
        vehicle:ServerSyncColdState(coldState, true)
    end)
end

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    ExecuteInGameThread(function()
        DisableAutoPilotWidgets()
    end)
end)

local function BlockTeleportHooks()
    RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerTeleportCharacter", function(Context, AbsoluteLocation, bCharge, bIsRespawn)
        if not IsRPPlayer() then return end
        local PC = Context:get()
        if not PC or not PC:IsValid() then return end
        local pawn = PC:K2_GetPawn()
        if pawn and pawn:IsValid() then
            local loc = pawn:K2_GetActorLocation()
            AbsoluteLocation:get().X = loc.X
            AbsoluteLocation:get().Y = loc.Y
            AbsoluteLocation:get().Z = loc.Z
            LogOutput("INFO", "[RPRestrictions] Blocked ServerTeleportCharacter — replaced with current pos")
        end
    end)

    RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerTeleportVehicle", function(Context, Vehicle, AbsoluteLocation)
        if not IsRPPlayer() then return end
        local veh = Vehicle:get()
        if veh and veh:IsValid() then
            local loc = veh:K2_GetActorLocation()
            AbsoluteLocation:get().X = loc.X
            AbsoluteLocation:get().Y = loc.Y
            AbsoluteLocation:get().Z = loc.Z
            LogOutput("INFO", "[RPRestrictions] Blocked ServerTeleportVehicle — replaced with current pos")
        end
    end)

    RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerResetVehicleAt", function(Context, Vehicle, WorldLocation, Rotation, bRemoveCargo, bResetCarriedVehicles)
        if not IsRPPlayer() then return end
        local veh = Vehicle:get()
        if veh and veh:IsValid() then
            local loc = veh:K2_GetActorLocation()
            WorldLocation:get().X = loc.X
            WorldLocation:get().Y = loc.Y
            WorldLocation:get().Z = loc.Z
            LogOutput("INFO", "[RPRestrictions] Blocked ServerResetVehicleAt — replaced with current pos")
        end
    end)
end

local function ClearTeleportPoints()
    if not IsRPPlayer() then return end
    local gameState = FindFirstOf("MotorTownGameState_C")
    if not gameState or not gameState:IsValid() then return end
    local ok, points = pcall(function() return gameState.Net_TeleportPoints end)
    if not ok or not points then return end
    local ok2, count = pcall(function() return points:Length() end)
    if ok2 and count and count > 0 then
        pcall(function() points:Empty() end)
        LogOutput("INFO", "[RPRestrictions] Cleared %d Net_TeleportPoints from GameState", count)
    end
end

BlockTeleportHooks()

LoopAsync(2000, function()
    ExecuteInGameThread(function()
        DisableAutoPilotWidgets()
        ForceDisableAutoPilot()
        ClearTeleportPoints()
    end)
    return false
end)

LogOutput("INFO", "[RPRestrictions] Loaded (v%s)", statics.ModVersion)

return {}
