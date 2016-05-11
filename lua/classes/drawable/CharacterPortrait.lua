local Drawable = require 'classes/drawable/Drawable'
local CharacterPortrait = Drawable:extend('CharacterPortrait')

function CharacterPortrait:init(character) 
	self.character = character
end

function CharacterPortrait:draw() 
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 360,75,300,300)	
	love.graphics.setColor(64,64,64)
	love.graphics.rectangle('fill', 360,375,300,30)	
	love.graphics.setColor(255,255,255)
	love.graphics.printf(self.character.name, 360, 380, 300, 'center')
end

return CharacterPortrait