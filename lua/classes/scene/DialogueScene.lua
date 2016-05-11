local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local Scene = require 'classes/scene/Scene'
local CharacterPortrait = require 'classes/drawable/CharacterPortrait'
local DialogueScene = Scene:extend('DialogueScene', {isOverlay = true, isBlocking = true})

function DialogueScene:show(dialogue)
	self.characterPortrait = CharacterPortrait:new(dialogue.other)
	self.dialogue = dialogue
	self.branch = nil
	self.option = nil
	self.optionNumber = nil
	self.isOver = nil	
	self:getOption()
end

function DialogueScene:getOption() 
	local dialogue = self.dialogue
	local branch = dialogue.currentBranch
	local option, optionNumber = dialogue:getSelectedOption()
	
	self.branch = branch
	self.option = option
	self.optionNumber = optionNumber
end

function DialogueScene:advance()
	local option = self.option
	if option.onSelected then
		option:onSelected()
	end
	
	if self.dialogue:advance(option) then
		if self.branch.character == 'o' then
			SceneManager:hide('dialogue')
		else 
			self.isOver = true		
		end
	else
		self:getOption()
	end
end

function DialogueScene:scrollOption(dir)
	local branch = self.branch
	local optionNumber = self.optionNumber
	optionNumber = optionNumber + dir
	
	if optionNumber > #branch.options then
		optionNumber = #branch.options
	end
	
	if optionNumber < 1 then
		optionNumber = 1
	end		
	
	self.optionNumber = optionNumber
	self.option = branch.options[optionNumber]
end

function DialogueScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
	
	local dialogue = self.dialogue
	local branch = self.branch
	local option = self.option
	
	love.graphics.setColor(255, 255, 255, 128)
	love.graphics.rectangle('fill', 50, 50, sw - 100, sh - 100)

	self.characterPortrait:draw()
	
	love.graphics.setColor(128,64,64)
	love.graphics.rectangle('fill', 75, 525, sw - 150, 300)
	
	if self.isOver then
		love.graphics.setColor(0,255,255)
		love.graphics.print('PRESS ENTER TO CONTINUE', sw - 320, 800)
		return
	end
	
	if branch.character == 'o' then
		love.graphics.setColor(255,255,255)		
		love.graphics.printf(dialogue.other.name .. ': ' .. option.text, 80, 530, sw - 160)
		love.graphics.setColor(0,255,255)
		love.graphics.print('PRESS ENTER TO CONTINUE', sw - 320, 800)		
	else
		local sy = 530
		for _, possibleOption in ipairs(branch.options) do
			if (option == possibleOption) then
				love.graphics.setColor(64,64,64)
				love.graphics.rectangle('fill', 80, sy, sw - 160, 30)
			end
			
			love.graphics.setColor(255,255,255)
			love.graphics.printf('You: ' .. possibleOption.text, 80, sy, sw - 160)
			sy = sy + 50
		end
	end
end

function DialogueScene:keyreleased(key, scancode)
	if key == 'return' or scancode == 'return' then
		if self.isOver then
			SceneManager:hide('dialogue')
		else
			self:advance()
		end
	end	
	
	local branch = self.branch
	if branch.character == 'h' then
		if key == 'down' or scancode == 'down' then
			self:scrollOption(1)
		end
		
		if key == 'up' or scancode == 'up' then
			self:scrollOption(-1)
		end
	end
end

return DialogueScene