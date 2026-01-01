---@meta

---@class AMTVehicleBaseBP_C : AMTVehicle
---@field UberGraphFrame FPointerToUberGraphFrame
---@field AIPerceptionStimuliSource UAIPerceptionStimuliSourceComponent
local AMTVehicleBaseBP_C = {}

AMTVehicleBaseBP_C['Convert To World Spawner'] = function(self, ) end
AMTVehicleBaseBP_C['Convert To Dealer Spawner'] = function(self, ) end
---@param EntryPoint int32
function AMTVehicleBaseBP_C:ExecuteUbergraph_MTVehicleBaseBP(EntryPoint) end


