---@meta

---@class FCategoryStyleManualMapping
---@field CategoryId FName
---@field Style FKantanCategoryStyle
local FCategoryStyleManualMapping = {}



---@class FSeriesStyleManualMapping
---@field SeriesId FName
---@field Style FKantanSeriesStyle
local FSeriesStyleManualMapping = {}



---@class UBarChart : UKantanBarChartBase
---@field DataSource UObject
local UBarChart = {}

---@param InDatasource UObject
---@return boolean
function UBarChart:SetDatasource(InDatasource) end


---@class UCartesianPlot : UKantanCartesianPlotBase
---@field DataSource UObject
local UCartesianPlot = {}

---@param InDatasource UObject
---@return boolean
function UCartesianPlot:SetDatasource(InDatasource) end


---@class UKantanBarChartBase : UKantanCategoryChart
---@field WidgetStyle FKantanBarChartStyle
---@field Orientation EKantanBarChartOrientation
---@field MaxBarValue float
---@field LabelPosition EKantanBarLabelPosition
---@field BarToGapRatio float
---@field ValueExtentsDisplay EKantanBarValueExtents
---@field ValueAxisCfg FCartesianAxisConfig
local UKantanBarChartBase = {}

---@param InCfg FCartesianAxisConfig
function UKantanBarChartBase:SetValueAxisConfig(InCfg) end
---@param InOrientation EKantanBarChartOrientation
function UKantanBarChartBase:SetOrientation(InOrientation) end
---@param InMaxValue float
function UKantanBarChartBase:SetMaxBarValue(InMaxValue) end
---@param InPosition EKantanBarLabelPosition
function UKantanBarChartBase:SetLabelPosition(InPosition) end
---@param InExtents EKantanBarValueExtents
function UKantanBarChartBase:SetExtentsDisplay(InExtents) end
---@param InRatio float
function UKantanBarChartBase:SetBarToGapRatio(InRatio) end


---@class UKantanCartesianChartBase : UKantanChart
---@field WidgetStyle FKantanCartesianChartStyle
---@field PlotScale FKantanCartesianPlotScale
---@field DataPointSize EKantanDataPointSize
---@field XAxisCfg FCartesianAxisConfig
---@field YAxisCfg FCartesianAxisConfig
---@field AxisTitlePadding FMargin
---@field SeriesStyleSet UKantanSeriesStyleSet
---@field ManualStyleMappings TArray<FSeriesStyleManualMapping>
---@field bAntiAlias boolean
local UKantanCartesianChartBase = {}

---@param InCfg FCartesianAxisConfig
function UKantanCartesianChartBase:SetYAxisConfig(InCfg) end
---@param InCfg FCartesianAxisConfig
function UKantanCartesianChartBase:SetXAxisConfig(InCfg) end
---@param InRangeX FCartesianAxisRange
---@param InRangeY FCartesianAxisRange
function UKantanCartesianChartBase:SetPlotScaleByRange(InRangeX, InRangeY) end
---@param InScale FVector2D
---@param InFocalCoords FVector2D
function UKantanCartesianChartBase:SetPlotScale(InScale, InFocalCoords) end
---@param InSize EKantanDataPointSize
function UKantanCartesianChartBase:SetDataPointSize(InSize) end
---@param InPadding FMargin
function UKantanCartesianChartBase:SetAxisTitlePadding(InPadding) end
---@param ID FName
---@param bEnable boolean
function UKantanCartesianChartBase:EnableSeries(ID, bEnable) end
---@param ID FName
---@param bDrawPoints boolean
---@param bDrawLines boolean
function UKantanCartesianChartBase:ConfigureSeries(ID, bDrawPoints, bDrawLines) end
---@param SeriesId FName
---@param PointStyle UKantanPointStyle
---@param Color FLinearColor
function UKantanCartesianChartBase:AddSeriesStyleOverride(SeriesId, PointStyle, Color) end


---@class UKantanCartesianPlotBase : UKantanCartesianChartBase
local UKantanCartesianPlotBase = {}


---@class UKantanCategoryChart : UKantanChart
---@field bAutoPerCategoryStyles boolean
---@field CategoryStyleSet UKantanCategoryStyleSet
---@field ManualStyleMappings TArray<FCategoryStyleManualMapping>
local UKantanCategoryChart = {}

---@param CategoryId FName
---@param Color FLinearColor
function UKantanCategoryChart:AddCategoryStyleOverride(CategoryId, Color) end


---@class UKantanChart : UWidget
---@field Margins FMargin
---@field ChartTitle FText
---@field TitlePadding FMargin
---@field UpdateTickRate float
local UKantanChart = {}

---@param InRate float
function UKantanChart:SetUpdateTickRate(InRate) end
---@param InMargins FMargin
function UKantanChart:SetMargins(InMargins) end
---@param InPadding FMargin
function UKantanChart:SetChartTitlePadding(InPadding) end
---@param InTitle FText
function UKantanChart:SetChartTitle(InTitle) end


---@class UKantanChartLegend : UWidget
---@field Margins FMargin
---@field SeriesPadding FMargin
---@field Background FSlateBrush
---@field FontSize int32
---@field Chart TWeakObjectPtr<UKantanCartesianChartBase>
local UKantanChartLegend = {}

---@param InPadding FMargin
function UKantanChartLegend:SetSeriesPadding(InPadding) end
---@param InMargins FMargin
function UKantanChartLegend:SetMargins(InMargins) end
---@param InFontSize int32
function UKantanChartLegend:SetFontSize(InFontSize) end
---@param InChart UKantanCartesianChartBase
function UKantanChartLegend:SetChart(InChart) end
---@param InBrush FSlateBrush
function UKantanChartLegend:SetBackground(InBrush) end


---@class UKantanTimeSeriesPlotBase : UKantanCartesianChartBase
---@field bUseFixedTimeRange boolean
---@field DisplayTimeRange float
---@field LowerTimeBound FCartesianRangeBound
---@field UpperTimeBound FCartesianRangeBound
---@field LowerValueBound FCartesianRangeBound
---@field UpperValueBound FCartesianRangeBound
---@field bExtendValueRangeToZero boolean
local UKantanTimeSeriesPlotBase = {}

---@param InUpperBound FCartesianRangeBound
function UKantanTimeSeriesPlotBase:SetUpperValueBound(InUpperBound) end
---@param InUpperBound FCartesianRangeBound
function UKantanTimeSeriesPlotBase:SetUpperTimeBound(InUpperBound) end
---@param InLowerBound FCartesianRangeBound
function UKantanTimeSeriesPlotBase:SetLowerValueBound(InLowerBound) end
---@param InLowerBound FCartesianRangeBound
function UKantanTimeSeriesPlotBase:SetLowerTimeBound(InLowerBound) end


---@class USimpleBarChart : UKantanBarChartBase
local USimpleBarChart = {}

---@param ID FName
---@param Value float
---@param bSuccess boolean
function USimpleBarChart:BP_UpdateCategoryValue(ID, Value, bSuccess) end
---@param ID FName
---@param bSuccess boolean
function USimpleBarChart:BP_RemoveCategory(ID, bSuccess) end
function USimpleBarChart:BP_RemoveAllCategories() end
---@param ID FName
---@param Name FText
---@param bSuccess boolean
function USimpleBarChart:BP_AddCategoryWithId(ID, Name, bSuccess) end
---@param Name FText
---@param CatId FName
function USimpleBarChart:BP_AddCategory(Name, CatId) end


---@class USimpleCartesianPlot : UKantanCartesianPlotBase
local USimpleCartesianPlot = {}

---@param ID FName
---@param bSuccess boolean
function USimpleCartesianPlot:BP_RemoveSeries(ID, bSuccess) end
function USimpleCartesianPlot:BP_RemoveAllSeries() end
---@param bSuccess boolean
---@param ID FName
---@param Name FText
---@param bEnabled boolean
---@param bShowPoints boolean
---@param bShowLines boolean
function USimpleCartesianPlot:BP_AddSeriesWithId(bSuccess, ID, Name, bEnabled, bShowPoints, bShowLines) end
---@param SeriesId FName
---@param Name FText
---@param bEnabled boolean
---@param bShowPoints boolean
---@param bShowLines boolean
function USimpleCartesianPlot:BP_AddSeries(SeriesId, Name, bEnabled, bShowPoints, bShowLines) end
---@param SeriesId FName
---@param Point FVector2D
---@param bSuccess boolean
function USimpleCartesianPlot:BP_AddDatapoint(SeriesId, Point, bSuccess) end


---@class USimpleTimeSeriesPlot : UKantanTimeSeriesPlotBase
local USimpleTimeSeriesPlot = {}

---@param ID FName
---@param bSuccess boolean
function USimpleTimeSeriesPlot:BP_RemoveSeries(ID, bSuccess) end
function USimpleTimeSeriesPlot:BP_RemoveAllSeries() end
---@param bSuccess boolean
---@param ID FName
---@param Name FText
---@param bEnabled boolean
---@param bShowPoints boolean
---@param bShowLines boolean
function USimpleTimeSeriesPlot:BP_AddSeriesWithId(bSuccess, ID, Name, bEnabled, bShowPoints, bShowLines) end
---@param SeriesId FName
---@param Name FText
---@param bEnabled boolean
---@param bShowPoints boolean
---@param bShowLines boolean
function USimpleTimeSeriesPlot:BP_AddSeries(SeriesId, Name, bEnabled, bShowPoints, bShowLines) end
---@param SeriesId FName
---@param Value float
---@param bSuccess boolean
function USimpleTimeSeriesPlot:BP_AddDatapointNow(SeriesId, Value, bSuccess) end
---@param SeriesId FName
---@param Point FVector2D
---@param bSuccess boolean
function USimpleTimeSeriesPlot:BP_AddDatapoint(SeriesId, Point, bSuccess) end


---@class UTimeSeriesPlot : UKantanTimeSeriesPlotBase
---@field DataSource UObject
local UTimeSeriesPlot = {}

---@param InDatasource UObject
---@return boolean
function UTimeSeriesPlot:SetDatasource(InDatasource) end


