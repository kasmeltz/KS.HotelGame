local Drawable = require 'classes/drawable/Drawable'
local CharacterPortrait = Drawable:extend('CharacterPortrait')

function CharacterPortrait:init(character) 
	CharacterPortrait.super:init()
	self.character = character
end

function CharacterPortrait:draw() 
	local sw = self.screenWidth
	local sh = self.screenHeight
	
	local left = (sw / 2) - 200
	
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', left, 75, 400, 400)	
	love.graphics.setColor(64,64,64)
	love.graphics.rectangle('fill', left, 475, 400, 30)	
	love.graphics.setColor(255,255,255)
	love.graphics.printf(self.character.name, left, 480, 400, 'center')
end

return CharacterPortrait