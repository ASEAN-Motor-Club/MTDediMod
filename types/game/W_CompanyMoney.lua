---@meta

---@class UW_CompanyMoney_C : UCompanyMoneyWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field DailyReportTitle UW_Title_C
---@field W_Template_PopupWindow UW_Template_PopupWindow_C
---@field W_Title UW_Title_C
local UW_CompanyMoney_C = {}

---@param Minutes int32
function UW_CompanyMoney_C:ReceiveSetDayMinutes(Minutes) end
---@param EntryPoint int32
function UW_CompanyMoney_C:ExecuteUbergraph_W_CompanyMoney(EntryPoint) end


