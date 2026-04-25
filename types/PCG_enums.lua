---@enum EDeterminismLevel
local EDeterminismLevel = {
    None = 0,
    NoDeterminism = 0,
    Basic = 1,
    OrderOrthogonal = 2,
    OrderConsistent = 3,
    OrderIndependent = 4,
    Deterministic = 4,
    EDeterminismLevel_MAX = 5,
}

---@enum EPCGActorFilter
local EPCGActorFilter = {
    Self = 0,
    Parent = 1,
    Root = 2,
    AllWorldActors = 3,
    Original = 4,
    FromInput = 5,
    EPCGActorFilter_MAX = 6,
}

---@enum EPCGActorSelection
local EPCGActorSelection = {
    ByTag = 0,
    ByName = 1,
    ByClass = 2,
    ByPath = 3,
    Unknown = 4,
    EPCGActorSelection_MAX = 5,
}

---@enum EPCGAttachOptions
local EPCGAttachOptions = {
    NotAttached = 0,
    Attached = 1,
    InFolder = 2,
    InGraphFolder = 3,
    InGeneratedFolder = 4,
    EPCGAttachOptions_MAX = 5,
}

---@enum EPCGAttractMode
local EPCGAttractMode = {
    Closest = 0,
    MinAttribute = 1,
    MaxAttribute = 2,
    FromIndex = 3,
    EPCGAttractMode_MAX = 4,
}

---@enum EPCGAttributeAccessorFlags
local EPCGAttributeAccessorFlags = {
    StrictType = 1,
    AllowBroadcast = 2,
    AllowConstructible = 4,
    AllowSetDefaultValue = 8,
    AllowReuseMetadataEntryKey = 16,
    AllowBroadcastAndConstructible = 6,
    EPCGAttributeAccessorFlags_MAX = 17,
}

---@enum EPCGAttributeFilterOperation
local EPCGAttributeFilterOperation = {
    KeepSelectedAttributes = 0,
    DeleteSelectedAttributes = 1,
    EPCGAttributeFilterOperation_MAX = 2,
}

---@enum EPCGAttributeFilterOperator
local EPCGAttributeFilterOperator = {
    Greater = 0,
    GreaterOrEqual = 1,
    Lesser = 2,
    LesserOrEqual = 3,
    Equal = 4,
    NotEqual = 5,
    InRange = 6,
    Substring = 7,
    Matches = 8,
    EPCGAttributeFilterOperator_MAX = 9,
}

---@enum EPCGAttributeInheritanceMode
local EPCGAttributeInheritanceMode = {
    None = 0,
    CopyAttributeSetup = 1,
    EPCGAttributeInheritanceMode_MAX = 2,
}

---@enum EPCGAttributeNoiseMode
local EPCGAttributeNoiseMode = {
    Set = 0,
    Minimum = 1,
    Maximum = 2,
    Add = 3,
    Multiply = 4,
    EPCGAttributeNoiseMode_MAX = 5,
}

---@enum EPCGAttributePropertySelection
local EPCGAttributePropertySelection = {
    Attribute = 0,
    PointProperty = 1,
    ExtraProperty = 2,
    EPCGAttributePropertySelection_MAX = 3,
}

---@enum EPCGAttributeReduceOperation
local EPCGAttributeReduceOperation = {
    Average = 0,
    Max = 1,
    Min = 2,
    Sum = 3,
    Join = 4,
}

---@enum EPCGAttributeSelectAxis
local EPCGAttributeSelectAxis = {
    X = 0,
    Y = 1,
    Z = 2,
    W = 3,
    CustomAxis = 4,
    EPCGAttributeSelectAxis_MAX = 5,
}

---@enum EPCGAttributeSelectOperation
local EPCGAttributeSelectOperation = {
    Min = 0,
    Max = 1,
    Median = 2,
}

---@enum EPCGBlurElementMode
local EPCGBlurElementMode = {
    Constant = 0,
    Linear = 1,
    Gaussian = 2,
    EPCGBlurElementMode_MAX = 3,
}

---@enum EPCGBoundsModifierMode
local EPCGBoundsModifierMode = {
    Set = 0,
    Intersect = 1,
    Include = 2,
    Translate = 3,
    Scale = 4,
    EPCGBoundsModifierMode_MAX = 5,
}

---@enum EPCGChangeType
local EPCGChangeType = {
    None = 0,
    Cosmetic = 1,
    Settings = 2,
    Input = 4,
    Edge = 8,
    Node = 16,
    Structural = 32,
    GenerationGrid = 64,
    ShaderSource = 128,
    EPCGChangeType_MAX = 129,
}

---@enum EPCGClusterAlgorithm
local EPCGClusterAlgorithm = {
    KMeans = 0,
    EM = 1,
    EPCGClusterAlgorithm_MAX = 2,
}

---@enum EPCGCollapseComparisonMode
local EPCGCollapseComparisonMode = {
    Position = 0,
    Center = 1,
    EPCGCollapseComparisonMode_MAX = 2,
}

---@enum EPCGCollapseMode
local EPCGCollapseMode = {
    PairwiseClosest = 0,
    AbsoluteClosest = 1,
    EPCGCollapseMode_MAX = 2,
}

---@enum EPCGCollapseVisitOrder
local EPCGCollapseVisitOrder = {
    Ordered = 0,
    Random = 1,
    MinAttribute = 2,
    MaxAttribute = 3,
    EPCGCollapseVisitOrder_MAX = 4,
}

---@enum EPCGCollisionQueryFlag
local EPCGCollisionQueryFlag = {
    Simple = 0,
    Complex = 1,
    SimpleFirst = 2,
    ComplexFirst = 3,
    EPCGCollisionQueryFlag_MAX = 4,
}

---@enum EPCGComponentDirtyFlag
local EPCGComponentDirtyFlag = {
    None = 0,
    Actor = 1,
    Landscape = 2,
    Input = 4,
    Data = 8,
    All = 15,
    EPCGComponentDirtyFlag_MAX = 16,
}

---@enum EPCGComponentGenerationTrigger
local EPCGComponentGenerationTrigger = {
    GenerateOnLoad = 0,
    GenerateOnDemand = 1,
    GenerateAtRuntime = 2,
    EPCGComponentGenerationTrigger_MAX = 3,
}

---@enum EPCGComponentInput
local EPCGComponentInput = {
    Actor = 0,
    Landscape = 1,
    Other = 2,
    EPCGComponentInput_MAX = 3,
}

---@enum EPCGComponentSelection
local EPCGComponentSelection = {
    ByTag = 0,
    ByClass = 1,
    Unknown = 2,
    EPCGComponentSelection_MAX = 3,
}

---@enum EPCGControlFlowSelectionMode
local EPCGControlFlowSelectionMode = {
    Integer = 0,
    Enum = 1,
    String = 2,
    EPCGControlFlowSelectionMode_MAX = 3,
}

---@enum EPCGControlPointFuseMode
local EPCGControlPointFuseMode = {
    KeepFirst = 0,
    KeepSecond = 1,
    Merge = 2,
    Auto = 3,
    EPCGControlPointFuseMode_MAX = 4,
}

---@enum EPCGCoordinateSpace
local EPCGCoordinateSpace = {
    World = 0,
    OriginalComponent = 1,
    LocalComponent = 2,
    EPCGCoordinateSpace_MAX = 3,
}

---@enum EPCGCopyAttributesOperation
local EPCGCopyAttributesOperation = {
    CopyEachSourceToEachTargetRespectively = 0,
    MergeSourcesAndCopyToAllTargets = 1,
    CopyEachSourceOnEveryTarget = 2,
    EPCGCopyAttributesOperation_MAX = 3,
}

---@enum EPCGCopyPointsInheritanceMode
local EPCGCopyPointsInheritanceMode = {
    Relative = 0,
    Source = 1,
    Target = 2,
    EPCGCopyPointsInheritanceMode_MAX = 3,
}

---@enum EPCGCopyPointsMetadataInheritanceMode
local EPCGCopyPointsMetadataInheritanceMode = {
    SourceFirst = 0,
    TargetFirst = 1,
    SourceOnly = 2,
    TargetOnly = 3,
    None = 4,
    EPCGCopyPointsMetadataInheritanceMode_MAX = 5,
}

---@enum EPCGCopyPointsTagInheritanceMode
local EPCGCopyPointsTagInheritanceMode = {
    Both = 0,
    Source = 1,
    Target = 2,
    EPCGCopyPointsTagInheritanceMode_MAX = 3,
}

---@enum EPCGCreateSplineMode
local EPCGCreateSplineMode = {
    CreateDataOnly = 0,
    CreateComponent = 1,
    EPCGCreateSplineMode_MAX = 2,
}

---@enum EPCGCullPointsMode
local EPCGCullPointsMode = {
    Ordered = 0,
    Unordered = 1,
    EPCGCullPointsMode_MAX = 2,
}

---@enum EPCGDataCountMode
local EPCGDataCountMode = {
    FromInputData = 0,
    Fixed = 1,
    EPCGDataCountMode_MAX = 2,
}

---@enum EPCGDataMultiplicity
local EPCGDataMultiplicity = {
    Pairwise = 0,
    CartesianProduct = 1,
    EPCGDataMultiplicity_MAX = 2,
}

---@enum EPCGDataType
local EPCGDataType = {
    None = 0,
    Point = 2,
    Spline = 4,
    LandscapeSpline = 8,
    PolyLine = 12,
    Landscape = 16,
    Texture = 32,
    RenderTarget = 64,
    BaseTexture = 96,
    Surface = 112,
    Volume = 128,
    Primitive = 256,
    DynamicMesh = 1024,
    Concrete = 1534,
    Composite = 512,
    Spatial = 2046,
    Param = 134217728,
    PointOrParam = 134217730,
    Settings = 268435456,
    Other = 536870912,
    Any = 1073741823,
    EPCGDataType_MAX = 1073741824,
}

---@enum EPCGDebugVisScaleMethod
local EPCGDebugVisScaleMethod = {
    Relative = 0,
    Absolute = 1,
    Extents = 2,
    EPCGDebugVisScaleMethod_MAX = 3,
}

---@enum EPCGDensityMergeOperation
local EPCGDensityMergeOperation = {
    Set = 0,
    Ignore = 1,
    Minimum = 2,
    Maximum = 3,
    Add = 4,
    Subtract = 5,
    Multiply = 6,
    Divide = 7,
    EPCGDensityMergeOperation_MAX = 8,
}

---@enum EPCGDifferenceDensityFunction
local EPCGDifferenceDensityFunction = {
    Minimum = 0,
    ClampedSubstraction = 1,
    Binary = 2,
    EPCGDifferenceDensityFunction_MAX = 3,
}

---@enum EPCGDifferenceMode
local EPCGDifferenceMode = {
    Inferred = 0,
    Continuous = 1,
    Discrete = 2,
    EPCGDifferenceMode_MAX = 3,
}

---@enum EPCGDispatchThreadCount
local EPCGDispatchThreadCount = {
    FromFirstOutputPin = 0,
    Fixed = 1,
    FromProductOfInputPins = 2,
    EPCGDispatchThreadCount_MAX = 3,
}

---@enum EPCGEditorDirtyMode
local EPCGEditorDirtyMode = {
    Normal = 0,
    Preview = 1,
    LoadAsPreview = 2,
    EPCGEditorDirtyMode_MAX = 3,
}

---@enum EPCGElementCountMode
local EPCGElementCountMode = {
    FromInputData = 0,
    Fixed = 1,
    EPCGElementCountMode_MAX = 2,
}

---@enum EPCGElementMultiplicity
local EPCGElementMultiplicity = {
    Product = 0,
    Sum = 1,
    EPCGElementMultiplicity_MAX = 2,
}

---@enum EPCGElementSource
local EPCGElementSource = {
    Trivial = 0,
    TrivialPostGraph = 1,
    Gather = 2,
    FromNode = 3,
    FromCookedSettings = 4,
    EPCGElementSource_MAX = 5,
}

---@enum EPCGExclusiveDataType
local EPCGExclusiveDataType = {
    None = 0,
    Point = 1,
    Spline = 2,
    LandscapeSpline = 3,
    PolyLine = 4,
    Landscape = 5,
    Texture = 6,
    RenderTarget = 7,
    BaseTexture = 8,
    Surface = 9,
    Volume = 10,
    Primitive = 11,
    Concrete = 12,
    Composite = 13,
    Spatial = 14,
    Param = 15,
    Settings = 16,
    Other = 17,
    Any = 18,
    PointOrParam = 19,
    DynamicMesh = 20,
    EPCGExclusiveDataType_MAX = 21,
}

---@enum EPCGExecutionPhase
local EPCGExecutionPhase = {
    NotExecuted = 0,
    PrepareData = 1,
    Execute = 2,
    PostExecute = 3,
    Done = 4,
    EPCGExecutionPhase_MAX = 5,
}

---@enum EPCGExtraProperties
local EPCGExtraProperties = {
    Index = 0,
    EPCGExtraProperties_MAX = 1,
}

---@enum EPCGFilterByTagOperation
local EPCGFilterByTagOperation = {
    KeepTagged = 0,
    RemoveTagged = 1,
    EPCGFilterByTagOperation_MAX = 2,
}

---@enum EPCGGenerationStatus
local EPCGGenerationStatus = {
    Completed = 0,
    Aborted = 1,
    EPCGGenerationStatus_MAX = 2,
}

---@enum EPCGGeodesicSphereRepresentation
local EPCGGeodesicSphereRepresentation = {
    Icosahedron = 0,
    EPCGGeodesicSphereRepresentation_MAX = 1,
}

---@enum EPCGGetDataFromActorMode
local EPCGGetDataFromActorMode = {
    ParseActorComponents = 0,
    GetSinglePoint = 1,
    GetDataFromProperty = 2,
    GetDataFromPCGComponent = 3,
    GetDataFromPCGComponentOrParseComponents = 4,
    GetActorReference = 5,
    GetComponentsReference = 6,
    EPCGGetDataFromActorMode_MAX = 7,
}

---@enum EPCGGridPivot
local EPCGGridPivot = {
    Global = 0,
    OriginalComponent = 1,
    LocalComponent = 2,
    EPCGGridPivot_MAX = 3,
}

---@enum EPCGHiGenGrid
local EPCGHiGenGrid = {
    Uninitialized = 0,
    Grid4 = 4,
    Grid8 = 8,
    Grid16 = 16,
    Grid32 = 32,
    Grid64 = 64,
    Grid128 = 128,
    Grid256 = 256,
    Grid512 = 512,
    Grid1024 = 1024,
    Grid2048 = 2048,
    Grid4096 = 4096,
    Grid8192 = 8192,
    Grid16384 = 16384,
    Grid32768 = 32768,
    Grid65536 = 65536,
    Grid131072 = 131072,
    Grid262144 = 262144,
    Grid524288 = 524288,
    Grid1048576 = 1048576,
    Grid2097152 = 2097152,
    Grid4194304 = 4194304,
    GridMin = 4,
    GridMax = 4194304,
    Unbounded = 2147483648,
    EPCGHiGenGrid_MAX = 2147483649,
}

---@enum EPCGIntersectionDensityFunction
local EPCGIntersectionDensityFunction = {
    Multiply = 0,
    Minimum = 1,
    EPCGIntersectionDensityFunction_MAX = 2,
}

---@enum EPCGKernelAttributeType
local EPCGKernelAttributeType = {
    None = 0,
    Bool = 1,
    Int = 2,
    Float = 3,
    Float2 = 4,
    Float3 = 5,
    Float4 = 6,
    Rotator = 7,
    Quat = 8,
    Transform = 9,
    StringKey = 10,
    Name = 11,
    Invalid = 255,
    EPCGKernelAttributeType_MAX = 256,
}

---@enum EPCGKernelType
local EPCGKernelType = {
    PointProcessor = 0,
    PointGenerator = 1,
    Custom = 2,
    EPCGKernelType_MAX = 3,
}

---@enum EPCGLandscapeCacheSerializationContents
local EPCGLandscapeCacheSerializationContents = {
    SerializeOnlyPositionsAndNormals = 0,
    SerializeOnlyLayerData = 1,
    SerializeAll = 2,
    EPCGLandscapeCacheSerializationContents_MAX = 3,
}

---@enum EPCGLandscapeCacheSerializationMode
local EPCGLandscapeCacheSerializationMode = {
    SerializeOnlyAtCook = 0,
    NeverSerialize = 1,
    AlwaysSerialize = 2,
    EPCGLandscapeCacheSerializationMode_MAX = 3,
}

---@enum EPCGLocalGridPivot
local EPCGLocalGridPivot = {
    Global = 0,
    OriginalComponent = 1,
    LocalComponent = 2,
    EPCGLocalGridPivot_MAX = 3,
}

---@enum EPCGMatchMaxDistanceMode
local EPCGMatchMaxDistanceMode = {
    NoMaxDistance = 0,
    UseConstantMaxDistance = 1,
    AttributeMaxDistance = 2,
    EPCGMatchMaxDistanceMode_MAX = 3,
}

---@enum EPCGMeshSelectorMaterialOverrideMode
local EPCGMeshSelectorMaterialOverrideMode = {
    NoOverride = 0,
    StaticOverride = 1,
    ByAttributeOverride = 2,
    EPCGMeshSelectorMaterialOverrideMode_MAX = 3,
}

---@enum EPCGMetadataBitwiseOperation
local EPCGMetadataBitwiseOperation = {
    And = 0,
    Not = 1,
    Or = 2,
    Xor = 3,
    EPCGMetadataBitwiseOperation_MAX = 4,
}

---@enum EPCGMetadataBooleanOperation
local EPCGMetadataBooleanOperation = {
    And = 0,
    Not = 1,
    Or = 2,
    Xor = 3,
    EPCGMetadataBooleanOperation_MAX = 4,
}

---@enum EPCGMetadataCompareOperation
local EPCGMetadataCompareOperation = {
    Equal = 0,
    NotEqual = 1,
    Greater = 2,
    GreaterOrEqual = 3,
    Less = 4,
    LessOrEqual = 5,
    EPCGMetadataCompareOperation_MAX = 6,
}

---@enum EPCGMetadataFilterMode
local EPCGMetadataFilterMode = {
    ExcludeAttributes = 0,
    IncludeAttributes = 1,
    EPCGMetadataFilterMode_MAX = 2,
}

---@enum EPCGMetadataMakeRotatorOp
local EPCGMetadataMakeRotatorOp = {
    MakeRotFromX = 0,
    MakeRotFromY = 1,
    MakeRotFromZ = 2,
    MakeRotFromXY = 3,
    MakeRotFromYX = 4,
    MakeRotFromXZ = 5,
    MakeRotFromZX = 6,
    MakeRotFromYZ = 7,
    MakeRotFromZY = 8,
    MakeRotFromAxes = 9,
    MakeRotFromAngles = 10,
    EPCGMetadataMakeRotatorOp_MAX = 11,
}

---@enum EPCGMetadataMakeVector3
local EPCGMetadataMakeVector3 = {
    ThreeValues = 0,
    Vector2AndValue = 1,
    EPCGMetadataMakeVector3_MAX = 2,
}

---@enum EPCGMetadataMakeVector4
local EPCGMetadataMakeVector4 = {
    FourValues = 0,
    Vector2AndTwoValues = 1,
    TwoVector2 = 2,
    Vector3AndValue = 3,
    EPCGMetadataMakeVector4_MAX = 4,
}

---@enum EPCGMetadataMathsOperation
local EPCGMetadataMathsOperation = {
    UnaryOp = 1024,
    Sign = 1025,
    Frac = 1026,
    Truncate = 1027,
    Round = 1028,
    Sqrt = 1029,
    Abs = 1030,
    Floor = 1031,
    Ceil = 1032,
    OneMinus = 1033,
    Inc = 1034,
    Dec = 1035,
    Negate = 1036,
    BinaryOp = 2048,
    Add = 2049,
    Subtract = 2050,
    Multiply = 2051,
    Divide = 2052,
    Max = 2053,
    Min = 2054,
    Pow = 2055,
    ClampMin = 2056,
    ClampMax = 2057,
    Modulo = 2058,
    Set = 2059,
    TernaryOp = 4096,
    Clamp = 4097,
    Lerp = 4098,
}

---@enum EPCGMetadataOp
local EPCGMetadataOp = {
    Min = 0,
    Max = 1,
    Sub = 2,
    Add = 3,
    Mul = 4,
    Div = 5,
    SourceValue = 6,
    TargetValue = 7,
}

---@enum EPCGMetadataRotatorOperation
local EPCGMetadataRotatorOperation = {
    RotatorOp = 0,
    Combine = 1,
    Invert = 2,
    Lerp = 3,
    Normalize = 4,
    TransformOp = 100,
    TransformRotation = 101,
    InverseTransformRotation = 102,
    EPCGMetadataRotatorOperation_MAX = 103,
}

---@enum EPCGMetadataSettingsBaseMode
local EPCGMetadataSettingsBaseMode = {
    Inferred = 0,
    NoBroadcast = 1,
    Broadcast = 2,
    EPCGMetadataSettingsBaseMode_MAX = 3,
}

---@enum EPCGMetadataSettingsBaseTypes
local EPCGMetadataSettingsBaseTypes = {
    AutoUpcastTypes = 0,
    StrictTypes = 1,
    EPCGMetadataSettingsBaseTypes_MAX = 2,
}

---@enum EPCGMetadataStringOperation
local EPCGMetadataStringOperation = {
    Append = 0,
    Replace = 1,
    EPCGMetadataStringOperation_MAX = 2,
}

---@enum EPCGMetadataTransformOperation
local EPCGMetadataTransformOperation = {
    Compose = 0,
    Invert = 1,
    Lerp = 2,
    EPCGMetadataTransformOperation_MAX = 3,
}

---@enum EPCGMetadataTrigOperation
local EPCGMetadataTrigOperation = {
    Acos = 0,
    Asin = 1,
    Atan = 2,
    Atan2 = 3,
    Cos = 4,
    Sin = 5,
    Tan = 6,
    DegToRad = 7,
    RadToDeg = 8,
    EPCGMetadataTrigOperation_MAX = 9,
}

---@enum EPCGMetadataTypes
local EPCGMetadataTypes = {
    Float = 0,
    Double = 1,
    Integer32 = 2,
    Integer64 = 3,
    Vector2 = 4,
    Vector = 5,
    Vector4 = 6,
    Quaternion = 7,
    Transform = 8,
    String = 9,
    Boolean = 10,
    Rotator = 11,
    Name = 12,
    SoftObjectPath = 13,
    SoftClassPath = 14,
    Count = 15,
    Unknown = 255,
    EPCGMetadataTypes_MAX = 256,
}

---@enum EPCGMetadataTypesConstantStructStringMode
local EPCGMetadataTypesConstantStructStringMode = {
    String = 0,
    SoftObjectPath = 1,
    SoftClassPath = 2,
    EPCGMetadataTypesConstantStructStringMode_MAX = 3,
}

---@enum EPCGMetadataVectorOperation
local EPCGMetadataVectorOperation = {
    VectorOp = 0,
    Cross = 1,
    Dot = 2,
    Distance = 3,
    Normalize = 4,
    Length = 5,
    RotateAroundAxis = 6,
    TransformOp = 100,
    TransformDirection = 101,
    TransformLocation = 102,
    InverseTransformDirection = 103,
    InverseTransformLocation = 104,
    EPCGMetadataVectorOperation_MAX = 105,
}

---@enum EPCGNodeTitleType
local EPCGNodeTitleType = {
    FullTitle = 0,
    ListView = 1,
    EPCGNodeTitleType_MAX = 2,
}

---@enum EPCGPathfindingCostFunctionMode
local EPCGPathfindingCostFunctionMode = {
    Distance = 0,
    FitnessScore = 1,
    CostMultiplier = 2,
    EPCGPathfindingCostFunctionMode_MAX = 3,
}

---@enum EPCGPathfindingSplineMode
local EPCGPathfindingSplineMode = {
    Curve = 0,
    Linear = 1,
    EPCGPathfindingSplineMode_MAX = 2,
}

---@enum EPCGPinInitMode
local EPCGPinInitMode = {
    FromInputPins = 0,
    Custom = 1,
    EPCGPinInitMode_MAX = 2,
}

---@enum EPCGPinStatus
local EPCGPinStatus = {
    Normal = 0,
    Required = 1,
    Advanced = 2,
    OverrideOrUserParam = 3,
    EPCGPinStatus_MAX = 4,
}

---@enum EPCGPinUsage
local EPCGPinUsage = {
    Normal = 0,
    Loop = 1,
    Feedback = 2,
    DependencyOnly = 3,
    EPCGPinUsage_MAX = 4,
}

---@enum EPCGPointExtentsModifierMode
local EPCGPointExtentsModifierMode = {
    Set = 0,
    Minimum = 1,
    Maximum = 2,
    Add = 3,
    Multiply = 4,
    EPCGPointExtentsModifierMode_MAX = 5,
}

---@enum EPCGPointNeighborhoodDensityMode
local EPCGPointNeighborhoodDensityMode = {
    None = 0,
    SetNormalizedDistanceToDensity = 1,
    SetAverageDensity = 2,
    EPCGPointNeighborhoodDensityMode_MAX = 3,
}

---@enum EPCGPointPosition
local EPCGPointPosition = {
    CellCenter = 0,
    CellCorners = 1,
    EPCGPointPosition_MAX = 2,
}

---@enum EPCGPointProperties
local EPCGPointProperties = {
    Density = 0,
    BoundsMin = 1,
    BoundsMax = 2,
    Extents = 3,
    Color = 4,
    Position = 5,
    Rotation = 6,
    Scale = 7,
    Transform = 8,
    Steepness = 9,
    LocalCenter = 10,
    Seed = 11,
    LocalSize = 12,
    ScaledLocalSize = 13,
    EPCGPointProperties_MAX = 14,
}

---@enum EPCGPrintVerbosity
local EPCGPrintVerbosity = {
    Log = 5,
    Warning = 3,
    Error = 2,
    EPCGPrintVerbosity_MAX = 6,
}

---@enum EPCGProjectionColorBlendMode
local EPCGProjectionColorBlendMode = {
    SourceValue = 0,
    TargetValue = 1,
    Add = 2,
    Subtract = 3,
    Multiply = 4,
    EPCGProjectionColorBlendMode_MAX = 5,
}

---@enum EPCGProjectionTagMergeMode
local EPCGProjectionTagMergeMode = {
    Source = 0,
    Target = 1,
    Both = 2,
    EPCGProjectionTagMergeMode_MAX = 3,
}

---@enum EPCGProxyInterfaceMode
local EPCGProxyInterfaceMode = {
    ByNativeElement = 0,
    ByBlueprintElement = 1,
    BySettings = 2,
    EPCGProxyInterfaceMode_MAX = 3,
}

---@enum EPCGReadbackMode
local EPCGReadbackMode = {
    None = 0,
    GraphOutput = 2,
    Inspection = 4,
    DebugVisualization = 8,
    EPCGReadbackMode_MAX = 9,
}

---@enum EPCGReverseSplineOperation
local EPCGReverseSplineOperation = {
    Reverse = 0,
    ForceClockwise = 1,
    ForceCounterClockwise = 2,
    EPCGReverseSplineOperation_MAX = 3,
}

---@enum EPCGSelectGrammarComparator
local EPCGSelectGrammarComparator = {
    BinaryOps = 32,
    Select = 33,
    LessThan = 34,
    LessThanEqualTo = 35,
    EqualTo = 36,
    GreaterThanEqualTo = 37,
    GreaterThan = 38,
    TernaryOps = 64,
    RangeExclusive = 65,
    RangeInclusive = 66,
    EPCGSelectGrammarComparator_MAX = 67,
}

---@enum EPCGSelfPruningType
local EPCGSelfPruningType = {
    LargeToSmall = 0,
    SmallToLarge = 1,
    AllEqual = 2,
    None = 3,
    RemoveDuplicates = 4,
    EPCGSelfPruningType_MAX = 5,
}

---@enum EPCGSettingsExecutionMode
local EPCGSettingsExecutionMode = {
    Enabled = 0,
    Debug = 1,
    Isolated = 2,
    Disabled = 3,
    EPCGSettingsExecutionMode_MAX = 4,
}

---@enum EPCGSettingsType
local EPCGSettingsType = {
    InputOutput = 0,
    Spatial = 1,
    Density = 2,
    Blueprint = 3,
    Metadata = 4,
    Filter = 5,
    Sampler = 6,
    Spawner = 7,
    Subgraph = 8,
    Debug = 9,
    Generic = 10,
    Param = 11,
    HierarchicalGeneration = 12,
    ControlFlow = 13,
    PointOps = 14,
    GraphParameters = 15,
    Reroute = 16,
    GPU = 17,
    DynamicMesh = 18,
    EPCGSettingsType_MAX = 19,
}

---@enum EPCGSortMethod
local EPCGSortMethod = {
    Ascending = 0,
    Descending = 1,
    EPCGSortMethod_MAX = 2,
}

---@enum EPCGSpawnActorGenerationTrigger
local EPCGSpawnActorGenerationTrigger = {
    Default = 0,
    ForceGenerate = 1,
    DoNotGenerateInEditor = 2,
    DoNotGenerate = 3,
    EPCGSpawnActorGenerationTrigger_MAX = 4,
}

---@enum EPCGSpawnActorOption
local EPCGSpawnActorOption = {
    CollapseActors = 0,
    MergePCGOnly = 1,
    NoMerging = 2,
    EPCGSpawnActorOption_MAX = 3,
}

---@enum EPCGSphereGeneration
local EPCGSphereGeneration = {
    Geodesic = 0,
    Angle = 1,
    Segments = 2,
    Random = 3,
    Poisson = 4,
    EPCGSphereGeneration_MAX = 5,
}

---@enum EPCGSpherePointOrientation
local EPCGSpherePointOrientation = {
    Radial = 0,
    Centric = 1,
    None = 2,
    EPCGSpherePointOrientation_MAX = 3,
}

---@enum EPCGSplineMeshForwardAxis
local EPCGSplineMeshForwardAxis = {
    X = 0,
    Y = 1,
    Z = 2,
    EPCGSplineMeshForwardAxis_MAX = 3,
}

---@enum EPCGSplineSamplingDimension
local EPCGSplineSamplingDimension = {
    OnSpline = 0,
    OnHorizontal = 1,
    OnVertical = 2,
    OnVolume = 3,
    OnInterior = 4,
    EPCGSplineSamplingDimension_MAX = 5,
}

---@enum EPCGSplineSamplingFill
local EPCGSplineSamplingFill = {
    Fill = 0,
    EdgesOnly = 1,
    EPCGSplineSamplingFill_MAX = 2,
}

---@enum EPCGSplineSamplingInteriorOrientation
local EPCGSplineSamplingInteriorOrientation = {
    Uniform = 0,
    FollowCurvature = 1,
    EPCGSplineSamplingInteriorOrientation_MAX = 2,
}

---@enum EPCGSplineSamplingMode
local EPCGSplineSamplingMode = {
    Subdivision = 0,
    Distance = 1,
    NumberOfSamples = 2,
    EPCGSplineSamplingMode_MAX = 3,
}

---@enum EPCGSplineSamplingSeedingMode
local EPCGSplineSamplingSeedingMode = {
    SeedFromPosition = 0,
    SeedFromIndex = 1,
    EPCGSplineSamplingSeedingMode_MAX = 2,
}

---@enum EPCGSplitAxis
local EPCGSplitAxis = {
    X = 0,
    Y = 1,
    Z = 2,
    EPCGSplitAxis_MAX = 3,
}

---@enum EPCGStringMatchingOperator
local EPCGStringMatchingOperator = {
    Equal = 0,
    Substring = 1,
    Matches = 2,
    EPCGStringMatchingOperator_MAX = 3,
}

---@enum EPCGTagFilterOperation
local EPCGTagFilterOperation = {
    KeepOnlySelectedTags = 0,
    DeleteSelectedTags = 1,
    EPCGTagFilterOperation_MAX = 2,
}

---@enum EPCGTextureAddressMode
local EPCGTextureAddressMode = {
    Clamp = 0,
    Wrap = 1,
    EPCGTextureAddressMode_MAX = 2,
}

---@enum EPCGTextureColorChannel
local EPCGTextureColorChannel = {
    Red = 0,
    Green = 1,
    Blue = 2,
    Alpha = 3,
    EPCGTextureColorChannel_MAX = 4,
}

---@enum EPCGTextureDensityFunction
local EPCGTextureDensityFunction = {
    Ignore = 0,
    Multiply = 1,
    EPCGTextureDensityFunction_MAX = 2,
}

---@enum EPCGTextureFilter
local EPCGTextureFilter = {
    Point = 0,
    Bilinear = 1,
    EPCGTextureFilter_MAX = 2,
}

---@enum EPCGTextureMappingMethod
local EPCGTextureMappingMethod = {
    Planar = 0,
    UVCoordinates = 1,
    EPCGTextureMappingMethod_MAX = 2,
}

---@enum EPCGTransformLerpMode
local EPCGTransformLerpMode = {
    QuatInterp = 0,
    EulerInterp = 1,
    DualQuatInterp = 2,
    EPCGTransformLerpMode_MAX = 3,
}

---@enum EPCGTypeConversion
local EPCGTypeConversion = {
    NoConversionRequired = 0,
    CollapseToPoint = 1,
    Filter = 2,
    MakeConcrete = 3,
    SplineToSurface = 4,
    Failed = 5,
    EPCGTypeConversion_MAX = 6,
}

---@enum EPCGUnionDensityFunction
local EPCGUnionDensityFunction = {
    Maximum = 0,
    ClampedAddition = 1,
    Binary = 2,
    EPCGUnionDensityFunction_MAX = 3,
}

---@enum EPCGUnionType
local EPCGUnionType = {
    LeftToRightPriority = 0,
    RightToLeftPriority = 1,
    KeepAll = 2,
    EPCGUnionType_MAX = 3,
}

---@enum EPCGUnitTestDummyEnum
local EPCGUnitTestDummyEnum = {
    One = 0,
    Two = 1,
    Three = 2,
    EPCGUnitTestDummyEnum_MAX = 3,
}

---@enum EPCGUserParameterSource
local EPCGUserParameterSource = {
    Current = 0,
    Upstream = 1,
    Root = 2,
    EPCGUserParameterSource_MAX = 3,
}

---@enum EPCGWorldQueryFilterByTag
local EPCGWorldQueryFilterByTag = {
    NoTagFilter = 0,
    IncludeTagged = 1,
    ExcludeTagged = 2,
    EPCGWorldQueryFilterByTag_MAX = 3,
}

---@enum EPCGWorldQuerySelectLandscapeHits
local EPCGWorldQuerySelectLandscapeHits = {
    Exclude = 0,
    Include = 1,
    Require = 2,
    EPCGWorldQuerySelectLandscapeHits_MAX = 3,
}

---@enum EPCGWorldRaycastMode
local EPCGWorldRaycastMode = {
    Infinite = 0,
    ScaledVector = 1,
    NormalizedWithLength = 2,
    Segments = 3,
    EPCGWorldRaycastMode_MAX = 4,
}

---@enum PCGDistanceShape
local PCGDistanceShape = {
    SphereBounds = 0,
    BoxBounds = 1,
    Center = 2,
    PCGDistanceShape_MAX = 3,
}

---@enum PCGNormalToDensityMode
local PCGNormalToDensityMode = {
    Set = 0,
    Minimum = 1,
    Maximum = 2,
    Add = 3,
    Subtract = 4,
    Multiply = 5,
    Divide = 6,
    PCGNormalToDensityMode_MAX = 7,
}

---@enum PCGSpatialNoiseMask2DMode
local PCGSpatialNoiseMask2DMode = {
    Perlin = 0,
    Caustic = 1,
    FractionalBrownian = 2,
    PCGSpatialNoiseMask2DMode_MAX = 3,
}

---@enum PCGSpatialNoiseMode
local PCGSpatialNoiseMode = {
    Perlin2D = 0,
    Caustic2D = 1,
    Voronoi2D = 2,
    FractionalBrownian2D = 3,
    EdgeMask2D = 4,
    PCGSpatialNoiseMode_MAX = 5,
}

