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
