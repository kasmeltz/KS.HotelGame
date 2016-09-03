local SimulationItem = require 'classes/simulation/SimulationItem'
local Quest = SimulationItem:extend('Quest')

Quest.NOT_STARTED = 1

-- locations
-- objectives
-- due date
-- status

function Quest:init(gameWorld)
	Quest.super.init(self, gameWorld)
	self.locations = {}
	self.objectives = {}
	self.status = Quest.NOT_STARTED
end

function Quest:addLocation(location)
	table.insert(self.locations, location)
end

function Quest:addObjective(objective)
	table.insert(self.objectives, objective)
end

return Quest