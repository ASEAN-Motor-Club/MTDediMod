---@meta

---@class ABP_SmallHouse_02_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field POI_House1 UMTAlwaysLoadedChildActorComponent
---@field TrashBagSpawner_03 UMTAlwaysLoadedChildActorComponent
---@field TrashBagSpawner_04 UMTAlwaysLoadedChildActorComponent
---@field Resident UMTAlwaysLoadedChildActorComponent
---@field BP_Farm_01 UChildActorComponent
---@field Decal1 UDecalComponent
---@field Streetlamp_011 UChildActorComponent
---@field Streetlamp_010 UChildActorComponent
---@field Decal UDecalComponent
---@field SM_TownWarehouse_Preset_01 UStaticMeshComponent
---@field SM_Prop_Rubbish_Pile_01 UStaticMeshComponent
---@field SM_Prop_CardboardBox_Stack_03 UStaticMeshComponent
---@field SM_Prop_Barrel_Trash_01 UStaticMeshComponent
---@field SM_Bld_Junk_Shelter_Preset_01 UStaticMeshComponent
---@field WallLight_03 UChildActorComponent
---@field SM_SmallHouse_01 UStaticMeshComponent
---@field IsTurnedOn boolean
---@field HouseMaterial TArray<UMaterialInstance>
---@field FarmMaterial TArray<UMaterialInstance>
---@field ConstructionMaterial TArray<UMaterialInstance>
---@field ApocalypseMaterial TArray<UMaterialInstance>
---@field Divide double
local ABP_SmallHouse_02_C = {}

function ABP_SmallHouse_02_C:TurnMaterial() end
function ABP_SmallHouse_02_C:UserConstructionScript() end
---@param DeltaSeconds float
function ABP_SmallHouse_02_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ABP_SmallHouse_02_C:ExecuteUbergraph_BP_SmallHouse_02(EntryPoint) end


