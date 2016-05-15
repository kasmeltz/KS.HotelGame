local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

local Scene = require 'classes/scene/Scene'
local ShaderDebugScene = Scene:extend('ShaderDebugScene')

function ShaderDebugScene:init()
	self.px = 600
	self.py = 260
end

function ShaderDebugScene:draw()
	local x1 = 50
	local y1 = 150		
	local x2 = 900
	local y2 = 50	
	local x3 = 50
	local y3 = 400	
	local x4 = 900
	local y4 = 600
	
	local px = self.px
	local py = self.py
	
	love.graphics.setColor(255,255,0)
	love.graphics.line(x1, y1, x3, y3)
	love.graphics.line(x2, y2, x4, y4)

	love.graphics.setColor(255,0,255)
	love.graphics.line(x1, y1, x2, y2)
	love.graphics.line(x3, y3, x4, y4)
	
	love.graphics.setColor(255,255,255)
	love.graphics.circle('fill', px, py, 10)
	
	local tx =  (px - x1) / (x2 - x1)
	
	local ly1 = y1 * ( 1 - ((px - x1) / (x2 - x1)) ) + 
		y2 * ( (px - x1) / (x2 - x1) )
		
	local ly2 = y3 * ( 1 - ((px - x3) / (x4 - x3)) ) + 
		y4 * ( (px - x3) / (x4 - x3) )		
	
	love.graphics.setColor(0,255,255)	
	love.graphics.circle('fill', px, ly1, 5)
	love.graphics.circle('fill', px, ly2, 5)
			
	local ty = (py - ly2) / (ly1 - ly2)
	
	local sy = 15
	love.graphics.print('Texture x: ' .. tx, 0, sy)
	sy = sy+ 15
	love.graphics.print('Texture y: ' .. ty, 0, sy)
	
	

end

function ShaderDebugScene:update(dt)
	if love.keyboard.isDown('d') then
		self.px = self.px + 100 * dt
	end
	if love.keyboard.isDown('a') then
		self.px = self.px - 100 * dt
	end	
	if love.keyboard.isDown('w') then
		self.py = self.py - 100 * dt
	end
	if love.keyboard.isDown('s') then
		self.py = self.py + 100 * dt
	end	
end

function ShaderDebugScene:keyreleased(key)	
	if key == 'f1' then
		SceneManager:show('shearTest')
	end
end

return ShaderDebugScene