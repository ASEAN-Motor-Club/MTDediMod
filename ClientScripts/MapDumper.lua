---MapDumper — export road network, navigation graph, and heightmap to JSON
---Usage: /dumpmap [filename] [heightmapSample=4]

local UEHelpers = require("UEHelpers")
local json = require("JsonParser")
local statics = require("Statics")

local dir = os.getenv("PWD") or io.popen("cd"):read()
local defaultOutDir = dir .. "/ue4ss/Mods/" .. statics.ModName

---@param v FVector
local function vec(v)
  if not v then return nil end
  return { X = v.X, Y = v.Y, Z = v.Z }
end

---@param road AMotorTownRoad
local function dumpRoad(road)
  local spline = road.Spline
  local points = {}
  local n = spline:GetNumberOfSplinePoints()
  for p = 0, n - 1 do
    local loc = spline:GetWorldLocationAtSplinePoint(p)
    table.insert(points, vec(loc))
  end

  local excludeKeys = {}
  road.ExcludeConnectionRoads:ForEach(function(_, elem)
    local r = elem:get()
    if r:IsValid() then
      table.insert(excludeKeys, r.CourseKey:ToString())
    end
  end)

  return {
    CourseKey = road.CourseKey:ToString(),
    RoadType = road.RoadType,
    LaneWidth = road.LaneWidth,
    NumForwardLanes = road.NumForwardLanes,
    NumBackwardLanes = road.NumBackwardLanes,
    SpeedLimitKPH = road.SpeedLimitKPH,
    RoadFlags = road.RoadFlags,
    bCopyFromLandscape = road.bCopyFromLandscape,
    CopyFromLandscapeWidthMultiplier = road.CopyFromLandscapeWidthMultiplier,
    MaxRoadSideTowDistance = road.MaxRoadSideTowDistance,
    SplineLength = spline:GetSplineLength(),
    NumSplinePoints = n,
    SplinePoints = points,
    ExcludeConnectionRoads = excludeKeys,
    SplineBounds = {
      Min = vec(road.SplineBounds.Min),
      Max = vec(road.SplineBounds.Max),
    },
  }
end

---@param node FMTRoadGraphNode
local function dumpGraphNode(node)
  local edges = {}
  node.Edges:ForEach(function(_, e)
    table.insert(edges, {
      NodeIndex = e.NodeIndex,
      Cost = e.Cost,
      Distance = e.Distance,
      Flags = e.Flags,
    })
  end)

  local navPointKeys = {}
  node.Debug_NavPoints:ForEach(function(_, wp)
    local np = wp:get()
    if np:IsValid() then
      table.insert(navPointKeys, np:GetFullName())
    end
  end)

  return {
    SplineDistance = node.SplineDistance,
    AbsoluteLocation = vec(node.AbsoluteLocation),
    Direction = vec(node.Direction),
    RightVector = vec(node.RightVector),
    NodeIndex = node.NodeIndex,
    LateralDistance = node.LateralDistance,
    LateralOffset = node.LateralOffset,
    Lane = node.Lane,
    SplinePointIndex = node.SplinePointIndex,
    Flags = node.Flags,
    AutoConnectDistance = node.AutoConnectDistance,
    SpeedLimit = node.SpeedLimit,
    IslandId = node.IslandId,
    CrossroadId = node.CrossroadId,
    RightSideClearance = node.RightSideClearance,
    Edges = edges,
    _debugNavPointNames = navPointKeys,
  }
end

---@param heightmap FMTHeightmapData
---@param sample integer
local function dumpHeightmap(heightmap, sample)
  sample = sample or 1
  local raw = heightmap.ScaledHeightData
  local sx = heightmap.SizeX
  local sy = heightmap.SizeY
  local outSX = math.floor(sx / sample)
  local outSY = math.floor(sy / sample)
  local heights = {}

  for y = 0, outSY - 1 do
    for x = 0, outSX - 1 do
      local srcX = x * sample
      local srcY = y * sample
      local idx = srcY * sx + srcX + 1  -- Lua 1-based
      local h = raw[idx]
      if h then
        table.insert(heights, h)
      else
        table.insert(heights, 0)
      end
    end
  end

  return {
    GridSize = heightmap.GridSize,
    ScaleZ = heightmap.ScaleZ,
    Origin = vec(heightmap.Origin),
    SizeX = sx,
    SizeY = sy,
    Sample = sample,
    SampledSizeX = outSX,
    SampledSizeY = outSY,
    Heights = heights,
  }
end

---Export everything to JSON
---@param filename string?
---@param heightmapSample integer?
function DumpMap(filename, heightmapSample)
  filename = filename or "map_export.json"
  heightmapSample = heightmapSample or 4

  local world = UEHelpers.GetWorld()
  local out = {
    exportedAt = os.date("%Y-%m-%dT%H:%M:%SZ"),
    roads = {},
    roadsByKey = {},
    navGraph = nil,
    heightmap = nil,
  }

  -- ─── Roads ──────────────────────────────────────────────────────
  local roadClass = StaticFindObject("/Script/MotorTown.MotorTownRoad")
  local roadActors = {}
  UEHelpers.GetGameplayStatics():GetAllActorsOfClass(world, roadClass, roadActors)

  LogOutput("INFO", "MapDumper: found %d road actors", #roadActors)

  for i = 1, #roadActors do
    local road = roadActors[i]:get()
    if road:IsValid() and not road:IsActorBeingDestroyed() then
      local r = dumpRoad(road)
      table.insert(out.roads, r)
      out.roadsByKey[r.CourseKey] = r
    end
  end

  -- ─── Navigation Graph ───────────────────────────────────────────
  local navClass = StaticFindObject("/Script/MotorTown.MotorTownNavigation")
  local navActors = {}
  UEHelpers.GetGameplayStatics():GetAllActorsOfClass(world, navClass, navActors)

  if #navActors > 0 then
    local nav = navActors[1]:get() ---@type AMotorTownNavigation
    if nav:IsValid() then
      local graph = nav.GraphData
      local nodes = {}
      graph.Nodes:ForEach(function(_, n)
        table.insert(nodes, dumpGraphNode(n))
      end)
      out.navGraph = {
        nodeCount = #nodes,
        bounds = {
          Min = vec(graph.Bounds.Min),
          Max = vec(graph.Bounds.Max),
        },
        nodes = nodes,
      }
      LogOutput("INFO", "MapDumper: exported %d nav graph nodes", #nodes)

      -- ─── Heightmap ──────────────────────────────────────────────
      local hmap = nav.HeightmapData
      if hmap.SizeX > 0 and hmap.SizeY > 0 then
        out.heightmap = dumpHeightmap(hmap, heightmapSample)
        LogOutput("INFO", "MapDumper: heightmap %dx%d (sample=%d) => %dx%d",
          hmap.SizeX, hmap.SizeY, heightmapSample,
          out.heightmap.SampledSizeX, out.heightmap.SampledSizeY)
      else
        LogOutput("WARN", "MapDumper: navigation actor has no heightmap")
      end
    end
  else
    LogOutput("WARN", "MapDumper: no AMotorTownNavigation actor found")
  end

  -- ─── Write JSON ─────────────────────────────────────────────────
  local path = defaultOutDir .. "/" .. filename
  local file, err = io.open(path, "wb")
  if file then
    file:write(json.stringify(out))
    file:close()
    LogOutput("INFO", "MapDumper: saved to %s", path)
  else
    LogOutput("ERROR", "MapDumper: failed to write %s: %s", path, err)
  end
end

-- Console command: /dumpmap [filename] [sample]
RegisterConsoleCommandHandler("dumpmap", function(Cmd, CommandParts, Ar)
  local filename = CommandParts[2]
  local sample = tonumber(CommandParts[3])
  ExecuteInGameThread(function()
    DumpMap(filename, sample)
  end)
  return true
end)

LogOutput("INFO", "MapDumper loaded")

return { DumpMap = DumpMap }
