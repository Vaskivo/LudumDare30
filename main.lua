-------------------------------------------------------------------------------                    
-- Ensure undefined global access is an error.                                                     
-------------------------------------------------------------------------------                    

local global_meta = {}      
setmetatable(_G, global_meta)

function global_meta:__index(k)
    error("Undefined global variable '" .. k .. "'!")                                              
end


lume = require 'utils/lume'
inspect = require 'utils/inspect'

-- Here we go!!

SCREEN_WIDTH = 480
SCREEN_HEIGHT = 800

MOAISim.openWindow('Unnamed', SCREEN_WIDTH, SCREEN_HEIGHT)

viewport = MOAIViewport.new()
viewport:setSize(SCREEN_WIDTH, SCREEN_HEIGHT)
viewport:setScale(SCREEN_WIDTH, SCREEN_HEIGHT)

layer = MOAILayer2D.new()
layer:setViewport(viewport)

MOAIRenderMgr.setRenderTable( { layer } )




-- do stuff

PlayerShip = require 'entities/playership'
Bullet = require 'entities/bullet'
BulletController = require 'entities/bulletcontroller'
BulletTypes = require 'entities/bullettypes'
Enemy = require 'entities/enemy'


player = PlayerShip.new()
player:setBoundaries(-240, -400, 240, 400)

layer:insertProp(player.prop)

controller = BulletController.new (player.prop, layer, BulletTypes.player)
controller:startController()

enemy = Enemy.new(-50, 300)
layer:insertProp(enemy.prop)


function main()
  while true do
    local now = MOAISim.getElapsedTime()
    local delta_time = now - run_time
    
    -- update stuff
    player:update(delta_time)
    --bulletMgr:update(delta_time)
    controller:update(delta_time)
    
    run_time = now
    
    coroutine.yield()
  end
end

thread = MOAICoroutine.new ()

run_time = MOAISim.getElapsedTime()
thread:run(main)




-- INPUT EVENTS

-- keyboard
function onKeyboardEvent ( key, down )	
  local key_value = string.char(key)
  
  if down == true then -- pressed key
    if key_value == 'a' then
      player:addDirection(-1, 0)
    end
    if key_value == 'd' then
      player:addDirection(1, 0)
    end
    if key_value == 'w' then
      player:addDirection(0, 1)
    end
    if key_value == 's' then
      player:addDirection(0, -1)
    end
  else                  -- released key
    if key_value == 'a' then
      player:addDirection(1, 0)
    end
    if key_value == 'd' then
      player:addDirection(-1, 0)
    end
    if key_value == 'w' then
      player:addDirection(0, -1)
    end
    if key_value == 's' then
      player:addDirection(0, 1)
    end
  end
end
MOAIInputMgr.device.keyboard:setCallback ( onKeyboardEvent )

-- mouse
mouse_x = 0
mouse_y = 0
mouse_down = false

function onPointerEvent ( x, y )
	mouse_x, mouse_y = layer:wndToWorld(x, y)
  if mouse_down then
    player:setDestination(mouse_x, mouse_y)
    player:setDirection(mouse_x, mouse_y)
  end
end
MOAIInputMgr.device.pointer:setCallback ( onPointerEvent )

function onLeftClickEvent(down)
  mouse_down = down
  if down then
    player:setDestination(mouse_x, mouse_y)
    player:setDirection(mouse_x, mouse_y)
  else
    player:resetDirection()
  end
end
MOAIInputMgr.device.mouseLeft:setCallback ( onLeftClickEvent ) 

  
  
  