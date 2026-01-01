---@meta

---@class FGeometryCollectionTransferVertexScalarAttributeNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field FromCollection FManagedArrayCollection
---@field AttributeKey FCollectionAttributeKey
---@field BoundingVolumeType EDataflowTransferNodeBoundingVolume
---@field SampleScale EDataflowTransferNodeSampleScale
---@field Falloff EDataflowTransferNodeFalloff
---@field FalloffThreshold float
---@field EdgeMultiplier float
---@field BoundMultiplier float
local FGeometryCollectionTransferVertexScalarAttributeNode = {}



---@class FSetVertexColorInCollectionFromFloatArrayDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field FloatArray TArray<float>
---@field Scale float
local FSetVertexColorInCollectionFromFloatArrayDataflowNode = {}



---@class FSetVertexColorInCollectionFromVertexSelectionDataflowNode : FDataflowNode
---@field Collection FManagedArrayCollection
---@field VertexSelection FDataflowVertexSelection
---@field SelectedColor FLinearColor
---@field NonSelectedColor FLinearColor
local FSetVertexColorInCollectionFromVertexSelectionDataflowNode = {}



