
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
                           life = 5,
                           hitbox = { min_x = -16,
                                      min_y = -16,
                                      max_x = 16,
                                      max_y = 16
                                    },
                           bulletType = BulletTypes.enemy1,
                           behaviour = {},
                         }
EnemyTypes.enemy_small.behaviour[1] = function(enemy)
  local test = function()
    return enemy and enemy.body
  end
  
  local f = function()
    local timer = MOAITimer.new()
    -- first action
    if test() then
      enemy.body:setLinearVelocity(0, -250)
    end
  end
  return f
end


EnemyTypes.enemy_small.behaviour[2] = function(enemy)
  local test = function()
    return enemy and enemy.body
  end
  
  local f = function()
    local timer = MOAITimer.new()
    
    if test() then
      enemy.body:setLinearVelocity(250, -180)
      
      utils.threadSleep(2)
    end
    
    if test() then
      
      enemy.bulletController:createBullet(0, -12)
    end
  end
  return f
end

    

return EnemyTypes