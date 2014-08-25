
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
                           life = 3,
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
  
  local f = function()      -- straight down
    local timer = MOAITimer.new()
    -- first action
    if test() then
      enemy.body:setLinearVelocity(0, -250)
    end
    utils.threadSleep(10)
    enemy.dead = true
  end
  return f
end

EnemyTypes.enemy_small.behaviour[2] = function(enemy)
  local test = function()
    return enemy and enemy.body
  end
  
  local f = function()      -- down-right
    local timer = MOAITimer.new()
    
    if test() then
      enemy.body:setLinearVelocity(250, -180)
      
      utils.threadSleep(1)
    end
    
    if test() then
      
      enemy.bulletController:createBullet(0, -12)
    end
    
    utils.threadSleep(10)
    enemy.dead = true
  end
  return f
end

EnemyTypes.enemy_small.behaviour[3] = function(enemy)
  local test = function()
    return enemy and enemy.body
  end
  
  local f = function()      -- down-left
    local timer = MOAITimer.new()
    
    if test() then
      enemy.body:setLinearVelocity(-250, -180)
    end
    utils.threadSleep(1)
    if test() then
      
      enemy.bulletController:createBullet(0, -12)
    end
    
    utils.threadSleep(10)
    enemy.dead = true
  end
  return f
end    

EnemyTypes.enemy_small.behaviour[4] = function(enemy)
  local test = function()
    return enemy and enemy.body
  end
  
  local f = function()        -- down then left
    local timer = MOAITimer.new()
    
    if test() then
      enemy.body:setLinearVelocity(0, -250)
    end
    utils.threadSleep(1)
    
    if test() then
      enemy.bulletController:createBullet(0, -12)
      enemy.body:setLinearVelocity(0, 0)
    end
    utils.threadSleep(2)
    
    if test() then
      enemy.body:setLinearVelocity(-250, 0)
    end
    utils.threadSleep(10)
    
    enemy.dead = true
  end
  return f
end   

EnemyTypes.enemy_small.behaviour[5] = function(enemy)
  local test = function()
    return enemy and enemy.body
  end
  
  local f = function()      -- down then right
    local timer = MOAITimer.new()
    
    if test() then
      enemy.body:setLinearVelocity(0, -250)
    end
    utils.threadSleep(1)
    
    if test() then
      enemy.bulletController:createBullet(0, -12)
      enemy.body:setLinearVelocity(0, 0)
    end
    utils.threadSleep(2)
    
    if test() then
      enemy.body:setLinearVelocity(250, 0)
    end
    utils.threadSleep(10)
    
    enemy.dead = true
  end
  return f
end   



local enemy_normal_deck = MOAIGfxQuad2D.new()
enemy_normal_deck:setTexture( ResourceManager.getSprite( 'big_ship.png') )
enemy_normal_deck:setRect(-48, -32, 48, 32)

EnemyTypes.enemy_normal = { TAG = 'ENEMY',
                            deck = enemy_normal_deck,
                            life = 100,
                            hitbox = { min_x = -45,
                                       min_y = -30,
                                       max_x = 45,
                                       max_y = 30
                                     },
                            bulletType = BulletTypes.enemy1,
                            behaviour = {},
                          }
EnemyTypes.enemy_normal.behaviour[1] = function(enemy)
  local test = function()
    return enemy and enemy.body
  end
  
  local f = function()
    if test() then 
      enemy.body:setLinearVelocity(0, -200)
    end
    utils.threadSleep(1.5)
    
    for i = 1, 3 do
      for j = 1, 3 do
        if test() then
          enemy.body:setLinearVelocity(0, 0)
          enemy.bulletController:createBullet(0, -12, -1, -1)
          enemy.bulletController:createBullet(0, -12, -0.5, -1)
          enemy.bulletController:createBullet(0, -12, 0, -1)
          enemy.bulletController:createBullet(0, -12, 0.5, -1)
          enemy.bulletController:createBullet(0, -12, 1, -1)
        end
        utils.threadSleep(0.1)
      end
      utils.threadSleep(2)
    end
    utils.threadSleep(1)
    
    if test() then 
      enemy.body:setLinearVelocity(0, 200)
    end
    utils.threadSleep(5)
    
    enemy.dead = true
  end
  return f
end


return EnemyTypes