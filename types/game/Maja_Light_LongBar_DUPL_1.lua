---@meta

---@class AMaja_Light_LongBar_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field RectLight URectLightComponent
---@field MTLightControl UMTLightControlComponent
---@field LightBar UStaticMeshComponent
---@field MTInteractable UMTInteractableComponent
---@field DefaultSceneRoot USceneComponent
local AMaja_Light_LongBar_C = {}

function AMaja_Light_LongBar_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AMaja_Light_LongBar_C:ExecuteUbergraph_Maja_Light_LongBar(EntryPoint) end


