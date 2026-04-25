---@meta

---@class AVendor_Uniform_Police_C : AMTAICharacter_C
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTMapIconPlaceName UMTMapIconPlaceNameComponent
---@field MTInteractable UMTInteractableComponent
---@field Sphere USphereComponent
---@field MTVendor UMTVendorComponent
local AVendor_Uniform_Police_C = {}

function AVendor_Uniform_Police_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AVendor_Uniform_Police_C:ExecuteUbergraph_Vendor_Uniform_Police(EntryPoint) end


