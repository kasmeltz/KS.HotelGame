local Scene = require 'classes/scene/Scene'
local SpaceSimulatorScene = Scene:extend('SpaceSimulatorScene')

local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()
local FFIMatrix4x4 = require 'classes/math/FFIMatrix4x4'
local FFIVector3 = require 'classes/math/FFIVector3'
local FFIMesh = require 'classes/math/FFIMesh'

function SpaceSimulatorScene:init(gameWorld)
	SpaceSimulatorScene.super.init(self, gameWorld)
	
	self.cameraPosition = FFIVector3.newVector()
	FFIVector3.setValues(self.cameraPosition, 0, 0, 10)
	self.cameraTarget = FFIVector3.newVector()
	FFIVector3.setValues(self.cameraTarget, 0, 0, 0)
	self.up = FFIVector3.newVector()
	FFIVector3.setValues(self.up, 0, 1, 0)	

	--self.mesh = FFIMesh.newMesh(1)	
	
	local mesh = {}
	mesh.rotation = FFIVector3.newVector()
	mesh.position = FFIVector3.newVector()
	FFIVector3.setValues(mesh.position, 0, 0, 0)
	FFIVector3.setValues(mesh.rotation, 0, 0, 0)
	
	mesh.vertCount = 8
	mesh.vertices = {}
	mesh.vertices[0] = FFIVector3.newVector()
	FFIVector3.setValues(mesh.vertices[0], -1, 1, 1)
	mesh.vertices[1] = FFIVector3.newVector()
	FFIVector3.setValues(mesh.vertices[1], 1, 1, 1)
	mesh.vertices[2] = FFIVector3.newVector()
	FFIVector3.setValues(mesh.vertices[2], -1, -1, 1)
	mesh.vertices[3] = FFIVector3.newVector()
	FFIVector3.setValues(mesh.vertices[3], -1, -1, -1)
	mesh.vertices[4] = FFIVector3.newVector()
	FFIVector3.setValues(mesh.vertices[4], -1, 1, -1)
	mesh.vertices[5] = FFIVector3.newVector()
	FFIVector3.setValues(mesh.vertices[5], 1, 1, -1)
	mesh.vertices[6] = FFIVector3.newVector()
	FFIVector3.setValues(mesh.vertices[6], 1, -1, 1)
	mesh.vertices[7] = FFIVector3.newVector()
	FFIVector3.setValues(mesh.vertices[7], 1, -1, -1)
	
	self.mesh = mesh 
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
	
	love.graphics.setColor(255,255,255)

	local mesh = self.mesh
	
	FFIMatrix4x4.rotationYawPitchRollInline(rotationMatrix, mesh.rotation[0], mesh.rotation[1], mesh.rotation[2])
	FFIMatrix4x4.translationInline(tranlsationMatrix, mesh.position[0], mesh.position[1], mesh.position[2])	
	FFIMatrix4x4.multiplyInline(worldMatrix, rotationMatrix, tranlsationMatrix)
	FFIMatrix4x4.multiplyInline(worldViewProjectionMatrix, worldMatrix, viewMatrix)
	FFIMatrix4x4.multiplyInline(worldViewProjectionMatrix, worldViewProjectionMatrix, projectionMatrix)
	for i = 0, mesh.vertCount - 1 do
		FFIMatrix4x4.project(ssv1, mesh.vertices[i], worldViewProjectionMatrix, 0, 0, sw, sh, -10, 10)	
		love.graphics.points(ssv1[0], ssv1[1])
	end
end

function SpaceSimulatorScene:update(dt)
	local mesh = self.mesh
	
	if love.keyboard.isDown('up') then
		mesh.rotation[1] = mesh.rotation[1] + 1 * dt
		--self.cameraPosition[2] = self.cameraPosition[2] - 10 * dt
	end
	
	if love.keyboard.isDown('down') then
		mesh.rotation[1] = mesh.rotation[1] - 1 * dt
		--self.cameraPosition[2]  = self.cameraPosition[2] + 10 * dt
	end	
	
	if love.keyboard.isDown('left') then
		mesh.rotation[0] = mesh.rotation[0] - 1 * dt
	end
	
	if love.keyboard.isDown('right') then
		mesh.rotation[0] = mesh.rotation[0] + 1 * dt
	end
end

return SpaceSimulatorScene