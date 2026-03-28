---@enum EMassCommandOperationType
local EMassCommandOperationType = {
    None = 0,
    Create = 1,
    Add = 2,
    Remove = 3,
    ChangeComposition = 4,
    Set = 5,
    Destroy = 6,
    MAX = 7,
}

---@enum EMassFragmentAccess
local EMassFragmentAccess = {
    None = 0,
    ReadOnly = 1,
    ReadWrite = 2,
    MAX = 3,
}

---@enum EMassFragmentPresence
local EMassFragmentPresence = {
    All = 0,
    Any = 1,
    None = 2,
    Optional = 3,
    MAX = 4,
}

---@enum EMassObservedOperation
local EMassObservedOperation = {
    Add = 0,
    Remove = 1,
    MAX = 2,
}

---@enum EMassProcessingPhase
local EMassProcessingPhase = {
    PrePhysics = 0,
    StartPhysics = 1,
    DuringPhysics = 2,
    EndPhysics = 3,
    PostPhysics = 4,
    FrameEnd = 5,
    MAX = 6,
}

---@enum EProcessorExecutionFlags
local EProcessorExecutionFlags = {
    None = 0,
    Standalone = 1,
    Server = 2,
    Client = 4,
    Editor = 8,
    EditorWorld = 16,
    AllNetModes = 7,
    AllWorldModes = 23,
    All = 31,
    EProcessorExecutionFlags_MAX = 32,
}

