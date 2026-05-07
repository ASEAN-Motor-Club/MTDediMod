local json = require("JsonParser")
local UEHelpers = require("UEHelpers")

local balanceConfig = {}
local balanceConfigRaw = ReadFileAsString("../../../BalanceConfig.json")
if balanceConfigRaw then
    local config = json.parse(balanceConfigRaw)
    if config then
        balanceConfig = config
        LogOutput("INFO", "BalanceConfig.json loaded")
    else
        LogOutput("WARN", "BalanceConfig.json: invalid JSON")
    end
end

local simpleFields = {
    "VehicleOwnerProfitSharePerCost",
    "TaxiPaymentPer100Meter",
    "AmbulancePaymentPer100Meter",
    "BusPayment",
    "BusPaymentPer100Meter",
    "MaxNonFixCargo",
    "JobIncomeToJobExpMultiplier",
    "FuelCostPerLiter",
    "SmallEngineFuelConsumption",
    "MediumEngineFuelConsumption",
    "LargeEngineFuelConsumption",
    "RoadsideServiceRefuelingBaseCost",
    "RoadsideServiceRefuelingPercent",
    "RoadsideServiceRefuelingCostMultiplier",
    "RoadsideServiceTowToRoadCostPer1Km",
    "BoxTrailerPaymentPer1Km",
    "NavigatedTowRequestBasePayment",
    "NavigatedTowRequestPaymentPer1Km",
    "VehicleDeliveryBasePayment",
    "VehicleDeliveryPaymentPer1Km",
    "RescueRequestBasePayment",
    "RescueRequestPaymentPer1Km",
    "TowStartRewardBasePayment",
    "TowStartRewardSizeUnit",
    "TowStartRewardWeightUnit",
    "TowStartRewardDamageExponent",
}

local vector2dFields = {
    "TowBasePaymentBonusSize",
    "TowBasePaymentBonusMultiplier",
    "TowDistPaymentBonusSize",
    "TowDistPaymentBonusMultiplier",
    "RescueBasePaymentBonusSize",
    "RescueBasePaymentBonusMultiplier",
    "TowStartRewardSizeRateClamp",
    "TowStartRewardWeightRateClamp",
    "TowStartRewardDamageMultiplierRange",
}

-- Static enum lookup tables derived from types/MotorTown_enums.lua.
-- key:get() on enum-keyed TMaps may return integers instead of FNames,
-- so we build a string→int map from the authoritative enum definitions.
local enumLookup = {
    EMTFuelType = {
        Invalid = 0,
        Gasoline = 1,
        Diesel = 2,
        Electric = 3,
        Water = 4,
    },
    EMTVehicleType = {
        None = 0,
        Kart = 1,
        Small = 2,
        Pickup = 3,
        Bus = 4,
        Truck = 5,
        SemiTractor = 6,
        SemiTrailer = 7,
        SmallTrailer = 8,
        Motorhome = 9,
        Caravan = 10,
        HeavyMachinery = 11,
        Bike = 12,
        Racecar = 13,
    },
    EMTTruckClass = {
        None = 0,
        LightDuty = 1,
        MediumDuty = 2,
        HeavyDuty = 3,
    },
}

local tmapFields = {
    { configKey = "VehicleOwnerProfitShare", field = "VehicleOwnerProfitShare", enumType = "EMTVehicleType" },
    { configKey = "RentalCostMultiplier", field = "RentalCostMultiplier", enumType = "EMTVehicleType" },
    { configKey = "VehicleSpawnCostByVehicleType", field = "VehicleSpawnCostByVehicleType", enumType = "EMTVehicleType" },
    { configKey = "VehicleSpawnCostByTruckClass", field = "VehicleSpawnCostByTruckClass", enumType = "EMTTruckClass" },
    { configKey = "VehicleSpawnCostPer1KmByTruckClass", field = "VehicleSpawnCostPer1KmByTruckClass", enumType = "EMTTruckClass" },
    { configKey = "TireWearByWeightPowerByTruckClass", field = "TireWearByWeightPowerByTruckClass", enumType = "EMTTruckClass" },
    { configKey = "FuelCostPerLiters", field = "FuelCostPerLiters", enumType = "EMTFuelType" },
}

---Build reverse lookup: enumTypeName → (integer → enum name)
local enumReverseLookup = {}
for enumName, entries in pairs(enumLookup) do
    enumReverseLookup[enumName] = {}
    for name, intValue in pairs(entries) do
        enumReverseLookup[enumName][intValue] = name
    end
end

---Build a string→key map from an existing TMap via ForEach.
---Returns both the dynamic map (from live TMap keys) and the enum name→int map.
---@param tmap table UE4SS TMap object
---@param enumTypeName string? enum type name for static lookup fallback
---@return table<string, any> map of string key -> usable TMap key
local function buildKeyMap(tmap, enumTypeName)
    local map = {}
    tmap:ForEach(function(key, _)
        local keyObj = key:get()
        local keyStr = tostring(keyObj)
        map[keyStr] = keyObj
    end)

    if enumTypeName and enumLookup[enumTypeName] then
        for name, intValue in pairs(enumLookup[enumTypeName]) do
            if map[name] == nil then
                map[name] = intValue
            end
        end
    end

    return map
end

---@param balanceTable table FMTBalanceTable struct
---@param config table BalanceConfig overrides
local function applyOverrides(balanceTable, config)
    for _, field in ipairs(simpleFields) do
        local value = config[field]
        if value ~= nil then
            local ok, err = pcall(function()
                balanceTable[field] = value
            end)
            if ok then
                LogOutput("INFO", "Balance override: %s = %s", field, tostring(value))
            else
                LogOutput("WARN", "Balance override failed for %s: %s", field, tostring(err))
            end
        end
    end

    for _, field in ipairs(vector2dFields) do
        local value = config[field]
        if value ~= nil and type(value) == "table" then
            local ok, err = pcall(function()
                if value.X ~= nil then
                    balanceTable[field].X = value.X
                end
                if value.Y ~= nil then
                    balanceTable[field].Y = value.Y
                end
            end)
            if ok then
                LogOutput("INFO", "Balance override: %s = {X=%s, Y=%s}", field,
                    tostring(value.X), tostring(value.Y))
            else
                LogOutput("WARN", "Balance override failed for %s: %s", field, tostring(err))
            end
        end
    end

    for _, tmapDef in ipairs(tmapFields) do
        local overrides = config[tmapDef.configKey]
        if overrides ~= nil and type(overrides) == "table" then
            local ok, err = pcall(function()
                local tmap = balanceTable[tmapDef.field]
                local keyMap = buildKeyMap(tmap, tmapDef.enumType)
                for name, value in pairs(overrides) do
                    local enumKey = keyMap[name]
                    if enumKey ~= nil then
                        tmap:Add(enumKey, value)
                        LogOutput("INFO", "Balance override: %s[%s] = %s", tmapDef.field, name, tostring(value))
                    else
                        LogOutput("WARN", "Balance override: unknown TMap key '%s' for %s", name, tmapDef.field)
                    end
                end
            end)
            if not ok then
                LogOutput("WARN", "Balance override failed for TMap %s: %s", tmapDef.field, tostring(err))
            end
        end
    end
end

---@return table? balanceTable from GameResource, nil if unavailable
local function getGameResourceBalanceTable()
    local ok, results = pcall(FindAllOf, "MTGameResource")
    if ok and results and #results > 0 then
        local gr = results[1]
        if gr and gr:IsValid() then
            return gr.BalanceTable
        end
    end

    local gameInstance = UEHelpers.GetGameInstance()
    if not gameInstance or not gameInstance:IsValid() then
        return nil
    end
    local gameResource = gameInstance.GameResource
    if not gameResource or not gameResource:IsValid() then
        return nil
    end
    return gameResource.BalanceTable
end

---@return table? balanceTable from UMTBalanceSettings CDO, nil if unavailable
local function getBalanceSettingsBalanceTable()
    local balanceSettingsClass = StaticFindObject("/Script/MotorTown.MTBalanceSettings")
    if not balanceSettingsClass or not balanceSettingsClass:IsValid() then
        return nil
    end
    ---@cast balanceSettingsClass UClass
    local cdo = balanceSettingsClass:GetCDO()
    if not cdo or not cdo:IsValid() then
        return nil
    end
    return cdo.BalanceTable
end

local function applyConfigOverrides()
    if not balanceConfig or next(balanceConfig) == nil then
        return
    end

    LogOutput("INFO", "Applying balance table overrides from BalanceConfig.json")

    local grTable = getGameResourceBalanceTable()
    if grTable then
        LogOutput("INFO", "Applying overrides to UMTGameResource.BalanceTable")
        applyOverrides(grTable, balanceConfig)
    else
        LogOutput("WARN", "UMTGameResource.BalanceTable not available")
    end

    local settingsTable = getBalanceSettingsBalanceTable()
    if settingsTable then
        LogOutput("INFO", "Applying overrides to UMTBalanceSettings.BalanceTable")
        applyOverrides(settingsTable, balanceConfig)
    else
        LogOutput("WARN", "UMTBalanceSettings.BalanceTable not available")
    end
end

---@param balanceTable table FMTBalanceTable
---@return table<string, any> JSON-serializable snapshot
local function snapshotBalanceTable(balanceTable)
    local data = {}

    for _, field in ipairs(simpleFields) do
        local ok, value = pcall(function() return balanceTable[field] end)
        if ok and value ~= nil then
            data[field] = value
        end
    end

    for _, field in ipairs(vector2dFields) do
        local ok, vec = pcall(function() return balanceTable[field] end)
        if ok and vec ~= nil then
            local xOk, x = pcall(function() return vec.X end)
            local yOk, y = pcall(function() return vec.Y end)
            data[field] = {
                X = xOk and x or 0,
                Y = yOk and y or 0,
            }
        end
    end

    for _, tmapDef in ipairs(tmapFields) do
        local ok, tmap = pcall(function() return balanceTable[tmapDef.field] end)
        if ok and tmap ~= nil then
            local tmapData = {}
            local reverseMap = tmapDef.enumType and enumReverseLookup[tmapDef.enumType]
            pcall(function()
                tmap:ForEach(function(key, value)
                    local keyObj = key:get()
                    local keyStr = tostring(keyObj)
                    if reverseMap and tonumber(keyStr) and reverseMap[tonumber(keyStr)] then
                        keyStr = reverseMap[tonumber(keyStr)]
                    end
                    tmapData[keyStr] = value:get()
                end)
            end)
            data[tmapDef.field] = tmapData
        end
    end

    return data
end

local function HandleGetBalance(_session)
    local grTable = getGameResourceBalanceTable()
    local settingsTable = getBalanceSettingsBalanceTable()

    local result = {}
    if grTable then
        result.GameResource = snapshotBalanceTable(grTable)
    end
    if settingsTable then
        result.BalanceSettings = snapshotBalanceTable(settingsTable)
    end

    if not grTable and not settingsTable then
        return { error = "Balance tables not available" }, nil, 503
    end

    return result
end

local function HandlePatchBalance(session)
    local body = json.parse(session.content)
    if not body then
        return { error = "Invalid JSON body" }, nil, 400
    end

    local applied = {}

    local grTable = getGameResourceBalanceTable()
    if grTable then
        applyOverrides(grTable, body)
        table.insert(applied, "GameResource")
    end

    local settingsTable = getBalanceSettingsBalanceTable()
    if settingsTable then
        applyOverrides(settingsTable, body)
        table.insert(applied, "BalanceSettings")
    end

    if #applied == 0 then
        return { error = "Balance tables not available" }, nil, 503
    end

    return { status = "ok", appliedTo = applied }
end

applyConfigOverrides()

if next(balanceConfig) then
    local gameResourceOverridesApplied = false

    NotifyOnNewObject("/Script/MotorTown.MTGameResource", function(obj)
        if gameResourceOverridesApplied then return end
        if not obj or not obj:IsValid() then return end
        local grTable = obj.BalanceTable
        if grTable then
            LogOutput("INFO", "UMTGameResource created via NotifyOnNewObject, applying balance overrides")
            applyOverrides(grTable, balanceConfig)
            gameResourceOverridesApplied = true
        end
    end)

    LoopInGameThreadWithDelay(2000, function()
        if gameResourceOverridesApplied then return true end

        local grTable = getGameResourceBalanceTable()
        if grTable then
            LogOutput("INFO", "GameResource now available (poll), applying balance overrides")
            applyOverrides(grTable, balanceConfig)
            gameResourceOverridesApplied = true
            return true
        end

        return false
    end)

    RegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerRefuelVehicle", function(Context, Vehicle, CargoSpace, FuelType, CurrentFuel, TargetFuel, Cost, bChargeToOwner, TankerVehicle)
        LogOutput("INFO", "ServerRefuelVehicle: FuelType=%s, CurrentFuel=%.2f, TargetFuel=%.2f, Cost=%.2f",
            tostring(FuelType), CurrentFuel, TargetFuel, Cost)
    end)
end

return {
    HandleGetBalance = HandleGetBalance,
    HandlePatchBalance = HandlePatchBalance,
    applyConfigOverrides = applyConfigOverrides,
}
