
-- make namespace global
_G.ResourceManager = {}

-- constants:
--              resource folder path
ResourceManager.RES_PATH = './res/'
--              images folder path
ResourceManager.SPRITES_PATH = ResourceManager.RES_PATH .. 'sprites/'
--              fonts folder path
ResourceManager.FONTS_PATH = ResourceManager.RES_PATH .. 'fonts/'


-- create a cache for fonts and images
local spriteCache = {}

-- retrieve sprite
function ResourceManager.getSprite(filename)
  
  if spriteCache[filename] then
    return spriteCache[filename]
  end
  
  local sprite = MOAIImage.new()
  sprite:load( ResourceManager.SPRITES_PATH .. filename )
  spriteCache[filename] = sprite
  
  return sprite  
end










