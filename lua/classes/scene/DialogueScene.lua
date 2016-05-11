local class = require 'libs/30log/30log'
local Scene = require 'classes/scene/Scene'
local DialogueScene = Scene:extend('DialogueScene', {isOverlay = true, isBlocking = true})

function DialogueScene:draw()
	love.graphics.setColor(255, 255, 255, 128)
	love.graphics.rectangle('fill', 50,50,1024-100, 768-100)

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 360,75,300,300)
	
	love.graphics.setColor(64,64,64)
	love.graphics.rectangle('fill', 360,375,300,30)
	
	love.graphics.setColor(255,255,255)
	love.graphics.printf('Bank Guy', 360, 380, 300, 'center')
	
	love.graphics.setLineWidth(4)
	love.graphics.setColor(64,64,255)
	love.graphics.rectangle('line', 360,75,300,300)
	
	love.graphics.setColor(128,64,64)
	love.graphics.rectangle('fill', 75,425,875,275)
end

function DialogueScene:keyreleased(key, scancode)
	print(key, scancode)
end

return DialogueScene