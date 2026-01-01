---@meta

---@class UW_CompanyVehiclesEntry_C : UCompanyVehiclesEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
local UW_CompanyVehiclesEntry_C = {}

function UW_CompanyVehiclesEntry_C:Construct() end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_CompanyVehiclesEntry_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UW_CompanyVehiclesEntry_C:ExecuteUbergraph_W_CompanyVehiclesEntry(EntryPoint) end


