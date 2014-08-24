
local Enemy = {}
Enemy.__index = Enemy

local deck = MOAIScriptDeck.new()
deck:setRect(-32, -32, 32, 32)
deck:setDrawCallback(
  function ()
    MOAIGfxDevice.setPenColor(0,0,1)
    MOAIDraw.fillRect(-32, -32, 32, 32)
  end
)


function Enemy.new(x, y, config, boundaries)
  local enemy = setmetatable({}, Enemy)
  
  -- inits
  local prop = MOAIProp2D.new()
  prop:setDeck(config.deck)
  prop:setLoc(0, 0)
  
  local body = physicsWorld:addBody(MOAIBox2DBody.KINEMATIC)
  body:setTransform(x, y)
  
  prop:setAttrLink(MOAIProp2D.INHERIT_LOC, body, MOAIProp2D.TRANSFORM_TRAIT)
  
  local fixture = body:addRect(config.hitbox.min_x, config.hitbox.min_y, 
                               config.hitbox.max_x, config.hitbox.max_y)
  fixture:setCollisionHandler(Enemy._collisionCallback, MOAIBox2DArbiter.ALL)
  fixture:setSensor(true)
  
  local bulletController = BulletController.new (body, 
                                                 layers[layer_EnemyBullets], 
                                                 BulletTypes.enemy1, 
                                                 boundaries)
  bulletController:start()

  
  --[[
  local timer = MOAITimer.new()
  timer:setSpan(1)
  timer:setMode(MOAITimer.LOOP)
  timer:setListener(MOAITimer.EVENT_TIMER_LOOP, config.behaviour(enemy))
  timer:start()
  --]]
  local behaviour = MOAICoroutine.new()
  
  
  -- putting everything in it's place
  enemy.prop = prop
  enemy.body = body
  enemy.fixture = fixture
  fixture.entity = enemy
  
  enemy.bulletController = bulletController
  enemy.behaviour = behaviour
  --enemy.timer = timer
  
  enemy.TAG = config.TAG
  enemy.life = config.life
  enemy.hitbox = config.hitbox
  enemy.bulletType = config.bulletType
  enemy.boundaries = boundaries
  
  enemy.dead = false
  enemy.hitsLastFrame = 0
  
  
  behaviour:run(config.behaviour(enemy))
  return enemy
end

function Enemy.update(self, delta_time)
  -- do stuff
  if self.dead then
    return
  end
  
  self.life = self.life - self.hitsLastFrame
  self.hitsLastFrame = 0
  
  if self.life <= 0 then
    self:destroy()
    self.dead = true
  end  
end

function Enemy.destroy(self)
  --self.bulletController:destroy()
  --self.bulletController = nil
  self.bulletController:stop()
  
  self.fixture.entity = nil
  self.fixture:destroy()
  self.fixture = nil
  
  self.body:destroy()
  self.body = nil
  
  layers[layer_Enemies]:removeProp(self.prop)
  self.prop = nil
  self.deck = nil
end

function Enemy.insideBoundaries(self)
  local bounds = self.boundaries
  local x, y = self.body:getPosition()
  
  return lume.inside(y, bounds.min_y, bounds.max_y) and 
         lume.inside(x, bounds.min_x, bounds.max_x) 
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
      fixtureA.entity.hitsLastFrame = fixtureA.entity.hitsLastFrame + 1
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