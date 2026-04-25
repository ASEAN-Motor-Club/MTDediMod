---@meta

---@class AAttachment_ToggleLightVendor_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTInteractable UMTInteractableComponent
---@field MTItemSell UMTItemSellComponent
---@field ChildActor UChildActorComponent
---@field ItemKey FName
---@field ItemsDataTable UDataTable
local AAttachment_ToggleLightVendor_C = {}

function AAttachment_ToggleLightVendor_C:UserConstructionScript() end
function AAttachment_ToggleLightVendor_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AAttachment_ToggleLightVendor_C:ExecuteUbergraph_Attachment_ToggleLightVendor(EntryPoint) end


