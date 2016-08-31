local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local Scene = require 'classes/scene/Scene'
local SkillTreeScene = Scene:extend('SkillTreeScene', {isOverlay = true, isBlocking = true})

function SkillTreeScene:init(gameWorld)
	SkillTreeScene.super.init(self, gameWorld)	
end

function SkillTreeScene:show(hero)

end

function SkillTreeScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
	
	love.graphics.setColor(64, 64, 64)
	love.graphics.rectangle('fill', 50, 50, sw - 100, sh - 100)
 
	local font = FontManager:getFont('Courier32')
	love.graphics.setFont(font)	
	
	love.graphics.setColor(0,255,255)
	--love.graphics.printf(self.title, 60, 80, sw - 120, 'center')
	
	local font = FontManager:getFont('Courier16')
	love.graphics.setFont(font)	

	love.graphics.setColor(255,255,255)
	--love.graphics.printf(self.text, 60, 180, sw - 120, 'left')
	
	love.graphics.setColor(0,255,255)
	love.graphics.print('PRESS ENTER TO CONTINUE', sw - 320, 800)		
end

function SkillTreeScene:keyreleased(key, scancode)
	if key == 'return' or scancode == 'return' then
		SceneManager:hide('skilltree')
	end	
end

return SkillTreeScene