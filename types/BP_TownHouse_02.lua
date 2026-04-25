---@meta

---@class ABP_TownHouse_02_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_ChristmasDeco_Light_09 UStaticMeshComponent
---@field SM_ChristmasDeco_Light_08 UStaticMeshComponent
---@field SM_ChristmasDeco_Light_07 UStaticMeshComponent
---@field SM_ChristmasDeco_Light_06 UStaticMeshComponent
---@field SM_ChristmasDeco_Light_04 UStaticMeshComponent
---@field SM_ChristmasDeco_Light_05 UStaticMeshComponent
---@field SM_ChristmasDeco_Light_03 UStaticMeshComponent
---@field SM_ChristmasDeco_Light_02 UStaticMeshComponent
---@field SM_ChristmasDeco_Wreath_02 UStaticMeshComponent
---@field SM_TownHouse_Chimney_04 UStaticMeshComponent
---@field WallLight_03 UChildActorComponent
---@field SM_Townhouse_Roof_010 UStaticMeshComponent
---@field SM_Townhouse_Roof_09 UStaticMeshComponent
---@field SM_Townhouse_Roof_08 UStaticMeshComponent
---@field SM_Townhouse_Roof_07 UStaticMeshComponent
---@field SM_Townhouse_Roof_06 UStaticMeshComponent
---@field SM_Townhouse_Roof_05 UStaticMeshComponent
---@field SM_Townhouse_Roof_04 UStaticMeshComponent
---@field SM_Townhouse_Roof_03 UStaticMeshComponent
---@field SM_TownHouse_Floor_04 UStaticMeshComponent
---@field SM_TownHouse_Floor_011 UStaticMeshComponent
---@field SM_TownHouse_Floor_010 UStaticMeshComponent
---@field SM_TownHouse_Floor_09 UStaticMeshComponent
---@field SM_TownHouse_Floor_08 UStaticMeshComponent
---@field SM_TownHouse_Floor_07 UStaticMeshComponent
---@field SM_TownHouse_Floor_06 UStaticMeshComponent
---@field SM_TownHouse_Floor_05 UStaticMeshComponent
---@field SM_TownHouse_Floor_02 UStaticMeshComponent
---@field SM_TownHouse_Wall_010 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_06 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_09 UStaticMeshComponent
---@field SM_TownHouse_Wall_012 UStaticMeshComponent
---@field SM_TownHouse_Pillar_07 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_08 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_07 UStaticMeshComponent
---@field SM_Townhouse_OutStairs_01 UStaticMeshComponent
---@field SM_TownHouse_Wall_02 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_05 UStaticMeshComponent
---@field SM_TownHouse_Wall_011 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_04 UStaticMeshComponent
---@field SM_TownHouse_Wall_09 UStaticMeshComponent
---@field SM_TownHouse_WindowWall_03 UStaticMeshComponent
---@field SM_TownHouse_Pillar_04 UStaticMeshComponent
---@field SM_TownHouse_DoorWall_01 UStaticMeshComponent
---@field SM_TownHouse_Pillar_05 UStaticMeshComponent
---@field SM_TownHouse_Pillar_01 UStaticMeshComponent
---@field SM_TownHouse_Wall_08 UStaticMeshComponent
---@field SM_TownHouse_Floor_03 UStaticMeshComponent
---@field SM_TownHouse_Floor_015 UStaticMeshComponent
---@field SM_TownHouse_Floor_013 UStaticMeshComponent
---@field SM_Townhouse_Door_01 UStaticMeshComponent
---@field SM_TownHouse_Floor_01 UStaticMeshComponent
---@field HouseMaterial UMaterialInstance
---@field GlassMaterial UMaterialInstance
---@field UseableDoor boolean
---@field IsTurnedOn boolean
---@field IsChristmas boolean
local ABP_TownHouse_02_C = {}

function ABP_TownHouse_02_C:TurnMaterial() end
ABP_TownHouse_02_C['Town House'] = function(self, ) end
function ABP_TownHouse_02_C:UserConstructionScript() end
---@param DeltaSeconds float
function ABP_TownHouse_02_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ABP_TownHouse_02_C:ExecuteUbergraph_BP_TownHouse_02(EntryPoint) end


