local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local Scene = require 'classes/scene/Scene'
local RPGSimulationScene = Scene:extend('RPGSimulationScene')

RPGSimulationScene.BATTLE_TAB = 0

local questObjectives = 
{
	'Defeat the dragon',
	'Rescue the princess',
	'Recover the stolen orb',
	'Deliver a package',
	'Investigate rumours',
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
	
	math.randomseed(os.time())
	
	self.terrainStripTypes = 
	{
		love.graphics.newImage('data/images/forest1.png'),
		love.graphics.newImage('data/images/forest2.png'),
		love.graphics.newImage('data/images/forest3.png'),
		love.graphics.newImage('data/images/forest4.png')
	}
	
	self.heroTypes =
	{
		love.graphics.newImage('data/images/fighter1.png')
	}
	
	self.monsterTypes = 
	{
		love.graphics.newImage('data/images/skeleton.png')
	}
	
	self.walkingSpeed = 200
	self.isInCombat = false
	self.monsterFightX = 400
	self.monsterMinDistance = 300
	self.activeTab = RPGSimulationScene.BATTLE_TAB
	self.battleActionPoints = 100
end

function RPGSimulationScene:generateQuest()
	local quest = {}
	
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

function RPGSimulationScene:createTerrain()
	local terrainStrips = {}
	
	local sx = 0
	for i = 1, 4 do
		local idx = math.random(1, #self.terrainStripTypes)
		local strip = { sx, 0, 1 }
		sx = sx + 300
		
		terrainStrips[#terrainStrips + 1] = strip
	end
	
	return terrainStrips	
end

local heroClasses = 
{
	'Knight',
	'Mage',
	'Barbarian',
	'Cleric',
	'Druid',
	'Thief',
	'Necromancer',
	'Ranger',
}

local heroRaces =
{
	'Human',
	'Dwarf', 
	'Elf', 
	'Gnome',
	'Orc',
}

local heroFirstNames =  
{
	'Paul', 
	'George',
	'John',
	'Ringo'
}

local heroLastNames =
{
	'McCartney',
	'Lennon',
	'Harrison',
	'Starr'
}

function RPGSimulationScene:createHero() 
	local hero = {}
	local idx
	
	idx = math.random(1, #heroFirstNames)
	hero.fname = heroFirstNames[idx]

	idx = math.random(1, #heroLastNames)
	hero.lname = heroLastNames[idx]
	
	idx = math.random(1, #heroClasses)
	hero.class = heroClasses[idx]
	
	idx = math.random(1, #heroRaces)
	hero.race = heroRaces[idx]
	
	hero.level = math.random(1, 3)
	
	hero.physicalDamage = hero.level * math.random(2, 5)
	hero.physicalDefense = hero.level * math.random(2, 5)
	hero.magicSkill = hero.level * math.random(2, 5)
	
	hero.hitPoints = hero.level * math.random(10, 40)
	hero.maxHitPoints = hero.hitPoints	
	
	hero.actionPoints = 0
	
	return hero
end

function RPGSimulationScene:show(heroes)
	if not heroes then
		heroes = {}
		for i = 1, 4 do
			heroes[#heroes + 1] = self:createHero()	
		end
	end
	
	self.heroes = heroes
	
	self.quest = self:generateQuest()
	
	self.terrainStrips = self:createTerrain()
	
	self.monsters = {}
	
	local gameTime = self.gameWorld.gameTime
	gameTime:setSpeed(9)
end

local tabWidth = 50
function RPGSimulationScene:drawTab(text, idx, sy)
	local sx = idx * tabWidth

	love.graphics.setColor(100, 100, 250)
	love.graphics.rectangle('fill', sx, sy, tabWidth, 30)
	love.graphics.setColor(70, 70, 150)
	love.graphics.rectangle('line', sx, sy, tabWidth, 30)
	love.graphics.setColor(0, 0, 0)

	local font = FontManager:getFont('Courier16')
	love.graphics.setFont(font)		
	love.graphics.setColor(0,0,0)
	local tw = font:getWidth(text)
	local th = font:getHeight(text)
	
	love.graphics.print(text, sx + (tabWidth / 2) - (tw / 2), sy + 15 - (th / 2))
end

function RPGSimulationScene:drawTopStrip()
	local sw = self.screenWidth
	local sh = self.screenHeight	
	
	local heroes = self.heroes
	local monsters = self.monsters
	local quest = self.quest
	
	love.graphics.setColor(255,255,255)
	
	for _, terrainStrip in ipairs(self.terrainStrips) do		
		local sx = terrainStrip[1]
		local sy = terrainStrip[2]
		local idx = terrainStrip[3]
		
		love.graphics.draw(self.terrainStripTypes[idx], sx, sy)
	end	
	
	self:drawHero(heroes[1], 150, 100)	
	self:drawHero(heroes[2], 200, 130)
	self:drawHero(heroes[3], 250, 100)
	self:drawHero(heroes[4], 300, 130)
	
	love.graphics.setColor(255,255,255)
	
	for _, monsterGroup in ipairs(monsters) do
		for _, monster in ipairs(monsterGroup) do
			self:drawMonster(monster)
		end
	end
		
	love.graphics.setColor(255,255,255)
	
	local gameTime = self.gameWorld.gameTime
	local timeText = gameTime:getDateString('%d, %B, %Y %H:%M:%S')
	
	local font = FontManager:getFont('Courier16')
	love.graphics.setFont(font)		
	local tw = font:getWidth(timeText)	
	love.graphics.print(timeText, sw - tw - 10, 0)
	
	local locationText = quest.name .. ' ' .. quest.terrain
	local tw = font:getWidth(locationText)
	love.graphics.print(locationText, sw - tw - 10, 20)	
	
	love.graphics.print(quest.objective .. ' in the ' .. quest.name .. ' ' .. quest.terrain, 10, 0)	
end

function RPGSimulationScene:drawBattleTab()
	local sw = self.screenWidth
	local sh = self.screenHeight	
	
	local battle = self.battle
	
	if not battle then 
		return
	end
	
	local font = FontManager:getFont('Courier12')
	love.graphics.setFont(font)		
	love.graphics.setColor(255,255,255)
	
	local sy = 210
	local heroes = self.heroes
	for _, hero in ipairs(heroes) do
		if battle.currentActor == hero then
			love.graphics.setColor(255,255,0)
		else
			love.graphics.setColor(255,255,255)
		end
		love.graphics.print('L'.. hero.level .. ' ' .. hero.fname .. ' ' .. hero.lname, 10, sy)		
		self:drawBar(10, sy + 30, 100, self.battleActionPoints, hero.actionPoints, 150, 100, 100, 100, 50, 50)
		sy = sy + 40
	end
		
	love.graphics.setColor(255,255,255)
	
	local battle = self.battle
	local monsters = battle.monsters
	local sy = 210
	for _, monster in ipairs(monsters) do
		if battle.currentActor == monster then
			love.graphics.setColor(255,255,0)
		else
			love.graphics.setColor(255,255,255)
		end
		love.graphics.print('L' .. monster.level .. ' ' ..monster.name, 400, sy)
		self:drawBar(400, sy + 30, 100, self.battleActionPoints, monster.actionPoints, 150, 100, 100, 100, 50, 50)
		sy = sy + 40
	end
	
	if battle.currentActor then	
		self:drawBattleInput()
	end
end

function RPGSimulationScene:drawBattleInput()
	love.graphics.setColor(200,200,200)
	love.graphics.rectangle('line', 10, 380, 500, 330)
	
	
end

function RPGSimulationScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight	

	self:drawTopStrip()
	
	if self.activeTab ==  RPGSimulationScene.BATTLE_TAB then
		self:drawBattleTab()
	end
	
	self:drawTab('B',  RPGSimulationScene.BATTLE_TAB, sh - 30)
	self:drawTab('P', 1, sh - 30)
	self:drawTab('I', 2, sh - 30)
	self:drawTab('C', 3, sh - 30)
	self:drawTab('G', 4, sh - 30)
	self:drawTab('Q', 5, sh - 30)
	self:drawTab('H', 6, sh - 30)
end

function RPGSimulationScene:drawBar(sx, sy, width, max, current, fr, fg, fb, br, bg, bb, showText)
	local showText = showText or true
	
	local max = math.floor(max)
	local max = math.floor(max)
	local current = math.floor(current)

	local font = FontManager:getFont('Courier12')
	love.graphics.setFont(font)		
	love.graphics.setColor(0,0,0)
	local text = current .. '/' .. max
	local tw = font:getWidth(text)
	local th = font:getHeight(text)
	
	local ratio = current / max
	
	love.graphics.setColor(fr, fg, fb)
	love.graphics.rectangle('fill', sx, sy - th, width * ratio, th)
	love.graphics.setColor(br, bg, bb)
	love.graphics.rectangle('line', sx, sy - th, width, th)

	if showText then
		love.graphics.setColor(255, 255, 255)
		love.graphics.print(text, sx + (width / 2) - (tw / 2), sy - th)
	end
end

function RPGSimulationScene:drawHero(hero, sx, sy)
	local hpBarWidth = 50
	
	love.graphics.setColor(255,255,255)
	local characterImg = self.heroTypes[1]
	love.graphics.draw(characterImg, sx, sy)
		
	self:drawBar(sx + 10, sy, 70, hero.maxHitPoints, hero.hitPoints, 100, 200, 100, 80, 150, 80)
end

function RPGSimulationScene:drawMonster(monster)
	local sx = monster[1]
	local sy = monster[2]
	local idx = monster[3]		
	
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.monsterTypes[idx], sx, sy)
	
	self:drawBar(sx - 5, sy, 70, monster.maxHitPoints, monster.hitPoints, 100, 200, 100, 80, 150, 80)
end

function RPGSimulationScene:startBattle()
	local gameTime = self.gameWorld.gameTime
	local heroes = self.heroes
	local monsters = self.monsters	
	local monsterFightX = self.monsterFightX
	local battleActionPoints = self.battleActionPoints
	
	self.walkingSpeed = 0
	self.isInCombat = true
	gameTime:setSpeed(5)

	for _, hero in ipairs(heroes) do
		hero.actionPoints = math.random(0, battleActionPoints / 2)
	end	
	
	-- position monsters properly
	local firstGroup = monsters[1]
	for _, monster in ipairs(firstGroup) do
		monster.actionPoints = math.random(0, battleActionPoints / 2)
	end
	
	self.battle = self:createBattle()
end

function RPGSimulationScene:createMonsterGroup()
	local monsters = self.monsters
	local sw = self.screenWidth
	
	local monsterGroup = {}
	local monsterCount = math.random(1, 4)
	local msx = sw + 50
	local msy = 110
	local odd = 0
	for i = 1, monsterCount do
		local monster = { msx, msy, 1 }
		
		monster.name = 'Skeleton'
		monster.level = math.random(1, 3)
	
		monster.physicalDamage = monster.level * math.random(2, 5)	
		monster.physicalDefense = monster.level * math.random(2, 5)
		monster.magicSkill = monster.level * math.random(2, 5)	
		monster.hitPoints = monster.level * math.random(10, 40)
		monster.maxHitPoints = monster.hitPoints	
		
		monster.actionPoints = 0
		
		monsterGroup[#monsterGroup +1] = monster
		
		odd = 1 - odd
		if odd == 0 then
			msy = 110
		else
			msy = 130
		end
		msx = msx + 50
	end
	monsters[#monsters +1] = monsterGroup
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
				self:startBattle()
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
			self:createMonsterGroup()
		end
	end	
end

function RPGSimulationScene:createBattle()
	local battle = {}
	
	local monsterGroup = self.monsters[1]
	battle.monsters = monsterGroup	
	
	return battle	
end

function RPGSimulationScene:setBattleActor(actor)
	local battle = self.battle
	battle.currentActor = actor
end

function RPGSimulationScene:updateCombat(dt)
	local battle = self.battle
	local heroes = self.heroes
	local monsters = battle.monsters
	local battleActionPoints = self.battleActionPoints
	
	-- someone is taking a turn
	if battle.currentActor then
	
	else	
		for _, hero in ipairs(heroes) do
			hero.actionPoints = hero.actionPoints + (dt * 100)
			if (hero.actionPoints > battleActionPoints) then
				self:setBattleActor(hero)
				hero.actionPoints = battleActionPoints
				return
			end
		end

		for _, monster in ipairs(monsters) do
			monster.actionPoints = monster.actionPoints + (dt * 100)
			if (monster.actionPoints > battleActionPoints) then
				self:setBattleActor(monster)
				monster.actionPoints = battleActionPoints
				return
			end
		end
	end	
end

function RPGSimulationScene:update(dt)
	if self.isInCombat then
		self:updateCombat(dt)
	else
		self:updateWalking(dt)
	end
	
end

function RPGSimulationScene:keyreleased(key, scancode)
end

return RPGSimulationScene