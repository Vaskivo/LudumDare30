
local Bullet = {}
Bullet.__index = Bullet


function Bullet.new(x, y, config, boundaries)
  local bullet = setmetatable({}, Bullet)
  
  -- inits
  local prop = MOAIProp2D.new()
  prop:setDeck(config.deck)
  prop:setLoc(0, 0)
  
  local body = physicsWorld:addBody(MOAIBox2DBody.DYNAMIC)
  body:setTransform(x, y)
  
  prop:setAttrLink(MOAIProp2D.INHERIT_LOC, body, MOAIProp2D.TRANSFORM_TRAIT)
  
  local fixture = body:addCircle(0, 0, config.hitbox_radius)
  fixture:setSensor(true)
  
  body:setLinearVelocity(config.direction.x * config.speed, 
                         config.direction.y * config.speed)
  
  -- putting everything in its place
  bullet.prop = prop
  bullet.deck = config.deck
  bullet.body = body
  bullet.fixture = fixture
  fixture.entity = bullet
  
  bullet.TAG = config.TAG
  bullet.speed = config.speed
  bullet.direction = config.direction
  bullet.rate_of_fire = config.rate_of_fire
  bullet.hitbox_radius = config.hitbox_radius
  
  bullet.boundaries = boundaries
  
  bullet.dead = false
  
  return bullet
end

function Bullet.update(self, delta_time)
  local x, y = self.body:getPosition()
  
  if self.boundaries then
    local bounds = self.boundaries
    if not lume.inside(y, bounds.min_y, bounds.max_y) or
        not lume.inside(x, bounds.min_x, bounds.max_x) then
      self.dead = true
    end
  end
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

function Bullet.destroy(self)
  self.fixture.entity = nil
  self.fixture:destroy()
  self.fixture = nil
  self.body:destroy()
  self.body = nil
  
  self.deck = nil
  self.prop = nil
end


return Bullet