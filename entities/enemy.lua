
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
  prop:setLoc(0, 0)
  
  local body = physicsWorld:addBody(MOAIBox2DBody.KINEMATIC)
  body:setTransform(x, y)
  
  prop:setAttrLink(MOAIProp2D.INHERIT_LOC, body, MOAIProp2D.TRANSFORM_TRAIT)
  
  local fixture = body:addRect(-32, -32, 32, 32)
  fixture:setCollisionHandler(Enemy._collisionCallback, MOAIBox2DArbiter.ALL)
  fixture:setSensor(true)
  
  -- putting everything in it's place
  enemy.prop = prop
  enemy.body = body
  enemy.fixture = fixture
  fixture.entity = enemy
  
  enemy.TAG = TAG
  
  enemy.dead = false
  
  return enemy
end

function Enemy.update(delta_time)
  -- do stuff
end

function Enemy._collisionCallback( event, fixtureA, fixtureB, arbiter )
  local tag = nil
  if fixtureB.entity and fixtureB.entity.TAG then
    tag = fixtureB.entity.TAG
  end
  
	if event == MOAIBox2DArbiter.BEGIN then
		if tag == 'PLAYER_BULLET' then
      -- do stuff
      fixtureB.entity.dead = true
    end
	end
	
	if event == MOAIBox2DArbiter.END then
		--print ( 'end!' )
	end
	
	if event == MOAIBox2DArbiter.PRE_SOLVE then
		--print ( 'pre!' )
	end
	
	if event == MOAIBox2DArbiter.POST_SOLVE then
    --print ( 'post!' )
	end
end
 









return Enemy