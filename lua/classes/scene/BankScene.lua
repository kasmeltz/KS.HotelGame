local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()

local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Character = require 'classes/simulation/Character'
local Dialogue = require 'classes/simulation/Dialogue'
local Scene = require 'classes/scene/Scene'
local BankScene = Scene:extend('BankScene')

function BankScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight	
	local left = (sw / 2) - 200
	local character = self.character
	
	local font = FontManager:getFont('Courier32')
	love.graphics.setFont(font)
	
	love.graphics.setColor(255,0,255)
	love.graphics.printf('The Bank', 0, 10, sw, 'center')
end

function BankScene:keyreleased(key, scancode)
	local gw = self.gameWorld
	
	if key == 'a' then
		local character = Character:new(gw)
		character.name = 'Bank Guy'	
		local dialogue = Dialogue:new('gameIntro', 'start', gw, gw.hero, character)
		SceneManager:show('dialogue', dialogue)
	end
end

return BankScene