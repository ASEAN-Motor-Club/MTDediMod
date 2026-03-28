---@meta

---@class ACityApartment_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field floor CityApartmentFloor_Enum::Type
---@field BaseDelete boolean
---@field IsCorner boolean
---@field IsBaseShop boolean
---@field CornerShopChange boolean
---@field DoorChange boolean
---@field ['Shop Base Type'] CityApartmentBaseType_Enum::Type
---@field IsStack boolean
---@field ['Stack Type'] CityApartmentType_Enum::Type
---@field ['2FType'] CityApartmentType_Enum::Type
---@field ['3FType'] CityApartmentType_Enum::Type
---@field ['4FType'] CityApartmentType_Enum::Type
---@field ['5FType'] CityApartmentType_Enum::Type
---@field ['Roof Type'] CityApartmentType_Enum::Type
---@field UseAircon boolean
---@field UseStairs boolean
---@field UseStairsSideX boolean
---@field UseStairsSideY boolean
---@field InstanceMaterial UMaterialInstance
---@field ShopMaterial UMaterialInstance
---@field DynamicMaterials TArray<UMaterialInstanceDynamic>
---@field IsTurnedOn boolean
local ACityApartment_C = {}

---@param StaticMesh UStaticMeshComponent
---@param Material UMaterialInstance
function ACityApartment_C:TurnMaterial(StaticMesh, Material) end
function ACityApartment_C:ApartmentStackType() end
function ACityApartment_C:ApartmentStairs() end
---@param Location FVector
function ACityApartment_C:ApartmentRoofType(Location) end
function ACityApartment_C:Apartment5F() end
function ACityApartment_C:Apartment4F() end
function ACityApartment_C:Apartment3F() end
function ACityApartment_C:Apartment2F() end
function ACityApartment_C:CityApartmentGenerate() end
function ACityApartment_C:UserConstructionScript() end
function ACityApartment_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function ACityApartment_C:ReceiveEndPlay(EndPlayReason) end
function ACityApartment_C:Tick() end
---@param EntryPoint int32
function ACityApartment_C:ExecuteUbergraph_CityApartment(EntryPoint) end


