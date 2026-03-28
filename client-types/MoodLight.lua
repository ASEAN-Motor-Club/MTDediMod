---@meta

---@class AMoodLight_C : AMTVehicleInteriorLight
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Light2 USpotLightComponent
---@field Light1 USpotLightComponent
---@field MoodLight UStaticMeshComponent
local AMoodLight_C = {}

function AMoodLight_C:ReceiveBeginPlay() end
---@param bOn boolean
function AMoodLight_C:ReceiveSetLightOn(bOn) end
---@param EntryPoint int32
function AMoodLight_C:ExecuteUbergraph_MoodLight(EntryPoint) end


