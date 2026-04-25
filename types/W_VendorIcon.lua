---@meta

---@class UW_VendorIcon_C : UUserWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Icon UWB_Icon_Base_C
local UW_VendorIcon_C = {}

---@param IsDesignTime boolean
function UW_VendorIcon_C:PreConstruct(IsDesignTime) end
function UW_VendorIcon_C:Construct() end
---@param EntryPoint int32
function UW_VendorIcon_C:ExecuteUbergraph_W_VendorIcon(EntryPoint) end


