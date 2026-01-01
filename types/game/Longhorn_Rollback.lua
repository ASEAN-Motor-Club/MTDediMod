---@meta

---@class ALonghorn_Rollback_C : AMTVehicleBaseBP_C
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTVehicleHeadLight1 UMTVehicleHeadLight
---@field BlinkerLight_011 UBlinkerLight_01_C
---@field BlinkerLight_01 UBlinkerLight_01_C
---@field MTVehicleHeadLight UMTVehicleHeadLight
---@field ControlPanelSeat_R UMTSeatComponent
---@field ControlPanel_R UStaticMeshComponent
---@field ControlPanelInteraction_R UMTInteractableComponent
---@field ControlPanelSeat_L UMTSeatComponent
---@field ControlPanel_L UStaticMeshComponent
---@field Piston_Raise_Upper UStaticMeshComponent
---@field Piston_Raise_Lower UStaticMeshComponent
---@field LeftSideMirror UMTMirrorComponent
---@field RightSideMirror UMTMirrorComponent
---@field FrontDomeLightSlot UMTVehiclePartSlotComponent
---@field Differential2 UMTDifferentialComponent
---@field Wheel5 UMHWheelComponent
---@field Wheel4 UMHWheelComponent
---@field MTVehicleUtilitySlot1 UMTVehicleUtilitySlotComponent
---@field MTVehicleUtilitySlot UMTVehicleUtilitySlotComponent
---@field PassengerSeat1 UMTSeatComponent
---@field MTVehicleWrecker UMTVehicleWreckerComponent
---@field MTVehicleCargoSpace UMTVehicleCargoSpaceComponent
---@field Constraint_Slider UMTConstraintComponent
---@field Constraint_Tilt UMTConstraintComponent
---@field Bed UStaticMeshComponent
---@field Slider UStaticMeshComponent
---@field ControlPanelInteraction_L UMTInteractableComponent
---@field ReverseLight_02 UReverseLight_01_C
---@field TaliLight_02 UTaliLight_01_C
---@field ReverseLight_01 UReverseLight_01_C
---@field TaliLight_01 UTaliLight_01_C
---@field DriverSeat UMTSeatComponent
---@field Differential1 UMTDifferentialComponent
---@field transmission UMHTransmissionComponent
local ALonghorn_Rollback_C = {}

function ALonghorn_Rollback_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function ALonghorn_Rollback_C:ExecuteUbergraph_Longhorn_Rollback(EntryPoint) end


