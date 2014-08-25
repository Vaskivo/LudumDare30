
local utils = {}

function utils.threadSleep(time, timer)
  local timer = timer or MOAITimer.new()
  timer:setSpan(time)
  timer:start()
  MOAICoroutine.blockOnAction(timer)
end



return utils