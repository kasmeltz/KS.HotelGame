local SimulationItem = require 'classes/simulation/SimulationItem'
local Battle = SimulationItem:extend('Battle')
local BattleMiniGame = require 'classes/simulation/BattleMiniGame'

Battle.NO_ACTIONS = 1
Battle.SOMEONE_ACTING = 2

-- monsetrs
-- whose turn it is
-- battle state

function Battle:init(gameWorld)
	Battle.super.init(self, gameWorld)
	
	self.monsters = {}
	
	self.actionLevelRequiredToAct = 2
end

--
-- Does whatever needs to happen when a battle starts
--
function Battle:start()
	local heroParty = self.heroParty
	local monsters = self.monsters
	local actionLevelRequiredToAct = self.actionLevelRequiredToAct
	
	for _, hero in ipairs(heroParty.heroes) do
		hero.battleTimer = math.random() * actionLevelRequiredToAct
	end
	for _, monster in ipairs(monsters) do
		monster.battleTimer = math.random() * actionLevelRequiredToAct
	end

	self.currentActor = nil
		
	self.state = Battle.NO_ACTIONS

end

function Battle:setCurrentActor(actor)
	local actionLevelRequiredToAct = self.actionLevelRequiredToAct

	actor.battleTimer = actionLevelRequiredToAct
	self.currentActor = actor
	
	self.currentMiniGame = BattleMiniGame:new(self.gameWorld, self.currentActor)
	
	self.currentMiniGame.onFinish = function(miniGame)
		self.currentActor.battleTimer = 0
		self.currentActor = nil
		self.state = Battle.NO_ACTIONS
	end
	
	self.state = Battle.SOMEONE_ACTING
end

function Battle:updateBattleTimers(dt)
	local heroParty = self.heroParty
	local monsters = self.monsters
	local actionLevelRequiredToAct = self.actionLevelRequiredToAct
	
	for _, hero in ipairs(heroParty.heroes) do
		hero.battleTimer = hero.battleTimer + dt
		if hero.battleTimer >= self.actionLevelRequiredToAct then
			self:setCurrentActor(hero)
			return
		end
	end
	
	for _, monster in ipairs(monsters) do
		monster.battleTimer = monster.battleTimer + dt
		if monster.battleTimer >= self.actionLevelRequiredToAct then
			self:setCurrentActor(monster)
			return
		end
	end
end

function Battle:update(dt)
	if self.state == Battle.NO_ACTIONS then
		self:updateBattleTimers(dt)
	elseif self.state == Battle.SOMEONE_ACTING then	
		self.currentMiniGame:update(dt)		
	end
end

return Battle