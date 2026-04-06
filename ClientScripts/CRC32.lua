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
---Uses 8-byte batched string.byte() calls for better Lua 5.4 throughput.
---@param data string
---@return string 8-character lowercase hex string
function CRC32.sum(data)
  local crc = 0xFFFFFFFF
  local len = #data
  local i = 1
  -- Process 8 bytes at a time to amortise string.byte call overhead
  while i <= len - 7 do
    local b1,b2,b3,b4,b5,b6,b7,b8 = data:byte(i, i + 7)
    crc = TABLE[(crc ~ b1) & 0xFF] ~ (crc >> 8)
    crc = TABLE[(crc ~ b2) & 0xFF] ~ (crc >> 8)
    crc = TABLE[(crc ~ b3) & 0xFF] ~ (crc >> 8)
    crc = TABLE[(crc ~ b4) & 0xFF] ~ (crc >> 8)
    crc = TABLE[(crc ~ b5) & 0xFF] ~ (crc >> 8)
    crc = TABLE[(crc ~ b6) & 0xFF] ~ (crc >> 8)
    crc = TABLE[(crc ~ b7) & 0xFF] ~ (crc >> 8)
    crc = TABLE[(crc ~ b8) & 0xFF] ~ (crc >> 8)
    i = i + 8
  end
  -- Remaining bytes
  while i <= len do
    crc = TABLE[(crc ~ data:byte(i)) & 0xFF] ~ (crc >> 8)
    i = i + 1
  end
  return string.format("%08x", (~crc) & 0xFFFFFFFF)
end

return CRC32
