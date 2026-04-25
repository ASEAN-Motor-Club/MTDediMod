---@meta

---@class AMixi_C : AMTVehicleBaseBP_C
---@field UberGraphFrame FPointerToUberGraphFrame
---@field BlinkerLight_02 UBlinkerLight_01_C
---@field BlinkerLight_01 UBlinkerLight_01_C
---@field BlinkerLight_04 UBlinkerLight_01_C
---@field ReverseLight_02 UReverseLight_01_C
---@field TaliLight_02 UTaliLight_01_C
---@field ReverseLight_01 UReverseLight_01_C
---@field BlinkerLight_03 UBlinkerLight_01_C
---@field TaliLight_01 UTaliLight_01_C
---@field RearLight_01 UStaticMeshComponent
---@field FrontDomeLightSlot UMTVehiclePartSlotComponent
---@field Mixer_Tank UStaticMeshComponent
---@field Cargo_Mixer UStaticMeshComponent
---@field HeadLight_Left UMTVehicleHeadLight
---@field HeadLight_Right UMTVehicleHeadLight
---@field MTVehicleTruck UMTVehicleTruckComponent
---@field MTVehicleCargoSpace UMTVehicleCargoSpaceComponent
---@field RightSideLookDownMirror UMTMirrorComponent
---@field RightSideMirror UMTMirrorComponent
---@field LeftSideMirror UMTMirrorComponent
---@field PassengerSeat1 UMTSeatComponent
---@field DriverSeat UMTSeatComponent
---@field Differential2 UMTDifferentialComponent
---@field Wheel5 UMHWheelComponent
---@field Wheel4 UMHWheelComponent
---@field Differential1 UMTDifferentialComponent
---@field transmission UMHTransmissionComponent
---@field DefaultTankRelativeRotation FRotator
local AMixi_C = {}

---@param DeltaSeconds float
function AMixi_C:ReceiveTick(DeltaSeconds) end
function AMixi_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AMixi_C:ExecuteUbergraph_Mixi(EntryPoint) end


