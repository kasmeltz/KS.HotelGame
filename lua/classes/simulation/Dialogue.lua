local SimulationItem = require 'classes/simulation/SimulationItem'
local Dialogue = SimulationItem:extend('Dialogue')

local DialogueBranchFactory = require 'classes/factories/DialogueBranchFactory'
DialogueBranchFactory = DialogueBranchFactory:getInstance()

function Dialogue:init(dialogueName, startBranch, gameWorld, hero, other)
	Dialogue.super.init(self, gameWorld)
	
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
	
	if self.currentBranch.onStart then
		self.currentBranch.onStart()
	end
end

function Dialogue:advance(option) 
	local branch = self.currentBranch

	if option.next then	
		if option.onNext then
			option:onNext()
		end
		
		self:setBranch(option.next())
	else
		if branch.next then
			if branch.onNext then
				branch:onNext()
			end
			
			self:setBranch(branch.next())
		else	
			return true
		end
	end
end

function Dialogue:getSelectedOption()
	local branch = self.currentBranch
	
	local idx = 1
	local option = branch.options[idx]
	
	if branch.character == 'o' then
		for i = 1, #branch.options do
			local possibleOption = branch.options[i]			
			if not possibleOption.trySelect then
				option = possibleOption
				idx = i
				break
			end			
			if possibleOption:trySelect() then
				option = possibleOption
				idx = i
				break
			end
		end
			
		if option.onSelected then
			option:onSelected()
		end
	end
		
	return option, idx
end

return Dialogue