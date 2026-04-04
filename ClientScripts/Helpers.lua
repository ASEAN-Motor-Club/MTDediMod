local UEHelpers = require("UEHelpers")

local myPlayerControllerCache = CreateInvalidObject() ---@cast myPlayerControllerCache AMotorTownPlayerController
---Get my own PlayerController
---@return AMotorTownPlayerController
function GetMyPlayerController()
  if myPlayerControllerCache:IsValid() then
    return myPlayerControllerCache
  end

  local gameInstance = UEHelpers.GetGameInstance()
  if gameInstance:IsValid() and gameInstance.LocalPlayers and #gameInstance.LocalPlayers > 0 then
    local localPlayer = gameInstance.LocalPlayers[1]
    if localPlayer:IsValid() then
      myPlayerControllerCache = localPlayer.PlayerController
    end
  else
    local playerController = UEHelpers.GetPlayerController()
    if playerController:IsValid() then
      myPlayerControllerCache = playerController
    end
  end
  return myPlayerControllerCache ---@type AMotorTownPlayerController
end

-- Importing functions to the global namespace of this mod just so that we don't have to retype 'UEHelpers.' over and over again.
local GetKismetSystemLibrary = UEHelpers.GetKismetSystemLibrary
local GetKismetMathLibrary = UEHelpers.GetKismetMathLibrary

local IsInitialized = false

local function Init()
  if not GetKismetSystemLibrary():IsValid() then error("KismetSystemLibrary not valid\n") end

  if not GetKismetMathLibrary():IsValid() then error("KismetMathLibrary not valid\n") end

  IsInitialized = true
end

Init()

---Get actor from hit result
---@param HitResult FHitResult
---@return AActor
function GetActorFromHitResult(HitResult)
  local actorClass = StaticFindObject("/Script/Engine.Actor")
  ---@cast actorClass UClass

  if UnrealVersion:IsBelow(5, 0) then
    return HitResult.Actor:Get()
  elseif UnrealVersion:IsBelow(5, 4) then
    return HitResult.HitObjectHandle.Actor:Get()
  else
    -- In UE 5.5, ReferenceObject can return a component (e.g. StaticMeshComponent)
    -- instead of the actor. Walk up the Outer chain to find the owning actor,
    -- mirroring what the C++ FHitResult::GetActor() does internally.
    local hitObject = HitResult.HitObjectHandle.ReferenceObject:Get()
    if hitObject:IsValid() and not hitObject:IsA(actorClass) then
      hitObject = hitObject:GetOuter()
    end
    return hitObject
  end
end

local selectedActor = CreateInvalidObject()
---@cast selectedActor AActor

---Get selected actor
---@return AActor
function GetSelectedActor()
  if selectedActor:IsValid() then return selectedActor end

  local wasHit, hitResult = GetHitResultFromCenterLineTrace()
  if wasHit then
    selectedActor = GetActorFromHitResult(hitResult)
    LogOutput("INFO", "Selected actor: %s", selectedActor:GetFullName())
  end
  return selectedActor
end

---Get a hit result from the camera center line trace
---@return boolean
---@return FHitResult
function GetHitResultFromCenterLineTrace()
  if not IsInitialized then return false, {} end

  local playerController = GetMyPlayerController()
  local playerPawn = playerController.Pawn
  local cameraManager = playerController.PlayerCameraManager
  local startVector = cameraManager:GetCameraLocation()
  local addValue = GetKismetMathLibrary():Multiply_VectorInt(
    GetKismetMathLibrary():GetForwardVector(cameraManager:GetCameraRotation()), 50000.0)
  local endVector = GetKismetMathLibrary():Add_VectorVector(startVector, addValue)
  local traceColor = {
    ["R"] = 0,
    ["G"] = 0,
    ["B"] = 0,
    ["A"] = 0,
  }
  local traceHitColor = traceColor
  local drawDebugTrace_Type_None = 0
  local traceTypeQuery_TraceTypeQuery1 = 0
  local actorsToIgnore = {
  }
  local hitResult = {}
  local wasHit = GetKismetSystemLibrary():LineTraceSingle(
    playerPawn,
    startVector,
    endVector,
    traceTypeQuery_TraceTypeQuery1,
    false,
    actorsToIgnore,
    drawDebugTrace_Type_None,
    hitResult,
    true,
    traceColor,
    traceHitColor,
    0.0
  )
  return wasHit, hitResult
end

local function DeselectActor()
  selectedActor = CreateInvalidObject()
  LogOutput("INFO", "Selected actor: none")
end

RegisterKeyBind(Key.F, { ModifierKey.CONTROL, ModifierKey.SHIFT }, GetSelectedActor)
RegisterKeyBind(Key.D, { ModifierKey.CONTROL, ModifierKey.SHIFT }, DeselectActor)
RegisterConsoleCommandHandler("deselectactor", function(Cmd, CommandParts, Ar)
  DeselectActor()
  return true
end)

---Convert FVector to JSON serializable table
---@param vector FVector
function VectorToTable(vector)
  if vector ~= nil and type(vector.IsValid) == "function" and not vector:IsValid() then
    return nil
  end
  return {
    X = vector.X,
    Y = vector.Y,
    Z = vector.Z
  }
end

---Convert FRotator to JSON serializable table
---@param rotation FQuat
function QuatToTable(rotation)
  return {
    W = rotation.W,
    X = rotation.X,
    Y = rotation.Y,
    Z = rotation.Z
  }
end

---Convert FRotator to JSON serializable table
---@param rotation FRotator
function RotatorToTable(rotation)
  return {
    Pitch = rotation.Pitch,
    Yaw = rotation.Yaw,
    Roll = rotation.Roll
  }
end

---Convert FTransform to JSON serializable table
---@param transform FTransform
function TransformToTable(transform)
  local location = VectorToTable(transform.Translation)
  local rotation = QuatToTable(transform.Rotation)
  local scale = VectorToTable(transform.Scale3D)
  return {
    Location = location,
    Rotation = rotation,
    Scale3D = scale
  }
end

---Convert FGuid to string
---@param guid FGuid
function GuidToString(guid)
  if guid == nil then
    return "0000"
  end

  if type(guid) == "table" then return "0000" end

  if type(guid.IsValid) == "function" and not guid:IsValid() then
    return "0000"
  end
  local rawGuid = { guid.A, guid.B, guid.C, guid.D }
  local strGuid = ""
  for index, value in ipairs(rawGuid) do
    if value < 0 then
      rawGuid[index] = rawGuid[index] + 0x100000000
    end
    strGuid = string.format("%s%08x", strGuid, rawGuid[index])
  end
  return strGuid:upper()
end

---Read file as strings
---@param path string
---@return string|nil
function ReadFileAsString(path)
  local file = io.open(path, "rb")
  if file then
    local content = file:read("*all")
    file:close()
    return content
  end
  return nil
end

---Split string by the separator.
---Returns `nil` if input is `nil` or empty.
---@param inputstr string Input string
---@param sep string? Separator character(s). Defaults to a whitespace.
---@return string[]?
function SplitString(inputstr, sep)
  if inputstr == nil then return nil end
  -- if sep is null, set it as space
  if sep == nil then
    sep = '%s'
  end
  -- define an array
  local t = {}
  -- split string based on sep
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)')
  do
    -- insert the substring in table
    table.insert(t, str)
  end
  -- return the array
  return t
end

---Attempt to load a module, otherwise returns nil.
---This method does not automatically resolve the module completion.
---You may need to set the `@type` manually.
---@param moduleName string
function RequireSafe(moduleName)
  local hasModule, module = pcall(require, moduleName)
  if hasModule then
    return module
  end
  return nil
end

---Merge two tables together, overwriting base table values with the appended table values recursively
---@param base table
---@param append table
---@return table
function MergeTable(base, append)
  for k, v in pairs(append) do
    if type(v) == "table" then
      if type(base[k] or false) == "table" then
        MergeTable(base[k] or {}, append[k] or {})
      else
        base[k] = v
      end
    else
      base[k] = v
    end
  end
  return base
end


local socket = RequireSafe("socket") ---@type Socket?
---Halts CPU operation for the given duration
---@param ms integer Duration to sleep in miliseconds
function Sleep(ms)
  if ms ~= 0 then
    if socket then
      socket.sleep(ms / 1000)
    end
  end
end

---Execute given function in the GameThread
---@param exec fun()
function ExecuteInGameThreadSync(exec)
  local wait = 0
  local isProcessing = true
  ExecuteInGameThread(function()
    exec()
    isProcessing = false
  end)

  while isProcessing and wait < 1000 do
    wait = wait + 1
    Sleep(1)
  end
end
