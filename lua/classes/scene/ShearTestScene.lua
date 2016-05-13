local Scene = require 'classes/scene/Scene'
local ShearTestScene = Scene:extend('ShearTestScene')

local toChannel = love.thread.getChannel('toBuildings')
local fromChannel = love.thread.getChannel('fromBuildings')

local cpml = require 'libs/cpml'

local roofMesh
local wallMesh

function ShearTestScene:init()
	ShearTestScene.super.init(self)
	self.roofImage = love.graphics.newImage('data/images/roof.jpg')
	self.wallImage = love.graphics.newImage('data/images/building2.jpg')
	local drawingMesh = love.graphics.newMesh(3, 'triangles', 'dynamic')
	self.drawingMesh = drawingMesh	

	roofMesh = 	
	{
		texture = self.roofImage,		
		{
			vertices = 
			{
				{1, 1, -1, 0, 1},
				{1, -1, -1, 0, 0},
				{-1, 1, -1, 1, 1}
			}, 
			normal = { 0, 0, -1 }
		}, 
		{
			vertices = 
			{
				{1, -1, -1, 0, 0},
				{-1, -1, -1, 1, 0},
				{-1, 1, -1, 1, 1}
			}, 		
			normal = { 0, 0, -1 }
		}
	}	
	
	wallMesh = 
	{
		texture = self.wallImage,
		{
			vertices = 
			{
				{1, -1, -5, 0, 1},
				{1, -1, -1, 0, 0},
				{1, 1, -5, 1, 1},
			}, 
			normal = { -1, 0, 0 }
		},
		{
			vertices = 
			{
				{1, -1, -1, 0, 0},
				{1, 1, -1, 1, 0},
				{1, 1, -5, 1, 1},
			}, 
			normal = { -1, 0, 0 }
		},
		{
			vertices = 
			{
				{-1, -1, -5, 0, 1},
				{-1, -1, -1, 0, 0},
				{-1, 1, -5, 1, 1},
			}, 
			normal = { 1, 0, 0 }
		},
		{
			vertices = 
			{
				{-1, -1, -1, 0, 0},
				{-1, 1, -1, 1, 0},
				{-1, 1, -5, 1, 1},
			}, 
			normal = { 1, 0, 0 }
		},
		{
			vertices = 
			{
				{-1, -1, -5, 0, 1},
				{-1, -1, -1, 0, 0},
				{1, -1, -5, 1, 1}
			}, 
			normal = { 0, 1, 0 }
		},
		{
			vertices = 
			{
				{-1, -1, -1, 0, 0},
				{1, -1, -1, 1, 0},
				{1, -1, -5, 1, 1},
			}, 
			normal = { 0, 1, 0 }
		},
		{
			vertices = 
			{
				{-1, 1, -5, 0, 1},
				{-1, 1, -1, 0, 0},
				{1, 1, -5, 1, 1},
			}, 
			normal = { 0, -1, 0 }
		},
		{
			vertices = 
			{
				{-1, 1, -1, 0, 0},
				{1, 1, -1, 1, 0},
				{1, 1, -5, 1, 1},
			}, 
			normal = { 0, -1, 0 }
		}
	}
end

local cam = {0, 0, -10}

local building1Pos = {0, 0, 0}

function ShearTestScene:addMeshToRender(mesh, pos)
	local meshesToRender = self.meshesToRender
	
	-- move verts according to object and camera
	local movedMesh = { texture = mesh.texture }
	for _, triangle in ipairs(mesh) do
		local movedTriangle = { normal = triangle.normal, vertices = {} }
		for _, vertex in ipairs(triangle.vertices) do	
			local movedVertex = 
			{			
				vertex[1] + cam[1] - pos[1], 
				vertex[2] + cam[2] - pos[2], 
				vertex[3] + cam[3] - pos[3], 
				vertex[4], 
				vertex[5] 
			}
			movedTriangle.vertices[#movedTriangle.vertices + 1] = movedVertex
		end		
		movedMesh[#movedMesh + 1] = movedTriangle
	end
	
	meshesToRender[#meshesToRender + 1] = movedMesh
end

function ShearTestScene:renderMeshes()
	local meshesToRender = self.meshesToRender

	-- sort triangles
	local orderedTriangles = {}	
	for _, mesh in ipairs(meshesToRender) do
		for _, triangle in ipairs(mesh) do	
			local n = triangle.normal
			local mx, my, mz, lx, ly, lz = 0, 0, 0, 0, 0, 0
			for _, vertex in ipairs(triangle.vertices) do
				mx = mx + vertex[1]
				my = my + vertex[2]
				mz = mz + vertex[3]
			end
			mx = mx / 3
			my = my / 3
			mz = mz / 3
			local lx = mx + cam[1]
			local ly = my + cam[2]
			local lz = mz + cam[3]			
			local dot = n[1] * lx + n[2] * ly + n[3] * lz		

			--print('dot')			
			--print(dot)
			
			if dot > 1 then
				local dx = mx - cam[1]
				local dy = my - cam[2]
				local dz = mz - cam[3]
				triangle.distanceToCamera = (dx * dx) + (dy * dy) + (dz * dz)
				triangle.texture = mesh.texture
				orderedTriangles[#orderedTriangles + 1] = triangle
			end
		end
	end
	
	table.sort(orderedTriangles, 
		function(a,b) 
			return a.distanceToCamera > b.distanceToCamera 
		end)
		
	-- transform triangles to 2d space		
	local sw = self.screenWidth
	local sh = self.screenHeight
	local hsw = sw / 2
	local hsh = sh / 2	
	local drawingMesh = self.drawingMesh	
	
	local vertices2D = {}	
	for _, triangle in ipairs(orderedTriangles) do
		for i, vertex in ipairs(triangle.vertices) do
			local tx = (vertex[1] / vertex[3] * sw) + hsw
			local ty = (-vertex[2] / vertex[3] * sh) + hsh	
			vertices2D[i] = { tx, ty, vertex[4], vertex[5] }
		end

		-- TO DO check to see if transformed vertices are within screen coordinates		
		for i, vertex in ipairs(vertices2D) do
			drawingMesh:setVertex(i, vertex[1], vertex[2], vertex[3], vertex[4], 255, 255, 255, 255)
		end		
		drawingMesh:setTexture(triangle.texture)
		love.graphics.draw(drawingMesh, 0, 0)
	end	
end

function ShearTestScene:draw()	
	self.meshesToRender = {}
	
	self:addMeshToRender(wallMesh, building1Pos)
	self:addMeshToRender(roofMesh, building1Pos)	

	self:renderMeshes()	
end

function ShearTestScene:update(dt)	
	if love.keyboard.isDown('a') then
		cam[1] = cam[1] + dt * 2
	end
	if love.keyboard.isDown('d') then
		cam[1] = cam[1] - dt * 2
	end
	if love.keyboard.isDown('w') then
		cam[2] = cam[2] - dt * 2
	end
	if love.keyboard.isDown('s') then
		cam[2] = cam[2] + dt * 2
	end
	if love.keyboard.isDown('q') then
		cam[3] = cam[3] - dt * 2
	end
	if love.keyboard.isDown('e') then
		cam[3] = cam[3] + dt * 2
	end	
end

return ShearTestScene