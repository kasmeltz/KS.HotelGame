local SimulationItem = require 'classes/simulation/SimulationItem'
local Objective = SimulationItem:extend('Objective')

-- title
-- tasks
-- rewards
-- quest

function Objective:init(gameWorld)
	Objective.super.init(self, gameWorld)
end

return WorldMap