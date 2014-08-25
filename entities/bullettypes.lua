

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

local enemy_bullet_deck = MOAIGfxQuad2D.new()
enemy_bullet_deck:setRect(-12, -12, 12, 12)
enemy_bullet_deck:setTexture( ResourceManager.getSprite('enemy_bullet.png') )

BulletTypes.enemy1 = { TAG = 'ENEMY_BULLET',
                       deck = enemy_bullet_deck,
                       direction = { x = 0, y = -1},
                       speed = 20,
                       rate_of_fire = 2,
                       hitbox_radius = 5,
                     }




return BulletTypes