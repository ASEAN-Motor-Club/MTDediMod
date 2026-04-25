---@meta

---@class UWB_Icon_Base_C : UIconImageWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field img_Icon UImage
---@field img_Icon_Base UImage
---@field img_Icon_Mask1 UImage
---@field img_Icon_Mask2 UImage
---@field img_Icon_Outline1 UImage
---@field img_Icon_Outline2 UImage
---@field Text_IconText UTextBlock
---@field Icon UObject
---@field bBaseColor boolean
---@field BaseColor FLinearColor
---@field bBaseMask boolean
---@field BaseMaskColor FLinearColor
---@field bOutline1 boolean
---@field Outline1_Color FLinearColor
---@field bContour boolean
---@field Contour_Color FLinearColor
---@field bGlassMask boolean
---@field GlassMask_Color FLinearColor
---@field ['GlassMask Types'] E_GlassMaskTypes::Type
---@field IconColor FLinearColor
---@field IconScale double
---@field Overall_Angle double
---@field IconBaseTypes E_IconBaseTypes::Type
---@field IconBaseSize E_Sizes::Type
---@field Custom_BaseIcon UTexture2D
---@field Custom_Mask1 UTexture2D
---@field Custom_Mask2 UTexture2D
---@field Custom_Outline1 UTexture2D
---@field Custom_Outline2 UTexture2D
---@field Icon_Translation_X double
---@field Icon_Translation_Y double
---@field bUseIconText boolean
---@field IconText FText
---@field IconText_Transform FWidgetTransform
---@field IconText_Color FSlateColor
---@field IconTextFont FSlateFontInfo
local UWB_Icon_Base_C = {}

---@param IsDesignTime boolean
function UWB_Icon_Base_C:PreConstruct(IsDesignTime) end
function UWB_Icon_Base_C:Update() end
function UWB_Icon_Base_C:Construct() end
---@param IconType EMTIconType
---@param bDisabled boolean
function UWB_Icon_Base_C:ReceiveSetIconType(IconType, bDisabled) end
---@param Color FLinearColor
function UWB_Icon_Base_C:ReceiveOverrideColor(Color) end
---@param EntryPoint int32
function UWB_Icon_Base_C:ExecuteUbergraph_WB_Icon_Base(EntryPoint) end


