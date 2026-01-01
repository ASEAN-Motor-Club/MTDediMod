---@meta

-- Missing UE4 template types (simplified)
---@alias TWeakObjectPtr<T> T?
---@alias TSubclassOf<T> UClass

-- Missing callback/delegate types
---@alias FOutputDevice any
---@alias FObjectInstancingGraph any

-- Missing property types  
---@alias PropertyClass UClass
---@alias LocalObject UObject
---@alias UObjectDerivative UObject

-- ======================================
-- Missing fields from generated types
-- ======================================

-- AMTCharacter.Net_Customization is missing from generated types
-- Field exists at runtime but wasn't captured by TypeGenerator
---@class AMTCharacter
---@field Net_Customization FMTCharacterCustomization

-- ======================================
-- UE4/UE5 Version-Specific Type Extensions
-- ======================================

-- FHitResult has different fields depending on Unreal Engine version
-- These extensions provide cross-version compatibility
---@class FHitResult
---@field Actor RemoteUnrealParam<AActor>  -- UE 4.x
---@field HitObjectHandle FHitResultHandle  -- UE 5.x

---@class FHitResultHandle
---@field Actor RemoteUnrealParam<AActor>  -- UE 5.0-5.3
---@field ReferenceObject RemoteUnrealParam<UObject>  -- UE 5.4+

-- ======================================
-- UE4SS Type Definition Corrections
-- ======================================

-- TArray should inherit from RemoteObject as per UE4SS documentation
-- https://docs.ue4ss.com/lua-api/classes/tarray.html
-- The generated types incorrectly define it as just { [integer]: T }
-- which provides array indexing but loses RemoteObject methods like IsValid()
---@class TArray<T> : RemoteObject
