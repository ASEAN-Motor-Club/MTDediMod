---@meta

---@class FSimpleControllerAxisStatus
local FSimpleControllerAxisStatus = {}


---@class FSimpleControllerComboStruct
local FSimpleControllerComboStruct = {}


---@class FSimpleControllerDevice
local FSimpleControllerDevice = {}


---@class FSimpleControllerForceFeedbackEffect
local FSimpleControllerForceFeedbackEffect = {}


---@class USimpleControllerBPLibrary : UBlueprintFunctionLibrary
---@field onButtonDownEventDelegate FSimpleControllerBPLibraryOnButtonDownEventDelegate
---@field onButtonUpEventDelegate FSimpleControllerBPLibraryOnButtonUpEventDelegate
---@field onDirectionalPadEventDelegate FSimpleControllerBPLibraryOnDirectionalPadEventDelegate
---@field onBallMovedEventDelegate FSimpleControllerBPLibraryOnBallMovedEventDelegate
---@field onaxisMovedEventDelegate FSimpleControllerBPLibraryOnaxisMovedEventDelegate
---@field ondeviceAttachedEventDelegate FSimpleControllerBPLibraryOndeviceAttachedEventDelegate
---@field ondeviceDetachedEventDelegate FSimpleControllerBPLibraryOndeviceDetachedEventDelegate
---@field oncomboEventDelegate FSimpleControllerBPLibraryOncomboEventDelegate
local USimpleControllerBPLibrary = {}

function USimpleControllerBPLibrary:stopController() end
---@param device FSimpleControllerDevice
---@param gain int32
function USimpleControllerBPLibrary:setGainForceFeedback(device, gain) end
---@param device FSimpleControllerDevice
---@param autocenter int32
function USimpleControllerBPLibrary:setAutocenterForceFeedback(device, autocenter) end
---@param directoryType ESimpleControllerDirectoryType
---@param deviceIndex int32
---@param fileNameWithPath FString
---@param createDirectory boolean
---@return boolean
function USimpleControllerBPLibrary:saveMapping(directoryType, deviceIndex, fileNameWithPath, createDirectory) end
---@param successful boolean
---@param errorMessage FString
---@param deviceIndex int32
---@param strengthSmallMotor float
---@param strengthLargeMotor float
---@param lengthInMilliseconds int64
function USimpleControllerBPLibrary:Rumble(successful, errorMessage, deviceIndex, strengthSmallMotor, strengthLargeMotor, lengthInMilliseconds) end
---@param deviceIndex int32
---@param oldButtonID int32
function USimpleControllerBPLibrary:resetButtonToDefaultMapping(deviceIndex, oldButtonID) end
---@param deviceIndex int32
---@param oldAxisID int32
function USimpleControllerBPLibrary:resetAxisToDefaultMapping(deviceIndex, oldAxisID) end
---@param deviceIndex int32
---@param axisID int32
function USimpleControllerBPLibrary:resetAxisInverting(deviceIndex, axisID) end
---@param deviceIndex int32
function USimpleControllerBPLibrary:resetAllButtonsToDefaultMapping(deviceIndex) end
---@param deviceIndex int32
function USimpleControllerBPLibrary:resetAllAxisToDefaultMapping(deviceIndex) end
---@param deviceIndex int32
function USimpleControllerBPLibrary:resetAllAxisInverting(deviceIndex) end
---@param Name FString
function USimpleControllerBPLibrary:removeGamepadCombo(Name) end
---@param Name FString
---@param maxTimeInSeconds float
---@param combosArray TArray<ESimpleControllerComboGamepadAction>
function USimpleControllerBPLibrary:registerGamepadCombo(Name, maxTimeInSeconds, combosArray) end
---@param directoryType ESimpleControllerDirectoryType
---@param deviceIndex int32
---@param fileNameWithPath FString
---@return boolean
function USimpleControllerBPLibrary:loadMapping(directoryType, deviceIndex, fileNameWithPath) end
---@param deviceIndex int32
---@param axisID int32
function USimpleControllerBPLibrary:InvertAxis(deviceIndex, axisID) end
---@param refreshRate ESimpleControllerRefreshRate
---@param xinputAsDirectinput boolean
---@param useGamepadAPI boolean
function USimpleControllerBPLibrary:initController(refreshRate, xinputAsDirectinput, useGamepadAPI) end
---@return USimpleControllerBPLibrary
function USimpleControllerBPLibrary:getSimpleControllerTarget() end
---@param connectionIndex ESimpleControllerConnectionIndex
---@param refreshRate ESimpleControllerPersistentEventRefreshRate
---@return USimpleControllerCustomEvents
function USimpleControllerBPLibrary:getPersistentGamepadEvent(connectionIndex, refreshRate) end
---@param connectionIndex ESimpleControllerConnectionIndex
---@return USimpleControllerCustomEvents
function USimpleControllerBPLibrary:getGamepadEvent(connectionIndex) end
---@param Direction ESimpleControllerDirectionalPad
---@return FString
function USimpleControllerBPLibrary:GetDirectinalPadValueString(Direction) end
---@param device FSimpleControllerDevice
---@param powerLevel ESimpleControllerPowerLevel
function USimpleControllerBPLibrary:getCurrentPowerLevel(device, powerLevel) end
---@return TArray<FSimpleControllerDevice>
function USimpleControllerBPLibrary:getConnectedControllers() end
---@param connectionIndex int32
---@param found boolean
---@param deviceIndex int32
function USimpleControllerBPLibrary:findDeviceIndexByConnectionIndex(connectionIndex, found, deviceIndex) end
---@param deviceIndex int32
---@param found boolean
---@return FSimpleControllerDevice
function USimpleControllerBPLibrary:findControllerByDeviceIndex(deviceIndex, found) end
---@param DeviceID FString
---@param found boolean
---@return FSimpleControllerDevice
function USimpleControllerBPLibrary:findControllerByDeviceID(DeviceID, found) end
---@param DeviceID FString
---@param directionalPadValue int32
---@param directionalPadIndex int32
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:directionalPadEventDelegate__DelegateSignature(DeviceID, directionalPadValue, directionalPadIndex, deviceIndex, device) end
---@param DeviceID FString
---@param directionalPadValue int32
---@param directionalPadIndex int32
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:directionalPadEventDelegate(DeviceID, directionalPadValue, directionalPadIndex, deviceIndex, device) end
---@param directionalPadValue int32
---@param Direction ESimpleControllerDirectionalPad
function USimpleControllerBPLibrary:directinalPadValueToDirection(directionalPadValue, Direction) end
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:deviceDetachedEventDelegate__DelegateSignature(device) end
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:deviceDetachedEventDelegate(device) end
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:deviceAttachedEventDelegate__DelegateSignature(device) end
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:deviceAttachedEventDelegate(device) end
---@param ForceFeedbackEffect FSimpleControllerForceFeedbackEffect
function USimpleControllerBPLibrary:destroyForceFeedbackEffect(ForceFeedbackEffect) end
---@param ForceFeedbackEffect FSimpleControllerForceFeedbackEffect
---@param successful boolean
---@param errorMessage FString
---@param device FSimpleControllerDevice
---@param directionType ESimpleControllerForceFeedbackDirectionType
---@param directionX int32
---@param directionY int32
---@param directionZ int32
---@param Length int32
---@param Delay int32
---@param startLevel float
---@param endLevel float
---@param attackLength int32
---@param attackLevel float
---@param fadeLength int32
---@param fadeLevel float
function USimpleControllerBPLibrary:createForceFeedbackEffectRamp(ForceFeedbackEffect, successful, errorMessage, device, directionType, directionX, directionY, directionZ, Length, Delay, startLevel, endLevel, attackLength, attackLevel, fadeLength, fadeLevel) end
---@param ForceFeedbackEffect FSimpleControllerForceFeedbackEffect
---@param successful boolean
---@param errorMessage FString
---@param device FSimpleControllerDevice
---@param PeriodicType ESimpleControllerForceFeedbackEffectPeriodicType
---@param directionType ESimpleControllerForceFeedbackDirectionType
---@param directionX int32
---@param directionY int32
---@param directionZ int32
---@param Length int32
---@param Delay int32
---@param Period int32
---@param Magnitude float
---@param Offset int32
---@param phase int32
---@param attackLength int32
---@param attackLevel float
---@param fadeLength int32
---@param fadeLevel float
function USimpleControllerBPLibrary:createForceFeedbackEffectPeriodic(ForceFeedbackEffect, successful, errorMessage, device, PeriodicType, directionType, directionX, directionY, directionZ, Length, Delay, Period, Magnitude, Offset, phase, attackLength, attackLevel, fadeLength, fadeLevel) end
---@param ForceFeedbackEffect FSimpleControllerForceFeedbackEffect
---@param successful boolean
---@param errorMessage FString
---@param device FSimpleControllerDevice
---@param ConditionType ESimpleControllerForceFeedbackEffectConditionType
---@param useDirectionX boolean
---@param useDirectionY boolean
---@param useDirectionZ boolean
---@param Length int32
---@param Delay int32
---@param rightLevel float
---@param leftLevel float
---@param rightLevelIncreaseSpeed int32
---@param leftLevelIncreaseSpeed int32
---@param deadband float
---@param Center int32
function USimpleControllerBPLibrary:createForceFeedbackEffectCondition(ForceFeedbackEffect, successful, errorMessage, device, ConditionType, useDirectionX, useDirectionY, useDirectionZ, Length, Delay, rightLevel, leftLevel, rightLevelIncreaseSpeed, leftLevelIncreaseSpeed, deadband, Center) end
---@param device FSimpleControllerDevice
---@param comboName FString
---@param comboTimeInSeconds float
function USimpleControllerBPLibrary:comboEventDelegate__DelegateSignature(device, comboName, comboTimeInSeconds) end
---@param device FSimpleControllerDevice
---@param comboName FString
---@param comboTimeInSeconds float
function USimpleControllerBPLibrary:comboEventDelegate(device, comboName, comboTimeInSeconds) end
---@param deviceIndex int32
---@param oldButtonID int32
---@param newButtonID int32
function USimpleControllerBPLibrary:changeButtonMapping(deviceIndex, oldButtonID, newButtonID) end
---@param deviceIndex int32
---@param oldAxisID int32
---@param newAxisID int32
function USimpleControllerBPLibrary:changeAxisMapping(deviceIndex, oldAxisID, newAxisID) end
---@param DeviceID FString
---@param buttonID int32
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:buttonUpEventDelegate__DelegateSignature(DeviceID, buttonID, deviceIndex, device) end
---@param DeviceID FString
---@param buttonID int32
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:buttonUpEventDelegate(DeviceID, buttonID, deviceIndex, device) end
---@param buttonID int32
---@param buttons ESimpleControllerButtons
function USimpleControllerBPLibrary:buttonIDToButton(buttonID, buttons) end
---@param DeviceID FString
---@param buttonID int32
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:buttonDownEventDelegate__DelegateSignature(DeviceID, buttonID, deviceIndex, device) end
---@param DeviceID FString
---@param buttonID int32
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:buttonDownEventDelegate(DeviceID, buttonID, deviceIndex, device) end
---@param ForceFeedbackEffect FSimpleControllerForceFeedbackEffect
---@param effectID int32
---@param successful boolean
function USimpleControllerBPLibrary:breakForceFeedbackEffect(ForceFeedbackEffect, effectID, successful) end
---@param device FSimpleControllerDevice
---@param deviceIndex int32
---@param connectionIndex int32
---@param DeviceID FString
---@param deviceName FString
---@param controllerName FString
---@param vendorID int32
---@param productID int32
---@param numAxes int32
---@param numButtons int32
---@param numDirectionalPadAxes int32
---@param numBalls int32
---@param hasHaptic boolean
---@param gamepadAPI_Support boolean
---@param isXinput boolean
---@param Type ESimpleControllerType
function USimpleControllerBPLibrary:breakDeviceInfo(device, deviceIndex, connectionIndex, DeviceID, deviceName, controllerName, vendorID, productID, numAxes, numButtons, numDirectionalPadAxes, numBalls, hasHaptic, gamepadAPI_Support, isXinput, Type) end
---@param device FSimpleControllerDevice
---@param hasHaptic boolean
---@param forceFeedback_CONSTANT boolean
---@param forceFeedback_SINE boolean
---@param forceFeedback_LEFTRIGHT boolean
---@param forceFeedback_TRIANGLE boolean
---@param forceFeedback_SAWTOOTHUP boolean
---@param forceFeedback_SAWTOOTHDOWN boolean
---@param forceFeedback_RAMP boolean
---@param forceFeedback_SPRING boolean
---@param forceFeedback_DAMPER boolean
---@param forceFeedback_INERTIA boolean
---@param forceFeedback_FRICTION boolean
---@param forceFeedback_CUSTOM boolean
---@param forceFeedback_GAIN boolean
---@param forceFeedback_AUTOCENTER boolean
---@param forceFeedback_STATUS boolean
---@param forceFeedback_PAUSE boolean
---@param forceFeedback_POLAR boolean
---@param forceFeedback_CARTESIAN boolean
---@param forceFeedback_SPHERICAL boolean
---@param forceFeedback_INFINITY boolean
---@param maxSimultaneouslyEffects int32
function USimpleControllerBPLibrary:breakDeviceForceFeedbackInfo(device, hasHaptic, forceFeedback_CONSTANT, forceFeedback_SINE, forceFeedback_LEFTRIGHT, forceFeedback_TRIANGLE, forceFeedback_SAWTOOTHUP, forceFeedback_SAWTOOTHDOWN, forceFeedback_RAMP, forceFeedback_SPRING, forceFeedback_DAMPER, forceFeedback_INERTIA, forceFeedback_FRICTION, forceFeedback_CUSTOM, forceFeedback_GAIN, forceFeedback_AUTOCENTER, forceFeedback_STATUS, forceFeedback_PAUSE, forceFeedback_POLAR, forceFeedback_CARTESIAN, forceFeedback_SPHERICAL, forceFeedback_INFINITY, maxSimultaneouslyEffects) end
---@param axisStatus FSimpleControllerAxisStatus
---@param leftStickX float
---@param leftStickY float
---@param rightStickX float
---@param rightStickY float
---@param leftTrigger float
---@param rightTrigger float
function USimpleControllerBPLibrary:breakAxisStatus(axisStatus, leftStickX, leftStickY, rightStickX, rightStickY, leftTrigger, rightTrigger) end
---@param DeviceID FString
---@param ballID int32
---@param xRel float
---@param yRel int32
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:ballMovedEventDelegate__DelegateSignature(DeviceID, ballID, xRel, yRel, device) end
---@param DeviceID FString
---@param ballID int32
---@param xRel int32
---@param yRel int32
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:ballMovedEventDelegate(DeviceID, ballID, xRel, yRel, device) end
---@param DeviceID FString
---@param axisID int32
---@param AxisValue float
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:axisMovedEventDelegate__DelegateSignature(DeviceID, axisID, AxisValue, deviceIndex, device) end
---@param DeviceID FString
---@param axisID int32
---@param AxisValue float
---@param deviceIndex int32
---@param device FSimpleControllerDevice
function USimpleControllerBPLibrary:axisMovedEventDelegate(DeviceID, axisID, AxisValue, deviceIndex, device) end


---@class USimpleControllerCustomEvents : UObject
---@field onControllerButton_A FSimpleControllerCustomEventsOnControllerButton_A
---@field onControllerButton_B FSimpleControllerCustomEventsOnControllerButton_B
---@field onControllerButton_X FSimpleControllerCustomEventsOnControllerButton_X
---@field onControllerButton_Y FSimpleControllerCustomEventsOnControllerButton_Y
---@field onControllerButton_BACK FSimpleControllerCustomEventsOnControllerButton_BACK
---@field onControllerButton_GUIDE FSimpleControllerCustomEventsOnControllerButton_GUIDE
---@field onControllerButton_START FSimpleControllerCustomEventsOnControllerButton_START
---@field onControllerButton_LEFTSTICK FSimpleControllerCustomEventsOnControllerButton_LEFTSTICK
---@field onControllerButton_RIGHTSTICK FSimpleControllerCustomEventsOnControllerButton_RIGHTSTICK
---@field onControllerButton_LEFTSHOULDER FSimpleControllerCustomEventsOnControllerButton_LEFTSHOULDER
---@field onControllerButton_RIGHTSHOULDER FSimpleControllerCustomEventsOnControllerButton_RIGHTSHOULDER
---@field onControllerButton_DPAD_UP FSimpleControllerCustomEventsOnControllerButton_DPAD_UP
---@field onControllerButton_DPAD_DOWN FSimpleControllerCustomEventsOnControllerButton_DPAD_DOWN
---@field onControllerButton_DPAD_LEFT FSimpleControllerCustomEventsOnControllerButton_DPAD_LEFT
---@field onControllerButton_DPAD_RIGHT FSimpleControllerCustomEventsOnControllerButton_DPAD_RIGHT
---@field onControllerButton_ALL_PRESSED FSimpleControllerCustomEventsOnControllerButton_ALL_PRESSED
---@field onControllerButton_ALL_RELEASED FSimpleControllerCustomEventsOnControllerButton_ALL_RELEASED
---@field onControllerAxis_LEFT_X FSimpleControllerCustomEventsOnControllerAxis_LEFT_X
---@field onControllerAxis_LEFT_Y FSimpleControllerCustomEventsOnControllerAxis_LEFT_Y
---@field onControllerAxis_RIGHT_X FSimpleControllerCustomEventsOnControllerAxis_RIGHT_X
---@field onControllerAxis_RIGHT_Y FSimpleControllerCustomEventsOnControllerAxis_RIGHT_Y
---@field onControllerAxis_TRIGGER_LEFT FSimpleControllerCustomEventsOnControllerAxis_TRIGGER_LEFT
---@field onControllerAxis_TRIGGER_RIGHT FSimpleControllerCustomEventsOnControllerAxis_TRIGGER_RIGHT
---@field onControllerAxis_ALL FSimpleControllerCustomEventsOnControllerAxis_ALL
local USimpleControllerCustomEvents = {}

---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_Y(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_X(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_START__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_START(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_RIGHTSTICK__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_RIGHTSTICK(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_RIGHTSHOULDER__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_RIGHTSHOULDER(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_LEFTSTICK__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_LEFTSTICK(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_LEFTSHOULDER__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_LEFTSHOULDER(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_GUIDE__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_GUIDE(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_DPAD_UP__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_DPAD_UP(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_DPAD_RIGHT__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_DPAD_RIGHT(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_DPAD_LEFT__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_DPAD_LEFT(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_DPAD_DOWN__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_DPAD_DOWN(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_ButtonFaceTop__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_ButtonFaceRight__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_ButtonFaceLeft__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_ButtonFaceBottom__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:ControllerButton_BACK__DelegateSignature(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_BACK(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_B(status) end
---@param status ESimpleControllerAllButtonReleasedStatus
function USimpleControllerCustomEvents:ControllerButton_ALL_RELEASED__DelegateSignature(status) end
---@param status ESimpleControllerAllButtonReleasedStatus
function USimpleControllerCustomEvents:controllerButton_ALL_RELEASED(status) end
---@param status ESimpleControllerAllButtonPressedStatus
function USimpleControllerCustomEvents:ControllerButton_ALL_PRESSED__DelegateSignature(status) end
---@param status ESimpleControllerAllButtonPressedStatus
function USimpleControllerCustomEvents:controllerButton_ALL_PRESSED(status) end
---@param status ESimpleControllerButtonStatus
function USimpleControllerCustomEvents:controllerButton_A(status) end
---@param AxisValue float
function USimpleControllerCustomEvents:ControllerAxis_TRIGGER_RIGHT__DelegateSignature(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:controllerAxis_TRIGGER_RIGHT(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:ControllerAxis_TRIGGER_LEFT__DelegateSignature(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:controllerAxis_TRIGGER_LEFT(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:ControllerAxis_RIGHT_Y__DelegateSignature(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:controllerAxis_RIGHT_Y(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:ControllerAxis_RIGHT_X__DelegateSignature(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:controllerAxis_RIGHT_X(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:ControllerAxis_LEFT_Y__DelegateSignature(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:controllerAxis_LEFT_Y(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:ControllerAxis_LEFT_X__DelegateSignature(AxisValue) end
---@param AxisValue float
function USimpleControllerCustomEvents:controllerAxis_LEFT_X(AxisValue) end
---@param axisValues FSimpleControllerAxisStatus
function USimpleControllerCustomEvents:ControllerAxis_ALL__DelegateSignature(axisValues) end
---@param axisValues FSimpleControllerAxisStatus
function USimpleControllerCustomEvents:controllerAxis_ALL(axisValues) end


