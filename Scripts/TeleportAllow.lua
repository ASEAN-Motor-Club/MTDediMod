---TeleportAllow: one-shot bypass tokens for the anti-teleport-with-cargo
---hooks in RPManager.lua.
---
---The universal anti-cheat pins ServerTeleportVehicle (always) and
---ServerResetVehicleAt (long-range, cargo kept). Our OWN Lua teleport
---handlers (PlayerManager.HandleTeleportPlayer → backend /tp, /tp2marker,
---/rescue) must never be pinned, so they take a token here right before the
---RPC and release it right after.
---
---Lua-originated UFunction calls fire UE4SS hooks synchronously on the game
---thread, so set-before-call / clear-after-call is race-free.

local M = {}

local allowCount = 0

---Take one bypass token: the NEXT hooked teleport RPC from this thread is
---allowed through unmodified. Nesting-safe (counts).
function M.Take()
  allowCount = allowCount + 1
end

---Release a previously taken token (call after the RPC returns, including on
---error paths).
function M.Release()
  if allowCount > 0 then allowCount = allowCount - 1 end
end

---Consume the token if one is outstanding. Returns true when the current
---hook invocation was initiated by our own Lua code.
function M.Consume()
  if allowCount > 0 then
    allowCount = allowCount - 1
    return true
  end
  return false
end

return M
