

local BulletTypes = {}

local deck = MOAIScriptDeck.new()
deck:setRect(-10, -10, 10, 10)
deck:setDrawCallback(
  function ()
    MOAIGfxDevice.setPenColor(1,0,0)
    MOAIDraw.fillCircle(0, 0, 10)
  end
)

-- player bullets
BulletTypes.player = { TAG = 'PLAYER_BULLET',
                       deck = deck,
                       direction = { x = 0, y = 1},
                       speed = 500,
                       rate_of_fire = 1/20,
                       hitbox_radius = 5
                     }
BulletTypes.player.behaviour = function (controller)
    local state = 0
    local f = function ()
        if state == 0 then
          controller:createBullet(0, 30)
          state = 1
        elseif state == 1 then
          controller:createBullet(-10, 30)
          controller:createBullet(10, 30)
          state = 0
        end
      end
    return f
  end


local deck1 = MOAIScriptDeck.new()
deck1:setRect(-10, -10, 10, 10)
deck1:setDrawCallback(
  function ()
    MOAIGfxDevice.setPenColor(1,1,0)
    MOAIDraw.fillCircle(0, 0, 10)
  end
)

BulletTypes.enemy1 = { TAG = 'ENEMY_BULLET',
                       deck = deck1,
                       direction = { x = 0, y = -1},
                       speed = 200,
                       rate_of_fire = 1,
                       hitbox_radius = 5,
                     }
BulletTypes.enemy1.behaviour = function (controller)
    local f = function ()
      controller:createBullet(-10, -20)
      controller:createBullet(10, -20)
    end
    return f
  end



return BulletTypes