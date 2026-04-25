---@meta

---@class AIT_Firework_06_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field NS_Firework_LightUp_03 UNiagaraComponent
---@field FireworkFountain_01 UAudioComponent
---@field FireworkBurst_02 UAudioComponent
---@field FireworkRocket_01 UAudioComponent
---@field NS_Firework_Large_02 UNiagaraComponent
---@field MTInteractable UMTInteractableComponent
---@field SM_FireworkFountain_03 UStaticMeshComponent
---@field LightUpDuration double
---@field FireworkDuration double
---@field RocketDuration double
---@field RocketFadeOutDuration double
---@field bIgnited boolean
---@field bUsed boolean
local AIT_Firework_06_C = {}

function AIT_Firework_06_C:ReceiveBeginPlay() end
function AIT_Firework_06_C:Ignite() end
---@param Interactor AActor
---@param Param1 float
function AIT_Firework_06_C:HandleUse(Interactor, Param1) end
---@param EntryPoint int32
function AIT_Firework_06_C:ExecuteUbergraph_IT_Firework_06(EntryPoint) end


