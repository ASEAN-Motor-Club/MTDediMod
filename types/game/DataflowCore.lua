---@meta

---@class FDataflowAllTypes : FDataflowAnyType
local FDataflowAllTypes = {}


---@class FDataflowAnyType
local FDataflowAnyType = {}


---@class FDataflowArrayInput : FDataflowInput
local FDataflowArrayInput = {}


---@class FDataflowBranchNode : FDataflowNode
---@field TrueValue FDataflowAnyType
---@field FalseValue FDataflowAnyType
---@field bCondition boolean
---@field Result FDataflowAnyType
local FDataflowBranchNode = {}



---@class FDataflowConnection
local FDataflowConnection = {}


---@class FDataflowFaceSelection : FDataflowSelection
local FDataflowFaceSelection = {}


---@class FDataflowGeometrySelection : FDataflowSelection
local FDataflowGeometrySelection = {}


---@class FDataflowInput : FDataflowConnection
local FDataflowInput = {}


---@class FDataflowMaterialSelection : FDataflowSelection
local FDataflowMaterialSelection = {}


---@class FDataflowMathAbsNode : FDataflowMathOneInputOperatorNode
---@field Fallback FDataflowNumericTypes
local FDataflowMathAbsNode = {}



---@class FDataflowMathAddNode : FDataflowMathTwoInputsOperatorNode
local FDataflowMathAddNode = {}


---@class FDataflowMathArcCosNode : FDataflowMathOneInputOperatorNode
local FDataflowMathArcCosNode = {}


---@class FDataflowMathArcSinNode : FDataflowMathOneInputOperatorNode
local FDataflowMathArcSinNode = {}


---@class FDataflowMathArcTan2Node : FDataflowMathTwoInputsOperatorNode
local FDataflowMathArcTan2Node = {}


---@class FDataflowMathArcTanNode : FDataflowMathOneInputOperatorNode
local FDataflowMathArcTanNode = {}


---@class FDataflowMathCeilNode : FDataflowMathOneInputOperatorNode
local FDataflowMathCeilNode = {}


---@class FDataflowMathConstantNode : FDataflowNode
---@field Constant EDataflowMathConstantsEnum
---@field Result FDataflowNumericTypes
local FDataflowMathConstantNode = {}



---@class FDataflowMathCosNode : FDataflowMathOneInputOperatorNode
local FDataflowMathCosNode = {}


---@class FDataflowMathCubeNode : FDataflowMathOneInputOperatorNode
local FDataflowMathCubeNode = {}


---@class FDataflowMathDegToRadNode : FDataflowMathOneInputOperatorNode
local FDataflowMathDegToRadNode = {}


---@class FDataflowMathDivideNode : FDataflowMathTwoInputsOperatorNode
---@field Fallback FDataflowNumericTypes
local FDataflowMathDivideNode = {}



---@class FDataflowMathExpNode : FDataflowMathOneInputOperatorNode
local FDataflowMathExpNode = {}


---@class FDataflowMathFloorNode : FDataflowMathOneInputOperatorNode
local FDataflowMathFloorNode = {}


---@class FDataflowMathFracNode : FDataflowMathOneInputOperatorNode
local FDataflowMathFracNode = {}


---@class FDataflowMathInverseSquareRootNode : FDataflowMathOneInputOperatorNode
---@field Fallback FDataflowNumericTypes
local FDataflowMathInverseSquareRootNode = {}



---@class FDataflowMathLogNode : FDataflowMathOneInputOperatorNode
local FDataflowMathLogNode = {}


---@class FDataflowMathLogXNode : FDataflowMathOneInputOperatorNode
---@field base FDataflowNumericTypes
local FDataflowMathLogXNode = {}



---@class FDataflowMathMaximumNode : FDataflowMathTwoInputsOperatorNode
local FDataflowMathMaximumNode = {}


---@class FDataflowMathMinimumNode : FDataflowMathTwoInputsOperatorNode
local FDataflowMathMinimumNode = {}


---@class FDataflowMathMultiplyNode : FDataflowMathTwoInputsOperatorNode
local FDataflowMathMultiplyNode = {}


---@class FDataflowMathNegateNode : FDataflowMathOneInputOperatorNode
---@field Fallback FDataflowNumericTypes
local FDataflowMathNegateNode = {}



---@class FDataflowMathOneInputOperatorNode : FDataflowNode
---@field A FDataflowNumericTypes
---@field Result FDataflowNumericTypes
local FDataflowMathOneInputOperatorNode = {}



---@class FDataflowMathOneMinusNode : FDataflowMathOneInputOperatorNode
local FDataflowMathOneMinusNode = {}


---@class FDataflowMathPowNode : FDataflowMathTwoInputsOperatorNode
local FDataflowMathPowNode = {}


---@class FDataflowMathRadToDegNode : FDataflowMathOneInputOperatorNode
local FDataflowMathRadToDegNode = {}


---@class FDataflowMathReciprocalNode : FDataflowMathOneInputOperatorNode
---@field Fallback FDataflowNumericTypes
local FDataflowMathReciprocalNode = {}



---@class FDataflowMathRoundNode : FDataflowMathOneInputOperatorNode
local FDataflowMathRoundNode = {}


---@class FDataflowMathSignNode : FDataflowMathOneInputOperatorNode
local FDataflowMathSignNode = {}


---@class FDataflowMathSinNode : FDataflowMathOneInputOperatorNode
local FDataflowMathSinNode = {}


---@class FDataflowMathSquareNode : FDataflowMathOneInputOperatorNode
local FDataflowMathSquareNode = {}


---@class FDataflowMathSquareRootNode : FDataflowMathOneInputOperatorNode
local FDataflowMathSquareRootNode = {}


---@class FDataflowMathSubtractNode : FDataflowMathTwoInputsOperatorNode
local FDataflowMathSubtractNode = {}


---@class FDataflowMathTanNode : FDataflowMathOneInputOperatorNode
local FDataflowMathTanNode = {}


---@class FDataflowMathTruncNode : FDataflowMathOneInputOperatorNode
local FDataflowMathTruncNode = {}


---@class FDataflowMathTwoInputsOperatorNode : FDataflowNode
---@field A FDataflowNumericTypes
---@field B FDataflowNumericTypes
---@field Result FDataflowNumericTypes
local FDataflowMathTwoInputsOperatorNode = {}



---@class FDataflowNode
---@field bActive boolean
local FDataflowNode = {}



---@class FDataflowNumericTypes : FDataflowAnyType
---@field Value double
local FDataflowNumericTypes = {}



---@class FDataflowOutput : FDataflowConnection
local FDataflowOutput = {}


---@class FDataflowOverrideNode : FDataflowNode
---@field Key FName
---@field Default FString
---@field IsOverriden boolean
local FDataflowOverrideNode = {}



---@class FDataflowPrintNode : FDataflowNode
---@field Value FDataflowStringConvertibleTypes
local FDataflowPrintNode = {}



---@class FDataflowReRouteNode : FDataflowNode
---@field Value FDataflowAnyType
local FDataflowReRouteNode = {}



---@class FDataflowSelectNode : FDataflowNode
---@field Inputs TArray<FDataflowAnyType>
---@field SelectedIndex int32
---@field Result FDataflowAnyType
local FDataflowSelectNode = {}



---@class FDataflowSelection
local FDataflowSelection = {}


---@class FDataflowStringConvertibleTypes : FDataflowAnyType
---@field Value FString
local FDataflowStringConvertibleTypes = {}



---@class FDataflowStringTypes : FDataflowAnyType
---@field Value FString
local FDataflowStringTypes = {}



---@class FDataflowTerminalNode : FDataflowNode
local FDataflowTerminalNode = {}


---@class FDataflowTransformSelection : FDataflowSelection
local FDataflowTransformSelection = {}


---@class FDataflowUObjectConvertibleTypes : FDataflowAnyType
---@field Value UObject
local FDataflowUObjectConvertibleTypes = {}



---@class FDataflowVectorAddNode : FDataflowNode
---@field A FDataflowVectorTypes
---@field B FDataflowVectorTypes
---@field V FDataflowVectorTypes
local FDataflowVectorAddNode = {}



---@class FDataflowVectorBreakNode : FDataflowNode
---@field V FDataflowVectorTypes
---@field X FDataflowNumericTypes
---@field Y FDataflowNumericTypes
---@field Z FDataflowNumericTypes
---@field W FDataflowNumericTypes
local FDataflowVectorBreakNode = {}



---@class FDataflowVectorCrossProductNode : FDataflowNode
---@field A FDataflowVectorTypes
---@field B FDataflowVectorTypes
---@field CrossProduct FDataflowVectorTypes
local FDataflowVectorCrossProductNode = {}



---@class FDataflowVectorDistanceNode : FDataflowNode
---@field A FDataflowVectorTypes
---@field B FDataflowVectorTypes
---@field Distance FDataflowNumericTypes
local FDataflowVectorDistanceNode = {}



---@class FDataflowVectorDotProductNode : FDataflowNode
---@field A FDataflowVectorTypes
---@field B FDataflowVectorTypes
---@field DotProduct FDataflowNumericTypes
local FDataflowVectorDotProductNode = {}



---@class FDataflowVectorLengthNode : FDataflowNode
---@field V FDataflowVectorTypes
---@field Length FDataflowNumericTypes
local FDataflowVectorLengthNode = {}



---@class FDataflowVectorMakeVec2Node : FDataflowNode
---@field X FDataflowNumericTypes
---@field Y FDataflowNumericTypes
---@field Vector2D FDataflowVectorTypes
local FDataflowVectorMakeVec2Node = {}



---@class FDataflowVectorMakeVec3Node : FDataflowNode
---@field X FDataflowNumericTypes
---@field Y FDataflowNumericTypes
---@field Z FDataflowNumericTypes
---@field Vector3d FDataflowVectorTypes
local FDataflowVectorMakeVec3Node = {}



---@class FDataflowVectorMakeVec4Node : FDataflowNode
---@field X FDataflowNumericTypes
---@field Y FDataflowNumericTypes
---@field Z FDataflowNumericTypes
---@field W FDataflowNumericTypes
---@field Vector4d FDataflowVectorTypes
local FDataflowVectorMakeVec4Node = {}



---@class FDataflowVectorNormalize : FDataflowNode
---@field V FDataflowVectorTypes
---@field Normalized FDataflowVectorTypes
local FDataflowVectorNormalize = {}



---@class FDataflowVectorScaleNode : FDataflowNode
---@field V FDataflowVectorTypes
---@field Scale FDataflowNumericTypes
---@field Scaled FDataflowVectorTypes
local FDataflowVectorScaleNode = {}



---@class FDataflowVectorSquaredLengthNode : FDataflowNode
---@field V FDataflowVectorTypes
---@field SquaredLength FDataflowNumericTypes
local FDataflowVectorSquaredLengthNode = {}



---@class FDataflowVectorSubtractNode : FDataflowNode
---@field A FDataflowVectorTypes
---@field B FDataflowVectorTypes
---@field V FDataflowVectorTypes
local FDataflowVectorSubtractNode = {}



---@class FDataflowVectorTypes : FDataflowAnyType
---@field Value FVector4
local FDataflowVectorTypes = {}



---@class FDataflowVertexSelection : FDataflowSelection
local FDataflowVertexSelection = {}


---@class FNodeColors
---@field NodeTitleColor FLinearColor
---@field NodeBodyTintColor FLinearColor
local FNodeColors = {}



---@class UDataflowSettings : UDeveloperSettings
---@field ArrayPinTypeColor FLinearColor
---@field ManagedArrayCollectionPinTypeColor FLinearColor
---@field BoxPinTypeColor FLinearColor
---@field SpherePinTypeColor FLinearColor
---@field DataflowAnyTypePinTypeColor FLinearColor
---@field NodeColorsMap TMap<FName, FNodeColors>
local UDataflowSettings = {}



