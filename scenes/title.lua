
require 'resourcemgr'

-- title screen

local TitleScene = {}
TitleScene.__index = TitleScene

local deck = MOAIGfxQuad2D.new()
deck:setTexture( ResourceManager.getSprite('button1.png') )
deck:setRect(-128, -32, 128, 32)


function TitleScene.new()
  local scene = setmetatable({}, TitleScene)
  
 
  return scene
end

function TitleScene.update(self, delta_timer)
  
end

function TitleScene.setup(self)
  
  -- input setup
  self.mouse_x = 0
  self.mouse_y = 0
  self.mouse_down = false
  MOAIInputMgr.device.pointer:setCallback ( self:createPointerCallback() )
  MOAIInputMgr.device.mouseLeft:setCallback (self:createMouseLeftCallback() )
  
  
  local buttonFont = ResourceManager.getFont('DejaVuSans.ttf', 35)
  
  -- start button
  local startButton = MOAIProp2D.new()
  startButton:setDeck(deck)
  startButton:setLoc(0, -50)
  
  local startText = MOAITextBox.new()
  startText:setString('Start')
  startText:setFont( buttonFont )
  startText:setRect(-128, -32, 128, 32)
  startText:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  startText:setYFlip(true)
  startText:setLoc(0, -50)
  
  startButton.onLeftClickUp = function ()
      sceneManager:switchToScene('level1')
    end
  
  -- credits button
  local creditsButton = MOAIProp2D.new()
  creditsButton:setDeck(deck)
  creditsButton:setLoc(0, -125)
  
  local creditsText = MOAITextBox.new()
  creditsText:setString('Credits')
  creditsText:setFont( buttonFont )
  creditsText:setRect(-128, -32, 128, 32)
  creditsText:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  creditsText:setYFlip(true)
  creditsText:setLoc(0, -125)
  
  creditsButton.onLeftClickUp = function ()
      print( 'clicked CREDITS')
    end
    
  -- adding them to layers & partitions
  local guiPartition = MOAIPartition.new ()
  layers[layer_GUI]:setPartition(guiPartition)
  
  guiPartition:insertProp(startButton)
  layers[layer_GUIText]:insertProp(startText)
  guiPartition:insertProp(creditsButton)
  layers[layer_GUIText]:insertProp(creditsText)
  
  self.startButton = startButton
  self.startText = startText
  self.creditsButton = creditsButton
  self.creditsText = creditsText
  
  self.guiPartition = guiPartition
end

function TitleScene.cleanup(self)
  self.guiPartition:clear()
  layers[layer_GUIText]:removeProp(self.startText)
  
  self.startButton = nil
  self.startText = nil
  
  resetLayers()
  
  MOAIInputMgr.device.pointer:setCallback ( nil )
  MOAIInputMgr.device.mouseLeft:setCallback ( nil )
end

function TitleScene.createPointerCallback(self)
  local layer = layers[layer_GUI]

  local callback = function (x, y)
    self.mouse_x, self.mouse_y = layer:wndToWorld(x, y)
  end
  
  return callback
end

function TitleScene.createMouseLeftCallback(self)
  
  local callback = function (down)
    self.mouse_down = down
    
    if down then
      -- do stuff
    else
      local pick = self.guiPartition:propForPoint(self.mouse_x, self.mouse_y)
      if pick and pick.onLeftClickUp then
        pick.onLeftClickUp()
      end
    end
  end 
  
  return callback
end



return TitleScene




