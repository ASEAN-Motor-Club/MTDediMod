local json = require("JsonParser")

local _companySystem = CreateInvalidObject()
---@return AMTCompanySystem
local function GetCompanySystem()
  local gameState = GetMotorTownGameState()
  if gameState:IsValid() and gameState.Net_CompanySystem:IsValid() then
    _companySystem = gameState.Net_CompanySystem
  end
  return _companySystem
end

---Convert FMTCompanyDepot to JSON serializable table
---@param depot FMTCompanyDepot
---@return table
local function DepotToTable(depot)
  return {
    BuildingGuid = GuidToString(depot.BuildingGuid),
    Name = depot.Name:ToString(),
    CompanyGuid = GuidToString(depot.CompanyGuid),
    bIsUnderConstruction = depot.bIsUnderConstruction,
    Storage = depot.Storage,
    NumActiveVehicles = depot.NumActiveVehicles,
    RunningCostPer10Mins = depot.RunningCostPer10Mins,
    StorageMultiplier = depot.StorageMultiplier,
  }
end

---Get all depots or filter by building GUID or company GUID
---@param buildingGuid string? Filter by building GUID
---@param companyGuid string? Filter by company GUID
---@return table[]
local function GetDepots(buildingGuid, companyGuid)
  local companySystem = GetCompanySystem()
  local arr = {}

  if companySystem:IsValid() then
    companySystem.Net_Depots:ForEach(function(index, element)
      local depot = element:get()

      if buildingGuid and buildingGuid:upper() ~= GuidToString(depot.BuildingGuid) then
        return
      end

      if companyGuid and companyGuid:upper() ~= GuidToString(depot.CompanyGuid) then
        return
      end

      table.insert(arr, DepotToTable(depot))
    end)
  end

  return arr
end

---Handle GET /depots or GET /depots/:buildingGuid
---@type RequestPathHandler
local function HandleGetDepots(session)
  local buildingGuid = session.pathComponents[2]
  local companyGuid = session.queryComponents.company_guid

  local data = GetDepots(buildingGuid, companyGuid)

  if buildingGuid and #data == 0 then
    return json.stringify { message = string.format("Depot %s not found", buildingGuid) }, nil, 404
  end

  return json.stringify { data = data }
end

return {
  HandleGetDepots = HandleGetDepots,
}
