local Scene = require 'classes/scene/Scene'
local CharacterPortrait = require 'classes/drawable/CharacterPortrait'
local DialogueScene = Scene:extend('DialogueScene', {isOverlay = true, isBlocking = true})

function DialogueScene:show(dialogue)
	self.characterPortrait = CharacterPortrait:new(dialogue.other)
	self.dialogue = dialogue
end

function DialogueScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
	local dialogue = self.dialogue
	local branch = dialogue.currentBranch
	
	local option = branch.options[dialogue.selectedOption]
	
	love.graphics.setColor(255, 255, 255, 128)
	love.graphics.rectangle('fill', 50, 50, sw - 100, sh - 100)

	self.characterPortrait:draw()
	
	love.graphics.setColor(128,64,64)
	love.graphics.rectangle('fill', 75, 525, sw - 150, 300)
	
	love.graphics.setColor(255,255,255)
	love.graphics.printf(option.text, 75, 550, sw - 150)
end

function DialogueScene:keyreleased(key, scancode)
	print(key, scancode)
end

return DialogueScene