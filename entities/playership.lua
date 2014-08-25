
Bullet = require 'entities/bullet'
BulletTypes = require 'entities/bullettypes'

-- main player


local PlayerShip = {}
PlayerShip.__index = PlayerShip  -- dont forget this.

local TAG = 'PLAYER_SHIP'
local speed = 500


local deck = MOAIGfxQuad2D.new()
deck:setTexture( ResourceManager.getSprite( 'ship.png') )
deck:setRect(-24, -32, 24, 32)


function PlayerShip.new(x, y, boundaries)
  local ship = setmetatable({}, PlayerShip)
  
  -- inits
  local prop = MOAIProp2D.new()
  prop:setDeck(deck)
  prop:setLoc(0, 0)
  
  local body = physicsWorld:addBody(MOAIBox2DBody.KINEMATIC)
  body:setTransform(x, y)
  
  prop:setAttrLink(MOAIProp2D.INHERIT_LOC, body, MOAIProp2D.TRANSFORM_TRAIT)
  
  local fixture = body:addRect(-16, -16, 16, 16)
  fixture:setSensor(true)
  
  ---[[
  local controller = BulletController.new (body, 
                                           layers[layer_PlayerBullets], 
                                           BulletTypes.player, 
                                           boundaries)
  --controller:start()
  --]]
  
  local behaviour = MOAICoroutine.new()
  
  -- putting everything in its place
  ship.prop = prop
  ship.body = body
  ship.fixture = fixture
  fixture.entity = ship
  ship.controller = controller
  ship.behaviour = behaviour
  
  
  ship.TAG = TAG
  
  ship.direction = { x = 0, y = 0 }
  ship.boundaries = boundaries
  ship.destination = nil
  
  behaviour:run(ship:createBehaviour())
  return ship
end


function PlayerShip.update(self, delta_time)
  
  local x, y = self.body:getPosition()
  local mov_x = (self.direction.x * delta_time)
  local mov_y = (self.direction.y * delta_time)
  local new_x = x + mov_x
  local new_y = y + mov_y
  
  if self.boundaries then
    new_x = lume.clamp(new_x, self.boundaries.min_x, self.boundaries.max_x)
    new_y = lume.clamp(new_y, self.boundaries.min_y, self.boundaries.max_y)
  end
  
  if self.destination then
    local distance = lume.distance(x, y, self.destination.x, self.destination.y)
    local travel = lume.norm(mov_x, mov_y)
    if distance < travel then
      new_x = x + (mov_x / travel) * distance
      new_y = y + (mov_y / travel) * distance
      self.destination = nil
      self:resetDirection()
    end
  end
  
  self.body:setTransform(new_x, new_y)
  
  self.controller:update(delta_time)
end

-- to be used with touch/mouse input
function PlayerShip.setDirection(self, x, y)
  local pos_x, pos_y = self.body:getPosition()
  local v_x = x - pos_x
  local v_y = y - pos_y
  
  local new_x, new_y = lume.normalize(v_x, v_y)
  self.direction.x = speed * new_x
  self.direction.y = speed * new_y
end

function PlayerShip.resetDirection(self)
  self.direction = { x = 0, y = 0 }
end

-- needed for the ship to stop when reaching the mouse pointer
function PlayerShip.setDestination(self, x, y)
  self.destination = { x = x, y = y }
end
  
function PlayerShip.resetDestination(self, x, y)
  self.destination = nil
end  
  
-- to be used with keyboard input
function PlayerShip.addDirection(self, x, y)
  self.direction.x = self.direction.x + x * speed
  self.direction.y = self.direction.y + y * speed
end

function PlayerShip.setBoundaries(self, min_x, min_y, max_x, max_y)
  self.boundaries = { min_x = min_x,
                      min_y = min_y,
                      max_x = max_x,
                      max_y = max_y
                    }
end

function PlayerShip.destroy(self)
  self.behaviour:stop()
  
  -- destroy physics
  
  self.controller:destroy()
  layers[layer_Player]:removeProp(self.prop)
  self.prop = nil
  self.deck = nil
end

function PlayerShip.createBehaviour(self)
  local state = 0
  local span = BulletTypes.player.rate_of_fire
  
  local f = function()
    local timer = MOAITimer.new()
    
    while true do
      if state == 0 then 
        self.controller:createBullet(0, 30)
        state = 1
      else
        self.controller:createBullet(-10, 30)
        self.controller:createBullet(10, 30)
        state = 0
      end

      timer:setSpan(span)
      timer:start()
      MOAICoroutine.blockOnAction(timer)
    end
  end
  return f
end
      

return PlayerShip