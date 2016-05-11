local class = require 'libs/30log/30log'
local SpriteSheetManager = class('SpriteSheetManager', { sheets = {} } )
local instance = SpriteSheetManager()

function SpriteSheetManager.new() 
  error('Cannot instantiate SpriteSheetManager') 
end

function SpriteSheetManager.extend() 
  error('Cannot extend from a SpriteSheetManager')
end

function SpriteSheetManager:init()	
end

function SpriteSheetManager:getInstance()
  return instance
end

function SpriteSheetManager:addSheet(sheet, name)
	self.sheets[name] = sheet
end

function SpriteSheetManager:getSheet(name)
	return self.sheets[name]
end

return SpriteSheetManager