local Scene = require 'classes/scene/Scene'
local OperationGameScene = Scene:extend('OperationGameScene')

local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

function OperationGameScene:init()
	OperationGameScene.super.init(self, gameWorld)
	
	self.background = love.graphics.newImage('data/images/operationgame.png')
	
	self.topY = 0
end

function OperationGameScene:draw()	
	love.graphics.draw(self.background, 0, self.topY)
end
					
function OperationGameScene:update(dt)
	local x, y = love.mouse.getPosition()
	if y > 850 then
		self.topY = self.topY - 1500 * dt
	end	
	if y < 50 then
		self.topY = self.topY + 1500 * dt
	end	
	
	if self.topY > 0 then 
		self.topY  = 0
	end
	if self.topY < -2133 + 900 then
		self.topY = -2133 + 900
	end
end

return OperationGameScene