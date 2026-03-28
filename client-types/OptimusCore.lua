---@meta

---@class FOptimusAction
local FOptimusAction = {}


---@class FOptimusAnimAttributeArray
---@field InnerArray TArray<FOptimusAnimAttributeDescription>
local FOptimusAnimAttributeArray = {}



---@class FOptimusAnimAttributeBufferArray
---@field InnerArray TArray<FOptimusAnimAttributeBufferDescription>
local FOptimusAnimAttributeBufferArray = {}



---@class FOptimusAnimAttributeBufferDescription
---@field Name FString
---@field DataType FOptimusDataTypeRef
---@field DefaultValueStruct FOptimusValueContainerStruct
---@field HlslId FString
---@field PinName FName
local FOptimusAnimAttributeBufferDescription = {}



---@class FOptimusAnimAttributeDescription
---@field Name FString
---@field BoneName FName
---@field DataType FOptimusDataTypeRef
---@field DefaultValueStruct FOptimusValueContainerStruct
---@field HlslId FString
---@field PinName FName
---@field DefaultValue UOptimusValueContainer
local FOptimusAnimAttributeDescription = {}



---@class FOptimusComponentBindingAction_AddBinding : FOptimusAction
local FOptimusComponentBindingAction_AddBinding = {}


---@class FOptimusComponentBindingAction_RemoveBinding : FOptimusAction
local FOptimusComponentBindingAction_RemoveBinding = {}


---@class FOptimusComponentBindingAction_RenameBinding : FOptimusAction
local FOptimusComponentBindingAction_RenameBinding = {}


---@class FOptimusComponentBindingAction_SetComponentSource : FOptimusAction
local FOptimusComponentBindingAction_SetComponentSource = {}


---@class FOptimusCompoundAction : FOptimusAction
local FOptimusCompoundAction = {}


---@class FOptimusComputeGraphInfo
---@field GraphType EOptimusNodeGraphType
---@field GraphName FName
---@field ComputeGraph UOptimusComputeGraph
local FOptimusComputeGraphInfo = {}



---@class FOptimusConstant
---@field Identifier FOptimusConstantIdentifier
---@field Definition FOptimusConstantDefinition
---@field ComponentBindingIndex int32
---@field Type EOptimusConstantType
local FOptimusConstant = {}



---@class FOptimusConstantContainer
---@field KernelContainers TArray<FOptimusKernelConstantContainer>
local FOptimusConstantContainer = {}



---@class FOptimusConstantDefinition
---@field ReferencedConstant FOptimusConstantIdentifier
---@field Expression FString
local FOptimusConstantDefinition = {}



---@class FOptimusConstantIdentifier
---@field NodePath FName
---@field GroupName FName
---@field ConstantName FName
local FOptimusConstantIdentifier = {}



---@class FOptimusConstantIndex
---@field KernelIndex int32
---@field Type EOptimusConstantType
---@field ConstantIndex int32
local FOptimusConstantIndex = {}



---@class FOptimusDataDomain
---@field Type EOptimusDataDomainType
---@field DimensionNames TArray<FName>
---@field Multiplier int32
---@field Expression FString
---@field LevelNames TArray<FName>
local FOptimusDataDomain = {}



---@class FOptimusDataInterfacePropertyOverrideInfo
---@field PinNameToValueIdMap TMap<FName, FOptimusValueIdentifier>
local FOptimusDataInterfacePropertyOverrideInfo = {}



---@class FOptimusDataType
---@field TypeName FName
---@field DisplayName FText
---@field ShaderValueType FShaderValueTypeHandle
---@field ShaderValueSize int32
---@field TypeCategory FName
---@field TypeObject TWeakObjectPtr<UObject>
---@field bHasCustomPinColor boolean
---@field CustomPinColor FLinearColor
---@field UsageFlags EOptimusDataTypeUsageFlags
---@field TypeFlags EOptimusDataTypeFlags
local FOptimusDataType = {}



---@class FOptimusDataTypeRef
---@field TypeName FName
---@field TypeObject TSoftObjectPtr<UObject>
local FOptimusDataTypeRef = {}



---@class FOptimusDebugDrawParameters
---@field bForceEnable boolean
---@field MaxLineCount int32
---@field MaxTriangleCount int32
---@field MaxCharacterCount int32
---@field FontSize int32
local FOptimusDebugDrawParameters = {}



---@class FOptimusDeformerInstanceComponentBinding
---@field ProviderName FName
---@field ComponentName FName
local FOptimusDeformerInstanceComponentBinding = {}



---@class FOptimusDeformerInstanceExecInfo
---@field GraphName FName
---@field GraphType EOptimusNodeGraphType
---@field ComputeGraph UComputeGraph
---@field ComputeGraphInstance FComputeGraphInstance
local FOptimusDeformerInstanceExecInfo = {}



---@class FOptimusExecutionDomain
---@field Type EOptimusExecutionDomainType
---@field Name FName
---@field Expression FString
local FOptimusExecutionDomain = {}



---@class FOptimusFunctionNodeGraphHeader
---@field GraphPath TSoftObjectPtr<UOptimusFunctionNodeGraph>
---@field FunctionName FName
---@field Category FName
local FOptimusFunctionNodeGraphHeader = {}



---@class FOptimusFunctionNodeGraphHeaderArray
---@field Headers TArray<FOptimusFunctionNodeGraphHeader>
local FOptimusFunctionNodeGraphHeaderArray = {}



---@class FOptimusFunctionReferenceData
---@field FunctionReferences TMap<FSoftObjectPath, FOptimusFunctionReferenceNodeSet>
local FOptimusFunctionReferenceData = {}



---@class FOptimusFunctionReferenceNodeSet
---@field Nodes TSet<TSoftObjectPtr<UOptimusNode_FunctionReference>>
local FOptimusFunctionReferenceNodeSet = {}



---@class FOptimusGraphVariableDescription
---@field Name FString
---@field ValueType FShaderValueTypeHandle
---@field ValueId FOptimusValueIdentifier
---@field Offset int32
---@field Value TArray<uint8>
---@field ShaderValue FShaderValueContainer
---@field SourceObject TSoftObjectPtr<UObject>
local FOptimusGraphVariableDescription = {}



---@class FOptimusKernelConstantContainer
---@field InputConstants TArray<FOptimusConstant>
---@field OutputConstants TArray<FOptimusConstant>
---@field GroupNameToBindingIndex TMap<FName, int32>
local FOptimusKernelConstantContainer = {}



---@class FOptimusLoopTerminalInfo
---@field Count int32
---@field Bindings FOptimusParameterBindingArray
local FOptimusLoopTerminalInfo = {}



---@class FOptimusNodeAction_AddGroupingPin : FOptimusNodeAction_AddRemovePin
local FOptimusNodeAction_AddGroupingPin = {}


---@class FOptimusNodeAction_AddPin : FOptimusNodeAction_AddRemovePin
local FOptimusNodeAction_AddPin = {}


---@class FOptimusNodeAction_AddRemovePin : FOptimusAction
local FOptimusNodeAction_AddRemovePin = {}


---@class FOptimusNodeAction_MoveNode : FOptimusAction
local FOptimusNodeAction_MoveNode = {}


---@class FOptimusNodeAction_MovePin : FOptimusAction
local FOptimusNodeAction_MovePin = {}


---@class FOptimusNodeAction_RemovePin : FOptimusNodeAction_AddRemovePin
local FOptimusNodeAction_RemovePin = {}


---@class FOptimusNodeAction_RenameNode : FOptimusAction
local FOptimusNodeAction_RenameNode = {}


---@class FOptimusNodeAction_SetPinDataDomain : FOptimusAction
local FOptimusNodeAction_SetPinDataDomain = {}


---@class FOptimusNodeAction_SetPinName : FOptimusAction
local FOptimusNodeAction_SetPinName = {}


---@class FOptimusNodeAction_SetPinType : FOptimusAction
local FOptimusNodeAction_SetPinType = {}


---@class FOptimusNodeAction_SetPinValue : FOptimusAction
local FOptimusNodeAction_SetPinValue = {}


---@class FOptimusNodeGraphAction_AddGraph : FOptimusAction
local FOptimusNodeGraphAction_AddGraph = {}


---@class FOptimusNodeGraphAction_AddLink : FOptimusNodeGraphAction_AddRemoveLink
local FOptimusNodeGraphAction_AddLink = {}


---@class FOptimusNodeGraphAction_AddNode : FOptimusAction
local FOptimusNodeGraphAction_AddNode = {}


---@class FOptimusNodeGraphAction_AddNodePair : FOptimusNodeGraphAction_AddRemoveNodePair
local FOptimusNodeGraphAction_AddNodePair = {}


---@class FOptimusNodeGraphAction_AddRemoveLink : FOptimusAction
local FOptimusNodeGraphAction_AddRemoveLink = {}


---@class FOptimusNodeGraphAction_AddRemoveNodePair : FOptimusAction
local FOptimusNodeGraphAction_AddRemoveNodePair = {}


---@class FOptimusNodeGraphAction_ConnectAdderPin : FOptimusNodeGraphAction_AddRemoveLink
local FOptimusNodeGraphAction_ConnectAdderPin = {}


---@class FOptimusNodeGraphAction_DuplicateNode : FOptimusAction
local FOptimusNodeGraphAction_DuplicateNode = {}


---@class FOptimusNodeGraphAction_PackageKernelFunction : FOptimusAction
local FOptimusNodeGraphAction_PackageKernelFunction = {}


---@class FOptimusNodeGraphAction_RemoveGraph : FOptimusAction
local FOptimusNodeGraphAction_RemoveGraph = {}


---@class FOptimusNodeGraphAction_RemoveLink : FOptimusNodeGraphAction_AddRemoveLink
local FOptimusNodeGraphAction_RemoveLink = {}


---@class FOptimusNodeGraphAction_RemoveNode : FOptimusAction
local FOptimusNodeGraphAction_RemoveNode = {}


---@class FOptimusNodeGraphAction_RemoveNodePair : FOptimusNodeGraphAction_AddRemoveNodePair
local FOptimusNodeGraphAction_RemoveNodePair = {}


---@class FOptimusNodeGraphAction_RenameGraph : FOptimusAction
local FOptimusNodeGraphAction_RenameGraph = {}


---@class FOptimusNodeGraphAction_UnpackageKernelFunction : FOptimusAction
local FOptimusNodeGraphAction_UnpackageKernelFunction = {}


---@class FOptimusNode_ComponentSource_DuplicationInfo
---@field BindingName FName
---@field ComponentType TSubclassOf<UOptimusComponentSource>
local FOptimusNode_ComponentSource_DuplicationInfo = {}



---@class FOptimusNode_GetVariable_DuplicationInfo
---@field VariableName FName
---@field DataType FOptimusDataTypeRef
---@field DefaultValue FString
local FOptimusNode_GetVariable_DuplicationInfo = {}



---@class FOptimusNode_ResourceAccessorBase_DuplicationInfo
---@field ResourceName FName
---@field DataType FOptimusDataTypeRef
---@field DataDomain FOptimusDataDomain
local FOptimusNode_ResourceAccessorBase_DuplicationInfo = {}



---@class FOptimusParameterBinding
---@field Name FOptimusValidatedName
---@field DataType FOptimusDataTypeRef
---@field DataDomain FOptimusDataDomain
---@field bSupportAtomicIfCompatibleDataType boolean
---@field bSupportRead boolean
local FOptimusParameterBinding = {}



---@class FOptimusParameterBindingArray
---@field InnerArray TArray<FOptimusParameterBinding>
local FOptimusParameterBindingArray = {}



---@class FOptimusPinPairInfo
---@field InputPinPath TArray<FName>
---@field OutputPinPath TArray<FName>
local FOptimusPinPairInfo = {}



---@class FOptimusResourceAction_AddResource : FOptimusAction
local FOptimusResourceAction_AddResource = {}


---@class FOptimusResourceAction_RemoveResource : FOptimusAction
local FOptimusResourceAction_RemoveResource = {}


---@class FOptimusResourceAction_RenameResource : FOptimusAction
local FOptimusResourceAction_RenameResource = {}


---@class FOptimusResourceAction_SetDataDomain : FOptimusAction
local FOptimusResourceAction_SetDataDomain = {}


---@class FOptimusResourceAction_SetDataType : FOptimusAction
local FOptimusResourceAction_SetDataType = {}


---@class FOptimusSecondaryInputBindingsGroup
---@field GroupName FOptimusValidatedName
---@field BindingArray FOptimusParameterBindingArray
local FOptimusSecondaryInputBindingsGroup = {}



---@class FOptimusShaderText
---@field Declarations FString
---@field ShaderText FString
local FOptimusShaderText = {}



---@class FOptimusValidatedName
---@field Name FName
local FOptimusValidatedName = {}



---@class FOptimusValueContainerStruct
---@field Value FInstancedPropertyBag
local FOptimusValueContainerStruct = {}



---@class FOptimusValueDescription
---@field DataType FOptimusDataTypeRef
---@field ValueUsage EOptimusValueUsage
---@field Value FOptimusValueContainerStruct
---@field ShaderValue FShaderValueContainer
local FOptimusValueDescription = {}



---@class FOptimusValueIdentifier
---@field Type EOptimusValueType
---@field Name FName
local FOptimusValueIdentifier = {}



---@class FOptimusVariableAction_AddVariable : FOptimusAction
local FOptimusVariableAction_AddVariable = {}


---@class FOptimusVariableAction_RemoveVariable : FOptimusAction
local FOptimusVariableAction_RemoveVariable = {}


---@class FOptimusVariableAction_RenameVariable : FOptimusAction
local FOptimusVariableAction_RenameVariable = {}


---@class FOptimusVariableAction_SetDataType : FOptimusAction
local FOptimusVariableAction_SetDataType = {}


---@class FOptimusVariableMetaDataEntry
---@field Key FName
---@field Value FString
local FOptimusVariableMetaDataEntry = {}



---@class FOptimus_ShaderBinding
---@field Name FName
---@field DataType FOptimusDataTypeRef
local FOptimus_ShaderBinding = {}



---@class FRigUnit_AddOptimusDeformer : FRigUnitMutable
---@field DeformerInstanceGuid FGuid
local FRigUnit_AddOptimusDeformer = {}



---@class FRigVMTrait_OptimusDeformer : FRigVMTrait
---@field DeformerGraph TSoftObjectPtr<UOptimusDeformer>
local FRigVMTrait_OptimusDeformer = {}



---@class FRigVMTrait_OptimusDeformerSettings : FRigVMTrait
---@field ExecutionPhase EOptimusDeformerExecutionPhase
---@field ExecutionGroup int32
---@field DeformChildComponents boolean
---@field ExcludeChildComponentsWithTag FName
local FRigVMTrait_OptimusDeformerSettings = {}



---@class FRigVMTrait_OptimusVariableBase : FRigVMTrait
local FRigVMTrait_OptimusVariableBase = {}


---@class FRigVMTrait_SetDeformerBoolArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<boolean>
local FRigVMTrait_SetDeformerBoolArrayVariable = {}



---@class FRigVMTrait_SetDeformerBoolVariable : FRigVMTrait_OptimusVariableBase
---@field Value boolean
local FRigVMTrait_SetDeformerBoolVariable = {}



---@class FRigVMTrait_SetDeformerFloatArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<double>
local FRigVMTrait_SetDeformerFloatArrayVariable = {}



---@class FRigVMTrait_SetDeformerFloatVariable : FRigVMTrait_OptimusVariableBase
---@field Value double
local FRigVMTrait_SetDeformerFloatVariable = {}



---@class FRigVMTrait_SetDeformerInt2ArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FIntPoint>
local FRigVMTrait_SetDeformerInt2ArrayVariable = {}



---@class FRigVMTrait_SetDeformerInt2Variable : FRigVMTrait_OptimusVariableBase
---@field Value FIntPoint
local FRigVMTrait_SetDeformerInt2Variable = {}



---@class FRigVMTrait_SetDeformerInt3ArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FIntVector>
local FRigVMTrait_SetDeformerInt3ArrayVariable = {}



---@class FRigVMTrait_SetDeformerInt3Variable : FRigVMTrait_OptimusVariableBase
---@field Value FIntVector
local FRigVMTrait_SetDeformerInt3Variable = {}



---@class FRigVMTrait_SetDeformerInt4ArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FIntVector4>
local FRigVMTrait_SetDeformerInt4ArrayVariable = {}



---@class FRigVMTrait_SetDeformerInt4Variable : FRigVMTrait_OptimusVariableBase
---@field Value FIntVector4
local FRigVMTrait_SetDeformerInt4Variable = {}



---@class FRigVMTrait_SetDeformerIntArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<int32>
local FRigVMTrait_SetDeformerIntArrayVariable = {}



---@class FRigVMTrait_SetDeformerIntVariable : FRigVMTrait_OptimusVariableBase
---@field Value int32
local FRigVMTrait_SetDeformerIntVariable = {}



---@class FRigVMTrait_SetDeformerLinearColorArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FLinearColor>
local FRigVMTrait_SetDeformerLinearColorArrayVariable = {}



---@class FRigVMTrait_SetDeformerLinearColorVariable : FRigVMTrait_OptimusVariableBase
---@field Value FLinearColor
local FRigVMTrait_SetDeformerLinearColorVariable = {}



---@class FRigVMTrait_SetDeformerNameArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FName>
local FRigVMTrait_SetDeformerNameArrayVariable = {}



---@class FRigVMTrait_SetDeformerNameVariable : FRigVMTrait_OptimusVariableBase
---@field Value FName
local FRigVMTrait_SetDeformerNameVariable = {}



---@class FRigVMTrait_SetDeformerQuatArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FQuat>
local FRigVMTrait_SetDeformerQuatArrayVariable = {}



---@class FRigVMTrait_SetDeformerQuatVariable : FRigVMTrait_OptimusVariableBase
---@field Value FQuat
local FRigVMTrait_SetDeformerQuatVariable = {}



---@class FRigVMTrait_SetDeformerRotatorArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FRotator>
local FRigVMTrait_SetDeformerRotatorArrayVariable = {}



---@class FRigVMTrait_SetDeformerRotatorVariable : FRigVMTrait_OptimusVariableBase
---@field Value FRotator
local FRigVMTrait_SetDeformerRotatorVariable = {}



---@class FRigVMTrait_SetDeformerTransformArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FTransform>
local FRigVMTrait_SetDeformerTransformArrayVariable = {}



---@class FRigVMTrait_SetDeformerTransformVariable : FRigVMTrait_OptimusVariableBase
---@field Value FTransform
local FRigVMTrait_SetDeformerTransformVariable = {}



---@class FRigVMTrait_SetDeformerVector2ArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FVector2D>
local FRigVMTrait_SetDeformerVector2ArrayVariable = {}



---@class FRigVMTrait_SetDeformerVector2Variable : FRigVMTrait_OptimusVariableBase
---@field Value FVector2D
local FRigVMTrait_SetDeformerVector2Variable = {}



---@class FRigVMTrait_SetDeformerVector4ArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FVector4>
local FRigVMTrait_SetDeformerVector4ArrayVariable = {}



---@class FRigVMTrait_SetDeformerVector4Variable : FRigVMTrait_OptimusVariableBase
---@field Value FVector4
local FRigVMTrait_SetDeformerVector4Variable = {}



---@class FRigVMTrait_SetDeformerVectorArrayVariable : FRigVMTrait_OptimusVariableBase
---@field Value TArray<FVector>
local FRigVMTrait_SetDeformerVectorArrayVariable = {}



---@class FRigVMTrait_SetDeformerVectorVariable : FRigVMTrait_OptimusVariableBase
---@field Value FVector
local FRigVMTrait_SetDeformerVectorVariable = {}



---@class IOptimusAlternativeSelectedObjectProvider : IInterface
local IOptimusAlternativeSelectedObjectProvider = {}


---@class IOptimusComponentBindingProvider : IInterface
local IOptimusComponentBindingProvider = {}


---@class IOptimusComponentBindingReceiver : IInterface
local IOptimusComponentBindingReceiver = {}


---@class IOptimusComputeKernelDataInterface : IInterface
local IOptimusComputeKernelDataInterface = {}


---@class IOptimusComputeKernelProvider : IInterface
local IOptimusComputeKernelProvider = {}


---@class IOptimusDataInterfaceProvider : IInterface
local IOptimusDataInterfaceProvider = {}


---@class IOptimusDeformerInstanceAccessor : IInterface
local IOptimusDeformerInstanceAccessor = {}


---@class IOptimusDeprecatedExecutionDataInterface : IInterface
local IOptimusDeprecatedExecutionDataInterface = {}


---@class IOptimusExecutionDomainProvider : IInterface
local IOptimusExecutionDomainProvider = {}


---@class IOptimusGeneratedClassDefiner : IInterface
local IOptimusGeneratedClassDefiner = {}


---@class IOptimusNodeAdderPinProvider : IInterface
local IOptimusNodeAdderPinProvider = {}


---@class IOptimusNodeFunctionLibraryOwner : IInterface
local IOptimusNodeFunctionLibraryOwner = {}


---@class IOptimusNodeGraphCollectionOwner : IInterface
local IOptimusNodeGraphCollectionOwner = {}


---@class IOptimusNodeGraphProvider : IInterface
local IOptimusNodeGraphProvider = {}


---@class IOptimusNodePairProvider : IInterface
local IOptimusNodePairProvider = {}


---@class IOptimusNodePinRouter : IInterface
local IOptimusNodePinRouter = {}


---@class IOptimusNodeSubGraphReferencer : IInterface
local IOptimusNodeSubGraphReferencer = {}


---@class IOptimusNonCollapsibleNode : IInterface
local IOptimusNonCollapsibleNode = {}


---@class IOptimusNonCopyableNode : IInterface
local IOptimusNonCopyableNode = {}


---@class IOptimusOutputBufferWriter : IInterface
local IOptimusOutputBufferWriter = {}


---@class IOptimusParameterBindingProvider : IInterface
local IOptimusParameterBindingProvider = {}


---@class IOptimusPathResolver : IInterface
local IOptimusPathResolver = {}


---@class IOptimusPersistentBufferProvider : IInterface
local IOptimusPersistentBufferProvider = {}


---@class IOptimusPinMutabilityDefiner : IInterface
local IOptimusPinMutabilityDefiner = {}


---@class IOptimusPropertyPinProvider : IInterface
local IOptimusPropertyPinProvider = {}


---@class IOptimusShaderTextProvider : IInterface
local IOptimusShaderTextProvider = {}


---@class IOptimusUnnamedNodePinProvider : IInterface
local IOptimusUnnamedNodePinProvider = {}


---@class IOptimusValueProvider : IInterface
local IOptimusValueProvider = {}


---@class UDefault__OptimusNode_ComputeKernelFunctionGeneratorClass
local UDefault__OptimusNode_ComputeKernelFunctionGeneratorClass = {}


---@class UDefault__OptimusNode_ConstantValueGeneratorClass
local UDefault__OptimusNode_ConstantValueGeneratorClass = {}


---@class UDefault__OptimusValueContainerGeneratorClass
local UDefault__OptimusValueContainerGeneratorClass = {}


---@class UOptimusActionStack : UObject
---@field TransactedActionIndex int32
local UOptimusActionStack = {}



---@class UOptimusAdvancedSkeletonDataInterface : UOptimusComputeDataInterface
---@field SkinWeightProfile FName
---@field bEnableLayeredSkinning boolean
---@field AttributeBufferArray FOptimusAnimAttributeBufferArray
local UOptimusAdvancedSkeletonDataInterface = {}



---@class UOptimusAdvancedSkeletonDataProvider : UComputeDataProvider
---@field SkeletalMesh USkeletalMeshComponent
---@field DeformerInstance UOptimusDeformerInstance
local UOptimusAdvancedSkeletonDataProvider = {}



---@class UOptimusAnimAttributeDataInterface : UOptimusComputeDataInterface
---@field AttributeArray FOptimusAnimAttributeArray
local UOptimusAnimAttributeDataInterface = {}



---@class UOptimusAnimAttributeDataProvider : UComputeDataProvider
---@field SkeletalMesh USkeletalMeshComponent
local UOptimusAnimAttributeDataProvider = {}



---@class UOptimusClothDataInterface : UOptimusComputeDataInterface
local UOptimusClothDataInterface = {}


---@class UOptimusClothDataProvider : UComputeDataProvider
---@field SkinnedMesh USkinnedMeshComponent
local UOptimusClothDataProvider = {}



---@class UOptimusComponentSource : UObject
local UOptimusComponentSource = {}


---@class UOptimusComponentSourceBinding : UObject
---@field BindingName FName
---@field ComponentType TSubclassOf<UOptimusComponentSource>
---@field ComponentTags TArray<FName>
---@field bIsPrimaryBinding boolean
local UOptimusComponentSourceBinding = {}



---@class UOptimusComponentSourceBindingContainer : UObject
---@field Bindings TArray<UOptimusComponentSourceBinding>
local UOptimusComponentSourceBindingContainer = {}



---@class UOptimusComputeDataInterface : UComputeDataInterface
local UOptimusComputeDataInterface = {}


---@class UOptimusComputeGraph : UComputeGraph
---@field KernelToNode TArray<TWeakObjectPtr<UOptimusNode>>
local UOptimusComputeGraph = {}



---@class UOptimusConnectivityDataInterface : UOptimusComputeDataInterface
local UOptimusConnectivityDataInterface = {}


---@class UOptimusConnectivityDataProvider : UComputeDataProvider
---@field SkinnedMesh USkinnedMeshComponent
local UOptimusConnectivityDataProvider = {}



---@class UOptimusCopyKernelDataInterface : UComputeDataInterface
---@field ComponentSourceBinding TWeakObjectPtr<UOptimusComponentSourceBinding>
---@field NumThreadsExpression FString
local UOptimusCopyKernelDataInterface = {}



---@class UOptimusCopyKernelDataProvider : UComputeDataProvider
local UOptimusCopyKernelDataProvider = {}


---@class UOptimusCustomComputeKernelDataInterface : UComputeDataInterface
---@field ComponentSourceBinding TWeakObjectPtr<UOptimusComponentSourceBinding>
---@field NumThreadsExpression FString
---@field ExecutionDomainConstantIdentifier FOptimusConstantIdentifier
local UOptimusCustomComputeKernelDataInterface = {}



---@class UOptimusCustomComputeKernelDataProvider : UComputeDataProvider
local UOptimusCustomComputeKernelDataProvider = {}


---@class UOptimusDebugDrawDataInterface : UOptimusComputeDataInterface
---@field bIsSupported boolean
---@field DebugDrawParameters FOptimusDebugDrawParameters
local UOptimusDebugDrawDataInterface = {}



---@class UOptimusDebugDrawDataProvider : UComputeDataProvider
---@field PrimitiveComponent UPrimitiveComponent
---@field DebugDrawParameters FOptimusDebugDrawParameters
local UOptimusDebugDrawDataProvider = {}



---@class UOptimusDeformer : UMeshDeformer
---@field Mesh USkeletalMesh
---@field ComputeGraphs TArray<FOptimusComputeGraphInfo>
---@field DataInterfacePropertyOverrideMap TMap<TWeakObjectPtr<UComputeDataInterface>, FOptimusDataInterfacePropertyOverrideInfo>
---@field ValueMap TMap<FOptimusValueIdentifier, FOptimusValueDescription>
---@field ActionStack UOptimusActionStack
---@field status EOptimusDeformerStatus
---@field Graphs TArray<UOptimusNodeGraph>
---@field Bindings UOptimusComponentSourceBindingContainer
---@field Variables UOptimusVariableContainer
---@field Resources UOptimusResourceContainer
local UOptimusDeformer = {}

---@return TArray<UOptimusVariableDescription>
function UOptimusDeformer:GetVariables() end
---@return TArray<UOptimusResourceDescription>
function UOptimusDeformer:GetResources() end
---@return UOptimusComponentSourceBinding
function UOptimusDeformer:GetPrimaryComponentBinding() end
---@return TArray<UOptimusComponentSourceBinding>
function UOptimusDeformer:GetComponentBindings() end


---@class UOptimusDeformerDynamicInstanceManager : UMeshDeformerInstance
---@field DefaultInstance UOptimusDeformerInstance
---@field GuidToRigDeformerInstanceMap TMap<FGuid, UOptimusDeformerInstance>
local UOptimusDeformerDynamicInstanceManager = {}



---@class UOptimusDeformerInstance : UMeshDeformerInstance
---@field MeshComponent TWeakObjectPtr<UMeshComponent>
---@field InstanceSettings TWeakObjectPtr<UOptimusDeformerInstanceSettings>
---@field ComputeGraphExecInfos TArray<FOptimusDeformerInstanceExecInfo>
local UOptimusDeformerInstance = {}

---@param InVariableName FName
---@param InValue FVector
---@return boolean
function UOptimusDeformerInstance:SetVectorVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FVector>
---@return boolean
function UOptimusDeformerInstance:SetVectorArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FVector4
---@return boolean
function UOptimusDeformerInstance:SetVector4Variable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FVector4>
---@return boolean
function UOptimusDeformerInstance:SetVector4ArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FVector2D
---@return boolean
function UOptimusDeformerInstance:SetVector2Variable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FVector2D>
---@return boolean
function UOptimusDeformerInstance:SetVector2ArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FTransform
---@return boolean
function UOptimusDeformerInstance:SetTransformVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FTransform>
---@return boolean
function UOptimusDeformerInstance:SetTransformArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FRotator
---@return boolean
function UOptimusDeformerInstance:SetRotatorVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FRotator>
---@return boolean
function UOptimusDeformerInstance:SetRotatorArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FQuat
---@return boolean
function UOptimusDeformerInstance:SetQuatVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FQuat>
---@return boolean
function UOptimusDeformerInstance:SetQuatArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FName
---@return boolean
function UOptimusDeformerInstance:SetNameVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FName>
---@return boolean
function UOptimusDeformerInstance:SetNameArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FLinearColor
---@return boolean
function UOptimusDeformerInstance:SetLinearColorVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FLinearColor>
---@return boolean
function UOptimusDeformerInstance:SetLinearColorArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue int32
---@return boolean
function UOptimusDeformerInstance:SetIntVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<int32>
---@return boolean
function UOptimusDeformerInstance:SetIntArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FIntVector4
---@return boolean
function UOptimusDeformerInstance:SetInt4Variable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FIntVector4>
---@return boolean
function UOptimusDeformerInstance:SetInt4ArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FIntVector
---@return boolean
function UOptimusDeformerInstance:SetInt3Variable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FIntVector>
---@return boolean
function UOptimusDeformerInstance:SetInt3ArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue FIntPoint
---@return boolean
function UOptimusDeformerInstance:SetInt2Variable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<FIntPoint>
---@return boolean
function UOptimusDeformerInstance:SetInt2ArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue double
---@return boolean
function UOptimusDeformerInstance:SetFloatVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<double>
---@return boolean
function UOptimusDeformerInstance:SetFloatArrayVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue boolean
---@return boolean
function UOptimusDeformerInstance:SetBoolVariable(InVariableName, InValue) end
---@param InVariableName FName
---@param InValue TArray<boolean>
---@return boolean
function UOptimusDeformerInstance:SetBoolArrayVariable(InVariableName, InValue) end
---@param InTriggerGraphName FName
---@return boolean
function UOptimusDeformerInstance:EnqueueTriggerGraph(InTriggerGraphName) end


---@class UOptimusDeformerInstanceSettings : UMeshDeformerInstanceSettings
---@field Deformer TWeakObjectPtr<UOptimusDeformer>
---@field Bindings TArray<FOptimusDeformerInstanceComponentBinding>
local UOptimusDeformerInstanceSettings = {}



---@class UOptimusDuplicateVerticesDataInterface : UOptimusComputeDataInterface
local UOptimusDuplicateVerticesDataInterface = {}


---@class UOptimusDuplicateVerticesDataProvider : UComputeDataProvider
---@field SkinnedMesh USkinnedMeshComponent
local UOptimusDuplicateVerticesDataProvider = {}



---@class UOptimusFunctionNodeGraph : UOptimusNodeSubGraph
---@field Category FName
---@field AccessSpecifier FName
local UOptimusFunctionNodeGraph = {}

---@return TArray<FName>
function UOptimusFunctionNodeGraph:GetAccessSpecifierOptions() end


---@class UOptimusGraphDataInterface : UComputeDataInterface
---@field Variables TArray<FOptimusGraphVariableDescription>
---@field ParameterBufferSize int32
local UOptimusGraphDataInterface = {}



---@class UOptimusGraphDataProvider : UComputeDataProvider
---@field MeshComponent UMeshComponent
---@field Variables TArray<FOptimusGraphVariableDescription>
---@field DeformerInstance UOptimusDeformerInstance
local UOptimusGraphDataProvider = {}



---@class UOptimusHalfEdgeDataInterface : UOptimusComputeDataInterface
local UOptimusHalfEdgeDataInterface = {}


---@class UOptimusHalfEdgeDataProvider : UComputeDataProvider
---@field SkinnedMesh USkinnedMeshComponent
local UOptimusHalfEdgeDataProvider = {}



---@class UOptimusImplicitPersistentBufferDataInterface : UOptimusRawBufferDataInterface
---@field bZeroInitForAtomicWrites boolean
local UOptimusImplicitPersistentBufferDataInterface = {}



---@class UOptimusImplicitPersistentBufferDataProvider : UOptimusRawBufferDataProvider
local UOptimusImplicitPersistentBufferDataProvider = {}


---@class UOptimusKernelSource : UComputeKernelSource
---@field Source FString
local UOptimusKernelSource = {}



---@class UOptimusLoopTerminalDataInterface : UOptimusComputeDataInterface
---@field Index uint32
---@field Count uint32
local UOptimusLoopTerminalDataInterface = {}



---@class UOptimusLoopTerminalDataProvider : UComputeDataProvider
local UOptimusLoopTerminalDataProvider = {}


---@class UOptimusMorphTargetDataInterface : UOptimusComputeDataInterface
local UOptimusMorphTargetDataInterface = {}


---@class UOptimusMorphTargetDataProvider : UComputeDataProvider
---@field SkinnedMesh USkinnedMeshComponent
local UOptimusMorphTargetDataProvider = {}



---@class UOptimusNode : UObject
---@field DisplayName FText
---@field GraphPosition FVector2D
---@field Pins TArray<UOptimusNodePin>
---@field ExpandedPins TSet<FName>
---@field DiagnosticLevel EOptimusDiagnosticLevel
local UOptimusNode = {}

---@param InPosition FVector2D
---@return boolean
function UOptimusNode:SetGraphPosition(InPosition) end
---@return FName
function UOptimusNode:GetNodeName() end
---@return FName
function UOptimusNode:GetNodeCategory() end
---@return FVector2D
function UOptimusNode:GetGraphPosition() end
---@return FText
function UOptimusNode:GetDisplayName() end


---@class UOptimusNodeGraph : UObject
---@field GraphType EOptimusNodeGraphType
---@field Nodes TArray<UOptimusNode>
---@field Links TArray<UOptimusNodeLink>
---@field NodePairs TArray<UOptimusNodePair>
---@field Subgraphs TArray<UOptimusNodeGraph>
local UOptimusNodeGraph = {}

---@param InGraph UOptimusNodeGraph
---@param InNewName FString
---@return boolean
function UOptimusNodeGraph:RenameGraphDirect(InGraph, InNewName) end
---@param InGraph UOptimusNodeGraph
---@param InNewName FString
---@return boolean
function UOptimusNodeGraph:RenameGraph(InGraph, InNewName) end
---@param InNodes TArray<UOptimusNode>
---@return boolean
function UOptimusNodeGraph:RemoveNodes(InNodes) end
---@param InNode UOptimusNode
---@return boolean
function UOptimusNodeGraph:RemoveNode(InNode) end
---@param InNodeOutputPin UOptimusNodePin
---@param InNodeInputPin UOptimusNodePin
---@return boolean
function UOptimusNodeGraph:RemoveLink(InNodeOutputPin, InNodeInputPin) end
---@param InNodePin UOptimusNodePin
---@return boolean
function UOptimusNodeGraph:RemoveAllLinks(InNodePin) end
---@param InGraph UOptimusNodeGraph
---@param InInsertBefore int32
---@return boolean
function UOptimusNodeGraph:MoveGraphDirect(InGraph, InInsertBefore) end
---@param InNode UOptimusNode
---@return boolean
function UOptimusNodeGraph:IsSubGraphReference(InNode) end
---@param InNode UOptimusNode
---@return boolean
function UOptimusNodeGraph:IsKernelFunction(InNode) end
---@param InNode UOptimusNode
---@return boolean
function UOptimusNodeGraph:IsFunctionReference(InNode) end
---@return boolean
function UOptimusNodeGraph:IsFunctionGraph() end
---@return boolean
function UOptimusNodeGraph:IsExecutionGraph() end
---@param InNode UOptimusNode
---@return boolean
function UOptimusNodeGraph:IsCustomKernel(InNode) end
---@return EOptimusNodeGraphType
function UOptimusNodeGraph:GetGraphType() end
---@return TArray<UOptimusNodeGraph>
function UOptimusNodeGraph:GetGraphs() end
---@return int32
function UOptimusNodeGraph:GetGraphIndex() end
---@param InGraphReferenceNode UOptimusNode
---@return TArray<UOptimusNode>
function UOptimusNodeGraph:ExpandCollapsedNodes(InGraphReferenceNode) end
---@param InNodes TArray<UOptimusNode>
---@param InPosition FVector2D
---@return boolean
function UOptimusNodeGraph:DuplicateNodes(InNodes, InPosition) end
---@param InNode UOptimusNode
---@param InPosition FVector2D
---@return UOptimusNode
function UOptimusNodeGraph:DuplicateNode(InNode, InPosition) end
---@param InFunctionNode UOptimusNode
---@return boolean
function UOptimusNodeGraph:ConvertToSubGraph(InFunctionNode) end
---@param InSubGraphNode UOptimusNode
---@return boolean
function UOptimusNodeGraph:ConvertToFunction(InSubGraphNode) end
---@param InKernelFunction UOptimusNode
---@return UOptimusNode
function UOptimusNodeGraph:ConvertFunctionToCustomKernel(InKernelFunction) end
---@param InCustomKernel UOptimusNode
---@return UOptimusNode
function UOptimusNodeGraph:ConvertCustomKernelToFunction(InCustomKernel) end
---@param InNodes TArray<UOptimusNode>
---@return UOptimusNode
function UOptimusNodeGraph:CollapseNodesToSubGraph(InNodes) end
---@param InNodes TArray<UOptimusNode>
---@return UOptimusNode
function UOptimusNodeGraph:CollapseNodesToFunction(InNodes) end
---@param InVariableDesc UOptimusVariableDescription
---@param InPosition FVector2D
---@return UOptimusNode
function UOptimusNodeGraph:AddVariableGetNode(InVariableDesc, InPosition) end
---@param InDataTypeRef FOptimusDataTypeRef
---@param InPosition FVector2D
---@return UOptimusNode
function UOptimusNodeGraph:AddValueNode(InDataTypeRef, InPosition) end
---@param InResourceDesc UOptimusResourceDescription
---@param InPosition FVector2D
---@return UOptimusNode
function UOptimusNodeGraph:AddResourceSetNode(InResourceDesc, InPosition) end
---@param InResourceDesc UOptimusResourceDescription
---@param InPosition FVector2D
---@return UOptimusNode
function UOptimusNodeGraph:AddResourceNode(InResourceDesc, InPosition) end
---@param InResourceDesc UOptimusResourceDescription
---@param InPosition FVector2D
---@return UOptimusNode
function UOptimusNodeGraph:AddResourceGetNode(InResourceDesc, InPosition) end
---@param InNodeClass TSubclassOf<UOptimusNode>
---@param InPosition FVector2D
---@return UOptimusNode
function UOptimusNodeGraph:AddNode(InNodeClass, InPosition) end
---@param InPosition FVector2D
---@return TArray<UOptimusNode>
function UOptimusNodeGraph:AddLoopTerminalNodes(InPosition) end
---@param InNodeOutputPin UOptimusNodePin
---@param InNodeInputPin UOptimusNodePin
---@return boolean
function UOptimusNodeGraph:AddLink(InNodeOutputPin, InNodeInputPin) end
---@param InFunctionGraph TSoftObjectPtr<UOptimusFunctionNodeGraph>
---@param InPosition FVector2D
---@return UOptimusNode
function UOptimusNodeGraph:AddFunctionReferenceNode(InFunctionGraph, InPosition) end
---@param InDataInterfaceClass TSubclassOf<UOptimusComputeDataInterface>
---@param InPosition FVector2D
---@return UOptimusNode
function UOptimusNodeGraph:AddDataInterfaceNode(InDataInterfaceClass, InPosition) end
---@param InComponentBinding UOptimusComponentSourceBinding
---@param InPosition FVector2D
---@return UOptimusNode
function UOptimusNodeGraph:AddComponentBindingGetNode(InComponentBinding, InPosition) end


---@class UOptimusNodeLink : UObject
---@field NodeOutputPin UOptimusNodePin
---@field NodeInputPin UOptimusNodePin
local UOptimusNodeLink = {}



---@class UOptimusNodePair : UObject
---@field First UOptimusNode
---@field Second UOptimusNode
local UOptimusNodePair = {}



---@class UOptimusNodePin : UObject
---@field bIsGroupingPin boolean
---@field Direction EOptimusNodePinDirection
---@field StorageType EOptimusNodePinStorageType
---@field DataDomain FOptimusDataDomain
---@field DataType FOptimusDataTypeRef
---@field SubPins TArray<UOptimusNodePin>
local UOptimusNodePin = {}



---@class UOptimusNodeSubGraph : UOptimusNodeGraph
---@field InputBindings FOptimusParameterBindingArray
---@field OutputBindings FOptimusParameterBindingArray
local UOptimusNodeSubGraph = {}



---@class UOptimusNode_AnimAttributeDataInterface : UOptimusNode_DataInterface
local UOptimusNode_AnimAttributeDataInterface = {}


---@class UOptimusNode_ComponentSource : UOptimusNode
---@field Binding UOptimusComponentSourceBinding
---@field DuplicationInfo FOptimusNode_ComponentSource_DuplicationInfo
local UOptimusNode_ComponentSource = {}



---@class UOptimusNode_ComputeKernelBase : UOptimusNode
local UOptimusNode_ComputeKernelBase = {}


---@class UOptimusNode_ComputeKernelFunction : UOptimusNode_ComputeKernelBase
local UOptimusNode_ComputeKernelFunction = {}


---@class UOptimusNode_ComputeKernelFunctionGeneratorClass : UClass
---@field Category FName
---@field KernelName FName
---@field ExecutionDomain FOptimusExecutionDomain
---@field GroupSize FIntVector
---@field InputBindings TArray<FOptimusParameterBinding>
---@field OutputBindings TArray<FOptimusParameterBinding>
---@field ShaderSource FString
local UOptimusNode_ComputeKernelFunctionGeneratorClass = {}



---@class UOptimusNode_ConstantValue : UOptimusNode
local UOptimusNode_ConstantValue = {}


---@class UOptimusNode_ConstantValueGeneratorClass : UClass
---@field DataType FOptimusDataTypeRef
local UOptimusNode_ConstantValueGeneratorClass = {}



---@class UOptimusNode_CustomComputeKernel : UOptimusNode_ComputeKernelBase
---@field Category FName
---@field KernelName FOptimusValidatedName
---@field ExecutionDomain FOptimusExecutionDomain
---@field GroupSize FIntVector
---@field Parameters TArray<FOptimus_ShaderBinding>
---@field InputBindings TArray<FOptimusParameterBinding>
---@field OutputBindings TArray<FOptimusParameterBinding>
---@field InputBindingArray FOptimusParameterBindingArray
---@field OutputBindingArray FOptimusParameterBindingArray
---@field SecondaryInputBindingGroups TArray<FOptimusSecondaryInputBindingsGroup>
---@field AdditionalSources TArray<UComputeSource>
---@field ShaderSource FOptimusShaderText
local UOptimusNode_CustomComputeKernel = {}



---@class UOptimusNode_DataInterface : UOptimusNode
---@field DataInterfaceClass UClass
---@field DataInterfaceData UOptimusComputeDataInterface
local UOptimusNode_DataInterface = {}



---@class UOptimusNode_FunctionReference : UOptimusNode
---@field FunctionGraph TSoftObjectPtr<UOptimusFunctionNodeGraph>
---@field DefaultComponentPin TWeakObjectPtr<UOptimusNodePin>
local UOptimusNode_FunctionReference = {}



---@class UOptimusNode_GetResource : UOptimusNode_ResourceAccessorBase
local UOptimusNode_GetResource = {}


---@class UOptimusNode_GetVariable : UOptimusNode
---@field VariableDesc TWeakObjectPtr<UOptimusVariableDescription>
---@field DuplicationInfo FOptimusNode_GetVariable_DuplicationInfo
local UOptimusNode_GetVariable = {}



---@class UOptimusNode_GraphTerminal : UOptimusNode
---@field TerminalType EOptimusTerminalType
---@field DefaultComponentPin TWeakObjectPtr<UOptimusNodePin>
local UOptimusNode_GraphTerminal = {}



---@class UOptimusNode_LoopTerminal : UOptimusNode
---@field TerminalType EOptimusTerminalType
---@field LoopInfo FOptimusLoopTerminalInfo
---@field IndexPin UOptimusNodePin
---@field CountPin UOptimusNodePin
---@field PinPairInfos TArray<FOptimusPinPairInfo>
local UOptimusNode_LoopTerminal = {}



---@class UOptimusNode_Resource : UOptimusNode_ResourceAccessorBase
local UOptimusNode_Resource = {}


---@class UOptimusNode_ResourceAccessorBase : UOptimusNode
---@field ResourceDesc TWeakObjectPtr<UOptimusResourceDescription>
---@field WriteType EOptimusBufferWriteType
---@field DuplicationInfo FOptimusNode_ResourceAccessorBase_DuplicationInfo
local UOptimusNode_ResourceAccessorBase = {}



---@class UOptimusNode_SetResource : UOptimusNode_ResourceAccessorBase
local UOptimusNode_SetResource = {}


---@class UOptimusNode_SubGraphReference : UOptimusNode
---@field SubgraphName FName
---@field DefaultComponentPin TWeakObjectPtr<UOptimusNodePin>
local UOptimusNode_SubGraphReference = {}



---@class UOptimusPersistentBufferDataInterface : UOptimusRawBufferDataInterface
---@field ResourceName FName
local UOptimusPersistentBufferDataInterface = {}



---@class UOptimusPersistentBufferDataProvider : UOptimusRawBufferDataProvider
local UOptimusPersistentBufferDataProvider = {}


---@class UOptimusRawBufferDataInterface : UOptimusComputeDataInterface
---@field ValueType FShaderValueTypeHandle
---@field DataDomain FOptimusDataDomain
---@field ComponentSourceBinding TWeakObjectPtr<UOptimusComponentSourceBinding>
---@field DomainConstantIdentifier FOptimusConstantIdentifier
local UOptimusRawBufferDataInterface = {}



---@class UOptimusRawBufferDataProvider : UComputeDataProvider
local UOptimusRawBufferDataProvider = {}


---@class UOptimusResourceContainer : UObject
---@field Descriptions TArray<UOptimusResourceDescription>
local UOptimusResourceContainer = {}



---@class UOptimusResourceDescription : UObject
---@field ResourceName FName
---@field DataType FOptimusDataTypeRef
---@field ComponentBinding TWeakObjectPtr<UOptimusComponentSourceBinding>
---@field DataDomain FOptimusDataDomain
---@field DataInterface UOptimusPersistentBufferDataInterface
local UOptimusResourceDescription = {}



---@class UOptimusSceneComponentSource : UOptimusComponentSource
local UOptimusSceneComponentSource = {}


---@class UOptimusSceneDataInterface : UOptimusComputeDataInterface
local UOptimusSceneDataInterface = {}


---@class UOptimusSceneDataProvider : UComputeDataProvider
---@field SceneComponent USceneComponent
local UOptimusSceneDataProvider = {}



---@class UOptimusSkeletalMeshComponentSource : UOptimusSkinnedMeshComponentSource
local UOptimusSkeletalMeshComponentSource = {}


---@class UOptimusSkeletonDataInterface : UOptimusComputeDataInterface
local UOptimusSkeletonDataInterface = {}


---@class UOptimusSkeletonDataProvider : UComputeDataProvider
---@field SkinnedMesh USkinnedMeshComponent
local UOptimusSkeletonDataProvider = {}



---@class UOptimusSkinWeightsAsVertexMaskDataInterface : UOptimusComputeDataInterface
---@field SkinWeightProfile FName
---@field BoneNames TArray<FName>
---@field ExpandTowardsRoot int32
---@field ExpandTowardsLeaf int32
---@field bDebugDrawIncludedBones boolean
---@field DebugDrawColor FColor
local UOptimusSkinWeightsAsVertexMaskDataInterface = {}



---@class UOptimusSkinWeightsAsVertexMaskDataProvider : UComputeDataProvider
---@field SkeletalMesh USkeletalMeshComponent
---@field DeformerInstance UOptimusDeformerInstance
local UOptimusSkinWeightsAsVertexMaskDataProvider = {}



---@class UOptimusSkinnedMeshComponentSource : UOptimusComponentSource
local UOptimusSkinnedMeshComponentSource = {}


---@class UOptimusSkinnedMeshDataInterface : UOptimusComputeDataInterface
local UOptimusSkinnedMeshDataInterface = {}


---@class UOptimusSkinnedMeshDataProvider : UComputeDataProvider
---@field SkinnedMesh USkinnedMeshComponent
local UOptimusSkinnedMeshDataProvider = {}



---@class UOptimusSkinnedMeshExecDataInterface : UOptimusComputeDataInterface
---@field Domain EOptimusSkinnedMeshExecDomain
local UOptimusSkinnedMeshExecDataInterface = {}



---@class UOptimusSkinnedMeshExecDataProvider : UComputeDataProvider
---@field SkinnedMesh USkinnedMeshComponent
---@field Domain EOptimusSkinnedMeshExecDomain
local UOptimusSkinnedMeshExecDataProvider = {}



---@class UOptimusSkinnedMeshReadDataInterface : UOptimusComputeDataInterface
local UOptimusSkinnedMeshReadDataInterface = {}


---@class UOptimusSkinnedMeshReadDataProvider : UComputeDataProvider
---@field SkinnedMesh USkinnedMeshComponent
---@field DeformerInstance UOptimusDeformerInstance
local UOptimusSkinnedMeshReadDataProvider = {}



---@class UOptimusSkinnedMeshVertexAttributeDataInterface : UOptimusComputeDataInterface
---@field AttributeName FName
local UOptimusSkinnedMeshVertexAttributeDataInterface = {}



---@class UOptimusSkinnedMeshVertexAttributeDataProvider : UComputeDataProvider
---@field SkinnedMeshComponent USkinnedMeshComponent
---@field AttributeName FName
---@field DeformerInstance UOptimusDeformerInstance
local UOptimusSkinnedMeshVertexAttributeDataProvider = {}



---@class UOptimusSkinnedMeshWriteDataInterface : UOptimusComputeDataInterface
local UOptimusSkinnedMeshWriteDataInterface = {}


---@class UOptimusSkinnedMeshWriteDataProvider : UComputeDataProvider
---@field SkinnedMesh USkinnedMeshComponent
local UOptimusSkinnedMeshWriteDataProvider = {}



---@class UOptimusSource : UComputeSource
---@field SourceText FString
local UOptimusSource = {}



---@class UOptimusTransientBufferDataInterface : UOptimusRawBufferDataInterface
---@field bZeroInitForAtomicWrites boolean
local UOptimusTransientBufferDataInterface = {}



---@class UOptimusTransientBufferDataProvider : UOptimusRawBufferDataProvider
local UOptimusTransientBufferDataProvider = {}


---@class UOptimusValueContainer : UObject
local UOptimusValueContainer = {}


---@class UOptimusValueContainerGeneratorClass : UClass
---@field DataType FOptimusDataTypeRef
local UOptimusValueContainerGeneratorClass = {}



---@class UOptimusVariableContainer : UObject
---@field Descriptions TArray<UOptimusVariableDescription>
local UOptimusVariableContainer = {}



---@class UOptimusVariableDescription : UObject
---@field Guid FGuid
---@field VariableName FName
---@field DataType FOptimusDataTypeRef
---@field DefaultValueStruct FOptimusValueContainerStruct
---@field CachedShaderValue FShaderValueContainer
---@field ValueData TArray<uint8>
---@field DefaultValue UOptimusValueContainer
local UOptimusVariableDescription = {}



