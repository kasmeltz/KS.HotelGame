local SimulationItem = require 'classes/simulation/SimulationItem'
local Objective = SimulationItem:extend('Objective')

Objective.NOT_STARTED = 1

-- title
-- description
-- rewards
-- quest

function Objective:init(gameWorld)
	Objective.super.init(self, gameWorld)
	self.status = Objective.NOT_STARTED
end

return Objective