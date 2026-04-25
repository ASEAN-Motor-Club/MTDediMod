---@meta

---@class AVendor_Uniform_FireFighter_C : AMTAICharacter_C
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTMapIconPlaceName UMTMapIconPlaceNameComponent
---@field MTInteractable UMTInteractableComponent
---@field Sphere USphereComponent
---@field MTVendor UMTVendorComponent
local AVendor_Uniform_FireFighter_C = {}

function AVendor_Uniform_FireFighter_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AVendor_Uniform_FireFighter_C:ExecuteUbergraph_Vendor_Uniform_FireFighter(EntryPoint) end


