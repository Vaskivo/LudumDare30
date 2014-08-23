
-- main player


local PlayerShip = {}
PlayerShip.__index = PlayerShip  -- dont forget this.

local TAG = 'PLAYER_SHIP'
local speed = 300

local deck = MOAIScriptDeck.new()
deck:setRect(-24, -32, 24, 32)
deck:setDrawCallback(
  function ()
    MOAIGfxDevice.setPenColor(1,0,0)
    MOAIDraw.fillRect(-24, -32, 24, 32)
  end
)


function PlayerShip.new()
  local ship = setmetatable({}, PlayerShip)
  
  -- inits
  local prop = MOAIProp2D.new()
  prop:setDeck(deck)
  prop:setLoc(0, 0)
  
  
  -- putting everything in its place
  ship.prop = prop
  ship.TAG = TAG
  
  ship.direction = { x = 0, y = 0 }
  ship.boundaries = nil   -- explicit for readability
  ship.destination = nil
  
  return ship
end


function PlayerShip.update(self, delta_time)
  local x, y = self.prop:getLoc()
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
  
  self.prop:setLoc(new_x, new_y)
end

-- to be used with touch/mouse input
function PlayerShip.setDirection(self, x, y)
  local pos_x, pos_y = self.prop:getLoc()
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

return PlayerShip