local Scene = require 'classes/scene/Scene'
local SpaceSimulatorScene = Scene:extend('SpaceSimulatorScene')

local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()
local FFIMatrix4x4 = require 'classes/math/FFIMatrix4x4'

function SpaceSimulatorScene:init(gameWorld)
	SpaceSimulatorScene.super.init(self, gameWorld)
end

function SpaceSimulatorScene:draw(dt)
	table.sort(Profiler.list, function(a, b) return a.average > b.average end)	
	local sy = 30
	for name, item in ipairs(Profiler.list) do	
		love.graphics.print(item.name, 0, sy)
		sy = sy + 15
		love.graphics.print(item.average, 0, sy)
		sy = sy + 15
	end	
end

function SpaceSimulatorScene:update(dt)
	local sw = self.screenWidth
	local sh = self.screenHeight	
	local a = FFIMatrix4x4.newMatrix()
	FFIMatrix4x4.setValues(a, 
		8, 3, 2, 4, 
		3, 6, 1, 2, 
		3, 4, 6, 8, 
		7, 6, 5, 2)

	local b = FFIMatrix4x4.newMatrix()
	FFIMatrix4x4.setValues(b,
		8, 3, 2, 4, 
		3, 6, 1, 2, 
		3, 4, 6, 8, 
		7, 6, 5, 2)			
	local c = FFIMatrix4x4.newMatrix()	

	--[[
	FFIMatrix4x4.display(a)
	FFIMatrix4x4.inverseInline(c, a)
	FFIMatrix4x4.display(c)
	
	local d = FFIMatrix4x4.multiply(a, c)
	FFIMatrix4x4.display(d)	
	]]
end

return SpaceSimulatorScene