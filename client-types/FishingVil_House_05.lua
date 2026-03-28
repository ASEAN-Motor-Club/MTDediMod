---@meta

---@class AFishingVil_House_05_C : AMTBuilding
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTInteractable UMTInteractableComponent
---@field BuildingInteraction UStaticMeshComponent
---@field ChildActor UChildActorComponent
---@field SM_HouseFloor_03 UStaticMeshComponent
---@field SM_HouseRoofEdge_01 UStaticMeshComponent
---@field SM_HouseWall_01 UStaticMeshComponent
---@field SM_HouseWindowWall_01 UStaticMeshComponent
---@field SM_HouseWall_02 UStaticMeshComponent
---@field SM_HouseWindowWall_02 UStaticMeshComponent
---@field SM_HouseRoofEdge_02 UStaticMeshComponent
---@field SM_HouseWall_04 UStaticMeshComponent
---@field SM_HouseWindowWall_03 UStaticMeshComponent
---@field SM_HouseWindowWall_04 UStaticMeshComponent
---@field SM_HouseWindowWall_05 UStaticMeshComponent
---@field SM_HouseWall_03 UStaticMeshComponent
---@field SM_HousePillar_02 UStaticMeshComponent
---@field SM_HousePillar_01 UStaticMeshComponent
---@field SM_HouseStairs_01 UStaticMeshComponent
---@field SM_HouseFloor_02 UStaticMeshComponent
---@field SM_HouseDoorWall_01 UStaticMeshComponent
---@field SM_HouseFloor_01 UStaticMeshComponent
---@field SM_HouseWindowWall_06 UStaticMeshComponent
---@field WallLight_03 UChildActorComponent
---@field SM_HousePillar_03 UStaticMeshComponent
---@field SM_HousePillar_04 UStaticMeshComponent
---@field SM_HousePillar_05 UStaticMeshComponent
---@field SM_HousePillar_06 UStaticMeshComponent
---@field SM_HousePillar_07 UStaticMeshComponent
---@field SM_HousePillar_08 UStaticMeshComponent
---@field SM_HouseWall_05 UStaticMeshComponent
---@field Scene USceneComponent
---@field HouseMaterial UMaterialInstance
---@field GlassMaterial UMaterialInstance
---@field UseableDoor boolean
---@field IsTurnedOn boolean
local AFishingVil_House_05_C = {}

function AFishingVil_House_05_C:TurnMaterial() end
AFishingVil_House_05_C['Fishing Vil House'] = function(self, ) end
function AFishingVil_House_05_C:UserConstructionScript() end
---@param DeltaSeconds float
function AFishingVil_House_05_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AFishingVil_House_05_C:ExecuteUbergraph_FishingVil_House_05(EntryPoint) end


