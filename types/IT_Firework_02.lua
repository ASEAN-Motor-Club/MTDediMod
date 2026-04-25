---@meta

---@class AIT_Firework_02_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FireworkFountain_02 UAudioComponent
---@field NS_Firework_LightUp_01 UNiagaraComponent
---@field FireworkFountain_01 UAudioComponent
---@field FireworkCrackle_01 UAudioComponent
---@field NS_Firework_Small_02 UNiagaraComponent
---@field MTInteractable UMTInteractableComponent
---@field SM_FireworkFountain_01 UStaticMeshComponent
---@field LightUpDuration double
---@field FireworkDuration double
---@field FireworkFadeOutDuration double
---@field bIgnited boolean
---@field bUsed boolean
local AIT_Firework_02_C = {}

function AIT_Firework_02_C:ReceiveBeginPlay() end
function AIT_Firework_02_C:Ignite() end
---@param Interactor AActor
---@param Param1 float
function AIT_Firework_02_C:HandleUse(Interactor, Param1) end
---@param EntryPoint int32
function AIT_Firework_02_C:ExecuteUbergraph_IT_Firework_02(EntryPoint) end


