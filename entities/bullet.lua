
local Bullet = {}
Bullet.__index = Bullet


function Bullet.new(x, y, config)
  local bullet = setmetatable({}, Bullet)
  
  -- inits
  local prop = MOAIProp2D.new()
  prop:setDeck(config.deck)
  prop:setLoc(x, y)
  
  -- putting everything in its place
  bullet.prop = prop
  
  bullet.TAG = config.TAG
  bullet.speed = config.speed
  bullet.direction = config.direction
  bullet.rate_of_fire = config.rate_of_fire
  
  bullet.dead = false
  
  return bullet
end

function Bullet.update(self, delta_time)
  local x, y = self.prop:getLoc()
  local mov_x = (self.direction.x * delta_time)
  local mov_y = (self.direction.y * delta_time)
  local new_x = x + mov_x
  local new_y = y + mov_y
  
  if self.boundaries then
    
  end
  
  self.prop:setLoc(new_x, new_y)
end

function Bullet.setDirection(self, x, y)
  local pos_x, pos_y = self.prop:getLoc()
  local v_x = x - pos_x
  local v_y = y - pos_y
  
  local new_x, new_y = lume.normalize(v_x, v_y)
  self.direction.x = self.speed * new_x
  self.direction.y = self.speed * new_y
end

function Bullet.resetDirection(self)
  self.direction = { x = 0, y = 0 }
end



return Bullet