
require 'resourcemgr'

PlayerShip = require 'entities/playership'
Bullet = require 'entities/bullet'
BulletController = require 'entities/bulletcontroller'
BulletTypes = require 'entities/bullettypes'
Enemy = require 'entities/enemy'
EnemyTypes = require 'entities/enemytypes'

-- first level

local Level1 = {}
Level1.__index = Level1

local bounds = { min_x = -220,
                 min_y = -400,
                 max_x = 220,
                 max_y = 400
                }

function Level1.new()
  local scene = setmetatable({}, Level1)
  
  return scene
end

function Level1.update(self, delta_time)
  if self.finished then
    print("CENAS")
    sceneManager:switchToScene('end')
  end
  
  for enemy, _ in pairs(self.enemies) do
    if enemy.dead then
      self:destroyEnemy(enemy)
    else
      enemy:update(delta_time)
    end
  end
  
  if self.player then
    self.player:update(delta_time)
  end
end

function Level1.setup(self)
  -- input setup
  self.mouse_x = 0
  self.mouse_y = 0
  self.mouse_down = false
  MOAIInputMgr.device.pointer:setCallback ( self:createPointerCallback() )
  MOAIInputMgr.device.mouseLeft:setCallback (self:createMouseLeftCallback() )
  MOAIInputMgr.device.keyboard:setCallback ( self:createKeyboardCallback() )
  
  local player = PlayerShip.new(100, -300, bounds)
  layers[layer_Player]:insertProp(player.prop)
  
  local behaviour = MOAICoroutine.new()
  
  self.enemies = {}
  self.player = player
  self.behaviour = behaviour
  
  -- the enemies have controll of the bullets. But when one is destroyed,
  -- we shouldn't destroy the bullets but we should clean them up later.
  -- so, we use a bullet graveyard
  -- After 5 seconds, it destroys a bullet controller and all its bullets
  -- Gonna use a two layered graveyard
  local graveyard = { {}, {} }
  local graveyardThread = MOAICoroutine.new()
  graveyardThread:run( function ()
      while true do
        for controller, _ in pairs(graveyard[2]) do
          controller:destroy()
        end
        graveyard[2] = graveyard[1]
        graveyard[1] = {}
        
        utils.threadSleep(5)
      end
    end
  )
  self.graveyard = graveyard
  self.graveyardThread = graveyardThread
  
  
  
  behaviour:run(self:createBehaviour())
end

function Level1.cleanup(self)
  self.behaviour:stop()
  self.graveyardThread:stop()
  
  for enemy, _ in pairs(self.enemies) do
    self:destroyEnemy(enemy)
  end
  
  for controller, _ in pairs(self.graveyard[2]) do
    controller:destroy()
  end
  for controller, _ in pairs(self.graveyard[1]) do
    controller:destroy()
  end
  
  self.player:destroy()
  self.player = nil
  
  MOAIInputMgr.device.pointer:setCallback ( nil )
  MOAIInputMgr.device.mouseLeft:setCallback( nil )
  MOAIInputMgr.device.keyboard:setCallback ( nil )
end

function Level1.createEnemy(self, x, y, config, b_index, bounds)
  local enemy = Enemy.new(x, y, config, b_index, bounds)
  layers[layer_Enemies]:insertProp(enemy.prop)
  self.enemies[enemy] = true
end

function Level1.destroyEnemy(self, enemy)
  if self.enemies[enemy] then
    self.graveyard[1][enemy.bulletController] = true
    layers[layer_Enemies]:removeProp(enemy.prop)
    enemy:destroy()
    self.enemies[enemy] = nil
  end
end

function Level1.createBehaviour(self)
  local f = function()

    local timer = MOAITimer.new()
    --[[
    local textFont = ResourceManager.getFont('DejaVuSans.ttf', 40)
    local levelText = MOAITextBox.new()
    levelText:setString('Level 1')
    levelText:setFont( textFont )
    levelText:setRect(-128, -32, 128, 32)
    levelText:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
    levelText:setYFlip(true)
    levelText:setLoc(0, 200)
    layers[layer_GUIText]:insertProp(levelText)
    
    utils.threadSleep(3)
    
    layers[layer_GUIText]:removeProp(levelText)
    levelText = nil
    textFont = nil

    if not self.finished then
      self:createEnemy(-150, 450, EnemyTypes.enemy_small, 1, bounds)
      utils.threadSleep(2)
    end

    if not self.finished then
      self:createEnemy(150, 450, EnemyTypes.enemy_small, 1, bounds)
    end
    utils.threadSleep(2)
    
    for i = 0, 10 do
      if not self.finished then
        self:createEnemy(-260, 420, EnemyTypes.enemy_small, 2, bounds)
        utils.threadSleep(0.1)
      end
    end
    utils.threadSleep(1)
    
    for i = 0, 10 do
      if not self.finished then
        self:createEnemy(260, 420, EnemyTypes.enemy_small, 3, bounds)
        utils.threadSleep(0.1)
      end
    end
    utils.threadSleep(1)  
    
    if not self.finished then
      self:createEnemy(-150, 425, EnemyTypes.enemy_small, 4, bounds)
      self:createEnemy(150, 425, EnemyTypes.enemy_small, 5, bounds)
    end
    utils.threadSleep(1)  
    
    if not self.finished then
      self:createEnemy(-100, 450, EnemyTypes.enemy_small, 4, bounds)
      self:createEnemy(100, 450, EnemyTypes.enemy_small, 5, bounds)
    end
    utils.threadSleep(1)  
    
    if not self.finished then
      self:createEnemy(-50, 475, EnemyTypes.enemy_small, 4, bounds)
      self:createEnemy(50, 475, EnemyTypes.enemy_small, 5, bounds)
    end
    utils.threadSleep(3)    
      
    for i = 0, 10 do
      if not self.finished then
        self:createEnemy(-275, 420, EnemyTypes.enemy_small, 2, bounds)
        self:createEnemy(275, 420, EnemyTypes.enemy_small, 3, bounds)
        utils.threadSleep(0.1)
      end
    end
    utils.threadSleep(1)  

    if not self.finished then
      self:createEnemy(0, 450, EnemyTypes.enemy_normal, 1, bounds)
    end 
    utils.threadSleep(5)
    
    if not self.finished then
      self:createEnemy(180, 475, EnemyTypes.enemy_normal, 1, bounds)
    end
    utils.threadSleep(4)
    
    for i = -150, 50, 100 do
      if not self.finished then
        self:createEnemy(i, 450, EnemyTypes.enemy_small, 1, bounds)
      end
      utils.threadSleep(0.2)
    end
    utils.threadSleep(4)
    --]]
    if not self.finished then
      self:createEnemy(-180, 475, EnemyTypes.enemy_normal, 1, bounds)
    end
    utils.threadSleep(2)
    
    for i = 150, -50, -100 do
      if not self.finished then
        self:createEnemy(i, 450, EnemyTypes.enemy_small, 1, bounds)
      end
      utils.threadSleep(0.2)
    end
    utils.threadSleep(4)
    
    for i = 0, 5 do
      if not self.finished then
        self:createEnemy(-100 + (50 * i), 420, EnemyTypes.enemy_small, 5, bounds)
      end
      utils.threadSleep(0.5)
    end
    
    if not self.finished then
      self:createEnemy(-150, 475, EnemyTypes.enemy_normal, 1, bounds)
      self:createEnemy(150, 475, EnemyTypes.enemy_normal, 1, bounds)
    end
    utils.threadSleep(6)
    
    
    print (3798123)
    
    --utils.threadSleep(4)
    self.finished = true
    
  end
  return f
end

function Level1.createPointerCallback(self)
  local playerLayer = layers[layer_Player]
  --local guiLayer = layers[layer_GUI]
  
  local callback = function (x, y)
    self.mouse_x, self.mouse_y = playerLayer:wndToWorld(x, y)
    if self.mouse_down then
      self.player:setDestination(self.mouse_x, self.mouse_y)
      self.player:setDirection(self.mouse_x, self.mouse_y)
    end
  end
  return callback
end

function Level1.createMouseLeftCallback(self)
  local callback = function (down)
    self.mouse_down = down
    if down then
      if self.player and self.player.setDestination then
        self.player:setDestination(self.mouse_x, self.mouse_y)
        self.player:setDirection(self.mouse_x, self.mouse_y)
      end
    else
      self.player:resetDirection()
    end
  end
  return callback
end


function Level1.createKeyboardCallback(self)
  local callback = function (key, down)
    local key_value = string.char(key)
    
    if down == true then -- pressed key
      if key_value == 'a' then
        self.player:addDirection(-1, 0)
      end
      if key_value == 'd' then
        self.player:addDirection(1, 0)
      end
      if key_value == 'w' then
        self.player:addDirection(0, 1)
      end
      if key_value == 's' then
        self.player:addDirection(0, -1)
      end
    else                  -- released key
      if key_value == 'a' then
        self.player:addDirection(1, 0)
      end
      if key_value == 'd' then
        self.player:addDirection(-1, 0)
      end
      if key_value == 'w' then
        self.player:addDirection(0, -1)
      end
      if key_value == 's' then
        self.player:addDirection(0, 1)
      end
    end
  end
  
  return callback
end

return Level1
  
  