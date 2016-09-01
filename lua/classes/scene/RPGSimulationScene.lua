local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local Scene = require 'classes/scene/Scene'
local RPGSimulationScene = Scene:extend('RPGSimulationScene')

local questObjectives = 
{
	'Defeat the dragon',
	'Rescue the princess',
	'Recover the stolen orb',
	'Deliver a package',
	'Investigate',
	'Kill the evil wizard'
}

local difficultyTypes =
{
	'Easy',
	'Medium',
	'Hard',
	'Challenging',
	'Insane'
}

local terrainTypes = 
{
	'Forest', 'Swamp', 'Mountains', 'Hills', 'Plains', 'Sea', 'Desert', 'Tundra', 'Rainforest', 'Dungeon', 'Castle', 'Church'
}

local areaTypes = 
{
	'North', 'North East', 'East', 'South East', 'South', 'South West', 'West', 'North West'
}

local nameTypes = 
{
	'Dark', 'Light', 'Frozen', 'Greylock', 'Agwando', 'Infinite', 'Kilrog', 'Hidden', 'Mystic', 'Ancient', 'Forbidden'
}

function RPGSimulationScene:init(gameWorld)
	RPGSimulationScene.super.init(self, gameWorld)
	
	self.terrainStripTypes = 
	{
		love.graphics.newImage('data/images/forest1.png'),
		love.graphics.newImage('data/images/forest2.png'),
		love.graphics.newImage('data/images/forest3.png')
	}
	
	self.heroTypes =
	{
		love.graphics.newImage('data/images/fighter1.png')
	}
	
	self.monsterTypes = 
	{
		love.graphics.newImage('data/images/skeleton.png')
	}
	
	self.walkingSpeed = 100
	self.isInCombat = false
	self.monsterFightX = 400
	self.monsterMinDistance = 300
end

function RPGSimulationScene:generateQuest()
	local quest = {}
	
	math.randomseed(os.time())
	
	local idx = math.random(1, #questObjectives)
	
	quest.objective = questObjectives[idx]
	
	idx = math.random(1, #difficultyTypes)
	
	quest.difficulty = difficultyTypes[idx]
	
	idx = math.random(1, #terrainTypes)
	
	quest.terrain = terrainTypes[idx]
	
	idx = math.random(1, #nameTypes)
	
	quest.name = nameTypes[idx]
		
	return quest
end

function RPGSimulationScene:show()
	self.quest = self:generateQuest()
	
	self.terrainStrips = 
	{
		{ 0, 0, 1 }, 
		{ 300, 0, 2 },
		{ 600, 0, 3 },
		{ 900, 0, 2 },
		{ 1200, 0, 1 }
	}
	
	self.monsters = {}
end

function RPGSimulationScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
	
	local monsters = self.monsters
	local quest = self.quest
	
	local font = FontManager:getFont('ComicBold48')
	love.graphics.setFont(font)
		
	love.graphics.print(quest.objective, 10, 350)	
	love.graphics.print(quest.name .. ' ' .. quest.terrain , 10, 400)
	love.graphics.print(quest.difficulty, 10, 450)
	
	for _, terrainStrip in ipairs(self.terrainStrips) do		
		local sx = terrainStrip[1]
		local sy = terrainStrip[2]
		local idx = terrainStrip[3]
		
		love.graphics.draw(self.terrainStripTypes[idx], sx, sy)
	end	
	
	local characterImg = self.heroTypes[1]
	love.graphics.draw(characterImg, 300, 100)
	love.graphics.draw(characterImg, 300, 130)
	love.graphics.draw(characterImg, 250, 100)
	love.graphics.draw(characterImg, 250, 130)
	
	for _, monsterGroup in ipairs(monsters) do
		for _, monster in ipairs(monsterGroup) do
			local sx = monster[1]
			local sy = monster[2]
			local idx = monster[3]		
			love.graphics.draw(self.monsterTypes[idx], sx, sy)
		end
	end
end

function RPGSimulationScene:updateWalking(dt)
	local sw = self.screenWidth
	
	local terrainStrips = self.terrainStrips
	local terrainStripTypes = self.terrainStripTypes
	local monsterTypes = self.monsterTypes
	local monsters = self.monsters	
	local monsterFightX = self.monsterFightX

	for _, terrainStrip in ipairs(terrainStrips) do		
		local sx = terrainStrip[1]
		terrainStrip[1] = sx - (self.walkingSpeed * dt)
	end	
	
	for _, monsterGroup in ipairs(monsters) do
		for _, monster in ipairs(monsterGroup) do
			local sx = monster[1]
			monster[1] = sx - (self.walkingSpeed * dt)
			
			if monster[1] < monsterFightX then
				self.walkingSpeed = 0
				self.isInCombat = true
			end			
		end
	end
	
	local lastStrip = terrainStrips[#terrainStrips]
	local sx = lastStrip[1]
	local idx = lastStrip[3]
	local img = terrainStripTypes[idx]
	local stripWidth = img:getWidth()
	if sx <= sw - stripWidth then
		local newIdx = math.random(1, #terrainStripTypes)
		local newStrip = { sx + stripWidth, 0, newIdx }
		terrainStrips[#terrainStrips + 1] = newStrip
	end
	
	local firstStrip = terrainStrips[1]
	local sx = firstStrip[1]
	local idx = firstStrip[3]
	local img = terrainStripTypes[idx]
	local stripWidth = img:getWidth()
	if sx + stripWidth < 0 then
		table.remove(terrainStrips, 1)
	end	

	local canAddMonster = false	
	local lastMonsterGroup = self.monsters[#self.monsters]
	if lastMonsterGroup then
		local lastMonster = lastMonsterGroup[1]
		local sx = lastMonster[1]
		local idx = lastMonster[3]
		local img = monsterTypes[idx]
		local monsterWidth = img:getWidth()
				
		if sx < sw - self.monsterMinDistance then
			canAddMonster = true
		end	
	else
		canAddMonster = true
	end		
	
	if canAddMonster then
		local shouldAdd = math.random(1, 1000)
		if shouldAdd < 5 then
			local newMonsterGroup = {}
			local monsterCount = math.random(1, 6)
			local msx = sw + 50
			local msy = 120
			local odd = 0
			for i = 1, monsterCount do
				local newMonster = { msx, msy, 1 }
				newMonsterGroup[#newMonsterGroup +1] = newMonster
				
				odd = 1 - odd
				if odd == 0 then
					msx = msx + 50
					msy = 120
				else
					msy = 135
				end
			end
			monsters[#monsters +1] = newMonsterGroup
		end
	end	
end

function RPGSimulationScene:update(dt)
	if self.isInCombat then
	else
		self:updateWalking(dt)
	end
	
end

function RPGSimulationScene:keyreleased(key, scancode)
end

return RPGSimulationScene