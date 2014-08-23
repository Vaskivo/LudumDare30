

-- NOT USED!!!


Bullet = require 'entities/bullet'
BulletTypes = require 'entities/bullettypes'


local BulletManager = {}
BulletManager.__index = BulletManager


function BulletManager.new(layer)
  local manager = setmetatable({}, BulletManager)
  
  manager.bullet_set = {}
  manager.layer = layer
  
  return manager
end


function BulletManager.update(self, delta_time)
  for bullet, _ in pairs(self.bullet_set) do
    bullet:update(delta_time)
  end
end


function BulletManager.createBullet(self, x, y, bulletType)
  local bullet = Bullet.new(x, y, bulletType)
  self.layer:insertProp(bullet.prop)
  self.bullet_set[bullet] = true
end




return BulletManager