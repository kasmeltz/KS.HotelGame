local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()

local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Character = require 'classes/simulation/Character'
local Dialogue = require 'classes/simulation/Dialogue'
local Scene = require 'classes/scene/Scene'
local BankScene = Scene:extend('BankScene')

function BankScene:init(gameWorld)
	BankScene.super.init(self, gameWorld)
	
	self.options =
	{
		'Talk with Secretary',
		'Leave bank'
	}
	self.selectedOption = 1
end

function BankScene:scrollOption(dir)
	local options = self.options
	local selectedOption = self.selectedOption
	selectedOption = selectedOption + dir
	
	if selectedOption > #options then
		selectedOption = #options
	end
	
	if selectedOption < 1 then
		selectedOption = 1
	end		
	
	self.selectedOption = selectedOption
end

function BankScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight	
	local left = (sw / 2) - 200
	local character = self.character
	
	local font = FontManager:getFont('Courier32')
	love.graphics.setFont(font)
	
	love.graphics.setColor(255,0,255)
	love.graphics.printf('The Bank', 0, 10, sw, 'center')
	
	local font = FontManager:getFont('Courier16')
	love.graphics.setFont(font)
	
	local options = self.options	
	local sy = 300
	for i = 1, #options do
		if i == self.selectedOption then
			love.graphics.setColor(255,255,255)	
			love.graphics.rectangle('fill', 200, sy, sw - 400, 25)
			love.graphics.setColor(0,0,0)
		else
			love.graphics.setColor(255,255,255)	
		end
			love.graphics.printf(options[i], 0, sy, sw, 'center')
		sy = sy + 30
	end
	
end

function BankScene:keyreleased(key, scancode)
	local gw = self.gameWorld
	
	if key == 'down' or scancode == 'down' then
		self:scrollOption(1)
	end
		
	if key == 'up' or scancode == 'up' then
		self:scrollOption(-1)
	end
	
	if key == 'return' then
		if self.selectedOption == 1 then
			local character = Character:new(gw)
			character.name = 'Bank Guy'	
			local dialogue = Dialogue:new('gameIntro', 'start', gw, gw.hero, character)
			SceneManager:show('dialogue', dialogue)
		end
	end
end

return BankScene