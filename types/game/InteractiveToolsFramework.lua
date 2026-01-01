---@meta

---@class ACombinedTransformGizmoActor : AGizmoActor
---@field TranslateX UPrimitiveComponent
---@field TranslateY UPrimitiveComponent
---@field TranslateZ UPrimitiveComponent
---@field TranslateYZ UPrimitiveComponent
---@field TranslateXZ UPrimitiveComponent
---@field TranslateXY UPrimitiveComponent
---@field RotateX UPrimitiveComponent
---@field RotateY UPrimitiveComponent
---@field RotateZ UPrimitiveComponent
---@field RotationSphere UPrimitiveComponent
---@field UniformScale UPrimitiveComponent
---@field AxisScaleX UPrimitiveComponent
---@field AxisScaleY UPrimitiveComponent
---@field AxisScaleZ UPrimitiveComponent
---@field PlaneScaleYZ UPrimitiveComponent
---@field PlaneScaleXZ UPrimitiveComponent
---@field PlaneScaleXY UPrimitiveComponent
local ACombinedTransformGizmoActor = {}



---@class AGizmoActor : AInternalToolFrameworkActor
local AGizmoActor = {}


---@class AInternalToolFrameworkActor : AActor
---@field bIsSelectableInEditor boolean
local AInternalToolFrameworkActor = {}



---@class AIntervalGizmoActor : AGizmoActor
---@field UpIntervalComponent UGizmoLineHandleComponent
---@field DownIntervalComponent UGizmoLineHandleComponent
---@field ForwardIntervalComponent UGizmoLineHandleComponent
local AIntervalGizmoActor = {}



---@class FActiveGizmo
---@field Gizmo UInteractiveGizmo
local FActiveGizmo = {}



---@class FBehaviorInfo
---@field Behavior UInputBehavior
local FBehaviorInfo = {}



---@class FBrushStampData
local FBrushStampData = {}


---@class FDeviceButtonState
---@field Button FKey
---@field bPressed boolean
---@field bDown boolean
---@field bReleased boolean
---@field bDoubleClicked boolean
local FDeviceButtonState = {}



---@class FGizmoElementColorAttribute
---@field Value FLinearColor
---@field bHasValue boolean
---@field bOverridesChildState boolean
local FGizmoElementColorAttribute = {}



---@class FGizmoElementLineRenderStateAttributes
---@field LineColor FGizmoElementColorAttribute
---@field HoverLineColor FGizmoElementColorAttribute
---@field InteractLineColor FGizmoElementColorAttribute
local FGizmoElementLineRenderStateAttributes = {}



---@class FGizmoElementMaterialAttribute
---@field Value TWeakObjectPtr<UMaterialInterface>
---@field bOverridesChildState boolean
local FGizmoElementMaterialAttribute = {}



---@class FGizmoElementMeshRenderStateAttributes
---@field Material FGizmoElementMaterialAttribute
---@field HoverMaterial FGizmoElementMaterialAttribute
---@field InteractMaterial FGizmoElementMaterialAttribute
---@field VertexColor FGizmoElementColorAttribute
---@field HoverVertexColor FGizmoElementColorAttribute
---@field InteractVertexColor FGizmoElementColorAttribute
local FGizmoElementMeshRenderStateAttributes = {}



---@class FGizmoFloatParameterChange
---@field InitialValue float
---@field CurrentValue float
local FGizmoFloatParameterChange = {}



---@class FGizmoVec2ParameterChange
---@field InitialValue FVector2D
---@field CurrentValue FVector2D
local FGizmoVec2ParameterChange = {}



---@class FInputDeviceRay
---@field WorldRay FRay
---@field bHas2D boolean
---@field ScreenPosition FVector2D
local FInputDeviceRay = {}



---@class FInputDeviceState
---@field InputDevice EInputDevices
---@field bShiftKeyDown boolean
---@field bAltKeyDown boolean
---@field bCtrlKeyDown boolean
---@field bCmdKeyDown boolean
---@field Keyboard FKeyboardInputDeviceState
---@field Mouse FMouseInputDeviceState
local FInputDeviceState = {}



---@class FInputRayHit
---@field bHit boolean
---@field HitDepth double
---@field HitNormal FVector
---@field bHasHitNormal boolean
---@field HitIdentifier int32
---@field HitObject TWeakObjectPtr<UObject>
local FInputRayHit = {}



---@class FKeyboardInputDeviceState
---@field ActiveKey FDeviceButtonState
local FKeyboardInputDeviceState = {}



---@class FMouseInputDeviceState
---@field Left FDeviceButtonState
---@field Middle FDeviceButtonState
---@field Right FDeviceButtonState
---@field WheelDelta float
---@field Position2D FVector2D
---@field Delta2D FVector2D
---@field WorldRay FRay
local FMouseInputDeviceState = {}



---@class IAssetBackedTarget : IInterface
local IAssetBackedTarget = {}


---@class IGizmoAxisSource : IInterface
local IGizmoAxisSource = {}

---@return boolean
function IGizmoAxisSource:HasTangentVectors() end
---@param TangentXOut FVector
---@param TangentYOut FVector
function IGizmoAxisSource:GetTangentVectors(TangentXOut, TangentYOut) end
---@return FVector
function IGizmoAxisSource:GetOrigin() end
---@return FVector
function IGizmoAxisSource:GetDirection() end


---@class IGizmoBaseComponentInterface : IInterface
local IGizmoBaseComponentInterface = {}


---@class IGizmoClickMultiTarget : IInterface
local IGizmoClickMultiTarget = {}

---@param bInteracting boolean
---@param InPartIdentifier uint32
function IGizmoClickMultiTarget:UpdateInteractingState(bInteracting, InPartIdentifier) end
---@param bHovering boolean
---@param InPartIdentifier uint32
function IGizmoClickMultiTarget:UpdateHoverState(bHovering, InPartIdentifier) end
---@param bHittable boolean
---@param InPartIdentifier uint32
function IGizmoClickMultiTarget:UpdateHittableState(bHittable, InPartIdentifier) end


---@class IGizmoClickTarget : IInterface
local IGizmoClickTarget = {}

---@param bInteracting boolean
function IGizmoClickTarget:UpdateInteractingState(bInteracting) end
---@param bHovering boolean
function IGizmoClickTarget:UpdateHoverState(bHovering) end


---@class IGizmoFloatParameterSource : IInterface
local IGizmoFloatParameterSource = {}

---@param NewValue float
function IGizmoFloatParameterSource:SetParameter(NewValue) end
---@return float
function IGizmoFloatParameterSource:GetParameter() end
function IGizmoFloatParameterSource:EndModify() end
function IGizmoFloatParameterSource:BeginModify() end


---@class IGizmoRenderMultiTarget : IInterface
local IGizmoRenderMultiTarget = {}

---@param bVisible boolean
---@param InPartIdentifier uint32
function IGizmoRenderMultiTarget:UpdateVisibilityState(bVisible, InPartIdentifier) end


---@class IGizmoRenderTarget : IInterface
local IGizmoRenderTarget = {}


---@class IGizmoStateTarget : IInterface
local IGizmoStateTarget = {}

function IGizmoStateTarget:EndUpdate() end
function IGizmoStateTarget:BeginUpdate() end


---@class IGizmoTransformSource : IInterface
local IGizmoTransformSource = {}

---@param NewTransform FTransform
function IGizmoTransformSource:SetTransform(NewTransform) end
---@return FTransform
function IGizmoTransformSource:GetTransform() end


---@class IGizmoVec2ParameterSource : IInterface
local IGizmoVec2ParameterSource = {}

---@param NewValue FVector2D
function IGizmoVec2ParameterSource:SetParameter(NewValue) end
---@return FVector2D
function IGizmoVec2ParameterSource:GetParameter() end
function IGizmoVec2ParameterSource:EndModify() end
function IGizmoVec2ParameterSource:BeginModify() end


---@class IInputBehaviorSource : IInterface
local IInputBehaviorSource = {}


---@class IInteractiveToolCameraFocusAPI : IInterface
local IInteractiveToolCameraFocusAPI = {}


---@class IInteractiveToolEditorGizmoAPI : IInterface
local IInteractiveToolEditorGizmoAPI = {}


---@class IInteractiveToolExclusiveToolAPI : IInterface
local IInteractiveToolExclusiveToolAPI = {}


---@class IInteractiveToolManageGeometrySelectionAPI : IInterface
local IInteractiveToolManageGeometrySelectionAPI = {}


---@class IInteractiveToolNestedAcceptCancelAPI : IInterface
local IInteractiveToolNestedAcceptCancelAPI = {}


---@class IInteractiveToolShutdownQueryAPI : IInterface
local IInteractiveToolShutdownQueryAPI = {}


---@class IMaterialProvider : IInterface
local IMaterialProvider = {}


---@class IMeshDescriptionCommitter : IInterface
local IMeshDescriptionCommitter = {}


---@class IMeshDescriptionProvider : IInterface
local IMeshDescriptionProvider = {}


---@class IPhysicsDataSource : IInterface
local IPhysicsDataSource = {}


---@class IPrimitiveComponentBackedTarget : IInterface
local IPrimitiveComponentBackedTarget = {}


---@class ISkeletalMeshBackedTarget : IAssetBackedTarget
local ISkeletalMeshBackedTarget = {}


---@class IStaticMeshBackedTarget : IAssetBackedTarget
local IStaticMeshBackedTarget = {}


---@class IToolContextTransactionProvider : IInterface
local IToolContextTransactionProvider = {}


---@class IToolFrameworkComponent : IInterface
local IToolFrameworkComponent = {}


---@class IWidgetBaseBehavior : IInterface
local IWidgetBaseBehavior = {}


---@class UAnyButtonInputBehavior : UInputBehavior
local UAnyButtonInputBehavior = {}


---@class UAxisAngleGizmo : UInteractiveGizmo
---@field AxisSource TScriptInterface<IGizmoAxisSource>
---@field AngleSource TScriptInterface<IGizmoFloatParameterSource>
---@field HitTarget TScriptInterface<IGizmoClickTarget>
---@field StateTarget TScriptInterface<IGizmoStateTarget>
---@field MouseBehavior UClickDragInputBehavior
---@field bInInteraction boolean
---@field RotationOrigin FVector
---@field RotationAxis FVector
---@field RotationPlaneX FVector
---@field RotationPlaneY FVector
---@field InteractionStartPoint FVector
---@field InteractionCurPoint FVector
---@field InteractionStartAngle float
---@field InteractionCurAngle float
local UAxisAngleGizmo = {}



---@class UAxisAngleGizmoBuilder : UInteractiveGizmoBuilder
local UAxisAngleGizmoBuilder = {}


---@class UAxisPositionGizmo : UInteractiveGizmo
---@field AxisSource TScriptInterface<IGizmoAxisSource>
---@field ParameterSource TScriptInterface<IGizmoFloatParameterSource>
---@field GizmoViewContext UGizmoViewContext
---@field HitTarget TScriptInterface<IGizmoClickTarget>
---@field StateTarget TScriptInterface<IGizmoStateTarget>
---@field MouseBehavior UClickDragInputBehavior
---@field bEnableSignedAxis boolean
---@field bInInteraction boolean
---@field InteractionOrigin FVector
---@field InteractionAxis FVector
---@field InteractionStartPoint FVector
---@field InteractionCurPoint FVector
---@field InteractionStartParameter float
---@field InteractionCurParameter float
---@field ParameterSign float
local UAxisPositionGizmo = {}



---@class UAxisPositionGizmoBuilder : UInteractiveGizmoBuilder
local UAxisPositionGizmoBuilder = {}


---@class UBaseBrushTool : UMeshSurfacePointTool
---@field BrushProperties UBrushBaseProperties
---@field bInBrushStroke boolean
---@field WorldToLocalScale float
---@field LastBrushStamp FBrushStampData
---@field PropertyClass TSoftClassPtr<UBrushBaseProperties>
---@field BrushStampIndicator UBrushStampIndicator
local UBaseBrushTool = {}



---@class UBrushAdjusterInputBehavior : UAnyButtonInputBehavior
local UBrushAdjusterInputBehavior = {}


---@class UBrushBaseProperties : UInteractiveToolPropertySet
---@field BrushSize float
---@field bSpecifyRadius boolean
---@field BrushRadius float
---@field BrushStrength float
---@field BrushFalloffAmount float
---@field bShowStrength boolean
---@field bShowFalloff boolean
local UBrushBaseProperties = {}



---@class UBrushStampIndicator : UInteractiveGizmo
---@field bVisible boolean
---@field BrushRadius float
---@field BrushFalloff float
---@field BrushStrength float
---@field BrushPosition FVector
---@field BrushNormal FVector
---@field bDrawIndicatorLines boolean
---@field bDrawRadiusCircle boolean
---@field bScaleNormalByStrength boolean
---@field SampleStepCount int32
---@field LineColor FLinearColor
---@field LineThickness float
---@field bDepthTested boolean
---@field bDrawSecondaryLines boolean
---@field SecondaryLineThickness float
---@field SecondaryLineColor FLinearColor
---@field AttachedComponent UPrimitiveComponent
local UBrushStampIndicator = {}



---@class UBrushStampIndicatorBuilder : UInteractiveGizmoBuilder
local UBrushStampIndicatorBuilder = {}


---@class UClickDragInputBehavior : UAnyButtonInputBehavior
---@field bUpdateModifiersDuringDrag boolean
local UClickDragInputBehavior = {}



---@class UClickDragTool : UInteractiveTool
local UClickDragTool = {}


---@class UClickDragToolBuilder : UInteractiveToolBuilder
local UClickDragToolBuilder = {}


---@class UCombinedTransformGizmo : UInteractiveGizmo
---@field ActiveTarget UTransformProxy
---@field bSnapToWorldGrid boolean
---@field bGridSizeIsExplicit boolean
---@field ExplicitGridSize FVector
---@field bRotationGridSizeIsExplicit boolean
---@field ExplicitRotationGridSize FRotator
---@field bSnapToWorldRotGrid boolean
---@field bSnapToScaleGrid boolean
---@field bUseContextCoordinateSystem boolean
---@field CurrentCoordinateSystem EToolContextCoordinateSystem
---@field bUseContextGizmoMode boolean
---@field ActiveGizmoMode EToolContextTransformGizmoMode
---@field ActiveComponents TArray<UPrimitiveComponent>
---@field ActiveGizmos TArray<UInteractiveGizmo>
---@field CameraAxisSource UGizmoConstantFrameAxisSource
---@field AxisXSource UGizmoComponentAxisSource
---@field AxisYSource UGizmoComponentAxisSource
---@field AxisZSource UGizmoComponentAxisSource
---@field UnitAxisXSource UGizmoComponentAxisSource
---@field UnitAxisYSource UGizmoComponentAxisSource
---@field UnitAxisZSource UGizmoComponentAxisSource
---@field StateTarget UGizmoTransformChangeStateTarget
local UCombinedTransformGizmo = {}



---@class UCombinedTransformGizmoBuilder : UInteractiveGizmoBuilder
local UCombinedTransformGizmoBuilder = {}


---@class UCombinedTransformGizmoContextObject : UObject
local UCombinedTransformGizmoContextObject = {}


---@class UComponentBoundTransformProxy : UTransformProxy
local UComponentBoundTransformProxy = {}


---@class UContextObjectStore : UObject
---@field ContextObjects TArray<UObject>
local UContextObjectStore = {}



---@class UDoubleClickInputBehavior : USingleClickInputBehavior
local UDoubleClickInputBehavior = {}


---@class UGizmoArrowComponent : UGizmoBaseComponent
---@field Direction FVector
---@field Gap float
---@field Length float
---@field Thickness float
local UGizmoArrowComponent = {}



---@class UGizmoAxisIntervalParameterSource : UGizmoBaseFloatParameterSource
---@field FloatParameterSource TScriptInterface<IGizmoFloatParameterSource>
---@field MinParameter float
---@field MaxParameter float
local UGizmoAxisIntervalParameterSource = {}



---@class UGizmoAxisRotationParameterSource : UGizmoBaseFloatParameterSource
---@field AxisSource TScriptInterface<IGizmoAxisSource>
---@field TransformSource TScriptInterface<IGizmoTransformSource>
---@field Angle float
---@field LastChange FGizmoFloatParameterChange
---@field CurRotationAxis FVector
---@field CurRotationOrigin FVector
---@field InitialTransform FTransform
local UGizmoAxisRotationParameterSource = {}



---@class UGizmoAxisScaleParameterSource : UGizmoBaseFloatParameterSource
---@field AxisSource TScriptInterface<IGizmoAxisSource>
---@field TransformSource TScriptInterface<IGizmoTransformSource>
---@field ScaleMultiplier float
---@field bClampToZero boolean
---@field Parameter float
---@field LastChange FGizmoFloatParameterChange
---@field CurScaleAxis FVector
---@field CurScaleOrigin FVector
---@field InitialTransform FTransform
local UGizmoAxisScaleParameterSource = {}



---@class UGizmoAxisTranslationParameterSource : UGizmoBaseFloatParameterSource
---@field AxisSource TScriptInterface<IGizmoAxisSource>
---@field TransformSource TScriptInterface<IGizmoTransformSource>
---@field Parameter float
---@field LastChange FGizmoFloatParameterChange
---@field CurTranslationAxis FVector
---@field CurTranslationOrigin FVector
---@field InitialTransform FTransform
local UGizmoAxisTranslationParameterSource = {}



---@class UGizmoBaseComponent : UPrimitiveComponent
---@field Color FLinearColor
---@field HoverSizeMultiplier float
---@field PixelHitDistanceThreshold float
---@field GizmoViewContext UGizmoViewContext
local UGizmoBaseComponent = {}

---@param bWorldIn boolean
function UGizmoBaseComponent:UpdateWorldLocalState(bWorldIn) end
---@param bHoveringIn boolean
function UGizmoBaseComponent:UpdateHoverState(bHoveringIn) end


---@class UGizmoBaseFloatParameterSource : UObject
local UGizmoBaseFloatParameterSource = {}


---@class UGizmoBaseTransformSource : UObject
local UGizmoBaseTransformSource = {}


---@class UGizmoBaseVec2ParameterSource : UObject
local UGizmoBaseVec2ParameterSource = {}


---@class UGizmoBoxComponent : UGizmoBaseComponent
---@field Origin FVector
---@field Rotation FQuat
---@field Dimensions FVector
---@field LineThickness float
---@field bRemoveHiddenLines boolean
---@field bEnableAxisFlip boolean
local UGizmoBoxComponent = {}



---@class UGizmoCircleComponent : UGizmoBaseComponent
---@field Normal FVector
---@field Radius float
---@field Thickness float
---@field NumSides int32
---@field bViewAligned boolean
---@field bDrawFullCircle boolean
---@field bOnlyAllowFrontFacingHits boolean
local UGizmoCircleComponent = {}



---@class UGizmoComponentAxisSource : UObject
---@field Component USceneComponent
---@field AxisIndex int32
---@field bLocalAxes boolean
local UGizmoComponentAxisSource = {}



---@class UGizmoComponentHitTarget : UObject
---@field Component UPrimitiveComponent
local UGizmoComponentHitTarget = {}



---@class UGizmoComponentWorldTransformSource : UGizmoBaseTransformSource
---@field Component USceneComponent
---@field bModifyComponentOnTransform boolean
local UGizmoComponentWorldTransformSource = {}



---@class UGizmoConstantAxisSource : UObject
---@field Origin FVector
---@field Direction FVector
local UGizmoConstantAxisSource = {}



---@class UGizmoConstantFrameAxisSource : UObject
---@field Origin FVector
---@field Direction FVector
---@field TangentX FVector
---@field TangentY FVector
local UGizmoConstantFrameAxisSource = {}



---@class UGizmoElementArc : UGizmoElementCircleBase
---@field InnerRadius double
local UGizmoElementArc = {}



---@class UGizmoElementArrow : UGizmoElementBase
---@field CylinderElement UGizmoElementCylinder
---@field ConeElement UGizmoElementCone
---@field BoxElement UGizmoElementBox
---@field base FVector
---@field Direction FVector
---@field SideDirection FVector
---@field BodyLength float
---@field BodyRadius float
---@field HeadLength float
---@field HeadRadius float
---@field NumSides int32
---@field HeadType EGizmoElementArrowHeadType
local UGizmoElementArrow = {}



---@class UGizmoElementBase : UObject
---@field bEnabled boolean
---@field bEnabledForPerspectiveProjection boolean
---@field bEnabledForOrthographicProjection boolean
---@field bEnabledForDefaultState boolean
---@field bEnabledForHoveringState boolean
---@field bEnabledForInteractingState boolean
---@field PartIdentifier uint32
---@field MeshRenderAttributes FGizmoElementMeshRenderStateAttributes
---@field ElementState EGizmoElementState
---@field ElementInteractionState EGizmoElementInteractionState
---@field ViewDependentType EGizmoElementViewDependentType
---@field ViewDependentAxis FVector
---@field ViewDependentAngleTol float
---@field ViewDependentAxialMaxCosAngleTol float
---@field ViewDependentPlanarMinCosAngleTol float
---@field ViewAlignType EGizmoElementViewAlignType
---@field ViewAlignAxis FVector
---@field ViewAlignNormal FVector
---@field ViewAlignAxialAngleTol float
---@field ViewAlignAxialMaxCosAngleTol float
---@field PixelHitDistanceThreshold float
local UGizmoElementBase = {}



---@class UGizmoElementBox : UGizmoElementBase
---@field Center FVector
---@field Dimensions FVector
---@field UpDirection FVector
---@field SideDirection FVector
local UGizmoElementBox = {}



---@class UGizmoElementCircle : UGizmoElementCircleBase
---@field bDrawMesh boolean
---@field bDrawLine boolean
---@field bHitMesh boolean
---@field bHitLine boolean
local UGizmoElementCircle = {}



---@class UGizmoElementCircleBase : UGizmoElementLineBase
---@field Center FVector
---@field Axis0 FVector
---@field Axis1 FVector
---@field Radius double
---@field NumSegments int32
---@field PartialType EGizmoElementPartialType
---@field PartialStartAngle double
---@field PartialEndAngle double
---@field PartialViewDependentMaxCosTol double
local UGizmoElementCircleBase = {}



---@class UGizmoElementCone : UGizmoElementBase
---@field Origin FVector
---@field Direction FVector
---@field Height float
---@field Radius float
---@field NumSides int32
local UGizmoElementCone = {}



---@class UGizmoElementCylinder : UGizmoElementBase
---@field base FVector
---@field Direction FVector
---@field Height float
---@field Radius float
---@field NumSides int32
local UGizmoElementCylinder = {}



---@class UGizmoElementGroup : UGizmoElementLineBase
---@field bConstantScale boolean
---@field bHitOwner boolean
---@field Elements TArray<UGizmoElementBase>
local UGizmoElementGroup = {}



---@class UGizmoElementHitMultiTarget : UObject
---@field GizmoElement UGizmoElementBase
---@field GizmoViewContext UGizmoViewContext
---@field GizmoTransformProxy UTransformProxy
local UGizmoElementHitMultiTarget = {}



---@class UGizmoElementHitTarget : UObject
---@field GizmoElement UGizmoElementBase
---@field GizmoViewContext UGizmoViewContext
---@field GizmoTransformProxy UTransformProxy
local UGizmoElementHitTarget = {}



---@class UGizmoElementLineBase : UGizmoElementBase
---@field LineRenderAttributes FGizmoElementLineRenderStateAttributes
---@field LineThickness float
---@field bScreenSpaceLine boolean
---@field HoverLineThicknessMultiplier float
---@field InteractLineThicknessMultiplier float
local UGizmoElementLineBase = {}



---@class UGizmoElementLineStrip : UGizmoElementLineBase
---@field Vertices TArray<FVector>
---@field base FVector
---@field UpDirection FVector
---@field SideDirection FVector
---@field bDrawLineStrip boolean
local UGizmoElementLineStrip = {}



---@class UGizmoElementRectangle : UGizmoElementLineBase
---@field Center FVector
---@field Width float
---@field Height float
---@field UpDirection FVector
---@field SideDirection FVector
---@field bDrawMesh boolean
---@field bDrawLine boolean
---@field bHitMesh boolean
---@field bHitLine boolean
local UGizmoElementRectangle = {}



---@class UGizmoElementSphere : UGizmoElementBase
---@field Center FVector
---@field Radius float
---@field NumSides int32
local UGizmoElementSphere = {}



---@class UGizmoElementTorus : UGizmoElementCircleBase
---@field InnerRadius double
---@field NumInnerSlices int32
---@field bEndCaps boolean
local UGizmoElementTorus = {}



---@class UGizmoElementTriangleList : UGizmoElementBase
---@field Vertices TArray<FVector>
---@field base FVector
---@field UpDirection FVector
---@field SideDirection FVector
local UGizmoElementTriangleList = {}



---@class UGizmoLambdaHitTarget : UObject
local UGizmoLambdaHitTarget = {}


---@class UGizmoLambdaStateTarget : UObject
local UGizmoLambdaStateTarget = {}


---@class UGizmoLineHandleComponent : UGizmoBaseComponent
---@field Normal FVector
---@field HandleSize float
---@field Thickness float
---@field Direction FVector
---@field Length float
---@field bImageScale boolean
local UGizmoLineHandleComponent = {}



---@class UGizmoLocalFloatParameterSource : UGizmoBaseFloatParameterSource
---@field Value float
---@field LastChange FGizmoFloatParameterChange
local UGizmoLocalFloatParameterSource = {}



---@class UGizmoLocalVec2ParameterSource : UGizmoBaseVec2ParameterSource
---@field Value FVector2D
---@field LastChange FGizmoVec2ParameterChange
local UGizmoLocalVec2ParameterSource = {}



---@class UGizmoNilStateTarget : UObject
local UGizmoNilStateTarget = {}


---@class UGizmoObjectModifyStateTarget : UObject
---@field TransactionManager TScriptInterface<IToolContextTransactionProvider>
local UGizmoObjectModifyStateTarget = {}



---@class UGizmoPlaneScaleParameterSource : UGizmoBaseVec2ParameterSource
---@field AxisSource TScriptInterface<IGizmoAxisSource>
---@field TransformSource TScriptInterface<IGizmoTransformSource>
---@field ScaleMultiplier float
---@field bUseEqualScaling boolean
---@field bClampToZero boolean
---@field Parameter FVector2D
---@field LastChange FGizmoVec2ParameterChange
---@field CurScaleOrigin FVector
---@field CurScaleNormal FVector
---@field CurScaleAxisX FVector
---@field CurScaleAxisY FVector
---@field InitialTransform FTransform
local UGizmoPlaneScaleParameterSource = {}



---@class UGizmoPlaneTranslationParameterSource : UGizmoBaseVec2ParameterSource
---@field AxisSource TScriptInterface<IGizmoAxisSource>
---@field TransformSource TScriptInterface<IGizmoTransformSource>
---@field Parameter FVector2D
---@field LastChange FGizmoVec2ParameterChange
---@field CurTranslationOrigin FVector
---@field CurTranslationNormal FVector
---@field CurTranslationAxisX FVector
---@field CurTranslationAxisY FVector
---@field InitialTransform FTransform
local UGizmoPlaneTranslationParameterSource = {}



---@class UGizmoRectangleComponent : UGizmoBaseComponent
---@field directionX FVector
---@field directionY FVector
---@field bOrientYAccordingToCamera boolean
---@field OffsetX float
---@field OffsetY float
---@field LengthX float
---@field LengthY float
---@field Thickness float
---@field SegmentFlags uint8
local UGizmoRectangleComponent = {}



---@class UGizmoScaledAndUnscaledTransformSources : UGizmoBaseTransformSource
---@field ScaledTransformSource TScriptInterface<IGizmoTransformSource>
---@field UnscaledTransformSource TScriptInterface<IGizmoTransformSource>
local UGizmoScaledAndUnscaledTransformSources = {}



---@class UGizmoScaledTransformSource : UGizmoBaseTransformSource
---@field ChildTransformSource TScriptInterface<IGizmoTransformSource>
local UGizmoScaledTransformSource = {}



---@class UGizmoTransformChangeStateTarget : UObject
---@field TransactionManager TScriptInterface<IToolContextTransactionProvider>
local UGizmoTransformChangeStateTarget = {}



---@class UGizmoTransformProxyTransformSource : UGizmoBaseTransformSource
---@field Proxy UTransformProxy
local UGizmoTransformProxyTransformSource = {}



---@class UGizmoUniformScaleParameterSource : UGizmoBaseVec2ParameterSource
---@field AxisSource TScriptInterface<IGizmoAxisSource>
---@field TransformSource TScriptInterface<IGizmoTransformSource>
---@field ScaleMultiplier float
---@field Parameter FVector2D
---@field LastChange FGizmoVec2ParameterChange
---@field CurScaleOrigin FVector
---@field CurScaleNormal FVector
---@field CurScaleAxisX FVector
---@field CurScaleAxisY FVector
---@field InitialTransform FTransform
local UGizmoUniformScaleParameterSource = {}



---@class UGizmoViewContext : UObject
local UGizmoViewContext = {}


---@class UGizmoWorldAxisSource : UObject
---@field Origin FVector
---@field AxisIndex int32
local UGizmoWorldAxisSource = {}



---@class UInputBehavior : UObject
local UInputBehavior = {}


---@class UInputBehaviorSet : UObject
---@field Behaviors TArray<FBehaviorInfo>
local UInputBehaviorSet = {}



---@class UInputRouter : UObject
---@field bAutoInvalidateOnHover boolean
---@field bAutoInvalidateOnCapture boolean
---@field ActiveInputBehaviors UInputBehaviorSet
local UInputRouter = {}



---@class UInteractionMechanic : UObject
local UInteractionMechanic = {}


---@class UInteractiveCommand : UObject
local UInteractiveCommand = {}


---@class UInteractiveCommandArguments : UObject
local UInteractiveCommandArguments = {}


---@class UInteractiveCommandResult : UObject
local UInteractiveCommandResult = {}


---@class UInteractiveGizmo : UObject
---@field InputBehaviors UInputBehaviorSet
local UInteractiveGizmo = {}



---@class UInteractiveGizmoBuilder : UObject
local UInteractiveGizmoBuilder = {}


---@class UInteractiveGizmoManager : UObject
---@field ActiveGizmos TArray<FActiveGizmo>
---@field GizmoBuilders TMap<FString, UInteractiveGizmoBuilder>
local UInteractiveGizmoManager = {}



---@class UInteractiveTool : UObject
---@field InputBehaviors UInputBehaviorSet
---@field ToolPropertyObjects TArray<UObject>
local UInteractiveTool = {}



---@class UInteractiveToolBuilder : UObject
local UInteractiveToolBuilder = {}


---@class UInteractiveToolManager : UObject
---@field ActiveLeftTool UInteractiveTool
---@field ActiveRightTool UInteractiveTool
---@field ToolBuilders TMap<FString, UInteractiveToolBuilder>
local UInteractiveToolManager = {}



---@class UInteractiveToolPropertySet : UObject
---@field CachedPropertiesMap TMap<FString, UInteractiveToolPropertySet>
---@field bIsPropertySetEnabled boolean
local UInteractiveToolPropertySet = {}



---@class UInteractiveToolWithToolTargetsBuilder : UInteractiveToolBuilder
local UInteractiveToolWithToolTargetsBuilder = {}


---@class UInteractiveToolsContext : UObject
---@field InputRouter UInputRouter
---@field TargetManager UToolTargetManager
---@field ToolManager UInteractiveToolManager
---@field GizmoManager UInteractiveGizmoManager
---@field ContextObjectStore UContextObjectStore
---@field ToolManagerClass TSoftClassPtr<UInteractiveToolManager>
local UInteractiveToolsContext = {}



---@class UIntervalGizmo : UInteractiveGizmo
---@field StateTarget UGizmoTransformChangeStateTarget
---@field TransformProxy UTransformProxy
---@field ActiveComponents TArray<UPrimitiveComponent>
---@field ActiveGizmos TArray<UInteractiveGizmo>
---@field AxisYSource UGizmoComponentAxisSource
---@field AxisZSource UGizmoComponentAxisSource
local UIntervalGizmo = {}



---@class UIntervalGizmoBuilder : UInteractiveGizmoBuilder
local UIntervalGizmoBuilder = {}


---@class UKeyAsModifierInputBehavior : UInputBehavior
local UKeyAsModifierInputBehavior = {}


---@class UKeyInputBehavior : UInputBehavior
local UKeyInputBehavior = {}


---@class ULocalClickDragInputBehavior : UClickDragInputBehavior
local ULocalClickDragInputBehavior = {}


---@class ULocalDoubleClickInputBehavior : UDoubleClickInputBehavior
local ULocalDoubleClickInputBehavior = {}


---@class ULocalInputBehaviorSource : UObject
local ULocalInputBehaviorSource = {}


---@class ULocalMouseHoverBehavior : UMouseHoverBehavior
local ULocalMouseHoverBehavior = {}


---@class ULocalSingleClickInputBehavior : USingleClickInputBehavior
local ULocalSingleClickInputBehavior = {}


---@class UMeshSelectionSet : USelectionSet
---@field Vertices TArray<int32>
---@field Edges TArray<int32>
---@field Faces TArray<int32>
---@field Groups TArray<int32>
local UMeshSelectionSet = {}



---@class UMeshSurfacePointTool : USingleSelectionTool
---@field TargetWorld TWeakObjectPtr<UWorld>
local UMeshSurfacePointTool = {}



---@class UMeshSurfacePointToolBuilder : UInteractiveToolWithToolTargetsBuilder
local UMeshSurfacePointToolBuilder = {}


---@class UMouseHoverBehavior : UInputBehavior
local UMouseHoverBehavior = {}


---@class UMouseWheelInputBehavior : UAnyButtonInputBehavior
local UMouseWheelInputBehavior = {}


---@class UMultiClickSequenceInputBehavior : UAnyButtonInputBehavior
local UMultiClickSequenceInputBehavior = {}


---@class UMultiSelectionTool : UInteractiveTool
---@field Targets TArray<UToolTarget>
local UMultiSelectionTool = {}



---@class UPlanePositionGizmo : UInteractiveGizmo
---@field AxisSource TScriptInterface<IGizmoAxisSource>
---@field ParameterSource TScriptInterface<IGizmoVec2ParameterSource>
---@field HitTarget TScriptInterface<IGizmoClickTarget>
---@field StateTarget TScriptInterface<IGizmoStateTarget>
---@field MouseBehavior UClickDragInputBehavior
---@field bEnableSignedAxis boolean
---@field bFlipX boolean
---@field bFlipY boolean
---@field bInInteraction boolean
---@field InteractionOrigin FVector
---@field InteractionNormal FVector
---@field InteractionAxisX FVector
---@field InteractionAxisY FVector
---@field InteractionStartPoint FVector
---@field InteractionCurPoint FVector
---@field InteractionStartParameter FVector2D
---@field InteractionCurParameter FVector2D
---@field ParameterSigns FVector2D
local UPlanePositionGizmo = {}



---@class UPlanePositionGizmoBuilder : UInteractiveGizmoBuilder
local UPlanePositionGizmoBuilder = {}


---@class UPrimitiveComponentToolTarget : UToolTarget
local UPrimitiveComponentToolTarget = {}


---@class UPrimitiveComponentToolTargetFactory : UToolTargetFactory
local UPrimitiveComponentToolTargetFactory = {}


---@class URepositionableTransformGizmo : UCombinedTransformGizmo
---@field RepositionStateTarget UGizmoTransformChangeStateTarget
local URepositionableTransformGizmo = {}



---@class URepositionableTransformGizmoBuilder : UCombinedTransformGizmoBuilder
local URepositionableTransformGizmoBuilder = {}


---@class UScalableSphereGizmo : UInteractiveGizmo
---@field HitErrorThreshold float
---@field TransactionDescription FText
---@field Radius float
---@field bIsHovering boolean
---@field bIsDragging boolean
---@field ActiveTarget UTransformProxy
---@field ActiveAxis FVector
---@field DragStartWorldPosition FVector
---@field DragCurrentPositionProjected FVector
---@field InteractionStartParameter float
local UScalableSphereGizmo = {}



---@class UScalableSphereGizmoBuilder : UInteractiveGizmoBuilder
local UScalableSphereGizmoBuilder = {}


---@class UScalableSphereGizmoInputBehavior : UAnyButtonInputBehavior
local UScalableSphereGizmoInputBehavior = {}


---@class USceneSnappingManager : UObject
local USceneSnappingManager = {}


---@class USelectionSet : UObject
local USelectionSet = {}


---@class USimpleLambdaInteractiveGizmoBuilder : UInteractiveGizmoBuilder
local USimpleLambdaInteractiveGizmoBuilder = {}


---@class USimpleSingleClickGizmo : UInteractiveGizmo
---@field HitTarget TScriptInterface<IGizmoClickTarget>
---@field ClickBehavior USingleClickInputBehavior
local USimpleSingleClickGizmo = {}



---@class USingleClickInputBehavior : UAnyButtonInputBehavior
---@field HitTestOnRelease boolean
local USingleClickInputBehavior = {}



---@class USingleClickOrDragInputBehavior : UAnyButtonInputBehavior
---@field bBeginDragIfClickTargetNotHit boolean
---@field ClickDistanceThreshold float
local USingleClickOrDragInputBehavior = {}



---@class USingleClickTool : UInteractiveTool
local USingleClickTool = {}


---@class USingleClickToolBuilder : UInteractiveToolBuilder
local USingleClickToolBuilder = {}


---@class USingleKeyCaptureBehavior : UInputBehavior
local USingleKeyCaptureBehavior = {}


---@class USingleSelectionTool : UInteractiveTool
---@field Target UToolTarget
local USingleSelectionTool = {}



---@class UToolTarget : UObject
local UToolTarget = {}


---@class UToolTargetFactory : UObject
local UToolTargetFactory = {}


---@class UToolTargetManager : UObject
---@field Factories TArray<UToolTargetFactory>
local UToolTargetManager = {}



---@class UToolsContextCursorAPI : UObject
local UToolsContextCursorAPI = {}


---@class UTransformProxy : UObject
---@field bRotatePerObject boolean
---@field bSetPivotMode boolean
---@field SharedTransform FTransform
---@field InitialSharedTransform FTransform
local UTransformProxy = {}



---@class UViewAdjustedStaticMeshGizmoComponent : UStaticMeshComponent
---@field GizmoViewContext UGizmoViewContext
---@field SubstituteInteractionComponent UPrimitiveComponent
---@field HoverOverrideMaterial UMaterialInterface
local UViewAdjustedStaticMeshGizmoComponent = {}



