local Scene = require 'classes/scene/Scene'
local ShearTestScene = Scene:extend('ShearTestScene')

function ShearTestScene:init()
	ShearTestScene.super.init(self)
	self.image = love.graphics.newImage('data/images/building1.jpg')
	self.imageData = self.image:getData()
	self.shearX = 0
end

local data = love.image.newImageData(100,100)
function ShearTestScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight	
	
	local img = self.image
	local w = img:getWidth()
	local h = img:getHeight()
	
	love.graphics.draw(img, sw / 2, sh / 2, 0, 0.3, 0.5, w / 2, h / 2, 0, self.shearX)
	love.graphics.print(self.shearX, 10, 800)

	local imageData = self.imageData
	
	for x = 0, 99 do 
		for y = 0, 99 do
			local r, g, b, a = imageData:getPixel(x, y)
			data:setPixel(x, y, 255, 255, 255, (x * 8))
		end
	end
	
	local img = love.graphics.newImage(data)
	love.graphics.draw(img, 100, 100, 0, 3, 3)
end

function ShearTestScene:update(dt)
	self.shearX = self.shearX + (0 * dt)
end

return ShearTestScene