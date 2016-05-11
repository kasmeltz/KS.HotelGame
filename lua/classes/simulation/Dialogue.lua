local SimulationItem = require 'classes/simulation/SimulationItem'
local Dialogue = SimulationItem:extend('Dialogue')

local DialogueBranchFactory = require 'classes/factories/DialogueBranchFactory'
DialogueBranchFactory = DialogueBranchFactory:getInstance()

function Dialogue:init(dialogueName, startBranch, gameWorld, hero, other)
	Dialogue.super:init(gameWorld)
	
	local startBranch = startBranch or 'start'
	local branches = DialogueBranchFactory:createBranches(dialogueName, gameWorld, hero, other)
	self.branches = branches
	self.other = other
	self.hero = hero
	
	self:setBranch(startBranch)	
end

function Dialogue:setBranch(name)
	self.currentBranch = self.branches[name]
	if self.currentBranch == null then
		error('Dialogue can not set branch "' .. name .. '" because it doesn\'t exist')
	end	
end

function Dialogue:advance(option) 
	if option.next then	
		self:setBranch(option.next)
	else
		if (self.currentBranch.next) then
			self:setBranch(self.currentBranch.next)
		else	
			return true
		end
	end
end

function Dialogue:getSelectedOption()
	return self.currentBranch.options[1], 1
end

return Dialogue