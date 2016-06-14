local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local Scene = require 'classes/scene/Scene'
local LongTimeScene = Scene:extend('LongTimeScene')

local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

function LongTimeScene:init(gameWorld)
	LongTimeScene.super.init(self, gameWorld)
	self.timer = 0
	self.textColor = { 0, 255, 255 }
	self.fade = 1
	self.timeUntilSwitch = 7
	self.timeUntilFade = 5
end

function LongTimeScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
		
	local font = FontManager:getFont('ComicBold48')		
	love.graphics.setFont(font)	
	love.graphics.setColor(self.textColor[1] * self.fade, self.textColor[2] * self.fade, self.textColor[3] * self.fade)
	love.graphics.print('Yesterday afternoon in a city far,', 200, 380)
	love.graphics.print('far away (AKA in latin america...)', 200, 430)
end

function LongTimeScene:update(dt)
	self.timer = self.timer + dt
	
	if self.timer > self.timeUntilFade then
		self.fade = self.fade - dt
	end
	
	if self.fade < 0 then
		self.fade = 0
	end
	
	if self.timer > self.timeUntilSwitch then
		SceneManager:show('hobodefensetitle')
	end
end

return LongTimeScene