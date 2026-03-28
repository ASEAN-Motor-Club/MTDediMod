---@meta

---@class A_Base_BreakableLight_C : AMTBreakable
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTComponentLOD UMTComponentLODComponent
---@field bIsTurnedOn boolean
---@field ['Register Distance'] float
local A_Base_BreakableLight_C = {}

function A_Base_BreakableLight_C:OnTurnOnChanged() end
function A_Base_BreakableLight_C:UserConstructionScript() end
function A_Base_BreakableLight_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function A_Base_BreakableLight_C:ReceiveTick(DeltaSeconds) end
function A_Base_BreakableLight_C:OnBroken_Event_0() end
A_Base_BreakableLight_C['On Rolling Tick'] = function(self, ) end
function A_Base_BreakableLight_C:BndEvt___Base_Light_MTComponentLOD_K2Node_ComponentBoundEvent_0_MTSimpleDynamicEvent__DelegateSignature() end
---@param EntryPoint int32
function A_Base_BreakableLight_C:ExecuteUbergraph__Base_BreakableLight(EntryPoint) end


