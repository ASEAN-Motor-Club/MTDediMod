---@meta

---@class UW_DeliveryInteractionListItem_C : UDeliveryMissionListEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MenuBG3_NoRound_C_0 UMenuBG3_NoRound_C
local UW_DeliveryInteractionListItem_C = {}

function UW_DeliveryInteractionListItem_C:Construct() end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_DeliveryInteractionListItem_C:Tick(MyGeometry, InDeltaTime) end
---@param bIsSelected boolean
function UW_DeliveryInteractionListItem_C:BP_OnItemSelectionChanged(bIsSelected) end
---@param ListItemObject UObject
function UW_DeliveryInteractionListItem_C:OnListItemObjectSet(ListItemObject) end
function UW_DeliveryInteractionListItem_C:BndEvt__LoadButton_K2Node_ComponentBoundEvent_0_MTButtonClickedEvent__DelegateSignature() end
function UW_DeliveryInteractionListItem_C:BndEvt__UnloadButton_K2Node_ComponentBoundEvent_1_MTButtonClickedEvent__DelegateSignature() end
function UW_DeliveryInteractionListItem_C:OnFocused_Event_0() end
---@param EntryPoint int32
function UW_DeliveryInteractionListItem_C:ExecuteUbergraph_W_DeliveryInteractionListItem(EntryPoint) end


