---@meta

---@class AVendor_Uniform_Paramedic_C : AMTAICharacter_C
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTMapIconPlaceName UMTMapIconPlaceNameComponent
---@field MTInteractable UMTInteractableComponent
---@field Sphere USphereComponent
---@field MTVendor UMTVendorComponent
local AVendor_Uniform_Paramedic_C = {}

function AVendor_Uniform_Paramedic_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AVendor_Uniform_Paramedic_C:ExecuteUbergraph_Vendor_Uniform_Paramedic(EntryPoint) end


