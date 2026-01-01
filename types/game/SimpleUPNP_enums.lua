---@enum ESimpleUPNPErrorCode
local ESimpleUPNPErrorCode = {
    SUCCESS = 0,
    UNKNOWN = 1,
    IGD_NETWORK_INIT_FAILED = 2,
    IGD_REQUEST_FAILED = 3,
    IGD_GET_VALID_FAILED = 4,
    IGD_GET_STATUS_FAILED = 5,
    IGD_INVALID_DEVICE_LIST = 6,
    GET_EXTERNALIP_FAILED = 7,
    GET_COMMANLINK_PROPERTIES_FAILED = 8,
    GET_CONNECTION_INFO_FAILED = 9,
    GET_GENERIC_PORTMAPPING_ENTRY_FAILED = 10,
    GET_DEVICE_LIST_FAILED = 11,
    ADD_MAPPING_FAILED = 12,
    DELETE_MAPPING_FAILED = 13,
    REQUEST_TIMEOUT = 14,
    NOT_FINISHED_PREVIOUS_REQUEST = 15,
    ESimpleUPNPErrorCode_MAX = 16,
}

---@enum UPNPAction
local UPNPAction = {
    UPNPAction_ADD_Port = 0,
    UPNPAction_DELETE_Port = 1,
    UPNPAction_MAX = 2,
}

---@enum UPNPState
local UPNPState = {
    UPNPState_IDLE = 0,
    UPNPState_DiscoverDevice = 1,
    UPNPState_GetValidIGD = 2,
    UPNPState_GetStatus = 3,
    UPNPState_GetExternalIP = 4,
    UPNPState_GetConnectionTypeInfo = 5,
    UPNPState_GetCommonLinkProperties = 6,
    UPNPState_AddPortMapping = 7,
    UPNPState_DeletePortMapping = 8,
    UPNPState_GetGenericPortMappingEntry = 9,
    UPNPState_MAX = 10,
}

