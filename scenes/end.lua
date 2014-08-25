
require 'resourcemgr'

local EndScene = {}
EndScene.__index = EndScene

function EndScene.new()
  local scene = setmetatable({}, EndScene)
  
  return scene
end

function EndScene.update(self, delta_timer)
  
end

function EndScene.setup(self)
  self.mouse_x = 0
  self.mouse_y = 0
  self.mouse_down = false
  MOAIInputMgr.device.mouseLeft:setCallback (self:createMouseLeftCallback() )
  
  local bigFont = ResourceManager.getFont('DejaVuSans.ttf', 50)
  local smallFont = ResourceManager.getFont('DejaVuSans.ttf', 30)
  
  local text1 = MOAITextBox.new()
  text1:setString('Congratulations!')
  text1:setFont( bigFont )
  text1:setRect(-220, -200, 220, 200)
  text1:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  text1:setYFlip(true)
  text1:setLoc(0, 100)
  
  local text2 = MOAITextBox.new()
  text2:setString('Click to continue.')
  text2:setFont( smallFont )
  text2:setRect(-200, -200, 200, 200)
  text2:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  text2:setYFlip(true)
  text2:setLoc(0, -200)
  
  layers[layer_GUIText]:insertProp(text1)
  layers[layer_GUIText]:insertProp(text2)
  
  self.text1 = text1
  self.text2 = text2
end

function EndScene.cleanup(self)
  layers[layer_GUIText]:removeProp(self.text1)
  layers[layer_GUIText]:removeProp(self.text2)
  
  self.text1 = nil
  self.text2 = nil
  
  resetLayers()
  
  MOAIInputMgr.device.mouseLeft:setCallback ( nil )
end

function EndScene.createMouseLeftCallback(self)
  local callback = function(down)
    if not down then
      sceneManager:switchToScene('title')
    end
  end
  return callback
end

return EndScene