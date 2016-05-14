local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

local Scene = require 'classes/scene/Scene'
local ShearTestScene = Scene:extend('ShearTestScene')

function ShearTestScene:loadBuildingTypes()
	local text, size = love.filesystem.read('data/buildingTypes.dat')
	local condition = assert(loadstring('return ' .. text))
	return condition()
end

function ShearTestScene:init()
	ShearTestScene.super.init(self)
	
	self.buildingTypes = self:loadBuildingTypes()
	
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
	
	local roadImages = {}
	roadImages[1] = love.graphics.newImage('data/images/road1.jpg')
	self.roadImages = roadImages
	
	local sideWalkImages = {}
	sideWalkImages[1] = love.graphics.newImage('data/images/sidewalk.jpg')
	self.sideWalkImages = sideWalkImages
	
	local drawingMesh = love.graphics.newMesh(3, 'triangles', 'dynamic')
	self.drawingMesh = drawingMesh		
	
	local camera = {0, 0, 5}
	self.camera = camera

	local groundFloor = -5
	self.groundFloor = groundFloor
	
	local buildingObjects = {}	
	
	for i = 1, 500 do
		local t = math.random(1,4)
		local bo = 	self:createBuildingFromType(self.buildingTypes[t])
		bo.position = { math.random(0,400) - 200, math.random(0,400) - 200, 0 }
		buildingObjects[#buildingObjects + 1] = bo
	end
		
	self.buildingObjects = buildingObjects
		
	self.actordToRender = {}
	self.meshesToRender = {}
	self.scene = 
	{
		objects = {},
		actors = {}
	}
	self.orderedTriangles = {}
	
	self.hero = 
	{
		position = { 0, -5, groundFloor},
		movedPosition = {0, 0, groundFloor},
		oldPosition = {0, 0, groundFloor},
		position2D = {0, 0},		
	}	
	
	self.sceneBoundingBox = {}	
	self.sceneBoundingArea = 3
	self.sceneBoundingCameraFactor = 0.5
	
	self.cameraZoomTop = 5
	self.cameraZoomBottom = 1
	
	collectgarbage()
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
			{ex, ey, z, 1, 1},
			{ex, sy, z, 1, 0},
			{sx, ey, z, 0, 1}
		}, 
		movedVertices =
		{
			{0, 0, 0, 1, 1},
			{0, 0, 0, 1, 0},
			{0, 0, 0, 0, 1},
		},
		normal = { 0, 0, -1 },
		vertices2D = {{0,0}, {0,0}, {0,0}}
	}
	
	local t2 = 
	{
		vertices = 
		{
			{ex, sy, z, 1, 0},
			{sx, sy, z, 0, 0},
			{sx, ey, z, 0, 1}
		}, 		
		movedVertices = 
		{
			{0, 0, 0, 1, 0},
			{0, 0, 0, 0, 0},
			{0, 0, 0, 0, 1},
		},
		normal = { 0, 0, -1 },
		vertices2D = {{0,0}, {0,0}, {0,0}}
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
		vertices2D = {{0,0}, {0,0}, {0,0}}
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
		vertices2D = {{0,0}, {0,0}, {0,0}}
	}
	
	return t1, t2
end

function ShearTestScene:addWallSections(walls, sx, ex, sy, ey, sz, ez, ss, nx, ny)
	for z = sz - ss, ez, -ss do
		local t1, t2 = self:createWallSection(sx, ex, sy, ey, z + ss, z, nx, ny)
		table.insert(walls.triangles, t1)
		table.insert(walls.triangles, t2)
		local t1, t2 = self:createWallSection(sx, ex, sy, ey, z + ss, z, nx, ny)
		table.insert(walls.triangles, t1)
		table.insert(walls.triangles, t2)
	end
end

function ShearTestScene:createBuildingFromType(buildingType)
	local building = {}
	building.meshes = {}
	building.aggregateBoundingBox = { 999, 999, -999, -999 }
	building.boundingBoxes = {}
	building.movedBoxes = {}
	building.boundingBoxes2D = {}
	
	local groundFloor = self.groundFloor
	local height = math.random(buildingType.heights[1], buildingType.heights[2])	
	local roofHeight = groundFloor + height
	local design = buildingType.design
	
	local walls =
	{
		texture = self.buildingImages[1],
		triangles = {}
	}
	
	local roof = 
	{
		texture = self.roofImages[1],
		triangles = {}
	}
	
	local dh = #design
	local dw = #design[1]	
	local ss = 1
	
	local cy = -(dh / 2)	
	for dy = 1, dh do
		local text = design[dy]
		local cx = (dw / 2)
		for dx = 1, dw do
			local c = text:sub(dx,dx)
			if c == 'R'then
				self:addWallSections(walls, cx - ss, cx - ss, cy, cy + ss, roofHeight, groundFloor, 1, 1, 0)
			elseif c == 'L' then	
				self:addWallSections(walls, cx, cx, cy, cy + ss, roofHeight, groundFloor, 1, -1, 0)
			elseif c == 'T' then				
				self:addWallSections(walls, cx, cx - ss, cy, cy, roofHeight, groundFloor, 1, 0, 1)				
			elseif c == 'B' then				
				self:addWallSections(walls, cx, cx - ss, cy + ss, cy + ss, roofHeight, groundFloor, 1, 0, -1)
			elseif c == 'A' then
				self:addWallSections(walls, cx, cx, cy, cy + ss, roofHeight, groundFloor, 1, -1, 0)
				self:addWallSections(walls, cx, cx - ss, cy, cy, roofHeight, groundFloor, 1, 0, 1)
			elseif c == 'C' then
				self:addWallSections(walls, cx, cx, cy, cy + ss, roofHeight, groundFloor, 1, -1, 0)
				self:addWallSections(walls, cx, cx - ss, cy + ss, cy + ss, roofHeight, groundFloor, 1, 0, -1)			
			elseif c == 'W' then	
				self:addWallSections(walls, cx - ss, cx - ss, cy, cy + ss, roofHeight, groundFloor, 1, 1, 0)
				self:addWallSections(walls, cx, cx - ss, cy, cy, roofHeight, groundFloor, 1, 0, 1)
			elseif c == 'D' then	
				self:addWallSections(walls, cx - ss, cx - ss, cy, cy + ss, roofHeight, groundFloor, 1, 1, 0)
				self:addWallSections(walls, cx, cx - ss, cy + ss, cy + ss, roofHeight, groundFloor, 1, 0, -1)				
			end
			
			if c ~= 'Z'then
				-- one roof zection must be on top of every wall
				local t1, t2 = self:createRoofSection(cx, cx - ss, cy, cy + ss, roofHeight)
				table.insert(roof.triangles, t1)
				table.insert(roof.triangles, t2)						
				-- insert bounding boxes to match the structure
				local box = { cx - ss, cy, cx, cy + ss, groundFloor }
				table.insert(building.boundingBoxes, box)
				table.insert(building.movedBoxes,{0,0,0,0,0,0})
				table.insert(building.boundingBoxes2D,{0,0,0,0})	
				local abox = building.aggregateBoundingBox
				if box[1] < abox[1] then abox[1] = box[1] end
				if box[2] < abox[2] then abox[2] = box[2] end
				if box[3] > abox[3] then abox[3] = box[3] end
				if box[4] > abox[4] then abox[4] = box[4] end
			end
			
			cx = cx - ss
		end
		cy = cy + ss
	end	
	
	table.insert(building.meshes, walls)		
	table.insert(building.meshes, roof)			

	for _, mesh in ipairs(building.meshes) do
		self:findMiddle(mesh)
	end
	
	return building
end

function ShearTestScene:addObjectToScene(object)
	local meshesToRender = self.meshesToRender
	local position = object.position
	local sceneBoundingBox = self.sceneBoundingBox 

	-- check if object should even be in scene
	local abox = object.aggregateBoundingBox
	local ax1 = abox[1] + position[1]
	local ay1 = abox[2] + position[2]
	local ax2 = abox[3] + position[1]
	local ay2 = abox[4] + position[2]
	
	-- check if object should appear in scene
	if 	ax1 >= sceneBoundingBox[3] or
		ay1 >= sceneBoundingBox[4] or
		ax2 <= sceneBoundingBox[1] or
		ay2 <= sceneBoundingBox[2] then			
			return
	end
	
	-- update bounding boxes
	for idx, box in ipairs(object.boundingBoxes) do
		local movedBox = object.movedBoxes[idx]
		movedBox[1] = box[1] + position[1]
		movedBox[2] = box[2] + position[2]
		movedBox[3] = box[3] + position[1]
		movedBox[4] = box[4] + position[2]
		movedBox[5] = box[5] + position[3]			
	end
		
	-- update mesh position
	for _, mesh in ipairs(object.meshes) do		
		mesh.object = object
		for _, triangle in ipairs(mesh.triangles) do
			triangle.mesh = mesh
			for idx, vertex in ipairs(triangle.vertices) do
				local movedVertex = triangle.movedVertices[idx]
				movedVertex[1] = vertex[1] + position[1]
				movedVertex[2] = vertex[2] + position[2]
				movedVertex[3] = vertex[3] + position[3]
			end				
		end
		mesh.position = position
		meshesToRender[#meshesToRender + 1] = mesh
	end			
	
	local scene = self.scene
	table.insert(scene.objects, object)		
end

function ShearTestScene:addActorToScene(actor)
	local scene = self.scene
	table.insert(scene.actors, actor)	
end

function ShearTestScene:translate3Dto2D()
	local meshesToRender = self.meshesToRender
	local camera = self.camera
	local orderedTriangles = self.orderedTriangles
	
	local scene = self.scene
	
	Profiler:start('Update Objects To Camera')	
	
	-- update objects according to camera
	for _, object in ipairs(scene.objects) do
		for _, mesh in ipairs(object.meshes) do		
			for _, triangle in ipairs(mesh.triangles) do
				for idx, vertex in ipairs(triangle.vertices) do
					local movedVertex = triangle.movedVertices[idx]
					movedVertex[1] = movedVertex[1] - camera[1]
					movedVertex[2] = movedVertex[2] - camera[2]
					movedVertex[3] = movedVertex[3] - camera[3]
				end				
			end
		end		
		
		for idx, box in ipairs(object.boundingBoxes) do
			local movedBox = object.movedBoxes[idx]
			movedBox[1] = movedBox[1] - camera[1]
			movedBox[2] = movedBox[2] - camera[2]		
			movedBox[3] = movedBox[3] - camera[1]
			movedBox[4] = movedBox[4] - camera[2]
			movedBox[5] = movedBox[5] - camera[3]
		end	
	end
	
	Profiler:stop('Update Objects To Camera')
	
	Profiler:start('Calculate Triangle Distance')		
			
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
			local lz = mz - camera[3]			
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
	
	Profiler:stop('Calculate Triangle Distance')		
	
	Profiler:start('Sort Triangles')		
		
	table.sort(orderedTriangles, 
		function(a,b) 
			return a.distanceToCamera > b.distanceToCamera 
		end)
		
	Profiler:stop('Sort Triangles')		
		
	Profiler:start('Calculate 2D Points for Triangles')
	
	local sw = self.screenWidth
	local sh = self.screenHeight
	local hsw = sw / 2
	local hsh = sh / 2	
	
	-- created 2D points for meshes and test triangle visibility
	for _, triangle in ipairs(orderedTriangles) do
		triangle.visible = false
		for i, vertex in ipairs(triangle.movedVertices) do
			local tx = (vertex[1] / vertex[3] * sw) + hsw
			local ty = (-vertex[2] / vertex[3] * sh) + hsh	
			triangle.vertices2D[i][1] = tx
			triangle.vertices2D[i][2] = ty
			triangle.vertices2D[i][3] = vertex[4]
			triangle.vertices2D[i][4] = vertex[5]
		end

		for _, vertex in ipairs(triangle.vertices2D) do
			-- lazy way is to check that vertex is contained within bounding box that is bigger than screen
			if (vertex[1] >= -400 and vertex[1] <= sw + 400 and vertex[2] >= -400 and vertex[2] <= sh + 400) then
				triangle.visible = true
				break
			end					
		end		
	end
	
	Profiler:stop('Calculate 2D Points for Triangles')
	
	Profiler:start('Update Actors To Camera')
	
	-- update actors according to camera
	for _, actor in ipairs(scene.actors) do
		actor.movedPosition[1] = actor.position[1] - camera[1]
		actor.movedPosition[2] = actor.position[2] - camera[2]
		actor.movedPosition[3] = actor.position[3] - camera[3]
	end
	
	Profiler:stop('Update Actors To Camera')
	
	Profiler:start('Calculate 2D Points for Actors')
	
	-- create 2D points for actors
	for _, actor in ipairs(scene.actors) do
		local x = actor.movedPosition[1]
		local y = actor.movedPosition[2]
		local z = actor.movedPosition[3]
		actor.position2D[1] = (x / z * sw) + hsw
		actor.position2D[2] = (-y / z * sh) + hsh
	end
	
	Profiler:stop('Calculate 2D Points for Actors')
end

function ShearTestScene:createBoundingBoxes2D()
	local sw = self.screenWidth
	local sh = self.screenHeight
	local hsw = sw / 2
	local hsh = sh / 2	
	
	for _, object in ipairs(self.scene.objects) do
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

function ShearTestScene:clearScene()
	local scene = self.scene
	for i = 1, #scene.actors do
		scene.actors[i] = nil
	end

	for i = 1, #scene.objects do
		scene.objects[i] = nil
	end
	
	local meshesToRender = self.meshesToRender
	for i = 1, #meshesToRender do
		meshesToRender[i] = nil
	end	
	
	local orderedTriangles = self.orderedTriangles	
	for i = 1, #orderedTriangles do
		orderedTriangles[i] = nil
	end
	
	local camera = self.camera
	local sceneBoundingBox = self.sceneBoundingBox 
	
	local area = self.sceneBoundingArea + (camera[3] * self.sceneBoundingCameraFactor)
	
	sceneBoundingBox[1] = camera[1] -area
	sceneBoundingBox[2] = camera[2] -area
	sceneBoundingBox[3] = camera[1] +area
	sceneBoundingBox[4] = camera[2] +area
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

function ShearTestScene:findClosestBoundingBox(actor)
	local position = actor.position
	
	local d1, d2, d3, d4 = 999, 999, 999, 999
	for _, object in ipairs(self.scene.objects) do
		for idx, box in ipairs(object.movedBoxes) do				
			local box = object.movedBoxes[idx]
			d1 = math.min(d1, self:distToSegment(position[1], position[2], box[1], box[2], box[1], box[4]))
			d2 = math.min(d2, self:distToSegment(position[1], position[2], box[3], box[2], box[3], box[4]))
			d3 = math.min(d3, self:distToSegment(position[1], position[2], box[1], box[2], box[3], box[2]))
			d4 = math.min(d4, self:distToSegment(position[1], position[2], box[1], box[4], box[3], box[4]))
		end
	end
	
	return math.min(d4, math.min(d3, math.min(d1, d2)))
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
		camera[3] = camera[3] - dt * 10
	end
	if love.keyboard.isDown('e') then
		camera[3] = camera[3] + dt * 10
	end	
end

function ShearTestScene:update(dt)	
	local camera = self.camera
	local hero = self.hero
	
	hero.oldPosition[1] = hero.position[1]
	hero.oldPosition[2] = hero.position[2]		

	Profiler:start('Handle Input')	
	
	self:handleInput(dt)	
	
	Profiler:stop('Handle Input')	
	
	Profiler:start('Add Objects To Scene')	
	
	self:clearScene()
	local buildingObjects = self.buildingObjects
	for _, bldg in ipairs(buildingObjects) do
		self:addObjectToScene(bldg)
	end		
	self:addActorToScene(hero)
	
	Profiler:stop('Add Objects To Scene')
		
	Profiler:start('Check Collisions')	
	
	local dist = self:findClosestBoundingBox(hero)
	if dist < 0.1 then
		hero.position[1] = hero.oldPosition[1]
		hero.position[2] = hero.oldPosition[2]
		hero.position[1] = hero.oldPosition[1]
		hero.position[2] = hero.oldPosition[2]
	end	

	Profiler:stop('Check Collisions')	
	
	camera[1] = hero.position[1]
	camera[2] = hero.position[2]			
	
	Profiler:start('Translate 3D to 2D')	
	
	self:translate3Dto2D()	
	
	Profiler:stop('Translate 3D to 2D')
end


function ShearTestScene:renderTriangles()
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

function ShearTestScene:drawBoundingBoxes()
	for _, object in ipairs(self.scene.objects) do
		for idx, box in ipairs(object.movedBoxes) do				
			local box2D = object.boundingBoxes2D[idx]
			love.graphics.rectangle(
				'line',
				box2D[1], 
				box2D[2], 
				box2D[3] - box2D[1], 
				box2D[4] - box2D[2])
		end
	end
end

function ShearTestScene:drawRoad()
	local camera = self.camera
	local sw = self.screenWidth
	local sh = self.screenHeight
	local hsw = sw / 2
	local hsh = sh / 2	
		
	local x = camera[1]
	local y = camera[2]
	local z = self.groundFloor - camera[3] 
		
	local ss = -sw / z
	local zf = ss / 64
	
	local sx = (x / z * sw) + hsw
	local sy = (-y / z * sh) + hsh
	local tx = math.floor(sx / ss)
	local ty = math.floor(sx / ss)	
	local ox = sx % ss
	local oy = sy % ss
	
	--print(sx, sy, tx, ty, ox, oy)
	
	local roadImg = self.roadImages[1]
	local sidewalkImg = self.sideWalkImages[1]
	
	local cy = ty	
	for y = -oy, 900, ss do
		local cx = tx
		for x = -ox, 1200, ss do		
			if cx == 10 then
				love.graphics.draw(roadImg, x, y, 0, zf)
			else
				love.graphics.draw(sidewalkImg, x, y, 0, zf)
			end
			cx = cx + 1
		end
		cy = cy + 1
	end
end

function ShearTestScene:renderHero()
	local hero = self.hero		
	love.graphics.circle('fill', hero.position2D[1], hero.position2D[2], 10)
end

function ShearTestScene:draw()
	Profiler:start('Render Road')	
	
	self:drawRoad()		
	
	Profiler:stop('Render Road')
	
	Profiler:start('Render Hero')	
	
	self:renderHero()
	
	Profiler:stop('Render Hero')	

	Profiler:start('Render Triangles')
	
	self:renderTriangles()	
	
	Profiler:stop('Render Triangles')
		
	Profiler:start('Render Bounding Boxes')	
	
	--self:createBoundingBoxes2D()	
	--self:drawBoundingBoxes()
	
	Profiler:stop('Render Bounding Boxes')	

	local sy = 15
	love.graphics.print(
		'hx: '.. 
		self.hero.position[1] .. 
		' hy: ' .. 
		self.hero.position[2], 
		0, sy)
	
	sy = sy + 15		
	sy = sy + 15
	love.graphics.print('sceneBoundingBox: ['.. 
		self.sceneBoundingBox[1] .. ', ' ..
		self.sceneBoundingBox[2] .. ', ' ..
		self.sceneBoundingBox[3] .. ', ' ..
		self.sceneBoundingBox[4] .. ']'
			, 0, sy)
			
	sy = sy + 15	
	love.graphics.print('sceneBoundingArea: '.. self.sceneBoundingArea, 0, sy)
	sy = sy + 15	
	love.graphics.print('sceneBoundingCameraFactor: ' .. self.sceneBoundingCameraFactor, 0, sy)
	sy = sy + 15	
	love.graphics.print('camera Z: '.. self.camera[3], 0, sy)	
	sy = sy + 15
	sy = sy + 15	
	
	love.graphics.print('cameraZoomTop: '.. self.cameraZoomTop, 0, sy)
	sy = sy + 15	
	love.graphics.print('cameraZoomBottom: ' .. self.cameraZoomBottom, 0, sy)
	sy = sy + 15
	sy = sy + 15		

	love.graphics.print('memory: ' .. collectgarbage('count')*1024, 0, sy)
	sy = sy + 15
	sy = sy + 15		
		
	table.sort(Profiler.list, function(a, b) return a.average > b.average end)	
	for name, item in ipairs(Profiler.list) do	
		love.graphics.print(item. name .. ': ' .. item.average, 0, sy)
		sy = sy + 15
	end	
end

function ShearTestScene:keyreleased(key)
	if key == '1' then
		self.sceneBoundingArea = self.sceneBoundingArea - 0.5
	end	

	if key == '2' then
		self.sceneBoundingArea = self.sceneBoundingArea + 0.5
	end	
	
	if key == '3' then
		self.sceneBoundingCameraFactor = self.sceneBoundingCameraFactor - 0.1
	end	

	if key == '4' then
		self.sceneBoundingCameraFactor = self.sceneBoundingCameraFactor + 0.1
	end		

	if key == '5' then
		self.cameraZoomTop = self.cameraZoomTop + 0.1
	end		

	if key == '6' then
		self.cameraZoomTop = self.cameraZoomTop - 0.1
	end		

	if key == '7' then
		self.cameraZoomBottom = self.cameraZoomBottom + 0.1
	end		

	if key == '8' then
		self.cameraZoomBottom = self.cameraZoomBottom - 0.1
	end		

end

return ShearTestScene