---@meta

---@class AMaja_RoofRack_Bike_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTInteractable UMTInteractableComponent
---@field MTLightControl UMTLightControlComponent
---@field RoofRackHolderArmF UStaticMeshComponent
---@field RoofRackBike UStaticMeshComponent
---@field MountCol UBoxComponent
---@field RoofRackHolderArmU UStaticMeshComponent
---@field RoofRackBottom UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
local AMaja_RoofRack_Bike_C = {}

---@param DeltaSeconds float
function AMaja_RoofRack_Bike_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AMaja_RoofRack_Bike_C:ExecuteUbergraph_Maja_RoofRack_Bike(EntryPoint) end


