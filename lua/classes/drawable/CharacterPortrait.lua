local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()

local Drawable = require 'classes/drawable/Drawable'
local CharacterPortrait = Drawable:extend('CharacterPortrait')

function CharacterPortrait:init(character) 
	CharacterPortrait.super.init(self)
	self.character = character
	self.image = nil
	
	self.image = love.graphics.newImage('data/images/banker.png')
end

function CharacterPortrait:draw() 
	local sw = self.screenWidth
	local sh = self.screenHeight	
	local left = (sw / 2) - 200
	local character = self.character
	
	local font = FontManager:getFont('Courier16')
	love.graphics.setFont(font)
	
	love.graphics.setLineWidth(4)
	love.graphics.setColor(255,255,128)
	love.graphics.rectangle('fill', left, 75, 400, 400)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.image, left, 475  - self.image:getHeight())
	love.graphics.setColor(64,64,0)
	love.graphics.rectangle('line', left + 2, 75 + 2, 396, 396)		
	love.graphics.setColor(255,0,255)
	love.graphics.printf(character.emotion, left, 100, 400, 'center')	
	love.graphics.setColor(64,64,64)
	love.graphics.rectangle('fill', left, 475, 400, 30)	
	love.graphics.setColor(255,255,255)
	love.graphics.printf(character.name, left, 480, 400, 'center')
end

return CharacterPortrait