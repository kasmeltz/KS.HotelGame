local Scene = require 'classes/scene/Scene'
local ShearTestScene = Scene:extend('ShearTestScene')

function ShearTestScene:init()
	ShearTestScene.super.init(self)
	self.image = love.graphics.newImage('data/images/building2.jpg')
	
	local imageData = self.image:getData()	
	local id = {}
	for x = 0, 82 do 
		for y = 0, 149 do				
			local r, g, b, a = imageData:getPixel(x, y)
			id[#id + 1] = r
			id[#id + 1] = g
			id[#id + 1] = b
		end
	end
	self.id = id	
	self.transformedData = love.image.newImageData(83,150)	
	
	self.rotation = 0
end

function ShearTestScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight		
	local img = self.image
	local w = img:getWidth()
	local h = img:getHeight()
	
	local rotation = self.rotation
	local transformedData = self.transformedData
	local id = self.id	
	
	local cos = math.cos(rotation)
	local sin = math.sin(rotation)
	local cx = 0
	local cy = 0	
	
	for i = 1, 10 do
		local idx = 1
		for x = 0, 82 do 
			for y = 0, 149 do
				local r, g, b, a = 0, 0, 0, 0			
				local sx = x * cos - y * sin
				local sy = x * sin + y * cos				
				if sx >=0 and sx <= 82 and sy >= 0 and sy <= 149 then								
					idx = (sy * 3 * 82) + (sx * 3) + 1					
					idx = math.floor(idx)
					r = id[idx]
					g = id[idx + 1]
					b = id[idx + 2]
					a = 255
				end

				transformedData:setPixel(x, y, r, g, b, 255)				
			end
		end
	end	
	
	local img = love.graphics.newImage(transformedData)
	love.graphics.draw(img, 100, 100, 0, 4, 4)
	
end

function ShearTestScene:update(dt)
	self.rotation = self.rotation + (dt * 0.1)
end

return ShearTestScene