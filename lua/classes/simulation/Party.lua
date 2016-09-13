local SimulationItem = require 'classes/simulation/SimulationItem'
local Party = SimulationItem:extend('Party')

Party.CASTLE_DISTANCE = 0.002

-- heroes
-- gold
-- current location

function Party:init(gameWorld)
	Party.super.init(self, gameWorld)
	
	self.heroes = {}
	self.destination = nil
	self.walkingSpeed = 0.000002
	--self.walkingSpeed = 0.0002
	self.visited = {}	
end

function Party:addHero(hero)
	table.insert(self.heroes, hero)
end

function Party:removeHero(idx)
	table.remove(self.heroes, idx)
end

function Party:walking(w)
	if w == nil
		then return self.isWalking
	else
		self.isWalking = w 
	end
end

function Party:setLocation(location)
	self.currentLocation = location	
	location:discovered(true)	
	local fn = location:fullName()
	if not self.visited[fn] then
		self.visited[fn] = true
		
		if self.onVisitedNewLocation then		
			self.onVisitedNewLocation(location)
		end
	else
		if self.onVisitedLocation then
			self.onVisitedLocation(location)
		end
	end
end

function Party:setDestination(destination)
	self.destination = destination
	
	if destination then
		local dx = destination.cartesianX - self.cartesianX 
		local dy = destination.cartesianY - self.cartesianY		
		local l = math.sqrt(dx * dx + dy * dy)
		self.dx = dx / l
		self.dy = dy / l
	end
end

function Party:findClosestTerrain()
	local minDistance = 999
	local closestLocation = nil
	
	for _, location in ipairs(self.gameWorld.worldLocations) do
		local tt = location.terrainType:lower()
		local dx = self.cartesianX - location.cartesianX
		local dy = self.cartesianY - location.cartesianY
		local d = math.sqrt(dx * dx + dy * dy)
		if tt == 'castle' or tt == 'city' or tt == 'village' or tt == 'ruins' or tt == 'dungeon' or tt == 'pond'  then
			if d < Party.CASTLE_DISTANCE then
				minDistance = d
				closestLocation = location
			end
		else
			if d < minDistance then
				minDistance = d
				closestLocation = location
			end
		end
	end
	
	return closestLocation, minDistance
end

function Party:update(dt, gwdt)
	local location = self.currentLocation
	local destination = self.destination
	
	if destination and self.isWalking then
		local dx = self.cartesianX - destination.cartesianX
		local dy = self.cartesianY - destination.cartesianY
		local d1 = math.sqrt(dx * dx + dy * dy)

		self.cartesianX = self.cartesianX + self.dx * gwdt * self.walkingSpeed
		self.cartesianY = self.cartesianY + self.dy * gwdt * self.walkingSpeed
		
		local dx = self.cartesianX - destination.cartesianX
		local dy = self.cartesianY - destination.cartesianY
		local d2 = math.sqrt(dx * dx + dy * dy)
		if d2 > d1 then
			self.cartesianX = destination.cartesianX
			self.cartesianY = destination.cartesianY
			self.destination = nil
		end
		
		local closest, distance = self:findClosestTerrain()
		self:setLocation(closest)
	end
end

return Party