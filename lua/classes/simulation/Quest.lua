local SimulationItem = require 'classes/simulation/SimulationItem'
local Quest = SimulationItem:extend('Quest')

-- locations
-- objectives
-- due dates
-- status

function Quest:init(gameWorld)
	Quest.super.init(self, gameWorld)
end

return Quest