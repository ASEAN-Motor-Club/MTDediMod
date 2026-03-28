---@meta

---@class FCartesianAxisConfig
---@field Title FText
---@field Unit FText
---@field MarkerSpacing float
---@field MaxValueDigits int32
---@field LeftBottomAxis FCartesianAxisInstanceConfig
---@field RightTopAxis FCartesianAxisInstanceConfig
---@field FloatingAxis FCartesianAxisInstanceConfig
local FCartesianAxisConfig = {}



---@class FCartesianAxisInstanceConfig
---@field bEnabled boolean
---@field bShowTitle boolean
---@field bShowMarkers boolean
---@field bShowLabels boolean
local FCartesianAxisInstanceConfig = {}



---@class FCartesianAxisRange
---@field Min float
---@field Max float
local FCartesianAxisRange = {}



---@class FCartesianRangeBound
---@field Type ECartesianRangeBoundType
---@field FixedBoundValue float
local FCartesianRangeBound = {}



---@class FKantanBarChartStyle : FKantanChartStyle
---@field BarOpacity float
---@field BarOutlineOpacity float
---@field BarOutlineThickness float
local FKantanBarChartStyle = {}



---@class FKantanCartesianChartStyle : FKantanChartStyle
---@field DataOpacity float
---@field DataLineThickness float
local FKantanCartesianChartStyle = {}



---@class FKantanCartesianPlotScale
---@field Type ECartesianScalingType
---@field Scale FVector2D
---@field FocalCoordinates FVector2D
---@field RangeX FCartesianAxisRange
---@field RangeY FCartesianAxisRange
local FKantanCartesianPlotScale = {}



---@class FKantanCategoryStyle
---@field CategoryStyleId FName
---@field Color FLinearColor
local FKantanCategoryStyle = {}



---@class FKantanChartStyle : FSlateWidgetStyle
---@field Background FSlateBrush
---@field ChartLineColor FLinearColor
---@field ChartLineThickness float
---@field BaseFont FSlateFontInfo
---@field TitleFontSize int32
---@field AxisDescriptionFontSize int32
---@field AxisValueFontSize int32
---@field FontColor FLinearColor
local FKantanChartStyle = {}



---@class FKantanSeriesStyle
---@field StyleId FName
---@field PointStyle UKantanPointStyle
---@field Color FLinearColor
local FKantanSeriesStyle = {}



---@class UKantanBarChartWidgetStyle : USlateWidgetStyleContainerBase
---@field ChartStyle FKantanBarChartStyle
local UKantanBarChartWidgetStyle = {}



---@class UKantanCartesianChartWidgetStyle : USlateWidgetStyleContainerBase
---@field ChartStyle FKantanCartesianChartStyle
local UKantanCartesianChartWidgetStyle = {}



---@class UKantanCategoryStyleSet : UDataAsset
---@field Styles TArray<FKantanCategoryStyle>
local UKantanCategoryStyleSet = {}



---@class UKantanPointStyle : UDataAsset
---@field DataPointTexture UTexture2D
---@field PointSizeTextureOffsets FIntPoint
local UKantanPointStyle = {}



---@class UKantanSeriesStyleSet : UDataAsset
---@field Styles TArray<FKantanSeriesStyle>
local UKantanSeriesStyleSet = {}



