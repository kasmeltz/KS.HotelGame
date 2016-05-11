local Scene = require 'classes/scene/Scene'
local CharacterPortrait = require 'classes/drawable/CharacterPortrait'
local DialogueScene = Scene:extend('DialogueScene', {isOverlay = true, isBlocking = true})

function DialogueScene:show(dialogue)
	self.characterPortrait = CharacterPortrait:new(dialogue.other)
end

function DialogueScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
	
	love.graphics.setColor(255, 255, 255, 128)
	love.graphics.rectangle('fill', 50, 50, sw - 100, sh - 100)

	self.characterPortrait:draw()
	
	love.graphics.setColor(128,64,64)
	love.graphics.rectangle('fill', 75, 525, sw - 150, 300)
end

function DialogueScene:keyreleased(key, scancode)
	print(key, scancode)
end

return DialogueScene