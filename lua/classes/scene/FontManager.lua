local class = require 'libs/30log/30log'
local FontManager = class('FontManager', { fonts = {} } )
local instance = FontManager()

function FontManager.new() 
  error('Cannot instantiate FontManager') 
end

function FontManager.extend() 
  error('Cannot extend from a FontManager')
end

function FontManager:init()	
end

function FontManager:getInstance()
  return instance
end

function FontManager:addFont(font, name)
	self.fonts[name] = font
end

function FontManager:getFont(name)
	return self.fonts[name]
end

return FontManager