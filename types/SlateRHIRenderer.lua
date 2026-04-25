---@meta

---@class FSlatePostSettings
---@field bEnabled boolean
---@field PostProcessorClass TSubclassOf<USlateRHIPostBufferProcessor>
---@field PathToSlatePostRT FString
---@field CachedSlatePostRT UTextureRenderTarget2D
local FSlatePostSettings = {}



---@class USlateFXSubsystem : UEngineSubsystem
---@field SlatePostBufferProcessors TMap<ESlatePostRT, USlateRHIPostBufferProcessor>
local USlateFXSubsystem = {}

---@param InPostBufferBit ESlatePostRT
---@return USlateRHIPostBufferProcessor
function USlateFXSubsystem:GetSlatePostProcessor(InPostBufferBit) end


---@class USlatePostBufferBlur : USlateRHIPostBufferProcessor
---@field GaussianBlurStrength float
local USlatePostBufferBlur = {}



---@class USlateRHIPostBufferProcessor : UObject
local USlateRHIPostBufferProcessor = {}


---@class USlateRHIRendererSettings : UDeveloperSettings
---@field SlatePostSettings TMap<ESlatePostRT, FSlatePostSettings>
local USlateRHIRendererSettings = {}

---@param InPostBufferBit ESlatePostRT
---@return FSlatePostSettings
function USlateRHIRendererSettings:GetSlatePostSetting(InPostBufferBit) end
---@param InPostBufferBit ESlatePostRT
---@return FSlatePostSettings
function USlateRHIRendererSettings:GetMutableSlatePostSetting(InPostBufferBit) end


