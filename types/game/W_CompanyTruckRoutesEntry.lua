---@meta

---@class UW_CompanyTruckRoutesEntry_C : UCompanyTruckRoutesEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
local UW_CompanyTruckRoutesEntry_C = {}

---@param Navigation EUINavigation
---@return UWidget
function UW_CompanyTruckRoutesEntry_C:DoCustomNavigation_0(Navigation) end
function UW_CompanyTruckRoutesEntry_C:Construct() end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_CompanyTruckRoutesEntry_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UW_CompanyTruckRoutesEntry_C:ExecuteUbergraph_W_CompanyTruckRoutesEntry(EntryPoint) end


