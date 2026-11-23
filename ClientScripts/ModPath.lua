---Resolve the Motor Town install root without io.popen.
---
---On Windows, PWD is normally unset (Steam launch), so the old fallback
---`io:popen("cd")` ran. That is a Lua method call with a bogus self and throws
---a hard error at load, which aborts the ENTIRE client mod:
---    "calling 'popen' on bad self (string expected, got table)"
---Result: Shortcuts, RPRestrictions, ViewportManager etc. never loaded at all.
---
---The UE4SS working directory is either the Win64 exe dir or the ue4ss dir, so
---probe both with a plain io.open instead of shelling out.

local M = {}

---@return string dir to prefix before "/ue4ss/Mods/..."
function M.game_root()
    local env = os.getenv("PWD")
    if env and env ~= "" then return env end

    local function exists(path)
        local f = io.open(path, "rb")
        if f then
            f:close()
            return true
        end
        return false
    end

    if exists("ue4ss/Mods/mods.txt") then return "." end -- CWD = Binaries/Win64
    if exists("Mods/mods.txt") then return ".." end       -- CWD = ue4ss
    return "."
end

return M
