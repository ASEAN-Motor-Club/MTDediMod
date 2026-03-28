---@meta

---@class ABP_SmallHouse_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field TrashBagSpawner_02 UMTAlwaysLoadedChildActorComponent
---@field TrashBagSpawner_01 UMTAlwaysLoadedChildActorComponent
---@field POI_House UMTAlwaysLoadedChildActorComponent
---@field Resident UMTAlwaysLoadedChildActorComponent
---@field Streetlamp_011 UChildActorComponent
---@field SM_fence_106a4 UStaticMeshComponent
---@field SM_fence_106a5 UStaticMeshComponent
---@field SM_fence_106a6 UStaticMeshComponent
---@field SM_fence_106a7 UStaticMeshComponent
---@field SM_fence_106a8 UStaticMeshComponent
---@field SM_fence_106a9 UStaticMeshComponent
---@field SM_fence_106a3 UStaticMeshComponent
---@field SM_fence_106a2 UStaticMeshComponent
---@field SM_fence_106a1 UStaticMeshComponent
---@field SM_fence_106a11 UStaticMeshComponent
---@field SM_fence_106a12 UStaticMeshComponent
---@field SM_fence_106a13 UStaticMeshComponent
---@field SM_fence_106a10 UStaticMeshComponent
---@field Streetlamp_012 UChildActorComponent
---@field Streetlamp_010 UChildActorComponent
---@field Streetlamp_09 UChildActorComponent
---@field Decal UDecalComponent
---@field SM_wooden_blocks UStaticMeshComponent
---@field SM_TownWarehouse_Preset_01 UStaticMeshComponent
---@field SM_TownHouse_Garage_Preset_01 UStaticMeshComponent
---@field SM_tank UStaticMeshComponent
---@field SM_Prop_Rubbish_Pile_04 UStaticMeshComponent
---@field SM_Prop_Rubbish_Pile_01 UStaticMeshComponent
---@field SM_Prop_CardboardBox_Stack_03 UStaticMeshComponent
---@field SM_Prop_Barrel_Trash_01 UStaticMeshComponent
---@field SM_fence_106a UStaticMeshComponent
---@field SM_Bld_Junk_Shelter_Preset_01 UStaticMeshComponent
---@field WallLight_03 UChildActorComponent
---@field SM_SmallHouse_01 UStaticMeshComponent
---@field IsTurnedOn boolean
---@field HouseMaterial TArray<UMaterialInstance>
---@field FarmMaterial TArray<UMaterialInstance>
---@field ConstructionMaterial TArray<UMaterialInstance>
---@field ApocalypseMaterial TArray<UMaterialInstance>
---@field Divide double
local ABP_SmallHouse_01_C = {}

function ABP_SmallHouse_01_C:TurnMaterial() end
function ABP_SmallHouse_01_C:UserConstructionScript() end
---@param DeltaSeconds float
function ABP_SmallHouse_01_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ABP_SmallHouse_01_C:ExecuteUbergraph_BP_SmallHouse_01(EntryPoint) end


