local Scene = require 'classes/scene/Scene'
local SpaceSimulatorScene = Scene:extend('SpaceSimulatorScene')

local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()
local FFIMatrix4x4 = require 'classes/math/FFIMatrix4x4'
local FFIVector3 = require 'classes/math/FFIVector3'
local FFIMesh = require 'classes/math/FFIMesh'
local FFIRenderer = require 'classes/math/FFIRenderer'
local FFISDL = require 'classes/math/FFISDL'
FFISDL = FFISDL:getInstance()

function SpaceSimulatorScene:init(gameWorld)
	SpaceSimulatorScene.super.init(self, gameWorld)
	
	local drawingMesh = love.graphics.newMesh(3, 'triangles', 'dynamic')
	self.drawingMesh = drawingMesh
	
	local sw = self.screenWidth
	local sh = self.screenHeight

	self.cameraPosition = FFIVector3.newVector()
	self.cameraPosition.X = 0
	self.cameraPosition.Y = 10
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
	self.projectionMatrix = FFIMatrix4x4.newMatrix()
	self.rotationMatrix = FFIMatrix4x4.newMatrix()
	self.tranlsationMatrix = FFIMatrix4x4.newMatrix()	
	self.worldMatrix = FFIMatrix4x4.newMatrix()
	self.worldViewMatrix = FFIMatrix4x4.newMatrix()
	self.worldViewProjectionMatrix = FFIMatrix4x4.newMatrix()
	self.worldVert = FFIVector3.newVector()
	self.forwardVector = FFIVector3.newVector()
	
	local meshes = {}
		
	local size = 0.2
	local z = 0
	for z = -1, 1, size * 2 do
		for y = -6.5, 6.5, size * 2 - 0.05 do
			for x = -6.5, 6.5, size * 2 - 0.05 do
				if math.random(0,100) > 90 then
					local mesh = self:createMesh(size, size, size, x, y, z, 255, 128, 255)
					table.insert(meshes, mesh)
				end
			end
		end
	end
	
	self.meshes = meshes	
	
	print(#self.meshes)
	
	--FFISDL:start(1200, 900)
end

function SpaceSimulatorScene:createMesh(sx, sy, sz, x, y, z, r, g, b)
	local mesh = FFIMesh.newMesh(8, 8)
	mesh.rotation.X = 0
	mesh.rotation.Y = 0
	mesh.rotation.Z = 0
	mesh.position.X = x
	mesh.position.Y = y
	mesh.position.Z = z
	
	local vertices = mesh.vertices
	local faces = mesh.faces
		
	local v = vertices[0]
	v.X = -sx
	v.Y = sy
	v.Z = sz
	
	v = vertices[1]
	v.X = sx
	v.Y = sy
	v.Z = sz

	v = vertices[2]
	v.X = -sx
	v.Y = -sy
	v.Z = sz
	
	v = vertices[3]
	v.X = sx
	v.Y = -sy
	v.Z = sz
	
	v = vertices[4]
	v.X = sx
	v.Y = -sy
	v.Z = -sz
	
	v = vertices[5]
	v.X = sx
	v.Y = sy
	v.Z = -sz
	
	v = vertices[6]
	v.X = -sx
	v.Y = -sy
	v.Z = -sz

	v = vertices[7]
	v.X = -sx
	v.Y = sy
	v.Z = -sz

	local f = faces[0]
	f.A = 1
	f.B = 3
	f.C = 5
	f.r = r * 0.85
	f.g = g * 0.85
	f.b = b * 0.85

	local f = faces[1]
	f.A = 3
	f.B = 4
	f.C = 5
	f.r = r * 0.85
	f.g = g * 0.85
	f.b = b * 0.85

	local f = faces[2]
	f.A = 0
	f.B = 7
	f.C = 2
	f.r = r * 0.85
	f.g = g * 0.85
	f.b = b * 0.85
	
	local f = faces[3]
	f.A = 6
	f.B = 2
	f.C = 7
	f.r = r * 0.85
	f.g = g * 0.85
	f.b = b * 0.85
	
	local f = faces[4]
	f.A = 1
	f.B = 7
	f.C = 0
	f.r = r * 0.75
	f.g = g * 0.75
	f.b = b * 0.75
	
	local f = faces[5]
	f.A = 5
	f.B = 7
	f.C = 1
	f.r = r * 0.75
	f.g = g * 0.75
	f.b = b * 0.75
	
	local f = faces[6]
	f.A = 0
	f.B = 1
	f.C = 2
	f.r = r
	f.g = g
	f.b = b
	
	local f = faces[7]
	f.A = 1
	f.B = 2
	f.C = 3
	f.r = r
	f.g = g
	f.b = b
	
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
	Profiler:start('sdl blit')
	FFISDL:blit()
	Profiler:stop('sdl blit')	
	]]

	--Profiler:start('rendering scene')	
	--FFIRenderer.render(self.backBufferData:getPointer(), sw, sh)
	--Profiler:stop('rendering scene')	
	
	--Profiler:start('refreshing back buffer')	
	--self.backBuffer:refresh()
	--Profiler:stop('refreshing back buffer')	
	
	--Profiler:start('drawing back buffer')	
	--love.graphics.draw(self.backBuffer)
	--Profiler:stop('drawing back buffer')	

	local viewMatrix = self.viewMatrix
	local projectionMatrix = self.projectionMatrix
	local rotationMatrix = self.rotationMatrix
	local tranlsationMatrix = self.tranlsationMatrix
	local worldMatrix = self.worldMatrix
	local worldViewMatrix = self.worldViewMatrix
	local worldViewProjectionMatrix = self.worldViewProjectionMatrix	
	local worldVert = self.worldVert
	local forwardVector = self.forwardVector
	
	Profiler:start('calculating matrices')	
	-- once per camera per frame
	FFIMatrix4x4.lookAtLHInline(viewMatrix, self.cameraPosition, self.cameraTarget, self.up)
	FFIMatrix4x4.perspectiveFovRHInline(projectionMatrix, 0.78, 1200 / 900, 0.001, 100)                                                          	
	Profiler:stop('calculating matrices')
	
	love.graphics.setColor(255,255,255)
	local drawingMesh = self.drawingMesh
	
	for _, mesh in ipairs(self.meshes) do
		Profiler:start('calculating matrices')	
		-- once per mesh per frame
		--FFIMatrix4x4.rotationYawPitchRollInline(rotationMatrix, mesh.rotation)
		--FFIMatrix4x4.translationInline(tranlsationMatrix, mesh.position)
		FFIMatrix4x4.translationInline(worldMatrix, mesh.position)
		--FFIMatrix4x4.multiplyInline(worldMatrix, rotationMatrix, tranlsationMatrix)
		FFIMatrix4x4.multiplyInline(worldViewMatrix, worldMatrix, viewMatrix)
		FFIMatrix4x4.multiplyInline(worldViewProjectionMatrix, worldViewMatrix, projectionMatrix)		
		Profiler:stop('calculating matrices')	
			
		Profiler:start('projecting vertices')
		for i = 0, mesh.faceCount - 1 do	
			local triangle = mesh.triangles[i]
			local face = mesh.faces[i]
			--local normal = mesh.normals[i]
			--local middle = mesh.middles[i]			
			
			--FFIMatrix4x4.transformNormalInline(forwardVector, normal, worldMatrix)
			--FFIMatrix4x4.transformCoordinateInline(worldVert, middle, worldMatrix)							
			--FFIVector3.subtractInline(worldVert, worldVert, self.cameraPosition)
			--local dot = FFIVector3.dot(worldVert, forwardVector)			
			--if dot < 0 then
				FFIMatrix4x4.project(triangle[1], mesh.vertices[face.A], worldViewProjectionMatrix, 0, 0, sw, sh, -10, 10)
				FFIMatrix4x4.project(triangle[2], mesh.vertices[face.B], worldViewProjectionMatrix, 0, 0, sw, sh, -10, 10)
				FFIMatrix4x4.project(triangle[3], mesh.vertices[face.C], worldViewProjectionMatrix, 0, 0, sw, sh, -10, 10)
				--triangle.length = FFIVector3.lengthSquared(worldVert)
				trianglesToRender[#trianglesToRender + 1] = triangle
				triangle.face = face
			--end
		end
		Profiler:stop('projecting vertices')
	end
	
	--[[
	Profiler:start('sorting vertices')
	table.sort(trianglesToRender, function(a, b) 
		return	a.length > b.length
	end)
	Profiler:stop('sorting vertices')
	]]
	
	Profiler:start('drawing vertices')
	for _, triangle in ipairs(trianglesToRender) do
		local v1 = triangle[1]
		local v2 = triangle[2]
		local v3 = triangle[3]
		local face = triangle.face
		love.graphics.setColor(face.r, face.g, face.b)
		love.graphics.polygon('fill', v1.X, v1.Y, v2.X, v2.Y, v3.X, v3.Y)
		--drawingMesh:setVertex(1, v1.X, v1.Y, 0, 1, 128, 255, 255, 255)
		--drawingMesh:setVertex(2, v2.X, v2.Y, 1, 1, 255, 128, 255, 255)
		--drawingMesh:setVertex(3, v3.X, v3.Y, 1, 0, 255, 255, 128, 255)		
		--drawingMesh:setTexture(self.image)
--		love.graphics.draw(drawingMesh, 0, 0)
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
	
	--[[
	if love.keyboard.isDown('up') then
		self.cameraTarget.Y = self.cameraTarget.Y - 5 * dt
	end
	
	if love.keyboard.isDown('down') then
		self.cameraTarget.Y = self.cameraTarget.Y + 5 * dt
	end	
	
	if love.keyboard.isDown('left') then
		self.cameraTarget.X = self.cameraTarget.X - 5 * dt
	end
	
	if love.keyboard.isDown('right') then
		self.cameraTarget.X = self.cameraTarget.X + 5 * dt
	end
	]]
	
	if love.keyboard.isDown('w') then
		self.cameraPosition.Z = self.cameraPosition.Z - 25 * dt
		self.cameraTarget.Z = self.cameraTarget.Z - 25 * dt
		self.cameraPosition.Y = self.cameraPosition.Y - 25 * dt
		self.cameraTarget.Y = self.cameraTarget.Y - 25 * dt
	end
	
	if love.keyboard.isDown('s') then
		self.cameraPosition.Z = self.cameraPosition.Z + 25 * dt
		self.cameraTarget.Z = self.cameraTarget.Z + 25 * dt
		self.cameraPosition.Y = self.cameraPosition.Y + 25 * dt
		self.cameraTarget.Y = self.cameraTarget.Y + 25 * dt
	end
	
	if love.keyboard.isDown('a') then
		self.cameraPosition.X = self.cameraPosition.X - 5 * dt
		self.cameraTarget.X = self.cameraTarget.X - 5 * dt
	end
	
	if love.keyboard.isDown('d') then
		self.cameraPosition.X = self.cameraPosition.X + 5 * dt
		self.cameraTarget.X = self.cameraTarget.X + 5 * dt
	end
	
	--[[
	for i = 2, #self.meshes do
		local mesh = self.meshes[i]
		local x = math.random(-1, 1)
		local y = math.random(-1, 1)
		local z = math.random(-1, 1)
		mesh.rotation.X = mesh.rotation.X + x * dt
		mesh.rotation.Y = mesh.rotation.Y + y * dt
		mesh.rotation.Z = mesh.rotation.Z + z * dt
	end
	]]
end

function SpaceSimulatorScene:keyreleased(key)
	print(key)
end

return SpaceSimulatorScene