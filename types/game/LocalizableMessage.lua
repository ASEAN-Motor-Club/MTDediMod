---@meta

---@class FLocalizableMessage
---@field Key FString
---@field DefaultText FString
---@field Substitutions TArray<FLocalizableMessageParameterEntry>
local FLocalizableMessage = {}



---@class FLocalizableMessageParameterEntry
---@field Key FString
---@field Value FInstancedStruct
local FLocalizableMessageParameterEntry = {}



---@class FLocalizableMessageParameterFloat
---@field Value double
local FLocalizableMessageParameterFloat = {}



---@class FLocalizableMessageParameterInt
---@field Value int64
local FLocalizableMessageParameterInt = {}



---@class FLocalizableMessageParameterMessage
---@field Value FLocalizableMessage
local FLocalizableMessageParameterMessage = {}



---@class FLocalizableMessageParameterString
---@field Value FString
local FLocalizableMessageParameterString = {}



