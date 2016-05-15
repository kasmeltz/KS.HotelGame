local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()
local DayNightCycle = require 'classes/simulation/DayNightCycle'

local Scene = require 'classes/scene/Scene'
local ShearTestScene = Scene:extend('ShearTestScene')

function ShearTestScene:loadBuildingTypes()
	local text, size = love.filesystem.read('data/buildingTypes.dat')
	local condition = assert(loadstring('return ' .. text))
	return condition()
end

function ShearTestScene:init(gameWorld)
	ShearTestScene.super.init(self, gameWorld)
	
	self.buildingTypes = self:loadBuildingTypes()
	
	local roofImages = {}
	roofImages[1] = love.graphics.newImage('data/images/roof.jpg')
	roofImages[2] = love.graphics.newImage('data/images/roof2.jpg')
	roofImages[3] = love.graphics.newImage('data/images/roof3.jpg')
	roofImages[4] = love.graphics.newImage('data/images/roof4.jpg')
	self.roofImages = roofImages
	
	local buildingImages = {}
	buildingImages[1] = love.graphics.newImage('data/images/building3.jpg')
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
	
	local light = 
	{
		direction = { 0, 0, -1 },
		ambient = { 0.0, 0.0, 0.0 },
		directional = { 0.0, 0.0, 0.0 },
		position = { 900, 300, 100 },
		positional = { 1, 1, 1 },		
	}
	self.light = light	
	self.dayNightCycle = DayNightCycle:new(self.gameWorld)
	self.lightMode = 'mine'

	local groundFloor = -5
	self.groundFloor = groundFloor
	
	local buildingObjects = {}	
	
	for i = 1, 500 do
		local t = love.math.random(1,#self.buildingTypes)
		--local t = 1
		local bo = 	self:createBuildingFromType(self.buildingTypes[t])
		--bo.position = { 0, -9, 0 }
		bo.position = { love.math.random(0,400) - 200, love.math.random(0,400) - 200, 0 }
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
		position = { 0, 0, groundFloor},
		movedPosition = {0, 0, groundFloor},
		oldPosition = {0, 0, groundFloor},
		position2D = {0, 0},		
	}	
	
	self.sceneBoundingBox = {}	
	self.sceneBoundingArea = 3
	self.sceneBoundingCameraFactor = 0.5


	self.drawDebug = true	
	
	collectgarbage()

	self:update(0.001)		
	
	self.roadShader = love.graphics.newShader(
[[
	extern vec3 lightPosition;
	extern vec3 lightPositional;
	extern vec3 lightDirection;
	extern vec3 lightAmbient;
	extern vec3 lightDirectional;

	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
	{	
		vec3 normal = vec3(0, 0, -1);
		vec3 normalLightDir = normalize(lightDirection);
		vec4 surfaceColor = Texel(texture, texture_coords);

		//ambient
		vec3 ambient = lightAmbient * surfaceColor.rgb;

		// directional
		number NdotL = max(dot(normal, normalLightDir), 0.0);
		vec3 diffuse = lightDirectional * NdotL * surfaceColor.rgb;
		
		// positional
		vec3 positionalColor = vec3(0,0,0);
		vec3 surfaceToLight = lightPosition - vec3(screen_coords, -5);	
		surfaceToLight /=  (love_ScreenSize.x / 4);
		number brightness =  (0.15 / pow(length(surfaceToLight), 2)) * NdotL;
		brightness = clamp(brightness, 0, 1);
		positionalColor = brightness * surfaceColor.rgb * lightPositional;
		
		//linear color (color before gamma correction)
		vec3 linearColor = ambient + diffuse + positionalColor;
		linearColor = clamp(linearColor, 0, 1);
		
		//final color (after gamma correction)
		vec3 gamma = vec3(1.0/2.2);
		return vec4(pow(linearColor, gamma), surfaceColor.a);
	}
]]
	)
	
	self.wallShader = love.graphics.newShader(
[[
	extern vec3 lightPosition;
	extern vec3 lightPositional;
	extern vec3 lightDirection;
	extern vec3 lightAmbient;
	extern vec3 lightDirectional;

	extern vec3 normal;
	extern vec2 v1;
	extern vec2 v2;
	extern vec2 v3;
	extern vec2 v4;
	extern number vz;
	
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
	{	
		vec3 normalLightDir = normalize(lightDirection);
		vec4 surfaceColor = vec4(0,0,0,255);
    
		if (v1.y == v3.y && v2.y == v4.y && v4.x == v3.x && v1.x == v2.x) {
			surfaceColor = Texel(texture, texture_coords);
		} else {
			// vertical
			if (v1.y == v3.y) {				
				number ty = (screen_coords.y - v1.y) / (v2.y - v1.y);

				number lx1 = v1.x * ( 1 - ((screen_coords.y - v1.y) / (v2.y - v1.y)) ) + v2.x * ( (screen_coords.y - v1.y) / (v2.y - v1.y) );
				number lx2 = v3.x * ( 1 - ((screen_coords.y - v3.y) / (v4.y - v3.y)) ) + v4.x * ( (screen_coords.y - v3.y) / (v4.y - v3.y) );
				number tx = (screen_coords.x - lx2) / (lx1 - lx2);								
				surfaceColor = Texel(texture, vec2(1 - tx, 1 - ty));
			} 
			// horizontal
			else {			
				number tx = (screen_coords.x - v1.x) / (v2.x - v1.x);							
				number ly1 = v1.y * ( 1 - ((screen_coords.x - v1.x) / (v2.x - v1.x)) ) + v2.y * ( (screen_coords.x - v1.x) / (v2.x - v1.x) );
				number ly2 = v3.y * ( 1 - ((screen_coords.x - v3.x) / (v4.x - v3.x)) ) + v4.y * ( (screen_coords.x - v3.x) / (v4.x - v3.x) );
				number ty = (screen_coords.y - ly2) / (ly1 - ly2);				
				surfaceColor = Texel(texture, vec2(1 - ty, 1 - tx));
			}				
		}
	
		//ambient
		vec3 ambient = lightAmbient * surfaceColor.rgb;

		// directional
		number NdotL = max(dot(normal, normalLightDir), 0.0);
		vec3 diffuse = lightDirectional * NdotL * surfaceColor.rgb;
		
		// positional
		vec3 positionalColor = vec3(0,0,0);
		vec3 surfaceToLight = lightPosition - vec3(screen_coords, vz);	
		surfaceToLight /=  (love_ScreenSize.x / 4);
		number brightness =  (0.15 / pow(length(surfaceToLight), 2)) * NdotL;
		brightness = clamp(brightness, 0, 1);
		positionalColor = brightness * surfaceColor.rgb * lightPositional;
		
		//linear color (color before gamma correction)
		vec3 linearColor = ambient + diffuse + positionalColor;
		linearColor = clamp(linearColor, 0, 1);
		
		//final color (after gamma correction)
		vec3 gamma = vec3(1.0/2.2);
		return vec4(pow(linearColor, gamma), surfaceColor.a);
	}
]]
	)
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
		order = 1,
		vertices = 
		{
			{ex, ey, z},
			{ex, sy, z},
			{sx, ey, z},
		}, 
		movedVertices =
		{
			{0, 0, 0},
			{0, 0, 0},
			{0, 0, 0},
		},
		normal = { 0, 0, -1 },
		uv = 
		{
			{1, 1},
			{1, 0}, 
			{0, 1},
		},		
		vertices2D = {{0,0}, {0,0}, {0,0}}
	}
	
	local t2 = 
	{
		order = 2,
		vertices = 
		{
			{ex, sy, z},
			{sx, sy, z},
			{sx, ey, z},
		}, 		
		movedVertices = 
		{
			{0, 0, 0},
			{0, 0, 0},
			{0, 0, 0},
		},
		normal = { 0, 0, -1 },
		uv = 
		{
			{1, 0},
			{0, 0}, 
			{0, 1},
		},		
		vertices2D = {{0,0}, {0,0}, {0,0}}
	}
	
	return t1, t2
end

function ShearTestScene:createWallSection(sx, ex, sy, ey, sz, ez, nx, ny)
	local t1 = 
	{
		order = 1,
		vertices = 
		{
			{sx, sy, ez},
			{sx, sy, sz},
			{ex, ey, ez},
		}, 
		movedVertices =
		{
			{0, 0, 0},
			{0, 0, 0},
			{0, 0, 0},
		},
		normal = { nx, ny, 0 },
		uv = 
		{
			{0, 1},
			{0, 0}, 
			{1, 1},
		},	
		vertices2D = {{0,0}, {0,0}, {0,0}}
	}
	local t2 = 
	{
		order = 2,
		vertices = 
		{
			{sx, sy, sz},
			{ex, ey, sz},
			{ex, ey, ez},
		}, 
		movedVertices =
		{
			{0, 0, 0},
			{0, 0, 0},
			{0, 0, 0},
		},
		normal = { nx, ny, 0 },
		uv = 
		{
			{0, 0},
			{1, 0}, 
			{1, 1},
		},	
		vertices2D = {{0,0}, {0,0}, {0,0}}
	}
	
	return t1, t2
end

function ShearTestScene:addWallSections(walls, sx, ex, sy, ey, sz, ez, ss, nx, ny)
	--for z = sz - ss, ez, -ss do
		--local t1, t2 = self:createWallSection(sx, ex, sy, ey, z + ss, z, nx, ny)
		local t1, t2 = self:createWallSection(sx, ex, sy, ey, sz, ez, nx, ny)		
		table.insert(walls.triangles, t1)
		t1.meshIndex = #walls.triangles
		table.insert(walls.triangles, t2)
		t2.meshIndex = #walls.triangles
	--end
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
				t1.meshIndex = #roof.triangles
				table.insert(roof.triangles, t2)						
				t2.meshIndex = #roof.triangles
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
	local sbx1 = sceneBoundingBox[1]
	local sby1 = sceneBoundingBox[2]
	local sbx2 = sceneBoundingBox[3]
	local sby2 = sceneBoundingBox[4]

	-- check if object should even be in scene
	local abox = object.aggregateBoundingBox
	local ax1 = abox[1] + position[1]
	local ay1 = abox[2] + position[2]
	local ax2 = abox[3] + position[1]
	local ay2 = abox[4] + position[2]
	
	-- check if object should appear in scene
	if 	ax1 >= sbx2 or
		ay1 >= sby2 or
		ax2 <= sbx1 or
		ay2 <= sby1 then			
			return
	end
		
	-- update mesh position
	for _, mesh in ipairs(object.meshes) do		
		mesh.object = object
		for _, triangle in ipairs(mesh.triangles) do
			triangle.mesh = mesh
			triangle.visible = false
			for idx, vertex in ipairs(triangle.vertices) do
				local movedVertex = triangle.movedVertices[idx]
				movedVertex[1] = vertex[1] + position[1]
				movedVertex[2] = vertex[2] + position[2]
				movedVertex[3] = vertex[3] + position[3]
				
				-- check if mesh should appear in scene
				if movedVertex[1] >= sbx1 and
					movedVertex[1] <= sbx2 and
					movedVertex[2] >= sby1 and
					movedVertex[2] <= sby2 then
						triangle.visible = true
				end
			end
		end
		mesh.position = position
		meshesToRender[#meshesToRender + 1] = mesh
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
				if triangle.visible then
					for idx, vertex in ipairs(triangle.vertices) do
						local movedVertex = triangle.movedVertices[idx]
						movedVertex[1] = movedVertex[1] - camera[1]
						movedVertex[2] = movedVertex[2] - camera[2]
						movedVertex[3] = movedVertex[3] - camera[3]
					end
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
			if triangle.visible then
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
	self.dayNightCycle:update(dt)
	
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

	if not self.drawDebug then
		Profiler:start('Check Collisions')		
		local dist = self:findClosestBoundingBox(hero)
		if dist < 0.1 then
			hero.position[1] = hero.oldPosition[1]
			hero.position[2] = hero.oldPosition[2]
			hero.position[1] = hero.oldPosition[1]
			hero.position[2] = hero.oldPosition[2]
		end	
		Profiler:stop('Check Collisions')	
	end
	
	camera[1] = hero.position[1]
	camera[2] = hero.position[2]			
	
	Profiler:start('Translate 3D to 2D')	
	
	self:translate3Dto2D()	
	
	Profiler:stop('Translate 3D to 2D')
end

function ShearTestScene:renderTriangles()
	local orderedTriangles = self.orderedTriangles
	
	local wallShader = self.wallShader
	love.graphics.setShader(wallShader)
	
	local light = self.light
	if self.lightMode ~= 'mine' then		
		light = self.dayNightCycle.light
	end
	wallShader:send('lightDirection',light.direction)
	wallShader:send('lightAmbient', light.ambient)
	wallShader:send('lightDirectional', light.directional)
	wallShader:send('lightPosition', light.position)
	wallShader:send('lightPositional', light.positional)
	
	-- render triangles
	love.graphics.setLineWidth(2)
	local drawingMesh = self.drawingMesh
	for idx, triangle in ipairs(orderedTriangles) do
		local mesh = triangle.mesh
		if triangle.visible then
			for i, vertex in ipairs(triangle.vertices2D) do
				drawingMesh:setVertex(i, vertex[1], vertex[2], triangle.uv[i][1], triangle.uv[i][2], 255, 255, 255, 255)
			end		
			drawingMesh:setTexture(triangle.texture)			
			
			local mesh = triangle.mesh

			local sidx = triangle.meshIndex
			if triangle.order == 2 then
				sidx = sidx - 1
			end
			
			local t1 = mesh.triangles[sidx]
			local t2 = mesh.triangles[sidx + 1]
			
			local v1 = t1.vertices2D[1]
			local v2 = t1.vertices2D[2]
			local v3 = t1.vertices2D[3]
			local v4 = t2.vertices2D[2]
			
			if v1 and v2 and v3 and v4 then				
				local vz = (t1.movedVertices[1][3] + 
							t1.movedVertices[2][3] + 
							t1.movedVertices[3][3] + 
							t2.movedVertices[2][3]) / 4
							
				wallShader:send('normal', triangle.normal)
				wallShader:send('v1', v1)
				wallShader:send('v2', v2)
				wallShader:send('v3', v3)
				wallShader:send('v4', v4)
				wallShader:send('vz', vz)
				love.graphics.draw(drawingMesh, 0, 0)
			end
		end
	end
	love.graphics.setShader()
			
	if self.drawDebug then
		love.graphics.setFont(FontManager:getFont('Courier16'))
		for idx, triangle in ipairs(orderedTriangles) do
			local mesh = triangle.mesh
			if triangle.visible then					
				local x1 = triangle.vertices2D[1][1]
				local y1 = triangle.vertices2D[1][2]
				local x2 = triangle.vertices2D[2][1]
				local y2 = triangle.vertices2D[2][2]
				local x3 = triangle.vertices2D[3][1]
				local y3 = triangle.vertices2D[3][2]
				local mx = (x1 + x2 + x3) / 3
				local my = (y1 + y2 + y3) / 3				
				
				love.graphics.setColor(255,255,0)
				love.graphics.polygon('line', 
					x1, y1, x2, y2, x3, y3)
		
				love.graphics.setColor(0, 255, 255)									
				love.graphics.print('1', (x1 + mx)/ 2, (y1 + my) / 2)
				love.graphics.print('2', (x2 + mx)/ 2, (y2 + my) / 2)
				love.graphics.print('3', (x3 + mx)/ 2, (y3 + my) / 2)
				
				love.graphics.setColor(255,255,255)
				love.graphics.print(idx .. ': ' .. triangle.order, mx, my)
					
				love.graphics.setColor(255,255,255)
			end
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
		
	local ssx = (-sw / z)
	local ssy = (-sh / z)
	
	local sx = (x / z * sw) - (hsw)
	local sy = (-y / z * sh) - (hsh)
	
	local tx = math.floor(sx / ssx)
	local ty = math.floor(sy / ssy)	
	local ox = sx % ssx
	local oy = sy % ssy
	
	local roadImg = self.roadImages[1]
	local sidewalkImg = self.sideWalkImages[1]

	local zx = ssx / 64
	local zy = ssy / 64

	local roadShader = self.roadShader
	love.graphics.setShader(roadShader)
	
	local light = self.light
	local light = self.light
	if self.lightMode ~= 'mine' then		
		light = self.dayNightCycle.light
	end	
		
	roadShader:send('lightDirection',light.direction)
	roadShader:send('lightAmbient', light.ambient)
	roadShader:send('lightDirectional', light.directional)
	roadShader:send('lightPosition', light.position)
	roadShader:send('lightPositional', light.positional)
	
	local cy = ty	
	for y = -oy, 900, ssy do
		local cx = tx
		for x = -ox, 1200, ssx do					
			if cx == 10 then
				love.graphics.draw(roadImg, x, y, 0, zx, zy)
			else
				love.graphics.draw(sidewalkImg, x, y, 0, zx, zy)
			end
			if self.drawDebug then
				love.graphics.rectangle('line', x, y, ssx, ssy)
			end
			cx = cx + 1
		end
		cy = cy + 1
	end
	
	love.graphics.setShader()
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
	
	if self.drawDebug then
		self:createBoundingBoxes2D()	
		self:drawBoundingBoxes()
	end
	
	Profiler:stop('Render Bounding Boxes')	

	if self.drawDebug then 	
		love.graphics.setColor(0, 0, 0, 128)
		love.graphics.rectangle('fill', 0,0, 300, 150)
		love.graphics.setColor(255, 255, 0, 255)
		local sy = 30
		
		love.graphics.print('light position: ' .. 
			self.light.position[1] .. ', ' .. 
			self.light.position[2] .. ', ' .. 
			self.light.position[3], 0, sy)
				
		sy = sy + 15	
		
		love.graphics.print('light direction: ' .. 
			self.light.direction[1] .. ', ' .. 
			self.light.direction[2] .. ', ' .. 
			self.light.direction[3], 0, sy)
				
		sy = sy + 15	
		
		love.graphics.print('light ambient: ' .. 
			self.light.ambient[1] .. ', ' .. 
			self.light.ambient[2] .. ', ' .. 
			self.light.ambient[3], 0, sy)
				
		sy = sy + 15	
		
		love.graphics.print('light directional: ' .. 
			self.light.directional[1] .. ', ' .. 
			self.light.directional[2] .. ', ' .. 
			self.light.directional[3], 0, sy)
			
		sy = sy + 15	
		
		love.graphics.print('light positional: ' .. 
			self.light.positional[1] .. ', ' .. 
			self.light.positional[2] .. ', ' .. 
			self.light.positional[3], 0, sy)	

		sy = sy + 15			
		
		local gt = self.gameWorld.gameTime
		
		love.graphics.print('speed: ' ..  gt.speedTexts[gt.currentSpeed], 0, sy)	
					
		--[[
		sy = sy + 15
		sy = sy + 15
		
		love.graphics.print(
			'hx: '.. 
			self.hero.position[1] .. 
			' hy: ' .. 
			self.hero.position[2], 
			0, sy)
			
		sy = sy + 15		
		sy = sy + 15
		
		love.graphics.print('triangles rendered: ' .. #self.orderedTriangles, 0, sy)
				
		sy = sy + 15	
		sy = sy + 15
			
		love.graphics.print('camera Z: '.. self.camera[3], 0, sy)	
		sy = sy + 15
		sy = sy + 15	
		
		love.graphics.print('memory: ' .. collectgarbage('count')*1024, 0, sy)
		sy = sy + 15
		sy = sy + 15		
			
		table.sort(Profiler.list, function(a, b) return a.average > b.average end)	
		for name, item in ipairs(Profiler.list) do	
			love.graphics.print(item.name, 0, sy)
			sy = sy + 15
			love.graphics.print(item.average, 0, sy)
			sy = sy + 15
		end	
	]]
	end
end

function ShearTestScene:keyreleased(key)
	if key == '1' then
		self.light.ambient[1] = self.light.ambient[1] - 0.005
		self.light.ambient[2] = self.light.ambient[2] - 0.005
		self.light.ambient[3] = self.light.ambient[3] - 0.005
	end	
	
	if key == '2' then
		self.light.ambient[1] = self.light.ambient[1] + 0.005
		self.light.ambient[2] = self.light.ambient[2] + 0.005
		self.light.ambient[3] = self.light.ambient[3] + 0.005
	end	

	if key == '3' then
		self.light.directional[1] = self.light.directional[1] - 0.005
		self.light.directional[2] = self.light.directional[2] - 0.005
		self.light.directional[3] = self.light.directional[3] - 0.005
	end	

	if key == '4' then
		self.light.directional[1] = self.light.directional[1] + 0.005
		self.light.directional[2] = self.light.directional[2] + 0.005
		self.light.directional[3] = self.light.directional[3] + 0.005
	end	
	
	if key == '5' then
		self.light.positional[1] = self.light.positional[1] - 0.005
		self.light.positional[2] = self.light.positional[2] - 0.005
		self.light.positional[3] = self.light.positional[3] - 0.005
	end	

	if key == '6' then
		self.light.positional[1] = self.light.positional[1] + 0.005
		self.light.positional[2] = self.light.positional[2] + 0.005
		self.light.positional[3] = self.light.positional[3] + 0.005
	end	

	if key == 'k' then
		self.light.direction[1] = self.light.direction[1] - 0.01
	end	
	
	if key == 'n' then
		self.light.direction[1] = self.light.direction[1] + 0.01
	end	
	
	if key == 'o' then
		self.light.direction[2] = self.light.direction[2] - 0.01
	end	
	
	if key == 'l' then
		self.light.direction[2] = self.light.direction[2] + 0.01
	end	
	
	if key == 'i' then
		self.light.direction[3] = self.light.direction[3] - 0.01
	end	
	
	if key == 'p' then
		self.light.direction[3] = self.light.direction[3] + 0.01
	end	
	
	if key == 'kp4' then
		self.light.position[1] = self.light.position[1] - 10
	end	
	
	if key == 'kp6' then
		self.light.position[1] = self.light.position[1] + 10
	end	
	
	if key == 'kp8' then
		self.light.position[2] = self.light.position[2] - 10
	end	

	if key == 'kp2' then
		self.light.position[2] = self.light.position[2] + 10
	end		

	if key == 'kp7' then
		self.light.position[3] = self.light.position[3] - 10
	end	

	if key == 'kp9' then
		self.light.position[3] = self.light.position[3] + 10
	end
	
	if key == 'f1' then
		self.lightMode = 'mine'
	end

	if key == 'f2' then
		self.lightMode = 'daynight'
	end
	
	if key == 'f9' then
		self.drawDebug = not self.drawDebug
	end
	
	if key == '8' then
		local gt = self.gameWorld.gameTime
		local sp = gt.currentSpeed
		sp = sp - 1
		if sp > 0 then		
			gt:setSpeed(sp)
		end
	end
	
	if key == '9' then
		local gt = self.gameWorld.gameTime
		local sp = gt.currentSpeed
		sp = sp + 1
		if sp <= #gt.speeds then		
			gt:setSpeed(sp)
		end
	end
end

return ShearTestScene

