local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()

local Scene = require 'classes/scene/Scene'
local TowerDefenseScene = Scene:extend('TowerDefenseScene')

local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

function TowerDefenseScene:init(gameWorld)
	TowerDefenseScene.super.init(self, gameWorld)
	
	local cv = love.graphics.newCanvas(300,100)
	love.graphics.setCanvas(cv)
	local dirtyFox = FontManager:getFont('DirtyFox')
	love.graphics.setFont(dirtyFox)
	love.graphics.printf('Hobo\nDefense', 0, 0, 300, 'center')
	self.hoboCanvas = cv
	love.graphics.setCanvas()	
	self.titleScale = 20
	self.decay = 0.999	
	self.timer = 0
end

function TowerDefenseScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
		
	local font = FontManager:getFont('ComicBold48')		
	love.graphics.setFont(font)
	
	love.graphics.print('Yesterday afternoon, in a city far', 200, 380)
	love.graphics.print('far away (AKA in latin america...)', 200, 430)
	
	love.graphics.draw(self.hoboCanvas, sw / 2, sh / 2, 0, self.titleScale, self.titleScale, 150, 50)
	table.sort(Profiler.list, function(a, b) return a.average > b.average end)	
	local sy = 30
	for name, item in ipairs(Profiler.list) do	
		love.graphics.print(item.name, 0, sy)
		sy = sy + 15
		love.graphics.print(item.average, 0, sy)
		sy = sy + 15
	end		
end

function TowerDefenseScene:update(dt)
	self.titleScale = self.titleScale * self.decay
	self.decay = self.decay + (dt * 0.0001)
	self.decay = math.min(self.decay, 0.9996)
	
	self.timer = self.timer + dt
end

function TowerDefenseScene:keyreleased(key)
	print(key)
end

return TowerDefenseScene