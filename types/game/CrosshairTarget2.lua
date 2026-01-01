---@meta

---@class ACrosshairTarget2_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Marker1 UStaticMeshComponent
---@field Scene1 USceneComponent
---@field Scene USceneComponent
---@field Marker UStaticMeshComponent
local ACrosshairTarget2_C = {}

function ACrosshairTarget2_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function ACrosshairTarget2_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ACrosshairTarget2_C:ExecuteUbergraph_CrosshairTarget2(EntryPoint) end


