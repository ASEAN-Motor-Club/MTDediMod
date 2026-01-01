---@meta

---@class FKantanCartesianDatapoint
---@field Coords FVector2D
local FKantanCartesianDatapoint = {}



---@class IKantanCartesianDatasourceInterface : IInterface
local IKantanCartesianDatasourceInterface = {}

---@param SeriesIdx int32
---@return FText
function IKantanCartesianDatasourceInterface:GetSeriesName(SeriesIdx) end
---@param CatIdx int32
---@return FName
function IKantanCartesianDatasourceInterface:GetSeriesId(CatIdx) end
---@param SeriesIdx int32
---@return TArray<FKantanCartesianDatapoint>
function IKantanCartesianDatasourceInterface:GetSeriesDatapoints(SeriesIdx) end
---@return int32
function IKantanCartesianDatasourceInterface:GetNumSeries() end


---@class IKantanCategoryDatasourceInterface : IInterface
local IKantanCategoryDatasourceInterface = {}

---@return int32
function IKantanCategoryDatasourceInterface:GetNumCategories() end
---@param CatIdx int32
---@return float
function IKantanCategoryDatasourceInterface:GetCategoryValue(CatIdx) end
---@param CatIdx int32
---@return FText
function IKantanCategoryDatasourceInterface:GetCategoryName(CatIdx) end
---@param CatIdx int32
---@return FName
function IKantanCategoryDatasourceInterface:GetCategoryId(CatIdx) end


---@class UKantanSimpleCartesianDatasource : UObject
local UKantanSimpleCartesianDatasource = {}

---@param MaxDatapoints int32
---@return UKantanSimpleCartesianDatasource
function UKantanSimpleCartesianDatasource:NewSimpleCartesianDatasource(MaxDatapoints) end
---@param Limit int32
function UKantanSimpleCartesianDatasource:BP_SetDatapointLimit(Limit) end
---@param ID FName
---@param bSuccess boolean
function UKantanSimpleCartesianDatasource:BP_RemoveSeries(ID, bSuccess) end
function UKantanSimpleCartesianDatasource:BP_RemoveAllSeries() end
---@param ID FName
---@param Name FText
---@param bSuccess boolean
function UKantanSimpleCartesianDatasource:BP_AddSeriesWithId(ID, Name, bSuccess) end
---@param Name FText
---@param SeriesId FName
function UKantanSimpleCartesianDatasource:BP_AddSeries(Name, SeriesId) end
---@param SeriesId FName
---@param Point FVector2D
---@param bSuccess boolean
function UKantanSimpleCartesianDatasource:BP_AddDatapoint(SeriesId, Point, bSuccess) end


---@class UKantanSimpleCategoryDatasource : UObject
local UKantanSimpleCategoryDatasource = {}

---@return UKantanSimpleCategoryDatasource
function UKantanSimpleCategoryDatasource:NewSimpleCategoryDatasource() end
---@param ID FName
---@param Value float
---@param bSuccess boolean
function UKantanSimpleCategoryDatasource:BP_UpdateCategoryValue(ID, Value, bSuccess) end
---@param ID FName
---@param bSuccess boolean
function UKantanSimpleCategoryDatasource:BP_RemoveCategory(ID, bSuccess) end
function UKantanSimpleCategoryDatasource:BP_RemoveAllCategories() end
---@param ID FName
---@param Name FText
---@param bSuccess boolean
function UKantanSimpleCategoryDatasource:BP_AddCategoryWithId(ID, Name, bSuccess) end
---@param Name FText
---@param CatId FName
function UKantanSimpleCategoryDatasource:BP_AddCategory(Name, CatId) end


