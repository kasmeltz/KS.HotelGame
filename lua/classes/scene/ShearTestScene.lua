local Scene = require 'classes/scene/Scene'
local ShearTestScene = Scene:extend('ShearTestScene')

local toChannel = love.thread.getChannel('toBuildings')
local fromChannel = love.thread.getChannel('fromBuildings')

function ShearTestScene:init()
	ShearTestScene.super.init(self)
	self.image = love.graphics.newImage('data/images/building2.jpg')
end

function ShearTestScene:show()	
	local sw = self.screenWidth
	local sh = self.screenHeight		
	
	toChannel:push{sw, sh}
	local backBufferData = love.image.newImageData(sw,sh)	
	local backBufferImg = love.graphics.newImage(backBufferData)	
	self.backBufferData = backBufferData
	self.backBufferImg = backBufferImg	
	--toChannel:supply(backBufferData)
	
	local ptr, size = backBufferData:getPointer(), backBufferData:getSize()	
	print(backBufferData)
	print(ptr, size)
end

local redPixels = {}
local greenPixels = {}
local bluePixels = {}
for y = 0, 899 do
	redPixels[y] = {}
	greenPixels[y] = {}
	bluePixels[y] = {}
	for x = 0, 1199 do
		redPixels[y][x] = 64
		greenPixels[y][x] = 64
		bluePixels[y][x] = 64
	end
end	

function ShearTestScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
	local img = self.image
		
	local backBufferData = self.backBufferData
	local backBufferImg = self.backBufferImg	
	
--	backBufferData:clear()	

	local function fn(x, y, r, g, b, a)
		return redPixels[y][x], greenPixels[y][x], redPixels[y][x], 255
	end

	backBufferData:mapPixel(fn)		 
	
	backBufferImg:refresh()	
	love.graphics.draw(backBufferImg, 0, 0)
end

function ShearTestScene:update(dt)
end

return ShearTestScene