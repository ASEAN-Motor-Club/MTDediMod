--- fetch — Lua glue over the native fetch cdylib
--- Provides HTTPS GET with automatic JSON parsing.
---
--- Usage:
---   local fetch = require("fetch")
---
---   -- Returns parsed JSON as a Lua table; raises on error
---   local data = fetch.json("https://api.example.com/v1/items")
---   print(data[1].name)
---
---   -- Returns parsed JSON as a Lua table, or nil + error string
---   local data, err = fetch.get("https://api.example.com/v1/items")
---
---   -- Returns raw response body as a string, or nil + error string
---   local body, err = fetch.get_string("https://api.example.com/v1/items")

local _native = require("fetch.core")  -- loads fetch.dll / fetch.so

local M = {}

--- M.get(url) -> table | nil, string
--- Performs an HTTPS GET and parses the JSON response into a Lua table.
--- On failure returns nil plus an error message string.
M.get = _native.get

--- M.get_string(url) -> string | nil, string
--- Performs an HTTPS GET and returns the raw response body as a string.
--- On failure returns nil plus an error message string.
M.get_string = _native.get_string

--- M.json(url) -> table
--- Like M.get() but raises a Lua error on failure instead of returning nil.
function M.json(url)
    local data, err = _native.get(url)
    if data == nil then
        error(("fetch.json(%q): %s"):format(url, tostring(err)), 2)
    end
    return data
end

--- M.text(url) -> string
--- Like M.get_string() but raises a Lua error on failure instead of returning nil.
function M.text(url)
    local body, err = _native.get_string(url)
    if body == nil then
        error(("fetch.text(%q): %s"):format(url, tostring(err)), 2)
    end
    return body
end

return M
