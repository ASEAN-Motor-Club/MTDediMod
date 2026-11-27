--- Path resolution for AMC RaceCam inside MotorTownClientMod.
--- Never hardcodes a drive letter or SteamLibrary path: resolves relative to
--- the active Motor Town install via ModPath.game_root(), with an optional
--- RACECAM_DIR environment variable override.

local ModPath = require("ModPath")
local Statics = require("Statics")

local P = {}

local TOKEN_FILE = "racecam_token.txt"

local function trailing_slash(s)
    s = s:gsub("\\", "/")
    if s:sub(-1) ~= "/" then s = s .. "/" end
    return s
end

--- Runtime data directory (plans, routes, active_plan.txt, racecam_token.txt,
--- optional racecam_bind.txt, and opt-in diagnostic logs).
---@return string
function P.data_dir()
    local env = os.getenv("RACECAM_DIR")
    if env and env ~= "" then
        return trailing_slash(env)
    end
    local root = ModPath.game_root()
    return trailing_slash(root .. "/ue4ss/Mods/" .. Statics.ModName .. "/racecam")
end

--- Log file path inside the runtime data directory.
---@param filename string
---@return string
function P.log_path(filename)
    return P.data_dir() .. filename
end

--- Drop folder for event/route/plan JSON files. Operators can copy files here
--- straight from Discord downloads or a shared event pack; no cmd.exe `dir`
--- enumeration is performed on the game thread (the HTTP layer lists files
--- from `http.set_inbox_files` instead).
---@return string
function P.inbox_dir()
    return P.data_dir() .. "inbox/"
end

--- Single well-known drop file. Renaming any event JSON to `drop_event.json`
--- works even when no directory listing provider is available.
---@return string
function P.drop_file()
    return P.data_dir() .. "drop_event.json"
end

--- Best-effort single directory creation. The game runs on Windows, but the
--- same module is unit-tested on Linux, so use the matching shell command.
--- `mkdir -p` / `if not exist` are no-ops when the directory already exists;
--- the pcall keeps a failure from ever surfacing in the game console.
---@param dir string
---@return boolean
local function mkdir_best_effort(dir)
    if not dir or dir == "" then return false end
    local ok = pcall(function()
        if package.config:sub(1, 1) == "\\" then
            local win = dir:gsub("/", "\\")
            os.execute('if not exist "' .. win .. '" mkdir "' .. win .. '"')
        else
            os.execute('mkdir -p "' .. dir .. '"')
        end
    end)
    return ok == true
end

--- Ensure the requested directory plus the RaceCam runtime directories exist.
--- Creating the inbox here means a freshly installed mod is immediately ready
--- to accept dropped JSON files without any operator setup step.
---@param dir string?
---@return boolean
function P.ensure_dir(dir)
    mkdir_best_effort(dir)
    mkdir_best_effort(P.data_dir())
    mkdir_best_effort(P.inbox_dir())
    return true
end

local function trim(s)
    return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

--- Try a real CSPRNG before falling back to a mixed high-entropy seed.
--- Never logs or prints the returned bytes.
---@param n integer
---@return string?
local function external_entropy(n)
    local ok, f = pcall(io.open, "/dev/urandom", "rb")
    if ok and f then
        local okr, s = pcall(f.read, f, n)
        pcall(function() f:close() end)
        if okr and type(s) == "string" and #s > 0 then return s end
    end
    local oko, openssl = pcall(require, "openssl")
    if oko and type(openssl) == "table" and type(openssl.random) == "function" then
        local okr, s = pcall(openssl.random, n)
        if okr and type(s) == "string" and #s > 0 then return s end
    end
    local okb, bcrypt = pcall(require, "bcrypt")
    if okb and type(bcrypt) == "table" then
        if type(bcrypt.randombytes) == "function" then
            local okr, s = pcall(bcrypt.randombytes, n)
            if okr and type(s) == "string" and #s > 0 then return s end
        end
        if type(bcrypt.gensalt) == "function" then
            local okr, s = pcall(bcrypt.gensalt, 12)
            if okr and type(s) == "string" and #s > 0 then return s end
        end
    end
    local oks, ssl = pcall(require, "ssl")
    if oks and type(ssl) == "table" and type(ssl.random) == "function" then
        local okr, s = pcall(ssl.random, n)
        if okr and type(s) == "string" and #s > 0 then return s end
    end
    return nil
end

local function hex_encode(s)
    return (tostring(s):gsub(".", function(c) return string.format("%02x", c:byte()) end))
end

--- 32-bit avalanche mixer (FNV-1a variant). Kept arithmetic-only so it works
--- on Lua 5.1 through 5.4 without bit32/bitop dependencies.
local function mix32(s, salt)
    local h = 2166136261
    local v = tostring(s) .. "\1" .. tostring(salt)
    for i = 1, #v do
        h = (h + v:byte(i)) % 4294967296
        h = (h * 16777619) % 4294967296
        h = (h + (i * 2654435761)) % 4294967296
        h = (h * 16777619) % 4294967296
    end
    return math.floor(h)
end

--- Fallback: eight rounds of a mixed seed (time, monotonic clock, allocation
--- addresses, math state, globals). Enough entropy for a localhost-only token.
---@param extra string
---@return string 64 lowercase hex characters
local function mixed_seed_token(extra)
    local seed = table.concat({
        tostring(os.time()),
        string.format("%.17g", os.clock()),
        tostring({}), tostring({}), tostring({}),
        tostring(math.random()), tostring(_G), tostring(P),
        type(os.date) == "function" and tostring(os.date("%d%m%Y%H%M%S")) or "",
        tostring(extra or ""),
    }, "|")
    local parts = {}
    for round = 1, 8 do
        local h1 = mix32(seed, tostring(round) .. "a")
        local h2 = mix32(seed .. tostring(h1), tostring(round) .. "b")
        parts[#parts + 1] = string.format("%08x%08x", h1, h2)
    end
    return table.concat(parts)
end

local function generate_token()
    local bytes = external_entropy(32)
    if bytes and #bytes >= 32 then
        return hex_encode(bytes):sub(1, 64)
    end
    return mixed_seed_token(bytes and hex_encode(bytes) or "")
end

--- Ensure <data_dir>/racecam_token.txt exists with a 64-char lowercase hex
--- token. An EXISTING token file is never overwritten — in particular an
--- empty/whitespace-only file is preserved so the HTTP layer stays fail-closed.
--- The token value is never logged or printed.
---@return string? token nil when the file exists but has no token
function P.ensure_token()
    local path = P.token_path()
    local f = io.open(path, "r")
    if f then
        local existing = f:read("*a")
        pcall(function() f:close() end)
        local t = trim(existing)
        if t ~= "" then return t end
        return nil
    end
    P.ensure_dir(P.data_dir())
    local tok = generate_token()
    local o = io.open(path, "w")
    if not o then return nil end
    local ok = pcall(function() o:write(tok) o:close() end)
    if not ok then return nil end
    return tok
end

--- Read the trimmed auth token from <data_dir>/racecam_token.txt.
---@return string? token nil when missing, empty or whitespace-only
function P.read_token()
    local f = io.open(P.token_path(), "r")
    if not f then return nil end
    local raw = f:read("*a")
    pcall(function() f:close() end)
    local t = trim(raw)
    if t == "" then return nil end
    return t
end

--- Full path of the localhost auth token file.
---@return string
function P.token_path()
    return P.data_dir() .. TOKEN_FILE
end

return P
