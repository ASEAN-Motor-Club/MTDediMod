---@meta

---@class FCachedPropertyPath
---@field Segments TArray<FPropertyPathSegment>
---@field CachedFunction UFunction
local FCachedPropertyPath = {}



---@class FPropertyPathSegment
---@field Name FName
---@field ArrayIndex int32
---@field Struct UStruct
local FPropertyPathSegment = {}



---@class FPropertyPathTestBaseStruct
local FPropertyPathTestBaseStruct = {}


---@class FPropertyPathTestBed
---@field Object UPropertyPathTestObject
---@field ModifiedObject UPropertyPathTestObject
---@field ModifiedStruct FPropertyPathTestStruct
---@field DefaultStruct FPropertyPathTestStruct
local FPropertyPathTestBed = {}



---@class FPropertyPathTestInnerStruct : FPropertyPathTestBaseStruct
---@field float float
---@field bool boolean
---@field EnumOne EPropertyPathTestEnum
---@field EnumTwo EPropertyPathTestEnum
---@field EnumThree EPropertyPathTestEnum
---@field EnumFour EPropertyPathTestEnum
---@field Integer int32
---@field String FString
local FPropertyPathTestInnerStruct = {}



---@class FPropertyPathTestStruct : FPropertyPathTestBaseStruct
---@field bool boolean
---@field Integer int32
---@field EnumOne EPropertyPathTestEnum
---@field EnumTwo EPropertyPathTestEnum
---@field EnumThree EPropertyPathTestEnum
---@field EnumFour EPropertyPathTestEnum
---@field String FString
---@field float float
---@field InnerStruct FPropertyPathTestInnerStruct
---@field InnerObject UPropertyPathTestObject
local FPropertyPathTestStruct = {}



---@class UPropertyPathTestObject : UObject
---@field bool boolean
---@field EnumOne EPropertyPathTestEnum
---@field EnumTwo EPropertyPathTestEnum
---@field EnumThree EPropertyPathTestEnum
---@field EnumFour EPropertyPathTestEnum
---@field Integer int32
---@field String FString
---@field float float
---@field Struct FPropertyPathTestStruct
---@field StructRef FPropertyPathTestStruct
---@field StructConstRef FPropertyPathTestStruct
---@field InnerObject UPropertyPathTestObject
local UPropertyPathTestObject = {}

---@param InStruct FPropertyPathTestStruct
function UPropertyPathTestObject:SetStructRef(InStruct) end
---@param InStruct FPropertyPathTestStruct
function UPropertyPathTestObject:SetStructConstRef(InStruct) end
---@param InStruct FPropertyPathTestStruct
function UPropertyPathTestObject:SetStruct(InStruct) end
---@param InFloat float
function UPropertyPathTestObject:SetFloat(InFloat) end
---@return FPropertyPathTestStruct
function UPropertyPathTestObject:GetStructRef() end
---@return FPropertyPathTestStruct
function UPropertyPathTestObject:GetStructConstRef() end
---@return FPropertyPathTestStruct
function UPropertyPathTestObject:GetStruct() end
---@return float
function UPropertyPathTestObject:GetFloat() end


