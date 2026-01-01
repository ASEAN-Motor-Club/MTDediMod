---@meta

---@class ANeutz_Eyes_Truck_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Eyes7 UStaticMeshComponent
---@field Eyes8 UStaticMeshComponent
---@field Eyes9 UStaticMeshComponent
---@field Eyes10 UStaticMeshComponent
---@field Eyes2 UStaticMeshComponent
---@field Eyes5 UStaticMeshComponent
---@field Eyes4 UStaticMeshComponent
---@field Eyes3 UStaticMeshComponent
---@field Eyes6 UStaticMeshComponent
---@field Eyes1 UStaticMeshComponent
---@field MTLightControl UMTLightControlComponent
---@field MTInteractable UMTInteractableComponent
---@field StaticMesh UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
local ANeutz_Eyes_Truck_C = {}

---@param DeltaSeconds float
function ANeutz_Eyes_Truck_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ANeutz_Eyes_Truck_C:ExecuteUbergraph_Neutz_Eyes_Truck(EntryPoint) end


