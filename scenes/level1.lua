
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
  for enemy, _ in pairs(self.enemies) do
    if enemy.dead then
      self:destroyEnemy(enemy)
    else
      enemy:update(delta_time)
    end
  end
  
  self.player:update(delta_time)
end

function Level1.setup(self)
  -- input setup
  self.mouse_x = 0
  self.mouse_y = 0
  self.mouse_down = false
  MOAIInputMgr.device.pointer:setCallback ( self:createPointerCallback() )
  MOAIInputMgr.device.mouseLeft:setCallback (self:createMouseLeftCallback() )
  MOAIInputMgr.device.keyboard:setCallback ( self:createKeyboardCallback() )
  
  local player = PlayerShip.new(0, -300, bounds)
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
  -- enemies
  -- controllers and bullets
  -- player
  
  
end

function Level1.createEnemy(self, x, y, config, b_index, bounds)
  local enemy = Enemy.new(x, y, EnemyTypes.enemy_small, b_index, bounds)
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
    utils.threadSleep(2)

    if not self.finished then
      self:createEnemy(-180, 450, EnemyTypes.enemy_small, 1, bounds)
      utils.threadSleep(2)
    end

    if not self.finished then
      self:createEnemy(180, 450, EnemyTypes.enemy_small, 1, bounds)
      utils.threadSleep(2)
    end
    
    for i = 0, 10 do
      if not self.finished then
        self:createEnemy(-260, 420, EnemyTypes.enemy_small, 2, bounds)
        utils.threadSleep(0.1)
      end
    end
        
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
  
  