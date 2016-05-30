local Scene = require 'classes/scene/Scene'
local SpaceSimulatorScene = Scene:extend('SpaceSimulatorScene')

local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()
local FFIMatrix4x4 = require 'classes/math/FFIMatrix4x4'
local FFIVector3 = require 'classes/math/FFIVector3'

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
	
	local v1 = FFIVector3.newVector()	
	FFIVector3.setValues(v1, 1, 2, 3)	
	local v2 = FFIVector3.newVector(v1)
	FFIVector3.setValues(v2, 4, 5, 6)	

	local tm = FFIMatrix4x4.translation(2, 4, 6)
	FFIMatrix4x4.display(tm)
	local v3 = FFIMatrix4x4.transformCoordinate(v1, tm)
	FFIMatrix4x4.transformCoordinateInline(v2, v1, tm)	
	FFIVector3.display(v2)


end

return SpaceSimulatorScene