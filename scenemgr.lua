

local SceneManager = {}
SceneManager.__index = SceneManager


function SceneManager.new()
  local manager = setmetatable({}, SceneManager)
  
  local updateThread = nil
  
  
  manager.activeScene = nil
  
  return manager
end

function SceneManager.update(self, deltaTime)
  if self.activeScene then
    self.activeScene:update(deltaTime)
  end
end

function SceneManager.start(self)
  if self.updateThread and self.updateThread.stop then
    self.updateThread:stop()
  end
  
  self.runningTime = MOAISim.getElapsedTime()
  local thread = MOAICoroutine.new()
  self.updateThread = thread
  
  thread:run(function ()
      while true do
        local now = MOAISim.getElapsedTime()
        local deltaTime = now - self.runningTime
        self:update(deltaTime)
        
        self.runningTime = now
        coroutine.yield()
      end
    end
    )
end

function SceneManager.stop(self)
  if self.updateThread and self.updateThread.stop then
    self.updateThread:stop()
  end
  
  self.updateThread = nil
end

function SceneManager.switchToScene(self, sceneName)
  -- cleanup old scene
  if self.activeScene and self.activeScene.cleanup then
    self.activeScene:cleanup()
  end
  
  -- instantiate new scene

  local newSceneModule = require ('scenes/' .. sceneName)
  local newScene = newSceneModule.new()
  
  newScene = newScene
  newScene:setup()
  
  self.activeScene = newScene
end

return SceneManager
