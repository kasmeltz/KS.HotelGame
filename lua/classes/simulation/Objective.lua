local SimulationItem = require 'classes/simulation/SimulationItem'
local Objective = SimulationItem:extend('Objective')

-- objective type
-- objects of interation
-- reward
-- quest

function Objective:init(gameWorld)
	Objective.super.init(self, gameWorld)
end

return WorldMap