---@meta

---@class FAnalyticsEventAttr
---@field Name FString
---@field Value FString
local FAnalyticsEventAttr = {}



---@class UAnalyticsBlueprintLibrary : UBlueprintFunctionLibrary
local UAnalyticsBlueprintLibrary = {}

---@param Attributes TArray<FAnalyticsEventAttr>
---@return boolean
function UAnalyticsBlueprintLibrary:StartSessionWithAttributes(Attributes) end
---@return boolean
function UAnalyticsBlueprintLibrary:StartSession() end
---@param UserId FString
function UAnalyticsBlueprintLibrary:SetUserId(UserId) end
---@param SessionId FString
function UAnalyticsBlueprintLibrary:SetSessionId(SessionId) end
---@param Location FString
function UAnalyticsBlueprintLibrary:SetLocation(Location) end
---@param Gender FString
function UAnalyticsBlueprintLibrary:SetGender(Gender) end
---@param BuildInfo FString
function UAnalyticsBlueprintLibrary:SetBuildInfo(BuildInfo) end
---@param Age int32
function UAnalyticsBlueprintLibrary:SetAge(Age) end
---@param ItemId FString
---@param ItemQuantity int32
---@param Attributes TArray<FAnalyticsEventAttr>
function UAnalyticsBlueprintLibrary:RecordSimpleItemPurchaseWithAttributes(ItemId, ItemQuantity, Attributes) end
---@param ItemId FString
---@param ItemQuantity int32
function UAnalyticsBlueprintLibrary:RecordSimpleItemPurchase(ItemId, ItemQuantity) end
---@param GameCurrencyType FString
---@param GameCurrencyAmount int32
---@param Attributes TArray<FAnalyticsEventAttr>
function UAnalyticsBlueprintLibrary:RecordSimpleCurrencyPurchaseWithAttributes(GameCurrencyType, GameCurrencyAmount, Attributes) end
---@param GameCurrencyType FString
---@param GameCurrencyAmount int32
function UAnalyticsBlueprintLibrary:RecordSimpleCurrencyPurchase(GameCurrencyType, GameCurrencyAmount) end
---@param ProgressType FString
---@param ProgressNames TArray<FString>
---@param Attributes TArray<FAnalyticsEventAttr>
function UAnalyticsBlueprintLibrary:RecordProgressWithFullHierarchyAndAttributes(ProgressType, ProgressNames, Attributes) end
---@param ProgressType FString
---@param ProgressName FString
---@param Attributes TArray<FAnalyticsEventAttr>
function UAnalyticsBlueprintLibrary:RecordProgressWithAttributes(ProgressType, ProgressName, Attributes) end
---@param ProgressType FString
---@param ProgressName FString
function UAnalyticsBlueprintLibrary:RecordProgress(ProgressType, ProgressName) end
---@param ItemId FString
---@param Currency FString
---@param PerItemCost int32
---@param ItemQuantity int32
function UAnalyticsBlueprintLibrary:RecordItemPurchase(ItemId, Currency, PerItemCost, ItemQuantity) end
---@param EventName FString
---@param Attributes TArray<FAnalyticsEventAttr>
function UAnalyticsBlueprintLibrary:RecordEventWithAttributes(EventName, Attributes) end
---@param EventName FString
---@param AttributeName FString
---@param AttributeValue FString
function UAnalyticsBlueprintLibrary:RecordEventWithAttribute(EventName, AttributeName, AttributeValue) end
---@param EventName FString
function UAnalyticsBlueprintLibrary:RecordEvent(EventName) end
---@param Error FString
---@param Attributes TArray<FAnalyticsEventAttr>
function UAnalyticsBlueprintLibrary:RecordErrorWithAttributes(Error, Attributes) end
---@param Error FString
function UAnalyticsBlueprintLibrary:RecordError(Error) end
---@param GameCurrencyType FString
---@param GameCurrencyAmount int32
---@param RealCurrencyType FString
---@param RealMoneyCost float
---@param PaymentProvider FString
function UAnalyticsBlueprintLibrary:RecordCurrencyPurchase(GameCurrencyType, GameCurrencyAmount, RealCurrencyType, RealMoneyCost, PaymentProvider) end
---@param GameCurrencyType FString
---@param GameCurrencyAmount int32
---@param Attributes TArray<FAnalyticsEventAttr>
function UAnalyticsBlueprintLibrary:RecordCurrencyGivenWithAttributes(GameCurrencyType, GameCurrencyAmount, Attributes) end
---@param GameCurrencyType FString
---@param GameCurrencyAmount int32
function UAnalyticsBlueprintLibrary:RecordCurrencyGiven(GameCurrencyType, GameCurrencyAmount) end
---@param AttributeName FString
---@param AttributeValue FString
---@return FAnalyticsEventAttr
function UAnalyticsBlueprintLibrary:MakeEventAttribute(AttributeName, AttributeValue) end
---@return FString
function UAnalyticsBlueprintLibrary:GetUserId() end
---@return FString
function UAnalyticsBlueprintLibrary:GetSessionId() end
function UAnalyticsBlueprintLibrary:FlushEvents() end
function UAnalyticsBlueprintLibrary:EndSession() end


