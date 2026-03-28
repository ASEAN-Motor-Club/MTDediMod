---@meta

---@class FDataflowPreviewCacheParams
---@field FrameRate int32
---@field TimeRange FVector2f
---@field bAsyncCaching boolean
local FDataflowPreviewCacheParams = {}



---@class FStringValuePair
---@field Key FString
---@field Value FString
local FStringValuePair = {}



---@class IDataflowContentOwner : IInterface
local IDataflowContentOwner = {}


---@class UDataflow : UEdGraph
---@field bActive boolean
---@field Targets TArray<UObject>
---@field Material UMaterial
---@field Type EDataflowType
local UDataflow = {}



---@class UDataflowBaseContent : UDataflowContextObject
---@field DataflowTerminal FString
---@field TerminalAsset UObject
---@field bIsConstructionDirty boolean
---@field bIsSimulationDirty boolean
local UDataflowBaseContent = {}



---@class UDataflowBlueprintLibrary : UBlueprintFunctionLibrary
local UDataflowBlueprintLibrary = {}

---@param Dataflow UDataflow
---@param TerminalNodeName FName
---@param ResultAsset UObject
function UDataflowBlueprintLibrary:EvaluateTerminalNodeByName(Dataflow, TerminalNodeName, ResultAsset) end


---@class UDataflowContextObject : UObject
---@field SelectedNode UDataflowEdNode
---@field DataflowGraph UDataflow
local UDataflowContextObject = {}



---@class UDataflowEdNode : UEdGraphNode
---@field bRenderInAssetEditor boolean
---@field bRenderWireframeInAssetEditor boolean
---@field bCanEnableRenderWireframe boolean
local UDataflowEdNode = {}



---@class UDataflowSkeletalContent : UDataflowBaseContent
---@field SkeletalMesh USkeletalMesh
---@field AnimationAsset UAnimationAsset
local UDataflowSkeletalContent = {}



