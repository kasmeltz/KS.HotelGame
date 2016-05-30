local Scene = require 'classes/scene/Scene'
local SpaceSimulatorScene = Scene:extend('SpaceSimulatorScene')

local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()
local FFIMatrix4x4 = require 'classes/math/FFIMatrix4x4'
local FFIVector3 = require 'classes/math/FFIVector3'

function SpaceSimulatorScene:init(gameWorld)
	SpaceSimulatorScene.super.init(self, gameWorld)
	
	self.cameraPosition = FFIVector3.newVector()
	FFIVector3.setValues(self.cameraPosition, 0, 0, 5)
	self.cameraTarget = FFIVector3.newVector()
	FFIVector3.setValues(self.cameraTarget, 0, 0, 0)
	self.up = FFIVector3.newVector()
	FFIVector3.setValues(self.up, 0, 1, 0)	
	
	self.rotX = 0
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
	
	local sw = self.screenWidth
	local sh = self.screenHeight

	local v1 = FFIVector3.newVector()	
	FFIVector3.setValues(v1, 0, 0, 0)
	local v2 = FFIVector3.newVector()	
	FFIVector3.setValues(v2, -0.01, 0, 0)
	local v3 = FFIVector3.newVector()	
	FFIVector3.setValues(v3, 0, -0.01, 0)
	
	local ssv1 = FFIVector3.newVector()	
	local ssv2 = FFIVector3.newVector()
	local ssv3 = FFIVector3.newVector()
	
	local viewMatrix = FFIMatrix4x4.newMatrix()
	local projectionMatrix = FFIMatrix4x4.newMatrix()
	local rotationMatrix = FFIMatrix4x4.newMatrix()
	local tranlsationMatrix = FFIMatrix4x4.newMatrix()	
	local worldMatrix = FFIMatrix4x4.newMatrix()
	local worldViewProjectionMatrix = FFIMatrix4x4.newMatrix()
			
	FFIMatrix4x4.lookAtLHInline(viewMatrix, self.cameraPosition, self.cameraTarget, self.up)
	FFIMatrix4x4.perspectiveFovRHInline(projectionMatrix, 0.78, sw / sh, 0.01, 1)                                                          
	FFIMatrix4x4.rotationYawPitchRollInline(rotationMatrix, self.rotX, 0, 0)
	FFIMatrix4x4.translationInline(tranlsationMatrix, 0, 0, 0)	
	FFIMatrix4x4.multiplyInline(worldMatrix, rotationMatrix, tranlsationMatrix)
	FFIMatrix4x4.multiplyInline(worldViewProjectionMatrix, worldMatrix, viewMatrix)
	FFIMatrix4x4.multiplyInline(worldViewProjectionMatrix, worldViewProjectionMatrix, projectionMatrix)
	
	FFIMatrix4x4.project(ssv1, v1, worldViewProjectionMatrix, 0, 0, sw, sh, 0, 10)	
	FFIMatrix4x4.project(ssv2, v2, worldViewProjectionMatrix, 0, 0, sw, sh, 0, 10)	
	FFIMatrix4x4.project(ssv3, v3, worldViewProjectionMatrix, 0, 0, sw, sh, 0, 10)	
	
	love.graphics.setColor(255,255,255)
	love.graphics.polygon('line', ssv1[0], ssv1[1], ssv2[0], ssv2[1], ssv3[0], ssv3[1])
end

function SpaceSimulatorScene:update(dt)
	if love.keyboard.isDown('up') then
		self.cameraPosition[2] = self.cameraPosition[2] + 10 * dt
	end
	
	if love.keyboard.isDown('down') then
		self.cameraPosition[2]  = self.cameraPosition[2]  - 10 * dt
	end
	
	if love.keyboard.isDown('left') then
		self.rotX = self.rotX + 1 * dt
	end
	
	if love.keyboard.isDown('right') then
		self.rotX  = self.rotX - 1 * dt
	end
end

return SpaceSimulatorScene