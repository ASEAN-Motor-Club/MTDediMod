---@meta

---@class FALoadingScreenSettings
---@field MinimumLoadingScreenDisplayTime float
---@field bAutoCompleteWhenLoadingCompletes boolean
---@field bMoviesAreSkippable boolean
---@field bWaitForManualStop boolean
---@field bAllowInEarlyStartup boolean
---@field bAllowEngineTick boolean
---@field PlaybackType EMoviePlaybackType
---@field MoviePaths TArray<FString>
---@field bShuffle boolean
---@field bSetDisplayMovieIndexManually boolean
---@field bShowWidgetOverlay boolean
---@field bShowLoadingCompleteText boolean
---@field LoadingCompleteTextSettings FLoadingCompleteTextSettings
---@field Background FBackgroundSettings
---@field TipWidget FTipSettings
---@field LoadingWidget FLoadingWidgetSettings
---@field Layout EAsyncLoadingScreenLayout
local FALoadingScreenSettings = {}



---@class FBackgroundSettings
---@field Images TArray<FSoftObjectPath>
---@field ImageStretch EStretch::Type
---@field Padding FMargin
---@field BackgroundColor FLinearColor
---@field bSetDisplayBackgroundManually boolean
local FBackgroundSettings = {}



---@class FCenterLayoutSettings
---@field bIsTipAtBottom boolean
---@field TipAlignment FWidgetAlignment
---@field BorderHorizontalAlignment EHorizontalAlignment
---@field BorderVerticalOffset float
---@field BorderPadding FMargin
---@field BorderBackground FSlateBrush
local FCenterLayoutSettings = {}



---@class FCircularThrobberSettings
---@field NumberOfPieces int32
---@field Period float
---@field Radius float
---@field Image FSlateBrush
local FCircularThrobberSettings = {}



---@class FClassicLayoutSettings
---@field bIsWidgetAtBottom boolean
---@field bIsLoadingWidgetAtLeft boolean
---@field Space float
---@field TipAlignment FWidgetAlignment
---@field BorderHorizontalAlignment EHorizontalAlignment
---@field BorderPadding FMargin
---@field BorderBackground FSlateBrush
local FClassicLayoutSettings = {}



---@class FDualSidebarLayoutSettings
---@field bIsLoadingWidgetAtRight boolean
---@field LeftVerticalAlignment EVerticalAlignment
---@field RightVerticalAlignment EVerticalAlignment
---@field LeftBorderVerticalAlignment EVerticalAlignment
---@field RightBorderVerticalAlignment EVerticalAlignment
---@field LeftBorderPadding FMargin
---@field RightBorderPadding FMargin
---@field LeftBorderBackground FSlateBrush
---@field RightBorderBackground FSlateBrush
local FDualSidebarLayoutSettings = {}



---@class FImageSequenceSettings
---@field Images TArray<UTexture2D>
---@field Scale FVector2D
---@field Interval float
---@field bPlayReverse boolean
local FImageSequenceSettings = {}



---@class FLetterboxLayoutSettings
---@field bIsLoadingWidgetAtTop boolean
---@field TipAlignment FWidgetAlignment
---@field LoadingWidgetAlignment FWidgetAlignment
---@field TopBorderHorizontalAlignment EHorizontalAlignment
---@field BottomBorderHorizontalAlignment EHorizontalAlignment
---@field TopBorderPadding FMargin
---@field BottomBorderPadding FMargin
---@field TopBorderBackground FSlateBrush
---@field BottomBorderBackground FSlateBrush
local FLetterboxLayoutSettings = {}



---@class FLoadingCompleteTextSettings
---@field LoadingCompleteText FText
---@field Appearance FTextAppearance
---@field Alignment FWidgetAlignment
---@field Padding FMargin
---@field bFadeInOutAnim boolean
---@field AnimationSpeed float
local FLoadingCompleteTextSettings = {}



---@class FLoadingWidgetSettings
---@field LoadingIconType ELoadingIconType
---@field LoadingWidgetType ELoadingWidgetType
---@field TransformTranslation FVector2D
---@field TransformScale FVector2D
---@field TransformPivot FVector2D
---@field LoadingText FText
---@field bLoadingTextRightPosition boolean
---@field bLoadingTextTopPosition boolean
---@field Appearance FTextAppearance
---@field ThrobberSettings FThrobberSettings
---@field CircularThrobberSettings FCircularThrobberSettings
---@field ImageSequenceSettings FImageSequenceSettings
---@field TextAlignment FWidgetAlignment
---@field LoadingIconAlignment FWidgetAlignment
---@field Space float
---@field bHideLoadingWidgetWhenCompletes boolean
local FLoadingWidgetSettings = {}



---@class FSidebarLayoutSettings
---@field bIsWidgetAtRight boolean
---@field bIsLoadingWidgetAtTop boolean
---@field Space float
---@field VerticalAlignment EVerticalAlignment
---@field LoadingWidgetAlignment FWidgetAlignment
---@field TipAlignment FWidgetAlignment
---@field BorderVerticalAlignment EVerticalAlignment
---@field BorderHorizontalOffset float
---@field BorderPadding FMargin
---@field BorderBackground FSlateBrush
local FSidebarLayoutSettings = {}



---@class FTextAppearance
---@field ColorAndOpacity FSlateColor
---@field Font FSlateFontInfo
---@field ShadowOffset FVector2D
---@field ShadowColorAndOpacity FLinearColor
---@field Justification ETextJustify::Type
local FTextAppearance = {}



---@class FThrobberSettings
---@field NumberOfPieces int32
---@field bAnimateHorizontally boolean
---@field bAnimateVertically boolean
---@field bAnimateOpacity boolean
---@field Image FSlateBrush
local FThrobberSettings = {}



---@class FTipSettings
---@field TipText TArray<FText>
---@field Appearance FTextAppearance
---@field TipWrapAt float
---@field bSetDisplayTipTextManually boolean
local FTipSettings = {}



---@class FWidgetAlignment
---@field HorizontalAlignment EHorizontalAlignment
---@field VerticalAlignment EVerticalAlignment
local FWidgetAlignment = {}



---@class UAsyncLoadingScreenLibrary : UBlueprintFunctionLibrary
local UAsyncLoadingScreenLibrary = {}

function UAsyncLoadingScreenLibrary:StopLoadingScreen() end
---@param bIsEnableLoadingScreen boolean
function UAsyncLoadingScreenLibrary:SetEnableLoadingScreen(bIsEnableLoadingScreen) end
---@param TipTextIndex int32
function UAsyncLoadingScreenLibrary:SetDisplayTipTextIndex(TipTextIndex) end
---@param MovieIndex int32
function UAsyncLoadingScreenLibrary:SetDisplayMovieIndex(MovieIndex) end
---@param BackgroundIndex int32
function UAsyncLoadingScreenLibrary:SetDisplayBackgroundIndex(BackgroundIndex) end
function UAsyncLoadingScreenLibrary:RemovePreloadedBackgroundImages() end
function UAsyncLoadingScreenLibrary:PreloadBackgroundImages() end
---@return boolean
function UAsyncLoadingScreenLibrary:GetIsEnableLoadingScreen() end


---@class ULoadingScreenSettings : UDeveloperSettings
---@field bPreloadBackgroundImages boolean
---@field StartupLoadingScreen FALoadingScreenSettings
---@field DefaultLoadingScreen FALoadingScreenSettings
---@field Classic FClassicLayoutSettings
---@field Center FCenterLayoutSettings
---@field Letterbox FLetterboxLayoutSettings
---@field Sidebar FSidebarLayoutSettings
---@field DualSidebar FDualSidebarLayoutSettings
local ULoadingScreenSettings = {}



