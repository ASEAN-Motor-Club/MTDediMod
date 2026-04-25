---@meta

---@class UW_CompanyDepotsEntry_C : UCompanyDepotsEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
local UW_CompanyDepotsEntry_C = {}

function UW_CompanyDepotsEntry_C:Construct() end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_CompanyDepotsEntry_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UW_CompanyDepotsEntry_C:ExecuteUbergraph_W_CompanyDepotsEntry(EntryPoint) end


