local SimulationItem = require 'classes/simulation/SimulationItem'
local Objective = SimulationItem:extend('Objective')

-- title
-- description
-- rewards
-- quest

function Objective:init(gameWorld)
	Objective.super.init(self, gameWorld)
end

return Objective