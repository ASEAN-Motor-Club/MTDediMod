---Thread execution helper functions
---@class Execution

local Execution = {}

---Execute the given function on the game thread and block until it completes.
---Delegates to the global ExecuteInGameThreadSync2 (defined in Helpers.lua).
---
---@param fn function Function to execute
---@param callerName string? Label for timeout warnings
function Execution.InGameThreadSync(fn, callerName)
  ExecuteInGameThreadSync2(fn, callerName)
end

return Execution
