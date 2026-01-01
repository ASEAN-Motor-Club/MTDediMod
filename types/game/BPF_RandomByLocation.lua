---@meta

---@class UBPF_RandomByLocation_C : UBlueprintFunctionLibrary
local UBPF_RandomByLocation_C = {}

---@param InTarget UStaticMeshComponent
---@param InMaterialList TArray<UMaterialInstance>
---@param InDivide double
---@param __WorldContext UObject
---@param OutMaterial UMaterialInstance
UBPF_RandomByLocation_C['Set Random Material By Location'] = function(self, InTarget, InMaterialList, InDivide, __WorldContext, OutMaterial) end
---@param InChildActor UChildActorComponent
---@param InActorList TArray<TSubclassOf<AActor>>
---@param InDivide double
---@param __WorldContext UObject
UBPF_RandomByLocation_C['Set Random Child Actor Class By Location'] = function(self, InChildActor, InActorList, InDivide, __WorldContext) end


