
local Enemy = {}
Enemy.__index = Enemy

local TAG = 'ENEMY'

local deck = MOAIScriptDeck.new()
deck:setRect(-32, -32, 32, 32)
deck:setDrawCallback(
  function ()
    MOAIGfxDevice.setPenColor(0,0,1)
    MOAIDraw.fillRect(-32, -32, 32, 32)
  end
)


function Enemy.new(x, y)
  local enemy = setmetatable({}, Enemy)
  
  -- inits
  local prop = MOAIProp2D.new()
  prop:setDeck(deck)
  prop:setLoc(x, y)
  
  -- putting everything in it's place
  enemy.prop = prop
  enemy.TAG = TAG
  
  
  return enemy
end

function Enemy.update(delta_time)
  -- do stuff
end
  








return Enemy