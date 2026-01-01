---@meta

---@class AMaja_RoofTent_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field RoofTentShoeBags UStaticMeshComponent
---@field MTInteractable UMTInteractableComponent
---@field MTLightControl UMTLightControlComponent
---@field RoofTentPacked UStaticMeshComponent
---@field RoofTentMeshOpening UStaticMeshComponent
---@field RoofTentMeshCover UStaticMeshComponent
---@field RoofTentBedFoldStep UStaticMeshComponent
---@field RoofTentBedFoldSupp UStaticMeshComponent
---@field RoofTentPillow4 UStaticMeshComponent
---@field RoofTentPillow3 UStaticMeshComponent
---@field RoofTentPillow2 UStaticMeshComponent
---@field RoofTentPillow1 UStaticMeshComponent
---@field RoofTentMesh UStaticMeshComponent
---@field RoofTentStrut5Cover UStaticMeshComponent
---@field RoofTentStrut4 UStaticMeshComponent
---@field RoofTentStrut3 UStaticMeshComponent
---@field RoofTentStrut2 UStaticMeshComponent
---@field RoofTentStrut1 UStaticMeshComponent
---@field RoofTentMattress UStaticMeshComponent
---@field RoofTentBedFold UStaticMeshComponent
---@field RoofTentBedBase UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
---@field Timeline_TentPACKED_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_BedFolding_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_TentCover_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_TentStrutCover_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_TentShoes_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_TentOpening_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_TentPillow4_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_TentPillow3_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_TentPillow2_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_TentPillow1_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_TentMesh_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_Ladder_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_BedSupports_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_Strut4_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_Strut3_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_Strut2_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_Strut1_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline_Mattress_2B99992145E7742D0A19E9B42E28947D float
---@field Timeline__Direction_2B99992145E7742D0A19E9B42E28947D ETimelineDirection::Type
---@field Timeline UTimelineComponent
local AMaja_RoofTent_C = {}

function AMaja_RoofTent_C:Timeline__FinishedFunc() end
function AMaja_RoofTent_C:Timeline__UpdateFunc() end
---@param DeltaSeconds float
function AMaja_RoofTent_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function AMaja_RoofTent_C:ExecuteUbergraph_Maja_RoofTent(EntryPoint) end


