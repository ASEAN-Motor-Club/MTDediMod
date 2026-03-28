---@meta

---@class ULocalizableMessageLibrary : UBlueprintFunctionLibrary
local ULocalizableMessageLibrary = {}

---@param Message FLocalizableMessage
function ULocalizableMessageLibrary:Reset_LocalizableMessage(Message) end
---@param Message FLocalizableMessage
---@return boolean
function ULocalizableMessageLibrary:IsEmpty_LocalizableMessage(Message) end
---@param WorldContextObject UObject
---@param Message FLocalizableMessage
---@return FText
function ULocalizableMessageLibrary:Conv_LocalizableMessageToText(WorldContextObject, Message) end


