---@meta

---@class AProxy_Light_FlatAmber2_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field RectLight URectLightComponent
---@field MTLightControl UMTLightControlComponent
---@field StaticMesh UStaticMeshComponent
---@field MTInteractable UMTInteractableComponent
---@field DefaultSceneRoot USceneComponent
---@field StrobeTimeline_LightIntensity_D96F4DD449A1EC55E975F0A8C91C00B8 float
---@field StrobeTimeline__Direction_D96F4DD449A1EC55E975F0A8C91C00B8 ETimelineDirection::Type
---@field StrobeTimeline UTimelineComponent
local AProxy_Light_FlatAmber2_C = {}

function AProxy_Light_FlatAmber2_C:StrobeTimeline__FinishedFunc() end
function AProxy_Light_FlatAmber2_C:StrobeTimeline__UpdateFunc() end
function AProxy_Light_FlatAmber2_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AProxy_Light_FlatAmber2_C:ExecuteUbergraph_Proxy_Light_FlatAmber2(EntryPoint) end


