local TerrainTypeManager = require 'classes/managers/TerrainTypeManager'
TerrainTypeManager = TerrainTypeManager:getInstance()
local Location = require 'classes/simulation/Location'
local GameTime = require 'classes/simulation/GameTime'

local class = require 'libs/30log/30log'
local GameWorld = class('GameWorld')

function GameWorld:init()
	local gameTime = GameTime:new()
	gameTime:setTime(2000, 2, 1, 7, 55, 0)
	gameTime:setSpeed(5)
	self.gameTime = gameTime
	self.locationsPerDirection = 20
	self.columnsPerRow = 4
	self:createWorldLocations()
end

function GameWorld:createWorldLocations()
	self.worldLocations = {}
	
	local availablePrefixes = {}
	local availableSuffixes = {}
	local availableNouns = {}
	local terrainTypes = TerrainTypeManager:getTerrainTypes()
	local prefixes = TerrainTypeManager:getPrefixes()
	local suffixes = TerrainTypeManager:getSuffixes()
	local nouns = TerrainTypeManager:getProperNouns()
	
	for i = 1, #prefixes do
		availablePrefixes[i] = i
	end
	
	for i = 1, #suffixes do
		availableSuffixes[i] = i
	end

	for i = 1, #nouns do
		availableNouns[i] = i
	end
	
	local difficulty = 1
	
	for cuadrant = 1, 8 do
		local row = 1
		local column = 1
		for i = 1, self.locationsPerDirection do
			local worldLocation = Location:new(self)
			local terrainIdx = math.random(1, #terrainTypes)
			worldLocation.terrainType = terrainTypes[terrainIdx]
			worldLocation.cuadrant = cuadrant
			
			local availableTable = nil
			local nameTable = nil
			local nameType = math.random(1, 3)			
			worldLocation.nameType = nameType
			
			if nameType == 1 then
				availableTable = availablePrefixes
				nameTable = prefixes
			elseif nameType == 2 then
				availableTable = availableSuffixes
				nameTable = suffixes
			elseif nameType == 3 then
				availableTable = availableNouns
				nameTable = nouns
			end
			
			if #availableTable == 0 then
				availableTable = availablePrefixes
			end

			if #availableTable == 0 then
				availableTable = availableSuffixes
			end

			if #availableTable == 0 then
				availableTable = availableNouns
			end
			
			local idx = math.random(1, #availableTable)
			local pidx = availableTable[idx]
			table.remove(availableTable, idx)				
			worldLocation.name = nameTable[pidx]
			worldLocation.row = row
			worldLocation.column = column				
			worldLocation.difficulty = difficulty
					
			table.insert(self.worldLocations, worldLocation)
			
			column = column + 1
			if column > self.columnsPerRow then
				column = 1
				row = row + 1
			end
			
			difficulty = difficulty + 1
			
			print('=============================')
			print(worldLocation.cuadrant, worldLocation.row, worldLocation.column, worldLocation.difficulty)
			print(worldLocation:fullName())
		end		
	end
end

function GameWorld:update(dt)
	self.gameTime:update(dt)
end

return GameWorld