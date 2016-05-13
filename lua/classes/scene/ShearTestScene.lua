local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

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
	
	local camera = {0, 0, -10}
	self.camera = camera

	local building1Pos = {0, -6, 0}
	local building2Pos = {10, 0, 0}
	local building3Pos = {0, 6, 0}
	local building4Pos = {6, 6, 0}
	local building5Pos = {-10, 0, 0}

	local buildingObjects = {}	
	
	buildingObjects[#buildingObjects + 1] = 
		self:createBuilding(-2, 2, -1, 1, 1, -5, 0.5,
		building1Pos, self.roofImages[1], self.buildingImages[1])		
	
	--[[
	buildingObjects[#buildingObjects + 1] = 
		self:createBuilding(-2, 2, -1, 1, -1, -5, 0.5,
		building2Pos, self.roofImages[2], self.buildingImages[2])
		
	buildingObjects[#buildingObjects + 1] = 
		self:createBuilding(-3, 3, -0.5, 0.5, -1, -5, 0.5,
		building3Pos, self.roofImages[3], self.buildingImages[3])
		
	buildingObjects[#buildingObjects + 1] = 
		self:createBuilding(-0.25, 0.25, -1, 1, -1, -5, 0.5,
		building4Pos, self.roofImages[4], self.buildingImages[4])
	]]
		
	self.buildingObjects = buildingObjects
		
	self.meshesToRender = {}
	self.scene = {}
	self.orderedTriangles = {}
	
	self.hero = 
	{
		position = {0, 0, -5},
		oldPosition = {0, 0, 0},
		position2D = {0, 0},		
	}
end

function ShearTestScene:show()
end

function ShearTestScene:findMiddle(mesh)
	for _, triangle in ipairs(mesh.triangles) do	
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
		normal = { 0, 0, -1 },
		vertices2D = {}
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
		normal = { 0, 0, -1 },
		vertices2D = {}
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
		normal = { nx, ny, 0 },
		vertices2D = {}
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
		normal = { nx, ny, 0 },
		vertices2D = {}
	}
	
	return t1, t2
end

function ShearTestScene:createBuilding(sx, ex, sy, ey, sz, ez, ss, position, roofImage, buildingImage)
	local building = {}
	building.position = position	
	building.meshes = {}
	building.boundingBoxes = {}
	building.movedBoxes = {}
	building.boundingBoxes2D = {}
	
	local roof = 
	{
		texture = roofImage,
		triangles = {}
	}
	
	for x = sx, ex - ss, ss do
		for y = sy, ey - ss, ss do
			-- roof structure must follow the walls
			local t1, t2 = self:createRoofSection(x, x + ss, y, y + ss, sz)
			table.insert(roof.triangles, t1)
			table.insert(roof.triangles, t2)						
			-- insert bounding boxes to match the structure
			local box = { x, y, x + ss, y + ss, ez }
			table.insert(building.boundingBoxes, box)
			table.insert(building.movedBoxes,{0,0,0,0,0,0})
			table.insert(building.boundingBoxes2D,{0,0,0,0})
		end
	end
	
	table.insert(building.meshes, roof)		
	
	local walls =
	{
		texture = buildingImage,
		triangles = {}
	}
	for y = sy, ey - ss, ss do
		for z = sz - ss, ez, -ss do
			local t1, t2 = self:createWallSection(sx, sx, y, y + ss, z + ss, z, 1, 0)
			table.insert(walls.triangles, t1)
			table.insert(walls.triangles, t2)
			local t1, t2 = self:createWallSection(ex, ex, y, y + ss, z + ss, z, -1, 0)
			table.insert(walls.triangles, t1)
			table.insert(walls.triangles, t2)
		end
	end
	
	for x = sx, ex - ss, ss do
		for z = sz - ss, ez, -ss do	
			local t1, t2 = self:createWallSection(x, x + ss, sy, sy, z + ss, z, 0, 1)
			table.insert(walls.triangles, t1)
			table.insert(walls.triangles, t2)
			local t1, t2 = self:createWallSection(x, x + ss, ey, ey, z + ss, z, 0, -1)
			table.insert(walls.triangles, t1)
			table.insert(walls.triangles, t2)
		end
	end

	table.insert(building.meshes, walls)
	
	for _, mesh in ipairs(building.meshes) do
		self:findMiddle(mesh)
	end
	
	return building
end

function ShearTestScene:addObjectToScene(object)
	local meshesToRender = self.meshesToRender
	local position = object.position
	local camera = self.camera

	object.rendered = false
	
	local scene = self.scene
	table.insert(scene, object)	
	
	-- move mesh according to object and camera
	for _, mesh in ipairs(object.meshes) do		
		mesh.object = object
		for _, triangle in ipairs(mesh.triangles) do
			triangle.mesh = mesh
			for idx, vertex in ipairs(triangle.vertices) do
				local movedVertex = triangle.movedVertices[idx]
				movedVertex[1] = vertex[1] + position[1] - camera[1]
				movedVertex[2] = vertex[2] + position[2] - camera[2]
				movedVertex[3] = vertex[3] + position[3] + camera[3]
			end				
		end
		mesh.position = position
		meshesToRender[#meshesToRender + 1] = mesh
	end		
	
	for idx, box in ipairs(object.boundingBoxes) do
		local movedBox = object.movedBoxes[idx]
		movedBox[1] = box[1] + position[1] - camera[1]
		movedBox[2] = box[2] + position[2] - camera[2]		
		movedBox[3] = box[3] + position[1] - camera[1]
		movedBox[4] = box[4] + position[2] - camera[2]
		movedBox[5] = box[5] + position[3] + camera[3]
	end
end

function ShearTestScene:translate3Dto2D()
	local meshesToRender = self.meshesToRender
	local camera = self.camera
	local orderedTriangles = self.orderedTriangles
	
	-- sort triangles	
	for _, mesh in ipairs(meshesToRender) do
		local pos = mesh.position
		for _, triangle in ipairs(mesh.triangles) do	
			local n = triangle.normal
			local middle = triangle.middle
			local mx = middle[1] + pos[1]
			local my = middle[2] + pos[2]
			local mz = middle[3] + pos[3]
			local lx = mx - camera[1]
			local ly = my - camera[2]
			local lz = mz + camera[3]			
			local dot = n[1] * lx + n[2] * ly + n[3] * lz		
			if dot > 0 then
				local dx = mx + camera[1]
				local dy = my + camera[2]
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
		
	local sw = self.screenWidth
	local sh = self.screenHeight
	local hsw = sw / 2
	local hsh = sh / 2	
	
	-- test triangle visibility
	for _, triangle in ipairs(orderedTriangles) do
		triangle.visible = false
		for i, vertex in ipairs(triangle.movedVertices) do
			local tx = (vertex[1] / vertex[3] * sw) + hsw
			local ty = (-vertex[2] / vertex[3] * sh) + hsh	
			triangle.vertices2D[i] = { tx, ty, vertex[4], vertex[5] }
		end

		for _, vertex in ipairs(triangle.vertices2D) do
			-- lazy way is to check that vertex is contained within bounding box that is bigger than screen
			if (vertex[1] >= -400 and vertex[1] <= sw + 400 and vertex[2] >= -400 and vertex[2] <= sh + 400) then
				triangle.mesh.object.rendered = true
				triangle.visible = true
				break
			end					
		end		
	end
end

function ShearTestScene:renderMeshes()
	local orderedTriangles = self.orderedTriangles

	-- render triangles
	local drawingMesh = self.drawingMesh
	for _, triangle in ipairs(orderedTriangles) do
		if triangle.visible then
			for i, vertex in ipairs(triangle.vertices2D) do
				drawingMesh:setVertex(i, vertex[1], vertex[2], vertex[3], vertex[4], 255, 255, 255, 255)
			end		
			drawingMesh:setTexture(triangle.texture)
			love.graphics.draw(drawingMesh, 0, 0)
		end
	end		
end

function ShearTestScene:createBoundingBoxes()
	local sw = self.screenWidth
	local sh = self.screenHeight
	local hsw = sw / 2
	local hsh = sh / 2	
	
	for _, object in ipairs(self.scene) do
		if object.rendered then
			for idx, box in ipairs(object.movedBoxes) do				
				local box2D = object.boundingBoxes2D[idx]
				local x1 = (box[1] / box[5] * sw) + hsw
				local y1 = (-box[2] / box[5] * sh) + hsh	
				local x2 = (box[3] / box[5] * sw) + hsw
				local y2 = (-box[4] / box[5] * sh) + hsh			
				box2D[1] = x1
				box2D[2] = y1
				box2D[3] = x2
				box2D[4] = y2			
			end
		end
	end
end

function ShearTestScene:clearScene()
	local scene = self.scene
	for i = 1, #scene do
		scene[i] = nil
	end
	
	local meshesToRender = self.meshesToRender
	for i = 1, #meshesToRender do
		meshesToRender[i] = nil
	end	
	
	local orderedTriangles = self.orderedTriangles	
	for i = 1, #orderedTriangles do
		orderedTriangles[i] = nil
	end
end

function ShearTestScene:drawBoundingBoxes()
	for _, object in ipairs(self.scene) do
		if object.rendered then
			for idx, box in ipairs(object.movedBoxes) do				
				local box2D = object.boundingBoxes2D[idx]
				love.graphics.rectangle('line',box2D[1], box2D[2], box2D[3] - box2D[1], box2D[4] - box2D[2])
			end
		end
	end
end

function ShearTestScene:renderHero()
	local hero = self.hero
	local camera = self.camera
	local position = hero.position
	local sw = self.screenWidth
	local sh = self.screenHeight
	local hsw = sw / 2
	local hsh = sh / 2	
		
	local x = position[1] - camera[1]
	local y = position[2] - camera[2]
	local z = position[3] + camera[3]
	
	local sx = (x / z * sw) + hsw
	local sy = (-y / z * sh) + hsh
	
	hero.position2D[1] = sx
	hero.position2D[2] = sy
	
	love.graphics.circle('fill', sx, sy, 10)
end

function ShearTestScene:draw()			
	Profiler:start('renderMeshes')
	
	self:renderMeshes()	

	Profiler:stop('renderMeshes')
	
	love.graphics.print('Time to add objects to secene: ' .. 
		Profiler:getAverage('addObjectsToScene'), 0, 15)
		
	love.graphics.print('Time to render meshes: ' .. 
		Profiler:getAverage('renderMeshes'), 0, 30)		
		
	love.graphics.print('Time to translate 3d to 2d: ' .. 
		Profiler:getAverage('translate3Dto2D'), 0, 45)					
		
	love.graphics.print('Time to create bounding boxes: ' .. 
		Profiler:getAverage('createBoundingBoxes'), 0, 60)			

	love.graphics.print('Time to check collisions: ' .. 
		Profiler:getAverage('checkCollisions'), 0, 75)				
		
	self:drawBoundingBoxes()
	
	self:renderHero()
end

function ShearTestScene:sqr(x) 
    return x * x 
end

function ShearTestScene:dist2(x1, y1, x2, y2)
    return self:sqr(x1 - x2) + self:sqr(y1 - y2)
end

function ShearTestScene:distToSegmentSquared(px, py, x1, y1, x2, y2)
	local l2 = self:dist2(x1, y1, x2, y2)
	
	if l2 == 0 then 
		return self:dist2(px, py, x1, y1)
	end
	
	local t = ((px - x1) * (x2 - x1) + (py - y1) * (y2 - y1)) / l2
    
	if t < 0 then
		return self:dist2(px, py, x1, y1)
	end
	if t > 1 then 
		return self:dist2(px, py, x2, y2)
	end
	
	local nx = x1 + t * (x2 - x1)
	local ny = y1 + t * (y2 - y1)
	
	return self:dist2(px, py, nx, ny)
end

function ShearTestScene:distToSegment(px, py, x1, y1, x2, y2)
    return math.sqrt(self:distToSegmentSquared(px, py, x1, y1, x2, y2))
end

function ShearTestScene:handleInput(dt)
	local camera = self.camera
	local hero = self.hero
	
	if love.keyboard.isDown('a') then
		hero.position[1] = hero.position[1] + dt * 5
	end
	if love.keyboard.isDown('d') then
		hero.position[1] = hero.position[1] - dt * 5
	end
	if love.keyboard.isDown('w') then
		hero.position[2] = hero.position[2] - dt * 5
	end
	if love.keyboard.isDown('s') then
		hero.position[2] = hero.position[2] + dt * 5
	end
	if love.keyboard.isDown('q') then
		camera[3] = camera[3] - dt * 5
	end
	if love.keyboard.isDown('e') then
		camera[3] = camera[3] + dt * 5
	end	
end

function ShearTestScene:checkCollisions(actor)
	local position = actor.position2D
	
	local d1, d2, d3, d4
	for _, object in ipairs(self.scene) do
		if object.rendered then
			for idx, box in ipairs(object.movedBoxes) do				
				local box2D = object.boundingBoxes2D[idx]
				d1 = self:distToSegment(position[1], position[2], box2D[1], box2D[2], box2D[1], box2D[4])		
				d2 = self:distToSegment(position[1], position[2], box2D[3], box2D[2], box2D[3], box2D[4])		
				d3 = self:distToSegment(position[1], position[2], box2D[1], box2D[2], box2D[3], box2D[2])		
				d4 = self:distToSegment(position[1], position[2], box2D[1], box2D[4], box2D[3], box2D[4])		
			end
		end
	end
	
	return math.min(d4, math.min(d3, math.min(d1, d2)))
end

function ShearTestScene:update(dt)	
	local hero = self.hero

	Profiler:start('addObjectsToScene')
		
	self:clearScene()	
	local buildingObjects = self.buildingObjects
	for _, bldg in ipairs(buildingObjects) do
		self:addObjectToScene(bldg)
	end	
	
	Profiler:stop('addObjectsToScene')
	
	Profiler:start('translate3Dto2D')
	
	self:translate3Dto2D()
	
	Profiler:stop('translate3Dto2D')
	
	Profiler:start('createBoundingBoxes')
	
	self:createBoundingBoxes()
	
	Profiler:stop('createBoundingBoxes')

	hero.oldPosition[1] = hero.position[1]
	hero.oldPosition[2] = hero.position[2]
	
	self:handleInput(dt)

	Profiler:start('checkCollisions')
	
	if self:checkCollisions(hero) then
		print('================================')
		print('old position: ' .. hero.oldPosition[1] .. ', ' .. hero.oldPosition[2])
		print('new position: ' .. hero.position[1] .. ', ' .. hero.position[2])
		print('================================')
	
		hero.position[1] = hero.oldPosition[1]
		hero.position[2] = hero.oldPosition[2]
	end
	
	Profiler:stop('checkCollisions')
	
	local camera = self.camera
	local hero = self.hero
		
	camera[1] = hero.position[1]
	camera[2] = hero.position[2]
end

return ShearTestScene