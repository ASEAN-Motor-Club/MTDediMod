---@meta

---@class ASashimiAquarium_01_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field SM_Fish_07 UStaticMeshComponent
---@field SM_Fish_06 UStaticMeshComponent
---@field SM_Fish_05 UStaticMeshComponent
---@field SM_Fish_04 UStaticMeshComponent
---@field SM_Prop_Food_Fish_Whole_02 UStaticMeshComponent
---@field SM_Fish_02 UStaticMeshComponent
---@field SM_Prop_Food_Fish_Whole_05 UStaticMeshComponent
---@field SM_Prop_Food_Fish_Whole_04 UStaticMeshComponent
---@field SM_Prop_Food_Fish_Whole_03 UStaticMeshComponent
---@field SM_Fish_03 UStaticMeshComponent
---@field Fish_04_Location_Z_B76B8B924BAA0AFC8F1254B9888B6191 float
---@field Fish_04_Location_Y_B76B8B924BAA0AFC8F1254B9888B6191 float
---@field Fish_04_Location_X_B76B8B924BAA0AFC8F1254B9888B6191 float
---@field Fish_04_Rotate_Z_B76B8B924BAA0AFC8F1254B9888B6191 float
---@field Fish_04_Rotate_Y_B76B8B924BAA0AFC8F1254B9888B6191 float
---@field Fish_04_Rotate_X_B76B8B924BAA0AFC8F1254B9888B6191 float
---@field Fish_04__Direction_B76B8B924BAA0AFC8F1254B9888B6191 ETimelineDirection::Type
---@field Fish_04 UTimelineComponent
---@field Floating_Rotate_Z_D4EF6521477E794F9E43C7B72A037F19 float
---@field Floating_Rotate_Y_D4EF6521477E794F9E43C7B72A037F19 float
---@field Floating_Rotate_X_D4EF6521477E794F9E43C7B72A037F19 float
---@field Floating__Direction_D4EF6521477E794F9E43C7B72A037F19 ETimelineDirection::Type
---@field Floating UTimelineComponent
---@field Fish_03_Location_Z_5FB1BCEE4CDD9719776BFEA4B88FE097 float
---@field Fish_03_Location_Y_5FB1BCEE4CDD9719776BFEA4B88FE097 float
---@field Fish_03_Location_X_5FB1BCEE4CDD9719776BFEA4B88FE097 float
---@field Fish_03_Rotate_Z_5FB1BCEE4CDD9719776BFEA4B88FE097 float
---@field Fish_03_Rotate_Y_5FB1BCEE4CDD9719776BFEA4B88FE097 float
---@field Fish_03_Rotate_X_5FB1BCEE4CDD9719776BFEA4B88FE097 float
---@field Fish_03__Direction_5FB1BCEE4CDD9719776BFEA4B88FE097 ETimelineDirection::Type
---@field Fish_03 UTimelineComponent
---@field Fish_02_Location_Z_35D6F4C8495776A6C70435A4DFA8C7FA float
---@field Fish_02_Location_Y_35D6F4C8495776A6C70435A4DFA8C7FA float
---@field Fish_02_Location_X_35D6F4C8495776A6C70435A4DFA8C7FA float
---@field Fish_02_Rotate_Z_35D6F4C8495776A6C70435A4DFA8C7FA float
---@field Fish_02_Rotate_Y_35D6F4C8495776A6C70435A4DFA8C7FA float
---@field Fish_02_Rotate_X_35D6F4C8495776A6C70435A4DFA8C7FA float
---@field Fish_02__Direction_35D6F4C8495776A6C70435A4DFA8C7FA ETimelineDirection::Type
---@field Fish_02 UTimelineComponent
---@field Fish_01_Location_Z_D7B4D9084E3F7C50236756B929D7DFED float
---@field Fish_01_Location_Y_D7B4D9084E3F7C50236756B929D7DFED float
---@field Fish_01_Location_X_D7B4D9084E3F7C50236756B929D7DFED float
---@field Fish_01_Rotate_Z_D7B4D9084E3F7C50236756B929D7DFED float
---@field Fish_01_Rotate_Y_D7B4D9084E3F7C50236756B929D7DFED float
---@field Fish_01_Rotate_X_D7B4D9084E3F7C50236756B929D7DFED float
---@field Fish_01__Direction_D7B4D9084E3F7C50236756B929D7DFED ETimelineDirection::Type
---@field Fish_01 UTimelineComponent
---@field Intensity double
local ASashimiAquarium_01_C = {}

function ASashimiAquarium_01_C:Fish_01__FinishedFunc() end
function ASashimiAquarium_01_C:Fish_01__UpdateFunc() end
function ASashimiAquarium_01_C:Fish_02__FinishedFunc() end
function ASashimiAquarium_01_C:Fish_02__UpdateFunc() end
function ASashimiAquarium_01_C:Fish_03__FinishedFunc() end
function ASashimiAquarium_01_C:Fish_03__UpdateFunc() end
function ASashimiAquarium_01_C:Floating__FinishedFunc() end
function ASashimiAquarium_01_C:Floating__UpdateFunc() end
function ASashimiAquarium_01_C:Fish_04__FinishedFunc() end
function ASashimiAquarium_01_C:Fish_04__UpdateFunc() end
---@param DeltaSeconds float
function ASashimiAquarium_01_C:ReceiveTick(DeltaSeconds) end
function ASashimiAquarium_01_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function ASashimiAquarium_01_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function ASashimiAquarium_01_C:ExecuteUbergraph_SashimiAquarium_01(EntryPoint) end


