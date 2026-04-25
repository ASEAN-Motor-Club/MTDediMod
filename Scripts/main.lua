local dir = os.getenv("PWD") or io.popen("cd"):read()
package.cpath = package.cpath .. ";" .. dir .. "/ue4ss/Mods/shared/?/core.dll"
package.cpath = package.cpath .. ";" .. dir .. "/ue4ss/Mods/shared/?.dll"

require("Helpers")
local json = require("JsonParser")
local logging = require("Debugging/Logging")
local statics = require("Statics")

---@deprecated Use LogOutput instead to avoid concat errors
LogMsg = logging.logMsg
LogOutput = logging.logOutput

local playerManager = require("PlayerManager")
local eventManager = require("EventManager")
local serverManager = require("ServerManager")
local cargoManager = require("CargoManager")
local chatManager = require("ChatManager")
local widgetManager = require("ViewportManager")
local companyManager = require("CompanyManager")
local characterManager = require("CharacterManager")
local Commands = require("Commands")

local function LoadWebserver()
  local status, err = pcall(function()
    local server = require("Webserver")

    -- Local imports are placed here due to socket dependency

    local propertyManager = require("PropertyManager")
    local vehicleManager = require("VehicleManager")
    local assetManager = require("AssetManager")
    local webclient = require("Webclient")
    local depotManager = require("DepotManager")

    -- Note that the ordering of the path registration matters.
    -- Put more specific paths before more general ones

    -- General server status
    server.registerHandler("/webhook", "GET", webclient.HandleGetWebhooks)
    server.registerHandler("/status", "GET", serverManager.HandleGetServerStatus, true)
    server.registerHandler("/version", "GET", serverManager.HandleGetModVersion, true)
    server.registerHandler("/status/general", "GET", serverManager.HandleGetServerState, true)
    server.registerHandler("/status/general/*", "GET", serverManager.HandleGetZoneState, true)
    server.registerHandler("/dump/lua_types", "POST", function(session)
        GenerateLuaTypes()
        return { status = "lua types generated" }, nil, 200
    end, true)
    server.registerHandler("/mods/reload", "POST", function(session)
        RestartCurrentMod()
        return { status = "received mods reload signal" }, nil, 202
    end, true)
    server.registerHandler("/status/traffic", "POST", serverManager.HandleUpdateNpcTraffic)
    server.registerHandler("/config", "POST", serverManager.HandleSetServerConfig)
    server.registerHandler("/police/patrol_areas", "GET", serverManager.HandleGetPolicePatrolAreas)
    server.registerHandler("/command", "POST", serverManager.HandleServerExecCommand)

    -- Player management
    server.registerHandler("/players", "GET", playerManager.HandleGetPlayerStates, true)
    server.registerHandler("/players/*/teleport", "POST", playerManager.HandleTeleportPlayer)
    server.registerHandler("/players/*/money", "POST", playerManager.HandleTransferMoneyToPlayer)
    server.registerHandler("/players/*/chat", "POST", playerManager.HandlePlayerSendChat)
    server.registerHandler("/players/*/mute", "POST", playerManager.HandleMutePlayer)
    server.registerHandler("/players/*/mute", "DELETE", playerManager.HandleUnmutePlayer)
    server.registerHandler("/players/muted", "GET", playerManager.HandleGetMutedPlayers)
    server.registerHandler("/players/*/name", "PUT", playerManager.HandleSetPlayerName)
    server.registerHandler("/players/*/suspect", "POST", playerManager.HandleMakePlayerSuspect)
    
    -- Experimental
    server.registerHandler("/players/*/experimental/hide_actor", "POST", playerManager.HandleExperimentalHideActor)
    server.registerHandler("/players/*/experimental/hide_costume", "POST", playerManager.HandleExperimentalHideCostume)
    server.registerHandler("/players/*/experimental/ghost", "POST", playerManager.HandleExperimentalGhostFlag)
    server.registerHandler("/players/*/experimental/spectate", "POST", playerManager.HandleExperimentalSpectate)
    server.registerHandler("/players/*/despawn_cargo", "POST", cargoManager.HandleDespawnPlayerCargo)
    server.registerHandler("/players/*/vehicle_cargos", "GET", cargoManager.HandleGetVehicleCargos)
    server.registerHandler("/players/*/vehicle_cargos", "DELETE", cargoManager.HandleClearVehicleCargos)
    server.registerHandler("/police", "GET", playerManager.HandleGetPoliceState)
    server.registerHandler("/players/*", "GET", playerManager.HandleGetPlayerStates, true)
    server.registerHandler("/parties", "GET", playerManager.HandleGetParties)

    -- Event management
    server.registerHandler("/events", "GET", eventManager.HandleGetEvents)
    server.registerHandler("/events", "POST", eventManager.HandleCreateNewEvent)
    server.registerHandler("/events/*", "GET", eventManager.HandleGetEvents)
    server.registerHandler("/events/*/state", "POST", eventManager.HandleChangeEventState)
    server.registerHandler("/events/*/join", "POST", eventManager.HandleJoinEvent)
    server.registerHandler("/events/*/leave", "POST", eventManager.HandleLeaveEvent)
    server.registerHandler("/events/*", "POST", eventManager.HandleUpdateEvent)
    server.registerHandler("/events/*", "DELETE", eventManager.HandleRemoveEvent)

    -- Properties management
    server.registerHandler("/houses", "GET", propertyManager.HandleGetHouses)
    server.registerHandler("/houses/spawn", "POST", propertyManager.HandleSpawnHouse)
    server.registerHandler("/houses/*/transfer/direct", "POST", propertyManager.HandleTransferHouseDirect)
    server.registerHandler("/houses/*/transfer/direct_extend", "POST", propertyManager.HandleTransferHouseDirectExtend)
    server.registerHandler("/houses/*/rent/extend", "POST", propertyManager.HandleExtendHouseRent)

    -- Cargo management
    server.registerHandler("/delivery/points", "GET", cargoManager.HandleGetDeliveryPoints)
    server.registerHandler("/delivery/points/*", "GET", cargoManager.HandleGetDeliveryPoints)
    server.registerHandler("/player_contracts/*", "GET", cargoManager.HandleGetPlayerContracts)


    -- Vehicle management
    server.registerHandler("/vehicles", "GET", vehicleManager.HandleGetVehicles)
    server.registerHandler("/vehicles/spawn", "POST", vehicleManager.HandleSpawnVehicle)
    server.registerHandler("/vehicle_parts_by_tag/*", "GET", vehicleManager.HandleGetVehiclePartsByTag)
    server.registerHandler("/vehicle_parts_by_tag/*", "POST", vehicleManager.HandleSetVehiclePartsByTag)
    server.registerHandler("/tagged_vehicles", "GET", vehicleManager.HandleGetVehiclesByTag)
    server.registerHandler("/vehicles", "PATCH", vehicleManager.HandleSetVehicleParameter)
    server.registerHandler("/player_vehicles/*/detach", "POST", vehicleManager.HandleDetachPlayerVehicle)
    server.registerHandler("/player_vehicles/*/decal", "GET", vehicleManager.HandleGetPlayerVehicleDecal)
    server.registerHandler("/player_vehicles/*/decal", "POST", vehicleManager.HandleSetPlayerVehicleDecal)
    server.registerHandler("/player_vehicles/*/last/decals", "GET", vehicleManager.HandleGetPlayerLastVehicleDecals)
    server.registerHandler("/player_vehicles/*/last/parts", "GET", vehicleManager.HandleGetPlayerLastVehicleParts)
    server.registerHandler("/player_vehicles/*/last", "GET", vehicleManager.HandleGetPlayerLastVehicle)
    server.registerHandler("/player_vehicles/*/list", "GET", vehicleManager.HandleGetPlayerVehicles)
    server.registerHandler("/vehicles/*", "GET", vehicleManager.HandleGetVehicles)
    server.registerHandler("/vehicles/*", "PATCH", vehicleManager.HandleSetVehicleParameter)
    server.registerHandler("/world_vehicles/*/decal", "POST", vehicleManager.HandleSetWorldVehicleDecal)
    server.registerHandler("/dealers/spawn", "POST", vehicleManager.HandleCreateVehicleDealerSpawnPoint)
    server.registerHandler("/garages", "GET", vehicleManager.HandleGetGarages)
    server.registerHandler("/garages/spawn", "POST", vehicleManager.HandleSpawnGarage)
    -- rename to POST /vehicles
    server.registerHandler("/player_vehicles/*/despawn", "POST", vehicleManager.HandleDespawnPlayerVehicle)
    server.registerHandler("/player_vehicles/*/exit", "GET", vehicleManager.HandlePlayerExitVehicle)
    server.registerHandler("/players/*/enter_last_vehicle", "POST", vehicleManager.HandlePlayerEnterLastVehicle)

    -- Asset management
    server.registerHandler("/assets/spawn", "POST", assetManager.HandleSpawnActor)
    server.registerHandler("/assets/despawn", "POST", assetManager.HandleDespawnActor)

    -- UI management
    server.registerHandler("/messages/popup", "POST", widgetManager.HandleShowPopupMessage)
    server.registerHandler("/messages/system", "POST", widgetManager.HandleShowSystemMessage)
    server.registerHandler("/messages/announce", "POST", chatManager.HandleAnnounceMessage)

    -- Company management
    server.registerHandler("/companies", "GET", companyManager.HandleGetCompanies)

    -- Depot management
    server.registerHandler("/depots", "GET", depotManager.HandleGetDepots, false)
    server.registerHandler("/depots/*", "GET", depotManager.HandleGetDepots, false)

    -- Character management
    server.registerHandler("/characters", "GET", characterManager.HandleGetCharacters)

    server.run("*")
    return nil
  end)
  if not status then
    LogOutput("ERROR", "Webserver stopped unexpectedly due to error: %s", err)
  end
end

LoadWebserver()
LogOutput("INFO", "Mod loaded")
