local SimulationItem = require 'classes/simulation/SimulationItem'
local Guild = SimulationItem:extend('Guild')

local CharacterClassesManager = require 'classes/managers/CharacterClassesManager'
CharacterClassesManager = CharacterClassesManager:getInstance()
local RacesManager = require 'classes/managers/RacesManager'
RacesManager = RacesManager:getInstance()
local NameManager = require 'classes/managers/NameManager'
NameManager = NameManager:getInstance()

local GameTime = require 'classes/simulation/GameTime'

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
	local gameTime = gameWorld.gameTime
	
	local level = math.random(minLevel, maxLevel)
	local age = math.random(minAge, maxAge)
	
	local birthDate = GameTime:new()
	
	-- birth date
-- name
-- character class
-- race
-- skill levels
-- health
-- magic
-- level
-- experience
-- defense
-- battle damage
-- battle timers

	
	
end

return Guild