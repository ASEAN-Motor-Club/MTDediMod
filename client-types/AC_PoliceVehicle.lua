---@meta

---@class AAC_PoliceVehicle_C : AMTPoliceVehicleAIController
---@field UberGraphFrame FPointerToUberGraphFrame
local AAC_PoliceVehicle_C = {}

function AAC_PoliceVehicle_C:ReceiveBeginPlay() end
---@param PossessedPawn APawn
function AAC_PoliceVehicle_C:ReceivePossess(PossessedPawn) end
---@param UnpossessedPawn APawn
function AAC_PoliceVehicle_C:ReceiveUnPossess(UnpossessedPawn) end
---@param EntryPoint int32
function AAC_PoliceVehicle_C:ExecuteUbergraph_AC_PoliceVehicle(EntryPoint) end


