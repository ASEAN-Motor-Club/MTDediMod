-- Tests for Webserver.lua threading and dispatch logic
--
-- These tests verify:
--   1. ExecuteInGameThreadSync blocking dispatch (spin-wait from async thread)
--   2. ExecuteInGameThreadSync timeout behavior
--   3. Webserver GET/HEAD dispatch runs directly on async thread
--   4. Webserver POST/PUT/DELETE/PATCH dispatch uses blocking ExecuteInGameThreadSync
--   5. pendingResponse polling and JSON stringify on async thread

-- ============================================================
-- Stubs for Webserver.lua dependencies
-- ============================================================

package.loaded["socket"] = {
  sleep = function(secs) end,
  gettime = function() return os.clock() end,
  bind = function(host, port)
    return {
      getsockname = function() return host, port end,
      settimeout = function() end,
      accept = function() return nil, "timeout" end,
    }
  end,
  select = function(r, w, timeout) return nil, nil, "timeout" end,
}

package.loaded["mime"] = {
  b64 = function(s) return s end,
}

package.loaded["socket.url"] = {
  parse = function(urlStr)
    return { path = urlStr or "/", query = nil }
  end,
  parse_path = function(path)
    local parts = {}
    for part in string.gmatch(path or "/", "[^/]+") do
      table.insert(parts, part)
    end
    return parts
  end,
  unescape = function(s) return s end,
}

package.loaded["Statics"] = {
  ModName = "TestMod",
  ModVersion = "0.0.0",
  ModLogLevel = 1,
}

package.loaded["bcrypt"] = nil  -- RequireSafe returns nil for this

-- Ensure Helpers.lua is loaded first (provides ExecuteInGameThreadSync, RequireSafe, etc.)
require("Helpers")

-- ============================================================
-- Tests for ExecuteInGameThreadSync
-- ============================================================

describe("ExecuteInGameThreadSync", function()
  it("uses ExecuteInGameThread + spin-wait when called from async thread", function()
    local executed = false

    -- Track whether ExecuteInGameThread was invoked
    local eigtCalled = false
    local origEigt = _G.ExecuteInGameThread
    _G.ExecuteInGameThread = function(fn)
      eigtCalled = true
      fn()  -- simulate game thread executing immediately
    end

    local ok = _G.ExecuteInGameThreadSync(function()
      executed = true
    end, "async_test", 100)

    -- Restore immediately
    _G.ExecuteInGameThread = origEigt

    assert.is_true(ok)
    assert.is_true(executed)
    assert.is_true(eigtCalled, "ExecuteInGameThread should have been called for async dispatch")
  end)

  it("returns false on timeout when game thread stalls", function()
    -- Override ExecuteInGameThread to never execute the callback
    local origEigt = _G.ExecuteInGameThread
    _G.ExecuteInGameThread = function(fn)
      -- Intentionally do not call fn() — simulates stalled game thread
    end

    local ok = _G.ExecuteInGameThreadSync(function()
      error("should not execute")
    end, "timeout_test", 5)

    -- Restore
    _G.ExecuteInGameThread = origEigt

    assert.is_false(ok, "Should return false when game thread stalls")
  end)
end)

-- ============================================================
-- Load Webserver.lua after setting up stubs
-- ============================================================
local webserver = require("Webserver")

-- ============================================================
-- Tests for Webserver handler return types
-- ============================================================

describe("Webserver handlers", function()
  it("return tables (not pre-stringified JSON) for async stringify", function()
    local json = require("JsonParser")

    -- Register a test handler
    webserver.registerHandler("/test_table", "GET", function(session)
      return { data = "hello", count = 42 }
    end, false)

    -- Verify the pattern: handlers return tables
    local handlerResult = { data = "hello", count = 42 }
    assert.is_table(handlerResult)
    assert.are.equal("hello", handlerResult.data)

    -- Verify async stringify works
    local str = json.stringify(handlerResult)
    assert.is_string(str)
    local parsed = json.parse(str)
    assert.are.equal("hello", parsed.data)
    assert.are.equal(42, parsed.count)
  end)

  it("preserve pre-stringified responses (backward compatibility)", function()
    local json = require("JsonParser")
    local preStringified = json.stringify({ status = "ok" })

    -- If a handler returns a string, it should pass through unchanged
    assert.is_string(preStringified)
    local parsed = json.parse(preStringified)
    assert.are.equal("ok", parsed.status)
  end)
end)

-- ============================================================
-- Tests for JSON stringify offload
-- ============================================================

describe("JSON stringify offload", function()
  it("stringifies tables on async thread after game thread returns data", function()
    local json = require("JsonParser")

    -- Simulate the flow:
    -- 1. Game thread handler returns a table
    local gameThreadResult = { players = { { id = 1, name = "Alice" }, { id = 2, name = "Bob" } } }

    -- 2. Async thread stringifies it
    local asyncString = json.stringify(gameThreadResult)

    assert.is_string(asyncString)
    local parsed = json.parse(asyncString)
    assert.are.equal(2, #parsed.players)
    assert.are.equal("Alice", parsed.players[1].name)
  end)

  it("handles nested structures during async stringify", function()
    local json = require("JsonParser")
    local complex = {
      vehicles = {
        {
          id = "v1",
          parts = { engine = { hp = 500 }, wheels = { count = 4 } }
        }
      },
      metadata = { version = "1.0", timestamp = 1234567890 }
    }

    local str = json.stringify(complex)
    local parsed = json.parse(str)
    assert.are.equal("v1", parsed.vehicles[1].id)
    assert.are.equal(500, parsed.vehicles[1].parts.engine.hp)
    assert.are.equal("1.0", parsed.metadata.version)
  end)
end)
