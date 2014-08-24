
-- This class is basically "bullet AI"


Bullet = require 'entities/bullet'
BulletTypes = require 'entities/bullettypes'

local BulletController = {}
BulletController.__index = BulletController


function BulletController.new(transform, layer, config, boundaries)
  local controller = setmetatable({}, BulletController)
  
  local timer = MOAITimer.new()
  timer:setSpan(config.rate_of_fire)
  timer:setMode(MOAITimer.LOOP)
  timer:setListener(MOAITimer.EVENT_TIMER_LOOP, config.behaviour(controller))
  
  controller.transform = transform
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
  local my_x, my_y = self.transform:getLoc()
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

function BulletController.startController(self)
  self.timer:start()
end

function BulletController.stopController(self)
  self.timer:stop()
end




return BulletController