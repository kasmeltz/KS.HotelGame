local SimulationItem = require 'classes/simulation/SimulationItem'
local Recipe = SimulationItem:extend('Recipe')

-- component ingredients
-- component / item results

function Recipe:init(gameWorld)
	Recipe.super.init(self, gameWorld)
end

return Recipe