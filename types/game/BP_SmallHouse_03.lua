---@meta

---@class ABP_SmallHouse_03_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field TrashBagSpawner_04 UMTAlwaysLoadedChildActorComponent
---@field TrashBagSpawner_03 UMTAlwaysLoadedChildActorComponent
---@field POI_House1 UMTAlwaysLoadedChildActorComponent
---@field Resident1 UMTAlwaysLoadedChildActorComponent
---@field SM_Tree_Generic_Giant_01 UStaticMeshComponent
---@field SM_TrashBin_Preset_01 UStaticMeshComponent
---@field SM_TireSet_02 UStaticMeshComponent
---@field SM_Prop_Makeshift_Fence_06 UStaticMeshComponent
---@field SM_Prop_Makeshift_Fence_05 UStaticMeshComponent
---@field SM_Prop_Makeshift_Fence_04 UStaticMeshComponent
---@field SM_Prop_Makeshift_Fence_03 UStaticMeshComponent
---@field SM_Prop_Makeshift_Fence_02 UStaticMeshComponent
---@field SM_Prop_Car_Wrecked_SUV_01 UStaticMeshComponent
---@field SM_Prop_Barricade_020 UStaticMeshComponent
---@field SM_Prop_Barricade_019 UStaticMeshComponent
---@field SM_Prop_Barricade_018 UStaticMeshComponent
---@field SM_Prop_Barricade_017 UStaticMeshComponent
---@field SM_Prop_Barricade_016 UStaticMeshComponent
---@field SM_Prop_Barricade_015 UStaticMeshComponent
---@field SM_Prop_Barricade_014 UStaticMeshComponent
---@field SM_Prop_Barricade_013 UStaticMeshComponent
---@field SM_Prop_Barricade_012 UStaticMeshComponent
---@field SM_Prop_Barricade_011 UStaticMeshComponent
---@field SM_Prop_Barricade_010 UStaticMeshComponent
---@field SM_Prop_Barricade_09 UStaticMeshComponent
---@field SM_Prop_Barricade_08 UStaticMeshComponent
---@field SM_Prop_Barricade_07 UStaticMeshComponent
---@field SM_Prop_Barricade_06 UStaticMeshComponent
---@field SM_Prop_Barricade_05 UStaticMeshComponent
---@field SM_Prop_Barricade_04 UStaticMeshComponent
---@field SM_Prop_Barricade_03 UStaticMeshComponent
---@field SM_Prop_Barricade_02 UStaticMeshComponent
---@field SM_Prop_Barricade_01 UStaticMeshComponent
---@field SM_GrassPatch_01 UStaticMeshComponent
---@field Decal1 UDecalComponent
---@field Streetlamp_011 UChildActorComponent
---@field Decal UDecalComponent
---@field SM_Prop_Rubbish_Pile_04 UStaticMeshComponent
---@field SM_Prop_Rubbish_Pile_01 UStaticMeshComponent
---@field SM_Prop_Barrel_Trash_01 UStaticMeshComponent
---@field WallLight_03 UChildActorComponent
---@field SM_SmallHouse_01 UStaticMeshComponent
---@field IsTurnedOn boolean
---@field HouseMaterial TArray<UMaterialInstance>
---@field FarmMaterial TArray<UMaterialInstance>
---@field FarmGrassMaterial TArray<UMaterialInstance>
---@field ConstructionMaterial TArray<UMaterialInstance>
---@field ApocalypseMaterial TArray<UMaterialInstance>
---@field Divide double
local ABP_SmallHouse_03_C = {}

function ABP_SmallHouse_03_C:TurnMaterial() end
function ABP_SmallHouse_03_C:UserConstructionScript() end
---@param DeltaSeconds float
function ABP_SmallHouse_03_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ABP_SmallHouse_03_C:ExecuteUbergraph_BP_SmallHouse_03(EntryPoint) end


