---Pure-Lua CRC32 implementation (Lua 5.3+ bitwise ops).
---Sufficient for pak integrity checks — detects any modification to file content.

local CRC32 = {}

-- Pre-computed lookup table (standard CRC32/zlib polynomial 0xEDB88320)
local TABLE = (function()
  local t = {}
  for i = 0, 255 do
    local c = i
    for _ = 1, 8 do
      if c & 1 == 1 then
        c = 0xEDB88320 ~ (c >> 1)
      else
        c = c >> 1
      end
    end
    t[i] = c
  end
  return t
end)()

---Compute CRC32 of a binary string.
---@param data string
---@return string 8-character lowercase hex string
function CRC32.sum(data)
  local crc = 0xFFFFFFFF
  for i = 1, #data do
    local byte = data:byte(i)
    crc = TABLE[(crc ~ byte) & 0xFF] ~ (crc >> 8)
  end
  return string.format("%08x", (~crc) & 0xFFFFFFFF)
end

return CRC32
