local SimulationItem = require 'classes/simulation/SimulationItem'
local BattleMiniGame = SimulationItem:extend('BattleMiniGame')

BattleMiniGame.COUNTDOWN = 1
BattleMiniGame.DOING_KEYPRESSES = 2

function BattleMiniGame:init(gameWorld, actor)
	BattleMiniGame.super.init(self, gameWorld)
	
	self.actor = actor
	
	self.name = 'Press Da Keys'
	self.countdown = 1
	self.score = 0
	self.state = BattleMiniGame.COUNTDOWN
end

function BattleMiniGame:startKeyPresses(dt)
	self.countdown = 0
	self.state = BattleMiniGame.DOING_KEYPRESSES
	
	self.keysToPress = 	{}
	
	for i = 1, 4 do
		local keyPressInfo = {}
		keyPressInfo.timeBefore = math.random() * 1 + 0.5
		keyPressInfo.timeToPress = math.random() * 1 + 0.5
		keyPressInfo.key = string.char(math.random(97, 122))
		keyPressInfo.isShown = false
		table.insert(self.keysToPress, keyPressInfo)
	end
	
	self.keyToPressIndex = 1
	self.currentKeyToPress = self.keysToPress[1]
end

function BattleMiniGame:advanceKeyPress()
	local currentKeyToPress = self.currentKeyToPress
	currentKeyToPress.timeToPress = 0
	currentKeyToPress.isShown = false	
	
	self.keyToPressIndex = self.keyToPressIndex + 1	
	currentKeyToPress = self.keysToPress[self.keyToPressIndex]
	if not currentKeyToPress then
		self.state = BattleMiniGame.FINISHED
		
		if self.onFinish then self:onFinish() end
	end
	self.currentKeyToPress = currentKeyToPress
end

function BattleMiniGame:updateKeyPresses(dt)
	local currentKeyToPress = self.currentKeyToPress
	
	if not currentKeyToPress.isShown then
		currentKeyToPress.timeBefore = currentKeyToPress.timeBefore - dt
		if currentKeyToPress.timeBefore <= 0 then
			currentKeyToPress.timeBefore = 0
			currentKeyToPress.isShown = true
		end
	else
		currentKeyToPress.timeToPress = currentKeyToPress.timeToPress - dt
		if currentKeyToPress.timeToPress <= 0 then
			self:advanceKeyPress()
		end
	end			
end

function BattleMiniGame:updateCountdown(dt)
	self.countdown = self.countdown - dt
	
	if self.countdown <= 0 then
		self:startKeyPresses()		
	end
end

function BattleMiniGame:update(dt)
	if self.state == BattleMiniGame.COUNTDOWN then
		self:updateCountdown(dt)
	elseif self.state == BattleMiniGame.DOING_KEYPRESSES then
		self:updateKeyPresses(dt)
	end
end

return BattleMiniGame