---@meta

---@class AFishingVil_House_03A_C : AMTBuilding
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_HouseWindowWall_04 UStaticMeshComponent
---@field SM_HouseWall_04 UStaticMeshComponent
---@field SM_HouseDoorWall_02 UStaticMeshComponent
---@field SM_HouseFloor_04 UStaticMeshComponent
---@field ChildActor1 UChildActorComponent
---@field SM_HouseRoof_01 UStaticMeshComponent
---@field ChildActor UChildActorComponent
---@field SM_HouseRoofEdge_01 UStaticMeshComponent
---@field SM_HouseRoofEdge_02 UStaticMeshComponent
---@field SM_HouseWall_05 UStaticMeshComponent
---@field SM_HouseWall_03 UStaticMeshComponent
---@field SM_HouseWindowWall_03 UStaticMeshComponent
---@field SM_HouseWindowWall_05 UStaticMeshComponent
---@field SM_HouseWall_02 UStaticMeshComponent
---@field SM_HouseWall_01 UStaticMeshComponent
---@field SM_HouseRoof_02 UStaticMeshComponent
---@field SM_HouseWall_07 UStaticMeshComponent
---@field WallLight_04 UChildActorComponent
---@field SM_HouseFloor_03 UStaticMeshComponent
---@field SM_HouseWindowWall_01 UStaticMeshComponent
---@field SM_HouseFloor_02 UStaticMeshComponent
---@field WallLight_03 UChildActorComponent
---@field SM_HouseWall_08 UStaticMeshComponent
---@field SM_HouseWindowWall_02 UStaticMeshComponent
---@field SM_HouseWall_09 UStaticMeshComponent
---@field SM_HousePillar_02 UStaticMeshComponent
---@field SM_HousePillar_01 UStaticMeshComponent
---@field SM_HouseDoorWall_01 UStaticMeshComponent
---@field SM_HousePillar_03 UStaticMeshComponent
---@field SM_HousePillar_04 UStaticMeshComponent
---@field SM_HouseStairs_01 UStaticMeshComponent
---@field SM_HouseWall_06 UStaticMeshComponent
---@field SM_HouseFloor_01 UStaticMeshComponent
---@field BuildingInteraction UStaticMeshComponent
---@field MTInteractable UMTInteractableComponent
---@field SM_HouseEnterance_01 UStaticMeshComponent
---@field Scene USceneComponent
---@field HouseMaterial UMaterialInstance
---@field GlassMaterial UMaterialInstance
---@field UseableDoor boolean
---@field IsTurnedOn boolean
local AFishingVil_House_03A_C = {}

function AFishingVil_House_03A_C:TurnMaterial() end
AFishingVil_House_03A_C['Fishing Vil House'] = function(self, ) end
function AFishingVil_House_03A_C:UserConstructionScript() end
---@param DeltaSeconds float
function AFishingVil_House_03A_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AFishingVil_House_03A_C:ExecuteUbergraph_FishingVil_House_03A(EntryPoint) end


