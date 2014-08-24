

local BulletTypes = {}

local player_bullet_deck = MOAIGfxQuad2D.new()
player_bullet_deck:setTexture( ResourceManager.getSprite('player_shot.png') )
player_bullet_deck:setRect(-4, -16, 4, 16)


-- player bullets
BulletTypes.player = { TAG = 'PLAYER_BULLET',
                       deck = player_bullet_deck,
                       direction = { x = 0, y = 1},
                       speed = 800,
                       rate_of_fire = 1/30,
                       hitbox_radius = 4
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
                       rate_of_fire = 2,
                       hitbox_radius = 5,
                     }
BulletTypes.enemy1.behaviour = function (controller)
    local f = function ()
      controller:createBullet(0, -20)
    end
    return f
  end



return BulletTypes