---@meta

---@class FBreakAttributeKeyDataflowNode : FDataflowNode
---@field AttributeKeyIn FCollectionAttributeKey
---@field AttributeOut FString
---@field GroupOut FString
local FBreakAttributeKeyDataflowNode = {}



---@class FDataflowCollectionAddScalarVertexPropertyNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field Name FString
---@field AttributeKey FCollectionAttributeKey
---@field VertexWeights TArray<float>
---@field TargetGroup FScalarVertexPropertyGroup
local FDataflowCollectionAddScalarVertexPropertyNode = {}



---@class FDataflowFunctionProperty
local FDataflowFunctionProperty = {}


---@class FFloatOverrideDataflowNode : FDataflowNode
---@field PropertyName FName
---@field KeyName FName
---@field ValueOut float
local FFloatOverrideDataflowNode = {}



---@class FGetSkeletalMeshDataflowNode : FDataflowNode
---@field SkeletalMesh USkeletalMesh
---@field PropertyName FName
local FGetSkeletalMeshDataflowNode = {}



---@class FGetSkeletonDataflowNode : FDataflowNode
---@field Skeleton USkeleton
---@field PropertyName FName
local FGetSkeletonDataflowNode = {}



---@class FGetStaticMeshDataflowNode : FDataflowNode
---@field StaticMesh UStaticMesh
---@field PropertyName FName
local FGetStaticMeshDataflowNode = {}



---@class FMakeAttributeKeyDataflowNode : FDataflowNode
---@field GroupIn FString
---@field AttributeIn FString
---@field AttributeKeyOut FCollectionAttributeKey
local FMakeAttributeKeyDataflowNode = {}



---@class FScalarVertexPropertyGroup
---@field Name FName
local FScalarVertexPropertyGroup = {}



---@class FSelectionSetDataflowNode : FDataflowNode
---@field Indices FString
---@field IndicesOut TArray<int32>
local FSelectionSetDataflowNode = {}



---@class FSkeletalMeshBoneDataflowNode : FDataflowNode
---@field BoneName FName
---@field SkeletalMesh USkeletalMesh
---@field BoneIndexOut int32
---@field PropertyName FName
local FSkeletalMeshBoneDataflowNode = {}



---@class FSkeletalMeshReferenceTransformDataflowNode : FDataflowNode
---@field SkeletalMeshIn USkeletalMesh
---@field BoneIndexIn int32
---@field TransformOut FTransform
local FSkeletalMeshReferenceTransformDataflowNode = {}



