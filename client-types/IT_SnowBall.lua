---@meta

---@class AIT_SnowBall_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Snowball UStaticMeshComponent
local AIT_SnowBall_C = {}

---@param MyComp UPrimitiveComponent
---@param Other AActor
---@param OtherComp UPrimitiveComponent
---@param bSelfMoved boolean
---@param HitLocation FVector
---@param HitNormal FVector
---@param NormalImpulse FVector
---@param Hit FHitResult
function AIT_SnowBall_C:ReceiveHit(MyComp, Other, OtherComp, bSelfMoved, HitLocation, HitNormal, NormalImpulse, Hit) end
function AIT_SnowBall_C:Explode() end
---@param EntryPoint int32
function AIT_SnowBall_C:ExecuteUbergraph_IT_SnowBall(EntryPoint) end


