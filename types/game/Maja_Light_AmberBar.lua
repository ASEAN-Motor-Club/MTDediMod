---@meta

---@class AMaja_Light_AmberBar_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTLightControl2 UMTLightControlComponent
---@field RectLight1 URectLightComponent
---@field RectLight3 URectLightComponent
---@field RectLight4 URectLightComponent
---@field LightMesh2 UStaticMeshComponent
---@field RectLight5 URectLightComponent
---@field RectLight2 URectLightComponent
---@field RectLight URectLightComponent
---@field LightMesh1 UStaticMeshComponent
---@field MTLightControl1 UMTLightControlComponent
---@field LightBar UStaticMeshComponent
---@field MTInteractable UMTInteractableComponent
---@field DefaultSceneRoot USceneComponent
---@field Patern6_Right_11FF3D6D4A79A65812418F828DEBEEAC float
---@field Patern6_Left_11FF3D6D4A79A65812418F828DEBEEAC float
---@field Patern6__Direction_11FF3D6D4A79A65812418F828DEBEEAC ETimelineDirection::Type
---@field Patern6 UTimelineComponent
---@field Pattern5_Right_9FF565B047A0DD8A42F1DF97D64727F2 float
---@field Pattern5_Left_9FF565B047A0DD8A42F1DF97D64727F2 float
---@field Pattern5__Direction_9FF565B047A0DD8A42F1DF97D64727F2 ETimelineDirection::Type
---@field Pattern5 UTimelineComponent
---@field Pattern4_Both_7F1C61F34591D78D4A74418DA596F540 float
---@field Pattern4__Direction_7F1C61F34591D78D4A74418DA596F540 ETimelineDirection::Type
---@field Pattern4 UTimelineComponent
---@field Pattern3_Both_3319B0C8427DD640B6F87CA7B761019B float
---@field Pattern3__Direction_3319B0C8427DD640B6F87CA7B761019B ETimelineDirection::Type
---@field Pattern3 UTimelineComponent
---@field Pattern1_Right_BD50C9D54A9B1D07F7ED5688AF7F7259 float
---@field Pattern1_Left_BD50C9D54A9B1D07F7ED5688AF7F7259 float
---@field Pattern1__Direction_BD50C9D54A9B1D07F7ED5688AF7F7259 ETimelineDirection::Type
---@field Pattern1 UTimelineComponent
local AMaja_Light_AmberBar_C = {}

function AMaja_Light_AmberBar_C:Pattern1__FinishedFunc() end
function AMaja_Light_AmberBar_C:Pattern1__UpdateFunc() end
function AMaja_Light_AmberBar_C:Pattern3__FinishedFunc() end
function AMaja_Light_AmberBar_C:Pattern3__UpdateFunc() end
function AMaja_Light_AmberBar_C:Pattern4__FinishedFunc() end
function AMaja_Light_AmberBar_C:Pattern4__UpdateFunc() end
function AMaja_Light_AmberBar_C:Pattern5__FinishedFunc() end
function AMaja_Light_AmberBar_C:Pattern5__UpdateFunc() end
function AMaja_Light_AmberBar_C:Patern6__FinishedFunc() end
function AMaja_Light_AmberBar_C:Patern6__UpdateFunc() end
---@param DeltaSeconds float
function AMaja_Light_AmberBar_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AMaja_Light_AmberBar_C:ExecuteUbergraph_Maja_Light_AmberBar(EntryPoint) end


