---@meta

---@class IInterchangeAnimationPayloadInterface : IInterface
local IInterchangeAnimationPayloadInterface = {}


---@class IInterchangeBlockedTexturePayloadInterface : IInterface
local IInterchangeBlockedTexturePayloadInterface = {}


---@class IInterchangeMeshPayloadInterface : IInterface
local IInterchangeMeshPayloadInterface = {}


---@class IInterchangeSlicedTexturePayloadInterface : IInterface
local IInterchangeSlicedTexturePayloadInterface = {}


---@class IInterchangeTextureLightProfilePayloadInterface : IInterface
local IInterchangeTextureLightProfilePayloadInterface = {}


---@class IInterchangeTexturePayloadInterface : IInterface
local IInterchangeTexturePayloadInterface = {}


---@class IInterchangeVariantSetPayloadInterface : IInterface
local IInterchangeVariantSetPayloadInterface = {}


---@class UInterchangeActorFactory : UInterchangeFactoryBase
local UInterchangeActorFactory = {}


---@class UInterchangeAnimSequenceFactory : UInterchangeFactoryBase
local UInterchangeAnimSequenceFactory = {}


---@class UInterchangeAssetUserData : UAssetUserData
---@field MetaData TMap<FString, FString>
local UInterchangeAssetUserData = {}



---@class UInterchangeCameraActorFactory : UInterchangeActorFactory
local UInterchangeCameraActorFactory = {}


---@class UInterchangeCineCameraActorFactory : UInterchangeActorFactory
local UInterchangeCineCameraActorFactory = {}


---@class UInterchangeDDSTranslator : UInterchangeTranslatorBase
local UInterchangeDDSTranslator = {}


---@class UInterchangeDecalActorFactory : UInterchangeActorFactory
local UInterchangeDecalActorFactory = {}


---@class UInterchangeFbxTranslator : UInterchangeTranslatorBase
---@field CacheFbxTranslatorSettings UInterchangeFbxTranslatorSettings
local UInterchangeFbxTranslator = {}



---@class UInterchangeFbxTranslatorSettings : UInterchangeTranslatorSettings
---@field bConvertScene boolean
---@field bForceFrontXAxis boolean
---@field bConvertSceneUnit boolean
---@field bKeepFbxNamespace boolean
local UInterchangeFbxTranslatorSettings = {}



---@class UInterchangeGLTFTranslator : UInterchangeTranslatorBase
local UInterchangeGLTFTranslator = {}


---@class UInterchangeIESTranslator : UInterchangeTranslatorBase
local UInterchangeIESTranslator = {}


---@class UInterchangeImageWrapperTranslator : UInterchangeTranslatorBase
local UInterchangeImageWrapperTranslator = {}


---@class UInterchangeJPGTranslator : UInterchangeTranslatorBase
local UInterchangeJPGTranslator = {}


---@class UInterchangeLevelFactory : UInterchangeFactoryBase
local UInterchangeLevelFactory = {}


---@class UInterchangeLevelInstanceActorFactory : UInterchangeActorFactory
local UInterchangeLevelInstanceActorFactory = {}


---@class UInterchangeLevelSequenceFactory : UInterchangeFactoryBase
local UInterchangeLevelSequenceFactory = {}


---@class UInterchangeLightActorFactory : UInterchangeActorFactory
local UInterchangeLightActorFactory = {}


---@class UInterchangeMaterialFactory : UInterchangeFactoryBase
local UInterchangeMaterialFactory = {}


---@class UInterchangeMaterialFunctionFactory : UInterchangeFactoryBase
local UInterchangeMaterialFunctionFactory = {}


---@class UInterchangeMaterialXTranslator : UInterchangeTranslatorBase
local UInterchangeMaterialXTranslator = {}


---@class UInterchangeOBJTranslator : UInterchangeTranslatorBase
local UInterchangeOBJTranslator = {}


---@class UInterchangePSDTranslator : UInterchangeTranslatorBase
local UInterchangePSDTranslator = {}


---@class UInterchangePhysicsAssetFactory : UInterchangeFactoryBase
local UInterchangePhysicsAssetFactory = {}


---@class UInterchangeSceneImportAssetFactory : UInterchangeFactoryBase
local UInterchangeSceneImportAssetFactory = {}


---@class UInterchangeSceneVariantSetsFactory : UInterchangeFactoryBase
local UInterchangeSceneVariantSetsFactory = {}


---@class UInterchangeSkeletalMeshActorFactory : UInterchangeActorFactory
local UInterchangeSkeletalMeshActorFactory = {}


---@class UInterchangeSkeletalMeshFactory : UInterchangeFactoryBase
local UInterchangeSkeletalMeshFactory = {}


---@class UInterchangeSkeletonFactory : UInterchangeFactoryBase
local UInterchangeSkeletonFactory = {}


---@class UInterchangeStaticMeshActorFactory : UInterchangeActorFactory
local UInterchangeStaticMeshActorFactory = {}


---@class UInterchangeStaticMeshFactory : UInterchangeFactoryBase
local UInterchangeStaticMeshFactory = {}


---@class UInterchangeTextureFactory : UInterchangeFactoryBase
local UInterchangeTextureFactory = {}


---@class UInterchangeUEJPEGTranslator : UInterchangeTranslatorBase
local UInterchangeUEJPEGTranslator = {}


---@class UInterchangeUSDTranslator : UInterchangeTranslatorBase
---@field TranslatorSettings UInterchangeUsdTranslatorSettings
local UInterchangeUSDTranslator = {}



---@class UInterchangeUsdTranslatorSettings : UInterchangeTranslatorSettings
---@field GeometryPurpose int32
---@field RenderContext FName
---@field MaterialPurpose FName
---@field InterpolationType EUsdInterpolationType
---@field bOverrideStageOptions boolean
---@field StageOptions FUsdStageOptions
local UInterchangeUsdTranslatorSettings = {}



---@class UMaterialExpressionMaterialXAppend3Vector : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field C FExpressionInput
local UMaterialExpressionMaterialXAppend3Vector = {}



---@class UMaterialExpressionMaterialXAppend4Vector : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field C FExpressionInput
---@field D FExpressionInput
local UMaterialExpressionMaterialXAppend4Vector = {}



---@class UMaterialExpressionMaterialXBurn : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXBurn = {}



---@class UMaterialExpressionMaterialXDifference : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXDifference = {}



---@class UMaterialExpressionMaterialXDisjointOver : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXDisjointOver = {}



---@class UMaterialExpressionMaterialXDodge : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXDodge = {}



---@class UMaterialExpressionMaterialXFractal3D : UMaterialExpression
---@field Position FExpressionInput
---@field Amplitude FExpressionInput
---@field ConstAmplitude float
---@field Octaves FExpressionInput
---@field ConstOctaves int32
---@field Lacunarity FExpressionInput
---@field ConstLacunarity float
---@field Diminish FExpressionInput
---@field ConstDiminish float
---@field Scale float
---@field bTurbulence boolean
---@field Levels int32
---@field OutputMin float
---@field OutputMax float
local UMaterialExpressionMaterialXFractal3D = {}



---@class UMaterialExpressionMaterialXIn : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXIn = {}



---@class UMaterialExpressionMaterialXLuminance : UMaterialExpression
---@field Input FExpressionInput
---@field LuminanceFactors FLinearColor
---@field LuminanceMode EMaterialXLuminanceMode
local UMaterialExpressionMaterialXLuminance = {}



---@class UMaterialExpressionMaterialXMask : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXMask = {}



---@class UMaterialExpressionMaterialXMatte : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXMatte = {}



---@class UMaterialExpressionMaterialXMinus : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXMinus = {}



---@class UMaterialExpressionMaterialXOut : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXOut = {}



---@class UMaterialExpressionMaterialXOver : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXOver = {}



---@class UMaterialExpressionMaterialXOverlay : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXOverlay = {}



---@class UMaterialExpressionMaterialXPlace2D : UMaterialExpression
---@field Coordinates FExpressionInput
---@field Pivot FExpressionInput
---@field Scale FExpressionInput
---@field Offset FExpressionInput
---@field RotationAngle FExpressionInput
---@field ConstRotationAngle float
---@field ConstCoordinate uint8
local UMaterialExpressionMaterialXPlace2D = {}



---@class UMaterialExpressionMaterialXPlus : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXPlus = {}



---@class UMaterialExpressionMaterialXPremult : UMaterialExpression
---@field Input FExpressionInput
local UMaterialExpressionMaterialXPremult = {}



---@class UMaterialExpressionMaterialXRamp4 : UMaterialExpression
---@field Coordinates FExpressionInput
---@field A FExpressionInput
---@field B FExpressionInput
---@field C FExpressionInput
---@field D FExpressionInput
---@field ConstCoordinate uint8
local UMaterialExpressionMaterialXRamp4 = {}



---@class UMaterialExpressionMaterialXRampLeftRight : UMaterialExpression
---@field Coordinates FExpressionInput
---@field A FExpressionInput
---@field B FExpressionInput
---@field ConstCoordinate uint8
local UMaterialExpressionMaterialXRampLeftRight = {}



---@class UMaterialExpressionMaterialXRampTopBottom : UMaterialExpression
---@field Coordinates FExpressionInput
---@field A FExpressionInput
---@field B FExpressionInput
---@field ConstCoordinate uint8
local UMaterialExpressionMaterialXRampTopBottom = {}



---@class UMaterialExpressionMaterialXRemap : UMaterialExpression
---@field Input FExpressionInput
---@field InputLow FExpressionInput
---@field InputHigh FExpressionInput
---@field TargetLow FExpressionInput
---@field TargetHigh FExpressionInput
---@field InputLowDefault float
---@field InputHighDefault float
---@field TargetLowDefault float
---@field TargetHighDefault float
local UMaterialExpressionMaterialXRemap = {}



---@class UMaterialExpressionMaterialXRotate2D : UMaterialExpression
---@field Input FExpressionInput
---@field RotationAngle FExpressionInput
---@field ConstRotationAngle float
local UMaterialExpressionMaterialXRotate2D = {}



---@class UMaterialExpressionMaterialXScreen : UMaterialExpression
---@field A FExpressionInput
---@field B FExpressionInput
---@field Alpha FExpressionInput
---@field ConstAlpha float
local UMaterialExpressionMaterialXScreen = {}



---@class UMaterialExpressionMaterialXSplitLeftRight : UMaterialExpression
---@field Coordinates FExpressionInput
---@field A FExpressionInput
---@field B FExpressionInput
---@field Center FExpressionInput
---@field ConstCenter float
---@field ConstCoordinate uint8
local UMaterialExpressionMaterialXSplitLeftRight = {}



---@class UMaterialExpressionMaterialXSplitTopBottom : UMaterialExpression
---@field Coordinates FExpressionInput
---@field A FExpressionInput
---@field B FExpressionInput
---@field Center FExpressionInput
---@field ConstCenter float
---@field ConstCoordinate uint8
local UMaterialExpressionMaterialXSplitTopBottom = {}



---@class UMaterialExpressionMaterialXSwizzle : UMaterialExpression
---@field Input FExpressionInput
---@field Channels FString
local UMaterialExpressionMaterialXSwizzle = {}



---@class UMaterialExpressionMaterialXTextureSampleParameterBlur : UMaterialExpressionTextureSampleParameter2D
---@field KernelSize EMAterialXTextureSampleBlurKernel
---@field FilterSize float
---@field FilterOffset float
---@field Filter EMaterialXTextureSampleBlurFilter
local UMaterialExpressionMaterialXTextureSampleParameterBlur = {}



---@class UMaterialExpressionMaterialXUnpremult : UMaterialExpression
---@field Input FExpressionInput
local UMaterialExpressionMaterialXUnpremult = {}



