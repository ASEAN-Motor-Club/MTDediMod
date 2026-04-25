---@meta

---@class AIT_Firework_04_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FireworkFountain_01 UAudioComponent
---@field FireworkBurst_01 UAudioComponent
---@field FireworkRocket_01 UAudioComponent
---@field NS_Firework_LightUp_02 UNiagaraComponent
---@field NS_Firework_Middle_02 UNiagaraComponent
---@field MTInteractable UMTInteractableComponent
---@field SM_FireworkFountain_02 UStaticMeshComponent
---@field LightUpDuration double
---@field FireworkDuration double
---@field RocketDuration double
---@field RocketFadeOutDuration double
---@field bIgnited boolean
---@field bUsed boolean
local AIT_Firework_04_C = {}

function AIT_Firework_04_C:ReceiveBeginPlay() end
function AIT_Firework_04_C:Ignite() end
---@param Interactor AActor
---@param Param1 float
function AIT_Firework_04_C:HandleUse(Interactor, Param1) end
---@param EntryPoint int32
function AIT_Firework_04_C:ExecuteUbergraph_IT_Firework_04(EntryPoint) end


