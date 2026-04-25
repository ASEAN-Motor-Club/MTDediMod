---@meta

---@class FMathRBFInterpolateQuatColor_Target
---@field Target FQuat
---@field Value FLinearColor
local FMathRBFInterpolateQuatColor_Target = {}



---@class FMathRBFInterpolateQuatFloat_Target
---@field Target FQuat
---@field Value float
local FMathRBFInterpolateQuatFloat_Target = {}



---@class FMathRBFInterpolateQuatQuat_Target
---@field Target FQuat
---@field Value FQuat
local FMathRBFInterpolateQuatQuat_Target = {}



---@class FMathRBFInterpolateQuatVector_Target
---@field Target FQuat
---@field Value FVector
local FMathRBFInterpolateQuatVector_Target = {}



---@class FMathRBFInterpolateQuatXform_Target
---@field Target FQuat
---@field Value FTransform
local FMathRBFInterpolateQuatXform_Target = {}



---@class FMathRBFInterpolateVectorColor_Target
---@field Target FVector
---@field Value FLinearColor
local FMathRBFInterpolateVectorColor_Target = {}



---@class FMathRBFInterpolateVectorFloat_Target
---@field Target FVector
---@field Value float
local FMathRBFInterpolateVectorFloat_Target = {}



---@class FMathRBFInterpolateVectorQuat_Target
---@field Target FVector
---@field Value FQuat
local FMathRBFInterpolateVectorQuat_Target = {}



---@class FMathRBFInterpolateVectorVector_Target
---@field Target FVector
---@field Value FVector
local FMathRBFInterpolateVectorVector_Target = {}



---@class FMathRBFInterpolateVectorXform_Target
---@field Target FVector
---@field Value FTransform
local FMathRBFInterpolateVectorXform_Target = {}



---@class FRigDispatch_FromString : FRigVMDispatchFactory
local FRigDispatch_FromString = {}


---@class FRigDispatch_ToString : FRigVMDispatchFactory
local FRigDispatch_ToString = {}


---@class FRigVMBaseOp
local FRigVMBaseOp = {}


---@class FRigVMBinaryOp : FRigVMBaseOp
local FRigVMBinaryOp = {}


---@class FRigVMBranchInfo
---@field Index int32
---@field Label FName
---@field InstructionIndex int32
---@field ArgumentIndex int32
---@field FirstInstruction uint16
---@field LastInstruction uint16
local FRigVMBranchInfo = {}



---@class FRigVMBreakpoint
local FRigVMBreakpoint = {}


---@class FRigVMByteCode
---@field ByteCode TArray<uint8>
---@field NumInstructions int32
---@field Entries TArray<FRigVMByteCodeEntry>
---@field BranchInfos TArray<FRigVMBranchInfo>
---@field PredicateBranches TArray<FRigVMPredicateBranch>
---@field PublicContextPathName FString
local FRigVMByteCode = {}



---@class FRigVMByteCodeEntry
---@field Name FName
---@field InstructionIndex int32
local FRigVMByteCodeEntry = {}



---@class FRigVMByteCodeStatistics
---@field InstructionCount int32
---@field DataBytes int32
local FRigVMByteCodeStatistics = {}



---@class FRigVMChangeTypeOp : FRigVMUnaryOp
local FRigVMChangeTypeOp = {}


---@class FRigVMComparisonOp : FRigVMBaseOp
local FRigVMComparisonOp = {}


---@class FRigVMCopyOp : FRigVMBaseOp
local FRigVMCopyOp = {}


---@class FRigVMDebugInfo
local FRigVMDebugInfo = {}


---@class FRigVMDispatchFactory
local FRigVMDispatchFactory = {}


---@class FRigVMDispatch_ArrayAdd : FRigVMDispatch_ArraySetAtIndex
local FRigVMDispatch_ArrayAdd = {}


---@class FRigVMDispatch_ArrayAppend : FRigVMDispatch_ArrayBaseMutable
local FRigVMDispatch_ArrayAppend = {}


---@class FRigVMDispatch_ArrayBase : FRigVMDispatch_CoreBase
local FRigVMDispatch_ArrayBase = {}


---@class FRigVMDispatch_ArrayBaseMutable : FRigVMDispatch_ArrayBase
local FRigVMDispatch_ArrayBaseMutable = {}


---@class FRigVMDispatch_ArrayClone : FRigVMDispatch_ArrayBase
local FRigVMDispatch_ArrayClone = {}


---@class FRigVMDispatch_ArrayDifference : FRigVMDispatch_ArrayBase
local FRigVMDispatch_ArrayDifference = {}


---@class FRigVMDispatch_ArrayFind : FRigVMDispatch_ArrayBase
local FRigVMDispatch_ArrayFind = {}


---@class FRigVMDispatch_ArrayGetAtIndex : FRigVMDispatch_ArrayBase
local FRigVMDispatch_ArrayGetAtIndex = {}


---@class FRigVMDispatch_ArrayGetNum : FRigVMDispatch_ArrayBase
local FRigVMDispatch_ArrayGetNum = {}


---@class FRigVMDispatch_ArrayInit : FRigVMDispatch_ArrayBaseMutable
local FRigVMDispatch_ArrayInit = {}


---@class FRigVMDispatch_ArrayInsert : FRigVMDispatch_ArraySetAtIndex
local FRigVMDispatch_ArrayInsert = {}


---@class FRigVMDispatch_ArrayIntersection : FRigVMDispatch_ArrayDifference
local FRigVMDispatch_ArrayIntersection = {}


---@class FRigVMDispatch_ArrayIterator : FRigVMDispatch_ArrayBaseMutable
local FRigVMDispatch_ArrayIterator = {}


---@class FRigVMDispatch_ArrayMake : FRigVMDispatch_ArrayBase
local FRigVMDispatch_ArrayMake = {}


---@class FRigVMDispatch_ArrayRemove : FRigVMDispatch_ArrayBaseMutable
local FRigVMDispatch_ArrayRemove = {}


---@class FRigVMDispatch_ArrayReset : FRigVMDispatch_ArrayBaseMutable
local FRigVMDispatch_ArrayReset = {}


---@class FRigVMDispatch_ArrayReverse : FRigVMDispatch_ArrayReset
local FRigVMDispatch_ArrayReverse = {}


---@class FRigVMDispatch_ArraySetAtIndex : FRigVMDispatch_ArrayBaseMutable
local FRigVMDispatch_ArraySetAtIndex = {}


---@class FRigVMDispatch_ArraySetNum : FRigVMDispatch_ArrayBaseMutable
local FRigVMDispatch_ArraySetNum = {}


---@class FRigVMDispatch_ArrayUnion : FRigVMDispatch_ArrayAppend
local FRigVMDispatch_ArrayUnion = {}


---@class FRigVMDispatch_BreakStruct : FRigVMDispatch_MakeStruct
local FRigVMDispatch_BreakStruct = {}


---@class FRigVMDispatch_CastEnumToInt : FRigVMDispatchFactory
local FRigVMDispatch_CastEnumToInt = {}


---@class FRigVMDispatch_CastIntToEnum : FRigVMDispatchFactory
local FRigVMDispatch_CastIntToEnum = {}


---@class FRigVMDispatch_CastObject : FRigVMDispatchFactory
local FRigVMDispatch_CastObject = {}


---@class FRigVMDispatch_Constant : FRigVMDispatch_CoreBase
local FRigVMDispatch_Constant = {}


---@class FRigVMDispatch_CoreBase : FRigVMDispatchFactory
local FRigVMDispatch_CoreBase = {}


---@class FRigVMDispatch_CoreEquals : FRigVMDispatch_CoreBase
local FRigVMDispatch_CoreEquals = {}


---@class FRigVMDispatch_CoreNotEquals : FRigVMDispatch_CoreEquals
local FRigVMDispatch_CoreNotEquals = {}


---@class FRigVMDispatch_If : FRigVMDispatch_CoreBase
local FRigVMDispatch_If = {}


---@class FRigVMDispatch_MakeStruct : FRigVMDispatch_CoreBase
local FRigVMDispatch_MakeStruct = {}


---@class FRigVMDispatch_Print : FRigVMDispatchFactory
local FRigVMDispatch_Print = {}


---@class FRigVMDispatch_SelectInt32 : FRigVMDispatch_CoreBase
local FRigVMDispatch_SelectInt32 = {}


---@class FRigVMDispatch_SwitchInt32 : FRigVMDispatch_CoreBase
local FRigVMDispatch_SwitchInt32 = {}


---@class FRigVMDrawContainer
---@field Instructions TArray<FRigVMDrawInstruction>
local FRigVMDrawContainer = {}



---@class FRigVMDrawInstruction
---@field Name FName
---@field PrimitiveType ERigVMDrawSettings::Type
---@field Positions TArray<FVector>
---@field Color FLinearColor
---@field Thickness float
---@field Transform FTransform
local FRigVMDrawInstruction = {}



---@class FRigVMDrawInterface : FRigVMDrawContainer
local FRigVMDrawInterface = {}


---@class FRigVMExecuteContext
local FRigVMExecuteContext = {}


---@class FRigVMExecuteOp : FRigVMBaseOp
local FRigVMExecuteOp = {}


---@class FRigVMExtendedExecuteContext
local FRigVMExtendedExecuteContext = {}


---@class FRigVMExternalVariable : FRigVMExternalVariableDef
local FRigVMExternalVariable = {}


---@class FRigVMExternalVariableDef
local FRigVMExternalVariableDef = {}


---@class FRigVMFourPointBezier
---@field A FVector
---@field B FVector
---@field C FVector
---@field D FVector
local FRigVMFourPointBezier = {}



---@class FRigVMFunctionCompilationData
---@field ByteCode FRigVMByteCode
---@field FunctionNames TArray<FName>
---@field WorkPropertyDescriptions TArray<FRigVMFunctionCompilationPropertyDescription>
---@field WorkPropertyPathDescriptions TArray<FRigVMFunctionCompilationPropertyPath>
---@field LiteralPropertyDescriptions TArray<FRigVMFunctionCompilationPropertyDescription>
---@field LiteralPropertyPathDescriptions TArray<FRigVMFunctionCompilationPropertyPath>
---@field DebugPropertyDescriptions TArray<FRigVMFunctionCompilationPropertyDescription>
---@field DebugPropertyPathDescriptions TArray<FRigVMFunctionCompilationPropertyPath>
---@field ExternalPropertyDescriptions TArray<FRigVMFunctionCompilationPropertyDescription>
---@field ExternalPropertyPathDescriptions TArray<FRigVMFunctionCompilationPropertyPath>
---@field ExternalRegisterIndexToVariable TMap<int32, FName>
---@field Operands TMap<FString, FRigVMOperand>
---@field Hash uint32
---@field bEncounteredSurpressedErrors boolean
local FRigVMFunctionCompilationData = {}



---@class FRigVMFunctionCompilationPropertyDescription
---@field Name FName
---@field CPPType FString
---@field CPPTypeObject TSoftObjectPtr<UObject>
---@field DefaultValue FString
local FRigVMFunctionCompilationPropertyDescription = {}



---@class FRigVMFunctionCompilationPropertyPath
---@field PropertyIndex int32
---@field HeadCPPType FString
---@field SegmentPath FString
local FRigVMFunctionCompilationPropertyPath = {}



---@class FRigVMFunction_AccumulateBase : FRigVMFunction_SimBase
local FRigVMFunction_AccumulateBase = {}


---@class FRigVMFunction_AccumulateFloatAdd : FRigVMFunction_AccumulateBase
---@field Increment float
---@field InitialValue float
---@field bIntegrateDeltaTime boolean
---@field Result float
---@field AccumulatedValue float
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateFloatAdd = {}



---@class FRigVMFunction_AccumulateFloatLerp : FRigVMFunction_AccumulateBase
---@field TargetValue float
---@field InitialValue float
---@field Blend float
---@field bIntegrateDeltaTime boolean
---@field Result float
---@field AccumulatedValue float
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateFloatLerp = {}



---@class FRigVMFunction_AccumulateFloatMul : FRigVMFunction_AccumulateBase
---@field Multiplier float
---@field InitialValue float
---@field bIntegrateDeltaTime boolean
---@field Result float
---@field AccumulatedValue float
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateFloatMul = {}



---@class FRigVMFunction_AccumulateFloatRange : FRigVMFunction_AccumulateBase
---@field Value float
---@field Minimum float
---@field Maximum float
---@field AccumulatedMinimum float
---@field AccumulatedMaximum float
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateFloatRange = {}



---@class FRigVMFunction_AccumulateQuatLerp : FRigVMFunction_AccumulateBase
---@field TargetValue FQuat
---@field InitialValue FQuat
---@field Blend float
---@field bIntegrateDeltaTime boolean
---@field Result FQuat
---@field AccumulatedValue FQuat
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateQuatLerp = {}



---@class FRigVMFunction_AccumulateQuatMul : FRigVMFunction_AccumulateBase
---@field Multiplier FQuat
---@field InitialValue FQuat
---@field bFlipOrder boolean
---@field bIntegrateDeltaTime boolean
---@field Result FQuat
---@field AccumulatedValue FQuat
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateQuatMul = {}



---@class FRigVMFunction_AccumulateTransformLerp : FRigVMFunction_AccumulateBase
---@field TargetValue FTransform
---@field InitialValue FTransform
---@field Blend float
---@field bIntegrateDeltaTime boolean
---@field Result FTransform
---@field AccumulatedValue FTransform
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateTransformLerp = {}



---@class FRigVMFunction_AccumulateTransformMul : FRigVMFunction_AccumulateBase
---@field Multiplier FTransform
---@field InitialValue FTransform
---@field bFlipOrder boolean
---@field bIntegrateDeltaTime boolean
---@field Result FTransform
---@field AccumulatedValue FTransform
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateTransformMul = {}



---@class FRigVMFunction_AccumulateVectorAdd : FRigVMFunction_AccumulateBase
---@field Increment FVector
---@field InitialValue FVector
---@field bIntegrateDeltaTime boolean
---@field Result FVector
---@field AccumulatedValue FVector
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateVectorAdd = {}



---@class FRigVMFunction_AccumulateVectorLerp : FRigVMFunction_AccumulateBase
---@field TargetValue FVector
---@field InitialValue FVector
---@field Blend float
---@field bIntegrateDeltaTime boolean
---@field Result FVector
---@field AccumulatedValue FVector
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateVectorLerp = {}



---@class FRigVMFunction_AccumulateVectorMul : FRigVMFunction_AccumulateBase
---@field Multiplier FVector
---@field InitialValue FVector
---@field bIntegrateDeltaTime boolean
---@field Result FVector
---@field AccumulatedValue FVector
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateVectorMul = {}



---@class FRigVMFunction_AccumulateVectorRange : FRigVMFunction_AccumulateBase
---@field Value FVector
---@field Minimum FVector
---@field Maximum FVector
---@field AccumulatedMinimum FVector
---@field AccumulatedMaximum FVector
---@field bIsInitialized boolean
local FRigVMFunction_AccumulateVectorRange = {}



---@class FRigVMFunction_AlphaInterp : FRigVMFunction_SimBase
---@field Value float
---@field Scale float
---@field Bias float
---@field bMapRange boolean
---@field InRange FInputRange
---@field OutRange FInputRange
---@field bClampResult boolean
---@field ClampMin float
---@field ClampMax float
---@field bInterpResult boolean
---@field InterpSpeedIncreasing float
---@field InterpSpeedDecreasing float
---@field Result float
---@field ScaleBiasClamp FInputScaleBiasClamp
local FRigVMFunction_AlphaInterp = {}



---@class FRigVMFunction_AlphaInterpQuat : FRigVMFunction_SimBase
---@field Value FQuat
---@field Scale float
---@field Bias float
---@field bMapRange boolean
---@field InRange FInputRange
---@field OutRange FInputRange
---@field bClampResult boolean
---@field ClampMin float
---@field ClampMax float
---@field bInterpResult boolean
---@field InterpSpeedIncreasing float
---@field InterpSpeedDecreasing float
---@field Result FQuat
---@field ScaleBiasClamp FInputScaleBiasClamp
local FRigVMFunction_AlphaInterpQuat = {}



---@class FRigVMFunction_AlphaInterpVector : FRigVMFunction_SimBase
---@field Value FVector
---@field Scale float
---@field Bias float
---@field bMapRange boolean
---@field InRange FInputRange
---@field OutRange FInputRange
---@field bClampResult boolean
---@field ClampMin float
---@field ClampMax float
---@field bInterpResult boolean
---@field InterpSpeedIncreasing float
---@field InterpSpeedDecreasing float
---@field Result FVector
---@field ScaleBiasClamp FInputScaleBiasClamp
local FRigVMFunction_AlphaInterpVector = {}



---@class FRigVMFunction_AnimBase : FRigVMStruct
local FRigVMFunction_AnimBase = {}


---@class FRigVMFunction_AnimEasing : FRigVMFunction_AnimBase
---@field Value float
---@field Type ERigVMAnimEasingType
---@field SourceMinimum float
---@field SourceMaximum float
---@field TargetMinimum float
---@field TargetMaximum float
---@field Result float
local FRigVMFunction_AnimEasing = {}



---@class FRigVMFunction_AnimEasingType : FRigVMFunction_AnimBase
---@field Type ERigVMAnimEasingType
local FRigVMFunction_AnimEasingType = {}



---@class FRigVMFunction_AnimEvalRichCurve : FRigVMFunction_AnimBase
---@field Value float
---@field Curve FRuntimeFloatCurve
---@field SourceMinimum float
---@field SourceMaximum float
---@field TargetMinimum float
---@field TargetMaximum float
---@field Result float
local FRigVMFunction_AnimEvalRichCurve = {}



---@class FRigVMFunction_AnimRichCurve : FRigVMFunction_AnimBase
---@field Curve FRuntimeFloatCurve
local FRigVMFunction_AnimRichCurve = {}



---@class FRigVMFunction_Contains : FRigVMFunction_NameBase
---@field Name FName
---@field Search FName
---@field Result boolean
local FRigVMFunction_Contains = {}



---@class FRigVMFunction_ControlFlowBase : FRigVMStruct
local FRigVMFunction_ControlFlowBase = {}


---@class FRigVMFunction_ControlFlowBranch : FRigVMFunction_ControlFlowBase
---@field ExecuteContext FRigVMExecuteContext
---@field Condition boolean
---@field TRUE FRigVMExecuteContext
---@field FALSE FRigVMExecuteContext
---@field Completed FRigVMExecuteContext
---@field BlockToRun FName
local FRigVMFunction_ControlFlowBranch = {}



---@class FRigVMFunction_DebugArc : FRigVMFunction_DebugBaseMutable
---@field Transform FTransform
---@field Color FLinearColor
---@field Radius float
---@field MinimumDegrees float
---@field MaximumDegrees float
---@field Thickness float
---@field Detail int32
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugArc = {}



---@class FRigVMFunction_DebugArcNoSpace : FRigVMFunction_DebugBaseMutable
---@field Transform FTransform
---@field Color FLinearColor
---@field Radius float
---@field MinimumDegrees float
---@field MaximumDegrees float
---@field Thickness float
---@field Detail int32
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugArcNoSpace = {}



---@class FRigVMFunction_DebugBase : FRigVMStruct
local FRigVMFunction_DebugBase = {}


---@class FRigVMFunction_DebugBaseMutable : FRigVMStructMutable
local FRigVMFunction_DebugBaseMutable = {}


---@class FRigVMFunction_DebugBoxNoSpace : FRigVMFunction_DebugBaseMutable
---@field Box FBox
---@field Color FLinearColor
---@field Thickness float
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugBoxNoSpace = {}



---@class FRigVMFunction_DebugLineNoSpace : FRigVMFunction_DebugBaseMutable
---@field A FVector
---@field B FVector
---@field Color FLinearColor
---@field Thickness float
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugLineNoSpace = {}



---@class FRigVMFunction_DebugLineStripNoSpace : FRigVMFunction_DebugBaseMutable
---@field Points TArray<FVector>
---@field Color FLinearColor
---@field Thickness float
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugLineStripNoSpace = {}



---@class FRigVMFunction_DebugPoint : FRigVMFunction_DebugBase
---@field Vector FVector
---@field Mode ERigUnitDebugPointMode
---@field Color FLinearColor
---@field Scale float
---@field Thickness float
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugPoint = {}



---@class FRigVMFunction_DebugPointMutable : FRigVMFunction_DebugBaseMutable
---@field Vector FVector
---@field Mode ERigUnitDebugPointMode
---@field Color FLinearColor
---@field Scale float
---@field Thickness float
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugPointMutable = {}



---@class FRigVMFunction_DebugRectangle : FRigVMFunction_DebugBaseMutable
---@field Transform FTransform
---@field Color FLinearColor
---@field Scale float
---@field Thickness float
---@field Space FName
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugRectangle = {}



---@class FRigVMFunction_DebugRectangleNoSpace : FRigVMFunction_DebugBaseMutable
---@field Transform FTransform
---@field Color FLinearColor
---@field Scale float
---@field Thickness float
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugRectangleNoSpace = {}



---@class FRigVMFunction_DebugTransformArrayMutableNoSpace : FRigVMFunction_DebugBaseMutable
---@field Transforms TArray<FTransform>
---@field ParentIndices TArray<int32>
---@field Mode ERigUnitDebugTransformMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugTransformArrayMutableNoSpace = {}



---@class FRigVMFunction_DebugTransformArrayMutable_WorkData
---@field DrawTransforms TArray<FTransform>
local FRigVMFunction_DebugTransformArrayMutable_WorkData = {}



---@class FRigVMFunction_DebugTransformMutableNoSpace : FRigVMFunction_DebugBaseMutable
---@field Transform FTransform
---@field Mode ERigUnitDebugTransformMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
---@field WorldOffset FTransform
---@field bEnabled boolean
local FRigVMFunction_DebugTransformMutableNoSpace = {}



---@class FRigVMFunction_DeltaFromPreviousFloat : FRigVMFunction_SimBase
---@field Value float
---@field Delta float
---@field PreviousValue float
---@field Cache float
---@field bIsInitialized boolean
local FRigVMFunction_DeltaFromPreviousFloat = {}



---@class FRigVMFunction_DeltaFromPreviousQuat : FRigVMFunction_SimBase
---@field Value FQuat
---@field Delta FQuat
---@field PreviousValue FQuat
---@field Cache FQuat
---@field bIsInitialized boolean
local FRigVMFunction_DeltaFromPreviousQuat = {}



---@class FRigVMFunction_DeltaFromPreviousTransform : FRigVMFunction_SimBase
---@field Value FTransform
---@field Delta FTransform
---@field PreviousValue FTransform
---@field Cache FTransform
---@field bIsInitialized boolean
local FRigVMFunction_DeltaFromPreviousTransform = {}



---@class FRigVMFunction_DeltaFromPreviousVector : FRigVMFunction_SimBase
---@field Value FVector
---@field Delta FVector
---@field PreviousValue FVector
---@field Cache FVector
---@field bIsInitialized boolean
local FRigVMFunction_DeltaFromPreviousVector = {}



---@class FRigVMFunction_EndsWith : FRigVMFunction_NameBase
---@field Name FName
---@field Ending FName
---@field Result boolean
local FRigVMFunction_EndsWith = {}



---@class FRigVMFunction_ForLoopCount : FRigVMStructMutable
---@field BlockToRun FName
---@field Count int32
---@field Index int32
---@field Ratio float
---@field Completed FRigVMExecuteContext
local FRigVMFunction_ForLoopCount = {}



---@class FRigVMFunction_FramesToSeconds : FRigVMFunction_AnimBase
---@field Frames float
---@field Seconds float
local FRigVMFunction_FramesToSeconds = {}



---@class FRigVMFunction_GetDeltaTime : FRigVMFunction_AnimBase
---@field Result float
local FRigVMFunction_GetDeltaTime = {}



---@class FRigVMFunction_GetWorldTime : FRigVMFunction_AnimBase
---@field Year float
---@field Month float
---@field Day float
---@field WeekDay float
---@field Hours float
---@field Minutes float
---@field Seconds float
---@field OverallSeconds float
local FRigVMFunction_GetWorldTime = {}



---@class FRigVMFunction_IsHostBeingDebugged : FRigVMStruct
---@field Result boolean
local FRigVMFunction_IsHostBeingDebugged = {}



---@class FRigVMFunction_KalmanFloat : FRigVMFunction_SimBase
---@field Value float
---@field BufferSize int32
---@field Result float
---@field Buffer TArray<float>
---@field LastInsertIndex int32
local FRigVMFunction_KalmanFloat = {}



---@class FRigVMFunction_KalmanTransform : FRigVMFunction_SimBase
---@field Value FTransform
---@field BufferSize int32
---@field Result FTransform
---@field Buffer TArray<FTransform>
---@field LastInsertIndex int32
local FRigVMFunction_KalmanTransform = {}



---@class FRigVMFunction_KalmanVector : FRigVMFunction_SimBase
---@field Value FVector
---@field BufferSize int32
---@field Result FVector
---@field Buffer TArray<FVector>
---@field LastInsertIndex int32
local FRigVMFunction_KalmanVector = {}



---@class FRigVMFunction_MathBase : FRigVMStruct
local FRigVMFunction_MathBase = {}


---@class FRigVMFunction_MathBoolAnd : FRigVMFunction_MathBoolBinaryAggregateOp
local FRigVMFunction_MathBoolAnd = {}


---@class FRigVMFunction_MathBoolBase : FRigVMFunction_MathBase
local FRigVMFunction_MathBoolBase = {}


---@class FRigVMFunction_MathBoolBinaryAggregateOp : FRigVMFunction_MathBoolBase
---@field A boolean
---@field B boolean
---@field Result boolean
local FRigVMFunction_MathBoolBinaryAggregateOp = {}



---@class FRigVMFunction_MathBoolBinaryOp : FRigVMFunction_MathBoolBase
---@field A boolean
---@field B boolean
---@field Result boolean
local FRigVMFunction_MathBoolBinaryOp = {}



---@class FRigVMFunction_MathBoolConstFalse : FRigVMFunction_MathBoolConstant
local FRigVMFunction_MathBoolConstFalse = {}


---@class FRigVMFunction_MathBoolConstTrue : FRigVMFunction_MathBoolConstant
local FRigVMFunction_MathBoolConstTrue = {}


---@class FRigVMFunction_MathBoolConstant : FRigVMFunction_MathBoolBase
---@field Value boolean
local FRigVMFunction_MathBoolConstant = {}



---@class FRigVMFunction_MathBoolEquals : FRigVMFunction_MathBoolBase
---@field A boolean
---@field B boolean
---@field Result boolean
local FRigVMFunction_MathBoolEquals = {}



---@class FRigVMFunction_MathBoolFlipFlop : FRigVMFunction_MathBoolBase
---@field StartValue boolean
---@field Duration float
---@field Result boolean
---@field LastValue boolean
---@field TimeLeft float
local FRigVMFunction_MathBoolFlipFlop = {}



---@class FRigVMFunction_MathBoolMake : FRigVMFunction_MathBoolBase
---@field Value boolean
local FRigVMFunction_MathBoolMake = {}



---@class FRigVMFunction_MathBoolNand : FRigVMFunction_MathBoolBinaryOp
local FRigVMFunction_MathBoolNand = {}


---@class FRigVMFunction_MathBoolNand2 : FRigVMFunction_MathBoolBinaryOp
local FRigVMFunction_MathBoolNand2 = {}


---@class FRigVMFunction_MathBoolNot : FRigVMFunction_MathBoolUnaryOp
local FRigVMFunction_MathBoolNot = {}


---@class FRigVMFunction_MathBoolNotEquals : FRigVMFunction_MathBoolBase
---@field A boolean
---@field B boolean
---@field Result boolean
local FRigVMFunction_MathBoolNotEquals = {}



---@class FRigVMFunction_MathBoolOnce : FRigVMFunction_MathBoolBase
---@field Duration float
---@field Result boolean
---@field LastValue boolean
---@field TimeLeft float
local FRigVMFunction_MathBoolOnce = {}



---@class FRigVMFunction_MathBoolOr : FRigVMFunction_MathBoolBinaryAggregateOp
local FRigVMFunction_MathBoolOr = {}


---@class FRigVMFunction_MathBoolToFloat : FRigVMFunction_MathBoolBase
---@field Value boolean
---@field Result float
local FRigVMFunction_MathBoolToFloat = {}



---@class FRigVMFunction_MathBoolToInteger : FRigVMFunction_MathBoolBase
---@field Value boolean
---@field Result int32
local FRigVMFunction_MathBoolToInteger = {}



---@class FRigVMFunction_MathBoolToggled : FRigVMFunction_MathBoolBase
---@field Value boolean
---@field Toggled boolean
---@field Initialized boolean
---@field LastValue boolean
local FRigVMFunction_MathBoolToggled = {}



---@class FRigVMFunction_MathBoolUnaryOp : FRigVMFunction_MathBoolBase
---@field Value boolean
---@field Result boolean
local FRigVMFunction_MathBoolUnaryOp = {}



---@class FRigVMFunction_MathBoxBase : FRigVMFunction_MathBase
local FRigVMFunction_MathBoxBase = {}


---@class FRigVMFunction_MathBoxExpand : FRigVMFunction_MathBoxBase
---@field Box FBox
---@field Amount FVector
---@field Result FBox
local FRigVMFunction_MathBoxExpand = {}



---@class FRigVMFunction_MathBoxFromArray : FRigVMFunction_MathBoxBase
---@field Array TArray<FVector>
---@field Box FBox
---@field Minimum FVector
---@field Maximum FVector
---@field Center FVector
---@field Size FVector
local FRigVMFunction_MathBoxFromArray = {}



---@class FRigVMFunction_MathBoxGetCenter : FRigVMFunction_MathBoxBase
---@field Box FBox
---@field Center FVector
local FRigVMFunction_MathBoxGetCenter = {}



---@class FRigVMFunction_MathBoxGetDistance : FRigVMFunction_MathBoxBase
---@field Box FBox
---@field Position FVector
---@field Square boolean
---@field Valid boolean
---@field Distance float
local FRigVMFunction_MathBoxGetDistance = {}



---@class FRigVMFunction_MathBoxGetSize : FRigVMFunction_MathBoxBase
---@field Box FBox
---@field Size FVector
---@field Extent FVector
local FRigVMFunction_MathBoxGetSize = {}



---@class FRigVMFunction_MathBoxGetVolume : FRigVMFunction_MathBoxBase
---@field Box FBox
---@field Volume float
local FRigVMFunction_MathBoxGetVolume = {}



---@class FRigVMFunction_MathBoxIsInside : FRigVMFunction_MathBoxBase
---@field Box FBox
---@field Position FVector
---@field Result boolean
local FRigVMFunction_MathBoxIsInside = {}



---@class FRigVMFunction_MathBoxIsValid : FRigVMFunction_MathBoxBase
---@field Box FBox
---@field Valid boolean
local FRigVMFunction_MathBoxIsValid = {}



---@class FRigVMFunction_MathBoxMoveTo : FRigVMFunction_MathBoxBase
---@field Box FBox
---@field Center FVector
---@field Result FBox
local FRigVMFunction_MathBoxMoveTo = {}



---@class FRigVMFunction_MathBoxShift : FRigVMFunction_MathBoxBase
---@field Box FBox
---@field Amount FVector
---@field Result FBox
local FRigVMFunction_MathBoxShift = {}



---@class FRigVMFunction_MathBoxTransform : FRigVMFunction_MathBoxBase
---@field Box FBox
---@field Transform FTransform
---@field Result FBox
local FRigVMFunction_MathBoxTransform = {}



---@class FRigVMFunction_MathColorAdd : FRigVMFunction_MathColorBinaryAggregateOp
local FRigVMFunction_MathColorAdd = {}


---@class FRigVMFunction_MathColorBase : FRigVMFunction_MathBase
local FRigVMFunction_MathColorBase = {}


---@class FRigVMFunction_MathColorBinaryAggregateOp : FRigVMFunction_MathColorBase
---@field A FLinearColor
---@field B FLinearColor
---@field Result FLinearColor
local FRigVMFunction_MathColorBinaryAggregateOp = {}



---@class FRigVMFunction_MathColorBinaryOp : FRigVMFunction_MathColorBase
---@field A FLinearColor
---@field B FLinearColor
---@field Result FLinearColor
local FRigVMFunction_MathColorBinaryOp = {}



---@class FRigVMFunction_MathColorFromDouble : FRigVMFunction_MathColorBase
---@field Value double
---@field Result FLinearColor
local FRigVMFunction_MathColorFromDouble = {}



---@class FRigVMFunction_MathColorFromFloat : FRigVMFunction_MathColorBase
---@field Value float
---@field Result FLinearColor
local FRigVMFunction_MathColorFromFloat = {}



---@class FRigVMFunction_MathColorLerp : FRigVMFunction_MathColorBase
---@field A FLinearColor
---@field B FLinearColor
---@field T float
---@field Result FLinearColor
local FRigVMFunction_MathColorLerp = {}



---@class FRigVMFunction_MathColorMake : FRigVMFunction_MathColorBase
---@field R float
---@field G float
---@field B float
---@field A float
---@field Result FLinearColor
local FRigVMFunction_MathColorMake = {}



---@class FRigVMFunction_MathColorMul : FRigVMFunction_MathColorBinaryAggregateOp
local FRigVMFunction_MathColorMul = {}


---@class FRigVMFunction_MathColorSub : FRigVMFunction_MathColorBinaryOp
local FRigVMFunction_MathColorSub = {}


---@class FRigVMFunction_MathDistanceToPlane : FRigVMFunction_MathVectorBase
---@field Point FVector
---@field PlanePoint FVector
---@field PlaneNormal FVector
---@field ClosestPointOnPlane FVector
---@field SignedDistance float
local FRigVMFunction_MathDistanceToPlane = {}



---@class FRigVMFunction_MathDoubleAbs : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleAbs = {}


---@class FRigVMFunction_MathDoubleAcos : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleAcos = {}


---@class FRigVMFunction_MathDoubleAdd : FRigVMFunction_MathDoubleBinaryAggregateOp
local FRigVMFunction_MathDoubleAdd = {}


---@class FRigVMFunction_MathDoubleArrayAverage : FRigVMFunction_MathDoubleBase
---@field Array TArray<double>
---@field Average double
local FRigVMFunction_MathDoubleArrayAverage = {}



---@class FRigVMFunction_MathDoubleArraySum : FRigVMFunction_MathDoubleBase
---@field Array TArray<double>
---@field Sum double
local FRigVMFunction_MathDoubleArraySum = {}



---@class FRigVMFunction_MathDoubleAsin : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleAsin = {}


---@class FRigVMFunction_MathDoubleAtan : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleAtan = {}


---@class FRigVMFunction_MathDoubleAtan2 : FRigVMFunction_MathDoubleBinaryOp
local FRigVMFunction_MathDoubleAtan2 = {}


---@class FRigVMFunction_MathDoubleBase : FRigVMFunction_MathBase
local FRigVMFunction_MathDoubleBase = {}


---@class FRigVMFunction_MathDoubleBinaryAggregateOp : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field Result double
local FRigVMFunction_MathDoubleBinaryAggregateOp = {}



---@class FRigVMFunction_MathDoubleBinaryOp : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field Result double
local FRigVMFunction_MathDoubleBinaryOp = {}



---@class FRigVMFunction_MathDoubleCeil : FRigVMFunction_MathDoubleBase
---@field Value double
---@field Result double
---@field Int int32
local FRigVMFunction_MathDoubleCeil = {}



---@class FRigVMFunction_MathDoubleClamp : FRigVMFunction_MathDoubleBase
---@field Value double
---@field Minimum double
---@field Maximum double
---@field Result double
local FRigVMFunction_MathDoubleClamp = {}



---@class FRigVMFunction_MathDoubleConstE : FRigVMFunction_MathDoubleConstant
local FRigVMFunction_MathDoubleConstE = {}


---@class FRigVMFunction_MathDoubleConstHalfPi : FRigVMFunction_MathDoubleConstant
local FRigVMFunction_MathDoubleConstHalfPi = {}


---@class FRigVMFunction_MathDoubleConstPi : FRigVMFunction_MathDoubleConstant
local FRigVMFunction_MathDoubleConstPi = {}


---@class FRigVMFunction_MathDoubleConstTwoPi : FRigVMFunction_MathDoubleConstant
local FRigVMFunction_MathDoubleConstTwoPi = {}


---@class FRigVMFunction_MathDoubleConstant : FRigVMFunction_MathDoubleBase
---@field Value double
local FRigVMFunction_MathDoubleConstant = {}



---@class FRigVMFunction_MathDoubleCos : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleCos = {}


---@class FRigVMFunction_MathDoubleDeg : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleDeg = {}


---@class FRigVMFunction_MathDoubleDiv : FRigVMFunction_MathDoubleBinaryOp
local FRigVMFunction_MathDoubleDiv = {}


---@class FRigVMFunction_MathDoubleEquals : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field Result boolean
local FRigVMFunction_MathDoubleEquals = {}



---@class FRigVMFunction_MathDoubleExponential : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleExponential = {}


---@class FRigVMFunction_MathDoubleFloor : FRigVMFunction_MathDoubleBase
---@field Value double
---@field Result double
---@field Int int32
local FRigVMFunction_MathDoubleFloor = {}



---@class FRigVMFunction_MathDoubleGreater : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field Result boolean
local FRigVMFunction_MathDoubleGreater = {}



---@class FRigVMFunction_MathDoubleGreaterEqual : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field Result boolean
local FRigVMFunction_MathDoubleGreaterEqual = {}



---@class FRigVMFunction_MathDoubleIsNearlyEqual : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field Tolerance double
---@field Result boolean
local FRigVMFunction_MathDoubleIsNearlyEqual = {}



---@class FRigVMFunction_MathDoubleIsNearlyZero : FRigVMFunction_MathDoubleBase
---@field Value double
---@field Tolerance double
---@field Result boolean
local FRigVMFunction_MathDoubleIsNearlyZero = {}



---@class FRigVMFunction_MathDoubleLawOfCosine : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field C double
---@field AlphaAngle double
---@field BetaAngle double
---@field GammaAngle double
---@field bValid boolean
local FRigVMFunction_MathDoubleLawOfCosine = {}



---@class FRigVMFunction_MathDoubleLerp : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field T double
---@field Result double
local FRigVMFunction_MathDoubleLerp = {}



---@class FRigVMFunction_MathDoubleLess : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field Result boolean
local FRigVMFunction_MathDoubleLess = {}



---@class FRigVMFunction_MathDoubleLessEqual : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field Result boolean
local FRigVMFunction_MathDoubleLessEqual = {}



---@class FRigVMFunction_MathDoubleMake : FRigVMFunction_MathDoubleBase
---@field Value double
local FRigVMFunction_MathDoubleMake = {}



---@class FRigVMFunction_MathDoubleMax : FRigVMFunction_MathDoubleBinaryAggregateOp
local FRigVMFunction_MathDoubleMax = {}


---@class FRigVMFunction_MathDoubleMin : FRigVMFunction_MathDoubleBinaryAggregateOp
local FRigVMFunction_MathDoubleMin = {}


---@class FRigVMFunction_MathDoubleMod : FRigVMFunction_MathDoubleBinaryOp
local FRigVMFunction_MathDoubleMod = {}


---@class FRigVMFunction_MathDoubleMul : FRigVMFunction_MathDoubleBinaryAggregateOp
local FRigVMFunction_MathDoubleMul = {}


---@class FRigVMFunction_MathDoubleNegate : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleNegate = {}


---@class FRigVMFunction_MathDoubleNotEquals : FRigVMFunction_MathDoubleBase
---@field A double
---@field B double
---@field Result boolean
local FRigVMFunction_MathDoubleNotEquals = {}



---@class FRigVMFunction_MathDoublePow : FRigVMFunction_MathDoubleBinaryOp
local FRigVMFunction_MathDoublePow = {}


---@class FRigVMFunction_MathDoubleRad : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleRad = {}


---@class FRigVMFunction_MathDoubleRemap : FRigVMFunction_MathDoubleBase
---@field Value double
---@field SourceMinimum double
---@field SourceMaximum double
---@field TargetMinimum double
---@field TargetMaximum double
---@field bClamp boolean
---@field Result double
local FRigVMFunction_MathDoubleRemap = {}



---@class FRigVMFunction_MathDoubleRound : FRigVMFunction_MathDoubleBase
---@field Value double
---@field Result double
---@field Int int32
local FRigVMFunction_MathDoubleRound = {}



---@class FRigVMFunction_MathDoubleSign : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleSign = {}


---@class FRigVMFunction_MathDoubleSin : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleSin = {}


---@class FRigVMFunction_MathDoubleSqrt : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleSqrt = {}


---@class FRigVMFunction_MathDoubleSub : FRigVMFunction_MathDoubleBinaryOp
local FRigVMFunction_MathDoubleSub = {}


---@class FRigVMFunction_MathDoubleTan : FRigVMFunction_MathDoubleUnaryOp
local FRigVMFunction_MathDoubleTan = {}


---@class FRigVMFunction_MathDoubleToFloat : FRigVMFunction_MathDoubleBase
---@field Value double
---@field Result float
local FRigVMFunction_MathDoubleToFloat = {}



---@class FRigVMFunction_MathDoubleToInt : FRigVMFunction_MathDoubleBase
---@field Value double
---@field Result int32
local FRigVMFunction_MathDoubleToInt = {}



---@class FRigVMFunction_MathDoubleUnaryOp : FRigVMFunction_MathDoubleBase
---@field Value double
---@field Result double
local FRigVMFunction_MathDoubleUnaryOp = {}



---@class FRigVMFunction_MathFloatAbs : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatAbs = {}


---@class FRigVMFunction_MathFloatAcos : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatAcos = {}


---@class FRigVMFunction_MathFloatAdd : FRigVMFunction_MathFloatBinaryAggregateOp
local FRigVMFunction_MathFloatAdd = {}


---@class FRigVMFunction_MathFloatArrayAverage : FRigVMFunction_MathFloatBase
---@field Array TArray<float>
---@field Average float
local FRigVMFunction_MathFloatArrayAverage = {}



---@class FRigVMFunction_MathFloatArraySum : FRigVMFunction_MathFloatBase
---@field Array TArray<float>
---@field Sum float
local FRigVMFunction_MathFloatArraySum = {}



---@class FRigVMFunction_MathFloatAsin : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatAsin = {}


---@class FRigVMFunction_MathFloatAtan : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatAtan = {}


---@class FRigVMFunction_MathFloatAtan2 : FRigVMFunction_MathFloatBinaryOp
local FRigVMFunction_MathFloatAtan2 = {}


---@class FRigVMFunction_MathFloatBase : FRigVMFunction_MathBase
local FRigVMFunction_MathFloatBase = {}


---@class FRigVMFunction_MathFloatBinaryAggregateOp : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field Result float
local FRigVMFunction_MathFloatBinaryAggregateOp = {}



---@class FRigVMFunction_MathFloatBinaryOp : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field Result float
local FRigVMFunction_MathFloatBinaryOp = {}



---@class FRigVMFunction_MathFloatCeil : FRigVMFunction_MathFloatBase
---@field Value float
---@field Result float
---@field Int int32
local FRigVMFunction_MathFloatCeil = {}



---@class FRigVMFunction_MathFloatClamp : FRigVMFunction_MathFloatBase
---@field Value float
---@field Minimum float
---@field Maximum float
---@field Result float
local FRigVMFunction_MathFloatClamp = {}



---@class FRigVMFunction_MathFloatConstE : FRigVMFunction_MathFloatConstant
local FRigVMFunction_MathFloatConstE = {}


---@class FRigVMFunction_MathFloatConstHalfPi : FRigVMFunction_MathFloatConstant
local FRigVMFunction_MathFloatConstHalfPi = {}


---@class FRigVMFunction_MathFloatConstPi : FRigVMFunction_MathFloatConstant
local FRigVMFunction_MathFloatConstPi = {}


---@class FRigVMFunction_MathFloatConstTwoPi : FRigVMFunction_MathFloatConstant
local FRigVMFunction_MathFloatConstTwoPi = {}


---@class FRigVMFunction_MathFloatConstant : FRigVMFunction_MathFloatBase
---@field Value float
local FRigVMFunction_MathFloatConstant = {}



---@class FRigVMFunction_MathFloatCos : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatCos = {}


---@class FRigVMFunction_MathFloatDeg : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatDeg = {}


---@class FRigVMFunction_MathFloatDiv : FRigVMFunction_MathFloatBinaryOp
local FRigVMFunction_MathFloatDiv = {}


---@class FRigVMFunction_MathFloatEquals : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field Result boolean
local FRigVMFunction_MathFloatEquals = {}



---@class FRigVMFunction_MathFloatExponential : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatExponential = {}


---@class FRigVMFunction_MathFloatFloor : FRigVMFunction_MathFloatBase
---@field Value float
---@field Result float
---@field Int int32
local FRigVMFunction_MathFloatFloor = {}



---@class FRigVMFunction_MathFloatGreater : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field Result boolean
local FRigVMFunction_MathFloatGreater = {}



---@class FRigVMFunction_MathFloatGreaterEqual : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field Result boolean
local FRigVMFunction_MathFloatGreaterEqual = {}



---@class FRigVMFunction_MathFloatIsNearlyEqual : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field Tolerance float
---@field Result boolean
local FRigVMFunction_MathFloatIsNearlyEqual = {}



---@class FRigVMFunction_MathFloatIsNearlyZero : FRigVMFunction_MathFloatBase
---@field Value float
---@field Tolerance float
---@field Result boolean
local FRigVMFunction_MathFloatIsNearlyZero = {}



---@class FRigVMFunction_MathFloatLawOfCosine : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field C float
---@field AlphaAngle float
---@field BetaAngle float
---@field GammaAngle float
---@field bValid boolean
local FRigVMFunction_MathFloatLawOfCosine = {}



---@class FRigVMFunction_MathFloatLerp : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field T float
---@field Result float
local FRigVMFunction_MathFloatLerp = {}



---@class FRigVMFunction_MathFloatLess : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field Result boolean
local FRigVMFunction_MathFloatLess = {}



---@class FRigVMFunction_MathFloatLessEqual : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field Result boolean
local FRigVMFunction_MathFloatLessEqual = {}



---@class FRigVMFunction_MathFloatMake : FRigVMFunction_MathFloatBase
---@field Value float
local FRigVMFunction_MathFloatMake = {}



---@class FRigVMFunction_MathFloatMax : FRigVMFunction_MathFloatBinaryAggregateOp
local FRigVMFunction_MathFloatMax = {}


---@class FRigVMFunction_MathFloatMin : FRigVMFunction_MathFloatBinaryAggregateOp
local FRigVMFunction_MathFloatMin = {}


---@class FRigVMFunction_MathFloatMod : FRigVMFunction_MathFloatBinaryOp
local FRigVMFunction_MathFloatMod = {}


---@class FRigVMFunction_MathFloatMul : FRigVMFunction_MathFloatBinaryAggregateOp
local FRigVMFunction_MathFloatMul = {}


---@class FRigVMFunction_MathFloatNegate : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatNegate = {}


---@class FRigVMFunction_MathFloatNotEquals : FRigVMFunction_MathFloatBase
---@field A float
---@field B float
---@field Result boolean
local FRigVMFunction_MathFloatNotEquals = {}



---@class FRigVMFunction_MathFloatPow : FRigVMFunction_MathFloatBinaryOp
local FRigVMFunction_MathFloatPow = {}


---@class FRigVMFunction_MathFloatRad : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatRad = {}


---@class FRigVMFunction_MathFloatRemap : FRigVMFunction_MathFloatBase
---@field Value float
---@field SourceMinimum float
---@field SourceMaximum float
---@field TargetMinimum float
---@field TargetMaximum float
---@field bClamp boolean
---@field Result float
local FRigVMFunction_MathFloatRemap = {}



---@class FRigVMFunction_MathFloatRound : FRigVMFunction_MathFloatBase
---@field Value float
---@field Result float
---@field Int int32
local FRigVMFunction_MathFloatRound = {}



---@class FRigVMFunction_MathFloatSelectBool : FRigVMFunction_MathFloatBase
---@field Condition boolean
---@field IfTrue float
---@field IfFalse float
---@field Result float
local FRigVMFunction_MathFloatSelectBool = {}



---@class FRigVMFunction_MathFloatSign : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatSign = {}


---@class FRigVMFunction_MathFloatSin : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatSin = {}


---@class FRigVMFunction_MathFloatSqrt : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatSqrt = {}


---@class FRigVMFunction_MathFloatSub : FRigVMFunction_MathFloatBinaryOp
local FRigVMFunction_MathFloatSub = {}


---@class FRigVMFunction_MathFloatTan : FRigVMFunction_MathFloatUnaryOp
local FRigVMFunction_MathFloatTan = {}


---@class FRigVMFunction_MathFloatToDouble : FRigVMFunction_MathFloatBase
---@field Value float
---@field Result double
local FRigVMFunction_MathFloatToDouble = {}



---@class FRigVMFunction_MathFloatToInt : FRigVMFunction_MathFloatBase
---@field Value float
---@field Result int32
local FRigVMFunction_MathFloatToInt = {}



---@class FRigVMFunction_MathFloatUnaryOp : FRigVMFunction_MathFloatBase
---@field Value float
---@field Result float
local FRigVMFunction_MathFloatUnaryOp = {}



---@class FRigVMFunction_MathIntAbs : FRigVMFunction_MathIntUnaryOp
local FRigVMFunction_MathIntAbs = {}


---@class FRigVMFunction_MathIntAdd : FRigVMFunction_MathIntBinaryAggregateOp
local FRigVMFunction_MathIntAdd = {}


---@class FRigVMFunction_MathIntArrayAverage : FRigVMFunction_MathIntBase
---@field Array TArray<int32>
---@field Average int32
local FRigVMFunction_MathIntArrayAverage = {}



---@class FRigVMFunction_MathIntArraySum : FRigVMFunction_MathIntBase
---@field Array TArray<int32>
---@field Sum int32
local FRigVMFunction_MathIntArraySum = {}



---@class FRigVMFunction_MathIntBase : FRigVMFunction_MathBase
local FRigVMFunction_MathIntBase = {}


---@class FRigVMFunction_MathIntBinaryAggregateOp : FRigVMFunction_MathIntBase
---@field A int32
---@field B int32
---@field Result int32
local FRigVMFunction_MathIntBinaryAggregateOp = {}



---@class FRigVMFunction_MathIntBinaryOp : FRigVMFunction_MathIntBase
---@field A int32
---@field B int32
---@field Result int32
local FRigVMFunction_MathIntBinaryOp = {}



---@class FRigVMFunction_MathIntClamp : FRigVMFunction_MathIntBase
---@field Value int32
---@field Minimum int32
---@field Maximum int32
---@field Result int32
local FRigVMFunction_MathIntClamp = {}



---@class FRigVMFunction_MathIntDiv : FRigVMFunction_MathIntBinaryOp
local FRigVMFunction_MathIntDiv = {}


---@class FRigVMFunction_MathIntEquals : FRigVMFunction_MathIntBase
---@field A int32
---@field B int32
---@field Result boolean
local FRigVMFunction_MathIntEquals = {}



---@class FRigVMFunction_MathIntGreater : FRigVMFunction_MathIntBase
---@field A int32
---@field B int32
---@field Result boolean
local FRigVMFunction_MathIntGreater = {}



---@class FRigVMFunction_MathIntGreaterEqual : FRigVMFunction_MathIntBase
---@field A int32
---@field B int32
---@field Result boolean
local FRigVMFunction_MathIntGreaterEqual = {}



---@class FRigVMFunction_MathIntLess : FRigVMFunction_MathIntBase
---@field A int32
---@field B int32
---@field Result boolean
local FRigVMFunction_MathIntLess = {}



---@class FRigVMFunction_MathIntLessEqual : FRigVMFunction_MathIntBase
---@field A int32
---@field B int32
---@field Result boolean
local FRigVMFunction_MathIntLessEqual = {}



---@class FRigVMFunction_MathIntMake : FRigVMFunction_MathIntBase
---@field Value int32
local FRigVMFunction_MathIntMake = {}



---@class FRigVMFunction_MathIntMax : FRigVMFunction_MathIntBinaryAggregateOp
local FRigVMFunction_MathIntMax = {}


---@class FRigVMFunction_MathIntMin : FRigVMFunction_MathIntBinaryAggregateOp
local FRigVMFunction_MathIntMin = {}


---@class FRigVMFunction_MathIntMod : FRigVMFunction_MathIntBinaryOp
local FRigVMFunction_MathIntMod = {}


---@class FRigVMFunction_MathIntMul : FRigVMFunction_MathIntBinaryAggregateOp
local FRigVMFunction_MathIntMul = {}


---@class FRigVMFunction_MathIntNegate : FRigVMFunction_MathIntUnaryOp
local FRigVMFunction_MathIntNegate = {}


---@class FRigVMFunction_MathIntNotEquals : FRigVMFunction_MathIntBase
---@field A int32
---@field B int32
---@field Result boolean
local FRigVMFunction_MathIntNotEquals = {}



---@class FRigVMFunction_MathIntPow : FRigVMFunction_MathIntBinaryOp
local FRigVMFunction_MathIntPow = {}


---@class FRigVMFunction_MathIntSign : FRigVMFunction_MathIntUnaryOp
local FRigVMFunction_MathIntSign = {}


---@class FRigVMFunction_MathIntSub : FRigVMFunction_MathIntBinaryOp
local FRigVMFunction_MathIntSub = {}


---@class FRigVMFunction_MathIntToDouble : FRigVMFunction_MathIntBase
---@field Value int32
---@field Result double
local FRigVMFunction_MathIntToDouble = {}



---@class FRigVMFunction_MathIntToFloat : FRigVMFunction_MathIntBase
---@field Value int32
---@field Result float
local FRigVMFunction_MathIntToFloat = {}



---@class FRigVMFunction_MathIntToName : FRigVMFunction_MathIntBase
---@field Number int32
---@field PaddedSize int32
---@field Result FName
local FRigVMFunction_MathIntToName = {}



---@class FRigVMFunction_MathIntToString : FRigVMFunction_MathIntBase
---@field Number int32
---@field PaddedSize int32
---@field Result FString
local FRigVMFunction_MathIntToString = {}



---@class FRigVMFunction_MathIntUnaryOp : FRigVMFunction_MathIntBase
---@field Value int32
---@field Result int32
local FRigVMFunction_MathIntUnaryOp = {}



---@class FRigVMFunction_MathIntersectPlane : FRigVMFunction_MathVectorBase
---@field Start FVector
---@field Direction FVector
---@field PlanePoint FVector
---@field PlaneNormal FVector
---@field Result FVector
---@field Distance float
local FRigVMFunction_MathIntersectPlane = {}



---@class FRigVMFunction_MathMatrixBase : FRigVMFunction_MathBase
local FRigVMFunction_MathMatrixBase = {}


---@class FRigVMFunction_MathMatrixBinaryAggregateOp : FRigVMFunction_MathMatrixBase
---@field A FMatrix
---@field B FMatrix
---@field Result FMatrix
local FRigVMFunction_MathMatrixBinaryAggregateOp = {}



---@class FRigVMFunction_MathMatrixBinaryOp : FRigVMFunction_MathMatrixBase
---@field A FMatrix
---@field B FMatrix
---@field Result FMatrix
local FRigVMFunction_MathMatrixBinaryOp = {}



---@class FRigVMFunction_MathMatrixFromTransform : FRigVMFunction_MathMatrixBase
---@field Transform FTransform
---@field Result FMatrix
local FRigVMFunction_MathMatrixFromTransform = {}



---@class FRigVMFunction_MathMatrixFromTransformV2 : FRigVMFunction_MathMatrixBase
---@field Value FTransform
---@field Result FMatrix
local FRigVMFunction_MathMatrixFromTransformV2 = {}



---@class FRigVMFunction_MathMatrixFromVectors : FRigVMFunction_MathMatrixBase
---@field Origin FVector
---@field X FVector
---@field Y FVector
---@field Z FVector
---@field Result FMatrix
local FRigVMFunction_MathMatrixFromVectors = {}



---@class FRigVMFunction_MathMatrixInverse : FRigVMFunction_MathMatrixUnaryOp
local FRigVMFunction_MathMatrixInverse = {}


---@class FRigVMFunction_MathMatrixMul : FRigVMFunction_MathMatrixBinaryAggregateOp
local FRigVMFunction_MathMatrixMul = {}


---@class FRigVMFunction_MathMatrixToTransform : FRigVMFunction_MathMatrixBase
---@field Value FMatrix
---@field Result FTransform
local FRigVMFunction_MathMatrixToTransform = {}



---@class FRigVMFunction_MathMatrixToVectors : FRigVMFunction_MathMatrixBase
---@field Value FMatrix
---@field Origin FVector
---@field X FVector
---@field Y FVector
---@field Z FVector
local FRigVMFunction_MathMatrixToVectors = {}



---@class FRigVMFunction_MathMatrixUnaryOp : FRigVMFunction_MathMatrixBase
---@field Value FMatrix
---@field Result FMatrix
local FRigVMFunction_MathMatrixUnaryOp = {}



---@class FRigVMFunction_MathMutableBase : FRigVMStructMutable
local FRigVMFunction_MathMutableBase = {}


---@class FRigVMFunction_MathQuaternionBase : FRigVMFunction_MathBase
local FRigVMFunction_MathQuaternionBase = {}


---@class FRigVMFunction_MathQuaternionBinaryAggregateOp : FRigVMFunction_MathQuaternionBase
---@field A FQuat
---@field B FQuat
---@field Result FQuat
local FRigVMFunction_MathQuaternionBinaryAggregateOp = {}



---@class FRigVMFunction_MathQuaternionBinaryOp : FRigVMFunction_MathQuaternionBase
---@field A FQuat
---@field B FQuat
---@field Result FQuat
local FRigVMFunction_MathQuaternionBinaryOp = {}



---@class FRigVMFunction_MathQuaternionDot : FRigVMFunction_MathQuaternionBase
---@field A FQuat
---@field B FQuat
---@field Result float
local FRigVMFunction_MathQuaternionDot = {}



---@class FRigVMFunction_MathQuaternionEquals : FRigVMFunction_MathQuaternionBase
---@field A FQuat
---@field B FQuat
---@field Result boolean
local FRigVMFunction_MathQuaternionEquals = {}



---@class FRigVMFunction_MathQuaternionFromAxisAndAngle : FRigVMFunction_MathQuaternionBase
---@field Axis FVector
---@field Angle float
---@field Result FQuat
local FRigVMFunction_MathQuaternionFromAxisAndAngle = {}



---@class FRigVMFunction_MathQuaternionFromEuler : FRigVMFunction_MathQuaternionBase
---@field Euler FVector
---@field RotationOrder EEulerRotationOrder
---@field Result FQuat
local FRigVMFunction_MathQuaternionFromEuler = {}



---@class FRigVMFunction_MathQuaternionFromRotator : FRigVMFunction_MathQuaternionBase
---@field Rotator FRotator
---@field Result FQuat
local FRigVMFunction_MathQuaternionFromRotator = {}



---@class FRigVMFunction_MathQuaternionFromRotatorV2 : FRigVMFunction_MathQuaternionBase
---@field Value FRotator
---@field Result FQuat
local FRigVMFunction_MathQuaternionFromRotatorV2 = {}



---@class FRigVMFunction_MathQuaternionFromTwoVectors : FRigVMFunction_MathQuaternionBase
---@field A FVector
---@field B FVector
---@field Result FQuat
local FRigVMFunction_MathQuaternionFromTwoVectors = {}



---@class FRigVMFunction_MathQuaternionGetAxis : FRigVMFunction_MathQuaternionBase
---@field Quaternion FQuat
---@field Axis EAxis::Type
---@field Result FVector
local FRigVMFunction_MathQuaternionGetAxis = {}



---@class FRigVMFunction_MathQuaternionInverse : FRigVMFunction_MathQuaternionUnaryOp
local FRigVMFunction_MathQuaternionInverse = {}


---@class FRigVMFunction_MathQuaternionMake : FRigVMFunction_MathQuaternionBase
---@field X float
---@field Y float
---@field Z float
---@field W float
---@field Result FQuat
local FRigVMFunction_MathQuaternionMake = {}



---@class FRigVMFunction_MathQuaternionMakeAbsolute : FRigVMFunction_MathQuaternionBase
---@field Local FQuat
---@field Parent FQuat
---@field Global FQuat
local FRigVMFunction_MathQuaternionMakeAbsolute = {}



---@class FRigVMFunction_MathQuaternionMakeRelative : FRigVMFunction_MathQuaternionBase
---@field Global FQuat
---@field Parent FQuat
---@field Local FQuat
local FRigVMFunction_MathQuaternionMakeRelative = {}



---@class FRigVMFunction_MathQuaternionMirrorTransform : FRigVMFunction_MathQuaternionBase
---@field Value FQuat
---@field MirrorAxis EAxis::Type
---@field AxisToFlip EAxis::Type
---@field CentralTransform FTransform
---@field Result FQuat
local FRigVMFunction_MathQuaternionMirrorTransform = {}



---@class FRigVMFunction_MathQuaternionMul : FRigVMFunction_MathQuaternionBinaryAggregateOp
local FRigVMFunction_MathQuaternionMul = {}


---@class FRigVMFunction_MathQuaternionNotEquals : FRigVMFunction_MathQuaternionBase
---@field A FQuat
---@field B FQuat
---@field Result boolean
local FRigVMFunction_MathQuaternionNotEquals = {}



---@class FRigVMFunction_MathQuaternionRotateVector : FRigVMFunction_MathQuaternionBase
---@field Transform FQuat
---@field Vector FVector
---@field Result FVector
local FRigVMFunction_MathQuaternionRotateVector = {}



---@class FRigVMFunction_MathQuaternionRotationOrder : FRigVMFunction_MathBase
---@field RotationOrder EEulerRotationOrder
local FRigVMFunction_MathQuaternionRotationOrder = {}



---@class FRigVMFunction_MathQuaternionScale : FRigVMFunction_MathQuaternionBase
---@field Value FQuat
---@field Scale float
local FRigVMFunction_MathQuaternionScale = {}



---@class FRigVMFunction_MathQuaternionScaleV2 : FRigVMFunction_MathQuaternionBase
---@field Value FQuat
---@field Factor float
---@field Result FQuat
local FRigVMFunction_MathQuaternionScaleV2 = {}



---@class FRigVMFunction_MathQuaternionSelectBool : FRigVMFunction_MathQuaternionBase
---@field Condition boolean
---@field IfTrue FQuat
---@field IfFalse FQuat
---@field Result FQuat
local FRigVMFunction_MathQuaternionSelectBool = {}



---@class FRigVMFunction_MathQuaternionSlerp : FRigVMFunction_MathQuaternionBase
---@field A FQuat
---@field B FQuat
---@field T float
---@field Result FQuat
local FRigVMFunction_MathQuaternionSlerp = {}



---@class FRigVMFunction_MathQuaternionSwingTwist : FRigVMFunction_MathQuaternionBase
---@field Input FQuat
---@field TwistAxis FVector
---@field Swing FQuat
---@field Twist FQuat
local FRigVMFunction_MathQuaternionSwingTwist = {}



---@class FRigVMFunction_MathQuaternionToAxisAndAngle : FRigVMFunction_MathQuaternionBase
---@field Value FQuat
---@field Axis FVector
---@field Angle float
local FRigVMFunction_MathQuaternionToAxisAndAngle = {}



---@class FRigVMFunction_MathQuaternionToEuler : FRigVMFunction_MathQuaternionBase
---@field Value FQuat
---@field RotationOrder EEulerRotationOrder
---@field Result FVector
local FRigVMFunction_MathQuaternionToEuler = {}



---@class FRigVMFunction_MathQuaternionToRotator : FRigVMFunction_MathQuaternionBase
---@field Value FQuat
---@field Result FRotator
local FRigVMFunction_MathQuaternionToRotator = {}



---@class FRigVMFunction_MathQuaternionToVectors : FRigVMFunction_MathQuaternionBase
---@field Value FQuat
---@field Forward FVector
---@field Right FVector
---@field Up FVector
local FRigVMFunction_MathQuaternionToVectors = {}



---@class FRigVMFunction_MathQuaternionUnaryOp : FRigVMFunction_MathQuaternionBase
---@field Value FQuat
---@field Result FQuat
local FRigVMFunction_MathQuaternionUnaryOp = {}



---@class FRigVMFunction_MathQuaternionUnit : FRigVMFunction_MathQuaternionUnaryOp
local FRigVMFunction_MathQuaternionUnit = {}


---@class FRigVMFunction_MathRBFInterpolateBase : FRigVMFunction_MathBase
local FRigVMFunction_MathRBFInterpolateBase = {}


---@class FRigVMFunction_MathRBFInterpolateQuatBase : FRigVMFunction_MathRBFInterpolateBase
---@field Input FQuat
---@field DistanceFunction ERBFQuatDistanceType
---@field SmoothingFunction ERBFKernelType
---@field SmoothingAngle float
---@field bNormalizeOutput boolean
---@field TwistAxis FVector
---@field WorkData FRigVMFunction_MathRBFInterpolateQuatWorkData
local FRigVMFunction_MathRBFInterpolateQuatBase = {}



---@class FRigVMFunction_MathRBFInterpolateQuatColor : FRigVMFunction_MathRBFInterpolateQuatBase
---@field Targets TArray<FMathRBFInterpolateQuatColor_Target>
---@field Output FLinearColor
local FRigVMFunction_MathRBFInterpolateQuatColor = {}



---@class FRigVMFunction_MathRBFInterpolateQuatFloat : FRigVMFunction_MathRBFInterpolateQuatBase
---@field Targets TArray<FMathRBFInterpolateQuatFloat_Target>
---@field Output float
local FRigVMFunction_MathRBFInterpolateQuatFloat = {}



---@class FRigVMFunction_MathRBFInterpolateQuatQuat : FRigVMFunction_MathRBFInterpolateQuatBase
---@field Targets TArray<FMathRBFInterpolateQuatQuat_Target>
---@field Output FQuat
local FRigVMFunction_MathRBFInterpolateQuatQuat = {}



---@class FRigVMFunction_MathRBFInterpolateQuatVector : FRigVMFunction_MathRBFInterpolateQuatBase
---@field Targets TArray<FMathRBFInterpolateQuatVector_Target>
---@field Output FVector
local FRigVMFunction_MathRBFInterpolateQuatVector = {}



---@class FRigVMFunction_MathRBFInterpolateQuatWorkData
local FRigVMFunction_MathRBFInterpolateQuatWorkData = {}


---@class FRigVMFunction_MathRBFInterpolateQuatXform : FRigVMFunction_MathRBFInterpolateQuatBase
---@field Targets TArray<FMathRBFInterpolateQuatXform_Target>
---@field Output FTransform
local FRigVMFunction_MathRBFInterpolateQuatXform = {}



---@class FRigVMFunction_MathRBFInterpolateVectorBase : FRigVMFunction_MathRBFInterpolateBase
---@field Input FVector
---@field DistanceFunction ERBFVectorDistanceType
---@field SmoothingFunction ERBFKernelType
---@field SmoothingRadius float
---@field bNormalizeOutput boolean
---@field WorkData FRigVMFunction_MathRBFInterpolateVectorWorkData
local FRigVMFunction_MathRBFInterpolateVectorBase = {}



---@class FRigVMFunction_MathRBFInterpolateVectorColor : FRigVMFunction_MathRBFInterpolateVectorBase
---@field Targets TArray<FMathRBFInterpolateVectorColor_Target>
---@field Output FLinearColor
local FRigVMFunction_MathRBFInterpolateVectorColor = {}



---@class FRigVMFunction_MathRBFInterpolateVectorFloat : FRigVMFunction_MathRBFInterpolateVectorBase
---@field Targets TArray<FMathRBFInterpolateVectorFloat_Target>
---@field Output float
local FRigVMFunction_MathRBFInterpolateVectorFloat = {}



---@class FRigVMFunction_MathRBFInterpolateVectorQuat : FRigVMFunction_MathRBFInterpolateVectorBase
---@field Targets TArray<FMathRBFInterpolateVectorQuat_Target>
---@field Output FQuat
local FRigVMFunction_MathRBFInterpolateVectorQuat = {}



---@class FRigVMFunction_MathRBFInterpolateVectorVector : FRigVMFunction_MathRBFInterpolateVectorBase
---@field Targets TArray<FMathRBFInterpolateVectorVector_Target>
---@field Output FVector
local FRigVMFunction_MathRBFInterpolateVectorVector = {}



---@class FRigVMFunction_MathRBFInterpolateVectorWorkData
local FRigVMFunction_MathRBFInterpolateVectorWorkData = {}


---@class FRigVMFunction_MathRBFInterpolateVectorXform : FRigVMFunction_MathRBFInterpolateVectorBase
---@field Targets TArray<FMathRBFInterpolateVectorXform_Target>
---@field Output FTransform
local FRigVMFunction_MathRBFInterpolateVectorXform = {}



---@class FRigVMFunction_MathRayBase : FRigVMFunction_MathBase
local FRigVMFunction_MathRayBase = {}


---@class FRigVMFunction_MathRayGetAt : FRigVMFunction_MathRayBase
---@field Ray FRay
---@field Ratio float
---@field Result FVector
local FRigVMFunction_MathRayGetAt = {}



---@class FRigVMFunction_MathRayIntersectPlane : FRigVMFunction_MathRayBase
---@field Ray FRay
---@field PlanePoint FVector
---@field PlaneNormal FVector
---@field Result FVector
---@field Distance float
---@field Ratio float
local FRigVMFunction_MathRayIntersectPlane = {}



---@class FRigVMFunction_MathRayIntersectRay : FRigVMFunction_MathRayBase
---@field A FRay
---@field B FRay
---@field Result FVector
---@field Distance float
---@field RatioA float
---@field RatioB float
local FRigVMFunction_MathRayIntersectRay = {}



---@class FRigVMFunction_MathRayTransform : FRigVMFunction_MathRayBase
---@field Ray FRay
---@field Transform FTransform
---@field Result FRay
local FRigVMFunction_MathRayTransform = {}



---@class FRigVMFunction_MathTransformAccumulateArray : FRigVMFunction_MathTransformMutableBase
---@field Transforms TArray<FTransform>
---@field TargetSpace ERigVMTransformSpace
---@field Root FTransform
---@field ParentIndices TArray<int32>
local FRigVMFunction_MathTransformAccumulateArray = {}



---@class FRigVMFunction_MathTransformArrayToSRT : FRigVMFunction_MathTransformBase
---@field Transforms TArray<FTransform>
---@field Translations TArray<FVector>
---@field Rotations TArray<FQuat>
---@field Scales TArray<FVector>
local FRigVMFunction_MathTransformArrayToSRT = {}



---@class FRigVMFunction_MathTransformBase : FRigVMFunction_MathBase
local FRigVMFunction_MathTransformBase = {}


---@class FRigVMFunction_MathTransformBinaryAggregateOp : FRigVMFunction_MathTransformBase
---@field A FTransform
---@field B FTransform
---@field Result FTransform
local FRigVMFunction_MathTransformBinaryAggregateOp = {}



---@class FRigVMFunction_MathTransformBinaryOp : FRigVMFunction_MathTransformBase
---@field A FTransform
---@field B FTransform
---@field Result FTransform
local FRigVMFunction_MathTransformBinaryOp = {}



---@class FRigVMFunction_MathTransformClampSpatially : FRigVMFunction_MathTransformBase
---@field Value FTransform
---@field Axis EAxis::Type
---@field Type ERigVMClampSpatialMode::Type
---@field Minimum float
---@field Maximum float
---@field Space FTransform
---@field bDrawDebug boolean
---@field DebugColor FLinearColor
---@field DebugThickness float
---@field Result FTransform
local FRigVMFunction_MathTransformClampSpatially = {}



---@class FRigVMFunction_MathTransformFromEulerTransform : FRigVMFunction_MathTransformBase
---@field EulerTransform FEulerTransform
---@field Result FTransform
local FRigVMFunction_MathTransformFromEulerTransform = {}



---@class FRigVMFunction_MathTransformFromEulerTransformV2 : FRigVMFunction_MathTransformBase
---@field Value FEulerTransform
---@field Result FTransform
local FRigVMFunction_MathTransformFromEulerTransformV2 = {}



---@class FRigVMFunction_MathTransformFromSRT : FRigVMFunction_MathTransformBase
---@field Location FVector
---@field Rotation FVector
---@field RotationOrder EEulerRotationOrder
---@field Scale FVector
---@field Transform FTransform
---@field EulerTransform FEulerTransform
local FRigVMFunction_MathTransformFromSRT = {}



---@class FRigVMFunction_MathTransformInverse : FRigVMFunction_MathTransformUnaryOp
local FRigVMFunction_MathTransformInverse = {}


---@class FRigVMFunction_MathTransformLerp : FRigVMFunction_MathTransformBase
---@field A FTransform
---@field B FTransform
---@field T float
---@field Result FTransform
local FRigVMFunction_MathTransformLerp = {}



---@class FRigVMFunction_MathTransformMake : FRigVMFunction_MathTransformBase
---@field Translation FVector
---@field Rotation FQuat
---@field Scale FVector
---@field Result FTransform
local FRigVMFunction_MathTransformMake = {}



---@class FRigVMFunction_MathTransformMakeAbsolute : FRigVMFunction_MathTransformBase
---@field Local FTransform
---@field Parent FTransform
---@field Global FTransform
local FRigVMFunction_MathTransformMakeAbsolute = {}



---@class FRigVMFunction_MathTransformMakeRelative : FRigVMFunction_MathTransformBase
---@field Global FTransform
---@field Parent FTransform
---@field Local FTransform
local FRigVMFunction_MathTransformMakeRelative = {}



---@class FRigVMFunction_MathTransformMirrorTransform : FRigVMFunction_MathTransformBase
---@field Value FTransform
---@field MirrorAxis EAxis::Type
---@field AxisToFlip EAxis::Type
---@field CentralTransform FTransform
---@field Result FTransform
local FRigVMFunction_MathTransformMirrorTransform = {}



---@class FRigVMFunction_MathTransformMul : FRigVMFunction_MathTransformBinaryAggregateOp
local FRigVMFunction_MathTransformMul = {}


---@class FRigVMFunction_MathTransformMutableBase : FRigVMFunction_MathMutableBase
local FRigVMFunction_MathTransformMutableBase = {}


---@class FRigVMFunction_MathTransformRotateVector : FRigVMFunction_MathTransformBase
---@field Transform FTransform
---@field Vector FVector
---@field Result FVector
local FRigVMFunction_MathTransformRotateVector = {}



---@class FRigVMFunction_MathTransformSelectBool : FRigVMFunction_MathTransformBase
---@field Condition boolean
---@field IfTrue FTransform
---@field IfFalse FTransform
---@field Result FTransform
local FRigVMFunction_MathTransformSelectBool = {}



---@class FRigVMFunction_MathTransformToEulerTransform : FRigVMFunction_MathTransformBase
---@field Value FTransform
---@field Result FEulerTransform
local FRigVMFunction_MathTransformToEulerTransform = {}



---@class FRigVMFunction_MathTransformToVectors : FRigVMFunction_MathTransformBase
---@field Value FTransform
---@field Forward FVector
---@field Right FVector
---@field Up FVector
local FRigVMFunction_MathTransformToVectors = {}



---@class FRigVMFunction_MathTransformTransformVector : FRigVMFunction_MathTransformBase
---@field Transform FTransform
---@field Location FVector
---@field Result FVector
local FRigVMFunction_MathTransformTransformVector = {}



---@class FRigVMFunction_MathTransformUnaryOp : FRigVMFunction_MathTransformBase
---@field Value FTransform
---@field Result FTransform
local FRigVMFunction_MathTransformUnaryOp = {}



---@class FRigVMFunction_MathVectorAbs : FRigVMFunction_MathVectorUnaryOp
local FRigVMFunction_MathVectorAbs = {}


---@class FRigVMFunction_MathVectorAdd : FRigVMFunction_MathVectorBinaryAggregateOp
local FRigVMFunction_MathVectorAdd = {}


---@class FRigVMFunction_MathVectorAngle : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field Result float
local FRigVMFunction_MathVectorAngle = {}



---@class FRigVMFunction_MathVectorArrayAverage : FRigVMFunction_MathVectorBase
---@field Array TArray<FVector>
---@field Average FVector
local FRigVMFunction_MathVectorArrayAverage = {}



---@class FRigVMFunction_MathVectorArraySum : FRigVMFunction_MathVectorBase
---@field Array TArray<FVector>
---@field Sum FVector
local FRigVMFunction_MathVectorArraySum = {}



---@class FRigVMFunction_MathVectorBase : FRigVMFunction_MathBase
local FRigVMFunction_MathVectorBase = {}


---@class FRigVMFunction_MathVectorBezierFourPoint : FRigVMFunction_MathVectorBase
---@field Bezier FRigVMFourPointBezier
---@field T float
---@field Result FVector
---@field Tangent FVector
local FRigVMFunction_MathVectorBezierFourPoint = {}



---@class FRigVMFunction_MathVectorBinaryAggregateOp : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field Result FVector
local FRigVMFunction_MathVectorBinaryAggregateOp = {}



---@class FRigVMFunction_MathVectorBinaryOp : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field Result FVector
local FRigVMFunction_MathVectorBinaryOp = {}



---@class FRigVMFunction_MathVectorCeil : FRigVMFunction_MathVectorUnaryOp
local FRigVMFunction_MathVectorCeil = {}


---@class FRigVMFunction_MathVectorClamp : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field Minimum FVector
---@field Maximum FVector
---@field Result FVector
local FRigVMFunction_MathVectorClamp = {}



---@class FRigVMFunction_MathVectorClampLength : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field MinimumLength float
---@field MaximumLength float
---@field Result FVector
local FRigVMFunction_MathVectorClampLength = {}



---@class FRigVMFunction_MathVectorClampSpatially : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field Axis EAxis::Type
---@field Type ERigVMClampSpatialMode::Type
---@field Minimum float
---@field Maximum float
---@field Space FTransform
---@field bDrawDebug boolean
---@field DebugColor FLinearColor
---@field DebugThickness float
---@field Result FVector
local FRigVMFunction_MathVectorClampSpatially = {}



---@class FRigVMFunction_MathVectorCross : FRigVMFunction_MathVectorBinaryOp
local FRigVMFunction_MathVectorCross = {}


---@class FRigVMFunction_MathVectorDeg : FRigVMFunction_MathVectorUnaryOp
local FRigVMFunction_MathVectorDeg = {}


---@class FRigVMFunction_MathVectorDistance : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field Result float
local FRigVMFunction_MathVectorDistance = {}



---@class FRigVMFunction_MathVectorDiv : FRigVMFunction_MathVectorBinaryOp
local FRigVMFunction_MathVectorDiv = {}


---@class FRigVMFunction_MathVectorDot : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field Result float
local FRigVMFunction_MathVectorDot = {}



---@class FRigVMFunction_MathVectorEquals : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field Result boolean
local FRigVMFunction_MathVectorEquals = {}



---@class FRigVMFunction_MathVectorFloor : FRigVMFunction_MathVectorUnaryOp
local FRigVMFunction_MathVectorFloor = {}


---@class FRigVMFunction_MathVectorFromDouble : FRigVMFunction_MathVectorBase
---@field Value double
---@field Result FVector
local FRigVMFunction_MathVectorFromDouble = {}



---@class FRigVMFunction_MathVectorFromFloat : FRigVMFunction_MathVectorBase
---@field Value float
---@field Result FVector
local FRigVMFunction_MathVectorFromFloat = {}



---@class FRigVMFunction_MathVectorIsNearlyEqual : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field Tolerance float
---@field Result boolean
local FRigVMFunction_MathVectorIsNearlyEqual = {}



---@class FRigVMFunction_MathVectorIsNearlyZero : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field Tolerance float
---@field Result boolean
local FRigVMFunction_MathVectorIsNearlyZero = {}



---@class FRigVMFunction_MathVectorLength : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field Result float
local FRigVMFunction_MathVectorLength = {}



---@class FRigVMFunction_MathVectorLengthSquared : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field Result float
local FRigVMFunction_MathVectorLengthSquared = {}



---@class FRigVMFunction_MathVectorLerp : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field T float
---@field Result FVector
local FRigVMFunction_MathVectorLerp = {}



---@class FRigVMFunction_MathVectorMake : FRigVMFunction_MathVectorBase
---@field X float
---@field Y float
---@field Z float
---@field Result FVector
local FRigVMFunction_MathVectorMake = {}



---@class FRigVMFunction_MathVectorMakeAbsolute : FRigVMFunction_MathVectorBase
---@field Local FVector
---@field Parent FVector
---@field Global FVector
local FRigVMFunction_MathVectorMakeAbsolute = {}



---@class FRigVMFunction_MathVectorMakeBezierFourPoint : FRigVMFunction_MathVectorBase
---@field Bezier FRigVMFourPointBezier
local FRigVMFunction_MathVectorMakeBezierFourPoint = {}



---@class FRigVMFunction_MathVectorMakeRelative : FRigVMFunction_MathVectorBase
---@field Global FVector
---@field Parent FVector
---@field Local FVector
local FRigVMFunction_MathVectorMakeRelative = {}



---@class FRigVMFunction_MathVectorMax : FRigVMFunction_MathVectorBinaryAggregateOp
local FRigVMFunction_MathVectorMax = {}


---@class FRigVMFunction_MathVectorMin : FRigVMFunction_MathVectorBinaryAggregateOp
local FRigVMFunction_MathVectorMin = {}


---@class FRigVMFunction_MathVectorMirror : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field Normal FVector
---@field Result FVector
local FRigVMFunction_MathVectorMirror = {}



---@class FRigVMFunction_MathVectorMirrorTransform : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field MirrorAxis EAxis::Type
---@field AxisToFlip EAxis::Type
---@field CentralTransform FTransform
---@field Result FVector
local FRigVMFunction_MathVectorMirrorTransform = {}



---@class FRigVMFunction_MathVectorMod : FRigVMFunction_MathVectorBinaryOp
local FRigVMFunction_MathVectorMod = {}


---@class FRigVMFunction_MathVectorMul : FRigVMFunction_MathVectorBinaryAggregateOp
local FRigVMFunction_MathVectorMul = {}


---@class FRigVMFunction_MathVectorNegate : FRigVMFunction_MathVectorUnaryOp
local FRigVMFunction_MathVectorNegate = {}


---@class FRigVMFunction_MathVectorNotEquals : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field Result boolean
local FRigVMFunction_MathVectorNotEquals = {}



---@class FRigVMFunction_MathVectorOrthogonal : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field Result boolean
local FRigVMFunction_MathVectorOrthogonal = {}



---@class FRigVMFunction_MathVectorParallel : FRigVMFunction_MathVectorBase
---@field A FVector
---@field B FVector
---@field Result boolean
local FRigVMFunction_MathVectorParallel = {}



---@class FRigVMFunction_MathVectorRad : FRigVMFunction_MathVectorUnaryOp
local FRigVMFunction_MathVectorRad = {}


---@class FRigVMFunction_MathVectorRemap : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field SourceMinimum FVector
---@field SourceMaximum FVector
---@field TargetMinimum FVector
---@field TargetMaximum FVector
---@field bClamp boolean
---@field Result FVector
local FRigVMFunction_MathVectorRemap = {}



---@class FRigVMFunction_MathVectorRound : FRigVMFunction_MathVectorUnaryOp
local FRigVMFunction_MathVectorRound = {}


---@class FRigVMFunction_MathVectorScale : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field Factor float
---@field Result FVector
local FRigVMFunction_MathVectorScale = {}



---@class FRigVMFunction_MathVectorSelectBool : FRigVMFunction_MathVectorBase
---@field Condition boolean
---@field IfTrue FVector
---@field IfFalse FVector
---@field Result FVector
local FRigVMFunction_MathVectorSelectBool = {}



---@class FRigVMFunction_MathVectorSetLength : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field Length float
---@field Result FVector
local FRigVMFunction_MathVectorSetLength = {}



---@class FRigVMFunction_MathVectorSign : FRigVMFunction_MathVectorUnaryOp
local FRigVMFunction_MathVectorSign = {}


---@class FRigVMFunction_MathVectorSub : FRigVMFunction_MathVectorBinaryOp
local FRigVMFunction_MathVectorSub = {}


---@class FRigVMFunction_MathVectorUnaryOp : FRigVMFunction_MathVectorBase
---@field Value FVector
---@field Result FVector
local FRigVMFunction_MathVectorUnaryOp = {}



---@class FRigVMFunction_MathVectorUnit : FRigVMFunction_MathVectorUnaryOp
local FRigVMFunction_MathVectorUnit = {}


---@class FRigVMFunction_NameBase : FRigVMStruct
local FRigVMFunction_NameBase = {}


---@class FRigVMFunction_NameConcat : FRigVMFunction_NameBase
---@field A FName
---@field B FName
---@field Result FName
local FRigVMFunction_NameConcat = {}



---@class FRigVMFunction_NameReplace : FRigVMFunction_NameBase
---@field Name FName
---@field Old FName
---@field New FName
---@field Result FName
local FRigVMFunction_NameReplace = {}



---@class FRigVMFunction_NameTruncate : FRigVMFunction_NameBase
---@field Name FName
---@field Count int32
---@field FromEnd boolean
---@field Remainder FName
---@field Chopped FName
local FRigVMFunction_NameTruncate = {}



---@class FRigVMFunction_NoiseDouble : FRigVMFunction_MathBase
---@field Value double
---@field Speed double
---@field Frequency double
---@field Minimum double
---@field Maximum double
---@field Result double
---@field Time double
local FRigVMFunction_NoiseDouble = {}



---@class FRigVMFunction_NoiseFloat : FRigVMFunction_MathBase
---@field Value float
---@field Speed float
---@field Frequency float
---@field Minimum float
---@field Maximum float
---@field Result float
---@field Time float
local FRigVMFunction_NoiseFloat = {}



---@class FRigVMFunction_NoiseVector : FRigVMFunction_MathBase
---@field Position FVector
---@field Speed FVector
---@field Frequency FVector
---@field Minimum float
---@field Maximum float
---@field Result FVector
---@field Time FVector
local FRigVMFunction_NoiseVector = {}



---@class FRigVMFunction_NoiseVector2 : FRigVMFunction_MathBase
---@field Value FVector
---@field Speed FVector
---@field Frequency FVector
---@field Minimum double
---@field Maximum double
---@field Result FVector
---@field Time FVector
local FRigVMFunction_NoiseVector2 = {}



---@class FRigVMFunction_RandomFloat : FRigVMFunction_MathBase
---@field Seed int32
---@field Minimum float
---@field Maximum float
---@field Duration float
---@field Result float
---@field LastResult float
---@field LastSeed int32
---@field BaseSeed int32
---@field TimeLeft float
local FRigVMFunction_RandomFloat = {}



---@class FRigVMFunction_RandomVector : FRigVMFunction_MathBase
---@field Seed int32
---@field Minimum float
---@field Maximum float
---@field Duration float
---@field Result FVector
---@field LastResult FVector
---@field LastSeed int32
---@field BaseSeed int32
---@field TimeLeft float
local FRigVMFunction_RandomVector = {}



---@class FRigVMFunction_SecondsToFrames : FRigVMFunction_AnimBase
---@field Seconds float
---@field Frames float
local FRigVMFunction_SecondsToFrames = {}



---@class FRigVMFunction_Sequence : FRigVMStruct
---@field ExecuteContext FRigVMExecuteContext
---@field A FRigVMExecuteContext
---@field B FRigVMExecuteContext
local FRigVMFunction_Sequence = {}



---@class FRigVMFunction_SimBase : FRigVMStruct
local FRigVMFunction_SimBase = {}


---@class FRigVMFunction_SimBaseMutable : FRigVMStructMutable
local FRigVMFunction_SimBaseMutable = {}


---@class FRigVMFunction_StartsWith : FRigVMFunction_NameBase
---@field Name FName
---@field Start FName
---@field Result boolean
local FRigVMFunction_StartsWith = {}



---@class FRigVMFunction_StringBase : FRigVMStruct
local FRigVMFunction_StringBase = {}


---@class FRigVMFunction_StringConcat : FRigVMFunction_StringBase
---@field A FString
---@field B FString
---@field Result FString
local FRigVMFunction_StringConcat = {}



---@class FRigVMFunction_StringContains : FRigVMFunction_StringBase
---@field Name FString
---@field Search FString
---@field Result boolean
local FRigVMFunction_StringContains = {}



---@class FRigVMFunction_StringEndsWith : FRigVMFunction_StringBase
---@field Name FString
---@field Ending FString
---@field Result boolean
local FRigVMFunction_StringEndsWith = {}



---@class FRigVMFunction_StringFind : FRigVMFunction_StringBase
---@field Value FString
---@field Search FString
---@field found boolean
---@field Index int32
local FRigVMFunction_StringFind = {}



---@class FRigVMFunction_StringJoin : FRigVMFunction_StringBase
---@field Values TArray<FString>
---@field Separator FString
---@field Result FString
local FRigVMFunction_StringJoin = {}



---@class FRigVMFunction_StringLeft : FRigVMFunction_StringBase
---@field Value FString
---@field Count int32
---@field Result FString
local FRigVMFunction_StringLeft = {}



---@class FRigVMFunction_StringLength : FRigVMFunction_StringBase
---@field Value FString
---@field Length int32
local FRigVMFunction_StringLength = {}



---@class FRigVMFunction_StringMiddle : FRigVMFunction_StringBase
---@field Value FString
---@field Start int32
---@field Count int32
---@field Result FString
local FRigVMFunction_StringMiddle = {}



---@class FRigVMFunction_StringPadInteger : FRigVMFunction_StringBase
---@field Value int32
---@field Digits int32
---@field Result FString
local FRigVMFunction_StringPadInteger = {}



---@class FRigVMFunction_StringReplace : FRigVMFunction_StringBase
---@field Name FString
---@field Old FString
---@field New FString
---@field Result FString
local FRigVMFunction_StringReplace = {}



---@class FRigVMFunction_StringReverse : FRigVMFunction_StringBase
---@field Value FString
---@field Reverse FString
local FRigVMFunction_StringReverse = {}



---@class FRigVMFunction_StringRight : FRigVMFunction_StringBase
---@field Value FString
---@field Count int32
---@field Result FString
local FRigVMFunction_StringRight = {}



---@class FRigVMFunction_StringSplit : FRigVMFunction_StringBase
---@field Value FString
---@field Separator FString
---@field Result TArray<FString>
local FRigVMFunction_StringSplit = {}



---@class FRigVMFunction_StringStartsWith : FRigVMFunction_StringBase
---@field Name FString
---@field Start FString
---@field Result boolean
local FRigVMFunction_StringStartsWith = {}



---@class FRigVMFunction_StringToLowercase : FRigVMFunction_StringBase
---@field Value FString
---@field Result FString
local FRigVMFunction_StringToLowercase = {}



---@class FRigVMFunction_StringToUppercase : FRigVMFunction_StringBase
---@field Value FString
---@field Result FString
local FRigVMFunction_StringToUppercase = {}



---@class FRigVMFunction_StringTrimWhitespace : FRigVMFunction_StringBase
---@field Value FString
---@field Result FString
local FRigVMFunction_StringTrimWhitespace = {}



---@class FRigVMFunction_StringTruncate : FRigVMFunction_StringBase
---@field Name FString
---@field Count int32
---@field FromEnd boolean
---@field Remainder FString
---@field Chopped FString
local FRigVMFunction_StringTruncate = {}



---@class FRigVMFunction_TimeLoop : FRigVMFunction_SimBase
---@field Speed float
---@field Duration float
---@field Normalize boolean
---@field Absolute float
---@field Relative float
---@field FlipFlop float
---@field Even boolean
---@field AccumulatedAbsolute float
---@field AccumulatedRelative float
---@field NumIterations int32
---@field bIsInitialized boolean
local FRigVMFunction_TimeLoop = {}



---@class FRigVMFunction_TimeOffsetFloat : FRigVMFunction_SimBase
---@field Value float
---@field SecondsAgo float
---@field BufferSize int32
---@field TimeRange float
---@field Result float
---@field Buffer TArray<float>
---@field DeltaTimes TArray<float>
---@field LastInsertIndex int32
---@field UpperBound int32
local FRigVMFunction_TimeOffsetFloat = {}



---@class FRigVMFunction_TimeOffsetTransform : FRigVMFunction_SimBase
---@field Value FTransform
---@field SecondsAgo float
---@field BufferSize int32
---@field TimeRange float
---@field Result FTransform
---@field Buffer TArray<FTransform>
---@field DeltaTimes TArray<float>
---@field LastInsertIndex int32
---@field UpperBound int32
local FRigVMFunction_TimeOffsetTransform = {}



---@class FRigVMFunction_TimeOffsetVector : FRigVMFunction_SimBase
---@field Value FVector
---@field SecondsAgo float
---@field BufferSize int32
---@field TimeRange float
---@field Result FVector
---@field Buffer TArray<FVector>
---@field DeltaTimes TArray<float>
---@field LastInsertIndex int32
---@field UpperBound int32
local FRigVMFunction_TimeOffsetVector = {}



---@class FRigVMFunction_Timeline : FRigVMFunction_SimBase
---@field Speed float
---@field Time float
---@field AccumulatedValue float
---@field bIsInitialized boolean
local FRigVMFunction_Timeline = {}



---@class FRigVMFunction_UserDefinedEvent : FRigVMStruct
---@field ExecuteContext FRigVMExecuteContext
---@field EventName FName
local FRigVMFunction_UserDefinedEvent = {}



---@class FRigVMFunction_VerletIntegrateVector : FRigVMFunction_SimBase
---@field Target FVector
---@field Strength float
---@field Damp float
---@field Blend float
---@field Force FVector
---@field Position FVector
---@field Velocity FVector
---@field Acceleration FVector
---@field Point FRigVMSimPoint
---@field bInitialized boolean
local FRigVMFunction_VerletIntegrateVector = {}



---@class FRigVMFunction_VisualDebugQuat : FRigVMFunction_DebugBase
---@field Value FQuat
---@field bEnabled boolean
---@field Thickness float
---@field Scale float
---@field BoneSpace FName
local FRigVMFunction_VisualDebugQuat = {}



---@class FRigVMFunction_VisualDebugQuatNoSpace : FRigVMFunction_DebugBase
---@field Value FQuat
---@field bEnabled boolean
---@field Thickness float
---@field Scale float
local FRigVMFunction_VisualDebugQuatNoSpace = {}



---@class FRigVMFunction_VisualDebugTransform : FRigVMFunction_DebugBase
---@field Value FTransform
---@field bEnabled boolean
---@field Thickness float
---@field Scale float
---@field BoneSpace FName
local FRigVMFunction_VisualDebugTransform = {}



---@class FRigVMFunction_VisualDebugTransformNoSpace : FRigVMFunction_DebugBase
---@field Value FTransform
---@field bEnabled boolean
---@field Thickness float
---@field Scale float
local FRigVMFunction_VisualDebugTransformNoSpace = {}



---@class FRigVMFunction_VisualDebugVector : FRigVMFunction_DebugBase
---@field Value FVector
---@field bEnabled boolean
---@field Mode ERigUnitVisualDebugPointMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
---@field BoneSpace FName
local FRigVMFunction_VisualDebugVector = {}



---@class FRigVMFunction_VisualDebugVectorNoSpace : FRigVMFunction_DebugBase
---@field Value FVector
---@field bEnabled boolean
---@field Mode ERigUnitVisualDebugPointMode
---@field Color FLinearColor
---@field Thickness float
---@field Scale float
local FRigVMFunction_VisualDebugVectorNoSpace = {}



---@class FRigVMGraphFunctionArgument
---@field Name FName
---@field DisplayName FName
---@field CPPType FName
---@field CPPTypeObject TSoftObjectPtr<UObject>
---@field bIsArray boolean
---@field Direction ERigVMPinDirection
---@field DefaultValue FString
---@field bIsConst boolean
---@field PathToTooltip TMap<FString, FText>
local FRigVMGraphFunctionArgument = {}



---@class FRigVMGraphFunctionData
---@field Header FRigVMGraphFunctionHeader
---@field CompilationData FRigVMFunctionCompilationData
---@field SerializedCollapsedNode FString
local FRigVMGraphFunctionData = {}



---@class FRigVMGraphFunctionHeader
---@field LibraryPointer FRigVMGraphFunctionIdentifier
---@field Variant FRigVMVariant
---@field Name FName
---@field NodeTitle FString
---@field NodeColor FLinearColor
---@field ToolTip FText
---@field Description FString
---@field Category FString
---@field Keywords FString
---@field Arguments TArray<FRigVMGraphFunctionArgument>
---@field Dependencies TMap<FRigVMGraphFunctionIdentifier, uint32>
---@field ExternalVariables TArray<FRigVMExternalVariable>
---@field Layout FRigVMNodeLayout
local FRigVMGraphFunctionHeader = {}



---@class FRigVMGraphFunctionHeaderArray
---@field Headers TArray<FRigVMGraphFunctionHeader>
local FRigVMGraphFunctionHeaderArray = {}



---@class FRigVMGraphFunctionIdentifier
---@field LibraryNode FSoftObjectPath
---@field LibraryNodePath FString
---@field HostObject FSoftObjectPath
local FRigVMGraphFunctionIdentifier = {}



---@class FRigVMGraphFunctionStore
---@field PublicFunctions TArray<FRigVMGraphFunctionData>
---@field PrivateFunctions TArray<FRigVMGraphFunctionData>
local FRigVMGraphFunctionStore = {}



---@class FRigVMInstruction
---@field ByteCodeIndex uint64
---@field OpCode ERigVMOpCode
---@field OperandAlignment uint8
local FRigVMInstruction = {}



---@class FRigVMInstructionArray
---@field Instructions TArray<FRigVMInstruction>
local FRigVMInstructionArray = {}



---@class FRigVMInstructionSetExecuteState
---@field SliceHashToNumInstruction TMap<uint32, uint32>
local FRigVMInstructionSetExecuteState = {}



---@class FRigVMInstructionVisitInfo
local FRigVMInstructionVisitInfo = {}


---@class FRigVMInvokeEntryOp : FRigVMBaseOp
local FRigVMInvokeEntryOp = {}


---@class FRigVMJumpIfOp : FRigVMUnaryOp
local FRigVMJumpIfOp = {}


---@class FRigVMJumpOp : FRigVMBaseOp
local FRigVMJumpOp = {}


---@class FRigVMJumpToBranchOp : FRigVMUnaryOp
local FRigVMJumpToBranchOp = {}


---@class FRigVMMemoryContainer
---@field bUseNameMap boolean
---@field MemoryType ERigVMMemoryType
---@field Registers TArray<FRigVMRegister>
---@field RegisterOffsets TArray<FRigVMRegisterOffset>
---@field Data TArray<uint8>
---@field ScriptStructs TArray<UScriptStruct>
---@field NameMap TMap<FName, int32>
---@field bEncounteredErrorDuringLoad boolean
local FRigVMMemoryContainer = {}



---@class FRigVMMemoryStatistics
---@field RegisterCount int32
---@field DataBytes int32
---@field TotalBytes int32
local FRigVMMemoryStatistics = {}



---@class FRigVMMemoryStorageStruct : FInstancedPropertyBag
local FRigVMMemoryStorageStruct = {}


---@class FRigVMMirrorSettings
---@field MirrorAxis EAxis::Type
---@field AxisToFlip EAxis::Type
---@field SearchString FString
---@field ReplaceString FString
local FRigVMMirrorSettings = {}



---@class FRigVMNodeLayout
---@field Categories TArray<FRigVMPinCategory>
---@field PinIndexInCategory TMap<FString, int32>
---@field DisplayNames TMap<FString, FString>
local FRigVMNodeLayout = {}



---@class FRigVMOperand
---@field MemoryType ERigVMMemoryType
---@field RegisterIndex uint16
---@field RegisterOffset uint16
local FRigVMOperand = {}



---@class FRigVMParameter
---@field Type ERigVMParameterType
---@field Name FName
---@field RegisterIndex int32
---@field CPPType FString
---@field ScriptStruct UScriptStruct
---@field ScriptStructPath FName
local FRigVMParameter = {}



---@class FRigVMPinCategory
---@field Path FString
---@field Elements TArray<FString>
---@field bExpandedByDefault boolean
local FRigVMPinCategory = {}



---@class FRigVMPredicateBranch
local FRigVMPredicateBranch = {}


---@class FRigVMProfilingInfo
local FRigVMProfilingInfo = {}


---@class FRigVMQuaternaryOp : FRigVMBaseOp
local FRigVMQuaternaryOp = {}


---@class FRigVMQuinaryOp : FRigVMBaseOp
local FRigVMQuinaryOp = {}


---@class FRigVMRegister
---@field Type ERigVMRegisterType
---@field ByteIndex uint32
---@field ElementSize uint16
---@field ElementCount uint16
---@field SliceCount uint16
---@field AlignmentBytes uint8
---@field TrailingBytes uint16
---@field Name FName
---@field ScriptStructIndex int32
---@field bIsArray boolean
---@field bIsDynamic boolean
local FRigVMRegister = {}



---@class FRigVMRegisterOffset
---@field Segments TArray<int32>
---@field Type ERigVMRegisterType
---@field CPPType FName
---@field ScriptStruct UScriptStruct
---@field ParentScriptStruct UScriptStruct
---@field ArrayIndex int32
---@field ElementSize uint16
---@field CachedSegmentPath FString
local FRigVMRegisterOffset = {}



---@class FRigVMRunInstructionsOp : FRigVMUnaryOp
local FRigVMRunInstructionsOp = {}


---@class FRigVMRuntimeSettings
---@field MaximumArraySize int32
local FRigVMRuntimeSettings = {}



---@class FRigVMSenaryOp : FRigVMBaseOp
local FRigVMSenaryOp = {}


---@class FRigVMSetupTraitsOp : FRigVMUnaryOp
local FRigVMSetupTraitsOp = {}


---@class FRigVMSimPoint
---@field Mass float
---@field Size float
---@field LinearDamping float
---@field InheritMotion float
---@field Position FVector
---@field LinearVelocity FVector
local FRigVMSimPoint = {}



---@class FRigVMSlice
local FRigVMSlice = {}


---@class FRigVMStatistics
---@field BytesForCDO int32
---@field BytesPerInstance int32
---@field LiteralMemory FRigVMMemoryStatistics
---@field WorkMemory FRigVMMemoryStatistics
---@field DebugMemory FRigVMMemoryStatistics
---@field BytesForCaching int32
---@field ByteCode FRigVMByteCodeStatistics
local FRigVMStatistics = {}



---@class FRigVMStruct
local FRigVMStruct = {}


---@class FRigVMStructMutable : FRigVMStruct
---@field ExecuteContext FRigVMExecuteContext
local FRigVMStructMutable = {}



---@class FRigVMTag
---@field Name FName
---@field Label FString
---@field ToolTip FText
---@field Color FLinearColor
---@field bShowInUserInterface boolean
---@field bMarksSubjectAsInvalid boolean
local FRigVMTag = {}



---@class FRigVMTemplateArgumentType
---@field CPPType FName
---@field CPPTypeObject UObject
local FRigVMTemplateArgumentType = {}



---@class FRigVMTernaryOp : FRigVMBaseOp
local FRigVMTernaryOp = {}


---@class FRigVMTrait : FRigVMStruct
---@field Name FString
local FRigVMTrait = {}



---@class FRigVMUnaryOp : FRigVMBaseOp
local FRigVMUnaryOp = {}


---@class FRigVMUnknownType
---@field Hash uint32
local FRigVMUnknownType = {}



---@class FRigVMUserWorkflow
---@field Title FString
---@field ToolTip FString
---@field Type ERigVMUserWorkflowType
---@field PerformDynamicDelegate FRigVMUserWorkflowPerformDynamicDelegate
---@field OptionsClass UClass
local FRigVMUserWorkflow = {}



---@class FRigVMVariant
---@field Guid FGuid
---@field Tags TArray<FRigVMTag>
local FRigVMVariant = {}



---@class FRigVMVariantRef
---@field ObjectPath FSoftObjectPath
---@field Variant FRigVMVariant
local FRigVMVariantRef = {}



---@class IRigVMGraphFunctionHost : IInterface
local IRigVMGraphFunctionHost = {}


---@class UDataAssetLink : UNameSpacedUserData
---@field DataAsset TSoftObjectPtr<UDataAsset>
---@field DataAssetCached UDataAsset
local UDataAssetLink = {}

---@param InDataAsset TSoftObjectPtr<UDataAsset>
function UDataAssetLink:SetDataAsset(InDataAsset) end
---@return TSoftObjectPtr<UDataAsset>
function UDataAssetLink:GetDataAsset() end


---@class UDefault__RigVMBlueprintGeneratedClass
local UDefault__RigVMBlueprintGeneratedClass = {}


---@class UDefault__RigVMMemoryStorageGeneratorClass
local UDefault__RigVMMemoryStorageGeneratorClass = {}


---@class UNameSpacedUserData : UAssetUserData
---@field NameSpace FString
local UNameSpacedUserData = {}



---@class URigVM : UObject
---@field LiteralMemoryStorage FRigVMMemoryStorageStruct
---@field DefaultWorkMemoryStorage FRigVMMemoryStorageStruct
---@field DefaultDebugMemoryStorage FRigVMMemoryStorageStruct
---@field ByteCodeStorage FRigVMByteCode
---@field Instructions FRigVMInstructionArray
---@field FunctionNamesStorage TArray<FName>
---@field Parameters TArray<FRigVMParameter>
---@field CachedVMHash uint32
local URigVM = {}

---@param InParameterName FName
---@param InValue FVector2D
---@param InArrayIndex int32
function URigVM:SetParameterValueVector2D(InParameterName, InValue, InArrayIndex) end
---@param InParameterName FName
---@param InValue FVector
---@param InArrayIndex int32
function URigVM:SetParameterValueVector(InParameterName, InValue, InArrayIndex) end
---@param InParameterName FName
---@param InValue FTransform
---@param InArrayIndex int32
function URigVM:SetParameterValueTransform(InParameterName, InValue, InArrayIndex) end
---@param InParameterName FName
---@param InValue FString
---@param InArrayIndex int32
function URigVM:SetParameterValueString(InParameterName, InValue, InArrayIndex) end
---@param InParameterName FName
---@param InValue FQuat
---@param InArrayIndex int32
function URigVM:SetParameterValueQuat(InParameterName, InValue, InArrayIndex) end
---@param InParameterName FName
---@param InValue FName
---@param InArrayIndex int32
function URigVM:SetParameterValueName(InParameterName, InValue, InArrayIndex) end
---@param InParameterName FName
---@param InValue int32
---@param InArrayIndex int32
function URigVM:SetParameterValueInt(InParameterName, InValue, InArrayIndex) end
---@param InParameterName FName
---@param InValue float
---@param InArrayIndex int32
function URigVM:SetParameterValueFloat(InParameterName, InValue, InArrayIndex) end
---@param InParameterName FName
---@param InValue double
---@param InArrayIndex int32
function URigVM:SetParameterValueDouble(InParameterName, InValue, InArrayIndex) end
---@param InParameterName FName
---@param InValue boolean
---@param InArrayIndex int32
function URigVM:SetParameterValueBool(InParameterName, InValue, InArrayIndex) end
---@return FRigVMStatistics
function URigVM:GetStatistics() end
---@param InFunctionIndex int32
---@return FString
function URigVM:GetRigVMFunctionName(InFunctionIndex) end
---@param InParameterName FName
---@param InArrayIndex int32
---@return FVector2D
function URigVM:GetParameterValueVector2D(InParameterName, InArrayIndex) end
---@param InParameterName FName
---@param InArrayIndex int32
---@return FVector
function URigVM:GetParameterValueVector(InParameterName, InArrayIndex) end
---@param InParameterName FName
---@param InArrayIndex int32
---@return FTransform
function URigVM:GetParameterValueTransform(InParameterName, InArrayIndex) end
---@param InParameterName FName
---@param InArrayIndex int32
---@return FString
function URigVM:GetParameterValueString(InParameterName, InArrayIndex) end
---@param InParameterName FName
---@param InArrayIndex int32
---@return FQuat
function URigVM:GetParameterValueQuat(InParameterName, InArrayIndex) end
---@param InParameterName FName
---@param InArrayIndex int32
---@return FName
function URigVM:GetParameterValueName(InParameterName, InArrayIndex) end
---@param InParameterName FName
---@param InArrayIndex int32
---@return int32
function URigVM:GetParameterValueInt(InParameterName, InArrayIndex) end
---@param InParameterName FName
---@param InArrayIndex int32
---@return float
function URigVM:GetParameterValueFloat(InParameterName, InArrayIndex) end
---@param InParameterName FName
---@param InArrayIndex int32
---@return double
function URigVM:GetParameterValueDouble(InParameterName, InArrayIndex) end
---@param InParameterName FName
---@param InArrayIndex int32
---@return boolean
function URigVM:GetParameterValueBool(InParameterName, InArrayIndex) end
---@param Context FRigVMExtendedExecuteContext
---@param InEntryName FName
---@return boolean
function URigVM:Execute(Context, InEntryName) end
---@param InRigVMStruct UScriptStruct
---@param InMethodName FName
---@return int32
function URigVM:AddRigVMFunction(InRigVMStruct, InMethodName) end


---@class URigVMBlueprintGeneratedClass : UBlueprintGeneratedClass
---@field GraphFunctionStore FRigVMGraphFunctionStore
local URigVMBlueprintGeneratedClass = {}



---@class URigVMEditorSettings : UDeveloperSettings
local URigVMEditorSettings = {}


---@class URigVMHost : UObject
---@field VMRuntimeSettings FRigVMRuntimeSettings
---@field VM URigVM
---@field UserDefinedStructGuidToPathName TMap<FString, FSoftObjectPath>
---@field UserDefinedEnumToPathName TMap<FString, FSoftObjectPath>
---@field UserDefinedTypesInUse TSet<UObject>
---@field DrawContainer FRigVMDrawContainer
---@field EventQueue TArray<FName>
---@field AssetUserData TArray<UAssetUserData>
local URigVMHost = {}

---@param InEventName FName
---@return boolean
function URigVMHost:SupportsEvent(InEventName) end
---@param InVariableName FName
---@param InValue FString
---@return boolean
function URigVMHost:SetVariableFromString(InVariableName, InValue) end
---@param InFramesPerSecond float
function URigVMHost:SetFramesPerSecond(InFramesPerSecond) end
---@param InDeltaTime float
function URigVMHost:SetDeltaTime(InDeltaTime) end
---@param InAbsoluteTime float
---@param InSetDeltaTimeZero boolean
function URigVMHost:SetAbsoluteTime(InAbsoluteTime, InSetDeltaTimeZero) end
---@param InAbsoluteTime float
---@param InDeltaTime float
function URigVMHost:SetAbsoluteAndDeltaTime(InAbsoluteTime, InDeltaTime) end
---@param InEventName FName
---@param InEventIndex int32
function URigVMHost:RequestRunOnceEvent(InEventName, InEventIndex) end
function URigVMHost:RequestInit() end
---@param InEventName FName
---@return boolean
function URigVMHost:RemoveRunOnceEvent(InEventName) end
---@return boolean
function URigVMHost:IsInitRequired() end
---@return URigVM
function URigVMHost:GetVM() end
---@param InVariableName FName
---@return FName
function URigVMHost:GetVariableType(InVariableName) end
---@param InVariableName FName
---@return FString
function URigVMHost:GetVariableAsString(InVariableName) end
---@return TArray<FName>
function URigVMHost:GetSupportedEvents() end
---@return TArray<FName>
function URigVMHost:GetScriptAccessibleVariables() end
---@return FRigVMExtendedExecuteContext
function URigVMHost:GetExtendedExecuteContext() end
---@return float
function URigVMHost:GetDeltaTime() end
---@return float
function URigVMHost:GetCurrentFramesPerSecond() end
---@return float
function URigVMHost:GetAbsoluteTime() end
---@param Outer UObject
---@param OptionalClass TSubclassOf<URigVMHost>
---@return TArray<URigVMHost>
function URigVMHost:FindRigVMHosts(Outer, OptionalClass) end
---@param InEventName FName
---@return boolean
function URigVMHost:ExecuteEvent(InEventName) end
---@param InEventName FName
---@return boolean
function URigVMHost:Execute(InEventName) end
---@return boolean
function URigVMHost:CanExecute() end


---@class URigVMMemoryStorage : UObject
local URigVMMemoryStorage = {}


---@class URigVMMemoryStorageGeneratorClass : UClass
local URigVMMemoryStorageGeneratorClass = {}


---@class URigVMNativized : URigVM
local URigVMNativized = {}


---@class URigVMProjectSettings : UDeveloperSettings
---@field VariantTags TArray<FRigVMTag>
local URigVMProjectSettings = {}

---@param InTagName FName
---@return FRigVMTag
function URigVMProjectSettings:GetTag(InTagName) end


---@class URigVMUserWorkflowOptions : UObject
---@field Subject UObject
---@field Workflow FRigVMUserWorkflow
local URigVMUserWorkflowOptions = {}

---@return boolean
function URigVMUserWorkflowOptions:RequiresDialog() end
---@param InMessage FString
function URigVMUserWorkflowOptions:ReportWarning(InMessage) end
---@param InMessage FString
function URigVMUserWorkflowOptions:ReportInfo(InMessage) end
---@param InMessage FString
function URigVMUserWorkflowOptions:ReportError(InMessage) end
---@return boolean
function URigVMUserWorkflowOptions:IsValid() end


