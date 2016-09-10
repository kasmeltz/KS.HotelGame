local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local Battle = require 'classes/simulation/Battle'
local Monster = require 'classes/simulation/Monster'
local BattleMiniGame = require 'classes.simulation/BattleMiniGame'

local Scene = require 'classes/scene/Scene'
local BattleScene = Scene:extend('BattleScene')

function BattleScene:init(gameWorld)
	BattleScene.super.init(self, gameWorld)
	
	local battle = Battle:new(gameWorld)	
	
	for i = 1, 4 do
		local monster = Monster:new(gameWorld)
		monster.name = 'Skeleton '.. i
		monster.maxHealth = 5
		monster.health = 5
		monster.attack = 1
		monster.defense = 1
		table.insert(battle.monsters, monster)
	end
	
	battle.heroParty = gameWorld.heroParty
	
	self.gameWorld.currentBattle = battle
	
	-- to do 
	-- create display items for the simulation items	
	
	battle:start()
end

function BattleScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
	local gameWorld = self.gameWorld

	local battle = gameWorld.currentBattle
	local heroParty = battle.heroParty
	local monsters = battle.monsters	
	local miniGame = battle.currentMiniGame
	
	local sy = 100
	
	for _, hero in ipairs(heroParty.heroes) do
		love.graphics.print(hero:fullName(), 10, sy)
		love.graphics.print(hero.battleTimer, 200, sy)
		
		if hero == battle.currentActor then
			love.graphics.print("Is currently acting", 400, sy)
		end
		
		sy = sy + 20
	end
	
	sy = sy + 20
	for _, monster in ipairs(monsters) do
		love.graphics.print(monster.name, 10, sy)
		love.graphics.print(monster.battleTimer, 200, sy)
		
		if monster == battle.currentActor then
			love.graphics.print("Is currently acting", 400, sy)
		end

		sy = sy + 20		
	end	

	if miniGame then
		local font = FontManager:getFont('Courier16')
		love.graphics.setFont(font)		

		love.graphics.print(miniGame.name, 500, 500)

		if miniGame.state == BattleMiniGame.COUNTDOWN then
			love.graphics.print(miniGame.countdown, 500, 550)
		end
		
		if miniGame.state == BattleMiniGame.DOING_KEYPRESSES then
			local currentKeyToPress = miniGame.currentKeyToPress
			if currentKeyToPress.isShown then			
				love.graphics.print(currentKeyToPress.key, 500, 550)
			end
		end
		
		love.graphics.print(miniGame.score, 500, 450)
	end
	
end

function BattleScene:update(dt)
end

function BattleScene:keyreleased(key, scancode)
end

function BattleScene:keypressed(key)
	local gameWorld = self.gameWorld
	local battle = gameWorld.currentBattle
	local miniGame = battle.currentMiniGame
	if miniGame then
		if miniGame.state == BattleMiniGame.DOING_KEYPRESSES then
			local currentKeyToPress = miniGame.currentKeyToPress
			if currentKeyToPress.isShown then
				if key == currentKeyToPress.key then
					miniGame.score = miniGame.score + 1
					miniGame:advanceKeyPress()
				end
			end
		end
	end
end

return BattleScene
