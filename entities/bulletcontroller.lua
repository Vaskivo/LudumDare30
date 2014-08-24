
-- This class is basically "bullet AI"


Bullet = require 'entities/bullet'
BulletTypes = require 'entities/bullettypes'

local BulletController = {}
BulletController.__index = BulletController


function BulletController.new(parent_body, layer, config, boundaries)
  local controller = setmetatable({}, BulletController)
  
  local timer = MOAITimer.new()
  timer:setSpan(config.rate_of_fire)
  timer:setMode(MOAITimer.LOOP)
  timer:setListener(MOAITimer.EVENT_TIMER_LOOP, config.behaviour(controller))
  
  controller.parent_body = parent_body
  controller.layer = layer
  controller.bullet_set = {}
  controller.config = config
  controller.boundaries = boundaries
  controller.timer = timer
  
  return controller
end


function BulletController.update(self, delta_time)
  for bullet, _ in pairs(self.bullet_set) do
    if bullet.dead then
      self:destroyBullet(bullet)
    else    
      bullet:update(delta_time)
    end
  end
end

function BulletController.createBullet(self, x, y)
  local my_x, my_y = self.parent_body:getPosition()
  local bullet = Bullet.new(my_x + x, my_y + y, self.config, self.boundaries)
  self.layer:insertProp(bullet.prop)
  self.bullet_set[bullet] = true
end

function BulletController.destroyBullet(self, bullet)
  if self.bullet_set[bullet] then
    self.layer:removeProp(bullet.prop)
    bullet:destroy()
    self.bullet_set[bullet] = nil
  end
end

function BulletController.start(self)
  self.timer:start()
end

function BulletController.stop(self)
  self.timer:stop()
end

function BulletController.destroy(self)
  self.timer:stop()
  self.timer = nil
  
  self.parent_body = nil
  self.layer = nil
  self.bullet_set = nil
  self.config = nil
  self.boundaries = nil
end


return BulletController