---@meta

---@class ACityOffice_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field CityOfficeType CityOffice_Enum::Type
---@field DynamicMaterials_Blue TArray<UMaterialInstanceDynamic>
---@field DynamicMaterials_Yellow TArray<UMaterialInstanceDynamic>
---@field IsTurnedOn boolean
local ACityOffice_C = {}

---@param StaticMesh UStaticMeshComponent
---@param Material UMaterialInstance
function ACityOffice_C:TurnMaterial_Yellow(StaticMesh, Material) end
---@param StaticMesh UStaticMeshComponent
---@param Material UMaterialInstance
function ACityOffice_C:TurnMaterial_Blue(StaticMesh, Material) end
function ACityOffice_C:CityOfficeGenerate() end
function ACityOffice_C:UserConstructionScript() end
---@param DeltaSeconds float
function ACityOffice_C:ReceiveTick(DeltaSeconds) end
function ACityOffice_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function ACityOffice_C:ExecuteUbergraph_CityOffice(EntryPoint) end


