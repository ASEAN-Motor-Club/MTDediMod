---@meta

---@class AProxy_Light_FlatAmber_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field RectLight URectLightComponent
---@field MTLightControl UMTLightControlComponent
---@field StaticMesh UStaticMeshComponent
---@field MTInteractable UMTInteractableComponent
---@field DefaultSceneRoot USceneComponent
---@field StrobeTimeLine_LightIntensity_3758F03E4013DEE7C38798AB03696F80 float
---@field StrobeTimeLine__Direction_3758F03E4013DEE7C38798AB03696F80 ETimelineDirection::Type
---@field StrobeTimeline UTimelineComponent
local AProxy_Light_FlatAmber_C = {}

function AProxy_Light_FlatAmber_C:StrobeTimeline__FinishedFunc() end
function AProxy_Light_FlatAmber_C:StrobeTimeline__UpdateFunc() end
function AProxy_Light_FlatAmber_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AProxy_Light_FlatAmber_C:ExecuteUbergraph_Proxy_Light_FlatAmber(EntryPoint) end


