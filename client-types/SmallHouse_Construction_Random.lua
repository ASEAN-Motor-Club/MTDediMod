---@meta

---@class ASmallHouse_Construction_Random_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field ChildActor UChildActorComponent
---@field SmallHouseType TArray<TSubclassOf<AActor>>
---@field Divide double
local ASmallHouse_Construction_Random_C = {}

function ASmallHouse_Construction_Random_C:RandomGeneration() end
function ASmallHouse_Construction_Random_C:UserConstructionScript() end
function ASmallHouse_Construction_Random_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function ASmallHouse_Construction_Random_C:ExecuteUbergraph_SmallHouse_Construction_Random(EntryPoint) end


