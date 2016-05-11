local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local Scene = require 'classes/scene/Scene'
local CharacterPortrait = require 'classes/drawable/CharacterPortrait'
local StoryScene = Scene:extend('StoryScene', {isOverlay = true, isBlocking = true})

function StoryScene:show(story)
	self.story = story
	self.text = story:text()
	self.title = self.story:title()
end

function StoryScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
	
	love.graphics.setColor(128, 128, 128)
	love.graphics.rectangle('fill', 50, 50, sw - 100, sh - 100)
	love.graphics.setColor(64, 64, 64)
	love.graphics.rectangle('fill', 50, 50, sw - 100, 100)

	local font = FontManager:getFont('Courier32')
	love.graphics.setFont(font)	
	
	love.graphics.setColor(0,255,255)
	love.graphics.printf(self.title, 60, 80, sw - 120, 'center')
	
	local font = FontManager:getFont('Courier16')
	love.graphics.setFont(font)	

	love.graphics.setColor(255,255,255)
	love.graphics.printf(self.text, 60, 180, sw - 120, 'left')
	
	love.graphics.setColor(0,255,255)
	love.graphics.print('PRESS ENTER TO CONTINUE', sw - 320, 800)		
end

function StoryScene:keyreleased(key, scancode)
	if key == 'return' or scancode == 'return' then
		SceneManager:hide('story')
	end	
end

return StoryScene