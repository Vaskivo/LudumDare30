
-- This class is basically "bullet AI"


Bullet = require 'entities/bullet'
BulletTypes = require 'entities/bullettypes'

local BulletController = {}
BulletController.__index = BulletController


function BulletController.new(parent_body, layer, config, boundaries)
  local controller = setmetatable({}, BulletController)
  
  controller.parent_body = parent_body
  controller.layer = layer
  controller.bullet_set = {}
  controller.config = config
  controller.boundaries = boundaries
  
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

function BulletController.createBullet(self, x, y, dir_x, dir_y)
  if self.parent_body then
    local my_x, my_y = self.parent_body:getPosition()
    local bullet = Bullet.new(my_x + x, my_y + y, self.config, self.boundaries)
    self.layer:insertProp(bullet.prop)
    self.bullet_set[bullet] = true
    
    if dir_x and dir_y then
      bullet:setDirection(dir_x, dir_y)
    end
  end
end

function BulletController.destroyBullet(self, bullet)
  if self.bullet_set[bullet] then
    self.layer:removeProp(bullet.prop)
    bullet:destroy()
    self.bullet_set[bullet] = nil
  end
end

function BulletController.destroy(self)
  for bullet, _ in pairs(self.bullet_set) do
    self:destroyBullet(bullet)
  end
  
  self.parent_body = nil
  self.layer = nil
  self.bullet_set = nil
  self.config = nil
  self.boundaries = nil
end


return BulletController