# UE4SS Fetch API

## Making HTTPS requests from UE4SS Lua

The custom `fetch` library provides synchronous HTTP GET/POST via a native DLL.

## Setup

Place `fetch/core.dll` and `fetch/init.lua` in `shared/fetch/`:

```
shared/
  fetch/
    core.dll
    init.lua
```

The init.lua should load the core DLL:

```lua
-- shared/fetch/init.lua
local core = require("fetch.core")
return {
    get = function(url)
        return core.request("GET", url)
    end,
    post = function(url, body)
        return core.request("POST", url, body)
    end
}
```

## Usage

```lua
local fetch = require("fetch.init")

-- GET request
local data, err = fetch.get("https://api.example.com/data")
if data then
    -- data is already parsed JSON (table)
    for _, item in ipairs(data) do
        print(item.name)
    end
else
    print("Error:", err)
end

-- POST request
local response, err = fetch.post("https://api.example.com/action", '{"key":"value"}')
```

## Error handling

```lua
local function FetchApiPoints()
    local fetch = require("fetch.init")
    local data, err = fetch.get(API_URL)
    
    if data and type(data) == "table" then
        -- Process data
        return data
    else
        LogOutput("WARN", "API fetch failed: %s", tostring(err))
        return nil
    end
end
```

## JSON parsing

If the fetch library returns raw JSON strings instead of tables:

```lua
local json = require("JsonParser")
local text, err = fetch.get(API_URL)
local data = json.parse(text)
```

## Caching / debouncing

```lua
local fetchAttempted = false

local function FetchOnce()
    if fetchAttempted then return end
    fetchAttempted = true
    -- fetch...
end
```

## Important notes

- The `fetch` library requires `fetch/core.dll` to be accessible from the Lua package path
- UE4SS mods run in the game process; HTTPS requests are synchronous (blocking)
- Keep requests lightweight — don't fetch large payloads or call frequently
- Always validate response data before using it
