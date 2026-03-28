---Thread execution helper functions
---@class Execution

local socket = require("socket")

local Execution = {}

---Execute function in game thread synchronously (blocking)
---Waits up to 1 second for completion before timing out
---@param fn function Function to execute in game thread
---@param callerName string? Optional caller name for logging
function Execution.InGameThreadSync(fn, callerName)
  callerName = callerName or "unknown"
  local wait = 0
  local isFinished = false
  ExecuteInGameThread(function()
    LogOutput('INFO', 'ExecuteInGameThreadSync callback: %s', callerName)
    fn()
    isFinished = true
    LogOutput('INFO', 'finished ExecuteInGameThreadSync callback: %s', callerName)
  end)

  while not isFinished and wait < 1000 do
    wait = wait + 1
    socket.sleep(1 / 1000)
  end
end

return Execution
