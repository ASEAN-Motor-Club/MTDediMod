---@meta

---@class FDescriptionColumn : FEditorDataStorageColumn
---@field Description FText
local FDescriptionColumn = {}



---@class FDisplayNameColumn : FEditorDataStorageColumn
---@field DisplayName FText
local FDisplayNameColumn = {}



---@class FEditorDataStorageColumn
local FEditorDataStorageColumn = {}


---@class FEditorDataStorageTag
local FEditorDataStorageTag = {}


---@class FFolderTag : FEditorDataStorageTag
local FFolderTag = {}


---@class FHideRowFromUITag : FEditorDataStorageTag
local FHideRowFromUITag = {}


---@class FNameColumn : FEditorDataStorageColumn
---@field Name FName
local FNameColumn = {}



---@class FObjectOverrideColumn : FEditorDataStorageColumn
local FObjectOverrideColumn = {}


---@class FSCCExternalRevisionIdColumn : FEditorDataStorageColumn
---@field RevisionId FSCCRevisionId
local FSCCExternalRevisionIdColumn = {}



---@class FSCCExternallyEditedTag : FEditorDataStorageTag
local FSCCExternallyEditedTag = {}


---@class FSCCExternallyLockedColumn : FEditorDataStorageColumn
---@field LockedBy FSCCUserInfo
local FSCCExternallyLockedColumn = {}



---@class FSCCInChangelistTag : FEditorDataStorageTag
local FSCCInChangelistTag = {}


---@class FSCCLockedTag : FEditorDataStorageTag
local FSCCLockedTag = {}


---@class FSCCNotCurrentTag : FEditorDataStorageTag
local FSCCNotCurrentTag = {}


---@class FSCCRevisionId
---@field ID uint32
local FSCCRevisionId = {}



---@class FSCCRevisionIdColumn : FEditorDataStorageColumn
---@field RevisionId FSCCRevisionId
local FSCCRevisionIdColumn = {}



---@class FSCCStagedTag : FEditorDataStorageTag
local FSCCStagedTag = {}


---@class FSCCStatusColumn : FEditorDataStorageColumn
---@field Modification ESCCModification
local FSCCStatusColumn = {}



---@class FSCCUserInfo
---@field Name FString
local FSCCUserInfo = {}



---@class FScriptTypedElementHandle
local FScriptTypedElementHandle = {}


---@class FScriptTypedElementListProxy
local FScriptTypedElementListProxy = {}


---@class FSimpleWidgetConstructor : FTypedElementWidgetConstructor
local FSimpleWidgetConstructor = {}


---@class FSlateColorColumn : FEditorDataStorageColumn
---@field Color FSlateColor
local FSlateColorColumn = {}



---@class FTEDSProcessorTestsReferenceColumn : FEditorDataStorageColumn
local FTEDSProcessorTestsReferenceColumn = {}


---@class FTEDSProcessorTests_Linked : FEditorDataStorageTag
local FTEDSProcessorTests_Linked = {}


---@class FTEDSProcessorTests_PrimaryTag : FEditorDataStorageTag
local FTEDSProcessorTests_PrimaryTag = {}


---@class FTEDSProcessorTests_SecondaryTag : FEditorDataStorageTag
local FTEDSProcessorTests_SecondaryTag = {}


---@class FTableRowParentColumn : FEditorDataStorageColumn
local FTableRowParentColumn = {}


---@class FTedsRowHandle
---@field RowHandle uint64
local FTedsRowHandle = {}



---@class FTestColumnA : FEditorDataStorageColumn
local FTestColumnA = {}


---@class FTestColumnB : FEditorDataStorageColumn
local FTestColumnB = {}


---@class FTestColumnC : FEditorDataStorageColumn
local FTestColumnC = {}


---@class FTestColumnD : FEditorDataStorageColumn
local FTestColumnD = {}


---@class FTestColumnE : FEditorDataStorageColumn
local FTestColumnE = {}


---@class FTestColumnF : FEditorDataStorageColumn
local FTestColumnF = {}


---@class FTestColumnG : FEditorDataStorageColumn
local FTestColumnG = {}


---@class FTestColumnInt : FEditorDataStorageColumn
---@field TestInt int32
local FTestColumnInt = {}



---@class FTestColumnString : FEditorDataStorageColumn
---@field TestString FString
local FTestColumnString = {}



---@class FTestTagColumnA : FEditorDataStorageTag
local FTestTagColumnA = {}


---@class FTestTagColumnB : FEditorDataStorageTag
local FTestTagColumnB = {}


---@class FTestTagColumnC : FEditorDataStorageTag
local FTestTagColumnC = {}


---@class FTestTagColumnD : FEditorDataStorageTag
local FTestTagColumnD = {}


---@class FTest_PingPongDurPhys : FEditorDataStorageColumn
---@field Value uint64
local FTest_PingPongDurPhys = {}



---@class FTest_PingPongPostPhys : FEditorDataStorageColumn
---@field Value uint64
local FTest_PingPongPostPhys = {}



---@class FTest_PingPongPrePhys : FEditorDataStorageColumn
---@field Value uint64
local FTest_PingPongPrePhys = {}



---@class FTypedElementActorTag : FEditorDataStorageTag
local FTypedElementActorTag = {}


---@class FTypedElementAlertActionColumn : FEditorDataStorageColumn
local FTypedElementAlertActionColumn = {}


---@class FTypedElementAlertColumn : FEditorDataStorageColumn
---@field Message FText
---@field AlertType FTypedElementAlertColumnType
local FTypedElementAlertColumn = {}



---@class FTypedElementChildAlertColumn : FEditorDataStorageColumn
local FTypedElementChildAlertColumn = {}


---@class FTypedElementClassDefaultObjectTag : FEditorDataStorageTag
local FTypedElementClassDefaultObjectTag = {}


---@class FTypedElementClassTypeInfoColumn : FEditorDataStorageColumn
local FTypedElementClassTypeInfoColumn = {}


---@class FTypedElementExternalObjectColumn : FEditorDataStorageColumn
local FTypedElementExternalObjectColumn = {}


---@class FTypedElementFloatValueCacheColumn : FEditorDataStorageColumn
---@field Value float
local FTypedElementFloatValueCacheColumn = {}



---@class FTypedElementI32IntValueCacheColumn : FEditorDataStorageColumn
---@field Value int32
local FTypedElementI32IntValueCacheColumn = {}



---@class FTypedElementI64IntValueCacheColumn : FEditorDataStorageColumn
---@field Value int64
local FTypedElementI64IntValueCacheColumn = {}



---@class FTypedElementIconOverrideColumn : FEditorDataStorageColumn
---@field IconName FName
local FTypedElementIconOverrideColumn = {}



---@class FTypedElementLabelColumn : FEditorDataStorageColumn
---@field Label FString
local FTypedElementLabelColumn = {}



---@class FTypedElementLabelHashColumn : FEditorDataStorageColumn
---@field LabelHash uint64
local FTypedElementLabelHashColumn = {}



---@class FTypedElementLocalTransformColumn : FEditorDataStorageColumn
---@field Transform FTransform
local FTypedElementLocalTransformColumn = {}



---@class FTypedElementLoosePropertyTag : FEditorDataStorageTag
local FTypedElementLoosePropertyTag = {}


---@class FTypedElementPackageLoadedPathColumn : FEditorDataStorageColumn
local FTypedElementPackageLoadedPathColumn = {}


---@class FTypedElementPackagePathColumn : FEditorDataStorageColumn
---@field Path FString
local FTypedElementPackagePathColumn = {}



---@class FTypedElementPackageReference : FEditorDataStorageColumn
local FTypedElementPackageReference = {}


---@class FTypedElementPackageUnresolvedReference : FEditorDataStorageColumn
local FTypedElementPackageUnresolvedReference = {}


---@class FTypedElementPackageUpdatedTag : FEditorDataStorageTag
local FTypedElementPackageUpdatedTag = {}


---@class FTypedElementPivotOffset : FEditorDataStorageColumn
---@field Offset FVector
local FTypedElementPivotOffset = {}



---@class FTypedElementPropertyBagPlaceholderTag : FEditorDataStorageTag
local FTypedElementPropertyBagPlaceholderTag = {}


---@class FTypedElementPropertyBagPlaceholderTypeInfoColumn : FEditorDataStorageColumn
local FTypedElementPropertyBagPlaceholderTypeInfoColumn = {}


---@class FTypedElementRowReferenceColumn : FEditorDataStorageColumn
local FTypedElementRowReferenceColumn = {}


---@class FTypedElementScriptStructTypeInfoColumn : FEditorDataStorageColumn
local FTypedElementScriptStructTypeInfoColumn = {}


---@class FTypedElementSelectionColumn : FEditorDataStorageColumn
---@field SelectionSet FName
local FTypedElementSelectionColumn = {}



---@class FTypedElementSlateWidgetReferenceColumn : FEditorDataStorageColumn
local FTypedElementSlateWidgetReferenceColumn = {}


---@class FTypedElementSlateWidgetReferenceDeletesRowTag : FEditorDataStorageTag
local FTypedElementSlateWidgetReferenceDeletesRowTag = {}


---@class FTypedElementSyncBackToWorldTag : FEditorDataStorageTag
local FTypedElementSyncBackToWorldTag = {}


---@class FTypedElementSyncFromWorldInteractiveTag : FEditorDataStorageTag
local FTypedElementSyncFromWorldInteractiveTag = {}


---@class FTypedElementSyncFromWorldTag : FEditorDataStorageTag
local FTypedElementSyncFromWorldTag = {}


---@class FTypedElementU32IntValueCacheColumn : FEditorDataStorageColumn
---@field Value uint32
local FTypedElementU32IntValueCacheColumn = {}



---@class FTypedElementU64IntValueCacheColumn : FEditorDataStorageColumn
---@field Value uint64
local FTypedElementU64IntValueCacheColumn = {}



---@class FTypedElementUObjectColumn : FEditorDataStorageColumn
local FTypedElementUObjectColumn = {}


---@class FTypedElementUObjectIdColumn : FEditorDataStorageColumn
---@field ID uint32
---@field SerialNumber int32
local FTypedElementUObjectIdColumn = {}



---@class FTypedElementViewportOutlineColorColumn : FEditorDataStorageColumn
---@field SelectionOutlineColorIndex uint8
local FTypedElementViewportOutlineColorColumn = {}



---@class FTypedElementViewportOverlayColorColumn : FEditorDataStorageColumn
---@field OverlayColor FColor
local FTypedElementViewportOverlayColorColumn = {}



---@class FTypedElementWidgetConstructor
local FTypedElementWidgetConstructor = {}


---@class FTypedElementWorldColumn : FEditorDataStorageColumn
local FTypedElementWorldColumn = {}


---@class FUnresolvedTableRowParentColumn : FEditorDataStorageColumn
---@field ParentIdHash uint64
local FUnresolvedTableRowParentColumn = {}



---@class ITestTypedElementInterfaceA : IInterface
local ITestTypedElementInterfaceA = {}

---@param InElementHandle FScriptTypedElementHandle
---@param InNewName FText
---@param bNotify boolean
---@return boolean
function ITestTypedElementInterfaceA:SetDisplayName(InElementHandle, InNewName, bNotify) end
---@param InElementHandle FScriptTypedElementHandle
---@return FText
function ITestTypedElementInterfaceA:GetDisplayName(InElementHandle) end


---@class ITestTypedElementInterfaceB : IInterface
local ITestTypedElementInterfaceB = {}

---@param InElementHandle FScriptTypedElementHandle
---@return boolean
function ITestTypedElementInterfaceB:MarkAsTested(InElementHandle) end


---@class ITestTypedElementInterfaceC : IInterface
local ITestTypedElementInterfaceC = {}

---@param InElementHandle FScriptTypedElementHandle
---@return boolean
function ITestTypedElementInterfaceC:GetIsTested(InElementHandle) end


---@class ITypedElementCounterInterface : IInterface
local ITypedElementCounterInterface = {}


---@class UEditorDataStorageFactory : UObject
local UEditorDataStorageFactory = {}


---@class UTestTypedElementInterfaceA_ImplTyped : UObject
local UTestTypedElementInterfaceA_ImplTyped = {}


---@class UTestTypedElementInterfaceA_ImplUntyped : UObject
local UTestTypedElementInterfaceA_ImplUntyped = {}


---@class UTestTypedElementInterfaceBAndC_Typed : UObject
local UTestTypedElementInterfaceBAndC_Typed = {}


---@class UTest_PingPongBetweenPhaseFactory : UEditorDataStorageFactory
local UTest_PingPongBetweenPhaseFactory = {}


---@class UTypedElementHandleLibrary : UObject
local UTypedElementHandleLibrary = {}

---@param ElementHandle FScriptTypedElementHandle
function UTypedElementHandleLibrary:Release(ElementHandle) end
---@param LHS FScriptTypedElementHandle
---@param RHS FScriptTypedElementHandle
---@return boolean
function UTypedElementHandleLibrary:NotEqual(LHS, RHS) end
---@param ElementHandle FScriptTypedElementHandle
---@return boolean
function UTypedElementHandleLibrary:IsSet(ElementHandle) end
---@param LHS FScriptTypedElementHandle
---@param RHS FScriptTypedElementHandle
---@return boolean
function UTypedElementHandleLibrary:Equal(LHS, RHS) end


---@class UTypedElementListLibrary : UObject
local UTypedElementListLibrary = {}

---@param ElementList FScriptTypedElementListProxy
function UTypedElementListLibrary:Shrink(ElementList) end
---@param ElementList FScriptTypedElementListProxy
function UTypedElementListLibrary:Reset(ElementList) end
---@param ElementList FScriptTypedElementListProxy
---@param Size int32
function UTypedElementListLibrary:Reserve(ElementList, Size) end
---@param ElementList FScriptTypedElementListProxy
---@param ElementHandle FScriptTypedElementHandle
---@return boolean
function UTypedElementListLibrary:Remove(ElementList, ElementHandle) end
---@param ElementList FScriptTypedElementListProxy
---@return int32
function UTypedElementListLibrary:Num(ElementList) end
---@param ElementList FScriptTypedElementListProxy
---@param Index int32
---@return boolean
function UTypedElementListLibrary:IsValidIndex(ElementList, Index) end
---@param ElementList FScriptTypedElementListProxy
---@param ElementTypeName FName
---@return boolean
function UTypedElementListLibrary:HasElementsOfType(ElementList, ElementTypeName) end
---@param ElementList FScriptTypedElementListProxy
---@param BaseInterfaceType TSubclassOf<UInterface>
---@return boolean
function UTypedElementListLibrary:HasElements(ElementList, BaseInterfaceType) end
---@param ElementList FScriptTypedElementListProxy
---@param ElementHandle FScriptTypedElementHandle
---@param BaseInterfaceType TSubclassOf<UInterface>
---@return UObject
function UTypedElementListLibrary:GetElementInterface(ElementList, ElementHandle, BaseInterfaceType) end
---@param ElementList FScriptTypedElementListProxy
---@param BaseInterfaceType TSubclassOf<UInterface>
---@return TArray<FScriptTypedElementHandle>
function UTypedElementListLibrary:GetElementHandles(ElementList, BaseInterfaceType) end
---@param ElementList FScriptTypedElementListProxy
---@param Index int32
---@return FScriptTypedElementHandle
function UTypedElementListLibrary:GetElementHandleAt(ElementList, Index) end
---@param ElementList FScriptTypedElementListProxy
---@param Slack int32
function UTypedElementListLibrary:Empty(ElementList, Slack) end
---@param Registry UTypedElementRegistry
---@return FScriptTypedElementListProxy
function UTypedElementListLibrary:CreateScriptElementList(Registry) end
---@param ElementList FScriptTypedElementListProxy
---@param ElementTypeName FName
---@return int32
function UTypedElementListLibrary:CountElementsOfType(ElementList, ElementTypeName) end
---@param ElementList FScriptTypedElementListProxy
---@param BaseInterfaceType TSubclassOf<UInterface>
---@return int32
function UTypedElementListLibrary:CountElements(ElementList, BaseInterfaceType) end
---@param ElementList FScriptTypedElementListProxy
---@param ElementHandle FScriptTypedElementHandle
---@return boolean
function UTypedElementListLibrary:Contains(ElementList, ElementHandle) end
---@param ElementList FScriptTypedElementListProxy
---@return FScriptTypedElementListProxy
function UTypedElementListLibrary:Clone(ElementList) end
---@param ElementList FScriptTypedElementListProxy
---@param OtherElementList FScriptTypedElementListProxy
function UTypedElementListLibrary:AppendList(ElementList, OtherElementList) end
---@param ElementList FScriptTypedElementListProxy
---@param ElementHandles TArray<FScriptTypedElementHandle>
function UTypedElementListLibrary:Append(ElementList, ElementHandles) end
---@param ElementList FScriptTypedElementListProxy
---@param ElementHandle FScriptTypedElementHandle
---@return boolean
function UTypedElementListLibrary:Add(ElementList, ElementHandle) end


---@class UTypedElementRegistry : UObject
local UTypedElementRegistry = {}

---@return UTypedElementRegistry
function UTypedElementRegistry:GetInstance() end
---@param InElementHandle FScriptTypedElementHandle
---@param InBaseInterfaceType TSubclassOf<UInterface>
---@return UObject
function UTypedElementRegistry:GetElementInterface(InElementHandle, InBaseInterfaceType) end


