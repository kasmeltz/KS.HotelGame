local class = require 'libs/30log/30log'
local Drawable = class('Drawable')

function Drawable:draw() end

function Drawable:init() 
	self.screenWidth, self.screenHeight = love.graphics.getDimensions( )
end

return Drawable