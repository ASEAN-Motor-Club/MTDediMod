---@meta

---@class AMaja_Light_ShortBar_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field RectLight URectLightComponent
---@field MTLightControl UMTLightControlComponent
---@field LightBar UStaticMeshComponent
---@field MTInteractable UMTInteractableComponent
---@field DefaultSceneRoot USceneComponent
local AMaja_Light_ShortBar_C = {}

function AMaja_Light_ShortBar_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AMaja_Light_ShortBar_C:ExecuteUbergraph_Maja_Light_ShortBar(EntryPoint) end


