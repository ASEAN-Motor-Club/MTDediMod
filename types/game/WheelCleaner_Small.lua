---@meta

---@class AWheelCleaner_Small_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FX_Sprinkler18 UParticleSystemComponent
---@field FX_Sprinkler1 UParticleSystemComponent
---@field FX_Sprinkler7 UParticleSystemComponent
---@field FX_Sprinkler8 UParticleSystemComponent
---@field FX_Sprinkler12 UParticleSystemComponent
---@field FX_Sprinkler11 UParticleSystemComponent
---@field FX_Sprinkler3 UParticleSystemComponent
---@field FX_Sprinkler15 UParticleSystemComponent
---@field FX_Sprinkler5 UParticleSystemComponent
---@field FX_Sprinkler30 UParticleSystemComponent
---@field FX_Sprinkler26 UParticleSystemComponent
---@field FX_Sprinkler24 UParticleSystemComponent
---@field FX_Sprinkler23 UParticleSystemComponent
---@field FX_Sprinkler22 UParticleSystemComponent
---@field FX_Sprinkler21 UParticleSystemComponent
---@field FX_Sprinkler19 UParticleSystemComponent
---@field FX_Sprinkler31 UParticleSystemComponent
---@field FX_Sprinkler29 UParticleSystemComponent
---@field FX_Sprinkler28 UParticleSystemComponent
---@field FX_Sprinkler27 UParticleSystemComponent
---@field FX_Sprinkler25 UParticleSystemComponent
---@field FX_Sprinkler20 UParticleSystemComponent
---@field FX_Sprinkler17 UParticleSystemComponent
---@field FX_Sprinkler16 UParticleSystemComponent
---@field FX_Sprinkler10 UParticleSystemComponent
---@field FX_Sprinkler9 UParticleSystemComponent
---@field FX_Sprinkler13 UParticleSystemComponent
---@field FX_Sprinkler14 UParticleSystemComponent
---@field FX_Sprinkler4 UParticleSystemComponent
---@field FX_Sprinkler2 UParticleSystemComponent
---@field FX_Sprinkler6 UParticleSystemComponent
---@field FX_Sprinkler UParticleSystemComponent
---@field SM_WheelCleaner_01_Ramp UStaticMeshComponent
---@field MTOverlap UMTOverlapComponent
---@field Box UBoxComponent
---@field Scene USceneComponent
local AWheelCleaner_Small_C = {}

---@param bHasOverlap boolean
function AWheelCleaner_Small_C:BndEvt__GarageDoor_01_MTOverlap_K2Node_ComponentBoundEvent_2_OverlapTestedEvent__DelegateSignature(bHasOverlap) end
function AWheelCleaner_Small_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AWheelCleaner_Small_C:ReceiveEndPlay(EndPlayReason) end
function AWheelCleaner_Small_C:TurnOn() end
function AWheelCleaner_Small_C:TurnOff() end
---@param EntryPoint int32
function AWheelCleaner_Small_C:ExecuteUbergraph_WheelCleaner_Small(EntryPoint) end


