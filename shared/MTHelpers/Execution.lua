---Thread execution helper functions
---@class Execution

local Execution = {}

---Execute the given function directly on the current thread.
---
---Previously this was a spin-wait synchronization bridge from the async thread to the game
---thread. Now that the webserver runs on the game thread via LoopInGameThreadWithDelay,
---we simply call the function inline.
---
---@param fn function Function to execute (runs immediately, inline)
---@param callerName string? (unused — kept for call-site compatibility)
function Execution.InGameThreadSync(fn, callerName)
  fn()
end

return Execution
