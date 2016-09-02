local TerrainTypeManager = require 'classes/managers/TerrainTypeManager'
TerrainTypeManager = TerrainTypeManager:getInstance()
local Location = require 'classes/simulation/Location'
local Quest = require 'classes/simulation/Quest'
local GameTime = require 'classes/simulation/GameTime'

local class = require 'libs/30log/30log'
local GameWorld = class('GameWorld')

-- create a brand new game world
function GameWorld:init()
	local gameTime = GameTime:new()
	gameTime:setTime(2000, 2, 1, 7, 55, 0)
	gameTime:setSpeed(5)
	self.gameTime = gameTime
	self.locationsPerDirection = 20
	self.columnsPerRow = 4
end

function GameWorld:generateNewWorld()
	self:createWorldLocations()
	self:createInitialQuests()
end

function GameWorld:createInitialQuests()
	self.activeQuests = {}
	
	local q = self:createQuest(1, 1, 1, 1)
	table.insert(self.activeQuests, q)
	local q = self:createQuest(1, 1, 1, 1)
	table.insert(self.activeQuests, q)
	local q = self:createQuest(1, 1, 1, 1)
	table.insert(self.activeQuests, q)
	local q = self:createQuest(1, 3, 1, 1)	
	table.insert(self.activeQuests, q)
	local q = self:createQuest(2, 3, 1, 2)	
	table.insert(self.activeQuests, q)
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
	
	for quadrant = 1, 8 do
		local row = 1
		local column = 1
		for i = 1, self.locationsPerDirection do
			local worldLocation = Location:new(self)
			local terrainIdx = math.random(1, #terrainTypes)
			worldLocation.terrainType = terrainTypes[terrainIdx]
			
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
			worldLocation.difficulty = difficulty
			
			worldLocation:setQuadrantRowColumn(quadrant, row, column)
					
			table.insert(self.worldLocations, worldLocation)
			
			column = column + 1
			if column > self.columnsPerRow then
				column = 1
				row = row + 1
			end
			
			difficulty = difficulty + 1
		end		
	end
end

function GameWorld:createQuest(minDifficulty, maxDifficulty, minLocations, maxLocations)
	local locationCount = math.random(minLocations, maxLocations)	
	local quest = Quest:new()

	for i = 1, locationCount do
		local difficulty = math.random(minDifficulty, maxDifficulty)

		local selectedLocation = nil
		for _, location in ipairs(self.worldLocations) do
			if location.difficulty == difficulty then			
				selectedLocation = location
				break
			end
		end
		
		quest:addLocation(location)
	end	
	
	return quest
end

function GameWorld:update(dt)
	self.gameTime:update(dt)
end

return GameWorld