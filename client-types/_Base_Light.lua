---@meta

---@class A_Base_Light_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTComponentLOD UMTComponentLODComponent
---@field bIsTurnedOn boolean
---@field LightMaterialIndex int32
---@field ['Register Distance'] float
local A_Base_Light_C = {}

function A_Base_Light_C:OnTurnOnChanged() end
function A_Base_Light_C:UserConstructionScript() end
function A_Base_Light_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function A_Base_Light_C:ReceiveTick(DeltaSeconds) end
function A_Base_Light_C:RollingTick() end
function A_Base_Light_C:BndEvt___Base_Light_MTComponentLOD_K2Node_ComponentBoundEvent_0_MTSimpleDynamicEvent__DelegateSignature() end
---@param EntryPoint int32
function A_Base_Light_C:ExecuteUbergraph__Base_Light(EntryPoint) end


