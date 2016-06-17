local Scene = require 'classes/scene/Scene'
local BeatEmUpGameScene = Scene:extend('BeatEmUpGameScene')

local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

function BeatEmUpGameScene:init()
	BeatEmUpGameScene.super.init(self, gameWorld)
	
	self.spriteSheet = love.graphics.newImage('data/images/fighter.png')
	
	local width = self.spriteSheet:getWidth()
	local height = self.spriteSheet:getHeight()
	
	local frames = 
	{
		{65,74},		
		{62,75},
		{60,76},
		{60,76},
		{60,77},
		{61,75},
		{69,75},
		{65,75},
		{60,76},
		{60,75},
		{60,76},
		{61,75}
	}
	
	local sx = 0
	local sy = 0
	
	for _, frame in ipairs(frames) do	
		frame[3] = love.graphics.newQuad(sx, sy, frame[1], frame[2], width, height)
		sx = sx + frame[1] + 2
	end
	
	self.frames = frames
	self.frameIndex = 1
	
	self.frameTimeCount = 0
	self.frameDelay = 0.05
	
	self.charX = 0
end

function BeatEmUpGameScene:draw()
	local frames = self.frames
	
	local frame = frames[self.frameIndex]
	love.graphics.draw(self.spriteSheet, frame[3], self.charX + 65 - frame[1], 50)
end
					
function BeatEmUpGameScene:update(dt)
	self.frameTimeCount = self.frameTimeCount + dt
	if self.frameTimeCount > self.frameDelay then
		self.frameTimeCount = self.frameTimeCount - self.frameDelay
		self.frameIndex = self.frameIndex + 1
		if self.frameIndex > #self.frames then
			self.frameIndex = 1
		end
	end
	
	self.charX = self.charX + 50 * dt
end

return BeatEmUpGameScene