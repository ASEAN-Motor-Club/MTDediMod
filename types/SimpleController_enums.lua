---@enum ESimpleControllerAllButtonPressedStatus
local ESimpleControllerAllButtonPressedStatus = {
    ButtonFaceBottom = 0,
    ButtonFaceRight = 1,
    ButtonFaceLeft = 2,
    ButtonFaceTop = 3,
    LEFTSHOULDER = 4,
    RIGHTSHOULDER = 5,
    DPAD_UP = 6,
    DPAD_DOWN = 7,
    DPAD_LEFT = 8,
    DPAD_RIGHT = 9,
    DPAD_LEFTUP = 10,
    DPAD_LEFTDOWN = 11,
    DPAD_RIGHTUP = 12,
    DPAD_RIGHTDOWN = 13,
    BACK = 14,
    GUIDE = 15,
    START = 16,
    LEFTSTICK = 17,
    RIGHTSTICK = 18,
    ESimpleControllerAllButtonPressedStatus_MAX = 19,
}

---@enum ESimpleControllerAllButtonReleasedStatus
local ESimpleControllerAllButtonReleasedStatus = {
    ButtonFaceBottom = 0,
    ButtonFaceRight = 1,
    ButtonFaceLeft = 2,
    ButtonFaceTop = 3,
    LEFTSHOULDER = 4,
    RIGHTSHOULDER = 5,
    DPAD_UP = 6,
    DPAD_DOWN = 7,
    DPAD_LEFT = 8,
    DPAD_RIGHT = 9,
    DPAD_LEFTUP = 10,
    DPAD_LEFTDOWN = 11,
    DPAD_RIGHTUP = 12,
    DPAD_RIGHTDOWN = 13,
    BACK = 14,
    GUIDE = 15,
    START = 16,
    LEFTSTICK = 17,
    RIGHTSTICK = 18,
    ESimpleControllerAllButtonReleasedStatus_MAX = 19,
}

---@enum ESimpleControllerButtonStatus
local ESimpleControllerButtonStatus = {
    Pressed = 0,
    Released = 1,
    ESimpleControllerButtonStatus_MAX = 2,
}

---@enum ESimpleControllerButtons
local ESimpleControllerButtons = {
    Button_0 = 0,
    Button_1 = 1,
    Button_2 = 2,
    Button_3 = 3,
    Button_4 = 4,
    Button_5 = 5,
    Button_6 = 6,
    Button_7 = 7,
    Button_8 = 8,
    Button_9 = 9,
    Button_10 = 10,
    Button_11 = 11,
    Button_12 = 12,
    Button_13 = 13,
    Button_14 = 14,
    Button_15 = 15,
    Button_16 = 16,
    Button_17 = 17,
    Button_18 = 18,
    Button_19 = 19,
    Button_20 = 20,
    Button_MAX = 21,
}

---@enum ESimpleControllerComboGamepadAction
local ESimpleControllerComboGamepadAction = {
    ButtonFaceBottomClicked = 0,
    ButtonFaceRightClicked = 1,
    ButtonFaceLeftClicked = 2,
    ButtonFaceTopClicked = 3,
    LEFTSHOULDERClicked = 4,
    RIGHTSHOULDERClicked = 5,
    DPAD_UPClicked = 6,
    DPAD_DOWNClicked = 7,
    DPAD_LEFTClicked = 8,
    DPAD_RIGHTClicked = 9,
    BACKClicked = 10,
    GUIDEClicked = 11,
    STARTClicked = 12,
    LEFTSTICKClicked = 13,
    RIGHTSTICKClicked = 14,
    ButtonFaceBottomPressed = 15,
    ButtonFaceRightPressed = 16,
    ButtonFaceLeftPressed = 17,
    ButtonFaceTopPressed = 18,
    LEFTSHOULDERPressed = 19,
    RIGHTSHOULDERPressed = 20,
    DPAD_UPPressed = 21,
    DPAD_DOWNPressed = 22,
    DPAD_LEFTPressed = 23,
    DPAD_RIGHTPressed = 24,
    BACKPressed = 25,
    GUIDEPressed = 26,
    STARTPressed = 27,
    LEFTSTICKPressed = 28,
    RIGHTSTICKPressed = 29,
    ButtonFaceBottomReleased = 30,
    ButtonFaceRightReleased = 31,
    ButtonFaceLeftReleased = 32,
    ButtonFaceTopReleased = 33,
    LEFTSHOULDERReleased = 34,
    RIGHTSHOULDERReleased = 35,
    DPAD_UPReleased = 36,
    DPAD_DOWNReleased = 37,
    DPAD_LEFTReleased = 38,
    DPAD_RIGHTReleased = 39,
    BACKReleased = 40,
    GUIDEReleased = 41,
    STARTReleased = 42,
    LEFTSTICKReleased = 43,
    RIGHTSTICKReleased = 44,
    ESimpleControllerComboGamepadAction_MAX = 45,
}

---@enum ESimpleControllerConnectionIndex
local ESimpleControllerConnectionIndex = {
    Index_0 = 0,
    Index_1 = 1,
    Index_2 = 2,
    Index_3 = 3,
    Index_4 = 4,
    Index_5 = 5,
    Index_6 = 6,
    Index_7 = 7,
    Index_8 = 8,
    Index_9 = 9,
    Index_10 = 10,
    Index_11 = 11,
    Index_12 = 12,
    Index_13 = 13,
    Index_14 = 14,
    Index_15 = 15,
    Index_MAX = 16,
}

---@enum ESimpleControllerDirectionalPad
local ESimpleControllerDirectionalPad = {
    CENTERED = 0,
    UP = 1,
    RIGHT = 2,
    DOWN = 3,
    LEFT = 4,
    RIGHTUP = 5,
    RIGHTDOWN = 6,
    LEFTUP = 7,
    LEFTDOWN = 8,
    ESimpleControllerDirectionalPad_MAX = 9,
}

---@enum ESimpleControllerDirectoryType
local ESimpleControllerDirectoryType = {
    GameDir = 0,
    AbsoluteDir = 1,
    ESimpleControllerDirectoryType_MAX = 2,
}

---@enum ESimpleControllerForceFeedbackDirectionType
local ESimpleControllerForceFeedbackDirectionType = {
    CARTESIAN = 0,
    POLAR = 1,
    SPHERICAL = 2,
    ESimpleControllerForceFeedbackDirectionType_MAX = 3,
}

---@enum ESimpleControllerForceFeedbackEffectConditionType
local ESimpleControllerForceFeedbackEffectConditionType = {
    SPRING = 0,
    DAMPER = 1,
    INERTIA = 2,
    FRICTION = 3,
    ESimpleControllerForceFeedbackEffectConditionType_MAX = 4,
}

---@enum ESimpleControllerForceFeedbackEffectPeriodicType
local ESimpleControllerForceFeedbackEffectPeriodicType = {
    SINE = 0,
    TRIANGLE = 1,
    SAWTOOTHUP = 2,
    SAWTOOTHDOWN = 3,
    ESimpleControllerForceFeedbackEffectPeriodicType_MAX = 4,
}

---@enum ESimpleControllerForceFeedbackEffectType
local ESimpleControllerForceFeedbackEffectType = {
    CONSTANT = 0,
    LEFTRIGHT = 1,
    ESimpleControllerForceFeedbackEffectType_MAX = 2,
}

---@enum ESimpleControllerPersistentEventRefreshRate
local ESimpleControllerPersistentEventRefreshRate = {
    Index_10 = 0,
    Index_20 = 1,
    Index_30 = 2,
    Index_40 = 3,
    Index_50 = 4,
    Index_60 = 5,
    Index_70 = 6,
    Index_80 = 7,
    Index_90 = 8,
    Index_100 = 9,
    Index_120 = 10,
    Index_140 = 11,
    Index_160 = 12,
    Index_180 = 13,
    Index_200 = 14,
    Index_MAX = 15,
}

---@enum ESimpleControllerPowerLevel
local ESimpleControllerPowerLevel = {
    UNKNOWN = 0,
    EMPTY = 1,
    LOW = 2,
    MEDIUM = 3,
    FULL = 4,
    WIRED = 5,
    MAX = 6,
}

---@enum ESimpleControllerRefreshRate
local ESimpleControllerRefreshRate = {
    Index_30 = 0,
    Index_60 = 1,
    Index_120 = 2,
    Index_240 = 3,
    Index_MAX = 4,
}

---@enum ESimpleControllerType
local ESimpleControllerType = {
    UNKNOWN = 0,
    GAMECONTROLLER = 1,
    WHEEL = 2,
    ARCADE_STICK = 3,
    FLIGHT_STICK = 4,
    DANCE_PAD = 5,
    GUITAR = 6,
    DRUM_KIT = 7,
    ARCADE_PAD = 8,
    THROTTLE = 9,
    ESimpleControllerType_MAX = 10,
}

