local Scene = require 'classes/scene/Scene'
local ShearTestScene = Scene:extend('ShearTestScene')

function ShearTestScene:init()
	ShearTestScene.super.init(self)
	local roofImages = {}
	roofImages[1] = love.graphics.newImage('data/images/roof.jpg')
	roofImages[2] = love.graphics.newImage('data/images/roof2.jpg')
	roofImages[3] = love.graphics.newImage('data/images/roof3.jpg')
	roofImages[4] = love.graphics.newImage('data/images/roof4.jpg')
	self.roofImages = roofImages
	
	local buildingImages = {}
	buildingImages[1] = love.graphics.newImage('data/images/building3.png')
	buildingImages[2] = love.graphics.newImage('data/images/building4.jpg')
	buildingImages[3] = love.graphics.newImage('data/images/building5.png')
	buildingImages[4] = love.graphics.newImage('data/images/building6.jpg')
	buildingImages[5] = love.graphics.newImage('data/images/building7.jpg')	
	self.buildingImages = buildingImages
	
	local drawingMesh = love.graphics.newMesh(3, 'triangles', 'dynamic')
	self.drawingMesh = drawingMesh		
	
	local camera = {-3, -2, -10}
	self.camera = camera

	local building1Pos = {0, 0, 0}
	local building2Pos = {10, 0, 0}
	local building3Pos = {0, 6, 0}
	local building4Pos = {6, 6, 0}
	local building5Pos = {-10, 0, 0}

	local buildingMeshes = {}
	
	buildingMeshes[#buildingMeshes + 1] = 
		self:createBuilding(-2, 2, -1, 1, 1, -5, 0.5,
		building1Pos, self.roofImages[1], self.buildingImages[1])		
		
	buildingMeshes[#buildingMeshes + 1] = 
		self:createBuilding(-2, 2, -1, 1, -1, -5, 0.5,
		building2Pos, self.roofImages[2], self.buildingImages[2])
		
	buildingMeshes[#buildingMeshes + 1] = 
		self:createBuilding(-3, 3, -0.5, 0.5, -1, -5, 0.5,
		building3Pos, self.roofImages[3], self.buildingImages[3])
		
	buildingMeshes[#buildingMeshes + 1] = 
		self:createBuilding(-0.25, 0.25, -1, 1, -1, -5, 0.5,
		building4Pos, self.roofImages[4], self.buildingImages[4])
		
	self.buildingMeshes = buildingMeshes
		
	self.meshesToRender = {}
end


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

function ShearTestScene:createRoofSection(sx, ex, sy, ey, z)
	local t1 = 
	{
		vertices = 
		{
			{ex, ey, z, 0, 1},
			{ex, sy, z, 0, 0},
			{sx, ey, z, 1, 1}
		}, 
		movedVertices =
		{
			{0, 0, 0, 0, 1},
			{0, 0, 0, 0, 0},
			{0, 0, 0, 1, 1},
		},
		normal = { 0, 0, -1 }
	}
	
	local t2 = 
	{
		vertices = 
		{
			{ex, sy, z, 0, 0},
			{sx, sy, z, 1, 0},
			{sx, ey, z, 1, 1}
		}, 		
		movedVertices = 
		{
			{0, 0, 0, 0, 0},
			{0, 0, 0, 1, 0},
			{0, 0, 0, 1, 1},
		},
		normal = { 0, 0, -1 }
	}
	
	return t1, t2
end

function ShearTestScene:createWallSection(sx, ex, sy, ey, sz, ez, nx, ny)
	local t1 = 
	{
		vertices = 
		{
			{sx, sy, ez, 0, 1},
			{sx, sy, sz, 0, 0},
			{ex, ey, ez, 1, 1},
		}, 
		movedVertices =
		{
			{0, 0, 0, 0, 1},
			{0, 0, 0, 0, 0},
			{0, 0, 0, 1, 1},
		},
		normal = { nx, ny, 0 }
	}
	local t2 = 
	{
		vertices = 
		{
			{sx, sy, sz, 0, 0},
			{ex, ey, sz, 1, 0},
			{ex, ey, ez, 1, 1},
		}, 
		movedVertices =
		{
			{0, 0, 0, 0, 0},
			{0, 0, 0, 1, 0},
			{0, 0, 0, 1, 1},
		},
		normal = { nx, ny, 0 }
	}
	
	return t1, t2
end

function ShearTestScene:createBuilding(sx, ex, sy, ey, sz, ez, ss, position, roofImage, buildingImage)
	local building = {}
	building.position = position
	
	building[1] = 
	{
		texture = roofImage	
	}
	
	local roof = building[1]
	local t1, t2 = self:createRoofSection(sx, ex, sy, ey, sz)
	roof[#roof + 1] = t1
	roof[#roof + 1] = t2
	
	building[2] = 
	{
		texture = buildingImage		
	}
	
	local walls = building[2]	
	for y = sy, ey - ss, ss do
		for z = sz - ss, ez, -ss do
			local t1, t2 = self:createWallSection(sx, sx, y, y + ss, z + ss, z, 1, 0)
			walls[#walls + 1] = t1
			walls[#walls + 1] = t2
			local t1, t2 = self:createWallSection(ex, ex, y, y + ss, z + ss, z, -1, 0)
			walls[#walls + 1] = t1
			walls[#walls + 1] = t2		
		end
	end
	
	for x = sx, ex - ss, ss do
		for z = sz - ss, ez, -ss do	
			local t1, t2 = self:createWallSection(x, x + ss, sy, sy, z + ss, z, 0, 1)
			walls[#walls + 1] = t1
			walls[#walls + 1] = t2
			local t1, t2 = self:createWallSection(x, x + ss, ey, ey, z + ss, z, 0, -1)
			walls[#walls + 1] = t1
			walls[#walls + 1] = t2		
		end
	end

	for _, mesh in ipairs(building) do
		self:findMiddle(mesh)
	end
	
	return building
end

function ShearTestScene:addMeshesToScene(meshes)
	local meshesToRender = self.meshesToRender
	local position = meshes.position
	local camera = self.camera
	
	-- move mesh according to object and camera
	for _, mesh in ipairs(meshes) do
		for _, triangle in ipairs(mesh) do
			for idx, vertex in ipairs(triangle.vertices) do
				local movedVertex = triangle.movedVertices[idx]
				movedVertex[1] = vertex[1] + camera[1] + position[1]
				movedVertex[2] = vertex[2] + camera[2] + position[2]
				movedVertex[3] = vertex[3] + camera[3] + position[3]
			end		
		end
		mesh.position = position
		meshesToRender[#meshesToRender + 1] = mesh
	end		
end

local orderedTriangles = {}	
function ShearTestScene:renderMeshes()
	local meshesToRender = self.meshesToRender
	local camera = self.camera
	
	for i = 1, #orderedTriangles do
		orderedTriangles[i] = nil
	end
	
	-- sort triangles	
	for _, mesh in ipairs(meshesToRender) do
		local pos = mesh.position
		for _, triangle in ipairs(mesh) do	
			local n = triangle.normal
			local middle = triangle.middle
			local mx = middle[1] + pos[1]
			local my = middle[2] + pos[2]
			local mz = middle[3] + pos[3]
			local lx = mx + camera[1]
			local ly = my + camera[2]
			local lz = mz + camera[3]			
			local dot = n[1] * lx + n[2] * ly + n[3] * lz		
			if dot > 0 then
				local dx = mx - camera[1]
				local dy = my - camera[2]
				local dz = mz - camera[3]
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
		for i, vertex in ipairs(triangle.movedVertices) do
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

local frame = 1
local timeToAddMeshes = 0
local timeToRender = 0
function ShearTestScene:draw()	
	local startTime = love.timer.getTime()
	
	local meshesToRender = self.meshesToRender
	for i = 1, #meshesToRender do
		meshesToRender[i] = nil
	end

	local buildingMeshes = self.buildingMeshes
	for _, bldg in ipairs(buildingMeshes) do
		self:addMeshesToScene(bldg)
	end
	
	local endTime = love.timer.getTime()
	
	timeToAddMeshes = timeToAddMeshes + (endTime - startTime)
	
	startTime = love.timer.getTime()
	
	self:renderMeshes()	
	
	endTime = love.timer.getTime()
	
	timeToRender = timeToRender + (endTime - startTime)

	love.graphics.print('Time to add meshes: ' .. (timeToAddMeshes / frame), 0, 20)	
	love.graphics.print('Time to render: ' .. (timeToRender / frame), 0, 35)
	
	frame = frame + 1
end

function ShearTestScene:update(dt)	
	local camera = self.camera
	
	if love.keyboard.isDown('a') then
		camera[1] = camera[1] - dt * 5
	end
	if love.keyboard.isDown('d') then
		camera[1] = camera[1] + dt * 5
	end
	if love.keyboard.isDown('w') then
		camera[2] = camera[2] + dt * 5
	end
	if love.keyboard.isDown('s') then
		camera[2] = camera[2] - dt * 5
	end
	if love.keyboard.isDown('q') then
		camera[3] = camera[3] - dt * 5
	end
	if love.keyboard.isDown('e') then
		camera[3] = camera[3] + dt * 5
	end	
end

return ShearTestScene