---@meta

---@class ASmallHouse_02_C : AMTBuilding
---@field UberGraphFrame FPointerToUberGraphFrame
---@field ChildActor1 UChildActorComponent
---@field ChildActor UChildActorComponent
---@field MTInteractable UMTInteractableComponent
---@field BuildingInteraction UStaticMeshComponent
---@field SM_Pipe_04 UStaticMeshComponent
---@field SM_airCondition_01 UStaticMeshComponent
---@field SM_airCondition_02 UStaticMeshComponent
---@field SM_Pipe_03 UStaticMeshComponent
---@field SM_Townhouse_OutFence_08 UStaticMeshComponent
---@field SM_Townhouse_OutFence_07 UStaticMeshComponent
---@field SM_TownHouse_Floor_02 UStaticMeshComponent
---@field SM_Townhouse_OutStairs_02 UStaticMeshComponent
---@field WallLight_04 UChildActorComponent
---@field SM_TownHouse_Wall_05 UStaticMeshComponent
---@field SM_TownHouse_Wall_04 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_01 UStaticMeshComponent
---@field SM_TownHouse_Wall_01 UStaticMeshComponent
---@field SM_TownHouse_DoorWall_02 UStaticMeshComponent
---@field SM_TownHouse_Wall_03 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_06 UStaticMeshComponent
---@field SM_Townhouse_OutFence_06 UStaticMeshComponent
---@field SM_Townhouse_OutFence_05 UStaticMeshComponent
---@field SM_Townhouse_OutFence_04 UStaticMeshComponent
---@field SM_Townhouse_OutFence_03 UStaticMeshComponent
---@field SM_TownHouse_OutFence_02 UStaticMeshComponent
---@field SM_TownHouse_OutFence_01 UStaticMeshComponent
---@field SM_TownHouse_Floor_014 UStaticMeshComponent
---@field SM_TownHouse_Floor_012 UStaticMeshComponent
---@field SM_TownHouse_Wall_02 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_010 UStaticMeshComponent
---@field WallLight_03 UChildActorComponent
---@field SM_Townhouse_Roof_010 UStaticMeshComponent
---@field SM_Townhouse_Roof_09 UStaticMeshComponent
---@field SM_Townhouse_Roof_08 UStaticMeshComponent
---@field SM_Townhouse_Roof_07 UStaticMeshComponent
---@field SM_Townhouse_Roof_06 UStaticMeshComponent
---@field SM_Townhouse_Roof_05 UStaticMeshComponent
---@field SM_Townhouse_Roof_04 UStaticMeshComponent
---@field SM_Townhouse_Roof_03 UStaticMeshComponent
---@field SM_TownHouse_Pillar_07 UStaticMeshComponent
---@field SM_Townhouse_OutStairs_01 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_05 UStaticMeshComponent
---@field SM_TownHouse_Wall_011 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_03 UStaticMeshComponent
---@field SM_TownHouse_Pillar_04 UStaticMeshComponent
---@field SM_TownHouse_DoorWall_01 UStaticMeshComponent
---@field SM_TownHouse_Pillar_05 UStaticMeshComponent
---@field SM_TownHouse_Pillar_01 UStaticMeshComponent
---@field SM_TownHouse_Wall_08 UStaticMeshComponent
---@field SM_TownHouse_Floor_03 UStaticMeshComponent
---@field SM_TownHouse_Floor_015 UStaticMeshComponent
---@field SM_TownHouse_Floor_013 UStaticMeshComponent
---@field SM_TownHouse_Floor_01 UStaticMeshComponent
---@field HouseMaterial UMaterialInstance
---@field GlassMaterial UMaterialInstance
---@field IsTurnedOn boolean
local ASmallHouse_02_C = {}

function ASmallHouse_02_C:TurnMaterial() end
ASmallHouse_02_C['Town House'] = function(self, ) end
function ASmallHouse_02_C:UserConstructionScript() end
---@param DeltaSeconds float
function ASmallHouse_02_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ASmallHouse_02_C:ExecuteUbergraph_SmallHouse_02(EntryPoint) end


