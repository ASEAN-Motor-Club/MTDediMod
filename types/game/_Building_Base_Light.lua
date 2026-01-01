---@meta

---@class A_Building_Base_Light_C : AMTBuilding
---@field UberGraphFrame FPointerToUberGraphFrame
---@field PointLight UPointLightComponent
---@field StaticMesh UStaticMeshComponent
---@field MTInteractable UMTInteractableComponent
---@field bIsTurnedOn boolean
local A_Building_Base_Light_C = {}

function A_Building_Base_Light_C:OnTurnOnChanged() end
function A_Building_Base_Light_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function A_Building_Base_Light_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function A_Building_Base_Light_C:ExecuteUbergraph__Building_Base_Light(EntryPoint) end


