---@meta

---@class AIT_PortableLight_01_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_Prop_Spotlight_Top_01 UStaticMeshComponent
---@field Mount UStaticMeshComponent
local AIT_PortableLight_01_C = {}

function AIT_PortableLight_01_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_PortableLight_01_C:ExecuteUbergraph_IT_PortableLight_01(EntryPoint) end


