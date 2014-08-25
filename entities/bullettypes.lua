

local BulletTypes = {}

local player_bullet_deck = MOAIGfxQuad2D.new()
player_bullet_deck:setTexture( ResourceManager.getSprite('player_shot.png') )
player_bullet_deck:setRect(-4, -16, 4, 16)


-- player bullets
BulletTypes.player = { TAG = 'PLAYER_BULLET',
                       deck = player_bullet_deck,
                       direction = { x = 0, y = 1},
                       speed = 1000,
                       rate_of_fire = 1/60,
                       hitbox_radius = 4
                     }

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




return BulletTypes