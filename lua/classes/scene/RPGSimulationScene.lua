local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local TerrainStripTypeManager = require 'classes/managers/TerrainStripTypeManager'
TerrainStripTypeManager = TerrainStripTypeManager:getInstance()

local Scene = require 'classes/scene/Scene'
local RPGSimulationScene = Scene:extend('RPGSimulationScene')

RPGSimulationScene.BATTLE_TAB = 0
RPGSimulationScene.PARTY_TAB = 1
RPGSimulationScene.GUILD_TAB = 4
RPGSimulationScene.QUEST_TAB = 5
RPGSimulationScene.MAP_TAB = 7

function RPGSimulationScene:init(gameWorld)
	RPGSimulationScene.super.init(self, gameWorld)
	
	self.heroTypes =
	{
		love.graphics.newImage('data/images/fighter1.png')
	}
	
	self.monsterTypes = 
	{
		love.graphics.newImage('data/images/skeleton.png')
	}
	
	self.scrollingSpeed = 10
	self.monsterFightX = 400
	self.monsterMinDistance = 300
	self.activeTab = RPGSimulationScene.GUILD_TAB
	self.battleActionPoints = 100
end

function RPGSimulationScene:createTerrainStrip(terrainType, sx, idx)
	local terrainStripTypes = TerrainStripTypeManager:getTerrainStripTypes(terrainType)
	local idx = idx or math.random(1, #terrainStripTypes)
	local strip = { sx, 0, terrainStripTypes[idx] }	
	return strip	
end

function RPGSimulationScene:createTerrain()
	local terrainStrips = {}
	
	local sx = 0
	for i = 1, 5 do
		local strip = self:createTerrainStrip('forest', sx)
		sx = sx + 300		
		terrainStrips[#terrainStrips + 1] = strip
	end
	
	return terrainStrips	
end

function RPGSimulationScene:show()
	self.terrainStrips = self:createTerrain()
	
	self.monsters = {}
	
	local gameTime = self.gameWorld.gameTime
	gameTime:setSpeed(4)
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
	local quest = self.gameWorld.currentQuest
	
	love.graphics.setColor(255,255,255)
	
	for _, terrainStrip in ipairs(self.terrainStrips) do		
		local sx = terrainStrip[1]
		local sy = terrainStrip[2]
		local tt = terrainStrip[3]
		
		love.graphics.draw(tt, sx, sy)
	end	
	
	--[[
	self:drawHero(heroes[1], 150, 100)	
	self:drawHero(heroes[2], 200, 130)
	self:drawHero(heroes[3], 250, 100)
	self:drawHero(heroes[4], 300, 130)
	]]
	
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
	
	local speedText = gameTime.speedTexts[gameTime.currentSpeed]
	local tw = font:getWidth(speedText)	
	love.graphics.print(speedText, sw - tw - 10, 15)
				
	local party = self.gameWorld.heroParty
	local locationText = party.currentLocation:fullName()
	local tw = font:getWidth(locationText)
	love.graphics.print(locationText, sw - tw - 10, 30)
	
	if party.destination then
		local destinationText = party.destination:fullName()
		local tw = font:getWidth(destinationText)
		love.graphics.print(destinationText, sw - tw - 10, 45)
	end		
		
	if quest then
	
		--love.graphics.print(quest.objective .. ' in the ' .. quest.name .. ' ' .. quest.terrain, 10, 0)
	end

	local goldText = 'Gold: $' .. party.gold
	local tw = font:getWidth(goldText)
	love.graphics.print(goldText, sw - tw - 10, 180)
end

function RPGSimulationScene:drawBattleTab()
--[[
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
	end]]
end

function RPGSimulationScene:drawMapTab()
	local sw = self.screenWidth
	local sh = self.screenHeight	
	
	local worldLocations = self.gameWorld.worldLocations

	love.graphics.setColor(180, 180, 180)
	love.graphics.rectangle('fill', sw / 2 - 300, sh / 2 - 100 , 600, 450)
	
	love.graphics.setColor(0,0,0)

	local font = FontManager:getFont('Courier12')	
	love.graphics.setFont(font)
	
	for _, location in ipairs(worldLocations) do
		if location.isDiscovered then
			local sx = sw / 2 + (location.cartesianX * 70)
			local sy = sh / 2 + (location.cartesianY * 70) + 100
			love.graphics.setColor(255,255,0)
			love.graphics.circle('fill', sx, sy, 3)			
			--local locationText = location:fullName()
			--local tw = font:getWidth(locationText)
			--love.graphics.setColor(0, 10, 0)		
			--love.graphics.print(locationText, sx - tw / 2, sy)
		end
	end
	
	local party = self.gameWorld.heroParty
	local sx = sw / 2 + (party.cartesianX * 70)
	local sy = sh / 2 + (party.cartesianY * 70) + 100
	love.graphics.setColor(255,0,0)
	love.graphics.circle('fill', sx, sy, 3)
	
	local destination = party.destination
	if destination then
		local sx = sw / 2 + (destination.cartesianX * 70)
		local sy = sh / 2 + (destination.cartesianY * 70) + 100
		love.graphics.setColor(0,0,255)
		love.graphics.circle('fill', sx, sy, 3)
	end
end

function RPGSimulationScene:drawQuestTab()
	local sw = self.screenWidth
	local sh = self.screenHeight	

	local quests = self.gameWorld.availableQuests	
	
	local sy = 250
	for _, quest in ipairs(quests) do
		local questTitleText = ''
		for _, objective in ipairs(quest.objectives) do
			questTitleText = questTitleText .. objective.title .. ' '		
		end
		
		questTitleText = questTitleText .. ' DUE DATE: ' .. quest.dueDate:getDateString('%d, %B, %Y %H:%M:%S')
		love.graphics.print(questTitleText, 0, sy)
		sy = sy + 60
	end
end

function RPGSimulationScene:drawGuildTab()
	local sw = self.screenWidth
	local sh = self.screenHeight	

	local guild = self.gameWorld.guild
	
	local sy = 220
	for _, hero in ipairs(guild.heroes) do
		local text = hero:fullName()		
		text = text .. ' L' .. hero.level .. ' ' .. hero.race.name .. ' ' .. hero.characterClass.name .. ' COST: $' .. hero.cost
		love.graphics.print(text, 0, sy)
		sy = sy + 25
	end
end

function RPGSimulationScene:drawPartyTab()
end

function RPGSimulationScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight	
	
	self:drawTopStrip()
	
	if self.activeTab ==  RPGSimulationScene.BATTLE_TAB then
		self:drawBattleTab()
	elseif self.activeTab == RPGSimulationScene.PARTY_TAB then
		self:drawPartyTab()
	elseif self.activeTab == RPGSimulationScene.QUEST_TAB then
		self:drawQuestTab()
	elseif self.activeTab == RPGSimulationScene.MAP_TAB then
		self:drawMapTab()
	elseif self.activeTab == RPGSimulationScene.GUILD_TAB then
		self:drawGuildTab()
	end
	
	self:drawTab('B', RPGSimulationScene.BATTLE_TAB, sh - 30)
	self:drawTab('P', RPGSimulationScene.PARTY_TAB, sh - 30)
	self:drawTab('I', 2, sh - 30)
	self:drawTab('C', 3, sh - 30)
	self:drawTab('G', RPGSimulationScene.GUILD_TAB, sh - 30)
	self:drawTab('Q', RPGSimulationScene.QUEST_TAB, sh - 30)
	self:drawTab('H', 6, sh - 30)
	self:drawTab('M', RPGSimulationScene.MAP_TAB, sh - 30)
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
	local party = self.gameWorld.heroParty
	
	party:walking(false)
	gameTime:setSpeed(5)
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

function RPGSimulationScene:updateWalking(dt, gwdt)
	local sw = self.screenWidth
	
	local terrainStrips = self.terrainStrips
	local monsterTypes = self.monsterTypes
	local monsters = self.monsters	
	local monsterFightX = self.monsterFightX

	for _, terrainStrip in ipairs(terrainStrips) do		
		local sx = terrainStrip[1]
		terrainStrip[1] = sx - (self.scrollingSpeed * gwdt)
	end	
	
	for _, monsterGroup in ipairs(monsters) do
		for _, monster in ipairs(monsterGroup) do
			local sx = monster[1]
			monster[1] = sx - (self.scrollingSpeed * gwdt)
			
			if monster[1] < monsterFightX then
				self:startBattle()
			end			
		end
	end
	
	local lastStrip = terrainStrips[#terrainStrips]
	local sx = lastStrip[1]
	local img = lastStrip[3]
	local stripWidth = img:getWidth()
	if sx <= sw - stripWidth then
		local newStrip = self:createTerrainStrip('forest', sx + stripWidth)
		terrainStrips[#terrainStrips + 1] = newStrip
	end
	
	local firstStrip = terrainStrips[1]
	local sx = firstStrip[1]
	local img = firstStrip[3]
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
		if shouldAdd < 1 then
			self:createMonsterGroup()
		end
	end	
end

function RPGSimulationScene:update(dt)
	local party = self.gameWorld.heroParty
	local gameTime = self.gameWorld.gameTime
	local gwdt = gameTime:updateSpeed(dt)
	
	if party:walking() then
		self:updateWalking(dt, gwdt)
	end	
end

function RPGSimulationScene:keyreleased(key, scancode)
	if key == 'm' then
		self.activeTab = RPGSimulationScene.MAP_TAB
	end
	--if key == 'b'then
		--self.activeTab = RPGSimulationScene.BATTLE_TAB
	--end
	if key == 'p' then
		self.activeTab = RPGSimulationScene.PARTY_TAB
	end
	if key == 'q' then
		self.activeTab = RPGSimulationScene.QUEST_TAB
	end
	if key == 'g' then
		self.activeTab = RPGSimulationScene.GUILD_TAB
	end
	
	if key == 'a' then
		local locations = self.gameWorld.worldLocations
		local idx = math.random(1, #locations)
		local location = locations[idx]
		self.gameWorld.heroParty:setDestination(location)
	end
	
	if key == '1' then
		self.gameWorld.heroParty:walking(true)
	end
	
	if key == '2' then
		self.gameWorld.heroParty:walking(false)
	end
	
	if key == '3' then
		local speed = self.gameWorld.gameTime.currentSpeed
		speed = speed - 1
		if speed > 0 then		
			self.gameWorld.gameTime:setSpeed(speed)
		end
	end
	
	if key == '4' then
		local speed = self.gameWorld.gameTime.currentSpeed
		speed = speed + 1
		if speed <= #self.gameWorld.gameTime.speeds then		
			self.gameWorld.gameTime:setSpeed(speed)
		end
	end
end

return RPGSimulationScene