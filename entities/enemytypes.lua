
BulletTypes = require 'entities/bullettypes'

local EnemyTypes = {}

--[[
local deck = MOAIScriptDeck.new()
deck:setRect(-32, -32, 32, 32)
deck:setDrawCallback(
  function ()
    MOAIGfxDevice.setPenColor(0,0,1)
    MOAIDraw.fillRect(-32, -32, 32, 32)
  end
)
]]

local enemy_small_deck = MOAIGfxQuad2D.new()
enemy_small_deck:setTexture( ResourceManager.getSprite( 'enemy_small.png') )
enemy_small_deck:setRect(-16, -16, 16, 16)


EnemyTypes.enemy_small = { TAG = 'ENEMY',
                           deck = enemy_small_deck,
                           life = 25,
                           hitbox = { min_x = -16,
                                      min_y = -16,
                                      max_x = 16,
                                      max_y = 16
                                    },
                           bulletType = BulletTypes.enemy1,
                         }
EnemyTypes.enemy_small.behaviour = function(enemy)
  local state = 0
  local test = function()
    return enemy and enemy.body
  end
  
  local f = function()
    local timer = MOAITimer.new()
    
    -- first action
    if test then
      enemy.body:setLinearVelocity(0, -20)
      timer:setSpan(2)
      timer:start()
      MOAICoroutine.blockOnAction(timer)
    end
    
    -- second action
    if test then
      enemy.body:setLinearVelocity(20, 0)
      timer:setSpan(2)
      timer:start()
    end
    
    
  end
  return f
end
--[[
EnemyTypes.enemy_small.behaviour = function(enemy)
  local state = 0
  local f = function()
    if not enemy or not enemy.body then
      return
    end
    if state == 0 then
      enemy.body:setLinearVelocity(0, -100)
      state = 1
    else state = 1 then
      if not enemy:insideBoundaries() then
        enemy.dead = true
        state = 2
      end
    else
      enemy.dead = true
    end
  end
  return f
end
--]]

EnemyTypes.enemy_small_1 = { TAG = 'ENEMY',
                             deck = enemy_small_deck,
                             life = 25,
                             hitbox = { min_x = -16,
                                        min_y = -16,
                                        max_x = 16,
                                        max_y = 16
                                      },
                             bulletType = BulletTypes.enemy1,
                           }
EnemyTypes.enemy_small_1.behaviour = function (enemy)
  local state = 0
  local f = function ()
    if not enemy or not enemy.body then
      return
    end
    if state == 0 then
      enemy.body:setLinearVelocity(200, -200)
      state = 1
    elseif state == 1 then
      if not enemy:insideBoundaries() then
        enemy.dead = true
        state = 2
      end
    else
      enemy.dead = true
    end
  end
  return f
end
    
    
EnemyTypes.enemy_small_2 = { TAG = 'ENEMY',
                             deck = enemy_small_deck,
                             life = 50,
                             hitbox = { min_x = -16,
                                        min_y = -16,
                                        max_x = 16,
                                        max_y = 16
                                      },
                             bulletType = BulletTypes.enemy1,
                           }
EnemyTypes.enemy_small_2.behaviour = function (enemy)
  local state = 0
  local f = function ()
    if not enemy or not enemy.body then
      return
    end
    if state == 0 then
      enemy.body:setLinearVelocity(-200, -200)
      state = 1
    elseif state == 1 then
      if not enemy:insideBoundaries() then
        enemy.dead = true
        state = 2
      end
    else
      enemy.dead = true
    end
  end
  return f
end
    

return EnemyTypes