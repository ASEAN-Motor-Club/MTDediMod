-- Tests for pure-logic helper functions from Scripts/Helpers.lua
--
-- Helpers.lua is loaded via require("Helpers") which runs as a side-effect
-- module (sets globals). The UE4SS stubs ensure it can load outside the game.

require("Helpers")

-- NOTE: GuidToString guards against type(guid) == "table" because real
-- UE4SS FGuid objects are userdata. In tests with plain Lua tables, that
-- guard fires and returns "0000". We test the conversion logic indirectly
-- via StringToGuid (which returns tables that GuidToString guards against)
-- and directly test the guard behavior.

describe("GuidToString", function()
  it("returns '0000' for nil guid", function()
    local result = GuidToString(nil)
    assert.are.equal("0000", result)
  end)

  it("returns '0000' for plain Lua table (guard against non-UE4SS)", function()
    -- Production code rejects plain tables; real FGuid are userdata
    local result = GuidToString({ A = 1, B = 2, C = 3, D = 4 })
    assert.are.equal("0000", result)
  end)

  it("returns '0000' for empty table", function()
    local result = GuidToString({})
    assert.are.equal("0000", result)
  end)
end)

describe("StringToGuid", function()
  it("converts a valid 32-char hex string to Guid table", function()
    local guid = StringToGuid("123456789ABCDEF01122334455667788")
    assert.are.equal(0x12345678, guid.A)
    assert.are.equal(0x9ABCDEF0, guid.B)
    assert.are.equal(0x11223344, guid.C)
    assert.are.equal(0x55667788, guid.D)
  end)

  it("parses all-zero guid", function()
    local guid = StringToGuid("00000000000000000000000000000000")
    assert.are.equal(0, guid.A)
    assert.are.equal(0, guid.B)
    assert.are.equal(0, guid.C)
    assert.are.equal(0, guid.D)
  end)

  it("parses FFFFFFFF values", function()
    local guid = StringToGuid("FFFFFFFF000000000000000000000000")
    assert.are.equal(0xFFFFFFFF, guid.A)
    assert.are.equal(0, guid.B)
  end)

  it("errors on invalid length", function()
    assert.has_error(function()
      StringToGuid("ABCD")
    end)
  end)

  it("generates random guid when nil", function()
    local guid = StringToGuid(nil)
    assert.is_not_nil(guid.A)
    assert.is_not_nil(guid.B)
    assert.is_not_nil(guid.C)
    assert.is_not_nil(guid.D)
  end)
end)

describe("SplitString", function()
  it("splits by space by default", function()
    local result = SplitString("hello world foo")
    assert.are.same({"hello", "world", "foo"}, result)
  end)

  it("splits by custom separator", function()
    local result = SplitString("a,b,c", ",")
    assert.are.same({"a", "b", "c"}, result)
  end)

  it("returns nil for nil input", function()
    assert.is_nil(SplitString(nil))
  end)

  it("handles single token (no separator found)", function()
    local result = SplitString("hello", ",")
    assert.are.same({"hello"}, result)
  end)
end)

describe("MergeTable", function()
  it("merges flat tables", function()
    local base = { a = 1, b = 2 }
    local append = { b = 3, c = 4 }
    local result = MergeTable(base, append)
    assert.are.equal(3, result.b)
    assert.are.equal(4, result.c)
    assert.are.equal(1, result.a)
  end)

  it("recursively merges nested tables", function()
    local base = { nested = { x = 1, y = 2 } }
    local append = { nested = { y = 99 } }
    local result = MergeTable(base, append)
    assert.are.equal(1, result.nested.x)
    assert.are.equal(99, result.nested.y)
  end)

  it("overwrites non-table with table", function()
    local base = { val = "string" }
    local append = { val = { nested = true } }
    local result = MergeTable(base, append)
    assert.are.same({ nested = true }, result.val)
  end)
end)

describe("VectorToTable", function()
  it("converts a vector-like object to a table", function()
    local vec = { X = 1.0, Y = 2.5, Z = -3.0 }
    local result = VectorToTable(vec)
    assert.are.same({ X = 1.0, Y = 2.5, Z = -3.0 }, result)
  end)
end)

describe("RotatorToTable", function()
  it("converts a rotator-like object to a table", function()
    local rot = { Pitch = 10.0, Yaw = 20.0, Roll = 30.0 }
    local result = RotatorToTable(rot)
    assert.are.same({ Pitch = 10.0, Yaw = 20.0, Roll = 30.0 }, result)
  end)
end)

describe("QuatToTable", function()
  it("converts a quaternion-like object to a table", function()
    local quat = { W = 1.0, X = 0.0, Y = 0.0, Z = 0.0 }
    local result = QuatToTable(quat)
    assert.are.same({ W = 1.0, X = 0.0, Y = 0.0, Z = 0.0 }, result)
  end)
end)

describe("RecursiveSetValue", function()
  it("sets a nested value", function()
    local t = { a = { b = { c = "old" } } }
    RecursiveSetValue(t, {"a", "b", "c"}, "new")
    assert.are.equal("new", t.a.b.c)
  end)

  it("errors on invalid field path", function()
    local t = { a = 1 }
    assert.has_error(function()
      RecursiveSetValue(t, {"nonexistent"}, "value")
    end)
  end)
end)
