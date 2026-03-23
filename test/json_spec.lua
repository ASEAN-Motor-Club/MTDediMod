-- Tests for Scripts/JsonParser.lua (pure-Lua JSON library)

local json = require("JsonParser")

describe("json.stringify", function()
  it("encodes a flat table as JSON object", function()
    local result = json.parse(json.stringify({ key = "value" }))
    assert.are.equal("value", result.key)
  end)

  it("encodes an array", function()
    local result = json.stringify({1, 2, 3})
    assert.is_truthy(result:match("^%["))
  end)

  it("encodes nested structures", function()
    local input = { outer = { inner = "deep" } }
    local result = json.parse(json.stringify(input))
    assert.are.equal("deep", result.outer.inner)
  end)

  it("encodes booleans", function()
    local result = json.stringify({ flag = true })
    assert.is_truthy(result:match("true"))
  end)

  it("encodes nil as null", function()
    local result = json.stringify(nil)
    assert.are.equal("null", result)
  end)

  it("encodes json.null as null", function()
    local result = json.stringify(json.null)
    assert.are.equal("null", result)
  end)

  it("encodes empty table as object", function()
    local result = json.stringify({})
    assert.are.equal("{}", result)
  end)
end)

describe("json.parse", function()
  it("parses a simple object", function()
    local result = json.parse('{"name": "test", "value": 42}')
    assert.are.equal("test", result.name)
    assert.are.equal(42, result.value)
  end)

  it("parses an array", function()
    local result = json.parse('[1, 2, 3]')
    assert.are.same({1, 2, 3}, result)
  end)

  it("parses nested objects", function()
    local result = json.parse('{"a": {"b": "c"}}')
    assert.are.equal("c", result.a.b)
  end)

  it("parses booleans and null", function()
    local result = json.parse('{"t": true, "f": false, "n": null}')
    assert.is_true(result.t)
    assert.is_false(result.f)
    assert.are.equal(json.null, result.n)
  end)

  it("parses strings with escape characters", function()
    local result = json.parse('{"s": "hello\\nworld"}')
    assert.are.equal("hello\nworld", result.s)
  end)

  it("returns nil for nil input", function()
    assert.is_nil(json.parse(nil))
  end)

  it("roundtrips complex data", function()
    local input = {
      name = "test",
      count = 42,
      nested = { items = {1, 2, 3} },
      flag = true
    }
    local roundtripped = json.parse(json.stringify(input))
    assert.are.equal(input.name, roundtripped.name)
    assert.are.equal(input.count, roundtripped.count)
    assert.are.same(input.nested.items, roundtripped.nested.items)
    assert.are.equal(input.flag, roundtripped.flag)
  end)
end)
