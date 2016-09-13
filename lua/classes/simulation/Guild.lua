local SimulationItem = require 'classes/simulation/SimulationItem'
local Guild = SimulationItem:extend('Guild')

local CharacterClassesManager = require 'classes/managers/CharacterClassesManager'
CharacterClassesManager = CharacterClassesManager:getInstance()
local RacesManager = require 'classes/managers/RacesManager'
RacesManager = RacesManager:getInstance()
local NameManager = require 'classes/managers/NameManager'
NameManager = NameManager:getInstance()

local GameTime = require 'classes/simulation/GameTime'
local Hero = require 'classes/simulation/Hero'

-- heroes
-- hero costs

function Guild:init(gameWorld)
	Guild.super.init(self, gameWorld)
end

function Guild:createInitialHeroes()
	self.heroes = {}
	
	for i = 1, 20 do
		local hero = self:createHero(1, 1, 20, 50)
		table.insert(self.heroes, hero)	
	end
end

function Guild:createHero(minLevel, maxLevel, minAge, maxAge)
	local gameWorld = self.gameWorld
	local characterClasses = CharacterClassesManager.characterClasses
	local races = RacesManager.races
	local firstNamesM = NameManager.firstNamesM
	local firstNamesF = NameManager.firstNamesF
	local lastNames = NameManager.lastNames
	
	local hero = Hero:new()
	
	local level = math.random(minLevel, maxLevel)
	hero.level = level
	
	local age = math.random(minAge, maxAge)
	local gameTime = gameWorld.gameTime
	local birthDate = GameTime:new()
	local date = gameTime:date()

	local year = date.year - age	
	local month = math.random(1, 12)
	local day = math.random(1,31)
	local hour = math.random(0,24)
	local minute = math.random(0,60)
	local second = math.random(0,60)
	
	birthDate:setTime(year, month, day, hour, minute, second)
		
	hero.birthDate = birthDate
	
	local gender = math.random(1,2)
	hero.gender = gender
	
	if gender == 1 then
		local idx = math.random(1, #firstNamesM)
		hero.firstName = firstNamesM[idx]
	else	
		local idx = math.random(1, #firstNamesF)
		hero.firstName = firstNamesF[idx]		
	end
	
	idx = math.random(1, #lastNames)
	hero.lastName = lastNames[idx]
	
	local idx = math.random(1, #characterClasses)
	hero.characterClass = characterClasses[idx]
	
	local idx = math.random(1, #races)
	hero.race = races[idx]

	hero.skillLevels = {}
	hero.experience = 0
	
	-- to do what is the formula for health
	hero.maxHealth = level * math.random(5,10)
	hero.health = hero.maxHealth

	-- to do what is the formula for attack
	hero.attack = level * math.random(1,3)
		
	-- to do what is the formaul for defense	
	hero.defense = level * math.random(1,3)
	
	-- to do what is the formula for magic
	hero.magic = level * math.random(5, 10)
		
	-- to do what is the formula for hero cost
	hero.cost = level * math.random(500,1000)
	
	hero.battleTimer = 0
	
	return hero
end

function Guild:removeHero(idx)
	table.remove(self.heroes, idx)
end

return Guild