---@meta

---@class FSharedImageConstRefBlueprint
local FSharedImageConstRefBlueprint = {}


---@class USharedImageConstRefBlueprintFns : UObject
local USharedImageConstRefBlueprintFns = {}

---@param Image FSharedImageConstRefBlueprint
---@return boolean
function USharedImageConstRefBlueprintFns:IsValid(Image) end
---@param Image FSharedImageConstRefBlueprint
---@return int32
function USharedImageConstRefBlueprintFns:GetWidth(Image) end
---@param Image FSharedImageConstRefBlueprint
---@return FVector2f
function USharedImageConstRefBlueprintFns:GetSize(Image) end
---@param Image FSharedImageConstRefBlueprint
---@param X int32
---@param Y int32
---@param bValid boolean
---@return FVector4f
function USharedImageConstRefBlueprintFns:GetPixelValue(Image, X, Y, bValid) end
---@param Image FSharedImageConstRefBlueprint
---@param X int32
---@param Y int32
---@param bValid boolean
---@param FailureColor FLinearColor
---@return FLinearColor
function USharedImageConstRefBlueprintFns:GetPixelLinearColor(Image, X, Y, bValid, FailureColor) end
---@param Image FSharedImageConstRefBlueprint
---@return int32
function USharedImageConstRefBlueprintFns:GetHeight(Image) end


