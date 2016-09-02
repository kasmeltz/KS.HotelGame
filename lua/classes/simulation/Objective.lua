local SimulationItem = require 'classes/simulation/SimulationItem'
local Objective = SimulationItem:extend('Objective')

-- name
-- object
-- reward

function Objective:init(gameWorld)
	Objective.super.init(self, gameWorld)
end

return WorldMap