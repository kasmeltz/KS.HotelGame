local Scene = require 'classes/scene/Scene'
local ShearTestScene = Scene:extend('ShearTestScene')

local cpml = require 'libs/cpml'

local roofMesh
local wallMesh

function ShearTestScene:findMiddle(mesh)
	for _, triangle in ipairs(mesh) do	
		local mx, my, mz = 0, 0, 0
		for _, vertex in ipairs(triangle.vertices) do
			mx = mx + vertex[1]
			my = my + vertex[2]
			mz = mz + vertex[3]
		end
		triangle.middle = { mx / 3, my / 3, mz / 3 }
	end
end

function ShearTestScene:createRoofSection(sx, ex, sy, ey)
	local t1 = 
	{
		vertices = 
		{
			{ex, ey, -1, 0, 1},
			{ex, sy, -1, 0, 0},
			{sx, ey, -1, 1, 1}
		}, 
		normal = { 0, 0, -1 }
	}
	
	local t2 = 
	{
		vertices = 
		{
			{ex, sy, -1, 0, 0},
			{sx, sy, -1, 1, 0},
			{sx, ey, -1, 1, 1}
		}, 		
		normal = { 0, 0, -1 }
	}
	
	return t1, t2
end

function ShearTestScene:createWallSection(sx, ex, sy, ey, nx, ny, level)
	local t1 = 
	{
		vertices = 
		{
			{sx, sy, level, 0, 1},
			{sx, sy, level + 1, 0, 0},
			{ex, ey, level, 1, 1},
		}, 
		normal = { nx, ny, 0 }
	}
	local t2 = 
	{
		vertices = 
		{
			{sx, sy, level + 1, 0, 0},
			{ex, ey, level + 1, 1, 0},
			{ex, ey, level, 1, 1},
		}, 
		normal = { nx, ny, 0 }
	}
	
	return t1, t2
end

function ShearTestScene:createBuilding(pos)
	local building = {}
	building.position = pos
	
	building[1] = 
	{
		texture = self.roofImage,		
	}
	
	local roof = building[1]
	local t1, t2 = self:createRoofSection(-0.5, 0.5, -0.5, 0.5)
	roof[#roof + 1] = t1
	roof[#roof + 1] = t2
	
	building[2] = 
	{
		texture = self.wallImage,		
	}
	
	local walls = building[2]	
	for i = 2, 6 do
		local level = -i
		local t1, t2 = self:createWallSection(0.5, 0.5, -0.5, 0.5, -1, 0, level)
		walls[#walls + 1] = t1
		walls[#walls + 1] = t2
		local t1, t2 = self:createWallSection(-0.5, -0.5, -0.5, 0.5, 1, 0, level)
		walls[#walls + 1] = t1
		walls[#walls + 1] = t2		
		local t1, t2 = self:createWallSection(-0.5, 0.5, -0.5, -0.5, 0, 1, level)
		walls[#walls + 1] = t1
		walls[#walls + 1] = t2
		local t1, t2 = self:createWallSection(-0.5, 0.5, 0.5, 0.5, 0, -1, level)
		walls[#walls + 1] = t1
		walls[#walls + 1] = t2		
	end

	for _, mesh in ipairs(building) do
		self:findMiddle(mesh)
	end
	
	return building
end

function ShearTestScene:init()
	ShearTestScene.super.init(self)
	self.roofImage = love.graphics.newImage('data/images/roof.jpg')
	self.wallImage = love.graphics.newImage('data/images/building3.png')
	local drawingMesh = love.graphics.newMesh(3, 'triangles', 'dynamic')
	self.drawingMesh = drawingMesh		
end

local cam = {0, 0, -5}

local building1Pos = {0, 0, 0}
local building2Pos = {6, 0, 0}
local building3Pos = {0, 6, 0}
local building4Pos = {6, 6, 0}
local building5Pos = {-10, 0, 0}

function ShearTestScene:addMeshesToScene(meshes)
	local meshesToRender = self.meshesToRender
	local position = meshes.position
	
	-- move mesh according to object and camera
	for _, mesh in ipairs(meshes) do
		local movedMesh = { texture = mesh.texture, position = position }
		for _, triangle in ipairs(mesh) do
			local movedTriangle = { normal = triangle.normal, middle = triangle.middle,  vertices = {} }
			for _, vertex in ipairs(triangle.vertices) do	
				local movedVertex = 
				{			
					vertex[1] + cam[1] + position[1], 
					vertex[2] + cam[2] + position[2], 
					vertex[3] + cam[3] + position[3], 
					vertex[4], 
					vertex[5] 
				}
				movedTriangle.vertices[#movedTriangle.vertices + 1] = movedVertex
			end		
			movedMesh[#movedMesh + 1] = movedTriangle
		end
		meshesToRender[#meshesToRender + 1] = movedMesh
	end		
end

function ShearTestScene:renderMeshes()
	local meshesToRender = self.meshesToRender

	-- sort triangles
	local orderedTriangles = {}	
	for _, mesh in ipairs(meshesToRender) do
		local pos = mesh.position
		for _, triangle in ipairs(mesh) do	
			local n = triangle.normal
			local middle = triangle.middle
			local mx = middle[1] + pos[1]
			local my = middle[2] + pos[2]
			local mz = middle[3] + pos[3]
			local lx = mx + cam[1]
			local ly = my + cam[2]
			local lz = mz + cam[3]			
			local dot = n[1] * lx + n[2] * ly + n[3] * lz		
			if dot > 0 then
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

		local insideScreen = false
		for _, vertex in ipairs(vertices2D) do
			if vertex[1] > 0 or vertex[1] < sw or vertex[2] > 0 or vertex[2] < sh then
				insideScreen = true
				break
			end
		end
		
		if insideScreen then		
			for i, vertex in ipairs(vertices2D) do
				drawingMesh:setVertex(i, vertex[1], vertex[2], vertex[3], vertex[4], 255, 255, 255, 255)
			end		
			drawingMesh:setTexture(triangle.texture)
			love.graphics.draw(drawingMesh, 0, 0)
		end
	end	
end

function ShearTestScene:draw()	
	self.meshesToRender = {}
	
	local bldg = self:createBuilding(building1Pos)
	self:addMeshesToScene(bldg)

	local bldg = self:createBuilding(building2Pos)
	self:addMeshesToScene(bldg)

	local bldg = self:createBuilding(building3Pos)
	self:addMeshesToScene(bldg)

	local bldg = self:createBuilding(building4Pos)
	self:addMeshesToScene(bldg)

	local bldg = self:createBuilding(building5Pos)
	self:addMeshesToScene(bldg)

	self:renderMeshes()	
end

function ShearTestScene:update(dt)	
	if love.keyboard.isDown('a') then
		cam[1] = cam[1] - dt * 5
	end
	if love.keyboard.isDown('d') then
		cam[1] = cam[1] + dt * 5
	end
	if love.keyboard.isDown('w') then
		cam[2] = cam[2] + dt * 5
	end
	if love.keyboard.isDown('s') then
		cam[2] = cam[2] - dt * 5
	end
	if love.keyboard.isDown('q') then
		cam[3] = cam[3] - dt * 5
	end
	if love.keyboard.isDown('e') then
		cam[3] = cam[3] + dt * 5
	end	
end

return ShearTestScene