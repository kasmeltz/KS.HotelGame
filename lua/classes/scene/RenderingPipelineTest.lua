local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

local Scene = require 'classes/scene/Scene'
local RenderingPipelineTest = Scene:extend('RenderingPiplineTest')

function RenderingPipelineTest:init()
	local toChannel = love.thread.getChannel('toWorld')
	self.toChannel = toChannel
	local fromChannel = love.thread.getChannel('fromWorld')
	self.fromChannel = fromChannel
	
	local sw = self.screenWidth
	local sh = self.screenHeight

	local images = {}
	images[#images + 1] = love.graphics.newImage('data/images/roof.jpg')
	images[#images + 1] = love.graphics.newImage('data/images/roof2.jpg')
	images[#images + 1] = love.graphics.newImage('data/images/roof3.jpg')
	images[#images + 1] = love.graphics.newImage('data/images/roof4.jpg')
	images[#images + 1] = love.graphics.newImage('data/images/building3.png')
	images[#images + 1] = love.graphics.newImage('data/images/building4.jpg')
	images[#images + 1] = love.graphics.newImage('data/images/building5.png')
	images[#images + 1] = love.graphics.newImage('data/images/building6.jpg')
	images[#images + 1] = love.graphics.newImage('data/images/building7.jpg')	
	images[#images + 1] = love.graphics.newImage('data/images/road1.jpg')
	images[#images + 1] = love.graphics.newImage('data/images/sidewalk.jpg')
	
	self.images = images
	
	self.canvases = {}
	
	for i = 1, 25 do
		local canvas = love.graphics.newCanvas(1200, 900)
		self:fillCanvas(canvas)
		self.canvases[#self.canvases + 1] = canvas
	end	
	
	self.drawMode = 'canvas'
end

function RenderingPipelineTest:fillCanvas(canvas)
	local ssx = 120
	local ssy = 90

	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	for y = 0, 900, ssy do
		for x = 0, 1200, ssx do					
			local i = math.random(1, #self.images)
			local img  = self.images[i]
			local zx = ssx / img:getWidth()
			local zy = ssy / img:getHeight()
			love.graphics.draw(self.images[i], x, y, 0, zx, zy)
		end	
	end
	love.graphics.setColor(0,255,255)
	love.graphics.setLineWidth(20)
	love.graphics.rectangle('line', 0, 0, 1200, 900)
	love.graphics.setColor(255,255,255)
	love.graphics.setCanvas()
end

function RenderingPipelineTest:drawCanvases()
	local zf = 1/3
	local idx = 1
	local sy =  0
	for y = 1, 3 do
		local sx = 0
		for x = 1, 3 do
			love.graphics.draw(self.canvases[idx], sx, sy, 0, zf, zf)
			idx = idx + 1
			sx = sx + 1200 * zf
		end
		sy = sy + 900 * zf
	end
end


function RenderingPipelineTest:drawBrute()
	local ssx = 120 
	local ssy = 90

	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	for y = 0, 900, ssy do
		for x = 0, 1200, ssx do					
			local i = math.random(1, #self.images)
			local img  = self.images[i]
			local zx = ssx / img:getWidth()
			local zy = ssy / img:getHeight()
			love.graphics.draw(self.images[i], x, y, 0, zx, zy)
		end	
	end
end

function RenderingPipelineTest:draw()
	local fromChannel = self.fromChannel
	if self.drawMode == 'canvas' then self:drawCanvases() end
	if self.drawMode == 'brute' then self:drawBrute() end	
	
	while 1 == 1 do
		local msg = fromChannel:pop()
		if msg then
			if msg == 'end' then
				break
			end
		end
	end	
end

function RenderingPipelineTest:keyreleased(key)
	if key == '1' then self.drawMode = 'canvas' end
	if key == '2' then self.drawMode = 'brute' end
end

return RenderingPipelineTest