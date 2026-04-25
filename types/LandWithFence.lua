---@meta

---@class ALandWithFence_C : AMTHouse
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Fences_0 TArray<AActor>
---@field FenceStep_0 FIntPoint
---@field ['Fence Actor Class'] TSubclassOf<AActor>
local ALandWithFence_C = {}

---@param Area_Size FIntPoint
ALandWithFence_C['Create Fences'] = function(self, Area_Size) end
function ALandWithFence_C:ClearFences() end
---@param NewAreaSize FIntPoint
function ALandWithFence_C:ReceiveSpawnFences(NewAreaSize) end
---@param EntryPoint int32
function ALandWithFence_C:ExecuteUbergraph_LandWithFence(EntryPoint) end


