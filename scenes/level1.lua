
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

local bounds = { min_x = -250,
                 min_y = -410,
                 max_x = 250,
                 max_y = 410
                }

function Level1.new()
  local scene = setmetatable({}, Level1)
  
  return scene
end

function Level1.update(self, delta_time)
  for enemy, _ in pairs(self.enemies) do
    enemy:update(delta_time)
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
  
  self.enemies = {}
  
  local enemy = Enemy.new(-200, 300, EnemyTypes.enemy_small, bounds)
  layers[layer_Enemies]:insertProp(enemy.prop)
  
  self.enemies[enemy] = true
  self.player = player
end

function Level1.cleanup(self)
  
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
  
  