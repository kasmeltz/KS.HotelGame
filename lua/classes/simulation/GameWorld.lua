local TerrainTypeManager = require 'classes/managers/TerrainTypeManager'
TerrainTypeManager = TerrainTypeManager:getInstance()
local ObjectiveTypeManager = require 'classes/managers/ObjectiveTypeManager'
ObjectiveTypeManager = ObjectiveTypeManager:getInstance()
local NameManager = require 'classes/managers/NameManager'
NameManager = NameManager:getInstance()

local Location = require 'classes/simulation/Location'
local Objective = require 'classes/simulation/Objective'
local Quest = require 'classes/simulation/Quest'
local Party = require 'classes/simulation/Party'
local Guild = require 'classes/simulation/Guild'
local GameTime = require 'classes/simulation/GameTime'

local class = require 'libs/30log/30log'
local GameWorld = class('GameWorld')

function GameWorld:init()
	local gameTime = GameTime:new()
	gameTime:setTime(2000, 2, 1, 7, 55, 0)
	gameTime:setSpeed(5)
	self.gameTime = gameTime
	self.locationsPerDirection = 30
	self.columnsPerRow = 4
end

-- create a brand new game world
function GameWorld:generateNewWorld()
	self.generatedObjectives = {}
	self:createWorldLocations()
	self:createInitialQuests()	
	self.guild = Guild:new(self)
	self.guild:createInitialHeroes()		
	self.heroParty = Party:new(self)
	
	local castle = self.worldLocations[#self.worldLocations]
	self.heroParty:setLocation(castle)
	self.heroParty.cartesianX = castle.cartesianX
	self.heroParty.cartesianY = castle.cartesianY
	
	self.heroParty.gold = 5000	
	self.heroParty:walking(false)
	
	self.heroParty:setDestination(self.worldLocations[1])
	
	self.heroParty:addHero(self.guild.heroes[1])
	self.heroParty:addHero(self.guild.heroes[2])
	self.heroParty:addHero(self.guild.heroes[3])
	self.heroParty:addHero(self.guild.heroes[4])
end

function GameWorld:createInitialQuests()
	self.availableQuests = {}
	
	local q = self:createQuest(1, 1, 1, 1)
	table.insert(self.availableQuests, q)
	local q = self:createQuest(1, 1, 1, 1)
	table.insert(self.availableQuests, q)
	local q = self:createQuest(1, 1, 1, 1)
	table.insert(self.availableQuests, q)
	local q = self:createQuest(1, 3, 1, 1)	
	table.insert(self.availableQuests, q)
	local q = self:createQuest(2, 3, 1, 2)	
	table.insert(self.availableQuests, q)
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
				
	local worldLocation = Location:new(self)
	worldLocation.terrainType = 'Castle'
	local idx = math.random(1, #availableNouns)
	local pidx = availableNouns[idx]
	worldLocation.name = nouns[pidx]
	worldLocation.nameType = 3
	worldLocation.difficulty = 0			
	worldLocation:setQuadrantRowColumn(0, 0, 0)
	worldLocation:discovered(true)
	table.insert(self.worldLocations, worldLocation)
end

function GameWorld:chooseObjectiveNoun(wordType, location)
	local availableNouns = ObjectiveTypeManager.nouns[wordType]
	local firstNamesM = NameManager.firstNamesM
	local firstNamesF = NameManager.firstNamesF
	local lastNames = NameManager.lastNames
	
	print(wordType)
	
	if wordType == 'nm' then
		local fidx = math.random(1, #firstNamesM)
		local lidx = math.random(1, #lastNames)
		
		return firstNamesM[fidx] .. ' ' .. lastNames[lidx]
	elseif wordType == 'nf' then
		local fidx = math.random(1, #firstNamesF)
		local lidx = math.random(1, #lastNames)
		
		return firstNamesF[fidx] .. ' ' .. lastNames[lidx]
	elseif wordType == 'l' then
		return location:fullName()
	else
		local idx = math.random(1, #availableNouns)
		return availableNouns[idx]
	end
end

function GameWorld:replaceNouns(text, chosenNouns)
	for i = 1, 1000 do
		if not chosenNouns[i] then break end
		text = text:gsub('%%' .. i .. '%%', chosenNouns[i])
	end
	return text
end

function GameWorld:createQuest(minDifficulty, maxDifficulty, minLocations, maxLocations)
	local locationCount = math.random(minLocations, maxLocations)	
	local objectiveTypes = ObjectiveTypeManager.objectiveTypes
		
	local quest = Quest:new()		
	local date = self.gameTime:date()
	quest.dueDate = GameTime:new()
	quest.dueDate:setTime(date.year, date.month, date.day + locationCount, date.hours, date.min, date.sec)
	
	for i = 1, locationCount do
		local difficulty = math.random(minDifficulty, maxDifficulty)

		local selectedLocation = nil
		for _, location in ipairs(self.worldLocations) do
			if location.difficulty == difficulty then			
				selectedLocation = location
				break
			end
		end
		
		quest:addLocation(selectedLocation)
		
		local objectiveChosen = false		
		while objectiveChosen == false do
			local objective = Objective:new()
			
			local oidx = math.random(1, #objectiveTypes)
			local objectiveType = objectiveTypes[oidx]
			local chosenNouns = {}
			
			for j = 1, #objectiveType.wordTypes do
				local noun = self:chooseObjectiveNoun(objectiveType.wordTypes[j], selectedLocation)
				noun = noun:gsub('%%l%%', selectedLocation:fullName())
				chosenNouns[#chosenNouns + 1] = noun
			end

			local title = objectiveType.title
			objective.title = self:replaceNouns(title, chosenNouns)
			
			if not self:isObjectiveDuplicate(objective) then
				self:rememberObjective(objective)
				local didx = math.random(1, #objectiveType.descriptions)
				local description = objectiveType.descriptions[didx]		
				objective.description = self:replaceNouns(description, chosenNouns)	
				objectiveChosen = objective
								
				print(objective.title)
				print(objective.description)
				
				-- to do
				-- generate reward for quest
			end
		end
		
		quest:addObjective(objectiveChosen)		
	end	
	
	return quest
end

function GameWorld:rememberObjective(objective)
	self.generatedObjectives[objective.title] = true
end

function GameWorld:isObjectiveDuplicate(objective)
	return self.generatedObjectives[objective.title]
end

function GameWorld:update(dt)
	local gwdt = self.gameTime:update(dt)
	
	if self.currentBattle then
		self.currentBattle:update(dt, gwdt)
	end
	
	self.heroParty:update(dt, gwdt)
end

return GameWorld