local SimulationItem = require 'classes/simulation/SimulationItem'
local Guild = SimulationItem:extend('Guild')

-- heroes
-- hero costs

function Guild:init(gameWorld)
	Guild.super.init(self, gameWorld)
end

return Guild