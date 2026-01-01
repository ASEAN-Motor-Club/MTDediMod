---@meta

---@class ASmallHouse_01_C : AMTBuilding
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTInteractable UMTInteractableComponent
---@field BuildingInteraction UStaticMeshComponent
---@field SM_TownHouse_Floor_01 UStaticMeshComponent
---@field SM_Townhouse_Roof_03 UStaticMeshComponent
---@field SM_TownHouse_Pillar_01 UStaticMeshComponent
---@field SM_TownHouse_Floor_012 UStaticMeshComponent
---@field Scene USceneComponent
---@field ChildActor UChildActorComponent
---@field SM_Prop_SatDish_01 UStaticMeshComponent
---@field SM_TownHouse_Chimney_03 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_08 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_09 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_010 UStaticMeshComponent
---@field SM_TownHouse_Floor_03 UStaticMeshComponent
---@field SM_TownHouse_Floor_02 UStaticMeshComponent
---@field SM_Townhouse_OutStairs_01 UStaticMeshComponent
---@field SM_TownHouse_Floor_014 UStaticMeshComponent
---@field SM_Townhouse_OutFence_06 UStaticMeshComponent
---@field SM_Townhouse_OutFence_05 UStaticMeshComponent
---@field SM_Townhouse_OutFence_03 UStaticMeshComponent
---@field SM_TownHouse_OutFence_02 UStaticMeshComponent
---@field SM_TownHouse_OutFence_01 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_07 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_02 UStaticMeshComponent
---@field SM_airCondition_02 UStaticMeshComponent
---@field SM_TownHouse_Wall_01 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_06 UStaticMeshComponent
---@field SM_TownHouse_Wall_02 UStaticMeshComponent
---@field WallLight_03 UChildActorComponent
---@field SM_Townhouse_Roof_010 UStaticMeshComponent
---@field SM_Townhouse_Roof_09 UStaticMeshComponent
---@field SM_Townhouse_Roof_08 UStaticMeshComponent
---@field SM_Townhouse_Roof_07 UStaticMeshComponent
---@field SM_Townhouse_Roof_05 UStaticMeshComponent
---@field SM_TownHouse_Pillar_07 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_05 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_03 UStaticMeshComponent
---@field SM_TownHouse_Pillar_04 UStaticMeshComponent
---@field SM_TownHouse_DoorWall_01 UStaticMeshComponent
---@field SM_TownHouse_Pillar_05 UStaticMeshComponent
---@field SM_TownHouse_Floor_015 UStaticMeshComponent
---@field HouseMaterial UMaterialInstance
---@field GlassMaterial UMaterialInstance
---@field UseableDoor boolean
---@field IsTurnedOn boolean
local ASmallHouse_01_C = {}

function ASmallHouse_01_C:TurnMaterial() end
ASmallHouse_01_C['Apply Material'] = function(self, ) end
function ASmallHouse_01_C:UserConstructionScript() end
---@param DeltaSeconds float
function ASmallHouse_01_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ASmallHouse_01_C:ExecuteUbergraph_SmallHouse_01(EntryPoint) end


