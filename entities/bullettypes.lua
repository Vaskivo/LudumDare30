

local BulletTypes = {}

local deck = MOAIScriptDeck.new()
deck:setRect(-10, -10, 10, 10)
deck:setDrawCallback(
  function ()
    MOAIGfxDevice.setPenColor(1,0,0)
    MOAIDraw.fillCircle(0, 0, 10)
  end
)

BulletTypes.player = { TAG = 'PLAYER_BULLET'
                       deck = deck,
                       direction = { x = 0, y = 500},
                       speed = 1000,
                       rate_of_fire = 1/20,
                     }
BulletTypes.player.behaviour = function (controller)
    local state = 0
    local f = function ()
        if state == 0 then
          controller:createBullet(0, 0)
          state = 1
        elseif state == 1 then
          controller:createBullet(-10, 0)
          controller:createBullet(10, 0)
          state = 0
        end
      end
    return f
  end





return BulletTypes