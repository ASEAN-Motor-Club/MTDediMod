---@meta

---@class ABP_FishingVil_House_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field WallLight_03 UChildActorComponent
---@field SM_HouseRoofEdge_02 UStaticMeshComponent
---@field SM_HouseRoofEdge_01 UStaticMeshComponent
---@field SM_HouseRoof_02 UStaticMeshComponent
---@field SM_HouseRoof_01 UStaticMeshComponent
---@field SM_HouseWall_08 UStaticMeshComponent
---@field SM_HouseWall_07 UStaticMeshComponent
---@field SM_HouseWall_06 UStaticMeshComponent
---@field SM_HouseWall_05 UStaticMeshComponent
---@field SM_HouseWall_04 UStaticMeshComponent
---@field SM_HouseDoor_01 UStaticMeshComponent
---@field SM_HousePillar_04 UStaticMeshComponent
---@field SM_HouseDoorWall_01 UStaticMeshComponent
---@field SM_HousePillar_02 UStaticMeshComponent
---@field SM_HousePillar_01 UStaticMeshComponent
---@field SM_HouseFloor_04 UStaticMeshComponent
---@field SM_HouseFloor_02 UStaticMeshComponent
---@field SM_HouseFloor_03 UStaticMeshComponent
---@field SM_HouseFloor_01 UStaticMeshComponent
---@field SM_HouseStairs_01 UStaticMeshComponent
---@field SM_HouseWall_03 UStaticMeshComponent
---@field SM_HouseWindowWall_07 UStaticMeshComponent
---@field SM_HouseWall_02 UStaticMeshComponent
---@field SM_HouseWall_01 UStaticMeshComponent
---@field SM_HouseWindowWall_06 UStaticMeshComponent
---@field SM_HouseWindowWall_05 UStaticMeshComponent
---@field SM_HouseWindowWall_04 UStaticMeshComponent
---@field SM_HouseWindowWall_03 UStaticMeshComponent
---@field SM_HouseWindowWall_02 UStaticMeshComponent
---@field SM_HouseWindowWall_01 UStaticMeshComponent
---@field SM_HousePillar_03 UStaticMeshComponent
---@field HouseMaterial UMaterialInstance
---@field GlassMaterial UMaterialInstance
---@field UseableDoor boolean
---@field IsTurnedOn boolean
local ABP_FishingVil_House_01_C = {}

function ABP_FishingVil_House_01_C:TurnMaterial() end
ABP_FishingVil_House_01_C['Fishing Vil House'] = function(self, ) end
function ABP_FishingVil_House_01_C:UserConstructionScript() end
---@param DeltaSeconds float
function ABP_FishingVil_House_01_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ABP_FishingVil_House_01_C:ExecuteUbergraph_BP_FishingVil_House_01(EntryPoint) end


