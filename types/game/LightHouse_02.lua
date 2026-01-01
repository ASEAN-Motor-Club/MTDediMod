---@meta

---@class ALightHouse_02_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field ChildActor UChildActorComponent
---@field Light_Rotation_Rotation_4E1FB7DA4101081EE51C8E9EDFBE8863 float
---@field Light_Rotation__Direction_4E1FB7DA4101081EE51C8E9EDFBE8863 ETimelineDirection::Type
---@field ['Light Rotation'] UTimelineComponent
---@field ['Rotate Angle'] double
local ALightHouse_02_C = {}

ALightHouse_02_C['Light Rotation__FinishedFunc'] = function(self, ) end
ALightHouse_02_C['Light Rotation__UpdateFunc'] = function(self, ) end
---@param DeltaSeconds float
function ALightHouse_02_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function ALightHouse_02_C:ExecuteUbergraph_LightHouse_02(EntryPoint) end


