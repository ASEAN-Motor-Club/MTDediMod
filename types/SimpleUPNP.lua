---@meta

---@class FCommonLinkProperties
---@field WANAccessType FString
---@field Layer1UpstreamMaxBitRate FString
---@field Layer1DownstreamMaxBitRate FString
---@field PhysicalLinkStatus FString
local FCommonLinkProperties = {}



---@class FDeviceInfo
---@field Location FString
---@field Server FString
---@field CacheContorl FString
---@field Ext FString
---@field ST FString
---@field USN FString
---@field Date FString
local FDeviceInfo = {}



---@class FDeviceStatusInfo
---@field Uptime int32
---@field ConnectionStatus FString
---@field LastConnectionError FString
---@field ExternalIPAddress FString
---@field LocalIPAddress FString
---@field DeviceLocation FString
---@field ConnectionType FString
---@field PossibleConnectionTypes FString
local FDeviceStatusInfo = {}



---@class FManufactureInfo
---@field SpecVersion FString
---@field FriendlyName FString
---@field Manufacturer FString
---@field ManufacturerURL FString
---@field ModelDescription FString
---@field ModelName FString
---@field ModelNumber FString
---@field ModelURL FString
---@field SerialNumber FString
local FManufactureInfo = {}



---@class FSimpleUPNPInfo
---@field Protocol FString
---@field ExternalPort FString
---@field InternalPort FString
---@field InAddress FString
---@field RemoteHost FString
---@field Desc FString
---@field Duration FString
---@field Enabled boolean
local FSimpleUPNPInfo = {}



---@class FUPNPDeviceInfo
---@field Manufacture FManufactureInfo
---@field DeviceStatusInfo FDeviceStatusInfo
---@field CommonLinkProperties FCommonLinkProperties
---@field DeviceList TArray<FDeviceInfo>
---@field CurrentDeviceIndex int32
---@field ErrorCode FString
local FUPNPDeviceInfo = {}



---@class UAddPortCallbackProxy : UOnlineBlueprintCallProxyBase
---@field OnSuccess FAddPortCallbackProxyOnSuccess
---@field OnFailure FAddPortCallbackProxyOnFailure
local UAddPortCallbackProxy = {}

---@param PNPInfo FSimpleUPNPInfo
---@return UAddPortCallbackProxy
function UAddPortCallbackProxy:CreateProxyObjectForAddPort(PNPInfo) end


---@class UGetPortListCallbackProxy : UOnlineBlueprintCallProxyBase
---@field OnSuccess FGetPortListCallbackProxyOnSuccess
---@field OnFailure FGetPortListCallbackProxyOnFailure
local UGetPortListCallbackProxy = {}

---@param WorldContextObject UObject
---@param Refresh boolean
---@param AllowRetry boolean
---@param OnlySearchDevices boolean
---@param Location FString
---@return UGetPortListCallbackProxy
function UGetPortListCallbackProxy:CreateProxyObjectForGetPortList(WorldContextObject, Refresh, AllowRetry, OnlySearchDevices, Location) end


---@class UPerformAllDevicesCallbackProxy : UOnlineBlueprintCallProxyBase
---@field OnSuccess FPerformAllDevicesCallbackProxyOnSuccess
---@field OnFailure FPerformAllDevicesCallbackProxyOnFailure
---@field World UWorld
local UPerformAllDevicesCallbackProxy = {}

---@param WorldContextObject UObject
---@param PNPInfo FSimpleUPNPInfo
---@param Action UPNPAction
---@return UPerformAllDevicesCallbackProxy
function UPerformAllDevicesCallbackProxy:CreateProxyObjectForPerformAllDevices(WorldContextObject, PNPInfo, Action) end


---@class URemovePortCallbackProxy : UOnlineBlueprintCallProxyBase
---@field OnSuccess FRemovePortCallbackProxyOnSuccess
---@field OnFailure FRemovePortCallbackProxyOnFailure
local URemovePortCallbackProxy = {}

---@param PNPInfo FSimpleUPNPInfo
---@return URemovePortCallbackProxy
function URemovePortCallbackProxy:CreateProxyObjectForRemovePort(PNPInfo) end


---@class USimpleUPNPBlueprintLibrary : UBlueprintFunctionLibrary
local USimpleUPNPBlueprintLibrary = {}

---@param State UPNPState
---@return boolean
function USimpleUPNPBlueprintLibrary:GetUPNPState(State) end
---@param DeviceInfo FUPNPDeviceInfo
---@return boolean
function USimpleUPNPBlueprintLibrary:GetDeviceInfo(DeviceInfo) end
---@param PortList TArray<FSimpleUPNPInfo>
---@return boolean
function USimpleUPNPBlueprintLibrary:GetCurrentPortMappingList(PortList) end


---@class UUPNPModule : UObject
local UUPNPModule = {}


