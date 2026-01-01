---@meta

---@class A_Common_InventoryProp_C : A_Common_Prop_C
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Timeline_Degree_F9C35C2942E688BD727F6C9989859F85 float
---@field Timeline__Direction_F9C35C2942E688BD727F6C9989859F85 ETimelineDirection::Type
---@field Timeline UTimelineComponent
local A_Common_InventoryProp_C = {}

function A_Common_InventoryProp_C:Timeline__FinishedFunc() end
function A_Common_InventoryProp_C:Timeline__UpdateFunc() end
---@param Interactor AActor
---@param Param1 float
function A_Common_InventoryProp_C:HandleUse(Interactor, Param1) end
---@param EntryPoint int32
function A_Common_InventoryProp_C:ExecuteUbergraph__Common_InventoryProp(EntryPoint) end


