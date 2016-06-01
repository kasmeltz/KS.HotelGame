local Scene = require 'classes/scene/Scene'
local SpaceSimulatorScene = Scene:extend('SpaceSimulatorScene')

local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()
local FFIMatrix4x4 = require 'classes/math/FFIMatrix4x4'
local FFIVector3 = require 'classes/math/FFIVector3'
local FFIMesh = require 'classes/math/FFIMesh'
local FFIRenderer = require 'classes/math/FFIRenderer'

function SpaceSimulatorScene:init(gameWorld)
	SpaceSimulatorScene.super.init(self, gameWorld)
	
	local sw = self.screenWidth
	local sh = self.screenHeight

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

	local mesh = FFIMesh.newMesh(8, 12)
	mesh.rotation.X = 0
	mesh.rotation.Y = 0
	mesh.rotation.Z = 0	
	mesh.position.X = 0
	mesh.position.Y = 0
	mesh.position.Z = 0
	
	local vertices = mesh.vertData.vertices
	local faces = mesh.vertData.faces
		
	vertices[0].X = -1
	vertices[0].Y = 1
	vertices[0].Z = 1
	
	vertices[1].X = 1
	vertices[1].Y = 1
	vertices[1].Z = 1

	vertices[2].X = -1
	vertices[2].Y = -1
	vertices[2].Z = 1
	
	vertices[3].X = 1
	vertices[3].Y = -1
	vertices[3].Z = 1
	
	vertices[4].X = -1
	vertices[4].Y = 1
	vertices[4].Z = -1
	
	vertices[5].X = 1
	vertices[5].Y = 1
	vertices[5].Z = -1

	vertices[6].X = 1
	vertices[6].Y = -1
	vertices[6].Z = -1

	vertices[7].X = -1
	vertices[7].Y = -1
	vertices[7].Z = -1

	faces[0].A = 0
	faces[0].B = 1
	faces[0].C = 2

	faces[1].A = 1
	faces[1].B = 2
	faces[1].C = 3

	faces[2].A = 1
	faces[2].B = 3
	faces[2].C = 6

	faces[3].A = 1
	faces[3].B = 5
	faces[3].C = 6

	faces[4].A = 0
	faces[4].B = 1
	faces[4].C = 4

	faces[5].A = 1
	faces[5].B = 4
	faces[5].C = 5
			
	faces[6].A = 2
	faces[6].B = 3
	faces[6].C = 7

	faces[7].A = 3
	faces[7].B = 6
	faces[7].C = 7
	
	faces[8].A = 0
	faces[8].B = 2
	faces[8].C = 7

	faces[9].A = 0
	faces[9].B = 4
	faces[9].C = 7

	faces[10].A = 4
	faces[10].B = 5
	faces[10].C = 6

	faces[11].A = 4
	faces[11].B = 6
	faces[11].C = 7
	
	--[[
	local vertData = mesh.vertData
	for i = 0, vertData.faceCount - 1 do
		local face = vertData.faces[i]
		print(face.A, face.B, face.C)
		print(vertData.vertices[face.A].X, vertData.vertices[face.A].Y, vertData.vertices[face.A].Z)
		print(vertData.vertices[face.B].X, vertData.vertices[face.B].Y, vertData.vertices[face.B].Z)
		print(vertData.vertices[face.C].X, vertData.vertices[face.C].Y, vertData.vertices[face.C].Z)
		print('-----------------------')
	end	
	io.read()
	]]
	
	self.mesh = mesh 
		
	self.backBufferData = love.image.newImageData(sw, sh)		
	self.backBuffer = love.graphics.newImage(self.backBufferData)
	
end

function SpaceSimulatorScene:draw(dt)
	local sw = self.screenWidth
	local sh = self.screenHeight
	
	--[[
	Profiler:start('rendering scene')	
	FFIRenderer.render(self.backBufferData:getPointer(), sw, sh)
	Profiler:stop('rendering scene')	
	
	Profiler:start('refreshing back buffer')	
	self.backBuffer:refresh()
	Profiler:stop('refreshing back buffer')	
	
	Profiler:start('drawing back buffer')	
	love.graphics.draw(self.backBuffer)
	Profiler:stop('drawing back buffer')	
	]]

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
	
	--print('=======================')
	local vertData = mesh.vertData
	for i = 0, vertData.faceCount - 1 do
		Profiler:start('projecting vertices')							  
		local face = vertData.faces[i]
		--print(face.A, face.B, face.C)
		--print(vertData.vertices[face.A].X, vertData.vertices[face.A].Y, vertData.vertices[face.A].Z)
		--print(vertData.vertices[face.B].X, vertData.vertices[face.B].Y, vertData.vertices[face.B].Z)
		--print(vertData.vertices[face.C].X, vertData.vertices[face.C].Y, vertData.vertices[face.C].Z)
		--print('-----------------------')

		FFIMatrix4x4.project(ssv1, vertData.vertices[face.A], worldViewProjectionMatrix, 0, 0, sw, sh, -1, 1)
		FFIMatrix4x4.project(ssv2, vertData.vertices[face.B], worldViewProjectionMatrix, 0, 0, sw, sh, -1, 1)
		FFIMatrix4x4.project(ssv3, vertData.vertices[face.C], worldViewProjectionMatrix, 0, 0, sw, sh, -1, 1)
		Profiler:stop('projecting vertices')		
		
		Profiler:start('drawing vertices')
		love.graphics.line(ssv1.X, ssv1.Y, ssv2.X, ssv2.Y)
		love.graphics.line(ssv2.X, ssv2.Y, ssv3.X, ssv3.Y)
		love.graphics.line(ssv3.X, ssv3.Y, ssv1.X, ssv1.Y)
		Profiler:stop('drawing vertices')
	end	
		
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