#pragma once

#include <Unreal/FProperty.hpp>
#include <Unreal/UObject.hpp>
#include <Unreal/UFunction.hpp>
#include <Unreal/UScriptStruct.hpp>
#include <unordered_map>
#include <string>

using namespace RC::Unreal;

// Caches FProperty* lookups to avoid repeated O(n) class-hierarchy traversals.
// All lookups are game-thread-only (hooks fire on the game thread), so no
// synchronization is needed.
//
// Three cache tiers:
//   GetFuncParam   — UFunction parameter properties  (GetPropertyByName)
//   GetStructField — UScriptStruct / UStruct fields   (GetPropertyByNameInChain)
//   GetObjectProp  — UObject instance properties      (GetPropertyByNameInChain, keyed by UClass)
class PropertyCache
{
public:
    // Call on hot-reload / mod init to drop stale pointers.
    static void Clear()
    {
        FuncParams().clear();
        StructFields().clear();
        ClassProps().clear();
    }

    // Cache a UFunction parameter property.  Parameters live directly on the
    // UFunction so GetPropertyByName (no hierarchy walk) is sufficient.
    static FProperty* GetFuncParam(UFunction* func, const wchar_t* name)
    {
        return Lookup(FuncParams(), reinterpret_cast<uintptr_t>(func), name,
            [func](const wchar_t* n) -> FProperty* { return func->GetPropertyByName(n); });
    }

    // Cache a struct/function field property.  Walks the inheritance chain via
    // GetPropertyByNameInChain.  Accepts both UScriptStruct* and UFunction*
    // (both inherit from UStruct).
    static FProperty* GetStructField(UStruct* Struct, const wchar_t* name)
    {
        return Lookup(StructFields(), reinterpret_cast<uintptr_t>(Struct), name,
            [Struct](const wchar_t* n) -> FProperty* { return Struct->GetPropertyByNameInChain(n); });
    }

    // Cache an object property by UClass.  All instances of the same class
    // share the same property layout, so the cache key is the UClass pointer.
    static FProperty* GetObjectProp(UObject* obj, const wchar_t* name)
    {
        return Lookup(ClassProps(), reinterpret_cast<uintptr_t>(obj->GetClassPrivate()), name,
            [obj](const wchar_t* n) -> FProperty* { return obj->GetPropertyByNameInChain(n); });
    }

    // Convenience: resolve an object property and return a typed value pointer.
    template<typename T>
    static const T* GetObjectValue(UObject* obj, const wchar_t* name)
    {
        auto* prop = GetObjectProp(obj, name);
        return prop ? prop->ContainerPtrToValuePtr<T>(obj) : nullptr;
    }

private:
    using PropMap  = std::unordered_map<std::wstring, FProperty*>;
    using OwnerMap = std::unordered_map<uintptr_t, PropMap>;

    static OwnerMap& FuncParams()   { static OwnerMap m; return m; }
    static OwnerMap& StructFields() { static OwnerMap m; return m; }
    static OwnerMap& ClassProps()   { static OwnerMap m; return m; }

    template<typename Resolver>
    static FProperty* Lookup(OwnerMap& cache, uintptr_t owner, const wchar_t* name, Resolver resolve)
    {
        auto& props = cache[owner];
        std::wstring key(name);
        auto it = props.find(key);
        if (it != props.end()) return it->second;
        auto* prop = resolve(name);
        props[key] = prop;
        return prop;
    }
};
