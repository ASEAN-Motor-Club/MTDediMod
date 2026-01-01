---@meta

---@class UJsonFieldData : UObject
local UJsonFieldData = {}

---@return FString
function UJsonFieldData:ToString() end
---@param Key FString
---@param Data TArray<FString>
---@return UJsonFieldData
function UJsonFieldData:SetStringArray(Key, Data) end
---@param Key FString
---@param Value FString
---@return UJsonFieldData
function UJsonFieldData:SetString(Key, Value) end
---@param Key FString
---@param ArrayData TArray<UJsonFieldData>
---@return UJsonFieldData
function UJsonFieldData:SetObjectArray(Key, ArrayData) end
---@param Key FString
---@param objectData UJsonFieldData
---@return UJsonFieldData
function UJsonFieldData:SetObject(Key, objectData) end
---@param Key FString
---@param Length int32
---@return UJsonFieldData
function UJsonFieldData:SetNullArray(Key, Length) end
---@param Key FString
---@return UJsonFieldData
function UJsonFieldData:SetNull(Key) end
---@param Key FString
---@param Data TArray<int32>
---@return UJsonFieldData
function UJsonFieldData:SetIntArray(Key, Data) end
---@param Key FString
---@param Value int64
---@return UJsonFieldData
function UJsonFieldData:SetInt64(Key, Value) end
---@param Key FString
---@param Value int32
---@return UJsonFieldData
function UJsonFieldData:SetInt(Key, Value) end
---@param Key FString
---@param Data TArray<float>
---@return UJsonFieldData
function UJsonFieldData:SetFloatArray(Key, Data) end
---@param Key FString
---@param Value float
---@return UJsonFieldData
function UJsonFieldData:SetFloat(Key, Value) end
---@param Key FString
---@param Value boolean
---@return UJsonFieldData
function UJsonFieldData:SetBoolean(Key, Value) end
---@param Key FString
---@param Data TArray<boolean>
---@return UJsonFieldData
function UJsonFieldData:SetBoolArray(Key, Data) end
---@param FilePath FString
---@param URL FString
function UJsonFieldData:PostRequestWithFile(FilePath, URL) end
---@param URL FString
---@param TimeoutSeconds float
function UJsonFieldData:PostRequest(URL, TimeoutSeconds) end
---@param Key FString
---@return boolean
function UJsonFieldData:HasField(Key) end
---@param Key FString
---@param Success boolean
---@return TArray<FString>
function UJsonFieldData:GetStringArray(Key, Success) end
---@param Key FString
---@param Success boolean
---@return FString
function UJsonFieldData:GetString(Key, Success) end
---@param URL FString
---@param TimeoutSeconds float
---@return UJsonFieldData
function UJsonFieldData:GetRequest(URL, TimeoutSeconds) end
---@return TArray<FString>
function UJsonFieldData:GetObjectKeys() end
---@param Key FString
---@param Success boolean
---@return TArray<UJsonFieldData>
function UJsonFieldData:GetObjectArray(Key, Success) end
---@param Key FString
---@param Success boolean
---@return UJsonFieldData
function UJsonFieldData:GetObject(Key, Success) end
---@param Key FString
---@param fieldExists boolean
---@return boolean
function UJsonFieldData:GetIsNull(Key, fieldExists) end
---@param Key FString
---@param Success boolean
---@return TArray<int32>
function UJsonFieldData:GetIntArray(Key, Success) end
---@param Key FString
---@param Success boolean
---@return int64
function UJsonFieldData:GetInt64(Key, Success) end
---@param Key FString
---@param Success boolean
---@return int32
function UJsonFieldData:GetInt(Key, Success) end
---@param Key FString
---@param Success boolean
---@return TArray<float>
function UJsonFieldData:GetFloatArray(Key, Success) end
---@param Key FString
---@param Success boolean
---@return float
function UJsonFieldData:GetFloat(Key, Success) end
---@param Key FString
---@param Success boolean
---@return TArray<boolean>
function UJsonFieldData:GetBoolArray(Key, Success) end
---@param Key FString
---@param Success boolean
---@return boolean
function UJsonFieldData:GetBool(Key, Success) end
---@param dataString FString
---@return boolean
function UJsonFieldData:FromString(dataString) end
---@param FilePath FString
---@return boolean
function UJsonFieldData:FromFile(FilePath) end
---@return UJsonFieldData
function UJsonFieldData:Create() end


