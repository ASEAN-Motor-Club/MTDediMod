---@enum ELiveLinkCameraProjectionMode
local ELiveLinkCameraProjectionMode = {
    Perspective = 0,
    Orthographic = 1,
    ELiveLinkCameraProjectionMode_MAX = 2,
}

---@enum ELiveLinkSourceMode
local ELiveLinkSourceMode = {
    Latest = 0,
    EngineTime = 1,
    Timecode = 2,
    ELiveLinkSourceMode_MAX = 3,
}

---@enum ELiveLinkSubjectState
local ELiveLinkSubjectState = {
    Connected = 0,
    Unresponsive = 1,
    Disconnected = 2,
    InvalidOrDisabled = 3,
    Unknown = 4,
    ELiveLinkSubjectState_MAX = 5,
}

