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
	
	local drawingMesh = love.graphics.newMesh(3, 'triangles', 'dynamic')
	self.drawingMesh = drawingMesh
	
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
	
	self.backBufferData = love.image.newImageData(sw, sh)		
	self.backBuffer = love.graphics.newImage(self.backBufferData)
	
	self.image = love.graphics.newImage('data/images/roof1.jpg')

	self.viewMatrix = FFIMatrix4x4.newMatrix()
	self.inverseViewMatrix = FFIMatrix4x4.newMatrix()
	self.projectionMatrix = FFIMatrix4x4.newMatrix()
	self.rotationMatrix = FFIMatrix4x4.newMatrix()
	self.tranlsationMatrix = FFIMatrix4x4.newMatrix()	
	self.worldMatrix = FFIMatrix4x4.newMatrix()
	self.worldViewMatrix = FFIMatrix4x4.newMatrix()
	self.worldViewProjectionMatrix = FFIMatrix4x4.newMatrix()
	self.worldVert = FFIVector3.newVector()
	self.forwardVector = FFIVector3.newVector()
	self.identityMatrix = FFIMatrix4x4.newMatrix()
	
	local meshes = {}
	
	local mesh = self:createMesh(0, 0, 0, 0, 0, 0)
	table.insert(meshes, mesh)
	
	--[[
	for i = 1, 250 do
		local x= math.random(-15, 15)
		local y = math.random(-15, 15)
		local z = math.random(-30, 0)
		local mesh = self:createMesh(x, y, z, 0, 0, 0)
		table.insert(meshes, mesh)
	end
	]]
	
	self.meshes = meshes	
end

function SpaceSimulatorScene:createMesh(x, y, z, rx, ry, rz)
	local mesh = FFIMesh.newMesh(8, 12)
	mesh.rotation.X = rx
	mesh.rotation.Y = ry
	mesh.rotation.Z = rz
	mesh.position.X = x
	mesh.position.Y = y
	mesh.position.Z = z
	
	local vertices = mesh.vertices
	local faces = mesh.faces
		
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
	
	vertices[4].X = 1
	vertices[4].Y = -1
	vertices[4].Z = -1
	
	vertices[5].X = 1
	vertices[5].Y = 1
	vertices[5].Z = -1
	
	vertices[6].X = -1
	vertices[6].Y = -1
	vertices[6].Z = -1

	vertices[7].X = -1
	vertices[7].Y = 1
	vertices[7].Z = -1
	
	faces[0].A = 0
	faces[0].B = 2
	faces[0].C = 1

	faces[1].A = 1
	faces[1].B = 2
	faces[1].C = 3

	faces[2].A = 1
	faces[2].B = 3
	faces[2].C = 5

	faces[3].A = 3
	faces[3].B = 4
	faces[3].C = 5
	
	faces[4].A = 6
	faces[4].B = 7
	faces[4].C = 4

	faces[5].A = 4
	faces[5].B = 7
	faces[5].C = 5

	faces[6].A = 0
	faces[6].B = 7
	faces[6].C = 2

	faces[7].A = 6
	faces[7].B = 2
	faces[7].C = 7
	
	faces[8].A = 2
	faces[8].B = 6
	faces[8].C = 3

	faces[9].A = 3
	faces[9].B = 6
	faces[9].C = 4

	faces[10].A = 1
	faces[10].B = 7
	faces[10].C = 0

	faces[11].A = 5
	faces[11].B = 7
	faces[11].C = 1	
	
	FFIMesh.calculateMiddlesAndNormals(mesh)
	
	return mesh
end

local trianglesToRender = {}
function SpaceSimulatorScene:draw(dt)
	local sw = self.screenWidth
	local sh = self.screenHeight
	
	for i = 1, #trianglesToRender do
		trianglesToRender[i] = nil
	end
	
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

	local viewMatrix = self.viewMatrix
	local inverseViewMatrix = self.inverseViewMatrix
	local projectionMatrix = self.projectionMatrix
	local rotationMatrix = self.rotationMatrix
	local tranlsationMatrix = self.tranlsationMatrix
	local worldMatrix = self.worldMatrix
	local worldViewMatrix = self.worldViewMatrix
	local worldViewProjectionMatrix = self.worldViewProjectionMatrix	
	local worldVert = self.worldVert
	local forwardVector = self.forwardVector
	local identityMatrix = self.identityMatrix
	
	Profiler:start('calculating matrices')	
	-- once per camera per frame
	FFIMatrix4x4.lookAtLHInline(viewMatrix, self.cameraPosition, self.cameraTarget, self.up)
	FFIMatrix4x4.inverseInline(inverseViewMatrix, viewMatrix)
	FFIMatrix4x4.perspectiveFovRHInline(projectionMatrix, 0.78, 1200 / 900, 0.001, 100)                                                          	
	Profiler:stop('calculating matrices')
	
	love.graphics.setColor(255,255,255)
	local drawingMesh = self.drawingMesh
	
	for _, mesh in ipairs(self.meshes) do
		Profiler:start('calculating matrices')	
		-- once per mesh per frame
		FFIMatrix4x4.rotationYawPitchRollInline(rotationMatrix, mesh.rotation)
		FFIMatrix4x4.translationInline(tranlsationMatrix, mesh.position)
		FFIMatrix4x4.multiplyInline(worldMatrix, rotationMatrix, tranlsationMatrix)
		FFIMatrix4x4.multiplyInline(worldViewMatrix, worldMatrix, viewMatrix)
		FFIMatrix4x4.multiplyInline(worldViewProjectionMatrix, worldViewMatrix, projectionMatrix)		
		Profiler:stop('calculating matrices')	
			
		Profiler:start('projecting vertices')
		for i = 0, mesh.faceCount - 1 do	
			local triangle = mesh.triangles[i]
			local face = mesh.faces[i]
			local normal = mesh.normals[i]
			local middle = mesh.middles[i]
			
			FFIMatrix4x4.transformNormalInline(forwardVector, normal, worldMatrix)
			FFIMatrix4x4.transformCoordinateInline(worldVert, middle, worldMatrix)							
			FFIVector3.subtractInline(worldVert, worldVert, self.cameraPosition)
			local dot = FFIVector3.dot(worldVert, forwardVector)			
			if dot < 0 then
				FFIMatrix4x4.project(triangle[1], mesh.vertices[face.A], worldViewProjectionMatrix, 0, 0, sw, sh, -10, 10)
				FFIMatrix4x4.project(triangle[2], mesh.vertices[face.B], worldViewProjectionMatrix, 0, 0, sw, sh, -10, 10)
				FFIMatrix4x4.project(triangle[3], mesh.vertices[face.C], worldViewProjectionMatrix, 0, 0, sw, sh, -10, 10)
				triangle.length = FFIVector3.lengthSquared(worldVert)
				trianglesToRender[#trianglesToRender + 1] = triangle
			end
		end
		Profiler:stop('projecting vertices')
	end
		
	Profiler:start('sorting vertices')
	table.sort(trianglesToRender, function(a, b) 
		return	a.length > b.length
	end)
	Profiler:stop('sorting vertices')
	
	Profiler:start('drawing vertices')
	for _, triangle in ipairs(trianglesToRender) do
		local v1 = triangle[1]
		local v2 = triangle[2]
		local v3 = triangle[3]
		drawingMesh:setVertex(1, v1.X, v1.Y, 0, 1, 128, 255, 255, 255)
		drawingMesh:setVertex(2, v2.X, v2.Y, 1, 1, 255, 128, 255, 255)
		drawingMesh:setVertex(3, v3.X, v3.Y, 1, 0, 255, 255, 128, 255)		
		--drawingMesh:setTexture(self.image)
		love.graphics.draw(drawingMesh, 0, 0)
	end
	Profiler:stop('drawing vertices')
	
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
	local mesh = self.meshes[1]

	if love.keyboard.isDown('pageup') then
		self.cameraPosition.Z = self.cameraPosition.Z - 10 * dt
	end
	
	if love.keyboard.isDown('pagedown') then
		self.cameraPosition.Z  = self.cameraPosition.Z + 10 * dt
	end	
	
	if love.keyboard.isDown('up') then
		mesh.rotation.Y = mesh.rotation.Y + 0.5 * dt
	end
	
	if love.keyboard.isDown('down') then
		mesh.rotation.Y = mesh.rotation.Y - 0.5 * dt
	end	
	
	if love.keyboard.isDown('left') then
		mesh.rotation.X = mesh.rotation.X - 0.5 * dt
	end
	
	if love.keyboard.isDown('right') then
		mesh.rotation.X = mesh.rotation.X + 0.5 * dt
	end
	
	if love.keyboard.isDown('z') then
		mesh.rotation.Z = mesh.rotation.Z - 0.5 * dt
	end
	
	if love.keyboard.isDown('x') then
		mesh.rotation.Z = mesh.rotation.Z + 0.5 * dt
	end
	
	if love.keyboard.isDown('w') then
		mesh.position.Z = mesh.position.Z - 5 * dt
		print(mesh.position.Z)
	end
	
	if love.keyboard.isDown('s') then
		mesh.position.Z = mesh.position.Z + 5 * dt
		print(mesh.position.Z)
	end
	
	if love.keyboard.isDown('a') then
		mesh.position.X = mesh.position.X - 5 * dt
	end
	
	if love.keyboard.isDown('d') then
		mesh.position.X = mesh.position.X + 5 * dt
	end
end

function SpaceSimulatorScene:keyreleased(key)
	print(key)
end

return SpaceSimulatorScene