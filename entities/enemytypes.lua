
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

local enemy1_deck = MOAIGfxQuad2D.new()
enemy1_deck:setTexture( ResourceManager.getSprite( 'enemy1.png') )
enemy1_deck:setRect(-32, -32, 32, 32)


EnemyTypes.enemy1 = { TAG = 'ENEMY',
                      deck = enemy1_deck,
                      life = 50,
                      hitbox = { min_x = -32,
                                 min_y = -32,
                                 max_x = 32,
                                 max_y = 32
                               },
                      bulletType = BulletTypes.enemy1,
                    }
EnemyTypes.enemy1.behaviour = function (enemy)
    local state = 0
    local f = function ()
      enemy.body:setLinearVelocity(0, 0)
      if state == 0 then
        print(state)
        enemy.body:setLinearVelocity(30, 0)
        state = 1
        enemy.timer:stop()
        enemy.timer:setSpan(4)
        enemy.timer:start()
      elseif state == 1 then
        print(state)
        enemy.body:setLinearVelocity(0, -30)
        state = 2
        enemy.timer:stop()
        enemy.timer:setSpan(4)
        enemy.timer:start()
      elseif state == 2 then 
        print(state)
        enemy.body:setLinearVelocity(-30, 0)
        state = 3
        enemy.timer:stop()
        enemy.timer:setSpan(5)
        enemy.timer:start()
      else
        print(state)
        enemy.dead = true
      end
    end
    return f
  end
        

return EnemyTypes