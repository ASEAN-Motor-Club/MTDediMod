-- TypeGenerator mod - generates Lua types for IDE support
-- Run once after a delay, then disable this mod

print("[TypeGenerator] Scheduling type generation in 5 seconds...")

ExecuteWithDelay(5000, function()
    print("[TypeGenerator] Generating Lua types...")
    GenerateLuaTypes()
    print("[TypeGenerator] Types generated to Mods/shared/types/")
    print("[TypeGenerator] Done! You can now disable this mod.")
end)

