---@meta

---@class AMotorTownPlayerControllerBP_C : AMotorTownPlayerController
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InGameHUDWidget UW_InGameHUD_C
---@field NewVar_0 UUserWidget
local AMotorTownPlayerControllerBP_C = {}

AMotorTownPlayerControllerBP_C['Tick Interactive Grass'] = function(self, ) end
---@param PreExposure float
function AMotorTownPlayerControllerBP_C:ReceiveSetPreExposure(PreExposure) end
---@param bHide boolean
function AMotorTownPlayerControllerBP_C:ReceiveHideInteractionBox(bHide) end
---@param DeltaSeconds float
function AMotorTownPlayerControllerBP_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AMotorTownPlayerControllerBP_C:ExecuteUbergraph_MotorTownPlayerControllerBP(EntryPoint) end


