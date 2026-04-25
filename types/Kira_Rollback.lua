---@meta

---@class AKira_Rollback_C : AMTVehicleBaseBP_C
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTVehicleUtilitySlot1 UMTVehicleUtilitySlotComponent
---@field MTVehicleUtilitySlot UMTVehicleUtilitySlotComponent
---@field PassengerSeat2 UMTSeatComponent
---@field PassengerSeat1 UMTSeatComponent
---@field MTVehicleWrecker UMTVehicleWreckerComponent
---@field MTVehicleCargoSpace UMTVehicleCargoSpaceComponent
---@field ControlPanelInteraction_R UMTInteractableComponent
---@field ControlPanel_R UStaticMeshComponent
---@field ControlPanelSeat_R UMTSeatComponent
---@field Constraint_Slider UMTConstraintComponent
---@field Constraint_Tilt UMTConstraintComponent
---@field ControlPanelSeat_L UMTSeatComponent
---@field Bed UStaticMeshComponent
---@field Slider UStaticMeshComponent
---@field ControlPanelInteraction_L UMTInteractableComponent
---@field ControlPanel_L UStaticMeshComponent
---@field FrontDomeLightSlot UMTVehiclePartSlotComponent
---@field BlinkerLight_02 UBlinkerLight_01_C
---@field BlinkerLight_01 UBlinkerLight_01_C
---@field HeadLight_Right UMTVehicleHeadLight
---@field HeadLight_Left UMTVehicleHeadLight
---@field BlinkerLight_04 UBlinkerLight_01_C
---@field ReverseLight_02 UReverseLight_01_C
---@field TaliLight_02 UTaliLight_01_C
---@field ReverseLight_01 UReverseLight_01_C
---@field BlinkerLight_03 UBlinkerLight_01_C
---@field TaliLight_01 UTaliLight_01_C
---@field RightSideMirror UMTMirrorComponent
---@field LeftSideMirror UMTMirrorComponent
---@field DriverSeat UMTSeatComponent
---@field Differential1 UMTDifferentialComponent
---@field transmission UMHTransmissionComponent
local AKira_Rollback_C = {}

function AKira_Rollback_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AKira_Rollback_C:ExecuteUbergraph_Kira_Rollback(EntryPoint) end


