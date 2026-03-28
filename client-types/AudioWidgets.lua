---@meta

---@class FAudioMaterialButtonStyle : FAudioMaterialWidgetStyle
---@field ButtonMainColor FLinearColor
---@field ButtonMainColorTint_1 FLinearColor
---@field ButtonMainColorTint_2 FLinearColor
---@field ButtonAccentColor FLinearColor
---@field ButtonShadowColor FLinearColor
---@field ButtonUnpressedOutlineColor FLinearColor
---@field ButtonPressedOutlineColor FLinearColor
local FAudioMaterialButtonStyle = {}



---@class FAudioMaterialEnvelopeSettings
---@field EnvelopeType EAudioMaterialEnvelopeType
---@field AttackCurve float
---@field AttackValue float
---@field AttackTime float
---@field DecayCurve float
---@field DecayTime float
---@field SustainValue float
---@field ReleaseCurve float
---@field ReleaseTime float
local FAudioMaterialEnvelopeSettings = {}



---@class FAudioMaterialEnvelopeStyle : FAudioMaterialWidgetStyle
---@field CurveColor FLinearColor
---@field BackgroundColor FLinearColor
---@field OutlineColor FLinearColor
local FAudioMaterialEnvelopeStyle = {}



---@class FAudioMaterialKnobStyle : FAudioMaterialWidgetStyle
---@field KnobMainColor FLinearColor
---@field KnobAccentColor FLinearColor
---@field KnobShadowColor FLinearColor
---@field KnobSmoothBevelColor FLinearColor
---@field KnobIndicatorDotColor FLinearColor
---@field KnobEdgeFillColor FLinearColor
---@field KnobBarColor FLinearColor
---@field KnobBarShadowColor FLinearColor
---@field KnobBarFillMinColor FLinearColor
---@field KnobBarFillMidColor FLinearColor
---@field KnobBarFillMaxColor FLinearColor
---@field KnobBarFillTintColor FLinearColor
---@field TextBoxStyle FAudioTextBoxStyle
local FAudioMaterialKnobStyle = {}



---@class FAudioMaterialMeterStyle : FAudioMaterialWidgetStyle
---@field MeterFillMinColor FLinearColor
---@field MeterFillMidColor FLinearColor
---@field MeterFillMaxColor FLinearColor
---@field MeterFillBackgroundColor FLinearColor
---@field MeterPadding FVector2D
---@field ValueRangeDb FVector2D
---@field bShowScale boolean
---@field bScaleSide boolean
---@field ScaleHashOffset float
---@field ScaleHashWidth float
---@field ScaleHashHeight float
---@field DecibelsPerHash int32
---@field Font FSlateFontInfo
local FAudioMaterialMeterStyle = {}



---@class FAudioMaterialSliderStyle : FAudioMaterialWidgetStyle
---@field SliderBackgroundColor FLinearColor
---@field SliderBackgroundAccentColor FLinearColor
---@field SliderValueMainColor FLinearColor
---@field SliderHandleMainColor FLinearColor
---@field SliderHandleOutlineColor FLinearColor
---@field TextBoxStyle FAudioTextBoxStyle
local FAudioMaterialSliderStyle = {}



---@class FAudioMaterialWidgetStyle : FSlateWidgetStyle
---@field Material UMaterialInterface
---@field DesiredSize FVector2f
local FAudioMaterialWidgetStyle = {}



---@class FAudioMeterDefaultColorStyle : FSlateWidgetStyle
---@field MeterBackgroundColor FLinearColor
---@field MeterValueColor FLinearColor
---@field MeterPeakColor FLinearColor
---@field MeterClippingColor FLinearColor
---@field MeterScaleColor FLinearColor
---@field MeterScaleLabelColor FLinearColor
local FAudioMeterDefaultColorStyle = {}



---@class FAudioMeterStyle : FSlateWidgetStyle
---@field MeterValueImage FSlateBrush
---@field BackgroundImage FSlateBrush
---@field MeterBackgroundImage FSlateBrush
---@field MeterValueBackgroundImage FSlateBrush
---@field MeterPeakImage FSlateBrush
---@field MeterSize FVector2D
---@field MeterPadding FVector2D
---@field MeterValuePadding float
---@field PeakValueWidth float
---@field ValueRangeDb FVector2D
---@field bShowScale boolean
---@field bScaleSide boolean
---@field ScaleHashOffset float
---@field ScaleHashWidth float
---@field ScaleHashHeight float
---@field DecibelsPerHash int32
---@field Font FSlateFontInfo
local FAudioMeterStyle = {}



---@class FAudioOscilloscopePanelStyle : FSlateWidgetStyle
---@field TimeRulerStyle FFixedSampleSequenceRulerStyle
---@field ValueGridStyle FSampledSequenceValueGridOverlayStyle
---@field WaveViewerStyle FSampledSequenceViewerStyle
---@field TriggerThresholdLineStyle FTriggerThresholdLineStyle
local FAudioOscilloscopePanelStyle = {}



---@class FAudioRadialSliderStyle : FSlateWidgetStyle
---@field TextBoxStyle FAudioTextBoxStyle
---@field CenterBackgroundColor FSlateColor
---@field SliderBarColor FSlateColor
---@field SliderProgressColor FSlateColor
---@field LabelPadding float
---@field DefaultSliderRadius float
local FAudioRadialSliderStyle = {}



---@class FAudioSliderStyle : FSlateWidgetStyle
---@field SliderStyle FSliderStyle
---@field TextBoxStyle FAudioTextBoxStyle
---@field WidgetBackgroundImage FSlateBrush
---@field SliderBackgroundColor FSlateColor
---@field SliderBackgroundSize FVector2D
---@field LabelPadding float
---@field SliderBarColor FSlateColor
---@field SliderThumbColor FSlateColor
---@field WidgetBackgroundColor FSlateColor
local FAudioSliderStyle = {}



---@class FAudioSpectrumPlotStyle : FSlateWidgetStyle
---@field BackgroundColor FSlateColor
---@field GridColor FSlateColor
---@field AxisLabelColor FSlateColor
---@field AxisLabelFont FSlateFontInfo
---@field SpectrumColor FSlateColor
---@field CrosshairColor FSlateColor
---@field CrosshairLabelFont FSlateFontInfo
local FAudioSpectrumPlotStyle = {}



---@class FAudioTextBoxStyle : FSlateWidgetStyle
---@field BackgroundImage FSlateBrush
---@field BackgroundColor FSlateColor
local FAudioTextBoxStyle = {}



---@class FAudioVectorscopePanelStyle : FSlateWidgetStyle
---@field ValueGridStyle FSampledSequenceValueGridOverlayStyle
---@field VectorViewerStyle FSampledSequenceVectorViewerStyle
local FAudioVectorscopePanelStyle = {}



---@class FFixedSampleSequenceRulerStyle : FSlateWidgetStyle
---@field HandleWidth float
---@field HandleColor FSlateColor
---@field HandleBrush FSlateBrush
---@field TicksColor FSlateColor
---@field TicksTextColor FSlateColor
---@field TicksTextFont FSlateFontInfo
---@field TicksTextOffset float
---@field BackgroundColor FSlateColor
---@field BackgroundBrush FSlateBrush
---@field DesiredWidth float
---@field DesiredHeight float
local FFixedSampleSequenceRulerStyle = {}



---@class FMeterChannelInfo
---@field MeterValue float
---@field PeakValue float
---@field ClippingValue float
local FMeterChannelInfo = {}



---@class FPlayheadOverlayStyle : FSlateWidgetStyle
---@field PlayheadColor FSlateColor
---@field PlayheadWidth float
---@field DesiredWidth float
---@field DesiredHeight float
local FPlayheadOverlayStyle = {}



---@class FSampledSequenceValueGridOverlayStyle : FSlateWidgetStyle
---@field GridColor FSlateColor
---@field GridThickness float
---@field LabelTextColor FSlateColor
---@field LabelTextFont FSlateFontInfo
---@field DesiredWidth float
---@field DesiredHeight float
local FSampledSequenceValueGridOverlayStyle = {}



---@class FSampledSequenceVectorViewerStyle : FSlateWidgetStyle
---@field BackgroundColor FSlateColor
---@field BackgroundBrush FSlateBrush
---@field LineColor FLinearColor
---@field LineThickness float
local FSampledSequenceVectorViewerStyle = {}



---@class FSampledSequenceViewerStyle : FSlateWidgetStyle
---@field SequenceColor FSlateColor
---@field SequenceLineThickness float
---@field MajorGridLineColor FSlateColor
---@field MinorGridLineColor FSlateColor
---@field ZeroCrossingLineColor FSlateColor
---@field ZeroCrossingLineThickness float
---@field SampleMarkersSize float
---@field SequenceBackgroundColor FSlateColor
---@field BackgroundBrush FSlateBrush
---@field DesiredWidth float
---@field DesiredHeight float
local FSampledSequenceViewerStyle = {}



---@class FTriggerThresholdLineStyle : FSlateWidgetStyle
---@field LineColor FLinearColor
local FTriggerThresholdLineStyle = {}



---@class UAudioFrequencyRadialSlider : UAudioRadialSlider
local UAudioFrequencyRadialSlider = {}


---@class UAudioFrequencySlider : UAudioSliderBase
---@field OutputRange FVector2D
local UAudioFrequencySlider = {}



---@class UAudioMaterialButton : UWidget
---@field WidgetStyle FAudioMaterialButtonStyle
---@field OnButtonPressedChangedEvent FAudioMaterialButtonOnButtonPressedChangedEvent
---@field bIsPressed boolean
local UAudioMaterialButton = {}

---@param InPressed boolean
function UAudioMaterialButton:SetIsPressed(InPressed) end
---@return boolean
function UAudioMaterialButton:GetIsPressed() end


---@class UAudioMaterialButtonWidgetStyle : USlateWidgetStyleContainerBase
---@field ButtonStyle FAudioMaterialButtonStyle
local UAudioMaterialButtonWidgetStyle = {}



---@class UAudioMaterialEnvelope : UWidget
---@field WidgetStyle FAudioMaterialEnvelopeStyle
---@field EnvelopeSettings FAudioMaterialEnvelopeSettings
local UAudioMaterialEnvelope = {}



---@class UAudioMaterialKnob : UWidget
---@field WidgetStyle FAudioMaterialKnobStyle
---@field OnKnobValueChanged FAudioMaterialKnobOnKnobValueChanged
---@field Value float
---@field TuneSpeed float
---@field FineTuneSpeed float
---@field bLocked boolean
---@field bMouseUsesStep boolean
---@field StepSize float
local UAudioMaterialKnob = {}

---@param InValue float
function UAudioMaterialKnob:SetValue(InValue) end
---@param InValue float
function UAudioMaterialKnob:SetTuneSpeed(InValue) end
---@param InValue float
function UAudioMaterialKnob:SetStepSize(InValue) end
---@param InUsesStep boolean
function UAudioMaterialKnob:SetMouseUsesStep(InUsesStep) end
---@param InLocked boolean
function UAudioMaterialKnob:SetLocked(InLocked) end
---@param InValue float
function UAudioMaterialKnob:SetFineTuneSpeed(InValue) end
---@return float
function UAudioMaterialKnob:GetValue() end
---@return float
function UAudioMaterialKnob:GetTuneSpeed() end
---@return float
function UAudioMaterialKnob:GetStepSize() end
---@return boolean
function UAudioMaterialKnob:GetMouseUsesStep() end
---@return boolean
function UAudioMaterialKnob:GetIsLocked() end
---@return float
function UAudioMaterialKnob:GetFineTuneSpeed() end


---@class UAudioMaterialKnobWidgetStyle : USlateWidgetStyleContainerBase
---@field KnobStyle FAudioMaterialKnobStyle
local UAudioMaterialKnobWidgetStyle = {}



---@class UAudioMaterialMeter : UWidget
---@field WidgetStyle FAudioMaterialMeterStyle
---@field Orientation EOrientation
---@field MeterChannelInfoDelegate FAudioMaterialMeterMeterChannelInfoDelegate
---@field MeterChannelInfo TArray<FMeterChannelInfo>
local UAudioMaterialMeter = {}

---@param InMeterChannelInfo TArray<FMeterChannelInfo>
function UAudioMaterialMeter:SetMeterChannelInfo(InMeterChannelInfo) end
---@return TArray<FMeterChannelInfo>
function UAudioMaterialMeter:GetMeterChannelInfo__DelegateSignature() end
---@return TArray<FMeterChannelInfo>
function UAudioMaterialMeter:GetMeterChannelInfo() end


---@class UAudioMaterialMeterWidgetStyle : USlateWidgetStyleContainerBase
---@field MeterStyle FAudioMaterialMeterStyle
local UAudioMaterialMeterWidgetStyle = {}



---@class UAudioMaterialSlider : UWidget
---@field WidgetStyle FAudioMaterialSliderStyle
---@field OnValueChanged FAudioMaterialSliderOnValueChanged
---@field Value float
---@field Orientation EOrientation
---@field TuneSpeed float
---@field FineTuneSpeed float
---@field bLocked boolean
---@field bMouseUsesStep boolean
---@field StepSize float
local UAudioMaterialSlider = {}

---@param InValue float
function UAudioMaterialSlider:SetValue(InValue) end
---@param InValue float
function UAudioMaterialSlider:SetTuneSpeed(InValue) end
---@param InValue float
function UAudioMaterialSlider:SetStepSize(InValue) end
---@param bInUsesStep boolean
function UAudioMaterialSlider:SetMouseUsesStep(bInUsesStep) end
---@param bInLocked boolean
function UAudioMaterialSlider:SetLocked(bInLocked) end
---@param InValue float
function UAudioMaterialSlider:SetFineTuneSpeed(InValue) end
---@return float
function UAudioMaterialSlider:GetValue() end
---@return float
function UAudioMaterialSlider:GetTuneSpeed() end
---@return float
function UAudioMaterialSlider:GetStepSize() end
---@return boolean
function UAudioMaterialSlider:GetMouseUsesStep() end
---@return boolean
function UAudioMaterialSlider:GetIsLocked() end
---@return float
function UAudioMaterialSlider:GetFineTuneSpeed() end


---@class UAudioMaterialSliderWidgetStyle : USlateWidgetStyleContainerBase
---@field SliderStyle FAudioMaterialSliderStyle
local UAudioMaterialSliderWidgetStyle = {}



---@class UAudioMeter : UWidget
---@field MeterChannelInfo TArray<FMeterChannelInfo>
---@field MeterChannelInfoDelegate FAudioMeterMeterChannelInfoDelegate
---@field WidgetStyle FAudioMeterStyle
---@field Orientation EOrientation
---@field BackgroundColor FLinearColor
---@field MeterBackgroundColor FLinearColor
---@field MeterValueColor FLinearColor
---@field MeterPeakColor FLinearColor
---@field MeterClippingColor FLinearColor
---@field MeterScaleColor FLinearColor
---@field MeterScaleLabelColor FLinearColor
local UAudioMeter = {}

---@param InValue FLinearColor
function UAudioMeter:SetMeterValueColor(InValue) end
---@param InValue FLinearColor
function UAudioMeter:SetMeterScaleLabelColor(InValue) end
---@param InValue FLinearColor
function UAudioMeter:SetMeterScaleColor(InValue) end
---@param InValue FLinearColor
function UAudioMeter:SetMeterPeakColor(InValue) end
---@param InValue FLinearColor
function UAudioMeter:SetMeterClippingColor(InValue) end
---@param InMeterChannelInfo TArray<FMeterChannelInfo>
function UAudioMeter:SetMeterChannelInfo(InMeterChannelInfo) end
---@param InValue FLinearColor
function UAudioMeter:SetMeterBackgroundColor(InValue) end
---@param InValue FLinearColor
function UAudioMeter:SetBackgroundColor(InValue) end
---@return TArray<FMeterChannelInfo>
function UAudioMeter:GetMeterChannelInfo__DelegateSignature() end
---@return TArray<FMeterChannelInfo>
function UAudioMeter:GetMeterChannelInfo() end


---@class UAudioOscilloscope : UWidget
---@field OscilloscopeStyle FAudioOscilloscopePanelStyle
---@field AudioBus UAudioBus
---@field MaxTimeWindowMs float
---@field TimeWindowMs float
---@field AnalysisPeriodMs float
---@field bShowTimeGrid boolean
---@field TimeGridLabelsUnit EXAxisLabelsUnit
---@field bShowAmplitudeGrid boolean
---@field bShowAmplitudeLabels boolean
---@field AmplitudeGridLabelsUnit EYAxisLabelsUnit
---@field TriggerMode EAudioOscilloscopeTriggerMode
---@field TriggerThreshold float
---@field PanelLayoutType EAudioPanelLayoutType
---@field ChannelToAnalyze int32
local UAudioOscilloscope = {}

function UAudioOscilloscope:StopProcessing() end
function UAudioOscilloscope:StartProcessing() end
---@return TArray<float>
function UAudioOscilloscope:GetOscilloscopeAudioSamples__DelegateSignature() end
---@return boolean
function UAudioOscilloscope:CanTriggeringBeSet() end


---@class UAudioRadialSlider : UWidget
---@field Value float
---@field ValueDelegate FAudioRadialSliderValueDelegate
---@field WidgetLayout EAudioRadialSliderLayout
---@field CenterBackgroundColor FLinearColor
---@field SliderProgressColor FLinearColor
---@field SliderBarColor FLinearColor
---@field HandStartEndRatio FVector2D
---@field UnitsText FText
---@field TextLabelBackgroundColor FLinearColor
---@field ShowLabelOnlyOnHover boolean
---@field ShowUnitsText boolean
---@field IsUnitsTextReadOnly boolean
---@field IsValueTextReadOnly boolean
---@field SliderThickness float
---@field OutputRange FVector2D
---@field OnValueChanged FAudioRadialSliderOnValueChanged
local UAudioRadialSlider = {}

---@param InLayout EAudioRadialSliderLayout
function UAudioRadialSlider:SetWidgetLayout(InLayout) end
---@param bIsReadOnly boolean
function UAudioRadialSlider:SetValueTextReadOnly(bIsReadOnly) end
---@param bIsReadOnly boolean
function UAudioRadialSlider:SetUnitsTextReadOnly(bIsReadOnly) end
---@param Units FText
function UAudioRadialSlider:SetUnitsText(Units) end
---@param InColor FSlateColor
function UAudioRadialSlider:SetTextLabelBackgroundColor(InColor) end
---@param InThickness float
function UAudioRadialSlider:SetSliderThickness(InThickness) end
---@param InValue FLinearColor
function UAudioRadialSlider:SetSliderProgressColor(InValue) end
---@param InValue FLinearColor
function UAudioRadialSlider:SetSliderBarColor(InValue) end
---@param bShowUnitsText boolean
function UAudioRadialSlider:SetShowUnitsText(bShowUnitsText) end
---@param bShowLabelOnlyOnHover boolean
function UAudioRadialSlider:SetShowLabelOnlyOnHover(bShowLabelOnlyOnHover) end
---@param InOutputRange FVector2D
function UAudioRadialSlider:SetOutputRange(InOutputRange) end
---@param InHandStartEndRatio FVector2D
function UAudioRadialSlider:SetHandStartEndRatio(InHandStartEndRatio) end
---@param InValue FLinearColor
function UAudioRadialSlider:SetCenterBackgroundColor(InValue) end
---@param OutputValue float
---@return float
function UAudioRadialSlider:GetSliderValue(OutputValue) end
---@param InSliderValue float
---@return float
function UAudioRadialSlider:GetOutputValue(InSliderValue) end


---@class UAudioSlider : UAudioSliderBase
---@field LinToOutputCurve TWeakObjectPtr<UCurveFloat>
---@field OutputToLinCurve TWeakObjectPtr<UCurveFloat>
local UAudioSlider = {}



---@class UAudioSliderBase : UWidget
---@field Value float
---@field UnitsText FText
---@field TextLabelBackgroundColor FLinearColor
---@field TextLabelBackgroundColorDelegate FAudioSliderBaseTextLabelBackgroundColorDelegate
---@field ShowLabelOnlyOnHover boolean
---@field ShowUnitsText boolean
---@field IsUnitsTextReadOnly boolean
---@field IsValueTextReadOnly boolean
---@field ValueDelegate FAudioSliderBaseValueDelegate
---@field SliderBackgroundColor FLinearColor
---@field SliderBackgroundColorDelegate FAudioSliderBaseSliderBackgroundColorDelegate
---@field SliderBarColor FLinearColor
---@field SliderBarColorDelegate FAudioSliderBaseSliderBarColorDelegate
---@field SliderThumbColor FLinearColor
---@field SliderThumbColorDelegate FAudioSliderBaseSliderThumbColorDelegate
---@field WidgetBackgroundColor FLinearColor
---@field WidgetBackgroundColorDelegate FAudioSliderBaseWidgetBackgroundColorDelegate
---@field Orientation EOrientation
---@field OnValueChanged FAudioSliderBaseOnValueChanged
local UAudioSliderBase = {}

---@param InValue FLinearColor
function UAudioSliderBase:SetWidgetBackgroundColor(InValue) end
---@param bIsReadOnly boolean
function UAudioSliderBase:SetValueTextReadOnly(bIsReadOnly) end
---@param bIsReadOnly boolean
function UAudioSliderBase:SetUnitsTextReadOnly(bIsReadOnly) end
---@param Units FText
function UAudioSliderBase:SetUnitsText(Units) end
---@param InColor FSlateColor
function UAudioSliderBase:SetTextLabelBackgroundColor(InColor) end
---@param InValue FLinearColor
function UAudioSliderBase:SetSliderThumbColor(InValue) end
---@param InValue FLinearColor
function UAudioSliderBase:SetSliderBarColor(InValue) end
---@param InValue FLinearColor
function UAudioSliderBase:SetSliderBackgroundColor(InValue) end
---@param bShowUnitsText boolean
function UAudioSliderBase:SetShowUnitsText(bShowUnitsText) end
---@param bShowLabelOnlyOnHover boolean
function UAudioSliderBase:SetShowLabelOnlyOnHover(bShowLabelOnlyOnHover) end
---@param OutputValue float
---@return float
function UAudioSliderBase:GetSliderValue(OutputValue) end
---@param InSliderValue float
---@return float
function UAudioSliderBase:GetOutputValue(InSliderValue) end
---@param OutputValue float
---@return float
function UAudioSliderBase:GetLinValue(OutputValue) end


---@class UAudioVectorscope : UWidget
---@field VectorscopeStyle FAudioVectorscopePanelStyle
---@field AudioBus UAudioBus
---@field bShowGrid boolean
---@field GridDivisions int32
---@field MaxDisplayPersistenceMs float
---@field DisplayPersistenceMs float
---@field Scale float
---@field PanelLayoutType EAudioPanelLayoutType
local UAudioVectorscope = {}

function UAudioVectorscope:StopProcessing() end
function UAudioVectorscope:StartProcessing() end
---@return TArray<float>
function UAudioVectorscope:GetVectorscopeAudioSamples__DelegateSignature() end


---@class UAudioVolumeRadialSlider : UAudioRadialSlider
local UAudioVolumeRadialSlider = {}


---@class UAudioVolumeSlider : UAudioSlider
local UAudioVolumeSlider = {}


