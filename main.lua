

---[[  ensures an error when acessing an undefined local
local global_meta = {}      
setmetatable(_G, global_meta)

function global_meta:__index(k)
    error("Undefined global variable '" .. k .. "'!")                                              
end
--]]

lume = require 'utils/lume'
inspect = require 'utils/inspect'
utils = require 'utils/utils'


-- Stting up stuff

SCREEN_WIDTH = 480
SCREEN_HEIGHT = 800

MOAISim.openWindow('Unnamed', SCREEN_WIDTH, SCREEN_HEIGHT)

viewport = MOAIViewport.new()
viewport:setSize(SCREEN_WIDTH, SCREEN_HEIGHT)
viewport:setScale(SCREEN_WIDTH, SCREEN_HEIGHT)


-- layers
layer_Background = 1
layer_Enemies = 2
layer_Player = 3
layer_PlayerBullets = 4
layer_EnemyBullets = 5
layer_GUI = 6
layer_GUIText = 7

layers = {}
function resetLayers()
  layers = {}
  for i = 1, 7 do
    local layer = MOAILayer2D.new()
    layer:setViewport(viewport)
    layers[i] = layer
  end
  MOAIRenderMgr.setRenderTable(nil)
  MOAIRenderMgr.setRenderTable( layers )
  return layers
end
resetLayers()

MOAIRenderMgr.setRenderTable( layers )

physicsWorld = MOAIBox2DWorld.new()
physicsWorld:setUnitsToMeters(0.1)
physicsWorld:start()

require 'utils/utils'
SceneManager = require 'scenemgr'

sceneManager = SceneManager.new()

sceneManager:switchToScene('title')
sceneManager:start()
