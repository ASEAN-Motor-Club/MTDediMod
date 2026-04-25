---@enum EAudioColorGradient
local EAudioColorGradient = {
    BlackToWhite = 0,
    WhiteToBlack = 1,
    EAudioColorGradient_MAX = 2,
}

---@enum EAudioMaterialEnvelopeType
local EAudioMaterialEnvelopeType = {
    AD = 0,
    ADSR = 1,
    EAudioMaterialEnvelopeType_MAX = 2,
}

---@enum EAudioOscilloscopeTriggerMode
local EAudioOscilloscopeTriggerMode = {
    None = 0,
    Rising = 1,
    Falling = 2,
    EAudioOscilloscopeTriggerMode_MAX = 3,
}

---@enum EAudioPanelLayoutType
local EAudioPanelLayoutType = {
    Basic = 0,
    Advanced = 1,
    EAudioPanelLayoutType_MAX = 2,
}

---@enum EAudioRadialSliderLayout
local EAudioRadialSliderLayout = {
    Layout_LabelTop = 0,
    Layout_LabelCenter = 1,
    Layout_LabelBottom = 2,
    Layout_MAX = 3,
}

---@enum EAudioSpectrogramFrequencyAxisPixelBucketMode
local EAudioSpectrogramFrequencyAxisPixelBucketMode = {
    Sample = 0,
    Peak = 1,
    Average = 2,
    EAudioSpectrogramFrequencyAxisPixelBucketMode_MAX = 3,
}

---@enum EAudioSpectrogramFrequencyAxisScale
local EAudioSpectrogramFrequencyAxisScale = {
    Linear = 0,
    Logarithmic = 1,
    EAudioSpectrogramFrequencyAxisScale_MAX = 2,
}

---@enum EAudioSpectrumAnalyzerBallistics
local EAudioSpectrumAnalyzerBallistics = {
    Analog = 0,
    Digital = 1,
    EAudioSpectrumAnalyzerBallistics_MAX = 2,
}

---@enum EAudioSpectrumAnalyzerType
local EAudioSpectrumAnalyzerType = {
    FFT = 0,
    CQT = 1,
    EAudioSpectrumAnalyzerType_MAX = 2,
}

---@enum EAudioSpectrumPlotFrequencyAxisPixelBucketMode
local EAudioSpectrumPlotFrequencyAxisPixelBucketMode = {
    Sample = 0,
    Peak = 1,
    Average = 2,
    EAudioSpectrumPlotFrequencyAxisPixelBucketMode_MAX = 3,
}

---@enum EAudioSpectrumPlotFrequencyAxisScale
local EAudioSpectrumPlotFrequencyAxisScale = {
    Linear = 0,
    Logarithmic = 1,
    EAudioSpectrumPlotFrequencyAxisScale_MAX = 2,
}

---@enum EAudioSpectrumPlotTilt
local EAudioSpectrumPlotTilt = {
    NoTilt = 0,
    Plus1_5dBPerOctave = 1,
    Plus3dBPerOctave = 2,
    Plus4_5dBPerOctave = 3,
    Plus6dBPerOctave = 4,
    EAudioSpectrumPlotTilt_MAX = 5,
}

---@enum EAudioUnitsValueType
local EAudioUnitsValueType = {
    Linear = 0,
    Frequency = 1,
    Volume = 2,
    EAudioUnitsValueType_MAX = 3,
}

---@enum EXAxisLabelsUnit
local EXAxisLabelsUnit = {
    Samples = 0,
    Seconds = 1,
    EXAxisLabelsUnit_MAX = 2,
}

---@enum EYAxisLabelsUnit
local EYAxisLabelsUnit = {
    Linear = 0,
    Db = 1,
    EYAxisLabelsUnit_MAX = 2,
}

