---@meta

---@class ABP_Factory_Crossroad_01_C : AStaticMeshActor
---@field UseRightLane boolean
---@field bIsRightLane4Way boolean
---@field ['bIsRightLane2Way_Close/Far'] boolean
---@field UseLeftLane boolean
---@field bIsLeftLane4Way boolean
---@field ['bIsLeftLane2Way_Close/Far'] boolean
---@field UseStraightLane boolean
---@field bIsStraightLane4Way boolean
---@field ['bIsStraightLane2Way_Left/Right'] boolean
local ABP_Factory_Crossroad_01_C = {}

---@param Component TArray<UStaticMeshComponent>
---@param Index int32
---@param Material UMaterialInstance
ABP_Factory_Crossroad_01_C['Set Material Array'] = function(self, Component, Index, Material) end
---@param Component UStaticMeshComponent
---@param Index int32
---@param Material UMaterialInstance
ABP_Factory_Crossroad_01_C['Set Material Single'] = function(self, Component, Index, Material) end
function ABP_Factory_Crossroad_01_C:UserConstructionScript() end


