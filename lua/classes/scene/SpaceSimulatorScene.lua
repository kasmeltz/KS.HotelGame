local Scene = require 'classes/scene/Scene'
local SpaceSimulatorScene = Scene:extend('SpaceSimulatorScene')

local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()
local FFIMatrix4x4 = require 'classes/math/FFIMatrix4x4'
local FFIVector3 = require 'classes/math/FFIVector3'
local FFIMesh = require 'classes/math/FFIMesh'

function SpaceSimulatorScene:init(gameWorld)
	SpaceSimulatorScene.super.init(self, gameWorld)
	
	local m = FFIMatrix4x4.identity()
	
	self.cameraPosition = FFIVector3.newVector()
	self.cameraPosition.X = 0
	self.cameraPosition.Y = 0
	self.cameraPosition.Z = 10

	self.cameraTarget = FFIVector3.newVector()
	self.cameraTarget.X = 0
	self.cameraTarget.Y = 0
	self.cameraTarget.Z = 0

	self.up = FFIVector3.newVector()
	self.up.X = 0
	self.up.Y = 1
	self.up.Z = 0

	--self.mesh = FFIMesh.newMesh(1)	
	
	local mesh = {}
	mesh.rotation = FFIVector3.newVector()
	mesh.rotation.X = 0
	mesh.rotation.Y = 0
	mesh.rotation.Z = 0
	
	mesh.position = FFIVector3.newVector()
	mesh.position.X = 0
	mesh.position.Y = 0
	mesh.position.Z = 0
		
	mesh.vertCount = 8
	mesh.vertices = {}
	mesh.vertices[0] = FFIVector3.newVector()
	mesh.vertices[0].X = -1
	mesh.vertices[0].Y = 1
	mesh.vertices[0].Z = 1
	
	mesh.vertices[1] = FFIVector3.newVector()
	mesh.vertices[1].X = 1
	mesh.vertices[1].Y = 1
	mesh.vertices[1].Z = 1

	mesh.vertices[2] = FFIVector3.newVector()
	mesh.vertices[2].X = -1
	mesh.vertices[2].Y = -1
	mesh.vertices[2].Z = 1
	
	mesh.vertices[3] = FFIVector3.newVector()
	mesh.vertices[3].X = -1
	mesh.vertices[3].Y = -1
	mesh.vertices[3].Z = -1
	
	mesh.vertices[4] = FFIVector3.newVector()
	mesh.vertices[4].X = -1
	mesh.vertices[4].Y = 1
	mesh.vertices[4].Z = -1
	
	mesh.vertices[5] = FFIVector3.newVector()
	mesh.vertices[5].X = 1
	mesh.vertices[5].Y = 1
	mesh.vertices[5].Z = -1

	mesh.vertices[6] = FFIVector3.newVector()
	mesh.vertices[6].X = 1
	mesh.vertices[6].Y = -1
	mesh.vertices[6].Z = 1

	mesh.vertices[7] = FFIVector3.newVector()
	mesh.vertices[7].X = 1
	mesh.vertices[7].Y = -1
	mesh.vertices[7].Z = -1
	
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

	Profiler:start('making new stuff')
	local ssv1 = FFIVector3.newVector()	
	local ssv2 = FFIVector3.newVector()
	local ssv3 = FFIVector3.newVector()	
	local viewMatrix = FFIMatrix4x4.newMatrix()
	local projectionMatrix = FFIMatrix4x4.newMatrix()
	local rotationMatrix = FFIMatrix4x4.newMatrix()
	local tranlsationMatrix = FFIMatrix4x4.newMatrix()	
	local worldMatrix = FFIMatrix4x4.newMatrix()
	local worldViewMatrix = FFIMatrix4x4.newMatrix()
	local worldViewProjectionMatrix = FFIMatrix4x4.newMatrix()
	Profiler:stop('making new stuff')
	
	Profiler:start('calculating matrices')	
	-- once per camera per frame
	FFIMatrix4x4.lookAtLHInline(viewMatrix, self.cameraPosition, self.cameraTarget, self.up)
	FFIMatrix4x4.perspectiveFovRHInline(projectionMatrix, 0.78, 1200 / 900, 0.01, 1)                                                          	
		
	love.graphics.setColor(255,255,255)
	local mesh = self.mesh	
	
	-- once per mesh per frame
	FFIMatrix4x4.rotationYawPitchRollInline(rotationMatrix, mesh.rotation)
	FFIMatrix4x4.translationInline(tranlsationMatrix, mesh.position)
	FFIMatrix4x4.multiplyInline(worldMatrix, rotationMatrix, tranlsationMatrix)
	FFIMatrix4x4.multiplyInline(worldViewMatrix, worldMatrix, viewMatrix)
	FFIMatrix4x4.multiplyInline(worldViewProjectionMatrix, worldViewMatrix, projectionMatrix)
		
	Profiler:stop('calculating matrices')
	
	for i = 0, mesh.vertCount - 1 do
		Profiler:start('projecting vertices')							  
		FFIMatrix4x4.project(ssv1, mesh.vertices[i], worldViewProjectionMatrix, 0, 0, sw, sh, -1, 1)
		Profiler:stop('projecting vertices')
		Profiler:start('drawing vertices')				
		love.graphics.points(ssv1.X, ssv1.Y)
		Profiler:stop('drawing vertices')
	end
	
end

function SpaceSimulatorScene:update(dt)
	local mesh = self.mesh

	if love.keyboard.isDown('pageup') then
		self.cameraPosition.Z = self.cameraPosition.Z - 10 * dt
	end
	
	if love.keyboard.isDown('pagedown') then
		self.cameraPosition.Z  = self.cameraPosition.Z + 10 * dt
	end	
	
	if love.keyboard.isDown('up') then
		mesh.rotation.Y = mesh.rotation.Y + 1 * dt
	end
	
	if love.keyboard.isDown('down') then
		mesh.rotation.Y = mesh.rotation.Y - 1 * dt
	end	
	
	if love.keyboard.isDown('left') then
		mesh.rotation.X = mesh.rotation.X - 1 * dt
	end
	
	if love.keyboard.isDown('right') then
		mesh.rotation.X = mesh.rotation.X + 1 * dt
	end
	
	if love.keyboard.isDown('z') then
		mesh.rotation.Z = mesh.rotation.Z - 1 * dt
	end
	
	if love.keyboard.isDown('x') then
		mesh.rotation.Z = mesh.rotation.Z + 1 * dt
	end
end

function SpaceSimulatorScene:keyreleased(key)
	print(key)
end

return SpaceSimulatorScene